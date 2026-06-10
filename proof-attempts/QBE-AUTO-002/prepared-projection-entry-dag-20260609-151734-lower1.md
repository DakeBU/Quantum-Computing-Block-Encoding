# QBE-AUTO-002 Prepared Projection Entry Proof DAG

Date: 2026-06-09
Run: `20260609-151734-QBE-AUTO-002-cycle01`
Role: lower 1, natural-language proof architect
Mode: faithfulPaper
Lean edit status: no Lean edits

## 1. Source Fragment

This packet translates the theorem-facing one-term Robin route from the local
GHL2025 source into a Lean proof DAG.  Public references should use the
paper anchors below, not the local machine path.

| Source line | Paper fragment being translated | Lean role | Dependency class |
|---|---|---|---|
| `main.tex:948-955` | Eq. `arbitrary sparcity`: $H_W^{(\kappa)}\ket{0}^{\lceil \log_2 \kappa \rceil} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}^{\lceil \log_2 \kappa \rceil}$, with Shukla--Vedula cited for the $O(\log \kappa)$ implementation. | Contract for both theorem-facing sparse-register side gates. | external-cited-contract |
| `main.tex:1098-1109` | Theorem `1 term robin`: an $(\mathcal{N}_D\mathcal{N}_f\kappa,\lceil\log_2 n\rceil+\lceil\log_2G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of $A_k \sim f(x)\partial^m/\partial x^m$. | Root theorem target; not closed by this local packet. | GHL-internal |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`; the displayed $\gamma_3$ boundary branch has coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and is summed over sparse slots. | Source branch map; focused displayed slot is `2`, full basis entry `[32,32]`. | GHL-internal plus QBE-local semantic bridge |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`; the theorem-facing circuit includes the $H_W^{(\kappa)}$ preparation side, `U_indic`, $O_{D^T}^S$, boundary $R_y$, pre-SWAP $O_{D^T}^{BS}$, $O_f$, SWAP, post-SWAP $(O_D^{BS})^\dagger`, `U_indic^\dagger`, and $(H_W^{(\kappa)})^\dagger`. | Transcript guard; the active seven-gate product is only the inner backend, not the whole theorem-facing circuit. | GHL-internal transcript plus QBE-local guard |
| `main.tex:2027-2035` | Definition `def:block-encoding`; after pure-ancilla cleanup, the clean signal block is projected by $(\bra{0}^s \otimes I)$. | Select the prepared clean-clean entry as the theorem-facing projection entry. | QBE-local semantic bridge |

The local equation being translated is the prepared-entry bridge:

```text
evalWith env PreparedEntry(H, env) = evalWith env BackendFold
```

under the explicit clean-column contract `hUniform`.  The currently open
composition field is separate:

```text
evalWith env Active00 = evalWith env PreparedEntry(H, env)
```

or one of its equivalent typed forms.  The source fragment above does not
license replacing `PreparedEntry(H, env)` by the H-free active seven-gate
entry without that finite composition theorem.

## 2. Definitions

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Let `Target(H, env)` be
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.

Let `PreparedEntry(H, env)` be
`(Target(H, env)).preparedProjectionEntry`.  By
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`, this
is the clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`, namely the
prepared sandwich $H_W^{(\kappa)\dagger} U_{\gamma_3} H_W^{(\kappa)}$ at the
sparse clean index.

Let `BackendFold` be `(Target(H, env)).backendBranchFold`, equivalently
`blockExtractionBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

Let `Slot2` be the focused displayed $\gamma_3$ branch.  The compiled index
bridge `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` maps it
to full basis entry `[32,32]`, and
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` identifies
the corresponding summand of `BackendFold`.

Let `Active00` be the H-free active seven-gate entry exposed by
`evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders
(oneTermParameters 3))[0,0]`.  The compiled mismatch witness
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`
records that this active gate list omits both $H_W^{(\kappa)}$ sides.

## 3. Natural-Language Proof

Active local theorem:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
  H env hUniform
```

This theorem states that `Coeff.evalWith env (Target(H, env).preparedProjectionEntry)`
equals `Coeff.evalWith env (Target(H, env).backendBranchFold)`.

Proof design:

1. Eq. `arbitrary sparcity` supplies the all-slot clean-column amplitude for
   $H_W^{(\kappa)}$.  In Lean this is not a circuit proof; it is the explicit
   contract `hUniform`.

2. The theorem-facing Fig. `1 term ROBIN` transcript has both side gates
   $H_W^{(\kappa)}$ and $(H_W^{(\kappa)})^\dagger$.  Therefore the source
   projection entry is the clean-clean entry of the prepared sandwich, not the
   active seven-gate `[0,0]` entry.

3. The prepared clean-clean entry expands over all sparse slots.  The Lean
   backend fold names this expansion as
   `blockExtractionBranchContributionSum
   oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

4. The displayed $\gamma_3$ source equation contributes the slot-`2` summand.
   The compiled bridge maps slot `2` to `[32,32]`.  This identifies the
   displayed term inside the all-slot fold, but it does not collapse the fold
   to one summand.

5. The compiled evaluator
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
   H env hUniform` proves the all-slot prepared clean entry evaluates to the
   backend fold.  The source-prepared target wrapper exposes the same equality
   as
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

6. Definition `def:block-encoding` justifies using the clean prepared
   projection entry as the theorem-facing signal entry after internal
   pure-ancilla cleanup.  It does not prove that `Active00` is equal to this
   prepared entry.  That is the remaining QBE-local finite composition field.

Therefore the source-correct route is:

```text
H_W clean-column contract
  -> prepared clean-clean entry of H_W^dagger * U_gamma3 * H_W
  -> all-slot backend fold
  -> selected slot-2 [32,32] summand inside the fold
  -> fixed product-to-coefficient map under false downstream flags.
```

The rejected route is:

```text
H-free active seven-gate [0,0]
  -> column-0 slot-0 diagnostic
  -> displayed slot-2 gamma3 branch.
```

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Class | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|---|
| `fig4_transcript_guards` | Theorem-facing gate labels include both $H_W^{(\kappa)}$ sides, `U_indic^\dagger`, pre-SWAP $O_{D^T}^{BS}$, post-SWAP $(O_D^{BS})^\dagger`, and cleanup. | `main.tex:1122-1164`; indicator self-inverse bridge. | GHL-internal transcript plus QBE-local bridge | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | proved transcript |
| `active_backend_guard` | Active backend is only the seven-gate inner product and omits both $H_W^{(\kappa)}$ side gates. | active backend circuit list. | QBE-local transcript guard | middle/lower 2 | `GHL2025.oneTermRobinActiveBackendCircuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | conversion window; mismatch note | `python3 tools/qbe.py check` | proved guard |
| `hw_clean_column_contract` | $H_W^{(\kappa)}$ supplies uniform clean-column amplitude over all sparse slots. | `main.tex:948-955`; Shukla--Vedula citation. | external-cited-contract | external | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger; conversion window | no recursive proof this batch | contract-only |
| `slot2_full_basis_path` | The displayed $\gamma_3$ slot `2` maps to full basis entry `[32,32]`. | Eq. `ROBIN clarified`; backend branch index map. | GHL-internal branch plus QBE-local index bridge | lower 1 | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `slot2_selected_summand` | Slot `2` is the selected summand of the backend contribution family. | `slot2_full_basis_path`; branch contribution family. | QBE-local semantic bridge | lower 1 | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `prepared_signal_entry_lhs` | Source route selects `Target(H, env).preparedProjectionEntry`, the clean-clean entry of the prepared sandwich. | block-encoding definition; prepared composite semantics. | QBE-local semantic bridge | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`; transcript theorem | conversion window; this packet | `python3 tools/qbe.py check` | compiled |
| `prepared_entry_backend_fold_eval` | Under `hUniform`, `evalWith env PreparedEntry(H, env) = evalWith env BackendFold`. | `hw_clean_column_contract`; prepared sandwich backend fold. | QBE-local bridge using external contract | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | this packet | `python3 tools/qbe.py check` | proved conditional |
| `prepared_entry_product_map` | Prepared-entry backend equality feeds the fixed product-to-coefficient map while downstream flags remain false. | `prepared_entry_backend_fold_eval`; fixed product-map record. | QBE-local semantic bridge | lower/middle | `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3` | proof-obligation ledger | `python3 tools/qbe.py check` | proved conditional |
| `active_eval_exposes_uncast_seven_gate` | Current active field still exposes H-free `Active00`; both $H_W^{(\kappa)}$ sides are absent. | active/prepared reduction; sparse-preparation absence guard. | QBE-local mismatch witness | lower 2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3` | mismatch note | `python3 tools/qbe.py check` | proved mismatch |
| `finite_active_to_prepared_composition` | Prove the finite theorem replacing `Active00` by `PreparedEntry(H, env)`, or a strictly smaller equivalent field. | prepared target; active backend guard; mismatch witness. | QBE-local finite matrix/composition theorem | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`; `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`; `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | proof-obligation ledger | `python3 tools/qbe.py check` | next active Lean leaf |
| `column0_slot0_diagnostic` | Active seven-gate `[0,0]` expands through slot `0`. | prefix/suffix support lemmas. | QBE-local diagnostic | none | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | diagnostic notes | none | retired |
| `raw_coeff_fold_route` | Raw symbolic constructor equality for H-free fold. | old constructor-equality route. | stale diagnostic | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

Next active leaf for a Lean worker:

```lean
(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement
```

Accepted equivalent smaller leaves are:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The worker should not choose a theorem whose only content is `Active00` slot
`0` equals the slot-`2` source summand.

## 5. Ordered Lean Lemmas To Reuse

1. Transcript guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`, and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`.

2. Sparse-preparation and prepared-sandwich contracts:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`, and
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

3. Slot and branch map:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, and
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`.

4. Source-prepared projection target:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

5. Product-map wiring:
   `oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3`,
   `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_preparedProjectionBackendEval_n3`,
   `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3`, and
   `oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3`.

6. Active-to-prepared target interfaces:
   `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3_transcript`,
   `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_iff_uncast_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_activePreparedCircuitField_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_backendEval_n3`, and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

7. Equivalent finite-composition leaves:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`,
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3`,
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`, and
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_uncastActiveEntryExpandedFold_n3`.

8. Diagnostics only:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, and
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.
   These should remain route guards or backlog items.

## 6. Failure Analysis

The target is mathematically wrong if it claims the full Fig. `1 term ROBIN`
semantics from the active seven-gate `[0,0]` product alone.  The source obtains
the $\kappa^{-1}$ denominator in the displayed $\gamma_3$ branch from the two
$H_W^{(\kappa)}$ sides, and the compiled active backend guard says those gates
are absent from `Active00`.

The target is also wrong if it uses the column-`0` slot-`0` diagnostic to prove
the displayed slot-`2` branch.  Eq. `ROBIN clarified` is summed over sparse
slots, and the focused branch in this packet is slot `2` at `[32,32]`.
Slot `0` diagnostics can help audit the H-free active backend, but they do not
identify the source displayed branch.

The remaining gap is not Shukla--Vedula, `O_D^{BS}`, `O_{D^T}^S`, `O_f`,
boundary $R_y$, LCU, or block-projection formalization.  Those remain
contract-only or unproved as already recorded.  The next Lean work is a
QBE-local finite matrix/composition theorem connecting `Active00` to the
source-prepared clean entry, or a smaller typed obstruction for that exact
field.

## 7. Handoff

Lower 1 refreshed the source-to-Lean DAG for the prepared projection entry.
The exact source-correct compiled bridge is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
H env hUniform`.  The next Lean leaf is
`(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`,
or the equivalent raw prepared-sandwich/active-entry field.  Do not route the
proof through column-`0` diagnostics or raw `Coeff` constructor equality.
