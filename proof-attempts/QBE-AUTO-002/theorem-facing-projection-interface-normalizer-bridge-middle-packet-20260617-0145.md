# Theorem-Facing Projection-Interface Normalizer Bridge Packet

Task: `QBE-AUTO-002`  
Run: `20260617-013501-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `paperBenchmark`  
Prepared: `2026-06-17 01:45 JST`

## Source Object

The source object is GHL2025 Theorem `theorem: 1 term robin`, the one-term
Robin block-encoding theorem treated as Theorem 3 for this run.  The active
source fragments are Eq. `eq: arbitrary sparcity`, Eq. `eq:angles for Ry`,
Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

The focused branch remains fixed to system entry `(0,0)`, sparse slot `2`,
signal block `[0,0]`, branch basis `[32,32]`, source-prepared projection, and
normalizer $N_D N_f \kappa$.

## Definitions

`ProjectionInterface(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

`NormalizerBridge(H, env)` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3 H env
```

`FiniteBlockContract` is:

```lean
oneTermRobinFiniteBlockCompositionContract 3
```

The projection-interface packet is compiled route memory:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
```

A narrow Lean lookup found no declaration named
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`,
so this leaf is not stale.

## Proof Translation Map

| Paper step | Lean object | Classification |
|---|---|---|
| Eq. `eq: arbitrary sparcity` prepares the sparse register with uniform amplitude. | `hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external contract; cited row `ShuklaVedula2024.HWkappaUniformSuperposition` |
| Eq. `eq:angles for Ry` supplies the focused boundary coefficient convention. | `hentry : env "boundary_cos_half_0_2" = Coeff.evalWith env (GHL2025.boundaryRotationNormalizedCoefficient (oneTermParameters 3) 0 2)` | source-backed corrected-angle contract |
| Eq. `eq: ROBIN clarified` has normalizer $N_D N_f \kappa$ in the focused $\gamma_3$ branch. | `hND`, `hNF`, `hkappa`, `hkappaSqrt`; `NormalizerBridge(H, env)` | QBE-local coefficient bridge |
| Definition `def:block-encoding` selects the signal-zero clean projection. | `ProjectionInterface(H, env).sourcePreparedProjectionEntry` and `.normalizedProjectionBridge` fields | active local interface glue |
| Theorem `theorem: 1 term robin` claims the final block-encoding. | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | blocked; not a lower2 target |

No new cited-result row is needed for this leaf.  The external ingredients are
already recorded and are used only through explicit hypotheses.

## Lower-Agent Split

| Lower role | Packet | Write scope | Acceptance |
|---|---|---|---|
| lower1 proof architect | Validate that the source map above feeds only the interface-field normalizer bridge and keeps the focused branch fixed to `(0,0)`, sparse slot `2`, source-prepared projection, branch basis `[32,32]`, signal block `[0,0]`, and normalizer $N_D N_f \kappa$. | no Lean write | returns proof-DAG feedback with `leaf=theorem_facing_projection_interface_normalizer_bridge`, `source_correspondence_ok=true` or a precise source gap |
| lower3 verifier | Check that `ProjectionInterface(H, env)` is compiled, its `normalizedProjectionBridge` field is the compiled normalizer bridge, the theorem-facing/active transcript split remains ten gates versus seven gates, `oneTermRobinFiniteBlockCompositionContract 3` still uses `oneTermRobinCircuitSemantics 3`, and all theorem flags remain false. | `verifier-feedback/QBE-AUTO-002/` only | typed feedback with `finite_matrix_ok=null`, `block_entry_ok=null`, `normalizer_ok=true`, and no semantic flag promotion |
| lower2 Lean worker | Prove exactly `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` in `QuantumBlockEncoding/RobinMatrix.lean`, after lower1/lower3 checks. | `QuantumBlockEncoding/RobinMatrix.lean` only | `python3 tools/qbe.py check`; if the declaration already exists, make no Lean edit and log `error_class=stale_leaf` |

## Lean Target

Lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and only for this
theorem:

```lean
theorem
    oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3
    (H : Matrix 8 8 Coeff) (env : String -> Rat)
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
        Coeff.evalWith env
          interface.normalizedProjectionBridge.theoremNormalizer =
      Coeff.evalWith env
        interface.normalizedProjectionBridge.expectedTargetEntry /\
      interface.correctedFiniteBlockProjectionEquality.proved = false /\
      interface.correctedFiniteBlockProjectionEqualityProved = false /\
      interface.fixedProductObligation.proved = false /\
      interface.finiteBlockNormalizedEquality.proved = false /\
      interface.finiteBlockProjectionObligation.proved = false /\
      interface.finiteBlockLCUCompositionObligation.proved = false /\
      interface.finiteBlockFinalExtractionObligation.proved = false /\
      interface.normalizedBlockEqualityProved = false /\
      interface.productToCoefficientProved = false /\
      interface.lcuCorrectProved = false /\
      interface.blockProjectionProved = false /\
      interface.blockCorrectProved = false /\
      interface.finalExtractionProved = false /\
      interface.oracleCorrectProved = false /\
      interface.unitaryProved = false /\
      interface.resourceClaimProved = false
```

Expected route:

1. Invoke `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
   with the six explicit hypotheses.
2. Destructure the compiled equality and false-flag facts.
3. `dsimp` the projection interface, contract audit, normalized projection
   bridge, and source-prepared product/projection packet.
4. Close by the compiled equality for the first conjunct and by `rfl` for the
   interface false fields.

## Rejections

Lower2 must not target:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality
```

This packet must not replace the Fig. 4 circuit, mutate the active backend
contract, add assumptions, or promote normalized-block equality, LCU
correctness, block projection, block correctness, final extraction, oracle
correctness, unitarity, resource claims, or product-to-coefficient closure.

## Deferred Ledgers

The post-baseline improvement population remains deferred until the GHL
baseline closes.  The fallback `QBE-OP-OPTCTRL-001` operator contract exists in
`tasks/QBE-OP-OPTCTRL-001.md`, but it is not active while the one-term Robin
baseline root is still open.
