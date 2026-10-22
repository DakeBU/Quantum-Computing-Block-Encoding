"""Run the four inspected BE102 support roots; this is never a prediction runner."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--build-root', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
parser.add_argument('--trusted-local-reference', action='store_true')
args = parser.parse_args()
if not args.trusted_local_reference:
    raise ValueError('Explicitly inspected fixed references only; never pass predictions.')
root = Path(__file__).resolve().parents[3]
build, out = args.build_root.resolve(), args.output.resolve()
if out.exists():
    raise FileExistsError('Preserve prior receipts; choose a new output path.')
sys.path[:0] = [str(root), str(root / 'benchmarks/quantumcomputingbench/src')]
from qcb_core import digest
from qcb_integrity import text_sha
from website.scripts.proof_inputs import proof_input_digest, lean_module_targets
identity = proof_input_digest(root)
gate = json.loads((build / '_out/lean-gate.json').read_text())
assert gate['passed'] and gate['proofInputsSha256'] == identity == proof_input_digest(build)
assert gate['compiledModules'] == lean_module_targets(root) == lean_module_targets(build)
path = root / 'benchmarks/quantumcomputingbench/reports/textbook-v1/repairs/fixed-references/DirtyWorkBoundary.lean'
source = path.read_text()
prefix = 'QuantumBlockEncoding.QcbDirtyWorkBoundary.'
names = ['entering_work_preserved', 'row_preserved', 'dirty_three_correct_sum', 'dirty_one_wrong_sum']
allowed = {'propext', 'Classical.choice', 'Quot.sound'}

def run(path):
    return subprocess.run(['lake', 'env', 'lean', str(path)], cwd=build, capture_output=True,
                          text=True, encoding='utf-8', timeout=300)

def axioms(stdout):
    return {name: sorted(a.strip() for a in values.split(',') if a.strip())
            for name, values in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", stdout)}

actual = run(path)
if actual.returncode:
    raise RuntimeError(actual.stdout[-6000:] + actual.stderr[-2000:])
roots = axioms(actual.stdout)
assert set(roots) == {prefix + name for name in names}
assert all(set(a) <= allowed for a in roots.values())
start = source.index(' := by\n', source.index('theorem entering_work_preserved'))
end = source.index('\ntheorem row_preserved', start)
with tempfile.TemporaryDirectory(prefix='qcb-inspected-dirty-work-negative-') as tmp:
    negative_path = Path(tmp) / 'SorryControl.lean'
    negative_path.write_text(source[:start] + ' := by\n  sorry\n' + source[end:], encoding='utf-8')
    negative = run(negative_path)
    negative_axioms = axioms(negative.stdout)
    assert 'sorryAx' in negative_axioms[prefix + 'entering_work_preserved']
    wrong_path = Path(tmp) / 'WrongTarget.lean'
    assert source.count('primitiveAccess3BasisEquiv state 6 = state 6') == 1
    wrong_path.write_text(source.replace('primitiveAccess3BasisEquiv state 6 = state 6', 'primitiveAccess3BasisEquiv state 6 = flipBit (state 6)'), encoding='utf-8')
    wrong = run(wrong_path)
    assert wrong.returncode != 0
assert identity == proof_input_digest(root) == proof_input_digest(build)
assert path.read_text() == source
repair = root / 'benchmarks/quantumcomputingbench/shared/repairs/be-102-dirty-work-boundary-repair.json'
receipt = {
    'schema_version': 'qcb.inspected_dirty_work_boundary_reference.v1',
    'execution_class': 'trusted_inspected_fixed_reference', 'isolated_prediction_evaluation': False,
    'canonical_runner_sha256_lf': text_sha(Path(__file__)),
    'source_file': path.relative_to(root).as_posix(), 'source_sha256_lf': text_sha(path),
    'source_sha256_bytes': hashlib.sha256(path.read_bytes()).hexdigest(),
    'repair_record_digest': digest(json.loads(repair.read_text())),
    'lean_version': subprocess.check_output(['lake', 'env', 'lean', '--version'], cwd=build, text=True).strip(),
    'reference_exit_code': actual.returncode, 'checked_roots': roots, 'approved_axioms': sorted(allowed),
    'reference_stdout': actual.stdout, 'reference_stderr': actual.stderr,
    'proof_inputs_sha256': identity, 'existing_compiled_module_count': len(gate['compiledModules']),
    'cached_checkout_commit': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=build, text=True).strip(),
    'full_library_gate_execution': 'Existing exact-digest/module-matching gate inherited; not rerun by this support check.',
    'sorry_control': {'exit_code': negative.returncode, 'offending_axioms': negative_axioms[prefix + 'entering_work_preserved'], 'rejected': True},
    'wrong_target_control': {'exit_code': wrong.returncode, 'rejected': True},
    'limitations': ['Four exact named support roots: unconditional entering-work/row preservation and two fixed dirty-input arithmetic witnesses, for the actual seven-wire circuit only.',
                   'Not a native formal-view admission, independent source-blind decoding, isolated prediction evaluation, all-prose kernel certification or finite-bit theorem.']}
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'checked_roots': len(roots), 'sorry_control_rejected': True,
                  'wrong_target_control_rejected': True, 'receipt_digest': digest(receipt)}))
