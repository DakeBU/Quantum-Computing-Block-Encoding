import QuantumBlockEncoding.VandaeleQuantumAdderTarget
import Mathlib.Tactic

/-!
# Canonical controlled quantum adder target for Vandaele Corollary 3

The uncontrolled quantum-adder target preserves the n-bit addend register `a`
and adds `value(a)` into the `(b,z)` payload viewed as one `(n+1)`-bit register.
Corollary 3 adds k external controls. Its semantic target is therefore unique:
apply the quantum adder exactly when every external control is one, otherwise
act as the identity.

This semantic leaf deliberately depends only on the canonical quantum-adder
permutation and primitive basis registers.  It does not import the historical
comparator/incrementer implementation tree.  The resource realization remains a
separate proof obligation.
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary3ControlledQuantumAdderTarget

open VandaeleQuantumAdderTarget
open PrimitiveBasisModularArithmetic

/-- All-k-controls-on predicate, stated directly on computational-basis bits. -/
def allControlsActive {k : Nat} (controls : PrimitiveBasis k) : Bool :=
  if (∀ wire, controls wire = 1) then true else false

@[simp] theorem allControlsActive_iff {k : Nat}
    (controls : PrimitiveBasis k) :
    allControlsActive controls = true ↔ ∀ wire, controls wire = 1 := by
  unfold allControlsActive
  by_cases active : ∀ wire, controls wire = 1 <;> simp [active]

/-- Pure predicate-controlled target permutation.  The key register is always
preserved; the target permutation is applied exactly on active keys. -/
def controlledTargetEquiv {κ α : Type*}
    (active : κ → Bool) (target : Equiv.Perm α) :
    Equiv.Perm (κ × α) where
  toFun state :=
    if active state.1 then (state.1, target state.2) else state
  invFun state :=
    if active state.1 then (state.1, target.symm state.2) else state
  left_inv state := by
    rcases state with ⟨key, value⟩
    cases condition : active key <;> simp [condition]
  right_inv state := by
    rcases state with ⟨key, value⟩
    cases condition : active key <;> simp [condition]

/-- State of k external controls and one complete quantum-adder register. -/
abbrev ControlledQuantumAdderState (k n : Nat) :=
  PrimitiveBasis k × QuantumAdderState n

/-- Canonical k-controlled quantum adder. -/
def controlledQuantumAdderEquiv (k n : Nat) :
    Equiv.Perm (ControlledQuantumAdderState k n) :=
  controlledTargetEquiv allControlsActive (quantumAdderEquiv n)

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
    simp [controlledQuantumAdderEquiv, controlledTargetEquiv, condition]

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
  rw [controlledQuantumAdder_action]
  simp [active, quantumAdder_preserves_a]

/-- Active-branch integer action on the combined `(b,z)` payload. -/
theorem active_payload_value
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (active : allControlsActive controls = true)
    (state : QuantumAdderState n) :
    basisNat (n + 1)
      (controlledQuantumAdderEquiv k n (controls, state)).2.2 =
      (basisNat (n + 1) state.2 + basisNat n state.1) %
        gridSize (n + 1) := by
  rw [controlledQuantumAdder_action]
  simp only [active, if_true]
  exact quantumAdder_payload_value n state

/-- Inactive branch is identity on the complete arithmetic state. -/
theorem inactive_identity
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (inactive : allControlsActive controls = false)
    (state : QuantumAdderState n) :
    controlledQuantumAdderEquiv k n (controls, state) = (controls, state) := by
  rw [controlledQuantumAdder_action]
  simp [inactive]

end VandaeleCorollary3ControlledQuantumAdderTarget
end QuantumBlockEncoding
