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
}


def check_current_gold(items, *, frozen_preview_audit=False):
    withdrawn = sorted({i.get('key') for i in items} & WITHDRAWN_KEYS.keys())
    if frozen_preview_audit:
        # Only reproduce the published historical preview for audit. Its CLI
        # separately refuses current native scoring/repackaging after a repair.
        withdrawn = [key for key in withdrawn if key not in {'qcb-core-sp-002', 'qcb-core-sp-006', 'qcb-core-sp-011'}]
    if withdrawn:
        raise ValueError('withdrawn historical native gold: ' + ', '.join(withdrawn)
                         + '; use scripts/release.py for the current admission overlay; old files are audit-only')
    if any(i.get('lifecycle') != 'released' for i in items):
        raise ValueError('current scoring accepts admitted release items only')
    return items
