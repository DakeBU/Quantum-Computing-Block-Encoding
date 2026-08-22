import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import Mathlib.Tactic

/-!
# Remaud--Vandaele Algorithm 2: target support

The final Equation-(7) induction should not re-prove noninterference separately
for every physical wire.  This module isolates the structural fact that every
MCX emitted by Algorithm 2 targets one of the parent source alpha targets.

For the embedded recursive child, this is not merely a statement that mapped
targets stay inside `X'`: the exact alpha-prime rank certificate identifies each
mapped child target with the corresponding original physical alpha target.
Thus the theorem below connects the recursive circuit tree back to the source
Definition-6 target set.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaTargetSupport

open MultiControlledXEmbedding
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister

/-- Every gate in the left source wall targets a source alpha target. -/
theorem leftScheduled_target_source
    {q m : Nat} (plan : AlphaPlan q m)
    (gate : MCXGate q) (member : gate ∈ (leftScheduled plan).program) :
    ∃ index : Fin m, gate.target = plan.target index := by
  have layerMember : gate ∈ leftLayer plan := by
    simpa [leftScheduled] using member
  unfold leftLayer at layerMember
  rw [List.mem_ofFn'] at layerMember
  rcases layerMember with ⟨j, rfl⟩
  exact ⟨leftSourceIndex m j, rfl⟩

/-- Every gate in the right source wall targets a source alpha target. -/
theorem rightScheduled_target_source
    {q m : Nat} (plan : AlphaPlan q m)
    (gate : MCXGate q) (member : gate ∈ (rightScheduled plan).program) :
    ∃ index : Fin m, gate.target = plan.target index := by
  have layerMember : gate ∈ rightLayer plan := by
    simpa [rightScheduled] using member
  unfold rightLayer at layerMember
  rw [List.mem_ofFn'] at layerMember
  rcases layerMember with ⟨j, rfl⟩
  exact ⟨rightSourceIndex m j, rfl⟩

/-- Main target-support theorem: every recursively emitted MCX target is one of
the parent source targets `alpha_i`. -/
theorem algorithm_target_source :
    ∀ {q m : Nat} (plan : AlphaPlan q m)
      (gate : MCXGate q),
      gate ∈ (algorithm plan).program →
        ∃ index : Fin m, gate.target = plan.target index := by
  intro q m
  induction m using Nat.strong_induction_on generalizing q with
  | h m induction =>
      intro plan gate member
      rcases m with (_ | _ | r)
      · rw [algorithm_zero] at member
        simp [emptyScheduled] at member
      · rw [algorithm_one] at member
        have baseMember : gate = sourceGate plan ⟨0, by decide⟩ := by
          simpa [baseOne] using member
        subst gate
        exact ⟨⟨0, by decide⟩, rfl⟩
      · let parentM := r + 2
        have recursiveRegime : 2 ≤ parentM := by omega
        let sourceLarge : 3 ≤ parentM + 1 := by omega
        let certificate := canonicalCertificate plan sourceLarge
        let childPlan := recursivePlan plan sourceLarge certificate
        have smaller : recursiveTargetCount parentM < parentM :=
          recursiveTargetCount_lt recursiveRegime
        rw [algorithm_step plan recursiveRegime] at member
        simp only [ScheduledMCXProgram.seq_program, List.mem_append] at member
        rcases member with (leftOrChild | rightMember)
        · rcases leftOrChild with leftMember | childMember
          · exact leftScheduled_target_source plan gate leftMember
          · rw [mapScheduled_program] at childMember
            unfold mapProgram at childMember
            rcases List.mem_map.mp childMember with
              ⟨childGate, childGateMember, mappedEq⟩
            have childTarget :=
              induction (recursiveTargetCount parentM) smaller
                childPlan childGate childGateMember
            rcases childTarget with ⟨j, targetEq⟩
            subst gate
            refine ⟨recursiveOriginalTargetIndex parentM sourceLarge j, ?_⟩
            simp [mapGate, targetEq, childPlan, certificate]
            exact canonical_recursive_target_physical plan sourceLarge j
        · exact rightScheduled_target_source plan gate rightMember

/-- Consequently any physical wire which is not an alpha target cannot be a
target of any gate in the Algorithm-2 program. -/
theorem algorithm_no_target_of_not_alpha
    {q m : Nat} (plan : AlphaPlan q m) (wire : Fin q)
    (notAlpha : ∀ index : Fin m, plan.target index ≠ wire) :
    ∀ gate ∈ (algorithm plan).program, gate.target ≠ wire := by
  intro gate member equal
  rcases algorithm_target_source plan gate member with ⟨index, targetEq⟩
  exact notAlpha index (targetEq.symm.trans equal)

/-- Every non-alpha physical wire is preserved by the complete recursively
synthesized Algorithm-2 circuit. -/
theorem algorithm_preserves_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (notAlpha : ∀ index : Fin m, plan.target index ≠ wire) :
    (algorithm plan).eval state wire = state wire := by
  change evalProgram (algorithm plan).program state wire = state wire
  exact MultiControlledXLayerSemantics.evalProgram_preserves_of_no_target
    (algorithm plan).program wire
    (algorithm_no_target_of_not_alpha plan wire notAlpha) state

/-- The non-alpha branch of Equation (7) is therefore already closed. -/
theorem algorithm_eq_equationSeven_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (notAlpha : ∀ index : Fin m, plan.target index ≠ wire) :
    (algorithm plan).eval state wire = equationSevenAction plan state wire := by
  rw [algorithm_preserves_nonAlpha plan state wire notAlpha]
  symm
  apply equationSeven_nonTarget
  intro hit
  rcases hit with ⟨index, equal⟩
  exact notAlpha index equal

end RemaudVandaeleLadderAlphaTargetSupport
end QuantumBlockEncoding
