import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import Mathlib.Tactic

/-!
# Local semantics of a valid arbitrary-MCX layer

A valid `MCXLayer` is stored as a chronological list but its proof says that
all gate supports are pairwise wire-disjoint.  Algorithm 2 needs the same local
reasoning API already available for the lower-level reversible IR:

* a gate in a valid layer sees exactly its original touched-wire input;
* its touched-wire output therefore agrees with its stand-alone MCX action;
* a wire not targeted by any gate in the layer is preserved.

This keeps the source proof local while the same layer object continues to carry
its certified depth-one resource meaning.
-/

namespace QuantumBlockEncoding
namespace MultiControlledXLayerSemantics

open MultiControlledXSchedule

/-- One MCX gate preserves every non-target physical wire. -/
theorem gateAction_apply_of_ne_target
    {q : Nat} (gate : MCXGate q) (wire : Fin q)
    (state : PrimitiveBasis q) (different : gate.target ≠ wire) :
    gateAction gate state wire = state wire := by
  by_cases enabled : active gate state
  · simp [gateAction, enabled, xBasisAction, different]
  · simp [gateAction, enabled]

/-- A wire touched by the right gate cannot be the target of a disjoint left
gate. -/
theorem target_ne_of_wireDisjoint_touched
    {q : Nat} {left right : MCXGate q}
    (disjoint : WireDisjoint left right)
    (wire : Fin q) (rightTouches : touches right wire) :
    left.target ≠ wire := by
  intro target
  exact disjoint wire ⟨Or.inl target.symm, rightTouches⟩

/-- A disjoint gate preserves every wire read or written by the selected gate. -/
theorem gateAction_preserves_touches_of_disjoint
    {q : Nat} {left right : MCXGate q}
    (disjoint : WireDisjoint left right)
    (state : PrimitiveBasis q)
    (wire : Fin q) (rightTouches : touches right wire) :
    gateAction left state wire = state wire :=
  gateAction_apply_of_ne_target left wire state
    (target_ne_of_wireDisjoint_touched disjoint wire rightTouches)

/-- MCX activation depends only on the gate's touched support. -/
theorem active_congr_on_touches
    {q : Nat} (gate : MCXGate q)
    (left right : PrimitiveBasis q)
    (agree : ∀ wire, touches gate wire → left wire = right wire) :
    active gate left ↔ active gate right := by
  constructor
  · intro enabled control member
    rw [← agree control (Or.inr member)]
    exact enabled control member
  · intro enabled control member
    rw [agree control (Or.inr member)]
    exact enabled control member

/-- If two inputs agree on one gate's support, then its outputs also agree on
that support. -/
theorem gateAction_congr_on_touches
    {q : Nat} (gate : MCXGate q)
    (left right : PrimitiveBasis q)
    (agree : ∀ wire, touches gate wire → left wire = right wire)
    (wire : Fin q) (touched : touches gate wire) :
    gateAction gate left wire = gateAction gate right wire := by
  have enabledIff := active_congr_on_touches gate left right agree
  by_cases enabled : active gate left
  · have enabledRight : active gate right := enabledIff.mp enabled
    by_cases target : wire = gate.target
    · subst wire
      simp [gateAction, enabled, enabledRight, xBasisAction,
        agree gate.target (Or.inl rfl)]
    · simp [gateAction, enabled, enabledRight, xBasisAction, target,
        agree wire touched]
  · have disabledRight : ¬ active gate right := by
      intro rightEnabled
      exact enabled (enabledIff.mpr rightEnabled)
    simp [gateAction, enabled, disabledRight, agree wire touched]

