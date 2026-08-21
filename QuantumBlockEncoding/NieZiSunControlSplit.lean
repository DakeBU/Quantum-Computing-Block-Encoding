import QuantumBlockEncoding.NieZiSunFigure3Resource
import Mathlib.Tactic

/-!
# Register split for the Nie--Zi--Sun Figure-3 recursion

The source draws the even-n case and states that odd n is identical.  We make
that statement concrete.  For every n>=4 we reserve physical wires 0..3 as the
four conditional-clean head controls, then split the remaining n-4 controls as

`left = floor((n-4)/2)`, `right = (n-4)-left`.

This module constructs the exact computational-basis equivalence

`PrimitiveBasis n ~= Head4 × PrimitiveBasis left × PrimitiveBasis right`.

No padding qubit or hidden control is introduced, so the odd-width case really
uses the original n controls.
-/

namespace QuantumBlockEncoding
namespace NieZiSunControlSplit

open NieZiSunFigure3Protocol
open NieZiSunFigure3Resource

/-- Head wire i is physical wire i. -/
def headWire
    (n : Nat) (large : 4 ≤ n) (i : Fin 4) : Fin n :=
  ⟨i.val, by omega⟩

/-- Left-tail wire. -/
def leftWire
    (n : Nat) (large : 4 ≤ n)
    (i : Fin (leftTailWidth n)) : Fin n :=
  ⟨4 + i.val, by
    have hi := i.isLt
    unfold leftTailWidth at hi
    omega⟩

/-- Right-tail wire. -/
def rightWire
    (n : Nat) (large : 4 ≤ n)
    (i : Fin (rightTailWidth n)) : Fin n :=
  ⟨4 + leftTailWidth n + i.val, by
    have hi := i.isLt
    unfold rightTailWidth at hi
    omega⟩

/-- Physical ranges are pairwise disjoint. -/
theorem head_ne_left
    (n : Nat) (large : 4 ≤ n)
    (h : Fin 4) (l : Fin (leftTailWidth n)) :
    headWire n large h ≠ leftWire n large l := by
  intro equal
  have values := congrArg Fin.val equal
  simp [headWire, leftWire] at values
  omega

theorem head_ne_right
    (n : Nat) (large : 4 ≤ n)
    (h : Fin 4) (r : Fin (rightTailWidth n)) :
    headWire n large h ≠ rightWire n large r := by
  intro equal
  have values := congrArg Fin.val equal
  simp [headWire, rightWire] at values
  omega

theorem left_ne_right
    (n : Nat) (large : 4 ≤ n)
    (l : Fin (leftTailWidth n)) (r : Fin (rightTailWidth n)) :
    leftWire n large l ≠ rightWire n large r := by
  intro equal
  have values := congrArg Fin.val equal
  simp [leftWire, rightWire] at values
  have hl := l.isLt
  omega

/-- Every physical control wire belongs to exactly one of the three regions. -/
theorem wire_region
    (n : Nat) (large : 4 ≤ n) (wire : Fin n) :
    wire.val < 4 ∨
      (4 ≤ wire.val ∧ wire.val < 4 + leftTailWidth n) ∨
      4 + leftTailWidth n ≤ wire.val := by
  omega

/-- Split a physical basis into head/left/right coordinates. -/
def splitControls
    (n : Nat) (large : 4 ≤ n) :
    PrimitiveBasis n ≃
      Head4 × PrimitiveBasis (leftTailWidth n) × PrimitiveBasis (rightTailWidth n) where
  toFun state :=
    ((fun i => state (headWire n large i)),
      (fun i => state (leftWire n large i)),
      (fun i => state (rightWire n large i)))
  invFun parts wire :=
    if head : wire.val < 4 then
      parts.1 ⟨wire.val, head⟩
    else if left : wire.val < 4 + leftTailWidth n then
      parts.2.1 ⟨wire.val - 4, by omega⟩
    else
      parts.2.2 ⟨wire.val - 4 - leftTailWidth n, by
        have wireLt := wire.isLt
        unfold rightTailWidth
        omega⟩
  left_inv state := by
    funext wire
    by_cases head : wire.val < 4
    · simp [head, headWire]
    · by_cases left : wire.val < 4 + leftTailWidth n
      · have lower : 4 ≤ wire.val := by omega
        let index : Fin (leftTailWidth n) := ⟨wire.val - 4, by omega⟩
        have wireEq : leftWire n large index = wire := by
          apply Fin.ext
          simp [leftWire, index]
          omega
        simp [head, left, index, wireEq]
      · have lower : 4 + leftTailWidth n ≤ wire.val := by omega
        let index : Fin (rightTailWidth n) :=
          ⟨wire.val - 4 - leftTailWidth n, by
            have wireLt := wire.isLt
            unfold rightTailWidth
            omega⟩
        have wireEq : rightWire n large index = wire := by
          apply Fin.ext
          simp [rightWire, index]
          omega
        simp [head, left, index, wireEq]
  right_inv parts := by
    rcases parts with ⟨headPart,leftPart,rightPart⟩
    apply Prod.ext
    · funext i
      simp [headWire]
    · apply Prod.ext
      · funext i
        have notHead : ¬ (leftWire n large i).val < 4 := by
          simp [leftWire]
        have isLeft : (leftWire n large i).val < 4 + leftTailWidth n := by
          have hi := i.isLt
          simp [leftWire]
          omega
        simp [leftWire, notHead, isLeft]
      · funext i
        have notHead : ¬ (rightWire n large i).val < 4 := by
          simp [rightWire]
        have notLeft : ¬ (rightWire n large i).val < 4 + leftTailWidth n := by
          simp [rightWire]
        simp [rightWire, notHead, notLeft]

/-- Reader-facing control-width identity. -/
theorem widths_recompose
    {n : Nat} (large : 4 ≤ n) :
    4 + leftTailWidth n + rightTailWidth n = n := by
  unfold leftTailWidth rightTailWidth
  omega

/-- The larger tail is exactly the common recurrence envelope from the resource
analysis. -/
theorem max_tail_eq_recursive
    {n : Nat} (large : 4 ≤ n) :
    max (leftTailWidth n) (rightTailWidth n) = recursiveWidth n := by
  unfold leftTailWidth rightTailWidth recursiveWidth
  omega

end NieZiSunControlSplit
end QuantumBlockEncoding
