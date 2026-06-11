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
