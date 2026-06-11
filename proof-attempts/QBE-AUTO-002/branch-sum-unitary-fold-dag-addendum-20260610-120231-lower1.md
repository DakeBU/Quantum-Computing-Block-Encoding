# QBE-AUTO-002 Lower 1 Addendum: Branch-Sum Via Full-Unitary Fold

Created: 2026-06-10 12:02 JST

Scope: natural-language proof architecture only. This addendum edits no Lean
source, changes no oracle contract, and promotes no theorem-facing semantic
flag. It continues
`proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`
after the latest branch-sum/unitary-fold bridge.

## 1. Exact Source Fragment

The source-paper fragment being translated is the clean boundary part of
Eq. `ROBIN clarified`, in the theorem and Fig. `1 term ROBIN` context:

$$
\ket{\gamma_3}
=
\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
\sum_{\substack{s=0,\dots,\kappa-1 \\
0 \leq j < K_1 \cup K_2 < j < 2^n}}
f(x_i)(D)_i^{(s)}\sigma^{(s)}
\ket{0}^{m_f+1}\ket{s}^{\lceil\log_2\kappa\rceil}
\ket{0}^{n-\lceil\log_2\kappa\rceil}\ket{j}^n\ket{0}
+ \dots .
$$

The sparse-register preparation fragment used by this equation is Eq.
`arbitrary sparcity`:

$$
H_W^{(\kappa)}\ket{0}^{\lceil\log_2\kappa\rceil}
=
\frac{1}{\sqrt{\kappa}}
\sum_{s=0}^{\kappa-1}\ket{s}^{\lceil\log_2\kappa\rceil}.
$$

The block-extraction fragment is Definition `def:block-encoding`: project the
clean signal/ancilla component of the circuit output and compare the resulting
system entry with the encoded operator entry.

## 2. Definitions Before Claims

Define `SignalBlockEntry` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry
```

Define `SignalUnitaryEntry` as:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry
```

Define `BackendContribution(s)` for `s : Fin 7` as:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s
```

Define `BackendFold` as:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The older local name
`oneTermRobinGamma3BoundaryBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3` is definitionally the
same seven-slot fold through the branch-sum wrapper.

For an explicit sparse-register preparation matrix `H`, define the prepared
sandwich fold as:

```lean
oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H
```

Under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, Lean
already proves:

```lean
oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform
```

so the prepared sandwich fold specializes to `BackendFold`.

## 3. Natural-Language Proof Of The Active Local Theorem

The active branch-sum theorem is:

```lean
SignalBlockEntry =
  oneTermRobinGamma3BoundaryBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled bridge
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`
shows that this theorem is equivalent to:

```lean
SignalUnitaryEntry = BackendFold
```

The source proof structure is the following.

First, Eq. `arbitrary sparcity` makes the clean sparse-register ket a uniform
sum over all seven paper slots in the focused `n = 3`, `kappa = 7` witness.
The dagger side contributes the matching clean bra amplitude. In Lean, this is
the contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` together
with the transpose-style dagger matrix
`oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3`.

Second, the all-slot backend summand is already defined and uniformly exposed:
`oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3 s` identifies
each backend contribution with the diagonal seven-gate entry at
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s` multiplied by the two
sparse-register amplitudes. The selected source branch is slot `2`, by
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`, but the
paper equation sums over all sparse slots. Therefore slot `2` proves only the
selected summand, not the fold.

Third, Definition `def:block-encoding` says that the clean projected system
entry is obtained from the signal-zero block of the circuit matrix. Lean has
already compiled the bridge from `SignalBlockEntry` to `SignalUnitaryEntry`.
The remaining local theorem is exactly the finite projection/backend expansion:
the signal-zero full-unitary entry must expand as the seven-slot prepared
backend fold.

Thus the next Lean worker should prove one of the following direct feeders:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

or, under the existing clean-column contract,

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H
```

The second statement feeds the first through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedSandwichBackend_n3` and
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.

## 4. Seven-Slot Survive/Vanish Audit

