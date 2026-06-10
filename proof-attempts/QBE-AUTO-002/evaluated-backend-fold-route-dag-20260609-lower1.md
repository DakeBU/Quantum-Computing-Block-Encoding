# QBE-AUTO-002 Lower 1 Addendum: Evaluated Backend-Fold Route DAG

Created: 2026-06-09

Scope: natural-language proof architecture only.  No Lean declaration is added
by this packet.

## 1. Source Fragment Being Translated

| Source anchor | Fragment | Lean-facing role | Dependency class |
|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}|0\rangle = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}|s\rangle$ and the Shukla--Vedula implementation citation | all-slot clean-column contract for the sparse-register preparation matrix `H` | external-cited-contract |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ and zero error | theorem root; not closed by this packet | GHL-internal |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | boundary part of $\gamma_3$ has coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ with clean ancillas | selected slot `2` branch and backend summand target | GHL-internal plus QBE-local index bridge |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing gate order contains both `H_W^(kappa)` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger` | transcript guard; active backend seven-gate product is not the full prepared circuit | GHL-internal transcript plus QBE-local guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | projection onto the signal-zero block gives the encoded operator entry | selects the signal-zero entry before comparing it to the backend branch fold | QBE-local semantic bridge |

## 2. Definitions Before Claims

Fix an environment `env : String -> Rat`.

Let `T_eval env` be
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  This is the
evaluation-level statement

$$
\operatorname{evalWith}_{env}(\text{signalUnitaryEntry}) =
\operatorname{evalWith}_{env}(\text{blockExtractionBranchContributionSum}).
$$

Let `H : Matrix 8 8 Coeff` be a sparse-register preparation matrix satisfying
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.  This
is the local typed contract corresponding to Eq. `arbitrary sparcity`; it is
not a proof of the Shukla--Vedula construction.

Let `E_backend` be
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
By
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
this is equivalent to the raw `Coeff` equality
`signalUnitaryEntry = blockExtractionBranchContributionSum ...`.

Let `R_raw H` be
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.
Under the clean-column contract for `H`,
`oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`
proves `R_raw H <-> E_backend`.

## 3. Natural-Language Proof Of The Local Route

The source theorem root is the one-term Robin block-encoding theorem.  The
current lower leaf is not the theorem root.  It is the QBE-local finite
matrix-semantics bridge needed after the Fig. `1 term ROBIN` transcript and
the source-prepared projection entry have been isolated.

The source-prepared route is:

1. Eq. `arbitrary sparcity` supplies the contract that the sparse preparation
   maps the clean sparse register to the uniform superposition over all
   $\kappa$ slots.  In Lean this is the hypothesis
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
2. Eq. `ROBIN clarified` selects the boundary $\gamma_3$ branch.  The focused
   finite witness uses slot `2`; the existing compiled branch map records that
   the selected backend contribution is the slot-`2` branch, not the active
   column-`0` diagnostic.
3. Fig. `fig:1 term ROBIN` supplies the prepared circuit role: the active
   seven-gate product is sandwiched between `H_W^(kappa)` and
   `(H_W^(kappa))^dagger`.  The transcript guard keeps these boundary gates
   visible and keeps `U_indic^dagger` as an explicit theorem-facing slot.
4. Definition `def:block-encoding` selects the signal-zero clean projection.
   The Lean object `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`
   is the source-facing selected projection target.
5. The prepared clean-entry evaluator is already compiled:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform`.
   It proves that the theorem-facing prepared clean entry evaluates to the
   backend branch fold under the `H_W^(kappa)` clean-column contract.
6. Therefore, if the finite active/prepared composition field supplies
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`,
   then `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`
   closes `T_eval env`.

The raw/backend route is stronger but not identical to the fixed-environment
evaluation statement.  A proof of `E_backend` gives the raw full-entry fold.
Applying `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
and then `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_unitaryEntryFold_n3`
closes `T_eval env` for every `env`.  Conversely, `T_eval env` for a fixed
environment does not imply the raw `Coeff` equality unless an additional
environment-injectivity or all-environments lemma is introduced.  No such
lemma is present in the current Lean DAG.

