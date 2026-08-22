import QuantumBlockEncoding.RemaudVandaeleAlphaGap
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankArithmetic
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveOrder
import Mathlib.Tactic

/-!
# Algorithm 2: alpha-prime is strictly increasing

The recursive source-index map is strictly increasing.  Every source index on
the *left* of a recursive comparison is ordinary (the special tail, when it
exists, is final), hence even.  For an even a<b,

  floor(b/2)-floor(a/2) < b-a.

Thus physical alpha growth dominates the number of deleted odd targets even in
the even-k special transition, where the final source-index gap can be exactly
one.  This is the correct uniform argument; no false two-index-gap assumption is
made.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaPrimeStrict

open RemaudVandaeleAlphaGap
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankArithmetic
open RemaudVandaeleLadderAlphaRecursiveOrder
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

/-- A recursive target which has a later recursive target cannot be the special
final tail. -/
theorem earlier_recursive_target_not_special
    (m : Nat) (large : 3 ≤ m + 1)
    {i j : Fin (recursiveTargetCount m)} (order : i < j) :
    ¬ isSpecialTail m i := by
  intro special
  have iLast := special.2
  have jLt := j.isLt
  omega

/-- Therefore every source index appearing on the left of a recursive target
comparison is even. -/
theorem earlier_recursive_originalIndex_even
    (m : Nat) (large : 3 ≤ m + 1)
    {i j : Fin (recursiveTargetCount m)} (order : i < j) :
    (recursiveOriginalTargetIndex m large i).val % 2 = 0 :=
  ordinary_originalIndex_even m large i
    (earlier_recursive_target_not_special m large order)

/-- If the left source index is even, halving grows strictly slower than the
source-index gap.  This covers both even-to-even ordinary transitions and the
final even-to-odd special-tail transition. -/
theorem half_gap_strict_of_left_even
    {a b : Nat} (leftEven : a % 2 = 0) (strict : a < b) :
    b / 2 - a / 2 < b - a := by
  omega

/-- Compact-rank alpha-prime values are strictly increasing. -/
theorem recursiveAlphaValue_strict
    {q m : Nat} (plan : AlphaPlan q m)
    (large : 3 ≤ m + 1)
    {i j : Fin (recursiveTargetCount m)} (order : i < j) :
    recursiveAlphaValue plan large i <
      recursiveAlphaValue plan large j := by
  rw [recursiveAlphaValue_eq_compactRank,
    recursiveAlphaValue_eq_compactRank]
  unfold compactRank
  let ri := recursiveOriginalTargetIndex m large i
  let rj := recursiveOriginalTargetIndex m large j
  have sourceStrict : ri.val < rj.val :=
    recursiveOriginalTargetIndex_strict m large order
  have leftEven : ri.val % 2 = 0 := by
    dsimp [ri]
    exact earlier_recursive_originalIndex_even m large order
  have indexOrder : ri.val ≤ rj.val := sourceStrict.le
  have targetGap := target_gap_ge_index_gap plan ri rj indexOrder
  have startToI := target_from_zero_gap plan ri
  have startToJ := target_from_zero_gap plan rj
  have deleteGap := half_gap_strict_of_left_even leftEven sourceStrict
  dsimp [ri, rj] at *
  omega

end RemaudVandaeleLadderAlphaPrimeStrict
end QuantumBlockEncoding
