# Middle Packet: Fixed Product-To-Coefficient Pre-Audit

Task: `QBE-AUTO-002`  
Run: `20260617-041033-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `fixed_product_to_coefficient_pre_audit`

## Source Contract

The active source theorem is GHL2025 Theorem `theorem: 1 term robin`, treated by
this run as the main one-term Robin block-encoding theorem.  The lower packet
uses only the maintained source anchors already synchronized in the conversion
window:

| Source anchor | Lean object | Use in this packet |
|---|---|---|
| Eq. `eq: ROBIN clarified`, boundary `gamma_3` branch | `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct` | focused slot-`2` coefficient/product route |
| Fig. `fig:1 term ROBIN` | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env` | theorem-facing source-prepared circuit, not the active seven-gate backend |
| Definition `def:block-encoding` | `oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3` | signal-zero block-entry backend gap |
| theorem denominator $N_D N_f \kappa$ | `interface.finiteBlockNormalizer` | normalizer used by the fixed product map |

No new cited result is needed.  The packet does not alter the paper circuit,
normalizer, oracle contracts, register layout, gate order, or semantic flags.

## Definitions

Use these abbreviations in the proof:

```lean
let interface :=
  oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
    H env
let gap := oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3
let obligation :=
  oneTermRobinGamma3ProductToCoefficientObligation 3
    ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

The compiled route memory to reuse is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
```

The invalid route remains:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
```

## Lower 1 Packet

Write the natural-language dependency proof for the coefficient/normalizer path.
The proof order is:

1. Reuse the compiled branch bridge to obtain the source-prepared entry equality
   with the slot-`2` projected branch product and the no-go guard against the
   generic backend projection statement.
2. Reuse the compiled finite-block normalizer bridge to obtain
   `sourcePreparedProjectionEntry * finiteBlockNormalizer =
   normalizedProjectionBridge.expectedTargetEntry`.
3. Read `BackendGap` as the current illness area: `BlockExtractionTarget`
   exposes the signal-zero block entry, but no backend-sourced
   `Fin 7 -> Coeff` summand family is available.
4. Conclude that the next Lean target is only a non-promoting pre-audit wrapper.
   It feeds `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, but it
   does not prove that obligation.

Record any disagreement as source-contract drift.  Do not ask lower2 to prove
`projectionSummationStatement`, `backendExpansionStatement`, the root product
obligation, LCU, block projection, unitarity, resource claims, post-baseline
candidate search, or OPTCTRL.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only, near the
compiled branch-decomposition wrapper.  Do not edit task files, paper notes, or
other Lean modules.

Compile exactly this theorem, with the same name unless Lean requires a minor
line-break adjustment:

```lean
theorem
    oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3
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
    let gap := oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3
    let obligation :=
      oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    Coeff.evalWith env interface.sourcePreparedProjectionEntry =
        Coeff.evalWith env
          oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct ∧
      Coeff.evalWith env interface.sourcePreparedProjectionEntry *
          Coeff.evalWith env interface.finiteBlockNormalizer =
        Coeff.evalWith env
          interface.normalizedProjectionBridge.expectedTargetEntry ∧
      interface.fixedProductObligation = obligation ∧
      obligation.proved = false ∧
      ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement ∧
      gap.exposesBranchContributionField = false ∧
      gap.backendFieldAvailable = false ∧
      gap.placeholderFamilyRejected = true ∧
      gap.projectionSummationProved = false ∧
      gap.productBridgeProved = false ∧
      gap.normalizedBlockEqualityProved = false ∧
      gap.productToCoefficientProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.normalizedBlockEqualityProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false
```

Suggested proof route:

```lean
  have hBranch :=
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3
      H env hUniform hentry
  have hNormalizer :=
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
      H env hUniform hentry hND hNF hkappa hkappaSqrt
  have hNoGo :=
    oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
  have _hGap := oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript
  rcases hBranch with
    ⟨_hNormProjected, hProjected, _hEntry, _hCircuitNe, hNoGoFromBranch, _⟩
  rcases hNormalizer with
    ⟨hNorm, _hFiniteNormalizer, _⟩
  dsimp [
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3,
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3,
    oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3,
    oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3,
    oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3,
    oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3] at *
```

Then finish with the two equalities, the fixed obligation identity, `hNoGo` or
`hNoGoFromBranch`, and `rfl` for the false flags.  If the nested `rcases`
pattern is brittle, destruct only the first two equality components and finish
the flags by `dsimp`.

Build expectation after any Lean edit:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

## Lower 3 Packet

Run a necessary-condition diagnostic before accepting the lower2 theorem:

| Field | Expected value |
|---|---|
| `leaf` | `fixed_product_to_coefficient_pre_audit` |
| `source_correspondence_ok` | `true` |
| `finite_matrix_ok` | `true` for typed source-prepared slot-`2` route only |
| `block_entry_ok` | `true` for the pre-audit equalities, not for root closure |
| `normalizer_ok` | `true` under explicit `hND`, `hNF`, `hkappa`, `hkappaSqrt` |
| `closed_theorem_ok` | `true` only if lower2 compiles the wrapper |
| `error_class` | `symbolic_bridge_gap` if uncompiled; `stale_leaf` only after compilation |
| `next_route` | keep `BackendGap` active and prepare a backend-sourced sparse-summand interface |

Reject the attempt if it assumes
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`,
uses `oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3` as a
closure route, changes `A`, changes the normalizer, promotes semantic flags, or
marks `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` proved.

## Middle Handoff

Middle handoff: leaf=`fixed_product_to_coefficient_pre_audit`; planned Lean
target=`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`;
source_correspondence_ok=true; next lower2 write scope is only
`QuantumBlockEncoding/RobinMatrix.lean`; lower3 must keep `BackendGap` active
and reject the generic backend projection statement.  This packet is not root
closure.
