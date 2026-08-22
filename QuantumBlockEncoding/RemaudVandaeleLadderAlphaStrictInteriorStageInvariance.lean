import QuantumBlockEncoding.RemaudVandaeleLadderAlphaStageNoninterference
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaStrictInteriorNoninterference
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaStrictInteriorStageInvariance

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaStageNoninterference
open RemaudVandaeleLadderAlphaStrictInteriorNoninterference

/-- The left wall cannot change the strict interior of a nonfirst source gate. -/
theorem strictInteriorActive_leftScheduled_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q)
    (current : Fin m) (nonzero : current.val ≠ 0) :
    strictInteriorActive plan ((leftScheduled plan).eval state) current ↔
      strictInteriorActive plan state current := by
  apply strictInteriorActive_congr_nonAlpha plan
    ((leftScheduled plan).eval state) state current nonzero
  intro wire notAlpha
  exact leftScheduled_preserves_nonAlpha plan state wire notAlpha

/-- The embedded recursive child cannot change a parent strict interior. -/
theorem strictInteriorActive_mappedRecursive_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (state : PrimitiveBasis q)
    (current : Fin m) (nonzero : current.val ≠ 0) :
    strictInteriorActive plan
        ((mapScheduled
          (selectedWire plan large)
          (selectedWire_injective plan large)
          (algorithm
            (recursivePlan plan large (canonicalCertificate plan large)))).eval state)
        current ↔
      strictInteriorActive plan state current := by
  apply strictInteriorActive_congr_nonAlpha plan
    ((mapScheduled
      (selectedWire plan large)
      (selectedWire_injective plan large)
      (algorithm
        (recursivePlan plan large (canonicalCertificate plan large)))).eval state)
    state current nonzero
  intro wire notAlpha
  exact mappedRecursive_preserves_parent_nonAlpha
    plan large state wire notAlpha

/-- The right wall also preserves every strict interior. -/
theorem strictInteriorActive_rightScheduled_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q)
    (current : Fin m) (nonzero : current.val ≠ 0) :
    strictInteriorActive plan ((rightScheduled plan).eval state) current ↔
      strictInteriorActive plan state current := by
  apply strictInteriorActive_congr_nonAlpha plan
    ((rightScheduled plan).eval state) state current nonzero
  intro wire notAlpha
  exact rightScheduled_preserves_nonAlpha plan state wire notAlpha

end RemaudVandaeleLadderAlphaStrictInteriorStageInvariance
end QuantumBlockEncoding
