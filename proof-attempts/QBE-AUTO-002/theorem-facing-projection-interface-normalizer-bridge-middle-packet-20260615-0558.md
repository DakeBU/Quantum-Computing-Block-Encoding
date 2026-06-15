# Theorem-Facing Projection-Interface Normalizer Bridge Middle Packet

Task: `QBE-AUTO-002`  
Run: `20260615-053748-QBE-AUTO-002-cycle01`  
Role: middle source-correspondence formalizer  
Mode: `faithfulPaper`  
Prepared: `2026-06-15 05:58 JST`

## Source Object

The paper object is the focused boundary $\gamma_3$ entry in GHL2025
Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, Eq.
`arbitrary sparcity`, and Eq. `angles for Ry`.

The focused branch remains fixed to system entry `(0,0)`, sparse slot `2`,
signal block `[0,0]`, branch basis `[32,32]`, source-prepared projection, and
normalizer $N_D N_f \kappa$.

## Definitions

`ProjectionInterface(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env
```

`NormalizerBridge(H, env)` is the compiled route:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3 H env
```

`FiniteBlockContract` is:

```lean
oneTermRobinFiniteBlockCompositionContract 3
```

The interface leaf compiled in the previous lower2 pass is now stale as lower
work:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
```

## Proof Translation Map

| Paper step | Lean object | Classification |
|---|---|---|
| Eq. `arbitrary sparcity` prepares the sparse register with uniform amplitude. | `hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external contract; cited row `ShuklaVedula2024.HWkappaUniformSuperposition` |
| Eq. `angles for Ry` supplies the focused boundary coefficient. | `hentry : env "boundary_cos_half_0_2" = Coeff.evalWith env (GHL2025.boundaryRotationNormalizedCoefficient (oneTermParameters 3) 0 2)` | source-backed corrected-angle contract |
| Eq. `ROBIN clarified` has normalizer $N_D N_f \kappa$ in the focused $\gamma_3$ branch. | `hND`, `hNF`, `hkappa`, `hkappaSqrt`; `NormalizerBridge(H, env)` | QBE-local coefficient bridge |
| Definition `def:block-encoding` selects the signal-zero clean projection. | `ProjectionInterface(H, env).sourcePreparedProjectionEntry` and `.normalizedProjectionBridge` fields | active local interface glue |
| Theorem `theorem: 1 term robin` claims the final block-encoding. | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | blocked; not a lower2 target |

No new cited-result row is needed for this leaf.  The external ingredients are
already present as contract-only rows; this packet uses them only as explicit
hypotheses.

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

Expected proof route:

1. Invoke `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
   with the six explicit hypotheses.
2. Destructure only the equality and false-flag facts needed.
3. `dsimp` the compiled projection interface, contract audit, normalized
   projection bridge, and source-prepared product/projection packet.
4. Close by `rfl` for the interface false fields and by the compiled equality
   for the first conjunct.

## Ownership Split

| Component | Owner |
|---|---|
| GHL-owned | Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding`, Eq. `arbitrary sparcity`, Eq. `angles for Ry` |
| External contract | `ShuklaVedula2024.HWkappaUniformSuperposition` for `hUniform`; corrected boundary-angle row for `hentry`; `LCU.StandardBlockEncoding` remains contract-only background |
| QBE-local semantic glue | `ProjectionInterface(H, env)`, `NormalizerBridge(H, env)`, finite block contract fields, and the planned interface-field bridge theorem |

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

The packet must not replace the Fig. 4 circuit, mutate the active backend
contract, add assumptions, or promote normalized-block equality, LCU
correctness, block projection, block correctness, final extraction, oracle
correctness, unitarity, resource claims, or product-to-coefficient closure.

## Next Route

If the theorem already exists, lower2 should make no Lean edit and log
`error_class=stale_leaf`.  If the theorem compiles, the next middle packet can
prepare the final coefficient bridge into
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
