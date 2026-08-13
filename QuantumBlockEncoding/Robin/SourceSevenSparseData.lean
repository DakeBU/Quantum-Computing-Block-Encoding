import QuantumBlockEncoding.Robin.EvolvedCandidates
import Mathlib.Tactic

/-!
# True padded-seven sparse source data for the fixed Robin benchmark

The physical selector is `Fin 8`. Slots zero through six are active and slot
seven pads the five genuine diagonals to the paper's `kappa = 7` interface.
Unlike the historical split-seven structural LCU, the position maps here are
pairwise distinct at every column.
-/

namespace QuantumBlockEncoding.Robin

/-- The source `D^T` offset ordering, expressed in the physical selector. -/
def warmRobinSourceDTOffset (slot : Fin 8) : Fin 8 :=
  ⟨(slot.val ^^^ 3) % 8, Nat.mod_lt _ (by decide)⟩

theorem warmRobinSourceDTOffset_table :
    List.ofFn warmRobinSourceDTOffset = [3, 2, 1, 0, 7, 6, 5, 4] := by
  native_decide

/-- Sparse row addressed by one physical slot at a fixed source column. -/
def warmRobinSourceDTRow (slot column : Fin 8) : Fin 8 :=
  ⟨(column.val + (warmRobinSourceDTOffset slot).val) % 8,
    Nat.mod_lt _ (by decide)⟩

/-- Exact integer value returned by the source sparse-value oracle. -/
def warmRobinSourceSevenWeight (slot column : Fin 8) : Int :=
  warmRobinIntegerTarget (warmRobinSourceDTRow slot column) column

/-- Slot seven is the zero diagonal used only for physical padding. -/
theorem warmRobinSourceSevenWeight_slot7_zero (column : Fin 8) :
    warmRobinSourceSevenWeight 7 column = 0 := by
  fin_cases column <;> native_decide

/-- At a fixed column, the eight physical slots enumerate eight distinct rows. -/
theorem warmRobinSourceDTRow_bijective_in_slot (column : Fin 8) :
    Function.Bijective (fun slot : Fin 8 => warmRobinSourceDTRow slot column) := by
  native_decide +revert

/-- At a fixed slot, cyclic sparse access is a permutation of the columns. -/
theorem warmRobinSourceDTRow_bijective_in_column (slot : Fin 8) :
    Function.Bijective (fun column : Fin 8 => warmRobinSourceDTRow slot column) := by
  native_decide +revert

/-- Exact sparse-access decomposition with seven active physical states. -/
theorem warmRobinSourceSevenSparseDecomposition (row column : Fin 8) :
    warmRobinIntegerTarget row column =
      ∑ slot : Fin 8,
        if slot.val < 7 ∧ warmRobinSourceDTRow slot column = row then
          warmRobinSourceSevenWeight slot column
        else 0 := by
  fin_cases row <;> fin_cases column <;> native_decide

def warmRobinSourceND : Rat := 8 / 3
def warmRobinSourceNf : Rat := 1
def warmRobinSourceKappa : Rat := 7

theorem warmRobinSourceAmplitude_eq_integer_div_32 (row column : Fin 8) :
    ((warmRobinIntegerTarget row column : Rat) / 12) /
        warmRobinSourceND =
      (warmRobinIntegerTarget row column : Rat) / 32 := by
  norm_num [warmRobinSourceND]
  ring

theorem warmRobinSourceAlpha_eq :
    warmRobinSourceND * warmRobinSourceNf * warmRobinSourceKappa = 56 / 3 := by
  norm_num [warmRobinSourceND, warmRobinSourceNf, warmRobinSourceKappa]

/-- Selector probability in the clean column of padded-seven PREPARE. -/
def warmRobinSourceSevenSelectorProbability (slot : Fin 8) : Rat :=
  if slot.val < 7 then 1 / 7 else 0

/-- Coefficient loaded by an active sparse slot. The padded slot is assigned
the identity coefficient because its clean PREPARE probability is zero. -/
def warmRobinSourceSevenPaddedCoefficient (slot column : Fin 8) : Rat :=
  if slot.val < 7 then warmRobinSourceSevenWeight slot column / 32 else 1

def warmRobinSourceSevenCleanFormula : Matrix 8 8 Rat := fun row column =>
  ∑ slot : Fin 8,
    if warmRobinSourceDTRow slot column = row then
      warmRobinSourceSevenSelectorProbability slot *
        warmRobinSourceSevenPaddedCoefficient slot column
    else 0

theorem warmRobinSourceSevenCleanFormula_eq_integer_div_224
    (row column : Fin 8) :
    warmRobinSourceSevenCleanFormula row column =
      warmRobinIntegerTargetRat row column / 224 := by
  fin_cases row <;> fin_cases column <;> native_decide

theorem warmRobinSourceSevenCleanFormula_eq_target (row column : Fin 8) :
    warmRobinSourceSevenCleanFormula row column =
      RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer := by
  rw [warmRobinSourceSevenCleanFormula_eq_integer_div_224]
  symm
  exact congrFun (congrFun warmRobin_normalized_eq_integer_div_224 row) column

end QuantumBlockEncoding.Robin
