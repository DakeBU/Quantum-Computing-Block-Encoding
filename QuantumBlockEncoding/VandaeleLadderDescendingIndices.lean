import QuantumBlockEncoding.VandaeleLadderContract
import Mathlib.Data.List.FinRange
import Mathlib.Data.List.OfFn
import Mathlib.Data.List.Pairwise
import Mathlib.Tactic

/-!
# Descending source chronology for Vandaele ladder operators

The source realization of Equation (5) executes ladder blocks in the order

`steps - 1, steps - 2, ..., 0`.

This file isolates the finite-order facts needed by the semantic proof.  In
particular, when the current block `i` is reached, every block already executed
has a strictly larger source index, while every block still to come has a
strictly smaller source index.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderDescendingIndices

/-- Chronological source order used by the naive Vandaele ladder. -/
def descendingIndices (steps : Nat) : List (Fin steps) :=
  (List.finRange steps).reverse

@[simp] theorem length_descendingIndices (steps : Nat) :
    (descendingIndices steps).length = steps := by
  simp [descendingIndices]

@[simp] theorem mem_descendingIndices {steps : Nat} (index : Fin steps) :
    index ∈ descendingIndices steps := by
  simp [descendingIndices]

/-- `finRange` is strictly increasing in its list order. -/
theorem pairwise_finRange_lt (steps : Nat) :
    (List.finRange steps).Pairwise (fun left right : Fin steps => left < right) := by
  rw [← List.ofFn_id steps, List.pairwise_ofFn]
  intro i j hij
  simpa using hij

/-- Reversing `finRange` gives the strict descending source chronology. -/
theorem pairwise_descendingIndices_gt (steps : Nat) :
    (descendingIndices steps).Pairwise
      (fun earlier later : Fin steps => later < earlier) := by
  have increasing := pairwise_finRange_lt steps
  simpa [descendingIndices] using increasing.reverse

/-- Every source block occurs exactly once in descending chronology. -/
theorem nodup_descendingIndices (steps : Nat) :
    (descendingIndices steps).Nodup := by
  exact (pairwise_descendingIndices_gt steps).imp (fun order => by
    intro equal
    subst equal
    exact (lt_irrefl _ order))

/-- Split the descending chronology at an arbitrary source block.

All already-executed indices in `earlierPart` are strictly larger than `index`,
and all not-yet-executed indices in `laterPart` are strictly smaller. -/
theorem exists_descending_split {steps : Nat} (index : Fin steps) :
    ∃ earlierPart laterPart : List (Fin steps),
      descendingIndices steps = earlierPart ++ index :: laterPart ∧
      (∀ earlier ∈ earlierPart, index < earlier) ∧
      (∀ later ∈ laterPart, later < index) := by
  have member : index ∈ descendingIndices steps := mem_descendingIndices index
  rw [List.mem_iff_append] at member
  rcases member with ⟨earlierPart, laterPart, split⟩
  have pairwise := pairwise_descendingIndices_gt steps
  rw [split, List.pairwise_append] at pairwise
  rcases pairwise with ⟨earlierPairwise, restPairwise, cross⟩
  refine ⟨earlierPart, laterPart, split, ?_, ?_⟩
  · intro earlier earlierMem
    exact cross earlier earlierMem index (by simp)
  · intro later laterMem
    exact List.rel_of_pairwise_cons restPairwise laterMem

end VandaeleLadderDescendingIndices
end QuantumBlockEncoding
