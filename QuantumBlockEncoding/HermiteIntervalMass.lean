import QuantumBlockEncoding.HermiteStatePreparation
import Mathlib.NumberTheory.Bernoulli
import Mathlib.Algebra.Field.GeomSum

/-!
# Exact discrete squared-mass formulas for the Hermite target

These are algebraic evaluation leaves, not a state-preparation circuit or a
free arithmetic oracle. Polynomial mass uses a degree-sized Faulhaber sum;
exponential mass uses a geometric sum. The sampled amplitudes remain the
function values, so every mass below sums their squares.
-/

namespace QuantumBlockEncoding.HermiteIntervalMass

open Polynomial Finset

noncomputable section

/-- A power sum with iteration bound depending on the degree, not sample count. -/
def powerSumClosed (count degree : ℕ) : ℚ :=
  ∑ i ∈ Finset.range (degree + 1),
    _root_.bernoulli i * ((degree + 1).choose i) *
      (count : ℚ) ^ (degree + 1 - i) / (degree + 1)

/-- Mathlib's exact Faulhaber theorem, exposed over the real target field. -/
theorem powerSumClosed_eq (count degree : ℕ) :
    (powerSumClosed count degree : ℝ) =
      ∑ j ∈ Finset.range count, (j : ℝ) ^ degree := by
  unfold powerSumClosed
  exact_mod_cast (_root_.sum_range_pow count degree).symm

/-- Square the actual polynomial amplitude after an affine index substitution. -/
def affineSquared (p : ℝ[X]) (start step : ℝ) : ℝ[X] :=
  (p.comp (C start + C step * X)) ^ 2

@[simp] theorem affineSquared_eval (p : ℝ[X]) (start step x : ℝ) :
    (affineSquared p start step).eval x = (p.eval (start + step * x)) ^ 2 := by
  simp [affineSquared]

/-- A supplied degree bound gives a fixed-size expression for discrete mass. -/
def polynomialMassClosed (p : ℝ[X]) (start step : ℝ) (count bound : ℕ) : ℝ :=
  ∑ r ∈ Finset.range (bound + 1),
    (affineSquared p start step).coeff r * (powerSumClosed count r : ℝ)

