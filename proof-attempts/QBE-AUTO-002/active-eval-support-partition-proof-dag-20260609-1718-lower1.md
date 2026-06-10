# QBE-AUTO-002 Lower 1 Packet: Active Eval Support Partition Route Check

Created: 2026-06-09 17:18 JST

Scope: natural-language proof architecture only.  No Lean source was edited by
this packet.

## 1. Source Fragment Being Translated

The paper fragment is Guseynov-Huang-Liu 2025, arXiv:2506.20478, Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and
Definition `def:block-encoding`.

| Source anchor | Paper fragment | Lean-facing declaration or target | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the sparse register with amplitude $1/\sqrt{\kappa}$ on every sparse slot. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; no Shukla-Vedula proof is assigned here |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ and zero error. | root theorem route fed by source-prepared projection and evaluated backend fold targets | GHL-internal theorem target | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the displayed boundary part of `gamma3` uses sparse slot `2` in the focused example, with clean branch index `32`. | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local index bridge | compiled selected-slot bridge |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit includes both $H_W^{(\kappa)}$ side gates, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger`. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local guard | compiled transcript guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the block-encoding proof must compare the clean signal block after the prescribed ancilla projection. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3 H env` | QBE-local semantic bridge | open finite composition field |

The source does not state that the H-free seven-gate active entry at `[0,0]`
equals the all-slot prepared sparse-register fold.  The paper route uses the
two $H_W^{(\kappa)}$ sides to create and project the sparse-register
superposition.

## 2. Definitions Before Claims

Fix `env : String -> Rat`.

Let

```lean
gates := GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)
```

and let the uncast active entry be

```lean
Coeff.evalWith env
  ((evalGateMatrices gates)
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let

```lean
U7 := oneTermRobinGamma3BoundarySevenGateMatrix_n3
```

where `U7` is the explicit seven-gate H-free product
`suffix * prefix`.

For each sparse slot `s : Fin 7`, define the backend full-basis index and
weighted summand by the existing Lean declarations

```lean
b s := oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s
B s := oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s
```

The compiled facts are:

```lean
b 0 = oneTermRobinGamma3BoundaryPrefixRow0_n3
b 2 = oneTermRobinGamma3BoundaryPrefixSource_n3
B s = U7 (b s) (b s)
        * oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor
```

The projection amplitude factor is

```lean
Coeff.mul (Coeff.symbol "sqrt_kappa_inv")
  (Coeff.symbol "sqrt_kappa_inv")
```

by `oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript`.

The backend fold is

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

and `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` expands it
as the weighted slot-`0` summand plus slots `1` through `6`.

## 3. Natural-Language Proof Of The Active Local Route Check

The active local theorem should not be a blind proof of
`oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`.
The support partition already exposes a target-shape problem.  The useful local
result for the Lean worker is the following route check:

For the H-free active seven-gate product, the `[0,0]` support partition is the
column-`0` two-path expansion through intermediate rows `96` and `97`.  This
is compiled as `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`
and `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`.  Its symbols are
`boundary_cos_half_0_0` and `boundary_sin_half_0_0`.

For the source displayed gamma3 branch, the selected sparse slot is slot `2`.
The full-basis branch index is `32`, compiled by
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`.  The selected
branch contribution is the seven-gate diagonal entry at `[32,32]` multiplied by
the two sparse-register projection amplitudes, compiled by
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` and
`oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3`.

For the backend fold, the slot-`0` summand is not the unweighted active entry.
It is the active `[0,0]` seven-gate diagonal multiplied by the same projection
amplitude factor, compiled by
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`.  The
remaining slots `1` through `6` remain explicit summands after
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.

Therefore a proof of the uncast active-entry leaf for arbitrary `env` would
need a new finite composition theorem saying:

```text
unweighted H-free active [0,0] entry
=
sum_s weighted H-free branch diagonal [b(s), b(s)] entries.
```

