import QuantumBlockEncoding.ComparatorIncrementerLemma7Eq38DirtyProtocol
import QuantumBlockEncoding.PrimitivePromiseBorrow
import Mathlib.Tactic

/-!
# Embed the Equation-(38) dirty protocol in a complete promise register

The source Lemma 7 owns an `(n-1)`-qubit promise register, while Equation (36)
uses one unknown dirty bit.  `PrimitivePromiseBorrow` provides the lossless
register transport required to select one real promise wire, use it as the dirty
Boolean flag, and leave every other promise wire untouched.

This file lifts the full dirty Equation-(38) protocol through that transport.
The resulting implementation has a strong property needed by the source:

* the complete promise register is restored for **every** incoming promise
  basis state, not only on the all-zero branch;
* the low/high target action is independent of the borrowed bit and matches the
  already-proved whole-word controlled increment.

No gate count is attached here.  The eventual Figure-9 `ReversibleProgram` must
refine this semantic implementation while satisfying the separate Lemma-7
resource closure.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7PromiseEmbedding

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7Eq38Bridge
open ComparatorIncrementerLemma7Eq38DirtyProtocol
open PrimitiveBasisRegisterSplit
open PrimitivePromiseBorrow
open ZModPrimitiveBasisBridge

/-- Structured state used before flattening the target register:
`(controls, low)`, full promise register, high. -/
abbrev Eq38PromiseState
    (k promiseWidth low high : Nat) :=
  (PrimitiveBasis k × PrimitiveBasis low) ×
    PrimitiveBasis promiseWidth × PrimitiveBasis high

/-- Lift the dirty Equation-(38) protocol to one selected promise-register wire. -/
def eq38BorrowedPromiseEquiv
    (k promiseWidth low high : Nat)
    (dirtyWire : Fin promiseWidth) :
    Equiv.Perm (Eq38PromiseState k promiseWidth low high) :=
  liftBorrowedFlagImplementation dirtyWire
    (eq38DirtyProtocolEquiv k low high)

/-- Complete promise-register restoration follows solely from restoration of the
borrowed dirty bit; all unborrowed promise wires are untouched by construction. -/
theorem eq38BorrowedPromise_restores_promise
    (k promiseWidth low high : Nat)
    (dirtyWire : Fin promiseWidth)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (promise : PrimitiveBasis promiseWidth)
    (highState : PrimitiveBasis high) :
    (eq38BorrowedPromiseEquiv k promiseWidth low high dirtyWire
      ((controls, lowState), promise, highState)).2.1 = promise := by
  apply liftBorrowedFlagImplementation_preserves_promise
  intro key flag target
  rcases key with ⟨externalControls, lowInput⟩
  exact eq38DirtyProtocol_restores_dirty
    k low high externalControls lowInput flag target

/-- Exact full-register action.  The promise register appears unchanged on the
right-hand side even though one of its physical bits supplied the dirty flag. -/
theorem eq38BorrowedPromise_action
    (k promiseWidth low high : Nat)
    (dirtyWire : Fin promiseWidth)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (promise : PrimitiveBasis promiseWidth)
    (highState : PrimitiveBasis high) :
    eq38BorrowedPromiseEquiv k promiseWidth low high dirtyWire
        ((controls, lowState), promise, highState) =
      if allControlsActive controls = true then
        ((controls, basisModularIncrementEquiv low lowState),
          promise,
          if allControlsActive lowState = true then
            basisModularIncrementEquiv high highState
          else highState)
      else
        ((controls, lowState), promise, highState) := by
  rw [liftBorrowedFlagImplementation_action]
  let borrowed := borrowPromiseBitEquiv dirtyWire promise
  have dirtyAction := eq38DirtyProtocol_action
    k low high controls lowState borrowed.1 highState
  rw [dirtyAction]
  by_cases external : allControlsActive controls = true
  · rw [if_pos external]
    by_cases carry : allControlsActive lowState = true
    · rw [if_pos carry]
      simp [borrowed]
    · rw [if_neg carry]
      simp [borrowed]
  · rw [if_neg external]
    simp [borrowed]

