import QuantumBlockEncoding.NieZiSunControlSplitAllOne
import QuantumBlockEncoding.NieZiSunFigure3GateCorrectness
import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.ReversibleProgramInverse
import QuantumBlockEncoding.VandaeleLemma1Contract
import Mathlib.Tactic

/-!
# Full actual-gate correctness of Nie--Zi--Sun Figure 3

The first-half gate list is already identified with the recursive semantic
`HalfComputation`.  Here we close the complete source circuit

`S1 ; S2 ; S3 ; S2^{-1} ; S1^{-1}`.

The proof deliberately uses gate-list reversal rather than reimplementing Step
4/5.  Forward refinement plus exact inverse semantics shows that the reversed
physical lists refine the source `step4` and `step5`.  The final result is the
one-clean-ancilla construction from Nie--Zi--Sun Theorem 1.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3FullGateCorrectness

open NieZiSunFigure3ChildRefinement
open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3GateCorrectness
open NieZiSunFigure3LocalStepRefinement
open NieZiSunFigure3Protocol
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram
open ReversibleProgramInverse

/-- The actual Step-2 list specializes the generic disjoint-child refinement. -/
theorem step2Program_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (step2Program n large) state) =
      step2 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  have source := actualStep2_refines
    n large
    (firstHalfProgram (leftTailWidth n))
    (firstHalfProgram (rightTailWidth n))
    (halfFamily (leftTailWidth n))
    (halfFamily (rightTailWidth n))
    (firstHalfProgram_refines (leftTailWidth n))
    (firstHalfProgram_refines (rightTailWidth n))
    state
  simpa [actualStep2Program, step2Program] using source

/-- Reversing actual Step 2 realizes source Step 4. -/
theorem reverse_step2Program_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (step2Program n large).reverse state) =
      step4 (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  let backward := evalReversibleProgram (step2Program n large).reverse state
  have roundtrip :
      evalReversibleProgram (step2Program n large) backward = state := by
    unfold backward
    have inverse := reverse_then_eval (step2Program n large)
    exact congrArg (fun equiv => equiv state) inverse
  have forward := step2Program_refines n large backward
  rw [roundtrip] at forward
  have undo := step4_step2
    (halfFamily (leftTailWidth n))
    (halfFamily (rightTailWidth n))
    (flatFigure3Coordinate n large backward)
  rw [← forward] at undo
  exact undo.symm

/-- Reverse Step 1 realizes source Step 5, because Step 1 is involutory. -/
theorem reverse_step1Program_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (step1Program n large).reverse state) =
      step5 (flatFigure3Coordinate n large state) := by
  let backward := evalReversibleProgram (step1Program n large).reverse state
  have roundtrip :
      evalReversibleProgram (step1Program n large) backward = state := by
    unfold backward
    have inverse := reverse_then_eval (step1Program n large)
    exact congrArg (fun equiv => equiv state) inverse
  have forward := step1_refines n large backward
  rw [roundtrip] at forward
  have undo := (@NieZiSunFigure3FirstHalf.step1_involutive
    (leftTailWidth n) (rightTailWidth n))
    (flatFigure3Coordinate n large backward)
  rw [← forward] at undo
  exact undo.symm