That statement is not the paper's register-level transformation.  The paper
uses $H_W^{(\kappa)}$ and $(H_W^{(\kappa)})^\dagger$ to supply the two
`sqrt_kappa_inv` factors and sum all sparse slots.  The compiled mismatch guard
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`
also records that the evaluated backend-fold target still exposes an H-free
active `[0,0]` entry and that both sparse-preparation side gates are absent from
`gates`.

The correct mathematical route is:

1. Keep `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3`
   as a QBE-local diagnostic leaf only if a worker can prove, from finite matrix
   semantics, that every weighted slot in the backend fold matches or cancels
   the H-free active entry.  The existing support partition does not do this.

2. For source-faithful theorem closure, route through the prepared composition
   field:

   ```lean
   (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
   ```

   or the existing stronger raw field

   ```lean
   (oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H)
     .rawEntryPreparedSandwichStatement
   ```

   These statements compare the active signal-zero entry with the clean entry
   of the prepared sandwich
   $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$.

3. Once the prepared composition field is proved, reuse the compiled bridges:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_rawEntryPreparedSandwichField_n3`,
   and
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

No external oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, final-extraction,
ODBS, ODTS, or `O_f` semantic flag is promoted by this route check.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | all-slot sparse-register preparation clean column | Eq. `arbitrary sparcity`; Shukla-Vedula cited implementation | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results/status notes | `python3 tools/qbe.py check` | contract-only |
| `fig4_transcript_guard` | theorem-facing Fig. 4 order with both `H_W` sides and explicit `U_indic^dagger` | Fig. `fig:1 term ROBIN`; U-indic self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | compiled |
| `slot2_backend_branch` | displayed gamma3 slot `2` maps to full basis `[32,32]` and the selected weighted branch summand | Eq. `ROBIN clarified`; branch index map; branch-entry selection | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3` | prepared-entry source DAG | `python3 tools/qbe.py check` | compiled |
| `slot0_active_support_partition` | H-free active `[0,0]` seven-gate entry has a two-path expansion through rows `96` and `97` | column-`0` finite support lemmas | lower/middle | `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`; `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | column-0 guard notes | `python3 tools/qbe.py check` | compiled diagnostic |
| `active_uncast_h_free_guard` | evaluated backend-fold target exposes the H-free active entry and lacks both `H_W` side gates | active circuit entry reduction; sparse-preparation absence guard | lower/middle | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | active/prepared mismatch note | `python3 tools/qbe.py check` | compiled mismatch witness |
| `backend_fold_weighted_shape` | backend fold contains weighted slot-`0` active diagonal plus slots `1` through `6` | all-slot branch formula; projection amplitude factor | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`; `oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript` | this packet | `python3 tools/qbe.py check` | compiled |
| `eval_gate_assoc_entry` | if the H-free route is still attempted, connect `evalGateMatrices gates [0,0]` to `U7[0,0]` without using the sorry-guarded raw matrix theorem | definitions of `evalGateMatrices`, `U7`, and gate list order | lower 2/refiner | new entry-level associativity lemma, not `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` unless repaired | this packet | `python3 tools/qbe.py check` | blocked internal; small only if route remains assigned |
| `active_eval_support_partition_decision` | decide whether the H-free active entry can equal the weighted seven-slot backend fold for arbitrary `env` | `slot0_active_support_partition`; `backend_fold_weighted_shape`; selected slot-`2` guard | lower 2/refiner | proof-obligation note or small theorem showing the exact obstruction | this packet | `python3 tools/qbe.py check` | next active leaf for route validation |
| `uncast_eval_entry_leaf` | prove `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | `eval_gate_assoc_entry`; `active_eval_support_partition_decision`; all-slot cancellation/matching theorem | lower 2/refiner | proposed theorem from middle packet | middle support packet | same gates | blocked unless all weighted slots are matched or eliminated |
| `prepared_composition_field` | relate active signal-zero entry to prepared sandwich clean entry | source Fig. 4 with both `H_W` sides; prepared matrix interface | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` or `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | prepared-sandwich packets | same gates | recommended source-faithful active leaf |
| `evaluated_backend_fold` | close the named evaluated backend fold through the source-prepared route | `prepared_composition_field`; `src_hw_uniform`; prepared backend bridge | lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | conversion window | same gates | open |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for the H-free fold | old raw scripts and sorry diagnostics | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

Next active leaf for a Lean worker:

```text
active_eval_support_partition_decision
```

The worker should either record that the uncast `evalWith` leaf is contract
drift as source closure, or prove a genuinely source-faithful prepared
composition field.  A proof that only rewrites to
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` is not enough.

## 5. Ordered Lean Lemma List

1. Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` only as
   transcript provenance.  They prove the paper-facing gate labels are present.

2. Reuse `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`
   and `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` as the
   active-target shape guard.

3. Reuse `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3` and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3` to show
   the backend fold's first summand is the active diagonal multiplied by
   `sqrt_kappa_inv * sqrt_kappa_inv`.

4. Reuse `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`, and
   `oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3` to keep
   the source displayed slot `2` branch separate from the active slot `0`
   diagnostic.

5. Reuse `oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript` for the
   exact projection factor:

   ```lean
   Coeff.mul (Coeff.symbol "sqrt_kappa_inv")
     (Coeff.symbol "sqrt_kappa_inv")
   ```

6. Reuse `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` to
   expose all seven weighted backend summands.

7. Reuse `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`
   and `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` only as a
   diagnostic support partition for the H-free `[0,0]` entry.

8. If lower 2 still attempts the uncast leaf, first prove a small entry-level
   associativity lemma for `[0,0]`:

   ```lean
   Coeff.evalWith env
     ((evalGateMatrices gates) row0 row0)
   =
   Coeff.evalWith env
     (oneTermRobinGamma3BoundarySevenGateMatrix_n3 row0 row0)
   ```

   This lemma should not depend on the sorry-guarded
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

9. Preferred source-faithful next theorem:

   ```lean
   (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H)
     .entryEqualityStatement
   ```

   or the stronger existing field

   ```lean
   (oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H)
     .rawEntryPreparedSandwichStatement
   ```

10. Then reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3`
    or `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
    to route the prepared field back into the named evaluated backend fold.

## 6. Failure Analysis

The current uncast target is mathematically unsafe as a source theorem.  Its
left-hand side is the H-free active `[0,0]` seven-gate product.  The source
Fig. 4 circuit and Eq. `arbitrary sparcity` require an
$H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich before the all-slot backend
fold can appear.

The existing Lean facts identify the obstruction:

| Fact | Meaning |
|---|---|
| `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3 env` | the active `[0,0]` support partition uses slot-`0` boundary symbols, not the displayed slot-`2` gamma3 symbols |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3` | the backend fold's slot-`0` summand is the active diagonal multiplied by the sparse projection amplitude factor |
| `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` | the backend fold still contains weighted slots `1` through `6` after exposing slot `0` |
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3` | the evaluated backend-fold target still exposes an H-free active entry and lacks both `H_W` side gates |

Thus the current proof obligation is not a missing matrix-support trick.  It is
a missing prepared-composition theorem.  If a worker proves only the column-`0`
two-path diagnostic, the result must be recorded as contract drift, not as
closure of Eq. `ROBIN clarified` or Fig. `fig:1 term ROBIN`.

## 7. Handoff

Lower 2 should not try to close
`oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` by
reusing only the column-`0` two-path diagnostic.  The next Lean step should be
one of:

1. record a small proof-obligation/mismatch theorem that the uncast target is
   H-free and weighted-fold shaped, using the compiled guards listed above; or
2. prove the source-faithful prepared-composition field
   `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
   or the stronger raw prepared-sandwich field.

No Lean source was edited in this lower-1 packet.
