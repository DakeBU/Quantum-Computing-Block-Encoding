# QBE-AUTO-002 Prepared Signal-Entry Source DAG

Date: 2026-06-09
Role: lower 1, natural-language proof architect
Mode: faithfulPaper
Lean edit status: no Lean edits

## 1. Source Fragment Being Translated

This packet translates the source route for the repaired theorem-facing
prepared signal entry.  Local TeX line numbers are working anchors for the
bundled GHL2025 source.

| Source anchor | Paper fragment | Translation role |
|---|---|---|
| `main.tex:948-955` | Eq. `arbitrary sparcity`: $H_W^{(\kappa)}\ket{0}=\kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$, with Shukla--Vedula cited for implementation cost. | External clean-column contract for both sparse-register boundary gates. |
| `main.tex:1098-1109` | Theorem `1 term robin`: an $(\mathcal{N}_D\mathcal{N}_f\kappa,\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of $A_k$. | Root theorem target; still not closed. |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`: the clean boundary part of $\gamma_3$ has coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and is summed over sparse slots. | Branch-correct backend fold; the focused displayed slot is `2`, with full basis index `[32,32]`. |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`: theorem-facing order includes the two $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}$, and post-SWAP $(O_D^{BS})^\dagger`. | Transcript guard; the active seven-gate backend is only the inner finite product. |
| `main.tex:2027-2035` | Definition `def:block-encoding`: the clean signal block is projected after pure-ancilla cleanup. | Prepared projection field selected by Lean. |

The exact local proof fragment now being translated is not the raw active
seven-gate entry.  It is the prepared clean-clean entry of
$H_W^{(\kappa)\dagger} U_{\gamma_3} H_W^{(\kappa)}$ and its evaluation as the
seven-slot backend fold.

## 2. Definitions Before Claims

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`.

Let `hUniform` denote
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.  This
is the typed Lean contract for Eq. `arbitrary sparcity`; it is not a
formalized Shukla--Vedula circuit proof.

Let `Target(H, env)` be
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.

