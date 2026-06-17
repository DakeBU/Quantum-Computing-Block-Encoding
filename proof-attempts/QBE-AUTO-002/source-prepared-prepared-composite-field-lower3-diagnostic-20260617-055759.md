# Lower3 Diagnostic: Source-Prepared Prepared-Composite Field

Task: `QBE-AUTO-002`  
Run: `20260617-054403-QBE-AUTO-002-cycle01`  
Leaf: `source_prepared_prepared_composite_field`  
Role: lower3 necessary-condition verifier  
Timestamp: `2026-06-17 05:57:59 JST`

## Active Leaf

The active leaf is the source-prepared prepared-composite field around
`oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H`, specifically
the evaluated equality carried by:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

This diagnostic is a necessary condition because any theorem-facing proof of
that equality must survive finite instantiation of the prepared matrix `H` and
the coefficient environment `env`.  The compiled obstruction theorem reduces
the source field to the unwrapped comparison between the active seven-gate
`[0,0]` entry and the prepared sparse clean-clean entry:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_obstruction_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
```

## Lean-Local Diagnostic

No project Lean file was edited.  I ran this scratch Lean diagnostic through
`lake env lean --stdin`:

```lean
import QuantumBlockEncoding.RobinMatrix

namespace QuantumBlockEncoding
namespace Examples.RobinHeat

private def lower3AllOneEnv : String -> Rat :=
  fun name =>
    if name = "f_3_0" then 1
    else if name = "N_f_inv" then 1
    else if name = "boundary_cos_half_0_2" then 1
    else if name = "sqrt_kappa_inv" then 1
    else 0

private def lower3UniformH : Matrix 8 8 Coeff :=
  fun _ _ => Coeff.symbol "sqrt_kappa_inv"

example :
    oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
      lower3UniformH := by
  intro s
  rfl

example :
    ¬ oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
        lower3UniformH lower3AllOneEnv := by
  intro hActive
  have hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        lower3UniformH := by
    intro s
    rfl
  have hFold :
      oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        lower3AllOneEnv :=
    (oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
      lower3UniformH lower3AllOneEnv hUniform).1 hActive
  have hZero :
      Coeff.evalWith lower3AllOneEnv
        oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution =
        0 :=
    (oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3
      lower3AllOneEnv).1 hFold
  have hOne :
      Coeff.evalWith lower3AllOneEnv
        oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution =
        1 := by
    simpa [lower3AllOneEnv] using
      oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3
  have hContradiction : (1 : Rat) = 0 := by
    calc
      (1 : Rat) =
          Coeff.evalWith lower3AllOneEnv
            oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution :=
          hOne.symm
      _ = 0 := hZero
  exact (by native_decide : ¬ ((1 : Rat) = 0)) hContradiction

end Examples.RobinHeat
end QuantumBlockEncoding
```

The diagnostic compiled.  It rejects the active/prepared composite equality as
a theorem target under the uniform clean-column matrix and all-one selected
branch environment.

## Finite Check Result

The contradiction route is:

1. The uniform matrix `lower3UniformH` satisfies
   `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3`.
2. Under that contract,
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3`
   turns the active/prepared field into
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3`.
3. The evaluated backend fold forces the selected slot-`2` contribution to
   evaluate to `0` by
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_selectedSlotContributionEval_zero_n3`.
4. The all-one selected-branch environment evaluates the same selected slot
   contribution to `1` by
   `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`.

Therefore the finite/path check contradicts the current target if lower2 tries
to prove the active/prepared equality itself.  The compiled active/prepared
field records useful route memory, but it cannot be promoted into theorem
closure.

## Rejection

Reject lower2 proof search for:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

as an unconditional or uniform-column theorem target.

Safe next route: middle should either restate the source contract so it no
longer equates the H-free active seven-gate `[0,0]` entry with the prepared
singleton clean entry under this witness, or lower2 should compile only a
non-promoting audit wrapper that records the obstruction and keeps the active
field, evaluated fold, product-to-coefficient, normalized block, LCU, oracle,
unitary, final extraction, resource, post-baseline, and OPTCTRL flags false.

