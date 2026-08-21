import QuantumBlockEncoding.GidneyZeroedCarryCompute
import QuantumBlockEncoding.GidneyZeroedDescendingAction
import QuantumBlockEncoding.ReversibleProgramSupport
import Mathlib.Tactic

/-!
# Arbitrary-width clean target action of the Gidney source circuit

The source gate proof is now split into two independent facts:

* the clean ascending ladder computes the canonical carry chain;
* the descending sweep consumes carry `a_j` exactly once on target `x_{j+2}`.

The final two gates handle bits zero and one.  Combining the three stages gives
an exact bitwise theorem: every output target bit is the canonical
`BinaryCarryTelescoping.incrementOutput` bit for the original target.

No numeric modular-arithmetic theorem is used here.  The next layer will sum
these bit equations and apply the already-proved carry telescoping identity.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedCleanTargetAction

open BinaryCarryTelescoping
open GidneyZeroedCarryCompute
open GidneyZeroedDescendingAction
open GidneyZeroedSourceProgram
open ReversibleProgramSupport

/-- The low-bit tail flips bit zero. -/
theorem lowBitProgram_bit_zero
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount)) :
    evalReversibleProgram (lowBitProgram carryCount) state
        (targetWire carryCount
          ⟨0, by unfold targetWidth; omega⟩) =
      flipBit (state (targetWire carryCount
        ⟨0, by unfold targetWidth; omega⟩)) := by
  simp [lowBitProgram, evalReversibleProgram,
    evalReversibleGate, cxBasisEquiv, cxBasisAction,
    xBasisEquiv, xBasisAction]

/-- Bit one is toggled exactly by the original bit zero. -/
theorem lowBitProgram_bit_one
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount)) :
    evalReversibleProgram (lowBitProgram carryCount) state
        (targetWire carryCount
          ⟨1, by unfold targetWidth; omega⟩) =
      applyCarry
        (state (targetWire carryCount
          ⟨0, by unfold targetWidth; omega⟩))
        (state (targetWire carryCount
          ⟨1, by unfold targetWidth; omega⟩)) := by
  rcases fin2_cases
      (state (targetWire carryCount
        ⟨0, by unfold targetWidth; omega⟩)) with h0 | h0
  · simp [lowBitProgram, evalReversibleProgram,
      evalReversibleGate, cxBasisEquiv, cxBasisAction,
      xBasisEquiv, xBasisAction, applyCarry, h0]
  · simp [lowBitProgram, evalReversibleProgram,
      evalReversibleGate, cxBasisEquiv, cxBasisAction,
      xBasisEquiv, xBasisAction, applyCarry, h0]

/-- The low-bit tail does not write any target bit of index at least two. -/
theorem lowBitProgram_preserves_high_target
    (carryCount : Nat)
    (wire : Fin (targetWidth carryCount))
    (high : 2 ≤ wire.val) :
    PreservesWire (lowBitProgram carryCount)
      (targetWire carryCount wire) := by
  intro gate member
  simp [lowBitProgram] at member
  rcases member with rfl | rfl
  · simp [targetsWire]
    intro equal
    have values := congrArg Fin.val equal
    simp only [targetWire_val] at values
    omega
  · simp [targetsWire]
    intro equal
    have values := congrArg Fin.val equal
    simp only [targetWire_val] at values
    omega

/-- The full descending sweep preserves bit zero. -/
theorem descending_preserves_bit_zero
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount)) :
    evalReversibleProgram (descendingSweepProgram carryCount) state
        (targetWire carryCount
          ⟨0, by unfold targetWidth; omega⟩) =
      state (targetWire carryCount
        ⟨0, by unfold targetWidth; omega⟩) := by
  unfold descendingSweepProgram
  exact evalReversibleProgram_apply_of_preservesWire
    (descendingSweepProgramFrom carryCount 0 carryCount (by omega))
    (targetWire carryCount
      ⟨0, by unfold targetWidth; omega⟩)
    state
    (descendingSweep_preserves_low_target
      carryCount 0 carryCount (by omega)
      ⟨0, by unfold targetWidth; omega⟩ (by omega))

/-- The full descending sweep preserves bit one. -/
theorem descending_preserves_bit_one
    (carryCount : Nat)
    (state : PrimitiveBasis (flatWidth carryCount)) :
    evalReversibleProgram (descendingSweepProgram carryCount) state
        (targetWire carryCount
          ⟨1, by unfold targetWidth; omega⟩) =
      state (targetWire carryCount
        ⟨1, by unfold targetWidth; omega⟩) := by
  unfold descendingSweepProgram
  exact evalReversibleProgram_apply_of_preservesWire
    (descendingSweepProgramFrom carryCount 0 carryCount (by omega))
    (targetWire carryCount
      ⟨1, by unfold targetWidth; omega⟩)
    state
    (descendingSweep_preserves_low_target
      carryCount 0 carryCount (by omega)
      ⟨1, by unfold targetWidth; omega⟩ (by omega))