/-- Exact arbitrary-count identity; no quadrature or continuum substitution. -/
theorem polynomialMassClosed_eq (p : ℝ[X]) (start step : ℝ) (count bound : ℕ)
    (h : (affineSquared p start step).natDegree ≤ bound) :
    polynomialMassClosed p start step count bound =
      ∑ j ∈ Finset.range count, (p.eval (start + step * j)) ^ 2 := by
  unfold polynomialMassClosed
  simp_rw [powerSumClosed_eq, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro j hj
  rw [← Polynomial.eval_eq_sum_range' (Nat.lt_succ_of_le h)]
  exact affineSquared_eval p start step j

theorem affineSquared_degree (p : ℝ[X]) (start step : ℝ) :
    (affineSquared p start step).natDegree ≤ 2 * p.natDegree := by
  have haff : (C start + C step * X : ℝ[X]).natDegree ≤ 1 := by
    apply (natDegree_add_le _ _).trans
    apply max_le
    · simp
    · exact (natDegree_C_mul_le step (X : ℝ[X])).trans (by simp)
  have hcomp : (p.comp (C start + C step * X)).natDegree ≤ p.natDegree := by
    rw [natDegree_comp]
    simpa using Nat.mul_le_mul_left p.natDegree haff
  unfold affineSquared
  rw [natDegree_pow]
  simpa [Nat.mul_comm] using Nat.mul_le_mul_right 2 hcomp

/-- At most `4*k+3` coefficient terms suffice for every affine progression. -/
theorem hermite_affineSquared_degree (k : ℕ) (start step : ℝ) :
    (affineSquared (HermitePolynomial.sourceInterpolant k) start step).natDegree ≤
      4 * k + 2 := by
  apply (affineSquared_degree _ _ _).trans
  have h := Nat.mul_le_mul_left 2 (HermitePolynomial.sourceInterpolant_degree k)
  omega

/-- The exact discrete squared mass of the polynomial branch, at arbitrary width. -/
theorem hermite_polynomial_mass (k count : ℕ) (start step : ℝ) :
    polynomialMassClosed (HermitePolynomial.sourceInterpolant k) start step count
      (4 * k + 2) =
    ∑ j ∈ Finset.range count,
      ((HermitePolynomial.sourceInterpolant k).eval (start + step * j)) ^ 2 :=
  polynomialMassClosed_eq _ _ _ _ _ (hermite_affineSquared_degree k start step)

/-- Explicit finite exponential mass, including the zero-step corner case. -/
def exponentialMassClosed (start step : ℝ) (count : ℕ) : ℝ :=
  if step = 0 then (count : ℝ) * Real.exp (2 * start)
  else Real.exp (2 * start) *
    ((Real.exp (2 * step)) ^ count - 1) / (Real.exp (2 * step) - 1)

/-- Exact geometric mass of squared exponential amplitudes. -/
theorem exponentialMassClosed_eq (start step : ℝ) (count : ℕ) :
    exponentialMassClosed start step count =
      ∑ j ∈ Finset.range count, (Real.exp (start + step * j)) ^ 2 := by
  have hterm (j : ℕ) :
      (Real.exp (start + step * j)) ^ 2 =
        Real.exp (2 * start) * (Real.exp (2 * step)) ^ j := by
    rw [← Real.exp_nat_mul, ← Real.exp_nat_mul, ← Real.exp_add]
    congr 1
    push_cast
    ring
  simp_rw [hterm]
  rw [← Finset.mul_sum]
  unfold exponentialMassClosed
  split_ifs with hs
  · simp [hs, mul_comm]
  · have hexp : Real.exp (2 * step) ≠ 1 := by
      intro he
      have hz : 2 * step = 0 := Real.exp_injective (by simpa using he)
      exact hs (by linarith)
    rw [geom_sum_eq hexp]
    ring

/-- The positive exponential branch uses the same formula with negated grid. -/
theorem right_exponential_mass (start step : ℝ) (count : ℕ) :
    exponentialMassClosed (-start) (-step) count =
      ∑ j ∈ Finset.range count, (Real.exp (-(start + step * j))) ^ 2 := by
  rw [exponentialMassClosed_eq]
  apply Finset.sum_congr rfl
  intro j hj
  congr 2
  ring

/-- On the middle branch the formula is the frozen `smoothInitial` mass. -/
theorem smoothInitial_middle_mass (k count : ℕ) (start step : ℝ)
    (h : ∀ j ∈ Finset.range count, start + step * j ∈ Set.Icc (-1) 0) :
    polynomialMassClosed (HermitePolynomial.sourceInterpolant k) start step count
      (4 * k + 2) =
    ∑ j ∈ Finset.range count,
      (HermitePolynomial.smoothInitial k (start + step * j)) ^ 2 := by
  rw [hermite_polynomial_mass]
  apply Finset.sum_congr rfl
  intro j hj
  rw [HermitePolynomial.smoothInitial_middle k _ (h j hj)]

/-- The left-tail formula concerns the function amplitude, not its square root. -/
theorem smoothInitial_left_mass (k count : ℕ) (start step : ℝ)
    (h : ∀ j ∈ Finset.range count, start + step * j < -1) :
    exponentialMassClosed start step count =
      ∑ j ∈ Finset.range count,
        (HermitePolynomial.smoothInitial k (start + step * j)) ^ 2 := by
  rw [exponentialMassClosed_eq]
  apply Finset.sum_congr rfl
  intro j hj
  rw [HermitePolynomial.smoothInitial_left k _ (h j hj)]

/-- The right-tail formula is equally a statement about the exact frozen target. -/
theorem smoothInitial_right_mass (k count : ℕ) (start step : ℝ)
    (h : ∀ j ∈ Finset.range count, 0 < start + step * j) :
    exponentialMassClosed (-start) (-step) count =
      ∑ j ∈ Finset.range count,
        (HermitePolynomial.smoothInitial k (start + step * j)) ^ 2 := by
  rw [right_exponential_mass]
  apply Finset.sum_congr rfl
  intro j hj
  rw [HermitePolynomial.smoothInitial_right k _ (h j hj)]

/-- The splice passes through amplitude one, independently of smoothing order. -/
theorem smoothInitial_zero (k : ℕ) : HermitePolynomial.smoothInitial k 0 = 1 := by
  rw [HermitePolynomial.smoothInitial_middle k 0 (by constructor <;> norm_num)]
  simpa using HermitePolynomial.sourceInterpolant_right_jet k 0 (Nat.zero_le k)

/-- The central sample in a nonempty qubit register, in the frozen LE indexing. -/
def centralIndex (n : ℕ) : Fin (gridSize (n + 1)) :=
  ⟨2 ^ n, by
    change 2 ^ n < 2 ^ (n + 1)
    rw [pow_succ]
    have h : 0 < 2 ^ n := pow_pos (by decide) n
    omega⟩

theorem gridPoint_central (n : ℕ) (L : ℝ) :
    HermiteStatePreparation.gridPoint (n + 1) L (centralIndex n) = 0 := by
  simp only [HermiteStatePreparation.gridPoint, centralIndex, gridSize,
    Nat.cast_pow, Nat.cast_ofNat, pow_succ]
  have hn : (2 : ℝ) ^ n ≠ 0 := pow_ne_zero n (by norm_num)
  field_simp
  push_cast
  ring

/-- A width-uniform conditioning anchor: the unnormalized squared norm is at
least one. This uses the actual grid's central sample, not a positivity oracle. -/
theorem sampled_mass_ge_one (k n : ℕ) (L : ℝ) :
    1 ≤ ∑ j : Fin (gridSize (n + 1)),
      (HermiteStatePreparation.sampledAmplitude k (n + 1) L j) ^ 2 := by
  have hc : HermiteStatePreparation.sampledAmplitude k (n + 1) L (centralIndex n) = 1 := by
    rw [HermiteStatePreparation.sampledAmplitude, gridPoint_central, smoothInitial_zero]
  have h := Finset.single_le_sum
    (f := fun j : Fin (gridSize (n + 1)) =>
      (HermiteStatePreparation.sampledAmplitude k (n + 1) L j) ^ 2)
    (fun j _ => sq_nonneg _) (Finset.mem_univ (centralIndex n))
  simpa only [hc, one_pow] using h

end

end QuantumBlockEncoding.HermiteIntervalMass
