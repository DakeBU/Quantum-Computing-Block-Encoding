import QuantumBlockEncoding.VandaeleClassicalAdderTarget
import QuantumBlockEncoding.VandaeleControlledComparatorTargets

/-!
# Canonical controlled classical-adder target

Corollary 8 ultimately implements one simple semantic oracle: add the classical
constant c modulo `2^n` exactly when all k external controls are one.  The source
Equations (53)-(54) are low-resource realizations of this target.

This module names the target once so later circuit refinements do not restate the
control condition ad hoc.
-/

namespace QuantumBlockEncoding
namespace VandaeleControlledAdderTarget

open PredicateControlledConjugation
open VandaeleClassicalAdderTarget
open VandaeleControlledComparatorTargets

/-- Canonical k-controlled adder for a ZMod-valued classical constant. -/
def controlledAdderEquiv
    (k n : Nat) (constant : ZMod (ComparatorIncrementerGeneral.gridSize n)) :
    Equiv.Perm (PrimitiveBasis k × PrimitiveBasis n) :=
  predicateControlledTargetEquiv controlsActive
    (basisModularAddEquiv n constant)

/-- External controls are preserved unconditionally. -/
theorem preserves_controls
    (k n : Nat)
    (constant : ZMod (ComparatorIncrementerGeneral.gridSize n))
    (controls : PrimitiveBasis k) (state : PrimitiveBasis n) :
    (controlledAdderEquiv k n constant (controls, state)).1 = controls := by
  cases condition : controlsActive controls <;>
    simp [controlledAdderEquiv, predicateControlledTargetEquiv, condition]

/-- Inactive controls give identity. -/
theorem inactive
    (k n : Nat)
    (constant : ZMod (ComparatorIncrementerGeneral.gridSize n))
    (controls : PrimitiveBasis k) (state : PrimitiveBasis n)
    (disabled : controlsActive controls = false) :
    controlledAdderEquiv k n constant (controls, state) = (controls, state) := by
  simp [controlledAdderEquiv, predicateControlledTargetEquiv, disabled]

/-- Active controls apply exactly the canonical modular adder. -/
theorem active
    (k n : Nat)
    (constant : ZMod (ComparatorIncrementerGeneral.gridSize n))
    (controls : PrimitiveBasis k) (state : PrimitiveBasis n)
    (enabled : controlsActive controls = true) :
    controlledAdderEquiv k n constant (controls, state) =
      (controls, basisModularAddEquiv n constant state) := by
  simp [controlledAdderEquiv, predicateControlledTargetEquiv, enabled]

/-- Exact controlled adder action in the modular basis representation. -/
theorem modular_action
    (k n : Nat)
    (constant : ZMod (ComparatorIncrementerGeneral.gridSize n))
    (controls : PrimitiveBasis k) (state : PrimitiveBasis n) :
    ZModPrimitiveBasisBridge.basisZModEquiv n
      (controlledAdderEquiv k n constant (controls, state)).2 =
      if controlsActive controls = true then
        ZModPrimitiveBasisBridge.basisZModEquiv n state + constant
      else
        ZModPrimitiveBasisBridge.basisZModEquiv n state := by
  by_cases enabled : controlsActive controls = true
  · rw [active k n constant controls state enabled]
    simp [enabled, basisModularAdd_commutes]
  · have disabled : controlsActive controls = false := by
      cases condition : controlsActive controls <;> simp_all
    rw [inactive k n constant controls state disabled]
    simp [enabled]

end VandaeleControlledAdderTarget
end QuantumBlockEncoding
