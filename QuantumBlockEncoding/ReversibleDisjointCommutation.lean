import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Semantic commutation of wire-disjoint reversible gates

`ReversibleSchedule` certifies that gates sharing one layer have disjoint wire
support.  Resource accounting alone is not enough: a parallel scheduler must
also know that interleaving two disjoint computations preserves their basis
semantics.

The proof below avoids a nine-case X/CX/CCX commutation table.  Every reversible
gate is put in the same semantic normal form: an activation predicate followed
by a bit flip on one target wire.  Wire-disjointness then says that each gate's
target is invisible to the other gate's activation predicate, and that the two
targets are distinct.
-/

namespace QuantumBlockEncoding

namespace ReversibleGate

/-- The unique wire that a reversible gate may flip. -/
def targetWire {qubits : Nat} : ReversibleGate qubits → Fin qubits
  | .x target => target
  | .cx _ target _ => target
  | .ccx _ _ target _ _ _ => target

/-- Activation predicate for the target flip.  `CX` uses `≠ 0`, exactly matching
its executable basis semantics; on `Fin 2` this is equivalent to control = 1. -/
def Active {qubits : Nat}
    (gate : ReversibleGate qubits) (state : PrimitiveBasis qubits) : Prop :=
  match gate with
  | .x _ => True
  | .cx control _ _ => state control ≠ 0
  | .ccx control0 control1 _ _ _ _ =>
      state control0 = 1 ∧ state control1 = 1

/-- Activation is decidable because every control is a finite computational
basis bit.  Keeping this instance local avoids changing the public proposition
API of the reversible IR. -/
local instance instDecidableActive {qubits : Nat}
    (gate : ReversibleGate qubits) (state : PrimitiveBasis qubits) :
    Decidable (gate.Active state) := by
  cases gate <;> unfold Active <;> infer_instance

/-- A gate always touches its own target. -/
@[simp] theorem targetWire_touches {qubits : Nat}
    (gate : ReversibleGate qubits) :
    gate.touches gate.targetWire := by
  cases gate <;> simp [targetWire, touches]

/-- Executable gate semantics in activation-plus-target-flip normal form. -/
theorem evalReversibleGate_apply {qubits : Nat}
    (gate : ReversibleGate qubits) (state : PrimitiveBasis qubits) :
    evalReversibleGate gate state =
      if gate.Active state then xBasisAction gate.targetWire state else state := by
  cases gate with
  | x target =>
      simp [Active, targetWire, evalReversibleGate, xBasisEquiv]
  | cx control target distinct =>
      by_cases zero : state control = 0
      · simp [Active, targetWire, evalReversibleGate, cxBasisEquiv,
          cxBasisAction, zero]
      · simp [Active, targetWire, evalReversibleGate, cxBasisEquiv,
          cxBasisAction, zero]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      by_cases active : state control0 = 1 ∧ state control1 = 1
      · simp [Active, targetWire, evalReversibleGate, ccxBasisEquiv,
          ccxBasisAction, active]
      · simp [Active, targetWire, evalReversibleGate, ccxBasisEquiv,
          ccxBasisAction, active]

/-- Flipping an untouched wire cannot change a gate's activation predicate. -/
theorem active_xBasisAction_of_not_touches {qubits : Nat}
    (gate : ReversibleGate qubits)
    (changed : Fin qubits)
    (state : PrimitiveBasis qubits)
    (notTouches : ¬ gate.touches changed) :
    gate.Active (xBasisAction changed state) ↔ gate.Active state := by
  cases gate with
  | x target =>
      simp [Active]
  | cx control target distinct =>
      have control_ne_changed : control ≠ changed := by
        intro equal
        apply notTouches
        exact Or.inl equal.symm
      simp [Active, xBasisAction, control_ne_changed]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      have control0_ne_changed : control0 ≠ changed := by
        intro equal
        apply notTouches
        exact Or.inl equal.symm
      have control1_ne_changed : control1 ≠ changed := by
        intro equal
        apply notTouches
        exact Or.inr (Or.inl equal.symm)
      simp [Active, xBasisAction, control0_ne_changed, control1_ne_changed]

/-- Under wire-disjointness, the right target is untouched by the left gate. -/
theorem left_not_touches_right_target {qubits : Nat}
    {left right : ReversibleGate qubits}
    (disjoint : WireDisjoint left right) :
    ¬ left.touches right.targetWire := by
  intro leftTouches
  exact disjoint right.targetWire
    ⟨leftTouches, targetWire_touches right⟩

/-- Under wire-disjointness, the left target is untouched by the right gate. -/
theorem right_not_touches_left_target {qubits : Nat}
    {left right : ReversibleGate qubits}
    (disjoint : WireDisjoint left right) :
    ¬ right.touches left.targetWire :=
  left_not_touches_right_target (wireDisjoint_symm disjoint)

/-- Wire-disjoint gates have distinct target wires. -/
theorem targetWire_ne {qubits : Nat}
    {left right : ReversibleGate qubits}
    (disjoint : WireDisjoint left right) :
    left.targetWire ≠ right.targetWire := by
  intro equal
  apply left_not_touches_right_target disjoint
  rw [← equal]
  exact targetWire_touches left

end ReversibleGate

/-- Bit flips on distinct wires commute exactly. -/
theorem xBasisAction_commute {qubits : Nat}
    {leftTarget rightTarget : Fin qubits}
    (distinct : leftTarget ≠ rightTarget)
    (state : PrimitiveBasis qubits) :
    xBasisAction leftTarget (xBasisAction rightTarget state) =
      xBasisAction rightTarget (xBasisAction leftTarget state) := by
  funext wire
  by_cases leftHit : wire = leftTarget
  · subst wire
    simp [xBasisAction, distinct, distinct.symm]
  · by_cases rightHit : wire = rightTarget
    · subst wire
      simp [xBasisAction, distinct, distinct.symm]
    · simp [xBasisAction, leftHit, rightHit]

/-- Any two wire-disjoint reversible gates commute on every computational-basis
state.  This is the semantic fact needed to justify parallel layer merging. -/
theorem evalReversibleGate_commute_of_wireDisjoint {qubits : Nat}
    {left right : ReversibleGate qubits}
    (disjoint : ReversibleGate.WireDisjoint left right)
    (state : PrimitiveBasis qubits) :
    evalReversibleGate left (evalReversibleGate right state) =
      evalReversibleGate right (evalReversibleGate left state) := by
  have leftUntouched :=
    ReversibleGate.left_not_touches_right_target disjoint
  have rightUntouched :=
    ReversibleGate.right_not_touches_left_target disjoint
  have leftActiveAfterRight :
      left.Active (xBasisAction right.targetWire state) ↔ left.Active state :=
    ReversibleGate.active_xBasisAction_of_not_touches
      left right.targetWire state leftUntouched
  have rightActiveAfterLeft :
      right.Active (xBasisAction left.targetWire state) ↔ right.Active state :=
    ReversibleGate.active_xBasisAction_of_not_touches
      right left.targetWire state rightUntouched
  have targetDistinct := ReversibleGate.targetWire_ne disjoint
  have flipsCommute := xBasisAction_commute targetDistinct state
  by_cases leftActive : left.Active state <;>
    by_cases rightActive : right.Active state <;>
      simp [ReversibleGate.evalReversibleGate_apply, leftActive, rightActive,
        leftActiveAfterRight, rightActiveAfterLeft, flipsCommute]

end QuantumBlockEncoding
