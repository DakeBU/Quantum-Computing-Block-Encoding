"""Actual expanded native corpus regression checks; source inspection not Lean."""
from pathlib import Path
import json,sys,unittest
B=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(B/'src'));sys.path.insert(0,str(B/'scripts'))
from qcb_core import score,model_input
from qcb_nl import native_errors,check_baseline,review_admits

class ExpandedCorpusTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.base=B/'data/public/nl-v9'
  if not cls.base.exists():raise unittest.SkipTest('expanded native milestone not built')
  cls.items=json.loads((cls.base/'items.json').read_text())
  cls.release=json.loads((cls.base/'release.json').read_text())

 def test_real_source_and_review_bindings(self):
  self.assertEqual(native_errors(self.items,check_baseline(B.parents[1]),B.parents[1]),[])

 def test_actual_reviewed_core_ids_unique(self):
  self.assertGreaterEqual(len(self.release),150)
  self.assertEqual(len({i['core_id'] for i in self.release}),len(self.release))
  self.assertTrue(all(all(review_admits(r,i) for r in i['reviews']) for i in self.release))

 def test_rejected_structured_and_cost_claims_not_gold(self):
  keys={i['core_id'] for i in self.release}
  self.assertNotIn('qcb-core-sp-101',keys)
  self.assertNotIn('qcb-core-la-205',keys)
  self.assertNotIn('qcb-core-plan-210',keys)

 def test_real_depth_is_separate_from_graph_distance(self):
  self.assertTrue(any(i['reviewed_semantic_step_count']>=6 for i in self.release))
  self.assertTrue(all(i['structural_graph_distance'] is None for i in self.release))
  self.assertTrue(all(i['reviewed_semantic_step_count']==len(i['semantic_steps']) for i in self.release))

 def test_copied_prose_is_not_model_or_human_validation(self):
  fixtures=score(self.release,[{'id':i['id'],'answer':i['reference_answer']} for i in self.release])
  self.assertFalse(fixtures['model_performance_measured'])
  self.assertTrue(all(i['correctness'] is None for i in fixtures['results']))

 def test_no_answer_metadata_in_real_model_prompts(self):
  for item in self.release:
   prompt=model_input(item)
   for key in ['reference_answer','rubric','semantic_steps','reviews','native_nl','source_refs']:
    self.assertNotIn(key,prompt)

 def test_no_source_inspection_promoted_to_new_compilation(self):
  self.assertTrue(all(i['formal'] is None for i in self.items))
  self.assertTrue(all(i['formal_evidence']['local_verification_performed'] is False for i in self.items))

if __name__=='__main__':unittest.main()
