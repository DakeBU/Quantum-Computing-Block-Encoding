import QuantumBlockEncoding.Robin.SourceBaseline
import QuantumBlockEncoding.Robin.WeightedPermutation
import Mathlib.Tactic

/-!
# Fixed Robin structural candidates

These are exact clean-branch algebra certificates. They deliberately stop
short of `VerifiedOperatorBlockEncoding`: PREPARE and coefficient rotations
still need one common complex-unitary circuit semantics.
-/

namespace QuantumBlockEncoding.Robin

/-- Clean branch predicted by the uniform-five LCU construction. -/
def warmRobinFiveShiftCleanFormula : Matrix 8 8 Rat := fun row column =>
  (1 / 5 : Rat) * ∑ slot : Fin 5,
    if warmRobinFiveShiftPerm slot column = row then
      warmRobinFiveShiftAmplitude slot column
    else 0

theorem warmRobinFiveShiftCleanFormula_eq_target (row column : Fin 8) :
    warmRobinFiveShiftCleanFormula row column =
      RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Clean branch predicted by the uniform Hadamard-8 LCU construction. -/
def warmRobinHadamard8CleanFormula : Matrix 8 8 Rat := fun row column =>
  (1 / 8 : Rat) * ∑ slot : Fin 8,
    if warmRobinEightSlotPerm slot column = row then
      warmRobinEightSlotAmplitude slot column
    else 0

theorem warmRobinHadamard8CleanFormula_eq_target (row column : Fin 8) :
    warmRobinHadamard8CleanFormula row column =
      RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer := by
  fin_cases row <;> fin_cases column <;> native_decide

def warmRobinSevenToEightSlot (slot : Fin 7) : Fin 8 :=
  ⟨match slot.val with | 0 => 0 | x + 1 => x + 2,
    by fin_cases slot <;> decide⟩

def warmRobinSevenSlotPerm (slot : Fin 7) (column : Fin 8) : Fin 8 :=
  warmRobinEightSlotPerm (warmRobinSevenToEightSlot slot) column

def warmRobinSevenSlotWeight (slot : Fin 7) (column : Fin 8) : Int :=
  match slot.val with
  | 0 => if column.val = 1 || column.val = 6 then -31 else -30
  | _ => warmRobinEightSlotWeight (warmRobinSevenToEightSlot slot) column

theorem warmRobinSevenSlotDecomposition (row column : Fin 8) :
    warmRobinIntegerTarget row column =
      ∑ slot : Fin 7,
        if warmRobinSevenSlotPerm slot column = row then
          warmRobinSevenSlotWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

def warmRobinSevenSlotAmplitude (slot : Fin 7) (column : Fin 8) : Rat :=
  warmRobinSevenSlotWeight slot column / 32

theorem warmRobinSevenSlotAmplitude_bounded (slot : Fin 7) (column : Fin 8) :
    |warmRobinSevenSlotAmplitude slot column| ≤ (31 / 32 : Rat) := by
  fin_cases slot <;> fin_cases column <;> native_decide

def warmRobinSevenSlotCleanFormula : Matrix 8 8 Rat := fun row column =>
  (1 / 7 : Rat) * ∑ slot : Fin 7,
    if warmRobinSevenSlotPerm slot column = row then
      warmRobinSevenSlotAmplitude slot column
    else 0

theorem warmRobinSevenSlotCleanFormula_eq_target (row column : Fin 8) :
    warmRobinSevenSlotCleanFormula row column =
      RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer := by
  fin_cases row <;> fin_cases column <;> native_decide

/-- Precise T2 blocker shared by the structural candidates. -/
def warmRobinStructuralCandidateBlockedLeaf : String :=
  "construct one complex-unitary PREPARE/SELECT/amplitude/unprepare matrix and prove its clean block is the compiled clean formula"

end QuantumBlockEncoding.Robin
