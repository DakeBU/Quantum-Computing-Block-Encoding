import QuantumBlockEncoding.ComparatorIncrementerLemma7BasisContract
import QuantumBlockEncoding.PredicateControlledStrongPromise
import Mathlib.Tactic

/-!
# Source-faithful Figure-9 strong-promise assembly

Vandaele Figure 9 does **not** control every Gidney slice. The CCX ladders in
slices 1 and 3 remain uncontrolled; only the gates in slices 2 and 4 receive the
external control. This is the resource-saving consequence of the controlled
conjugation identity from Figure 3(a).

At the promise-gate level the required global proof can be isolated from the
still-open gate-level slice decomposition. Let the four clean-branch target
actions be `T1,T2,T3,T4`. It is sufficient that

* every stage restores the promise register for arbitrary incoming contents;
* `T1 ; T3 = I`, so the two uncontrolled slices cancel when the external
  control is inactive;
* `T1 ; T2 ; T3 ; T4 = target`, so the active branch implements the desired
  target unitary.

The theorem below proves exactly this statement. It is the source-faithful
semantic assembly that later Figure-9 slice refinements must inhabit.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Figure9SourceAssembly

open ComparatorIncrementerLemma7BasisContract
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma8Contract
open PredicateControlledStrongPromise
open PromiseGateOptimization

/-- Lift an uncontrolled strong-promise stage through an untouched external key
register. -/
def liftUncontrolledPromiseStage
    {κ ρ α : Type*} (stage : Equiv.Perm (ρ × α)) :
    Equiv.Perm (κ × ρ × α) :=
  Equiv.prodCongr (Equiv.refl κ) stage

@[simp] theorem liftUncontrolledPromiseStage_apply
    {κ ρ α : Type*} (stage : Equiv.Perm (ρ × α))
    (key : κ) (promise : ρ) (value : α) :
    liftUncontrolledPromiseStage stage (key, promise, value) =
      (key, stage (promise, value)) := by
  rfl

/-- On the designated clean branch, an uncontrolled strong-promise stage has
its declared target action for every external key. -/
theorem liftUncontrolled_clean_action
    {κ ρ α : Type*} (cleanPromise : ρ)
    (stage : Equiv.Perm (ρ × α)) (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise stage target)
    (key : κ) (value : α) :
    liftUncontrolledPromiseStage stage (key, cleanPromise, value) =
      (key, cleanPromise, target value) := by
  change (key, stage (cleanPromise, value)) =
    (key, cleanPromise, target value)
  rw [strong.1 value]

/-- Uncontrolled strong-promise stages preserve key and promise for every
incoming promise value. -/
theorem liftUncontrolled_restores
    {κ ρ α : Type*} (cleanPromise : ρ)
    (stage : Equiv.Perm (ρ × α)) (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise stage target)
    (key : κ) (promise : ρ) (value : α) :
    (liftUncontrolledPromiseStage stage
      (key, promise, value)).1 = key ∧
    (liftUncontrolledPromiseStage stage
      (key, promise, value)).2.1 = promise := by
  change key = key ∧ (stage (promise, value)).1 = promise
  exact ⟨rfl, strong.2 promise value⟩

/-- Common restoration predicate used to compose source stages independently of
their clean-branch target action. -/
def RestoresKeyPromise
    {κ ρ α : Type*} (implementation : Equiv.Perm (κ × ρ × α)) : Prop :=
  ∀ key promise value,
    (implementation (key, promise, value)).1 = key ∧
    (implementation (key, promise, value)).2.1 = promise

/-- Restoration is closed under chronological composition. -/
theorem RestoresKeyPromise.trans
    {κ ρ α : Type*}
    {left right : Equiv.Perm (κ × ρ × α)}
    (leftRestores : RestoresKeyPromise left)
    (rightRestores : RestoresKeyPromise right) :
    RestoresKeyPromise (left.trans right) := by
  intro key promise value
  let middle := left (key, promise, value)
  have leftFact := leftRestores key promise value
  have rightFact := rightRestores middle.1 middle.2.1 middle.2.2
  change
    (right middle).1 = key ∧
      (right middle).2.1 = promise
  constructor
  · calc
      (right middle).1 = middle.1 := rightFact.1
      _ = key := leftFact.1
  · calc
      (right middle).2.1 = middle.2.1 := rightFact.2
      _ = promise := leftFact.2

/-- Restoration component extracted from a predicate-controlled strong-promise
specification. -/
theorem restores_of_predicate_spec
    {κ ρ α : Type*} {active : κ → Bool} {cleanPromise : ρ}
    {implementation : Equiv.Perm (κ × ρ × α)} {target : Equiv.Perm α}
    (spec : PredicateControlledStrongPromiseSpec
      active cleanPromise implementation target) :
    RestoresKeyPromise implementation :=
  spec.2.2

/-- Exact source Figure-9 stage order: slices 1 and 3 are uncontrolled, while
slices 2 and 4 carry the external predicate control. -/
def figureNineSourceImplementation
    {κ ρ α : Type*}
    (stage1 : Equiv.Perm (ρ × α))
    (stage2 : Equiv.Perm (κ × ρ × α))
    (stage3 : Equiv.Perm (ρ × α))
    (stage4 : Equiv.Perm (κ × ρ × α)) :
    Equiv.Perm (κ × ρ × α) :=
  (((liftUncontrolledPromiseStage stage1).trans stage2).trans
      (liftUncontrolledPromiseStage stage3)).trans stage4

