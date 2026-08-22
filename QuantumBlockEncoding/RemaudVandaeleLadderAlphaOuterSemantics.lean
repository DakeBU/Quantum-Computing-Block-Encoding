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
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOuterSemantics

open MultiControlledXLayerSemantics
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers

theorem rightSourceGate_mem
    {q m : Nat} (plan : AlphaPlan q m) (j : Fin (wallCount m)) :
    sourceGate plan (rightSourceIndex m j) ∈ rightLayer plan := by
  unfold rightLayer
  rw [List.mem_ofFn']
  exact ⟨j, rfl⟩

theorem leftSourceGate_mem
    {q m : Nat} (plan : AlphaPlan q m) (j : Fin (wallCount m)) :
    sourceGate plan (leftSourceIndex m j) ∈ leftLayer plan := by
  unfold leftLayer
  rw [List.mem_ofFn']
  exact ⟨j, rfl⟩

theorem rightLayer_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    evalProgram (rightLayer plan) state
        (plan.target (rightSourceIndex m j)) =
      if intervalActive plan state (rightSourceIndex m j) then
        flipBit (state (plan.target (rightSourceIndex m j)))
      else state (plan.target (rightSourceIndex m j)) := by
  have localAction := eval_validLayer_member_on_touched
    (rightLayer plan) (rightLayer_valid plan)
    (sourceGate plan (rightSourceIndex m j))
    (rightSourceGate_mem plan j) state
    (plan.target (rightSourceIndex m j)) (Or.inl rfl)
  rw [localAction]
  by_cases enabled : intervalActive plan state (rightSourceIndex m j)
  · have sourceEnabled :
        active (sourceGate plan (rightSourceIndex m j)) state :=
      (sourceGate_active_iff plan state (rightSourceIndex m j)).2 enabled
    simp [gateAction, sourceEnabled, enabled, xBasisAction, sourceGate]
  · have sourceDisabled :
        ¬ active (sourceGate plan (rightSourceIndex m j)) state := by
      intro sourceEnabled
      exact enabled ((sourceGate_active_iff plan state (rightSourceIndex m j)).1 sourceEnabled)
    simp [gateAction, sourceDisabled, enabled]

theorem leftLayer_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    evalProgram (leftLayer plan) state
        (plan.target (leftSourceIndex m j)) =
      if intervalActive plan state (leftSourceIndex m j) then
        flipBit (state (plan.target (leftSourceIndex m j)))
      else state (plan.target (leftSourceIndex m j)) := by
  have localAction := eval_validLayer_member_on_touched
    (leftLayer plan) (leftLayer_valid plan)
    (sourceGate plan (leftSourceIndex m j))
    (leftSourceGate_mem plan j) state
    (plan.target (leftSourceIndex m j)) (Or.inl rfl)
  rw [localAction]
  by_cases enabled : intervalActive plan state (leftSourceIndex m j)
  · have sourceEnabled :
        active (sourceGate plan (leftSourceIndex m j)) state :=
      (sourceGate_active_iff plan state (leftSourceIndex m j)).2 enabled
    simp [gateAction, sourceEnabled, enabled, xBasisAction, sourceGate]
  · have sourceDisabled :
        ¬ active (sourceGate plan (leftSourceIndex m j)) state := by
      intro sourceEnabled
      exact enabled ((sourceGate_active_iff plan state (leftSourceIndex m j)).1 sourceEnabled)
    simp [gateAction, sourceDisabled, enabled]

theorem rightScheduled_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    (rightScheduled plan).eval state
        (plan.target (rightSourceIndex m j)) =
      if intervalActive plan state (rightSourceIndex m j) then
        flipBit (state (plan.target (rightSourceIndex m j)))
      else state (plan.target (rightSourceIndex m j)) := by
  change evalProgram (rightScheduled plan).program state _ = _
  rw [show (rightScheduled plan).program = rightLayer plan by simp [rightScheduled]]
  exact rightLayer_target plan j state

theorem leftScheduled_target
    {q m : Nat} (plan : AlphaPlan q m)
    (j : Fin (wallCount m)) (state : PrimitiveBasis q) :
    (leftScheduled plan).eval state
        (plan.target (leftSourceIndex m j)) =
      if intervalActive plan state (leftSourceIndex m j) then
        flipBit (state (plan.target (leftSourceIndex m j)))
      else state (plan.target (leftSourceIndex m j)) := by
  change evalProgram (leftScheduled plan).program state _ = _
  rw [show (leftScheduled plan).program = leftLayer plan by simp [leftScheduled]]
  exact leftLayer_target plan j state

theorem rightScheduled_preserves_of_no_target
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (miss : ∀ j : Fin (wallCount m), plan.target (rightSourceIndex m j) ≠ wire) :
    (rightScheduled plan).eval state wire = state wire := by
  change evalProgram (rightScheduled plan).program state wire = state wire
  rw [show (rightScheduled plan).program = rightLayer plan by simp [rightScheduled]]
  apply eval_layer_preserves_of_no_target
  intro gate member
  unfold rightLayer at member
  rw [List.mem_ofFn'] at member
  rcases member with ⟨j, rfl⟩
  exact miss j

theorem leftScheduled_preserves_of_no_target
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (miss : ∀ j : Fin (wallCount m), plan.target (leftSourceIndex m j) ≠ wire) :
    (leftScheduled plan).eval state wire = state wire := by
  change evalProgram (leftScheduled plan).program state wire = state wire
  rw [show (leftScheduled plan).program = leftLayer plan by simp [leftScheduled]]
  apply eval_layer_preserves_of_no_target
  intro gate member
  unfold leftLayer at member
  rw [List.mem_ofFn'] at member
  rcases member with ⟨j, rfl⟩
  exact miss j

end RemaudVandaeleLadderAlphaOuterSemantics
end QuantumBlockEncoding
