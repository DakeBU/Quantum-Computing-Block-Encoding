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

This module starts that layer without hiding the hard geometry behind an
assumption.  It exposes the three source stages

`C_L ; embedded Algorithm(X') ; C_R`,

proves that the assembled schedule evaluates exactly as those stages, proves
exact logical readback through the physical `X'` embedding, proves that `C_L`
does not alter the recursive register seen by the child, proves noninterference
outside `X'`, and reduces full Algorithm-2 correctness to one explicit
stagewise Equation-(7) identity.

The next proof node is therefore mathematically sharp: translate the recursive
child's Equation-(7) predicates/targets back to parent physical coordinates and
then characterize the final `C_R` cancellation on the parent alpha targets.
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
stages.  This is the next nontrivial proof obligation, rather than a hidden
certificate field. -/
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
