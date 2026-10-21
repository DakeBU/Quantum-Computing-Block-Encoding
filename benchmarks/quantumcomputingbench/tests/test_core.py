"""Adversarial offline tests; never substitute these for Lean or model runs."""
import copy
import json
from pathlib import Path
import sys
import unittest

BASE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BASE / "src"))
from qcb_core import (assign_splits, content_hash, digest, model_input, prepare,
                      score, validate, write_json)

SNAP = {"snapshot_id": "fixture", "nodes": [{"id": "declaration:a"}, {"id": "declaration:b"}]}
RAW = {"key": "addition", "topic": "shared_foundations", "track": "reasoning",
       "question": "Given the stated normalization, explain why composition is valid.",
       "reference_answer": "Use both hypotheses, then substitute the equality.",
       "rubric": [{"id": "hyp", "criterion": "Preserve both hypotheses", "weight": 1},
                  {"id": "step", "criterion": "Perform the justified substitution", "weight": 1}],
       "target_nodes": ["declaration:a"], "supporting_nodes": ["declaration:b"],
       "assumptions": ["Both input hypotheses hold"], "conventions": ["exact"],
       "semantic_steps": [{"claim": "Substitute using both premises", "supporting_nodes": ["declaration:a", "declaration:b"]}],
       "difficulty": {"level": "intermediate", "rationale": "one reviewed substitution"},
       "source_refs": [{"path": "fixture.lean", "sha256": "0"*64, "anchor": "theorem a", "license": "MIT"}],
       "family": "substitution", "answer_format": "rubric", "evidence_status": "source_inspected",
       "formal": None, "unresolved_issues": []}


