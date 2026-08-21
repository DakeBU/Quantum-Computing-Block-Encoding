import QuantumBlockEncoding.ComparatorIncrementerEq39BasisCascade
import QuantumBlockEncoding.ComparatorIncrementerEq39SquareRootPlan
import QuantumBlockEncoding.ComparatorIncrementerLemma8TwoRoundSchedule

/-!
# Canonical block semantic certificate behind Vandaele Equation (42)

The source proof of Lemma 8 uses three facts simultaneously:

1. the square-root block cascade is the global n-bit successor (Equation 39);
2. whenever carry propagates from one block to the next, the already-incremented
   upper block is zero and can serve as the clean promise register (Equations
   40-42);
3. adjacent promise gates form a path and can be scheduled in two rounds.

Those facts were previously formalized in separate modules.  This file packages
them on the *same canonical square-root plan*.  It still does not claim a
low-depth gate implementation; the remaining Figure-10 refinement must realize
each local block action with the Lemma-7 circuit family.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8BlockCascadeCertificate

open ComparatorIncrementerEq39BasisCascade
open ComparatorIncrementerEq39BlockCascade
open ComparatorIncrementerEq39LocalActivation
open ComparatorIncrementerEq39SquareRootPlan
open ComparatorIncrementerLemma8Budget
open ComparatorIncrementerLemma8TwoRoundSchedule

/-- Canonical width stream used throughout the certificate. -/
abbrev Width (n : Nat) := canonicalWidth n

/-- Canonical heterogeneous block state. -/
abbrev State (n : Nat) := BlockBasisState (Width n)

/-- Exact whole-word successor statement for the canonical block state. -/
theorem global_successor (n : Nat) (state : State n) :
    basisBlockValue (Width n)
        (cascadeOutput (Width n) state) (blockSlots n) %
        ComparatorIncrementerGeneral.gridSize n =
      (basisBlockValue (Width n) state (blockSlots n) + 1) %
        ComparatorIncrementerGeneral.gridSize n := by
  exact canonicalSquareRoot_basisCascade_successor n state

/-- If carry propagates from block i to i+1, then block i's output is exactly
zero in its radix.  This is the arithmetic promise-cleanliness invariant used
when the next controlled increment is active. -/
theorem outgoingCarry_cleans_block
    (n : Nat) (state : State n) (i : Nat)
    (outgoing :
      blockCarry (Width n) (basisDigits (Width n) state) (i + 1) = 1) :
    basisDigit (Width n) (cascadeOutput (Width n) state) i = 0 := by
  let digits := basisDigits (Width n) state
  have digitBound : ∀ j, digits j < blockBase (Width n) j := by
    intro j
    exact basisDigit_lt_blockBase (Width n) state j
  have clean := nextCarry_implies_clean_current_block
    (Width n) digits digitBound i outgoing
  rw [cascadeOutput_digit]
  exact clean.2.2

/-- Same-round local promise gates in the canonical block chain have disjoint
promise/target register support. -/
theorem sameRound_disjoint
    (n : Nat)
    (left right : PromiseGateSlot (blockSlots n))
    (distinct : left ≠ right)
    (sameRound : round left = round right) :
    ∀ block : Fin (blockSlots n),
      ¬(Touches left block ∧ Touches right block) := by
  exact same_round_disjoint left right distinct sameRound

/-- Compact proof object carrying the source semantic/scheduling facts together. -/
structure Certificate (n : Nat) where
  successor : ∀ state : State n,
    basisBlockValue (Width n)
        (cascadeOutput (Width n) state) (blockSlots n) %
        ComparatorIncrementerGeneral.gridSize n =
      (basisBlockValue (Width n) state (blockSlots n) + 1) %
        ComparatorIncrementerGeneral.gridSize n
  carryCleans : ∀ state : State n, ∀ i,
    blockCarry (Width n) (basisDigits (Width n) state) (i + 1) = 1 →
      basisDigit (Width n) (cascadeOutput (Width n) state) i = 0
  roundDisjoint : ∀
    (left right : PromiseGateSlot (blockSlots n)),
    left ≠ right → round left = round right →
      ∀ block : Fin (blockSlots n),
        ¬(Touches left block ∧ Touches right block)

/-- Canonical Equation-(42) certificate for every n. -/
def canonicalCertificate (n : Nat) : Certificate n where
  successor := global_successor n
  carryCleans := outgoingCarry_cleans_block n
  roundDisjoint := sameRound_disjoint n

end ComparatorIncrementerLemma8BlockCascadeCertificate
end QuantumBlockEncoding
