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
            unchanged = [k for k in CONTRACT_FIELDS if not (k == "question" and item.get("question_successor"))]
            self.assertEqual({k: item[k] for k in unchanged}, {k: old[item["core_id"]][k] for k in unchanged})
            if item.get("textbook_successor"):
                self.assertEqual(item["textbook_successor"]["predecessor_item_digest"], digest(old[item["core_id"]]))
                self.assertNotIn(old[item["core_id"]]["reviews"][0], item["reviews"])

    def test_frozen_tag_cannot_be_repackaged_as_current(self):
        errors = io.StringIO()
        with patch.object(sys, "argv", ["release.py", "build"]), redirect_stderr(errors):
            self.assertEqual(release.main(), 1)
        self.assertIn("historical preview contains a withdrawn predecessor", errors.getvalue())

    def test_explicitly_withdrawn_answer_repairs_keep_questions_and_predecessors_separate(self):
        originals = {i['core_id']: i for i in self.historical}
        current, decisions = apply_current_reader_policy(self.historical)
        by_id = {i['core_id']: i for i in current}
        for core in ('qcb-core-be-102', 'qcb-core-plan-107', 'qcb-core-plan-204',
                     'qcb-core-plan-004', 'qcb-core-plan-007', 'qcb-core-plan-307'):
            old, new = originals[core], by_id[core]
            self.assertNotEqual(old['reference_answer'], new['reference_answer'])
            self.assertEqual({k: old[k] for k in CONTRACT_FIELDS}, {k: new[k] for k in CONTRACT_FIELDS})
            self.assertEqual(new['reviews'][0]['method'], 'independent-answer-successor-review')
            row = next(r for r in decisions if r['core_id'] == core)
            self.assertEqual(row['status'], 'reviewed_answer_successor_admitted_to_reader')
            self.assertEqual(row['prior_withdrawal']['predecessor_item_digest'], digest(old))
            with self.assertRaisesRegex(ValueError, 'withdrawn'):
                check_current_gold([old])

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
        current_policy = read_json(B / "shared/current-policy.json")
        repaired = {r["core_id"] for r in current_policy["answer_successors"] + current_policy["question_successors"]}
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

    def test_question_successor_versions_contract_without_adding_a_core_or_inheriting_approval(self):
        old = next(i for i in self.historical if i["core_id"] == "qcb-core-la-206")
        current, decisions = apply_current_reader_policy(self.historical)
        new = next(i for i in current if i["core_id"] == old["core_id"])
        lineage = new["question_successor"]
        self.assertNotEqual(old["question"], new["question"])
        self.assertNotEqual(lineage["predecessor_contract_hash"], lineage["current_contract_hash"])
        self.assertEqual(lineage["predecessor_contract_hash"], digest({k: old[k] for k in CONTRACT_FIELDS}))
        self.assertEqual(lineage["current_contract_hash"], digest({k: new[k] for k in CONTRACT_FIELDS}))
        self.assertEqual(new["question_version"], 2)
        self.assertFalse(lineage["equivalence_to_predecessor_claimed"])
        self.assertEqual(lineage["additional_core_count"], 0)
        self.assertNotIn("textbook_successor", new)
        self.assertEqual(new["reviews"][0]["method"], "independent-question-successor-review")
        self.assertNotIn(old["reviews"][0], new["reviews"])
        self.assertNotIn("task_hash", new)
        self.assertIn("task_hash", new["inherited_predecessor_hashes"])
        self.assertEqual(sum(i["core_id"] == old["core_id"] for i in current), 1)
        self.assertIn("reviewed_question_successor_admitted_to_reader",
                      [r["status"] for r in decisions if r["core_id"] == old["core_id"]])
        self.assertEqual(public_reader_item(new)["question_successor"], lineage)
        with self.assertRaisesRegex(ValueError, "withdrawn"):
            check_current_gold([old])

    def test_question_successor_rejects_unreviewed_contract_source_or_scope_changes(self):
        from copy import deepcopy
        row = read_json(B / "shared/current-policy.json")["question_successors"][0]
        rp, vp = B / row["repair"], B / row["review"]
        for field, value in (("question", "silently changed question"), ("assumptions", ["full rank"]),
                             ("split", "test_public"), ("question_version", 3),
                             ("supersedes_contract_hash", "same hash"), ("author", "")):
            bad = deepcopy(read_json(rp))
            bad[field] = value
            with patch.object(policy, "read_json", side_effect=lambda path: bad if Path(path) == rp else read_json(path)):
                with self.assertRaises(ValueError):
                    apply_current_reader_policy(self.historical)
        for field, value in (("reviewer", "/root"), ("reviewer", "stored-cost-author-b2"),
                             ("reviewer", "   "), ("reviewer", 123),
                             ("substantive_reconstruction", True), ("contract_change_assessment", True),
                             ("successor_contract_hash", "old contract reused"),
                             ("original_contract_hash", "unbound predecessor"),
                             ("repair_record_digest", "unreviewed change"),
                             ("contract_change_assessment", {}), ("question_version", 1)):
            bad = deepcopy(read_json(vp))
            bad[field] = value
            with patch.object(policy, "read_json", side_effect=lambda path: bad if Path(path) == vp else read_json(path)):
                with self.assertRaises(ValueError):
                    apply_current_reader_policy(self.historical)

    def test_polynomial_question_corrections_keep_reserved_core_and_split(self):
        originals = {i['core_id']: i for i in self.historical}
        current, decisions = apply_current_reader_policy(self.historical)
        by_id = {i['core_id']: i for i in current}
        for core in ('qcb-core-sp-108', 'qcb-core-sp-111'):
            with self.subTest(core=core):
                old, new = originals[core], by_id[core]
                self.assertNotEqual(old['question'], new['question'])
                self.assertEqual(new['question_version'], 2)
                fields = [k for k in CONTRACT_FIELDS if k != 'question']
                self.assertEqual({k: old[k] for k in fields}, {k: new[k] for k in fields})
                self.assertEqual(len(new['semantic_steps']), old['semantic_step_count'])
                self.assertEqual(sum(i['core_id'] == core for i in current), 1)
                lineage = new['question_successor']
                self.assertEqual(lineage['additional_core_count'], 0)
                self.assertFalse(lineage['equivalence_to_predecessor_claimed'])
                self.assertNotEqual(lineage['predecessor_contract_hash'], lineage['current_contract_hash'])
                self.assertEqual(new['reviews'][0]['method'], 'independent-question-successor-review')
                self.assertNotEqual(new['reviews'][0]['reviewer'], new['author']['identity'])
                self.assertNotIn(old['reviews'][0], new['reviews'])
                row = next(r for r in decisions if r['core_id'] == core)
                self.assertEqual(row['prior_withdrawal']['predecessor_item_digest'], digest(old))
                with self.assertRaisesRegex(ValueError, 'withdrawn'):
                    check_current_gold([old])

    def test_rejected_question_successor_stays_reserved_not_current_gold(self):
        from copy import deepcopy
        row = read_json(B / "shared/current-policy.json")["question_successors"][0]
        vp = B / row["review"]
        bad = deepcopy(read_json(vp))
        bad["verdict"] = "uncertain"
        with patch.object(policy, "read_json", side_effect=lambda path: bad if Path(path) == vp else read_json(path)):
            current, decisions = apply_current_reader_policy(self.historical)
        self.assertNotIn(row["core_id"], {i["core_id"] for i in current})
        self.assertEqual(next(r for r in decisions if r["core_id"] == row["core_id"])["status"],
                         "withheld_pending_distinct_question_review")

    def test_question_successor_schema_rejects_malformed_payload_even_if_review_rebound(self):
        from copy import deepcopy
        row = read_json(B / "shared/current-policy.json")["question_successors"][0]
        rp, vp = B / row["repair"], B / row["review"]
        for field, value in (("reference_answer", ""), ("rubric", None), ("rubric", ["invalid"]),
                             ("key", "qcb-core-sp-001"),
                             ("rubric", [{"id": "c1", "criterion": "check", "weight": float('nan')}]),
                             ("rubric", [{"id": "c1", "criterion": "check", "weight": True}])):
            candidate, review = deepcopy(read_json(rp)), deepcopy(read_json(vp))
            candidate[field] = value
            review["repair_record_digest"] = digest(candidate)
            def mocked(path):
                return candidate if Path(path) == rp else review if Path(path) == vp else read_json(path)
            with patch.object(policy, "read_json", side_effect=mocked), self.assertRaises(ValueError):
                apply_current_reader_policy(self.historical)