class CoreTests(unittest.TestCase):
    def setUp(self):
        self.items = assign_splits(prepare([RAW], SNAP))

    def test_valid_draft_not_released(self):
        self.assertEqual(validate(self.items, SNAP), [])
        self.assertEqual(self.items[0]["lifecycle"], "candidate")

    def test_deterministic(self):
        self.assertEqual(self.items, assign_splits(prepare([RAW], SNAP)))

    def test_no_unreviewed_promotion(self):
        self.items[0]["lifecycle"] = "released"
        self.assertTrue(validate(self.items, SNAP))

    def test_review_binding(self):
        item = self.items[0]
        item["reviews"] = [{"reviewer": "other", "verdict": "accept", "method": "distinct-context-source-review",
                             "artifact": "review.json", "content_hash": content_hash(item)}]
        item["validation"].update(nl_alignment="reviewed", answer_quality="reviewed")
        item["lifecycle"] = "released"
        self.assertEqual(validate(self.items, SNAP), [])
        item["reference_answer"] = "Wrong replacement."
        self.assertTrue(validate(self.items, SNAP))

    def test_target_or_context_tamper(self):
        self.items[0]["formal_context"] = {"target": "False"}
        self.assertTrue(validate(self.items, SNAP))

    def test_unknown_nodes(self):
        self.items[0]["target_nodes"].append("declaration:invented")
        self.assertTrue(validate(self.items, SNAP))

    def test_inflated_depth_and_support(self):
        self.items[0]["support_count"] = 9
        self.items[0]["semantic_step_count"] = 99
        self.assertGreaterEqual(len(validate(self.items, SNAP)), 2)

    def test_inference_requires_actual_mapping(self):
        self.items[0]["semantic_steps"][0]["supporting_nodes"] = ["imports:foo"]
        self.assertTrue(validate(self.items, SNAP))

    def test_same_target_solution_group(self):
        other = copy.deepcopy(RAW)
        other.update(key="reverse", family="other", question="Diagnose a missing hypothesis.")
        items = assign_splits(prepare([RAW, other], SNAP))
        self.assertEqual(items[0]["split_group"], items[1]["split_group"])
        items[1]["split"] = "dev" if items[0]["split"] != "dev" else "train"
        self.assertTrue(validate(items, SNAP))

    def test_transitive_leakage_union(self):
        a, b, c = [copy.deepcopy(RAW) for _ in range(3)]
        a.update(key="a", family="A", target_nodes=["declaration:a"])
        b.update(key="b", family="B", target_nodes=["declaration:a", "declaration:b"])
        c.update(key="c", family="C", target_nodes=["declaration:b"])
        items = assign_splits(prepare([a, b, c], SNAP))
        self.assertEqual(len({i["split_group"] for i in items}), 1)

    def test_planned_topic_holdout(self):
        raw = copy.deepcopy(RAW)
        raw["topic"] = "quantum_information"
        self.assertEqual(assign_splits(prepare([raw], SNAP))[0]["split"], "test_public")

    def test_prompt_never_contains_answers_or_metadata(self):
        item = self.items[0]
        item.update(private_gold="PRIVATE_CANARY", arbitrary={"answer": "SECRET"})
        item["reviews"] = [{"notes": "ANSWER_CANARY"}]
        for setting in ["closed_book", "open_library"]:
            prompt = model_input(item, setting)
            text = json.dumps(prompt)
            for forbidden in ["PRIVATE_CANARY", "SECRET", "ANSWER_CANARY", "reference_answer", "reference_proof"]:
                self.assertNotIn(forbidden, text)
            self.assertNotIn("rubric", prompt)

    def test_approved_interface_rejects_proofs(self):
        statements = [{"name": "a", "type": "P", "proof": "by trivial"}]
        with self.assertRaises(ValueError):
            model_input(self.items[0], "approved_interface", {"statements": statements, "policy_hash": digest(statements)})

    def test_approved_interface_bound(self):
        statements = [{"name": "a", "type": "P"}]
        good = {"statements": statements, "policy_hash": digest(statements)}
        self.assertEqual(model_input(self.items[0], "approved_interface", good)["interface"], statements)
        good["policy_hash"] = "bad"
        with self.assertRaises(ValueError):
            model_input(self.items[0], "approved_interface", good)

    def test_missing_predictions_are_zero(self):
        result = score(self.items, [])
        self.assertEqual(result["results"][0]["correctness"], 0)

    def test_no_word_count_or_keyword_grading(self):
        item = self.items[0]
        result = score(self.items, [{"id": item["id"], "answer": item["reference_answer"]}])
        self.assertIsNone(result["results"][0]["correctness"])

    def test_rubric_rating_binds_prediction_and_item(self):
        item = self.items[0]
        prediction = {"id": item["id"], "answer": "Independent answer."}
        rating = {"id": item["id"], "kind": "human_rubric", "reviewer": "human-evaluator",
                  "item_hash": content_hash(item), "prediction_hash": digest(prediction["answer"]),
                  "criteria": {"hyp": 1, "step": 0}, "semantic_fidelity": "unfaithful"}
        result = score(self.items, [prediction], [rating])
        self.assertEqual(result["results"][0]["correctness"], 0.5)
        self.assertEqual(result["results"][0]["semantic_fidelity"], "unfaithful")
        rating["criteria"]["step"] = float("nan")
        with self.assertRaises(ValueError):
            score(self.items, [prediction], [rating])

    def test_duplicate_and_unknown_predictions(self):
        p = {"id": self.items[0]["id"], "answer": "x"}
        with self.assertRaises(ValueError):
            score(self.items, [p, p])
        with self.assertRaises(ValueError):
            score(self.items, [{"id": "unknown", "answer": "x"}])

    def test_formal_never_scores_on_exit_or_text(self):
        item = self.items[0]
        item["answer_format"] = "lean"
        result = score(self.items, [{"id": item["id"], "answer": "by sorry"}])
        self.assertIsNone(result["results"][0]["correctness"])
        self.assertEqual(result["results"][0]["reason"], "isolated_verifier_required")

    def test_frozen_artifact_refuses_overwrite(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "release.json"
            write_json(p, [1], immutable=True)
            write_json(p, [1], immutable=True)
            with self.assertRaises(ValueError):
                write_json(p, [2], immutable=True)

    def test_malformed_required_fields_return_errors(self):
        for field in ["graph_version", "formal_context", "lifecycle", "author"]:
            item = copy.deepcopy(self.items[0])
            del item[field]
            self.assertTrue(validate([item], SNAP))

    def test_nonstring_prediction_rejected(self):
        with self.assertRaises(ValueError):
            score(self.items, [{"id": self.items[0]["id"], "answer": 42}])

    def test_unknown_evidence_is_not_lean_certificate(self):
        self.items[0]["evidence_status"] = "lean_certified"
        self.assertTrue(validate(self.items, SNAP))

    def test_uncertain_rubric_stays_ungraded(self):
        item = self.items[0]
        answer = "Unsure."
        rating = {"id": item["id"], "kind": "human_rubric", "reviewer": "human",
                  "item_hash": content_hash(item), "prediction_hash": digest(answer),
                  "criteria": {"hyp": 1, "step": 1}, "semantic_fidelity": "uncertain"}
        self.assertIsNone(score(self.items, [{"id": item["id"], "answer": answer}], [rating])["results"][0]["correctness"])

    def test_private_release_rejected(self):
        self.items[0]["release_policy"] = "evaluator_only"
        self.assertTrue(validate(self.items, SNAP))


if __name__ == "__main__":
    unittest.main()
