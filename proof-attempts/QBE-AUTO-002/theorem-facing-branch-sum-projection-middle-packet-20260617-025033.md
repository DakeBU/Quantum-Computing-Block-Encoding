# Theorem-Facing Branch-Sum Projection Packet

Task: `QBE-AUTO-002`  
Run: `20260617-024407-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `paperBenchmark`  
Prepared: `2026-06-17 02:50 JST`

## Source Object

The source object remains GHL2025 Theorem `theorem: 1 term robin`, the
one-term Robin block-encoding theorem treated as Theorem 3 for this run.  The
source anchors are Eq. `eq: arbitrary sparcity`, Eq. `eq:angles for Ry`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

The focused branch remains the boundary gamma3 branch for system entry `(0,0)`,
sparse slot `2`, signal block `[0,0]`, branch basis `[32,32]`, and normalizer
$N_D N_f \kappa$.  The just-compiled prepared projection contract is route
memory.  The next proof obligation is the finite projection/summation theorem
that expands the signal-zero block entry as the sparse-slot branch sum.

## Definitions

`PreparedProjectionContract(H, env)` is the compiled theorem:

```lean
oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3 H env
```

`BackendBranchTarget` is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3
```

`BranchContributionFamily` is:

```lean
oneTermRobinGamma3BoundaryBranchContributionFamily_n3
```

The preferred Lean theorem name for the family-level branch sum is:

```lean
oneTermRobinGamma3BoundaryBranchContribution_sum_n3
```

The equivalent generic target surface is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
```

The fixed root theorem remains blocked:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

## Source-Dependency Classification

| Missing or tempting ingredient | Classification | Decision |
|---|---|---|
| Signal-zero block entry equals the seven sparse-slot branch fold | `internal-paper-step` plus QBE-local finite projection/summation lemma | active proof-DAG leaf after lower1/lower3 checks |
| Unchanged raw backend expansion | finite no-go guard for the old H-free route | do not assign `backendExpansionStatement` directly as the lower2 target |
| Prepared projection entry equals slot-`2` projected branch product | QBE-local interface theorem | compiled route memory via `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` |
| `H_W^(kappa)` clean-column behavior | external cited contract | keep as explicit contract through `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| Final product-to-coefficient theorem | theorem-facing coefficient and normalized-block closure | still blocked; do not assign lower2 directly |

No new cited-result row is needed for this packet.  The branch-sum theorem is
local finite matrix semantics tied to Definition `def:block-encoding` and Eq.
`eq: ROBIN clarified`.

## Proof Translation Map

| Paper step | Lean object | Status |
|---|---|---|
| Definition `def:block-encoding` selects the clean signal block entry for system entry `(0,0)`. | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry` and `BackendBranchTarget.blockEntry` | typed |
| Eq. `eq: ROBIN clarified` sums boundary gamma3 branches over sparse slots and the focused example uses slot `2`. | `oneTermRobinGamma3BoundaryBranchContributionFocusedSlot`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | selected slot compiled |
| The prepared projection contract identifies the source-prepared clean entry with the slot-`2` projected branch product. | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` | compiled non-promoting route memory |
| The signal-zero block entry must equal the seven-slot backend branch fold. | `oneTermRobinGamma3BoundaryBranchContribution_sum_n3` or `BackendBranchTarget.projectionSummationStatement` | absent |
| The fixed product/coefficient theorem consumes the branch-sum bridge and normalizer route. | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | blocked |

## Current DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `prepared_projection_contract_leaf` | theorem-facing prepared projection entry equals focused slot-`2` projected branch product while false flags remain false | source-prepared projection target, slot-`2` product bridge, theorem-facing interface | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` | previous prepared-projection packet | previous gate | compiled route memory |
| `raw_backend_expansion_no_go` | unchanged active backend expansion route is refuted | all-one finite diagnostic and no-go theorem | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | verifier feedback | previous gate | forbidden route |
| `branch_sum_projection_leaf` | prove the signal-zero block entry equals the seven-slot backend branch fold | backend branch family, selected-slot theorem, block-extraction target, source branch map | lower1, lower3, then lower2 | planned `oneTermRobinGamma3BoundaryBranchContribution_sum_n3`; equivalent `BackendBranchTarget.projectionSummationStatement` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active frontier |
| `fixed_product_to_coefficient` | focused coefficient/product equality for `(n,i,j) = (3,0,0)` | branch-sum projection leaf, prepared projection contract, compiled normalizer bridge | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate plus proof-map sync | blocked |
| `post_baseline_candidate_population` | candidates for the same operator scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | GHL baseline root closed first | later middle | no active Lean target | task directive | not run | deferred |
| `fallback_optctrl_operator` | OPTCTRL rank-one time/type partial-isometry operator tensored with `I_n` | baseline closure plus stagnation in improvement search | later middle | planned `QuantumBlockEncoding/OptimalControl.lean` | `tasks/QBE-OP-OPTCTRL-001.md` | not run | deferred |

## Lower-Agent Split

| Lower role | Packet | Write scope | Acceptance |
|---|---|---|---|
| lower1 proof architect | Write a source-backed branch-sum proof map.  It must explain which source line supplies the sparse-slot fold, which Lean theorem supplies the selected slot, and why the old raw `backendExpansionStatement` route is not the target. | Markdown note under `proof-attempts/QBE-AUTO-002/` | `source_correspondence_ok=true` for the branch-sum projection leaf, or a precise source-contract gap |
| lower2 Lean worker | Prove exactly one active leaf: preferably `oneTermRobinGamma3BoundaryBranchContribution_sum_n3`, or the equivalent `BackendBranchTarget.projectionSummationStatement`.  If the target is blocked by the no-go guard, add only a smaller typed obstruction naming the missing projection-backend field. | Prefer `QuantumBlockEncoding/RobinMatrix.lean`; edit `QuantumBlockEncoding/CircuitSemantics.lean` only for the smallest reusable branch-summation interface | `python3 tools/qbe.py check`; `lake build`; `lake build Tests`; no product, block, oracle, unitarity, resource, or final-extraction flag promoted |
| lower3 verifier | Check finite branch-sum necessary conditions before lower2 spends tactic effort: branch slot `2`, branch basis `[32,32]`, signal block `[0,0]`, selected-slot theorem, no-go guard for unchanged backend expansion, and false theorem flags. | `verifier-feedback/QBE-AUTO-002/` | typed feedback for `leaf=theorem_facing_branch_sum_projection_leaf` |

## Lower2 Lean Contract

The preferred theorem surface is:

```lean
theorem oneTermRobinGamma3BoundaryBranchContribution_sum_n3 :
    oneTermRobinGamma3BoundaryBranchContributionFamily_n3.projectionSummationStatement := by
  -- prove the finite projection/summation theorem, or reduce to the generic
  -- backend branch target through an already compiled bridge.
```

The equivalent generic target is:

```lean
theorem oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_n3 :
    oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement := by
  -- do not prove the old raw backendExpansionStatement directly unless
  -- lower1/lower3 confirm that the target is not the refuted unchanged route.
```

Acceptable fallback:

```lean
-- a smaller typed obstruction record naming the missing finite
-- projection-backend branch-summation field for one signal block entry
```

Lower2 must not prove or assume:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

## Deferred Ledgers

The post-baseline improvement population remains deferred until the GHL
baseline root closes.  The fallback `QBE-OP-OPTCTRL-001` operator contract
remains deferred.  No candidate score is recorded in this packet because no
improved candidate is Lean-checked.
