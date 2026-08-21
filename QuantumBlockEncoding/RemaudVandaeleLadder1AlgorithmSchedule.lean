import QuantumBlockEncoding.RemaudVandaeleLadder1AlgorithmPlan
import Mathlib.Tactic

/-!
# Proof-bearing schedule for Remaud--Vandaele Algorithm 1

This module turns the exact physical plan from
`RemaudVandaeleLadder1AlgorithmPlan` into one recursive
`ScheduledReversibleProgram n`.

For `n >= 3` the schedule is literally

`[C_L] ; embed(Algorithm1(floor(n/2)), X') ; [C_R]`.

The two outer walls were already proved pairwise wire-disjoint, and the recursive
wire map `X'` was already proved injective.  Consequently certified depth and
gate count are read from the same scheduled object and satisfy exactly the
source recurrences of Remaud--Vandaele Lemma 2.

Semantic correctness is proved separately: this file establishes that the
*actual schedule topology* and the resource recurrence have been reproduced.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1AlgorithmSchedule

open RemaudVandaeleLadder1AlgorithmPlan
open ScheduledWireEmbedding

/-- One certified parallel layer. -/
def oneLayerScheduled {q : Nat}
    (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer) : ScheduledReversibleProgram q where
  layers := [layer]
  valid := by
    intro query member
    simpa using member ▸ valid

@[simp] theorem oneLayer_program {q : Nat}
    (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer) :
    (oneLayerScheduled layer valid).program = layer := by
  simp [oneLayerScheduled, ScheduledReversibleProgram.program,
    ReversibleSchedule.program]

@[simp] theorem oneLayer_gateCount {q : Nat}
    (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer) :
    (oneLayerScheduled layer valid).gateCount = layer.length := by
  simp [ScheduledReversibleProgram.gateCount,
    ReversibleSchedule.gateCount]

@[simp] theorem oneLayer_depth {q : Nat}
    (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer) :
    (oneLayerScheduled layer valid).depth = 1 := by
  rfl

/-- Empty certified schedule. -/
def emptyScheduled (q : Nat) : ScheduledReversibleProgram q where
  layers := []
  valid := by simp [ReversibleSchedule.Valid]

@[simp] theorem empty_gateCount (q : Nat) :
    (emptyScheduled q).gateCount = 0 := by
  rfl

@[simp] theorem empty_depth (q : Nat) :
    (emptyScheduled q).depth = 0 := by
  rfl

/-- Base `n=2` CNOT. -/
def baseTwoGate : ReversibleGate 2 :=
  .cx ⟨0, by decide⟩ ⟨1, by decide⟩ (by decide)

/-- Base `n=2` schedule from source Algorithm 1. -/
def baseTwoScheduled : ScheduledReversibleProgram 2 :=
  oneLayerScheduled [baseTwoGate] (by simp [ReversibleLayer.Valid])

@[simp] theorem baseTwo_gateCount : baseTwoScheduled.gateCount = 1 := by
  simp [baseTwoScheduled]

@[simp] theorem baseTwo_depth : baseTwoScheduled.depth = 1 := by
  simp [baseTwoScheduled]

/-- The actual recursive Algorithm-1 schedule. -/
def algorithm : (n : Nat) → ScheduledReversibleProgram n
  | 0 => emptyScheduled 0
  | 1 => emptyScheduled 1
  | 2 => baseTwoScheduled
  | n + 3 =>
      let width := n + 3
      let middleSmall := algorithm (recursiveWidth width)
      let middle := mapScheduledWires
        (recursiveWire width)
        (recursiveWire_injective (n := width))
        middleSmall
      ScheduledReversibleProgram.seq
        (ScheduledReversibleProgram.seq
          (oneLayerScheduled (leftLayer width) (leftLayer_valid width))
          middle)
        (oneLayerScheduled (rightLayer width) (rightLayer_valid width))
termination_by n => n

decreasing_by
  unfold recursiveWidth
  omega

@[simp] theorem algorithm_zero : algorithm 0 = emptyScheduled 0 := rfl
@[simp] theorem algorithm_one : algorithm 1 = emptyScheduled 1 := rfl
@[simp] theorem algorithm_two : algorithm 2 = baseTwoScheduled := rfl

/-- Exact structural equation for the non-base source schedule. -/
theorem algorithm_step
    {n : Nat} (large : 3 ≤ n) :
    algorithm n =
      let middleSmall := algorithm (recursiveWidth n)
      let middle := mapScheduledWires
        (recursiveWire n)
        (recursiveWire_injective (n := n))
        middleSmall
      ScheduledReversibleProgram.seq
        (ScheduledReversibleProgram.seq
          (oneLayerScheduled (leftLayer n) (leftLayer_valid n))
          middle)
        (oneLayerScheduled (rightLayer n) (rightLayer_valid n)) := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_add_of_le large
  rfl

/-- Gate count of the actual schedule obeys exactly the paper recurrence. -/
theorem algorithm_gateCount_eq_recurrence :
    ∀ n, (algorithm n).gateCount = gateRecurrence n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      rcases n with (_ | _ | _ | m)
      · rfl
      · rfl
      · simp [algorithm, gateRecurrence, baseTwoScheduled]
      · have smaller : (m + 3) / 2 < m + 3 := by omega
        have recursive := induction ((m + 3) / 2) smaller
        rw [algorithm_step (n := m + 3) (by omega)]
        simp [recursiveWidth, recursive,
          gateRecurrence, outerCount]

/-- Certified depth of the actual schedule obeys exactly the paper recurrence. -/
theorem algorithm_depth_eq_recurrence :
    ∀ n, (algorithm n).depth = depthRecurrence n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      rcases n with (_ | _ | _ | m)
      · rfl
      · rfl
      · simp [algorithm, depthRecurrence, baseTwoScheduled]
      · have smaller : (m + 3) / 2 < m + 3 := by omega
        have recursive := induction ((m + 3) / 2) smaller
        rw [algorithm_step (n := m + 3) (by omega)]
        simp [recursiveWidth, recursive, depthRecurrence]

/-- Reader-facing gate recurrence directly on the scheduled program. -/
theorem scheduled_gateCount_step
    {n : Nat} (large : 3 ≤ n) :
    (algorithm n).gateCount =
      2 * outerCount n + (algorithm (recursiveWidth n)).gateCount := by
  rw [algorithm_gateCount_eq_recurrence,
    gateRecurrence_step large,
    ← algorithm_gateCount_eq_recurrence]

/-- Reader-facing depth recurrence directly on the scheduled program. -/
theorem scheduled_depth_step
    {n : Nat} (large : 3 ≤ n) :
    (algorithm n).depth = 2 + (algorithm (recursiveWidth n)).depth := by
  rw [algorithm_depth_eq_recurrence,
    depthRecurrence_step large,
    ← algorithm_depth_eq_recurrence]

/-- The schedule is ancilla-free by construction: it lives on exactly the
original `n` input wires. -/
def allocatedQubits (n : Nat) : Nat := n

@[simp] theorem allocatedQubits_eq (n : Nat) : allocatedQubits n = n := rfl

end RemaudVandaeleLadder1AlgorithmSchedule
end QuantumBlockEncoding