/-- A whole prefix consisting of gates disjoint from a selected gate preserves
all input wires touched by that selected gate. -/
theorem evalProgram_preserves_gate_touches
    {q : Nat} (program : MCXProgram q) (gate : MCXGate q)
    (disjoint : ∀ prefixGate ∈ program, WireDisjoint prefixGate gate)
    (state : PrimitiveBasis q)
    (wire : Fin q) (touched : touches gate wire) :
    evalProgram program state wire = state wire := by
  induction program generalizing state with
  | nil => rfl
  | cons head rest induction =>
      have headDisjoint : WireDisjoint head gate := disjoint head (by simp)
      have restDisjoint : ∀ prefixGate ∈ rest,
          WireDisjoint prefixGate gate := by
        intro prefixGate member
        exact disjoint prefixGate (by simp [member])
      change
        evalProgram rest (gateAction head state) wire = state wire
      calc
        _ = gateAction head state wire :=
          induction restDisjoint (gateAction head state) wire touched
        _ = state wire :=
          gateAction_preserves_touches_of_disjoint
            headDisjoint state wire touched

/-- If no gate in a program targets one wire, the complete program preserves
that wire. -/
theorem evalProgram_preserves_of_no_target
    {q : Nat} (program : MCXProgram q) (wire : Fin q)
    (noTarget : ∀ gate ∈ program, gate.target ≠ wire)
    (state : PrimitiveBasis q) :
    evalProgram program state wire = state wire := by
  induction program generalizing state with
  | nil => rfl
  | cons head rest induction =>
      have headMiss : head.target ≠ wire := noTarget head (by simp)
      have restMiss : ∀ gate ∈ rest, gate.target ≠ wire := by
        intro gate member
        exact noTarget gate (by simp [member])
      change evalProgram rest (gateAction head state) wire = state wire
      calc
        _ = gateAction head state wire :=
          induction restMiss (gateAction head state)
        _ = state wire := gateAction_apply_of_ne_target head wire state headMiss

/-- In a valid depth-one layer, one selected member gate has exactly its
stand-alone action on every wire in its support. -/
theorem eval_validLayer_member_on_touched
    {q : Nat} (layer : MCXLayer q) (valid : LayerValid layer)
    (selected : MCXGate q) (member : selected ∈ layer)
    (state : PrimitiveBasis q)
    (wire : Fin q) (touched : touches selected wire) :
    evalProgram layer state wire = gateAction selected state wire := by
  induction layer generalizing state with
  | nil => simp at member
  | cons head rest induction =>
      have pairwise : (head :: rest).Pairwise WireDisjoint := by
        simpa [LayerValid] using valid
      have headTail : ∀ tailGate ∈ rest, WireDisjoint head tailGate := by
        simpa using (List.pairwise_cons.mp pairwise).1
      have restValid : LayerValid rest := by
        simpa [LayerValid] using (List.pairwise_cons.mp pairwise).2
      rcases List.mem_cons.mp member with rfl | tailMember
      · have tailPreserves :
          evalProgram rest (gateAction selected state) wire =
            gateAction selected state wire := by
          apply evalProgram_preserves_of_no_target
          intro tailGate tailGateMember
          exact target_ne_of_wireDisjoint_touched
            (wireDisjoint_symm (headTail tailGate tailGateMember))
            wire touched
        exact tailPreserves
      · have selectedDisjoint : WireDisjoint head selected :=
          headTail selected tailMember
        have tailResult :=
          induction restValid selected tailMember
            (gateAction head state) wire touched
        have inputAgreement : ∀ query, touches selected query →
            gateAction head state query = state query := by
          intro query queryTouched
          exact gateAction_preserves_touches_of_disjoint
            selectedDisjoint state query queryTouched
        exact tailResult.trans
          (gateAction_congr_on_touches selected
            (gateAction head state) state inputAgreement wire touched)

/-- If no gate in a layer targets a wire, the whole depth-one layer preserves
that wire. -/
theorem eval_layer_preserves_of_no_target
    {q : Nat} (layer : MCXLayer q) (wire : Fin q)
    (noTarget : ∀ gate ∈ layer, gate.target ≠ wire)
    (state : PrimitiveBasis q) :
    evalProgram layer state wire = state wire :=
  evalProgram_preserves_of_no_target layer wire noTarget state

end MultiControlledXLayerSemantics
end QuantumBlockEncoding
