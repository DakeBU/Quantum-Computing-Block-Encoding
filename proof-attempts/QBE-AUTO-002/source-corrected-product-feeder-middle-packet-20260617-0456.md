# Middle Packet: Source-Corrected Product Feeder Retarget

Task: `QBE-AUTO-002`  
Run: `20260617-044631-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `source_corrected_product_feeder`

## Source Contract

The active paper target is still GHL2025 Theorem `theorem: 1 term robin`,
treated in this run as the main one-term Robin block-encoding theorem.  The
fixed branch is the boundary `gamma_3` contribution for system entry `(0,0)`,
sparse slot `2`, source branch basis `[32,32]`, signal block `[0,0]`, and
normalizer `N_D*N_f*kappa`.

The relevant source anchors are Eq. `ROBIN clarified`, Eq. `arbitrary
sparcity`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.  No new external cited result is needed for this packet.
The `H_W^(kappa)` clean-column behavior remains the existing contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

## Current Route Memory

The following Lean declarations are compiled route memory and must not be
reassigned as lower2 targets:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3
oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3
```

The following generic backend routes are forbidden as closure routes:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
```

The all-slot backend summand family is typed, but its generic projection
statement is still the refuted surface.  It is route memory, not theorem
closure:

```lean
oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3
oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3
```

## Source-Dependency Audit

| Missing ingredient | Classification | Next route |
|---|---|---|
| Source-prepared clean entry and finite normalizer feed the fixed product obligation under `hUniform`, `hentry`, `hND`, `hNF`, `hkappa`, and `hkappaSqrt` | internal paper step plus QBE-local coefficient interface | compiled by `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`; stale as lower target |
| Unchanged generic projection/backend expansion statement | invalid route / finite counterexample | keep `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` and do not prove or assume the generic statement |
| Corrected source-shaped projection/product feeder into `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | internal paper step plus QBE-local finite matrix semantics | active lower1/lower3 audit, then one non-promoting lower2 wrapper if the exact Lean statement is source-backed |
| Final product-to-coefficient theorem | theorem-facing coefficient and normalized-block closure | blocked; do not assign directly |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `prepared_circuit_contract_correction` | exposes the prepared singleton clean entry through the theorem-facing finite block interface | source-prepared target and Fig. 4 transcript guard | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3` | prepared-circuit packet and lower2 feedback | previous full gate | compiled; retired |
| `fixed_product_to_coefficient_pre_audit` | packages source-prepared product equality, finite normalizer equality, no-go guard, and false flags | branch bridge; finite normalizer bridge; backend gap transcript | none | `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3` | fixed-product pre-audit packet and lower3 postcompile feedback | previous full gate | compiled; retired |
| `generic_backend_projection_surface` | unchanged backend projection/summation or backend expansion | all-one finite diagnostic and equivalence to old H-free fold | none | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | invalid-route packets | previous full gate | refuted; forbidden |
| `backend_all_slot_summand_formula` | all seven backend summands are typed and selected slot `2` is compiled | branch full-index map; selected slot theorem | none | `oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3`; `oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3` | backend-gap route memory | previous full gate | typed route memory; generic projection remains false |
| `source_corrected_product_feeder` | source-shaped feeder from the prepared projection/product route into the fixed product obligation, without using the refuted generic backend projection statement | `hUniform`, `hentry`, explicit normalizer identities, compiled pre-audit, no-go guards | lower1 and lower3 first; lower2 only after exact statement is confirmed | planned `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3` or a smaller source-backed wrapper | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active source-dependency leaf |
| `fixed_product_to_coefficient_3_0_0` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | corrected feeder plus final finite normalized block/projection equality | later | existing obligation | proof-obligation ledger | not run | blocked |
| `post_baseline_candidate_population` | candidates for the same operator scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | GHL baseline theorem closed first | later middle | none | task directive | not run | deferred |
| `fallback_optctrl_operator` | $E_k := |0><k|_{\rm time} \otimes |0><1|_{\rm type} \otimes I_n$ | baseline closure and improvement stagnation | later middle | planned OPTCTRL task | task directive | not run | deferred |

## Lower 1 Packet

Write a natural-language proof map for `source_corrected_product_feeder`.
The map must list the proof steps in this order:

1. Use Eq. `arbitrary sparcity` only through
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
2. Use Eq. `angles for Ry` through the explicit `hentry` hypothesis for
   `boundary_cos_half_0_2`; do not promote the full rotation convention.
3. Reuse the compiled source-prepared projection/product and finite-normalizer
   equalities from `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`.
4. Explain why the generic backend projection statement is not available:
   `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.
5. Name the smallest corrected source-shaped Lean statement that can feed
   `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` without proving it.

If no source-backed statement can be named, classify the blocker as
`source-contract-gap` and leave lower2 with no Lean edit.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Lower2 may edit only after lower1/lower3 confirm the exact source-backed
statement.  The preferred wrapper name is:

```lean
oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3
```

The wrapper must be non-promoting.  It may reuse
`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`, expose the
fixed obligation identity, keep the generic projection no-go guard, and keep
all product-to-coefficient, normalized-block, LCU, block, oracle, unitary,
resource, and final-extraction flags false.

Lower2 must not prove or assume:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

If lower1/lower3 do not supply a source-backed wrapper statement, lower2 should
make no Lean edit and log `error_class=source_translation_gap`.

## Lower 3 Packet

Run a necessary-condition diagnostic before any lower2 edit:

| Field | Expected value |
|---|---|
| `leaf` | `source_corrected_product_feeder` |
| `source_correspondence_ok` | `true` only if the statement cites Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding` |
| `finite_matrix_ok` | `true` for the source-prepared slot-`2` product and finite normalizer route; `false` for the generic projection statement |
| `block_entry_ok` | `prepared/product feeder only`; do not claim signal block branch-sum closure |
| `normalizer_ok` | `true` only under explicit `hND`, `hNF`, `hkappa`, and `hkappaSqrt` |
| `closed_theorem_ok` | `false` before a lower2 wrapper compiles |
| `error_class` | `symbolic_bridge_gap`; use `source_translation_gap` if no corrected source-shaped statement exists |
| `next_route` | lower2 compiles one non-promoting source-corrected feeder wrapper, or logs no-edit source gap |

Reject any route that revives the generic projection/backend expansion surface,
changes `A`, changes `alpha`, hides an oracle contract, mutates Fig. 4 gate
order, or starts post-baseline candidate search.

## Middle Handoff

Middle handoff: leaf=`source_corrected_product_feeder`;
source_correspondence_ok=true for the source-prepared coefficient route;
generic backend projection remains refuted; next lower work is lower1/lower3
source-shape audit before lower2 edits Lean.  The GHL baseline is not closed,
post-baseline improvement is deferred, and OPTCTRL is deferred.
