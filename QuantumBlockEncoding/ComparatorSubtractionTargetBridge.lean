import QuantumBlockEncoding.ComparatorSemanticTargets
import QuantumBlockEncoding.ComparatorSubtractionSemantics

/-!
# Bridge from subtraction high bit to the canonical QQ comparator

Vandaele Section 4.1 constructs comparison from the high bit of subtraction.
`ComparatorSubtractionSemantics` proves the arithmetic predicate; this module
turns it into an exact permutation identity.

The source-facing subtraction comparator toggles the flag iff the `(n+1)`-bit
representative of `a-b` has its high bit set.  The arithmetic high-bit theorem
then identifies this permutation with the canonical `a<b` comparator target.
-/

namespace QuantumBlockEncoding
namespace ComparatorSubtractionTargetBridge

open ComparatorIncrementerGeneral
open ComparatorSemanticTargets
open ComparatorSubtractionSemantics

/-- High-bit predicate read from the source subtraction semantics. -/
def subtractionHighActive
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) : Prop :=
  gridSize n ≤
    signedSubValue n
      ⟨qqLeftValue n state, qqLeftValue_lt_gridSize n state⟩
      ⟨qqRightValue n state, qqRightValue_lt_gridSize n state⟩

/-- Source subtraction-high-bit comparator action. -/
def subtractionComparatorAction
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    PrimitiveBasis (2 * n + 1) :=
  if subtractionHighActive n state then
    xBasisAction (qqFlagWire n) state
  else state

/-- Source high-bit predicate is exactly the public comparison predicate. -/
theorem subtractionHighActive_iff
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    subtractionHighActive n state ↔
      qqLeftValue n state < qqRightValue n state := by
  exact state_highBit_iff_comparison n state

/-- Pointwise source action equals the canonical comparator action. -/
theorem subtractionComparatorAction_eq
    (n : Nat) (state : PrimitiveBasis (2 * n + 1)) :
    subtractionComparatorAction n state = quantumComparatorAction n state := by
  unfold subtractionComparatorAction quantumComparatorAction
  rw [propext (subtractionHighActive_iff n state)]

/-- The subtraction construction therefore refines to the unique canonical QQ
comparator permutation. -/
def subtractionComparatorEquiv (n : Nat) :
    Equiv.Perm (PrimitiveBasis (2 * n + 1)) :=
  quantumComparatorEquiv n

/-- Reader-facing exact identity; the named source target is not a second
semantic object. -/
theorem subtractionComparatorEquiv_eq_canonical (n : Nat) :
    subtractionComparatorEquiv n = quantumComparatorEquiv n := by
  rfl

/-- Source subtraction interpretation satisfies the public QQ comparator spec. -/
theorem subtractionComparator_spec (n : Nat) :
    QuantumComparatorSpec n (subtractionComparatorEquiv n) :=
  quantumComparatorEquiv_spec n

end ComparatorSubtractionTargetBridge
end QuantumBlockEncoding
