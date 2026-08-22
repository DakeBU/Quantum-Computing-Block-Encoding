import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import Mathlib.Data.Nat.Log
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: MCX count/depth recurrence

Algorithm 2 synthesizes a general `L_alpha` whose alpha-vector has `k-1`
targets.  The Appendix proves that only `k`, not the physical interval lengths,
controls the MCX-layer topology:

`D(k) = 2 + D(floor(k/2))`,
`C(k) = 2 floor((k-1)/2) + C(floor(k/2))`,

with `D(1)=C(1)=0`, `D(2)=C(2)=1`.

This module re-proves the uniform O(log k) / O(k) consequences from the exact
recurrence.  No MCX-to-Toffoli synthesis is used here; that is deliberately the
next layer in the upstream citation chain.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaResource

/-- Number of MCX gates in each source outer wall. -/
def outerCount (k : Nat) : Nat := (k - 1) / 2

/-- Number of boundaries in the recursive call. -/
def recursiveK (k : Nat) : Nat := k / 2

/-- Exact MCX-depth recurrence from Appendix Equation (26). -/
def depthRecurrence : Nat → Nat
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | k + 3 => 2 + depthRecurrence ((k + 3) / 2)
termination_by k => k

decreasing_by omega

/-- Exact MCX-count recurrence from Appendix Equation (29). -/
def gateRecurrence : Nat → Nat
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | k + 3 => 2 * outerCount (k + 3) + gateRecurrence ((k + 3) / 2)
termination_by k => k

decreasing_by omega

/-- Lean's well-founded equation compiler supplies rewrite equations for these
recursive definitions; unlike ordinary structural recursion, they should not be
proved by definitional `rfl`. -/
@[simp] theorem depth_zero : depthRecurrence 0 = 0 := by
  simp [depthRecurrence]

@[simp] theorem depth_one : depthRecurrence 1 = 0 := by
  simp [depthRecurrence]

@[simp] theorem depth_two : depthRecurrence 2 = 1 := by
  simp [depthRecurrence]

@[simp] theorem gate_zero : gateRecurrence 0 = 0 := by
  simp [gateRecurrence]

@[simp] theorem gate_one : gateRecurrence 1 = 0 := by
  simp [gateRecurrence]

@[simp] theorem gate_two : gateRecurrence 2 = 1 := by
  simp [gateRecurrence]

/-- Reader-facing exact depth recurrence. -/
theorem depth_step {k : Nat} (large : 3 ≤ k) :
    depthRecurrence k = 2 + depthRecurrence (recursiveK k) := by
  have decompose : k = (k - 3) + 3 := by omega
  rw [decompose]
  simp [depthRecurrence, recursiveK]

/-- Reader-facing exact MCX-count recurrence. -/
theorem gate_step {k : Nat} (large : 3 ≤ k) :
    gateRecurrence k = 2 * outerCount k + gateRecurrence (recursiveK k) := by
  have decompose : k = (k - 3) + 3 := by omega
  rw [decompose]
  simp [gateRecurrence, recursiveK]

/-- Recursive ladder size decreases in the non-base regime. -/
theorem recursiveK_lt {k : Nat} (large : 2 < k) : recursiveK k < k := by
  unfold recursiveK
  omega

/-- The MCX count is uniformly linear. -/
theorem gateRecurrence_le_two_mul :
    ∀ k, gateRecurrence k ≤ 2 * k := by
  intro k
  induction k using Nat.strong_induction_on with
  | h k induction =>
      rcases k with (_ | _ | _ | m)
      · simp
      · simp
      · norm_num
      · have smaller : (m + 3) / 2 < m + 3 := by omega
        have recursive := induction ((m + 3) / 2) smaller
        rw [gate_step (k := m + 3) (by omega)]
        unfold outerCount recursiveK
        omega

/-- Binary logarithm drops by one at the halving recursive call. -/
theorem log2_half_add_one
    {k : Nat} (large : 2 ≤ k) :
    Nat.log2 k = Nat.log2 (k / 2) + 1 := by
  rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
  exact Nat.log_of_one_lt_of_le (by omega) large

/-- The MCX-layer depth is uniformly logarithmic. -/
theorem depthRecurrence_le_two_log :
    ∀ k, depthRecurrence k ≤ 2 * (Nat.log2 k + 1) := by
  intro k
  induction k using Nat.strong_induction_on with
  | h k induction =>
      rcases k with (_ | _ | _ | m)
      · simp
      · simp
      · norm_num
      · have smaller : (m + 3) / 2 < m + 3 := by omega
        have recursive := induction ((m + 3) / 2) smaller
        have logarithm := log2_half_add_one (k := m + 3) (by omega)
        rw [depth_step (k := m + 3) (by omega)]
        unfold recursiveK
        rw [logarithm]
        omega

/-- Source-level resource certificate indexed only by the number of ladder
boundaries. -/
def AlgorithmTwoResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat, ∀ k,
    gateCount k ≤ gateConstant * (k + 1) ∧
    depth k ≤ depthConstant * (Nat.log2 (k + 1) + 1)

/-- The exact Appendix recurrences close Algorithm 2's uniform MCX resources. -/
theorem recurrence_resources :
    AlgorithmTwoResourceTarget gateRecurrence depthRecurrence := by
  refine ⟨2, 2, ?_⟩
  intro k
  constructor
  · exact (gateRecurrence_le_two_mul k).trans (by nlinarith)
  · have source := depthRecurrence_le_two_log k
    have mono : Nat.log2 k ≤ Nat.log2 (k + 1) := by
      rw [Nat.log2_eq_log_two, Nat.log2_eq_log_two]
      exact Nat.log_mono_right (by omega)
    omega

end RemaudVandaeleLadderAlphaResource
end QuantumBlockEncoding
