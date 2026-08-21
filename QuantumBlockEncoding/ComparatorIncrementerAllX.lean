import QuantumBlockEncoding.ComparatorIncrementerModularConjugation
import QuantumBlockEncoding.PrimitiveBasisLE
import QuantumBlockEncoding.ReversibleRegisterLift
import Mathlib.Tactic

/-!
# Arbitrary-width all-X complement semantics

Vandaele Eq. (35) uses X on every target-register wire.  The modular algebra
layer already proved that `x ↦ -x-1` conjugates successor into predecessor.
This module connects that arithmetic description to ASPBE's actual
little-endian computational basis for arbitrary width and then packages the
operation as a real `ReversibleProgram n`.

Flipping every basis bit sends the flat integer `x` to `2^n - 1 - x`.  The
recursive program below flips the new low wire once and reuses the generic
successor-register lift for the remaining wires.  The later controlled-fan-out
leaf will add the external controls and source-model resource accounting.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerAllX

open ReversibleRegisterLift

/-- Flip every wire of an n-qubit computational-basis state. -/
def allXBasisAction {n : Nat} (state : PrimitiveBasis n) : PrimitiveBasis n :=
  fun wire => flipBit (state wire)

@[simp] theorem allXBasisAction_apply {n : Nat}
    (state : PrimitiveBasis n) (wire : Fin n) :
    allXBasisAction state wire = flipBit (state wire) := by
  rfl

/-- All-X is self-inverse. -/
theorem allXBasisAction_involutive {n : Nat} :
    Function.Involutive (@allXBasisAction n) := by
  intro state
  funext wire
  simp [allXBasisAction]

/-- All-X as a basis permutation. -/
def allXBasisEquiv (n : Nat) : PrimitiveBasis n ≃ PrimitiveBasis n where
  toFun := allXBasisAction
  invFun := allXBasisAction
  left_inv := allXBasisAction_involutive
  right_inv := allXBasisAction_involutive

@[simp] theorem allXBasisEquiv_apply (n : Nat) (state : PrimitiveBasis n) :
    allXBasisEquiv n state = allXBasisAction state := by
  rfl

/-- Numeric effect of one flipped bit. -/
theorem flipBit_val_eq_one_sub (bit : Fin 2) :
    (flipBit bit).val = 1 - bit.val := by
  fin_cases bit <;> rfl

/-- Exact arbitrary-width little-endian complement identity.

This is the basis-level meaning of the all-X fan-out used in Vandaele
Eq. (35): `x ↦ (2^n-1)-x`. -/
theorem primitiveBasisLEEquiv_allX_value
    (n : Nat) (state : PrimitiveBasis n) :
    (primitiveBasisLEEquiv n (allXBasisAction state)).val =
      gridSize n - 1 - (primitiveBasisLEEquiv n state).val := by
  induction n generalizing state with
  | zero =>
      simp [allXBasisAction, gridSize, primitiveBasisLEEquiv_zero_apply]
  | succ n induction =>
      rw [primitiveBasisLEEquiv_succ_value,
        primitiveBasisLEEquiv_succ_value]
      have tailIdentity := induction (fun wire => state wire.succ)
      change
        (primitiveBasisLEEquiv n
            (fun wire => flipBit (state wire.succ))).val =
          gridSize n - 1 -
            (primitiveBasisLEEquiv n
              (fun wire => state wire.succ)).val at tailIdentity
      have tailBound :
          (primitiveBasisLEEquiv n
            (fun wire => state wire.succ)).val < gridSize n :=
        (primitiveBasisLEEquiv n (fun wire => state wire.succ)).isLt
      have bitBound : (state 0).val < 2 := (state 0).isLt
      have sizeSucc : gridSize (n + 1) = 2 * gridSize n := by
        simp [gridSize, pow_succ, Nat.mul_comm]
      rw [tailIdentity, flipBit_val_eq_one_sub, sizeSucc]
      omega

/-- Transport all-X to the flat little-endian finite-index representation. -/
def allXFlatEquiv (n : Nat) :
    Fin (gridSize n) ≃ Fin (gridSize n) :=
  (primitiveBasisLEEquiv n).symm.trans
    ((allXBasisEquiv n).trans (primitiveBasisLEEquiv n))

