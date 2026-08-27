import QuantumBlockEncoding.VandaeleFigure4TakahashiSourceProgram
import Mathlib.Tactic

/-!
# Source-level audit of Vandaele Figure 5

Vandaele, arXiv:2603.12917v1, Figure 5 displays a three-slice ancilla-free
five-bit quantum--quantum comparator and labels its output

`|a⟩ |b⟩ |z⟩ ↦ |a⟩ |b⟩ |z XOR (a < b)⟩`.

This file isolates the source question before attempting a larger semantic
proof.  The three red slices are transcribed directly from the already
source-grounded Takahashi Figure-4 pieces:

* slice 1: complement all `B` wires, then source Steps 1 and 2;
* slice 2: source Step 3, then reverse its first four data-targeting Toffolis;
* slice 3: reverse the three data-targeting gates of Step 2, reverse Step 1,
  then complement all `B` wires again.

The resulting displayed program contains 34 reversible gates.  A concrete Lean
basis-state calculation below is sufficient to refute the printed `a < b`
label: on `a=1`, `b=0`, `z=0`, the program flips the flag wire to one.  Since
`1 < 0` is false, the discrepancy is a machine-checkable source obstruction.

Only the output flag coordinate is evaluated here.  This is intentional: the
repository represents basis states as functions, and asking `native_decide` to
compare whole function-valued eleven-wire states turns a tiny source audit into
an unnecessarily expensive global evaluator.  Universal semantics and data
restoration remain separate proof-DAG nodes.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorSemantics

open VandaeleFigure4TakahashiSourceProgram

/-- The five X gates drawn on the `b` register at both ends of Figure 5. -/
def complementB : ReversibleProgram 11 :=
  [ .x 1, .x 3, .x 5, .x 7, .x 9 ]

/-- The four data-targeting Toffolis of Step 3, run backwards.  The fifth
Toffoli of Step 3 targets `z` and is intentionally not undone. -/
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

/-- Exact three-slice five-bit gate list read from Figure 5. -/
def figure5Program : ReversibleProgram 11 :=
  slice1 ++ slice2 ++ slice3

/-- The red slices contain 13, 9, and 12 gates. -/
theorem figure5_sliceLengths :
    (slice1.length, slice2.length, slice3.length) = (13, 9, 12) := by
  native_decide

/-- The displayed Figure-5 transcription has 34 reversible gates in total. -/
theorem figure5_gateCount : figure5Program.length = 34 := by
  native_decide

/-- Smallest strict-direction witness in the certified little-endian layout:
`a=1`, `b=0`, `z=0`. -/
def directionWitness : SourceBasis :=
  sourceState 1 0 0 0 0 0 0 0 0 0 0

/-- Direct gate-level evaluation of only the output flag coordinate for the
witness.  Restricting to one coordinate avoids whole-function equality. -/
theorem figure5_directionWitness_flag :
    zValue (evalReversibleProgram figure5Program directionWitness) = 1 := by
  native_decide

/-- Typed obstruction to the printed Figure-5 semantics `z XOR (a < b)`.
The exact displayed gate list flips the flag on `a=1`, `b=0`, although
`a < b` is false. -/
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
