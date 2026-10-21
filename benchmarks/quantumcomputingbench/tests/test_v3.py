"""Regression tests for actual review failures; fixtures are not model results."""
from copy import deepcopy
import hashlib
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(B / "scripts"))
from qcb_core import assign_splits, digest, prepare, read_json, score, validate
from qcb_integrity import WITHDRAWN, check_not_withdrawn, matches, snapshot_input_matches, text_sha
from qcb_lean import _run_bounded, container_command, LIMITS, validate_proof_grammar
from qcb import checked_provisional, checked_release
from check_references import PREFIX, ROOTS, parse_reference_output
from authoring_packets import select_nodes, packet
from test_core import RAW, SNAP


class RepairContractTests(unittest.TestCase):
    def test_source_packets_are_bounded_diverse_and_not_coverage(self):
        snap = {"snapshot_id": "fixture", "edges": [], "hyperedges": [], "nodes": [
            {"id": name, "kind": "declaration", "topic": "shared", "source": source}
            for name,source in [("a", "module-a"), ("b", "module-a"), ("c", "module-c")]]}
        chosen = select_nodes(snap, [], set(), 2)
        self.assertEqual({n["id"] for n in chosen}, {"a", "c"})
        self.assertEqual([n["id"] for n in select_nodes(snap, [], {"a", "c"}, 2)], ["b"])
        record = packet(snap, chosen[0])
        self.assertEqual(record["released_coverage_added"], 0)
        self.assertEqual(record["questions_authored"], 0)

    def test_lf_hash_is_cross_platform_and_not_whitespace_normalization(self):
        with tempfile.TemporaryDirectory() as directory:
            p = Path(directory) / "source.lean"
            p.write_bytes(b"theorem a\r\n")
            self.assertTrue(matches(p, hashlib.sha256(b"theorem a\n").hexdigest()))
            p.write_bytes(b"theorem  a\n")
            self.assertFalse(matches(p, hashlib.sha256(b"theorem a\n").hexdigest()))

    def test_snapshot_escape_denied(self):
        self.assertFalse(snapshot_input_matches(R, "../outside", "a" * 64))

    def test_withdrawn_gold_cannot_be_scored(self):
        for key in WITHDRAWN:
            with self.assertRaisesRegex(ValueError, "withdrawn gold"):
                score([{"key": key}], [])

    def test_corrected_successors_not_withdrawn(self):
        check_not_withdrawn([{"key": k + "-corrected-v3"} for k in WITHDRAWN])

    def test_explicit_family_holdout_propagates_through_target_union(self):
        a, b = deepcopy(RAW), deepcopy(RAW)
        a.update(key="a", family="held")
        b.update(key="b", family="other", question="A different question with the same target.")
        rows = assign_splits(prepare([a,b], SNAP), {"held"})
        self.assertEqual({i["split"] for i in rows}, {"test_public"})

    def formal(self):
        raw = deepcopy(RAW)
        raw.update(answer_format="lean", formal={"imports": ["Foo"], "target": "True", "reference_proof": "True.intro"})
        return prepare([raw], SNAP)[0]

    def test_local_reference_receipt_does_not_award_formal_credit(self):
        item = self.formal()
        item["verification_receipts"] = [{"status": "certified", "isolated": False}]
        result = score([item], [{"id": item["id"], "answer": "True.intro"}])
        self.assertIsNone(result["results"][0]["correctness"])

    def test_live_formal_score_needs_full_binding_and_isolation(self):
        item = self.formal()
        pred = [{"id": item["id"], "answer": "True.intro"}]
        with self.assertRaisesRegex(ValueError, "unbound/nonisolated"):
            score([item], pred, formal_verifier=lambda i,p: {"status": "certified", "isolated": False})
        receipt = {"status": "certified", "isolated": True, "item_id": item["id"], "task_hash": item["task_hash"],
                   "context_hash": item["context_hash"], "graph_version": item["graph_version"],
                   "proof_sha256": hashlib.sha256(b"True.intro").hexdigest()}
        result = score([item], pred, formal_verifier=lambda i,p: receipt)
        self.assertEqual(result["results"][0]["correctness"], 1)
        self.assertIsNone(result["results"][0]["semantic_fidelity"])

    def test_environment_failure_not_failed_mathematics(self):
        item = self.formal()
        result = score([item], [{"id": item["id"], "answer": "True.intro"}],
                       formal_verifier=lambda i,p: {"status": "blocked", "reason": "no_runtime"})
        self.assertIsNone(result["results"][0]["correctness"])

    def test_container_user_can_access_work_and_public_file_mount(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "lean-toolchain").write_text("fixture")
            command = container_command("docker", "a@sha256:" + "a"*64, root, root/"private-temp", "test")
            self.assertIn("mode=1777", " ".join(command))
            self.assertIn("source=" + str(root/"private-temp"/"Harness.lean"), " ".join(command))

    def test_output_is_bounded_before_allocation_not_after_capture(self):
        with patch.dict(LIMITS, {"stdout_cap": 64, "stderr_cap": 64}):
            code, stdout, stderr, failure = _run_bounded([sys.executable, "-c", "print('x'*10000)"])
        self.assertEqual(failure, "output_cap")
        self.assertLessEqual(len(stdout), 64)

    def test_reference_audit_requires_all_roots_and_clean_axioms(self):
        text = "\n".join("QCB_REFERENCE_AXIOMS|" + PREFIX + name + "|propext" for name in ROOTS)
        self.assertEqual(len(parse_reference_output(text)), len(ROOTS))
        for bad in [text.replace("|propext", "|sorryAx", 1), text + "\n" + text.splitlines()[0], ""]:
            with self.assertRaises(ValueError):
                parse_reference_output(bad)


