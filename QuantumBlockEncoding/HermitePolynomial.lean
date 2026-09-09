import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.Analysis.Calculus.IteratedDeriv.Lemmas
import Mathlib.Algebra.Polynomial.Taylor
import Mathlib.Algebra.Polynomial.FieldDivision
import Mathlib.RingTheory.PowerSeries.Exp
import Mathlib.RingTheory.PowerSeries.WellKnown
import Mathlib.RingTheory.PowerSeries.Trunc
import Mathlib.Tactic

/-!
# Two-point Hermite interpolation for smooth initial data

The source polynomial `sourceInterpolant` is the positive closed form obtained
by truncating `exp(X)/(1-X)^(k+1)`. All endpoint jets and positivity are proved
from its coefficients. An independent extended-Euclid construction is retained
as a reusable two-point interpolation interface. The source contract is the
smooth initial datum in arXiv:2403.19123v3, Section 4.3, equations (4.31)-(4.32).
-/

noncomputable section

open Polynomial

namespace QuantumBlockEncoding.HermitePolynomial

/-- The truncated Taylor polynomial with the prescribed ordinary derivatives. -/
def jetPolynomial (a : ℝ) (k : ℕ) (v : ℕ → ℝ) : ℝ[X] :=
  taylor (-a) (∑ j ∈ Finset.range (k + 1), monomial j (v j / (j.factorial : ℝ)))

/-- Convert Taylor coefficients to ordinary iterated derivatives. -/
theorem eval_iterate_derivative (p : ℝ[X]) (a : ℝ) (j : ℕ) :
    (derivative^[j] p).eval a = (j.factorial : ℝ) * (taylor a p).coeff j := by
  rw [taylor_coeff, ← factorial_smul_hasseDeriv]
  simp [nsmul_eq_mul]

/-- Every requested jet is realized by its local Taylor polynomial. -/
theorem jetPolynomial_jet (a : ℝ) (k j : ℕ) (v : ℕ → ℝ) (hj : j ≤ k) :
    (derivative^[j] (jetPolynomial a k v)).eval a = v j := by
  rw [eval_iterate_derivative]
  simp only [jetPolynomial, taylor_taylor, add_neg_cancel, taylor_zero]
  rw [finset_sum_coeff]
  simp only [coeff_monomial]
  rw [Finset.sum_eq_single j]
  · simp only [ite_true]
    field_simp
  · intro b hb hbj
    simp [hbj]
  · simp [Finset.mem_range, Nat.lt_succ_of_le hj]

