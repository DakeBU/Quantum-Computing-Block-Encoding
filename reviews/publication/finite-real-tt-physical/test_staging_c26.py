"""Current-source checks for frozen c26 WIP; not source/publication acceptance."""
import hashlib
import importlib.util
import json
from pathlib import Path
import unittest
from unittest.mock import patch

PACKET = Path(__file__).resolve().parent
ROOT = PACKET.parents[2]


def read(path):
    return json.loads(path.read_text(encoding="utf-8"))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class C26Staging(unittest.TestCase):
    def test_actual_public_decoder_originals(self):
        freeze = PACKET / "decoder-c26/freeze.json"
        self.assertEqual(digest(freeze), "83b45975a001f11daef7f4cdfd1f1d316d5426de3b7a960181ff410579cd9f36")
        data = read(freeze)
        self.assertTrue(data["frozen"])
        self.assertEqual(len(data["public_artifacts"]), 15)
        for artifact in data["public_artifacts"]:
            with self.subTest(path=artifact["path"]):
                target = PACKET / "decoder-c26" / artifact["path"]
                self.assertTrue(target.is_file())
                self.assertEqual(digest(target), artifact["sha256"])
        self.assertIsNone(data["source_agreement_verdict"])
        self.assertIsNone(data["publication_verdict"])

    def test_same_source_and_honest_source_first_seal(self):
        lesson = ROOT / "docs/lessons/finite-real-tt-primitive-preparation-and-word-order.md"
        self.assertEqual(digest(lesson), "d71f16da026938debcd024d6f2fa9fa9268ade2096b5854a030d2065828b315d")
        seal = PACKET / "reviewer-c26/phase1-seal.json"
        self.assertEqual(digest(seal), "0e6c0bedcc98ae6ba2f8089bbd96e29e79b1da3b646458bc85bd093805304359")
        data = read(seal)
        self.assertEqual(digest(PACKET / "reviewer-c26/source-only-notes.md"), data["artifacts"]["notes"]["sha256"])
        self.assertTrue(data["exposure"]["prior_raw_byte_hash_IO"])
        self.assertFalse(data["exposure"]["prior_target_semantic_text_exposure"])
        self.assertFalse(data["exposure"]["absolute_file_unread_claim"])
        self.assertEqual(data["source_review"]["source_AND_edges"], 32)
        self.assertTrue(data["source_review"]["all_seven_semantic_slots_reviewed"])
        self.assertTrue(data["source_review"]["no_formal_target_matching_claim"])

    def test_actual_targets_and_all_37_real_probes(self):
        evidence = read(PACKET / "decoder-c26/evidence.json")
        signatures = read(PACKET / "decoder-c26/signatures.json")
        inventory = read(ROOT / "web/library/declarations.json")["declarations"]
        expected_counts = [10, 12, 15]
        observed = []
        for target, group, count, output in zip(evidence["modules"], signatures["modules"], expected_counts,
                                              ("probe-local-output.txt", "probe-word-output.txt", "probe-preparation-output.txt")):
            self.assertEqual(target["path"], group["path"])
            self.assertEqual(digest(ROOT / target["path"]), target["source_sha256"])
            self.assertEqual((target["compile_exit_code"], target["probe_exit_code"]), (0, 0))
            roots = group["roots"]
            self.assertEqual(len(roots), count)
            names = [x["fullName"] for x in inventory if x["source"] == target["path"]]
            self.assertEqual([x["name"] for x in roots], names)
            raw = (PACKET / "decoder-c26" / output).read_text(encoding="utf-8")
            for item in roots:
                self.assertIn(item["elaborated_type_display"], raw)
                self.assertIn(item["ordinary_axiom_output"], raw)
                self.assertNotIn("sorryAx", item["ordinary_axioms"])
                self.assertTrue(set(item["ordinary_axioms"]) <= {"propext", "Classical.choice", "Quot.sound"})
                observed.append(item["name"])
        self.assertEqual(len(set(observed)), 37)
        self.assertEqual(signatures["count"], 37)
        self.assertTrue(evidence["compiler"]["setup_overrides"]["source_Preparation_imports_fresh_LocalCompiler"])
        self.assertTrue(evidence["compiler"]["no_transitive_dependency_rebuild"])

    def test_failures_warnings_and_compiler_boundary_not_erased(self):
        evidence = read(PACKET / "decoder-c26/evidence.json")
        freeze = read(PACKET / "decoder-c26/freeze.json")
        self.assertEqual(freeze["checks"]["final_six_exit_codes"], [0] * 6)
        self.assertEqual(freeze["checks"]["preserved_failed_calls"], 3)
        self.assertEqual(freeze["checks"]["all_proof_process_calls_including_failures"], 9)
        calls = evidence["compiler"]["call_results"]
        self.assertEqual(sum(x["exit_code"] != 0 for x in calls), 3)
        self.assertEqual(sum(x["successful_intended_run"] for x in calls), 6)
        warnings = evidence["compiler"]["source_compile_warnings"]
        self.assertEqual([warnings[x]["count"] for x in ("TensorTrainLocalCompiler", "TensorTrainWord", "TensorTrainPrimitivePreparation")], [2, 1, 0])
        for item in freeze["private_artifact_hashes"]:
            self.assertFalse((PACKET / "decoder-c26" / item["path"]).exists())

    def test_current_previous_canonical_records_still_validate(self):
        spec = importlib.util.spec_from_file_location("c26_current_publication", ROOT / "website/scripts/check_research_publications.py")
        checker = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(checker)
        inventory = {x["fullName"]: x for x in read(ROOT / "web/library/declarations.json")["declarations"]}
        records = read(ROOT / "website/research/publications.json")["records"]
        for record in records:
            checker.validate_record(ROOT, record, inventory)

    def test_missing_actual_artifact_is_not_green(self):
        original = Path.is_file
        absent = PACKET / "decoder-c26/probe-word-output.txt"
        with patch.object(Path, "is_file", lambda p: False if p == absent else original(p)):
            result = unittest.TestResult()
            C26Staging("test_actual_public_decoder_originals").run(result)
        self.assertEqual(len(result.failures), 1)
        self.assertEqual(result.errors, [])


if __name__ == "__main__":
    unittest.main()
