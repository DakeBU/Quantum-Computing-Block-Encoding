"""Full universe accounting tests, distinct from mathematical answer review."""
from collections import Counter
from pathlib import Path
import sys
import unittest
BASE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BASE / "src"))
from qcb_snapshot import snapshot, coverage
from qcb_core import prepare

class SnapshotTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = BASE.parents[1]
        cls.snap = snapshot(cls.root)

    def test_deterministic_input_identity(self):
        other = snapshot(self.root)
        self.assertEqual(other["snapshot_id"], self.snap["snapshot_id"])
        self.assertEqual(other["input_hashes"], self.snap["input_hashes"])
        self.assertEqual(other["nodes"], self.snap["nodes"])

    def test_public_declarations_and_private_helpers_accounted(self):
        import json
        inventory = json.loads((self.root / "web/library/declarations.json").read_text())
        nodes = self.snap["nodes"]
        actual = {n["id"] for n in nodes if n["kind"] == "declaration"}
        self.assertEqual(actual, {"declaration:"+d["fullName"] for d in inventory["declarations"]})
        self.assertEqual(len(actual), len(inventory["declarations"]))
        self.assertTrue(any(n["kind"] == "private_helper" for n in nodes))

    def test_all_curriculum_parts_preserved(self):
        import json
        parts = json.loads((self.root / "website/curriculum-parts.json").read_text())["parts"]
        ids = {n["id"] for n in self.snap["nodes"]}
        for p in parts:
            self.assertIn(p["id"], ids)
            for c in p["chapters"]:
                self.assertIn(c["id"], ids)

    def test_hyperedges_keep_and_premises_and_failure_maps(self):
        import json
        expected = json.loads((self.root / "website/research/atlas.json").read_text())["hyperedges"]
        self.assertEqual(sorted(expected,key=lambda h:h["id"]), self.snap["hyperedges"])
        for h in self.snap["hyperedges"]:
            self.assertIn("tails", h)
            self.assertIn("failure_boundary", h)

    def test_imports_are_structural_only(self):
        edges = self.snap["edges"]
        ids = {n["id"] for n in self.snap["nodes"]}
        for e in edges:
            self.assertIn(e["source"], ids)
            self.assertIn(e["target"], ids)
            if e["type"] == "module-supports-importer":
                self.assertTrue(e["source"].startswith("module:"))
                self.assertTrue(e["target"].startswith("module:"))
        self.assertFalse(self.snap["compiled_this_run"])

    def test_unreviewed_candidates_do_not_count_as_coverage(self):
        node = next(n for n in self.snap["nodes"] if n["kind"] == "declaration")
        item = {"id":"draft", "lifecycle":"candidate", "target_nodes":[node["id"]], "supporting_nodes":[]}
        report = coverage(self.snap,[item])
        row = next(r for r in report["ledger"] if r["id"]==node["id"])
        self.assertEqual(row["disposition"],"candidate_pending_review")
        self.assertEqual(report["released_items"],0)
        self.assertEqual(len(report["ledger"]), len(self.snap["nodes"]))
        self.assertEqual(sum(report["dispositions"].values()),len(self.snap["nodes"]))
        self.assertFalse(report["benchmark_complete"])

if __name__ == "__main__":
    unittest.main()
