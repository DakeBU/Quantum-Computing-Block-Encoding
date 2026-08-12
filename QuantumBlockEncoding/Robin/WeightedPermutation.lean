import QuantumBlockEncoding.Robin.FixedN3Data
import Mathlib.Tactic

/-!
# Exact weighted-permutation decompositions of the fixed Robin matrix
-/

namespace QuantumBlockEncoding.Robin

def warmRobinFiveShiftPerm (slot : Fin 5) (column : Fin 8) : Fin 8 :=
  ⟨match slot.val with
    | 0 => column.val
    | 1 => (column.val + 7) % 8
    | 2 => (column.val + 1) % 8
    | 3 => (column.val + 6) % 8
    | _ => (column.val + 2) % 8,
   by fin_cases slot <;> fin_cases column <;> decide⟩

def warmRobinFiveShiftInverse (slot : Fin 5) (row : Fin 8) : Fin 8 :=
  ⟨match slot.val with
    | 0 => row.val
    | 1 => (row.val + 1) % 8
    | 2 => (row.val + 7) % 8
    | 3 => (row.val + 2) % 8
    | _ => (row.val + 6) % 8,
   by fin_cases slot <;> fin_cases row <;> decide⟩

def warmRobinFiveShiftWeight (slot : Fin 5) (column : Fin 8) : Int :=
  match slot.val with
  | 0 => if column.val = 1 || column.val = 6 then -31 else -30
  | 1 => if column.val = 0 then 0 else if column.val = 1 then 32 else 16
  | 2 => if column.val = 7 then 0 else if column.val = 6 then 32 else 16
  | 3 => if column.val < 2 then 0 else if column.val = 2 then -2 else -1
  | _ => if 6 ≤ column.val then 0 else if column.val = 5 then -2 else -1

theorem warmRobinFiveShift_leftInverse (slot : Fin 5) (column : Fin 8) :
    warmRobinFiveShiftInverse slot (warmRobinFiveShiftPerm slot column) = column := by
  fin_cases slot <;> fin_cases column <;> decide

theorem warmRobinFiveShift_rightInverse (slot : Fin 5) (row : Fin 8) :
    warmRobinFiveShiftPerm slot (warmRobinFiveShiftInverse slot row) = row := by
  fin_cases slot <;> fin_cases row <;> decide

theorem warmRobinFiveShiftPerm_bijective (slot : Fin 5) :
    Function.Bijective (warmRobinFiveShiftPerm slot) := by
  constructor
  · intro x y equality
    simpa only [warmRobinFiveShift_leftInverse] using
      congrArg (warmRobinFiveShiftInverse slot) equality
  · intro y
    exact ⟨warmRobinFiveShiftInverse slot y,
      warmRobinFiveShift_rightInverse slot y⟩

/-- Exact 64-entry five-shift decomposition, with columns mapped to rows. -/
theorem warmRobinFiveShiftDecomposition (row column : Fin 8) :
    warmRobinIntegerTarget row column =
      ∑ slot : Fin 5,
        if warmRobinFiveShiftPerm slot column = row then
          warmRobinFiveShiftWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

def warmRobinFiveShiftAmplitude (slot : Fin 5) (column : Fin 8) : Rat :=
  5 * warmRobinFiveShiftWeight slot column / 224

theorem warmRobinFiveShiftAmplitude_bounded (slot : Fin 5) (column : Fin 8) :
    |warmRobinFiveShiftAmplitude slot column| ≤ (5 / 7 : Rat) := by
  fin_cases slot <;> fin_cases column <;> native_decide

def warmRobinEightSlotPerm (slot : Fin 8) (column : Fin 8) : Fin 8 :=
  ⟨match slot.val with
    | 0 | 1 => column.val
    | 2 => (column.val + 7) % 8
    | 3 => (column.val + 1) % 8
    | 4 => (column.val + 6) % 8
    | 5 => (column.val + 2) % 8
    | 6 => match column.val with | 0 => 1 | 1 => 0 | 6 => 7 | 7 => 6 | x => x
    | _ => match column.val with | 0 => 2 | 2 => 0 | 5 => 7 | 7 => 5 | x => x,
   by fin_cases slot <;> fin_cases column <;> decide⟩

def warmRobinEightSlotWeight (slot : Fin 8) (column : Fin 8) : Int :=
  match slot.val with
  | 0 => -15
  | 1 => if column.val = 1 || column.val = 6 then -16 else -15
  | 2 => if column.val = 0 then 0 else 16
  | 3 => if column.val = 7 then 0 else 16
  | 4 => if column.val < 2 then 0 else -1
  | 5 => if column.val ≤ 5 then -1 else 0
  | 6 => if column.val = 1 || column.val = 6 then 16 else 0
  | _ => if column.val = 2 || column.val = 5 then -1 else 0

theorem warmRobinEightSlotDecomposition (row column : Fin 8) :
    warmRobinIntegerTarget row column =
      ∑ slot : Fin 8,
        if warmRobinEightSlotPerm slot column = row then
          warmRobinEightSlotWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

theorem warmRobinEightSlotPerm_bijective (slot : Fin 8) :
    Function.Bijective (warmRobinEightSlotPerm slot) := by
  fin_cases slot <;> decide

def warmRobinEightSlotAmplitude (slot : Fin 8) (column : Fin 8) : Rat :=
  warmRobinEightSlotWeight slot column / 28

theorem warmRobinEightSlotAmplitude_bounded (slot : Fin 8) (column : Fin 8) :
    |warmRobinEightSlotAmplitude slot column| ≤ (4 / 7 : Rat) := by
  fin_cases slot <;> fin_cases column <;> native_decide

end QuantumBlockEncoding.Robin