class ActualV3Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (B / "data/public/release-v3/release.json").exists():
            raise unittest.SkipTest("run build_v3.py after actual local reference replay")
        cls.release = checked_release("release-v3")
        cls.provisional = checked_provisional("release-v3")
        cls.reference = read_json(B / "reports/release-v3/lean-reference-checks.json")

    def test_four_bad_originals_absent_and_successors_pending(self):
        keys = {i["key"] for i in self.release + self.provisional}
        self.assertFalse(keys & WITHDRAWN.keys())
        for key in WITHDRAWN:
            item = next(i for i in self.provisional if i["supersedes"] == key)
            self.assertEqual(item["lifecycle"], "candidate")
            self.assertEqual(item["reviews"], [])

    def test_corrected_answers_do_not_inherit_false_context(self):
        resource = next(i for i in self.provisional if i.get("supersedes") == "qs-resource-depth-parallel-vs-serial")
        self.assertNotIn("peak ancilla demand", " ".join(resource["conventions"]))
        ry = next(i for i in self.provisional if i.get("supersedes") == "neg-ry-not-half-only-at-pi")
        self.assertNotIn("physical polar angle", " ".join(ry["assumptions"]))

    def test_all_three_actual_lean_references_fit_verifier_grammar(self):
        formal = [i for i in self.provisional if i.get("formal")]
        self.assertEqual(len(formal), 3)
        for item in formal:
            validate_proof_grammar(item["formal"]["reference_proof"])
            self.assertIn("QuantumBlockEncoding.", item["formal_context"]["target"])
        self.assertEqual(len(self.reference["generated_harnesses"]), 3)
        by_key = {h["key"]: h for h in self.reference["generated_harnesses"]}
        for item in formal:
            self.assertEqual(by_key[item["key"]]["formal_context"], item["formal_context"])
            self.assertEqual(by_key[item["key"]]["proof_sha256"],
                             hashlib.sha256(item["formal"]["reference_proof"].encode()).hexdigest())
        for item in self.provisional:
            roots = {PREFIX + r for r in item["reference_checks"]}
            self.assertLessEqual(roots, self.reference["checked_roots"].keys())
        self.assertTrue(matches(B / "lean/ReferenceChecks.lean", self.reference["reference_pack_sha256"]))

    def test_test_set_contains_core_mathematics_not_only_plans(self):
        tests = [i for i in self.release if i["split"] == "test_public"]
        self.assertTrue(any(i["track"] != "planned" for i in tests))
        self.assertTrue(any(i["family"] == "real-amplitude-preparation" for i in tests))
        self.assertTrue(any(i["track"] == "planned" for i in tests))

    def test_provisional_exact_grader_positive_negative_controls(self):
        exact = [i for i in self.provisional if i["answer_format"] == "exact"]
        self.assertEqual(len(exact), 5)
        for answer, value in [(lambda i: i["reference_answer"], 1), (lambda i: "incorrect", 0)]:
            result = score(exact, [{"id": i["id"], "answer": answer(i)} for i in exact])
            self.assertTrue(all(r["correctness"] == value for r in result["results"]))

    def test_local_references_and_negative_controls_are_honestly_classified(self):
        self.assertFalse(self.reference["isolated"])
        self.assertFalse(self.reference["independent_nl_review"])
        self.assertEqual(self.reference["negative_control"]["reason"], "sorry_axiom")
        self.assertEqual(self.reference["wrong_type_control"]["reason"], "unproven")
        self.assertEqual(len(self.reference["checked_roots"]), len(ROOTS))


if __name__ == "__main__":
    unittest.main()
