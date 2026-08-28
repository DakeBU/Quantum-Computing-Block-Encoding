import QuantumBlockEncoding.PrimitiveBasisModularArithmetic
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Canonical quantum adder target used by Vandaele Corollary 3

The ripple-carry adder in Figure 4 preserves an n-bit register `a`, adds it into
an n-bit register `b`, and toggles a final carry bit `z`. A clean way to state
the reversible target is to regard `(b,z)` as one `(n+1)`-bit little-endian
register. For each fixed basis value of `a`, the target simply performs

`(b,z) -> (b,z) + value(a) mod 2^(n+1)`.

This automatically gives the usual low-n-bit sum and carry toggle while making
invertibility immediate. The target now depends only on pure primitive-basis
arithmetic and register splitting; comparator/incrementer circuit modules are
not part of this semantic layer. Corollary 3 still needs the Figure-4/Theorem-1
circuit realization and resource proof.
-/

namespace QuantumBlockEncoding
namespace VandaeleQuantumAdderTarget

open PrimitiveBasisModularArithmetic
open PrimitiveBasisRegisterSplit

/-- Product state with the second component holding `b` plus its carry bit. -/
abbrev QuantumAdderState (n : Nat) :=
  PrimitiveBasis n × PrimitiveBasis (n + 1)

/-- Fibrewise quantum adder: preserve `a`, add its value to the `(b,z)` word. -/
def quantumAdderEquiv (n : Nat) : Equiv.Perm (QuantumAdderState n) where
  toFun state :=
    (state.1,
      basisModularAddNatEquiv (n + 1) (basisNat n state.1) state.2)
  invFun state :=
    (state.1,
      (basisModularAddNatEquiv (n + 1) (basisNat n state.1)).symm state.2)
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
  exact basisModularAddNat_value (n + 1) (basisNat n state.1) state.2

/-- Split an `(n+1)`-bit payload into the low n-bit sum register and one carry
bit. -/
def payloadSplitEquiv (n : Nat) :
    PrimitiveBasis (n + 1) ≃ PrimitiveBasis n × PrimitiveBasis 1 :=
  basisSplitEquiv n 1

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
  change
    (primitiveBasisLEEquiv (n + 1) payload).val =
      (primitiveBasisLEEquiv n (payloadBZEquiv n payload).1).val +
        gridSize n * (payloadBZEquiv n payload).2.val
  have source := primitiveBasisLEEquiv_splitBasis_recomposition n 1 payload
  simpa [payloadBZEquiv, payloadSplitEquiv, oneBitEquiv] using source

/-- On a clean carry bit z=0, the low output register is the usual modular
n-bit sum. The proof uses the fact that two n-bit inputs sum to less than
`2^(n+1)`, so the combined `(b,z)` addition has no second carry beyond z. -/
theorem cleanCarry_low_sum
    (n : Nat) (a b : PrimitiveBasis n) :
    let cleanPayload := (payloadBZEquiv n).symm (b, 0)
    basisNat n
      (payloadBZEquiv n
        (quantumAdderEquiv n (a, cleanPayload)).2).1 =
      (basisNat n b + basisNat n a) % gridSize n := by
  dsimp
  let inputPayload := (payloadBZEquiv n).symm (b, 0)
  let outputPayload := (quantumAdderEquiv n (a, inputPayload)).2
  let outputLow := (payloadBZEquiv n outputPayload).1
  let outputCarry := (payloadBZEquiv n outputPayload).2
  have inputValue : basisNat (n + 1) inputPayload = basisNat n b := by
    have source := payloadBZ_value n inputPayload
    have coordinates : payloadBZEquiv n inputPayload = (b, 0) := by
      exact (payloadBZEquiv n).apply_symm_apply (b, 0)
    rw [coordinates] at source
    simpa using source
  have doubleSize : gridSize (n + 1) = 2 * gridSize n := by
    unfold gridSize
    rw [pow_succ]
    ring
  have aLt : basisNat n a < gridSize n :=
    (primitiveBasisLEEquiv n a).isLt
  have bLt : basisNat n b < gridSize n :=
    (primitiveBasisLEEquiv n b).isLt
  have sumLt : basisNat n b + basisNat n a < gridSize (n + 1) := by
    rw [doubleSize]
    omega
  have full := quantumAdder_payload_value n (a, inputPayload)
  change basisNat (n + 1) outputPayload =
      (basisNat (n + 1) inputPayload + basisNat n a) % gridSize (n + 1) at full
  rw [inputValue, Nat.mod_eq_of_lt sumLt] at full
  have splitValue := payloadBZ_value n outputPayload
  change basisNat (n + 1) outputPayload =
      basisNat n outputLow + gridSize n * outputCarry.val at splitValue
  have recomposed :
      basisNat n outputLow + gridSize n * outputCarry.val =
        basisNat n b + basisNat n a := by
    rw [← splitValue, full]
  have reduced := congrArg (fun value => value % gridSize n) recomposed
  change
    (basisNat n outputLow + gridSize n * outputCarry.val) % gridSize n =
      (basisNat n b + basisNat n a) % gridSize n at reduced
  have outputLowLt : basisNat n outputLow < gridSize n :=
    (primitiveBasisLEEquiv n outputLow).isLt
  rw [Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt outputLowLt] at reduced
  exact reduced

end VandaeleQuantumAdderTarget
end QuantumBlockEncoding
