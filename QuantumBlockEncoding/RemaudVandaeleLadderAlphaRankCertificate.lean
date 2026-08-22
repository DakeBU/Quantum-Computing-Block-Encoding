import QuantumBlockEncoding.FilteredListRank
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaDeletedPrefixCount
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaPrimeStrict
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveCertificate
import Mathlib.Tactic

/-!
# Algorithm 2: selected-list rank is exactly alpha-prime

This is the final combinatorial identity behind the recursive register `X'`.
For recursive source target r:

* its unfiltered interval rank is `alpha_r-alpha_0`;
* the prefix contains exactly `floor(r/2)` deleted odd intermediate targets;
* therefore its filtered `X'` rank is
  `alpha_r-alpha_0-floor(r/2)`;
* `RemaudVandaeleLadderAlphaRankArithmetic` already proved that this is exactly
  the source pseudocode value `alpha'_j`.

Consequently the previously explicit `RecursiveRegisterCertificate` now has a
canonical inhabitant derived entirely from the source construction.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRankCertificate

open FilteredListRank
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaDeletedPrefixCount
open RemaudVandaeleLadderAlphaPrimeStrict
open RemaudVandaeleLadderAlphaRankArithmetic
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetMembership

/-- The retained-prefix count before a recursive target is exactly its compact
rank. -/
theorem retainedBefore_recursiveTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    FilteredListRank.retainedBefore
      (keepPhysicalWire plan large)
      (intervalList plan large)
      (plan.target (recursiveOriginalTargetIndex m large j)) =
        recursiveAlphaValue plan large j := by
  let offset := recursiveTargetOffset plan large j
  have intervalRank := recursiveTarget_interval_idxOf plan large j
  have partition := FilteredListRank.take_filter_partition_length
    (keepPhysicalWire plan large) (intervalList plan large) offset
  have deleteCount := deletedPrefix_length plan large j
  have prefixLength := targetPrefix_length plan large j
  have alphaRank := recursiveAlphaValue_eq_compactRank plan large j
  unfold FilteredListRank.retainedBefore
  rw [intervalRank]
  change
    ((targetPrefix plan large j).filter (keepPhysicalWire plan large)).length =
      recursiveAlphaValue plan large j
  have partition' :
      ((targetPrefix plan large j).filter (keepPhysicalWire plan large)).length +
        (deletedPrefix plan large j).length =
          (targetPrefix plan large j).length := by
    simpa [targetPrefix, deletedPrefix, deletePhysicalWireBool, offset] using partition
  rw [deleteCount, prefixLength] at partition'
  have keptRank :
      ((targetPrefix plan large j).filter (keepPhysicalWire plan large)).length =
        recursiveTargetOffset plan large j -
          (recursiveOriginalTargetIndex m large j).val / 2 := by
    omega
  rw [keptRank, alphaRank]
  rfl

/-- Main source rank equation: the recursive physical alpha target occurs in X'
at exactly the pseudocode alpha-prime coordinate. -/
theorem selectedList_idxOf_recursiveTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    (selectedList plan large).idxOf
      (plan.target (recursiveOriginalTargetIndex m large j)) =
        recursiveAlphaValue plan large j := by
  have member := recursiveTarget_mem_intervalList plan large j
  have retained := recursiveTarget_not_deleted plan large j
  have kept :
      keepPhysicalWire plan large
        (plan.target (recursiveOriginalTargetIndex m large j)) = true :=
    (keepPhysicalWire_eq_true_iff plan large _).2 retained
  have rank := FilteredListRank.idxOf_filter_eq_retainedBefore
    (keepPhysicalWire plan large)
    (intervalList plan large)
    (plan.target (recursiveOriginalTargetIndex m large j))
    (intervalList_nodup plan large)
    member kept
  unfold selectedList
  rw [rank]
  exact retainedBefore_recursiveTarget plan large j

/-- The source recursive register certificate is now fully constructed. -/
noncomputable def canonicalCertificate
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    RecursiveRegisterCertificate plan large :=
  ofRankTheorem plan large
    (selectedList_idxOf_recursiveTarget plan large)
    (recursiveAlphaValue_strict plan large)

/-- Reader-facing physical target theorem from the canonical certificate. -/
theorem canonical_recursive_target_physical
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    selectedWire plan large
      ((recursivePlan plan large (canonicalCertificate plan large)).target j) =
        plan.target (recursiveOriginalTargetIndex m large j) :=
  recursivePlan_target_physical plan large (canonicalCertificate plan large) j

/-- Reader-facing alpha-prime coordinate theorem. -/
theorem canonical_recursive_target_rank
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (j : Fin (recursiveTargetCount m)) :
    ((recursivePlan plan large (canonicalCertificate plan large)).target j).val =
      recursiveAlphaValue plan large j :=
  recursivePlan_target_val plan large (canonicalCertificate plan large) j

end RemaudVandaeleLadderAlphaRankCertificate
end QuantumBlockEncoding
