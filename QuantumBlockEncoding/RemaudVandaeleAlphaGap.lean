import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import Mathlib.Tactic

/-!
# Quantitative gaps in a strictly increasing alpha plan

A strictly increasing natural-number target vector gains at least one physical
wire for every source-index step.  This elementary fact is used when Algorithm 2
compacts its selected register: deleting at most one target per two source
indices cannot destroy strict monotonicity of alpha-prime.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleAlphaGap

open RemaudVandaeleLadderAlphaContract

/-- If source indices differ by d, physical target coordinates differ by at
least d. -/
theorem target_gap_ge_index_gap
    {q m : Nat} (plan : AlphaPlan q m)
    (i j : Fin m) (order : i.val ≤ j.val) :
    (plan.target i).val + (j.val - i.val) ≤ (plan.target j).val := by
  generalize gapEq : j.val - i.val = d
  induction d using Nat.strong_induction_on generalizing i j with
  | h d induction =>
      by_cases equal : i = j
      · subst j
        simp
      · have strictIndex : i.val < j.val := by
          have valuesNe : i.val ≠ j.val := by
            intro values
            apply equal
            exact Fin.ext values
          omega
        let previous : Fin m := ⟨j.val - 1, by omega⟩
        have previousOrder : i.val ≤ previous.val := by
          simp [previous]
          omega
        have smaller : previous.val - i.val < d := by
          simp [previous]
          omega
        have recursive := induction (previous.val - i.val) smaller
          i previous previousOrder rfl
        have lastStep :
            (plan.target previous).val + 1 ≤ (plan.target j).val := by
          have strict := plan.strict
            (show previous < j by
              simp [previous]
              omega)
          omega
        simp [previous] at recursive
        omega

/-- In particular, target r lies at least r-alpha0 wires after target 0. -/
theorem target_from_zero_gap
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m) :
    (plan.target ⟨0, by
      have indexLt := index.isLt
      omega⟩).val + index.val ≤
      (plan.target index).val := by
  have indexLt := index.isLt
  let zero : Fin m := ⟨0, by omega⟩
  have source := target_gap_ge_index_gap plan zero index (by
    simp [zero])
  simpa [zero] using source

end RemaudVandaeleAlphaGap
end QuantumBlockEncoding
