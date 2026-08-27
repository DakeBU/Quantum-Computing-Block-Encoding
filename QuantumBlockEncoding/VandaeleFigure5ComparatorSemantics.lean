import QuantumBlockEncoding.VandaeleFigure4TakahashiStepSemantics
import Mathlib.Tactic

/-!
# Source-level audit of Vandaele Figure 5

Vandaele, arXiv:2603.12917v1, Figure 5 displays a three-slice ancilla-free
five-bit quantum--quantum comparator and labels its output

`|a⟩ |b⟩ |z⟩ ↦ |a⟩ |b⟩ |z XOR (a < b)⟩`.

The three red slices are transcribed directly from the source-grounded
Takahashi pieces behind Figure 4.  The proof is deliberately compositional:
the prefix reuses the existing Step-1/2/3 semantic theorems, and the suffix is
proved to preserve the `z` coordinate because none of its gates targets `z`.
No global truth table over function-valued eleven-wire states is evaluated.

A concrete basis-state theorem then refutes the printed `a < b` label: for
`a=1`, `b=0`, `z=0`, the displayed source program flips `z` to one although
`1 < 0` is false.  This is a machine-checkable source obstruction.  The
universal characterization of the flag as `b < a` remains the next proof-DAG
node.
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

/-- Figure-5 slice 1. -/
def slice1 : ReversibleProgram 11 :=
  complementB ++ step1 ++ step2

/-- Figure-5 slice 2. -/
def slice2 : ReversibleProgram 11 :=
  step3 ++ undoStep3Data

/-- Figure-5 slice 3. -/
def slice3 : ReversibleProgram 11 :=
  undoStep2Data ++ step1.reverse ++ complementB

/-- Prefix ending exactly after the outgoing-carry write of Step 3. -/
def carryPrefix : ReversibleProgram 11 :=
  complementB ++ step1 ++ step2 ++ step3

/-- Data-uncompute suffix.  No gate in this program targets wire `z = 10`. -/
def dataSuffix : ReversibleProgram 11 :=
  undoStep3Data ++ undoStep2Data ++ step1.reverse ++ complementB

/-- Exact three-slice five-bit gate list read from Figure 5. -/
def figure5Program : ReversibleProgram 11 :=
  carryPrefix ++ dataSuffix

/-- The red slices contain 13, 9, and 12 gates. -/
theorem figure5_sliceLengths :
    (slice1.length, slice2.length, slice3.length) = (13, 9, 12) := by
  native_decide

/-- The displayed Figure-5 transcription has 34 reversible gates in total. -/
theorem figure5_gateCount : figure5Program.length = 34 := by
  native_decide

/-- State after the initial bitwise complement of `b`. -/
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

/-- The Figure-5 prefix is exactly Figure-4 Steps 1--3 on the complemented
`b` input. -/
theorem carryPrefix_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram carryPrefix
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep3
        a0 (flipBit b0)
        a1 (flipBit b1)
        a2 (flipBit b2)
        a3 (flipBit b3)
        a4 (flipBit b4)
        z := by
  simp only [carryPrefix, evalReversibleProgram_append_apply_local]
  rw [complementB_semantics]
  rw [step1_semantics]
  rw [step2_semantics]
  rw [step3_semantics]

/-- Every gate in the data-uncompute suffix leaves the flag wire untouched. -/
theorem dataSuffix_preserves_z (state : SourceBasis) :
    zValue (evalReversibleProgram dataSuffix state) = zValue state := by
  simp [dataSuffix, undoStep3Data, undoStep2Data, step3, step2, step1,
    evalReversibleProgram, evalReversibleGate,
    xBasisEquiv, xBasisAction, cxBasisEquiv, cxBasisAction,
    ccxBasisEquiv, ccxBasisAction, zValue]

/-- Source-level flag semantics of Figure 5 before interpreting the carry as
an inequality. -/
theorem figure5_flag_is_complementedB_carry
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    zValue
        (evalReversibleProgram figure5Program
          (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z)) =
      (xorBit
        (c5 a0 (flipBit b0) a1 (flipBit b1) a2 (flipBit b2)
          a3 (flipBit b3) a4 (flipBit b4)) z).val := by
  rw [figure5Program, evalReversibleProgram_append_apply_local]
  rw [dataSuffix_preserves_z]
  rw [carryPrefix_semantics]
  rfl

/-- Smallest strict-direction witness in the certified little-endian layout:
`a=1`, `b=0`, `z=0`. -/
def directionWitness : SourceBasis :=
  sourceState 1 0 0 0 0 0 0 0 0 0 0

/-- The exact displayed source program flips the witness flag. -/
theorem figure5_directionWitness_flag :
    zValue (evalReversibleProgram figure5Program directionWitness) = 1 := by
  change
    zValue
        (evalReversibleProgram figure5Program
          (sourceState 1 0 0 0 0 0 0 0 0 0 0)) = 1
  rw [figure5_flag_is_complementedB_carry]
  native_decide

/-- Typed obstruction to the printed Figure-5 semantics `z XOR (a < b)`. -/
theorem figure5_direction_counterexample :
    aValue directionWitness = 1 ∧
      bValue directionWitness = 0 ∧
      zValue directionWitness = 0 ∧
      zValue (evalReversibleProgram figure5Program directionWitness) = 1 ∧
      ¬ aValue directionWitness < bValue directionWitness := by
  constructor
  · native_decide
  constructor
  · native_decide
  constructor
  · native_decide
  constructor
  · exact figure5_directionWitness_flag
  · native_decide

end VandaeleFigure5ComparatorSemantics
end QuantumBlockEncoding
