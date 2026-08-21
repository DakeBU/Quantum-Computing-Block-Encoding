import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Vandaele Theorem 2 / Equation (25): recursive V2 register split

The comparator section names the recursive size

`beta = 2 ceil(sqrt n)`.

The incrementer recurrence module already uses the name `alpha(n)` for the same
arithmetic function.  To avoid silently conflating the paper's local notation,
this file exposes the comparator name `recursiveWidth` and records the equality
explicitly.

The V2 data region has `2n` wires.  Equation (25) separates a recursive
`recursiveWidth(n)`-wire V2 subproblem from the remaining local wires.  We give
the exact register equivalence, physical embeddings, partition arithmetic, and
the strict decrease used by the Theorem-2 recurrence.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorTheorem2RecursiveSplit

open ComparatorIncrementerRecurrence
open PrimitiveBasisRegisterSplit

/-- Comparator-paper beta; same arithmetic function as the incrementer module's
`alpha`. -/
def recursiveWidth (n : Nat) : Nat := alpha n

@[simp] theorem recursiveWidth_eq (n : Nat) :
    recursiveWidth n = 2 * ceilSqrt n := by
  rfl

/-- Nonrecursive wire mass inside the 2n-wire V2 data region. -/
def localWidth (n : Nat) : Nat := 2 * n - recursiveWidth n

/-- Ceiling square root is at most n for positive n. -/
theorem ceilSqrt_le_self {n : Nat} (positive : 1 ≤ n) : ceilSqrt n ≤ n := by
  unfold ceilSqrt
  by_cases square : Nat.sqrt n * Nat.sqrt n = n
  · simp [square]
    exact Nat.sqrt_le_self n
  · simp [square]
    have sqrtLt : Nat.sqrt n < n := by
      by_cases one : n = 1
      · subst n
        simp at square
      · have two : 2 ≤ n := by omega
        have sqrtLe := Nat.sqrt_le_self n
        omega
    omega

/-- Recursive V2 block fits inside the full 2n-wire data region. -/
theorem recursiveWidth_le_two_n
    {n : Nat} (positive : 1 ≤ n) :
    recursiveWidth n ≤ 2 * n := by
  unfold recursiveWidth alpha
  exact Nat.mul_le_mul_left 2 (ceilSqrt_le_self positive)

/-- Exact Equation-(25) wire partition. -/
theorem local_add_recursive
    {n : Nat} (positive : 1 ≤ n) :
    localWidth n + recursiveWidth n = 2 * n := by
  unfold localWidth
  have bound := recursiveWidth_le_two_n positive
  omega

/-- The recurrence parameter is strictly smaller beyond the finite base regime. -/
theorem recursive_parameter_decreases
    {n : Nat} (large : 7 ≤ n) : recursiveWidth n < n := by
  exact alpha_lt_self large

/-- Physical low local-wire embedding. -/
def localWire
    (n : Nat) (positive : 1 ≤ n)
    (wire : Fin (localWidth n)) : Fin (2 * n) :=
  ⟨wire.val, by
    have partition := local_add_recursive positive
    omega⟩

/-- Physical high recursive-subproblem embedding. -/
def recursiveWire
    (n : Nat) (positive : 1 ≤ n)
    (wire : Fin (recursiveWidth n)) : Fin (2 * n) :=
  ⟨localWidth n + wire.val, by
    have partition := local_add_recursive positive
    have bound := wire.isLt
    omega⟩

/-- The two source regions are disjoint. -/
theorem local_ne_recursive
    (n : Nat) (positive : 1 ≤ n)
    (local : Fin (localWidth n))
    (recursive : Fin (recursiveWidth n)) :
    localWire n positive local ≠ recursiveWire n positive recursive := by
  intro equal
  have values := congrArg Fin.val equal
  have localBound := local.isLt
  simp [localWire, recursiveWire] at values
  omega

/-- Both embeddings are injective. -/
theorem localWire_injective
    (n : Nat) (positive : 1 ≤ n) :
    Function.Injective (localWire n positive) := by
  intro left right equal
  apply Fin.ext
  exact congrArg Fin.val equal

theorem recursiveWire_injective
    (n : Nat) (positive : 1 ≤ n) :
    Function.Injective (recursiveWire n positive) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simp [recursiveWire] at values
  omega

/-- Every data wire belongs to one of the two Equation-(25) regions. -/
theorem wire_classification
    (n : Nat) (positive : 1 ≤ n) (wire : Fin (2 * n)) :
    (∃ local : Fin (localWidth n), localWire n positive local = wire) ∨
    (∃ recursive : Fin (recursiveWidth n),
      recursiveWire n positive recursive = wire) := by
  by_cases low : wire.val < localWidth n
  · left
    refine ⟨⟨wire.val, low⟩, ?_⟩
    apply Fin.ext
    rfl
  · right
    have localLe : localWidth n ≤ wire.val := by omega
    have partition := local_add_recursive positive
    have recursiveBound : wire.val - localWidth n < recursiveWidth n := by
      have wireBound := wire.isLt
      omega
    refine ⟨⟨wire.val - localWidth n, recursiveBound⟩, ?_⟩
    apply Fin.ext
    simp [recursiveWire]
    omega

/-- Exact product-register view of the 2n-wire V2 data region. -/
def dataSplitEquiv
    (n : Nat) (positive : 1 ≤ n) :
    PrimitiveBasis (2 * n) ≃
      PrimitiveBasis (localWidth n) × PrimitiveBasis (recursiveWidth n) := by
  rw [← local_add_recursive positive]
  exact basisSplitEquiv (localWidth n) (recursiveWidth n)

/-- Package the recursive split used by Equation (25). -/
structure RecursiveRegisterCertificate (n : Nat) where
  positive : 1 ≤ n
  local : Nat
  recursive : Nat
  partitions : local + recursive = 2 * n
  recursiveParameter : recursive = recursiveWidth n
  split : PrimitiveBasis (2 * n) ≃ PrimitiveBasis local × PrimitiveBasis recursive
  decreases : 7 ≤ n → recursive < n

/-- Canonical Equation-(25) register certificate. -/
def canonicalCertificate
    (n : Nat) (positive : 1 ≤ n) : RecursiveRegisterCertificate n where
  positive := positive
  local := localWidth n
  recursive := recursiveWidth n
  partitions := local_add_recursive positive
  recursiveParameter := rfl
  split := dataSplitEquiv n positive
  decreases := fun large => recursive_parameter_decreases large

end VandaeleComparatorTheorem2RecursiveSplit
end QuantumBlockEncoding
