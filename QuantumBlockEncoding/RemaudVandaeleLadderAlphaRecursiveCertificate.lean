import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankArithmetic
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

/-!
# Exact recursive-register certificate for Remaud--Vandaele Algorithm 2

At this point every part of the source `X'` construction is formal except one
finite-rank identity: after deleting the intermediate odd alpha targets, the
compact index of recursive target j must be the pseudocode value alpha'_j.

Rather than let downstream circuit construction depend on list internals, this
module states the exact proof-bearing certificate required by Algorithm 2.
Its canonical inhabitant is the deletion-count theorem currently being closed;
there is no semantic/resource assumption hidden in this interface.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveCertificate

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankArithmetic
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetMembership

/-- One exact source recursion certificate. -/
structure RecursiveRegisterCertificate
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) where
  /-- Compact X' target corresponding to every alpha-prime entry. -/
  target : Fin (recursiveTargetCount m) → Fin (selectedWidth plan large)
  /-- Its compact position is exactly the source pseudocode alpha-prime value. -/
  target_rank : ∀ j,
    (target j).val = recursiveAlphaValue plan large j
  /-- It is physically the original alpha target selected by the pseudocode. -/
  physical_target : ∀ j,
    selectedWire plan large (target j) =
      plan.target (recursiveOriginalTargetIndex m large j)
  /-- Recursive target order is strictly increasing in compact coordinates. -/
  strict : ∀ {i j}, i < j → (target i).val < (target j).val

/-- The certificate immediately supplies the recursive alpha-plan. -/
def recursivePlan
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (certificate : RecursiveRegisterCertificate plan large) :
    AlphaPlan (selectedWidth plan large) (recursiveTargetCount m) where
  target := certificate.target
  strict := certificate.strict

/-- Reader-facing alpha-prime equation on the recursive plan. -/
@[simp] theorem recursivePlan_target_val
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (certificate : RecursiveRegisterCertificate plan large)
    (j : Fin (recursiveTargetCount m)) :
    ((recursivePlan plan large certificate).target j).val =
      recursiveAlphaValue plan large j :=
  certificate.target_rank j

/-- Reader-facing physical target equation. -/
theorem recursivePlan_target_physical
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (certificate : RecursiveRegisterCertificate plan large)
    (j : Fin (recursiveTargetCount m)) :
    selectedWire plan large
      ((recursivePlan plan large certificate).target j) =
        plan.target (recursiveOriginalTargetIndex m large j) :=
  certificate.physical_target j

/-- Any canonical rank theorem of exactly the source form is sufficient to
construct the certificate: target j is simply the physical recursive target's
`idxOf` in selectedList. -/
def ofRankTheorem
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (rank : ∀ j : Fin (recursiveTargetCount m),
      (selectedList plan large).idxOf
        (plan.target (recursiveOriginalTargetIndex m large j)) =
          recursiveAlphaValue plan large j)
    (strictRank : ∀ {i j : Fin (recursiveTargetCount m)}, i < j →
      recursiveAlphaValue plan large i < recursiveAlphaValue plan large j) :
    RecursiveRegisterCertificate plan large where
  target := fun j =>
    ⟨recursiveAlphaValue plan large j, by
      have member := recursiveTarget_mem_selectedList plan large j
      have bound := List.idxOf_lt_length.2 member
      rw [rank j] at bound
      simpa [selectedWidth] using bound⟩
  target_rank := fun _ => rfl
  physical_target := by
    intro j
    unfold selectedWire
    let index : Fin (selectedList plan large).length :=
      ⟨recursiveAlphaValue plan large j, by
        have member := recursiveTarget_mem_selectedList plan large j
        have bound := List.idxOf_lt_length.2 member
        rw [rank j] at bound
        exact bound⟩
    have nodup := selectedList_nodup plan large
    have member := recursiveTarget_mem_selectedList plan large j
    rcases List.mem_iff_get.mp member with ⟨actual,actualValue⟩
    have actualRank := nodup.get_idxOf actual
    rw [actualValue, rank j] at actualRank
    have actualEq : actual = index := by
      apply Fin.ext
      exact congrArg Fin.val actualRank
    simpa [index, actualEq] using actualValue
  strict := by
    intro i j order
    exact strictRank order

end RemaudVandaeleLadderAlphaRecursiveCertificate
end QuantumBlockEncoding
