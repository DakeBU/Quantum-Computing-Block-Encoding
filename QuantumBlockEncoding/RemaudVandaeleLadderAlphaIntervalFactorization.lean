import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import Mathlib.Tactic

/-!
# General alpha-ladder interval factorization

For every nonfirst source gate, its contiguous control interval starts at the
previous alpha target.  It is useful to split the source activation into:

1. the predecessor target bit itself; and
2. all strict interior physical wires between the predecessor and current
   target.

This is the semantic factor used by Algorithm 2's ordinary cancellation: the
left wall changes the predecessor bit, while the strict interior is untouched.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaIntervalFactorization

open RemaudVandaeleLadderAlphaContract

/-- All physical wires strictly between the previous and current alpha targets
are one. -/
def strictInteriorActive
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (index : Fin m) : Prop :=
  if first : index.val = 0 then True
  else
    ∀ wire : Fin q,
      (plan.target ⟨index.val - 1, by
        have indexLt := index.isLt
        omega⟩).val < wire.val →
      wire.val < (plan.target index).val →
      state wire = 1

/-- For a nonfirst source gate, Equation-(7) activation factors into the
predecessor alpha bit and the strict interior of the physical interval. -/
theorem intervalActive_nonfirst_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q) (index : Fin m)
    (nonzero : index.val ≠ 0) :
    intervalActive plan state index ↔
      state (plan.target ⟨index.val - 1, by
        have indexLt := index.isLt
        omega⟩) = 1 ∧
        strictInteriorActive plan state index := by
  have indexLt := index.isLt
  let previous : Fin m := ⟨index.val - 1, by omega⟩
  have previousLt : previous < index := by
    change previous.val < index.val
    simp [previous]
    omega
  have targetStrict :
      (plan.target previous).val < (plan.target index).val :=
    plan.strict previousLt
  have lowerEq : lowerEndpoint plan index = (plan.target previous).val := by
    simp [lowerEndpoint, nonzero, previous]
  constructor
  · intro active
    constructor
    · apply active (plan.target previous)
      unfold inControlInterval
      constructor
      · rw [lowerEq]
      · exact targetStrict
    · simp [strictInteriorActive, nonzero]
      intro wire lower upper
      apply active wire
      unfold inControlInterval
      constructor
      · rw [lowerEq]
        exact lower.le
      · exact upper
  · rintro ⟨previousOne, interior⟩ wire interval
    unfold inControlInterval at interval
    have lower : (plan.target previous).val ≤ wire.val := by
      rw [← lowerEq]
      exact interval.1
    have upper : wire.val < (plan.target index).val := interval.2
    by_cases same : wire = plan.target previous
    · subst wire
      exact previousOne
    · have valueNe : wire.val ≠ (plan.target previous).val := by
        intro equal
        apply same
        apply Fin.ext
        exact equal
      have strictLower : (plan.target previous).val < wire.val := by omega
      have interior' := interior
      simp [strictInteriorActive, nonzero] at interior'
      exact interior' wire strictLower upper

/-- Reader-facing form using the previous source index explicitly. -/
theorem intervalActive_succIndex_iff
    {q m : Nat} (plan : AlphaPlan q m)
    (state : PrimitiveBasis q)
    (previous current : Fin m)
    (successor : current.val = previous.val + 1) :
    intervalActive plan state current ↔
      state (plan.target previous) = 1 ∧
        strictInteriorActive plan state current := by
  have currentLt := current.isLt
  have nonzero : current.val ≠ 0 := by omega
  have previousEq :
      (⟨current.val - 1, by omega⟩ : Fin m) = previous := by
    apply Fin.ext
    change current.val - 1 = previous.val
    omega
  rw [intervalActive_nonfirst_iff plan state current nonzero, previousEq]

end RemaudVandaeleLadderAlphaIntervalFactorization
end QuantumBlockEncoding
