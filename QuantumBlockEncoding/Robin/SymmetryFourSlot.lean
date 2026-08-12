import QuantumBlockEncoding.Robin.FixedN3Data
import Mathlib.Tactic

/-!
# Centrosymmetric four-slot Robin decomposition

The fixed `N = 8` Robin matrix is centrosymmetric.  Passing to symmetric and
antisymmetric reversal sectors reduces the structural weighted-permutation
problem to two `4 x 4` matrices.  Each sector admits an exact four-cyclic-shift
decomposition.  This file is deliberately structural: the pairing transform
and its full complex-unitary circuit semantics are attached in a later module.
-/

namespace QuantumBlockEncoding.Robin

/-- Reverse an eight-dimensional basis index. -/
def warmRobinReverse8 (index : Fin 8) : Fin 8 :=
  ⟨7 - index.val, by omega⟩

@[simp] theorem warmRobinReverse8_value (index : Fin 8) :
    (warmRobinReverse8 index).val = 7 - index.val := by
  rfl

@[simp] theorem warmRobinReverse8_involution (index : Fin 8) :
    warmRobinReverse8 (warmRobinReverse8 index) = index := by
  fin_cases index <;> decide

/-- The fixed integer Robin matrix is invariant under simultaneous reversal. -/
theorem warmRobinIntegerTarget_centrosymmetric (row column : Fin 8) :
    warmRobinIntegerTarget row column =
      warmRobinIntegerTarget (warmRobinReverse8 row)
        (warmRobinReverse8 column) := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Embed the low representative of a reversal pair. -/
def warmRobinPairLow (index : Fin 4) : Fin 8 :=
  ⟨index.val, by omega⟩

/-- Embed the high representative paired with `index`. -/
def warmRobinPairHigh (index : Fin 4) : Fin 8 :=
  warmRobinReverse8 (warmRobinPairLow index)

/-- Integer matrix in the symmetric reversal sector. -/
def warmRobinSymmetryPlusBlock : Matrix 4 4 Int := fun row column =>
  warmRobinIntegerTarget (warmRobinPairLow row) (warmRobinPairLow column) +
    warmRobinIntegerTarget (warmRobinPairLow row) (warmRobinPairHigh column)

/-- Integer matrix in the antisymmetric reversal sector. -/
def warmRobinSymmetryMinusBlock : Matrix 4 4 Int := fun row column =>
  warmRobinIntegerTarget (warmRobinPairLow row) (warmRobinPairLow column) -
    warmRobinIntegerTarget (warmRobinPairLow row) (warmRobinPairHigh column)

/-- The four cyclic permutations used in both symmetry sectors. -/
def warmRobinSymmetryFourShiftPerm (slot column : Fin 4) : Fin 4 :=
  ⟨(column.val + slot.val) % 4, Nat.mod_lt _ (by decide)⟩

theorem warmRobinSymmetryFourShiftPerm_bijective (slot : Fin 4) :
    Function.Bijective (warmRobinSymmetryFourShiftPerm slot) := by
  fin_cases slot <;> decide

/-- Integer weights for the symmetric sector. -/
def warmRobinSymmetryPlusWeight (slot column : Fin 4) : Int :=
  match slot.val, column.val with
  | 0, 0 => -30 | 0, 1 => -31 | 0, 2 => -30 | 0, _ => -14
  | 1, 0 => 16 | 1, 1 => 16 | 1, 2 => 15 | 1, _ => 0
  | 2, 0 => -1 | 2, 1 => -1 | 2, 2 => -2 | 2, _ => -1
  | _, 0 => 0 | _, 1 => 32 | _, 2 => 16 | _, _ => 15

/-- Integer weights for the antisymmetric sector. -/
def warmRobinSymmetryMinusWeight (slot column : Fin 4) : Int :=
  match slot.val, column.val with
  | 0, 0 => -30 | 0, 1 => -31 | 0, 2 => -30 | 0, _ => -46
  | 1, 0 => 16 | 1, 1 => 16 | 1, 2 => 17 | 1, _ => 0
  | 2, 0 => -1 | 2, 1 => -1 | 2, 2 => -2 | 2, _ => -1
  | _, 0 => 0 | _, 1 => 32 | _, 2 => 16 | _, _ => 17

/-- Exact four-shift decomposition of the symmetric sector. -/
theorem warmRobinSymmetryPlusFourShiftDecomposition (row column : Fin 4) :
    warmRobinSymmetryPlusBlock row column =
      ∑ slot : Fin 4,
        if warmRobinSymmetryFourShiftPerm slot column = row then
          warmRobinSymmetryPlusWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Exact four-shift decomposition of the antisymmetric sector. -/
theorem warmRobinSymmetryMinusFourShiftDecomposition (row column : Fin 4) :
    warmRobinSymmetryMinusBlock row column =
      ∑ slot : Fin 4,
        if warmRobinSymmetryFourShiftPerm slot column = row then
          warmRobinSymmetryMinusWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Select the weight table by symmetry sector (`0` symmetric, `1` antisymmetric). -/
def warmRobinSymmetryFourShiftWeight
    (sector : Fin 2) (slot column : Fin 4) : Int :=
  if sector.val = 0 then
    warmRobinSymmetryPlusWeight slot column
  else
    warmRobinSymmetryMinusWeight slot column

/-- Clean coefficient used by the four-slot amplitude loader. -/
def warmRobinSymmetryFourShiftAmplitude
    (sector : Fin 2) (slot column : Fin 4) : Rat :=
  warmRobinSymmetryFourShiftWeight sector slot column / 56

/-- Every four-slot amplitude lies in the unit interval. -/
theorem warmRobinSymmetryFourShiftAmplitude_bounded
    (sector : Fin 2) (slot column : Fin 4) :
    |warmRobinSymmetryFourShiftAmplitude sector slot column| ≤
      (23 / 28 : Rat) := by
  fin_cases sector <;> fin_cases slot <;> fin_cases column <;> native_decide

/-- Structural clean formula in one symmetry sector. -/
def warmRobinSymmetryFourShiftCleanFormula
    (sector : Fin 2) : Matrix 4 4 Rat := fun row column =>
  (1 / 4 : Rat) * ∑ slot : Fin 4,
    if warmRobinSymmetryFourShiftPerm slot column = row then
      warmRobinSymmetryFourShiftAmplitude sector slot column
    else 0

/-- The symmetric-sector clean formula is exactly `M₊ / 224`. -/
theorem warmRobinSymmetryPlusFourShiftCleanFormula_eq
    (row column : Fin 4) :
    warmRobinSymmetryFourShiftCleanFormula 0 row column =
      (warmRobinSymmetryPlusBlock row column : Rat) / 224 := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- The antisymmetric-sector clean formula is exactly `M₋ / 224`. -/
theorem warmRobinSymmetryMinusFourShiftCleanFormula_eq
    (row column : Fin 4) :
    warmRobinSymmetryFourShiftCleanFormula 1 row column =
      (warmRobinSymmetryMinusBlock row column : Rat) / 224 := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Both symmetry blocks have four nonzero entries in column one. -/
theorem warmRobinSymmetryBlocks_columnOne_fullSupport :
    (∀ row : Fin 4, warmRobinSymmetryPlusBlock row 1 ≠ 0) ∧
      (∀ row : Fin 4, warmRobinSymmetryMinusBlock row 1 ≠ 0) := by
  constructor <;> intro row <;> fin_cases row <;> native_decide

end QuantumBlockEncoding.Robin
