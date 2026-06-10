# QBE-AUTO-002 Lower 1 Packet: Uncast Eval Entry Bridge

Created: 2026-06-09 16:57 JST

Scope: natural-language proof architecture only.  No Lean source was edited by
this packet.

## 1. Source Fragment Being Translated

| Source anchor | Paper fragment translated | Lean-facing declaration or target | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}|0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle$, with the Shukla--Vedula implementation citation | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; do not recursively prove the cited preparation circuit |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$, zero error, and the stated gate/ancilla resources | root theorem route fed by `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | GHL-internal | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | boundary part of $\gamma_3$ uses coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ on clean ancillas, plus hidden remaining branches | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`, `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local index bridge | selected slot `2` branch compiled |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit includes both $H_W^{(\kappa)}$ sides, explicit $U_{\mathrm{indic}}^\dagger$, pre-SWAP $\hat O_{D^T}^{BS}$, post-SWAP $(\hat O_D^{BS})^\dagger$, $O_f$, SWAP, and the boundary/bulk derivative branch | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`, `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local guard | compiled transcript guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | clean signal-block projection selects the encoded operator entry | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | QBE-local semantic bridge | active finite `evalWith` bridge remains open |

The source does not give a standalone proof of the current finite entry
identity.  It gives the circuit transcript, the prepared sparse-register
contract, and the projection convention.  The remaining proof is a QBE-local
finite matrix-semantics bridge.

## 2. Definitions Before Claims

Fix `env : String -> Rat`.

Let

```lean
gates := GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)
```

and let `U_active := evalGateMatrices gates`.  The active uncast entry is

```lean
U_active
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3
```

after applying `Coeff.evalWith env`.

For each sparse slot `s : Fin 7`, let

```lean
b_s := oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s
B_s := oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s
```

where `B_s` is the diagonal seven-gate entry at `[b_s,b_s]` multiplied by the
prepared sparse-register projection amplitude factor.  The backend fold is

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Let `T_eval env` be
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  Let
`T_uncast env` be the right-hand proposition in
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`:

```lean
Coeff.evalWith env
  (U_active
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

## 3. Natural-Language Proof Of The Active Local Theorem

The active local theorem should prove `T_uncast env`; applying
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`
then closes `T_eval env`.  This is an evaluation-level theorem, not the raw
constructor equality and not a theorem-facing claim that the full Fig. 4
prepared circuit has been formalized.

The proof should proceed as follows.

1. Use the compiled transcript guard only as provenance.  The Lean worker
   should not unfold the full paper circuit or change the gate list.  The
   active product `U_active` is the existing seven-gate product, while the
   theorem-facing circuit keeps the two $H_W^{(\kappa)}$ sides and
   $U_{\mathrm{indic}}^\dagger$ visible through the compiled transcript guard.

2. Reduce the named target to the uncast entry with
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
   This removes only the block-extraction cast and record wrapper.

3. Rewrite the backend fold with
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.  This
   exposes slot `0` plus slots `1` through `6` without unfolding the raw
   `Coeff` syntax of all gates.

4. Evaluate the left-hand matrix product by finite support, using
   `Matrix.evalWith_mul_apply`, `Matrix.evalWith_mul_unique_path`, and
   `Matrix.evalWith_mul_two_path`.  The proof should isolate the relevant
   intermediate rows in the multiplication tree rather than proving
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as a raw
   matrix equality.

5. For every backend sparse slot, either connect the evaluated path
   contribution to `Coeff.evalWith env (B_s)`, or prove that the corresponding
   evaluated backend summand is zero for this focused branch.  This is the key
   finite-support content.  The existing selected-branch lemmas prove only the
   slot `2` mapping and selected summand identity; they do not prove the full
   seven-slot fold.

6. If the finite-support proof collapses the active `[0,0]` entry to the
   compiled column-`0` slot-`0` diagnostic only, the worker must stop and record
   contract drift.  The theorem
   `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`
   proves that this diagnostic uses `boundary_cos_half_0_0` and
   `boundary_sin_half_0_0`, not the displayed gamma3 slot `2` symbols.  It
   cannot be used as source closure for Eq. `ROBIN clarified`.

