import QuantumBlockEncoding.QuantumQueryWord
import Mathlib.Data.Real.Sqrt

/-!
Computational-basis output probabilities and squared Hellinger distance for a
single coherent query word. Our squared Hellinger convention is the sum of
squared square-root differences, with NO factor 1/2. The word's unitarity, output
normalization and state distance are derived; they are not extra assumptions.
This module does not treat arbitrary POVMs, reset/adaptive histories or minimax
regret lower bounds.
-/
namespace QuantumBlockEncoding.BasisHellinger

open scoped Matrix.Norms.L2Operator

variable {ι : Type*} [Fintype ι]

/-- Actual probability of coordinate `j` in computational-basis measurement. -/
noncomputable def basisProbability (x : EuclideanSpace ℂ ι) (j : ι) : ℝ := ‖x j‖ ^ 2

/-- The unnormalized convention: no factor `1/2`. -/
noncomputable def hellingerSq (p r : ι → ℝ) : ℝ :=
  ∑ j, (Real.sqrt (p j) - Real.sqrt (r j)) ^ 2

omit [Fintype ι] in
theorem basisProbability_nonneg (x : EuclideanSpace ℂ ι) (j : ι) :
    0 ≤ basisProbability x j := sq_nonneg _

theorem sum_basisProbability (x : EuclideanSpace ℂ ι) :
    ∑ j, basisProbability x j = ‖x‖ ^ 2 :=
  (PiLp.norm_sq_eq_of_L2 (fun _ : ι => ℂ) x).symm

/-- Normalization of the measured distribution follows from vector normalization. -/
theorem basisProbability_normalized (x : EuclideanSpace ℂ ι) (hx : ‖x‖ = 1) :
    ∑ j, basisProbability x j = 1 := by rw [sum_basisProbability, hx]; norm_num

omit [Fintype ι] in
theorem sqrt_basisProbability (x : EuclideanSpace ℂ ι) (j : ι) :
    Real.sqrt (basisProbability x j) = ‖x j‖ := Real.sqrt_sq (norm_nonneg _)

/-- Literal coordinate formula linking actual basis probabilities to Hellinger. -/
theorem hellingerSq_basis_formula (x y : EuclideanSpace ℂ ι) :
    hellingerSq (basisProbability x) (basisProbability y) =
      ∑ j, (‖x j‖ - ‖y j‖) ^ 2 := by
  simp only [hellingerSq, sqrt_basisProbability]

theorem hellingerSq_nonneg (p r : ι → ℝ) : 0 ≤ hellingerSq p r := by
  exact Finset.sum_nonneg (fun _ _ => sq_nonneg _)

/-- Coordinate reverse triangle, followed by the actual Euclidean norm identity. -/
theorem hellingerSq_basis_le (x y : EuclideanSpace ℂ ι) :
    hellingerSq (basisProbability x) (basisProbability y) ≤ ‖x - y‖ ^ 2 := by
  rw [hellingerSq_basis_formula, PiLp.norm_sq_eq_of_L2 (fun _ : ι => ℂ)]
  apply Finset.sum_le_sum
  intro j _
  have h := abs_norm_sub_norm_le (x j) (y j)
  have hs := (sq_le_sq₀ (abs_nonneg (‖x j‖ - ‖y j‖))
    (norm_nonneg (x j - y j))).mpr h
  simpa only [sq_abs, PiLp.sub_apply] using hs

variable [DecidableEq ι]

