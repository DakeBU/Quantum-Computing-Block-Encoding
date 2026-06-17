# Theorem-Facing Finite Block Normalizer Bridge Middle Packet

Task: `QBE-AUTO-002`  
Run: `20260617-032739-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `paperBenchmark`  
Prepared: `2026-06-17 03:34 JST`  
Leaf: `theorem_facing_finite_block_normalizer_bridge`

## Source-Dependency Audit

The source target remains GHL2025 Theorem `theorem: 1 term robin`, the
one-term Robin block-encoding theorem.  The active paper anchors are Eq.
`ROBIN clarified` for the displayed boundary $\gamma_3$ branch, Fig.
`fig:1 term ROBIN`, Eq. `arbitrary sparcity`, Eq. `angles for Ry`, and
Definition `def:block-encoding`.

The local TeX proof fragment does not introduce a new external theorem for
this step.  The paper uses the same normalizer $\mathcal{N}_D\mathcal{N}_f
\kappa$ in the theorem statement and in the displayed $\gamma_3$ coefficient.
In Lean, the compiled prepared projection bridge currently exposes the
normalizer as
`interface.normalizedProjectionBridge.theoremNormalizer`, while the finite
block-composition contract exposes it as `interface.finiteBlockNormalizer`.
The missing bridge is therefore QBE-local symbolic interface glue, not a new
oracle, LCU theorem, or paper assumption.

Source-dependency classification:

| Item | Classification | Lean-facing object | Status |
|---|---|---|---|
| Theorem normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ | internal paper step plus QBE-local symbolic bridge | `interface.finiteBlockNormalizer = interface.normalizedProjectionBridge.theoremNormalizer` | active leaf |
| Prepared slot-`2` product equality | compiled QBE-local theorem under explicit source contracts | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` | compiled route memory |
| Conditional product normalizer equality | compiled QBE-local theorem under `hUniform`, `hentry`, and coefficient identities | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | compiled route memory |
| Finite normalized block equality | contract-only LCU/block-composition obligation | `interface.finiteBlockNormalizedEquality.proved = false` | still false |
| Product-to-coefficient root | fixed theorem-facing root | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | open; not assigned |

No cited-results update is required for this leaf.  The external
`H_W^{(\kappa)}` clean-column row and the LCU/block-composition row remain
contract-only background; this packet must not recursively formalize them.

## Definitions