Let `PreparedEntry(H, env)` be
`(Target(H, env)).preparedProjectionEntry`.  By
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`, this
is
`(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix`
at the sparse clean-clean index.

Let `BackendFold` be `(Target(H, env)).backendBranchFold`, equivalently
`blockExtractionBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

Let `SlotIndex(s)` be
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s`.  The compiled theorem
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` maps source slot
`2` to full basis index `[32,32]`.

Let `Active00` be the uncast active seven-gate entry
`evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders
(oneTermParameters 3))[0,0]`.  The mismatch witness
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`
shows that this is still the current active side when the wrong field is
selected.

## 3. Natural-Language Proof Of The Active Local Theorem

The source-correct local theorem is:

```text
For fixed H and env, hUniform implies
  eval(PreparedEntry(H, env)) = eval(BackendFold).
The displayed slot-2 gamma3 term is the s = 2 summand of BackendFold.
```

Proof:

1. Eq. `arbitrary sparcity` gives the clean-column amplitude
   $\kappa^{-1/2}$ for each sparse slot on the ket side.  The theorem-facing
   transcript also contains the adjoint sparse-preparation side, so the bra
   contributes the matching clean-column factor.  In Lean this is the external
   contract `hUniform`, together with the already compiled prepared-sandwich
   interfaces.

2. The prepared clean-clean entry of
   $H_W^{(\kappa)\dagger} U_{\gamma_3} H_W^{(\kappa)}$ expands as the sum over
   sparse slots of the inner seven-gate branch entry
   `U_gamma3[SlotIndex(s), SlotIndex(s)]` multiplied by the two
   sparse-preparation amplitudes.  Lean names this family
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

3. The displayed source branch chosen by the current finite example is slot
   `2`.  The compiled index bridge maps that branch to `[32,32]`, and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` identifies
   the selected summand.  This proves where the displayed gamma3 term enters
   the backend fold; it does not reduce the all-slot fold to only slot `2`.

4. The all-slot prepared entry reaches the backend fold by the compiled
   evaluator bridge
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
   H env hUniform`.  The same route is exposed at the product-map layer by
   `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3`.

5. Definition `def:block-encoding` justifies selecting the clean prepared
   projection entry as the theorem-facing signal entry.  It does not justify
   replacing this entry with `Active00` unless QBE proves a separate finite
   composition theorem connecting the active seven-gate signal entry to the
   prepared singleton entry.

Therefore the branch-correct route is:

```text
Eq. arbitrary sparcity
  -> prepared clean-clean entry of H_W^dagger * U_gamma3 * H_W
  -> backend seven-slot fold
  -> selected slot-2 summand at [32,32] for the displayed gamma3 term
  -> fixed product-to-coefficient obligation.
```

The route is not:

```text
active seven-gate [0,0]
  -> column-0 slot-0 diagnostic
  -> displayed slot-2 branch.
```

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Class | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|---|
| `fig4_transcript_guards` | The theorem-facing transcript exposes $H_W^{(\kappa)}$, `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, post-SWAP $(O_D^{BS})^\dagger`, and cleanup. | `main.tex:1122-1164`; indicator self-inverse bridge. | GHL-internal transcript plus QBE-local bridge | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`, `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | proved |
| `active_backend_guard` | The active backend remains the seven-gate product and is not the full theorem-facing Fig. 4 circuit. | existing active circuit list | QBE-local transcript guard | middle | `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | conversion window | `python3 tools/qbe.py check` | proved |
| `hw_clean_column_contract` | $H_W^{(\kappa)}$ clean column supplies uniform amplitude on all seven slots. | `main.tex:948-955`; Shukla--Vedula citation. | external-cited-contract | external | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger | no recursive proof this batch | contract-only |
| `slot2_full_basis_path` | The displayed source slot `2` maps to full basis index `[32,32]`. | Eq. `ROBIN clarified`; branch index map. | GHL-internal branch plus QBE-local index bridge | lower | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `slot2_selected_summand` | The slot-`2` branch is the selected summand of the backend branch family. | `slot2_full_basis_path`; all-slot branch family. | QBE-local semantic bridge | lower | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `prepared_signal_entry_lhs` | The theorem-facing prepared signal entry is `Target(H, env).preparedProjectionEntry`, the clean-clean entry of the prepared singleton semantics. | block-encoding definition; prepared composite semantics. | QBE-local semantic bridge | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`, `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript` | conversion window; this packet | `python3 tools/qbe.py check` | compiled |
| `prepared_entry_backend_fold_eval` | Under `hUniform`, `eval(PreparedEntry) = eval(BackendFold)`. | `hw_clean_column_contract`; prepared sandwich fold. | QBE-local bridge using external contract | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` | this packet | `python3 tools/qbe.py check` | proved conditional |
| `prepared_entry_product_map` | The prepared-entry backend equality is wired to the fixed product obligation without promoting product, LCU, block, or final flags. | `prepared_entry_backend_fold_eval`; fixed product-map record. | QBE-local semantic bridge | lower/middle | `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3` | this packet | `python3 tools/qbe.py check` | proved conditional |
| `active_eval_exposes_uncast_seven_gate` | The old active field still exposes the seven-gate `[0,0]` entry while both `H_W` sides are absent. | active/prepared reduction; sparse-preparation absence guard. | QBE-local mismatch witness | lower 2 | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3` | `proof-attempts/QBE-AUTO-002/active-seven-gate-prepared-mismatch-20260609-lower2.md` | `python3 tools/qbe.py check` | proved mismatch witness |
| `finite_active_to_prepared_composition` | If a theorem still uses the active seven-gate signal entry on the left, prove a separate finite composition theorem before replacing it by the prepared entry. | prepared target; active backend guard. | QBE-local finite matrix/projection field | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`, `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`, or `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof-obligations ledger | `python3 tools/qbe.py check` | open; do not assume |
| `column0_slot0_diagnostic` | Active seven-gate `[0,0]` expands through slot-`0` factors. | prefix/suffix support lemmas. | QBE-local diagnostic | none | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | proof-obligations ledger | none | proved diagnostic; retired |
| `raw_coeff_fold_route` | Raw H-free constructor equality for symbolic `Coeff`. | old associativity route. | stale diagnostic | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

Next active leaf for a Lean worker:
reuse or expose the prepared-entry route, not the active seven-gate route.  If
the downstream statement does not already consume
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`,
add a small target-shape theorem that does.  If the left side remains
`Active00`, leave `finite_active_to_prepared_composition` as the open
obligation unless a genuine finite composition theorem is proved.

## 5. Ordered Intermediate Lean Lemmas To Reuse

1. Transcript guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`, and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`.

2. Sparse-preparation contracts:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   and
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

3. Slot-index and branch-family lemmas:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, and
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`.

4. Repaired prepared signal-entry target:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

5. Product-map route wiring:
   `oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3`,
   `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_preparedProjectionBackendEval_n3`,
   `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3`, and
   `oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3`.

6. Active/prepared obstruction interfaces:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3`, and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

7. Diagnostics only:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, and
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.
   These must not be used as the source proof of the slot-`2` prepared entry.

## 6. Failure Analysis

The current active/prepared equality is mathematically unsupported if its left
side is read as the active seven-gate `[0,0]` entry.  The latest compiled
mismatch witness proves that this active side omits both sparse-preparation
boundary gates, while Eq. `arbitrary sparcity` is exactly where the source
obtains the all-slot factor contributing the denominator `kappa`.

The column-`0` diagnostic expands `Active00` through slot-`0` symbols.  The
displayed gamma3 branch selected in this finite proof map is slot `2`, mapped
to `[32,32]`.  Therefore a proof that uses the slot-`0` diagnostic to close
the slot-`2` source branch is a branch mismatch, not progress.

The source-correct prepared-entry backend bridge is already compiled under the
external `H_W` clean-column contract.  The remaining open theorem is QBE-local:
either expose the prepared entry as the theorem-facing left side in every
downstream target, or prove a separate finite composition theorem explaining
why the active seven-gate signal entry can be replaced by the prepared
singleton entry.  No new Shukla--Vedula, Gilyen/LCU, sparse-oracle,
function-oracle, or block-projection result is needed for this packet.

The raw symbolic `Coeff` route remains diagnostic/backlog.  It is stronger
than the source-correct evaluator bridge and is blocked by constructor-level
matrix associativity rather than by the source paper.

## 7. Handoff

Lower 1 mapped the source slot-`2` gamma3 branch to the repaired
`preparedProjectionEntry` route.  No Lean files were edited.  The next Lean
worker should use
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`
and the product-map route wiring if the target consumes the prepared entry.
If the target still exposes active seven-gate `[0,0]`, the worker should keep
or prove the separate finite active-to-prepared composition obligation instead
of substituting the retired slot-`0` diagnostic.
