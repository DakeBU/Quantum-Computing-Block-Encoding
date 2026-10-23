"""Pure-Python contract tests for bounded non-Lean expansion progress reporting."""
from pathlib import Path
import importlib.util
import json
import sys
import tempfile
import unittest
from unittest.mock import patch
B=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(B/'src'))
spec=importlib.util.spec_from_file_location('native_expansion_status',B/'scripts/nl_expansion_status.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)

class ExpansionStatusTests(unittest.TestCase):
 def test_missing_batch_is_not_coverage(self):
  with tempfile.TemporaryDirectory() as tmp,patch.object(module,'check_baseline',return_value={'nodes':[]}):
   report=module.collect(Path(tmp))
   self.assertEqual(report['candidate_records'],0)
   self.assertEqual(report['independently_accepted_records'],0)
   self.assertTrue(all(r['state']=='not_delivered' for r in report['batches']))
   self.assertFalse(report['complete'])
   self.assertEqual(report['publishing'],'local_only_no_push')

 def test_nine_disjoint_scopes_and_id_ranges(self):
  self.assertEqual(len(module.BATCHES),9)
  self.assertEqual(len(set(i['prefix'] for i in module.BATCHES.values())),9)
  self.assertTrue(all(p.endswith('.json') for p in module.BATCHES))

 def test_no_lean_claim_in_progress_report(self):
  with tempfile.TemporaryDirectory() as tmp,patch.object(module,'check_baseline',return_value={'nodes':[]}):
   report=module.collect(Path(tmp))
   self.assertFalse(report['local_lean_verification_performed'])

if __name__=='__main__':unittest.main()
