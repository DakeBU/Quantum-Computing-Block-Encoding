import QuantumBlockEncoding.ReversibleProgramSupport
import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Local semantics of a valid parallel reversible layer

A `ReversibleLayer` is represented by a chronological list even though its
validity proof says that all gates are wire-disjoint.  Source circuits such as
Remaud--Vandaele Algorithm 1, Vandaele Figures 5/9/10, and parallel fan-out use
many such layers.

This module records the reusable consequence of layer validity:

* a gate occurring in a valid layer has exactly its stand-alone action on every
  wire that it touches;
* a wire that is not targeted by any gate in the layer is preserved.

The first statement is stronger than mere non-target preservation because it
also says that other gates cannot alter the controls read by the selected gate.
It lets source-specific proofs reason locally about one gate while resources
continue to come from the same proof-bearing parallel layer.
-/

namespace QuantumBlockEncoding
namespace ReversibleLayerSemantics

open ReversibleProgramSupport

/-- Wire-disjoint gates do not target each other's touched wires. -/
theorem notTargets_of_wireDisjoint_touched
    {q : Nat} {left right : ReversibleGate q}
    (disjoint : ReversibleGate.WireDisjoint left right)
    (wire : Fin q) (rightTouches : right.touches wire) :
    ¬ targetsWire left wire := by
  intro targeted
  have leftTouches :=
    ReversibleGateUnusedWireParity.touches_of_targetsWire left wire targeted
  exact disjoint wire ⟨leftTouches, rightTouches⟩

/-- If two gates are wire-disjoint, applying the first gate leaves every wire
read or written by the second gate unchanged. -/
theorem eval_gate_preserves_touches_of_disjoint
    {q : Nat} {left right : ReversibleGate q}
    (disjoint : ReversibleGate.WireDisjoint left right)
    (state : PrimitiveBasis q) :
    ∀ wire, right.touches wire →
      evalReversibleGate left state wire = state wire := by
  intro wire touched
  exact evalReversibleGate_apply_of_not_targets
    left wire state
    (notTargets_of_wireDisjoint_touched disjoint wire touched)

/-- Prefix gates that are all disjoint from one selected gate preserve the
selected gate's complete touched-wire input. -/
theorem eval_program_preserves_gate_touches
    {q : Nat} (program : ReversibleProgram q)
    (gate : ReversibleGate q)
    (disjoint : ∀ prefixGate ∈ program,
      ReversibleGate.WireDisjoint prefixGate gate)
    (state : PrimitiveBasis q) :
    ∀ wire, gate.touches wire →
      evalReversibleProgram program state wire = state wire := by
  induction program generalizing state with
  | nil =>
      intro wire touched
      rfl
  | cons head rest induction =>
      intro wire touched
      have headDisjoint : ReversibleGate.WireDisjoint head gate :=
        disjoint head (by simp)
      have restDisjoint : ∀ prefixGate ∈ rest,
          ReversibleGate.WireDisjoint prefixGate gate := by
        intro prefixGate member
        exact disjoint prefixGate (by simp [member])
      calc
        evalReversibleProgram (head :: rest) state wire =
            evalReversibleProgram rest
              (evalReversibleGate head state) wire := by rfl
        _ = evalReversibleGate head state wire :=
          induction restDisjoint (evalReversibleGate head state) wire touched
        _ = state wire :=
          eval_gate_preserves_touches_of_disjoint
            headDisjoint state wire touched

/-- In a valid parallel layer, one selected member gate has exactly its
stand-alone output on every wire it touches. -/
theorem eval_validLayer_member_on_touched
    {q : Nat} (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer)
    (selected : ReversibleGate q)
    (member : selected ∈ layer)
    (state : PrimitiveBasis q)
    (wire : Fin q) (touched : selected.touches wire) :
    evalReversibleProgram layer state wire =
      evalReversibleGate selected state wire := by
  induction layer generalizing state with
  | nil => simp at member
  | cons head rest induction =>
      have headTail :
          ∀ tailGate ∈ rest,
            ReversibleGate.WireDisjoint head tailGate := by
        simpa [ReversibleLayer.Valid] using valid
      rcases member with rfl | tailMember
      · have tailPreserves :
          evalReversibleProgram rest
              (evalReversibleGate selected state) wire =
            evalReversibleGate selected state wire := by
          apply evalReversibleProgram_apply_of_preservesWire
          intro tailGate tailGateMember
          have disjoint := headTail tailGate tailGateMember
          exact notTargets_of_wireDisjoint_touched
            (ReversibleGate.wireDisjoint_symm disjoint)
            wire touched
        exact tailPreserves
      · have selectedDisjoint : ReversibleGate.WireDisjoint head selected :=
          headTail selected tailMember
        have restValid : ReversibleLayer.Valid rest := by
          intro left leftMember
          have pairwise : rest.Pairwise ReversibleGate.WireDisjoint := by
            simpa [ReversibleLayer.Valid] using valid
          exact List.pairwise_iff_get.mp pairwise left leftMember
        have tailResult :=
          induction restValid selected tailMember
            (evalReversibleGate head state) wire touched
        have inputAgreement : ∀ query, selected.touches query →
            evalReversibleGate head state query = state query :=
          eval_gate_preserves_touches_of_disjoint selectedDisjoint state
        have selectedSame := evalReversibleGate_congr_on_touches
          selected (evalReversibleGate head state) state
          inputAgreement wire touched
        exact tailResult.trans selectedSame

/-- If no gate in a layer targets a wire, the whole layer preserves it. -/
theorem eval_layer_preserves_of_no_target
    {q : Nat} (layer : ReversibleLayer q)
    (wire : Fin q)
    (noTarget : ∀ gate ∈ layer, ¬ targetsWire gate wire)
    (state : PrimitiveBasis q) :
    evalReversibleProgram layer state wire = state wire := by
  exact evalReversibleProgram_apply_of_preservesWire
    layer wire state noTarget

end ReversibleLayerSemantics
end QuantumBlockEncoding
