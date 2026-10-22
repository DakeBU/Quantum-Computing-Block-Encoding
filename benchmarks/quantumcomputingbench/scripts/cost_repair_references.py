"""Replay only the inspected fixed cost-repair source; never accept predictions."""
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
    raise ValueError('Only explicitly inspected fixed references may run locally; never pass predictions.')
root = Path(__file__).resolve().parents[3]
build = args.build_root.resolve()
out = args.output.resolve()
if out.exists():
    raise FileExistsError('Do not overwrite an existing fixed-reference receipt; choose a new output.')
sys.path[:0] = [str(root), str(root/'benchmarks/quantumcomputingbench/src')]
from qcb_core import digest
from qcb_integrity import text_sha
from website.scripts.proof_inputs import proof_input_digest, lean_module_targets
identity = proof_input_digest(root)
gate = json.loads((build/'_out/lean-gate.json').read_text())
assert gate['passed'] and gate['proofInputsSha256'] == identity == proof_input_digest(build)
assert gate['compiledModules'] == lean_module_targets(root) == lean_module_targets(build)
path = root/'benchmarks/quantumcomputingbench/reports/textbook-v1/repairs/fixed-references/StoredCostRepair.lean'
source = path.read_text()
names = ['zero_branch','nonnegative_nonzero_branch','negative_nonzero_branch','addZeros_value','addZeros_cost','one_by_one_field_cost','one_by_one_zero_matrix']
prefix = 'QuantumBlockEncoding.StoredGivens.QcbCostRepairReference.'
allowed = {'propext','Classical.choice','Quot.sound'}
def run(path):
    return subprocess.run(['lake','env','lean',str(path)],cwd=build,capture_output=True,text=True,encoding='utf-8',timeout=300)
def axioms(stdout):
    return {name: sorted(a.strip() for a in values.split(',') if a.strip()) for name,values in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]",stdout)}
actual = run(path)
if actual.returncode:
    raise RuntimeError(actual.stdout[-6000:]+actual.stderr[-2000:])
roots = axioms(actual.stdout)
assert set(roots) == {prefix+n for n in names}
assert all(set(a)<=allowed for a in roots.values())
start = source.index(' := by\n',source.index('theorem zero_branch'))
end = source.index('\ntheorem nonnegative_nonzero_branch',start)
with tempfile.TemporaryDirectory(prefix='qcb-inspected-cost-negative-') as tmp:
    negative_path = Path(tmp)/'Negative.lean'
    negative_path.write_text(source[:start]+' := by\n  sorry\n'+source[end:],encoding='utf-8')
    negative = run(negative_path)
    negative_axioms = axioms(negative.stdout)
    assert 'sorryAx' in negative_axioms[prefix+'zero_branch']
    wrong_path = Path(tmp)/'WrongTarget.lean'
    wrong_path.write_text(source.replace('3 * tick .field op','4 * tick .field op',1),encoding='utf-8')
    wrong = run(wrong_path)
    assert wrong.returncode != 0
version = subprocess.check_output(['lake','env','lean','--version'],cwd=build,text=True).strip()
assert identity == proof_input_digest(root) == proof_input_digest(build)
assert path.read_text() == source
repair_dir = root/'benchmarks/quantumcomputingbench/shared/repairs'
repairs = {name: digest(json.loads((repair_dir/name).read_text())) for name in ['la-214-uniform-supplier-bound-repair.json','la-215-branch-cost-repair.json']}
receipt = {'schema_version':'qcb.inspected_cost_repair_reference.v1',
 'execution_class':'trusted_inspected_fixed_reference','isolated_prediction_evaluation':False,
 'canonical_runner_sha256_lf':text_sha(Path(__file__)),
 'source_file':path.relative_to(root).as_posix(),'source_sha256_lf':text_sha(path),
 'source_sha256_bytes':hashlib.sha256(path.read_bytes()).hexdigest(),
 'repair_record_digests':repairs,'lean_version':version,'reference_exit_code':actual.returncode,
 'checked_roots':roots,'approved_axioms':sorted(allowed),
 'reference_stdout':actual.stdout,'reference_stderr':actual.stderr,
 'proof_inputs_sha256':identity,'existing_compiled_module_count':len(gate['compiledModules']),
 'cached_checkout_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=build,text=True).strip(),
 'full_library_gate_execution':'Existing exact-digest/module-matching gate inherited; not freshly rerun by this reference check.',
 'sorry_control':{'exit_code':negative.returncode,'offending_axioms':negative_axioms[prefix+'zero_branch'],'rejected':True},
 'wrong_target_control':{'exit_code':wrong.returncode,'rejected':True},
 'limitations':['Seven exact named roots only: three concrete branch representatives plus the symbolic arbitrary-K one-by-one supplier construction and its helper lemmas.',
 'Universal sign-branch explanations still require the independently reviewed control-flow reconstruction; concrete representatives do not certify all NL prose.',
 'Not a native formal-view admission, blind semantic reconstruction, untrusted-output sandbox, finite-bit runtime result or model baseline.']}
out.parent.mkdir(parents=True,exist_ok=True)
out.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'checked_roots':len(roots),'sorry_control_rejected':True,'wrong_target_control_rejected':True,'receipt_digest':digest(receipt)}))
