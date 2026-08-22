import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaAlgorithmBaseSemantics

open MultiControlledXLayerSemantics
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract

theorem baseOne_target
    {q : Nat} (plan : AlphaPlan q 1) (state : PrimitiveBasis q) :
    (baseOne plan).eval state (plan.target ⟨0, by decide⟩) =
      if intervalActive plan state ⟨0, by decide⟩ then
        flipBit (state (plan.target ⟨0, by decide⟩))
      else state (plan.target ⟨0, by decide⟩) := by
  change evalProgram (baseOne plan).program state _ = _
  rw [show (baseOne plan).program =
      [sourceGate plan ⟨0, by decide⟩] by simp [baseOne]]
  have gateAtTarget := eval_validLayer_member_on_touched
    [sourceGate plan ⟨0, by decide⟩]
    (by simp [LayerValid, WireDisjoint])
    (sourceGate plan ⟨0, by decide⟩)
    (by simp) state
    (plan.target ⟨0, by decide⟩) (Or.inl rfl)
  rw [gateAtTarget]
  by_cases enabled : intervalActive plan state ⟨0, by decide⟩
  · have gateEnabled :
        active (sourceGate plan ⟨0, by decide⟩) state :=
      (sourceGate_active_iff plan state ⟨0, by decide⟩).2 enabled
    unfold gateAction
    rw [if_pos gateEnabled, if_pos enabled]
    simp [sourceGate, xBasisAction]
  · have gateDisabled :
        ¬ active (sourceGate plan ⟨0, by decide⟩) state := by
      intro activeGate
      exact enabled ((sourceGate_active_iff plan state ⟨0, by decide⟩).1 activeGate)
    unfold gateAction
    rw [if_neg gateDisabled, if_neg enabled]

theorem baseOne_nonTarget
    {q : Nat} (plan : AlphaPlan q 1) (state : PrimitiveBasis q)
    (wire : Fin q)
    (different : plan.target ⟨0, by decide⟩ ≠ wire) :
    (baseOne plan).eval state wire = state wire := by
  change evalProgram (baseOne plan).program state wire = state wire
  apply evalProgram_preserves_of_no_target
  intro gate member
  have equal : gate = sourceGate plan ⟨0, by decide⟩ := by
    simpa [baseOne] using member
  subst gate
  exact different

theorem algorithm_zero_refines
    {q : Nat} (plan : AlphaPlan q 0) :
    ∀ state, (algorithm plan).eval state = equationSevenAction plan state := by
  intro state
  funext wire
  have miss : ¬ ∃ index : Fin 0, plan.target index = wire := by simp
  rw [equationSeven_nonTarget plan state wire miss]
  simp [emptyScheduled, ScheduledMCXProgram.eval,
    ScheduledMCXProgram.program, scheduleProgram, evalProgram]

theorem algorithm_one_refines
    {q : Nat} (plan : AlphaPlan q 1) :
    ∀ state, (algorithm plan).eval state = equationSevenAction plan state := by
  intro state
  funext wire
  let zero : Fin 1 := ⟨0, by decide⟩
  by_cases hit : plan.target zero = wire
  · subst wire
    rw [algorithm_one]
    have source := baseOne_target plan state
    rw [equationSeven_target plan state zero]
    simpa [zero] using source
  · rw [algorithm_one]
    rw [baseOne_nonTarget plan state wire (by simpa [zero] using hit)]
    symm
    apply equationSeven_nonTarget
    intro targetHit
    rcases targetHit with ⟨index, equal⟩
    have indexZero : index = zero := by
      apply Fin.ext
      omega
    subst index
    exact hit equal

end RemaudVandaeleLadderAlphaAlgorithmBaseSemantics
end QuantumBlockEncoding
