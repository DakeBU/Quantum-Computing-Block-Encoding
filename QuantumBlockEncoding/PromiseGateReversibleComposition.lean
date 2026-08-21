import QuantumBlockEncoding.PromiseGateCircuitIdentities

/-!
# Reversible promise gates compose on a shared promise register

Section 3.1 states that promise gates compose naturally.  For the reversible
specialization used throughout ASPBE, the statement is exact and elementary:

* two weak promise gates on the same clean promise fibre compose to a weak
  promise gate whose target is the chronological target composition;
* if both gates are strong, the composition is strong because each stage
  restores the promise register for arbitrary incoming promise values.

This node is intentionally generic in the promise and target basis types.  It is
reused by controlled arithmetic constructions and by compute/use/uncompute
proofs instead of re-proving promise restoration stage by stage.
-/

namespace QuantumBlockEncoding
namespace PromiseGateReversibleComposition

open PromiseGateOptimization

/-- Sequential composition of weak promise gates is weak.  `Equiv.trans` uses
chronological order: first `left`, then `right`. -/
theorem weak_trans
    {ρ α : Type*}
    (cleanPromise : ρ)
    (left right : Equiv.Perm (ρ × α))
    (leftTarget rightTarget : Equiv.Perm α)
    (leftWeak : WeakPromiseSpec cleanPromise left leftTarget)
    (rightWeak : WeakPromiseSpec cleanPromise right rightTarget) :
    WeakPromiseSpec cleanPromise
      (left.trans right)
      (leftTarget.trans rightTarget) := by
  intro value
  change right (left (cleanPromise, value)) = _
  rw [leftWeak value]
  rw [rightWeak (leftTarget value)]
  rfl

/-- Sequential composition of strong promise gates is strong. -/
theorem strong_trans
    {ρ α : Type*}
    (cleanPromise : ρ)
    (left right : Equiv.Perm (ρ × α))
    (leftTarget rightTarget : Equiv.Perm α)
    (leftStrong : StrongPromiseSpec cleanPromise left leftTarget)
    (rightStrong : StrongPromiseSpec cleanPromise right rightTarget) :
    StrongPromiseSpec cleanPromise
      (left.trans right)
      (leftTarget.trans rightTarget) := by
  constructor
  · exact weak_trans cleanPromise left right
      leftTarget rightTarget leftStrong.1 rightStrong.1
  · intro promise value
    let middle := left (promise, value)
    have leftRestore : middle.1 = promise :=
      leftStrong.2 promise value
    have rightRestore : (right middle).1 = middle.1 :=
      rightStrong.2 middle.1 middle.2
    exact rightRestore.trans leftRestore

/-- A finite chronological list of strong promise stages remains strong.  The
target list is folded in the same order. -/
theorem strong_three
    {ρ α : Type*}
    (cleanPromise : ρ)
    (stage1 stage2 stage3 : Equiv.Perm (ρ × α))
    (target1 target2 target3 : Equiv.Perm α)
    (strong1 : StrongPromiseSpec cleanPromise stage1 target1)
    (strong2 : StrongPromiseSpec cleanPromise stage2 target2)
    (strong3 : StrongPromiseSpec cleanPromise stage3 target3) :
    StrongPromiseSpec cleanPromise
      ((stage1.trans stage2).trans stage3)
      ((target1.trans target2).trans target3) := by
  exact strong_trans cleanPromise
    (stage1.trans stage2) stage3
    (target1.trans target2) target3
    (strong_trans cleanPromise stage1 stage2 target1 target2 strong1 strong2)
    strong3

/-- Composition preserves unconditional promise restoration even if the target
semantics of the dirty fibres are not tracked. -/
theorem restores_under_trans
    {ρ α : Type*}
    (left right : Equiv.Perm (ρ × α))
    (leftRestores : ∀ promise value, (left (promise, value)).1 = promise)
    (rightRestores : ∀ promise value, (right (promise, value)).1 = promise)
    (promise : ρ) (value : α) :
    ((left.trans right) (promise, value)).1 = promise := by
  let middle := left (promise, value)
  have first := leftRestores promise value
  have second := rightRestores middle.1 middle.2
  exact second.trans first

end PromiseGateReversibleComposition
end QuantumBlockEncoding
