import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Borrow one dirty qubit from a primitive promise register

Several reversible constructions require one unknown dirty workspace bit but
must restore the complete promise register.  `PrimitiveBasis q` stores qubits as
`Fin q → Fin 2`, while the reusable dirty-flag protocols use `Bool`.

This module gives a lossless shared transport:

`PrimitiveBasis q ≃ Bool × remainingPromiseWires`.

It then lifts any permutation on `(key, Bool, target)` to the full promise
register by applying the permutation only to the borrowed bit and leaving every
other promise wire untouched.  A generic restoration theorem turns restoration
of the borrowed Boolean flag into restoration of the entire original promise
register.

This infrastructure is independent of Vandaele and is intended for later
State Preparation / Block Encoding dirty-workspace constructions as well.
-/

namespace QuantumBlockEncoding
namespace PrimitivePromiseBorrow

/-- Explicit computational-basis equivalence between one primitive qubit and a
Boolean dirty flag. -/
def finTwoBoolEquiv : Fin 2 ≃ Bool where
  toFun bit := if bit = 0 then false else true
  invFun bit := if bit then 1 else 0
  left_inv bit := by
    fin_cases bit <;> rfl
  right_inv bit := by
    cases bit <;> rfl

@[simp] theorem finTwoBoolEquiv_zero : finTwoBoolEquiv 0 = false := by
  rfl

@[simp] theorem finTwoBoolEquiv_one : finTwoBoolEquiv 1 = true := by
  rfl

@[simp] theorem finTwoBoolEquiv_symm_false :
    finTwoBoolEquiv.symm false = 0 := by
  rfl

@[simp] theorem finTwoBoolEquiv_symm_true :
    finTwoBoolEquiv.symm true = 1 := by
  rfl

/-- Remaining promise-register wires after selecting one borrowed bit. -/
abbrev PromiseRemainder {qubits : Nat} (dirtyWire : Fin qubits) :=
  OtherPrimitiveWires dirtyWire → Fin 2

/-- Split one real primitive promise qubit into a Boolean dirty flag and all
remaining promise wires. -/
def borrowPromiseBitEquiv {qubits : Nat} (dirtyWire : Fin qubits) :
    PrimitiveBasis qubits ≃ Bool × PromiseRemainder dirtyWire :=
  (splitPrimitiveWire dirtyWire).trans
    (Equiv.prodCongr finTwoBoolEquiv (Equiv.refl _))

@[simp] theorem borrowPromiseBitEquiv_flag
    {qubits : Nat} (dirtyWire : Fin qubits)
    (promise : PrimitiveBasis qubits) :
    (borrowPromiseBitEquiv dirtyWire promise).1 =
      finTwoBoolEquiv (promise dirtyWire) := by
  rfl

@[simp] theorem borrowPromiseBitEquiv_remainder
    {qubits : Nat} (dirtyWire : Fin qubits)
    (promise : PrimitiveBasis qubits)
    (wire : OtherPrimitiveWires dirtyWire) :
    (borrowPromiseBitEquiv dirtyWire promise).2 wire = promise wire.1 := by
  rfl

/-- Reassociate a full `(key, promise, target)` state into the dirty-protocol
state plus untouched promise remainder. -/
def borrowedFlagStateEquiv
    {κ α : Type*} {qubits : Nat} (dirtyWire : Fin qubits) :
    (κ × PrimitiveBasis qubits × α) ≃
      ((κ × Bool × α) × PromiseRemainder dirtyWire) where
  toFun state :=
    let borrowed := borrowPromiseBitEquiv dirtyWire state.2.1
    ((state.1, borrowed.1, state.2.2), borrowed.2)
  invFun state :=
    (state.1.1,
      (borrowPromiseBitEquiv dirtyWire).symm
        (state.1.2.1, state.2),
      state.1.2.2)
  left_inv state := by
    rcases state with ⟨key, promise, target⟩
    simp [borrowedFlagStateEquiv]
  right_inv state := by
    rcases state with ⟨⟨key, flag, target⟩, remainder⟩
    simp [borrowedFlagStateEquiv]

