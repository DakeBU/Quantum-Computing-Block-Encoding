import QuantumBlockEncoding.MultiControlledXEmbedding
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterLayers
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaResource
import Mathlib.Tactic

/-!
# Complete proof-bearing MCX schedule for Remaud--Vandaele Algorithm 2

All source parameters are now available internally:

* actual depth-one outer MCX walls;
* the ordered physical recursive register X';
* the exact alpha-prime target coordinates inside X';
* an injective MCX schedule wire embedding.

This module therefore assembles the complete recursive Algorithm-2 schedule.
No recursive-register certificate is supplied by the caller: the canonical
rank theorem from the source construction is used directly.

The same scheduled object is then shown to satisfy the exact Appendix
count/depth recurrences.  Semantic refinement to Equation (7) is the next layer.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaAlgorithmSchedule

open MultiControlledXEmbedding
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaResource
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Empty proof-bearing MCX schedule. -/
def emptyScheduled (q : Nat) : ScheduledMCXProgram q where
  layers := []
  valid := by simp [ScheduleValid]

/-- Single source MCX base case (k=2, one alpha target). -/
def baseOne
    {q : Nat} (plan : AlphaPlan q 1) : ScheduledMCXProgram q :=
  oneLayer [sourceGate plan ⟨0, by decide⟩]
    (by simp [LayerValid, WireDisjoint])

@[simp] theorem baseOne_gateCount
    {q : Nat} (plan : AlphaPlan q 1) :
    (baseOne plan).gateCount = 1 := by
  simp [baseOne]

@[simp] theorem baseOne_depth
    {q : Nat} (plan : AlphaPlan q 1) :
    (baseOne plan).depth = 1 := by
  simp [baseOne]

/-- Recursive target count is strictly smaller for m>=2. -/
theorem recursiveTargetCount_lt
    {m : Nat} (large : 2 ≤ m) : recursiveTargetCount m < m := by
  unfold recursiveTargetCount RemaudVandaeleLadderAlphaResource.recursiveK
  omega

/-- Boundary-count identity used by the Appendix recurrence. -/
theorem recursiveBoundaryCount_eq
    {m : Nat} (large : 2 ≤ m) :
    recursiveTargetCount m + 1 = recursiveK (m + 1) := by
  unfold recursiveTargetCount
  have positive : 1 ≤ recursiveK (m + 1) := by
    unfold recursiveK
    omega
  omega

/-- Complete Algorithm-2 scheduled MCX circuit for an arbitrary alpha plan. -/
noncomputable def algorithm :
    {q m : Nat} → AlphaPlan q m → ScheduledMCXProgram q
  | q, 0, plan => emptyScheduled q
  | q, 1, plan => baseOne plan
  | q, m + 2, plan =>
      let large : 3 ≤ (m + 2) + 1 := by omega
      let certificate := canonicalCertificate plan large
      let childPlan := recursivePlan plan large certificate
      let child := algorithm childPlan
      let embedded := mapScheduled
        (selectedWire plan large)
        (selectedWire_injective plan large)
        child
      ScheduledMCXProgram.seq
        (ScheduledMCXProgram.seq (leftScheduled plan) embedded)
        (rightScheduled plan)
termination_by _ q m plan => m

decreasing_by
  exact recursiveTargetCount_lt (m := m + 2) (by omega)

@[simp] theorem algorithm_zero
    {q : Nat} (plan : AlphaPlan q 0) :
    algorithm plan = emptyScheduled q := rfl

@[simp] theorem algorithm_one
    {q : Nat} (plan : AlphaPlan q 1) :
    algorithm plan = baseOne plan := rfl

/-- Reader-facing source structural equation in the recursive regime. -/
theorem algorithm_step
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    algorithm plan =
      let sourceLarge : 3 ≤ m + 1 := by omega
      let certificate := canonicalCertificate plan sourceLarge
      let childPlan := recursivePlan plan sourceLarge certificate
      let child := algorithm childPlan
      let embedded := mapScheduled
        (selectedWire plan sourceLarge)
        (selectedWire_injective plan sourceLarge)
        child
      ScheduledMCXProgram.seq
        (ScheduledMCXProgram.seq (leftScheduled plan) embedded)
        (rightScheduled plan) := by
  obtain ⟨r, rfl⟩ := Nat.exists_eq_add_of_le large
  rfl

