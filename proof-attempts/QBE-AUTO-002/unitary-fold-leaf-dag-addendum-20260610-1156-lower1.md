# QBE-AUTO-002 Lower 1 Addendum: Full-Unitary Fold Leaf

Created: 2026-06-10 11:56 JST

Scope: natural-language proof architecture only. This packet edits no Lean
source and promotes no semantic flag.

## Freshness Note

The prompt snapshot still names the branch-sum wrapper
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3` as the
active leaf. The latest dialogue board for
`runs/20260610-113838-QBE-AUTO-002-cycle01` supersedes that wrapper: lower 2
compiled
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`.
The wrapper is now only a statement-level bridge. The current active local
theorem is the full signal-unitary seven-slot fold:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The equivalent backend-expansion endpoint is:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

through:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
```

Postscript after the 11:59 lower handoff: another lower worker also compiled
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_preparedCleanEntry_n3`.
That bridge identifies the branch-sum wrapper with the prepared clean-entry
equality under the existing $H_W^{(\kappa)}$ clean-column contract. It does
not prove the prepared equality or the fold. The useful next leaf is therefore
the active-to-prepared clean-entry equality, the full unitary-entry fold, or a
strict support/cancellation lemma feeding one of those equivalent statements.

## 1. Source Fragment Being Translated

| Source anchor | Fragment being translated | Dependency class | Lean anchor |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$. This supplies the ket-side and dagger-side sparse-register amplitudes. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3` |
| `main.tex:1098-1109`, Theorem `1 term robin` | The theorem claims a one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ and the stated ancilla count. | GHL-internal root | theorem-facing route remains open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The displayed $\gamma_3$ boundary branch is the all-slot sum with coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ on clean ancillas, with other wavefunction branches hidden in `+ ...`. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | The theorem-facing circuit has both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}$, post-SWAP $(O_D^{BS})^\dagger`, and the seven inner backend gates. | GHL-internal transcript plus QBE-local bridge | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is extracted by projecting the ancillas onto zero and comparing the resulting system entry. | QBE-local finite projection bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`; `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3` |

## 2. Definitions Before Claims

Define `SignalUnitaryEntry` by:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry
```

Define `BackendContribution(s)` by:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s
```

For every `s : Fin 7`, Lean already proves:

```lean
oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3 s
```

so `BackendContribution(s)` is the seven-gate diagonal branch entry at
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s`, multiplied by the
two sparse-register projection amplitudes.

Define `BackendFold` by:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define the prepared sandwich fold for an explicit sparse-register preparation
matrix `H` by:

```lean
oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H
```

Under the clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, Lean
already proves that this prepared sandwich fold equals `BackendFold`.

## 3. Natural-Language Proof Design

The active theorem states that the full signal-zero unitary entry selected by
the block-encoding projection is the fold over the seven sparse-slot backend
contributions.

The source proof structure is:

1. Eq. `arbitrary sparcity` prepares the sparse register uniformly over all
   paper slots. The dagger side contributes the matching clean bra amplitude.
2. Eq. `ROBIN clarified` expresses the clean $\gamma_3$ boundary branch as a
   sum over the same sparse slots. The focused `n = 3` witness selects slot `2`
   as the displayed branch, but the source expression is still an all-slot
   sum.
3. Definition `def:block-encoding` says that after clean ancilla projection,
   the relevant system entry is read from the signal-zero block of the circuit
   matrix.
4. The QBE-local matrix semantics must therefore expand the selected full
   unitary entry as the seven prepared branch contributions.

In Lean, the first, second, and naming parts of this route are compiled. The
missing step is the finite projection backend:

```lean
SignalUnitaryEntry = BackendFold
```

The preferred implementation route is:

1. Use
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`
   to reduce the backend-expansion endpoint to the uncast `[0,0]`
   `evalGateMatrices` entry.
2. If needed, use
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
   to expose the current seven-summand shape.
3. Prove one genuinely new local leaf: either the uncast active entry equals
   the expanded seven-slot fold, or a named support/cancellation lemma that
   removes a specific obstruction in that equality.
4. Return through
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
   and then, if the wrapper statement is needed, through
   `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`.

The proof must not delete non-selected sparse slots. Slot `2` is the displayed
source branch, but Eq. `ROBIN clarified` and the two $H_W^{(\kappa)}$ sides
give an all-slot sum.

## 4. Seven-Slot Survive/Vanish Status

| Slot | Compiled facts | Status for this leaf | Dependency class |
|---|---|---|---|
| `0` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`; column-`0` diagnostics | Survives as a backend fold summand. It is useful for debugging the raw `[0,0]` active entry, but it is not the displayed slot-`2` branch. | QBE-local matrix semantics |
| `1` | all-slot formula only | Survives as an opaque summand. No vanish or cancellation theorem is compiled. | QBE-local matrix semantics |
| `2` | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3` | Survives as the focused displayed $\gamma_3$ boundary branch. | GHL-internal branch plus QBE-local matrix semantics |
| `3` | all-slot formula only | Survives as an opaque summand. No vanish or cancellation theorem is compiled. | QBE-local matrix semantics |
| `4` | all-slot formula only | Survives as an opaque summand. No vanish or cancellation theorem is compiled. | QBE-local matrix semantics |
| `5` | all-slot formula only | Survives as an opaque summand. No vanish or cancellation theorem is compiled. | QBE-local matrix semantics |
| `6` | all-slot formula only | Survives as an opaque summand. No vanish or cancellation theorem is compiled. | QBE-local matrix semantics |

No slot is currently justified as zero. A Lean worker may introduce a vanish
or cancellation lemma only after proving it from the existing matrices; it
must not be assumed from the source display.

## 5. Proof-DAG Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `1 term ROBIN`; indicator self-inverse bridge | compiled | middle/reviewer | Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`. |
| `signal_block_to_unitary` | block projection index convention | compiled | lower/middle | Reuse `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`. |
| `branch_sum_to_unitary_fold` | `signal_block_to_unitary`; fold naming | compiled bridge, not closure | lower 2 | Reuse `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`. |
| `all_slot_backend_formula` | branch full-index map; projection amplitude factor | compiled | lower/middle | Reuse `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` and `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`. |
| `slot2_selected` | Eq. `ROBIN clarified`; branch full-index selected slot | compiled | lower/middle | Reuse `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`. |
| `slot0_expansion_diagnostic` | active `[0,0]` column support lemmas | compiled diagnostic | lower/middle | Reuse for debugging only: `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`, `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`. |
| `unitary_fold_leaf` | `all_slot_backend_formula`; finite product/projection expansion | open active leaf | lower 2/refiner | Prove `SignalUnitaryEntry = BackendFold`, or prove a named support/cancellation lemma that feeds it directly. |
| `backend_expansion_endpoint` | `unitary_fold_leaf` | open equivalent endpoint | lower 2/refiner | Close via `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`. |
| `prepared_clean_equivalent_field` | external $H_W^{(\kappa)}$ clean-column contract; prepared sparse matrix clean entry | compiled equivalences, missing equality remains | lower 2 fallback only if reassigned | `oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3 H hUniform` and `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_preparedCleanEntry_n3` show the prepared clean-entry field is equivalent under `hUniform`. |
| `raw_coeff_constructor_route` | symbolic `Coeff` constructor equality | diagnostic `sorry` | none | Do not assign as source closure: `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` and `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` remain sorry-guarded diagnostics. |

Next active leaf for a Lean worker:

```lean
theorem <new_name> :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- finite projection/backend expansion proof
```

Strictly smaller acceptable leaf:

```lean
theorem <new_name> :
    (evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    blockExtractionBranchContributionSum
      oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- uncast active-entry fold proof
```

This smaller leaf feeds the active endpoint through
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`.

## 6. Ordered Lean Lemmas To Reuse

1. Projection/index layer:
   `signalSystemBlockProjection_apply`,
   `oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`,
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`.

2. Branch family layer:
   `blockExtractionBranchContributionSum`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`,
   `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.

3. Backend expansion bridges:
   `oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`,
   `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.

4. Active-entry source lemmas:
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_activeCircuitMatrix_n3`,
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
   `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`.

5. Existing support diagnostics:
   `oneTermRobinGamma3BoundaryPrefixCol0Support_n3`,
   `oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`.

6. Source-prepared equivalence route:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedCircuitSparseMatrix_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3`,
   `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_preparedCleanEntry_n3`.

## 7. Failure Analysis

The selected-slot theorem is not enough to prove the fold. It proves that slot
`2` has the right displayed $\gamma_3$ branch contribution, but the source
branch is summed over all sparse slots and the current Lean fold contains all
seven slots.

The column-`0` two-path diagnostic is not a source closure route by itself. It
expands the active `[0,0]` seven-gate entry using slot-`0` half-angle symbols,
while the displayed source branch for the focused witness is slot `2`.

The raw symbolic constructor route remains blocked. The diagnostic theorem
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` states the active
fold but still contains `sorry`, and prior attempts with `rfl` or
`native_decide` were recorded as max-depth or resource failures.

An arbitrary-`H` active/prepared equality is too strong unless the existing
clean-column contract is present. Under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
prepared clean-entry field is equivalent to the unitary fold by
`oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3 H
hUniform`; without that contract it is not the paper step.

## 8. Handoff

Lower 1 refreshed the proof blueprint, re-read the local source anchors from
`/home/nitanda_sub/mark/repos/outer_papers/quantum/GHL2025/main.tex`, and
updated the proof-DAG packet to the current full-unitary fold frontier. The
direct branch-sum wrapper is retired as an implementation target because
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`
and
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_preparedCleanEntry_n3`
are compiled bridges. The next Lean worker should prove the active-to-prepared
clean-entry equality, the full unitary-entry fold, or one named
support/cancellation lemma feeding those equivalent endpoints. No Lean source,
oracle contract, normalizer, paper circuit, or theorem-facing semantic flag was
changed by this packet.

## 9. Current-Run Addendum: Index Feeder And Full Fold Frontier

Created: 2026-06-10 12:40 JST.

This addendum reuses the proof-DAG above for run
`20260610-122328-QBE-AUTO-002-cycle01`. The selected theorem statement has not
changed. The latest accepted Lean feeder is
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`; it is useful
index memory for future support or cancellation lemmas, but it is already
compiled and should not be reassigned as the next lower target.

### 9.1 Source Fragment

| Source anchor | Fragment being translated | Current Lean interface | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the sparse register as an all-slot uniform sum. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1098-1109`, Theorem `1 term robin` | The one-term Robin block-encoding is the theorem-facing root; it remains open. | theorem-facing route through backend expansion and product obligations | GHL-internal root |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary line is an all-slot sparse sum; slot `2` is the focused displayed branch, not the whole sum. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing circuit keeps both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, and post-SWAP $(O_D^{BS})^\dagger$. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | GHL-internal transcript plus local gate-list audit |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is read from the signal-zero unitary entry before comparison with the target operator. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection/backend bridge |

### 9.2 Definitions And Local Proof

Define the active theorem as `FullUnitaryFold`:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

For `s : Fin 7`, define the backend branch index by
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s`. The compiled feeder

```lean
oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3 s
```

states that this full basis index has value `s.val * 16`. Hence slot `0`
maps to the active full basis index `0`, and slot `2` maps to the accepted
branch basis index `32`. The already compiled selected-slot theorem is still
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

Define `BackendContribution(s)` by
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s`, and define
`BackendFold` by
`blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.
The source prepared version is the clean entry of
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`; its clean entry
equals `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H` by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.
Under the clean-column contract, the prepared sandwich fold equals
`BackendFold` by `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.

The natural-language proof for the active route is therefore:

1. Expand the source sparse preparation as an all-slot sum using the existing
   $H_W^{(\kappa)}$ clean-column contract. This is a cited external contract,
   not a QBE proof of the state-preparation circuit.
2. Use the compiled branch-index feeder to place each sparse slot at full
   basis index `16 * s`. This identifies slot `2` with the displayed
   $\gamma_3$ branch at index `32`, while preserving all seven slots in the
   fold.
3. Use the prepared sparse-register matrix interface to show that its clean
   entry is the prepared sandwich sum, and then specialize that sum to
   `BackendFold` under `hUniform`.
4. The missing QBE-local theorem is still the active/prepared composition
   equality, equivalently `FullUnitaryFold`. A future proof of
   `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
   closes `FullUnitaryFold` through
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.
5. A direct H-free proof may be used only if it proves the same seven-slot
   fold through the compiled backend-expansion equivalence. It must not claim
   that the active seven-gate product alone is the theorem-facing Fig. 4
   circuit, because `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`
   proves both $H_W^{(\kappa)}$ boundary gates are absent from that active
   gate list.

### 9.3 Seven-Slot Status After The Index Feeder

| Slot | Index fact | Contribution status | Next Lean use |
|---|---|---|---|
| `0` | index value `0` by `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3` and the value feeder | Survives as the active diagonal diagnostic summand. | Useful for uncast active-entry diagnostics only. |
| `1` | index value `16` by the value feeder | No compiled vanish or cancellation fact. | Do not erase without a named theorem. |
| `2` | index value `32` by `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` and the value feeder | Survives as the focused Eq. `ROBIN clarified` boundary branch. | Reuse `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`. |
| `3` | index value `48` by the value feeder | No compiled vanish or cancellation fact. | Do not erase without a named theorem. |
| `4` | index value `64` by the value feeder | No compiled vanish or cancellation fact. | Do not erase without a named theorem. |
| `5` | index value `80` by the value feeder | No compiled vanish or cancellation fact. | Do not erase without a named theorem. |
| `6` | index value `96` by the value feeder | No compiled vanish or cancellation fact. | Do not erase without a named theorem. |

No newly compiled theorem justifies dropping slots `1`, `3`, `4`, `5`, or
`6`. The next support/cancellation leaf must prove an actual matrix-entry
fact, not only restate the index values.

### 9.4 Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 transcript keeps both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` role | source Fig. `fig:1 term ROBIN`; indicator bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | compiled guard |
| `prepared_gate_absence_guard` | active seven-gate list omits both sparse-preparation boundary gates | active gate labels | lower 2/middle | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | conversion window | same gate | compiled guard |
| `all_slot_index_feeder` | backend branch index has value `16 * s` for every `s : Fin 7` | basis-index definition and `clog2 7 = 3` | lower 2 | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3` | this addendum | same gate | compiled; retired as target |
| `selected_slot2_contribution` | slot `2` is the focused $\gamma_3$ boundary summand | all-slot index feeder; selected branch full-index theorem | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | this addendum | same gate | compiled |
| `prepared_sparse_clean_entry` | prepared sparse-register matrix clean entry is the prepared sandwich sum | prepared matrix definition | lower/middle | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3` | conversion window | same gate | compiled |
| `prepared_sum_to_backend_fold` | under `hUniform`, prepared sandwich sum is `BackendFold` | $H_W^{(\kappa)}$ clean-column contract | lower/middle | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3` | conversion window | same gate | compiled conditional |
| `active_prepared_entry_leaf` | active signal-zero entry equals prepared sparse matrix clean entry | active entry source; prepared sparse matrix interface | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | conversion window | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | open feeder |
| `unitary_fold_leaf` | `FullUnitaryFold` | backend contribution family; active/prepared feeder or direct backend expansion | lower 2/refiner | target statement above; diagnostic `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` still has `sorry` | this addendum | same three gates | open active leaf |
| `backend_expansion_endpoint` | generic backend-expansion endpoint equivalent to `FullUnitaryFold` | `unitary_fold_leaf` | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | conversion window | same three gates | open equivalent endpoint |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for the H-free fold | deeply nested `Coeff` syntax | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | sorry-guarded diagnostic |

Next active leaf for the Lean worker:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Acceptable smaller leaf:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

or a named support, vanish, or cancellation theorem that uses
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3` and directly feeds
the full seven-slot fold. A theorem that only recomputes `16 * s` is stale.

### 9.5 Ordered Lean Lemmas To Reuse

1. Index and selected-slot layer:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

2. Projection and fold layer:
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`,
   `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.

3. Prepared matrix layer:
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3_transcript`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_interfaceStatement_n3`.

4. Conditional closure layer:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedCircuitSparseMatrix_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_matrix_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.

5. Guard and failure-memory layer:
   `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`,
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

### 9.6 Failure Analysis

The active theorem is not mathematically wrong, but a raw constructor proof is
not a faithful source proof plan. The source circuit includes both
$H_W^{(\kappa)}$ sides, while the active seven-gate list lacks those gates.
The guard `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` makes
that mismatch explicit.

The new all-slot index feeder does not prove a vanish or cancellation result.
It only says where each sparse slot lands in the full basis. Therefore it can
feed future support lemmas, but it does not by itself close
`FullUnitaryFold`.

The selected slot theorem is also insufficient by itself. Eq.
`ROBIN clarified` contains an all-slot sparse sum; slot `2` identifies the
focused displayed branch but does not erase slots `0`, `1`, `3`, `4`, `5`, or
`6`.

The next Lean worker should either prove the active/prepared entry equality,
close `FullUnitaryFold` through the backend-expansion equivalence, or produce
a real support, vanish, or cancellation lemma that uses the index feeder and
has an explicit path into `FullUnitaryFold`.

## 10. Middle Addendum: Expanded All-Slots Feeder Accepted

Created: 2026-06-10 12:41 JST for run
`20260610-124120-QBE-AUTO-002-cycle01`.

The selected theorem statement has not changed.  Lower 2 has now compiled the
strict support feeder

```lean
oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3
```

which rewrites

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

as the seven weighted full-basis diagonal entries at sparse-slot indices
`0`, `16`, `32`, `48`, `64`, `80`, and `96`.  This feeder uses the existing
branch-index map and keeps slot `2` as the displayed $\gamma_3$ boundary
summand while preserving all other sparse slots.  It does not prove
`FullUnitaryFold`.

### 10.1 Updated Leaf Table

| Node | Interface | Dependencies | Status | Next action |
|---|---|---|---|---|
| `all_slot_index_feeder` | full basis value of slot `s` is `s.val * 16` | basis-index arithmetic | compiled by `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`; retired | reuse only as support memory |
| `expanded_all_slots_feeder` | backend fold is the explicit seven weighted diagonal entries | index feeder; slot-zero expansion; selected-slot bridge | compiled by `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`; retired | rewrite the backend RHS before proving the active entry equality |
| `expanded_uncast_entry_leaf` | active uncast `[0,0]` entry equals the explicit seven-summand backend RHS | `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`; expanded all-slot feeder | open active smaller leaf | prove in `QuantumBlockEncoding/RobinMatrix.lean` or reduce to one named support/vanish/cancellation lemma |
| `active_prepared_entry_leaf` | active signal-zero entry equals the prepared sparse-register clean entry under the existing clean-column route | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H`; `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | open accepted smaller leaf | use only with the explicit `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` contract |
| `unitary_fold_leaf` | `FullUnitaryFold` | expanded uncast entry leaf or active/prepared entry leaf | open active mathematical leaf | close after one feeder is proved |

### 10.2 Next Lower Packet

The next Lean worker should edit only `QuantumBlockEncoding/RobinMatrix.lean`
and prove one theorem.  The preferred theorem is the expanded uncast
active-entry equality exposed by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`,
using `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` as the
backend RHS normal form.  The accepted alternative is
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
under the existing clean-column contract route.  Recomputing the all-slot
expansion, rediscovering bridge equivalences, or proving the raw `Coeff`
constructor equality is stale work.

No oracle, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, or external primitive flag is promoted by
this addendum.

## 11. Lower 1 Current-Run Addendum: Expanded RHS And Next Leaf

Created: 2026-06-10 13:05 JST for run
`20260610-124120-QBE-AUTO-002-cycle01`.

This addendum is natural-language proof architecture only.  It edits no Lean
source, changes no circuit, adds no assumptions, and promotes no semantic flag.
It reuses the full-unitary fold DAG above after lower 2 compiled
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.

### 11.1 Source Fragment Being Translated

The active source fragment is still the one-term Robin path:

| Source anchor | Fragment translated here | Lean interface | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ maps the clean sparse register to the uniform all-slot sum. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1098-1109`, Theorem `1 term robin` | theorem-facing block-encoding root with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$; still open. | backend expansion route feeding the theorem-facing product obligations | GHL-internal root |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the clean $\gamma_3$ boundary contribution is an all-slot sum; slot `2` is the focused displayed summand. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit keeps both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, and post-SWAP $(O_D^{BS})^\dagger`. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | GHL-internal transcript plus QBE-local guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean signal projection reads the signal-zero unitary entry before comparison with the encoded operator. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection/backend bridge |

### 11.2 Definitions Before Claims

Define the active uncast entry by:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3
```

Define `BackendFold` by:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define the expanded backend RHS to be the right-hand side exposed by:

```lean
oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3
```

It is the sum of seven weighted diagonal entries of
`oneTermRobinGamma3BoundarySevenGateMatrix_n3` at full-basis indices
`0`, `16`, `32`, `48`, `64`, `80`, and `96`, each multiplied by
`oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor`.

Define `FullUnitaryFold` by:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The current next Lean theorem should prove the expanded uncast entry equality
on the right side of:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3
```

### 11.3 Natural-Language Proof Of The Active Local Theorem

The active theorem is `FullUnitaryFold`: the full signal-zero unitary entry
equals `BackendFold`.

The compiled bridge
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
reduces the equivalent backend-expansion endpoint to one finite matrix-entry
claim:

```lean
ActiveEntry = ExpandedBackendRHS
```

The proof design for the Lean worker is:

1. Use the compiled source-side entry bridge
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3` and the
   uncast bridge already packaged in
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.
   This identifies the active signal-zero unitary entry with the uncast
   `[0,0]` entry of the seven-gate `evalGateMatrices` product.
2. Use `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` only
   as a RHS normal form.  It has already expanded `BackendFold`; it should not
   be reproved.
3. Prove the remaining finite matrix-entry equality between the uncast
   active entry and that expanded RHS.  This is QBE-local matrix semantics:
   it is not Shukla--Vedula, not LCU, not an oracle-contract theorem, and not
   a normalizer theorem.
4. Convert the proved expanded equality to
   `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
   by the `.2` direction of
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.
5. Convert the backend-expansion statement to `FullUnitaryFold` by the `.1`
   direction of
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

The accepted prepared alternative is narrower: under an explicit
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
a proof of
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
closes `FullUnitaryFold` through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.
This route must keep the `hUniform` contract visible and must not mark
$H_W^{(\kappa)}$ itself as formalized.

### 11.4 Seven-Slot Survive/Vanish Table

| Slot | Full-basis index | Current expanded RHS term | Survive/vanish status | Dependency class |
|---|---:|---|---|---|
| `0` | `0` | diagonal `[0,0]` of `oneTermRobinGamma3BoundarySevenGateMatrix_n3` times the projection factor | survives as the active diagonal diagnostic summand; no cancellation theorem | QBE-local matrix semantics |
| `1` | `16` | diagonal `[16,16]` times the projection factor | survives; no vanish theorem is compiled | QBE-local matrix semantics |
| `2` | `32` | selected branch diagonal, expressed through `oneTermRobinGamma3BoundaryPrefixSource_n3` | survives as the focused Eq. `ROBIN clarified` boundary summand | GHL-internal branch plus QBE-local matrix semantics |
| `3` | `48` | diagonal `[48,48]` times the projection factor | survives; no vanish theorem is compiled | QBE-local matrix semantics |
| `4` | `64` | diagonal `[64,64]` times the projection factor | survives; no vanish theorem is compiled | QBE-local matrix semantics |
| `5` | `80` | diagonal `[80,80]` times the projection factor | survives; no vanish theorem is compiled | QBE-local matrix semantics |
| `6` | `96` | diagonal `[96,96]` times the projection factor | survives; no vanish theorem is compiled | QBE-local matrix semantics |

No slot may be erased in the next proof unless the worker proves a named
matrix-entry, vanish, or cancellation lemma from the existing matrices.  The
source display selects slot `2` for the visible boundary branch, but the
source sum and the two sparse-preparation sides remain all-slot.

### 11.5 Proof-DAG Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `fig:1 term ROBIN`; indicator dagger bridge | compiled guard | middle/reviewer | Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`. |
| `hfree_backend_guard` | active seven-gate list; sparse-preparation absence proof | compiled guard | lower/middle | Reuse `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`; do not call the active seven-gate product the full Fig. 4 circuit. |
| `all_slot_index_feeder` | backend branch full-index definition | compiled; retired | lower 2 | Reuse `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`; do not reassign. |
| `expanded_all_slots_feeder` | all-slot index feeder; slot-zero expansion; selected-slot bridge | compiled; retired | lower 2 | Reuse `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` only as RHS normal form. |
| `expanded_uncast_entry_leaf` | expanded all-slot RHS; uncast backend-expansion bridge | open active smaller leaf | lower 2/refiner | Prove the right side of `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`. |
| `active_prepared_entry_feeder` | explicit `hUniform`; prepared sparse clean-entry bridges | open accepted smaller leaf | lower 2/refiner | Prove `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` only under the existing clean-column route. |
| `unitary_fold_leaf` | `expanded_uncast_entry_leaf` or `active_prepared_entry_feeder` | open active mathematical leaf | lower 2/refiner | Close `FullUnitaryFold`. |
| `backend_expansion_endpoint` | `unitary_fold_leaf`; compiled equivalence | open equivalent endpoint | lower 2/refiner | Close via `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`. |
| `raw_coeff_constructor_route` | deeply nested symbolic `Coeff` constructors | diagnostic/backlog | none | Do not assign; diagnostic theorems remain sorry-guarded. |