/-- Clean flat source result. -/
def cleanSourceResult
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount)) :
    PrimitiveBasis (flatWidth carryCount) :=
  evalReversibleProgram (sourceProgram carryCount)
    (cleanFlat carryCount target)

/-- Exact arbitrary-width bitwise target theorem for the source circuit. -/
theorem cleanSourceResult_target_bit
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (wire : Fin (targetWidth carryCount)) :
    cleanSourceResult carryCount target (targetWire carryCount wire) =
      incrementOutput (targetStream carryCount target) wire.val := by
  unfold cleanSourceResult
  rw [sourceProgram_eq_compute_sweep_low]
  rw [evalReversibleProgram_append, evalReversibleProgram_append]
  simp only [Equiv.trans_apply]
  let afterCompute :=
    evalReversibleProgram (computeCarryProgram carryCount)
      (cleanFlat carryCount target)
  let afterSweep :=
    evalReversibleProgram (descendingSweepProgram carryCount) afterCompute
  have computeInvariant := computeCarryProgram_clean_semantics carryCount target
  have targetAfterCompute : ∀ w : Fin (targetWidth carryCount),
      afterCompute (targetWire carryCount w) = target w := by
    intro w
    exact computeInvariant.1 w
  by_cases bitZero : wire.val = 0
  · have wireEq : wire = ⟨0, by unfold targetWidth; omega⟩ := by
      apply Fin.ext
      exact bitZero
    subst wire
    have afterSweepZero := descending_preserves_bit_zero carryCount afterCompute
    rw [lowBitProgram_bit_zero]
    rw [afterSweepZero, targetAfterCompute]
    simp [incrementOutput, carryChain, applyCarry, targetStream]
  · by_cases bitOne : wire.val = 1
    · have wireEq : wire = ⟨1, by unfold targetWidth; omega⟩ := by
        apply Fin.ext
        exact bitOne
      subst wire
      have afterSweepZero := descending_preserves_bit_zero carryCount afterCompute
      have afterSweepOne := descending_preserves_bit_one carryCount afterCompute
      rw [lowBitProgram_bit_one]
      rw [afterSweepZero, afterSweepOne,
        targetAfterCompute, targetAfterCompute]
      simp [incrementOutput, carryChain, targetStream, andBit]
    · have high : 2 ≤ wire.val := by omega
      let workspace : Fin carryCount :=
        ⟨wire.val - 2, by
          have wireBound := wire.isLt
          unfold targetWidth at wireBound
          omega⟩
      have wireEq :
          (⟨workspace.val + 2, by unfold targetWidth; omega⟩ :
            Fin (targetWidth carryCount)) = wire := by
        apply Fin.ext
        simp [workspace]
        omega
      have lowTailPreserves :=
        evalReversibleProgram_apply_of_preservesWire
          (lowBitProgram carryCount)
          (targetWire carryCount wire)
          afterSweep
          (lowBitProgram_preserves_high_target carryCount wire high)
      rw [lowTailPreserves]
      have sweepAction :=
        fullDescendingSweep_target_action carryCount afterCompute workspace
      rw [wireEq] at sweepAction
      rw [sweepAction]
      have carryValue := computeInvariant.2.1 workspace workspace.isLt
      have originalTarget := targetAfterCompute wire
      rw [carryValue, originalTarget]
      change
        applyCarry
          (carryChain (targetStream carryCount target) wire.val)
          (target wire) =
        incrementOutput (targetStream carryCount target) wire.val
      have streamWire :
          targetStream carryCount target wire.val = target wire := by
        simp [targetStream, wire.isLt]
      rw [← streamWire]
      rfl

/-- Product-register form of the same clean target theorem. -/
theorem runSource_clean_target_bit
    (carryCount : Nat)
    (target : PrimitiveBasis (targetWidth carryCount))
    (wire : Fin (targetWidth carryCount)) :
    (runSource carryCount (target, zeroWorkspace carryCount)).1 wire =
      incrementOutput (targetStream carryCount target) wire.val := by
  unfold runSource
  change
    cleanSourceResult carryCount target (targetWire carryCount wire) = _
  exact cleanSourceResult_target_bit carryCount target wire

end GidneyZeroedCleanTargetAction
end QuantumBlockEncoding