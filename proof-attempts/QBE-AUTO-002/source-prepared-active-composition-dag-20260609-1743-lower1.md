# QBE-AUTO-002 Lower 1 Packet: Source-Prepared Active Composition DAG Addendum

Created: 2026-06-09 17:43 JST

Scope: natural-language proof architecture only. No Lean source was edited by
this packet.

## 1. Source Fragment Being Translated

This packet uses the local GHL2025 TeX archive only for reading. Public proof
maps should cite the arXiv paper and the source anchors below.

| Source anchor | Paper fragment or equation | Lean-facing declaration or target | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}^{\lceil\log_2\kappa\rceil}=\kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}^{\lceil\log_2\kappa\rceil}$. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | contract-only; do not prove Shukla--Vedula here |
| `main.tex:1098-1109`, Theorem `theorem: 1 term robin` | one-term Robin block-encoding of $A_k$ with normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ and zero error. | root theorem route through source-prepared projection | GHL-internal theorem target | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the boundary part of $\gamma_3$ has coefficient $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ and clean ancillas. | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | GHL-internal plus QBE-local index bridge | compiled selected slot-`2` bridge |
| `main.tex:1122-1164`, Fig. `fig:1 term ROBIN` | theorem-facing circuit has both $H_W^{(\kappa)}$ sides, explicit $U_{\mathrm{indic}}^\dagger$, pre-SWAP $O_{D^T}^{BS}$, and post-SWAP $(O_D^{BS})^\dagger$. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local bridge | compiled transcript guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the proof compares the clean projected block with the encoded operator entry. | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` | QBE-local semantic bridge | open active/prepared field |

The source fragment is a prepared-sandwich route. It does not state that the
H-free seven-gate active `[0,0]` entry alone equals the all-slot sparse-register
projection sum.

## 2. Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and, when the sparse
preparation is used, the existing contract

```lean
hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Let `Uactive` be the seven-gate active backend product

```lean
evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3))
```

and let `Active00(env)` be

