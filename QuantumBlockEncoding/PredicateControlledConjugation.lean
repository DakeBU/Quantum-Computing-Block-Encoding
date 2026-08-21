import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.Robin.ComplexLCU

/-!
# Predicate-controlled conjugation

Vandaele Figure 3(a) / Theorem 1 uses the fact that when
`W = V† U V`, controls need only be attached to the middle `U`; the outer `V`
and `V†` remain uncontrolled.  The repository already contains the one-Boolean
version.  This module lifts the identity to an arbitrary computational-basis
key predicate, which is the natural semantic model of k control qubits.

The theorem is independent of promise-register/resource considerations and is a
shared algebraic node for Lemma 5/7, comparator constructions, and later SP/BE
controlled subroutines.
-/

namespace QuantumBlockEncoding
namespace PredicateControlledConjugation

open PromiseGateOptimization
open Robin.ComplexLCU

/-- Apply a target permutation while preserving an arbitrary key register. -/
def liftKeyTargetEquiv {κ α : Type*} (target : Equiv.Perm α) :
    Equiv.Perm (κ × α) :=
  Equiv.prodCongr (Equiv.refl κ) target

/-- Apply a target permutation exactly on keys satisfying a Boolean predicate. -/
def predicateControlledTargetEquiv {κ α : Type*}
    (active : κ → Bool) (target : Equiv.Perm α) :
    Equiv.Perm (κ × α) where
  toFun state :=
    if active state.1 then (state.1, target state.2) else state
  invFun state :=
    if active state.1 then (state.1, target.symm state.2) else state
  left_inv state := by
    rcases state with ⟨key, value⟩
    cases condition : active key <;> simp [condition]
  right_inv state := by
    rcases state with ⟨key, value⟩
    cases condition : active key <;> simp [condition]

/-- Figure 3(a) for an arbitrary key predicate: only the middle operation needs
the external controls. -/
theorem predicateControlledConjugation_equiv
    {κ α : Type*} (active : κ → Bool)
    (outer middle : Equiv.Perm α) :
    ((liftKeyTargetEquiv outer).trans
        (predicateControlledTargetEquiv active middle)).trans
          (liftKeyTargetEquiv outer.symm) =
      predicateControlledTargetEquiv active
        (conjugatedTargetEquiv outer middle) := by
  apply Equiv.ext
  intro state
  rcases state with ⟨key, value⟩
  cases condition : active key <;>
    simp [liftKeyTargetEquiv, predicateControlledTargetEquiv,
      conjugatedTargetEquiv, condition]

/-- Exact pointwise form of the same identity. -/
theorem predicateControlledConjugation_action
    {κ α : Type*} (active : κ → Bool)
    (outer middle : Equiv.Perm α)
    (key : κ) (value : α) :
    (((liftKeyTargetEquiv outer).trans
        (predicateControlledTargetEquiv active middle)).trans
          (liftKeyTargetEquiv outer.symm)) (key, value) =
      if active key then
        (key, conjugatedTargetEquiv outer middle value)
      else (key, value) := by
  rw [predicateControlledConjugation_equiv]
  cases condition : active key <;>
    simp [predicateControlledTargetEquiv, condition]

/-- Matrix-level source identity. -/
theorem predicateControlledConjugation_matrix
    {κ α : Type*} [Fintype κ] [DecidableEq κ]
    [Fintype α] [DecidableEq α]
    (active : κ → Bool) (outer middle : Equiv.Perm α) :
    equivPermutationMatrix (liftKeyTargetEquiv outer.symm) *
        (equivPermutationMatrix
          (predicateControlledTargetEquiv active middle) *
          equivPermutationMatrix (liftKeyTargetEquiv outer)) =
      equivPermutationMatrix
        (predicateControlledTargetEquiv active
          (conjugatedTargetEquiv outer middle)) := by
  rw [equivPermutationMatrix_mul, equivPermutationMatrix_mul]
  rw [predicateControlledConjugation_equiv]

end PredicateControlledConjugation
end QuantumBlockEncoding
