import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.GidneyIncrementerProgramFamily
import QuantumBlockEncoding.PredicateControlledConjugation
import Mathlib.Tactic

/-!
# Figure-9 semantic assembly from controlled Gidney slices

A proof-bearing Gidney family may be refined into four chronological slices.
Figure 9 replaces each source slice by a low-resource implementation of the
*controlled* version of that same slice: slices 1 and 3 are handled by the
strong-promise ladder machinery, while slices 2 and 4 are handled by the
independent-involution / Lemma-5 machinery.

This module closes the global semantic step without assuming how any individual
replacement is implemented. If each replacement permutation is proved equal
to the predicate-controlled source slice, then their chronological composition
is exactly the predicate-controlled original Gidney incrementer.

Thus later gate-level work is local: prove four slice refinements and their
resource bounds. The overall controlled-increment correctness will not need to
be re-proved from scratch.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Figure9Assembly

open ComparatorIncrementerLemma7Contract
open GidneyIncrementerProgramFamily
open PredicateControlledConjugation

/-- One semantic replacement of a controlled source slice. -/
structure ControlledSliceReplacement
    {κ α : Type*}
    (active : κ → Bool) (source : Equiv.Perm α) where
  implementation : Equiv.Perm (κ × α)
  refinement :
    implementation = predicateControlledTargetEquiv active source

/-- Target controlled Gidney permutation before promise-register embedding. -/
def controlledGidneyTarget
    (family : ScheduledFamily) (k n : Nat) :
    Equiv.Perm (PrimitiveBasis k × PrimitiveBasis (flatWidth n)) :=
  predicateControlledTargetEquiv
    allControlsActive
    (evalReversibleProgram (family.scheduled n).program)

/-- Four local controlled replacements attached to one exact four-slice Gidney
decomposition. -/
structure FigureNineReplacement
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat) where
  slice1 : ControlledSliceReplacement allControlsActive
    (evalReversibleProgram (decomposition.slice1 n).program)
  slice2 : ControlledSliceReplacement allControlsActive
    (evalReversibleProgram (decomposition.slice2 n).program)
  slice3 : ControlledSliceReplacement allControlsActive
    (evalReversibleProgram (decomposition.slice3 n).program)
  slice4 : ControlledSliceReplacement allControlsActive
    (evalReversibleProgram (decomposition.slice4 n).program)

namespace FigureNineReplacement

/-- Chronological composition of the four replacement permutations. -/
def implementation
    {family : ScheduledFamily}
    {decomposition : FourSliceDecomposition family}
    {k n : Nat}
    (replacement : FigureNineReplacement family decomposition k n) :
    Equiv.Perm (PrimitiveBasis k × PrimitiveBasis (flatWidth n)) :=
  (((replacement.slice1.implementation.trans
      replacement.slice2.implementation).trans
      replacement.slice3.implementation).trans
      replacement.slice4.implementation)

/-- Evaluation of the four source slices is the evaluation of their composed
scheduled program. -/
theorem source_slice_eval_composition
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat) :
    (((evalReversibleProgram (decomposition.slice1 n).program).trans
        (evalReversibleProgram (decomposition.slice2 n).program)).trans
        (evalReversibleProgram (decomposition.slice3 n).program)).trans
        (evalReversibleProgram (decomposition.slice4 n).program) =
      evalReversibleProgram
        (composeFourSlices
          (decomposition.slice1 n)
          (decomposition.slice2 n)
          (decomposition.slice3 n)
          (decomposition.slice4 n)).program := by
  rw [composeFourSlices_program]
  rw [evalReversibleProgram_append]
  rw [evalReversibleProgram_append]
  rw [evalReversibleProgram_append]

/-- The four source slices reconstruct the exact certified Gidney permutation. -/
theorem source_slice_eval_eq_family
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (n : Nat) :
    (((evalReversibleProgram (decomposition.slice1 n).program).trans
        (evalReversibleProgram (decomposition.slice2 n).program)).trans
        (evalReversibleProgram (decomposition.slice3 n).program)).trans
        (evalReversibleProgram (decomposition.slice4 n).program) =
      evalReversibleProgram (family.scheduled n).program := by
  rw [source_slice_eval_composition family decomposition n]
  rw [decomposition.reconstructsProgram n]

/-- Global Figure-9 semantic theorem: local controlled-slice refinements compose
to the controlled original Gidney incrementer. -/
theorem correctness
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat)
    (replacement : FigureNineReplacement family decomposition k n) :
    replacement.implementation = controlledGidneyTarget family k n := by
  let source1 := evalReversibleProgram (decomposition.slice1 n).program
  let source2 := evalReversibleProgram (decomposition.slice2 n).program
  let source3 := evalReversibleProgram (decomposition.slice3 n).program
  let source4 := evalReversibleProgram (decomposition.slice4 n).program
  have sourceWhole :
      (((source1.trans source2).trans source3).trans source4) =
        evalReversibleProgram (family.scheduled n).program := by
    simpa [source1, source2, source3, source4] using
      source_slice_eval_eq_family family decomposition n
  calc
    replacement.implementation =
        (((predicateControlledTargetEquiv allControlsActive source1).trans
            (predicateControlledTargetEquiv allControlsActive source2)).trans
            (predicateControlledTargetEquiv allControlsActive source3)).trans
            (predicateControlledTargetEquiv allControlsActive source4) := by
      unfold implementation
      rw [replacement.slice1.refinement]
      rw [replacement.slice2.refinement]
      rw [replacement.slice3.refinement]
      rw [replacement.slice4.refinement]
    _ = ((predicateControlledTargetEquiv allControlsActive
            (source1.trans source2)).trans
          (predicateControlledTargetEquiv allControlsActive source3)).trans
          (predicateControlledTargetEquiv allControlsActive source4) := by
      rw [predicateControlledTarget_trans]
    _ = (predicateControlledTargetEquiv allControlsActive
            ((source1.trans source2).trans source3)).trans
          (predicateControlledTargetEquiv allControlsActive source4) := by
      rw [predicateControlledTarget_trans]
    _ = predicateControlledTargetEquiv allControlsActive
          (((source1.trans source2).trans source3).trans source4) := by
      rw [predicateControlledTarget_trans]
    _ = predicateControlledTargetEquiv allControlsActive
          (evalReversibleProgram (family.scheduled n).program) := by
      rw [sourceWhole]
    _ = controlledGidneyTarget family k n := by
      rfl

/-- Pointwise reader-facing form. -/
theorem action
    (family : ScheduledFamily)
    (decomposition : FourSliceDecomposition family)
    (k n : Nat)
    (replacement : FigureNineReplacement family decomposition k n)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (flatWidth n)) :
    replacement.implementation (controls, state) =
      if allControlsActive controls then
        (controls, evalReversibleProgram (family.scheduled n).program state)
      else (controls, state) := by
  rw [correctness family decomposition k n replacement]
  cases condition : allControlsActive controls <;>
    simp [controlledGidneyTarget, predicateControlledTargetEquiv, condition]

end FigureNineReplacement

end ComparatorIncrementerLemma7Figure9Assembly
end QuantumBlockEncoding