## 4. Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | all-slot sparse-register preparation clean column | Eq. `arbitrary sparcity`; cited Shukla--Vedula construction | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results/status notes | `python3 tools/qbe.py check` | contract-only |
| `fig4_transcript_guard` | theorem-facing Fig. 4 order with both `H_W` sides and explicit `U_indic^dagger` | Fig. `fig:1 term ROBIN`; U-indic self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | proved transcript guard |
| `slot2_backend_branch` | displayed gamma3 slot `2` is the selected backend summand | Eq. `ROBIN clarified`; branch full-index map | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | prepared-entry source DAG | `python3 tools/qbe.py check` | proved local bridge |
| `prepared_entry_backend_eval` | prepared clean entry evaluates to the backend fold under `hUniform` | `src_hw_uniform`; prepared projection target | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | prepared-entry DAG | `python3 tools/qbe.py check` | proved conditional |
| `active_uncast_reduction` | named evaluated fold is equivalent to uncast `evalGateMatrices` entry equality | block-entry cast removal; active circuit semantics | lower/middle | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | this packet | `python3 tools/qbe.py check` | proved equivalence |
| `backend_fold_expansion` | backend fold expands into seven explicit slot summands | backend branch family | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3` | this packet | `python3 tools/qbe.py check` | proved expansion |
| `active_eval_support_partition` | finite support calculation for the active `[0,0]` entry, with each surviving path matched to a backend slot or proved zero | `Matrix.evalWith_mul_*`; gate-local support lemmas | lower 2/refiner | new support lemmas inside `RobinMatrix.lean` if needed | this packet | `python3 tools/qbe.py check` | next active leaf subgoal |
| `uncast_eval_entry_leaf` | prove `T_uncast env` | `active_uncast_reduction`; `backend_fold_expansion`; `active_eval_support_partition` | lower 2/refiner | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | this packet; middle packet `eval-gate-matrices-entry-middle-packet-20260609-164304.md` | `python3 tools/qbe.py check`; then `lake build && lake build Tests` | preferred active Lean leaf |
| `raw_prepared_sandwich_leaf` | prove raw signal-zero entry equals the prepared $H_W^\dagger U H_W$ sandwich fold | source-prepared route; clean-column contract | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | prepared-sandwich packets | `python3 tools/qbe.py check` | allowed stronger reroute |
| `column0_slot0_guard` | active column-`0` diagnostic uses slot `0`, not gamma3 slot `2` | two-path column-0 expansion | none | `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | lower-2 guard | none | diagnostic; retired |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for the H-free fold | previous raw scripts | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

Next active leaf for the Lean worker:

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

The first implementation subgoal should be the `active_eval_support_partition`
row.  If that support partition cannot include or eliminate slots `1` through
`6`, the worker should return a proof-obligation note instead of forcing the
full theorem.

## 5. Ordered Lean Lemma List

1. Reuse `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
   It reduces the named evaluated backend fold to `T_uncast env`.

2. Reuse `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.
   It unfolds the backend fold into seven branch summands without raw gate
   unfolding.

3. Reuse `Matrix.evalWith_mul_apply`, `Matrix.evalWith_mul_unique_path`,
   `Matrix.evalWith_mul_two_path`, and
   `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`.
   These are the finite support lemmas for evaluated matrix products.

4. Reuse the compiled slot/index lemmas
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3`, and
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`.

5. Reuse `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
   It is a guard: the active gate list omits `H_W^(kappa)` and
   `(H_W^(kappa))^dagger`, so active-entry work is not full Fig. 4 closure.

6. Reuse `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3`
   only as a negative guard.  It prevents using the column-`0` two-path
   diagnostic as the source slot-`2` branch.

7. New recommended support lemma, if the full theorem is too large:

   ```lean
   theorem oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_supportPartition_n3
       (env : String -> Rat) :
       -- exact statement to be chosen by lower 2 after inspecting the
       -- multiplication tree; it should list the surviving intermediate
       -- rows and the zero rows used by Matrix.evalWith_mul_*.
   ```

   This lemma should be definition-free and should not promote any semantic
   flag.

8. New final active leaf:
   `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`.
   It feeds the named target by the equivalence in item 1.

9. Allowed stronger reroute:
   `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.
   Once proved, it feeds the named evaluated fold through
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_rawEntryPreparedSandwichField_n3`.

## 6. Failure Analysis

The current target is acceptable only as a QBE-local finite `evalWith`
matrix/projection bridge.  It must not be presented as the source theorem or
as a proof that the full prepared Fig. 4 circuit is formalized.

There is a real mismatch risk.  The active entry is the H-free seven-gate
`[0,0]` entry, and Lean already proves the active gate list lacks both
`H_W^(kappa)` side gates.  Lean also proves that the existing column-`0`
two-path diagnostic uses slot `0`, while the displayed source branch selected
by Eq. `ROBIN clarified` is slot `2`.  Therefore a proof that only reuses
`oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3` would be
mathematically wrong for the paper route.

If lower 2 can prove that the backend fold, under the current focused target
and arbitrary `env`, evaluates to the same H-free entry by finite support, then
the uncast leaf is valid as a backend semantics theorem.  If instead slots
`1` through `6` contain independent nonzero symbolic contributions that cannot
be eliminated, the target should be routed through the prepared-sandwich field
rather than forced.  The correct reroute is
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`
or a smaller prepared circuit entry lemma feeding it.

No ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block-projection,
normalized-equality, circuit-unitarity, block-correctness, product-to-
coefficient, or final-extraction flag is promoted by this packet.

## 7. Handoff

Lower 2 should first try a finite support partition for
`oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`.
Use the `Matrix.evalWith_mul_*` lemmas and the backend fold expansion.  Stop
and record contract drift if the proof reduces only to the slot-`0` column
diagnostic or if the backend slots cannot be matched or eliminated.