Next active leaf for the Lean worker:

```lean
-- the right side of
oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3
```

Equivalent recovery leaf:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Accepted prepared feeder:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

### 11.6 Ordered Lean Lemmas To Reuse

1. Active entry reductions:
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
   `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.

2. Backend RHS normal form:
   `blockExtractionBranchContributionSum`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.

3. Selected branch and slot guards:
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3`,
   `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.

4. Closure bridges:
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`.

5. Diagnostic-only memory:
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`,
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

### 11.7 Failure Analysis

The target is not mathematically wrong.  The failure mode is proof routing:
the all-slot RHS is now exposed, but the left-hand active product entry has
not been expanded to match it.

The old raw constructor route remains a bad implementation target because it
tries to prove a large symbolic `Coeff` equality directly and already has
recorded max-depth or resource failures.  The next proof should work through
the compiled uncast-entry equivalence or through the active/prepared entry
feeder under `hUniform`.

An arbitrary-`H` prepared equality would be too strong.  The prepared route is
faithful only when the existing clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` is kept
as an explicit external contract.

Reproving `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3` or
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` is stale
work.  Both are compiled support memory, not proof closure.

### 11.8 Handoff

Lower 1 added this current-run proof-DAG addendum.  It records
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` as compiled
and retired, keeps all seven sparse-slot RHS terms live, and names the next
Lean leaf as the expanded uncast active-entry equality exposed by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
or the active/prepared entry feeder under the existing `hUniform` route.  No
Lean source, oracle contract, normalizer, gate label, paper circuit, or
theorem-facing semantic flag was changed.

## 12. Lower 1 Current-Run Reuse Note: No Target Change

Created: 2026-06-10 13:16 JST for run
`20260610-125802-QBE-AUTO-002-cycle01`.

This note reuses the proof design in Section 11.  The selected theorem has
not changed since `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`
compiled.  The current lower packet should not rediscover the all-slot
expansion; it should use that theorem as the backend RHS normal form.

### 12.1 Source Fragment Being Translated

| Source anchor | Exact fragment or equation | Lean interface | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares the sparse register as the uniform all-slot sum. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the clean gamma_3 boundary term is an all-slot sparse sum with coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | the theorem-facing circuit contains both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, pre-SWAP $O_{D^T}^{BS}`, and post-SWAP $(O_D^{BS})^\dagger`. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | GHL-internal transcript plus QBE-local guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the clean signal block is read from the signal-zero unitary entry. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection/backend bridge |

### 12.2 Definitions And Active Local Proof

Define `ActiveEntry` as the uncast seven-gate entry:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3
```

Define `BackendFold` as:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define `ExpandedBackendRHS` as the right-hand side of
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`: seven
weighted diagonal entries of `oneTermRobinGamma3BoundarySevenGateMatrix_n3`
at full-basis indices `0`, `16`, `32`, `48`, `64`, `80`, and `96`.

The active smaller theorem is:

```lean
ActiveEntry = ExpandedBackendRHS
```

The natural-language proof route is:

1. Use
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
   as the typed wrapper for this equality.  This wrapper already handles the
   signal-entry uncast bridge and the statement-level conversion to the
   backend-expansion endpoint.
2. Rewrite the backend side only with
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.  This
   keeps every paper sparse slot visible.
3. Prove the remaining finite matrix-entry equality by expanding the active
   seven-gate product or by proving one named support, vanish, or cancellation
   lemma that feeds this equality directly.
4. Convert a proof of the expanded equality to
   `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
   by the `.2` direction of
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.
5. Convert the backend-expansion endpoint to `FullUnitaryFold` by the `.1`
   direction of
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

The accepted prepared alternative is unchanged: under
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
prove
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
and close the fold through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.

### 12.3 Survive And Vanish Status

| Slot | Full-basis index | Current term | Status | Justifying declaration |
|---|---:|---|---|---|
| `0` | `0` | diagonal `[0,0]` times projection factor | survives | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `1` | `16` | diagonal `[16,16]` times projection factor | survives; no vanish theorem | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `2` | `32` | selected gamma_3 branch diagonal times projection factor | survives as focused branch | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` |
| `3` | `48` | diagonal `[48,48]` times projection factor | survives; no vanish theorem | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `4` | `64` | diagonal `[64,64]` times projection factor | survives; no vanish theorem | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `5` | `80` | diagonal `[80,80]` times projection factor | survives; no vanish theorem | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `6` | `96` | diagonal `[96,96]` times projection factor | survives; no vanish theorem | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |

No current theorem justifies deleting slots `1`, `3`, `4`, `5`, or `6`.

### 12.4 Proof-DAG Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | source Fig. `fig:1 term ROBIN`; indicator dagger bridge | compiled | middle/reviewer | Reuse the theorem-facing gate-list guard. |
| `expanded_all_slots_feeder` | index feeder; slot-zero expansion; selected-slot bridge | compiled; retired | lower 2/middle | Use only as RHS normal form. |
| `expanded_uncast_entry_leaf` | expanded all-slot RHS; uncast backend-expansion bridge | open active smaller leaf | lower 2/refiner | Prove the right side of `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`. |
| `active_prepared_entry_feeder` | explicit `hUniform`; prepared clean-entry route | open accepted alternative | lower 2/refiner | Prove `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` only under the clean-column contract. |
| `unitary_fold_leaf` | `expanded_uncast_entry_leaf` or `active_prepared_entry_feeder` | open active root | lower 2/refiner | Close `FullUnitaryFold`. |
| `backend_expansion_endpoint` | `unitary_fold_leaf`; compiled equivalence | open equivalent endpoint | lower 2/refiner | Close via `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`. |
| `retired_routes` | branch-sum wrapper, raw `Coeff`, H-free diagnostic, compiled feeder rediscovery | stale or diagnostic | none | Do not assign. |

Next active leaf for the Lean worker:

```lean
-- right-hand proposition exposed by
oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3
```

### 12.5 Ordered Lean Lemmas To Reuse

1. `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`.
2. `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.
3. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`.
4. `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.
5. `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.
6. `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.
7. `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`, only for the prepared route under `hUniform`.

### 12.6 Failure Analysis

The target is mathematically plausible and still matches the paper route.  The
current obstruction is local finite matrix semantics: the active uncast entry
has not been expanded to the seven weighted diagonal terms.

The all-slot feeder does not prove any vanish or cancellation fact.  It only
exposes the backend RHS.  A future support lemma must be a real theorem about
the existing matrices.

The active seven-gate product is not the full theorem-facing Fig. 4 circuit,
because both $H_W^{(\kappa)}$ boundary gates are absent from that active list.
The guard `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` keeps
that distinction explicit.

The raw `Coeff` constructor route remains diagnostic/backlog because it has
known max-depth and resource failures.  The next worker should use the
expanded uncast wrapper or the prepared route under the explicit clean-column
contract.

### 12.7 Handoff

Lower 1 reused the existing full-unitary fold proof DAG for run
`20260610-125802-QBE-AUTO-002-cycle01`.  The selected theorem did not change:
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` is compiled
and retired, all seven backend RHS slots remain live, and the next Lean leaf
is the expanded uncast active-entry equality exposed by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
or the active/prepared entry feeder under the existing `hUniform` route.  No
Lean source, oracle contract, normalizer, gate label, paper circuit, or
semantic flag was changed.

## 13. Middle Current-Run Source-Prepared Feeder Addendum

Created: 2026-06-10 13:30 JST for run
`20260610-131957-QBE-AUTO-002-cycle01`.

The latest lower 2 Lean edit added:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3
```

This theorem is a proof-DAG alignment feeder.  It identifies
`SourcePreparedEntry`,

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

with the clean-entry equality for
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`.  It does not
prove that equality.

Current route:

1. Keep `hUniform :
   oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` as an
   explicit external cited contract.
2. Prove the prepared clean-entry equality, or prove `SourcePreparedEntry`
   directly.
3. Use
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
   to feed `FullUnitaryFold`.
4. Use the backend-expansion equivalence only after the fold or prepared-entry
   feeder is available.

Updated frontier:

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `prepared_clean_entry_equivalence` | prepared sparse matrix interface; active/prepared entry target | compiled feeder | lower 2/middle | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`; do not reassign it. |
| `active_prepared_entry_feeder` | explicit `hUniform`; prepared clean-entry equality | preferred active leaf | lower 2/refiner | Prove `SourcePreparedEntry` or the clean-entry equality it is equivalent to. |
| `unitary_fold_leaf` | `active_prepared_entry_feeder`; backend fold bridge | open dependent root | lower 2/refiner | Close through `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` after the feeder is proved. |
| `expanded_all_slots_feeder` | value, injective, and all-slot backend fold lemmas | compiled; retired | none | Use as backend RHS memory only. |
| `retired_routes` | branch-sum wrapper, H-free eval route, raw `Coeff`, column-`0` diagnostics, bridge rediscovery | stale or diagnostic | none | Do not assign. |

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU,
block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, oracle, or external
primitive flag is promoted by this addendum.

## 14. Lower 1 Current-Run Addendum: Source-Prepared Active/Prepared Entry

Created: 2026-06-10 13:31 JST for run
`20260610-131957-QBE-AUTO-002-cycle01`.

This addendum is natural-language proof architecture only. It changes no Lean
source, adds no hypothesis to a theorem-facing statement, changes no
normalizer, changes no circuit gate label, and promotes no semantic flag. It
updates the active leaf from the expanded H-free recovery route to the
source-prepared active/prepared entry route selected by the current directive.

### 14.1 Exact Source Fragment Or Equation

| Source anchor | Exact fragment being translated | Lean interface | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares the sparse register as $\kappa^{-1/2}\sum_s\ket{s}$. The dagger side supplies the matching clean bra amplitude in the prepared sandwich. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1098-1109`, Theorem `1 term robin` | The theorem-facing one-term Robin block-encoding remains the root. This packet only targets the local finite entry equality feeding it. | dependent route through `FullUnitaryFold`; final theorem-facing root remains open | GHL-internal root |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The clean $\gamma_3$ boundary branch is an all-slot sparse sum with coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3 H` | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The source circuit has both $H_W^{(\kappa)}$ sides around the active backend and keeps the explicit `U_indic^dagger` role. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | GHL-internal transcript plus QBE-local guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is read from the signal-zero entry before comparing with the encoded operator. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local finite projection/backend bridge |

### 14.2 Definitions Before Claims

Define `HUniform` for a fixed sparse-preparation matrix `H` by:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

This is an external cited contract for the clean column of
$H_W^{(\kappa)}$. It is not a Lean proof of the Shukla--Vedula preparation
circuit.

Define `PreparedCleanEntry(H)` by:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

Define `SourcePreparedEntry(H)` by:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The compiled feeder
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`
states:

```lean
SourcePreparedEntry(H) <-> PreparedCleanEntry(H)
```

Define `PreparedSandwichSum(H)` by:

```lean
oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H
```

The clean entry of the prepared sparse-register matrix is exactly
`PreparedSandwichSum(H)` by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.

Define `FullUnitaryFold` by:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

### 14.3 Natural-Language Proof Of The Active Local Theorem

The active local theorem is `SourcePreparedEntry(H)`, preferably stated with
the explicit route hypothesis:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement := by
  ...
```

The hypothesis `hUniform` is route information for the dependent fold. It
does not by itself prove the active/prepared composition equality.

The proof decomposition is:

1. Use Definition `def:block-encoding` through the existing Lean projection
   target to name the active side as
   `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`.
   The active-side source lemma is already packaged in
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`.
2. Use the prepared sparse-register matrix
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` as the source
   model of $H_W^{(\kappa)\dagger} U_{\gamma_3} H_W^{(\kappa)}$ on the sparse
   register. Its clean-clean entry is already identified with
   `PreparedSandwichSum(H)`.
3. Prove the missing QBE-local composition field:
   `PreparedCleanEntry(H)`. This is the statement that the active signal-zero
   entry equals the clean-clean entry of the prepared sparse-register sandwich
   matrix. It is not an oracle theorem and not an $H_W^{(\kappa)}$ circuit
   theorem.
4. Convert `PreparedCleanEntry(H)` to `SourcePreparedEntry(H)` by the reverse
   direction of
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`.
5. Under `hUniform`, convert `SourcePreparedEntry(H)` to `FullUnitaryFold`
   with `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.
   Internally, this uses
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3` to
   specialize every prepared sandwich summand to the corresponding backend
   contribution.

All seven sparse slots survive this route. The source display focuses the
boundary branch, but the source sum and the two $H_W^{(\kappa)}$ sides use the
whole sparse-slot family. Slots `1`, `3`, `4`, `5`, and `6` may be removed only
after a named Lean vanish or cancellation theorem proves that removal from the
existing matrices.

### 14.4 Prepared Slot Status

| Slot | Prepared-side term | Backend specialization under `hUniform` | Survive/vanish status | Dependency class |
|---|---|---|---|---|
| `0` | diagonal backend entry at full index `0`, multiplied by `H[0,0]` and `H^dagger[0,0]` | backend contribution slot `0` | survives; diagnostic slot, not source closure alone | QBE-local matrix semantics |
| `1` | diagonal backend entry at full index `16`, multiplied by clean-column factors | backend contribution slot `1` | survives; no vanish theorem | QBE-local matrix semantics |
| `2` | diagonal backend entry at full index `32`, multiplied by clean-column factors | selected $\gamma_3$ boundary contribution | survives as focused source branch | GHL-internal plus QBE-local matrix semantics |
| `3` | diagonal backend entry at full index `48`, multiplied by clean-column factors | backend contribution slot `3` | survives; no vanish theorem | QBE-local matrix semantics |
| `4` | diagonal backend entry at full index `64`, multiplied by clean-column factors | backend contribution slot `4` | survives; no vanish theorem | QBE-local matrix semantics |
| `5` | diagonal backend entry at full index `80`, multiplied by clean-column factors | backend contribution slot `5` | survives; no vanish theorem | QBE-local matrix semantics |
| `6` | diagonal backend entry at full index `96`, multiplied by clean-column factors | backend contribution slot `6` | survives; no vanish theorem | QBE-local matrix semantics |

### 14.5 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing transcript keeps both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` role | source Fig. `fig:1 term ROBIN`; indicator bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window and this packet | `python3 tools/qbe.py check` | compiled guard |
| `active_gate_absence_guard` | active seven-gate list is not the full theorem-facing circuit because it omits both sparse-preparation boundary gates | active gate labels | lower/middle | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | this packet | same gate | compiled guard |
| `source_uniform_contract` | clean column of `H` has amplitude `sqrt_kappa_inv` on every `s : Fin 7` | Eq. `arbitrary sparcity`; cited state-preparation contract | external/middle | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | proof obligations and cited-results memory | same gate | contract-only; not formalized |
| `prepared_matrix_clean_entry` | prepared sparse-register matrix clean-clean entry equals the prepared sandwich fold | prepared matrix definition | lower/middle | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3` | conversion window | same gate | compiled |
| `prepared_sum_backend_specialization` | under `HUniform`, the prepared sandwich fold equals the backend branch fold | `source_uniform_contract`; all-slot contribution formula | lower/middle | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3` | conversion window | same gate | compiled conditional |
| `prepared_clean_entry_equivalence` | `SourcePreparedEntry(H)` is equivalent to `PreparedCleanEntry(H)` | prepared circuit matrix interface; generic entry target | lower/middle | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3` | middle packet and this packet | same gate | compiled feeder; retired as target |
| `active_prepared_entry_feeder` | active signal-zero entry equals prepared sparse-register clean-clean entry | active entry source; prepared sparse matrix object | lower 2/refiner | target: `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`, or the equivalent prepared clean-entry equality | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | preferred active leaf |
| `unitary_fold_leaf` | `FullUnitaryFold` | `active_prepared_entry_feeder`; `source_uniform_contract`; prepared sum specialization | lower 2/refiner | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes the future proof | this packet | same three gates | open dependent root |
| `backend_expansion_endpoint` | backend-expansion formulation equivalent to `FullUnitaryFold` | `unitary_fold_leaf`; compiled equivalence | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | conversion window | same three gates | open equivalent endpoint |
| `expanded_uncast_recovery_leaf` | H-free active `[0,0]` entry equals expanded seven-slot backend RHS | expanded all-slot feeder; uncast backend bridge | lower 2 only if reassigned | `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` | older sections of this file | same three gates | recovery only; not preferred |
| `retired_or_diagnostic_routes` | branch-sum wrapper, full-index/injective/all-slot feeders, raw `Coeff`, H-free eval route, column-`0` diagnostics, bridge rediscovery | stale feeders or sorry-guarded diagnostics | none | names recorded in proof-obligations ledger | this packet | none | do not assign |

Next active leaf for the Lean worker:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement := by
  ...
```

Strictly smaller leaf that feeds it directly:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
        oneTermRobinGamma3BoundarySparseCleanIndex_n3
        oneTermRobinGamma3BoundarySparseCleanIndex_n3 := by
  ...
```

The second theorem closes the first by
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H).2`.

### 14.6 Ordered Lean Lemmas To Reuse

1. Source-prepared objects and indices:
   `oneTermRobinGamma3BoundarySparseCleanIndex_n3`,
   `oneTermRobinGamma3BoundarySparseSlotIndex_n3`,
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`.

2. Prepared sandwich matrix layer:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`.

3. Uniform-column specialization layer:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedCircuitSparseMatrix_n3`.

4. Active/prepared target layer:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_interfaceStatement_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3`.

5. Dependent closure layer:
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_matrix_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`.

6. Guard and recovery memory:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`,
   `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.

### 14.7 Failure Analysis

The current target is not mathematically wrong. It is the exact remaining
QBE-local composition field: the active signal-zero entry must be related to
the prepared clean-clean entry of the source-prepared sparse-register sandwich
matrix.

The `HUniform` contract is necessary for the dependent fold route, but it does
not prove the active/prepared entry equality. It only turns the prepared
sandwich fold into the backend branch fold after the active/prepared equality
has supplied the prepared clean entry.

The compiled theorem
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`
is not closure. It only lets the Lean worker choose between proving the
generic `PreparedCircuitEntryTarget` statement and proving the displayed
prepared clean-entry equality.

The expanded all-slot theorem remains useful recovery memory, but it is no
longer the preferred lower leaf. Reproving full-index, injectivity, all-slot
fold expansion, branch-sum wrappers, or bridge equivalences is stale work.

No source-supported proof currently deletes any sparse slot. The next proof
must keep all seven prepared summands unless it proves a named vanish or
cancellation lemma from the existing matrices.

The active seven-gate product must not be reported as the full Fig. 4 circuit.
`oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` records that the
two $H_W^{(\kappa)}$ boundary gates are absent from that active list, so the
faithful route must remain source-prepared.

### 14.8 Handoff

Lower 1 appended this source-prepared proof-DAG addendum for run
`20260610-131957-QBE-AUTO-002-cycle01`. The preferred next Lean leaf is
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
under the visible `HUniform` route, or the strictly smaller prepared
clean-entry equality equivalent to it by
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`.
The dependent root remains `FullUnitaryFold`, reached through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.
Expanded all-slot/full-index/injective feeders, branch-sum wrappers, H-free
eval routes, raw `Coeff` equalities, column-`0` diagnostics, and bridge
rediscovery stay retired. No Lean source, oracle contract, normalizer, paper
circuit, gate label, or semantic flag was changed.

## 15. Lower 1 Postscript: Prepared-Side Feeder Accepted

Created: 2026-06-10 13:37 JST for run
`20260610-131957-QBE-AUTO-002-cycle01`.

After Section 14 was appended, lower 2 compiled one strict prepared-side
feeder:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3
```

For fixed `H` and
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
this theorem proves that the `preparedEntry` cached in
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H` is the backend
branch fold. It uses the prepared clean-entry lemma and the all-slot
uniform-column specialization. It does not prove that the active entry equals
that prepared entry.

The proof-DAG consequence is narrow:

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `prepared_entry_backend_fold_feeder` | `HUniform`; prepared matrix clean entry; prepared sum specialization | compiled by `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`; retired as target | lower 2/middle | Reuse as the prepared-side normal form. |
| `active_prepared_entry_feeder` | active signal-zero entry; prepared entry normal form | still open preferred leaf | lower 2/refiner | Prove `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`, equivalently prove the active entry equals the now-normalized prepared/backend side. |
| `unitary_fold_leaf` | `active_prepared_entry_feeder`; `HUniform` | open dependent root | lower 2/refiner | Close through `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` only after the active/prepared equality is proved. |

The next Lean worker should not reprove the prepared side. The remaining
mathematical content is the active finite composition equality: the signal-zero
active entry must equal the source-prepared clean entry, with the prepared side
now available as the backend fold under `hUniform`.

## 16. Lower 1 Addendum: Active Side After Prepared-Side Feeder

Created: 2026-06-10 13:48 JST for run
`20260610-133742-QBE-AUTO-002-cycle01`.

Scope: natural-language proof architecture only. This packet edits no Lean
source, adds no assumption, changes no normalizer or circuit, and promotes no
semantic flag.

### 16.1 Source Fragment Being Translated

| Source anchor | Fragment being translated | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ maps the clean sparse register to $\kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$. This is the only source input used to normalize the prepared side. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | The theorem target is a one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. This remains a root target, not a closed theorem. | GHL-internal root | theorem-facing route remains open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary branch has coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and is summed over sparse slots. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing circuit contains the two $H_W^{(\kappa)}$ sides and the explicit `U_indic^dagger` role. The active seven-gate backend is only the inner component. | GHL-internal transcript plus QBE-local guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is obtained by projecting the ancillas to zero and comparing the resulting system entry. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

### 16.2 Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`.

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `Target(H)` as:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H
```

Define `SourcePreparedEntry(H)` as:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

By `PreparedCircuitEntryTarget.entryEqualityStatement`, this proposition is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).activeEntry =
  (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Define `BackendFold` as:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define `FullUnitaryFold` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

### 16.3 Natural-Language Proof Design

The active local theorem is `SourcePreparedEntry(H)`, usually carried with
`hUniform : HUniform` because the dependent root needs the prepared-side
normal form. The equality itself is the finite composition field: the active
signal-zero entry of the seven-gate backend must equal the clean-clean entry
of the source-prepared sparse-register sandwich.

The active side is already named. In `Target(H)`, the cached `activeEntry` is
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`,
with source supplied by
`oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3`. This side is
QBE-local matrix semantics and does not use `hUniform`.

