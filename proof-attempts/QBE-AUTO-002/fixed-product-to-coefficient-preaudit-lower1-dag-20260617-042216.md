# Lower1 DAG: Fixed Product-To-Coefficient Pre-Audit

Task: `QBE-AUTO-002`  
Run: `20260617-041033-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `fixed_product_to_coefficient_pre_audit`  
Lower profile: natural-language proof architect

## Source Fragment

The active paper target is GHL2025 Theorem `theorem: 1 term robin`, local
source `main.tex:1098-1109`.  It states that the one-term Robin circuit
constructs a block-encoding of $A_k \sim f(x)D$ with normalizer
$N_D N_f \kappa$ and the paper's register count.

The local equation being translated is the boundary `gamma_3` line of
Eq. `eq: ROBIN clarified`, local source `main.tex:1111-1119`:

$$
|\gamma_3\rangle =
  \frac{1}{N_D N_f \kappa}
  \sum_{s,j\ \mathrm{boundary}}
    f(x_i) D_i^{(s)} \sigma^{(s)}
    |0\rangle^{m_f+1}|s\rangle|0\rangle^{n-\lceil\log_2\kappa\rceil}
    |j\rangle^n|0\rangle
  + \cdots .
$$

Fig. `fig:1 term ROBIN`, local source `main.tex:1122-1164`, supplies the
theorem-facing prepared circuit.  Definition `def:block-encoding`, local
source `main.tex:2027-2035`, supplies the clean signal block projection
contract.  Eq. `arbitrary sparcity`, local source `main.tex:948-955`, supplies
only the clean-column contract for $H_W^{(\kappa)}$.

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define
`interface` as
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env`.
This object names the source-prepared projection entry, the finite block
normalizer, and the fixed product obligation while keeping the theorem-facing
semantic flags false.

Define `gap` as `oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3`.
This object says the finite block backend exposes the signal-zero block entry
and matching full-unitary entry, but it does not expose a backend-sourced
`Fin 7 -> Coeff` sparse-summand family for that entry.

Define `obligation` as
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, written in Lean as
`oneTermRobinGamma3ProductToCoefficientObligation 3
  <0, by native_decide> <0, by native_decide>`.
It is the fixed product-to-coefficient theorem for the focused system entry.
Its `proved` field is intentionally false.

## Local Proof

The pre-audit theorem should package the two compiled coefficient-side facts
and the one current backend obstruction.

First, apply
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3`
with `H`, `env`, `hUniform`, and `hentry`.  This gives the source-prepared
entry equality
`Coeff.evalWith env interface.sourcePreparedProjectionEntry =
Coeff.evalWith env oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`.
It also carries the no-go guard
`not oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`.
This is the source-backed slot-2 path from Eq. `ROBIN clarified`, not the
refuted generic backend projection route.

Second, apply
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3`
with `H`, `env`, `hUniform`, `hentry`, `hND`, `hNF`, `hkappa`, and
`hkappaSqrt`.  This gives
`Coeff.evalWith env interface.sourcePreparedProjectionEntry *
Coeff.evalWith env interface.finiteBlockNormalizer =
Coeff.evalWith env interface.normalizedProjectionBridge.expectedTargetEntry`.
The hypotheses are explicit coefficient-normalizer identities; they are not
new paper assumptions.

Third, unfold the theorem-facing interface enough to identify
`interface.fixedProductObligation = obligation`.  The fixed obligation remains
false by construction and by
`oneTermRobinGamma3ProductToCoefficientObligation_transcript`.

Fourth, read `gap` through
`oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript`.  The
backend gap keeps
`exposesBranchContributionField = false`,
`backendFieldAvailable = false`,
`placeholderFamilyRejected = true`,
`projectionSummationProved = false`,
`productBridgeProved = false`,
`normalizedBlockEqualityProved = false`, and
`productToCoefficientProved = false`.

