# Theorem-Facing Branch-Sum Projection Lower1 DAG

Task: `QBE-AUTO-002`  
Run: `20260617-024407-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `paperBenchmark`  
Leaf checked: `theorem_facing_branch_sum_projection_leaf`  
Verdict: do not release the current generic branch-sum target to lower2.

## 1. Source Fragment

The source theorem is GHL2025 Theorem `theorem: 1 term robin`.  The local
proof fragment used here is the boundary $\gamma_3$ line of Eq.
`eq: ROBIN clarified`, together with Eq. `eq: arbitrary sparcity`, Eq.
`eq:angles for Ry`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

For the focused witness, the paper-side branch is the boundary $\gamma_3$
clean branch for system entry $(0,0)$, sparse slot $s=2$, branch basis index
$32$, and normalizer $N_D N_f \kappa$.  Definition `def:block-encoding`
selects a clean signal block entry.  Eq. `eq: ROBIN clarified` describes the
prepared clean boundary branch after the sparse-preparation layer, not the
raw active seven-gate entry by itself.

## 2. Definitions Before Claims

`SignalBlockEntry` is
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry`.

`BackendBranch(s)` is
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s`.

`BackendFold` is
`blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

`PreparedEntry(H, env)` is
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.

`CurrentGenericProjection` is
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`.

## 3. Natural-Language Proof and Route Check

The source-backed local theorem that follows from the paper fragment is the
prepared projection route.  Under the explicit all-slot clean-column contract
for $H_W^{(\kappa)}$, `PreparedEntry(H, env)` evaluates to `BackendFold`.
The boundary-entry convention for slot $2$ then identifies `BackendFold` with
the focused projected branch product.  This is already compiled as
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.

The current middle packet also names `CurrentGenericProjection`, equivalently
`BlockExtractionBranchContributionTarget.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3`, as a possible
lower2 target.  That target is not source-correct as a theorem to prove.  In
`CircuitSemantics`, `projectionSummationStatement` is equivalent to
`backendExpansionStatement` for the same target.  RobinMatrix already proves
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`, using
the no-go guard
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.  Therefore a
Lean worker cannot prove the proposed generic branch-sum statement without
contradicting the existing finite diagnostic.

The mismatch is structural.  The paper branch is a prepared clean projection
coming through $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$.  The rejected target
asks for an H-free raw active projection over the active seven-gate backend.
The theorem-facing audit also records that the Fig. `fig:1 term ROBIN`
theorem-facing circuit and the active backend circuit are distinct.

## 4. Proof-DAG Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `source_theorem_1_term_robin` | GHL2025 Theorem `theorem: 1 term robin` | source anchor | upper/middle | keep as root baseline |
| `source_gamma3_prepared_branch` | Eq. `eq: ROBIN clarified`, Eq. `eq: arbitrary sparcity`, Eq. `eq:angles for Ry` | source-backed | lower1 | use prepared clean projection, not raw active entry |
| `prepared_projection_backend_eval` | source-prepared target, $H_W^{(\kappa)}$ clean-column contract | compiled conditional | none | reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` |
| `prepared_projection_slot2_product` | prepared backend eval, slot-`2` boundary-entry convention | compiled conditional | none | reuse `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` |
| `current_generic_projection_target` | backend branch target, generic projection/backend equivalence | refuted | none | do not assign to lower2 |
| `branch_sum_projection_leaf` | current middle packet | contract drift if interpreted as `CurrentGenericProjection` | middle/reviewer | retire or restate before Lean work |
| `corrected_finite_block_projection_contract` | source-prepared projection route, finite block-contract audit | active correction obligation | middle, then lower2 | state a corrected Prop selecting `PreparedEntry(H, env)` as theorem-facing projection entry |
| `fixed_product_to_coefficient` | corrected projection contract, normalizer bridge, finite block contract | blocked | later lower2 | do not attack yet |

## 5. Intermediate Lean Lemmas to Reuse

1. `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`:
   proves that the current generic projection-summation target is false.
2. `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`:
   finite no-go guard for the unchanged H-free backend expansion route.
3. `BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement`:
   explains why the generic projection target inherits the no-go.
4. `oneTermRobinGamma3BoundaryBackendProjectionStatement_equivBranchSum_n3`:
   identifies the generic projection statement with the focused H-free branch
   sum, only as a bridge.
5. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`:
   compiled source-prepared evaluation bridge under the clean-column contract.
6. `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`:
   compiled backend-fold to focused projected-branch product evaluator.
7. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`:
   compiled composite source-prepared projection route.
8. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript`:
   audit record showing the corrected finite block/projection equality is still
   false and must be stated precisely before theorem closure.

The next Lean worker should not add a theorem named
`oneTermRobinGamma3BoundaryBranchContribution_sum_n3` if its statement is
`CurrentGenericProjection`.  A safe Lean leaf would be a smaller non-promoting
obstruction or a corrected theorem-facing projection interface after middle
defines the precise Prop.

## 6. Failure Analysis

The current target is mathematically wrong as a lower2 theorem when it means
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`.
The existing Lean theorem
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` refutes
that target.  The primary `error_class` is `finite_matrix_counterexample`;
the secondary issue is `source_translation_gap`, because the paper line being
translated is the source-prepared clean branch, not the H-free active backend
entry.

Next route: middle should restate the active leaf as a corrected theorem-facing
finite block/projection contract whose left-hand side is the prepared clean
projection entry already exposed by
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`.
Only after that Prop is named should lower2 attempt one Lean leaf.  Until then,
lower2 should either leave Lean unchanged or compile a no-go/transcript theorem
that records the current branch-sum target as forbidden.
