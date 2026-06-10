# QBE-AUTO-002 Lower 1 Packet: Source-Prepared Branch-Sum Frontier

Created: 2026-06-09 18:35 JST

Scope: natural-language proof architecture only. No Lean source was edited by
this packet.

## 1. Source Fragment Being Translated

This packet re-reads the local GHL2025 TeX archive and translates only the
one-term Robin boundary projection fragment. Public proof maps should cite the
arXiv paper and the anchors below, not local machine paths.

| Source anchor | Paper fragment or equation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|---|
| `main.tex:948-955`, Eq. `arbitrary sparcity` | $H_W^{(\kappa)}\ket{0}^{\lceil\log_2\kappa\rceil} = \kappa^{-1/2}\sum_{s=0}^{\kappa-1}\ket{s}^{\lceil\log_2\kappa\rceil}$. | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external-cited-contract | typed contract only |
| `main.tex:1098-1109`, Theorem `1 term robin` | $U_{A_k}^{(1)}$ is a $(\mathcal{N}_D\mathcal{N}_f\kappa,\lceil\log_2 n\rceil+\lceil\log_2G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$ block-encoding of the one-term Robin operator. | theorem-facing route through source-prepared projection | GHL-internal root theorem | open |
| `main.tex:1111-1119`, Eq. `ROBIN clarified` | the boundary part of $\gamma_3$ carries $f(x_i)(D)_i^{(s)}\sigma^{(s)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ on clean ancillas, with other branches hidden in $+\dots$. | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; selected slot bridges | GHL-internal plus QBE-local branch map | all-slot summand family typed; selected slot compiled |
| `main.tex:1122-1164`, Fig. `1 term ROBIN` | the theorem-facing circuit has both $H_W^{(\kappa)}$ sides, explicit $U_{\mathrm{indic}}^\dagger$, pre-SWAP $O_{D^T}^{BS}$, and post-SWAP $(O_D^{BS})^\dagger$. | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | GHL-internal transcript plus QBE-local bridge | compiled transcript guard |
| `main.tex:2027-2035`, Definition `def:block-encoding` | the clean signal block is the projected unitary entry compared with the encoded operator entry. | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3`; `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3` | QBE-local finite projection bridge | active branch-sum leaf open |

The exact local equation now being translated is the branch-sum projection
inside the clean block:

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
  oneTermRobinGamma3BoundaryBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

This equation is route-equivalent to
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`.

## 2. Definitions Before Claims

Fix `H : Matrix 8 8 Coeff`, `env : String -> Rat`, and, when the sparse
preparation contract is used,

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Let `clean` be `oneTermRobinGamma3BoundarySparseCleanIndex_n3`.

Let `ActiveEntry` be the signal-zero entry selected by the finite block
projection:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry
```

Let `PreparedEntry(H)` be the clean-clean entry of the prepared sparse-register
sandwich:

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H clean clean
```

Let `BackendFold` be the all-slot backend fold:

```lean
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Let `BranchSum` be the same fold through the older local interface:

```lean
oneTermRobinGamma3BoundaryBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The compiled theorem-facing alias
`oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` is
already present. It is no longer a useful lower leaf.

## 3. Natural-Language Proof Of The Active Local Theorem

Claim A: under `hUniform`, the prepared clean entry evaluates to `BackendFold`.

Proof. Eq. `arbitrary sparcity` supplies the clean sparse-register column of
$H_W^{(\kappa)}$ for every paper sparse slot $s<\kappa$. The adjoint side uses
the transpose convention recorded by
`oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3`, so the clean row of
$(H_W^{(\kappa)})^\dagger$ contributes the matching factor. For each slot,
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`
rewrites the prepared sandwich contribution to the backend summand. Folding over
the seven slots gives
`oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`. The
prepared sparse matrix clean-entry lemma and singleton-semantics eval lemma then
give
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`, and
the source-facing alias reuses this theorem.

Claim B: the remaining theorem content is the finite branch-sum expansion of
the signal-zero block entry.

Proof design. The projection target defines `signalBlockEntry` as
`contract.expectedTarget.blockMatrix[0,0]` and proves the index bridge
`oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`
to the selected unitary entry. The backend target defines a concrete summand
family
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff`,
where each summand is the branch full-index diagonal entry of
`oneTermRobinGamma3BoundarySevenGateMatrix_n3` multiplied by the sparse-register
projection amplitude factor. The selected source $\gamma_3$ branch is already
compiled at slot `2` by
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`.

Therefore the active local theorem is not another `H_W` amplitude lemma. It is
the QBE-local finite projection lemma stating that the signal-zero block entry
is exactly the fold over this all-slot branch family. In Lean, prove the local
branch-sum equality above, then close
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
through
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`.

Claim C: the generic prepared-entry target is a route interface, not the next
standalone theorem for arbitrary `H`.

Proof. Under `hUniform`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`
identifies
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
with the backend-expansion statement. Without the uniform-column contract, a
universal theorem proving this entry equality for arbitrary `H` would compare a
fixed active entry with a prepared entry that depends on unconstrained entries
of `H`. The Lean worker should either prove the branch-sum/backend-expansion
leaf directly or state a theorem whose hypotheses include the already existing
`hUniform` context and a backend-expansion or branch-sum proof.

## 4. Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `src_hw_uniform` | clean column of $H_W^{(\kappa)}$ is uniform over seven paper sparse slots | Eq. `arbitrary sparcity`; Shukla--Vedula citation | external/backlog | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | cited-results and status notes | `python3 tools/qbe.py check` | external-cited-contract |
| `fig4_transcript_guard` | source-facing Fig. 4 transcript exposes both `H_W` sides, explicit `U_indic^dagger`, pre-SWAP `O_DT^BS`, and post-SWAP `(O_D^BS)^dagger` | Fig. `1 term ROBIN`; indicator self-inverse bridge | middle/reviewer | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`; `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | conversion window | same gate | proved transcript guard |
| `prepared_clean_backend_eval` | prepared clean entry evaluates to backend fold under `hUniform` | `src_hw_uniform`; prepared sparse matrix clean-entry lemmas | lower/middle | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`; `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | middle packet and this addendum | same gate | compiled conditional |
| `slot2_gamma3_selected` | Eq. `ROBIN clarified` boundary branch is selected sparse slot `2` in the focused `n=3` witness | branch full-index map; selected summand formula | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`; `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3` | source-prepared packets | same gate | compiled selected-slot bridge |
| `backend_branch_family` | all-slot backend contribution family is typed as `Fin 7 -> Coeff` | seven-gate branch full-index map; projection amplitude factor | lower/middle | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`; `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3` | backend-expansion packets | same gate | typed; no summation proof |
| `branch_sum_leaf` | signal-zero block entry equals the seven-slot backend branch fold | `backend_branch_family`; block-entry/unitary-entry bridge | lower 2/refiner | proposed `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3`; local form of `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active leaf |
| `backend_expansion_leaf` | generic backend expansion statement for the branch-contribution target | `branch_sum_leaf` | lower 2/refiner | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` | conversion window | same gate | open, route-equivalent to branch sum |
| `generic_prepared_entry_route` | active prepared entry target is equivalent to backend expansion under `hUniform` | `src_hw_uniform`; `backend_expansion_leaf` | lower 2 only after branch sum | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`; `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement` | source-prepared clean-entry packet | same gate | route interface; do not attack as arbitrary-`H` theorem |
| `hfree_eval_route` | H-free active `[0,0]` equals weighted backend fold after `evalWith` | support partition plus all-slot matching | none | proposed `oneTermRobinGamma3BoundaryEvalGateMatricesEntryEval_eq_backendFold_n3 env` | old support packet | none | retired as source-closure target |
| `raw_coeff_constructor_route` | raw symbolic constructor equality for the H-free fold | old diagnostic sorries | none | `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` | diagnostic/backlog | none | stale; do not assign |

Next active leaf for a Lean worker:

```lean
theorem oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3 :
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
      oneTermRobinGamma3BoundaryBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  -- finite projection/backend expansion proof
```

After that leaf, use the already compiled equivalence:

```lean
(oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3).2
```

to close
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.

## 5. Ordered Intermediate Lean Lemmas To Reuse

1. Transcript and source-role guards:
   `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`,
   `GHL2025.oneTermRobinActiveBackendCircuit_gateList`,
   `GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq`, and
   `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge`.

2. Sparse preparation and prepared clean entry:
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`,
   `oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3`,
   `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
   `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`,
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`, and
   `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3`.

3. Projection target and block-entry bridges:
   `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3`,
   `oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`,
   `oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3`, and
   `oneTermRobinGamma3BoundaryBackendProjectionStatement_equivBranchSum_n3`.

4. Backend branch family:
   `oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
   `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3`, and
   `oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3`.

5. Backend expansion route:
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivProjection_n3`,
   `oneTermRobinGamma3BoundaryBackendProjectionStatement_of_backendExpansion_n3`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`, and
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`.

6. Prepared-entry route interface:
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`,
   `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3`, and
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_entryTarget_n3`.

7. Diagnostic-only support:
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3`,
   `oneTermRobinGamma3BoundarySevenGateColumn0TwoPathEval_n3`,
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`, and
   `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.
   Do not use these as source closure.

## 6. Failure Analysis

The safe alias
`oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` is
already compiled, so assigning it again is stale.

The target
`(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
is useful as a route interface only in the existing `hUniform` context. A
standalone theorem proving it for arbitrary `H : Matrix 8 8 Coeff` would be too
strong: the prepared entry depends on `H`, while the active signal entry does
not. The compiled equivalence
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3`
shows the correct dependency: under `hUniform`, this entry target is exactly
the still-open backend-expansion theorem.

The H-free `evalWith` route and the raw `Coeff` constructor route remain
diagnostic. The source paper obtains the denominator $\kappa$ and all-slot
projection from the two `H_W^(kappa)` side gates. A proof that only analyzes
column `0`, slot `0`, or raw symbolic constructor equality does not translate
the source register-level transformation.

## 7. Handoff

Lower 1 produced a source-prepared branch-sum frontier. The source anchors
`main.tex:948-955`, `1098-1164`, and `2027-2035` were re-read. The theorem
facing transcript, explicit `U_indic^dagger` role, prepared clean-entry backend
evaluation, and safe alias are compiled. The next real Lean leaf is the local
branch-sum equality
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
oneTermRobinGamma3BoundaryBranchContributionSum
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, then route it through
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`. Do not
reassign the compiled alias, the H-free eval route, or raw `Coeff` equality. No
oracle, `H_W`, `R_y`, ODBS, ODTS, `O_f`, LCU, block-projection, normalized
equality, product-to-coefficient, unitarity, block-correctness, or final flags
were promoted.
