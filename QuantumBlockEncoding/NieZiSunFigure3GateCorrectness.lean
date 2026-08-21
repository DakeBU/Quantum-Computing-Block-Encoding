import QuantumBlockEncoding.NieZiSunFigure3ChildRefinement
import QuantumBlockEncoding.NieZiSunFigure3LocalStepRefinement
import QuantumBlockEncoding.NieZiSunFigure3ReversibleProgram
import Mathlib.Tactic

/-!
# Actual gate correctness of the recursive Nie--Zi--Sun first half

The semantic Figure-3 recursion and the physical `{X,CX,CCX}` gate list were
constructed separately.  This module closes their main refinement edge.

For n<=4 the finite base programs are checked exactly.  For n>=5, the proof
follows the source decomposition:

`Step1 ; (head-X + left/right recursive halves) ; Step3`.

Local Step1/Step3 refinements, disjoint child-register semantics, and the two
recursive induction hypotheses are the only ingredients.  The final theorem is
stated in the flat `(controls,A,T)` coordinate, so it directly says the actual
gate list is the recursive `halfFamily.forward` used in the source proof.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3GateCorrectness

open NieZiSunFigure3ChildRefinement
open NieZiSunFigure3FirstHalf
open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3LocalStepRefinement
open NieZiSunFigure3Protocol
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram

/-- The five finite first-half base programs implement the direct source half. -/
theorem smallFirstHalf_refines
    {n : Nat} (small : n < 5) :
    ChildRefines n (smallFirstHalf n) (directHalf n) := by
  interval_cases n <;> native_decide

/-- In the non-base case, the source recursive first half is exactly the
three-stage product `Step1 ; Step2 ; Step3`. -/
theorem firstHalfEquiv_action
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    firstHalfEquiv left right state =
      step3 (step2 left right (step1 state)) := by
  rfl

/-- Main arbitrary-width refinement: the actual recursive first-half gate list
implements the recursively defined source `HalfComputation`. -/
theorem firstHalfProgram_refines :
    (n : Nat) -> ChildRefines n (firstHalfProgram n) (halfFamily n)
  | 0 => by
      simpa [firstHalfProgram, halfFamily] using
        (smallFirstHalf_refines (n := 0) (by omega))
  | 1 => by
      simpa [firstHalfProgram, halfFamily] using
        (smallFirstHalf_refines (n := 1) (by omega))
  | 2 => by
      simpa [firstHalfProgram, halfFamily] using
        (smallFirstHalf_refines (n := 2) (by omega))
  | 3 => by
      simpa [firstHalfProgram, halfFamily] using
        (smallFirstHalf_refines (n := 3) (by omega))
  | 4 => by
      simpa [firstHalfProgram, halfFamily] using
        (smallFirstHalf_refines (n := 4) (by omega))
  | m + 5 => by
      let n := m + 5
      let large : 5 <= n := by omega
      have leftCorrect :=
        firstHalfProgram_refines (leftTailWidth n)
      have rightCorrect :=
        firstHalfProgram_refines (rightTailWidth n)
      intro state
      let leftProgram := firstHalfProgram (leftTailWidth n)
      let rightProgram := firstHalfProgram (rightTailWidth n)
      let leftHalf := halfFamily (leftTailWidth n)
      let rightHalf := halfFamily (rightTailWidth n)
      let actualStep2 := actualStep2Program n large leftProgram rightProgram
      let after1 := evalReversibleProgram (step1Program n large) state
      let after2 := evalReversibleProgram actualStep2 after1
      have step1Correct := step1_refines n large state
      have step2Correct := actualStep2_refines
        n large leftProgram rightProgram leftHalf rightHalf
        (by simpa [leftProgram,leftHalf] using leftCorrect)
        (by simpa [rightProgram,rightHalf] using rightCorrect)
        after1
      have step3Correct := step3_refines n large after2
      have programDecomposition :
          firstHalfProgram n =
            (step1Program n large ++ actualStep2) ++ step3Program n large := by
        simp [n, firstHalfProgram, actualStep2,
          actualStep2Program, leftProgram, rightProgram, List.append_assoc]
      have figureCorrect :
          flatFigure3Coordinate n large
              (evalReversibleProgram (firstHalfProgram n) state) =
            firstHalfEquiv leftHalf rightHalf
              (flatFigure3Coordinate n large state) := by
        rw [programDecomposition, evalReversibleProgram_append,
          evalReversibleProgram_append]
        change flatFigure3Coordinate n large
            (evalReversibleProgram (step3Program n large) after2) = _
        calc
          flatFigure3Coordinate n large
              (evalReversibleProgram (step3Program n large) after2) =
              step3 (flatFigure3Coordinate n large after2) := step3Correct
          _ = step3 (step2 leftHalf rightHalf
                (flatFigure3Coordinate n large after1)) := by
              rw [step2Correct]
          _ = step3 (step2 leftHalf rightHalf
                (step1 (flatFigure3Coordinate n large state))) := by
              rw [step1Correct]
          _ = firstHalfEquiv leftHalf rightHalf
                (flatFigure3Coordinate n large state) := by
              rw [firstHalfEquiv_action]
      -- `halfFamily` uses exactly the same splitControls coordinate as
      -- `flatFigure3Coordinate`; inject through that coordinate to discharge
      -- the final representation transport.
      apply (fullCoordinate n (by omega)).injective
      change flatFigure3Coordinate n large
          (evalReversibleProgram (firstHalfProgram n) state) = _
      simpa [n, halfFamily, asHalfComputation,
        flatFigure3Coordinate, flatProductCoordinate,
        leftHalf, rightHalf] using figureCorrect
termination_by n => n

decreasing_by
  all_goals
    unfold leftTailWidth rightTailWidth
    omega

/-- Reader-facing midpoint target property now obtained from the actual gate
list rather than the semantic recursive oracle. -/
theorem actual_firstHalf_cleanTarget
    (n : Nat) (controls : PrimitiveBasis n) :
    let cleanFlat := (flatProductCoordinate n).symm (controls,0,0)
    let output := evalReversibleProgram (firstHalfProgram n) cleanFlat
    (flatProductCoordinate n output).2.2 =
      if allOne controls then 1 else 0 := by
  dsimp
  have refinement := firstHalfProgram_refines n
    ((flatProductCoordinate n).symm (controls,0,0))
  rw [Equiv.apply_symm_apply] at refinement
  rw [refinement]
  exact (halfFamily n).cleanTarget controls

end NieZiSunFigure3GateCorrectness
end QuantumBlockEncoding
