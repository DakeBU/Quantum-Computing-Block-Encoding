import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Local carry algebra for the Takahashi adder behind Vandaele Figure 4

The Takahashi--Tani--Kunihiro ancilla-free adder does not store a separate
carry register.  Its forward sweep temporarily rewrites `A_i` so that a
Toffoli with controls `A_i XOR B_i` and `A_i XOR c_i` produces the next carry.
The elementary Boolean identity is

`c_{i+1} = a_i XOR ((a_i XOR b_i) AND (a_i XOR c_i))`,

which is the majority bit of `(a_i,b_i,c_i)`.  The final sum bit is

`s_i = a_i XOR b_i XOR c_i`.

This module proves those local identities independently of the eleven-wire
circuit representation.  The finite checks are only two-, three-, or four-bit
truth tables; the final five-bit certificate evaluates scalar bit arithmetic,
not function-valued reversible equivalences.  A downstream refinement module
uses these lemmas to prove the six source-program steps locally.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4TakahashiCarryAlgebra

/-- XOR expressed with the primitive computational-basis bit operation. -/
def xorBit (left right : Fin 2) : Fin 2 :=
  if left = 0 then right else flipBit right

/-- Boolean conjunction as a computational-basis bit. -/
def andBit (left right : Fin 2) : Fin 2 :=
  if left = 1 ∧ right = 1 then 1 else 0

/-- Carry recurrence in exactly the Boolean form exposed by the TTK forward
Toffoli sweep. -/
def carryNext (a b carry : Fin 2) : Fin 2 :=
  xorBit a (andBit (xorBit a b) (xorBit a carry))

/-- Ordinary full-adder sum bit. -/
def sumBit (a b carry : Fin 2) : Fin 2 :=
  xorBit a (xorBit b carry)

@[simp] theorem xorBit_value (left right : Fin 2) :
    (xorBit left right).val = (left.val + right.val) % 2 := by
  fin_cases left <;> fin_cases right <;> native_decide

@[simp] theorem andBit_value (left right : Fin 2) :
    (andBit left right).val = left.val * right.val := by
  fin_cases left <;> fin_cases right <;> native_decide

@[simp] theorem xorBit_zero_left (bit : Fin 2) :
    xorBit 0 bit = bit := by
  fin_cases bit <;> rfl

@[simp] theorem xorBit_zero_right (bit : Fin 2) :
    xorBit bit 0 = bit := by
  fin_cases bit <;> rfl

@[simp] theorem xorBit_self (bit : Fin 2) :
    xorBit bit bit = 0 := by
  fin_cases bit <;> rfl

@[simp] theorem xorBit_comm (left right : Fin 2) :
    xorBit left right = xorBit right left := by
  fin_cases left <;> fin_cases right <;> rfl

@[simp] theorem xorBit_assoc (a b c : Fin 2) :
    xorBit (xorBit a b) c = xorBit a (xorBit b c) := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> rfl

@[simp] theorem andBit_comm (left right : Fin 2) :
    andBit left right = andBit right left := by
  fin_cases left <;> fin_cases right <;> rfl

/-- Cancellation in the syntactic orientation produced by a CNOT ladder. -/
@[simp] theorem xorBit_cancel_left (a b : Fin 2) :
    xorBit a (xorBit a b) = b := by
  fin_cases a <;> fin_cases b <;> rfl

/-- Cancellation when the repeated bit is separated by one XOR term. -/
@[simp] theorem xorBit_cancel_middle (a b c : Fin 2) :
    xorBit a (xorBit b (xorBit a c)) = xorBit b c := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> rfl

/-- The TTK carry formula is exactly the majority bit. -/
theorem carryNext_value (a b carry : Fin 2) :
    (carryNext a b carry).val =
      (a.val + b.val + carry.val) / 2 := by
  fin_cases a <;> fin_cases b <;> fin_cases carry <;> native_decide

/-- Local full-adder conservation law: one sum bit plus twice the carry equals
the integer sum of the three input bits. -/
theorem sumBit_add_twice_carryNext (a b carry : Fin 2) :
    (sumBit a b carry).val + 2 * (carryNext a b carry).val =
      a.val + b.val + carry.val := by
  fin_cases a <;> fin_cases b <;> fin_cases carry <;> native_decide

/-- Forward TTK Toffoli identity.  Before the gate the next `A` wire contains
`next XOR a`; toggling it by `(a XOR b) AND (a XOR carry)` replaces the `a`
contribution by the newly computed carry. -/
theorem forwardCarry_identity (a b carry next : Fin 2) :
    xorBit
        (andBit (xorBit a b) (xorBit a carry))
        (xorBit a next) =
      xorBit (carryNext a b carry) next := by
  fin_cases a <;> fin_cases b <;> fin_cases carry <;>
    fin_cases next <;> rfl