/-- Gate count of the actual source schedule obeys the Algorithm-2 recurrence. -/
theorem algorithm_gateCount_step
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    (algorithm plan).gateCount =
      2 * wallCount m +
        (algorithm
          (recursivePlan plan (by omega)
            (canonicalCertificate plan (by omega)))).gateCount := by
  rw [algorithm_step plan large]
  simp [leftScheduled, rightScheduled]
  ring

/-- Depth of the actual source schedule obeys the Algorithm-2 recurrence. -/
theorem algorithm_depth_step
    {q m : Nat} (plan : AlphaPlan q m) (large : 2 ≤ m) :
    (algorithm plan).depth =
      2 +
        (algorithm
          (recursivePlan plan (by omega)
            (canonicalCertificate plan (by omega)))).depth := by
  rw [algorithm_step plan large]
  simp [leftScheduled, rightScheduled]

/-- Exact gate-count recurrence from [9] Appendix Equation (29), now attached
to the actual MCX schedule. -/
theorem algorithm_gateCount_eq_source :
    ∀ {q m : Nat} (plan : AlphaPlan q m),
      (algorithm plan).gateCount = gateRecurrence (m + 1) := by
  intro q m plan
  induction m using Nat.strong_induction_on generalizing q with
  | h m induction =>
      rcases m with (_ | _ | r)
      · rfl
      · simp [algorithm, gateRecurrence, baseOne]
      · let m := r + 2
        have large : 2 ≤ m := by omega
        let sourceLarge : 3 ≤ m + 1 := by omega
        let childPlan := recursivePlan plan sourceLarge
          (canonicalCertificate plan sourceLarge)
        have smaller : recursiveTargetCount m < m :=
          recursiveTargetCount_lt large
        have child := induction (recursiveTargetCount m) smaller childPlan
        rw [algorithm_gateCount_step plan large]
        rw [child]
        rw [gate_step (k := m + 1) (by omega)]
        have boundaries := recursiveBoundaryCount_eq large
        simp [wallCount, boundaryCount, outerCount]
        omega

/-- Exact depth recurrence from [9] Appendix Equation (26), attached to the
same physical MCX schedule. -/
theorem algorithm_depth_eq_source :
    ∀ {q m : Nat} (plan : AlphaPlan q m),
      (algorithm plan).depth = depthRecurrence (m + 1) := by
  intro q m plan
  induction m using Nat.strong_induction_on generalizing q with
  | h m induction =>
      rcases m with (_ | _ | r)
      · rfl
      · simp [algorithm, depthRecurrence, baseOne]
      · let m := r + 2
        have large : 2 ≤ m := by omega
        let sourceLarge : 3 ≤ m + 1 := by omega
        let childPlan := recursivePlan plan sourceLarge
          (canonicalCertificate plan sourceLarge)
        have smaller : recursiveTargetCount m < m :=
          recursiveTargetCount_lt large
        have child := induction (recursiveTargetCount m) smaller childPlan
        rw [algorithm_depth_step plan large]
        rw [child]
        rw [depth_step (k := m + 1) (by omega)]
        have boundaries := recursiveBoundaryCount_eq large
        omega

/-- The actual source schedule therefore has the already-proved uniform MCX
resource bounds, independent of physical interval lengths. -/
theorem algorithm_resources
    {q m : Nat} (plan : AlphaPlan q m) :
    (algorithm plan).gateCount ≤ 2 * (m + 1) ∧
      (algorithm plan).depth ≤ 2 * (Nat.log2 (m + 1) + 1) := by
  rw [algorithm_gateCount_eq_source,
    algorithm_depth_eq_source]
  exact ⟨gateRecurrence_le_two_mul (m + 1),
    depthRecurrence_le_two_log (m + 1)⟩

end RemaudVandaeleLadderAlphaAlgorithmSchedule
end QuantumBlockEncoding
