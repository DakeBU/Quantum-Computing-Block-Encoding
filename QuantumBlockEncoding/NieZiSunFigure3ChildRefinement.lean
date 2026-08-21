import QuantumBlockEncoding.NieZiSunFigure3FlatCoordinates
import QuantumBlockEncoding.NieZiSunFigure3LocalStepRefinement
import QuantumBlockEncoding.ReversibleDisjointEmbedding
import Mathlib.Tactic

/-!
# Child-program refinement for Nie--Zi--Sun Figure 3

The only recursive part of source Step 2 consists of two first-half circuits on
disjoint physical registers.  This module proves a generic composition lemma:
if each child flat program refines its `HalfComputation`, then the actual

`head X ; embedded-left ; embedded-right`

sequence refines the abstract source `step2`.  The proof uses the shared
disjoint-embedding semantics, so the two children cannot silently corrupt each
other's work/target wires.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3ChildRefinement

open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3LocalStepRefinement
open NieZiSunFigure3Protocol
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram
open ReversibleDisjointEmbedding
open ReversibleWireEmbedding

/-- One flat child program implements one abstract recursive first half. -/
def ChildRefines (width : Nat)
    (program : ReversibleProgram (width + 2))
    (half : HalfComputation width) : Prop :=
  ∀ state,
    flatProductCoordinate width (evalReversibleProgram program state) =
      half.forward (flatProductCoordinate width state)

/-- Embedded left/right child lists are disjoint on the parent register. -/
theorem mappedChildren_disjoint
    (n : Nat) (large : 5 <= n) :
    DisjointImages (leftEmbed n large) (rightEmbed n large) :=
  NieZiSunFigure3FlatCoordinates.childEmbeddings_disjoint n large

/-- After the four head-X gates, the physical left child register contains
exactly `(leftTail,I2,I1)` of the abstract Step-2 input. -/
theorem left_child_input_after_headX
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatProductCoordinate (leftTailWidth n)
      (readEmbeddedState (leftEmbed n large)
        (evalReversibleProgram (headXProgram n large) state)) =
      let before := flatFigure3Coordinate n large state
      (before.2.1,(flipHead before.1) 1,(flipHead before.1) 0) := by
  have head := headX_refines n large state
  have coords := coordinate_read_leftEmbed n large
    (evalReversibleProgram (headXProgram n large) state)
  rw [head] at coords
  simpa using coords

/-- Right-child analogue. -/
theorem right_child_input_after_headX
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatProductCoordinate (rightTailWidth n)
      (readEmbeddedState (rightEmbed n large)
        (evalReversibleProgram (headXProgram n large) state)) =
      let before := flatFigure3Coordinate n large state
      (before.2.2.1,(flipHead before.1) 3,(flipHead before.1) 2) := by
  have head := headX_refines n large state
  have coords := coordinate_read_rightEmbed n large
    (evalReversibleProgram (headXProgram n large) state)
  rw [head] at coords
  simpa using coords

/-- Complete actual Step-2 gate sequence. -/
def actualStep2Program
    (n : Nat) (large : 5 <= n)
    (leftProgram : ReversibleProgram (leftTailWidth n + 2))
    (rightProgram : ReversibleProgram (rightTailWidth n + 2)) :
    ReversibleProgram (totalWidth n) :=
  headXProgram n large ++
    mapProgramWires (leftEmbed n large) (leftEmbed_injective n large)
      leftProgram ++
    mapProgramWires (rightEmbed n large) (rightEmbed_injective n large)
      rightProgram

