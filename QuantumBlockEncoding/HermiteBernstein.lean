import QuantumBlockEncoding.HermitePolynomial
import Mathlib.RingTheory.Polynomial.Bernstein

/-!
# Exact positive Bernstein representation of the source Hermite polynomial

This module concerns exact real algebra, not a Bernstein approximation of a
function and not the floating-point implementation of the stable MPS candidate.
The source coordinate is `t = p + 1` and its Bernstein degree is `2 * k + 1`.
-/

noncomputable section

open Polynomial
open scoped BigOperators

namespace QuantumBlockEncoding.HermiteBernstein

open HermitePolynomial

/-- Evaluation of the exact degree-`d` Bernstein basis polynomial. -/
def basis (d r : ℕ) (t : ℝ) : ℝ := (bernsteinPolynomial ℝ d r).eval t

theorem basis_eq (d r : ℕ) (t : ℝ) :
    basis d r t = (d.choose r : ℝ) * t ^ r * (1 - t) ^ (d - r) := by
  simp [basis, bernsteinPolynomial]

theorem basis_nonneg (d r : ℕ) (t : ℝ) (ht : t ∈ Set.Icc 0 1) :
    0 ≤ basis d r t := by
  rw [basis_eq]
  exact mul_nonneg (mul_nonneg (Nat.cast_nonneg _) (pow_nonneg ht.1 _))
    (pow_nonneg (sub_nonneg.mpr ht.2) _)

theorem basis_flip (d r : ℕ) (hr : r ≤ d) (t : ℝ) :
    basis d r (1 - t) = basis d (d - r) t := by
  have h := congrArg (fun p : ℝ[X] => p.eval t) (bernsteinPolynomial.flip ℝ d r hr)
  simpa [basis] using h

/-- The coefficient of `t^i` in the source's positive truncated series. -/
def sourceCoefficient (k i : ℕ) : ℝ := PowerSeries.coeff i (coefficientSeries k)

theorem sourceCoefficient_eq (k i : ℕ) :
    sourceCoefficient k i = ∑ m ∈ Finset.range (i + 1),
      (Nat.choose (k + i - m) k : ℝ) / (m.factorial : ℝ) :=
  coefficientSeries_coeff k i

theorem sourceCoefficient_nonneg (k i : ℕ) : 0 ≤ sourceCoefficient k i :=
  coefficientSeries_coeff_nonneg k i

/-- Degree-elevation weight from source monomial `i` to basis index `i+j`. -/
def elevationWeight (k i j : ℕ) : ℝ :=
  ((k - i).choose j : ℝ) / ((2 * k + 1).choose (i + j) : ℝ)

theorem elevationWeight_nonneg (k i j : ℕ) : 0 ≤ elevationWeight k i j :=
  div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

theorem elevation_term (k i j : ℕ) (hi : i ≤ k) (hj : j ≤ k - i) (t : ℝ) :
    elevationWeight k i j * basis (2 * k + 1) (i + j) t =
      t ^ i * (1 - t) ^ (k + 1) *
        ((k - i).choose j : ℝ) * t ^ j * (1 - t) ^ (k - i - j) := by
  have hij : i + j ≤ 2 * k + 1 := by omega
  have hn : ((2 * k + 1).choose (i + j) : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.choose_pos hij).ne'
  have he : 2 * k + 1 - (i + j) = (k + 1) + (k - i - j) := by omega
  rw [elevationWeight, basis_eq, he, pow_add, pow_add]
  field_simp

/-- Exact degree elevation of one endpoint-factor monomial. -/
theorem elevation_sum (k i : ℕ) (hi : i ≤ k) (t : ℝ) :
    (∑ j ∈ Finset.range (k - i + 1),
      elevationWeight k i j * basis (2 * k + 1) (i + j) t) =
      t ^ i * (1 - t) ^ (k + 1) := by
  calc
    _ = t ^ i * (1 - t) ^ (k + 1) *
        ∑ j ∈ Finset.range (k - i + 1),
          t ^ j * (1 - t) ^ (k - i - j) * ((k - i).choose j : ℝ) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j hj
      rw [elevation_term k i j hi (by simpa using hj)]
      ring
    _ = t ^ i * (1 - t) ^ (k + 1) * (t + (1 - t)) ^ (k - i) := by
      rw [add_pow]
    _ = _ := by simp