| Slot | Existing Lean declarations | Survive/vanish status | Dependency class |
|---|---|---|---|
| `0` | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`; `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` | Survives as a fold summand. It is diagnostic for the `[0,0]` active entry and is not a vanish theorem. | QBE-local matrix semantics |
| `1` | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | Survives as an all-slot prepared backend summand. No zero or cancellation theorem is compiled. | QBE-local matrix semantics |
| `2` | `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3` | Survives as the focused displayed `gamma_3` boundary summand. | GHL-internal branch plus QBE-local matrix semantics |
| `3` | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | Survives as an all-slot prepared backend summand. No zero or cancellation theorem is compiled. | QBE-local matrix semantics |
| `4` | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | Survives as an all-slot prepared backend summand. No zero or cancellation theorem is compiled. | QBE-local matrix semantics |
| `5` | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | Survives as an all-slot prepared backend summand. No zero or cancellation theorem is compiled. | QBE-local matrix semantics |
| `6` | `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3` | Survives as an all-slot prepared backend summand. No zero or cancellation theorem is compiled. | QBE-local matrix semantics |

No backend slot currently vanishes by a named Lean theorem. A future vanish or
cancellation lemma must be proved from the existing matrices before any slot is
removed from the fold.

## 5. Proof-DAG Table

| Node | Dependencies | Status | Owner | Next action |
|---|---|---|---|---|
| `fig4_transcript_guard` | Theorem `1 term robin`; Fig. `1 term ROBIN`; indicator dagger role | compiled | middle/reviewer | Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`. |
| `hw_uniform_contract` | Eq. `arbitrary sparcity`; Shukla--Vedula implementation claim | external-cited-contract | future cited-contract worker | Reuse only as `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; do not mark proved. |
| `signal_block_to_unitary` | Definition `def:block-encoding`; signal-zero block convention | compiled | lower/middle | Reuse `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`. |
| `branch_sum_to_unitary_fold` | `signal_block_to_unitary`; fold-name bridge | compiled bridge | lower 2 | Use `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3` to close the wrapper after the fold is proved. |
| `all_slot_summand_formula` | branch full-index map; sparse projection amplitude factor | compiled | lower/middle | Reuse `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`. |
| `prepared_fold_specializes_backend` | `hw_uniform_contract`; all-slot prepared sandwich contributions | compiled conditional | lower/middle | Reuse `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3 H hUniform`. |
| `unitary_fold_leaf` | `all_slot_summand_formula`; finite product/projection expansion | open active leaf | lower 2/refiner | Prove `SignalUnitaryEntry = BackendFold`, or prove a named strict feeder. |
| `prepared_sandwich_raw_entry_leaf` | `hw_uniform_contract`; prepared sandwich target | open strict feeder | lower 2/refiner | Prove `SignalUnitaryEntry = oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`; then use the compiled conditional fold bridge. |
| `backend_expansion_endpoint` | `unitary_fold_leaf` | open equivalent endpoint | lower 2/refiner | Close through `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`. |
| `final_block_encoding_root` | backend expansion; oracle contracts; product-to-coefficient; normalized equality | open | future upper/middle | Do not claim complete in this packet. |

The next active leaf for a Lean worker is:

```lean
theorem <new_name> :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- finite projection/backend expansion proof
```

A strictly smaller acceptable feeder is:

```lean
theorem <new_name>
    (H : Matrix 8 8 Coeff)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H := by
  -- prepared-sandwich raw-entry proof
```

This feeder must not be stated for arbitrary `H` without `hUniform`.

## 6. Ordered Lean Lemmas To Reuse

1. `signalSystemBlockProjection_apply`.
2. `oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`.
3. `oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`.
4. `blockExtractionBranchContributionSum`.
5. `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.
6. `oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3`.
7. `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.
8. `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`, for diagnostics only.
9. `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`, for diagnostics only.
10. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`.
11. `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.
12. `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedSandwichBackend_n3`.
13. `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_unitaryEntryFold_n3`.
14. `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`.
15. `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.
16. `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`.
17. `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`.

## 7. Failure Analysis

The current target is mathematically right as a local finite projection/backend
statement, but the implementation route should not attack the branch-sum
wrapper directly. The wrapper is now only a named consequence of the
full-unitary fold by
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`.

The selected-slot route is insufficient. It proves the slot-`2` displayed
boundary summand, while the source expression and the two `H_W^(kappa)` sides
produce an all-slot fold.

The column-`0` and raw `Coeff` constructor routes remain diagnostic. The
diagnostic theorem
`oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` still contains
`sorry`; previous direct `rfl` and `native_decide` attempts were recorded as
resource failures. A new Lean leaf should expose a smaller finite
product/projection theorem or the prepared-sandwich raw-entry equality, rather
than retrying the entire raw equality.

An arbitrary-`H` active/prepared equality would be too strong. The prepared
side depends on `H`; the paper step uses only matrices satisfying the
`H_W^(kappa)` clean-column contract.

## 8. Handoff

Lower 1 added this branch-sum/unitary-fold DAG continuation for run
`20260610-120231-QBE-AUTO-002-cycle01`. The direct branch-sum theorem remains
open, but its current local content is the equivalent full signal-unitary
seven-slot fold. All seven sparse slots survive unless a future Lean theorem
proves a specific vanish or cancellation fact. The next Lean worker should
prove the full unitary-entry fold or the stricter prepared-sandwich raw-entry
feeder under the existing `hUniform` contract. No Lean source, paper circuit,
normalizer, oracle contract, block projection flag, LCU flag, unitarity flag,
or final extraction flag was changed.
