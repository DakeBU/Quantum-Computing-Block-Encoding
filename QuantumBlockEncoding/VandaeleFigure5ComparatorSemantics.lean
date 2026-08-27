import QuantumBlockEncoding.VandaeleFigure4TakahashiArithmeticSemantics
import Mathlib.Tactic

/-!
# Gate-level semantics of Vandaele Figure 5

Vandaele, arXiv:2603.12917v1, Figure 5 displays a three-slice ancilla-free
five-bit quantum--quantum comparator and labels its output

`|a⟩ |b⟩ |z⟩ ↦ |a⟩ |b⟩ |z XOR (a < b)⟩`.

We transcribe the three red slices directly from the already certified
Takahashi source pieces behind Figure 4.  The proof deliberately does not run a
single global truth table through the 34-gate evaluator.  Instead it reuses the
Step-1/2/3 refinement theorems and proves only the three short local uncompute
segments.  The final scalar comparison lemma is independent of the circuit
evaluator.

With the displayed wire order and the little-endian arithmetic convention
certified for Figure 4, the resulting program restores both data registers but
toggles the flag by `b < a`, not by `a < b`.  A concrete basis-state witness is
included so this source discrepancy is a typed obstruction rather than prose.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorSemantics

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure4TakahashiStepSemantics

/-- The five X gates drawn on the `b` register at both ends of Figure 5. -/
def complementB : ReversibleProgram 11 :=
  [ .x 1, .x 3, .x 5, .x 7, .x 9 ]

/-- The four data-targeting Toffolis of Step 3, run backwards. -/
def undoStep3Data : ReversibleProgram 11 :=
  (step3.take 4).reverse

/-- Step 2 without its first `A₄ -> z` CNOT, run backwards. -/
def undoStep2Data : ReversibleProgram 11 :=
  (step2.drop 1).reverse

/-- Figure-5 slice 1: complement `b`, then run the two Figure-4 prefix steps. -/
def slice1 : ReversibleProgram 11 :=
  complementB ++ step1 ++ step2

/-- Figure-5 slice 2 computes the carry, then uncomputes the four temporary
carry-workspace Toffolis while leaving the final write to `z` in place. -/
def slice2 : ReversibleProgram 11 :=
  step3 ++ undoStep3Data

/-- Figure-5 slice 3 restores the data-targeting part of Step 2 and Step 1,
then removes the initial complement of `b`. -/
def slice3 : ReversibleProgram 11 :=
  undoStep2Data ++ step1.reverse ++ complementB

/-- Exact three-slice five-bit program displayed in Figure 5. -/
def figure5Program : ReversibleProgram 11 :=
  slice1 ++ slice2 ++ slice3

/-- A computational-basis bit for a strict natural-number comparison. -/
def strictLtBit (left right : Nat) : Fin 2 :=
  if left < right then 1 else 0

/-- The three red slices contain 13, 9, and 12 gates, respectively. -/
theorem figure5_sliceLengths :
    (slice1.length, slice2.length, slice3.length) = (13, 9, 12) := by
  native_decide

/-- The displayed Figure-5 transcription contains exactly 34 reversible gates. -/
theorem figure5_gateCount : figure5Program.length = 34 := by
  native_decide

/-- State after the initial bitwise complement of the `b` register. -/
def afterComplementB
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 (flipBit b0)
    a1 (flipBit b1)
    a2 (flipBit b2)
    a3 (flipBit b3)
    a4 (flipBit b4)
    z

/-- The five displayed X gates are exactly bitwise complement on `b`. -/
theorem complementB_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram complementB
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterComplementB a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [complementB, evalReversibleProgram, evalReversibleGate,
      xBasisEquiv, xBasisAction, sourceState, afterComplementB]

/-- Data shape obtained after reversing the first four Step-3 Toffolis while
retaining the outgoing carry already written to `z`. -/
def afterUndoStep3Data
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit a1 b1)
    (xorBit a1 a2) (xorBit a2 b2)
    (xorBit a2 a3) (xorBit a3 b3)
    (xorBit a3 a4) (xorBit a4 b4)
    (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z)