The prepared side is now normalized. The cached `preparedEntry` is the clean
entry of `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`. The
clean-entry lemma
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3` rewrites
that entry to the prepared sandwich fold. The contract `hUniform` rewrites the
two $H_W^{(\kappa)}$ clean-column factors in every sparse slot, and
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3` turns
the prepared sandwich fold into `BackendFold`. Lower 2 has already packaged
these steps as:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3
```

The remaining proof must therefore produce the active finite-composition
equality. A Lean worker can prove `SourcePreparedEntry(H)` directly, or prove
the strictly smaller displayed equality:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

After `SourcePreparedEntry(H)` is proved, the dependent fold follows by:

```lean
oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3
```

with inputs `H`, `hUniform`, and the future entry proof. The backend-expansion
endpoint is then reachable only through the already compiled equivalence
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

### 16.4 Survive/Vanish Status After The Feeder

| Term family | Prepared-side status | Active-side status | Dependency class |
|---|---|---|---|
| Sparse slots `0` through `6` | All survive in the prepared sandwich and backend fold under `hUniform`. | The active entry is not yet expanded through the source-prepared field. | external-cited-contract plus QBE-local matrix semantics |
| Slot `2` | Survives as the focused displayed $\gamma_3$ boundary contribution. | It is not enough by itself to prove `SourcePreparedEntry(H)`. | GHL-internal plus QBE-local matrix semantics |
| Slots `1`, `3`, `4`, `5`, `6` | Survive as backend summands unless a future named Lean theorem proves a vanish or cancellation fact. | No active-side vanish theorem exists. | QBE-local matrix semantics |
| Slot `0` | Survives as a backend summand and remains diagnostic memory for `[0,0]` expansion. | Column-`0` diagnostics do not close the source-prepared theorem. | QBE-local diagnostic |

No term is currently justified as zero. The next proof must either keep all
seven prepared summands or prove a named local vanish or cancellation lemma
from the existing matrices.

### 16.5 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 transcript keeps both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` role | source Fig. `fig:1 term ROBIN`; indicator bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window and this packet | `python3 tools/qbe.py check` | compiled guard |
| `source_uniform_contract` | clean column of `H` has amplitude `sqrt_kappa_inv` for every sparse slot | Eq. `arbitrary sparcity`; Shukla--Vedula state-preparation contract | external/middle | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | proof obligations and cited-results memory | same gate | contract-only |
| `active_entry_source` | cached active entry is the signal-zero entry of the current active backend matrix | finite block-extraction target | lower/middle | `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3`; `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3` | this packet | same gate | compiled source |
| `prepared_clean_entry` | cached prepared entry is the source-prepared sparse-matrix clean entry | prepared sparse-register matrix definition | lower/middle | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3` | this packet | same gate | compiled |
| `prepared_entry_backend_fold_feeder` | under `hUniform`, cached prepared entry equals `BackendFold` | `source_uniform_contract`; prepared clean-entry lemma | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | Section 15 and this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | compiled feeder; retired as lower target |
| `source_prepared_entry` | active signal-zero entry equals the source-prepared clean entry | `active_entry_source`; `prepared_clean_entry`; finite composition semantics | lower 2/refiner | target `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet and middle packet `source-prepared-active-entry-after-prepared-side-feeder-middle-packet-20260610-1342.md` | same three gates | preferred active leaf |
| `unitary_fold_leaf` | `FullUnitaryFold` | `source_prepared_entry`; `source_uniform_contract`; prepared-side normal form | lower 2/refiner | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes the future proof | this packet | same three gates | open dependent root |
| `backend_expansion_endpoint` | backend-expansion formulation of the same fold | `unitary_fold_leaf`; compiled equivalence | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | conversion window | same three gates | open equivalent endpoint |
| `retired_or_diagnostic_routes` | branch-sum wrapper, source-prepared clean-entry alias, H-free `evalWith`, column-`0` diagnostics, raw `Coeff`, full-index/injective/all-slot feeders, and bridge rediscovery | stale feeders or sorry-guarded diagnostics | none | names recorded in proof-obligations ledger | this packet | none | do not assign |

Next active leaf for a Lean worker:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement := by
  ...
```

Strictly smaller active-side leaf:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry := by
  ...
```

The smaller leaf closes the preferred target by unfolding
`PreparedCircuitEntryTarget.entryEqualityStatement` for
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H`. The hypothesis
`hUniform` is present so the worker can reuse the prepared-side normal form
without changing the route; it must not be treated as a new oracle proof.

### 16.6 Ordered Lean Lemmas To Reuse

1. Generic prepared-entry interface:
   `PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3`.

2. Active entry source:
   `oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3`,
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_activeCircuitMatrix_n3`,
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
   `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`.

3. Prepared entry source:
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3`.

4. Prepared-side backend normal form:
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.

5. Dependent fold and endpoint bridges:
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`.

### 16.7 Failure Analysis

The current target is mathematically aligned with the source-prepared route.
It is the missing QBE-local finite composition theorem, not a new scientific
assumption.

The hypothesis `hUniform` does not prove `SourcePreparedEntry(H)`. It only
specializes the prepared side after the active/prepared equality supplies the
prepared clean entry.

Reproving
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`
is stale work. That theorem is a compiled prepared-side normal form.

Proving the H-free fold directly is an equivalent recovery route under
`hUniform`, but it must be returned through
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`
or `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.
The raw `Coeff` diagnostic theorem
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` remains
`sorry`-guarded and must not be treated as the source closure route.

No source line justifies deleting sparse slots from the prepared sum. The
displayed slot-`2` boundary contribution is part of the all-slot source sum,
not a replacement for it.

### 16.8 Handoff

Lower 1 appended this active-side addendum for run
`20260610-133742-QBE-AUTO-002-cycle01`. The prepared side is already compiled
and retired via
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.
The next Lean leaf remains `SourcePreparedEntry(H)`, namely
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`,
or the strictly smaller active-side equality against the cached
`preparedEntry`. `hUniform` stays an external clean-column contract used only
to normalize the prepared side and feed `FullUnitaryFold` through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.
No Lean source, oracle contract, normalizer, paper circuit, gate label, or
semantic flag was changed.

## 17. Lower 1 Postscript: Active Uncast Entry Frontier

Created: 2026-06-10 14:11 JST for run
`20260610-135339-QBE-AUTO-002-cycle01`.

Scope: natural-language proof architecture only. This postscript edits no Lean
source, changes no circuit, adds no assumption, and promotes no semantic flag.

### 17.1 Source Fragment Being Translated

| Source anchor | Fragment being translated | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ gives the all-slot clean-column amplitudes for the sparse-register preparation. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary expression is an all-slot sparse sum; slot `2` is the displayed focused branch, not the whole fold. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing circuit keeps both $H_W^{(\kappa)}$ sides and the explicit `U_indic^dagger` role. The active uncast product is only the inner seven-gate entry. | GHL-internal transcript plus QBE-local guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is read from the signal-zero entry before comparison with the encoded operator. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

### 17.2 Definitions Before Claims

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `ActiveUncastToPreparedEntry` as:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Define `SourcePreparedEntry` as:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Define `FullUnitaryFold` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled theorem
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`
identifies `SourcePreparedEntry` with `ActiveUncastToPreparedEntry`. The
compiled theorem
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`
normalizes only the prepared side under `HUniform`.

### 17.3 Natural-Language Proof Design

The active local problem is the finite matrix-entry comparison between the
uncast active seven-gate entry and the clean-clean entry of the prepared
source-side sparse-register sandwich.

The currently safe proof route is:

1. Use `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`
   only as a wrapper/cast bridge. It removes the block-extraction wrapper and
   dimension cast from `SourcePreparedEntry`.
2. Analyze the uncast active entry as a seven-gate product. Existing
   diagnostics show that the diagonal entry of
   `oneTermRobinGamma3BoundarySevenGateMatrix_n3` at the active clean index has
   two surviving internal paths through full indices `96` and `97`; the
   compiled theorem is
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`.
3. Keep the prepared side as the clean-clean entry of
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`. This entry is
   an all-slot sandwich sum depending on the column of `H`.
4. Apply `HUniform` only when normalizing the prepared side to `BackendFold`,
   via `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.
   This contract is cited external memory for $H_W^{(\kappa)}$; it is not a
   proof of the state-preparation primitive.
5. After `ActiveUncastToPreparedEntry` is available in a source-faithful form,
   recover `SourcePreparedEntry` through the wrapper bridge and then recover
   `FullUnitaryFold` through
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.

### 17.4 Survive, Vanish, And Cancellation Status

| Term family | Current Lean evidence | Status for the next leaf |
|---|---|---|
| Active seven-gate diagonal path through full index `96` | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | Survives in the current `evalWith` diagnostic for `SevenGateMatrix[0,0]`; it carries `boundary_cos_half_0_0`. |
| Active seven-gate diagonal path through full index `97` | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | Survives in the same diagnostic; it carries `boundary_sin_half_0_0`. |
| Other intermediate active product paths in the column-`0` diagnostic | support lemmas consumed by `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` | Vanish only inside that diagnostic proof. No theorem yet lifts this to the full uncast prepared-entry equality. |
| Backend/prepared sparse slot `0` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` | Survives as the active column-`0` backend summand with projection amplitude factor. |
| Backend/prepared sparse slot `2` | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | Survives as the focused displayed $\gamma_3$ boundary summand. It does not replace the all-slot sum. |
| Backend/prepared sparse slots `1`, `3`, `4`, `5`, `6` | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` | Survive as explicit summands. No compiled vanish or cancellation theorem erases them. |
| Cancellation between active paths and prepared slots | none | Open. A future smaller leaf may prove a named cancellation or support theorem, but it must be derived from the existing matrices. |

### 17.5 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 transcript exposes both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` role | source Fig. `fig:1 term ROBIN`; indicator bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window and this packet | `python3 tools/qbe.py check` | compiled guard |
| `prepared_entry_backend_fold_feeder` | cached prepared entry equals `BackendFold` under `HUniform` | prepared sparse matrix clean-entry lemma; all-slot clean-column contract | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform` | Section 15 and this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | compiled feeder; retired |
| `active_wrapper_cast_feeder` | `SourcePreparedEntry` is equivalent to the uncast active entry against cached prepared entry | signal-unitary entry source; dimension-cast removal | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H` | middle uncast packet and this postscript | same three gates | compiled feeder; retired |
| `active_two_path_diagnostic` | `SevenGateMatrix[0,0]` has two surviving evaluated paths through indices `96` and `97` | prefix/suffix support lemmas | lower/middle | `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`; `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | this packet | same three gates | compiled diagnostic; not closure |
| `active_uncast_to_prepared_entry_leaf` | uncast active seven-gate entry equals the cached prepared entry | active product semantics; prepared clean entry; `HUniform` if the prepared side is normalized | lower 2/refiner | target `ActiveUncastToPreparedEntry` | this packet | same three gates | active leaf, but see failure analysis below |
| `source_prepared_entry_leaf` | `SourcePreparedEntry` | `active_uncast_to_prepared_entry_leaf`; wrapper/cast bridge | lower 2/refiner after active leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | same three gates | open dependent target |
| `unitary_fold_leaf` | `FullUnitaryFold` | `source_prepared_entry_leaf`; `HUniform`; prepared-side normal form | lower 2/refiner after source-prepared entry | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes the future proof | this packet | same three gates | open dependent root |
| `retired_routes` | branch-sum wrapper, source-prepared clean-entry alias, H-free `evalWith`, column-`0` proof as theorem closure, raw `Coeff`, all-slot feeders, and bridge rediscovery | stale or diagnostic routes | none | names recorded in proof-obligations ledger | this packet | none | do not assign |

Next active leaf for a Lean worker should be stated with the source-prepared
contract visible:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3 =
        (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry := by
  ...
```

A strictly smaller acceptable leaf is a named support, vanish, or cancellation
lemma that feeds this equality directly. A lemma that only restates the
wrapper bridge or the prepared-side backend fold is stale.

### 17.6 Ordered Lean Lemmas To Reuse

1. Wrapper and source entry:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
   `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`.

2. Prepared-side normal form:
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.

3. Active product diagnostics:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`.

4. Backend all-slot support:
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.

5. Dependent closure:
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

### 17.7 Failure Analysis

The no-hypothesis version of `ActiveUncastToPreparedEntry` over arbitrary
`H : Matrix 8 8 Coeff` is too strong as a mathematical theorem. The left side
is the active seven-gate product entry and has no `H` parameter. The right side
is the clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`, whose definition
contains the entries `H (sparseSlotIndex s) sparseCleanIndex` and the
transpose-style dagger entries of `H`.

Therefore a Lean worker should not try to prove the arbitrary-`H` equality
without a contract or a fixed source-preparation matrix. The faithful route is
to keep `HUniform` visible, or to prove a smaller active support/cancellation
lemma that can later be combined with
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3
H hUniform`. This does not add a new assumption; it is the existing external
contract from Eq. `arbitrary sparcity`.

The active two-path diagnostic is useful but not enough. It describes the
slot-`0` column-`0` seven-gate diagonal entry after `Coeff.evalWith`; it does
not prove the source-prepared all-slot equality, and it does not justify
discarding sparse slots `1`, `2`, `3`, `4`, `5`, or `6`.

### 17.8 Handoff

Lower 1 appended this active-uncast postscript for run
`20260610-135339-QBE-AUTO-002-cycle01`. The prepared-side normal form and
active wrapper/cast bridge are compiled and retired. The remaining useful leaf
is the active finite product equality against the prepared entry, but the
arbitrary-`H` version is mathematically too strong unless the source
`HUniform` contract or a fixed source-preparation matrix is visible. The next
Lean worker should prove a contract-visible active equality or one named
support, vanish, or cancellation lemma feeding it directly. `SourcePreparedEntry`,
`FullUnitaryFold`, backend expansion, and the theorem-facing one-term Robin
block-encoding theorem remain open.

## 18. Lower 1 Postscript: Slot-Zero Support Accepted

Created: 2026-06-10 14:33 JST for run
`20260610-141642-QBE-AUTO-002-cycle01`.

Scope: natural-language proof architecture only. This postscript edits no Lean
source, changes no circuit, adds no assumption, and promotes no semantic flag.

### 18.1 Source Fragment Being Translated

| Source anchor | Fragment being translated | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the all-slot sparse register with amplitude $1/\sqrt{\kappa}$ on each slot. This remains the source of `HUniform`. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Theorem `1 term robin` | The final theorem claims a $(\mathcal{N}_D\mathcal{N}_f\kappa,\dots,0)$ block-encoding, but the current local target is only one matrix-entry feeder. | GHL-internal theorem statement plus QBE-local route | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ term is an all-slot sparse sum. Slot `2` is the displayed focused boundary branch; slot `0` is now known to vanish after evaluation in the active/backend support route; slots `1`, `3`, `4`, `5`, and `6` are still not erased by Lean. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The theorem-facing circuit keeps both $H_W^{(\kappa)}$ boundary gates around the inner seven-gate active product. The active uncast entry is only the inner seven-gate `[0,0]` entry. | GHL-internal transcript plus QBE-local guard | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal entry must pass through the source-prepared entry equality before it can be used as a block-encoding witness. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`; `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` |

### 18.2 Definitions Before Claims

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `ActiveUncastToPreparedEntry` as:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Define `SourcePreparedEntry` as:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Define `FullUnitaryFold` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Define `SlotZeroVanishSupport` as the pair of evaluated facts:

```lean
oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env
oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env
```

`SlotZeroVanishSupport` is a support feeder. It is not
`ActiveUncastToPreparedEntry`, not `SourcePreparedEntry`, and not
`FullUnitaryFold`.

### 18.3 Natural-Language Proof Design

The active local theorem remains `ActiveUncastToPreparedEntry`, preferably with
`HUniform` visible when the prepared side is normalized. The left side is the
uncast active seven-gate `[0,0]` product entry. The right side is the cached
clean-clean entry of the prepared sandwich
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`.

The compiled slot-`0` support facts reduce one branch of the all-slot backend
comparison after coefficient evaluation. The theorem
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env` proves that the
active seven-gate `[0,0]` entry evaluates to zero. The theorem
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env`
uses the slot-`0` backend summand formula to transport that zero to the
slot-`0` backend contribution.

This does not close the prepared-entry comparison. The prepared side still
normalizes to the complete seven-slot fold through
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3
H hUniform`. Slot `2` is the displayed $\gamma_3$ boundary branch, and the
remaining slots `1`, `3`, `4`, `5`, and `6` require named support, vanish, or
cancellation lemmas before the active equality can be proved by branch
partition.

The proof route for the next Lean worker is therefore:

1. Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`
   only to move between `SourcePreparedEntry` and `ActiveUncastToPreparedEntry`.
2. Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`
   only under `HUniform` to replace the cached prepared entry by the seven-slot
   backend fold.
3. Reuse `SlotZeroVanishSupport` to remove the slot-`0` evaluated summand.
4. Prove one new support, vanish, or cancellation lemma for a remaining slot
   family, or prove the whole `HUniform`-visible active equality if the existing
   support facts already suffice.
5. Recover `SourcePreparedEntry` through the wrapper bridge, then recover
   `FullUnitaryFold` through
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`.

### 18.4 Survive, Vanish, And Cancellation Status

| Term family | Current Lean evidence | Expected status for the next leaf |
|---|---|---|
| Active seven-gate `[0,0]` entry | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env` | Vanishes after `Coeff.evalWith`; retired as a lower target. |
| Backend slot `0` contribution | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env` | Vanishes after `Coeff.evalWith`; retired as a lower target. |
| Backend slot `2` contribution | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | Survives as the displayed $\gamma_3$ boundary branch unless a later source-faithful cancellation theorem says otherwise. |
| Backend slots `1`, `3`, `4`, `5`, `6` | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` exposes them as summands | Open. Each needs a named support, vanish, or cancellation lemma before a branch-partition proof can erase or combine it. |
| Prepared clean entry | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform` | Equals the all-slot backend fold under `HUniform`; this feeder is compiled and retired. |
| Full active/prepared equality | no proof yet | Open. Prove `ActiveUncastToPreparedEntry` with `HUniform` visible, or prove one strict smaller remaining-slot lemma. |

### 18.5 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 transcript includes both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` role | source Fig. `fig:1 term ROBIN`; indicator self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | compiled guard |
| `prepared_entry_backend_fold_feeder` | cached prepared entry equals seven-slot backend fold under `HUniform` | prepared clean-entry bridge; all-slot clean-column contract | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform` | Sections 16-18 | same gate | compiled feeder; retired |
| `active_wrapper_cast_feeder` | `SourcePreparedEntry` is equivalent to `ActiveUncastToPreparedEntry` | signal-unitary entry source; dimension-cast removal | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H` | Sections 17-18 | same gate | compiled feeder; retired |
| `slot0_vanish_support` | active `[0,0]` and backend slot-`0` contributions evaluate to zero | two-path active expansion; slot-`0` backend summand formula | none | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | this postscript and middle packet `active-side-slot-zero-support-middle-packet-20260610-1420.md` | same gate | compiled support; retired |
| `remaining_slot_support_leaf` | one named support, vanish, or cancellation fact for slots `1`, `3`, `4`, `5`, or `6` that feeds the active equality | all-slot backend fold expansion; selected slot bridge; slot-`0` vanish support | lower 2/refiner | no selected name yet | this postscript | same gate | next acceptable active leaf |
| `active_uncast_to_prepared_entry_leaf` | uncast active seven-gate `[0,0]` entry equals cached prepared entry | remaining slot support/cancellation facts; prepared cached entry; `HUniform` when normalizing prepared side | lower 2/refiner | target `ActiveUncastToPreparedEntry` | this postscript | same gate | preferred active mathematical leaf |
| `source_prepared_entry_leaf` | `SourcePreparedEntry` | `active_uncast_to_prepared_entry_leaf`; wrapper/cast bridge | lower 2/refiner after active leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this postscript | same gate | open dependent target |
| `unitary_fold_leaf` | `FullUnitaryFold` | `SourcePreparedEntry`; `HUniform`; prepared-entry backend-fold feeder | lower 2/refiner after source-prepared entry | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes the future proof | this postscript | same gate | open dependent root |
| `retired_routes` | branch-sum wrapper, source-prepared clean-entry alias, H-free `evalWith`, raw `Coeff`, all-slot fold expansion as a target, slot-`0` support, and bridge rediscovery | stale or support-only routes | none | names recorded in conversion window and proof-obligation ledger | this postscript | none | do not assign |

Next active leaf for a Lean worker:

```lean
theorem <new_remaining_slot_or_active_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3 =
        (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry := by
  ...
```

A smaller acceptable theorem should mention which of slots `1`, `3`, `4`,
`5`, or `6` it removes or combines, and should feed the displayed equality
directly.

### 18.6 Ordered Lean Lemmas To Reuse

1. Source and wrapper bridges:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
   `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
   `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`.

2. Prepared-side normal form under the external contract:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.

3. Slot-`0` support already compiled:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`.

4. Remaining all-slot backend structure:
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
   `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`.

5. Dependent closure after the active leaf:
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

### 18.7 Failure Analysis

The no-hypothesis arbitrary-`H` theorem
`ActiveUncastToPreparedEntry` is still too strong as a raw mathematical
statement. The left side has no `H`, while the right side is the clean-clean
entry of a prepared sandwich built from `H`. A faithful theorem must either
thread the existing `HUniform` contract through the prepared side or prove a
smaller `H`-independent support/cancellation lemma that is later combined with
the prepared-side normal form.

Slot-`0` vanish does not imply the all-slot fold vanishes. It removes only the
slot-`0` evaluated summand. Slot `2` remains the displayed boundary branch from
Eq. `ROBIN clarified`, and slots `1`, `3`, `4`, `5`, and `6` remain present in
the all-slot sum until Lean proves their support status.

The current target is not mathematically wrong if `HUniform` is kept explicit.
The wrong route is to prove the arbitrary-`H` equality directly, to reuse the
raw `Coeff` diagnostic theorem as closure, or to delete sparse slots because
the source display focuses on the boundary branch.

### 18.8 Handoff

Lower 1 appended this slot-zero support postscript for run
`20260610-141642-QBE-AUTO-002-cycle01`. Slot `0` is now compiled evaluated
support and retired via
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` and
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`.
The next Lean worker should prove `ActiveUncastToPreparedEntry` with
`HUniform` visible, or one strict remaining-slot support, vanish, or
cancellation lemma for slots `1`, `3`, `4`, `5`, or `6` that feeds it
directly. `SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, and the
one-term Robin block-encoding theorem remain open. No Lean source, oracle
contract, normalizer, paper circuit, gate label, or semantic flag changed.

### 18.9 Gate Result

The required commands were run after this Markdown-only update:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

All three failed while building `QuantumBlockEncoding.RobinMatrix`. The shared
Lean blocker is an unsolved goal at `QuantumBlockEncoding/RobinMatrix.lean:6855:54`,
where Lean must relate an `evalGateMatrices` fold containing an identity tail
to the explicitly grouped seven-gate `oneTermRobinGamma3BoundarySevenGateMatrix_n3`
entry after `Coeff.evalWith`. This lower-1 packet did not edit Lean, so the
failure is recorded as a gate blocker for the next Lean implementation worker,
not as a promoted theorem or a change in the scientific target.

## 19. Post-Slot-One Support Frontier

Created: 2026-06-10 JST.

Scope: natural-language proof architecture only. This postscript reflects the
middle packet for run `20260610-144151-QBE-AUTO-002-cycle01` and edits no Lean
source. I used the proof-DAG route rather than broad proof search because the
active theorem now depends on slot-by-slot support facts.

### 19.1 Source Fragment Being Translated

| Source anchor | Fragment being translated | Dependency class | Lean anchor |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares the sparse register uniformly over $s = 0,\ldots,\kappa-1$. This is the only source for the two sparse-register projection amplitudes. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Theorem `1 term robin` | The root claim is the one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. | GHL-internal root | still open; no final block flag promoted |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary branch is an all-slot sum. Slot `2` is the focused displayed branch in the current finite witness, but the paper expression still quantifies over every sparse slot. | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The active product is the inner seven-gate backend framed by the prepared $H_W^{(\kappa)}$ sides in the theorem-facing circuit. The latest support fact concerns the post-SWAP dagger side of $(O_D^{BS})^\dagger$ for slot `1`. | GHL-internal transcript plus QBE-local support | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is read by projecting the ancillas to zero; this is why the active clean-clean entry must be compared with the prepared clean-clean entry before the block route can close. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

### 19.2 Definitions Before Claims

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `ActiveUncastToPreparedEntry` as:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Define `BackendContribution(s)` by:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s
```

Define `FullUnitaryFold` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The prepared-side normal form is already compiled:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3
  H hUniform
```

The wrapper/cast bridge is already compiled:

```lean
oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H
```

### 19.3 Natural-Language Proof Of The Active Local Theorem

The active theorem should be proved by comparing the active seven-gate
clean-clean entry with the prepared sparse-register sandwich entry. Under
`HUniform`, the prepared entry is the seven-slot backend fold. Therefore the
active-side work is a finite matrix-entry proof: expand the seven-gate active
entry and match it against the slot fold without changing the source circuit.

The compiled all-slot fold expansion sends sparse slot `s : Fin 7` to full
basis index `16 * s.val`. The current support state is:

| Slot | Full index | Expected status in this frontier | Lean evidence |
|---|---:|---|---|
| `0` | `0` | Vanishes after `Coeff.evalWith`; retired as support. | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` |
| `1` | `16` | Partial support mismatch is compiled, but full branch vanish is still open. The next useful leaf is to thread the zero dagger-after-SWAP factor through the whole slot-`1` diagonal branch. | `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` |
| `2` | `32` | Survives as the selected $\gamma_3$ boundary branch unless a later source-faithful cancellation theorem says otherwise. | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` |
| `3` | `48` | Open. No vanish or cancellation theorem is compiled. | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` |
| `4` | `64` | Open. No vanish or cancellation theorem is compiled. | same all-slot expansion |
| `5` | `80` | Open. No vanish or cancellation theorem is compiled. | same all-slot expansion |
| `6` | `96` | Open. No vanish or cancellation theorem is compiled. | same all-slot expansion |

The proof obligation is not to delete the nonzero-looking slots from the
paper expression. The obligation is to prove, from the concrete matrices,
which slot paths actually reach the clean projected row and which do not.
Slot `1` now has enough local path evidence to attempt a full evaluated
branch-vanish lemma.

