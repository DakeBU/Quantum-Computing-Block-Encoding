# Prepared-Circuit Contract Correction Lower1 DAG

Task: `QBE-AUTO-002`
Run: `20260617-042830-QBE-AUTO-002-cycle01`
Mode: `paperBenchmark`
Leaf: `prepared_circuit_contract_correction`
Role: lower natural-language proof architect

## Source Fragment

The literal source archive path `outer_papers/quantum/GHL2025/main.tex` is not
present in this checkout.  The synchronized source map and paper notes identify
the active anchors as GHL2025 Theorem `1 term robin` at `main.tex:1098-1109`,
the clarified Robin coefficient equation at `main.tex:1111-1119`, Fig.
`1 term ROBIN` at `main.tex:1122-1164`, the sparse preparation equation
`eq:arbitrary sparcity`, and Definition `def:block-encoding` at
`main.tex:2027-2035`.

The proof fragment being translated is the theorem-facing block extraction
route:

$$
(\langle 0^a| \otimes I) U (|0^a\rangle \otimes I)
  = A_k /(N_D N_f \kappa).
$$

For this leaf, only the source-selection step is active.  Fig.
`1 term ROBIN` acts on the sparse-prepared sandwich
$H_W^{(\kappa)\dagger} U_{\gamma_3,\mathrm{bdry}} H_W^{(\kappa)}$, not on the
active seven-gate backend alone.  Lean records this with:

```lean
GHL2025.oneTermRobinTheoremFacingFig4Circuit
GHL2025.oneTermRobinCircuit
oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3
```

The target must expose the prepared singleton clean entry through
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env`
while keeping `oneTermRobinFiniteBlockCompositionContract 3` wired to
`oneTermRobinCircuitSemantics 3`.

## Definitions

Let `Fig4Circuit` be `GHL2025.oneTermRobinTheoremFacingFig4Circuit`, the
ten-gate theorem-facing transcript containing both `H_W^(kappa)` sides.

Let `ActiveCircuit` be `GHL2025.oneTermRobinCircuit`, the seven-gate active
backend component used by `oneTermRobinCircuitSemantics 3`.

For fixed `H : Matrix 8 8 Coeff` and environment `env : String -> Rat`, define
`Prepared(H)` as:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H
```

Let `clean` be `oneTermRobinGamma3BoundarySparseCleanIndex_n3`.

Let `SourceTarget(H, env)` be:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

Let `Interface(H, env)` be:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

Let `Gap(H)` be:

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H
```

## Local Theorem

The active lower2 theorem should be the non-promoting wrapper:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3
```

It should prove, by unfolding records and using the transcript guards, that:

```lean
Interface(H, env).sourcePreparedProjectionTarget = SourceTarget(H, env)
Interface(H, env).sourcePreparedProjectionEntry = Prepared(H).matrix clean clean
SourceTarget(H, env).preparedSemantics = Prepared(H)
SourceTarget(H, env).preparedProjectionEntry = Prepared(H).matrix clean clean
Interface(H, env).contractClaimSemantics = oneTermRobinCircuitSemantics 3
Interface(H, env).contractUsesActiveBackendSemantics = true
Interface(H, env).theoremFacingCircuit != Interface(H, env).activeBackendCircuit
Gap(H).rawEntryContractProved = true
Gap(H).sparsePreparationAbsenceProved = true
Gap(H).preparedCircuitEntryEqualityProved = false
```

It must also restate that the active/prepared entry equality, corrected finite
block projection equality, fixed product obligation, normalized block equality,
LCU, block projection, block correctness, final extraction, oracle correctness,
unitarity, resource, and product-to-coefficient flags remain false.

## Natural-Language Proof

First unfold `Interface(H, env)`.  By definition, its
`sourcePreparedProjectionTarget` field is `SourceTarget(H, env)`, its
`sourcePreparedProjectionEntry` field is
`SourceTarget(H, env).preparedProjectionEntry`, and its finite block contract is
`oneTermRobinFiniteBlockCompositionContract 3`.

Next unfold `SourceTarget(H, env)`.  Its `preparedSemantics` field is
`Prepared(H)`, its `cleanIndex` is `clean`, and its
`preparedProjectionEntry` field is `Prepared(H).matrix clean clean`.  This
gives the prepared singleton entry selected by the theorem-facing projection.

Then unfold the finite block contract audit inside the interface.  The audit
sets `contractClaimSemantics` to `oneTermRobinCircuitSemantics 3` and records
that the finite block contract still consumes the active seven-gate backend.
This preserves the current finite block contract instead of substituting the
ten-gate Fig. 4 transcript into it.

