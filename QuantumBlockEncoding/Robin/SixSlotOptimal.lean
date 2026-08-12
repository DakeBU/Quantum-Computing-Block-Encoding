import QuantumBlockEncoding.Robin.FixedN3Data
import Mathlib.Tactic

/-!
# Six-slot Robin decomposition with cap sum 80

This exact certificate separates two comparison regimes.  With amplitudes
scaled by `5/14` it block-encodes the established fixed target `M / 224`, hence
uses the same normalizer `56/3` as the warm benchmark.  Without that extra
scaling it block-encodes `M / 80`, corresponding to the smaller intrinsic
normalizer `20/3`.
-/

namespace QuantumBlockEncoding.Robin

/-- Six finite basis permutations, represented column-to-row. -/
def warmRobinSixSlotPerm (slot : Fin 6) (column : Fin 8) : Fin 8 :=
  ⟨match slot.val, column.val with
    | 0, 0 => 1 | 0, 1 => 0 | 0, 2 => 2 | 0, 3 => 3
    | 0, 4 => 4 | 0, 5 => 5 | 0, 6 => 7 | 0, _ => 6
    | 1, 0 => 0 | 1, 1 => 1 | 1, 2 => 3 | 1, 3 => 2
    | 1, 4 => 5 | 1, 5 => 4 | 1, 6 => 6 | 1, _ => 7
    | 2, 0 => 0 | 2, 1 => 2 | 2, 2 => 1 | 2, 3 => 4
    | 2, 4 => 3 | 2, 5 => 6 | 2, 6 => 5 | 2, _ => 7
    | 3, 0 => 3 | 3, 1 => 1 | 3, 2 => 0 | 3, 3 => 5
    | 3, 4 => 2 | 3, 5 => 7 | 3, 6 => 6 | 3, _ => 4
    | 4, 0 => 2 | 4, 1 => 3 | 4, 2 => 0 | 4, 3 => 1
    | 4, 4 => 6 | 4, 5 => 7 | 4, 6 => 4 | 4, _ => 5
    | _, 0 => 7 | _, 1 => 1 | _, 2 => 4 | _, 3 => 2
    | _, 4 => 5 | _, 5 => 3 | _, 6 => 6 | _, _ => 0,
    by fin_cases slot <;> fin_cases column <;> decide⟩

/-- Integer coefficient table for the six-slot certificate. -/
def warmRobinSixSlotWeight (slot : Fin 6) (column : Fin 8) : Int :=
  match slot.val, column.val with
  | 0, 0 => 16 | 0, 1 => 32 | 0, 2 => -30 | 0, 3 => -30
  | 0, 4 => -30 | 0, 5 => -30 | 0, 6 => 32 | 0, _ => 16
  | 1, 0 => -14 | 1, 1 => -29 | 1, 2 => 16 | 1, 3 => 15
  | 1, 4 => 15 | 1, 5 => 16 | 1, 6 => -29 | 1, _ => -14
  | 2, 0 => -16 | 2, 1 => 16 | 2, 2 => 16 | 2, 3 => 16
  | 2, 4 => 16 | 2, 5 => 16 | 2, 6 => 16 | 2, _ => -16
  | 3, 0 => 0 | 3, 1 => -1 | 3, 2 => -1 | 3, 3 => -1
  | 3, 4 => -1 | 3, 5 => -1 | 3, 6 => -1 | 3, _ => 0
  | 4, _ => -1
  | _, 0 => 0 | _, 1 => -1 | _, 2 => -1 | _, 3 => 1
  | _, 4 => 1 | _, 5 => -1 | _, 6 => -1 | _, _ => 0

/-- Per-slot absolute coefficient caps. -/
def warmRobinSixSlotCap (slot : Fin 6) : Nat :=
  match slot.val with
  | 0 => 32
  | 1 => 29
  | 2 => 16
  | _ => 1

theorem warmRobinSixSlotPerm_bijective (slot : Fin 6) :
    Function.Bijective (warmRobinSixSlotPerm slot) := by
  fin_cases slot <;> decide

/-- Exact reconstruction of the integer target. -/
theorem warmRobinSixSlotDecomposition (row column : Fin 8) :
    warmRobinIntegerTarget row column =
      ∑ slot : Fin 6,
        if warmRobinSixSlotPerm slot column = row then
          warmRobinSixSlotWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Every coefficient is bounded by its declared slot cap. -/
