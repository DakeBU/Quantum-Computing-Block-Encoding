import QuantumBlockEncoding.VandaeleFigure5ComparatorRepair
import Mathlib.Tactic

/-!
# Full reversible semantics of Vandaele Figure 5 and its minimal repair

The previous Figure-5 nodes deliberately separated two questions:

1. what predicate is written to the flag; and
2. whether the ten data wires are restored exactly.

The first question is closed: the displayed source toggles `z` by `b < a`, and
moving only the endpoint complement layers from `b` to `a` toggles it by the
printed target predicate `a < b`.

This file closes the second question compositionally.  The internal data
uncompute is proved once for an *arbitrary* flag value.  Starting from the
Step-3 carry workspace, the four reversed data Toffolis remove the carry
workspace, the three reversed Step-2 CNOTs restore the `a` register, and the
reversed Step-1 CNOTs restore the `b` register.  No theorem depends on the
actual value stored in `z`.

The shared theorem is then used twice:

* the original Figure-5 endpoint `B` complements restore the displayed data and
  leave the already certified flag `b < a`;
* the repaired endpoint `A` complements restore the displayed data and leave
  the already certified flag `a < b`.

Thus the repaired 34-gate source becomes a fully certified computational-basis
comparator, not merely a flag-level repair.  No global 2^11-state truth table
is evaluated.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorFullSemantics

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure4TakahashiStepSemantics
open VandaeleFigure5ComparatorSemantics
open VandaeleFigure5ComparatorDirection
open VandaeleFigure5ComparatorRepair

/-- Step-3 data workspace with an abstract flag.  This is `afterStep3` with the
outgoing-carry value on wire `z` deliberately forgotten. -/
def carryDataState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    (xorBit (c1 a0 b0) a1) (xorBit a1 b1)
    (xorBit (c2 a0 b0 a1 b1) a2) (xorBit a2 b2)
    (xorBit (c3 a0 b0 a1 b1 a2 b2) a3) (xorBit a3 b3)
    (xorBit (c4 a0 b0 a1 b1 a2 b2 a3 b3) a4) (xorBit a4 b4)
    flag

/-- Data state after the four carry-workspace Toffolis have been undone. -/
def prefixDataState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit a1 b1)
    (xorBit a1 a2) (xorBit a2 b2)
    (xorBit a2 a3) (xorBit a3 b3)
    (xorBit a3 a4) (xorBit a4 b4)
    flag

/-- Data state after the reversed Step-2 ladder restores every `a` wire. -/
def preSumDataState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit a1 b1)
    a2 (xorBit a2 b2)
    a3 (xorBit a3 b3)
    a4 (xorBit a4 b4)
    flag

/-- Existing Step-3 semantics factors through `carryDataState`; the carry flag
is merely a parameter to the data-uncompute theorem below. -/
theorem afterStep3_eq_carryDataState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    afterStep3 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z =
      carryDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z) := by
  rfl

/-- Reversing the first four Step-3 Toffolis removes only the carry workspace.
The flag is arbitrary and is carried through unchanged. -/
theorem undoStep3Data_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) :
    evalReversibleProgram undoStep3Data
        (carryDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag) =
      prefixDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag := by
  funext wire
  fin_cases wire <;>
    simp [undoStep3Data, step3, evalReversibleProgram,
      evalReversibleGate_ccx_eq_update, ccxUpdate,
      carryDataState, prefixDataState, sourceState,
      c2, c3, c4, uncomputeCarry_reordered,
      leastCarry_uncompute_targetFirst]

/-- Reversing the data-targeting part of Step 2 restores the higher `a` wires. -/
theorem undoStep2Data_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) :
    evalReversibleProgram undoStep2Data
        (prefixDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag) =
      preSumDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag := by
  funext wire
  fin_cases wire <;>
    simp [undoStep2Data, step2, evalReversibleProgram,
      evalReversibleGate_cx_eq_update, cxUpdate,
      prefixDataState, preSumDataState, sourceState]

/-- Reversing Step 1 removes the four pre-sum CNOTs and restores `b`. -/
theorem reverseStep1_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) :
    evalReversibleProgram step1.reverse
        (preSumDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag := by
  funext wire
  fin_cases wire <;>
    simp [step1, evalReversibleProgram,
      evalReversibleGate_cx_eq_update, cxUpdate,
      preSumDataState, sourceState]

/-- The internal Figure-5 data suffix, before the final endpoint complement. -/
def internalDataSuffix : ReversibleProgram 11 :=
  undoStep3Data ++ undoStep2Data ++ step1.reverse

/-- Shared data-restoration theorem.  It is independent of the comparison flag
and therefore applies unchanged to both the displayed and repaired circuits. -/
theorem internalDataSuffix_restores
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) :
    evalReversibleProgram internalDataSuffix
        (carryDataState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag := by
  simp only [internalDataSuffix, evalReversibleProgram_append_apply_local]
  rw [undoStep3Data_semantics, undoStep2Data_semantics, reverseStep1_semantics]

/-- The original Figure-5 suffix restores data that entered the carry workspace
with `b` complemented, then removes that complement. -/
theorem dataSuffix_restores_original_data
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) :
    evalReversibleProgram dataSuffix
        (carryDataState
          a0 (flipBit b0)
          a1 (flipBit b1)
          a2 (flipBit b2)
          a3 (flipBit b3)
          a4 (flipBit b4)
          flag) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag := by
  simp only [dataSuffix, evalReversibleProgram_append_apply_local]
  rw [undoStep3Data_semantics, undoStep2Data_semantics, reverseStep1_semantics]
  rw [complementB_semantics]
  simp [afterComplementB]

