import QuantumBlockEncoding.NieZiSunFigure3FlatProjections
import QuantumBlockEncoding.NieZiSunFigure3MacroEmbedding
import Mathlib.Tactic

/-!
# Gate-level refinement of the local Nie--Zi--Sun Figure-3 steps

This module removes all constant-size semantic macros from the recursive proof:
Step 1 and Step 3 are the actual CCX lists already truth-table certified, and
the four source X gates are the actual head flip.  Every statement is expressed
through the stable flat Figure-3 coordinate.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3LocalStepRefinement

open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3FlatProjections
open NieZiSunFigure3MacroEmbedding
open NieZiSunFigure3Protocol
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram

/-- Step 1 actual gate list is exactly the abstract source Step 1. -/
theorem step1_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
        (evalReversibleProgram (step1Program n large) state) =
      step1 (flatFigure3Coordinate n large state) := by
  let before := flatFigure3Coordinate n large state
  let after := flatFigure3Coordinate n large
    (evalReversibleProgram (step1Program n large) state)
  by_cases active : headAllOne before.1
  · have physicalActive :
        ∀ i : Fin 4,
          state ⟨i.val, by unfold totalWidth; omega⟩ = 1 := by
      intro i
      simpa [before] using active i
    apply Prod.ext
    · funext i
      simpa [after,before,step1,active] using
        step1Program_preserves_control n large state
          ⟨i.val, by omega⟩
    · apply Prod.ext
      · funext i
        simpa [after,before,step1,active] using
          step1Program_preserves_control n large state
            ⟨4+i.val, by
              have hi := i.isLt
              unfold leftTailWidth at hi
              omega⟩
      · apply Prod.ext
        · funext i
          simpa [after,before,step1,active] using
            step1Program_preserves_control n large state
              ⟨4+leftTailWidth n+i.val, by
                have hi := i.isLt
                have sum := NieZiSunFigure3Resource.tailWidths_sum n
                omega⟩
        · apply Prod.ext
          · rw [ancilla_apply]
            rw [step1Program_ancilla]
            simp [physicalActive,after,before,step1,active]
          · rw [target_apply]
            simpa [after,before,step1,active] using
              step1Program_preserves_finalTarget n large state
  · have physicalInactive :
        ¬ (∀ i : Fin 4,
          state ⟨i.val, by unfold totalWidth; omega⟩ = 1) := by
      intro all
      apply active
      intro i
      simpa [before] using all i
    apply Prod.ext
    · funext i
      simpa [after,before,step1,active] using
        step1Program_preserves_control n large state
          ⟨i.val, by omega⟩
    · apply Prod.ext
      · funext i
        simpa [after,before,step1,active] using
          step1Program_preserves_control n large state
            ⟨4+i.val, by
              have hi := i.isLt
              unfold leftTailWidth at hi
              omega⟩
      · apply Prod.ext
        · funext i
          simpa [after,before,step1,active] using
            step1Program_preserves_control n large state
              ⟨4+leftTailWidth n+i.val, by
                have hi := i.isLt
                have sum := NieZiSunFigure3Resource.tailWidths_sum n
                omega⟩
        · apply Prod.ext
          · rw [ancilla_apply]
            rw [step1Program_ancilla]
            simp [physicalInactive,after,before,step1,active]
          · rw [target_apply]
            simpa [after,before,step1,active] using
              step1Program_preserves_finalTarget n large state

/-- Four actual X instructions realize the source `flipHead`, preserving both
tails, A and T. -/
theorem headX_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
        (evalReversibleProgram (headXProgram n large) state) =
      let before := flatFigure3Coordinate n large state
      (flipHead before.1,before.2.1,before.2.2.1,
        before.2.2.2.1,before.2.2.2.2) := by
  let before := flatFigure3Coordinate n large state
  apply Prod.ext
  · funext i
    fin_cases i <;>
      simp [headXProgram, evalReversibleProgram, evalReversibleGate,
        xBasisEquiv, xBasisAction, flipHead, before]
  · apply Prod.ext
    · funext i
      have lower : 4 <= 4+i.val := by omega
      simp [headXProgram, evalReversibleProgram, evalReversibleGate,
        xBasisEquiv, xBasisAction, before, lower]
    · apply Prod.ext
      · funext i
        have lower : 4 <= 4 + leftTailWidth n + i.val := by omega
        simp [headXProgram, evalReversibleProgram, evalReversibleGate,
          xBasisEquiv, xBasisAction, before, lower]
      · apply Prod.ext
        · have ancLarge : 4 <= n := by omega
          simp [headXProgram, evalReversibleProgram, evalReversibleGate,
            xBasisEquiv, xBasisAction, before, ancillaWire, ancLarge]
        · have targetLarge : 4 <= n+1 := by omega
          simp [headXProgram, evalReversibleProgram, evalReversibleGate,
            xBasisEquiv, xBasisAction, before, finalTargetWire, targetLarge]

/-- Step 3 actual four-CCX list is exactly the abstract source Step 3. -/
theorem step3_refines
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatFigure3Coordinate n large
        (evalReversibleProgram (step3Program n large) state) =
      step3 (flatFigure3Coordinate n large state) := by
  let before := flatFigure3Coordinate n large state
  let after := flatFigure3Coordinate n large
    (evalReversibleProgram (step3Program n large) state)
  by_cases active : before.1 0 = 1 ∧ before.1 2 = 1 ∧ before.2.2.2.1 = 1
  · apply Prod.ext
    · funext i
      simpa [after,before,step3,active] using
        step3Program_preserves_nonTarget n large state
          ⟨i.val, by omega⟩
    · apply Prod.ext
      · funext i
        simpa [after,before,step3,active] using
          step3Program_preserves_nonTarget n large state
            ⟨4+i.val, by
              have hi := i.isLt
              unfold leftTailWidth at hi
              omega⟩
      · apply Prod.ext
        · funext i
          simpa [after,before,step3,active] using
            step3Program_preserves_nonTarget n large state
              ⟨4+leftTailWidth n+i.val, by
                have hi := i.isLt
                have sum := NieZiSunFigure3Resource.tailWidths_sum n
                omega⟩
        · apply Prod.ext
          · simpa [after,before,step3,active] using
              step3Program_preserves_nonTarget n large state
                ⟨n, by omega⟩
          · rw [target_apply]
            rw [step3Program_target]
            simpa [after,before,step3,active]
  · apply Prod.ext
    · funext i
      simpa [after,before,step3,active] using
        step3Program_preserves_nonTarget n large state
          ⟨i.val, by omega⟩
    · apply Prod.ext
      · funext i
        simpa [after,before,step3,active] using
          step3Program_preserves_nonTarget n large state
            ⟨4+i.val, by
              have hi := i.isLt
              unfold leftTailWidth at hi
              omega⟩
      · apply Prod.ext
        · funext i
          simpa [after,before,step3,active] using
            step3Program_preserves_nonTarget n large state
              ⟨4+leftTailWidth n+i.val, by
                have hi := i.isLt
                have sum := NieZiSunFigure3Resource.tailWidths_sum n
                omega⟩
        · apply Prod.ext
          · simpa [after,before,step3,active] using
              step3Program_preserves_nonTarget n large state
                ⟨n, by omega⟩
          · rw [target_apply]
            rw [step3Program_target]
            simpa [after,before,step3,active]

end NieZiSunFigure3LocalStepRefinement
end QuantumBlockEncoding