theorem warmRobinSixSlotWeight_natAbs_le_cap
    (slot : Fin 6) (column : Fin 8) :
    Int.natAbs (warmRobinSixSlotWeight slot column) ≤
      warmRobinSixSlotCap slot := by
  fin_cases slot <;> fin_cases column <;> native_decide

/-- The six caps sum to 80. -/
theorem warmRobinSixSlotCap_sum_eq_eighty :
    (∑ slot : Fin 6, warmRobinSixSlotCap slot) = 80 := by
  native_decide

/-- Probability assigned to one selector slot by the intrinsic PREPARE. -/
def warmRobinSixSlotPrepareProbability (slot : Fin 6) : Rat :=
  (warmRobinSixSlotCap slot : Rat) / 80

/-- Intrinsic clean coefficient `weight / cap`. -/
def warmRobinSixSlotIntrinsicAmplitude
    (slot : Fin 6) (column : Fin 8) : Rat :=
  (warmRobinSixSlotWeight slot column : Rat) /
    (warmRobinSixSlotCap slot : Rat)

/-- All intrinsic amplitude coefficients lie in `[-1,1]`. -/
theorem warmRobinSixSlotIntrinsicAmplitude_bounded
    (slot : Fin 6) (column : Fin 8) :
    |warmRobinSixSlotIntrinsicAmplitude slot column| ≤ 1 := by
  fin_cases slot <;> fin_cases column <;> native_decide

/-- Coefficient for the fixed `M/224` comparison contract. -/
def warmRobinSixSlotFixedAmplitude
    (slot : Fin 6) (column : Fin 8) : Rat :=
  (5 / 14 : Rat) * warmRobinSixSlotIntrinsicAmplitude slot column

/-- Fixed-normalizer amplitudes are uniformly bounded by `5/14`. -/
theorem warmRobinSixSlotFixedAmplitude_bounded
    (slot : Fin 6) (column : Fin 8) :
    |warmRobinSixSlotFixedAmplitude slot column| ≤ (5 / 14 : Rat) := by
  fin_cases slot <;> fin_cases column <;> native_decide

/-- Structural clean formula at the intrinsic normalizer. -/
def warmRobinSixSlotIntrinsicCleanFormula : Matrix 8 8 Rat := fun row column =>
  ∑ slot : Fin 6,
    warmRobinSixSlotPrepareProbability slot *
      if warmRobinSixSlotPerm slot column = row then
        warmRobinSixSlotIntrinsicAmplitude slot column
      else 0

/-- The intrinsic formula is exactly `A / (20/3) = M/80`. -/
theorem warmRobinSixSlotIntrinsicCleanFormula_eq_target
    (row column : Fin 8) :
    warmRobinSixSlotIntrinsicCleanFormula row column =
      RobinEvolution.warmRobinTarget row column / (20 / 3 : Rat) := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Structural clean formula under the established fixed normalizer. -/
def warmRobinSixSlotFixedCleanFormula : Matrix 8 8 Rat := fun row column =>
  ∑ slot : Fin 6,
    warmRobinSixSlotPrepareProbability slot *
      if warmRobinSixSlotPerm slot column = row then
        warmRobinSixSlotFixedAmplitude slot column
      else 0

/-- The fixed formula is exactly `A / (56/3) = M/224`. -/
theorem warmRobinSixSlotFixedCleanFormula_eq_target
    (row column : Fin 8) :
    warmRobinSixSlotFixedCleanFormula row column =
      RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Absolute column sum of the integer target. -/
def warmRobinIntegerColumnL1 (column : Fin 8) : Nat :=
  ∑ row : Fin 8, Int.natAbs (warmRobinIntegerTarget row column)

theorem warmRobinIntegerColumnL1_le_eighty (column : Fin 8) :
    warmRobinIntegerColumnL1 column ≤ 80 := by
  fin_cases column <;> native_decide

theorem warmRobinIntegerColumnOneL1_eq_eighty :
    warmRobinIntegerColumnL1 1 = 80 := by
  native_decide

/-- The cap sum attains the largest absolute column sum of the target. -/
theorem warmRobinSixSlotCap_sum_eq_maxColumnL1 :
    (∑ slot : Fin 6, warmRobinSixSlotCap slot) =
      warmRobinIntegerColumnL1 1 := by
  native_decide

end QuantumBlockEncoding.Robin
