import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterLayers
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: semantics of the two outer MCX walls

`RemaudVandaeleLadderAlphaOuterLayers` proves that `C_L` and `C_R` are actual
wire-disjoint depth-one layers.  The generic MCX layer semantics now turns that
resource certificate into local source semantics: every wall target has exactly
the stand-alone action of its corresponding source MCX, and every physical wire
not targeted by the wall is preserved.

This is the local semantic interface used by the Equation-(7) induction.  It
keeps source-index arithmetic separate from gate evaluation.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOuterSemantics

open MultiControlledXLayerSemantics
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers

/-- Every right-wall source gate occurs in the concrete right layer. -/
theorem rightSourceGate_mem
    {q m : Nat} (plan : AlphaPlan q m) (j : Fin (wallCount m)) :
    sourceGate plan (rightSourceIndex m j) ∈ rightLayer plan := by
  unfold rightLayer
  rw [List.mem_ofFn']
  exact ⟨j, rfl⟩

/-- Every left-wall source gate occurs in the concrete left layer. -/
theorem leftSourceGate_mem
    {q m : Nat} (plan : AlphaPlan q m) (j : Fin (wallCount m)) :
    sourceGate plan (leftSourceIndex m j) ∈ leftLayer plan := by
  unfold leftLayer
  rw [List.mem_ofFn']
  exact ⟨j, rfl⟩

/-- Exact right-wall action at one of its source targets. -/
theorem rightLayer_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    evalProgram (rightLayer plan) state
        (plan.target (rightSourceIndex m j)) =
      if intervalActive plan state (rightSourceIndex m j) then
        flipBit (state (plan.target (rightSourceIndex m j)))
      else state (plan.target (rightSourceIndex m j)) := by
  have gateAtTarget := eval_validLayer_member_on_touched
    (rightLayer plan) (rightLayer_valid plan)
    (sourceGate plan (rightSourceIndex m j))
    (rightSourceGate_mem plan j) state
    (plan.target (rightSourceIndex m j)) (Or.inl rfl)
  rw [gateAtTarget]
  by_cases enabled : intervalActive plan state (rightSourceIndex m j)
  · have gateEnabled :
        active (sourceGate plan (rightSourceIndex m j)) state :=
      (sourceGate_active_iff plan state (rightSourceIndex m j)).2 enabled
    unfold gateAction
    rw [if_pos gateEnabled, if_pos enabled]
    simp [sourceGate, xBasisAction]
  · have gateDisabled :
        ¬ active (sourceGate plan (rightSourceIndex m j)) state := by
      intro activeGate
      exact enabled
        ((sourceGate_active_iff plan state (rightSourceIndex m j)).1 activeGate)
    unfold gateAction
    rw [if_neg gateDisabled, if_neg enabled]

/-- Exact left-wall action at one of its source targets. -/
theorem leftLayer_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    evalProgram (leftLayer plan) state
        (plan.target (leftSourceIndex m j)) =
      if intervalActive plan state (leftSourceIndex m j) then
        flipBit (state (plan.target (leftSourceIndex m j)))
      else state (plan.target (leftSourceIndex m j)) := by
  have gateAtTarget := eval_validLayer_member_on_touched
    (leftLayer plan) (leftLayer_valid plan)
    (sourceGate plan (leftSourceIndex m j))
    (leftSourceGate_mem plan j) state
    (plan.target (leftSourceIndex m j)) (Or.inl rfl)
  rw [gateAtTarget]
  by_cases enabled : intervalActive plan state (leftSourceIndex m j)
  · have gateEnabled :
        active (sourceGate plan (leftSourceIndex m j)) state :=
      (sourceGate_active_iff plan state (leftSourceIndex m j)).2 enabled
    unfold gateAction
    rw [if_pos gateEnabled, if_pos enabled]
    simp [sourceGate, xBasisAction]
  · have gateDisabled :
        ¬ active (sourceGate plan (leftSourceIndex m j)) state := by
      intro activeGate
      exact enabled
        ((sourceGate_active_iff plan state (leftSourceIndex m j)).1 activeGate)
    unfold gateAction
    rw [if_neg gateDisabled, if_neg enabled]

/-- Scheduled right-wall form of the target theorem. -/
theorem rightScheduled_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state
        (plan.target (rightSourceIndex m j)) =
      if intervalActive plan state (rightSourceIndex m j) then
        flipBit (state (plan.target (rightSourceIndex m j)))
      else state (plan.target (rightSourceIndex m j)) := by
  change evalProgram (rightScheduled plan).program state _ = _
  rw [show (rightScheduled plan).program = rightLayer plan by
    simp [rightScheduled]]
  exact rightLayer_target plan j state

/-- Scheduled left-wall form of the target theorem. -/
theorem leftScheduled_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state
        (plan.target (leftSourceIndex m j)) =
      if intervalActive plan state (leftSourceIndex m j) then
        flipBit (state (plan.target (leftSourceIndex m j)))
      else state (plan.target (leftSourceIndex m j)) := by
  change evalProgram (leftScheduled plan).program state _ = _
  rw [show (leftScheduled plan).program = leftLayer plan by
    simp [leftScheduled]]
  exact leftLayer_target plan j state

/-- A physical wire not targeted by any right-wall source gate is preserved. -/
theorem rightScheduled_preserves_of_no_target
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (miss : ∀ j : Fin (wallCount m),
      plan.target (rightSourceIndex m j) ≠ wire) :
    (rightScheduled plan).eval state wire = state wire := by
  change evalProgram (rightScheduled plan).program state wire = state wire
  rw [show (rightScheduled plan).program = rightLayer plan by
    simp [rightScheduled]]
  apply eval_layer_preserves_of_no_target
  intro gate member
  unfold rightLayer at member
  rw [List.mem_ofFn'] at member
  rcases member with ⟨j, rfl⟩
  exact miss j

/-- A physical wire not targeted by any left-wall source gate is preserved. -/
theorem leftScheduled_preserves_of_no_target
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (miss : ∀ j : Fin (wallCount m),
      plan.target (leftSourceIndex m j) ≠ wire) :
    (leftScheduled plan).eval state wire = state wire := by
  change evalProgram (leftScheduled plan).program state wire = state wire
  rw [show (leftScheduled plan).program = leftLayer plan by
    simp [leftScheduled]]
  apply eval_layer_preserves_of_no_target
  intro gate member
  unfold leftLayer at member
  rw [List.mem_ofFn'] at member
  rcases member with ⟨j, rfl⟩
  exact miss j

end RemaudVandaeleLadderAlphaOuterSemantics
end QuantumBlockEncoding
