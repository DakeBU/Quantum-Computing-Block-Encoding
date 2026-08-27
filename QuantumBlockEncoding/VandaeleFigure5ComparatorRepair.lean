import QuantumBlockEncoding.VandaeleFigure5ComparatorDirection
import Mathlib.Tactic

/-!
# Minimal flag-level repair of Vandaele Figure 5

The certified Figure-5 source toggles `z` by `b < a`, while the printed target
semantics is `a < b`.  The direction theorem explains why: Figure 5 complements
`b` and therefore tests the carry of `a + (31 - b)`.

This file formalizes the smallest symmetric source repair suggested by that
arithmetic diagnosis.  The Takahashi carry-compute / data-uncompute skeleton is
left unchanged; only the five X gates at each endpoint are moved from the `b`
register to the `a` register.  Thus the carry becomes the outgoing carry of

`(31 - a) + b`,

which is exactly `[a < b]` for five-bit unsigned values.

The node certifies the exact 34-gate repaired source and its universal flag
semantics.  It intentionally does not yet claim whole-state comparator
correctness: exact restoration of both data registers is a separate reversible
source-refinement node.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorRepair

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure4TakahashiStepSemantics
open VandaeleFigure5ComparatorSemantics
open VandaeleFigure5ComparatorDirection

/-- Minimal endpoint change: complement the five `a` wires instead of `b`. -/
def complementA : ReversibleProgram 11 :=
  [ .x 0, .x 2, .x 4, .x 6, .x 8 ]

/-- Repaired prefix: compute the same Takahashi carry on `(NOT a, b)`. -/
def repairedCarryPrefix : ReversibleProgram 11 :=
  complementA ++ step1 ++ step2 ++ step3

/-- Repaired data-uncompute suffix.  Only the final endpoint complement changes
from Figure 5; all internal uncompute gates are identical. -/
def repairedDataSuffix : ReversibleProgram 11 :=
  undoStep3Data ++ undoStep2Data ++ step1.reverse ++ complementA

/-- Exact 34-gate source obtained by the endpoint complement swap. -/
def repairedFigure5Program : ReversibleProgram 11 :=
  repairedCarryPrefix ++ repairedDataSuffix

/-- The minimal flag repair has the same gate count as the displayed circuit. -/
theorem repairedFigure5_gateCount : repairedFigure5Program.length = 34 := by
  native_decide

/-- State after the repaired initial endpoint complement. -/
def afterComplementA
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    (flipBit a0) b0
    (flipBit a1) b1
    (flipBit a2) b2
    (flipBit a3) b3
    (flipBit a4) b4
    z

/-- The repaired endpoint X layer is exactly bitwise complement on `a`. -/
theorem complementA_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram complementA
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterComplementA a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [complementA, evalReversibleProgram, evalReversibleGate,
      xBasisEquiv, xBasisAction, sourceState, afterComplementA]

/-- The repaired carry prefix is Figure-4 Steps 1--3 on `(NOT a,b)`. -/
theorem repairedCarryPrefix_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram repairedCarryPrefix
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep3
        (flipBit a0) b0
        (flipBit a1) b1
        (flipBit a2) b2
        (flipBit a3) b3
        (flipBit a4) b4
        z := by
  simp only [repairedCarryPrefix, evalReversibleProgram_append_apply_local]
  rw [complementA_semantics]
  change
    evalReversibleProgram step3
        (evalReversibleProgram step2
          (evalReversibleProgram step1
            (sourceState
              (flipBit a0) b0
              (flipBit a1) b1
              (flipBit a2) b2
              (flipBit a3) b3
              (flipBit a4) b4
              z))) =
      afterStep3
        (flipBit a0) b0
        (flipBit a1) b1
        (flipBit a2) b2
        (flipBit a3) b3
        (flipBit a4) b4
        z
  rw [step1_semantics, step2_semantics, step3_semantics]

