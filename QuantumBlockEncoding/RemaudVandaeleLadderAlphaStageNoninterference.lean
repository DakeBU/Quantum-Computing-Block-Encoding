import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetSupport
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaStageNoninterference

open MultiControlledXEmbedding
open MultiControlledXLayerSemantics
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetSupport

/-- The left outer wall preserves every parent non-alpha wire. -/
theorem leftScheduled_preserves_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (notAlpha : ∀ index : Fin m, plan.target index ≠ wire) :
    (leftScheduled plan).eval state wire = state wire := by
  change evalProgram (leftScheduled plan).program state wire = state wire
  apply evalProgram_preserves_of_no_target
  intro gate member
  rcases leftScheduled_target_source plan gate member with ⟨index, targetEq⟩
  rw [targetEq]
  exact notAlpha index

/-- The right outer wall preserves every parent non-alpha wire. -/
theorem rightScheduled_preserves_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (wire : Fin q)
    (notAlpha : ∀ index : Fin m, plan.target index ≠ wire) :
    (rightScheduled plan).eval state wire = state wire := by
  change evalProgram (rightScheduled plan).program state wire = state wire
  apply evalProgram_preserves_of_no_target
  intro gate member
  rcases rightScheduled_target_source plan gate member with ⟨index, targetEq⟩
  rw [targetEq]
  exact notAlpha index

/-- The embedded recursive child also preserves every parent non-alpha wire.
The exact physical alpha-prime certificate identifies each mapped child target
with a parent alpha target. -/
theorem mappedRecursive_preserves_parent_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) (wire : Fin q)
    (notAlpha : ∀ index : Fin m, plan.target index ≠ wire) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state wire = state wire := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  change evalProgram
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm childPlan)).program state wire = state wire
  apply evalProgram_preserves_of_no_target
  intro mappedGate member
  rw [mapScheduled_program] at member
  unfold mapProgram at member
  rcases List.mem_map.mp member with ⟨childGate, childMember, rfl⟩
  rcases algorithm_target_source childPlan childGate childMember with
    ⟨j, childTarget⟩
  simp only [mapGate_target]
  rw [childTarget]
  rw [canonical_recursive_target_physical plan large j]
  exact notAlpha (recursiveOriginalTargetIndex m large j)

end RemaudVandaeleLadderAlphaStageNoninterference
end QuantumBlockEncoding
