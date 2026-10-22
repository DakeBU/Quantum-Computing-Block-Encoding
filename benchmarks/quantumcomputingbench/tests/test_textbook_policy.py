"""Historical preview is reproducible audit data, not repaired current gold."""
from contextlib import redirect_stderr
import io
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

B = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(B / "scripts"))
import release
from qcb_core import digest
from qcb_core import read_json
import qcb_textbook_policy as policy
from qcb_nl_release_policy import check_current_gold
from qcb_textbook_policy import apply_current_reader_policy, frozen_native_is_current, CONTRACT_FIELDS, public_reader_item


class TextbookPolicyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        _, _, cls.historical, _ = release.checked()

    def test_rejected_predecessor_is_not_current_gold(self):
        original = next(i for i in self.historical if i["core_id"] == "qcb-core-sp-002")
        with self.assertRaisesRegex(ValueError, "withdrawn"):
            check_current_gold([original])
        self.assertFalse(frozen_native_is_current(self.historical))

    def test_successor_cannot_increase_core_count_or_change_contract(self):
        current, decisions = apply_current_reader_policy(self.historical)
        self.assertEqual(len(current), len({i["core_id"] for i in current}))
        self.assertLessEqual(len(current), len(self.historical))
        old = {i["core_id"]: i for i in self.historical}
        for item in current:
            self.assertEqual({k: item[k] for k in CONTRACT_FIELDS}, {k: old[item["core_id"]][k] for k in CONTRACT_FIELDS})
            if item.get("textbook_successor"):
                self.assertEqual(item["textbook_successor"]["predecessor_item_digest"], digest(old[item["core_id"]]))
                self.assertNotIn(old[item["core_id"]]["reviews"][0], item["reviews"])

    def test_frozen_tag_cannot_be_repackaged_as_current(self):
        errors = io.StringIO()
        with patch.object(sys, "argv", ["release.py", "build"]), redirect_stderr(errors):
            self.assertEqual(release.main(), 1)
        self.assertIn("historical preview contains a withdrawn predecessor", errors.getvalue())

    def test_public_reader_download_is_not_a_raw_review_or_control_log(self):
        current, _ = apply_current_reader_policy(self.historical)
        for item in current:
            view = public_reader_item(item)
            self.assertEqual(view["reference_answer"], item["reference_answer"])
            self.assertEqual(view["source_item_digest"], digest(item))
            self.assertNotIn("reviews", view)
            self.assertNotIn("inherited_predecessor_reviews", view)
            self.assertNotIn("lineage", view)

    def test_exposition_repairs_cannot_change_contract_or_graph_scope(self):
        repair_path = B / "shared/repairs/sp-006-normalization-boundary-repair.json"
        for exposition in ({"question": "a different problem"},
                           {"semantic_steps": []},
                           {"semantic_steps": [{"claim": "bad scope", "supporting_nodes": ["unbound:node"]}] * 3}):
            bad = read_json(repair_path)
            bad["exposition"] = exposition
            with patch.object(policy, "read_json", side_effect=lambda p: bad if Path(p) == repair_path else read_json(p)):
                with self.assertRaisesRegex(ValueError, "contract|graph scope"):
                    apply_current_reader_policy(self.historical)

    def test_all_repaired_predecessors_are_withdrawn_from_current_gold(self):
        repaired = {r["core_id"] for r in read_json(B / "shared/current-policy.json")["answer_successors"]}
        for item in self.historical:
            if item["core_id"] in repaired:
                with self.assertRaisesRegex(ValueError, "withdrawn"):
                    check_current_gold([item])

    def test_quarantine_requires_exact_content_and_a_rejection_not_self_approval(self):
        p = B / "shared/current-policy.json"
        original_policy = read_json(p)
        self.assertTrue(original_policy["withdrawals"])
        for mutate in (lambda row: row.update(predecessor_item_digest="stale"),
                       lambda row: row.update(review_digest="unreviewed file"),
                       lambda row: row.update(finding_digest="different verdict")):
            from copy import deepcopy
            changed = deepcopy(original_policy)
            mutate(changed["withdrawals"][0])
            with patch.object(policy, "read_json", side_effect=lambda path: changed if Path(path) == p else read_json(path)):
                with self.assertRaisesRegex(ValueError, "quarantine"):
                    apply_current_reader_policy(self.historical)

    def test_quarantine_is_not_a_current_gold_key_and_never_discards_the_original(self):
        current, decisions = apply_current_reader_policy(self.historical)
        by_id = {i["core_id"]: i for i in self.historical}
        active = {i["core_id"] for i in current}
        withheld = [d for d in decisions if d["status"].startswith("withheld_")]
        self.assertTrue(withheld)
        for row in withheld:
            old = by_id[row["core_id"]]
            self.assertEqual(digest(old), row["predecessor_item_digest"])
            self.assertNotIn(row["core_id"], active)
            with self.assertRaisesRegex(ValueError, "withdrawn"):
                check_current_gold([old])
        check_current_gold(current)

    def test_quarantine_rejects_self_review_or_positive_verdict_even_with_updated_hashes(self):
        from copy import deepcopy
        p = B / "shared/current-policy.json"
        initial = read_json(p)
        old = {i["core_id"]: i for i in self.historical}
        for change in ("self_review", "positive_verdict", "stale_source"):
            changed = deepcopy(initial)
            row = changed["withdrawals"][0]
            review_path = B / row["review"]
            review = deepcopy(read_json(review_path))
            finding = next(f for f in review["items"] if f["core_id"] == row["core_id"])
            if change == "self_review":
                review["reviewer"] = old[row["core_id"]]["author"]["identity"]
            elif change == "positive_verdict":
                finding["verdict"] = "accept"
            else:
                finding["source_checks"][0]["sha256_lf"] = "different source"
            row["review_digest"], row["finding_digest"] = digest(review), digest(finding)
            def mocked(path):
                return changed if Path(path) == p else review if Path(path) == review_path else read_json(path)
            with patch.object(policy, "read_json", side_effect=mocked), self.assertRaises(ValueError):
                apply_current_reader_policy(self.historical)

    def test_duplicate_policy_cannot_hide_a_quarantine_behind_an_answer_successor(self):
        from copy import deepcopy
        p = B / "shared/current-policy.json"
        changed = deepcopy(read_json(p))
        changed["withdrawals"].append(changed["answer_successors"][0])
        with patch.object(policy, "read_json", side_effect=lambda path: changed if Path(path) == p else read_json(path)):
            with self.assertRaisesRegex(ValueError, "conflicting"):
                apply_current_reader_policy(self.historical)
