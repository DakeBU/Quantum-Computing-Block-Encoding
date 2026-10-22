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
}


def check_current_gold(items):
    withdrawn = sorted({i.get('key') for i in items} & WITHDRAWN_KEYS.keys())
    if withdrawn:
        raise ValueError('withdrawn historical native gold: ' + ', '.join(withdrawn)
                         + '; use nl-v12 or a separately reviewed successor; old files are audit-only')
    if any(i.get('lifecycle') != 'released' for i in items):
        raise ValueError('current scoring accepts admitted release items only')
    return items
