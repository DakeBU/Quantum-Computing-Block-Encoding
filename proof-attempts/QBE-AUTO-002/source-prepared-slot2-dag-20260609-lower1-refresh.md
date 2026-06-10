# QBE-AUTO-002 Source-Prepared Slot-2 Proof-DAG Refresh

Date: 2026-06-09
Role: lower 1, natural-language proof architect
Mode: faithfulPaper
Lean edit status: no Lean edits

## 1. Source Fragment Being Translated

This packet translates the theorem-facing one-term Robin route from GHL2025,
using the local TeX line numbers only as working anchors.

| Source anchor | Paper fragment | Translation role |
|---|---|---|
| `main.tex:948-955` | Eq. `arbitrary sparcity`: $H_W^{(\kappa)}|0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle$, with Shukla--Vedula cited for implementation cost. | External clean-column contract for the two $H_W^{(\kappa)}$ sides. |
| `main.tex:1098-1109` | Theorem `1 term robin`: an $(\mathcal{N}_D\mathcal{N}_f\kappa,\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of $A_k$. | Root theorem target; not closed in Lean. |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`: the clean boundary part of $\gamma_3$ is summed over sparse slots $s=0,\ldots,\kappa-1$ and carries coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$. | Branch-correct coefficient target.  The focused Lean slot is $s=2$, full basis index `[32,32]`. |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`: sparse preparation, `U_indic`, derivative or boundary branch operation, pre-SWAP $O_{D^T}^{BS}$, explicit `U_indic^dagger`, $O_f$, SWAP, post-SWAP $(O_D^{BS})^\dagger`, and sparse cleanup. | Theorem-facing transcript.  The active seven-gate backend is only a finite product subobject. |
| `main.tex:2027-2035` | Definition `def:block-encoding`: after internal pure-ancilla cleanup, the clean signal block is projected. | Source-prepared projection target. |

The source proof fragment is a prepared sparse-register proof.  It does not
assert that the raw seven-gate column `0` entry is the whole all-slot prepared
projection.

## 2. Definitions Before Claims

Fix `p = oneTermParameters 3`, an environment `env : String -> Rat`, and a
sparse-preparation matrix `H : Matrix 8 8 Coeff`.

Let `hUniform` denote the existing contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
This is the Lean form of Eq. `arbitrary sparcity`; it is contract-only and is
not a proof of the Shukla--Vedula circuit.

Let `slotIndex s` denote
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s`.  The compiled theorem
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` sends the
focused source slot `2` to full basis index `32`.  The compiled theorem
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3` sends source
slot `0` to full basis index `0`.

Let
`B s = oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s`.  By
definition, `B s` is the seven-gate diagonal entry at `slotIndex s`, multiplied
by the two sparse-register projection amplitudes.

Let `PreparedEntry(H)` be
`(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
clean clean`, where `clean = oneTermRobinGamma3BoundarySparseCleanIndex_n3`.

Let `BackendFold` be
`blockExtractionBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

Let `Active00` be the uncast active seven-gate entry
`(evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders
(oneTermParameters 3))) oneTermRobinGamma3BoundaryPrefixRow0_n3
oneTermRobinGamma3BoundaryPrefixRow0_n3`.

## 3. Natural-Language Proof Of The Active Local Claim

The source-faithful local claim is:

```text
Under hUniform, eval(PreparedEntry(H)) = eval(BackendFold).
The slot-2 displayed gamma3 branch is the s = 2 summand of BackendFold.
```

The proof is:

1. Eq. `arbitrary sparcity` supplies amplitude `sqrt_kappa_inv` for every
   sparse slot on the ket side.  The adjoint $H_W^{(\kappa)\dagger}$ supplies
   the same clean-column amplitude on the bra side.  In Lean these two factors
   are packaged as
   `oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor`.

2. For each `s : Fin 7`, the source branch basis state is
   `slotIndex s`.  The all-slot backend family reads the seven-gate branch
   entry at `[slotIndex s, slotIndex s]` and multiplies by the two projection
   amplitudes.  This is exactly
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s`.