/-- Source-faithful Figure-9 assembly theorem. -/
theorem source_figureNine_strongPromise
    {κ ρ α : Type*}
    (active : κ → Bool) (cleanPromise : ρ)
    (stage1 : Equiv.Perm (ρ × α))
    (stage2 : Equiv.Perm (κ × ρ × α))
    (stage3 : Equiv.Perm (ρ × α))
    (stage4 : Equiv.Perm (κ × ρ × α))
    (target1 target2 target3 target4 finalTarget : Equiv.Perm α)
    (strong1 : StrongPromiseSpec cleanPromise stage1 target1)
    (strong3 : StrongPromiseSpec cleanPromise stage3 target3)
    (spec2 : PredicateControlledStrongPromiseSpec
      active cleanPromise stage2 target2)
    (spec4 : PredicateControlledStrongPromiseSpec
      active cleanPromise stage4 target4)
    (inactiveCancel : target1.trans target3 = Equiv.refl α)
    (activeWhole :
      (((target1.trans target2).trans target3).trans target4) = finalTarget) :
    PredicateControlledStrongPromiseSpec
      active cleanPromise
      (figureNineSourceImplementation stage1 stage2 stage3 stage4)
      finalTarget := by
  constructor
  · intro key value inactive
    unfold figureNineSourceImplementation
    simp only [Equiv.trans_apply]
    rw [liftUncontrolled_clean_action cleanPromise stage1 target1 strong1]
    rw [spec2.1 key (target1 value) inactive]
    rw [liftUncontrolled_clean_action cleanPromise stage3 target3 strong3]
    rw [spec4.1 key (target3 (target1 value)) inactive]
    have cancelPoint := Equiv.congr_fun inactiveCancel value
    change target3 (target1 value) = value at cancelPoint
    exact congrArg (fun output => (key, cleanPromise, output)) cancelPoint
  · constructor
    · intro key value enabled
      unfold figureNineSourceImplementation
      simp only [Equiv.trans_apply]
      rw [liftUncontrolled_clean_action cleanPromise stage1 target1 strong1]
      rw [spec2.2.1 key (target1 value) enabled]
      rw [liftUncontrolled_clean_action cleanPromise stage3 target3 strong3]
      rw [spec4.2.1 key (target3 (target2 (target1 value))) enabled]
      have wholePoint := Equiv.congr_fun activeWhole value
      change
        target4 (target3 (target2 (target1 value))) =
          finalTarget value at wholePoint
      exact congrArg (fun output => (key, cleanPromise, output)) wholePoint
    · have restore1 :
          RestoresKeyPromise
            (liftUncontrolledPromiseStage (κ := κ) stage1) := by
        intro key promise value
        exact liftUncontrolled_restores
          cleanPromise stage1 target1 strong1 key promise value
      have restore2 : RestoresKeyPromise stage2 :=
        restores_of_predicate_spec spec2
      have restore3 :
          RestoresKeyPromise
            (liftUncontrolledPromiseStage (κ := κ) stage3) := by
        intro key promise value
        exact liftUncontrolled_restores
          cleanPromise stage3 target3 strong3 key promise value
      have restore4 : RestoresKeyPromise stage4 :=
        restores_of_predicate_spec spec4
      have combined :=
        (((restore1.trans restore2).trans restore3).trans restore4)
      simpa [figureNineSourceImplementation] using combined

/-- Lemma-7 specialization: once the four source slice targets satisfy the two
Figure-9 target identities, the optimized slice pattern directly inhabits the
public basis-level k-controlled strong-promise incrementer contract. -/
theorem source_figureNine_inhabits_lemmaSevenBasisSpec
    (k n : Nat)
    (stage1 : Equiv.Perm
      (PrimitiveBasis (lemmaSevenPromiseWidth n) × PrimitiveBasis n))
    (stage2 : Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) × PrimitiveBasis n))
    (stage3 : Equiv.Perm
      (PrimitiveBasis (lemmaSevenPromiseWidth n) × PrimitiveBasis n))
    (stage4 : Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) × PrimitiveBasis n))
    (target1 target2 target3 target4 : Equiv.Perm (PrimitiveBasis n))
    (strong1 : StrongPromiseSpec
      (zeroPromiseBasis (lemmaSevenPromiseWidth n)) stage1 target1)
    (strong3 : StrongPromiseSpec
      (zeroPromiseBasis (lemmaSevenPromiseWidth n)) stage3 target3)
    (spec2 : PredicateControlledStrongPromiseSpec
      allControlsActive
      (zeroPromiseBasis (lemmaSevenPromiseWidth n)) stage2 target2)
    (spec4 : PredicateControlledStrongPromiseSpec
      allControlsActive
      (zeroPromiseBasis (lemmaSevenPromiseWidth n)) stage4 target4)
    (inactiveCancel : target1.trans target3 = Equiv.refl _)
    (activeWhole :
      (((target1.trans target2).trans target3).trans target4) =
        ZModPrimitiveBasisBridge.basisModularIncrementEquiv n) :
    LemmaSevenBasisSpec k n
      (figureNineSourceImplementation stage1 stage2 stage3 stage4) := by
  exact source_figureNine_strongPromise
    allControlsActive
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    stage1 stage2 stage3 stage4
    target1 target2 target3 target4
    (ZModPrimitiveBasisBridge.basisModularIncrementEquiv n)
    strong1 strong3 spec2 spec4 inactiveCancel activeWhole

end ComparatorIncrementerLemma7Figure9SourceAssembly
end QuantumBlockEncoding