## 4. Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | all-slot sparse-register preparation column for `H_W^(kappa)` | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited contract | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results row; status notes | `python3 tools/qbe.py check` | contract-only |
| `fig4_transcript_guard` | theorem-facing Fig. 4 order, including both `H_W` sides and explicit `U_indic^dagger` | source Fig. `fig:1 term ROBIN`; U-indic self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | proved transcript guard |
| `slot2_backend_branch` | source $\gamma_3$ slot `2` is the selected backend summand | Eq. `ROBIN clarified`; branch full-index map | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | prepared-entry source DAG | `python3 tools/qbe.py check` | proved local bridge |
| `prepared_entry_backend_eval` | prepared clean entry evaluates to backend fold under `hUniform` | `src_hw_uniform`; source-prepared projection target | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | prepared-entry DAG | `python3 tools/qbe.py check` | proved conditional |
| `active_prepared_to_eval` | active/prepared selected-entry equality closes the evaluated backend fold | `prepared_entry_backend_eval`; active/prepared field | lower/middle | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform` | this packet | `python3 tools/qbe.py check` | proved conditional |
| `active_prepared_wrapper` | uncast active/prepared target is the same remaining evaluated fold under `hUniform` | prepared-sandwich bridge; active H-free guard | lower 2 | `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3 H env hUniform` | finite-active packet | `python3 tools/qbe.py check` | proved guard; retired as a lower target |
| `eval_backend_fold` | prove `Coeff.evalWith env signalUnitaryEntry = Coeff.evalWith env backendBranchFold` | uncast active-entry reduction; backend branch fold | lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` | middle packet; this addendum | `python3 tools/qbe.py check` | active leaf |
| `uncast_eval_entry_leaf` | strictly smaller spelling of `eval_backend_fold` on the uncast `evalGateMatrices` `[0,0]` entry | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env` | lower 2/refiner | new theorem suggested below | this addendum | `python3 tools/qbe.py check` | next active leaf |
| `backend_expansion_raw` | raw full-entry fold / backend expansion | backend branch target; projection summation interface | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | middle packet | `python3 tools/qbe.py check` | stronger allowed leaf; open |
| `raw_prepared_sandwich` | raw signal-zero entry equals prepared `H_W^dagger * U * H_W` sandwich fold | `src_hw_uniform`; raw field | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | middle packet | `python3 tools/qbe.py check` | iff to `backend_expansion_raw` under `hUniform`; open |
| `column0_slot0_guard` | active seven-gate column-`0` diagnostic uses slot-`0` Ry symbols, not gamma3 slot `2` | two-path column-`0` expansion | none | `oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` | lower-2 guard | `python3 tools/qbe.py check` | diagnostic; retired |
| `raw_coeff_constructor_route` | raw constructor equality via full symbolic `Coeff` unfolding | none; previous scripts hit max recursion and OOM | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic note | none | stale; do not assign |

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

This theorem feeds `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`
by applying
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
It is smaller than the named statement because it removes the block-extraction
record and dimension cast.  It is still the real finite branch-sum theorem, so
it should not be replaced by the column-`0` diagnostic or raw constructor
equality.

## 5. Ordered Lean Lemma List

1. Reuse `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.
   Purpose: keep the active seven-gate product distinct from the prepared
   theorem-facing sandwich.

2. Reuse
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3 env`.
   Purpose: reduce `T_eval env` to the uncast active `[0,0]` `evalGateMatrices`
   entry.

3. Reuse `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.
   Purpose: expand the right-hand backend fold into the seven explicit branch
   summands without unfolding the raw constructor equality.

4. Reuse `Matrix.evalWith_mul_apply`, `Matrix.evalWith_mul_unique_path`, and
   `Matrix.evalWith_mul_two_path` from `CircuitSemantics.lean`.
   Purpose: prove evaluated matrix-product entries by finite path support,
   avoiding raw `Coeff` syntactic expansion.

5. Reuse existing slot/index support lemmas around
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3`, and the
   existing row-support lemmas for prefix/suffix matrices.
   Purpose: each branch summand should be justified by a path-support lemma,
   not by a global symbolic matrix equality.

6. New recommended leaf:
   `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`,
   with the statement shown above.
   Purpose: finish the uncast evaluation-level branch-sum equality.

7. Optional route-packaging theorem, only after or alongside a proof of
   `backend_expansion_raw`:

   ```lean
   theorem oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3
       (env : String -> Rat)
       (hexpansion :
         oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
       oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
   ```

   This is not the main active leaf.  It is a one-way bridge from the stronger
   raw backend expansion to the evaluation-level target.

## 6. Failure Analysis And Routing Constraints

The current target is mathematically well routed as an evaluation-level QBE
finite matrix-semantics theorem.  The stale target is the raw constructor
equality, not the evaluated statement.

The three allowed leaves should not be described as mutually equivalent without
qualification.  Under `hUniform`, `R_raw H` is equivalent to `E_backend`.
Both are stronger than `T_eval env` and imply it by evaluating the raw equality.
The reverse implication from a single `env` is not available in Lean and would
require a new injectivity or all-environments theorem.  Do not add such a
hypothesis in faithful-paper mode.

The column-`0` diagnostic cannot prove the displayed gamma3 slot-`2` branch.
It may describe one active branch term, but
`oneTermRobinGamma3BoundarySevenGateColumn0UsesSlot0_notGamma3Slot2_n3` proves
that its Ry symbols are slot `0`, while Eq. `ROBIN clarified` focused source
branch is slot `2`.

The raw `Coeff` route remains diagnostic because previous attempts hit
max-recursion or memory blow-up.  The next Lean proof should stay at
`Coeff.evalWith` level and use finite path-support lemmas.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness, or final
extraction flag is promoted by this packet.

## 7. Handoff

Lower 1 recommends that lower 2 attempt the uncast evaluation leaf
`oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env`.
Use the existing `evalWith` matrix-product path lemmas and the backend fold
expansion.  If lower 2 instead attacks `backendExpansionStatement` or the raw
prepared-sandwich field, record it as a stronger raw leaf; do not claim that a
fixed-env evaluated statement proves the raw equality.
