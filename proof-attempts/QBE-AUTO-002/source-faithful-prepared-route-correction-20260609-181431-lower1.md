# QBE-AUTO-002 Lower 1 Packet: Source-Faithful Prepared Route Correction

Created: 2026-06-09 18:14 JST

Scope: natural-language proof architecture only. No Lean source was edited by
this packet.

## 1. Source Fragment Being Translated

This packet translates the one-term Robin theorem route in GHL2025. Public
proof maps should cite the arXiv paper and the anchors below, not local machine
paths.

| Source anchor | Fragment translated | Lean declaration or missing declaration | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}^{\lceil\log_2\kappa\rceil}=\kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}$. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | typed contract only |
| `main.tex:1098-1109`, Theorem `1 term robin` | $U_{A_k}^{(1)}$ is an $(\mathcal{N}_D\mathcal{N}_f\kappa,\lceil\log_2 n\rceil+\lceil\log_2G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of the one-term Robin operator. | theorem-facing route through a prepared circuit, not the H-free seven-gate entry alone | GHL-internal root theorem | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | The displayed $\gamma_3$ boundary branch has coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ on clean ancillas, with other branches hidden in $+\dots$. | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local index bridge | compiled selected slot-`2` bridge |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | The theorem-facing circuit has both $H_W^{(\kappa)}$ sides, explicit $U_{\mathrm{indic}}^\dagger$, pre-SWAP $O_{D^T}^{BS}$, and post-SWAP $(O_D^{BS})^\dagger$. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local bridge | compiled guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | The clean signal block is extracted after the stated ancilla cleanup. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local semantic bridge | partially compiled; active/prepared field open |

The exact source-level matrix fragment for this lower packet is the prepared
projection entry

$$
(\langle 0|_{\mathrm{sig}}\otimes I)U_{A_k}^{(1)}
(|0\rangle_{\mathrm{sig}}\otimes I),
$$

where the sparse-register part of $U_{A_k}^{(1)}$ includes
$(H_W^{(\kappa)})^\dagger$ on the left and $H_W^{(\kappa)}$ on the right. The
H-free seven-gate product is an internal backend component, not the whole
theorem-facing Fig. 4 unitary.

## 2. Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Let `clean := oneTermRobinGamma3BoundarySparseCleanIndex_n3`.

Let `Uactive` be the current seven-gate backend product

```lean
evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))
```

and let `Uprepared H` be the prepared singleton circuit matrix

```lean
(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
```

Let `BackendFold` abbreviate

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The source-faithful prepared entry statement is already represented by

```lean
Coeff.evalWith env (Uprepared H clean clean)
  = Coeff.evalWith env BackendFold
```

and compiled as

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
  H env hUniform
```

The currently dangerous target shape is

```lean
Coeff.evalWith env (Uactive row0 row0)
  = Coeff.evalWith env BackendFold
```

which is the H-free evaluated backend-fold route.

## 3. Natural-Language Proof Of The Source-Faithful Local Theorem

Claim: under `hUniform`, the theorem-facing prepared clean entry evaluates to
the seven-slot backend fold.

Proof. Eq. `arbitrary sparcity` gives the clean sparse-register column of
$H_W^{(\kappa)}$: each source slot $s<\kappa$ receives amplitude
$\kappa^{-1/2}$. The left boundary gate
$(H_W^{(\kappa)})^\dagger$ contributes the same clean-row factor. Therefore the
clean-clean entry of the prepared sandwich is the finite sum over sparse slots
of the active seven-gate diagonal branch entry, multiplied by the two
projection amplitudes. In Lean this is the definition of
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H`.

The compiled lemma
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3 H`
identifies the prepared sparse matrix clean entry with that sandwich sum. The
compiled lemma
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3
H env` removes the singleton `CircuitMatrixSemantics` wrapper after
`Coeff.evalWith`. Finally
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3
H hUniform` replaces the prepared sandwich by `BackendFold`. These three
steps prove
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
H env hUniform`.

This proof uses the paper's two $H_W^{(\kappa)}$ sides. It does not require
proving Shukla--Vedula state preparation internally, and it does not promote
`H_W`, `O_{D^T}^S`, `R_y`, `O_D^{BS}`, `O_f`, LCU, block-projection, or
block-correctness flags.

Claim: the H-free active equality
`Coeff.evalWith env (Uactive row0 row0) = Coeff.evalWith env BackendFold` is
not a source theorem unless an additional finite projection theorem proves that
all weighted sparse-slot contributions match or cancel.

Proof. The compiled guard
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`
rewrites the target to an equality whose left side is the H-free active
`[0,0]` entry and whose right side is the weighted slot-`0` summand plus slots
`1` through `6`. The paper obtains this weighted all-slot sum from
$H_W^{(\kappa)}$ and $(H_W^{(\kappa)})^\dagger`, not from the H-free entry
alone. Therefore a lower worker must not close the source theorem by proving
only the column-`0` two-path diagnostic.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | clean column of $H_W^{(\kappa)}$ is uniform over all sparse slots | Eq. `arbitrary sparcity`; Shukla--Vedula citation | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results/status notes | `python3 tools/qbe.py check` | external-cited-contract |
| `fig4_transcript_guard` | theorem-facing Fig. 4 transcript exposes both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger` | Fig. `1 term ROBIN`; indicator self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | same gate | proved transcript guard |
| `active_backend_guard` | active backend list is exactly the seven-gate H-free product and is not the full Fig. 4 transcript | `oneTermRobinCircuit`; gate placeholder list | middle/reviewer | `GHL2025.oneTermRobinActiveBackendCircuit_gateList`; `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | conversion window and this packet | same gate | proved mismatch guard |
| `slot2_gamma3_branch` | displayed boundary $\gamma_3$ branch is selected sparse slot `2` | Eq. `ROBIN clarified`; branch index map | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`; `oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3` | source-prepared packets | same gate | proved selected-branch bridge |
| `prepared_sandwich_backend` | prepared clean-clean entry evaluates to `BackendFold` under `hUniform` | `src_hw_uniform`; prepared sparse matrix clean-entry lemmas | lower/middle | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | this packet | same gate | proved conditional |
| `active_prepared_field` | active signal-zero entry equals prepared clean-clean entry | source-prepared singleton target | lower 2/refiner | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | conversion window | same gate | open; source-faithful only if interpreted as an explicit prepared-composition field, not as Fig. 4 proof from seven gates alone |
| `backend_expansion_core` | `signalUnitaryEntry = BackendFold` as raw backend expansion | active signal-entry fold; all-slot backend family | none until retargeted | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3` | backend-expansion packets | same gate | diagnostic for source closure; do not use as full Fig. 4 theorem unless H-free/all-slot equality is separately proved |
| `expanded_slot0_obstruction` | evaluated backend-fold target exposes H-free `[0,0]` versus weighted slot-`0` plus slots `1..6` | `backend_expansion_core`; fold expansion | lower/reviewer | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3` | `eval-entry-expanded-slot0-fold-20260609-lower2.md` | same gate | proved obstruction guard |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for the seven-gate fold | old diagnostic sorries | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |
| `source_prepared_target_alias` | theorem-facing prepared clean-entry route has a named target independent of the H-free diagnostic | `prepared_sandwich_backend`; transcript guard | lower 2 if a Lean edit is requested | proposed alias theorem reusing `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next safe Lean leaf |

Next active leaf for a Lean worker:

```lean
-- proposed name, definition-free alias over an existing compiled theorem
theorem oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
        oneTermRobinGamma3BoundarySparseCleanIndex_n3
        oneTermRobinGamma3BoundarySparseCleanIndex_n3)
      =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :=
  oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
    H env hUniform
```

This leaf is intentionally small. It gives the theorem-facing prepared route a
stable name and avoids pretending that the H-free active `[0,0]` entry is the
full Fig. 4 projection. If middle wants implementation rather than an alias,
the worker should first update the active target statement so its left side is
the prepared circuit clean entry, then reuse the same compiled theorem.

## 5. Ordered Intermediate Lean Lemmas To Reuse

1. Transcript guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`, and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`.

2. Sparse-preparation contract and prepared sandwich:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3`, and
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`.

3. Prepared matrix clean entry:
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3` and
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.

4. Source-prepared target packaging:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`.

5. Branch-correct gamma3 map:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`, and
   `oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3`.

6. Diagnostic guards only:
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesUncastSevenGate_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`, and
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`.

7. Do not use as active proof route:
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` and
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`. Both
   remain diagnostic/backlog because they ask for raw `Coeff` constructor
   equality rather than an `evalWith` semantic bridge.

## 6. Failure Analysis

The current `backendExpansionStatement` is mathematically too strong if it is
read as the paper's Fig. 4 theorem. Its compiled equivalences reduce it to the
H-free full-unitary entry fold

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

and the evaluated target exposes

```lean
Coeff.evalWith env (Uactive row0 row0)
  =
Coeff.evalWith env
  (weighted slot-0 summand + slots 1 through 6)
```

The source paper does not derive this equality from the seven-gate product
alone. It derives the weighted all-slot expression by applying
$H_W^{(\kappa)}$ before the active gates and
$(H_W^{(\kappa)})^\dagger$ afterward. Therefore a proof that only follows the
column-`0` two-path support partition would prove a simplified internal
contract, not the source register-level transformation.

The source-faithful route is already available conditionally through the
prepared entry:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
  H env hUniform
```

The remaining planning issue is target alignment. Either the theorem-facing
Lean target should keep the prepared circuit on the left, or a separate finite
theorem must be stated and proved explaining why the H-free active `[0,0]`
entry equals the prepared all-slot projection. Until that theorem exists, the
H-free backend expansion should stay diagnostic/backlog for source closure.

## 7. Handoff

Lower 1 produced a source-faithful prepared-route correction. The paper
fragment translates cleanly through the prepared sandwich under `hUniform`;
that part is already compiled. The active H-free evaluated backend-fold route
still exposes unweighted column `0` against a seven-slot weighted fold, so it
should not be assigned as a source theorem unless a new finite projection
theorem proves all slot contributions. Next safe Lean leaf is a definition-free
source-prepared alias over
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`, or a
middle retargeting that makes the theorem-facing left side the prepared circuit
clean entry.