/-- Main generic Step-2 refinement theorem. -/
theorem actualStep2_refines
    (n : Nat) (large : 5 <= n)
    (leftProgram : ReversibleProgram (leftTailWidth n + 2))
    (rightProgram : ReversibleProgram (rightTailWidth n + 2))
    (leftHalf : HalfComputation (leftTailWidth n))
    (rightHalf : HalfComputation (rightTailWidth n))
    (leftCorrect : ChildRefines (leftTailWidth n) leftProgram leftHalf)
    (rightCorrect : ChildRefines (rightTailWidth n) rightProgram rightHalf)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram
        (actualStep2Program n large leftProgram rightProgram) state) =
      step2 leftHalf rightHalf (flatFigure3Coordinate n large state) := by
  let afterHead := evalReversibleProgram (headXProgram n large) state
  let leftMapped := mapProgramWires
    (leftEmbed n large) (leftEmbed_injective n large) leftProgram
  let rightMapped := mapProgramWires
    (rightEmbed n large) (rightEmbed_injective n large) rightProgram
  let afterChildren := evalReversibleProgram (leftMapped ++ rightMapped) afterHead
  have headCoords := headX_refines n large state
  have leftView := read_left_after_both
    (leftEmbed n large) (leftEmbed_injective n large)
    (rightEmbed n large) (rightEmbed_injective n large)
    (mappedChildren_disjoint n large)
    leftProgram rightProgram afterHead
  have rightView := read_right_after_both
    (leftEmbed n large) (leftEmbed_injective n large)
    (rightEmbed n large) (rightEmbed_injective n large)
    (mappedChildren_disjoint n large)
    leftProgram rightProgram afterHead
  have leftLocal := congrArg (flatProductCoordinate (leftTailWidth n)) leftView
  have rightLocal := congrArg (flatProductCoordinate (rightTailWidth n)) rightView
  rw [leftCorrect] at leftLocal
  rw [rightCorrect] at rightLocal
  have leftInput := left_child_input_after_headX n large state
  have rightInput := right_child_input_after_headX n large state
  rw [leftInput] at leftLocal
  rw [rightInput] at rightLocal
  -- Reconstruct the parent product coordinates from the two disjoint local
  -- views; A and T are outside both child embeddings and were already preserved
  -- by the head-X layer.
  unfold actualStep2Program
  rw [evalReversibleProgram_append, evalReversibleProgram_append]
  change flatFigure3Coordinate n large afterChildren = _
  apply Prod.ext
  · funext i
    fin_cases i
    · exact congrArg (fun child => child.2.2) leftLocal
    · exact congrArg (fun child => child.2.1) leftLocal
    · exact congrArg (fun child => child.2.2) rightLocal
    · exact congrArg (fun child => child.2.1) rightLocal
  · apply Prod.ext
    · funext i
      exact congrArg (fun child => child.1 i) leftLocal
    · apply Prod.ext
      · funext i
        exact congrArg (fun child => child.1 i) rightLocal
      · apply Prod.ext
        · -- A is outside both children and unchanged by the head X layer.
          have leftOutside := eval_mapProgramWires_outside
            (leftEmbed n large) (leftEmbed_injective n large)
            leftProgram afterHead (ancillaWire n) (by
              intro logical equal
              unfold leftEmbed at equal
              by_cases c : logical.val < leftTailWidth n
              · simp [c, ancillaWire, totalWidth] at equal
                omega
              · by_cases w : logical.val = leftTailWidth n <;>
                  simp [c,w,ancillaWire,totalWidth] at equal <;> omega)
          have rightOutside := eval_mapProgramWires_outside
            (rightEmbed n large) (rightEmbed_injective n large)
            rightProgram
            (evalReversibleProgram leftMapped afterHead)
            (ancillaWire n) (by
              intro logical equal
              unfold rightEmbed at equal
              by_cases c : logical.val < rightTailWidth n
              · simp [c, ancillaWire, totalWidth] at equal
                omega
              · by_cases w : logical.val = rightTailWidth n <;>
                  simp [c,w,ancillaWire,totalWidth] at equal <;> omega)
          have headPreserves :
              evalReversibleProgram (headXProgram n large) state (ancillaWire n) =
                state (ancillaWire n) := by
            have h := headX_refines n large state
            exact congrArg (fun s => s.2.2.2.1) h
          simpa [afterChildren, leftMapped, rightMapped, afterHead,
            headCoords] using rightOutside.trans leftOutside.trans headPreserves
        · -- T is outside both children and the head-X layer.
          have leftOutside := eval_mapProgramWires_outside
            (leftEmbed n large) (leftEmbed_injective n large)
            leftProgram afterHead (finalTargetWire n) (by
              intro logical equal
              unfold leftEmbed at equal
              by_cases c : logical.val < leftTailWidth n
              · simp [c, finalTargetWire, totalWidth] at equal
                omega
              · by_cases w : logical.val = leftTailWidth n <;>
                  simp [c,w,finalTargetWire,totalWidth] at equal <;> omega)
          have rightOutside := eval_mapProgramWires_outside
            (rightEmbed n large) (rightEmbed_injective n large)
            rightProgram
            (evalReversibleProgram leftMapped afterHead)
            (finalTargetWire n) (by
              intro logical equal
              unfold rightEmbed at equal
              by_cases c : logical.val < rightTailWidth n
              · simp [c, finalTargetWire, totalWidth] at equal
                omega
              · by_cases w : logical.val = rightTailWidth n <;>
                  simp [c,w,finalTargetWire,totalWidth] at equal <;> omega)
          have headPreserves :
              evalReversibleProgram (headXProgram n large) state (finalTargetWire n) =
                state (finalTargetWire n) := by
            have h := headX_refines n large state
            exact congrArg (fun s => s.2.2.2.2) h
          simpa [afterChildren, leftMapped, rightMapped, afterHead,
            headCoords] using rightOutside.trans leftOutside.trans headPreserves

end NieZiSunFigure3ChildRefinement
end QuantumBlockEncoding
