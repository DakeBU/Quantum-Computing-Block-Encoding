import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import Mathlib.Tactic

/-!
# Quantitative gaps in a strictly increasing alpha plan

A strictly increasing natural-number target vector gains at least one physical
wire for every source-index step. This is used when Algorithm 2 compacts its
selected register: deleting at most one target per two source indices cannot
destroy strict monotonicity of alpha-prime.
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
        simp at gapEq
        have dZero : d = 0 := gapEq.symm
        subst d
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
        have gapStep : d = previous.val - i.val + 1 := by
          dsimp [previous]
          omega
        calc
          (plan.target i).val + d =
              (plan.target i).val + (previous.val - i.val) + 1 := by
                rw [gapStep]
                omega
          _ ≤ (plan.target previous).val + 1 :=
              Nat.add_le_add_right recursive 1
          _ ≤ (plan.target j).val := lastStep

/-- Target r lies at least r-alpha0 wires after target 0. -/
theorem target_from_zero_gap
    {q m : Nat} (plan : AlphaPlan q m)
    (index : Fin m) :
    (plan.target ⟨0, by
      have indexLt := index.isLt
      omega⟩).val + index.val ≤
      (plan.target index).val := by
  have indexLt := index.isLt
  let zero : Fin m := ⟨0, by omega⟩
  have source := target_gap_ge_index_gap plan zero index (by simp [zero])
  simpa [zero] using source

end RemaudVandaeleAlphaGap
end QuantumBlockEncoding
