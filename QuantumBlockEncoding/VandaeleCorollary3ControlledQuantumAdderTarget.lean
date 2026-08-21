import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.PredicateControlledConjugation
import QuantumBlockEncoding.VandaeleQuantumAdderTarget
import Mathlib.Tactic

/-!
# Canonical controlled quantum adder target for Vandaele Corollary 3

The uncontrolled quantum-adder target preserves the n-bit addend register `a`
and adds `value(a)` into the `(b,z)` payload viewed as one `(n+1)`-bit register.
Corollary 3 adds k external controls.  Its semantic target is therefore unique:
apply the quantum adder exactly when every external control is one, otherwise
act as the identity.

This file defines that target independently of Figure-4 gate synthesis.  The
resource realization is formalized separately in
`VandaeleCorollary3ControlledQuantumAdderResource`.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary3ControlledQuantumAdderTarget

open ComparatorIncrementerLemma7Contract
open PredicateControlledConjugation
open VandaeleQuantumAdderTarget

/-- State of k external controls and one complete quantum-adder register. -/
abbrev ControlledQuantumAdderState (k n : Nat) :=
  PrimitiveBasis k × QuantumAdderState n

/-- Canonical k-controlled quantum adder. -/
def controlledQuantumAdderEquiv (k n : Nat) :
    Equiv.Perm (ControlledQuantumAdderState k n) :=
  predicateControlledTargetEquiv allControlsActive (quantumAdderEquiv n)

/-- Reader-facing action. -/
theorem controlledQuantumAdder_action
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : QuantumAdderState n) :
    controlledQuantumAdderEquiv k n (controls, state) =
      if allControlsActive controls then
        (controls, quantumAdderEquiv n state)
      else (controls, state) := by
  cases condition : allControlsActive controls <;>
    simp [controlledQuantumAdderEquiv,
      predicateControlledTargetEquiv, condition]

/-- External controls are preserved exactly. -/
theorem preserves_controls
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : QuantumAdderState n) :
    (controlledQuantumAdderEquiv k n (controls, state)).1 = controls := by
  rw [controlledQuantumAdder_action]
  split <;> rfl

/-- On the active branch the addend register a is preserved. -/
theorem active_preserves_addend
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (active : allControlsActive controls = true)
    (state : QuantumAdderState n) :
    (controlledQuantumAdderEquiv k n (controls, state)).2.1 = state.1 := by
  rw [controlledQuantumAdder_action, if_pos active]
  exact quantumAdder_preserves_a n state

/-- Active-branch integer action on the combined `(b,z)` payload. -/
theorem active_payload_value
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (active : allControlsActive controls = true)
    (state : QuantumAdderState n) :
    ComparatorIncrementerGeneral.basisNat (n + 1)
      (controlledQuantumAdderEquiv k n (controls, state)).2.2 =
      (ComparatorIncrementerGeneral.basisNat (n + 1) state.2 +
        ComparatorIncrementerGeneral.basisNat n state.1) %
          ComparatorIncrementerGeneral.gridSize (n + 1) := by
  rw [controlledQuantumAdder_action, if_pos active]
  exact quantumAdder_payload_value n state

/-- Inactive branch is identity on the complete arithmetic state. -/
theorem inactive_identity
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (inactive : allControlsActive controls = false)
    (state : QuantumAdderState n) :
    controlledQuantumAdderEquiv k n (controls, state) = (controls, state) := by
  rw [controlledQuantumAdder_action, if_neg]
  exact Bool.eq_false_iff.mpr (by simpa using inactive)

end VandaeleCorollary3ControlledQuantumAdderTarget
end QuantumBlockEncoding
