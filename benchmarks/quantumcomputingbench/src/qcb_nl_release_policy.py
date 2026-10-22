"""Current mathematical admission policy over immutable native release history.

Old files remain inspectable; they must not be reused as current gold when an
answer was superseded after a real mathematical/source defect was identified.
This additive guard does not alter earlier pipeline hashes or claim new proofs.
"""
from qcb_nl import WITHDRAWN_NATIVE

WITHDRAWN_KEYS = {
    **WITHDRAWN_NATIVE,
    'qcb-core-sp-101': 'unasked degree-minimality overclaim; use exact degree upper-bound successor',
    'qcb-core-la-205': 'missing +2N write-budget term makes stated sum internally inconsistent',
    'qcb-core-plan-210-diagonal-one-sparse-block-encoding-identity': 'normalization A/||A|| used without excluding A=0',
    'qcb-core-plan-402-werner-isotropic-k-extendibility-thresholds': 'printed fraction (1-d)/k misread as 1-d/k in primary text extraction',
    'qcb-core-plan-411-transpose-trick-and-UU-invariance': 'false intermediate identity and silent source-conjugation repair',
    'qcb-core-plan-418-cloning-map-cp-trace-nonincreasing': 'incorrect single-Kraus extension and trace equality characterization',
    'qcb-core-plan-001-povm-nonunique-update': 'integration quarantine: positive square root and instrument semantics',
    'qcb-core-plan-002-partial-transpose-negativity-converse-boundary': 'integration quarantine: trivial-factor dimension counterexample',
    'qcb-core-plan-006-trace-norm-unitary-variational': 'integration quarantine: scalar counterexample and norm-bound argument',
    'qcb-core-plan-303-external-product-irrep': 'integration quarantine: wrong second tensor representation',
    'qcb-core-sp-002': 'textbook second pass: free output bond index conflated with summed input bond index; use the separately reviewed answer successor',
    'qcb-core-sp-006': 'textbook second pass: arbitrary-real normalization does not remove the circuit theorem nonnegative-entry hypothesis',
    'qcb-core-sp-011': 'textbook second pass: active dimension > 2 also forbids active-only unitary terminal cleanup',
    'qcb-core-sp-105': 'textbook second pass: unrestricted affine dimension is missing from answer and rubric',
    'qcb-core-sp-107': 'textbook second pass: public coefficient normalization/reflection contract is ambiguous',
    'qcb-core-sp-108': 'textbook second pass: false degree k+1 instead of i+k+1 in question',
    'qcb-core-sp-111': 'textbook second pass: zero grid step invalidates exact polynomial degree claim',
    'qcb-core-sp-113': 'textbook second pass: positivity does not supply the unit grid anchor',
    'qcb-core-sp-115': 'textbook second pass: width-two threshold claim omits bounded natural suffix premise',
    'qcb-core-sp-117': 'textbook second pass: single-cut/all-cut rank and circuit-existence conflation',
    'qcb-core-sp-119': 'textbook second pass: fixed-function versus order-indexed family ambiguity',
    'qcb-core-la-003': 'textbook second pass: raw coefficient syntax is not a ring under constructor operations',
    'qcb-core-la-013': 'textbook second pass: basis permutation must be explicitly wire-induced',
    'qcb-core-plan-003-density-set-convexity': 'textbook second pass: topological boundary is not the extreme-point set',
    'qcb-core-be-003': 'textbook second pass: conflicting scalar target ranges in question and assumptions',
    'qcb-core-be-004': 'textbook second pass: adjoint uniqueness and deterministic auxiliary cleanup overclaims',
    'qcb-core-be-008': 'textbook second pass: more signal qubits cannot evade clean-block contraction',
    'qcb-core-be-009': 'textbook second pass: counterexample violates the one-sparse premise',
    'qcb-core-be-012': 'textbook second pass: finite injective self-map is already surjective',
}


def check_current_gold(items, *, frozen_preview_audit=False):
    withdrawn = sorted({i.get('key') for i in items} & WITHDRAWN_KEYS.keys())
    if frozen_preview_audit:
        # Only reproduce the published historical preview for audit. Its CLI
        # separately refuses current native scoring/repackaging after a repair.
        audit_only_keys = {'qcb-core-sp-002', 'qcb-core-sp-006', 'qcb-core-sp-011',
            'qcb-core-sp-105', 'qcb-core-sp-107', 'qcb-core-sp-108', 'qcb-core-sp-111',
            'qcb-core-sp-113', 'qcb-core-sp-115', 'qcb-core-sp-117', 'qcb-core-sp-119',
            'qcb-core-la-003', 'qcb-core-la-013', 'qcb-core-plan-003-density-set-convexity',
            'qcb-core-be-003', 'qcb-core-be-004', 'qcb-core-be-008', 'qcb-core-be-009', 'qcb-core-be-012'}
        withdrawn = [key for key in withdrawn if key not in audit_only_keys]
    if withdrawn:
        raise ValueError('withdrawn historical native gold: ' + ', '.join(withdrawn)
                         + '; use scripts/release.py for the current admission overlay; old files are audit-only')
    if any(i.get('lifecycle') != 'released' for i in items):
        raise ValueError('current scoring accepts admitted release items only')
    return items
