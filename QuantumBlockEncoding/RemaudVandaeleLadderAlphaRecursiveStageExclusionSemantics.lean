import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveTargetExclusion
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetSupport
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaRecursiveStageExclusionSemantics

open MultiControlledXEmbedding
open MultiControlledXLayerSemantics
open MultiControlledXSchedule
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaRecursiveParameters
open RemaudVandaeleLadderAlphaRecursiveTargetExclusion
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaTargetSupport

theorem mappedRecursive_preserves_sourceTarget_of_excluded
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) (index : Fin m)
    (excluded : ∀ j : Fin (recursiveTargetCount m),
      recursiveOriginalTargetIndex m large j ≠ index) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state (plan.target index) = state (plan.target index) := by
  let childPlan := recursivePlan plan large (canonicalCertificate plan large)
  change evalProgram
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm childPlan)).program state (plan.target index) =
      state (plan.target index)
  apply evalProgram_preserves_of_no_target
  intro mappedGate member
  rw [mapScheduled_program] at member
  unfold mapProgram at member
  rcases List.mem_map.mp member with ⟨childGate, childMember, rfl⟩
  rcases algorithm_target_source childPlan childGate childMember with
    ⟨j, childTarget⟩
  change selectedWire plan large childGate.target ≠ plan.target index
  rw [childTarget, canonical_recursive_target_physical plan large j]
  intro targetEqual
  exact excluded j (target_injective plan targetEqual)

theorem mappedRecursive_preserves_zeroTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state (plan.target ⟨0, by omega⟩) =
      state (plan.target ⟨0, by omega⟩) := by
  apply mappedRecursive_preserves_sourceTarget_of_excluded
  intro j
  exact recursiveOriginalTargetIndex_ne_zero m large j

theorem mappedRecursive_preserves_ordinaryOddTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) (index : Fin m)
    (odd : index.val % 2 = 1)
    (beforeTail : index.val + 2 < m) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state (plan.target index) = state (plan.target index) := by
  apply mappedRecursive_preserves_sourceTarget_of_excluded
  intro j
  exact recursiveOriginalTargetIndex_ne_ordinaryOdd
    m large j index odd beforeTail

theorem mappedRecursive_preserves_finalTarget
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q) :
    (mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm (recursivePlan plan large (canonicalCertificate plan large)))).eval
      state (plan.target ⟨m - 1, by omega⟩) =
      state (plan.target ⟨m - 1, by omega⟩) := by
  apply mappedRecursive_preserves_sourceTarget_of_excluded
  intro j
  exact recursiveOriginalTargetIndex_ne_final m large j

end RemaudVandaeleLadderAlphaRecursiveStageExclusionSemantics
end QuantumBlockEncoding
