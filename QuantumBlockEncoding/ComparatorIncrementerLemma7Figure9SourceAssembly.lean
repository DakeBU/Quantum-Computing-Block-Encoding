import QuantumBlockEncoding.ComparatorIncrementerLemma7Figure9Assembly
import QuantumBlockEncoding.PredicateControlledConjugation
import Mathlib.Tactic

/-!
# Source-faithful Figure-9 conjugation assembly

Vandaele Figure 9 controls only slices 2 and 4 of the Gidney incrementer.
Slices 1 and 3 are the CCX compute/uncompute ladders and remain uncontrolled.
They are not required to restore the promise register individually: their role
is precisely the outer `V` / `V†` pair in the controlled-conjugation identity
of Figure 3(a).

Accordingly, the source-level proof obligation is:

1. the four scheduled slices reconstruct the exact certified Gidney program;
2. slice 3 is the inverse permutation of slice 1;
3. slices 2 and 4 receive the external predicate control.

Then

`V ; C(U₂) ; V† ; C(U₄)`

is exactly the predicate-controlled complete Gidney permutation.  This module
proves that statement without guessing any gate list inside the four slices.
The remaining gate-level task is to exhibit a four-slice decomposition with the
inverse-ladder property and refine slices 2/4 by Lemma 5.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Figure9SourceAssembly

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7Figure9Assembly
open GidneyIncrementerProgramFamily
open PredicateControlledConjugation
open PromiseGateOptimization

/-- Optimized Figure-9 control pattern: the outer ladder pair is left
uncontrolled, while only the middle/non-ladder slices receive the external
predicate control. -/
def optimizedFigureNineImplementation
    {κ α : Type*} (active : κ → Bool)
    (outer middle trailing : Equiv.Perm α) :
    Equiv.Perm (κ × α) :=
  (((liftKeyTargetEquiv outer).trans
      (predicateControlledTargetEquiv active middle)).trans
      (liftKeyTargetEquiv outer.symm)).trans
      (predicateControlledTargetEquiv active trailing)

/-- Figure 3(a) plus control-distribution over sequential composition proves the
optimized pattern is the controlled composite target. -/
theorem optimizedFigureNine_eq_controlled_composite
    {κ α : Type*} (active : κ → Bool)
    (outer middle trailing : Equiv.Perm α) :
    optimizedFigureNineImplementation active outer middle trailing =
      predicateControlledTargetEquiv active
        ((conjugatedTargetEquiv outer middle).trans trailing) := by
  unfold optimizedFigureNineImplementation
  rw [predicateControlledConjugation_equiv]
  rw [predicateControlledTarget_trans]

/-- Source-specific structural condition not contained in the generic
`FourSliceDecomposition`: the third Gidney slice uncomputes the first ladder. -/
structure SourceFigureNineDecomposition
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat) where
  slice3Inverse :
    evalReversibleProgram (decomposition.slice3 n).program =
      (evalReversibleProgram (decomposition.slice1 n).program).symm

/-- Under the source inverse-ladder condition, the conjugated first three slices
followed by slice 4 are exactly the original certified Gidney permutation. -/
theorem source_composite_eq_family
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat)
    (source : SourceFigureNineDecomposition family decomposition n) :
    (conjugatedTargetEquiv
        (evalReversibleProgram (decomposition.slice1 n).program)
        (evalReversibleProgram (decomposition.slice2 n).program)).trans
      (evalReversibleProgram (decomposition.slice4 n).program) =
        evalReversibleProgram (family.scheduled n).program := by
  apply Equiv.ext
  intro state
  have whole := Equiv.congr_fun
    (FigureNineReplacement.source_slice_eval_eq_family
      family decomposition n) state
  simpa [conjugatedTargetEquiv, Equiv.trans_apply,
    source.slice3Inverse] using whole

/-- Exact source Figure-9 semantic theorem: leave slices 1/3 uncontrolled,
control slices 2/4, and obtain the same controlled Gidney permutation as the
naive all-gates-controlled route. -/
theorem source_optimized_eq_controlledGidney
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat)
    (source : SourceFigureNineDecomposition family decomposition n) :
    optimizedFigureNineImplementation
        allControlsActive
        (evalReversibleProgram (decomposition.slice1 n).program)
        (evalReversibleProgram (decomposition.slice2 n).program)
        (evalReversibleProgram (decomposition.slice4 n).program) =
      controlledGidneyTarget family k n := by
  calc
    optimizedFigureNineImplementation
        allControlsActive
        (evalReversibleProgram (decomposition.slice1 n).program)
        (evalReversibleProgram (decomposition.slice2 n).program)
        (evalReversibleProgram (decomposition.slice4 n).program) =
      predicateControlledTargetEquiv allControlsActive
        ((conjugatedTargetEquiv
          (evalReversibleProgram (decomposition.slice1 n).program)
          (evalReversibleProgram (decomposition.slice2 n).program)).trans
          (evalReversibleProgram (decomposition.slice4 n).program)) :=
      optimizedFigureNine_eq_controlled_composite _ _ _ _
    _ = predicateControlledTargetEquiv allControlsActive
        (evalReversibleProgram (family.scheduled n).program) := by
      rw [source_composite_eq_family family decomposition n source]
    _ = controlledGidneyTarget family k n := by
      rfl

/-- Reader-facing action form.  The optimized source control pattern has exactly
the same computational-basis action as controlling the complete Gidney
permutation. -/
theorem source_optimized_action
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat)
    (source : SourceFigureNineDecomposition family decomposition n)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (flatWidth n)) :
    optimizedFigureNineImplementation
        allControlsActive
        (evalReversibleProgram (decomposition.slice1 n).program)
        (evalReversibleProgram (decomposition.slice2 n).program)
        (evalReversibleProgram (decomposition.slice4 n).program)
        (controls, state) =
      if allControlsActive controls then
        (controls, evalReversibleProgram (family.scheduled n).program state)
      else (controls, state) := by
  rw [source_optimized_eq_controlledGidney
    family decomposition k n source]
  cases condition : allControlsActive controls <;>
    simp [controlledGidneyTarget, predicateControlledTargetEquiv, condition]

end ComparatorIncrementerLemma7Figure9SourceAssembly
end QuantumBlockEncoding