"""Current mathematical admission policy over immutable native release history.

Old files remain inspectable; they must not be reused as current gold when an
answer was superseded after a real mathematical/source defect was identified.
This additive guard does not alter earlier pipeline hashes or claim new proofs.
"""
from qcb_nl import WITHDRAWN_NATIVE

WITHDRAWN_KEYS = {
    'qcb-core-be-102': 'Dirty-input loss of a clean-branch guarantee is not universal simultaneous arithmetic failure and scratch corruption.',
    'qcb-core-be-104': 'Bare emitted gate products omit the compiler global phase and do not equal the claimed exact 0/1 permutation matrix.',
    'qcb-core-be-108': 'Independent row/column permutations preserve unitarity; same-axis algebra closure is not a necessary condition.',
    'qcb-core-be-112': 'Product unitarity neither forces the final adjoint nor guarantees deterministic selector cleanup.',
    'qcb-core-be-119': 'Visible backend wire count is not established as the full physical count including internal oracle workspace.',
    'qcb-core-plan-104-schur-lemma-equivariant-zero-or-iso': 'Equivariance as a functional equation omits the linear-map premise used by Schur kernel/image reasoning.',
    'qcb-core-plan-105-schur-lemma-scalar-over-alg-closed': 'The scalar-Schur question omits linearity; a nonlinear equivariant function need not be scalar.',
    'qcb-core-plan-106-abelian-group-complex-irreps-one-dimensional': 'The unrestricted abelian-group contract omits finite dimension and has an infinite-dimensional irreducible counterexample.',
    'qcb-core-plan-107-pauli-twirl-maximally-mixed': 'The Pauli twirl expansion omits the right adjoint and contains a false noncommutative equality.',
    'qcb-core-plan-108-character-is-class-function-degree': 'The scalar field convention is absent; trace of identity need not recover integer dimension in positive characteristic.',
    'qcb-core-plan-203-povm-amplitude-amplification-query-count': 'The amplification proof assumes an input-state reflection and independent fresh trials absent from the access contract.',
    'qcb-core-plan-204-unambiguous-discrimination-inconclusive-necessity': 'The complex-overlap proof drops a conjugation and equates 1-c^2 with 1-|c|^2.',
    'qcb-core-plan-206-povm-shared-ancilla-beta-assumption-boundary': 'Disjoint clean ancillas admit a common union projector; the proposed compensating PREP is also unnormalized.',
    'qcb-core-plan-207-amplitude-oracle-from-bit-oracle-uncompute': 'The explanation conflates joint signal/index decoherence with an unchanged signal marginal and basis-input coherence.',
    'qcb-core-plan-208-amplitude-oracle-maxnorm-normalization-boundary': 'The regime analysis mishandles zero entries and loses signed/complex amplitude phases through a magnitude-only rotation.',
    'qcb-core-plan-209-amplitude-vs-bit-oracle-query-gate-roles': 'The resource ledger switches from original entry-bit queries to a derived angle oracle and omits conversion resources.',
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
    'qcb-core-la-112': 'textbook second pass: UpperPrefix does not set earlier diagonal entries to zero',
    'qcb-core-la-119': 'textbook second pass: fixed-size example is not an asymptotic lower bound or optimal plane necessity',
    'qcb-core-la-206': 'textbook second pass: literal equality-with-budgets wording conflicts with the proved upper bound',
    'qcb-core-la-214': 'textbook second pass: a polynomial supplier example does not refute polynomial boundedness; use reviewed quantified repair',
    'qcb-core-la-215': 'textbook second pass: nonnegative-y nonzero branch does not attain the full field budget; use reviewed branch repair',
    'qcb-core-la-219': 'textbook second pass: correlated compiled guards do not establish an attainable loose-cap endpoint',
    'qcb-core-la-220': 'textbook second pass: attained maximum bond differs from its upper bound for a single closed core',
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
        audit_only_keys = {'qcb-core-be-102', 'qcb-core-be-104', 'qcb-core-be-108', 'qcb-core-be-112', 'qcb-core-be-119', 'qcb-core-plan-104-schur-lemma-equivariant-zero-or-iso', 'qcb-core-plan-105-schur-lemma-scalar-over-alg-closed', 'qcb-core-plan-106-abelian-group-complex-irreps-one-dimensional', 'qcb-core-plan-107-pauli-twirl-maximally-mixed', 'qcb-core-plan-108-character-is-class-function-degree', 'qcb-core-plan-203-povm-amplitude-amplification-query-count', 'qcb-core-plan-204-unambiguous-discrimination-inconclusive-necessity', 'qcb-core-plan-206-povm-shared-ancilla-beta-assumption-boundary', 'qcb-core-plan-207-amplitude-oracle-from-bit-oracle-uncompute', 'qcb-core-plan-208-amplitude-oracle-maxnorm-normalization-boundary', 'qcb-core-plan-209-amplitude-vs-bit-oracle-query-gate-roles',
            'qcb-core-sp-002', 'qcb-core-sp-006', 'qcb-core-sp-011',
            'qcb-core-sp-105', 'qcb-core-sp-107', 'qcb-core-sp-108', 'qcb-core-sp-111',
            'qcb-core-sp-113', 'qcb-core-sp-115', 'qcb-core-sp-117', 'qcb-core-sp-119',
            'qcb-core-la-003', 'qcb-core-la-013', 'qcb-core-plan-003-density-set-convexity',
            'qcb-core-la-112', 'qcb-core-la-119', 'qcb-core-la-206', 'qcb-core-la-214',
            'qcb-core-la-215', 'qcb-core-la-219', 'qcb-core-la-220',
            'qcb-core-be-003', 'qcb-core-be-004', 'qcb-core-be-008', 'qcb-core-be-009', 'qcb-core-be-012'}
        withdrawn = [key for key in withdrawn if key not in audit_only_keys]
    if withdrawn:
        raise ValueError('withdrawn historical native gold: ' + ', '.join(withdrawn)
                         + '; use scripts/release.py for the current admission overlay; old files are audit-only')
    if any(i.get('lifecycle') != 'released' for i in items):
        raise ValueError('current scoring accepts admitted release items only')
    return items
