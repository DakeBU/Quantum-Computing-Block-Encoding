"""Current withdrawal policy tests; all old artifacts remain audit-only intact."""
from pathlib import Path
import json,sys,unittest
B=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(B/'src'))
from qcb_nl_release_policy import WITHDRAWN_KEYS,check_current_gold

class CurrentPolicyTests(unittest.TestCase):
 def test_known_false_old_answers_cannot_score(self):
  for key in WITHDRAWN_KEYS:
   with self.subTest(key=key),self.assertRaises(ValueError):
    check_current_gold([{'key':key,'lifecycle':'released'}])

 def test_candidate_never_gold(self):
  with self.assertRaises(ValueError):check_current_gold([{'key':'new','lifecycle':'candidate'}])

 def test_corrected_key_not_mistaken_for_new_count_or_old_gold(self):
  key='qcb-core-sp-101-corrected-v2'
  self.assertEqual(check_current_gold([{'key':key,'lifecycle':'released'}])[0]['key'],key)

 def test_actual_current_release_has_no_withdrawn_answers(self):
  p=B/'data/public/nl-v12/release.json'
  if not p.exists():raise unittest.SkipTest('expanded native release not built')
  values=json.loads(p.read_text());self.assertGreaterEqual(len(values),200)
  self.assertEqual(len(check_current_gold(values)),len(values))
  self.assertEqual(len({i['core_id'] for i in values}),len(values))

 def test_original_old_files_are_still_present_for_audit(self):
  for name in ['batch2_structured_preparation.json','batch2_stored_costs.json','batch2_scientific_algorithms.json','batch3_quantum_information_apps.json']:
   self.assertTrue((B/'data/native_nl'/name).is_file())

if __name__=='__main__':unittest.main()