noncomputable def wordOutput (w : QuantumQueryWord.Word ι) (U : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : EuclideanSpace ℂ ι :=
  Matrix.toEuclideanCLM (𝕜 := ℂ) (QuantumQueryWord.eval w U) ψ

/-- Output normalization is supplied by the evaluator's proved unitarity. -/
theorem wordOutput_norm (w : QuantumQueryWord.Word ι) (U : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hU : U ∈ Matrix.unitaryGroup ι ℂ) :
    ‖wordOutput w U ψ‖ = ‖ψ‖ :=
  BornStability.unitary_norm_map _ (QuantumQueryWord.eval_unitary w U hU) ψ

theorem wordOutput_probability_normalized (w : QuantumQueryWord.Word ι)
    (U : Matrix ι ι ℂ) (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) :
    ∑ j, basisProbability (wordOutput w U ψ) j = 1 := by
  apply basisProbability_normalized
  rw [wordOutput_norm w U ψ hU, hψ]

/-- State distance is derived from the operator telescoping theorem. -/
theorem wordOutput_distance_le (w : QuantumQueryWord.Word ι) (U V : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    ‖wordOutput w U ψ - wordOutput w V ψ‖ ≤ (QuantumQueryWord.queryCount w : ℝ) * η := by
  calc
    _ = ‖Matrix.toEuclideanCLM (𝕜 := ℂ)
        (QuantumQueryWord.eval w U - QuantumQueryWord.eval w V) ψ‖ := by simp [wordOutput]
    _ ≤ ‖Matrix.toEuclideanCLM (𝕜 := ℂ)
        (QuantumQueryWord.eval w U - QuantumQueryWord.eval w V)‖ * ‖ψ‖ :=
      (Matrix.toEuclideanCLM (𝕜 := ℂ)
        (QuantumQueryWord.eval w U - QuantumQueryWord.eval w V)).le_opNorm ψ
    _ ≤ _ := by
      rw [hψ, mul_one, Matrix.l2_opNorm_toEuclideanCLM]
      exact QuantumQueryWord.eval_distance_le w U V hU hV hUV

/-- A real per-word information bound, charged by forward PLUS inverse queries. -/
theorem word_hellingerSq_le (w : QuantumQueryWord.Word ι) (U V : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    hellingerSq (basisProbability (wordOutput w U ψ)) (basisProbability (wordOutput w V ψ))
      ≤ (QuantumQueryWord.queryCount w : ℝ) ^ 2 * η ^ 2 := by
  have hd := wordOutput_distance_le w U V ψ hψ hU hV hUV
  have hη : 0 ≤ η := (norm_nonneg (U - V)).trans hUV
  calc
    _ ≤ ‖wordOutput w U ψ - wordOutput w V ψ‖ ^ 2 := hellingerSq_basis_le _ _
    _ ≤ ((QuantumQueryWord.queryCount w : ℝ) * η) ^ 2 :=
      (sq_le_sq₀ (norm_nonneg _) (mul_nonneg (Nat.cast_nonneg _) hη)).mpr hd
    _ = _ := by ring

/-- The budget refinement is proved from actual query count, not supplied as a
quadratic information assumption. -/
theorem bounded_word_hellingerSq_le (w : QuantumQueryWord.Word ι) (U V : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    {η : ℝ} (hUV : ‖U - V‖ ≤ η) {D : ℕ} (hD : QuantumQueryWord.queryCount w ≤ D) :
    hellingerSq (basisProbability (wordOutput w U ψ)) (basisProbability (wordOutput w V ψ))
      ≤ (D : ℝ) * (QuantumQueryWord.queryCount w : ℝ) * η ^ 2 := by
  have hD' : (QuantumQueryWord.queryCount w : ℝ) ≤ (D : ℝ) := by exact_mod_cast hD
  calc
    _ ≤ (QuantumQueryWord.queryCount w : ℝ) ^ 2 * η ^ 2 :=
      word_hellingerSq_le w U V ψ hψ hU hV hUV
    _ = ((QuantumQueryWord.queryCount w : ℝ) * (QuantumQueryWord.queryCount w : ℝ)) *
        η ^ 2 := by ring
    _ ≤ _ := mul_le_mul_of_nonneg_right
      (mul_le_mul_of_nonneg_right hD' (Nat.cast_nonneg _)) (sq_nonneg η)

end QuantumBlockEncoding.BasisHellinger
