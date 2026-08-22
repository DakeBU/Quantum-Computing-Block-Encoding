import QuantumBlockEncoding.RemaudVandaeleLadderAlphaIntervalFactorization
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetMembership
import Mathlib.Tactic

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaStrictInteriorNoninterference

open RemaudVandaeleLadderAlphaContract
open RemaudVandaeleLadderAlphaIntervalFactorization
open RemaudVandaeleLadderAlphaTargetMembership

/-- A physical wire strictly between two consecutive alpha targets is not itself
any alpha target. -/
theorem strictInterior_wire_not_alpha
    {q m : Nat} (plan : AlphaPlan q m)
    (current : Fin m) (nonzero : current.val ≠ 0)
    (wire : Fin q)
    (lower :
      (plan.target ⟨current.val - 1, by omega⟩).val < wire.val)
    (upper : wire.val < (plan.target current).val) :
    ∀ source : Fin m, plan.target source ≠ wire := by
  let previous : Fin m := ⟨current.val - 1, by omega⟩
  intro source equal
  have equalVal := congrArg Fin.val equal
  by_cases before : source.val ≤ previous.val
  · have targetBefore := target_le_of_index_le plan before
    dsimp [previous] at targetBefore
    omega
  · have currentBeforeSource : current.val ≤ source.val := by
      dsimp [previous] at before
      omega
    have targetAfter := target_le_of_index_le plan currentBeforeSource
    omega

/-- Any two parent states agreeing on every non-alpha wire have the same strict
interior activation at a nonfirst source target. -/
theorem strictInteriorActive_congr_nonAlpha
    {q m : Nat} (plan : AlphaPlan q m)
    (left right : PrimitiveBasis q)
    (current : Fin m) (nonzero : current.val ≠ 0)
    (agree : ∀ wire : Fin q,
      (∀ source : Fin m, plan.target source ≠ wire) →
        left wire = right wire) :
    strictInteriorActive plan left current ↔
      strictInteriorActive plan right current := by
  have transfer :
      ∀ wire : Fin q,
        (plan.target ⟨current.val - 1, by omega⟩).val < wire.val →
        wire.val < (plan.target current).val →
        left wire = right wire := by
    intro wire lower upper
    exact agree wire
      (strictInterior_wire_not_alpha plan current nonzero wire lower upper)
  simp [strictInteriorActive, nonzero]
  constructor
  · intro active wire lower upper
    rw [← transfer wire lower upper]
    exact active wire lower upper
  · intro active wire lower upper
    rw [transfer wire lower upper]
    exact active wire lower upper

end RemaudVandaeleLadderAlphaStrictInteriorNoninterference
end QuantumBlockEncoding
