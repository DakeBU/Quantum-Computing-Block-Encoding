import Mathlib.Data.List.FinRange
import Mathlib.Tactic

/-!
# Rank of an element after filtering an ordered nodup list

Several source constructions compact an ordered physical register by deleting a
known subset of wires.  The basic combinatorics is independent of quantum
circuits: in a nodup list, the rank of a retained element after filtering is the
number of retained elements before its original position.

This module isolates that fact so Algorithm 2's alpha-prime proof does not bury
generic list bookkeeping inside circuit semantics.
-/

namespace QuantumBlockEncoding
namespace FilteredListRank

variable {α : Type*} [DecidableEq α]

/-- Number of retained entries strictly before the first occurrence of `a`. -/
def retainedBefore
    (keep : α → Bool) (list : List α) (a : α) : Nat :=
  ((list.take (list.idxOf a)).filter keep).length

/-- Boolean complement. -/
def deleteOfKeep (keep : α → Bool) : α → Bool := fun x => !(keep x)

/-- Every list is partitioned exactly into kept and deleted entries. -/
theorem filter_partition_length
    (keep : α → Bool) (list : List α) :
    (list.filter keep).length +
      (list.filter (deleteOfKeep keep)).length = list.length := by
  induction list with
  | nil => rfl
  | cons head tail induction =>
      cases h : keep head <;>
        simp [deleteOfKeep, h, induction]

/-- The partition identity on a prefix. -/
theorem take_filter_partition_length
    (keep : α → Bool) (list : List α) (count : Nat) :
    ((list.take count).filter keep).length +
      ((list.take count).filter (deleteOfKeep keep)).length =
        (list.take count).length :=
  filter_partition_length keep (list.take count)

/-- Main filter-rank theorem for a retained member of a nodup list. -/
theorem idxOf_filter_eq_retainedBefore
    (keep : α → Bool) (list : List α) (a : α)
    (nodup : list.Nodup)
    (member : a ∈ list)
    (kept : keep a = true) :
    (list.filter keep).idxOf a = retainedBefore keep list a := by
  induction list with
  | nil => simp at member
  | cons head tail induction =>
      have tailNodup := (List.nodup_cons.mp nodup).2
      by_cases same : a = head
      · subst a
        simp [retainedBefore, kept]
      · have tailMember : a ∈ tail := by
          simpa [same] using member
        have recursive := induction tailNodup tailMember kept
        by_cases headKept : keep head = true
        · simp [retainedBefore, same, headKept, recursive]
        · have headFalse : keep head = false := by
            cases h : keep head <;> simp_all
          simp [retainedBefore, same, headFalse, recursive]

/-- The same result stated as an exact position bound, useful for constructing a
`Fin (filter.length)`. -/
theorem retainedBefore_lt_filter_length
    (keep : α → Bool) (list : List α) (a : α)
    (nodup : list.Nodup)
    (member : a ∈ list)
    (kept : keep a = true) :
    retainedBefore keep list a < (list.filter keep).length := by
  rw [← idxOf_filter_eq_retainedBefore keep list a nodup member kept]
  exact List.idxOf_lt_length.2 (by simpa [kept] using member)

/-- At the retained rank, `get` returns the requested element. -/
theorem get_filter_retainedBefore
    (keep : α → Bool) (list : List α) (a : α)
    (nodup : list.Nodup)
    (member : a ∈ list)
    (kept : keep a = true) :
    (list.filter keep).get
      ⟨retainedBefore keep list a,
        retainedBefore_lt_filter_length keep list a nodup member kept⟩ = a := by
  have rank := idxOf_filter_eq_retainedBefore keep list a nodup member kept
  have filteredMember : a ∈ list.filter keep := by simpa [kept] using member
  rcases List.mem_iff_get.mp filteredMember with ⟨index,indexValue⟩
  have filteredNodup := nodup.filter keep
  have indexRank : (list.filter keep).idxOf a = index.val := by
    have source := List.get_idxOf filteredNodup index
    rw [indexValue] at source
    exact source
  have indexEq : index =
      ⟨retainedBefore keep list a,
        retainedBefore_lt_filter_length keep list a nodup member kept⟩ := by
    apply Fin.ext
    omega
  rw [← indexEq]
  exact indexValue

end FilteredListRank
end QuantumBlockEncoding