### 19.4 Proof-DAG Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `fig:1 term ROBIN`; indicator dagger bridge | compiled guard | none | Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and keep both $H_W^{(\kappa)}$ sides visible. |
| `prepared_entry_backend_fold_feeder` | `HUniform`; prepared clean-entry bridge | compiled feeder; retired | none | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform`. |
| `active_wrapper_cast_feeder` | signal-unitary entry bridge; cast removal | compiled feeder; retired | none | Reuse `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H`. |
| `slot0_vanish_support` | two-path active expansion; function-oracle zero entries | compiled support; retired | none | Reuse only as support memory. |
| `slot1_support_mismatch` | branch full-index map; forward sparse-access image; SWAP image; dagger entry | compiled support; not full vanish | none | Reuse `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`. |
| `slot1_full_vanish_leaf` | `slot1_support_mismatch`; slot-`1` branch diagonal expansion; projection amplitude factor | next preferred smaller leaf | lower 2/refiner | Prove an evaluated slot-`1` diagonal or backend-contribution vanish theorem. |
| `remaining_slot_support_leaf` | all-slot expansion; support facts for slots `0` and `1`; selected slot `2` | open alternative smaller leaf | lower 2/refiner | Prove one strict support, vanish, or cancellation lemma for slots `3`, `4`, `5`, or `6`. |
| `active_uncast_to_prepared_entry_leaf` | prepared backend fold under `HUniform`; all required active support/cancellation lemmas | preferred mathematical leaf, still open | lower 2/refiner | Prove `ActiveUncastToPreparedEntry` with the existing `HUniform` route visible. |
| `source_prepared_entry_leaf` | `active_uncast_to_prepared_entry_leaf`; wrapper/cast bridge | open dependent target | lower 2 after active leaf | Recover `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`. |
| `unitary_fold_leaf` | `SourcePreparedEntry`; `HUniform`; prepared-side normal form | open dependent root | lower 2 after source entry | Recover through `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`. |

Next active leaf for a Lean worker:

```lean
theorem <slot_one_branch_vanish_name>
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨1, by native_decide⟩) = 0 := by
  ...
```

An even smaller acceptable feeder is the diagonal factor version:

```lean
theorem <slot_one_diagonal_vanish_name>
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        (⟨16, by native_decide⟩ : Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
        (⟨16, by native_decide⟩ : Fin oneTermRobinGamma3BoundaryPrefixDim_n3)) = 0 := by
  ...
```

This smaller theorem feeds the backend contribution by
`oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` or the
slot-specialized unfolding of
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

### 19.5 Ordered Lean Lemmas To Reuse

1. Slot indexing:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`.

2. All-slot summand exposure:
   `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.

3. Compiled support:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`,
   `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`.

4. Prepared-side contract route:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.

5. Closure bridges after the active leaf:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

### 19.6 Failure Analysis

The compiled slot-`1` theorem is only a path-support mismatch. It proves that
the slot-`1` path reaches a column where the transpose-style dagger row is
zero, but it does not yet prove that the complete slot-`1` diagonal branch or
backend contribution evaluates to zero. Treating it as a full branch vanish
would overstate the Lean result.

The arbitrary-`H` equality remains a bad route. The right side is a prepared
sandwich entry depending on `H`; the source-backed route supplies information
about it only through `HUniform`. A Lean worker who cannot keep `HUniform`
visible should instead prove an `H`-independent slot support lemma, not force
the arbitrary-`H` theorem.

Slot `2` must not be erased merely because slot `0` vanishes or slot `1` has a
support mismatch. It is the selected boundary branch tied to Eq. `ROBIN
clarified`. If later Lean work proves all other slots vanish while slot `2`
still survives, middle should audit whether the active row/branch target is
aligned with the source branch before declaring a theorem failure.

### 19.7 Handoff

Lower 1 appended this post-slot-one support postscript for run
`20260610-144151-QBE-AUTO-002-cycle01`. The current frontier is still
`ActiveUncastToPreparedEntry`, but the next smaller Lean leaf should be a full
slot-`1` evaluated branch vanish/cancellation theorem using
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`, or one strict
support/vanish/cancellation lemma for slots `3`, `4`, `5`, or `6`. Slot `0`
vanish and slot `1` dagger-after-SWAP support are retired support facts.
`SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, and the one-term
Robin theorem remain open. No Lean source, oracle contract, normalizer, gate
label, paper circuit, or semantic flag changed.

## 20. Post-Remaining-Slots Support Frontier

Created: 2026-06-10 JST.

Scope: natural-language proof architecture only. This postscript reflects the
middle packet for run `20260610-150313-QBE-AUTO-002-cycle01`. It edits no Lean
source, adds no hypothesis, and promotes no oracle, preparation, projection,
block-correctness, or final-extraction flag.

### 20.1 Source Fragment Being Translated

| Source anchor | Fragment being translated | Dependency class | Lean anchor |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}$ prepares a uniform sparse-slot superposition. In the current route this appears only as the explicit clean-column contract for the prepared side. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Theorem `1 term robin` | The final theorem claims a one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. The current local target is only a finite matrix-entry feeder. | GHL-internal root plus QBE-local backend route | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes a future active/prepared proof |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary branch is an all-slot sparse sum. Slot `2` is the focused selected branch in the finite witness; nonselected slots may be removed only by Lean-proved support, vanish, or cancellation facts. | GHL-internal branch expression plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The seven-gate backend contains the pre-SWAP sparse access, SWAP, and post-SWAP $(O_D^{BS})^\dagger$ cleanup. The current slot facts are about the post-SWAP dagger support, not about a replacement circuit. | GHL-internal transcript plus QBE-local support | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`; `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean block is read from a signal-zero matrix entry. The current route compares that active clean entry with the prepared sparse-register clean entry before the block theorem can close. | QBE-local finite projection/backend bridge | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry`; `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` |

### 20.2 Definitions Before Claims

Define `HUniform` as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Define `ActiveUncastToPreparedEntry` as:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Define the slot-`1` backend branch contribution by:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3
  ⟨1, by native_decide⟩
```

Unfolding the branch contribution gives the diagonal factor at full index `16`
times the sparse projection amplitude:

```lean
Coeff.mul
  (oneTermRobinGamma3BoundarySevenGateMatrix_n3
    (⟨16, by native_decide⟩ :
      Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
    (⟨16, by native_decide⟩ :
      Fin oneTermRobinGamma3BoundaryPrefixDim_n3))
  oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor
```

The compiled support fact for slot `1` is:

```lean
oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3
```

It says that full index `16` maps through forward sparse access to `112`,
through SWAP to `14`, and then the transpose-style dagger matrix has zero in
the relevant row-column entry. This is support evidence for the diagonal
factor, not yet a theorem about the evaluated whole branch contribution.

### 20.3 Natural-Language Proof Of The Active Local Theorem

The active theorem remains `ActiveUncastToPreparedEntry`. Under `HUniform`,
the prepared cached entry is already the seven-slot backend fold by
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`.
The active-side work is therefore to show that the concrete seven-gate active
entry has exactly the same evaluated slot contributions as that prepared fold.

The current proof should not try to prove the whole equality at once. It should
first close the next missing branch-level leaf:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
```

The mathematical argument for that leaf is:

1. Slot `1` has full backend index `16`, by the branch-index map.
2. The slot-`1` branch contribution is the seven-gate diagonal entry at
   `(16,16)` multiplied by the projection amplitude, by the branch
   contribution definition.
3. The compiled path-support fact says that the slot-`1` clean path reaches a
   post-SWAP column where the $(O_D^{BS})^\dagger$ row for the original slot
   has coefficient zero.
4. A new diagonal-factor lemma should thread this zero dagger entry through the
   concrete seven-gate product and prove:

   ```lean
   Coeff.evalWith env
     (oneTermRobinGamma3BoundarySevenGateMatrix_n3
       (⟨16, by native_decide⟩ :
         Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
       (⟨16, by native_decide⟩ :
         Fin oneTermRobinGamma3BoundaryPrefixDim_n3)) = 0
   ```

5. Once the diagonal factor evaluates to zero, the full slot-`1` backend branch
   contribution evaluates to zero because `Coeff.evalWith` maps multiplication
   to multiplication and the branch contribution is a product with that
   diagonal factor.

This route keeps the source all-slot expression intact. It removes only the
slot contribution whose zero has been proved by the concrete matrix semantics.

### 20.4 Term Status For The Seven-Slot Fold

| Slot | Full index | Current term status | Lean evidence | Dependency class |
|---|---:|---|---|---|
| `0` | `0` | Vanishes after `Coeff.evalWith`; retired. | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | QBE-local finite support/evaluation |
| `1` | `16` | Next preferred smaller leaf. Support mismatch is compiled, but full evaluated branch vanish is open. | `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`; proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` | QBE-local finite branch evaluation |
| `2` | `32` | Survives as the focused selected $\gamma_3$ boundary branch. | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | GHL-internal selected branch plus QBE-local semantics |
| `3` | `48` | Has dagger-after-SWAP zero support, but no full branch vanish theorem. Retired as support-only for this packet. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support |
| `4` | `64` | Same as slot `3`: support-only, not branch vanish. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support |
| `5` | `80` | Same as slot `3`: support-only, not branch vanish. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support |
| `6` | `96` | Same as slot `3`: support-only, not branch vanish. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support |

### 20.5 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 gate order, including both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` role | source Fig. `fig:1 term ROBIN`; indicator bridge | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | earlier conversion-window packets | already gated | compiled guard |
| `prepared_entry_backend_fold_feeder` | cached prepared entry equals the backend fold under `HUniform` | sparse-preparation clean-column contract; prepared clean-entry bridge | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform` | Sections 15-19 | already gated | compiled feeder; retired |
| `active_wrapper_cast_feeder` | `SourcePreparedEntry` is equivalent to the uncast active entry against the cached prepared entry | signal-entry source; cast removal | none | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3 H` | Sections 17-19 | already gated | compiled feeder; retired |
| `slot0_eval_vanish` | slot `0` backend contribution evaluates to zero | active column-`0` vanish; slot-`0` contribution formula | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env` | Section 18 | already gated | compiled support/evaluation; retired |
| `slot1_support_mismatch` | slot `1` path reaches zero dagger support after SWAP | full index `16`; forward sparse image `112`; SWAP image `14`; dagger entry zero | none | `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | Section 19 | already gated | compiled support; not branch vanish |
| `remaining_slots_support_mismatch` | slots `3` through `6` have zero dagger support after SWAP | full indices `48`, `64`, `80`, `96`; concrete sparse/SWAP/dagger images | none | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | `post-remaining-slots-support-middle-packet-20260610-1515.md` | already gated | compiled support; retired |
| `slot1_diagonal_factor_leaf` | evaluated seven-gate diagonal factor at `(16,16)` is zero | `slot1_support_mismatch`; concrete seven-gate matrix expansion | lower 2/refiner | proposed `oneTermRobinGamma3BoundarySevenGateSlotOneDiagonalEval_zero_n3 env` | this postscript | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next strict feeder if branch proof is too large |
| `slot1_full_vanish_leaf` | evaluated slot-`1` backend branch contribution is zero | `slot1_diagonal_factor_leaf`; branch contribution unfolding | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | this postscript | same three gates | next preferred smaller leaf |
| `active_uncast_to_prepared_entry_leaf` | uncast active seven-gate `[0,0]` entry equals the cached prepared entry | prepared backend-fold feeder; slot vanish/cancellation facts; selected branch formula | lower 2/refiner | target `ActiveUncastToPreparedEntry` | proof-obligation ledger and this postscript | same three gates | preferred active mathematical leaf |
| `source_prepared_entry_leaf` | active/prepared entry equality | `active_uncast_to_prepared_entry_leaf`; active wrapper/cast feeder | lower 2 after active leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | proof-obligation ledger | same three gates | open dependent target |
| `unitary_fold_leaf` | full signal-zero unitary entry equals seven-slot backend fold | `source_prepared_entry_leaf`; `HUniform`; prepared-side normal form | lower 2 after source entry | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes future proof | proof blueprint | same three gates | open dependent root |

Next active Lean leaf:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨1, by native_decide⟩) = 0 := by
  ...
```

Strict feeder if that theorem is still too large:

```lean
theorem oneTermRobinGamma3BoundarySevenGateSlotOneDiagonalEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        (⟨16, by native_decide⟩ :
          Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
        (⟨16, by native_decide⟩ :
          Fin oneTermRobinGamma3BoundaryPrefixDim_n3)) = 0 := by
  ...
```

### 20.6 Ordered Lean Lemmas To Reuse

1. Branch index and selected-slot facts:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`.

2. Backend contribution exposure:
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`,
   `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

3. Existing evaluated vanish/support:
   `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`,
   `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`,
   `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

4. Prepared-side and active-wrapper route:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`.

5. Closure bridges after the active leaf:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.

### 20.7 Failure Analysis

The current target is mathematically well routed, but the support facts must
not be overstated. `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`
and `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`
are path-support statements. They do not by themselves rewrite a
`oneTermRobinGamma3BoundarySevenGateMatrix_n3` diagonal entry, and they do not
prove that a backend branch contribution evaluates to zero.

The likely missing Lean interface is a small product-entry lemma that connects
the zero dagger-after-SWAP coefficient to the evaluated seven-gate diagonal
factor for a fixed slot. For this packet, the useful fixed slot is slot `1` at
full index `16`. Proving another support-only lemma for slots `3` through `6`
is stale because the corresponding support facts are already compiled and
retired.

The route must keep `HUniform` visible only when it uses the prepared cached
entry. The slot-`1` branch vanish theorem itself should be independent of an
arbitrary `H`; it is a concrete seven-gate/backend contribution fact. If a
Lean proof starts requiring a stronger hypothesis on `H`, it is proving the
wrong leaf.

### 20.8 Handoff

Lower 1 appended this post-remaining-slots support postscript for run
`20260610-150313-QBE-AUTO-002-cycle01`. The active mathematical leaf remains
`ActiveUncastToPreparedEntry`; the next smaller Lean leaf is the full
slot-`1` evaluated backend branch vanish/cancellation theorem
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env`,
or the strict diagonal-factor feeder at full index `16`.
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` is
compiled support for slots `3` through `6`, retired, and not a branch-vanish
theorem. `SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, and the
one-term Robin theorem remain open. No Lean source, oracle contract,
normalizer, gate label, paper circuit, or semantic flag changed.

## 21. Post-Slot-One Evaluated Remaining-Slots Frontier

This postscript is the narrow current-run addendum requested after
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`
compiled. It supersedes Section 20 only for dynamic lower-agent scheduling.
It does not change the source theorem, the circuit transcript, oracle
contracts, normalizer, or the prepared $H_W^{(\kappa)}$ contract route.

### 21.1 Definitions First

`ActiveUncastToPreparedEntry` is the proposition

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

`FullUnitaryFold` is the proposition

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

### 21.2 Slot Status

| Slot | Full index | Current term status | Lean evidence | Dependency class |
|---|---:|---|---|---|
| `0` | `0` | Vanishes after `Coeff.evalWith`; retired. | `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | QBE-local finite support/evaluation |
| `1` | `16` | Full evaluated backend contribution vanishes; retired. | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | QBE-local finite branch evaluation |
| `2` | `32` | Survives as the focused selected $\gamma_3$ boundary branch. | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | GHL-internal selected branch plus QBE-local semantics |
| `3` | `48` | Next preferred smaller leaf: prove full evaluated vanish or cancellation, not another support-only fact. | proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`, or a full-index `48` diagonal-factor lemma feeding it | QBE-local finite branch evaluation |
| `4` | `64` | Has support-only mismatch; full evaluated branch vanish/cancellation remains open. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support, not closure |
| `5` | `80` | Has support-only mismatch; full evaluated branch vanish/cancellation remains open. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support, not closure |
| `6` | `96` | Has support-only mismatch; full evaluated branch vanish/cancellation remains open. | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | QBE-local finite support, not closure |

### 21.3 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `slot1_full_vanish_leaf` | slot-`1` backend branch contribution evaluates to zero | Section 20 support route and evaluated branch expansion | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env` | this postscript | already gated | compiled feeder; retired |
| `remaining_slots_support_mismatch` | slots `3` through `6` have zero dagger support after SWAP | full indices `48`, `64`, `80`, `96`; concrete sparse/SWAP/dagger images | none | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | Section 20 | already gated | compiled support; retired; not full branch vanish |
| `slot3_diagonal_factor_leaf` | evaluated seven-gate diagonal factor at full index `48` is zero or cancels as required by the branch formula | slot `3` support mismatch; full-index map; seven-gate branch contribution unfolding | lower 2/refiner | proposed strict feeder, name to be chosen in `QuantumBlockEncoding/RobinMatrix.lean` | this postscript | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active smaller leaf if full branch theorem is too large |
| `slot3_full_vanish_leaf` | evaluated slot-`3` backend branch contribution is zero or cancels | `slot3_diagonal_factor_leaf`; branch contribution formula | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env` | this postscript | same three gates | next preferred smaller leaf |
| `active_uncast_to_prepared_entry_leaf` | uncast seven-gate `[0,0]` entry equals the cached prepared entry | prepared backend-fold feeder; active wrapper/cast bridge; selected slot `2`; remaining evaluated vanish/cancellation facts | lower 2/refiner | target `ActiveUncastToPreparedEntry` | conversion window and proof-obligation ledger | same three gates | preferred active mathematical leaf |
| `source_prepared_entry_leaf` | active/prepared entry equality | `active_uncast_to_prepared_entry_leaf`; active wrapper/cast feeder | lower 2 after active leaf | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | proof-obligation ledger | same three gates | open dependent target |
| `unitary_fold_leaf` | full signal-zero unitary entry equals the seven-slot backend branch fold | `source_prepared_entry_leaf`; `HUniform`; prepared-side normal form | lower 2 after source entry | `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` consumes a future proof | proof blueprint | same three gates | open dependent root |

### 21.4 Lower-Agent Packet

Lower 1 should not restart the Fig. 4 transcript audit. The source-facing
transcript guard, explicit `U_indic^dagger` role, and both
$H_W^{(\kappa)}$ prepared sides remain compiled guards. Lower 1 should use
this Section 21 table as the proof map for the remaining-slots evaluated
frontier.

Lower 2 may edit only `QuantumBlockEncoding/RobinMatrix.lean`. The preferred
implementation target is

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3
```

with parameter `env : String -> Rat`, or a strict full-index `48`
diagonal-factor lemma that directly feeds that theorem. Lower 2 may instead
prove `ActiveUncastToPreparedEntry` directly if the prepared cached-entry
route is available.

### 21.5 Retired Routes

The following targets are stale for lower work: the branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery, prepared-side backend fold,
active wrapper/cast removal, all-slot fold expansion, slot-`0` vanish,
slot-`1` support mismatch, slot-`1` evaluated vanish, and the slots `3`
through `6` support-only mismatch theorem.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this postscript.

### 21.6 Lower 1 Proof-Architecture Note For Slot 3

Created: 2026-06-11 19:33 JST for run
`20260611-191349-QBE-AUTO-002-cycle01`.

This note reuses the Section 21 frontier. The selected theorem name has not
changed. The exact source fragment being translated remains Eq.
`ROBIN clarified`, especially the $\gamma_3$ line in `main.tex:1111-1119`,
with the $H_W^{(\kappa)}$ uniform sparse-register preparation from
`main.tex:948-955`, the Fig. `1 term ROBIN` gate order from
`main.tex:1122-1164`, and the block-projection convention from
`main.tex:2027-2035`.

Status clarification after the lower-1 gate run: the shared worktree now
contains a Lean implementation of
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`
and the private diagonal-factor lemma named below. This lower-1 packet did not
author that Lean edit; the proof route below records the mathematical
decomposition and the gates at the end of this run compiled the shared
worktree with that theorem present.

For slot `3`, define

```lean
slot3 := (⟨3, by native_decide⟩ : Fin 7)
row48 := (⟨48, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
```

The compiled full-index map gives
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 slot3 = row48`.
The compiled support-only fact
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`
records the finite path `48 -> 16 -> 2` and the zero dagger entry from row
`48` at post-SWAP column `2`. This fact is not itself a full branch vanish
theorem, because the seven-gate product still has to propagate support through
the prefix matrix, `O_f`, SWAP, and the dagger matrix.

Natural-language local proof for the next Lean leaf:

1. Prove a private diagonal-factor lemma
   `oneTermRobinGamma3BoundarySevenGateSlotThreeEval_zero_n3 env` stating
   that `Coeff.evalWith env (oneTermRobinGamma3BoundarySevenGateMatrix_n3
   row48 row48) = 0`.
2. Mirror the compiled slot-`1` proof. For the prefix column `48`, the
   `Ry_boundary` step exposes the adjacent column `49`; the forward
   `O_D^BS` image sends `48` to `16` and `49` to `17`. Thus the four-gate
   prefix has evaluated support only at rows `16` and `17`.
3. For the suffix row `48`, the dagger support is only at column `16` because
   `bandedSparseAccessPaperImage p 48 = 16`. The two suffix entries needed
   against prefix rows `16` and `17` reduce to `O_f` entries from the SWAP
   preimage `2`; both `O_f[2,16]` and `O_f[2,17]` are zero by the executable
   function-oracle matrix. This is the finite evaluated cancellation that the
   support-only theorem points to.
4. Conclude the public branch theorem by unfolding
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, rewriting the
   slot-`3` full index to `row48`, and simplifying `Coeff.evalWith` of the
   product using the diagonal-factor zero:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨3, by native_decide⟩) = 0 := by
  unfold oneTermRobinGamma3BoundaryBackendBranchContribution_n3
  rw [show oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3
        ⟨3, by native_decide⟩ = row48 from by native_decide]
  simp [oneTermRobinGamma3BoundarySevenGateSlotThreeEval_zero_n3 env]
```

The placeholder name `row48` in the sketch should be a private abbreviation in
`QuantumBlockEncoding/RobinMatrix.lean`, following the existing row-`16`
slot-`1` proof style.

Updated proof-DAG delta:

| Node | Dependencies | Status | Owner | Next route |
|---|---|---|---|---|
| `slot1_full_vanish_leaf` | slot-`1` diagonal support chain | compiled, retired | none | Reuse only as a proof pattern. |
| `remaining_slots_support_mismatch` | full indices `48`, `64`, `80`, `96`; sparse/SWAP/dagger images | compiled support, retired | none | Do not reassign as closure. |
| `slot3_prefix_support_leaf` | indicator, `O_DT^S`, `Ry_boundary`, `O_D^BS`; values `48 -> 16`, `49 -> 17` | present in shared worktree after lower-1 gate run | lower 2/shared | Review as part of the slot-3 Lean patch. |
| `slot3_suffix_zero_leaf` | dagger row `48` support at column `16`; SWAP value `16 -> 2`; zero `O_f[2,16]` and `O_f[2,17]` | present in shared worktree after lower-1 gate run | lower 2/shared | Review as part of the slot-3 Lean patch. |
| `slot3_diagonal_factor_leaf` | `slot3_prefix_support_leaf`; `slot3_suffix_zero_leaf` | present in shared worktree after lower-1 gate run | lower 2/shared | Review `oneTermRobinGamma3BoundarySevenGateSlotThreeEval_zero_n3 env`. |
| `slot3_full_vanish_leaf` | `slot3_diagonal_factor_leaf`; branch contribution unfolding | present in shared worktree after lower-1 gate run | lower 2/shared | Review `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`. |
| `active_uncast_to_prepared_entry_leaf` | slot vanish/cancellation facts and prepared-side backend fold | preferred mathematical leaf | lower 2/refiner | Attempt directly only if the prepared cached-entry route is available. |

Ordered Lean lemmas to reuse before adding any helper:

1. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`.
2. `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.
3. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`.
4. `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.
5. `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`.
6. `GHL2025.swapOracleMatrix_eq_image`.
7. `GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image`.

Failure analysis: the current target is mathematically plausible and source
faithful. The risk is only proof granularity. A support-only theorem for slot
`3` through slot `6` is stale, and a raw `Coeff` constructor equality is the
wrong route. If the slot-`3` diagonal-factor proof becomes too large, lower 2
should stop after one of `slot3_prefix_support_leaf` or `slot3_suffix_zero_leaf`
as a compiled strict feeder, not broaden the theorem or promote an oracle
contract.

Verifier feedback for this lower-1 packet:

| Field | Value |
|---|---|
| `leaf` | `slot3_diagonal_factor_leaf -> oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `not_run_no_lean_edit` |
| `lean_build_ok` | `not_run_no_lean_edit` |
| `finite_matrix_ok` | `partial_support_values_checked_by_existing_Lean_and_read_only_eval` |
| `block_entry_ok` | `false_open` |
| `ancilla_cleanup_ok` | `false_contract_only` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove slot-3 evaluated diagonal factor at full index 48, then unfold the slot-3 backend contribution` |

### 21.7 Post-Slot-3 Frontier: Slot 4 Evaluated Vanish

Created: 2026-06-11 19:52 JST for run
`20260611-193425-QBE-AUTO-002-cycle01`.

This postscript is the narrow lower-1 update after
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`
compiled. Slot `3` and the full-index `48` diagonal-factor route are now
retired. The active smaller Lean leaf is slot `4` full evaluated vanish, or
one strict full-index `64` feeder that directly proves it.

#### 21.7.1 Source Fragment

| Source anchor | Fragment being translated | Lean-facing object | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares an all-slot sparse-register average. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary term is an all-slot sum; slot `2` is the selected displayed summand, while nonselected slots must be proved zero or cancelling by finite matrix semantics. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | GHL-internal plus QBE-local semantic bridge |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The seven active backend gates remain `U_indic`, `O_{D^T}^S`, `R_y`, pre-SWAP `O_D^{BS}`, `O_f`, SWAP, and post-SWAP `(O_D^{BS})^dagger`, with the theorem-facing $H_W^{(\kappa)}$ sides outside this local leaf. | `oneTermRobinGamma3BoundarySevenGateMatrix_n3`; `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | GHL-internal transcript plus QBE-local matrix semantics |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block eventually reads the signal-zero unitary entry; this local packet only removes one nonselected branch summand feeding that fold. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection backend |

#### 21.7.2 Definitions Before Claims

For the next Lean worker, define the slot and rows by the existing full-index
map:

```lean
slot4 := (⟨4, by native_decide⟩ : Fin 7)
row64 := (⟨64, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
row65 := (⟨65, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
row32 := oneTermRobinGamma3BoundaryPrefixSource_n3
row33 := oneTermRobinGamma3BoundaryPrefixRow33_n3
row4 := (⟨4, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
```

Let `Prefix` be `oneTermRobinGamma3BoundaryPrefixMatrix_n3`, the product
`O_D^BS * Ry_boundary * O_DT^S * U_indic`. Let `Suffix` be
`oneTermRobinGamma3BoundarySuffixMatrix_n3`, the product
`(O_D^BS)^dagger * SWAP * O_f`. Let `U` be
`oneTermRobinGamma3BoundarySevenGateMatrix_n3 = Suffix * Prefix`.

The active local theorem should be:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨4, by native_decide⟩) = 0
```

The strict smaller feeder should be:

```lean
private theorem oneTermRobinGamma3BoundarySevenGateSlotFourEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3 row64 row64) = 0
```

#### 21.7.3 Natural-Language Proof

The full-index map gives `oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3
slot4 = row64`. Therefore the slot-`4` backend contribution is the diagonal
entry `U[row64,row64]` multiplied by the already fixed sparse projection
amplitude factor. It is enough to prove that the evaluated diagonal entry is
zero.

Expand `U[row64,row64]` as the matrix product
`sum_q Suffix[row64,q] * Prefix[q,row64]`. The prefix support calculation is
the slot-`3` pattern shifted from full index `48` to full index `64`.
The first two gates keep support on column `64`; the boundary rotation exposes
only rows `64` and `65`; the forward sparse-access image sends `64` to `32`
and `65` to `33`. Thus `Prefix[q,row64]` evaluates to zero unless
`q = row32` or `q = row33`.

It remains to show that the suffix kills those two possible rows. The dagger
row `64` has support only at column `32`, because
`bandedSparseAccessPaperImage p 64 = 32`. The two suffix entries reduce to
the two `OfSwap` entries `OfSwap[row32,row32]` and `OfSwap[row32,row33]`.
The SWAP row `32` has preimage `4`, and the executable function oracle gives
`O_f[row4,row32] = 0` and `O_f[row4,row33] = 0`. Hence both suffix entries
evaluate to zero, so every path in the product expansion is zero.

The compiled support theorem
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`
confirms the finite clean-path mismatch for slot `4`
(`64 -> 32 -> 4`, with the dagger entry at post-SWAP column `4` equal to
zero), but it is not itself a branch vanish theorem. The Lean proof should use
it only as orientation; the closure step is the evaluated prefix/suffix product
argument above.

