import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Resource and workspace closure for Vandaele Theorem 3

Theorem 3 implements the classical-quantum comparator by rewriting its central
subcircuit using four `V_2` operators.  Equation (31) splits them into two
half-width groups.  The source then borrows the input qubits themselves as dirty
workspace:

* the first pair uses `ceil(n/2)` input qubits as dirty workspace;
* the second pair uses `floor(n/2)` input qubits as dirty workspace.

Those two borrowed sets partition the n input qubits, so they require no extra
qubits.  Equation (31) introduces one clean combining bit; Figure 2(a) finally
replaces exactly that bit by one dirty ancilla.  This is the source qubit-count
argument behind Theorem 3.

The same file closes the gate/depth algebra: four half-width Theorem-2 `V_2`
instances plus any linear/logarithmic outer Figure-7 layers remain O(n) gates
and O(log n) depth.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorTheorem3Resource

open ComparatorIncrementerTheorem4DepthBound
open VandaeleComparatorTheorem2Resource
open VandaeleLemma5SplitBudget

/-- Exact borrowed-input workspace budget of Equations (31)-(32). -/
structure BorrowedInputBudget (n : Nat) where
  firstGroupWidth : Nat
  secondGroupWidth : Nat
  borrowedForFirst : Nat
  borrowedForSecond : Nat
  groupsPartitionInput : firstGroupWidth + secondGroupWidth = n
  firstBorrowMatches : borrowedForFirst = firstGroupWidth
  secondBorrowMatches : borrowedForSecond = secondGroupWidth
  borrowedTotal : borrowedForFirst + borrowedForSecond = n

/-- Canonical floor/ceiling source budget. -/
def canonicalBorrowedInputBudget (n : Nat) : BorrowedInputBudget n where
  firstGroupWidth := upperHalf n
  secondGroupWidth := lowerHalf n
  borrowedForFirst := upperHalf n
  borrowedForSecond := lowerHalf n
  groupsPartitionInput := by
    rw [Nat.add_comm]
    exact halves_partition n
  firstBorrowMatches := rfl
  secondBorrowMatches := rfl
  borrowedTotal := by
    rw [Nat.add_comm]
    exact halves_partition n

/-- No additional workspace qubits are required by the four V2 instances: all
of their dirty workspace is supplied by input wires. -/
theorem v2_extra_workspace_zero (n : Nat) :
    (canonicalBorrowedInputBudget n).borrowedForFirst +
        (canonicalBorrowedInputBudget n).borrowedForSecond = n :=
  (canonicalBorrowedInputBudget n).borrowedTotal

/-- Equation-(31) introduces exactly one external clean combining bit. -/
def cleanCombiningAncillas (_n : Nat) : Nat := 1

/-- Figure 2(a) replaces that clean bit by exactly one dirty ancilla. -/
def finalDirtyAncillas (_n : Nat) : Nat := 1

theorem clean_to_dirty_preserves_extra_count (n : Nat) :
    cleanCombiningAncillas n = finalDirtyAncillas n := by
  rfl

/-- Half-width linear scale is bounded by the full n scale. -/
theorem upperHalf_succ_le_succ (n : Nat) : upperHalf n + 1 ≤ n + 1 := by
  unfold upperHalf lowerHalf
  omega

theorem lowerHalf_succ_le_succ (n : Nat) : lowerHalf n + 1 ≤ n + 1 := by
  unfold lowerHalf
  omega

/-- Binary-log rank is monotone under the half-width splits. -/
theorem logRank_upperHalf_le (n : Nat) :
    logRank (upperHalf n) ≤ logRank n := by
  have width := upperHalf_succ_le_succ n
  have logBound :
      Nat.log2 (upperHalf n + 1) ≤ Nat.log2 (n + 1) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right width
  unfold logRank
  omega

theorem logRank_lowerHalf_le (n : Nat) :
    logRank (lowerHalf n) ≤ logRank n := by
  have width := lowerHalf_succ_le_succ n
  have logBound :
      Nat.log2 (lowerHalf n + 1) ≤ Nat.log2 (n + 1) := by
    rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
    exact Nat.log_mono_right width
  unfold logRank
  omega

/-- Uniform O(n)/O(log n) resource target for the non-V2 outer pieces of
Figure 7. -/
def OuterResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n,
      gateCount n ≤ gateConstant * (n + 1) ∧
      depth n ≤ depthConstant * logRank n