The circuit mismatch is a finite transcript fact.  Unfold
`GHL2025.oneTermRobinTheoremFacingFig4Circuit` and
`GHL2025.oneTermRobinCircuit`; the first list has the two sparse-preparation
side gates and explicit source cleanup slots, while the second list is the
seven-gate backend component.  Lean can close the inequality with
`native_decide`, as in
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript`.

Finally unfold `Gap(H)`.  Its `rawEntryContractProved` and
`sparsePreparationAbsenceProved` flags are true because the compiled lemmas
`oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3` and
`oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` are recorded by
`oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H`.
The same record explicitly keeps `preparedCircuitEntryEqualityProved = false`.
All downstream theorem-facing flags are definitionally false in the interface,
so the wrapper closes them by `rfl`.

This proof does not establish
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`.
It only exposes the source-prepared clean entry and prevents future proof
steps from treating the raw H-free seven-gate entry as the full Fig. 4 block
entry.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 has the prepared source gates | source map `FigRobin`; no Lean hypotheses | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | Fig. 4 visual audit | previous gate | compiled |
| `active_backend_guard` | active backend is the seven-gate component | source map `FigRobin`; backend contract | none | `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | Fig. 4 visual audit | previous gate | compiled |
| `sparse_preparation_absence_guard` | active backend omits both `H_W^(kappa)` sides | active backend guard | none | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | prepared-circuit gap notes | previous gate | compiled |
| `prepared_singleton_semantics` | prepared singleton semantics exists and has clean entry | prepared sparse matrix interface | none | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3`; `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3` | source-prepared projection notes | previous gate | compiled |
| `source_prepared_projection_target` | selected theorem-facing entry is the prepared clean entry | prepared singleton semantics | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`; transcript theorem | conversion window source-prepared target | previous gate | compiled |
| `theorem_facing_projection_interface` | attach source-prepared target to active finite block contract | source target; finite block audit | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`; transcript theorem | proof obligations 2026-06-17 | previous gate | compiled |
| `prepared_circuit_contract_correction` | expose prepared clean entry through theorem-facing interface and keep false flags | all nodes above | lower2 | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3` | this file and middle packet 04:34 | `python3 tools/qbe.py check` | next active Lean leaf |
| `active_prepared_selected_entry_composition` | prove active signal-zero entry equals prepared singleton clean entry after evaluation | correction wrapper; finite composition semantics | later lower2/refiner | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` or uncast equivalent | source-prepared active field ledgers | not run | blocked internal |
| `fixed_product_to_coefficient_3_0_0` | close focused root product-to-coefficient obligation | active/prepared composition; branch bridge; finite normalizer bridge | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | root proof-obligation ledger | not run | blocked |

The next active leaf for the Lean worker is
`prepared_circuit_contract_correction`.  After that wrapper compiles, the next
mathematical leaf is `active_prepared_selected_entry_composition`, not the root
product theorem.

## Ordered Lean Lemmas To Reuse

1. `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`
2. `GHL2025.oneTermRobinActiveBackendCircuit_gateList`
3. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`
4. `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3`
5. `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H`
6. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3 H env`
7. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript H env`
8. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript H env`
9. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript H env`

The intended proof script should introduce a local `hdistinct` for
`Fig4Circuit != ActiveCircuit`, unfold the interface, source target, gap, and
finite block contract records, and then close the conjunction by repeated
`constructor`, `exact hdistinct`, and `rfl`.

## Failure Analysis

The current target is mathematically appropriate as a wrapper.  It is not a
proof of the paper's block-encoding theorem and should not be used as closure
of `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

The invalid route remains any theorem that treats
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
or `.projectionSummationStatement` as the source-facing Fig. 4 block entry.
Those routes are guarded by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` and
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.

The real remaining mathematical gap after this wrapper is the active/prepared
selected-entry composition theorem.  A Lean proof that tries to close it by
`rfl` after unfolding the active seven-gate backend would be a
`shape_or_register_gap`, because the source theorem includes the sparse
preparation sides.

No new external cited result is needed for this wrapper.  The existing
`H_W^(kappa)` clean-column contract remains contract-only and is not promoted.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `prepared_circuit_contract_correction` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` for the current tree before Lean edits |
| `lean_build_ok` | `pending gate at end of lower1 run` |
| `finite_matrix_ok` | `true` for exposing the typed prepared singleton clean entry; not a proof of active/prepared equality |
| `block_entry_ok` | `true` only for `interface.sourcePreparedProjectionEntry = Prepared(H).matrix clean clean` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `null` |
| `unitarity_ok` | `null` |
| `closed_theorem_ok` | `false`; this lower1 artifact adds no Lean theorem |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `lower2 should compile the non-promoting wrapper, then route to active_prepared_selected_entry_composition` |