#### 21.7.4 Proof-DAG Table

| Node | Dependencies | Status | Owner | Next route |
|---|---|---|---|---|
| `slot3_full_vanish_leaf` | full-index `48` support chain; branch contribution unfolding | compiled; retired | none | Reuse only as a proof pattern. |
| `slot4_support_mismatch_memory` | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`; values `64 -> 32 -> 4` | compiled support; retired | none | Do not assign as closure. |
| `slot4_prefix_col64_support_leaf` | `U_indic`, `O_DT^S`, `Ry_boundary`, forward `O_D^BS`; images `64 -> 32` and `65 -> 33` | active strict feeder | lower 2/refiner | Prove prefix column `64` has evaluated support only at rows `32` and `33`. |
| `slot4_suffix_row64_zero_leaf` | dagger row `64` support at column `32`; SWAP preimage `4`; zero `O_f[4,32]` and `O_f[4,33]` | active strict feeder | lower 2/refiner | Prove suffix row `64` kills columns `32` and `33`. |
| `slot4_diagonal_factor_leaf` | `slot4_prefix_col64_support_leaf`; `slot4_suffix_row64_zero_leaf`; `Matrix.evalWith_mul_eq_zero_of_all_paths_zero` | next active leaf if public theorem is too large | lower 2/refiner | Prove `oneTermRobinGamma3BoundarySevenGateSlotFourEval_zero_n3 env`. |
| `slot4_full_vanish_leaf` | `slot4_diagonal_factor_leaf`; branch contribution unfolding; full-index map | preferred smaller leaf | lower 2/refiner | Prove `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env`. |
| `active_uncast_to_prepared_entry_leaf` | slots `0`, `1`, `3`, and future remaining-slot vanish/cancellation facts; prepared backend-fold feeder | preferred mathematical leaf, still open | lower 2/refiner | Attempt directly only if the prepared cached-entry route is ready. |
| `source_prepared_entry_leaf` | `active_uncast_to_prepared_entry_leaf`; active wrapper/cast bridge | open dependent target | later lower 2 | Close `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`. |
| `unitary_fold_leaf` | `source_prepared_entry_leaf`; `HUniform`; prepared backend-fold normal form | open dependent root | later lower 2 | Close `FullUnitaryFold` through existing compiled bridges. |

Next active leaf for the Lean worker:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env
```

Acceptable strict feeder:

```lean
oneTermRobinGamma3BoundarySevenGateSlotFourEval_zero_n3 env
```

#### 21.7.5 Ordered Lean Lemmas

Reuse existing declarations first:

1. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`.
2. `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.
3. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`.
4. `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`.
5. `GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image`.
6. `GHL2025.swapOracleMatrix_eq_image`.
7. `GHL2025.swapOracleImage_self_inverse`.

Suggested new private helpers, in dependency order:

1. `oneTermRobinGamma3BoundaryPrefixRow4_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow64_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow65_n3`.
2. `oneTermRobinGamma3BoundaryIndicatorCol64_support_n3`.
3. `oneTermRobinGamma3BoundaryODTSCol64_support_n3`.
4. `oneTermRobinGamma3BoundaryDUPrefixCol64Support_n3`.
5. `oneTermRobinGamma3BoundaryRyCol64_support_n3`.
6. `oneTermRobinGamma3BoundaryRDUPrefixCol64Support_n3`.
7. `oneTermRobinGamma3BoundaryODBSCol64_support_n3` and
   `oneTermRobinGamma3BoundaryODBSCol65_support_n3`, using executable values
   `bandedSparseAccessPaperImage p 64 = 32` and
   `bandedSparseAccessPaperImage p 65 = 33`.
8. `oneTermRobinGamma3BoundaryPrefixCol64Support_n3`, showing prefix support
   only at rows `32` and `33`.
9. `oneTermRobinGamma3BoundarySwapRow32_support_n3`, using
   `swapOracleImage p 32 = 4`.
10. `oneTermRobinGamma3BoundaryOfSwapRow32Col32_zero_n3` and
    `oneTermRobinGamma3BoundaryOfSwapRow32Col33_zero_n3`, using executable
    zeroes `functionOraclePaperMatrix p row4 row32 = 0` and
    `functionOraclePaperMatrix p row4 row33 = 0`.
11. `oneTermRobinGamma3BoundaryDaggerRow64_support_n3`, using
    `bandedSparseAccessPaperImage p 64 = 32`.
12. `oneTermRobinGamma3BoundarySuffixRow64Col32_zero_n3` and
    `oneTermRobinGamma3BoundarySuffixRow64Col33_zero_n3`.
13. `oneTermRobinGamma3BoundarySevenGateSlotFourEval_zero_n3`.
14. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3`.

#### 21.7.6 Failure Analysis

The selected theorem is mathematically well routed and faithful to the source:
Eq. `ROBIN clarified` keeps all sparse slots in the $\gamma_3$ sum, and this
leaf removes one nonselected slot by evaluated finite matrix semantics. It
does not change the circuit, the oracle contracts, the normalizer, or the
theorem statement.

The main risk is proof granularity. Reusing
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` as
though it proves the full branch contribution would be a route error; it is
support-only memory. If the slot-`4` product proof becomes too large, lower 2
should stop after one compiled strict feeder, preferably the diagonal-factor
lemma at `[64,64]`, rather than broadening to raw `Coeff` constructor equality
or adding any new hypothesis.

Verifier feedback for this lower-1 design packet:

| Field | Value |
|---|---|
| `leaf` | `slot4_diagonal_factor_leaf -> oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true_shared_worktree_gated_no_lean_edit` |
| `lean_build_ok` | `true_shared_worktree_gated_no_lean_edit` |
| `finite_matrix_ok` | `partial_read_only_eval_confirmed_64_to_32_65_to_33_swap32_to_4_and_Of_zeroes` |
| `block_entry_ok` | `false_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `none_design_packet` |
| `next_route` | `prove slot-4 evaluated diagonal factor at full index 64, then unfold the slot-4 backend contribution` |

Handoff: lower 1 appended this Section 21.7 packet only and ran
`python3 tools/qbe.py check`, `lake build`, and `lake build Tests`; all passed
with the known `RobinMatrix` diagnostic sorries. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. The next Lean worker should edit only
`QuantumBlockEncoding/RobinMatrix.lean` and close the slot-`4` evaluated
vanish theorem or its strict full-index `64` diagonal-factor feeder.

Concurrency note added after the handoff: a parallel lower-2 worker then closed
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env`
using this full-index `64` route. Treat Section 21.7 as the proof map for that
now-compiled leaf. The next open route is slot `5` evaluated vanish/cancellation
or use slots `0`, `1`, `3`, and `4` toward `ActiveUncastToPreparedEntry`, as
recorded in the run dialogue.

### 21.8 Post-Slot-4 Frontier: Slot 5 Evaluated Vanish

Created: 2026-06-11 20:18 JST for run
`20260611-195209-QBE-AUTO-002-cycle01`.

This postscript is the narrow lower-1 update after
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env`
compiled. Slot `4` and the full-index `64` route are now retired. The active
smaller Lean leaf is slot `5` full evaluated vanish, or one strict full-index
`80` feeder that directly proves it. Slot `6` remains a later remaining-slot
target. The preferred mathematical leaf is still `ActiveUncastToPreparedEntry`.

#### 21.8.1 Source Fragment