/-- Conservative exact gate envelope: outer layers plus two V2 calls on each
half. -/
def theoremThreeGateEnvelope
    (outerGate v2Gate : Nat → Nat) (n : Nat) : Nat :=
  outerGate n + 2 * v2Gate (upperHalf n) + 2 * v2Gate (lowerHalf n)

/-- Corresponding serial depth envelope.  Any legal source parallelism only
improves this upper bound. -/
def theoremThreeDepthEnvelope
    (outerDepth v2Depth : Nat → Nat) (n : Nat) : Nat :=
  outerDepth n + 2 * v2Depth (upperHalf n) + 2 * v2Depth (lowerHalf n)

/-- Public upper-resource target for Theorem 3. -/
def TheoremThreeUpperTarget
    (gateCount depth dirtyAncillas : Nat → Nat) : Prop :=
  (∃ gateConstant : Nat, ∀ n,
    gateCount n ≤ gateConstant * (n + 1)) ∧
  (∃ depthConstant : Nat, ∀ n,
    depth n ≤ depthConstant * logRank n) ∧
  (∀ n, dirtyAncillas n = 1)

/-- Theorem-2 V2 resources plus linear/log outer layers close the complete
Theorem-3 upper resource statement with exactly one dirty ancilla. -/
theorem theoremThree_upper_closure
    (outerGate outerDepth v2Gate v2Depth : Nat → Nat)
    (outerResources : OuterResourceTarget outerGate outerDepth)
    (v2GateConstant v2DepthConstant : Nat)
    (v2GateBound : ∀ width,
      v2Gate width ≤ v2GateConstant * (width + 1))
    (v2DepthBound : ∀ width,
      v2Depth width ≤ v2DepthConstant * logRank width) :
    TheoremThreeUpperTarget
      (theoremThreeGateEnvelope outerGate v2Gate)
      (theoremThreeDepthEnvelope outerDepth v2Depth)
      finalDirtyAncillas := by
  rcases outerResources with
    ⟨outerGateConstant, outerDepthConstant, outerBounds⟩
  constructor
  · refine ⟨outerGateConstant + 4 * v2GateConstant, ?_⟩
    intro n
    have outer := (outerBounds n).1
    have upper := (v2GateBound (upperHalf n)).trans
      (Nat.mul_le_mul_left v2GateConstant (upperHalf_succ_le_succ n))
    have lower := (v2GateBound (lowerHalf n)).trans
      (Nat.mul_le_mul_left v2GateConstant (lowerHalf_succ_le_succ n))
    unfold theoremThreeGateEnvelope
    calc
      outerGate n + 2 * v2Gate (upperHalf n) +
          2 * v2Gate (lowerHalf n) ≤
        outerGateConstant * (n + 1) +
          2 * (v2GateConstant * (n + 1)) +
          2 * (v2GateConstant * (n + 1)) :=
        Nat.add_le_add (Nat.add_le_add outer
          (Nat.mul_le_mul_left 2 upper))
          (Nat.mul_le_mul_left 2 lower)
      _ = (outerGateConstant + 4 * v2GateConstant) * (n + 1) := by ring
  · constructor
    · refine ⟨outerDepthConstant + 4 * v2DepthConstant, ?_⟩
      intro n
      have outer := (outerBounds n).2
      have upper := (v2DepthBound (upperHalf n)).trans
        (Nat.mul_le_mul_left v2DepthConstant (logRank_upperHalf_le n))
      have lower := (v2DepthBound (lowerHalf n)).trans
        (Nat.mul_le_mul_left v2DepthConstant (logRank_lowerHalf_le n))
      unfold theoremThreeDepthEnvelope
      calc
        outerDepth n + 2 * v2Depth (upperHalf n) +
            2 * v2Depth (lowerHalf n) ≤
          outerDepthConstant * logRank n +
            2 * (v2DepthConstant * logRank n) +
            2 * (v2DepthConstant * logRank n) :=
          Nat.add_le_add (Nat.add_le_add outer
            (Nat.mul_le_mul_left 2 upper))
            (Nat.mul_le_mul_left 2 lower)
        _ = (outerDepthConstant + 4 * v2DepthConstant) * logRank n := by ring
    · intro n
      rfl

end VandaeleComparatorTheorem3Resource
end QuantumBlockEncoding
