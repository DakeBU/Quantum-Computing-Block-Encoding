import QuantumBlockEncoding.ComparatorIncrementerGeneral
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.VandaeleClassicalAdderTarget
import Mathlib.Tactic

/-!
# Canonical quantum adder target used by Vandaele Corollary 3

The ripple-carry adder in Figure 4 preserves an n-bit register `a`, adds it into
an n-bit register `b`, and toggles a final carry bit `z`.  A clean way to state
the reversible target is to regard `(b,z)` as one `(n+1)`-bit little-endian
register.  For each fixed basis value of `a`, the target simply performs

`(b,z) -> (b,z) + value(a) mod 2^(n+1)`.

This automatically gives the usual low-n-bit sum and carry toggle while making
invertibility immediate.  The construction is a semantic target; Corollary 3
still needs the Figure-4/Theorem-1 circuit realization and resource proof.
-/

namespace QuantumBlockEncoding
namespace VandaeleQuantumAdderTarget

open ComparatorIncrementerGeneral
open PrimitiveBasisRegisterSplit
open VandaeleClassicalAdderTarget

/-- Product state with the second component holding `b` plus its carry bit. -/
abbrev QuantumAdderState (n : Nat) :=
  PrimitiveBasis n × PrimitiveBasis (n + 1)

/-- Fibrewise quantum adder: preserve `a`, add its value to the `(b,z)` word. -/
def quantumAdderEquiv (n : Nat) : Equiv.Perm (QuantumAdderState n) where
  toFun state :=
    (state.1,
      basisModularAddEquiv (n + 1) (basisNat n state.1) state.2)
  invFun state :=
    (state.1,
      (basisModularAddEquiv (n + 1) (basisNat n state.1)).symm state.2)
  left_inv state := by
    rcases state with ⟨a,payload⟩
    simp
  right_inv state := by
    rcases state with ⟨a,payload⟩
    simp

/-- The source addend register is preserved exactly. -/
@[simp] theorem quantumAdder_preserves_a
    (n : Nat) (state : QuantumAdderState n) :
    (quantumAdderEquiv n state).1 = state.1 := by
  rfl

/-- Integer action on the `(b,z)` register. -/
theorem quantumAdder_payload_value
    (n : Nat) (state : QuantumAdderState n) :
    basisNat (n + 1) (quantumAdderEquiv n state).2 =
      (basisNat (n + 1) state.2 + basisNat n state.1) % gridSize (n + 1) := by
  exact basisModularAdd_spec (n + 1) (basisNat n state.1) state.2

/-- Split an `(n+1)`-bit payload into the low n-bit sum register and one carry
bit. -/
def payloadSplitEquiv (n : Nat) :
    PrimitiveBasis (n + 1) ≃ PrimitiveBasis n × PrimitiveBasis 1 := by
  simpa [Nat.add_comm] using basisSplitEquiv n 1

/-- Canonical one-bit register embedding/extraction. -/
def oneBitEquiv : PrimitiveBasis 1 ≃ Fin 2 where
  toFun state := state ⟨0, by decide⟩
  invFun bit := fun _ => bit
  left_inv state := by
    funext wire
    fin_cases wire
    rfl
  right_inv bit := by
    rfl

/-- Reader-facing `(b,z)` coordinates. -/
def payloadBZEquiv (n : Nat) :
    PrimitiveBasis (n + 1) ≃ PrimitiveBasis n × Fin 2 :=
  (payloadSplitEquiv n).trans
    (Equiv.prodCongr (Equiv.refl (PrimitiveBasis n)) oneBitEquiv)

/-- Value of a `(b,z)` payload is `b + 2^n z`. -/
theorem payloadBZ_value
    (n : Nat) (payload : PrimitiveBasis (n + 1)) :
    basisNat (n + 1) payload =
      basisNat n (payloadBZEquiv n payload).1 +
        gridSize n * (payloadBZEquiv n payload).2.val := by
  unfold basisNat payloadBZEquiv payloadSplitEquiv oneBitEquiv
  simpa [Nat.add_comm] using
    primitiveBasisLEEquiv_splitBasis_recomposition n 1 payload

/-- On a clean carry bit z=0, the low output register is the usual modular
n-bit sum. -/
theorem cleanCarry_low_sum
    (n : Nat) (a b : PrimitiveBasis n) :
    let cleanPayload := (payloadBZEquiv n).symm (b, 0)
    basisNat n
      (payloadBZEquiv n
        (quantumAdderEquiv n (a, cleanPayload)).2).1 =
      (basisNat n b + basisNat n a) % gridSize n := by
  dsimp
  have full := quantumAdder_payload_value n
    (a, (payloadBZEquiv n).symm (b, 0))
  have splitValue := payloadBZ_value n
    (quantumAdderEquiv n
      (a, (payloadBZEquiv n).symm (b, 0))).2
  have inputValue := payloadBZ_value n ((payloadBZEquiv n).symm (b, 0))
  simp at inputValue
  rw [inputValue] at full
  have lowMod := congrArg (fun value => value % gridSize n) full
  rw [splitValue] at lowMod
  have sizePos : 0 < gridSize n := Nat.pow_pos (by decide)
  have doubleSize : gridSize (n + 1) = 2 * gridSize n := by
    unfold gridSize
    rw [pow_succ]
    ring
  rw [doubleSize] at lowMod
  simpa [Nat.add_mod, Nat.mul_mod] using lowMod

end VandaeleQuantumAdderTarget
end QuantumBlockEncoding