/-- Full non-base gate list refines the exact five-step source protocol. -/
theorem fullProgram_refines_protocol
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
      (evalReversibleProgram (fullProgram n) state) =
      protocol
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := by
  let s1 := step1Program n large
  let s2 := step2Program n large
  let s3 := step3Program n large
  let after1 := evalReversibleProgram s1 state
  let after2 := evalReversibleProgram s2 after1
  let after3 := evalReversibleProgram s3 after2
  let after4 := evalReversibleProgram s2.reverse after3
  have h1 := step1_refines n large state
  have h2 := step2Program_refines n large after1
  have h3 := step3_refines n large after2
  have h4 := reverse_step2Program_refines n large after3
  have h5 := reverse_step1Program_refines n large after4
  have decomposition : fullProgram n =
      (((s1 ++ s2) ++ s3) ++ s2.reverse) ++ s1.reverse := by
    simp [fullProgram, large, s1, s2, s3, List.append_assoc]
  rw [decomposition, evalReversibleProgram_append,
    evalReversibleProgram_append, evalReversibleProgram_append,
    evalReversibleProgram_append]
  change flatFigure3Coordinate n large
      (evalReversibleProgram s1.reverse after4) = _
  calc
    flatFigure3Coordinate n large
        (evalReversibleProgram s1.reverse after4) =
        step5 (flatFigure3Coordinate n large after4) := h5
    _ = step5 (step4
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large after3)) := by rw [h4]
    _ = step5 (step4
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (flatFigure3Coordinate n large after2))) := by rw [h3]
    _ = step5 (step4
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (step2
          (halfFamily (leftTailWidth n))
          (halfFamily (rightTailWidth n))
          (flatFigure3Coordinate n large after1)))) := by rw [h2]
    _ = step5 (step4
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (step3 (step2
          (halfFamily (leftTailWidth n))
          (halfFamily (rightTailWidth n))
          (step1 (flatFigure3Coordinate n large state))))) := by rw [h1]
    _ = protocol
        (halfFamily (leftTailWidth n))
        (halfFamily (rightTailWidth n))
        (flatFigure3Coordinate n large state) := rfl

/-- Clean-ancilla correctness of the actual complete gate family. -/
theorem fullProgram_clean_action
    (n : Nat) (controls : PrimitiveBasis n) (target : Fin 2) :
    let input := (flatProductCoordinate n).symm (controls,0,target)
    let output := evalReversibleProgram (fullProgram n) input
    flatProductCoordinate n output =
      if allOne controls then
        (controls,0,flipBit target)
      else (controls,0,target) := by
  dsimp
  by_cases large : 5 <= n
  · let input := (flatProductCoordinate n).symm (controls,0,target)
    have refinement := fullProgram_refines_protocol n large input
    let parts := NieZiSunControlSplit.splitControls n (by omega) controls
    have source := protocol_correct
      (halfFamily (leftTailWidth n))
      (halfFamily (rightTailWidth n))
      parts.1 parts.2.1 parts.2.2 target
    have activation := NieZiSunControlSplitAllOne.allOne_split_iff
      (n := n) (by omega) controls
    have inputCoord :
        flatFigure3Coordinate n large input =
          (parts.1,parts.2.1,parts.2.2,0,target) := by
      simp [input, flatFigure3Coordinate, flatProductCoordinate,
        fullCoordinate, parts]
    rw [inputCoord] at refinement
    rw [refinement]
    apply (fullCoordinate n (by omega)).injective
    simpa [fullActive, activation, flatFigure3Coordinate,
      flatProductCoordinate, fullCoordinate, parts] using source
  · have small : n < 5 := by omega
    have half := smallFirstHalf_refines (n := n) small
    have input := (flatProductCoordinate n).symm (controls,0,target)
    have source := half input
    rw [Equiv.apply_symm_apply] at source
    simpa [fullProgram, large, directHalf, directHalfAction] using source

/-- Reader-facing one-clean-ancilla C^nX theorem over the actual gate list. -/
theorem actual_cleanAncilla_multiControlledX
    (n : Nat) :
    PromiseGateOptimization.WeakPromiseSpec
      (0 : Fin 2)
      (((flatProductCoordinate n).symm.trans
        (evalReversibleProgram (fullProgram n))).trans
          (flatProductCoordinate n))
      (VandaeleLemma1Contract.multiControlledXEquiv n) := by
  intro state
  rcases state with ⟨controls,target⟩
  have source := fullProgram_clean_action n controls target
  by_cases active : allOne controls
  · have targetActive : VandaeleLemma1Contract.allControlsOne controls := active
    simpa [active, VandaeleLemma1Contract.multiControlledXEquiv,
      VandaeleLemma1Contract.multiControlledXAction, targetActive] using source
  · have targetInactive : ¬ VandaeleLemma1Contract.allControlsOne controls := by
      intro all
      exact active all
    simpa [active, VandaeleLemma1Contract.multiControlledXEquiv,
      VandaeleLemma1Contract.multiControlledXAction, targetInactive] using source

end NieZiSunFigure3FullGateCorrectness
end QuantumBlockEncoding
