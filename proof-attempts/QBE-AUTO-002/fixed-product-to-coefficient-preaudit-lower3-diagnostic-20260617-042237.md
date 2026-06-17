# Fixed Product-To-Coefficient Pre-Audit: Lower3 Diagnostic

Task: `QBE-AUTO-002`  
Run: `20260617-041033-QBE-AUTO-002-cycle01`  
Role: lower3 necessary-condition verifier  
Mode: `paperBenchmark`  
Leaf: `fixed_product_to_coefficient_pre_audit`

## Active Leaf

The active leaf is `fixed_product_to_coefficient_pre_audit`, with the planned
Lean wrapper:

```lean
oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3
```

This diagnostic is necessary because the next product route feeds
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  Before lower2
works on that wrapper, the source-prepared slot-`2` branch equality, the finite
normalizer equality, and the active `BackendGap` false flags must all be
checked together.  Otherwise a worker could accidentally revive the rejected
generic backend projection surface or promote the root product theorem.

## Lean-Local Diagnostic

No theorem-facing Lean declaration was edited.  I ran a non-persistent
`lake env lean --stdin` diagnostic importing `QuantumBlockEncoding.RobinMatrix`
and opening `QuantumBlockEncoding.Examples.RobinHeat`.

The diagnostic first checked these compiled route declarations:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_branchDecompositionProjectionBridge_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript
oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
```

It then proved the exact planned pre-audit conjunction over stdin:

```lean
example
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
    let gap := oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3
    let obligation :=
      oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    Coeff.evalWith env interface.sourcePreparedProjectionEntry =
        Coeff.evalWith env
          oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct /\
      Coeff.evalWith env interface.sourcePreparedProjectionEntry *
          Coeff.evalWith env interface.finiteBlockNormalizer =
        Coeff.evalWith env
          interface.normalizedProjectionBridge.expectedTargetEntry /\
      interface.fixedProductObligation = obligation /\
      obligation.proved = false /\
      ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement /\
      gap.exposesBranchContributionField = false /\
      gap.backendFieldAvailable = false /\
      gap.placeholderFamilyRejected = true /\
      gap.projectionSummationProved = false /\
      gap.productBridgeProved = false /\
      gap.normalizedBlockEqualityProved = false /\
      gap.productToCoefficientProved = false /\
      interface.productToCoefficientProved = false /\
      interface.normalizedBlockEqualityProved = false /\
      interface.lcuCorrectProved = false /\
      interface.blockProjectionProved = false /\
      interface.blockCorrectProved = false /\
      interface.finalExtractionProved = false
```

The stdin proof reused the compiled branch bridge, finite-block normalizer
bridge, `BackendGap` transcript, and generic projection-summation no-go guard.
It passed without writing a Lean declaration.

## Result

The necessary conditions passed for the planned non-promoting wrapper:

- `source_correspondence_ok=true`: the leaf stays tied to GHL2025 Theorem
  `theorem: 1 term robin`, Eq. `eq: ROBIN clarified` boundary `gamma_3`, Fig.
  `fig:1 term ROBIN`, and Definition `def:block-encoding`.
- `finite_matrix_ok=true`: the check is restricted to the typed `n=3`
  source-prepared slot-`2` route, not the root normalized-block theorem.
- `block_entry_ok=true`: the two pre-audit equalities compile in stdin.
- `normalizer_ok=true`: only under the explicit `hND`, `hNF`, `hkappa`, and
  `hkappaSqrt` hypotheses.
- `BackendGap` remains active: `backendFieldAvailable=false`,
  `projectionSummationProved=false`, and `productToCoefficientProved=false`.

The planned declaration itself is not present in `RobinMatrix.lean`, so
`closed_theorem_ok=false` for the named wrapper.  This is a
`symbolic_bridge_gap`, not a finite counterexample and not a stale leaf.

## Rejection

Reject any lower2 route that assumes:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Also reject using
`oneTermRobinGamma3BoundaryProjectionSummationProductBridge_leaf_n3` as root
closure or marking `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`
proved from this diagnostic.

## Gate

`python3 tools/qbe.py check` passed.  It ran `lake build` and
`lake build Tests`; both succeeded with only the known two diagnostic `sorry`
warnings in `QuantumBlockEncoding/RobinMatrix.lean`.

## Typed Feedback

```json
{
  "leaf": "fixed_product_to_coefficient_pre_audit",
  "source_correspondence_ok": true,
  "finite_matrix_ok": true,
  "block_entry_ok": true,
  "normalizer_ok": true,
  "closed_theorem_ok": false,
  "error_class": "symbolic_bridge_gap",
  "next_route": "Lower2 may compile exactly one non-promoting wrapper oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3; keep BackendGap active and then prepare a backend-sourced sparse-summand interface."
}
```