/-- External controls are preserved by the full promise-register lift. -/
theorem eq38BorrowedPromise_preserves_controls
    (k promiseWidth low high : Nat)
    (dirtyWire : Fin promiseWidth)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (promise : PrimitiveBasis promiseWidth)
    (highState : PrimitiveBasis high) :
    (eq38BorrowedPromiseEquiv k promiseWidth low high dirtyWire
      ((controls, lowState), promise, highState)).1.1 = controls := by
  rw [eq38BorrowedPromise_action]
  split <;> rfl

/-- The target low/high pair induced by the full promise-register lift is
exactly the same pair as the raw dirty protocol, regardless of the promise
contents. -/
theorem eq38BorrowedPromise_targets_match_dirty
    (k promiseWidth low high : Nat)
    (dirtyWire : Fin promiseWidth)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (promise : PrimitiveBasis promiseWidth)
    (highState : PrimitiveBasis high) :
    let promiseOutput :=
      eq38BorrowedPromiseEquiv k promiseWidth low high dirtyWire
        ((controls, lowState), promise, highState)
    let dirty := (borrowPromiseBitEquiv dirtyWire promise).1
    let dirtyOutput :=
      eq38DirtyProtocolEquiv k low high
        ((controls, lowState), dirty, highState)
    (promiseOutput.1.2, promiseOutput.2.2) =
      (dirtyOutput.1.2, dirtyOutput.2.2) := by
  dsimp
  rw [eq38BorrowedPromise_action, eq38DirtyProtocol_action]
  by_cases external : allControlsActive controls = true <;>
    simp [external]

/-- Recombining the target registers yields the public whole-word controlled
increment, for arbitrary incoming promise contents. -/
theorem eq38BorrowedPromise_matches_wholeWord
    (k promiseWidth low high : Nat)
    (dirtyWire : Fin promiseWidth)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis low)
    (promise : PrimitiveBasis promiseWidth)
    (highState : PrimitiveBasis high) :
    let output :=
      eq38BorrowedPromiseEquiv k promiseWidth low high dirtyWire
        ((controls, lowState), promise, highState)
    combineBasis low high (output.1.2, output.2.2) =
      (wholeWordControlledIncrementEquiv k low high
        (controls, combineBasis low high (lowState, highState))).2 := by
  dsimp
  let dirty := (borrowPromiseBitEquiv dirtyWire promise).1
  have targets := eq38BorrowedPromise_targets_match_dirty
    k promiseWidth low high dirtyWire
    controls lowState promise highState
  rw [targets]
  exact eq38DirtyProtocol_matches_wholeWord
    k low high controls lowState dirty highState

/-- Source half-width specialization, still with an arbitrary complete promise
register and an explicitly selected borrowed wire. -/
theorem eq38BorrowedHalfSplit_matches_semantic_target
    (k promiseWidth n : Nat)
    (dirtyWire : Fin promiseWidth)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis (eq38LowWidth n))
    (promise : PrimitiveBasis promiseWidth)
    (highState : PrimitiveBasis (eq38HighWidth n)) :
    let output :=
      eq38BorrowedPromiseEquiv
        k promiseWidth (eq38LowWidth n) (eq38HighWidth n) dirtyWire
        ((controls, lowState), promise, highState)
    combineBasis (eq38LowWidth n) (eq38HighWidth n)
        (output.1.2, output.2.2) =
      (eq38SemanticEquiv k n
        (controls,
          combineBasis (eq38LowWidth n) (eq38HighWidth n)
            (lowState, highState))).2 := by
  simpa [eq38SemanticEquiv, wholeWordControlledIncrementEquiv] using
    (eq38BorrowedPromise_matches_wholeWord
      k promiseWidth (eq38LowWidth n) (eq38HighWidth n)
      dirtyWire controls lowState promise highState)

end ComparatorIncrementerLemma7PromiseEmbedding
end QuantumBlockEncoding
