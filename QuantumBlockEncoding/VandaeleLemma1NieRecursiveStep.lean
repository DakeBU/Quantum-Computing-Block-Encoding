import QuantumBlockEncoding.VandaeleLemma1NieLayout
import QuantumBlockEncoding.ReversibleComputeUseUncompute
import QuantumBlockEncoding.ParallelReversibleSemantics
import Mathlib.Tactic

/-!
# One generic proof-bearing Nie Figure-3 recursive step

This module does not yet solve the recursion.  Instead it proves the reusable
inductive constructor: given two already-certified child *splits*, place their
`forwardHalf`s on the two disjoint Figure-3 subregisters, run them in parallel,
and surround the resulting computation by the fixed Step-1 / normalization /
Step-3 blocks.

The output is again a `ReversibleComputeActionUncompute`.  Its reverse half is
therefore generated from the exact gate schedule, rather than postulated as a
second numeric recurrence.

Most importantly, the exact resource equations are stated in terms of the
children's complete circuits and central commits:

```
D(parent) = 32 + max (D(left)+C(left), D(right)+C(right))
G(parent) = 32 + (G(left)+Cg(left)) + (G(right)+Cg(right))
```

where `C/Cg` are child commit depth/gate count.  Once the recursive family proves
a uniform constant bound on commits, these equations immediately expose the
source `D(n)=D(n/2)+O(1)` and linear-size recurrence.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieRecursiveStep

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open ScheduledWireEmbedding
open ReversibleEmbeddingDisjointness
open ReversibleComputeActionUncompute

private theorem four_le_of_five_le {k : Nat} (five_le : 5 ≤ k) : 4 ≤ k := by
  omega

/-- Embed the left child's exposed first half into the parent Figure-3 layout. -/
def leftForward {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k))) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  let four_le := four_le_of_five_le five_le
  mapScheduledWires (leftChildEmbed k four_le)
    (leftChildEmbed_injective k four_le) left.forwardHalf

/-- Embed the right child's exposed first half. -/
def rightForward {k : Nat} (five_le : 5 ≤ k)
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  let four_le := four_le_of_five_le five_le
  mapScheduledWires (rightChildEmbed k four_le)
    (rightChildEmbed_injective k four_le) right.forwardHalf