`ProjectionInterface(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

`PreparedEntry(H, env)` is:

```lean
(ProjectionInterface(H, env)).sourcePreparedProjectionEntry
```

`FiniteBlockNormalizer(H, env)` is:

```lean
(ProjectionInterface(H, env)).finiteBlockNormalizer
```

`BridgeNormalizer(H, env)` is:

```lean
(ProjectionInterface(H, env)).normalizedProjectionBridge.theoremNormalizer
```

The active bridge should expose the compiled normalizer equality through
`FiniteBlockNormalizer(H, env)`, while preserving every theorem-facing proof
flag as false.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_slot2_product` | prepared projection entry evaluates to the slot-`2` projected product | `hUniform`, `hentry`, source-prepared target | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | source-prepared route notes | previous full gate | compiled route memory |
| `theorem_facing_corrected_prepared_projection_entry` | expose `PreparedEntry(H, env) = normalizedProjectionBridge.projectedBranchProduct` after `Coeff.evalWith` | source-prepared slot-`2` theorem, theorem-facing interface | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` | lower2 03:25 feedback | previous full gate | compiled; retired as lower target |
| `theorem_facing_normalizer_bridge` | prepared entry times bridge normalizer equals expected target entry | source-prepared slot-`2` theorem, coefficient identities | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | normalizer packet | previous full gate | compiled route memory |
| `theorem_facing_finite_block_normalizer_bridge` | replace bridge normalizer by finite block contract normalizer in the theorem-facing interface | compiled normalizer bridge, finite block contract transcript, product route transcript | lower2 after lower3 check | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `branch_decomposition_projection_bridge` | identify the slot-`2` projected branch product with the signal-zero block entry | finite block index lemma, source-prepared product route, no-go guard | later lower1/lower3 | not yet released | proof-obligation ledger | not run | still blocked |
| `fixed_product_to_coefficient` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | finite block normalizer bridge, branch-decomposition/projection bridge, final coefficient algebra | later | existing obligation | proof-obligation ledger | not run | blocked |
| `post_baseline_population` | candidate population for the same operator scored by `(depth, gateCount, auxiliaryQubits, oracleCalls)` | baseline theorem closed first | later middle | none | task directive | not run | deferred |
| `fallback_optctrl_operator` | $E_k := |0\rangle\langle k|_{\rm time} \otimes |0\rangle\langle 1|_{\rm type} \otimes I_n$ | baseline closure and improvement stagnation | later middle | planned OPTCTRL task | task directive | not run | deferred |

## Lower-Agent Split

Lower1 proof architect:
Validate that this wrapper is the normalizer part of Definition
`def:block-encoding`, not a proof of the finite normalized block equality.
The proof map should cite Theorem `theorem: 1 term robin`, Eq. `ROBIN
clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`.
It should record that the universal active/prepared field target remains
rejected by the lower3 finite counterexample from 02:18.

Lower3 verifier:
Before lower2 edits Lean, run a small shape check that
`ProjectionInterface(H, env).finiteBlockNormalizer` unfolds to
`GHL2025.oneTermRobinNormalizer` and that
`ProjectionInterface(H, env).normalizedProjectionBridge.theoremNormalizer`
unfolds through `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` to
the same object.  Also confirm signal row `0`, signal column `0`, sparse slot
`2`, branch basis index `32`, theorem-facing gate count `10`, active backend
gate count `7`, and all downstream flags false.

Lower2 Lean worker:
Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Add exactly one
non-promoting theorem near the existing theorem-facing projection-interface
wrappers.  Do not edit the root product-to-coefficient theorem and do not
touch the refuted generic backend projection route.

```lean
theorem
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hentry :
      env "boundary_cos_half_0_2" =
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (oneTermParameters 3) 0 2))
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1)
    (hkappa : env "kappa_inv" * env "kappa" = 1)
    (hkappaSqrt :
      env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
        env "kappa_inv") :
    let interface :=
      oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
        H env
    Coeff.evalWith env interface.sourcePreparedProjectionEntry *
        Coeff.evalWith env interface.finiteBlockNormalizer =
      Coeff.evalWith env
        interface.normalizedProjectionBridge.expectedTargetEntry ∧
      interface.finiteBlockNormalizer =
        interface.normalizedProjectionBridge.theoremNormalizer ∧
      interface.correctedFiniteBlockProjectionEquality.proved = false ∧
      interface.correctedFiniteBlockProjectionEqualityProved = false ∧
      interface.fixedProductObligation.proved = false ∧
      interface.finiteBlockNormalizedEquality.proved = false ∧
      interface.finiteBlockProjectionObligation.proved = false ∧
      interface.finiteBlockLCUCompositionObligation.proved = false ∧
      interface.finiteBlockFinalExtractionObligation.proved = false ∧
      interface.normalizedBlockEqualityProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false ∧
      interface.oracleCorrectProved = false ∧
      interface.unitaryProved = false ∧
      interface.resourceClaimProved = false := by
  have hNormalizer :=
    oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3
      H env hUniform hentry hND hNF hkappa hkappaSqrt
  rcases hNormalizer with
    ⟨hEval, _hcorr, _hcorrFlag, _hfixed, _hnormEq,
      _hproj, _hlcu, _hfinal, _hnormFlag, _hprod, _hlcuFlag,
      _hblockProj, _hblockCorrect, _hfinalFlag, _horacle, _hunitary,
      _hresource⟩
  dsimp [
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3,
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3,
    oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3,
    oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3,
    oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3,
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3,
    oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3,
    oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3,
    oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3,
    oneTermRobinFiniteBlockCompositionContract]
    at hEval ⊢
  exact ⟨hEval, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩
```

Middle stdin diagnostic:
The exact theorem above was checked with `lake env lean --stdin` on
2026-06-17 03:34 JST and parsed successfully.

## Rejections

Do not assign lower2 to any of these routes:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

The active/prepared field target was rejected by the finite counterexample in
`verifier-feedback/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-lower3-20260617-021813.json`.
The generic backend projection route is refuted by
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`.

## Typed Feedback

```text
leaf=theorem_facing_finite_block_normalizer_bridge
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=null
finite_matrix_ok=shape_checked_by_stdin_normalizer_unfold
block_entry_ok=normalizer_bridge_only
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
resource_score=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=lower3 verifies finite-block normalizer shape and false flags, then lower2 compiles exactly one wrapper theorem oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
```

No normalized-block equality, block projection, LCU correctness, block
correctness, final extraction, oracle correctness, unitarity, resource score,
post-baseline candidate, or OPTCTRL fallback claim is promoted by this packet.
