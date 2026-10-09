```lean
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Tactic


namespace QuantumBlockEncoding.BornStability

open scoped InnerProductSpace Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

noncomputable def probability (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : ℝ :=
  (inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
    (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re

set_option maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in

theorem effect_norm_le_one (P : Matrix ι ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    ‖P‖ ≤ 1 :=
  by
    letI : CStarAlgebra (Matrix ι ι ℂ) := {}
    exact (CStarAlgebra.norm_le_one_iff_of_nonneg (A := Matrix ι ι ℂ) P hP).mpr hPI

theorem unitary_norm_map (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (ψ : EuclideanSpace ℂ ι) :
    ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ‖ = ‖ψ‖ :=
  ContinuousLinearMap.norm_map_of_mem_unitary
    (Unitary.map_mem (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := ι)) hU) ψ


theorem quadratic_difference_le {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] (P : E →L[ℂ] E) (hP : ‖P‖ ≤ 1)
    (x y : E) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    |(inner ℂ x (P x)).re - (inner ℂ y (P y)).re| ≤ 2 * ‖x - y‖ := by
  have split : inner ℂ x (P x) - inner ℂ y (P y) =
      inner ℂ (x - y) (P x) + inner ℂ y (P (x - y)) := by
    simp only [map_sub, inner_sub_left, inner_sub_right]
    ring
  have hPx : ‖P x‖ ≤ 1 := by
    calc
      ‖P x‖ ≤ ‖P‖ * ‖x‖ := P.le_opNorm x
      _ ≤ 1 := by simpa [hx] using hP
  have hPxy : ‖P (x - y)‖ ≤ ‖x - y‖ := by
    calc
      _ ≤ ‖P‖ * ‖x - y‖ := P.le_opNorm _
      _ ≤ ‖x - y‖ := by nlinarith [norm_nonneg (x - y)]
  calc
    _ = |(inner ℂ x (P x) - inner ℂ y (P y)).re| := by simp
    _ ≤ ‖inner ℂ x (P x) - inner ℂ y (P y)‖ := Complex.abs_re_le_norm _
    _ ≤ ‖inner ℂ (x - y) (P x)‖ + ‖inner ℂ y (P (x - y))‖ := by
      rw [split]; exact norm_add_le _ _
    _ ≤ ‖x - y‖ * ‖P x‖ + ‖y‖ * ‖P (x - y)‖ :=
      add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _)
    _ ≤ 2 * ‖x - y‖ := by rw [hy]; nlinarith [norm_nonneg (x - y)]


theorem probability_difference_le (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |probability U P ψ - probability V P ψ| ≤ 2 * η := by
  have hPc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
    rw [Matrix.l2_opNorm_toEuclideanCLM]
    exact effect_norm_le_one P hP hPI
  have hd : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ - Matrix.toEuclideanCLM (𝕜 := ℂ) V ψ‖ ≤ η := by
    calc
      _ = ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V) ψ‖ := by simp
      _ ≤ ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)‖ * ‖ψ‖ :=
        (Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)).le_opNorm ψ
      _ ≤ η := by
        rw [hψ, mul_one, Matrix.l2_opNorm_toEuclideanCLM]
        exact hUV
  exact (quadratic_difference_le _ hPc _ _
    (by rw [unitary_norm_map U hU, hψ])
    (by rw [unitary_norm_map V hV, hψ])).trans (by linarith)



theorem probability_mem_Icc (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    probability U P ψ ∈ Set.Icc (0 : ℝ) 1 := by
  let x := Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ
  have hx : ‖x‖ = 1 := (unitary_norm_map U hU ψ).trans hψ
  have hpos : (Matrix.toEuclideanCLM (𝕜 := ℂ) P).IsPositive := by
    apply (ContinuousLinearMap.isPositive_toLinearMap_iff _).mp
    rw [Matrix.coe_toEuclideanCLM_eq_toEuclideanLin, Matrix.isPositive_toEuclideanLin_iff]
    exact Matrix.nonneg_iff_posSemidef.mp hP
  refine ⟨hpos.re_inner_nonneg_right x, ?_⟩
  change (inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)).re ≤ 1
  calc
    _ ≤ ‖inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)‖ := Complex.re_le_norm _
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P x‖ := norm_inner_le_norm _ _
    _ ≤ 1 := by
      have hc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
        rw [Matrix.l2_opNorm_toEuclideanCLM]
        exact effect_norm_le_one P hP hPI
      have := (Matrix.toEuclideanCLM (𝕜 := ℂ) P).le_opNorm x
      rw [hx, one_mul]
      rw [hx] at this
      simpa using this.trans (by simpa using hc)

end QuantumBlockEncoding.BornStability
```
```lean
import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation


theorem aligned_probability_difference_le {n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    (exact approximate : PrimitiveCircuit n) (ha : Aligned δ exact approximate)
    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
      BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
        (exact.length : ℝ) * δ := by
  have h := BornStability.probability_difference_le
    (evalPrimitiveCircuit approximate) (evalPrimitiveCircuit exact) P ψ hψ
    (evalPrimitiveCircuit_unitary approximate) (evalPrimitiveCircuit_unitary exact)
    hP hPI (aligned_eval_distance_le hδ ha)
  convert h using 1; ring

end QuantumBlockEncoding.CircuitEffectStability
```