/-- Same carry step in the nested XOR orientation produced by symbolic
execution of the source gate list. -/
@[simp] theorem forwardCarry_nested (a b carry next : Fin 2) :
    xorBit a
        (xorBit next (andBit (xorBit a b) (xorBit a carry))) =
      xorBit next (carryNext a b carry) := by
  fin_cases a <;> fin_cases b <;> fin_cases carry <;>
    fin_cases next <;> rfl

/-- Repeating the same Toffoli after the higher carry has been consumed removes
that temporary carry contribution.  This is the local algebraic heart of the
TTK descending uncompute sweep. -/
theorem uncomputeCarry_identity (a b carry next : Fin 2) :
    xorBit
        (andBit (xorBit a b) (xorBit a carry))
        (xorBit (carryNext a b carry) next) =
      xorBit a next := by
  fin_cases a <;> fin_cases b <;> fin_cases carry <;>
    fin_cases next <;> rfl

/-- Same uncompute identity with the carry and `next` terms reversed. -/
@[simp] theorem uncomputeCarry_reordered (a b carry next : Fin 2) :
    xorBit
        (andBit (xorBit a b) (xorBit a carry))
        (xorBit next (carryNext a b carry)) =
      xorBit a next := by
  fin_cases a <;> fin_cases b <;> fin_cases carry <;>
    fin_cases next <;> rfl

/-- Five little-endian bits interpreted as an unsigned natural number. -/
def fiveValue (x0 x1 x2 x3 x4 : Fin 2) : Nat :=
  x0.val + 2 * x1.val + 4 * x2.val + 8 * x3.val + 16 * x4.val

/-- Carry entering bit one. -/
def c1 (a0 b0 : Fin 2) : Fin 2 :=
  carryNext a0 b0 0

/-- Carry entering bit two. -/
def c2 (a0 b0 a1 b1 : Fin 2) : Fin 2 :=
  carryNext a1 b1 (c1 a0 b0)

/-- Carry entering bit three. -/
def c3 (a0 b0 a1 b1 a2 b2 : Fin 2) : Fin 2 :=
  carryNext a2 b2 (c2 a0 b0 a1 b1)

/-- Carry entering bit four. -/
def c4 (a0 b0 a1 b1 a2 b2 a3 b3 : Fin 2) : Fin 2 :=
  carryNext a3 b3 (c3 a0 b0 a1 b1 a2 b2)

/-- Outgoing carry of the five-bit addition. -/
def c5 (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Fin 2) : Fin 2 :=
  carryNext a4 b4 (c4 a0 b0 a1 b1 a2 b2 a3 b3)

/-- Least-significant output sum bit. -/
def s0 (a0 b0 : Fin 2) : Fin 2 :=
  sumBit a0 b0 0

/-- Output sum bit one. -/
def s1 (a0 b0 a1 b1 : Fin 2) : Fin 2 :=
  sumBit a1 b1 (c1 a0 b0)

/-- Output sum bit two. -/
def s2 (a0 b0 a1 b1 a2 b2 : Fin 2) : Fin 2 :=
  sumBit a2 b2 (c2 a0 b0 a1 b1)

/-- Output sum bit three. -/
def s3 (a0 b0 a1 b1 a2 b2 a3 b3 : Fin 2) : Fin 2 :=
  sumBit a3 b3 (c3 a0 b0 a1 b1 a2 b2)

/-- Most-significant output sum bit. -/
def s4 (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Fin 2) : Fin 2 :=
  sumBit a4 b4 (c4 a0 b0 a1 b1 a2 b2 a3 b3)

/-- Pure arithmetic certificate for the five-bit instance used in Vandaele
Figure 4.  This theorem is intentionally independent of the gate evaluator:
it says exactly what the local carry recurrence means arithmetically. -/
theorem fiveBit_arithmetic_certificate
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 : Fin 2) :
    let a := fiveValue a0 a1 a2 a3 a4
    let b := fiveValue b0 b1 b2 b3 b4
    let low := fiveValue
      (s0 a0 b0)
      (s1 a0 b0 a1 b1)
      (s2 a0 b0 a1 b1 a2 b2)
      (s3 a0 b0 a1 b1 a2 b2 a3 b3)
      (s4 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4)
    low = (a + b) % 32 ∧
      (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4).val = (a + b) / 32 := by
  native_decide +revert

end VandaeleFigure4TakahashiCarryAlgebra
end QuantumBlockEncoding