/-- Lift a dirty-flag implementation to a complete promise register, preserving
all unborrowed promise wires by construction. -/
def liftBorrowedFlagImplementation
    {κ α : Type*} {qubits : Nat}
    (dirtyWire : Fin qubits)
    (implementation : Equiv.Perm (κ × Bool × α)) :
    Equiv.Perm (κ × PrimitiveBasis qubits × α) :=
  (borrowedFlagStateEquiv dirtyWire).trans
    ((Equiv.prodCongr implementation (Equiv.refl _)).trans
      (borrowedFlagStateEquiv dirtyWire).symm)

/-- Exact action after splitting the borrowed flag.  This is the convenient
normal form used by consumers. -/
theorem liftBorrowedFlagImplementation_action
    {κ α : Type*} {qubits : Nat}
    (dirtyWire : Fin qubits)
    (implementation : Equiv.Perm (κ × Bool × α))
    (key : κ) (promise : PrimitiveBasis qubits) (target : α) :
    let borrowed := borrowPromiseBitEquiv dirtyWire promise
    liftBorrowedFlagImplementation dirtyWire implementation
        (key, promise, target) =
      let output := implementation (key, borrowed.1, target)
      (output.1,
        (borrowPromiseBitEquiv dirtyWire).symm
          (output.2.1, borrowed.2),
        output.2.2) := by
  rfl

/-- Restoration of the one borrowed Boolean bit implies restoration of the
entire original primitive promise register, because the remainder never moved. -/
theorem liftBorrowedFlagImplementation_preserves_promise
    {κ α : Type*} {qubits : Nat}
    (dirtyWire : Fin qubits)
    (implementation : Equiv.Perm (κ × Bool × α))
    (restoresFlag : ∀ key flag target,
      (implementation (key, flag, target)).2.1 = flag)
    (key : κ) (promise : PrimitiveBasis qubits) (target : α) :
    (liftBorrowedFlagImplementation dirtyWire implementation
      (key, promise, target)).2.1 = promise := by
  rw [liftBorrowedFlagImplementation_action]
  let borrowed := borrowPromiseBitEquiv dirtyWire promise
  let output := implementation (key, borrowed.1, target)
  change
    (borrowPromiseBitEquiv dirtyWire).symm
        (output.2.1, borrowed.2) = promise
  have flagRestored : output.2.1 = borrowed.1 := by
    exact restoresFlag key borrowed.1 target
  rw [flagRestored]
  exact (borrowPromiseBitEquiv dirtyWire).symm_apply_apply promise

/-- The full-register lift preserves the external key whenever the underlying
dirty protocol does. -/
theorem liftBorrowedFlagImplementation_preserves_key
    {κ α : Type*} {qubits : Nat}
    (dirtyWire : Fin qubits)
    (implementation : Equiv.Perm (κ × Bool × α))
    (preservesKey : ∀ key flag target,
      (implementation (key, flag, target)).1 = key)
    (key : κ) (promise : PrimitiveBasis qubits) (target : α) :
    (liftBorrowedFlagImplementation dirtyWire implementation
      (key, promise, target)).1 = key := by
  rw [liftBorrowedFlagImplementation_action]
  exact preservesKey key (borrowPromiseBitEquiv dirtyWire promise).1 target

/-- Target action transports unchanged through the full promise-register lift. -/
theorem liftBorrowedFlagImplementation_target
    {κ α : Type*} {qubits : Nat}
    (dirtyWire : Fin qubits)
    (implementation : Equiv.Perm (κ × Bool × α))
    (key : κ) (promise : PrimitiveBasis qubits) (target : α) :
    (liftBorrowedFlagImplementation dirtyWire implementation
      (key, promise, target)).2.2 =
      (implementation
        (key, (borrowPromiseBitEquiv dirtyWire promise).1, target)).2.2 := by
  rw [liftBorrowedFlagImplementation_action]

end PrimitivePromiseBorrow
end QuantumBlockEncoding
