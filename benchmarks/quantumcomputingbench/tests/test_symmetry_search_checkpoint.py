"""Exact editorial bindings and fail-closed admission, not mathematical proofs."""
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

B = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(B / 'src'), str(B / 'scripts')]
import release
from qcb_core import digest, read_json
from qcb_curriculum import core_contract
import qcb_textbook_policy as policy

ANSWER_ONLY = {414, 509}
QUESTION_ONLY = {415, 420, 510, 513, 515, 517, 518, 520}
IDS = {f'qcb-core-plan-{n}' for n in ANSWER_ONLY | QUESTION_ONLY}


class SymmetrySearchCheckpointTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.originals = {i['core_id']: i for i in release.checked()[2]}
        cls.current, cls.decisions = policy.apply_current_reader_policy(list(cls.originals.values()))
        cls.by_id = {i['core_id']: i for i in cls.current}

    def test_exact_ten_targets_keep_core_scope_and_review_only_current_content(self):
        self.assertTrue(IDS <= self.by_id.keys())
        self.assertEqual(len(self.current), len(self.by_id))
        for core in IDS:
            with self.subTest(core=core):
                old, new = self.originals[core], self.by_id[core]
                changed = {'question'} if int(core.rsplit('-', 1)[1]) in QUESTION_ONLY else set()
                for field in set(policy.CONTRACT_FIELDS) - changed:
                    self.assertEqual(old[field], new[field])
                self.assertEqual([s['supporting_nodes'] for s in old['semantic_steps']],
                                 [s['supporting_nodes'] for s in new['semantic_steps']])
                self.assertEqual(len(new['semantic_steps']), old['semantic_step_count'])
                self.assertNotEqual(old['reference_answer'], new['reference_answer'])
                self.assertNotIn(old['reviews'][0], new['reviews'])
                self.assertNotEqual(new['reviews'][0]['reviewer'], new['author']['identity'])
                decision = next(d for d in self.decisions if d['core_id'] == core)
                self.assertEqual(decision['prior_withdrawal']['predecessor_item_digest'], digest(old))

    def test_question_changes_are_visible_not_claimed_equivalent_or_additional_cores(self):
        for number in QUESTION_ONLY:
            core = f'qcb-core-plan-{number}'
            old, new = self.originals[core], self.by_id[core]
            lineage = new['question_successor']
            self.assertEqual(new['question_version'], 2)
            self.assertEqual(lineage['changed_contract_fields'], ['question'])
            self.assertEqual(lineage['predecessor_contract_hash'], digest(core_contract(old)))
            self.assertEqual(lineage['current_contract_hash'], digest(core_contract(new)))
            self.assertNotEqual(lineage['predecessor_contract_hash'], lineage['current_contract_hash'])
            self.assertFalse(lineage['equivalence_to_predecessor_claimed'])
            self.assertEqual(lineage['additional_core_count'], 0)
            self.assertNotIn('task_hash', new)
            self.assertIn('task_hash', new['inherited_predecessor_hashes'])
        for number in ANSWER_ONLY:
            new = self.by_id[f'qcb-core-plan-{number}']
            self.assertIn('textbook_successor', new)
            self.assertNotIn('question_successor', new)

    def test_each_missing_exact_review_withholds_its_target_without_reusing_old_approval(self):
        current_policy = read_json(B / 'shared/current-policy.json')
        rows = current_policy['answer_successors'] + current_policy['question_successors']
        actual_is_file = Path.is_file
        for row in [r for r in rows if r['core_id'] in IDS]:
            missing = B / row['review']
            with self.subTest(core=row['core_id']), patch.object(Path, 'is_file',
                    lambda path: False if path == missing else actual_is_file(path)):
                current, decisions = policy.apply_current_reader_policy(list(self.originals.values()))
            self.assertNotIn(row['core_id'], {i['core_id'] for i in current})
            decision = next(d for d in decisions if d['core_id'] == row['core_id'])
            self.assertTrue(decision['status'].startswith('withheld_pending_distinct_'))


if __name__ == '__main__':
    unittest.main()
