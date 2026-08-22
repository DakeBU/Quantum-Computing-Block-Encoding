import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedNoninterference
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: semantic refinement spine

`RemaudVandaeleLadderAlphaAlgorithmSchedule` already constructs the complete
proof-bearing Algorithm-2 MCX schedule, proves the physical recursive register
`X'`, identifies every recursive `alpha'` rank, and closes the exact source
count/depth recurrences.

The remaining theorem is semantic: the actual recursive schedule must refine
the closed-form input-state target `equationSevenAction` from Definition 6 /
Equation (7).

This module exposes the three source stages

`C_L ; embedded Algorithm(X') ; C_R`,

proves exact logical readback through the physical `X'` embedding, proves that
`C_L` does not alter the recursive register seen by the child, and isolates the
recursive-target bridge needed by the final Equation-(7) induction.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaAlgorithmSemantics

open MultiControlledXEmbedding
open MultiControlledXSchedule
open MultiControlledXScheduleSemantics
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaSelectedNoninterference
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Source-facing semantic correctness proposition for one alpha plan. -/
def AlgorithmSpec {q m : Nat} (plan : AlphaPlan q m) : Prop :=
  ∀ state,
    (algorithm plan).eval state = equationSevenAction plan state

/-- State after the left source wall `C_L`. -/
def afterLeft {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) : PrimitiveBasis q :=
  (leftScheduled plan).eval state

/-- The recursively synthesized child, embedded into the actual physical
subregister `X'`. -/
noncomputable def middleScheduled
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    ScheduledMCXProgram q :=
  let certificate := canonicalCertificate plan large
  let childPlan := recursivePlan plan large certificate
  mapScheduled
    (selectedWire plan large)
    (selectedWire_injective plan large)
    (algorithm childPlan)

/-- State after `C_L` and the embedded recursive child. -/
noncomputable def afterMiddle
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) : PrimitiveBasis q :=
  (middleScheduled plan large).eval (afterLeft plan state)

/-- State after the full recursive source decomposition
`C_L ; Algorithm(X') ; C_R`. -/
noncomputable def afterRight
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) : PrimitiveBasis q :=
  (rightScheduled plan).eval (afterMiddle plan large state)

/-- The recursive schedule definition evaluates exactly as the three source
stages `C_L ; Algorithm(X') ; C_R`. -/
theorem algorithm_step_eval
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    (algorithm plan).eval state = afterRight plan large state := by
  have recursiveRegime : 2 ≤ m := by omega
  rw [algorithm_step plan recursiveRegime]
  simp [afterRight, afterMiddle, afterLeft, middleScheduled, seq_eval]

/-- Exact logical readback theorem for the recursive middle stage.  No semantic
property of the child is assumed here: this is purely the certified physical
embedding theorem. -/
theorem middle_readback
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    readEmbedded (selectedWire plan large) (afterMiddle plan large state) =
      (algorithm
        (recursivePlan plan large (canonicalCertificate plan large))).eval
        (readEmbedded (selectedWire plan large) (afterLeft plan state)) := by
  unfold afterMiddle middleScheduled
  exact readEmbedded_evalScheduled
    (selectedWire plan large)
    (selectedWire_injective plan large)
    (algorithm (recursivePlan plan large (canonicalCertificate plan large)))
    (afterLeft plan state)

/-- Because `C_L` targets only deleted odd alpha wires (plus the final source
target beyond `X'`), the recursive child sees the *original parent input*
restricted to `X'`.  This is the exact induction entrance for Algorithm 2. -/
theorem middle_readback_from_original
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    readEmbedded (selectedWire plan large) (afterMiddle plan large state) =
      (algorithm
        (recursivePlan plan large (canonicalCertificate plan large))).eval
        (readEmbedded (selectedWire plan large) state) := by
  rw [middle_readback]
  have leftReadback :
      readEmbedded (selectedWire plan large) (afterLeft plan state) =
        readEmbedded (selectedWire plan large) state := by
    simpa [afterLeft] using readEmbedded_leftScheduled plan large state
  rw [leftReadback]

/-- Recursive-target semantic bridge.  Once the child satisfies Equation (7),
its `j`-th alpha-prime target can be read directly as the corresponding parent
physical alpha target.  The left wall has disappeared completely from the
induction hypothesis: the child is evaluated on the original parent input
restricted to `X'`. -/
theorem middle_recursiveTarget_action
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (j : Fin (RemaudVandaeleLadderAlphaRecursiveParameters.recursiveTargetCount m))
    (childCorrect : AlgorithmSpec
      (recursivePlan plan large (canonicalCertificate plan large))) :
    afterMiddle plan large state
        (plan.target
          (RemaudVandaeleLadderAlphaRecursiveParameters.recursiveOriginalTargetIndex
            m large j)) =
      equationSevenAction
        (recursivePlan plan large (canonicalCertificate plan large))
        (readEmbedded (selectedWire plan large) state)
        ((recursivePlan plan large (canonicalCertificate plan large)).target j) := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  have readback := congrFun
    (middle_readback_from_original plan large state)
    (childPlan.target j)
  have physical :
      selectedWire plan large (childPlan.target j) =
        plan.target
          (RemaudVandaeleLadderAlphaRecursiveParameters.recursiveOriginalTargetIndex
            m large j) := by
    simpa [childPlan] using canonical_recursive_target_physical plan large j
  have childSemantics :=
    childCorrect (readEmbedded (selectedWire plan large) state)
  change
    afterMiddle plan large state
        (plan.target
          (RemaudVandaeleLadderAlphaRecursiveParameters.recursiveOriginalTargetIndex
            m large j)) =
      equationSevenAction childPlan
        (readEmbedded (selectedWire plan large) state)
        (childPlan.target j)
  rw [physical] at readback
  rw [childSemantics] at readback
  exact readback

/-- The recursive middle stage cannot modify a physical wire outside the image
of the selected recursive register `X'`. -/
theorem middle_preserves_outside
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) (wire : Fin q)
    (outside : ∀ logical, selectedWire plan large logical ≠ wire) :
    afterMiddle plan large state wire = afterLeft plan state wire := by
  unfold afterMiddle middleScheduled
  exact evalMappedScheduled_outside
    (selectedWire plan large)
    (selectedWire_injective plan large)
    (algorithm (recursivePlan plan large (canonicalCertificate plan large)))
    (afterLeft plan state) wire outside

/-- Full Algorithm-2 semantic correctness in the recursive regime is now
*equivalent* to one explicit local Equation-(7) identity for the three source
stages. -/
theorem algorithmSpec_iff_stagewiseEquationSeven
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1) :
    AlgorithmSpec plan ↔
      ∀ state, afterRight plan large state = equationSevenAction plan state := by
  constructor
  · intro correctness state
    rw [← algorithm_step_eval plan large state]
    exact correctness state
  · intro stagewise state
    rw [algorithm_step_eval plan large state]
    exact stagewise state

end RemaudVandaeleLadderAlphaAlgorithmSemantics
end QuantumBlockEncoding