/-- A high-multiplicity zero preserves all derivatives below the multiplicity. -/
theorem jet_eq_of_pow_dvd_sub (p q : ℝ[X]) (a : ℝ) (k j : ℕ)
    (hj : j ≤ k) (h : (X - C a) ^ (k + 1) ∣ p - q) :
    (derivative^[j] p).eval a = (derivative^[j] q).eval a := by
  have hd := pow_sub_dvd_iterate_derivative_of_pow_dvd j h
  have hj' : 1 ≤ k + 1 - j := by omega
  have hx' : X - C a ∣ (X - C a) ^ (k + 1 - j) := by
    simpa only [pow_one] using (pow_dvd_pow (X - C a) hj')
  have hx : X - C a ∣ derivative^[j] (p - q) := hx'.trans hd
  obtain ⟨r, hr⟩ := hx
  have he := congrArg (fun f : ℝ[X] => f.eval a) hr
  simpa [iterate_derivative_sub, sub_eq_zero] using he

/-- The inverse constant that normalizes the extended-gcd identity. -/
def bezoutNormalizer (A B : ℝ[X]) : ℝ[X] :=
  C ((EuclideanDomain.gcd A B).coeff 0)⁻¹

theorem bezoutNormalizer_gcd (A B : ℝ[X]) (h : IsCoprime A B) :
    bezoutNormalizer A B * EuclideanDomain.gcd A B = 1 := by
  have hg : IsUnit (EuclideanDomain.gcd A B) :=
    EuclideanDomain.gcd_isUnit_iff.mpr h
  obtain ⟨r, hr, hgr⟩ := Polynomial.isUnit_iff.mp hg
  unfold bezoutNormalizer
  rw [← hgr]
  simp only [coeff_C_zero, ← C_mul, inv_mul_cancel₀ hr.ne_zero, C_1]

/-- An explicit Chinese-remainder interpolant, using extended Euclid. -/
def twoPointInterpolant (A B u v : ℝ[X]) : ℝ[X] :=
  (bezoutNormalizer A B *
    (B * EuclideanDomain.gcdB A B * u + A * EuclideanDomain.gcdA A B * v)) %
    (A * B)

theorem twoPointInterpolant_left (A B u v : ℝ[X]) (h : IsCoprime A B) :
    A ∣ twoPointInterpolant A B u v - u := by
  have he : bezoutNormalizer A B *
      (A * EuclideanDomain.gcdA A B + B * EuclideanDomain.gcdB A B) = 1 := by
    rw [← EuclideanDomain.gcd_eq_gcd_ab]
    exact bezoutNormalizer_gcd A B h
  unfold twoPointInterpolant
  rw [EuclideanDomain.mod_eq_sub_mul_div]
  refine ⟨bezoutNormalizer A B * EuclideanDomain.gcdA A B * (v - u) -
    B * ((bezoutNormalizer A B *
      (B * EuclideanDomain.gcdB A B * u + A * EuclideanDomain.gcdA A B * v)) /
      (A * B)), ?_⟩
  calc
    _ = _ - u * (bezoutNormalizer A B *
        (A * EuclideanDomain.gcdA A B + B * EuclideanDomain.gcdB A B)) := by
      rw [he, mul_one]
    _ = _ := by ring

theorem twoPointInterpolant_right (A B u v : ℝ[X]) (h : IsCoprime A B) :
    B ∣ twoPointInterpolant A B u v - v := by
  have he : bezoutNormalizer A B *
      (A * EuclideanDomain.gcdA A B + B * EuclideanDomain.gcdB A B) = 1 := by
    rw [← EuclideanDomain.gcd_eq_gcd_ab]
    exact bezoutNormalizer_gcd A B h
  unfold twoPointInterpolant
  rw [EuclideanDomain.mod_eq_sub_mul_div]
  refine ⟨bezoutNormalizer A B * EuclideanDomain.gcdB A B * (u - v) -
    A * ((bezoutNormalizer A B *
      (B * EuclideanDomain.gcdB A B * u + A * EuclideanDomain.gcdA A B * v)) /
      (A * B)), ?_⟩
  calc
    _ = _ - v * (bezoutNormalizer A B *
        (A * EuclideanDomain.gcdA A B + B * EuclideanDomain.gcdB A B)) := by
      rw [he, mul_one]
    _ = _ := by ring

/-- The multiplicity polynomial for the endpoint `-1`. -/
def leftModulus (k : ℕ) : ℝ[X] := (X - C (-1)) ^ (k + 1)

/-- The multiplicity polynomial for the endpoint `0`. -/
def rightModulus (k : ℕ) : ℝ[X] := (X - C 0) ^ (k + 1)

theorem endpointModuli_coprime (k : ℕ) : IsCoprime (leftModulus k) (rightModulus k) := by
  apply IsCoprime.pow
  exact isCoprime_X_sub_C_of_isUnit_sub (by norm_num)

/-- The degree-bounded polynomial joining the jets of `exp p` and `exp (-p)`. -/
def interpolant (k : ℕ) : ℝ[X] :=
  twoPointInterpolant (leftModulus k) (rightModulus k)
    (jetPolynomial (-1) k (fun _ => Real.exp (-1)))
    (jetPolynomial 0 k (fun j => (-1 : ℝ) ^ j))

/-- All derivatives through order `k` at `-1` equal `exp (-1)`. -/
theorem interpolant_left_jet (k j : ℕ) (hj : j ≤ k) :
    (derivative^[j] (interpolant k)).eval (-1) = Real.exp (-1) := by
  rw [jet_eq_of_pow_dvd_sub _ (jetPolynomial (-1) k (fun _ => Real.exp (-1)))
    (-1) k j hj]
  · exact jetPolynomial_jet (-1) k j _ hj
  · exact twoPointInterpolant_left _ _ _ _ (endpointModuli_coprime k)

/-- All derivatives through order `k` at `0` equal `(-1)^j`. -/
theorem interpolant_right_jet (k j : ℕ) (hj : j ≤ k) :
    (derivative^[j] (interpolant k)).eval 0 = (-1 : ℝ) ^ j := by
  rw [jet_eq_of_pow_dvd_sub _ (jetPolynomial 0 k (fun j => (-1 : ℝ) ^ j)) 0 k j hj]
  · exact jetPolynomial_jet 0 k j _ hj
  · exact twoPointInterpolant_right _ _ _ _ (endpointModuli_coprime k)

/-- The construction has the minimal Hermite degree bound. -/
theorem interpolant_degree (k : ℕ) : (interpolant k).natDegree ≤ 2 * k + 1 := by
  have hdeg : (leftModulus k * rightModulus k).natDegree = 2 * k + 2 := by
    unfold leftModulus rightModulus
    rw [natDegree_mul (pow_ne_zero _ (X_sub_C_ne_zero _))
      (pow_ne_zero _ (X_sub_C_ne_zero _))]
    simp only [natDegree_pow, natDegree_X_sub_C, mul_one]
    omega
  have h := natDegree_mod_lt
    (bezoutNormalizer (leftModulus k) (rightModulus k) *
      (rightModulus k * EuclideanDomain.gcdB (leftModulus k) (rightModulus k) *
        jetPolynomial (-1) k (fun _ => Real.exp (-1)) +
      leftModulus k * EuclideanDomain.gcdA (leftModulus k) (rightModulus k) *
        jetPolynomial 0 k (fun j => (-1 : ℝ) ^ j)))
    (q := leftModulus k * rightModulus k) (by omega)
  rw [hdeg] at h
  exact Nat.le_of_lt_succ (by simpa [interpolant, twoPointInterpolant, Nat.add_assoc] using h)

/-- The generating series whose first `k+1` coefficients are the source's `a_{k,r}`. -/
def coefficientSeries (k : ℕ) : PowerSeries ℝ :=
  PowerSeries.exp ℝ * (PowerSeries.invOneSubPow ℝ (k + 1)).val

/-- The exact polynomial `A_k`, implemented as a finite Taylor truncation. -/
def coefficientPolynomial (k : ℕ) : ℝ[X] :=
  PowerSeries.trunc (k + 1) (coefficientSeries k)

/-- One endpoint cardinal factor in the symmetric closed-form Hermite formula. -/
def endpointFactor (k : ℕ) : ℝ[X] := (1 - X) ^ (k + 1) * coefficientPolynomial k

/-- The source closed form, in the coordinate `t = p + 1`. -/
def sourceInterpolant (k : ℕ) : ℝ[X] :=
  taylor 1 (C (Real.exp (-1)) * endpointFactor k +
    (endpointFactor k).comp (1 - X))

theorem coefficientSeries_coeff (k r : ℕ) :
    PowerSeries.coeff r (coefficientSeries k) =
      ∑ m ∈ Finset.range (r + 1), (Nat.choose (k + r - m) k : ℝ) /
        (m.factorial : ℝ) := by
  simp only [coefficientSeries, PowerSeries.coeff_mul,
    PowerSeries.invOneSubPow_val_succ_eq_mk_add_choose, PowerSeries.coeff_mk,
    PowerSeries.coeff_exp]
  rw [Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]
  apply Finset.sum_congr rfl
  intro m hm
  have hm' : m ≤ r := by simpa using hm
  simp [Nat.add_sub_assoc hm', div_eq_mul_inv, mul_comm]

theorem coefficientSeries_coeff_nonneg (k r : ℕ) :
    0 ≤ PowerSeries.coeff r (coefficientSeries k) := by
  rw [coefficientSeries_coeff]
  exact Finset.sum_nonneg fun _ _ => div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

@[simp] theorem coefficientSeries_coeff_zero (k : ℕ) :
    PowerSeries.coeff 0 (coefficientSeries k) = 1 := by
  simp [coefficientSeries_coeff]

theorem endpointFactor_series_trunc (k : ℕ) :
    PowerSeries.trunc (k + 1) (endpointFactor k : PowerSeries ℝ) =
      PowerSeries.trunc (k + 1) (PowerSeries.exp ℝ) := by
  have hi : ((1 - PowerSeries.X : PowerSeries ℝ) ^ (k + 1)) *
      (PowerSeries.invOneSubPow ℝ (k + 1)).val = 1 :=
    (PowerSeries.invOneSubPow ℝ (k + 1)).inv_val
  simp only [endpointFactor, coefficientPolynomial, Polynomial.coe_mul,
    Polynomial.coe_pow, Polynomial.coe_sub, Polynomial.coe_one, Polynomial.coe_X,
    PowerSeries.trunc_mul_trunc, coefficientSeries]
  rw [mul_left_comm, hi, mul_one]

theorem endpointFactor_coeff (k j : ℕ) (hj : j ≤ k) :
    (endpointFactor k).coeff j = 1 / (j.factorial : ℝ) := by
  have he := congrArg (fun p : ℝ[X] => p.coeff j) (endpointFactor_series_trunc k)
  simpa [PowerSeries.coeff_trunc, Nat.lt_succ_of_le hj] using he

theorem endpointFactor_zero_jet (k j : ℕ) (hj : j ≤ k) :
    (derivative^[j] (endpointFactor k)).eval 0 = 1 := by
  rw [eval_iterate_derivative, taylor_zero, endpointFactor_coeff k j hj]
  simp [Nat.factorial_ne_zero]

theorem endpointFactor_one_jet (k j : ℕ) (hj : j ≤ k) :
    (derivative^[j] (endpointFactor k)).eval 1 = 0 := by
  have hf : (X - C (1 : ℝ)) ^ (k + 1) ∣ endpointFactor k - 0 := by
    refine ⟨(-1) ^ (k + 1) * coefficientPolynomial k, ?_⟩
    simp only [endpointFactor, sub_zero, C_1]
    rw [← mul_assoc, ← mul_pow]
    congr 2
    ring
  simpa using jet_eq_of_pow_dvd_sub (endpointFactor k) 0 1 k j hj hf

theorem sourceInterpolant_left_jet (k j : ℕ) (hj : j ≤ k) :
    (derivative^[j] (sourceInterpolant k)).eval (-1) = Real.exp (-1) := by
  rw [eval_iterate_derivative]
  simp only [sourceInterpolant, taylor_taylor, neg_add_cancel, taylor_zero]
  rw [← taylor_zero (C (Real.exp (-1)) * endpointFactor k +
    (endpointFactor k).comp (1 - X)), ← eval_iterate_derivative]
  rw [iterate_map_add, iterate_derivative_C_mul, iterate_derivative_comp_one_sub_X]
  simp [endpointFactor_zero_jet k j hj, endpointFactor_one_jet k j hj]

theorem sourceInterpolant_right_jet (k j : ℕ) (hj : j ≤ k) :
    (derivative^[j] (sourceInterpolant k)).eval 0 = (-1 : ℝ) ^ j := by
  rw [eval_iterate_derivative]
  simp only [sourceInterpolant, taylor_taylor, zero_add]
  rw [← eval_iterate_derivative]
  rw [iterate_map_add, iterate_derivative_C_mul, iterate_derivative_comp_one_sub_X]
  simp [endpointFactor_zero_jet k j hj, endpointFactor_one_jet k j hj]

theorem coefficientPolynomial_pos (k : ℕ) (t : ℝ) (ht : 0 ≤ t) :
    0 < (coefficientPolynomial k).eval t := by
  have hsum : (coefficientPolynomial k).eval t =
      ∑ r ∈ Finset.range (k + 1), PowerSeries.coeff r (coefficientSeries k) * t ^ r :=
    PowerSeries.eval₂_trunc_eq_sum_range t (RingHom.id ℝ) (k + 1) (coefficientSeries k)
  rw [hsum]
  have h := Finset.single_le_sum
    (f := fun r => PowerSeries.coeff r (coefficientSeries k) * t ^ r)
    (fun r _ => mul_nonneg (coefficientSeries_coeff_nonneg k r) (pow_nonneg ht r))
    (show 0 ∈ Finset.range (k + 1) by simp)
  simp only [coefficientSeries_coeff_zero, pow_zero, mul_one] at h
  linarith

theorem sourceInterpolant_pos (k : ℕ) (p : ℝ) (hp : p ∈ Set.Icc (-1) 0) :
    0 < (sourceInterpolant k).eval p := by
  have h0 : 0 ≤ p + 1 := by linarith [hp.1]
  have h1 : 0 ≤ 1 - (p + 1) := by linarith [hp.2]
  have ha := coefficientPolynomial_pos k (p + 1) h0
  have hb := coefficientPolynomial_pos k (1 - (p + 1)) h1
  simp only [sourceInterpolant, taylor_eval, eval_add, eval_mul, eval_C, eval_comp,
    eval_sub, eval_one, eval_X, endpointFactor, eval_pow]
  have he := Real.exp_pos (-1)
  by_cases hz : p + 1 = 0
  · simp only [hz, sub_zero, one_pow, one_mul, zero_pow (Nat.succ_ne_zero k),
      sub_self, zero_mul, add_zero]
    exact mul_pos he (coefficientPolynomial_pos k 0 le_rfl)
  · have ht : 0 < p + 1 := lt_of_le_of_ne h0 (Ne.symm hz)
    have hright : 0 < (1 - (1 - (p + 1))) ^ (k + 1) *
        (coefficientPolynomial k).eval (1 - (p + 1)) := by
      apply mul_pos _ hb
      simpa [add_comm] using pow_pos ht (k + 1)
    exact add_pos_of_nonneg_of_pos
      (mul_nonneg he.le (mul_nonneg (pow_nonneg h1 _) ha.le)) hright

/-- The coefficient polynomial is exactly the finite sum in the closed form. -/
theorem coefficientPolynomial_eval (k : ℕ) (t : ℝ) :
    (coefficientPolynomial k).eval t =
      ∑ r ∈ Finset.range (k + 1),
        (∑ m ∈ Finset.range (r + 1), (Nat.choose (k + r - m) k : ℝ) /
          (m.factorial : ℝ)) * t ^ r := by
  rw [coefficientPolynomial, Polynomial.eval, PowerSeries.eval₂_trunc_eq_sum_range]
  simp only [RingHom.id_apply, coefficientSeries_coeff]

/-- Source formula with the coordinate convention `t = p + 1` made explicit. -/
theorem sourceInterpolant_eval (k : ℕ) (p : ℝ) :
    (sourceInterpolant k).eval p =
      Real.exp (-1) * (1 - (p + 1)) ^ (k + 1) *
        (coefficientPolynomial k).eval (p + 1) +
      (p + 1) ^ (k + 1) * (coefficientPolynomial k).eval (1 - (p + 1)) := by
  simp only [sourceInterpolant, endpointFactor, taylor_eval, eval_add, eval_mul,
    eval_C, eval_pow, eval_sub, eval_one, eval_X, eval_comp]
  congr 1
  · ring
  · congr 2
    ring

theorem coefficientPolynomial_degree (k : ℕ) : (coefficientPolynomial k).natDegree ≤ k :=
  Nat.le_of_lt_succ (PowerSeries.natDegree_trunc_lt (coefficientSeries k) k)

theorem endpointFactor_degree (k : ℕ) : (endpointFactor k).natDegree ≤ 2 * k + 1 := by
  have hs : (1 - X : ℝ[X]).natDegree = 1 := by
    rw [← natDegree_neg]
    simpa using (natDegree_X_sub_C (1 : ℝ))
  have h := natDegree_mul_le (p := (1 - X : ℝ[X]) ^ (k + 1))
    (q := coefficientPolynomial k)
  rw [natDegree_pow, hs, mul_one] at h
  have ha := coefficientPolynomial_degree k
  exact (show (endpointFactor k).natDegree ≤ (k + 1) + (coefficientPolynomial k).natDegree
    from h).trans (by omega)

/-- The source closed form has degree at most `2k+1`. -/
theorem sourceInterpolant_degree (k : ℕ) : (sourceInterpolant k).natDegree ≤ 2 * k + 1 := by
  rw [sourceInterpolant, natDegree_taylor]
  apply natDegree_add_le_of_degree_le
  · exact (natDegree_C_mul_le _ _).trans (endpointFactor_degree k)
  · have hs : (1 - X : ℝ[X]).natDegree = 1 := by
      rw [← natDegree_neg]
      simpa using (natDegree_X_sub_C (1 : ℝ))
    simpa [natDegree_comp, hs] using endpointFactor_degree k

/-- Algebraic and analytic repeated differentiation agree for real polynomials. -/
theorem iteratedDeriv_polynomial (p : ℝ[X]) (j : ℕ) (x : ℝ) :
    iteratedDeriv j (fun y => p.eval y) x = (derivative^[j] p).eval x := by
  induction j generalizing p with
  | zero => rfl
  | succ j ih =>
    rw [iteratedDeriv_succ']
    have he : deriv (fun y => p.eval y) = fun y => p.derivative.eval y := by
      funext y
      exact p.deriv
    rw [he, ih, Function.iterate_succ_apply]

theorem sourceInterpolant_left_iteratedDeriv (k j : ℕ) (hj : j ≤ k) :
    iteratedDeriv j (fun p => (sourceInterpolant k).eval p) (-1) = Real.exp (-1) := by
  rw [iteratedDeriv_polynomial]
  exact sourceInterpolant_left_jet k j hj

theorem sourceInterpolant_right_iteratedDeriv (k j : ℕ) (hj : j ≤ k) :
    iteratedDeriv j (fun p => (sourceInterpolant k).eval p) 0 = (-1 : ℝ) ^ j := by
  rw [iteratedDeriv_polynomial]
  exact sourceInterpolant_right_jet k j hj

/-- The literal piecewise initial datum: left exponential, Hermite bridge, right exponential. -/
def smoothInitial (k : ℕ) (p : ℝ) : ℝ :=
  if p < -1 then Real.exp p else
    if p ≤ 0 then (sourceInterpolant k).eval p else Real.exp (-p)

theorem smoothInitial_left (k : ℕ) (p : ℝ) (hp : p < -1) :
    smoothInitial k p = Real.exp p := by simp [smoothInitial, hp]

theorem smoothInitial_middle (k : ℕ) (p : ℝ) (hp : p ∈ Set.Icc (-1) 0) :
    smoothInitial k p = (sourceInterpolant k).eval p := by
  simp [smoothInitial, not_lt.mpr hp.1, hp.2]

theorem smoothInitial_right (k : ℕ) (p : ℝ) (hp : 0 < p) :
    smoothInitial k p = Real.exp (-p) := by
  simp [smoothInitial, not_lt.mpr (show -1 ≤ p by linarith), not_le.mpr hp]

/-- Strict positivity holds globally and makes every finite sampled norm nonzero. -/
theorem smoothInitial_pos (k : ℕ) (p : ℝ) : 0 < smoothInitial k p := by
  unfold smoothInitial
  split_ifs with hl hr
  · exact Real.exp_pos p
  · exact sourceInterpolant_pos k p ⟨not_lt.mp hl, hr⟩
  · exact Real.exp_pos (-p)

/-- Agreement of a finite jet is equivalent to divisibility by the endpoint multiplicity. -/
theorem pow_dvd_sub_of_jet_eq (p q : ℝ[X]) (a : ℝ) (k : ℕ)
    (h : ∀ j ≤ k, (derivative^[j] p).eval a = (derivative^[j] q).eval a) :
    (X - C a) ^ (k + 1) ∣ p - q := by
  have ht : X ^ (k + 1) ∣ taylor a (p - q) := by
    apply X_pow_dvd_iff.mpr
    intro j hj
    have he : (j.factorial : ℝ) * (taylor a (p - q)).coeff j = 0 := by
      rw [← eval_iterate_derivative]
      simp only [iterate_derivative_sub, eval_sub, h j (by omega), sub_self]
    exact (mul_eq_zero.mp he).resolve_left (by exact_mod_cast Nat.factorial_ne_zero j)
  have hm := map_dvd (taylorAlgHom (-a)) ht
  simpa [taylor_taylor, ← sub_eq_add_neg] using hm

/-- There is only one degree-bounded polynomial with the source endpoint jets. -/
theorem sourceInterpolant_unique (k : ℕ) (p : ℝ[X]) (hp : p.natDegree ≤ 2 * k + 1)
    (hl : ∀ j ≤ k, (derivative^[j] p).eval (-1) = Real.exp (-1))
    (hr : ∀ j ≤ k, (derivative^[j] p).eval 0 = (-1 : ℝ) ^ j) :
    p = sourceInterpolant k := by
  have hleft : leftModulus k ∣ p - sourceInterpolant k :=
    pow_dvd_sub_of_jet_eq p (sourceInterpolant k) (-1) k
      (fun j hj => (hl j hj).trans (sourceInterpolant_left_jet k j hj).symm)
  have hright : rightModulus k ∣ p - sourceInterpolant k :=
    pow_dvd_sub_of_jet_eq p (sourceInterpolant k) 0 k
      (fun j hj => (hr j hj).trans (sourceInterpolant_right_jet k j hj).symm)
  have hdiv := (endpointModuli_coprime k).mul_dvd hleft hright
  by_contra hne
  have hd := natDegree_le_of_dvd hdiv (sub_ne_zero.mpr hne)
  have hm : (leftModulus k * rightModulus k).natDegree = 2 * k + 2 := by
    unfold leftModulus rightModulus
    rw [natDegree_mul (pow_ne_zero _ (X_sub_C_ne_zero _))
      (pow_ne_zero _ (X_sub_C_ne_zero _))]
    simp only [natDegree_pow, natDegree_X_sub_C, mul_one]
    omega
  have hb := (natDegree_sub_le p (sourceInterpolant k)).trans
    (max_le hp (sourceInterpolant_degree k))
  rw [hm] at hd
  omega

/-- The Euclidean-algorithm construction and the positive source formula agree exactly. -/
theorem interpolant_eq_sourceInterpolant (k : ℕ) : interpolant k = sourceInterpolant k :=
  sourceInterpolant_unique k (interpolant k) (interpolant_degree k)
    (interpolant_left_jet k) (interpolant_right_jet k)

end QuantumBlockEncoding.HermitePolynomial
