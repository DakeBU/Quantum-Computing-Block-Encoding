import QuantumBlockEncoding.VandaeleLemma1NieFixedSemantics
import Mathlib.Tactic

/-!
# Logical control partition for the Nie Figure-3 recursion

The Figure-3 parent reserves four controls and divides the remaining controls
between two recursive children.  The correctness induction should consume this
as one algebraic fact, not redo physical-wire arithmetic in every semantic
proof.

This module proves that the parent all-controls predicate is exactly the
conjunction of:

* all four reserved controls are one;
* all logical controls of the left child are one;
* all logical controls of the right child are one.

It also identifies the latter two predicates with `allFlatControlsOne` after
reading the parent register through the corresponding child embeddings.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieControlPartition

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1NieFixedSemantics
open ReversibleWireEmbedding

/-- Parent control index occupied by the `j`th logical left-child control. -/
def leftParentControl (k : Nat) (four_le : 4 ≤ k)
    (j : Fin (leftSize k)) : Fin k :=
  ⟨4 + j.val, by
    have partition := split_size k four_le
    have bound := j.isLt
    omega⟩

/-- Parent control index occupied by the `j`th logical right-child control. -/
def rightParentControl (k : Nat) (four_le : 4 ≤ k)
    (j : Fin (rightSize k)) : Fin k :=
  ⟨4 + leftSize k + j.val, by
    have partition := split_size k four_le
    have bound := j.isLt
    omega⟩

@[simp] theorem leftChildEmbed_control
    (k : Nat) (four_le : 4 ≤ k) (j : Fin (leftSize k)) :
    leftChildEmbed k four_le (controlWire (leftSize k) j) =
      controlWire k (leftParentControl k four_le j) := by
  apply Fin.ext
  simp [leftChildEmbed, controlWire, leftParentControl, j.isLt]

@[simp] theorem rightChildEmbed_control
    (k : Nat) (four_le : 4 ≤ k) (j : Fin (rightSize k)) :
    rightChildEmbed k four_le (controlWire (rightSize k) j) =
      controlWire k (rightParentControl k four_le j) := by
  apply Fin.ext
  simp [rightChildEmbed, controlWire, rightParentControl, j.isLt]

/-- All controls assigned to the left recursive block were one in the parent. -/
def LeftBlockAllOne (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) : Prop :=
  ∀ j : Fin (leftSize k),
    state (controlWire k (leftParentControl k four_le j)) = 1

/-- All controls assigned to the right recursive block were one in the parent. -/
def RightBlockAllOne (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) : Prop :=
  ∀ j : Fin (rightSize k),
    state (controlWire k (rightParentControl k four_le j)) = 1

/-- Reading the left child's logical control block through the physical embedding
recovers exactly the parent `LeftBlockAllOne` predicate. -/
theorem leftChild_allFlatControlsOne_iff
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne (leftSize k)
        (readEmbeddedState (leftChildEmbed k four_le) state) ↔
      LeftBlockAllOne k four_le state := by
  constructor
  · intro childAll j
    have hit := childAll j
    simpa [readEmbeddedState] using hit
  · intro parentAll j
    have hit := parentAll j
    simpa [readEmbeddedState] using hit

/-- Symmetric right-child predicate identification. -/
theorem rightChild_allFlatControlsOne_iff
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne (rightSize k)
        (readEmbeddedState (rightChildEmbed k four_le) state) ↔
      RightBlockAllOne k four_le state := by
  constructor
  · intro childAll j
    have hit := childAll j
    simpa [readEmbeddedState] using hit
  · intro parentAll j
    have hit := parentAll j
    simpa [readEmbeddedState] using hit

/-- Exact logical partition of the parent activation predicate. -/
theorem allFlatControlsOne_iff_parts
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne k state ↔
      ReservedAllOne k four_le state ∧
      LeftBlockAllOne k four_le state ∧
      RightBlockAllOne k four_le state := by
  constructor
  · intro all
    refine ⟨?_, ?_, ?_⟩
    · intro index
      exact all (reservedControl k four_le index)
    · intro j
      exact all (leftParentControl k four_le j)
    · intro j
      exact all (rightParentControl k four_le j)
  · rintro ⟨reserved, left, right⟩ wire
    by_cases inReserved : wire.val < 4
    · let index : Fin 4 := ⟨wire.val, inReserved⟩
      have same : reservedControl k four_le index = wire := by
        apply Fin.ext
        simp [index, reservedControl]
      have hit := reserved index
      simpa [reservedWire, same] using hit
    · by_cases inLeft : wire.val < 4 + leftSize k
      · let j : Fin (leftSize k) := ⟨wire.val - 4, by omega⟩
        have same : leftParentControl k four_le j = wire := by
          apply Fin.ext
          simp [leftParentControl, j]
          omega
        have hit := left j
        simpa [same] using hit
      · let j : Fin (rightSize k) :=
          ⟨wire.val - (4 + leftSize k), by
            have partition := split_size k four_le
            have upper : wire.val < k := wire.isLt
            omega⟩
        have same : rightParentControl k four_le j = wire := by
          apply Fin.ext
          simp [rightParentControl, j]
          omega
        have hit := right j
        simpa [same] using hit

end VandaeleLemma1NieControlPartition
end QuantumBlockEncoding