# QBE-AUTO-002 Lower 1 Addendum: Branch-Sum Leaf Only

Created: 2026-06-10 11:16:23 JST

Scope: natural-language proof-DAG addendum only.  This packet reuses
`proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-dag-20260609-1835-lower1.md`
and does not edit Lean.

## Active Target

The active Lean target is exactly:

```lean
theorem oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3 :
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
      oneTermRobinGamma3BoundaryBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- finite projection/backend branch-sum proof
```

Here:

- `SignalBlockEntry` means
  `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry`.
- `BranchSum` means
  `oneTermRobinGamma3BoundaryBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

The equivalent generic route is still:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

through:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3
```

This addendum does not promote any final block-encoding, normalized equality,
unitarity, LCU, oracle, or extraction flag.

## Source Anchors

| Source anchor | Content used here | Dependency class | Lean anchor |
|---|---|---|---|
| `main.tex:948-955` | `H_W^(kappa)` prepares the sparse register uniformly over `s = 0, ..., kappa - 1`. | external-cited-contract | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` uses the prepared route; this addendum does not reprove it. |
| `main.tex:1098-1164` | The one-term Robin theorem, Eq. `ROBIN clarified`, and Fig. `1 term ROBIN` define the theorem-facing route and gate order. | GHL-internal | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`. |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`: the displayed `gamma_3` boundary branch has coefficient `f(x_i) (D)_i^(s) sigma^(s) / (N_D N_f kappa)` on clean ancillas, with remaining branches hidden in `+ ...`. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` identifies the selected slot-`2` backend summand with the accepted selected contribution. |
| `main.tex:2027-2035` | The block-encoding definition projects onto clean ancillas and compares the signal block with the encoded operator entry. | QBE-local matrix semantics | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`. |

## Seven-Slot Fold: Survive And Vanish Status

The branch fold is a project-local fold over `Fin 7`.  The backend family is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff
```

The current compiled facts justify the following narrow classification:

| Slot | Current Lean status | Survive/vanish classification for this leaf | Dependency class |
|---|---|---|---|
| `0` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3` identifies the slot-`0` summand as the active row-`0` seven-gate diagonal term times the sparse projection factor. | Survives syntactically as a fold summand.  It is not the Eq. `ROBIN clarified` selected boundary branch, and no named theorem proves it vanishes. | QBE-local matrix semantics |
| `1` | No named selected-slot or vanish theorem is available in the required declaration list. | Remains an opaque backend summand.  Do not erase it unless a new Lean theorem proves the slot contribution is zero or otherwise cancels in the fold. | QBE-local matrix semantics |
| `2` | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` proves this backend summand equals `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`. | This is the displayed `gamma_3` boundary branch that survives as the selected contribution for the focused `n = 3` witness. | GHL-internal source branch plus QBE-local matrix semantics |
| `3` | No named selected-slot or vanish theorem is available in the required declaration list. | Remains an opaque backend summand.  Do not erase it without a named Lean theorem. | QBE-local matrix semantics |
| `4` | No named selected-slot or vanish theorem is available in the required declaration list. | Remains an opaque backend summand.  Do not erase it without a named Lean theorem. | QBE-local matrix semantics |
| `5` | No named selected-slot or vanish theorem is available in the required declaration list. | Remains an opaque backend summand.  Do not erase it without a named Lean theorem. | QBE-local matrix semantics |
| `6` | No named selected-slot or vanish theorem is available in the required declaration list. | Remains an opaque backend summand.  Do not erase it without a named Lean theorem. | QBE-local matrix semantics |

Therefore the branch-sum leaf should not be implemented by throwing away
non-selected slots.  The proof must either expand `signalBlockEntry` into the
same seven summands, or introduce strictly smaller named vanish/cancellation
lemmas for specific slots before using them.  At the time of this addendum, the
only selected contribution theorem named for the active route is
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

## Dependency Classes For Required Ingredients