/-- Flat-index form of the same complement identity. -/
@[simp] theorem allXFlatEquiv_value
    (n : Nat) (index : Fin (gridSize n)) :
    (allXFlatEquiv n index).val = gridSize n - 1 - index.val := by
  have basisIdentity := primitiveBasisLEEquiv_allX_value n
    ((primitiveBasisLEEquiv n).symm index)
  simpa [allXFlatEquiv, allXBasisEquiv] using basisIdentity

/-- The transported all-X operation is still involutory. -/
theorem allXFlatEquiv_involutive (n : Nat) :
    Function.Involutive (allXFlatEquiv n) := by
  intro index
  apply Fin.ext
  simp only [allXFlatEquiv_value]
  have indexBound := index.isLt
  have sizePos : 0 < gridSize n := Nat.pow_pos (by decide)
  omega

/-! ## Gate-level reversible implementation -/

/-- One X on every wire.  The recursion deliberately reuses
`liftProgramSucc`: the new low wire is flipped locally and the old all-X
program is shifted onto the successor wires. -/
def allXReversibleProgram : (n : Nat) → ReversibleProgram n
  | 0 => []
  | n + 1 =>
      .x (0 : Fin (n + 1)) ::
        liftProgramSucc (allXReversibleProgram n)

/-- Exact basis action of the arbitrary-width reversible all-X program. -/
theorem allXReversibleProgram_action
    (n : Nat) (state : PrimitiveBasis n) :
    evalReversibleProgram (allXReversibleProgram n) state =
      allXBasisAction state := by
  induction n generalizing state with
  | zero =>
      funext wire
      exact Fin.elim0 wire
  | succ n induction =>
      change
        evalReversibleProgram
            (liftProgramSucc (allXReversibleProgram n))
            (xBasisAction (0 : Fin (n + 1)) state) =
          allXBasisAction state
      funext wire
      refine Fin.cases ?_ (fun tailWire => ?_) wire
      · calc
          (evalReversibleProgram
              (liftProgramSucc (allXReversibleProgram n))
              (xBasisAction (0 : Fin (n + 1)) state)) 0 =
              (xBasisAction (0 : Fin (n + 1)) state) 0 :=
            eval_liftProgramSucc_head
              (allXReversibleProgram n)
              (xBasisAction (0 : Fin (n + 1)) state)
          _ = flipBit (state 0) := by simp [xBasisAction]
          _ = allXBasisAction state 0 := by rfl
      · have tailLift := tailState_eval_liftProgramSucc
          (allXReversibleProgram n)
          (xBasisAction (0 : Fin (n + 1)) state)
        calc
          (evalReversibleProgram
              (liftProgramSucc (allXReversibleProgram n))
              (xBasisAction (0 : Fin (n + 1)) state)) tailWire.succ =
              tailState
                (evalReversibleProgram
                  (liftProgramSucc (allXReversibleProgram n))
                  (xBasisAction (0 : Fin (n + 1)) state)) tailWire := by
            rfl
          _ = evalReversibleProgram (allXReversibleProgram n)
                (tailState (xBasisAction (0 : Fin (n + 1)) state))
                tailWire := congrFun tailLift tailWire
          _ = allXBasisAction
                (tailState (xBasisAction (0 : Fin (n + 1)) state))
                tailWire := congrFun
                  (induction
                    (tailState (xBasisAction (0 : Fin (n + 1)) state)))
                  tailWire
          _ = allXBasisAction state tailWire.succ := by
            simp [allXBasisAction, tailState, xBasisAction]

/-- The recursive X-only program evaluates to the representation-level all-X
permutation, so the Eq. (35) conjugator is now connected to ASPBE's reversible
proof IR rather than remaining an abstract permutation. -/
theorem allXReversibleProgram_eval (n : Nat) :
    evalReversibleProgram (allXReversibleProgram n) = allXBasisEquiv n := by
  apply Equiv.ext
  intro state
  exact allXReversibleProgram_action n state

end ComparatorIncrementerAllX
end QuantumBlockEncoding