3. The focused displayed branch is `s = 2`.  The compiled map sends it to
   `[32,32]`, and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` identifies
   its summand with the selected slot contribution.  Under the corrected
   boundary-rotation coefficient hypothesis, the conditional lemma
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`
   evaluates that selected summand as the route's projected product.  This is
   a selected-branch fact, not the full projection theorem.

4. The prepared singleton clean entry sums over all seven branches because the
   two $H_W^{(\kappa)}$ sides are present.  The compiled bridge
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`
   proves, after `Coeff.evalWith`, that this prepared entry is `BackendFold`.

5. The active seven-gate column-`0` entry is a different object.  The accepted
   diagnostic theorem
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` expands it using
   slot-`0` half-angle symbols
   `boundary_cos_half_0_0` and `boundary_sin_half_0_0`.  It must not be used as
   evidence for the displayed slot-`2` branch or for the all-slot prepared
   projection.

Therefore the next Lean worker should not try to prove the current theorem by
showing that column `0` is slot `2`.  The source-faithful route is:

```text
source slot 2 [32,32]
  -> selected backend summand B 2
  -> all-slot backend fold BackendFold
  -> prepared singleton clean entry via hUniform
  -> theorem-facing source-prepared projection target.
```

If a target reduces the left side to `Active00`, the worker should first record
a typed mismatch/obligation.  A proof of `Active00 = PreparedEntry(H)` is not
justified by the cited source fragment unless a finite projection/composition
theorem explains why the active seven-gate signal entry already includes the
two $H_W^{(\kappa)}$ sides.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Class | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|---|
| `fig4_theorem_transcript_slots` | The theorem-facing transcript exposes $H_W^{(\kappa)}$, `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, post-SWAP $(O_D^{BS})^\dagger`, and cleanup. | `main.tex:1122-1164`; indicator self-inverse bridge. | GHL-internal transcript plus QBE-local bridge | middle | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`, `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | `conversion-windows/QBE-AUTO-002.md` | `python3 tools/qbe.py check` | proved |
| `active_backend_guard` | The active finite backend is still the seven-gate product and is not the full Fig. transcript. | Existing `oneTermRobinCircuit`. | QBE-local transcript guard | middle | `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | conversion window | `python3 tools/qbe.py check` | proved |
| `hw_clean_column_contract` | $H_W^{(\kappa)}$ clean column has amplitude `sqrt_kappa_inv` on all seven slots. | `main.tex:948-955`; Shukla--Vedula citation. | external-cited-contract | external | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results ledger | no recursive proof this batch | contract-only |
| `slot2_full_basis_path` | Source slot `2` maps to full branch basis index `32`. | Eq. `ROBIN clarified`; branch index map. | GHL-internal branch plus QBE-local index bridge | lower | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `slot0_active_index_audit` | Active uncast `[0,0]` is sparse slot `0`, not slot `2`. | branch index map; column-`0` diagnostics. | QBE-local diagnostic | lower | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3`, `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | proof obligations | `python3 tools/qbe.py check` | proved diagnostic |
| `slot2_selected_summand` | `B 2` is the selected backend branch contribution. | `slot2_full_basis_path`; all-slot branch family. | QBE-local semantic bridge | lower | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | this packet | `python3 tools/qbe.py check` | proved |
| `slot2_eval_under_coeff_contract` | Under corrected Ry coefficient hypothesis, the selected slot-`2` summand evaluates to the route product. | branch entry `[32,32]`; corrected coefficient contract. | QBE-local bridge plus contract hypotheses | lower | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3` | proof obligations | `python3 tools/qbe.py check` | conditional, compiled |
| `prepared_clean_to_backend_eval` | Under `hUniform`, the prepared singleton clean entry evaluates to `BackendFold`. | `hw_clean_column_contract`; prepared sandwich sum. | QBE-local bridge using external contract | lower | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | conversion window | `python3 tools/qbe.py check` | proved conditional |
| `source_prepared_projection_target` | The theorem-facing projection target selects the prepared singleton clean entry before comparing with active backend semantics. | block-encoding definition; prepared singleton bridge. | QBE-local semantic bridge | middle/lower | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`, transcript theorem | proof obligations | `python3 tools/qbe.py check` | compiled target |
| `raw_entry_prepared_sandwich_field` | Raw `signalUnitaryEntry = preparedProjectionSandwichSum H`. | source-prepared target; active signal entry. | QBE-local finite composition field | lower 2 | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | source-prepared middle packet | `python3 tools/qbe.py check` | open, mismatch risk |
| `active_prepared_eval` | Evaluated active/prepared singleton statement. | `raw_entry_prepared_sandwich_field` or evaluated backend fold. | QBE-local semantic bridge | lower 2 | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`, uncast form | conversion window | `python3 tools/qbe.py check` | open |
| `evaluated_backend_fold` | `eval(signalUnitaryEntry) = eval(BackendFold)`. | finite projection theorem; prepared bridge. | QBE-local semantic bridge | lower 2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | proof obligations | `python3 tools/qbe.py check` | open |
| `raw_coeff_fold_route` | H-free raw constructor equality for symbolic `Coeff` expressions. | old associativity route. | stale diagnostic | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | `evalGateMatrices-associativity-attempt.md` | none | stale; do not assign |

