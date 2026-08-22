import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterLayers
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaOuterActivationStability

open MultiControlledXLayerSemantics
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers

/-- Any control of a selected source gate is preserved by a valid wall
containing that gate.  The selected gate itself only changes its target, and all
other gates are support-disjoint. -/
theorem eval_validWall_preserves_sourceControl
    {q m : Nat} (plan : AlphaPlan q m)
    (layer : MCXLayer q) (valid : LayerValid layer)
    (index : Fin m)
    (member : sourceGate plan index ∈ layer)
    (state : PrimitiveBasis q)
    (wire : Fin q) (control : inControlInterval plan index wire) :
    evalProgram layer state wire = state wire := by
  have controlMember : wire ∈ (sourceGate plan index).controls :=
    (mem_controlFinset_iff plan index wire).2 control
  have touched : touches (sourceGate plan index) wire := Or.inr controlMember
  have gateAtWire := eval_validLayer_member_on_touched
    layer valid (sourceGate plan index) member state wire touched
  rw [gateAtWire]
  apply gateAction_apply_of_ne_target
  intro targetEq
  have targetNotControl := (sourceGate plan index).target_not_control
  apply targetNotControl
  simpa [targetEq] using controlMember

/-- A source gate's Equation-(7) activation predicate is unchanged after a
valid depth-one wall containing that gate. -/
theorem intervalActive_eval_validWall_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (layer : MCXLayer q) (valid : LayerValid layer)
    (index : Fin m)
    (member : sourceGate plan index ∈ layer)
    (state : PrimitiveBasis q) :
    intervalActive plan (evalProgram layer state) index ↔
      intervalActive plan state index := by
  constructor
  · intro activeAfter wire control
    rw [← eval_validWall_preserves_sourceControl
      plan layer valid index member state wire control]
    exact activeAfter wire control
  · intro activeBefore wire control
    rw [eval_validWall_preserves_sourceControl
      plan layer valid index member state wire control]
    exact activeBefore wire control

/-- Left-wall specialization. -/
theorem intervalActive_leftScheduled_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (slot : Fin (wallCount m)) (state : PrimitiveBasis q) :
    intervalActive plan ((leftScheduled plan).eval state)
        (leftSourceIndex m slot) ↔
      intervalActive plan state (leftSourceIndex m slot) := by
  change intervalActive plan (evalProgram (leftLayer plan) state)
      (leftSourceIndex m slot) ↔ _
  apply intervalActive_eval_validWall_iff
    plan (leftLayer plan) (leftLayer_valid plan)
  unfold leftLayer
  rw [List.mem_ofFn']
  exact ⟨slot, rfl⟩

/-- Right-wall specialization. -/
theorem intervalActive_rightScheduled_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (slot : Fin (wallCount m)) (state : PrimitiveBasis q) :
    intervalActive plan ((rightScheduled plan).eval state)
        (rightSourceIndex m slot) ↔
      intervalActive plan state (rightSourceIndex m slot) := by
  change intervalActive plan (evalProgram (rightLayer plan) state)
      (rightSourceIndex m slot) ↔ _
  apply intervalActive_eval_validWall_iff
    plan (rightLayer plan) (rightLayer_valid plan)
  unfold rightLayer
  rw [List.mem_ofFn']
  exact ⟨slot, rfl⟩

end RemaudVandaeleLadderAlphaOuterActivationStability
end QuantumBlockEncoding
