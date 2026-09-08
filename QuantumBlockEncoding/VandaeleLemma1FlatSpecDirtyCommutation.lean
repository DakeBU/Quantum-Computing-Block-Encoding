import QuantumBlockEncoding.VandaeleLemma1PrimitiveBaseCases
import Mathlib.Tactic

/-!
# Dirty-wire commutation forced by the flat Vandaele contract

A `LemmaOneFlatSpec` implementation may use the final wire as arbitrary dirty
workspace, but its public contract says more than restoration: controls and the
target depend only on the external state, while the dirty coordinate is returned
unchanged.  Consequently the entire implementation commutes with an independent
Pauli-X on that dirty wire.

This generic fact is the algebraic bridge later used by the Figure-3 proof:
Step 1 borrows the outer target `T` as the fixed `C⁴X` gadget's dirty wire, so
Step 1 commutes with `X_T` without reopening its ten-CCX implementation.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1FlatSpecDirtyCommutation

open VandaeleLemma1ProgramFamily
open VandaeleLemma1PrimitiveBaseCases

local instance instDecidableAllFlatControlsOne
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    Decidable (allFlatControlsOne k state) := by
  unfold allFlatControlsOne
  infer_instance

/-- Flipping the dirty workspace cannot change the source activation predicate. -/
theorem allFlatControlsOne_xBasisAction_dirty_iff
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne k (xBasisAction (dirtyWire k) state) ↔
      allFlatControlsOne k state := by
  constructor <;> intro active wire
  · have hit := active wire
    simpa [xBasisAction, controlWire_ne_dirty] using hit
  · have hit := active wire
    simpa [xBasisAction, controlWire_ne_dirty] using hit

/-- Every exact flat implementation commutes with flipping its arbitrary dirty
workspace bit. -/
theorem flatSpec_commutes_dirtyX
    (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)))
    (spec : LemmaOneFlatSpec k implementation)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    implementation (xBasisAction (dirtyWire k) state) =
      xBasisAction (dirtyWire k) (implementation state) := by
  let flipped := xBasisAction (dirtyWire k) state
  have flippedControls := (spec flipped).1
  have flippedTarget := (spec flipped).2.1
  have flippedDirty := (spec flipped).2.2
  have originalControls := (spec state).1
  have originalTarget := (spec state).2.1
  have originalDirty := (spec state).2.2
  funext wire
  rcases wire_classification k wire with control | target | dirty
  · let logical : Fin k := ⟨wire.val, control⟩
    have same : wire = controlWire k logical := by
      apply Fin.ext
      rfl
    calc
      implementation flipped wire =
          implementation flipped (controlWire k logical) := by
        exact congrArg (fun w => implementation flipped w) same
      _ = flipped (controlWire k logical) := flippedControls logical
      _ = state (controlWire k logical) := by
        simp [flipped, xBasisAction, controlWire_ne_dirty]
      _ = implementation state (controlWire k logical) :=
        (originalControls logical).symm
      _ = xBasisAction (dirtyWire k) (implementation state)
          (controlWire k logical) := by
        simp [xBasisAction, controlWire_ne_dirty]
      _ = xBasisAction (dirtyWire k) (implementation state) wire := by
        exact congrArg
          (fun w => xBasisAction (dirtyWire k) (implementation state) w)
          same.symm
  · subst wire
    have predicate :
        allFlatControlsOne k flipped ↔ allFlatControlsOne k state := by
      simpa [flipped] using allFlatControlsOne_xBasisAction_dirty_iff k state
    have targetInput : flipped (targetWire k) = state (targetWire k) := by
      simp [flipped, xBasisAction, targetWire_ne_dirty]
    calc
      implementation flipped (targetWire k) =
          (if allFlatControlsOne k flipped then
            flipBit (flipped (targetWire k))
          else flipped (targetWire k)) := flippedTarget
      _ = (if allFlatControlsOne k state then
            flipBit (state (targetWire k))
          else state (targetWire k)) := by
        by_cases active : allFlatControlsOne k state
        · have flippedActive : allFlatControlsOne k flipped := predicate.mpr active
          simp [active, flippedActive, targetInput]
        · have flippedInactive : ¬ allFlatControlsOne k flipped := by
            intro h
            exact active (predicate.mp h)
          simp [active, flippedInactive, targetInput]
      _ = implementation state (targetWire k) := originalTarget.symm
      _ = xBasisAction (dirtyWire k) (implementation state)
          (targetWire k) := by
        simp [xBasisAction, targetWire_ne_dirty]
  · subst wire
    calc
      implementation flipped (dirtyWire k) = flipped (dirtyWire k) :=
        flippedDirty
      _ = flipBit (state (dirtyWire k)) := by
        simp [flipped, xBasisAction]
      _ = flipBit (implementation state (dirtyWire k)) := by
        rw [originalDirty]
      _ = xBasisAction (dirtyWire k) (implementation state)
          (dirtyWire k) := by
        simp [xBasisAction]

end VandaeleLemma1FlatSpecDirtyCommutation
end QuantumBlockEncoding