import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Real input-wire borrowing for Vandaele Theorem 3

Theorem 3 does not merely compare workspace counts.  Equations (31)-(32) reuse
actual input qubits as dirty workspace for the two half-width groups of V2
operators.  This module makes those physical subregisters explicit.

The n input wires are split into a low floor-half and a high ceiling-half.  The
corresponding embeddings are injective, disjoint, and cover every input wire.
The product equivalence below is the register transport later gate-level V2
embeddings should reuse, rather than introducing ad-hoc Fin arithmetic.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorTheorem3BorrowedInput

open PrimitiveBasisRegisterSplit
open VandaeleLemma5SplitBudget

/-- Equality transport for dependent primitive-basis widths. -/
def basisWidthEquiv {a b : Nat} (equal : a = b) :
    PrimitiveBasis a ≃ PrimitiveBasis b := by
  subst b
  exact Equiv.refl _

/-- Low floor-half input wire. -/
def lowInputWire (n : Nat) (wire : Fin (lowerHalf n)) : Fin n :=
  ⟨wire.val, by
    have bound := wire.isLt
    unfold lowerHalf at bound
    have halfLe : n / 2 ≤ n := Nat.div_le_self n 2
    omega⟩

/-- High ceiling-half input wire. -/
def highInputWire (n : Nat) (wire : Fin (upperHalf n)) : Fin n :=
  ⟨lowerHalf n + wire.val, by
    have bound := wire.isLt
    have partition := halves_partition n
    omega⟩

@[simp] theorem lowInputWire_val
    (n : Nat) (wire : Fin (lowerHalf n)) :
    (lowInputWire n wire).val = wire.val := by
  rfl

@[simp] theorem highInputWire_val
    (n : Nat) (wire : Fin (upperHalf n)) :
    (highInputWire n wire).val = lowerHalf n + wire.val := by
  rfl

/-- Both physical embeddings are injective. -/
theorem lowInputWire_injective (n : Nat) :
    Function.Injective (lowInputWire n) := by
  intro left right equal
  apply Fin.ext
  exact congrArg Fin.val equal

theorem highInputWire_injective (n : Nat) :
    Function.Injective (highInputWire n) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simp only [highInputWire_val] at values
  omega

/-- Low and high borrowed subsets are disjoint. -/
theorem low_ne_high
    (n : Nat)
    (low : Fin (lowerHalf n))
    (high : Fin (upperHalf n)) :
    lowInputWire n low ≠ highInputWire n high := by
  intro equal
  have values := congrArg Fin.val equal
  simp only [lowInputWire_val, highInputWire_val] at values
  have lowBound := low.isLt
  omega

/-- Every input wire belongs to exactly one of the two borrowed subsets. -/
theorem inputWire_classification (n : Nat) (wire : Fin n) :
    (∃ low : Fin (lowerHalf n), lowInputWire n low = wire) ∨
    (∃ high : Fin (upperHalf n), highInputWire n high = wire) := by
  by_cases low : wire.val < lowerHalf n
  · left
    refine ⟨⟨wire.val, low⟩, ?_⟩
    apply Fin.ext
    rfl
  · right
    have lowerLe : lowerHalf n ≤ wire.val := by omega
    have highBound : wire.val - lowerHalf n < upperHalf n := by
      have partition := halves_partition n
      have wireBound := wire.isLt
      omega
    refine ⟨⟨wire.val - lowerHalf n, highBound⟩, ?_⟩
    apply Fin.ext
    simp [highInputWire]
    omega

/-- Canonical physical split of the n input wires into floor/ceiling halves. -/
def inputHalfEquiv (n : Nat) :
    PrimitiveBasis n ≃
      PrimitiveBasis (lowerHalf n) × PrimitiveBasis (upperHalf n) :=
  (basisWidthEquiv (halves_partition n).symm).trans
    (basisSplitEquiv (lowerHalf n) (upperHalf n))

/-- The low factor is exactly the low borrowed physical subset. -/
theorem inputHalfEquiv_low
    (n : Nat) (state : PrimitiveBasis n)
    (wire : Fin (lowerHalf n)) :
    (inputHalfEquiv n state).1 wire = state (lowInputWire n wire) := by
  rfl

/-- The high factor is exactly the high borrowed physical subset. -/
theorem inputHalfEquiv_high
    (n : Nat) (state : PrimitiveBasis n)
    (wire : Fin (upperHalf n)) :
    (inputHalfEquiv n state).2 wire = state (highInputWire n wire) := by
  rfl

/-- Source-facing borrowing package tied to actual wire maps. -/
structure BorrowedInputRegisterCertificate (n : Nat) where
  split : PrimitiveBasis n ≃
    PrimitiveBasis (lowerHalf n) × PrimitiveBasis (upperHalf n)
  lowEmbed : Fin (lowerHalf n) → Fin n
  highEmbed : Fin (upperHalf n) → Fin n
  lowInjective : Function.Injective lowEmbed
  highInjective : Function.Injective highEmbed
  disjoint : ∀ low high, lowEmbed low ≠ highEmbed high
  covers : ∀ wire : Fin n,
    (∃ low, lowEmbed low = wire) ∨ (∃ high, highEmbed high = wire)

/-- Canonical exact register certificate for Equations (31)-(32). -/
def canonicalBorrowedInputRegisterCertificate (n : Nat) :
    BorrowedInputRegisterCertificate n where
  split := inputHalfEquiv n
  lowEmbed := lowInputWire n
  highEmbed := highInputWire n
  lowInjective := lowInputWire_injective n
  highInjective := highInputWire_injective n
  disjoint := low_ne_high n
  covers := inputWire_classification n

end VandaeleComparatorTheorem3BorrowedInput
end QuantumBlockEncoding