/-- Collected Bernstein coefficients for the source's left endpoint factor.
The double-sum presentation makes degree elevation explicit; `leftCoefficient_eq`
identifies it with the single-sum formula used by the candidate implementation. -/
def leftCoefficient (k r : ℕ) : ℝ :=
  ∑ i ∈ Finset.range (k + 1), ∑ j ∈ Finset.range (k - i + 1),
    if r = i + j then sourceCoefficient k i * elevationWeight k i j else 0

theorem leftCoefficient_eq (k r : ℕ) :
    leftCoefficient k r = ∑ i ∈ Finset.range (k + 1),
      if i ≤ r ∧ r ≤ k then sourceCoefficient k i *
        ((k - i).choose (r - i) : ℝ) / ((2 * k + 1).choose r : ℝ) else 0 := by
  unfold leftCoefficient
  apply Finset.sum_congr rfl
  intro i hi
  have hi' : i ≤ k := by simpa using hi
  by_cases h : i ≤ r ∧ r ≤ k
  · rw [if_pos h, Finset.sum_eq_single (r - i)]
    · simp only [Nat.add_sub_of_le h.1, if_true, elevationWeight]
      ring
    · intro j hj hji
      have hn : r ≠ i + j := by omega
      simp [hn]
    · intro hn
      exact False.elim (hn (Finset.mem_range.mpr (by omega)))
  · rw [if_neg h]
    apply Finset.sum_eq_zero
    intro j hj
    have hn : r ≠ i + j := by
      have hj' : j ≤ k - i := by simpa using hj
      omega
    simp [hn]

theorem leftCoefficient_nonneg (k r : ℕ) : 0 ≤ leftCoefficient k r := by
  unfold leftCoefficient
  apply Finset.sum_nonneg
  intro i hi
  apply Finset.sum_nonneg
  intro j hj
  split_ifs
  · exact mul_nonneg (sourceCoefficient_nonneg k i) (elevationWeight_nonneg k i j)
  · exact le_rfl