/-- Local uncompute certificate for the four data-targeting Step-3 Toffolis. -/
theorem undoStep3Data_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram undoStep3Data
        (afterStep3 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterUndoStep3Data a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [undoStep3Data, step3, evalReversibleProgram,
      evalReversibleGate_ccx_eq_update, ccxUpdate,
      sourceState, afterStep3, afterUndoStep3Data,
      c2, c3, c4, c5, uncomputeCarry_reordered,
      leastCarry_uncompute_reordered, leastCarry_uncompute_targetFirst]

/-- Data shape after reversing the three data-targeting Step-2 CNOTs. -/
def afterUndoStep2Data
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit a1 b1)
    a2 (xorBit a2 b2)
    a3 (xorBit a3 b3)
    a4 (xorBit a4 b4)
    (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z)

/-- Local uncompute certificate for the data-targeting part of Step 2. -/
theorem undoStep2Data_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram undoStep2Data
        (afterUndoStep3Data a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterUndoStep2Data a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [undoStep2Data, step2, evalReversibleProgram,
      evalReversibleGate_cx_eq_update, cxUpdate,
      sourceState, afterUndoStep3Data, afterUndoStep2Data]

/-- Reversing Step 1 restores the current `b` bits without touching the carry
flag retained on `z`. -/
theorem undoStep1_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step1.reverse
        (afterUndoStep2Data a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z) := by
  funext wire
  fin_cases wire <;>
    simp [step1, evalReversibleProgram,
      evalReversibleGate_cx_eq_update, cxUpdate,
      sourceState, afterUndoStep2Data]

/-- Gate-level Figure-5 semantics before interpreting the complemented-input
carry as an inequality.  This proof is a composition of local semantic nodes,
not a global `2^11` circuit truth table. -/
theorem figure5Program_semantics_carry_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram figure5Program
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit
          (c5 a0 (flipBit b0) a1 (flipBit b1) a2 (flipBit b2)
            a3 (flipBit b3) a4 (flipBit b4)) z) := by
  simp only [figure5Program, slice1, slice2, slice3,
    evalReversibleProgram_append_apply_local]
  rw [complementB_semantics]
  rw [step1_semantics]
  rw [step2_semantics]
  rw [step3_semantics]
  rw [undoStep3Data_semantics]
  rw [undoStep2Data_semantics]
  rw [undoStep1_semantics]
  rw [complementB_semantics]
  simp [afterComplementB]

/-- The outgoing carry after complementing `b` is exactly the predicate
`b < a`.  This is a scalar ten-bit arithmetic check, independent of circuit
evaluation. -/
theorem complementedB_carry_eq_b_lt_a
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Fin 2) :
    c5 a0 (flipBit b0) a1 (flipBit b1) a2 (flipBit b2)
        a3 (flipBit b3) a4 (flipBit b4) =
      strictLtBit
        (fiveValue b0 b1 b2 b3 b4)
        (fiveValue a0 a1 a2 a3 a4) := by
  apply Fin.ext
  native_decide +revert

/-- Exact gate-level semantics on all eleven displayed basis bits: both data
registers are restored and `z` is toggled iff `b < a`. -/
theorem figure5Program_semantics_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram figure5Program
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit z
          (strictLtBit
            (fiveValue b0 b1 b2 b3 b4)
            (fiveValue a0 a1 a2 a3 a4))) := by
  rw [figure5Program_semantics_carry_bits]
  rw [complementedB_carry_eq_b_lt_a]
  simp [xorBit_comm]

/-- Smallest strict-direction witness: `a=1`, `b=0`, `z=0`. -/
def directionWitness : SourceBasis :=
  sourceState 1 0 0 0 0 0 0 0 0 0 0

/-- Typed obstruction to the Figure-5 label `z XOR (a < b)`.
For `a=1`, `b=0`, the displayed gate list toggles the flag even though
`a < b` is false. -/
theorem figure5_direction_counterexample :
    aValue directionWitness = 1 ∧
      bValue directionWitness = 0 ∧
      zValue directionWitness = 0 ∧
      zValue (evalReversibleProgram figure5Program directionWitness) = 1 ∧
      ¬ aValue directionWitness < bValue directionWitness := by
  native_decide

end VandaeleFigure5ComparatorSemantics
end QuantumBlockEncoding