Therefore the correct lower2 theorem is only the non-promoting wrapper
`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`.  It feeds the
fixed product obligation by recording its exact inputs and current obstruction;
it does not close the product obligation, normalized block equality, LCU,
block projection, block correctness, final extraction, oracle correctness,
unitarity, or resource claim.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Status | Owner | Next route |
|---|---|---|---|---|---|
| `source_prepared_slot2_product` | Source-prepared projection entry evaluates to the Eq. `ROBIN clarified` slot-2 projected product. | `hUniform`, `hentry`, source-prepared target. | compiled route memory | none | reuse only |
| `branch_decomposition_projection_bridge` | Theorem-facing source-prepared entry equals both projected products and carries the generic projection no-go guard. | source-prepared slot-2 bridge; theorem-facing interface; `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`. | compiled; stale as lower work | none | reuse in pre-audit |
| `finite_block_normalizer_bridge` | Source-prepared projection entry times `interface.finiteBlockNormalizer` equals the expected target entry. | normalizer bridge; finite block contract; explicit `hND`, `hNF`, `hkappa`, `hkappaSqrt`. | compiled route memory | none | reuse in pre-audit |
| `backend_summand_interface_gap` | `BlockExtractionTarget` exposes the signal-zero block entry but not a backend-sourced sparse-summand family. | backend field target; branch-contribution target; block-extraction target. | active illness area | lower1/lower3 | keep active |
| `fixed_product_to_coefficient_pre_audit` | Package the two compiled coefficient-side equalities, fixed obligation identity, no-go guard, and backend gap false flags. | branch bridge; finite normalizer bridge; backend gap transcript. | active leaf for lower2 | lower2 | compile `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3` |
| `backend_sourced_sparse_summand_interface` | Produce a `Fin 7 -> Coeff` family sourced from `contract.expectedTarget.blockMatrix[0,0]`, satisfying selected slot 2 and branch-sum predicates. | `BlockExtractionTarget`; `BlockExtractionBranchContributionTarget`; source slot-2 predicate. | blocked internal | later lower1/lower3 then lower2 | define next precise leaf after pre-audit compiles |
| `fixed_product_to_coefficient` | Close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. | pre-audit wrapper plus backend-sourced sparse-summand interface and final coefficient algebra. | blocked; do not assign directly | later | wait |

## Ordered Lean Lemmas To Reuse

1. `oneTermRobinGamma3ProductToCoefficientObligation_transcript`.
   Use it to confirm the fixed obligation remains sourced to Eq. `ROBIN
   clarified`, Theorem one-term block-encoding, Fig. `1 term ROBIN`, and
   Definition `def:block-encoding`, with `proved = false`.

2. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
   This is the source-prepared slot-2 equality under `hUniform` and `hentry`.
   Lower2 should not reprove it.

3. `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`
   and
   `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3`.
   These expose the slot-2 projected product through theorem-facing interface
   fields.

4. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3`.
   This is the first direct dependency for the pre-audit wrapper.

5. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3`.
   This is the second direct dependency for the pre-audit wrapper.

6. `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.
   Use this as the guard rejecting the generic
   `projectionSummationStatement` route.

7. `oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript`.
   Use this to keep the backend sparse-summand illness area explicit.

8. Planned:
   `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`.
   This should be a wrapper theorem only; it should not add definitions,
   assumptions, semantic flags, or root closure.

## Failure Analysis

The current target is mathematically valid as a pre-audit wrapper, but it is
not strong enough to prove the source theorem.  The blocked step is not the
normalizer algebra: that path is already compiled under explicit hypotheses.
The blocked step is the finite backend projection/summation theorem demanded
by Definition `def:block-encoding`.

The generic route through
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`
is not allowed.  It is refuted by
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.
The route through
`oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3` is also
not a closure route, because it assumes
`backendExpansionStatement` as an input.

The next real theorem after the pre-audit wrapper should be a backend-sourced
sparse-summand interface: a `branchContribution : Fin 7 -> Coeff` computed
from the actual `BlockExtractionTarget`/finite projection backend for the
focused signal-zero block entry, with selected slot 2 and branch-sum theorems.
Until that interface exists, `oneTermRobinGamma3ProductToCoefficientObligation
3 0 0` must remain unassigned to lower2 and `proved = false`.

## Handoff

Leaf: `fixed_product_to_coefficient_pre_audit`.  
Error class: `symbolic_bridge_gap`.  
Next route: lower2 should compile exactly
`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3` as a
non-promoting wrapper using the two compiled bridge declarations and
`BackendGap`; lower3 should then verify that `BackendGap` remains active and
that the generic projection/backend expansion routes remain rejected.

No Lean edit was made in this lower1 pass.

Gate status: `python3 tools/qbe.py check` passed, and explicit
`lake build && lake build Tests` passed.  The only warnings were the known two
`QuantumBlockEncoding/RobinMatrix.lean` diagnostic `sorry` warnings.