| Ingredient | Required declaration | Class | Use in the branch-sum leaf |
|---|---|---|---|
| Theorem-facing Fig. 4 transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | GHL-internal | Confirms the source circuit route being modeled; not a summation proof. |
| Indicator dagger role | `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal plus QBE-local matrix semantics | Keeps the explicit `U_indic^dagger` role aligned with the compiled indicator matrix bridge. |
| Prepared clean-entry alias | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | external-cited-contract plus QBE-local matrix semantics | Already compiled; useful only as context, not the active lower target. |
| Sparse preparation absence guard | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | QBE-local matrix semantics | Confirms the active backend seven-gate core omits the sparse-preparation side gates; it is not a slot-vanish theorem. |
| Selected backend summand | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local matrix semantics | Proves slot `2` is the accepted selected contribution. |
| Backend expansion equivalence | `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3` | QBE-local matrix semantics | Converts the focused branch-sum equality to/from the generic backend-expansion statement. |
| Prepared-entry route equivalence | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3` | external-cited-contract plus QBE-local matrix semantics | Route interface after the branch-sum/backend-expansion leaf; not the current proof target. |

## Narrow Proof DAG

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | Source Fig. `1 term ROBIN` route is the theorem-facing circuit route with both `H_W` sides and explicit `U_indic^dagger`. | `main.tex:1098-1164` | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | prior conversion window and source-prepared DAG | `python3 tools/qbe.py check` | proved |
| `prepared_clean_alias_context` | Prepared clean entry evaluates to backend fold under the sparse-preparation contract. | `main.tex:948-955`; prepared clean-entry route | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | source-prepared branch-sum DAG | same gate | proved but stale as active target |
| `active_backend_guard` | The active seven-gate backend core omits sparse-preparation side gates. | backend gate-list guard | lower/middle | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | mismatch and branch-sum packets | same gate | proved guard, not a vanish theorem |
| `slot2_selected_branch` | Slot `2` in `Fin 7` is the focused Eq. `ROBIN clarified` boundary contribution. | `main.tex:1111-1119`; branch full-index map | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | source-prepared branch-sum DAG plus this addendum | same gate | proved |
| `all_slot_backend_family` | Backend contribution family is typed as seven sparse-slot summands. | branch full-index map; projection amplitude factor | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | source-prepared branch-sum DAG plus this addendum | same gate | typed |
| `branch_sum_leaf` | `SignalBlockEntry = BranchSum` for the all-slot backend family. | `all_slot_backend_family`; block-entry projection semantics; no slot erasure without named theorem | lower 2 | `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3` | this addendum | `python3 tools/qbe.py check`; then full repository gate if Lean is edited | active leaf |
| `backend_expansion_route` | Generic backend expansion is equivalent to the focused branch-sum equality. | `branch_sum_leaf` | lower 2 after branch-sum proof | `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3` | source-prepared branch-sum DAG plus this addendum | same gate | proved equivalence, open endpoint |

## Retired Lower Targets

The following are explicitly stale for this cycle:

- Source-prepared clean-entry alias:
  `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3`
  is already compiled.
- Arbitrary-`H` generic prepared-entry target:
  use `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`
  only after the backend-expansion or branch-sum leaf is proved.
- H-free eval and column-`0` diagnostics:
  these do not close the source-prepared seven-slot projection route.
- Raw `Coeff` constructor equality:
  it is diagnostic and should not replace the matrix-entry projection proof.
- Finite active/prepared guard work:
  the branch-sum leaf already has the active backend guard context it needs.
- Rediscovery of compiled conditional bridges:
  do not reprove `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`
  or the prepared-entry/backend-expansion equivalence.

## Non-Promoted Flags

This packet does not promote ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block
projection, normalized equality, unitarity, block correctness, or final
extraction flags.  It only narrows the next Lean proof to the finite
matrix-semantics statement that `SignalBlockEntry` equals the seven-slot
backend `BranchSum`.

## Lower 1 Continuation After Lean Re-Read

Updated: 2026-06-10 lower natural-language proof architect.

The Lean re-read found that the direct theorem
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3` is still
absent.  The compiled theorem
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_of_activePreparedEntryTarget_n3`
is only a conditional feeder: it transports a future
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
proof through `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`.
It does not close the finite branch-sum leaf.

### Exact Source Fragment

The source equation being translated is the clean `gamma_3` boundary branch of
Eq. `ROBIN clarified`:

$$
\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
\sum_{s=0}^{\kappa-1}
f(x_i)(D)_i^{(s)}\sigma^{(s)}
\ket{0}^{m_f+1}\ket{s}^{\lceil\log_2\kappa\rceil}
\ket{0}^{n-\lceil\log_2\kappa\rceil}\ket{j}^n\ket{0}.
$$

For the focused `n = 3` Lean witness this is represented by the all-slot
backend family

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff
```

and the block-encoding projection fragment from Definition `def:block-encoding`
is represented by:

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry
```

The active theorem is the finite projection equality:

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
  oneTermRobinGamma3BoundaryBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

### Natural-Language Proof Design

Define `branchContribution(s)` to be the diagonal seven-gate backend entry at
the full branch index for sparse slot `s`, multiplied by the two clean
sparse-register projection amplitudes.  This is exactly
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s`.

Define `BranchSum` to be the left fold over all seven `Fin 7` slots.  This is
definitionally the same fold as
`blockExtractionBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

The local theorem should prove that the signal-zero block entry selected by the
block-encoding projection equals this complete seven-slot fold.  The proof
must use the block-entry bridge
`oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3` and the
generic target interface
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3`; after those
bridges, the remaining mathematical content is precisely the backend expansion
statement of that target.

Slot `2` is the only slot currently identified with the displayed boundary
branch, by
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.  Slot `0`
has the diagnostic formula
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3` and the fold
expansion
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.  Slots
`1`, `3`, `4`, `5`, and `6` have no compiled vanish theorem.  Therefore a Lean
proof cannot delete these terms.  It must either derive the full seven-slot
fold from the projection backend, or introduce new named zero/cancellation
lemmas before rewriting the fold.

### Updated Proof-DAG Leaf Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `selected_slot_clause` | Eq. `ROBIN clarified`; branch full-index selected slot | proved | lower/middle | Reuse `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`. |
| `fold_domain_support` | `List.finRange 7`; selected slot membership | proved | lower/middle | Reuse `oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3`. |
| `slot0_diagnostic` | active row-`0` full index | proved diagnostic | lower/middle | Reuse only for debugging expanded folds; do not treat as source closure. |
| `backend_projection_equiv` | generic block-entry bridge and branch-sum fold bridge | proved equivalence | lower/middle | Reuse `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`. |
| `conditional_active_prepared_feeder` | external clean-column contract plus future active/prepared equality | compiled conditional | lower 2 context | Reuse only after a real `entryEqualityStatement` proof. |
| `direct_branch_sum_leaf` | all-slot backend family; projection backend expansion | open active leaf | lower 2 | Prove `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3` or `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`. |
| `raw_entry_prepared_sandwich_field` | prepared sandwich backend specialization under `hUniform` | open smaller equivalent field | lower 2 fallback | If direct branch sum is too large, prove the raw entry equals the prepared sandwich fold, then use the compiled equivalences. |

### Ordered Lean Lemmas To Reuse

1. `blockExtractionBranchContributionSum` and
   `BlockExtractionBranchContributionTarget.backendExpansionStatement` from
   `QuantumBlockEncoding/CircuitSemantics.lean`.
2. `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.
3. `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.
4. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`, only as
   a diagnostic expansion aid.
5. `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`, only if
   the worker chooses the expanded-fold route.
6. `oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3`.
7. `oneTermRobinGamma3BoundaryBackendProjectionStatement_equivBranchSum_n3`.
8. `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`.
9. `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.
10. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
    only for a source-prepared fallback under
    `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
11. `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_of_activePreparedEntryTarget_n3`,
    only as a conditional feeder after a future active/prepared entry proof.

### Failure Analysis

The target is mathematically correct as a finite projection/backend expansion,
but the current Lean backend does not yet expose the raw projection theorem
that expands `contract.expectedTarget.blockMatrix[0,0]` or the corresponding
signal-zero full-unitary entry as the seven backend summands.  The active proof
should not be routed through raw constructor equality, column-`0` slot-only
diagnostics, or selected-slot deletion.  Those routes fail because the source
branch uses the complete sparse-slot sum supplied by the two
`H_W^(kappa)` boundary gates, and the compiled Lean facts do not prove that
non-selected backend slots vanish.