| Source anchor | Fragment being translated | Lean-facing object | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares $\frac{1}{\sqrt{\kappa}}\sum_{s=0}^{\kappa-1}\ket{s}$ in the sparse register. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary term has the all-slot coefficient $\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa} f(x_i)(D)_i^{(s)}\sigma^{(s)}$ on clean ancillas. The focused displayed branch is slot `2`; nonselected slots must be removed only by named finite matrix-semantics lemmas. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | The local active product is still `U_indic`, `O_{D^T}^S`, `R_y`, pre-SWAP `O_D^{BS}`, `O_f`, SWAP, and post-SWAP `(O_D^{BS})^\dagger`; theorem-facing $H_W^{(\kappa)}$ sides and the explicit `U_indic^\dagger` role remain transcript guards outside this leaf. | `oneTermRobinGamma3BoundarySevenGateMatrix_n3`; `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local matrix semantics |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is recovered only after `SourcePreparedEntry` and `FullUnitaryFold`; this packet only removes one nonselected branch summand in the finite backend fold. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge |

#### 21.8.2 Definitions Before Claims

For the next Lean worker, define the slot and rows by the existing full-index
map:

```lean
slot5 := (⟨5, by native_decide⟩ : Fin 7)
row80 := (⟨80, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
row81 := (⟨81, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
row10 := (⟨10, by native_decide⟩ :
  Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
```

Let `Prefix` be `oneTermRobinGamma3BoundaryPrefixMatrix_n3`, the four-gate
product `O_D^BS * Ry_boundary * O_DT^S * U_indic`. Let `OfSwap` be
`oneTermRobinGamma3BoundaryOfSwapMatrix_n3`, the product `SWAP * O_f`. Let
`Suffix` be `oneTermRobinGamma3BoundarySuffixMatrix_n3`, the product
`(O_D^BS)^dagger * SWAP * O_f`. Let `U` be
`oneTermRobinGamma3BoundarySevenGateMatrix_n3 = Suffix * Prefix`.

The active local theorem should be:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨5, by native_decide⟩) = 0
```

The strict smaller feeder should be:

```lean
private theorem oneTermRobinGamma3BoundarySevenGateSlotFiveEval_zero_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3 row80 row80) = 0
```

#### 21.8.3 Natural-Language Proof

The full-index map gives
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 slot5 = row80`.
Therefore the slot-`5` backend contribution is the diagonal entry
`U[row80,row80]` multiplied by the fixed sparse projection amplitude factor.
It is enough to prove that the evaluated diagonal entry is zero.

Expand `U[row80,row80]` as the matrix product
`sum_q Suffix[row80,q] * Prefix[q,row80]`. The prefix support calculation is
the same proof shape as slots `3` and `4`, with the concrete arithmetic shifted
to full index `80`. The indicator oracle leaves column `80` at row `80`; the
`O_{D^T}^S` support theorem keeps support at row `80`; and the boundary
rotation has indicator bit `0`, so it can expose only rows `80` and `81`.
The forward sparse-access image is `80 -> 80` and `81 -> 81`. Thus
`Prefix[q,row80]` evaluates to zero unless `q = row80` or `q = row81`.

It remains to prove that the suffix kills those two possible prefix rows. The
post-SWAP dagger row `80` has support only at column `80`, because
`bandedSparseAccessPaperImage p 80 = 80`. The two suffix entries reduce to
`OfSwap[row80,row80]` and `OfSwap[row80,row81]`. The SWAP row `80` has preimage
`10`, and the executable function oracle gives
`O_f[row10,row80] = 0` and `O_f[row10,row81] = 0`. Hence both suffix entries
evaluate to zero, and every path in the product expansion is zero.

The compiled theorem
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`
records the clean-path support mismatch for slot `5`
(`80 -> 80 -> 10`, with the dagger entry at post-SWAP column `10` equal to
zero), but it remains support-only. The Lean worker should use it only as
orientation; the closure step must be the evaluated prefix/suffix product
argument above.

#### 21.8.4 Proof-DAG Table

| Node | Dependencies | Status | Owner | Next route |
|---|---|---|---|---|
| `slot4_full_vanish_leaf` | full-index `64` support chain; branch contribution unfolding | compiled; retired | none | Reuse only as a proof pattern. |
| `slot5_support_mismatch_memory` | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`; values `80 -> 80 -> 10` | compiled support; retired | none | Do not assign as closure. |
| `slot5_prefix_col80_support_leaf` | `U_indic`, `O_DT^S`, `Ry_boundary`, forward `O_D^BS`; images `80 -> 80` and `81 -> 81` | active strict feeder | lower 2/refiner | Prove prefix column `80` has evaluated support only at rows `80` and `81`. |
| `slot5_suffix_row80_zero_leaf` | dagger row `80` support at column `80`; SWAP preimage `10`; zero `O_f[10,80]` and `O_f[10,81]` | active strict feeder | lower 2/refiner | Prove suffix row `80` kills columns `80` and `81`. |
| `slot5_diagonal_factor_leaf` | `slot5_prefix_col80_support_leaf`; `slot5_suffix_row80_zero_leaf`; `Matrix.evalWith_mul_eq_zero_of_all_paths_zero` | next active leaf if public theorem is too large | lower 2/refiner | Prove `oneTermRobinGamma3BoundarySevenGateSlotFiveEval_zero_n3 env`. |
| `slot5_full_vanish_leaf` | `slot5_diagonal_factor_leaf`; branch contribution unfolding; full-index map | preferred smaller leaf | lower 2/refiner | Prove `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env`. |
| `slot6_remaining_vanish_leaf` | slot-`6` support mismatch; full-index `96`; analogous prefix/suffix arithmetic | later remaining-slot leaf | later lower 2/refiner | Assign only after slot `5` closes or if middle explicitly reroutes. |
| `active_uncast_to_prepared_entry_leaf` | slots `0`, `1`, `3`, `4`, and future remaining-slot vanish/cancellation facts; cached prepared entry; prepared backend-fold feeder | preferred active mathematical leaf, still open | lower 2/refiner | Attempt directly only if the cached prepared-entry comparison is ready. |
| `source_prepared_entry_leaf` | `active_uncast_to_prepared_entry_leaf`; active wrapper/cast bridge | open dependent target | later lower 2 | Close `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`. |
| `unitary_fold_leaf` | `source_prepared_entry_leaf`; `HUniform`; prepared backend-fold normal form | open dependent root | later lower 2 | Close `FullUnitaryFold` through existing compiled bridges. |

Next active leaf for the Lean worker:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env
```

Acceptable strict feeder:

```lean
oneTermRobinGamma3BoundarySevenGateSlotFiveEval_zero_n3 env
```

#### 21.8.5 Ordered Lean Lemmas

Reuse existing declarations first:

1. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`.
2. `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.
3. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`.
4. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`.
5. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3`.
6. `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`.
7. `GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image`.
8. `GHL2025.swapOracleMatrix_eq_image`.
9. `GHL2025.swapOracleImage_self_inverse`.

Suggested new private helpers, in dependency order:

1. `oneTermRobinGamma3BoundaryPrefixRow10_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow80_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow81_n3`.
2. `oneTermRobinGamma3BoundaryIndicatorCol80_support_n3`.
3. `oneTermRobinGamma3BoundaryODTSCol80_support_n3`.
4. `oneTermRobinGamma3BoundaryDUPrefixCol80Support_n3`.
5. `oneTermRobinGamma3BoundaryRyCol80_support_n3`.
6. `oneTermRobinGamma3BoundaryRDUPrefixCol80Support_n3`.
7. `oneTermRobinGamma3BoundaryODBSCol80_support_n3` and
   `oneTermRobinGamma3BoundaryODBSCol81_support_n3`, using executable values
   `bandedSparseAccessPaperImage p 80 = 80` and
   `bandedSparseAccessPaperImage p 81 = 81`.
8. `oneTermRobinGamma3BoundaryPrefixCol80Support_n3`, showing prefix support
   only at rows `80` and `81`.
9. `oneTermRobinGamma3BoundarySwapRow80_support_n3`, using the self-inverse
   SWAP fact and executable value `swapOracleImage p 80 = 10`.
10. `oneTermRobinGamma3BoundaryOfSwapRow80Col80_zero_n3` and
    `oneTermRobinGamma3BoundaryOfSwapRow80Col81_zero_n3`, using executable
    zeroes `functionOraclePaperMatrix p row10 row80 = 0` and
    `functionOraclePaperMatrix p row10 row81 = 0`.
11. `oneTermRobinGamma3BoundaryDaggerRow80_support_n3`, using
    `bandedSparseAccessPaperImage p 80 = 80`.
12. `oneTermRobinGamma3BoundarySuffixRow80Col80_zero_n3` and
    `oneTermRobinGamma3BoundarySuffixRow80Col81_zero_n3`.
13. `oneTermRobinGamma3BoundarySevenGateSlotFiveEval_zero_n3`.
14. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3`.

#### 21.8.6 Failure Analysis

The selected theorem is mathematically well routed and faithful to the source:
Eq. `ROBIN clarified` keeps all sparse slots in the $\gamma_3$ sum, and this
leaf removes one nonselected slot by evaluated finite matrix semantics. It
does not change the circuit, the oracle contracts, the normalizer, or the
theorem statement.

The main risk is repeating the stale support-only route. The compiled
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` fact
does not prove the slot-`5` branch contribution vanishes; it only records one
clean-path mismatch. If the full public theorem is too large, lower 2 should
stop after one compiled strict feeder, preferably the diagonal-factor lemma at
`[80,80]`, rather than broadening to raw `Coeff` constructor equality or adding
any new hypothesis.

Verifier feedback for this lower-1 design packet:

| Field | Value |
|---|---|
| `leaf` | `slot5_diagonal_factor_leaf -> oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true_markdown_only_gate_passed_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed_no_lean_edit` |
| `finite_matrix_ok` | `partial_read_only_eval_confirmed_80_to_80_81_to_81_swap80_to_10_and_Of_zeroes` |
| `block_entry_ok` | `false_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `none_design_packet` |
| `next_route` | `prove slot-5 evaluated diagonal factor at full index 80, then unfold the slot-5 backend contribution` |

Handoff: lower 1 appended this Section 21.8 packet only and ran
`python3 tools/qbe.py check`, `lake build`, and `lake build Tests`; all passed
with the known `RobinMatrix` diagnostic sorries. No Lean source, oracle
contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. The next Lean worker should edit only
`QuantumBlockEncoding/RobinMatrix.lean` and close the slot-`5` evaluated
vanish theorem or its strict full-index `80` diagonal-factor feeder.

Middle concurrency note added after the next upper handoff: a parallel lower-2
worker closed
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env`
using this full-index `80` route. Treat Section 21.8 as the proof map for that
now-compiled leaf. The active smaller route is now slot `6` evaluated
vanish/cancellation, or a strict full-index `96` feeder, while the preferred
mathematical leaf remains `ActiveUncastToPreparedEntry`.

### 21.9 Post-Slot-5 Frontier: Slot 6 Evaluated Vanish

This postscript supersedes Section 21.8 as the active remaining-slot packet.
Slot `5` and its full-index `80` feeder are now compiled and retired. The only
remaining nonselected backend slot without a full evaluated vanish/cancellation
theorem is slot `6`.

#### 21.9.1 Source Fragment

The source fragment remains the one-term Robin backend route:

| Source anchor | Paper role | Lean-facing object | Dependency class |
|---|---|---|---|
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | Claims the one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ | theorem-facing root, still open | GHL-internal theorem root |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The $\gamma_3$ boundary coefficient is an all-slot sparse-register sum over $s = 0,\dots,\kappa-1$ | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; slot `2` selected branch plus nonselected slot vanish feeders | GHL-internal plus QBE-local matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | Gate order through $U_{\mathrm{indic}}$, $O_{D^T}^S$/boundary $R_y$, pre-SWAP $O_{D^T}^{BS}$, $O_f$, SWAP, and post-SWAP $(O_D^{BS})^\dagger$ | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; active seven-gate backend core | GHL-internal transcript plus QBE-local matrix semantics |
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the all-slot sparse register | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract, not formalized here |
| `main.tex:2027-2035`, Definition `def:block-encoding` | Clean block projection endpoint | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge, still open |

This packet translates only the last local nonselected summand in Eq. `ROBIN
clarified`. It does not alter the theorem, circuit, normalizer, hypotheses, or
external primitive contracts.

#### 21.9.2 Definitions Before Claims

Use the existing focused parameters:

```lean
p := oneTermRobinGamma3BoundaryPrefixParameters_n3
slot6 := (⟨6, by native_decide⟩ : Fin 7)
```

The backend branch-full-index map sends `slot6` to full basis row `96`:

```lean
oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 slot6
  = (⟨96, by native_decide⟩ :
      Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
```

The target theorem for lower 2 is:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨6, by native_decide⟩) = 0
```

An acceptable strict feeder is the diagonal seven-gate entry:

```lean
private theorem oneTermRobinGamma3BoundarySevenGateSlotSixEval_zero_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        (⟨96, by native_decide⟩ :
          Fin oneTermRobinGamma3BoundaryPrefixDim_n3)
        (⟨96, by native_decide⟩ :
          Fin oneTermRobinGamma3BoundaryPrefixDim_n3)) = 0
```

#### 21.9.3 Natural-Language Proof

Split the seven-gate backend matrix as `suffix * prefix`, following the
compiled slot-`4` and slot-`5` leaves.

For the prefix column `96`, the indicator and `O_{D^T}^S` stages have support
only at the same full index `96`. The boundary $R_y$ stage can only preserve
the paired rows `96` and `97`. The forward sparse-access gate then maps these
two possible rows to rows `48` and `49`, respectively:

```text
bandedSparseAccessPaperImage p 96 = 48
bandedSparseAccessPaperImage p 97 = 49
```

Therefore the evaluated prefix entry at column `96` vanishes for every
intermediate row except `48` and `49`.

For the suffix row `96`, the post-SWAP dagger has support only at column `48`,
because the forward sparse-access image of row `96` is `48`. The SWAP row `48`
has preimage `6`:

```text
swapOracleImage p 48 = 6
```

The function-oracle entries on the two surviving prefix columns are both zero:

```text
functionOraclePaperMatrix p row6 row48 = Coeff.rat 0
functionOraclePaperMatrix p row6 row49 = Coeff.rat 0
```

Thus the evaluated suffix entries from row `96` to columns `48` and `49` are
zero. All other intermediate rows are already killed by prefix support. Applying
`Matrix.evalWith_mul_eq_zero_of_all_paths_zero` to the seven-gate product gives
the diagonal-factor feeder at `[96,96]`. Unfolding
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, rewriting
`slot6` to full index `96`, and simplifying with the diagonal feeder proves
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3`.

This is a QBE-local finite matrix-semantics proof. It removes the last
nonselected backend slot from the evaluated all-slot fold route, but it does
not by itself prove `ActiveUncastToPreparedEntry`, `SourcePreparedEntry`,
`FullUnitaryFold`, backend expansion, or the theorem-facing block-encoding
claim.

#### 21.9.4 Proof-DAG Table

| Node | Dependencies | Status | Owner | Next route |
|---|---|---|---|---|
| `slot5_full_vanish_leaf` | full-index `80` support chain; branch contribution unfolding | compiled; retired | none | Reuse only as a proof pattern. |
| `slot6_support_mismatch_memory` | `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`; values `96 -> 48 -> 6` | compiled support-only; retired | none | Do not assign as closure. |
| `slot6_prefix_col96_support_leaf` | `U_indic`, `O_{D^T}^S`, boundary $R_y$, forward `O_D^BS`; images `96 -> 48` and `97 -> 49` | active strict feeder | lower 2/refiner | Prove prefix column `96` has evaluated support only at rows `48` and `49`. |
| `slot6_suffix_row96_zero_leaf` | dagger row `96` support at column `48`; SWAP preimage `6`; zero `O_f[6,48]` and `O_f[6,49]` | active strict feeder | lower 2/refiner | Prove suffix row `96` kills columns `48` and `49`. |
| `slot6_diagonal_factor_leaf` | `slot6_prefix_col96_support_leaf`; `slot6_suffix_row96_zero_leaf`; `Matrix.evalWith_mul_eq_zero_of_all_paths_zero` | next active leaf if the public theorem is too large | lower 2/refiner | Prove `oneTermRobinGamma3BoundarySevenGateSlotSixEval_zero_n3 env`. |
| `slot6_full_vanish_leaf` | `slot6_diagonal_factor_leaf`; branch contribution unfolding; full-index map | preferred smaller leaf | lower 2/refiner | Prove `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env`. |
| `active_uncast_to_prepared_entry_leaf` | slots `0`, `1`, `3`, `4`, `5`, and future slot `6` vanish/cancellation facts; cached prepared entry; prepared backend-fold feeder | preferred active mathematical leaf, still open | lower 2/refiner | Attempt directly only if the cached prepared-entry comparison is ready. |
| `source_prepared_entry_leaf` | `active_uncast_to_prepared_entry_leaf`; active wrapper/cast bridge | open dependent target | later lower 2 | Close `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`. |
| `unitary_fold_leaf` | `source_prepared_entry_leaf`; `HUniform`; prepared backend-fold normal form | open dependent root | later lower 2 | Close `FullUnitaryFold` through existing compiled bridges. |

Next active leaf for the Lean worker:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env
```

Acceptable strict feeder:

```lean
oneTermRobinGamma3BoundarySevenGateSlotSixEval_zero_n3 env
```

#### 21.9.5 Ordered Lean Lemmas

Reuse existing declarations first:

1. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`.
2. `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`,
   as support memory only.
3. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`.
4. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`.
5. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`.
6. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3`.
7. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3`.
8. `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`.
9. `GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image`.
10. `GHL2025.swapOracleMatrix_eq_image`.
11. `GHL2025.swapOracleImage_self_inverse`.
12. Existing row abbreviations for `48` and `49`, if lower 2 places the new
    helpers after the compiled slot-`3` block in `RobinMatrix.lean`.

Suggested new private helpers, in dependency order:

1. `oneTermRobinGamma3BoundaryPrefixRow6_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow96_n3`,
   `oneTermRobinGamma3BoundaryPrefixRow97_n3`.
2. `oneTermRobinGamma3BoundaryIndicatorCol96_support_n3`.
3. `oneTermRobinGamma3BoundaryODTSCol96_support_n3`.
4. `oneTermRobinGamma3BoundaryDUPrefixCol96Support_n3`.
5. `oneTermRobinGamma3BoundaryRyCol96_support_n3`.
6. `oneTermRobinGamma3BoundaryRDUPrefixCol96Support_n3`.
7. `oneTermRobinGamma3BoundaryODBSCol96_support_n3` and
   `oneTermRobinGamma3BoundaryODBSCol97_support_n3`, using executable values
   `bandedSparseAccessPaperImage p 96 = 48` and
   `bandedSparseAccessPaperImage p 97 = 49`.
8. `oneTermRobinGamma3BoundaryPrefixCol96Support_n3`, showing prefix support
   only at rows `48` and `49`.
9. `oneTermRobinGamma3BoundarySwapRow48_support_n3`, using the self-inverse
   SWAP fact and executable value `swapOracleImage p 48 = 6`.
10. `oneTermRobinGamma3BoundaryOfSwapRow48Col48_zero_n3` and
    `oneTermRobinGamma3BoundaryOfSwapRow48Col49_zero_n3`, using executable
    zeroes `functionOraclePaperMatrix p row6 row48 = 0` and
    `functionOraclePaperMatrix p row6 row49 = 0`.
11. `oneTermRobinGamma3BoundaryDaggerRow96_support_n3`, using
    `bandedSparseAccessPaperImage p 96 = 48`.
12. `oneTermRobinGamma3BoundarySuffixRow96Col48_zero_n3` and
    `oneTermRobinGamma3BoundarySuffixRow96Col49_zero_n3`.
13. `oneTermRobinGamma3BoundarySevenGateSlotSixEval_zero_n3`.
14. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3`.

#### 21.9.6 Failure Analysis

The selected slot-`6` route is mathematically well shaped and source-faithful:
Eq. `ROBIN clarified` keeps every sparse slot in the $\gamma_3$ all-slot sum,
and this leaf removes the last nonselected backend slot by evaluated finite
matrix semantics. It does not modify the source circuit, oracle contracts,
normalizer, gate labels, theorem hypotheses, or projection target.

The support-only theorem
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` must
not be treated as the slot-`6` theorem. It records the clean-path arithmetic
`96 -> 48 -> 6` and the dagger support mismatch, but it does not prove the full
evaluated seven-gate diagonal entry or the backend branch contribution
vanishes. If the public slot-`6` theorem is too large, lower 2 should stop at
the strict diagonal-factor feeder at `[96,96]`, not at another support-only
fact.

Verifier feedback for this lower-1 design packet:

| Field | Value |
|---|---|
| `leaf` | `slot6_diagonal_factor_leaf -> oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed_no_lean_edit` |
| `finite_matrix_ok` | `partial_read_only_eval_confirmed_96_to_48_97_to_49_swap48_to_6_and_Of_zeroes` |
| `block_entry_ok` | `false_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `none_design_packet` |
| `next_route` | `prove slot-6 evaluated diagonal factor at full index 96, then unfold the slot-6 backend contribution` |

Handoff: lower 1 appended this Section 21.9 packet only and ran
`python3 tools/qbe.py check`, `lake build`, and `lake build Tests`; all passed
with the known `RobinMatrix` diagnostic sorries. No Lean source, oracle
contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. The next Lean worker should edit only
`QuantumBlockEncoding/RobinMatrix.lean` and close the slot-`6` evaluated
vanish theorem or its strict full-index `96` diagonal-factor feeder.

Middle concurrency note added after the lower handoff: a parallel lower-2
worker closed
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env`
using this full-index `96` route. Treat Section 21.9 as the proof map for that
now-compiled leaf. The remaining active mathematical route is
`ActiveUncastToPreparedEntry`, using the compiled vanish/cancellation evidence
for slots `0`, `1`, `3`, `4`, `5`, and `6` together with the selected slot `2`
branch.

### 21.10 Post-Slot-6 Frontier: Active-Uncast And Source-Prepared Entry

This postscript supersedes Section 21.9 as the active lower-1 proof packet.
Slots `0`, `1`, `3`, `4`, `5`, and `6` now have compiled evaluated vanish
feeders and are retired. The remaining selected sparse slot is slot `2`, which
is the focused $\gamma_3$ boundary contribution in Eq. `ROBIN clarified`.

#### 21.10.1 Source Fragment

The source-paper fragment being translated is the prepared one-term Robin
projection route:

| Source anchor | Paper fragment being translated | Lean-facing object | Dependency class |
|---|---|---|---|
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | the theorem claims a one-term Robin block-encoding with normalizer $\mathcal{N}_D \mathcal{N}_f \kappa$ | theorem-facing root, still open | GHL-internal theorem root plus cited contracts |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the $\gamma_3$ boundary branch is an all-slot sum over $s = 0,\dots,\kappa-1$; slot `2` is the focused nonzero branch for the current finite witness | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal branch equation plus QBE-local finite matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | the theorem-facing circuit contains the two $H_W^{(\kappa)}$ boundary gates, explicit `U_indic^dagger`, the pre-SWAP `O_{D^T}^{BS}`, $O_f$, SWAP, and post-SWAP $(O_D^{BS})^\dagger$ | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | GHL-internal transcript plus QBE-local matrix backend |
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the sparse register uniformly over all sparse slots | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract, not formalized here |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the clean signal block is the entry selected by projecting clean ancillas | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge |

This packet does not change the paper circuit, oracle contracts, normalizer,
gate labels, theorem hypotheses, or any theorem-facing semantic flag.

#### 21.10.2 Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and the existing clean
column contract

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Let

```lean
gates :=
  GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)

A :=
  (evalGateMatrices gates)
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3

B :=
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3

C2 :=
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
    oneTermRobinGamma3BoundaryBranchContributionFocusedSlot
```

The source-prepared evaluated active leaf is:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
  H env
```

The displayed raw active-uncast target is:

```lean
A = (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The raw target is stronger than the evaluated slot-vanish evidence. The
compiled vanish feeders are statements about `Coeff.evalWith env`, so they
feed the evaluated/source-prepared route immediately. A raw `Coeff` proof of
the displayed equality still needs a raw full-entry fold theorem or raw
selected-slot cancellation theorem.

#### 21.10.3 Natural-Language Proof

The prepared side is already normalized under the existing $H_W^{(\kappa)}$
clean-column contract. The theorem
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform`
identifies the cached prepared entry with the backend seven-slot fold. At the
evaluation level, the same fact is available through
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

The backend fold now has all nonselected branches removed after evaluation.
Slot `0` is handled by
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3`.
Slots `1`, `3`, `4`, `5`, and `6` are handled by the corresponding compiled
full evaluated branch vanish theorems. Therefore the evaluated fold reduces to
the evaluated slot-`2` summand.

The selected slot is already identified at the raw branch-family level:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3
```

The selected slot maps to full index `32` by
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`, so the
remaining active-side finite theorem is to compare the active seven-gate
`[0,0]` entry with the same slot-`2` contribution or with the resulting backend
fold. This is the next useful lower-2 leaf. It is QBE-local finite matrix
semantics, not a new oracle or sparse-preparation assumption.

After that active-side evaluated equality is supplied, the compiled route
closes the source-prepared evaluated statement:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3
```

or, equivalently, the bridge

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
```

under `hUniform`.

If lower 2 is assigned the raw `ActiveUncastToPreparedEntry` statement instead
of the evaluated/source-prepared statement, the proof must use a raw fold route:
prove the raw unitary-entry fold and then apply
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_of_unitaryEntryFold_n3 H
hUniform`. The evaluated vanish theorems alone cannot close a raw `Coeff`
equality.

The active backend matrix list remains the seven-gate core. The theorem-facing
Fig. 4 transcript guard separately records both $H_W^{(\kappa)}$ sides and the
explicit `U_indic^dagger` role. Therefore this active proof must be described
as the finite active/prepared composition field, not as a proof that the
seven-gate active list is the full Fig. 4 circuit.

#### 21.10.4 Proof-DAG Table

| Node | Dependencies | Status | Owner | Lean declaration or target | Dependency class | Next route |
|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | source Fig. `fig:1 term ROBIN`; Eq. `arbitrary sparcity` | compiled; still guard-only | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | GHL-internal transcript | Reuse only to keep full-circuit claims honest. |
| `source_uniform_contract` | Eq. `arbitrary sparcity`; Shukla--Vedula cited state-preparation result | contract-only | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | Use as explicit hypothesis; do not formalize here. |
| `slot2_selected_contribution` | Eq. `ROBIN clarified`; branch full-index map | compiled | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` | GHL-internal plus QBE-local semantic bridge | Reuse as the selected summand. |
| `nonselected_slot_vanish_family` | compiled evaluated vanish facts for slots `0`, `1`, `3`, `4`, `5`, and `6` | compiled; retired as individual lower targets | none | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` and slots `1`, `3`, `4`, `5`, `6` analogues | QBE-local finite matrix semantics | Use together, not as new slot work. |
| `backend_fold_eval_to_slot2_leaf` | expanded seven-slot fold; `nonselected_slot_vanish_family`; `slot2_selected_contribution` | acceptable strict feeder | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryBackendBranchFold_eval_eq_selectedSlot_n3 env` | QBE-local semantic bridge | Prove evaluated backend fold reduces to slot `2`. |
| `active_entry_eval_to_backend_fold_leaf` | active seven-gate entry; selected slot `2`; backend fold reduction | active strict feeder | lower 2/refiner | proposed active-side evaluated fold theorem feeding `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | QBE-local finite matrix semantics | Preferred smaller leaf if full active/prepared eval is too large. |
| `active_uncast_source_prepared_eval_leaf` | `active_entry_eval_to_backend_fold_leaf`; `source_uniform_contract`; prepared clean-entry backend bridge | active mathematical leaf | lower 2/refiner | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` | QBE-local semantic bridge under external contract | Preferred source-prepared evaluated target. |
| `raw_active_uncast_leaf` | raw unitary-entry fold; `source_uniform_contract`; prepared-entry backend fold | open, stronger than evaluated leaf | lower 2 only if explicitly assigned | displayed raw `ActiveUncastToPreparedEntry` | QBE-local raw `Coeff` theorem | Do not use evaluated vanish facts alone. |
| `source_prepared_entry_leaf` | `raw_active_uncast_leaf` or source-prepared eval route plus wrapper bridge | open dependent target | later lower 2 | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | QBE-local prepared circuit semantics | Recover through compiled active/prepared bridges. |
| `unitary_fold_leaf` | `source_prepared_entry_leaf`; `source_uniform_contract`; prepared backend-fold theorem | open dependent root | later lower 2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | QBE-local projection/backend theorem | Close only after active/source-prepared field. |
| `retired_routes` | branch-sum wrapper, raw `Coeff` diagnostics, H-free diagnostic route, slot `6` support/diagonal/vanish, bridge rediscovery | stale or diagnostic | none | names recorded in the conversion window and proof-obligation ledger | stale | Do not assign. |

Next active leaf for a Lean worker:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
  H env
```

Acceptable strict feeder:

```lean
oneTermRobinGamma3BoundaryBackendBranchFold_eval_eq_selectedSlot_n3 env
```

or an active-side evaluated theorem that directly proves
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` and is then
routed through the existing source-prepared bridge under `hUniform`.

#### 21.10.5 Ordered Lean Lemmas

Reuse existing declarations first:

1. `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`.
2. `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
3. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
4. `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3`.
5. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3 H hUniform`.
6. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`.
7. `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.
8. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3 env`.
9. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3 env`.
10. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3 env`.
11. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3 env`.
12. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3 env`.
13. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3 env`.
14. `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.
15. `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`.
16. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
17. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3 H env hUniform`.
18. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3 H env hUniform`.
19. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_of_unitaryEntryFold_n3 H hUniform`, only for a raw fold route.

Suggested new leaves, in dependency order:

1. `oneTermRobinGamma3BoundaryBackendBranchFold_eval_eq_selectedSlot_n3 env`:
   after evaluating the expanded seven-slot backend fold, all nonselected
   slots vanish and the fold equals the evaluated slot-`2` contribution.
2. `oneTermRobinGamma3BoundaryActiveEntryEval_eq_selectedSlotContribution_n3 env`:
   the active seven-gate `[0,0]` entry evaluates to the selected slot-`2`
   backend contribution. If this theorem needs the existing corrected
   `Ry_boundary` entry hypothesis, it must use the already recorded
   `correctedEntryHypothesis`; do not add a new assumption silently.
3. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_selectedSlot_n3 env`:
   combine the previous two evaluated statements to prove
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
4. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_from_selectedSlot_n3
   H env hUniform`:
   close the source-prepared evaluated active leaf through the compiled
   `...of_evaluatedBackendFold...` bridge.

#### 21.10.6 Failure Analysis

The current frontier is mathematically well shaped only if the `H` dependence
and the evaluated/raw distinction remain explicit. The compiled nonselected
slot facts are evaluated facts, so they cannot prove the raw
`ActiveUncastToPreparedEntry` equality by themselves. A raw proof must supply a
raw unitary-entry fold or raw selected-slot cancellation theorem.

A direct arbitrary-`H` raw statement is not the right mathematical target
unless the existing $H_W^{(\kappa)}$ clean-column contract or a raw fold bridge
is present. If a lower worker sees a theorem statement with free `H` and no
`hUniform` or raw fold hypothesis, the correct action is to stop and record a
proof-obligation mismatch rather than proving a simplified contract.

The active seven-gate placeholder list still omits both $H_W^{(\kappa)}$
boundary gates. Therefore the active-side theorem is a finite composition field
relating the active core to the prepared sandwich, not a full Fig. 4 transcript
closure.

Verifier feedback for this lower-1 design packet:

| Field | Value |
|---|---|
| `leaf` | `post_slot6_active_uncast_source_prepared_design` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed_no_lean_edit` |
| `finite_matrix_ok` | `partial_all_nonselected_eval_vanish_facts_compiled_selected_slot2_compiled` |
| `block_entry_ok` | `false_open_active_prepared_composition_field` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove source-prepared evaluated active leaf, or first prove backend fold eval reduces to selected slot 2 and active entry eval matches that selected contribution` |

Handoff: lower 1 appended this Section 21.10 packet only. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. The next Lean worker should edit only
`QuantumBlockEncoding/RobinMatrix.lean` and should target the source-prepared
evaluated active leaf or one strict selected-slot/active-side evaluated feeder
that directly feeds it. Repeating any slot `0`, `1`, `3`, `4`, `5`, or `6`
vanish/support theorem is stale.

Concurrency note added after reading the dialogue board: a parallel lower-2
worker has now closed the selected-slot backend-fold eval feeder
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
env`. Treat `backend_fold_eval_to_slot2_leaf` above as compiled and retired.
The remaining active route is the active uncast evaluated entry comparison:
compare the `evalGateMatrices` `[0,0]` entry with the selected slot-`2`
contribution, then use the existing source-prepared bridge under `hUniform`.

### 21.11 Post-Selected-Slot Frontier: Active-Side Eval Comparison Audit

This postscript supersedes only the active leaf scheduling part of Section
21.10. The selected-slot backend-fold feeder is now compiled and retired:

```lean
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
```

The current named frontier is the active-side evaluated selected-slot
comparison:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

#### 21.11.1 Source Fragment

The source-paper fragment is unchanged:

| Source anchor | Paper fragment being translated | Lean-facing object | Dependency class |
|---|---|---|---|
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ | theorem-facing root, still open | GHL-internal theorem root plus cited contracts |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | clean $\gamma_3$ boundary branch is an all-slot sum; the focused finite witness selects slot `2` | `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`; `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3` | GHL-internal branch equation plus QBE-local finite matrix semantics |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit has both $H_W^{(\kappa)}$ sides, explicit `U_indic^dagger`, the seven active backend gates, and the post-SWAP dagger cleanup | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | GHL-internal transcript plus QBE-local matrix backend |
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ prepares the uniform sparse-slot state | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract, not formalized here |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean block entry is selected after clean-ancilla projection | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` | QBE-local projection/backend bridge |

#### 21.11.2 Definitions Before Claims

Fix `env : String -> Rat`. Let

```lean
gates :=
  GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)

A0 :=
  Coeff.evalWith env
    ((evalGateMatrices gates)
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)

S2 :=
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution

B :=
  Coeff.evalWith env
    (blockExtractionBranchContributionSum
      oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

`ActiveSelectedSlotEvalComparison` is the proposition `A0 = S2`.

The compiled backend-side theorem gives `B = S2`:

```lean
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
  env
```

Therefore a valid proof of `A0 = S2` would immediately prove the evaluated
backend-fold statement by transitivity and
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
env`.

The `H` matrix and the clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` enter
only after this evaluated fold is proved, through
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3`.

#### 21.11.3 Natural-Language Proof And Audit

The backend side is complete for the current evaluated route. The all-slot
fold has been reduced to the selected slot-`2` contribution: slots `0`, `1`,
`3`, `4`, `5`, and `6` have compiled evaluated vanish facts, and
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`
packages the fold collapse.

If a Lean worker can prove `ActiveSelectedSlotEvalComparison`, the rest of the
evaluated route is short. Rewrite
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` with
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
env`. The goal becomes `A0 = B`. Use `A0 = S2` from the new active leaf and
use the symmetry of the compiled theorem `B = S2`. This proves the evaluated
backend fold. Under `hUniform`, the existing bridge
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3`
then closes the source-prepared evaluated active/prepared statement.

However, the direct active comparison has a source/register mismatch risk. The
left side is the H-free active seven-gate `evalGateMatrices` clean entry at
full basis `[0,0]`. The selected slot-`2` contribution is the prepared
sparse-register branch contribution coming from the source $\gamma_3$ all-slot
sum. Existing Lean already records the relevant guard:
`oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` proves that the
active placeholder list contains neither $H_W^{(\kappa)}$ nor its dagger, and
`oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3` says the missing
field is a prepared-sandwich semantics entry for
$H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$.

There is also a concrete active-side warning. The compiled theorem
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env` proves that the
explicit seven-gate boundary matrix entry at `[0,0]` evaluates to zero. The
selected slot-`2` contribution is represented instead by the full-basis entry
`[32,32]` multiplied by the two sparse-register projection amplitudes. Thus a
proof that first closes the diagnostic matrix-association bridge
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` would
reduce the assigned active comparison to a non-source-backed claim that the
selected slot-`2` contribution evaluates to zero for arbitrary `env`.

The safer mathematical route is therefore not another backend-slot theorem and
not the diagnostic raw `Coeff` equality. The next Lean work should either
produce a genuine `evalGateMatrices`-level path theorem showing why the active
`[0,0]` entry is the selected slot-`2` branch without using the diagnostic
seven-gate identity, or stop and promote the mismatch to the prepared-circuit
semantics gap already named by
`oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3`.

#### 21.11.4 Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration or target | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. 4 gate order with both $H_W^{(\kappa)}$ sides and explicit `U_indic^dagger` | source Fig. `fig:1 term ROBIN`; Eq. `arbitrary sparcity` | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window and Sections 21.10-21.11 | already gated | compiled guard; no full semantic proof |
| `source_uniform_contract` | uniform sparse-register clean column | Shukla--Vedula cited state-preparation contract; Eq. `arbitrary sparcity` | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | conversion window | same gate when used | external-cited-contract |
| `active_gate_absence_guard` | active placeholder list omits $H_W^{(\kappa)}$ and its dagger | active seven-gate list | none | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | prepared-circuit semantics gap | already gated | compiled guard |
| `backend_fold_eval_to_slot2_leaf` | evaluated backend fold equals selected slot-`2` contribution | slot vanish family; selected branch theorem | none | `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | Section 21.10 and current sync | already gated | proved; retired |
| `active_selected_slot_eval_comparison_leaf` | H-free active `evalGateMatrices` `[0,0]` entry equals selected slot-`2` contribution | active finite product semantics; selected slot object; must not use retired backend-slot work | lower 2 only if it can prove a direct `evalGateMatrices`-level path | target `ActiveSelectedSlotEvalComparison` displayed above | this Section 21.11 | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | source-shape risk; do not force through diagnostic seven-gate identity |
| `prepared_circuit_semantics_gap` | missing matrix field for $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ prepared sandwich | `active_gate_absence_guard`; source Fig. 4 boundary gates | middle/refiner | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`; transcript theorem | Section 21.11 | same gate | blocked internal; preferred reroute if active comparison cannot be proved source-faithfully |
| `evaluated_backend_fold_from_active_selected` | route packaging from `ActiveSelectedSlotEvalComparison` to evaluated backend fold | `active_selected_slot_eval_comparison_leaf`; `backend_fold_eval_to_slot2_leaf`; uncast active-entry equivalence | later lower 2 | proposed `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activeSelectedSlotEval_n3 env` | this Section 21.11 | same gate | easy dependent bridge after a valid active comparison |
| `source_prepared_eval_leaf` | source-prepared evaluated active/prepared statement | `evaluated_backend_fold_from_active_selected`; `source_uniform_contract` | later lower 2 | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; bridge `...of_evaluatedBackendFold...` | Sections 21.10-21.11 | same gate | open dependent target |
| `retired_routes` | backend slots `0`, `1`, `3`, `4`, `5`, `6`; selected backend-fold reduction; raw constructor diagnostics; bridge rediscovery | previous lower packets | none | names recorded in conversion window and proof-obligation ledger | current sync | none | stale; do not assign |

Next active leaf for a Lean worker, if the current directive is kept:

```lean
-- ActiveSelectedSlotEvalComparison
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

The strict safety condition is that the proof must be a source-faithful
`evalGateMatrices`-level path/projection proof. It must not use
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` plus
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env` to force the
selected slot to vanish.

#### 21.11.5 Ordered Lean Lemmas

Reuse existing declarations first:

1. `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env`.
2. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
3. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3 H env hUniform`.
4. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
5. `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`.
6. `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H`.
7. `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3_transcript`.
8. `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3 env hentry`, only when the corrected entry hypothesis is explicitly available.
9. `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env`, as a mismatch diagnostic for the explicit seven-gate matrix only.
10. `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`, diagnostic/backlog only; do not use it to close the active selected-slot target.

Potential new lemmas, ordered by dependency:

1. `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_n3 env`:
   prove the active `evalGateMatrices` `[0,0]` entry evaluates to the selected
   slot-`2` contribution by a direct source-faithful path/projection argument.
   If the proof collapses to the explicit seven-gate `[0,0]` zero theorem,
   stop and record a mismatch instead.
2. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activeSelectedSlotEval_n3 env`:
   from the active comparison plus
   `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
   env`, prove `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
   env`.
3. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_from_activeSelectedSlot_n3
   H env hUniform`:
   package the previous lemma through
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3`.
4. If lemma 1 is blocked, replace it with a prepared-sandwich semantics leaf:
   define the missing matrix-entry field for
   $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ named by
   `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3`; do not change
   the paper circuit or add a new assumption.

#### 21.11.6 Failure Analysis

The current target is not yet certified as mathematically well shaped. It
compares an H-free active seven-gate clean entry with a prepared sparse-slot
contribution that source Eq. `ROBIN clarified` obtains only after the sparse
register has been prepared and projected. Lean already names this gap through
`oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3`.

The target should be routed through a prepared-sandwich semantics theorem
unless lower 2 can prove a direct `evalGateMatrices`-level path from active
basis `[0,0]` to the selected slot-`2` contribution without using the
diagnostic equality between `evalGateMatrices` and
`oneTermRobinGamma3BoundarySevenGateMatrix_n3`.

Verifier feedback for this lower-1 design packet:

| Field | Value |
|---|---|
| `leaf` | `active_selected_slot_eval_comparison_leaf` |
| `source_correspondence_ok` | `false_for_direct_H_free_active_to_prepared_slot2_comparison` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed_no_lean_edit` |
| `finite_matrix_ok` | `partial_backend_fold_to_slot2_compiled_active_side_mismatch_diagnostic_exists` |
| `block_entry_ok` | `false_open_prepared_sandwich_projection_field` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `prove a direct evalGateMatrices-level selected-slot path, or reroute to the prepared-circuit semantics gap for H_W^dagger * U * H_W` |

Handoff: lower 1 appended this Section 21.11 packet only. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. The active selected-slot backend-fold theorem is
compiled and retired. The next lower worker should not repeat any slot vanish
or backend-fold-to-slot-`2` theorem. If attempting the displayed active
comparison, the worker must prove it as a direct `evalGateMatrices`-level
path/projection theorem; otherwise the route should be recorded as the
prepared-circuit semantics gap already named in Lean.

Concurrency note added after reading the dialogue board: a parallel lower-2
worker has now closed
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3`.
Treat the route-packaging node
`evaluated_backend_fold_from_active_selected` as compiled and retired. The
active selected-slot comparison itself remains open, and the shape/register-gap
warning above still applies to any direct proof of that comparison.

### 21.12 Current-Run Confirmation After Active-Selected Bridge Sync

This postscript is intentionally narrow. The active theorem name did not
change after Section 21.11. Middle has now synchronized the current run
`20260611-214323-QBE-AUTO-002-cycle01`, and the compiled bridge
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3`
is retired as route packaging. The active local theorem remains
`ActiveSelectedSlotEvalComparison`.

#### 21.12.1 Source Fragment Being Translated

The source fragment is the boundary $\gamma_3$ line of Eq. `ROBIN clarified`:
the clean branch has coefficient
$1/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and sums over sparse slots
$s = 0,\dots,\kappa-1$ on the Robin boundary range. The focused finite Lean
witness selects sparse slot `2`; the nonselected slots have already been
removed only by named evaluated finite-matrix theorems. The Fig. `1 term
ROBIN` caption remains part of the route because the source circuit includes
the $H_W^{(\kappa)}$ preparation boundary gates and the post-SWAP cleanup; the
current H-free active comparison must not silently replace that prepared
sandwich.

#### 21.12.2 Definitions And Local Claim

Fix `env : String -> Rat`. Define

```lean
A0 :=
  Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)

S2 :=
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

The current local claim is `A0 = S2`. The compiled theorem
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
env` proves that this claim is equivalent to
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; it does not
prove either side. The compiled theorem
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
env` supplies the backend side `backendFold = S2` and is also retired.

#### 21.12.3 Natural-Language Proof Design

A source-faithful proof of `A0 = S2` would have to work directly at the
`evalGateMatrices` path level. It should identify the unique active product
path whose sparse-register slice is the selected slot `2`, prove that every
other active path contributing to the same clean `[0,0]` entry is zero or
cancels by a named finite support lemma, and then rewrite the surviving path
to `oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution`.

The proof must not use the diagnostic route
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` followed by
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3 env`. That route
computes the explicit H-free seven-gate column-zero entry and points toward
zero, while the source $\gamma_3$ selected contribution is a prepared
sparse-slot branch with the two $H_W^{(\kappa)}$ sides visible in the paper
transcript. If lower2 finds that all available active-entry rewrites collapse
through the diagnostic zero theorem, the correct mathematical classification is
`shape_or_register_gap`; the next route is the prepared-sandwich semantics
field named by `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`.

#### 21.12.4 Proof-DAG Delta

| Node | Interface | Dependencies | Owner | Lean declaration or target | Status |
|---|---|---|---|---|---|
| `active_selected_slot_eval_comparison_leaf` | evaluated active `[0,0]` entry equals selected slot-`2` contribution | active `evalGateMatrices` path semantics; selected slot contribution; compiled backend-fold-to-slot-`2` theorem only as context | lower2 | target `A0 = S2` above | active leaf |
| `active_selected_to_fold_bridge` | package `A0 = S2` as evaluated backend fold | `active_selected_slot_eval_comparison_leaf`; `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env` | proved; retired |
| `prepared_sandwich_gap_leaf` | source-prepared $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ entry supplies the clean projection route | Fig. `1 term ROBIN`; `HUniform`; prepared-sandwich interfaces | lower2/refiner after gap classification | `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`; `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` | controlled fallback |
| `retired_backend_slot_work` | slots `0`, `1`, `3`, `4`, `5`, `6` vanish and backend fold reduces to slot `2` | named compiled slot vanish family | none | compiled declarations listed in the blueprint | stale; do not assign |

The next active leaf is still `active_selected_slot_eval_comparison_leaf`.

#### 21.12.5 Ordered Lean Lemmas For The Worker

Reuse these declarations in this order:

1. `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env`.
2. `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env`.
3. `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3 env hentry`, only after a correct selected-entry hypothesis has been derived.
4. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`, as a guard that the active placeholder list is H-free.
5. `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`, if the active proof collapses through the H-free diagnostic zero route.

The only acceptable new Lean leaf from this postscript is a direct active-side
finite-product lemma feeding `A0 = S2`. A theorem that merely rediscovers a
backend slot vanish fact, the selected-slot backend fold, or the active-selected
bridge is stale work.

#### 21.12.6 Failure Analysis And Verifier Feedback

The target is mathematically risky because it compares an H-free active
`evalGateMatrices` clean entry with a selected contribution that belongs to the
source-prepared sparse-slot branch. This is not a proof of contradiction; it is
a proof-shape warning. A valid proof must expose a direct source-faithful path
from the active entry to the selected branch. Otherwise the route should move
to the prepared-sandwich field.

| Field | Value |
|---|---|
| `leaf` | `active_selected_slot_eval_comparison_leaf` |
| `source_correspondence_ok` | `partial_direct_active_path_not_yet_proved` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed` |
| `finite_matrix_ok` | `partial_backend_side_compiled_active_side_open` |
| `block_entry_ok` | `false_open_active_to_prepared_selected_slot_comparison` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap_if_active_proof_uses_diagnostic_zero_route` |
| `next_route` | `prove direct evalGateMatrices-level selected-slot path, or route to prepared-sandwich semantics gap` |

Handoff: lower1 made only this Markdown proof-DAG confirmation. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. Lower2 should attempt exactly the active selected-slot
comparison or one direct active-side feeder; if the proof route uses the
diagnostic seven-gate zero theorem, record the prepared-sandwich gap instead of
claiming theorem closure.

### 21.13 Prepared-Sandwich Semantics Gap Postscript

This postscript supersedes Section 21.12 as the default lower route. A
parallel lower worker compiled
`oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`.
That theorem records that the H-free active selected-slot comparison is a
`shape_or_register_gap` when it is routed through the diagnostic seven-gate
matrix identity and the column-zero vanish theorem. The next lower theorem
should therefore target the source-prepared sandwich field, not the H-free
active selected-slot comparison by default.

#### 21.13.1 Source Fragment Being Translated

The source fragment is the prepared sparse-register step in the one-term Robin
proof:

| Source anchor | Fragment | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$ | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the $\gamma_3$ boundary clean branch has coefficient $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and sums over all sparse slots | GHL-internal plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3`; `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | the theorem-facing circuit has both $H_W^{(\kappa)}$ sides around the inner Robin operator route | GHL-internal transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the signal-zero entry is the projected matrix entry to be compared with the prepared clean branch | QBE-local projection semantics | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

The TeX proof does not license replacing the prepared sandwich
$H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ by the H-free seven-gate active
product. The source-prepared route must keep the two $H_W^{(\kappa)}$ boundary
maps visible and keep the clean-column theorem as a cited contract.

#### 21.13.2 Definitions And Local Claim

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and, when needed, the
existing external contract
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Define the clean sparse-register index
`c := oneTermRobinGamma3BoundarySparseCleanIndex_n3`. Define the prepared
sparse-register sandwich matrix
`P_H := oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`. Define
the prepared sandwich fold
`S_H := oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`. Define
the active seven-gate entry

```lean
A(env) :=
  Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

and define the prepared clean entry

```lean
P(env) :=
  Coeff.evalWith env
    ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
      c c).
```

The active local claim for lower2 is the prepared-sandwich statement

```lean
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
```

or equivalently

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env.
```

As a theorem over arbitrary `H`, this claim should be attempted only with the
already named clean-column contract in scope. Without `hUniform`, the right
side depends on arbitrary entries of `H`, while the active seven-gate left side
does not.

#### 21.13.3 Natural-Language Proof Design

The prepared sparse-register matrix `P_H` is the finite matrix for
$H_W^{(\kappa)\dagger} U_{\gamma_3,\mathrm{bdry}} H_W^{(\kappa)}$ on the sparse
register. Its clean-clean entry is

$$
\sum_s U_{\gamma_3,\mathrm{bdry}}[\mathrm{full}(s),\mathrm{full}(s)]
     H[s,0] H^\dagger[0,s].
$$

Lean already proves this clean entry is exactly `S_H` by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`, and it
proves the singleton prepared circuit semantics evaluates to this matrix entry
by `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.

Under `hUniform`, each factor `H[s,0]` and the matching transpose-dagger factor
contributes the source amplitude $1/\sqrt{\kappa}$. Therefore every prepared
slot contribution specializes to the backend branch contribution, and the
seven-slot prepared fold specializes to the backend fold. Lean already packages
these two steps as
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`
and `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.

The remaining proof is the composition field, not the slot arithmetic. Lower2
must identify the signal-zero active entry selected by the block-extraction
target with the clean entry of the prepared singleton semantics. The narrowest
source-correct leaf is therefore an active/prepared entry theorem feeding one
of the following statements:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
```

The proof should not unfold the active placeholder list and then use
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` with
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`. That route proves a
diagnostic property of the H-free active matrix and does not supply the
source-prepared $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ entry.

#### 21.13.4 Proof-DAG Delta

| Node | Interface | Dependencies | Dependency class | Owner | Lean declaration or target | Status |
|---|---|---|---|---|---|---|
| `hw_uniform_contract` | clean-column amplitudes for each sparse slot | Eq. `arbitrary sparcity`; Shukla--Vedula implementation cited by GHL2025 | external-cited-contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | contract-only |
| `prepared_sparse_matrix_clean_entry` | clean-clean entry of `P_H` equals `S_H` | prepared sparse matrix definition | QBE-local matrix semantics | none | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` | proved |
| `prepared_singleton_eval` | singleton prepared composite semantics evaluates to `P_H[c,c]` | singleton `evalGateMatrices` evaluator | QBE-local matrix semantics | none | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3 H env` | proved |
| `prepared_sum_to_backend_fold` | under `hUniform`, `S_H` evaluates to the backend branch fold | `hw_uniform_contract`; seven-slot branch contribution definitions | GHL-internal plus QBE-local matrix semantics | none | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform` | proved conditional |
| `active_prepared_composition_leaf` | active signal-zero entry equals prepared singleton clean entry after evaluation | block-extraction active entry; prepared singleton clean entry; no diagnostic seven-gate zero route | QBE-local source-prepared composition field | lower2 | prove `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` or `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env` under the existing `hUniform` contract | active leaf |
| `raw_prepared_sandwich_field` | raw signal-zero entry equals `P_H[c,c]` or `S_H` before evaluation packaging | prepared sparse matrix clean-entry theorem | QBE-local stronger feeder | lower2 only if chosen | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | allowed equivalent feeder |
| `prepared_sandwich_to_fold_bridge` | prepared-sandwich eval is equivalent to evaluated backend fold under `hUniform` | `prepared_sum_to_backend_fold`; active-entry uncast bridge | QBE-local route bridge | none | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3 H env hUniform` | proved; retired |
| `h_free_active_selected_route` | active selected-slot comparison by H-free seven-gate diagnostics | diagnostic seven-gate identity; column-zero vanish theorem | QBE-local verifier feedback | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3 env hDiagnostic hActiveSelected` | retired as default target |

The next active leaf is `active_prepared_composition_leaf`. The raw
prepared-sandwich field is acceptable only if the worker routes it back through
the compiled prepared-sandwich bridge and keeps `hUniform` contract-only.

#### 21.13.5 Ordered Lean Lemmas For The Worker

Reuse existing declarations in this order:

1. `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H`.
2. `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H`.
3. `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
4. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3 H env`.
5. `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3 H env`.
6. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H`.
7. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3 H env`.
8. `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3 H env hUniform`.
9. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform`.
10. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform`, only after the active/prepared composition field is available.

Potential new Lean theorem names, ordered by dependency:

1. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_n3 H env hUniform`:
   prove the uncast active/prepared singleton comparison. This is the preferred
   leaf if the worker can supply the missing composition theorem.
2. `oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_n3 H env hUniform`:
   prove the equivalent prepared-sandwich evaluation statement using
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`.
3. `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_n3 H hUniform`:
   prove the stronger raw field only if it can be justified as the source
   prepared composite entry, not by rewriting the H-free active seven-gate
   product.

#### 21.13.6 Failure Analysis And Verifier Feedback

The current target is correct only as a prepared-circuit semantics field. A
theorem that quantifies arbitrary `H` and proves the prepared-sandwich equality
without the already named clean-column contract would be mathematically
ill-shaped because the prepared fold depends on `H`. A theorem that proves the
active side by the H-free diagnostic seven-gate zero route is also invalid for
source closure because Fig. `1 term ROBIN` requires both
$H_W^{(\kappa)}$ sides.

If lower2 cannot construct the active/prepared composition theorem, the useful
failure is not another backend slot theorem. It is a typed
`source_translation_gap` or `shape_or_register_gap` saying that the existing
`oneTermRobinGateMatrixPlaceholders` object exposes only the seven inner gates
and still lacks a theorem-facing prepared circuit semantics object for the
full $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ entry.

| Field | Value |
|---|---|
| `leaf` | `active_prepared_composition_leaf` |
| `source_correspondence_ok` | `true_for_prepared_sandwich_route_false_for_h_free_default_route` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed` |
| `finite_matrix_ok` | `partial_prepared_clean_entry_and_backend_fold_bridges_compiled_active_prepared_field_open` |
| `block_entry_ok` | `false_open_active_signal_zero_to_prepared_clean_entry` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `prove active/prepared singleton clean-entry composition field under existing HUniform contract, or record source_translation_gap for the missing theorem-facing prepared circuit semantics` |

Handoff: lower1 appended only this prepared-sandwich proof-DAG postscript. No
Lean source, oracle contract, theorem hypothesis, normalizer, gate label, paper
circuit, or semantic flag changed. Lower2 should edit only
`QuantumBlockEncoding/RobinMatrix.lean` and attempt the active/prepared
composition leaf or a raw prepared-sandwich feeder that returns through the
compiled bridge. The H-free active selected-slot comparison, selected-slot
backend fold, nonselected slot vanish lemmas, raw `Coeff` constructor route,
and diagnostic seven-gate zero route remain retired.

Concurrency note: after this Section 21.13 packet was drafted, lower2 compiled
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`.
Treat that strict prepared-matrix feeder as proved and retired. The next active
leaf is now the same mathematical field with one wrapper removed:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

This is still the active/prepared composition field. It remains a
source-prepared matrix-entry theorem, not a license to return to the H-free
diagnostic seven-gate zero route.

#### 21.14 Post-Feeder Active/Prepared Composition Leaf

This postscript is a narrow lower1 addendum after the compiled feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`.
That feeder is now proved and retired. The next Lean worker should target only
the unwrapped active/prepared composition field.

##### 21.14.1 Source Fragment Being Translated

| Source anchor | Fragment | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ sends the clean sparse-register basis vector to the uniform sparse-slot superposition, with implementation cited to Shukla--Vedula. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Thm. `1 term robin` | the one-term Robin circuit should be a block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. | GHL-internal theorem target plus external contracts | theorem-facing root still open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the boundary $\gamma_3$ clean branch carries the coefficient $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and sums over the sparse slots. | GHL-internal branch algebra plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H`; backend branch declarations |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | the theorem-facing route keeps both $H_W^{(\kappa)}$ sides, the explicit $U_{\mathrm{indic}}^\dagger$ role, pre-SWAP $\hat O_{D^T}^{BS}$, and post-SWAP $(\hat O_D^{BS})^\dagger$. | GHL-internal transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the clean signal block entry is the matrix entry that must match the prepared backend expression. | QBE-local projection semantics | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry` |

The exact local equation now assigned to lower2 is the right-hand side of the
compiled strict feeder:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

##### 21.14.2 Definitions And Local Claim

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`. Define

```lean
clean := oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

Define the active evaluated entry

```lean
A(env) :=
  Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

and the prepared sparse clean entry

```lean
P(H, env) :=
  Coeff.evalWith env
    (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H clean clean).
```

The active local theorem is `A(env) = P(H, env)`. The equivalent named wrappers
are:

```lean
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` is still
the external contract that specializes the prepared side to the backend branch
fold. It should remain explicit in downstream route bridges and must not be
promoted as a proved gate-level construction.

##### 21.14.3 Natural-Language Proof Design

The prepared side is already exposed. By
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`, the
prepared sparse matrix at `clean, clean` is the prepared sandwich fold
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`. The newly
compiled feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`
therefore proves that the named prepared-sandwich evaluated target is exactly
the unwrapped comparison `A(env) = P(H, env)`.

Under the explicit clean-column contract, the prepared sandwich fold evaluates
to the backend branch fold by
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3` and
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
This explains the source coefficient $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$:
one factor of $1/\sqrt{\kappa}$ comes from the ket-side preparation and the
matching bra-side factor comes from the dagger convention. These theorems do
not prove the active/prepared composition field; they only settle the prepared
side once the source-prepared entry has been selected.

The remaining work is the active-side composition theorem. The active entry is
the `[0,0]` entry of the H-free seven-gate placeholder product selected by the
block-extraction wrapper. The prepared entry is the clean-clean entry of the
source-prepared sparse-register sandwich. Lower2 must prove that these two
entries match, or record that the current active `CircuitMatrixSemantics` object
still lacks a theorem-facing field relating the seven-gate core to the prepared
$H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich.

The proof must not return to
`ActiveSelectedSlotEvalComparison` by combining
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` with
`oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3`. That route is a
diagnostic for the H-free active matrix and does not supply the source-prepared
sandwich entry required by Fig. `1 term ROBIN`.

##### 21.14.4 Proof-DAG Delta

| Node | Interface | Dependencies | Dependency class | Owner | Lean declaration or target | Status |
|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing gate order keeps both $H_W^{(\kappa)}$ sides and explicit $U_{\mathrm{indic}}^\dagger$ | source Fig. `1 term ROBIN`; indicator self-inverse bridge | GHL-internal transcript plus QBE-local bridge | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | proved guard |
| `hw_uniform_contract` | sparse-preparation clean column has uniform slot amplitudes | Eq. `arbitrary sparcity`; cited Shukla--Vedula implementation | external-cited-contract | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | contract-only |
| `prepared_sparse_clean_entry` | prepared sparse clean-clean entry is the prepared sandwich fold | prepared sparse matrix definition | QBE-local matrix semantics | none | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` | proved |
| `strict_prepared_sparse_feeder` | named prepared-sandwich eval target is equivalent to `A(env) = P(H, env)` | `prepared_sparse_clean_entry` | QBE-local evalWith bridge | none | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env` | proved; retired as lower target |
| `prepared_side_to_backend` | under `hw_uniform_contract`, the prepared side evaluates to the backend branch fold | clean-column contract; prepared sandwich contribution lemmas | external-cited-contract plus QBE-local semantic bridge | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`; `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform` | proved conditional; not closure |
| `active_prepared_composition_leaf` | prove `A(env) = P(H, env)` | active uncast entry bridge; prepared sparse clean-entry feeder; source-prepared circuit field record | QBE-local finite matrix semantics | lower2 | RHS of `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env`; equivalent targets listed above | active leaf |
| `source_prepared_projection_field` | theorem-facing source-prepared active field follows from the uncast active/prepared comparison | `active_prepared_composition_leaf`; source projection target bridges | QBE-local projection bridge | lower2 after active leaf | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | open dependent |
| `unitary_fold_leaf` | full signal-zero unitary entry evaluates to the backend fold | `active_prepared_composition_leaf`; `prepared_side_to_backend` | QBE-local backend fold | later lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | open dependent |
| `h_free_active_selected_route` | H-free selected-slot comparison through seven-gate zero diagnostics | diagnostic obstruction and retired slot work | QBE-local diagnostic only | none | `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`; `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3` | stale by default |

The next active leaf is `active_prepared_composition_leaf`.

##### 21.14.5 Ordered Lean Lemmas For The Worker

Reuse existing declarations in this order:

1. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H`.
2. `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env`.
3. `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3 H env`.
4. `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_sparseEval_n3 H env`.
5. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3 H env`.
6. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env`.
7. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H`.
8. `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3 H env`.
9. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform`, only for the downstream backend-fold bridge.
10. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform`, only after the active/prepared composition leaf is supplied.

Potential new Lean theorem names, from smallest to largest:

1. `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_n3 H env`:
   the exact unwrapped equality `A(env) = P(H, env)`.
2. `oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_n3 H env`:
   close the named prepared-sandwich statement through the strict feeder.
3. `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_n3 H env`:
   close the active/prepared singleton wrapper through the prepared-sandwich
   bridge.
4. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H` entry equality:
   close the stronger raw active/prepared entry field if the proof is cleaner.

If the theorem is stated with an explicit `hUniform`, it is a conditional
route theorem, not closure of an unconditional arbitrary-`H` equality. Such a
conditional theorem is useful only if middle names it as the next accepted
feeder.

##### 21.14.6 Failure Analysis And Verifier Feedback

The current target is source-correct only as an active/prepared composition
field. The left-hand side is H-free, while the right-hand side contains entries
of `H` through the prepared sparse-register matrix. If lower2 is asked to prove
the unwrapped equality for arbitrary `H` without a composition theorem or an
explicit clean-column route, that statement should be reported as a
`source_translation_gap` or `shape_or_register_gap` instead of patched by adding
new assumptions or changing the circuit.

The strict prepared-sparse feeder is no longer the active theorem. Reassigning
it, repeating backend slot vanish/support work, using the raw `Coeff`
constructor-equality route, or reviving the H-free active-selected diagnostic
route is stale.

| Field | Value |
|---|---|
| `leaf` | `active_prepared_composition_leaf` |
| `source_correspondence_ok` | `true_for_source_prepared_route` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed` |
| `finite_matrix_ok` | `partial_strict_prepared_sparse_feeder_compiled_active_prepared_field_open` |
| `block_entry_ok` | `false_open_active_entry_to_prepared_sparse_clean_entry` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `none_for_plan_shape_or_register_gap_if_unconditional_arbitrary_H_target_is_required` |
| `next_route` | `prove the unwrapped active seven-gate evalWith entry equals the prepared sparse clean-clean entry, or record a source_translation_gap for the missing theorem-facing prepared circuit semantics field` |

Handoff: lower1 appended this post-feeder proof-DAG packet only. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. Lower2 should edit only `QuantumBlockEncoding/RobinMatrix.lean`
and attempt exactly `active_prepared_composition_leaf` or a smaller theorem
that feeds it directly.

#### 21.15 Post-Source-Projection Feeder Route Check

This is a narrow lower1 postscript after the compiled feeder
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`.
It does not change the active Lean target. It records the exact proof shape and
the current mathematical risk of treating the unwrapped target as an
unconditional arbitrary-`H` theorem.

##### 21.15.1 Source Fragment Being Translated

The source fragment is the same prepared sparse-register sandwich used in
Sections 21.13 and 21.14.

| Source anchor | Fragment | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}^{\lceil\log_2\kappa\rceil} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}^{\lceil\log_2\kappa\rceil}$, with implementation delegated to Shukla--Vedula. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Theorem `1 term robin` | the Robin one-term circuit is claimed as a block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$. | GHL-internal theorem target plus external contracts | theorem-facing root remains open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the $\gamma_3$ boundary branch has the clean coefficient $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$ after the two sparse-preparation amplitudes are paired. | GHL-internal branch algebra plus QBE-local matrix semantics | `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`; `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | the theorem-facing route contains the prepared $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich, explicit `U_indic^dagger`, pre-SWAP $\hat O_{D^T}^{BS}$, and post-SWAP $(\hat O_D^{BS})^\dagger$. | GHL-internal transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the clean signal-system block entry is the matrix entry that eventually witnesses the block-encoding. | QBE-local projection semantics | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |

The exact unwrapped equation now exposed by the source-projection feeder is:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

##### 21.15.2 Definitions And Local Claim

Fix `H : Matrix 8 8 Coeff` and `env : String -> Rat`. Define
`clean := oneTermRobinGamma3BoundarySparseCleanIndex_n3`.

Define the active evaluated entry by

```lean
A(env) :=
  Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define the prepared sparse clean entry by

```lean
P(H, env) :=
  Coeff.evalWith env
    (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H clean clean)
```

The active local proposition is `A(env) = P(H, env)`. The newest compiled
source-projection feeder proves that this proposition is equivalent to the
theorem-facing source-prepared active field:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The proposition is therefore the current frontier. It is not a proof of the
one-term theorem, not a proof of the sparse-preparation primitive, and not a
block-correctness or final-extraction theorem.

##### 21.15.3 Natural-Language Proof Design

The prepared side has already been reduced. The clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` is the prepared
sandwich fold by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H`.
Under the external clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, that
fold evaluates to the backend branch fold by
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform`
and `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`.
This accounts for the two factors of `sqrt_kappa_inv` in the source equation
and produces the displayed $\kappa^{-1}$ coefficient in Eq. `ROBIN clarified`.

The active side has also been unwrapped. The source-projection target now
uses the `[0,0]` entry of the active seven-gate placeholder product selected
by the block-extraction wrapper. The compiled theorem
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3`
says that proving the theorem-facing active field is exactly proving
`A(env) = P(H, env)`.

The remaining mathematical content is therefore not another wrapper bridge.
It is the finite composition theorem that identifies the active seven-gate
signal entry with the source-prepared sparse-register sandwich entry. The
source paper uses the specific $H_W^{(\kappa)}$ preparation, not an arbitrary
matrix. Thus an unconditional theorem over arbitrary `H` has no source proof
as stated unless a separate Lean theorem first shows that this `H` is the
paper's sparse-preparation matrix or the route is explicitly conditional on
the existing clean-column contract. Lower2 should either prove the current
composition field from a source-backed circuit-semantics theorem, or record
the missing theorem as a `shape_or_register_gap`.

##### 21.15.4 Proof-DAG Delta

| Node | Interface | Dependencies | Dependency class | Owner | Lean declaration or target | Status |
|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | Fig. `1 term ROBIN` transcript keeps both $H_W^{(\kappa)}$ sides and the explicit dagger roles | source figure; indicator self-inverse bridge | GHL-internal transcript plus QBE-local bridge | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | proved guard |
| `prepared_sparse_clean_entry` | clean-clean entry of the prepared sparse matrix is the prepared sandwich fold | prepared sparse matrix definition | QBE-local matrix semantics | none | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H` | proved |
| `prepared_side_to_backend` | under `HUniform`, the prepared clean entry evaluates to the backend branch fold | clean-column contract; prepared sandwich contribution lemmas | external-cited-contract plus QBE-local semantic bridge | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | proved conditional; retired as closure target |
| `strict_prepared_sparse_feeder` | prepared-sandwich target is equivalent to `A(env) = P(H, env)` | prepared sparse clean entry | QBE-local evalWith bridge | none | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env` | proved feeder; retired |
| `source_projection_sparse_feeder` | theorem-facing source-projection active field is equivalent to `A(env) = P(H, env)` | strict prepared sparse feeder; source projection target wrapper | QBE-local projection/eval bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` | proved feeder; retired |
| `active_prepared_composition_leaf` | prove `A(env) = P(H, env)` without changing the paper circuit or oracle contracts | active seven-gate uncast entry; prepared sparse clean entry; source-backed composition theorem still missing | QBE-local finite matrix semantics | lower2 | RHS of `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env` | active leaf, blocked if arbitrary `H` remains unconstrained |
| `source_prepared_entry_leaf` | recover the theorem-facing active/prepared field after the active leaf | `active_prepared_composition_leaf`; source-projection feeder | QBE-local projection bridge | lower2 after active leaf | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | open dependent |
| `unitary_fold_leaf` | recover the backend fold under `HUniform` after the active field | `active_prepared_composition_leaf`; `prepared_side_to_backend` | QBE-local backend fold bridge | later lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or equivalent fold target | open dependent |
| `retired_diagnostics` | H-free selected-slot diagnostics, backend slot support/vanish work, raw `Coeff` constructor equalities, and bridge rediscovery | stale routes | QBE-local diagnostics/backlog | none | existing diagnostic declarations | stale |

The next active leaf for a Lean worker is `active_prepared_composition_leaf`.
If no source-backed theorem can relate the active seven-gate semantics to the
prepared sandwich for the specific sparse-preparation matrix, the correct
output is a smaller compiled obstruction or a typed failure note, not an
assumption added to the theorem.

##### 21.15.5 Ordered Lean Lemmas For The Worker

Reuse existing declarations in this order:

1. `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H`.
2. `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env`.
3. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env`.
4. `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3 H env`.
5. `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_sparseEval_n3 H env`.
6. `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_iff_uncast_n3 H env`.
7. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_preparedCleanEntry_n3 H`.
8. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform`, only for the downstream backend-fold route.
9. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`, only after the active/prepared field is supplied or explicitly assumed as a feeder.
10. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_backendEval_n3 H env hUniform`, only for downstream recovery, not as a replacement proof of the active leaf.

Candidate smaller Lean leaves, ordered by source faithfulness:

1. `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_n3 H env`:
   prove exactly `A(env) = P(H, env)` if the missing composition theorem is
   available.
2. `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3 H env`:
   compile a transcript theorem recording that the active field is still
   missing because `H` is unconstrained. This is acceptable only as failure
   memory, not as theorem closure.
3. `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H` entry equality:
   prove the stronger raw field only if the proof uses a source-backed
   prepared-composition theorem and does not revive raw `Coeff` constructor
   equality as the main route.

##### 21.15.6 Failure Analysis And Verifier Feedback

The displayed target is source-faithful as a name for the remaining
composition field, but it is not paper-backed as an unconditional theorem for
all `H`. The left-hand side is the active seven-gate placeholder product and
does not depend on `H`; the right-hand side is the clean-clean entry of
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` and explicitly
depends on `H`. The source paper fixes `H` to the sparse-preparation operation
$H_W^{(\kappa)}$ and cites its implementation. It does not claim the same
entry equality for an arbitrary sparse-register matrix.

Therefore the current lower route should not add hypotheses, change the
normalizer, or mutate the circuit to force the arbitrary-`H` theorem. If the
Lean worker cannot prove the exact active/prepared field from existing
source-backed declarations, the useful result is to compile or record the
obstruction: the theorem-facing prepared circuit semantics still needs either
a concrete `H_W^{(\kappa)}` matrix declaration or a conditional route through
the existing clean-column contract.

| Field | Value |
|---|---|
| `leaf` | `active_prepared_composition_leaf` |
| `source_correspondence_ok` | `true_as_remaining_source_prepared_field_false_as_unconditional_arbitrary_H_theorem` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed` |
| `finite_matrix_ok` | `partial_prepared_side_and_projection_feeders_compiled_active_prepared_field_open` |
| `block_entry_ok` | `false_active_entry_to_prepared_sparse_clean_entry_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `prove a source-backed active/prepared composition theorem for the prepared H_W sandwich, or record a source_translation_gap for the missing concrete H_W semantics instead of proving arbitrary-H equality` |

Handoff: lower1 appended this Section 21.15 route check only. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. Lower2 should edit only `QuantumBlockEncoding/RobinMatrix.lean`
and either prove `active_prepared_composition_leaf` from an existing
source-backed composition theorem or record the arbitrary-`H` mismatch as a
typed obstruction.

##### 21.15.7 Post-Bridge Retirement Postscript

Lower2 has now compiled
`oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`.
This bridge retires `active_prepared_composition_leaf` as the preferred next
lower target. It is route wiring only: under
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
the exact unwrapped sparse-clean equality is equivalent to
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

The source fragment being translated is unchanged. Eq. `arbitrary sparcity`
at `main.tex:948-955` supplies the clean column of $H_W^{(\kappa)}$ as an
external contract; Theorem `1 term robin` and Eq. `ROBIN clarified` at
`main.tex:1098-1119` identify the one-term Robin block-encoding target and
the gamma3 boundary coefficient $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$; Fig.
`1 term ROBIN` at `main.tex:1122-1164` fixes the prepared sandwich circuit;
Definition `def:block-encoding` at `main.tex:2027-2035` explains why the clean
signal-system entry is the theorem-facing projection.

For fixed `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and
`hUniform`, define

```lean
A(env) :=
  Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)

P(H, env) :=
  Coeff.evalWith env
    (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
      oneTermRobinGamma3BoundarySparseCleanIndex_n3
      oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

and let

```lean
B(env) := oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The compiled bridge proves `(A(env) = P(H, env)) ↔ B(env)`. Therefore the
active proof-DAG leaf is now `evaluated_backend_fold_leaf`, not another proof
of the sparse-clean bridge. A Lean worker can prove the leaf by proving the
right-hand side exposed by
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`,
namely that the evaluated active seven-gate `[0,0]` entry equals the evaluated
backend branch fold. If the worker instead attacks `A(env) = P(H, env)`
directly, the proof must keep `hUniform` explicit through the compiled bridge;
an unconditional arbitrary-`H` theorem would be stronger than the paper source.

| Node | Interface | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|---|
| `post_feeder_sparse_clean_to_fold_bridge` | `(A(env) = P(H, env)) ↔ B(env)` under `hUniform` | strict prepared-sparse feeder; prepared clean-entry backend theorem | proved; retired | none | reuse only |
| `evaluated_backend_fold_leaf` | prove `B(env)` | active-entry uncast bridge; backend fold semantics | active leaf | lower2 | prove `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or a direct evaluated entry feeder |
| `active_prepared_composition_leaf` | prove `A(env) = P(H, env)` | post-feeder bridge; `hUniform` if routed through prepared side | equivalent but no longer preferred | lower2 only if chosen | keep `hUniform` explicit; do not claim arbitrary `H` |
| `source_prepared_entry_leaf` | recover theorem-facing active/prepared field | evaluated/active leaf plus source projection wrappers | open dependent | later lower2 | wait for active leaf |
| `unitary_fold_leaf` | recover raw signal-zero fold | evaluated fold; raw/evaluated bridge | open dependent | later lower2 | wait for evaluated fold |

Ordered Lean route for the next worker:

1. Reuse
   `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`
   only as a bridge.
2. Reuse
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`
   to reduce `B(env)` to the evaluated active-entry/backend-fold equality.
3. Prove a smaller feeder such as the uncast evaluated active-entry equality
   against `blockExtractionBranchContributionSum
   oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, then close `B(env)`
   by the equivalence in step 2.
4. Use
   `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env`
   only inside the evaluated fold proof if it helps; do not reassign retired
   selected-slot vanish/support leaves.
5. Avoid the diagnostic raw `Coeff` route through
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as theorem
   closure, because that declaration remains a guarded obstruction record.

Failure analysis: the current target is mathematically well-shaped as
`B(env)`. A failure to prove `B(env)` is a finite evaluated matrix-semantics
gap or tactic gap. A failure caused by replacing it with an unconditional
`A(env) = P(H, env)` theorem over arbitrary `H` is a shape/register gap, since
the source fixes $H$ through $H_W^{(\kappa)}$ and its clean-column contract.

| Field | Value |
|---|---|
| `leaf` | `evaluated_backend_fold_leaf` |
| `source_correspondence_ok` | `true_for_evaluated_backend_fold_false_for_unconditional_arbitrary_H_sparse_equality` |
| `lean_parse_ok` | `true_after_minimal_diagnostic_lean_repair` |
| `lean_build_ok` | `true_after_minimal_diagnostic_lean_repair_and_gate` |
| `finite_matrix_ok` | `partial_compiled_bridge_reduces_sparse_clean_leaf_to_evaluated_fold` |
| `block_entry_ok` | `false_evaluated_backend_fold_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a direct evaluated active-entry/backend-fold lemma feeding it; keep hUniform explicit if using the sparse-clean equality` |

Handoff: this postscript only retires the compiled bridge
`oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`
as a target and names `evaluated_backend_fold_leaf` as the next active lower
leaf. During the final clean rebuild, Lean exposed a max-recursion failure in
the diagnostic theorem
`oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; the only
Lean repair was to remove the expensive pre-`sorry` simplification from that
already sorry-guarded diagnostic proof body. No oracle contract, theorem
hypothesis, normalizer, gate label, paper circuit, or semantic flag changed,
and no target theorem was closed.

#### 21.16 Post-Bridge Evaluated Backend Fold Frontier

This is a narrow lower1 postscript after lower2 compiled
`oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3`.
The bridge is now route wiring only. It should not be assigned as a lower
target.

##### 21.16.1 Source Fragment Being Translated

The source proof fragment remains the same Fig. `1 term ROBIN` prepared
sandwich, but the active Lean leaf has moved one equivalence step:

| Source anchor | Fragment | Dependency class | Lean interface |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | The sparse-preparation column satisfies $H_W^{(\kappa)}\ket{0} = \kappa^{-1/2}\sum_s \ket{s}$. | external-cited-contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` |
| `main.tex:1098-1109`, Theorem `1 term robin` | The theorem-facing circuit should give a $(\mathcal{N}_D\mathcal{N}_f\kappa, \cdots, 0)$ block-encoding. | GHL-internal theorem target plus contracts | theorem-facing root remains open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The gamma3 boundary term has coefficient $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$ after the two sparse-preparation amplitudes are paired. | GHL-internal branch algebra plus QBE-local semantics | prepared clean-entry-to-backend lemmas |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | The theorem-facing circuit contains the two $H_W^{(\kappa)}$ boundary gates, explicit `U_indic^dagger`, pre-SWAP $\hat O_{D^T}^{BS}$, and post-SWAP $(\hat O_D^{BS})^\dagger$. | GHL-internal transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal-system projection selects the matrix entry that must match the encoded operator entry. | QBE-local projection semantics | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` |

Define the active uncast evaluated entry by

```lean
A(env) :=
  Coeff.evalWith env
    ((evalGateMatrices
      (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
      oneTermRobinGamma3BoundaryPrefixRow0_n3
      oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Define the prepared sparse clean-clean entry by

```lean
P(H, env) :=
  Coeff.evalWith env
    (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
      oneTermRobinGamma3BoundarySparseCleanIndex_n3
      oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Define the evaluated backend fold by

```lean
B(env) :=
  oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The newly compiled bridge states, under
`hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`,
that `A(env) = P(H, env)` is equivalent to `B(env)`.

##### 21.16.2 Natural-Language Proof Of The Local Frontier

The definitions above separate the two remaining statements. The equation
`A(env) = P(H, env)` is the unwrapped active/prepared sparse-clean equality.
It still contains an arbitrary parameter `H`. The paper source does not claim
this equality for every matrix `H`; it uses the specific sparse-preparation
operation $H_W^{(\kappa)}$ whose clean column is recorded in Lean by
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.

Under that clean-column contract, the prepared side is already accounted for.
The theorem
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`
turns the prepared clean-clean entry into the backend branch fold. This is the
Lean version of the two $1/\sqrt{\kappa}$ factors in Eq. `ROBIN clarified`
becoming the $1/\kappa$ coefficient in the gamma3 boundary branch.

The active side is also already unwrapped to the selected signal-zero entry.
The theorem
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`
identifies `B(env)` with the evaluated `[0,0]` entry of the active seven-gate
placeholder product compared with the same backend branch fold.

Therefore the next mathematical leaf is not another wrapper theorem. It is
one of the two equivalent finite evaluated matrix-entry statements:

1. Prove `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
2. Prove the exact unwrapped equality `A(env) = P(H, env)` only through a
   source-backed prepared-composition theorem for the `H_W^{(\kappa)}`
   sandwich, or under the existing `hUniform` route.

The first option is the preferred next Lean target because it avoids claiming
an unconditional arbitrary-`H` theorem. If lower2 attacks the sparse-clean
equality directly and cannot connect `H` to the paper's prepared column, the
result should be logged as a `shape_or_register_gap` or
`source_translation_gap`, not repaired by changing hypotheses, normalizers,
or circuit labels.

##### 21.16.3 Proof-DAG Delta

| Node | Interface | Dependencies | Dependency class | Owner | Lean declaration or target | Status |
|---|---|---|---|---|---|---|
| `fig4_transcript_guard` | theorem-facing Fig. `1 term ROBIN` transcript, including both $H_W^{(\kappa)}$ sides and explicit dagger roles | source figure; indicator bridge | GHL-internal transcript plus QBE-local bridge | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | proved guard |
| `prepared_side_to_backend` | under `hUniform`, the prepared clean-clean entry evaluates to the backend branch fold | clean-column contract; prepared sandwich backend theorem | external-cited-contract plus QBE-local semantic bridge | none | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | proved conditional; reusable |
| `strict_prepared_sparse_feeder` | prepared-sandwich equality is equivalent to `A(env) = P(H, env)` | prepared sparse clean-entry theorem | QBE-local evalWith bridge | none | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env` | proved feeder; retired |
| `post_feeder_sparse_clean_to_fold_bridge` | under `hUniform`, `A(env) = P(H, env)` is equivalent to `B(env)` | strict prepared-sparse feeder; prepared-side backend bridge | QBE-local equivalence bridge under external clean-column contract | none | `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | proved bridge; retired |
| `evaluated_backend_fold_leaf` | prove the evaluated signal-zero entry equals the backend branch fold | active entry uncast bridge; backend branch fold semantics | QBE-local finite matrix semantics | lower2 | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | next active leaf |
| `active_prepared_composition_leaf` | prove `A(env) = P(H, env)` only through the source-prepared route | post-feeder bridge; source-backed prepared-composition theorem still missing if `H` is arbitrary | QBE-local finite matrix semantics plus external clean-column contract | lower2 if selected | exact unwrapped equality in `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform` | active equivalent leaf; not unconditional for arbitrary `H` |
| `source_prepared_entry_leaf` | recover theorem-facing source-prepared active field | active/evaluated leaf; source projection wrappers | QBE-local projection bridge | later lower2 | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` | open dependent |
| `unitary_fold_leaf` | recover raw full signal-zero fold after evaluated theorem closure | evaluated fold; raw/evaluated bridge if needed | QBE-local projection/backend theorem | later lower2 | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3` | open dependent root |
| `retired_routes` | strict feeders, finite active/prepared reduction guards, H-free active-selected diagnostics, slot vanish/support work, raw `Coeff`, branch-sum wrappers, and compiled bridge rediscovery | stale or diagnostic routes | QBE-local diagnostics/backlog | none | declarations already recorded in Lean and the conversion window | stale; do not assign |

The next active leaf for a Lean worker is `evaluated_backend_fold_leaf`. The
unwrapped sparse-clean equality remains an acceptable equivalent only when the
proof route respects the existing `hUniform` contract and does not promote an
arbitrary-`H` theorem.

##### 21.16.4 Ordered Lean Lemmas For The Worker

Reuse existing declarations in this order:

1. `oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3 H env hUniform`, only as a bridge; do not reprove it.
2. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`, to expose the active evaluated `[0,0]` entry.
3. `oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`, through the theorem above, for the block-extraction-to-active-entry rewrite.
4. `oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3 env`, through the theorem above, for the cast removal.
5. `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env`, only as an existing backend simplifier inside a proof of the evaluated fold; do not reassign slot vanish/support work.
6. `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`, only for recovery through the prepared route.
7. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env`, only after a proof of the active/evaluated leaf is available.
8. `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`, only for the equivalent backend-expansion endpoint.

Candidate direct Lean leaves, ordered by source faithfulness:

1. `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`: preferred
   active leaf.
2. A smaller theorem proving the right-hand statement of
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
3. The exact unwrapped sparse-clean equality `A(env) = P(H, env)`, but only
   when the proof explicitly routes through the existing `hUniform` contract
   or a source-backed concrete prepared-composition theorem.

Do not target the newly compiled bridge, the strict prepared-sparse feeder, raw
`Coeff` constructor equality, branch-sum wrappers, or H-free selected-slot
diagnostics as standalone lower leaves.

##### 21.16.5 Failure Analysis And Verifier Feedback

The current target is mathematically well-shaped when read as an evaluated
backend-fold theorem. It is risky only if it is replaced by an unconditional
claim that `A(env) = P(H, env)` for all `H`. The left side has no `H`, while
the right side depends on the prepared sparse matrix parameter. The paper
fixes that parameter through $H_W^{(\kappa)}$ and a cited clean-column
contract, so an arbitrary-`H` proof would be stronger than the source.

| Field | Value |
|---|---|
| `leaf` | `evaluated_backend_fold_leaf` |
| `source_correspondence_ok` | `true_for_evaluated_fold_under_post_feeder_bridge_false_for_unconditional_arbitrary_H_sparse_equality` |
| `lean_parse_ok` | `true_markdown_only_no_lean_edit` |
| `lean_build_ok` | `true_markdown_only_gate_passed` |
| `finite_matrix_ok` | `partial_bridge_compiled_evaluated_fold_open` |
| `block_entry_ok` | `false_evaluated_backend_fold_still_open` |
| `ancilla_cleanup_ok` | `not_promoted` |
| `normalizer_ok` | `unchanged` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env or a smaller evaluated matrix-entry lemma feeding it; if attacking sparse-clean equality directly, keep hUniform explicit or record shape_or_register_gap` |

Handoff: lower1 appended this Section 21.16 route check only. No Lean source,
oracle contract, theorem hypothesis, normalizer, gate label, paper circuit, or
semantic flag changed. Lower2 should edit only `QuantumBlockEncoding/RobinMatrix.lean`
and attempt the evaluated backend fold, the exact sparse-clean equality through
the compiled post-feeder bridge, or a strictly smaller evaluated matrix-entry
lemma that feeds one of those two statements.