/-- The collected coefficients evaluate to the literal source endpoint factor. -/
theorem leftCoefficient_eval (k : ℕ) (t : ℝ) :
    (∑ r ∈ Finset.range (2 * k + 2), leftCoefficient k r * basis (2 * k + 1) r t) =
      (endpointFactor k).eval t := by
  simp only [leftCoefficient, Finset.sum_mul]
  rw [Finset.sum_comm]
  calc
    _ = ∑ i ∈ Finset.range (k + 1), sourceCoefficient k i *
        (∑ j ∈ Finset.range (k - i + 1),
          elevationWeight k i j * basis (2 * k + 1) (i + j) t) := by
      apply Finset.sum_congr rfl
      intro i hi
      have hi' : i ≤ k := by simpa using hi
      rw [Finset.sum_comm, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j hj
      have hj' : j ≤ k - i := by simpa using hj
      rw [Finset.sum_eq_single (i + j)]
      · simp [mul_assoc]
      · intro r hr hrne
        simp [hrne]
      · intro hn
        exact False.elim (hn (Finset.mem_range.mpr (by omega)))
    _ = ∑ i ∈ Finset.range (k + 1),
        sourceCoefficient k i * (t ^ i * (1 - t) ^ (k + 1)) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [elevation_sum k i (by simpa using hi)]
    _ = (endpointFactor k).eval t := by
      simp only [endpointFactor, eval_mul, eval_pow, eval_sub, eval_one, eval_X]
      have he : (coefficientPolynomial k).eval t =
          ∑ i ∈ Finset.range (k + 1), sourceCoefficient k i * t ^ i :=
        PowerSeries.eval₂_trunc_eq_sum_range t (RingHom.id ℝ) (k + 1) (coefficientSeries k)
      rw [he, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i hi
      ring

/-- The actual positive Bernstein coefficient vector of the source polynomial. -/
def sourceBernsteinCoefficient (k r : ℕ) : ℝ :=
  Real.exp (-1) * leftCoefficient k r + leftCoefficient k (2 * k + 1 - r)

theorem sourceBernsteinCoefficient_nonneg (k r : ℕ) :
    0 ≤ sourceBernsteinCoefficient k r :=
  add_nonneg (mul_nonneg (Real.exp_pos _).le (leftCoefficient_nonneg k r))
    (leftCoefficient_nonneg k _)

/-- Reflection of a coefficient vector corresponds exactly to `t ↦ 1-t`. -/
theorem reflected_sum (d : ℕ) (c : ℕ → ℝ) (t : ℝ) :
    (∑ r ∈ Finset.range (d + 1), c (d - r) * basis d r t) =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (1 - t) := by
  rw [← Finset.sum_range_reflect (fun r => c r * basis d r (1 - t)) (d + 1)]
  apply Finset.sum_congr rfl
  intro r hr
  have hr' : r ≤ d := by simpa using hr
  simp only [Nat.add_sub_cancel, basis_flip d (d - r) (Nat.sub_le d r),
    Nat.sub_sub_self hr']

/-- Exact source-to-Bernstein bridge, valid for every real coordinate, not merely
on `[0,1]`. The interval is needed only for the nonnegativity of the basis. -/
theorem sourceInterpolant_bernstein (k : ℕ) (t : ℝ) :
    (∑ r ∈ Finset.range (2 * k + 2),
      sourceBernsteinCoefficient k r * basis (2 * k + 1) r t) =
      (sourceInterpolant k).eval (t - 1) := by
  simp only [sourceBernsteinCoefficient, add_mul, Finset.sum_add_distrib, mul_assoc,
    ← Finset.mul_sum]
  rw [show 2 * k + 2 = (2 * k + 1) + 1 by omega, reflected_sum]
  rw [show 2 * k + 1 + 1 = 2 * k + 2 by omega, leftCoefficient_eval,
    leftCoefficient_eval]
  simp only [sourceInterpolant, taylor_eval, eval_add, eval_mul, eval_C, eval_comp,
    eval_sub, eval_one, eval_X, sub_add_cancel]

/-- Shift a coefficient row by one entry. -/
def coefficientShift : Module.End ℝ (ℕ → ℝ) where
  toFun c i := c (i + 1)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

theorem coefficientShift_pow (n i : ℕ) (c : ℕ → ℝ) :
    (coefficientShift ^ n) c i = c (i + n) := by
  induction n generalizing i with
  | zero => simp
  | succ n ih =>
    rw [pow_succ', Module.End.mul_apply]
    change (coefficientShift ^ n) c (i + 1) = _
    rw [ih]
    congr 1
    omega

/-- One exact de Casteljau update on an infinite coefficient row. Only the first
`d+1` entries can influence a degree-`d` evaluation. -/
def casteljauStep (t : ℝ) : Module.End ℝ (ℕ → ℝ) :=
  t • coefficientShift + (1 - t) • 1

theorem casteljauStep_apply (t : ℝ) (c : ℕ → ℝ) (i : ℕ) :
    casteljauStep t c i = (1 - t) * c i + t * c (i + 1) := by
  simp [casteljauStep, coefficientShift, add_comm]

/-- Repeated rows of the exact de Casteljau triangle. -/
def casteljau (d : ℕ) (c : ℕ → ℝ) (t : ℝ) (i : ℕ) : ℝ :=
  (casteljauStep t ^ d) c i

theorem casteljau_eq_sum (d : ℕ) (c : ℕ → ℝ) (t : ℝ) (i : ℕ) :
    casteljau d c t i = ∑ j ∈ Finset.range (d + 1), c (i + j) * basis d j t := by
  have hc : Commute (t • coefficientShift) ((1 - t) •
      (1 : Module.End ℝ (ℕ → ℝ))) := by
    change _ * _ = _ * _
    ext c i
    simp [coefficientShift]
    ring
  unfold casteljau casteljauStep
  rw [hc.add_pow]
  simp only [LinearMap.sum_apply, Finset.sum_apply, smul_pow, one_pow,
    Module.End.mul_apply, LinearMap.smul_apply, Pi.smul_apply, smul_eq_mul,
    Module.End.one_apply, Module.End.natCast_apply]
  apply Finset.sum_congr rfl
  intro j hj
  rw [coefficientShift_pow, basis_eq]
  simp only [Pi.smul_apply, smul_eq_mul]
  ring

/-- Left edge of the de Casteljau triangle: coefficients on `[0,u]`. -/
def leftRestriction (u : ℝ) (c : ℕ → ℝ) (i : ℕ) : ℝ := casteljau i c u 0

theorem casteljauStep_mul_parameter (u t : ℝ) :
    casteljauStep (u * t) = (1 - t) • (1 : Module.End ℝ (ℕ → ℝ)) +
      t • casteljauStep u := by
  ext c i
  simp [casteljauStep_apply]
  ring

theorem leftRestriction_step (u t : ℝ) (c : ℕ → ℝ) :
    leftRestriction u (casteljauStep (u * t) c) =
      casteljauStep t (leftRestriction u c) := by
  funext i
  rw [casteljauStep_apply]
  simp only [leftRestriction, casteljau, casteljauStep_mul_parameter u t,
    LinearMap.add_apply, LinearMap.smul_apply, Module.End.one_apply,
    map_add, map_smul, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    pow_succ, Module.End.mul_apply]

/-- The left subdivision evaluates the original polynomial at `u*t`. -/
theorem casteljau_leftRestriction (d : ℕ) (c : ℕ → ℝ) (u t : ℝ) :
    casteljau d (leftRestriction u c) t 0 = casteljau d c (u * t) 0 := by
  have hs : Function.Semiconj (leftRestriction u) (casteljauStep (u * t))
      (casteljauStep t) := leftRestriction_step u t
  have he := congrArg (fun f : ℕ → ℝ => f 0) (hs.iterate_right d c)
  simpa only [leftRestriction, casteljau, pow_zero, Module.End.one_apply,
    ← Module.End.pow_apply] using he.symm

/-- Exact coefficient-level semantics of left de Casteljau subdivision. -/
theorem leftRestriction_eval (d : ℕ) (c : ℕ → ℝ) (u t : ℝ) :
    (∑ r ∈ Finset.range (d + 1), leftRestriction u c r * basis d r t) =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (u * t) := by
  simpa only [casteljau_eq_sum, zero_add] using casteljau_leftRestriction d c u t

/-- Right edge of the de Casteljau triangle, equivalently reflected left
subdivision. The degree is required because the right edge reverses order. -/
def rightRestriction (d : ℕ) (u : ℝ) (c : ℕ → ℝ) (i : ℕ) : ℝ :=
  leftRestriction (1 - u) (fun r => c (d - r)) (d - i)

theorem rightRestriction_eq_casteljau (d i : ℕ) (hi : i ≤ d) (u : ℝ) (c : ℕ → ℝ) :
    rightRestriction d u c i = casteljau (d - i) c u i := by
  simp only [rightRestriction, leftRestriction, casteljau_eq_sum, zero_add]
  rw [← Finset.sum_range_reflect
    (fun j => c (d - j) * basis (d - i) j (1 - u)) (d - i + 1)]
  apply Finset.sum_congr rfl
  intro j hj
  have hj' : j ≤ d - i := by simpa using hj
  simp only [Nat.add_sub_cancel, basis_flip (d - i) (d - i - j) (by omega),
    Nat.sub_sub_self hj']
  congr 2
  omega

theorem rightRestriction_eval (d : ℕ) (c : ℕ → ℝ) (u t : ℝ) :
    (∑ r ∈ Finset.range (d + 1), rightRestriction d u c r * basis d r t) =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (u + (1 - u) * t) := by
  unfold rightRestriction
  rw [reflected_sum, leftRestriction_eval, reflected_sum]
  congr 1
  ext r
  congr 2
  ring

/-- The candidate's two successive subdivisions restricting to `[u,v]`. -/
def restrictCoefficients (d : ℕ) (u v : ℝ) (c : ℕ → ℝ) : ℕ → ℝ :=
  leftRestriction ((v - u) / (1 - u)) (rightRestriction d u c)

/-- Exact affine restriction; no floating-point quantities occur. -/
theorem restrictCoefficients_eval (d : ℕ) (c : ℕ → ℝ) (u v t : ℝ) (hu : u ≠ 1) :
    (∑ r ∈ Finset.range (d + 1), restrictCoefficients d u v c r * basis d r t) =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (u + (v - u) * t) := by
  unfold restrictCoefficients
  rw [leftRestriction_eval, rightRestriction_eval]
  have hne : 1 - u ≠ 0 := sub_ne_zero.mpr (Ne.symm hu)
  have he : u + (1 - u) * ((v - u) / (1 - u) * t) = u + (v - u) * t := by
    field_simp
  rw [he]

theorem basis_sum (d : ℕ) (t : ℝ) :
    (∑ r ∈ Finset.range (d + 1), basis d r t) = 1 := by
  have he := congrArg (fun p : ℝ[X] => p.eval t) (bernsteinPolynomial.sum ℝ d)
  simpa [basis, eval_finset_sum] using he

/-- Bernstein evaluation lies in any common interval containing its coefficients. -/
theorem bernstein_sum_bounds (d : ℕ) (c : ℕ → ℝ) (t lo hi : ℝ)
    (ht : t ∈ Set.Icc 0 1) (hc : ∀ r ≤ d, c r ∈ Set.Icc lo hi) :
    (∑ r ∈ Finset.range (d + 1), c r * basis d r t) ∈ Set.Icc lo hi := by
  constructor
  · calc
      lo = ∑ r ∈ Finset.range (d + 1), lo * basis d r t := by
        rw [← Finset.mul_sum, basis_sum, mul_one]
      _ ≤ _ := Finset.sum_le_sum fun r hr =>
        mul_le_mul_of_nonneg_right (hc r (by simpa using hr)).1 (basis_nonneg d r t ht)
  · calc
      _ ≤ ∑ r ∈ Finset.range (d + 1), hi * basis d r t :=
        Finset.sum_le_sum fun r hr =>
          mul_le_mul_of_nonneg_right (hc r (by simpa using hr)).2 (basis_nonneg d r t ht)
      _ = hi := by rw [← Finset.mul_sum, basis_sum, mul_one]

theorem leftRestriction_bounds (d : ℕ) (c : ℕ → ℝ) (u lo hi : ℝ)
    (hu : u ∈ Set.Icc 0 1) (hc : ∀ r ≤ d, c r ∈ Set.Icc lo hi)
    (i : ℕ) (hi' : i ≤ d) : leftRestriction u c i ∈ Set.Icc lo hi := by
  simpa only [leftRestriction, casteljau_eq_sum, zero_add] using
    bernstein_sum_bounds i c u lo hi hu (fun r hr => hc r (hr.trans hi'))

theorem rightRestriction_bounds (d : ℕ) (c : ℕ → ℝ) (u lo hi : ℝ)
    (hu : u ∈ Set.Icc 0 1) (hc : ∀ r ≤ d, c r ∈ Set.Icc lo hi)
    (i : ℕ) : rightRestriction d u c i ∈ Set.Icc lo hi := by
  apply leftRestriction_bounds d _ (1 - u) lo hi
  · constructor <;> linarith [hu.1, hu.2]
  · intro r hr
    exact hc (d - r) (Nat.sub_le _ _)
  · exact Nat.sub_le _ _

/-- Every restricted coefficient remains in the original coefficient bounds. -/
theorem restrictCoefficients_bounds (d : ℕ) (c : ℕ → ℝ) (u v lo hi : ℝ)
    (hu : 0 ≤ u) (huv : u < v) (hv : v ≤ 1)
    (hc : ∀ r ≤ d, c r ∈ Set.Icc lo hi) (i : ℕ) (hi' : i ≤ d) :
    restrictCoefficients d u v c i ∈ Set.Icc lo hi := by
  have hden : 0 < 1 - u := by linarith
  apply leftRestriction_bounds d _ _ lo hi _ _ i hi'
  · constructor
    · exact div_nonneg (by linarith) hden.le
    · exact (div_le_one hden).mpr (by linarith)
  · intro r hr
    exact rightRestriction_bounds d c u lo hi ⟨hu, by linarith⟩ hc r

theorem basis_half (d r : ℕ) (hr : r ≤ d) :
    basis d r (1 / 2) = (d.choose r : ℝ) / 2 ^ d := by
  rw [basis_eq, show 1 - (1 / 2 : ℝ) = 1 / 2 by norm_num, mul_assoc,
    ← pow_add, Nat.add_sub_of_le hr, one_div_pow]
  ring

/-- The lower half-interval subdivision row is the candidate's binomial row. -/
theorem leftRestriction_half (c : ℕ → ℝ) (i : ℕ) :
    leftRestriction (1 / 2) c i =
      ∑ j ∈ Finset.range (i + 1), c j * (i.choose j : ℝ) / 2 ^ i := by
  simp only [leftRestriction, casteljau_eq_sum, zero_add]
  apply Finset.sum_congr rfl
  intro j hj
  rw [basis_half i j (by simpa using hj)]
  ring

/-- The upper half-interval subdivision row, with `j` the offset from row `i`. -/
theorem rightRestriction_half (d i : ℕ) (hi : i ≤ d) (c : ℕ → ℝ) :
    rightRestriction d (1 / 2) c i =
      ∑ j ∈ Finset.range (d - i + 1),
        c (i + j) * ((d - i).choose j : ℝ) / 2 ^ (d - i) := by
  rw [rightRestriction_eq_casteljau d i hi, casteljau_eq_sum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [basis_half (d - i) j (by simpa using hj)]
  ring

/-- The complete exact source/restriction bridge needed by Bernstein injection. -/
theorem sourceInterpolant_restricted (k : ℕ) (u v t : ℝ) (hu : u ≠ 1) :
    (∑ r ∈ Finset.range (2 * k + 2),
      restrictCoefficients (2 * k + 1) u v (sourceBernsteinCoefficient k) r *
        basis (2 * k + 1) r t) =
      (sourceInterpolant k).eval (u + (v - u) * t - 1) := by
  rw [show 2 * k + 2 = (2 * k + 1) + 1 by omega, restrictCoefficients_eval _ _ _ _ _ hu]
  exact sourceInterpolant_bernstein k (u + (v - u) * t)

/-- Exact coefficient update for one binary digit; `false` is the lower child. -/
def halfSubdivision (d : ℕ) (bit : Bool) (c : ℕ → ℝ) : ℕ → ℝ :=
  if bit then rightRestriction d (1 / 2) c else leftRestriction (1 / 2) c

/-- The local coordinate of one binary child. -/
def childCoordinate (bit : Bool) (t : ℝ) : ℝ :=
  if bit then (1 + t) / 2 else t / 2

theorem halfSubdivision_eval (d : ℕ) (c : ℕ → ℝ) (bit : Bool) (t : ℝ) :
    (∑ r ∈ Finset.range (d + 1), halfSubdivision d bit c r * basis d r t) =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (childCoordinate bit t) := by
  cases bit
  · simp only [halfSubdivision, Bool.false_eq_true, if_false, childCoordinate]
    rw [leftRestriction_eval]
    congr 1
    ext r
    congr 2
    ring
  · simp only [halfSubdivision, if_true, childCoordinate]
    rw [rightRestriction_eval]
    congr 1
    ext r
    congr 2
    ring

/-- Successive binary subdivisions in MSB-first order. -/
def subdivisionPath (d : ℕ) (c : ℕ → ℝ) : List Bool → (ℕ → ℝ)
  | [] => c
  | bit :: bits => subdivisionPath d (halfSubdivision d bit c) bits

/-- Composition of the same MSB-first binary-child coordinate maps. -/
def pathCoordinate : List Bool → ℝ → ℝ
  | [], t => t
  | bit :: bits, t => childCoordinate bit (pathCoordinate bits t)

/-- The shared Bernstein state is exact after any finite bit prefix. -/
theorem subdivisionPath_eval (d : ℕ) (c : ℕ → ℝ) (bits : List Bool) (t : ℝ) :
    (∑ r ∈ Finset.range (d + 1), subdivisionPath d c bits r * basis d r t) =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (pathCoordinate bits t) := by
  induction bits generalizing c with
  | nil => rfl
  | cons bit bits ih =>
    simp only [subdivisionPath, pathCoordinate]
    rw [ih, halfSubdivision_eval]

theorem bernstein_eval_zero (d : ℕ) (c : ℕ → ℝ) :
    (∑ r ∈ Finset.range (d + 1), c r * basis d r 0) = c 0 := by
  simp [basis, bernsteinPolynomial.eval_at_0]

/-- The zeroth coefficient after the last digit is the value at the represented
left endpoint. This is the exact shared-state readout invariant. -/
theorem subdivisionPath_readout (d : ℕ) (c : ℕ → ℝ) (bits : List Bool) :
    subdivisionPath d c bits 0 =
      ∑ r ∈ Finset.range (d + 1), c r * basis d r (pathCoordinate bits 0) := by
  rw [← subdivisionPath_eval, bernstein_eval_zero]

/-- Source-correct readout from a restricted Bernstein injection followed by any
finite MSB-first suffix. The separate threshold-injection automaton is not
asserted by this theorem. -/
theorem sourceInterpolant_subdivision_readout (k : ℕ) (u v : ℝ) (hu : u ≠ 1)
    (bits : List Bool) :
    subdivisionPath (2 * k + 1)
      (restrictCoefficients (2 * k + 1) u v (sourceBernsteinCoefficient k)) bits 0 =
      (sourceInterpolant k).eval (u + (v - u) * pathCoordinate bits 0 - 1) := by
  rw [subdivisionPath_readout]
  exact sourceInterpolant_restricted k u v (pathCoordinate bits 0) hu

end QuantumBlockEncoding.HermiteBernstein