Next active leaf for a Lean worker:
compile a small typed mismatch/projection-field packet if the target still
reduces to `Active00 = PreparedEntry(H)`.  The packet should name that
`Active00` is slot `0` using
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`, while the displayed
source branch is slot `2` using
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`.  Only after a
theorem-facing prepared-entry LHS is exposed should the worker attempt the
`evalWith` bridge into `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

## 5. Ordered Intermediate Lean Lemmas To Reuse

1. Transcript guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`, and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`.

2. Slot maps:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` for slot `2`
   at `[32,32]`, and
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3` for slot `0`
   at `[0,0]`.

3. Selected-branch interfaces:
   `oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3`,
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`,
   and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

4. All-slot backend family and prepared bridge:
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`,
   and
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

5. Source-prepared target route:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_backendEval_n3`,
   and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3`.

6. Active column-`0` diagnostics:
   `oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3`, and
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`.  Reuse these
   only to show what the active `[0,0]` entry is; do not use them for the
   displayed slot-`2` coefficient.

7. Route equivalences:
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`,
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`,
   `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3`,
   and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

## 6. Failure Analysis

The direct route
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`
is unsafe as a theorem-closure target if it is read as a paper proof that the
active seven-gate `[0,0]` entry already contains the prepared sparse-register
projection.  The Lean definitions reduce the active side to `Active00`, and
the compiled column-`0` diagnostics show that this entry uses sparse slot `0`
symbols.  The displayed $\gamma_3$ branch in Eq. `ROBIN clarified` is the
slot-`2` branch at `[32,32]`.

The source paper obtains the factor `1/kappa` from the two
$H_W^{(\kappa)}$ sides.  A seven-gate active product that omits those sides
cannot be called the full Fig. `1 term ROBIN` circuit, and it cannot be
identified with the all-slot prepared sandwich without a separate finite
projection/composition theorem.

The external dependency is only the clean-column preparation contract for
$H_W^{(\kappa)}$.  The missing equality between the active signal entry and
the source-prepared singleton entry is QBE-local finite matrix semantics, not
a Shukla--Vedula theorem and not a Gilyen LCU theorem.

The raw H-free `Coeff` route remains diagnostic/backlog.  Symbolic `Coeff`
stores products and sums as constructors, so associativity and identity laws
are valid only after `Coeff.evalWith` or through explicitly proved evaluator
bridges.

## 7. Handoff

Lower 1 refreshed the proof-DAG around the source-prepared slot-`2` route after
the accepted slot-`0` column diagnostics.  No Lean files were edited.  The next
worker should not prove slot `2` from column `0`; they should either compile a
typed mismatch/projection-field record for the active `[0,0]` left side or
expose a theorem-facing prepared-entry left side before attempting the
`evalWith` backend-fold bridge.
