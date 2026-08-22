import QuantumBlockEncoding.RemaudVandaeleLadderAlphaStageNoninterference
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaFirstIntervalNoninterference

open MultiControlledXEmbedding
open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaOuterLayers
open RemaudVandaeleLadderAlphaRankCertificate
open RemaudVandaeleLadderAlphaRecursiveCertificate
open RemaudVandaeleLadderAlphaSelectedRegister
open RemaudVandaeleLadderAlphaStageNoninterference
open RemaudVandaeleLadderAlphaTargetMembership

theorem firstInterval_wire_not_alpha
    {q m : Nat} (plan : AlphaPlan q m)
    (zero : Fin m) (zeroVal : zero.val = 0)
    (wire : Fin q)
    (control : inControlInterval plan zero wire) :
    ∀ source : Fin m, plan.target source ≠ wire := by
  intro source equal
  have sourceOrder : zero.val ≤ source.val := by omega
  have targetOrder := target_le_of_index_le plan sourceOrder
  have upper := control.2
  unfold upperEndpoint at upper
  rw [equal] at targetOrder
  omega

theorem firstIntervalActive_congr_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m)
    (zero : Fin m) (zeroVal : zero.val = 0)
    (left right : PrimitiveBasis q)
    (agree : ∀ wire : Fin q,
      (∀ source : Fin m, plan.target source ≠ wire) →
        left wire = right wire) :
    intervalActive plan left zero ↔ intervalActive plan right zero := by
  constructor
  · intro active wire control
    rw [← agree wire (firstInterval_wire_not_alpha
      plan zero zeroVal wire control)]
    exact active wire control
  · intro active wire control
    rw [agree wire (firstInterval_wire_not_alpha
      plan zero zeroVal wire control)]
    exact active wire control

theorem firstIntervalActive_leftScheduled_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (zero : Fin m) (zeroVal : zero.val = 0)
    (state : PrimitiveBasis q) :
    intervalActive plan ((leftScheduled plan).eval state) zero ↔
      intervalActive plan state zero := by
  apply firstIntervalActive_congr_nonAlpha plan zero zeroVal
  intro wire notAlpha
  exact leftScheduled_preserves_nonAlpha plan state wire notAlpha

theorem firstIntervalActive_mappedRecursive_iff
    {q m : Nat} (plan : AlphaPlan q m) (large : 3 ≤ m + 1)
    (zero : Fin m) (zeroVal : zero.val = 0)
    (state : PrimitiveBasis q) :
    intervalActive plan
        ((mapScheduled
          (selectedWire plan large)
          (selectedWire_injective plan large)
          (algorithm
            (recursivePlan plan large (canonicalCertificate plan large)))).eval state)
        zero ↔
      intervalActive plan state zero := by
  apply firstIntervalActive_congr_nonAlpha plan zero zeroVal
  intro wire notAlpha
  exact mappedRecursive_preserves_parent_nonAlpha
    plan large state wire notAlpha

end RemaudVandaeleLadderAlphaFirstIntervalNoninterference
end QuantumBlockEncoding
