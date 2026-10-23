"""Bind real fixed-reference receipts; unit tests do not pretend to rerun Lean."""
from pathlib import Path
import re
import subprocess
import sys
import unittest

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / 'src'))
from qcb_core import digest, read_json
from qcb_integrity import text_sha
from qcb_lean import APPROVED_AXIOMS


class CostRepairReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.receipt = read_json(B / 'reports/textbook-v1/repairs/fixed-references/checked-receipt.json')

    def test_source_runner_and_exact_repair_bindings(self):
        report = self.receipt
        self.assertEqual(report['source_sha256_lf'], text_sha(R / report['source_file']))
        self.assertEqual(report['canonical_runner_sha256_lf'], text_sha(B / 'scripts/cost_repair_references.py'))
        for name, value in report['repair_record_digests'].items():
            self.assertEqual(value, digest(read_json(B / 'shared/repairs' / name)))
        from website.scripts.proof_inputs import proof_input_digest, lean_module_targets
        self.assertEqual(report['proof_inputs_sha256'], proof_input_digest(R))
        self.assertEqual(report['existing_compiled_module_count'], len(lean_module_targets(R)))

    def test_seven_named_roots_have_actual_allowed_transitive_axioms(self):
        report = self.receipt
        names = {'zero_branch', 'nonnegative_nonzero_branch', 'negative_nonzero_branch',
                 'addZeros_value', 'addZeros_cost', 'one_by_one_field_cost', 'one_by_one_zero_matrix'}
        expected = {'QuantumBlockEncoding.StoredGivens.QcbCostRepairReference.' + n for n in names}
        self.assertEqual(set(report['checked_roots']), expected)
        parsed = {name: sorted(a.strip() for a in values.split(',') if a.strip())
                  for name, values in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", report['reference_stdout'])}
        self.assertEqual(parsed, report['checked_roots'])
        self.assertEqual(report['reference_exit_code'], 0)
        self.assertTrue(all(set(a) <= APPROVED_AXIOMS for a in parsed.values()))
        self.assertEqual(set(report['approved_axioms']), APPROVED_AXIOMS)
        self.assertIs(report['isolated_prediction_evaluation'], False)
        self.assertTrue(report['limitations'])

    def test_actual_negative_controls_are_not_mistaken_for_valid_references(self):
        report = self.receipt
        self.assertIn('sorryAx', report['sorry_control']['offending_axioms'])
        self.assertTrue(report['sorry_control']['rejected'])
        self.assertNotEqual(report['wrong_target_control']['exit_code'], 0)
        self.assertTrue(report['wrong_target_control']['rejected'])

    def test_local_execution_requires_explicit_inspected_reference_flag(self):
        result = subprocess.run([sys.executable, str(B / 'scripts/cost_repair_references.py'),
                                 '--build-root', str(R), '--output', str(R / '_out/not-executed.json')],
                                capture_output=True, text=True, timeout=30)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('never pass predictions', result.stderr)


class SingleRepairReferenceChecks:
    """The same evidence rules apply to each separately inspected support packet."""
    def test_actual_support_receipt_binds_roots_candidate_runner_and_substrate(self):
        report = read_json(B / 'reports/textbook-v1/repairs/fixed-references' / self.receipt_name)
        self.assertEqual(report['source_sha256_lf'], text_sha(R / report['source_file']))
        self.assertEqual(report['canonical_runner_sha256_lf'], text_sha(B / 'scripts' / self.runner_name))
        self.assertEqual(report['repair_record_digest'], digest(read_json(B / 'shared/repairs' / self.repair_name)))
        expected = {self.namespace + n for n in self.root_names}
        self.assertEqual(set(report['checked_roots']), expected)
        parsed = {name: sorted(a.strip() for a in values.split(',') if a.strip())
                  for name, values in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", report['reference_stdout'])}
        self.assertEqual(parsed, report['checked_roots'])
        self.assertTrue(all(set(a) <= APPROVED_AXIOMS for a in parsed.values()))
        self.assertEqual(report['reference_exit_code'], 0)
        self.assertIn('sorryAx', report['sorry_control']['offending_axioms'])
        self.assertTrue(report['sorry_control']['rejected'])
        self.assertNotEqual(report['wrong_target_control']['exit_code'], 0)
        self.assertTrue(report['wrong_target_control']['rejected'])
        self.assertFalse(report['isolated_prediction_evaluation'])
        from website.scripts.proof_inputs import proof_input_digest, lean_module_targets
        self.assertEqual(report['proof_inputs_sha256'], proof_input_digest(R))
        self.assertEqual(report['existing_compiled_module_count'], len(lean_module_targets(R)))

    def test_prediction_execution_is_not_enabled_by_reference_script(self):
        result = subprocess.run([sys.executable, str(B / 'scripts' / self.runner_name),
                                 '--build-root', str(R), '--output', str(R / '_out/not-executed-wide.json')],
                                capture_output=True, text=True, timeout=30)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('never pass predictions', result.stderr)


class WideLQContractReferenceTests(SingleRepairReferenceChecks, unittest.TestCase):
    receipt_name = 'wide-lq-checked-receipt.json'
    runner_name = 'wide_lq_contract_reference.py'
    repair_name = 'la-206-cost-contract-successor.json'
    namespace = 'QuantumBlockEncoding.QcbWideLQCostContract.'
    root_names = ('actual_stage_cost', 'one_by_one_emit', 'one_by_one_budget_emit')


class DirtyWorkBoundaryReferenceTests(SingleRepairReferenceChecks, unittest.TestCase):
    receipt_name = 'dirty-work-checked-receipt.json'
    runner_name = 'dirty_work_boundary_reference.py'
    repair_name = 'be-102-dirty-work-boundary-repair.json'
    namespace = 'QuantumBlockEncoding.QcbDirtyWorkBoundary.'
    root_names = ('entering_work_preserved', 'row_preserved', 'dirty_three_correct_sum', 'dirty_one_wrong_sum')


if __name__ == '__main__':
    unittest.main()