/-- The repaired suffix analogously restores data that entered with `a`
complemented, then removes that complement. -/
theorem repairedDataSuffix_restores_data
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag : Fin 2) :
    evalReversibleProgram repairedDataSuffix
        (carryDataState
          (flipBit a0) b0
          (flipBit a1) b1
          (flipBit a2) b2
          (flipBit a3) b3
          (flipBit a4) b4
          flag) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 flag := by
  simp only [repairedDataSuffix, evalReversibleProgram_append_apply_local]
  rw [undoStep3Data_semantics, undoStep2Data_semantics, reverseStep1_semantics]
  rw [complementA_semantics]
  simp [afterComplementA]

/-- Full computational-basis semantics of the *displayed* Figure-5 source.
Both data registers are restored exactly, but the flag predicate is `b < a`. -/
theorem figure5Program_full_semantics_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram figure5Program
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit z
          (strictLtBit
            (fiveValue b0 b1 b2 b3 b4)
            (fiveValue a0 a1 a2 a3 a4))) := by
  rw [figure5Program, evalReversibleProgram_append_apply_local]
  rw [carryPrefix_semantics]
  rw [afterStep3_eq_carryDataState]
  rw [dataSuffix_restores_original_data]
  rw [complementedB_c5_eq_strictLtBit]
  rw [xorBit_comm]

/-- Full arbitrary-state semantics of the displayed Figure-5 source. -/
theorem figure5Program_full_semantics (state : SourceBasis) :
    evalReversibleProgram figure5Program state =
      sourceState
        (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
        (state 6) (state 7) (state 8) (state 9)
        (xorBit (state 10) (strictLtBit (bValue state) (aValue state))) := by
  have bits := figure5Program_full_semantics_bits
    (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
    (state 6) (state 7) (state 8) (state 9) (state 10)
  rw [sourceState_eta state] at bits
  simpa only [aValue, bValue, fiveValue] using bits

/-- Full computational-basis semantics of the minimal repaired source.
The ten data wires are restored and the flag now matches the printed target
predicate `a < b`. -/
theorem repairedFigure5_full_semantics_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram repairedFigure5Program
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit z
          (strictLtBit
            (fiveValue a0 a1 a2 a3 a4)
            (fiveValue b0 b1 b2 b3 b4))) := by
  rw [repairedFigure5Program, evalReversibleProgram_append_apply_local]
  rw [repairedCarryPrefix_semantics]
  rw [afterStep3_eq_carryDataState]
  rw [repairedDataSuffix_restores_data]
  rw [complementedA_c5_eq_strictLtBit]
  rw [xorBit_comm]

/-- Reader-facing full comparator certificate for the 34-gate repaired source. -/
theorem repairedFigure5_full_semantics (state : SourceBasis) :
    evalReversibleProgram repairedFigure5Program state =
      sourceState
        (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
        (state 6) (state 7) (state 8) (state 9)
        (xorBit (state 10) (strictLtBit (aValue state) (bValue state))) := by
  have bits := repairedFigure5_full_semantics_bits
    (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
    (state 6) (state 7) (state 8) (state 9) (state 10)
  rw [sourceState_eta state] at bits
  simpa only [aValue, bValue, fiveValue] using bits

/-- The displayed Figure-5 source preserves the numeric `a` register. -/
theorem figure5Program_preserves_a (state : SourceBasis) :
    aValue (evalReversibleProgram figure5Program state) = aValue state := by
  rw [figure5Program_full_semantics]
  simp [aValue, sourceState]

/-- The displayed Figure-5 source preserves the numeric `b` register. -/
theorem figure5Program_preserves_b (state : SourceBasis) :
    bValue (evalReversibleProgram figure5Program state) = bValue state := by
  rw [figure5Program_full_semantics]
  simp [bValue, sourceState]

/-- The repaired source preserves the numeric `a` register. -/
theorem repairedFigure5_preserves_a (state : SourceBasis) :
    aValue (evalReversibleProgram repairedFigure5Program state) = aValue state := by
  rw [repairedFigure5_full_semantics]
  simp [aValue, sourceState]

/-- The repaired source preserves the numeric `b` register. -/
theorem repairedFigure5_preserves_b (state : SourceBasis) :
    bValue (evalReversibleProgram repairedFigure5Program state) = bValue state := by
  rw [repairedFigure5_full_semantics]
  simp [bValue, sourceState]

end VandaeleFigure5ComparatorFullSemantics
end QuantumBlockEncoding
