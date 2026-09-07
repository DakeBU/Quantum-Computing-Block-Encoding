import QuantumBlockEncoding.ReversibleComputeActionUncompute
import Mathlib.Tactic

/-!
# Compute / use / uncompute halves for recursive reversible circuits

Nie Figure 3 uses a child construction asymmetrically in time: Step 2 executes
the child's first half through its central action, the parent consumes the
intermediate result, and Step 4 executes the exact reverse of that first half.
This is slightly different from merely appending the child's ordinary cleanup.

For a split `prepare ; commit ; prepare⁻¹`, define

* `forwardHalf = prepare ; commit`;
* `backwardHalf = (forwardHalf)⁻¹ = commit⁻¹ ; prepare⁻¹`.

The two halves restore the complete basis state when concatenated.  Their total
depth is one complete child depth plus exactly one extra central-commit depth.
Thus, when `commit` has constant depth, the source recurrence is genuinely
`D(n) = D(child) + O(1)` rather than `2 D(child) + O(1)`.
-/

namespace QuantumBlockEncoding
namespace ReversibleComputeActionUncompute

/-- The delayed second half used after a parent has consumed the child result. -/
def backwardHalf {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    ScheduledReversibleProgram qubits :=
  split.forwardHalf.reverse

@[simp] theorem backwardHalf_gateCount {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.backwardHalf.gateCount = split.forwardHalf.gateCount := by
  simp [backwardHalf]

@[simp] theorem backwardHalf_depth {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.backwardHalf.depth = split.forwardHalf.depth := by
  simp [backwardHalf]

/-- Step 2 followed by Step 4 restores every computational-basis wire exactly. -/
theorem backwardHalf_restores_forwardHalf {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram split.backwardHalf.program
        (evalReversibleProgram split.forwardHalf.program state) = state := by
  exact ScheduledReversibleProgram.eval_reverse_after split.forwardHalf state

/-- Figure-3 depth accounting: the two exposed halves cost one full child plus
one extra copy of the central action. -/
theorem forwardHalf_depth_add_backwardHalf_depth {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.forwardHalf.depth + split.backwardHalf.depth =
      split.full.depth + split.commit.depth := by
  simp [backwardHalf, forwardHalf, full, cleanup]
  omega

/-- The same exact accounting identity for logical gate count. -/
theorem forwardHalf_gateCount_add_backwardHalf_gateCount {qubits : Nat}
    (split : ReversibleComputeActionUncompute qubits) :
    split.forwardHalf.gateCount + split.backwardHalf.gateCount =
      split.full.gateCount + split.commit.gateCount := by
  simp [backwardHalf, forwardHalf, full, cleanup]
  omega

/-- In particular, a uniform constant bound on the central commit is exactly
the additive overhead needed when a parent splits a child across Step 2/4. -/
theorem halves_depth_le_full_add
    {qubits bound : Nat}
    (split : ReversibleComputeActionUncompute qubits)
    (commitBound : split.commit.depth ≤ bound) :
    split.forwardHalf.depth + split.backwardHalf.depth ≤
      split.full.depth + bound := by
  rw [forwardHalf_depth_add_backwardHalf_depth]
  omega

end ReversibleComputeActionUncompute
end QuantumBlockEncoding
