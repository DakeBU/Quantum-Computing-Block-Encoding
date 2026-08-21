import QuantumBlockEncoding.ComparatorSemanticTargets
import QuantumBlockEncoding.PredicateControlledConjugation
import QuantumBlockEncoding.VandaeleLemma1Contract

/-!
# Canonical controlled comparator targets

Corollaries 5 and 6 add k external controls to the quantum-quantum and
classical-quantum comparators.  Before proving a source circuit realization, ASPBE
needs one canonical semantic target for each controlled oracle.

The key predicate is exactly the Definition-2.1 all-controls-one predicate.  If
it is active, apply the already source-correct canonical comparator; otherwise
leave the comparator register unchanged.  External controls are preserved by
construction.
-/

namespace QuantumBlockEncoding
namespace VandaeleControlledComparatorTargets

open ComparatorIncrementerGeneral
open ComparatorSemanticTargets
open PredicateControlledConjugation
open VandaeleLemma1Contract

/-- Boolean version of the all-controls-one predicate. -/
def controlsActive {k : Nat} (controls : PrimitiveBasis k) : Bool :=
  if allControlsOne controls then true else false

@[simp] theorem controlsActive_eq_true_iff
    {k : Nat} (controls : PrimitiveBasis k) :
    controlsActive controls = true ↔ allControlsOne controls := by
  unfold controlsActive
  by_cases active : allControlsOne controls <;> simp [active]

/-- Canonical k-controlled QQ comparator. -/
def controlledQuantumComparatorEquiv (k n : Nat) :
    Equiv.Perm
      (PrimitiveBasis k × PrimitiveBasis (2 * n + 1)) :=
  predicateControlledTargetEquiv controlsActive
    (quantumComparatorEquiv n)

/-- Canonical k-controlled source CQ comparator (Equation 29 direction). -/
def controlledClassicalComparatorEquiv
    (k n constant : Nat) :
    Equiv.Perm
      (PrimitiveBasis k × PrimitiveBasis (n + 1)) :=
  predicateControlledTargetEquiv controlsActive
    (classicalComparatorEquiv n constant)

/-- External controls are always preserved. -/
theorem controlledQQ_preserves_controls
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (2 * n + 1)) :
    (controlledQuantumComparatorEquiv k n (controls, state)).1 = controls := by
  cases condition : controlsActive controls <;>
    simp [controlledQuantumComparatorEquiv,
      predicateControlledTargetEquiv, condition]

/-- Inactive controls make the QQ comparator the identity. -/
theorem controlledQQ_inactive
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (2 * n + 1))
    (inactive : controlsActive controls = false) :
    controlledQuantumComparatorEquiv k n (controls, state) =
      (controls, state) := by
  simp [controlledQuantumComparatorEquiv,
    predicateControlledTargetEquiv, inactive]

/-- Active controls apply exactly the canonical QQ comparator. -/
theorem controlledQQ_active
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (2 * n + 1))
    (active : controlsActive controls = true) :
    controlledQuantumComparatorEquiv k n (controls, state) =
      (controls, quantumComparatorEquiv n state) := by
  simp [controlledQuantumComparatorEquiv,
    predicateControlledTargetEquiv, active]

/-- Reader-facing controlled QQ flag equation. -/
theorem controlledQQ_flag
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (2 * n + 1)) :
    (controlledQuantumComparatorEquiv k n (controls, state)).2 (qqFlagWire n) =
      if controlsActive controls = true ∧
          qqLeftValue n state < qqRightValue n state then
        flipBit (state (qqFlagWire n))
      else state (qqFlagWire n) := by
  by_cases enabled : controlsActive controls = true
  · rw [controlledQQ_active k n controls state enabled]
    have spec := quantumComparatorEquiv_spec n state
    simp [enabled, spec.2.2]
  · have inactive : controlsActive controls = false := by
      cases condition : controlsActive controls <;> simp_all
    rw [controlledQQ_inactive k n controls state inactive]
    simp [enabled]

/-- Controlled CQ external controls are preserved. -/
theorem controlledCQ_preserves_controls
    (k n constant : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (n + 1)) :
    (controlledClassicalComparatorEquiv k n constant
      (controls, state)).1 = controls := by
  cases condition : controlsActive controls <;>
    simp [controlledClassicalComparatorEquiv,
      predicateControlledTargetEquiv, condition]

/-- Inactive controls make the CQ comparator the identity. -/
theorem controlledCQ_inactive
    (k n constant : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (n + 1))
    (inactive : controlsActive controls = false) :
    controlledClassicalComparatorEquiv k n constant (controls, state) =
      (controls, state) := by
  simp [controlledClassicalComparatorEquiv,
    predicateControlledTargetEquiv, inactive]

/-- Active controls apply the canonical Equation-(29) comparator. -/
theorem controlledCQ_active
    (k n constant : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (n + 1))
    (active : controlsActive controls = true) :
    controlledClassicalComparatorEquiv k n constant (controls, state) =
      (controls, classicalComparatorEquiv n constant state) := by
  simp [controlledClassicalComparatorEquiv,
    predicateControlledTargetEquiv, active]

/-- Reader-facing controlled CQ flag equation. -/
theorem controlledCQ_flag
    (k n constant : Nat)
    (controls : PrimitiveBasis k)
    (state : PrimitiveBasis (n + 1)) :
    (controlledClassicalComparatorEquiv k n constant
      (controls, state)).2 (cqFlagWire n) =
      if controlsActive controls = true ∧
          constant < cqAddressValue n state then
        flipBit (state (cqFlagWire n))
      else state (cqFlagWire n) := by
  by_cases enabled : controlsActive controls = true
  · rw [controlledCQ_active k n constant controls state enabled]
    have spec := classicalComparatorEquiv_spec n constant state
    simp [enabled, spec.2]
  · have inactive : controlsActive controls = false := by
      cases condition : controlsActive controls <;> simp_all
    rw [controlledCQ_inactive k n constant controls state inactive]
    simp [enabled]

end VandaeleControlledComparatorTargets
end QuantumBlockEncoding
