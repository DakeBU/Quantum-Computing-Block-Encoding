import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Canonical basis permutations for Vandaele comparators

The parameterized comparator contracts specify input/output behavior but do not
name one canonical permutation.  Source circuit refinements are cleaner when all
implementations target the same object.

This module constructs the computational-basis permutations directly:

* quantum-quantum: preserve both n-bit inputs and toggle z iff a<b;
* classical-quantum: preserve the n-bit input and toggle z iff a<constant.

The comparison predicates do not depend on the flag bit, so both actions are
involutions.
-/

namespace QuantumBlockEncoding
namespace ComparatorSemanticTargets

open ComparatorIncrementerGeneral

/-- Flipping the QQ flag leaves the left input value unchanged. -/
theorem qqLeftValue_xFlag
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    qqLeftValue n (xBasisAction (qqFlagWire n) state) = qqLeftValue n state := by
  unfold qqLeftValue
  apply Finset.sum_congr rfl
  intro wire _
  have distinct : qqLeftWire n wire ≠ qqFlagWire n := by
    intro equal
    have values := congrArg Fin.val equal
    simp [qqLeftWire, qqFlagWire] at values
    omega
  simp [xBasisAction, distinct]

/-- Flipping the QQ flag leaves the right input value unchanged. -/
theorem qqRightValue_xFlag
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    qqRightValue n (xBasisAction (qqFlagWire n) state) = qqRightValue n state := by
  unfold qqRightValue
  apply Finset.sum_congr rfl
  intro wire _
  have distinct : qqRightWire n wire ≠ qqFlagWire n := by
    intro equal
    have values := congrArg Fin.val equal
    simp [qqRightWire, qqFlagWire] at values
    omega
  simp [xBasisAction, distinct]

/-- Canonical QQ comparator action. -/
def quantumComparatorAction (n : Nat)
    (state : PrimitiveBasis (2 * n + 1)) : PrimitiveBasis (2 * n + 1) :=
  if qqLeftValue n state < qqRightValue n state then
    xBasisAction (qqFlagWire n) state
  else state

/-- QQ action is self-inverse because the predicate is flag-independent. -/
theorem quantumComparatorAction_involutive (n : Nat) :
    Function.Involutive (quantumComparatorAction n) := by
  intro state
  by_cases active : qqLeftValue n state < qqRightValue n state
  · rw [quantumComparatorAction, if_pos active]
    have activeAfter :
        qqLeftValue n (xBasisAction (qqFlagWire n) state) <
          qqRightValue n (xBasisAction (qqFlagWire n) state) := by
      simpa [qqLeftValue_xFlag, qqRightValue_xFlag] using active
    rw [quantumComparatorAction, if_pos activeAfter]
    exact xBasisAction_involutive (qqFlagWire n) state
  · rw [quantumComparatorAction, if_neg active]
    rw [quantumComparatorAction, if_neg active]

/-- Canonical QQ comparator permutation. -/
def quantumComparatorEquiv (n : Nat) :
    Equiv.Perm (PrimitiveBasis (2 * n + 1)) where
  toFun := quantumComparatorAction n
  invFun := quantumComparatorAction n
  left_inv := quantumComparatorAction_involutive n
  right_inv := quantumComparatorAction_involutive n

/-- Canonical QQ target satisfies the repository comparator contract exactly. -/
theorem quantumComparatorEquiv_spec (n : Nat) :
    QuantumComparatorSpec n (quantumComparatorEquiv n) := by
  intro state
  by_cases active : qqLeftValue n state < qqRightValue n state
  · constructor
    · intro wire
      have distinct : qqLeftWire n wire ≠ qqFlagWire n := by
        intro equal
        have values := congrArg Fin.val equal
        simp [qqLeftWire, qqFlagWire] at values
        omega
      simp [quantumComparatorEquiv, quantumComparatorAction,
        active, xBasisAction, distinct]
    · constructor
      · intro wire
        have distinct : qqRightWire n wire ≠ qqFlagWire n := by
          intro equal
          have values := congrArg Fin.val equal
          simp [qqRightWire, qqFlagWire] at values
          omega
        simp [quantumComparatorEquiv, quantumComparatorAction,
          active, xBasisAction, distinct]
      · simp [quantumComparatorEquiv, quantumComparatorAction,
          active, xBasisAction]
  · constructor
    · intro wire
      simp [quantumComparatorEquiv, quantumComparatorAction, active]
    · constructor
      · intro wire
        simp [quantumComparatorEquiv, quantumComparatorAction, active]
      · simp [quantumComparatorEquiv, quantumComparatorAction, active]

/-- Flipping the CQ flag leaves the address value unchanged. -/
theorem cqAddressValue_xFlag
    (n : Nat) (state : PrimitiveBasis (n + 1)) :
    cqAddressValue n (xBasisAction (cqFlagWire n) state) = cqAddressValue n state := by
  unfold cqAddressValue
  apply Finset.sum_congr rfl
  intro wire _
  have distinct : cqAddressWire n wire ≠ cqFlagWire n := by
    intro equal
    have values := congrArg Fin.val equal
    simp [cqAddressWire, cqFlagWire] at values
    omega
  simp [xBasisAction, distinct]

/-- Canonical classical-quantum comparator action. -/
def classicalComparatorAction (n constant : Nat)
    (state : PrimitiveBasis (n + 1)) : PrimitiveBasis (n + 1) :=
  if cqAddressValue n state < constant then
    xBasisAction (cqFlagWire n) state
  else state

/-- CQ action is self-inverse for the same flag-independence reason. -/
theorem classicalComparatorAction_involutive (n constant : Nat) :
    Function.Involutive (classicalComparatorAction n constant) := by
  intro state
  by_cases active : cqAddressValue n state < constant
  · rw [classicalComparatorAction, if_pos active]
    have activeAfter :
        cqAddressValue n (xBasisAction (cqFlagWire n) state) < constant := by
      simpa [cqAddressValue_xFlag] using active
    rw [classicalComparatorAction, if_pos activeAfter]
    exact xBasisAction_involutive (cqFlagWire n) state
  · rw [classicalComparatorAction, if_neg active]
    rw [classicalComparatorAction, if_neg active]

/-- Canonical CQ comparator permutation. -/
def classicalComparatorEquiv (n constant : Nat) :
    Equiv.Perm (PrimitiveBasis (n + 1)) where
  toFun := classicalComparatorAction n constant
  invFun := classicalComparatorAction n constant
  left_inv := classicalComparatorAction_involutive n constant
  right_inv := classicalComparatorAction_involutive n constant

/-- Canonical CQ target satisfies the repository contract exactly. -/
theorem classicalComparatorEquiv_spec (n constant : Nat) :
    ClassicalComparatorSpec n constant (classicalComparatorEquiv n constant) := by
  intro state
  by_cases active : cqAddressValue n state < constant
  · constructor
    · intro wire
      have distinct : cqAddressWire n wire ≠ cqFlagWire n := by
        intro equal
        have values := congrArg Fin.val equal
        simp [cqAddressWire, cqFlagWire] at values
        omega
      simp [classicalComparatorEquiv, classicalComparatorAction,
        active, xBasisAction, distinct]
    · simp [classicalComparatorEquiv, classicalComparatorAction,
        active, xBasisAction]
  · constructor
    · intro wire
      simp [classicalComparatorEquiv, classicalComparatorAction, active]
    · simp [classicalComparatorEquiv, classicalComparatorAction, active]

end ComparatorSemanticTargets
end QuantumBlockEncoding
