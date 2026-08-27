import QuantumBlockEncoding.VandaeleFigure4TakahashiArithmeticSemantics
import Mathlib.Tactic

/-!
# Gate-level semantics of Vandaele Figure 5

Vandaele, arXiv:2603.12917v1, Figure 5 displays a three-slice ancilla-free
five-bit quantum--quantum comparator and labels its output

`|a⟩ |b⟩ |z⟩ ↦ |a⟩ |b⟩ |z XOR (a < b)⟩`.

The displayed circuit is built directly from the Takahashi adder of Figure 4.
This file transcribes the three red slices using the already certified source
pieces, without re-proving the 29-gate adder:

* slice 1 complements all `B` wires, then applies source Steps 1 and 2;
* slice 2 applies source Step 3, then reverses its first four data-targeting
  Toffolis while deliberately leaving the final carry write to `z` in place;
* slice 3 reverses the three data-targeting gates of source Step 2, reverses
  Step 1, and complements all `B` wires again.

The resulting 34-gate program restores both data registers exactly.  Lean then
checks the strict-comparison direction on all computational-basis inputs.  The
important result is source-level rather than interpretive: with the displayed
wire order and the little-endian arithmetic already certified for Figure 4,
the flag is toggled by `b < a`, not by `a < b`.  A concrete basis-state witness
is included below so that the discrepancy with the Figure-5 label is a typed
obstruction rather than a prose warning.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorSemantics

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure4TakahashiStepSemantics

/-- The five X gates drawn on the `b` register at both ends of Figure 5. -/
def complementB : ReversibleProgram 11 :=
  [ .x 1, .x 3, .x 5, .x 7, .x 9 ]

/-- Figure-5 slice 1: complement `b`, then run the two Figure-4 prefix steps. -/
def slice1 : ReversibleProgram 11 :=
  complementB ++ step1 ++ step2

/-- Figure-5 slice 2: compute the outgoing carry and uncompute the four
carry-workspace Toffolis.  `step3` has five Toffolis; the fifth targets `z` and
is intentionally not undone. -/
def slice2 : ReversibleProgram 11 :=
  step3 ++ (step3.take 4).reverse

/-- Figure-5 slice 3 restores the data-targeting part of Step 2 and all of
Step 1, then removes the initial bitwise complement of `b`.  The first gate of
`step2` targets `z`, so only `step2.drop 1` is undone. -/
def slice3 : ReversibleProgram 11 :=
  (step2.drop 1).reverse ++ step1.reverse ++ complementB

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

/-- Exact gate-level semantics on the eleven displayed basis bits.

The data bits are restored, while `z` is toggled iff the numeric value of `b`
is strictly smaller than the numeric value of `a`.
-/
theorem figure5Program_semantics_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram figure5Program
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4
        (xorBit z
          (strictLtBit
            (fiveValue b0 b1 b2 b3 b4)
            (fiveValue a0 a1 a2 a3 a4))) := by
  funext wire
  fin_cases wire <;> native_decide +revert

/-- Arbitrary-state form of the Figure-5 semantics. -/
theorem figure5Program_semantics (state : SourceBasis) :
    evalReversibleProgram figure5Program state =
      sourceState
        (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
        (state 6) (state 7) (state 8) (state 9)
        (xorBit (state 10) (strictLtBit (bValue state) (aValue state))) := by
  rw [← sourceState_eta state]
  simpa [aValue, bValue, fiveValue, sourceState] using
    figure5Program_semantics_bits
      (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
      (state 6) (state 7) (state 8) (state 9) (state 10)

/-- Figure 5 preserves the numeric `a` register. -/
theorem figure5Program_preserves_a (state : SourceBasis) :
    aValue (evalReversibleProgram figure5Program state) = aValue state := by
  rw [figure5Program_semantics]
  simp [aValue, sourceState]

/-- Figure 5 preserves the numeric `b` register. -/
theorem figure5Program_preserves_b (state : SourceBasis) :
    bValue (evalReversibleProgram figure5Program state) = bValue state := by
  rw [figure5Program_semantics]
  simp [bValue, sourceState]

/-- The machine-checked flag direction of the displayed Figure-5 gate list. -/
theorem figure5Program_toggles_b_lt_a (state : SourceBasis) :
    zValue (evalReversibleProgram figure5Program state) =
      (zValue state + (strictLtBit (bValue state) (aValue state)).val) % 2 := by
  rw [figure5Program_semantics]
  simp [zValue, sourceState, xorBit_value]

/-- Smallest strict-direction witness: `a=1`, `b=0`, `z=0`.
The displayed circuit toggles the flag although `a < b` is false. -/
def directionWitness : SourceBasis :=
  sourceState 1 0 0 0 0 0 0 0 0 0 0

/-- Typed obstruction to the Figure-5 label `z XOR (a < b)`.

For the concrete input `a=1`, `b=0`, the gate list outputs flag `1`, while
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