/-- The repaired uncompute suffix still contains no gate targeting `z`. -/
theorem repairedDataSuffix_avoids_z :
    programAvoidsTarget (10 : Fin 11) repairedDataSuffix := by
  simp [programAvoidsTarget, repairedDataSuffix, undoStep3Data, undoStep2Data,
    step3, step2, step1, complementA, reversibleGateTarget]

/-- Consequently the repaired suffix preserves the comparison flag. -/
theorem repairedDataSuffix_preserves_z (state : SourceBasis) :
    zValue (evalReversibleProgram repairedDataSuffix state) = zValue state := by
  unfold zValue
  rw [evalReversibleProgram_preserves_wire_of_avoidsTarget
    (wire := (10 : Fin 11)) (program := repairedDataSuffix)
    (state := state) repairedDataSuffix_avoids_z]

/-- Gate/source-level flag theorem before interpreting the repaired carry. -/
theorem repairedFigure5_flag_is_complementedA_carry
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    zValue
        (evalReversibleProgram repairedFigure5Program
          (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z)) =
      (xorBit
        (c5 (flipBit a0) b0
          (flipBit a1) b1
          (flipBit a2) b2
          (flipBit a3) b3
          (flipBit a4) b4)
        z).val := by
  rw [repairedFigure5Program, evalReversibleProgram_append_apply_local]
  rw [repairedDataSuffix_preserves_z]
  rw [repairedCarryPrefix_semantics]
  rfl

/-- Complementing `a` instead of `b` reverses the comparison direction of the
outgoing Figure-4 carry. -/
theorem complementedA_c5_eq_strictLtBit
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Fin 2) :
    c5 (flipBit a0) b0
        (flipBit a1) b1
        (flipBit a2) b2
        (flipBit a3) b3
        (flipBit a4) b4 =
      strictLtBit
        (fiveValue a0 a1 a2 a3 a4)
        (fiveValue b0 b1 b2 b3 b4) := by
  apply Fin.ext
  have carry :
      (c5 (flipBit a0) b0
          (flipBit a1) b1
          (flipBit a2) b2
          (flipBit a3) b3
          (flipBit a4) b4).val =
        (fiveValue (flipBit a0) (flipBit a1) (flipBit a2)
            (flipBit a3) (flipBit a4) +
          fiveValue b0 b1 b2 b3 b4) / 32 := by
    exact (fiveBit_arithmetic_certificate
      (flipBit a0) b0
      (flipBit a1) b1
      (flipBit a2) b2
      (flipBit a3) b3
      (flipBit a4) b4).2
  rw [fiveValue_flipBits] at carry
  rw [carry, strictLtBit_value]
  simpa [Nat.add_comm] using
    complementedNat_carry_eq_ltBit
      (fiveValue b0 b1 b2 b3 b4)
      (fiveValue a0 a1 a2 a3 a4)
      (fiveValue_lt_32 b0 b1 b2 b3 b4)
      (fiveValue_lt_32 a0 a1 a2 a3 a4)

/-- Universal repaired flag theorem on the eleven explicitly displayed bits. -/
theorem repairedFigure5_toggles_a_lt_b_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    zValue
        (evalReversibleProgram repairedFigure5Program
          (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z)) =
      (xorBit z
        (strictLtBit
          (fiveValue a0 a1 a2 a3 a4)
          (fiveValue b0 b1 b2 b3 b4))).val := by
  rw [repairedFigure5_flag_is_complementedA_carry]
  rw [complementedA_c5_eq_strictLtBit]
  rw [xorBit_comm]

/-- Reader-facing arbitrary-state repaired flag theorem. -/
theorem repairedFigure5_toggles_a_lt_b (state : SourceBasis) :
    zValue (evalReversibleProgram repairedFigure5Program state) =
      (zValue state + (strictLtBit (aValue state) (bValue state)).val) % 2 := by
  have bits := repairedFigure5_toggles_a_lt_b_bits
    (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
    (state 6) (state 7) (state 8) (state 9) (state 10)
  rw [sourceState_eta state] at bits
  simpa only [aValue, bValue, zValue, fiveValue, xorBit_value] using bits

end VandaeleFigure5ComparatorRepair
end QuantumBlockEncoding
