"""Actual local release integration checks; unavailable Lean stays blocked."""
from pathlib import Path
import json
import sys
import unittest
B=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(B/'src'))
from qcb_core import validate, digest, model_input

class ReleaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory=B/'data/public/release-v2'
        if not cls.directory.exists():
            raise unittest.SkipTest('Run snapshot/generate/review/export release-v2 before integration checks')
        cls.items=json.loads((cls.directory/'items.json').read_text())
        cls.release=json.loads((cls.directory/'release.json').read_text())
        cls.snap=json.loads((B/'manifests/release-v2/snapshot.json').read_text())

    def test_actual_retained_items_validate(self):
        self.assertEqual(validate(self.items,self.snap,B.parents[1]),[])
        self.assertEqual(len({i['id'] for i in self.items}),len(self.items))

    def test_release_has_real_bound_review_and_no_lean_claim(self):
        self.assertTrue(self.release)
        for i in self.release:
            self.assertEqual(i['lifecycle'],'released')
            self.assertTrue(i['reviews'])
            self.assertEqual(i['unresolved_issues'],[])
            self.assertIsNone(i['formal'])
            self.assertNotIn('lean_certified',i['evidence_status'])

    def test_all_three_splits_and_planned_holdout(self):
        self.assertEqual({i['split'] for i in self.release},{'train','dev','test_public'})
        for i in self.release:
            if i['track']=='planned':self.assertEqual(i['split'],'test_public')

    def test_real_prompt_export_excludes_gold(self):
        prompts=json.loads((self.directory/'prompts-closed_book.json').read_text())
        self.assertEqual(prompts,[model_input(i) for i in self.release])
        for p in prompts:
            self.assertNotIn('reference_answer',p)
            self.assertNotIn('rubric',p)
            self.assertNotIn('formal',p)
            self.assertNotIn('reviews',p)

    def test_all_nodes_accounted_no_candidate_inflation(self):
        coverage=json.loads((B/'reports/release-v2/coverage.json').read_text())
        self.assertEqual(len(coverage['ledger']),len(self.snap['nodes']))
        self.assertEqual(sum(coverage['dispositions'].values()),len(self.snap['nodes']))
        released_ids={i['id'] for i in self.release}
        for row in coverage['ledger']:
            self.assertTrue(set(row['released_items'])<=released_ids)
        self.assertEqual(coverage['lean_certified_items'],0)
        self.assertFalse(coverage['benchmark_complete'])

if __name__=='__main__':unittest.main()