```lean
Coeff.evalWith env
  (Uactive oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

Let `Pprepared(H)` be

```lean
(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
```

and let `Prepared00(H, env)` be

```lean
Coeff.evalWith env
  (Pprepared(H)
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Let `Sandwich(H)` be

```lean
oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H
```

and let `BackendFold` be

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The active local statements are:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H)
  .rawEntryPreparedSandwichStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

## 3. Natural-Language Proof Of The Local Route

### Prepared Clean Entry To Backend Fold

Claim: under `hUniform`, the theorem-facing prepared clean entry evaluates to
`BackendFold`.

Proof: the singleton prepared circuit clean entry evaluates to the prepared
sparse matrix clean entry by
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`.
The prepared sparse matrix clean entry is `Sandwich(H)` by
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`. The
uniform-column contract from Eq. `arbitrary sparcity` turns `Sandwich(H)` into
`BackendFold` by
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`. The
source-prepared target packages this as
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform`.

### Active-To-Prepared Field

Claim: the current active/prepared field is the remaining finite composition
obligation; it is not an external-oracle gap.

Proof: the active side reduces to the seven-gate H-free `[0,0]` entry by
`oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`.
The right side is the clean entry of the prepared singleton circuit, and it
reduces to the prepared sandwich by
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`.
Under `hUniform`, that sandwich evaluates to the backend fold, so
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3`
identifies the uncast active/prepared target with
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.

The compiled guard
`oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3`
also records that both `H_W^(kappa)` side gates are absent from the active gate
list. Therefore a proof of the active/prepared field must supply the same
finite projection/summation content as the evaluated backend fold or the raw
backend-expansion statement. It cannot be closed by the Fig. 4 transcript
alone.

### Source-Branch Correctness

Eq. `ROBIN clarified` is represented in the focused finite proof by the
selected slot-`2` backend branch at full basis `[32,32]`. The compiled
declarations
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3` and
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` keep this
branch separate from the column-`0` slot-`0` diagnostic path. The diagnostic
two-path theorem may describe one active H-free entry, but it does not prove
the displayed $\gamma_3$ branch or the all-slot prepared projection sum.

## 4. Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | all-slot sparse-register clean column for $H_W^{(\kappa)}$ | Eq. `arbitrary sparcity`; Shukla--Vedula cited implementation | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results/status notes | `python3 tools/qbe.py check` | contract-only |
| `fig4_transcript_guard` | source-facing Fig. 4 order with both `H_W` sides and explicit `U_indic^dagger` | Fig. `fig:1 term ROBIN`; indicator self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | `python3 tools/qbe.py check` | compiled |
| `slot2_backend_branch` | displayed $\gamma_3$ slot `2` maps to the selected backend summand | Eq. `ROBIN clarified`; branch index map | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | prepared-entry source DAG | `python3 tools/qbe.py check` | compiled |
| `prepared_entry_backend_eval` | prepared clean entry evaluates to `BackendFold` under `hUniform` | `src_hw_uniform`; prepared singleton semantics | lower/middle | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform`; `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | prepared-entry packets | `python3 tools/qbe.py check` | compiled conditional |
| `active_backend_hfree_guard` | active backend list omits both `H_W` side gates | active gate matrix placeholder list | lower/middle | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`; `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3 H env` | mismatch notes | `python3 tools/qbe.py check` | compiled guard |
| `active_prepared_alignment` | active/prepared statements are equivalent to the evaluated backend fold under `hUniform` | prepared sandwich bridge; backend-fold bridge | lower/middle | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3 H env hUniform`; `oneTermRobinGamma3BoundaryFiniteActivePreparedComposition_reducesToBackendFold_n3 H env hUniform` | middle packet | `python3 tools/qbe.py check` | compiled guard; not closure |
| `generic_entry_leaf` | active entry equals prepared sparse clean entry | prepared entry target; active-source reduction | lower 2/refiner | `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | open; only source-faithful with the existing `H_W` contract context |
| `raw_prepared_sandwich_leaf` | raw signal-zero entry equals `Sandwich(H)` | raw field/backend equivalence | lower 2/refiner | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` | prepared-sandwich packets | same gates | open; stronger allowed leaf under `hUniform` |
| `backend_expansion_core` | raw signal-entry fold equals the backend branch sum | backend branch contribution target | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | backend bridge notes | same gates | next active mathematical leaf if theorem closure is attempted |
| `evaluated_backend_fold` | fixed-environment `evalWith` version of the backend fold | active/prepared alignment or raw backend expansion | lower 2/refiner | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3 H env hUniform hActive` | conversion window | same gates | open; closes from active/prepared or backend expansion |
| `uncast_eval_hfree_route` | H-free active `[0,0]` equals weighted backend fold after `evalWith` | support partition plus all-slot matching | none unless reassigned | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | 17:18 route check | none | diagnostic/blocked as source closure |
| `raw_coeff_constructor_route` | raw symbolic constructor equality from full expansion | old raw scripts and diagnostic sorries | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

Next active leaf for the Lean worker:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

or, if the worker stays inside the source-prepared interface, the same content
through

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

with the existing `hUniform` contract kept explicit in the route theorem. The
worker should not attempt to prove the arbitrary-`H` active/prepared statement
as an unconditional paper theorem.

## 5. Ordered Intermediate Lean Lemmas To Reuse

1. Transcript and role guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`, and
   `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.

2. Source branch map:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`, and
   `oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3`.

3. Prepared clean-entry route:
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`, and
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.

4. Source-prepared projection target:
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3`.

5. Active/prepared target reductions:
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3`,
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3`,
   `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3`, and
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3`.

6. Generic field and raw-field equivalences:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`,
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_statement_n3`, and
   `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`.

7. Conditional closures:
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_rawEntryPreparedSandwichField_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_backendExpansion_n3`, and
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_backendExpansion_n3`.

8. Diagnostic-only support:
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, and
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.
   These should not be used as source closure.

## 6. Failure Analysis

The unconditional active/prepared statement with arbitrary `H` is too strong as
a faithful source theorem. The paper supplies a specific sparse-register
preparation behavior through Eq. `arbitrary sparcity`, represented in Lean by
the existing `hUniform` contract. A proof for every `H : Matrix 8 8 Coeff`
would add content that the paper does not claim.

The H-free uncast evaluated leaf is also not a source-closure theorem by
itself. The active gate list omits `H_W^(kappa)` and
`(H_W^(kappa))^dagger`, while the source $\gamma_3$ denominator `\kappa` and
the all-slot branch sum are supplied by those two side gates. The compiled
expanded slot-`0` guard is useful diagnostics, but it cannot replace the
selected slot-`2` source branch or the prepared projection sum.

The raw `Coeff` constructor equality remains a diagnostic route. The source
only requires equality after the appropriate semantic interpretation and
projection. If a worker proves the stronger raw backend-expansion statement,
that proof should be routed through the existing conditional bridges and not
presented as a revival of the old constructor-equality search.

## 7. Handoff

Lower 1 re-read the GHL source anchors, the current middle packet, and the Lean
route interfaces. The prepared-entry backend evaluator is compiled and
source-correct under the existing `H_W^(kappa)` clean-column contract. The
remaining theorem content is the finite backend-expansion/projection fold; the
active/prepared statements are route interfaces for that content, not a direct
paper proof that the H-free active `[0,0]` entry already contains the two `H_W`
side gates. Lower 2 should either attack
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
or a route-equivalent prepared-entry field under the existing `hUniform`
context. Do not promote oracle, `H_W`, `R_y`, LCU, block-projection,
block-correctness, unitarity, normalized-equality, product-to-coefficient, or
final-extraction flags.