/-- The two mapped child halves are cross-disjoint by construction of their
physical wire images. -/
theorem forward_cross {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    ReversibleSchedule.CrossWireDisjoint
      (leftForward five_le left).layers
      (rightForward five_le right).layers := by
  let four_le := four_le_of_five_le five_le
  exact mapScheduledWires_crossWireDisjoint
    (leftChildEmbed k four_le)
    (leftChildEmbed_injective k four_le)
    (rightChildEmbed k four_le)
    (rightChildEmbed_injective k four_le)
    (childImagesDisjoint k four_le)
    left.forwardHalf right.forwardHalf

/-- Figure-3 Step 2 recursive work: the two first halves share time slices. -/
def parallelForward {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  ScheduledReversibleProgram.parallel
    (leftForward five_le left)
    (rightForward five_le right)
    (forward_cross five_le left right)

/-- Normalization followed by the two recursive first halves. -/
def stepTwo {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  let four_le := four_le_of_five_le five_le
  ScheduledReversibleProgram.seq
    (normalizeScheduled k four_le)
    (parallelForward five_le left right)

/-- Figure-3 preparation: Step 1, then Step 2. -/
def prepare {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  let four_le := four_le_of_five_le five_le
  ScheduledReversibleProgram.seq
    (stepOneScheduled k four_le)
    (stepTwo five_le left right)

/-- Figure-3 central Step 3. -/
def commit {k : Nat} (five_le : 5 ≤ k) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  stepThreeScheduled k (four_le_of_five_le five_le)

/-- One complete generic clean-ancilla Figure-3 split.  The reverse of `prepare`
produces Step 4 and Step 5 from the actual Step-2/Step-1 gate lists. -/
def recursiveSplit {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    ReversibleComputeActionUncompute (lemmaOneFlatWidth k) where
  prepare := prepare five_le left right
  commit := commit five_le

@[simp] theorem leftForward_gateCount {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k))) :
    (leftForward five_le left).gateCount = left.forwardHalf.gateCount := by
  simp [leftForward]

@[simp] theorem leftForward_depth {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k))) :
    (leftForward five_le left).depth = left.forwardHalf.depth := by
  simp [leftForward]

@[simp] theorem rightForward_gateCount {k : Nat} (five_le : 5 ≤ k)
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (rightForward five_le right).gateCount = right.forwardHalf.gateCount := by
  simp [rightForward]

@[simp] theorem rightForward_depth {k : Nat} (five_le : 5 ≤ k)
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (rightForward five_le right).depth = right.forwardHalf.depth := by
  simp [rightForward]

@[simp] theorem parallelForward_gateCount {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (parallelForward five_le left right).gateCount =
      left.forwardHalf.gateCount + right.forwardHalf.gateCount := by
  simp [parallelForward]

@[simp] theorem parallelForward_depth {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (parallelForward five_le left right).depth =
      max left.forwardHalf.depth right.forwardHalf.depth := by
  simp [parallelForward]

/-- The parallel schedule is semantically equal to the two mapped children in
sequential order; the depth reduction therefore does not alter basis semantics. -/
theorem eval_parallelForward_eq_seq {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    evalReversibleProgram (parallelForward five_le left right).program =
      evalReversibleProgram
        (ScheduledReversibleProgram.seq
          (leftForward five_le left)
          (rightForward five_le right)).program := by
  exact ScheduledReversibleProgram.eval_parallel_eq_seq
    (leftForward five_le left)
    (rightForward five_le right)
    (forward_cross five_le left right)

@[simp] theorem stepTwo_gateCount {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (stepTwo five_le left right).gateCount =
      4 + left.forwardHalf.gateCount + right.forwardHalf.gateCount := by
  simp [stepTwo, Nat.add_assoc]

@[simp] theorem stepTwo_depth {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (stepTwo five_le left right).depth =
      4 + max left.forwardHalf.depth right.forwardHalf.depth := by
  simp [stepTwo]

@[simp] theorem prepare_gateCount {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (prepare five_le left right).gateCount =
      14 + left.forwardHalf.gateCount + right.forwardHalf.gateCount := by
  simp [prepare, Nat.add_assoc]
  omega

@[simp] theorem prepare_depth {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (prepare five_le left right).depth =
      14 + max left.forwardHalf.depth right.forwardHalf.depth := by
  simp [prepare]
  omega

@[simp] theorem commit_gateCount {k : Nat} (five_le : 5 ≤ k) :
    (commit five_le).gateCount = 4 := by
  simp [commit]

@[simp] theorem commit_depth {k : Nat} (five_le : 5 ≤ k) :
    (commit five_le).depth = 4 := by
  simp [commit]

/-- Exact full gate-count recurrence from the proof-bearing Figure-3 schedule. -/
theorem recursiveSplit_full_gateCount {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (recursiveSplit five_le left right).full.gateCount =
      32 +
        (left.full.gateCount + left.commit.gateCount) +
        (right.full.gateCount + right.commit.gateCount) := by
  rw [ReversibleComputeActionUncompute.full_gateCount]
  simp [recursiveSplit]
  omega

/-- Exact full depth recurrence.  The two child first halves run in parallel, so
only the maximum child branch survives. -/
theorem recursiveSplit_full_depth {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (recursiveSplit five_le left right).full.depth =
      32 + max
        (left.full.depth + left.commit.depth)
        (right.full.depth + right.commit.depth) := by
  rw [ReversibleComputeActionUncompute.full_depth]
  simp [recursiveSplit]
  have leftHalf :=
    ReversibleComputeActionUncompute.forwardHalf_depth_add_backwardHalf_depth left
  have rightHalf :=
    ReversibleComputeActionUncompute.forwardHalf_depth_add_backwardHalf_depth right
  simp [backwardHalf] at leftHalf rightHalf
  omega

/-- Every non-base recursive node has the same constant central gadget. -/
theorem recursiveSplit_commit_resources {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k))) :
    (recursiveSplit five_le left right).commit.gateCount = 4 ∧
    (recursiveSplit five_le left right).commit.depth = 4 := by
  simp [recursiveSplit]

end VandaeleLemma1NieRecursiveStep
end QuantumBlockEncoding