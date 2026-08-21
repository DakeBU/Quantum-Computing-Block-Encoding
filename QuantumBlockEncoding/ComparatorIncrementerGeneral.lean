import QuantumBlockEncoding.ComparatorIncrementer
import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# Parameterized comparator and incrementer contracts

This file is the semantic bridge from the finite arithmetic seed to the
arbitrary-width constructions of arXiv:2603.12917.  It fixes the exact
correctness propositions first; the recursive circuit families and their
resource recurrences remain subsequent proof obligations.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerGeneral

open scoped BigOperators

/-- Little-endian integer represented by an `n`-wire primitive basis state. -/
def basisNat (n : Nat) (state : PrimitiveBasis n) : Nat :=
  (primitiveBasisLEEquiv n state).val

/-- Semantic contract for an `n`-bit modular incrementer. -/
def IncrementerSpec (n : Nat)
    (permutation : PrimitiveBasis n ≃ PrimitiveBasis n) : Prop :=
  ∀ state,
    basisNat n (permutation state) =
      (basisNat n state + 1) % gridSize n

/-- Low-address wire in an `n`-bit address plus one flag register. -/
def cqAddressWire (n : Nat) (wire : Fin n) : Fin (n + 1) :=
  ⟨wire.val, by omega⟩

/-- Flag wire in an `n`-bit address plus one flag register. -/
def cqFlagWire (n : Nat) : Fin (n + 1) :=
  ⟨n, by omega⟩

/-- Little-endian value of the address register used by a classical--quantum
comparator. -/
def cqAddressValue (n : Nat) (state : PrimitiveBasis (n + 1)) : Nat :=
  ∑ wire : Fin n, (state (cqAddressWire n wire)).val * 2 ^ wire.val

/-- Generic threshold-oracle contract used elsewhere in ASPBE: preserve the
address and toggle the flag iff `address < constant`.  This is deliberately
kept separate from Vandaele Equation (29), whose comparison direction is the
opposite one. -/
def AddressBelowConstantSpec (n constant : Nat)
    (permutation : PrimitiveBasis (n + 1) ≃ PrimitiveBasis (n + 1)) : Prop :=
  ∀ state,
    (∀ wire : Fin n,
      permutation state (cqAddressWire n wire) =
        state (cqAddressWire n wire)) ∧
    permutation state (cqFlagWire n) =
      if cqAddressValue n state < constant then
        flipBit (state (cqFlagWire n))
      else state (cqFlagWire n)

/-- Vandaele Equation (29): a classical constant `constant` is compared to the
quantum address `a`, and the flag is toggled iff `constant < a`. -/
def ClassicalComparatorSpec (n constant : Nat)
    (permutation : PrimitiveBasis (n + 1) ≃ PrimitiveBasis (n + 1)) : Prop :=
  ∀ state,
    (∀ wire : Fin n,
      permutation state (cqAddressWire n wire) =
        state (cqAddressWire n wire)) ∧
    permutation state (cqFlagWire n) =
      if constant < cqAddressValue n state then
        flipBit (state (cqFlagWire n))
      else state (cqFlagWire n)

/-- First quantum input register of an `n`-by-`n` comparator. -/
def qqLeftWire (n : Nat) (wire : Fin n) : Fin (2 * n + 1) :=
  ⟨wire.val, by omega⟩

/-- Second quantum input register of an `n`-by-`n` comparator. -/
def qqRightWire (n : Nat) (wire : Fin n) : Fin (2 * n + 1) :=
  ⟨n + wire.val, by omega⟩

/-- Output flag of an `n`-by-`n` comparator. -/
def qqFlagWire (n : Nat) : Fin (2 * n + 1) :=
  ⟨2 * n, by omega⟩

def qqLeftValue (n : Nat) (state : PrimitiveBasis (2 * n + 1)) : Nat :=
  ∑ wire : Fin n, (state (qqLeftWire n wire)).val * 2 ^ wire.val

def qqRightValue (n : Nat) (state : PrimitiveBasis (2 * n + 1)) : Nat :=
  ∑ wire : Fin n, (state (qqRightWire n wire)).val * 2 ^ wire.val

/-- Exact reversible quantum--quantum comparator contract. Both input
registers are preserved and the flag is toggled iff the left integer is less
than the right integer. -/
def QuantumComparatorSpec (n : Nat)
    (permutation : PrimitiveBasis (2 * n + 1) ≃ PrimitiveBasis (2 * n + 1)) : Prop :=
  ∀ state,
    (∀ wire : Fin n,
      permutation state (qqLeftWire n wire) = state (qqLeftWire n wire)) ∧
    (∀ wire : Fin n,
      permutation state (qqRightWire n wire) = state (qqRightWire n wire)) ∧
    permutation state (qqFlagWire n) =
      if qqLeftValue n state < qqRightValue n state then
        flipBit (state (qqFlagWire n))
      else state (qqFlagWire n)

/-- A proof-bearing program family interface.  Constructing a value of this
structure for all widths is exactly the missing arbitrary-width incrementer
correctness theorem; the structure itself does not assume such a family exists. -/
structure ReversibleIncrementerFamily where
  program : (n : Nat) → ReversibleProgram n
  correctness : ∀ n,
    IncrementerSpec n (evalReversibleProgram (program n))

/-- Proof-bearing interface for the source Equation-(29) classical comparator. -/
structure ReversibleClassicalComparatorFamily where
  program : (n constant : Nat) → ReversibleProgram (n + 1)
  correctness : ∀ n constant,
    ClassicalComparatorSpec n constant
      (evalReversibleProgram (program n constant))

/-- Separate family interface for generic ASPBE `address < constant` threshold
oracles. -/
structure ReversibleAddressBelowConstantComparatorFamily where
  program : (n constant : Nat) → ReversibleProgram (n + 1)
  correctness : ∀ n constant,
    AddressBelowConstantSpec n constant
      (evalReversibleProgram (program n constant))

/-- The fixed three-bit arithmetic seed is an actual instance of the
parameterized modular-incrementer semantics. -/
theorem incrementer3_satisfies_parameterized_spec :
    IncrementerSpec 3
      (evalReversibleProgram ComparatorIncrementer.incrementer3Program) := by
  native_decide

/-- The fixed `<3` seed belongs to the generic threshold-oracle direction, not
to Vandaele Equation (29).  Keeping this distinction explicit avoids silently
reversing the source comparator. -/
theorem comparatorLtThree_satisfies_addressBelow_spec :
    AddressBelowConstantSpec 2 3
      (evalReversibleProgram ComparatorIncrementer.comparatorLtThreeProgram) := by
  native_decide

end ComparatorIncrementerGeneral
end QuantumBlockEncoding
