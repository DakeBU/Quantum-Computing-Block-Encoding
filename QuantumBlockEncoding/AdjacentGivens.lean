import QuantumBlockEncoding.RealAmplitudePreparation
import QuantumBlockEncoding.SelectedRyPlane

/-!
# Exact adjacent-row Givens decomposition of real SO matrices

The ordered plane `(i,j)` uses the standard RY convention. Elimination uses
the negative of the exact signed preparation angle. Zero pivots are assigned
angle zero. The computed bottom-up passes preserve earlier standard-basis
columns, orthogonality, and determinant. The final sign follows from determinant
one, yielding an exact list of `N*(N-1)/2` adjacent rotations for every real SO
matrix, including dimensions zero and one. Relabeling these numerical indices
by Gray code and compiling the resulting qubit edges is a separate interface.
-/

namespace QuantumBlockEncoding.AdjacentGivens

open RealAmplitudePreparation

noncomputable def rotateRows {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (theta : ℝ) : _root_.Matrix (Fin N) (Fin M) ℝ :=
  fun row col =>
    if row = i then Real.cos (theta / 2) * A i col - Real.sin (theta / 2) * A j col
    else if row = j then Real.sin (theta / 2) * A i col + Real.cos (theta / 2) * A j col
    else A row col

noncomputable def planeMatrix {N : ℕ} (i j : Fin N) (theta : ℝ) :
    _root_.Matrix (Fin N) (Fin N) ℝ := rotateRows 1 i j theta

theorem planeMatrix_mul {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (theta : ℝ) : planeMatrix i j theta * A = rotateRows A i j theta := by
  ext row col
  simp only [_root_.Matrix.mul_apply, planeMatrix, rotateRows]
  by_cases hi : row = i
  · subst row
    simp [Finset.sum_sub_distrib, sub_mul, _root_.Matrix.one_apply]
  · by_cases hj : row = j
    · subst row
      simp [hi, Finset.sum_add_distrib, add_mul, _root_.Matrix.one_apply]
    · simp [hi, hj, _root_.Matrix.one_apply]

theorem rotateRows_inverse {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    rotateRows (rotateRows A i j theta) i j (-theta) = A := by
  ext row col
  have circle := Real.sin_sq_add_cos_sq (theta / 2)
  by_cases hi : row = i
  · subst row
    simp [rotateRows, distinct.symm, neg_div, Real.cos_neg, Real.sin_neg]
    nlinarith [congrArg (fun x : ℝ => x * A i col) circle]
  · by_cases hj : row = j
    · subst row
      simp [rotateRows, distinct.symm, neg_div, Real.cos_neg, Real.sin_neg]
      nlinarith [congrArg (fun x : ℝ => x * A j col) circle]
    · simp [rotateRows, hi, hj]

theorem planeMatrix_inverse {N : ℕ} (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    planeMatrix i j (-theta) * planeMatrix i j theta = 1 := by
  rw [planeMatrix_mul]
  exact rotateRows_inverse 1 i j distinct theta

theorem planeMatrix_transpose {N : ℕ} (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    (planeMatrix i j theta).transpose = planeMatrix i j (-theta) := by
  ext row col
  by_cases ri : row = i <;> by_cases rj : row = j <;>
    by_cases ci : col = i <;> by_cases cj : col = j <;>
    simp_all [planeMatrix, rotateRows, _root_.Matrix.transpose_apply, _root_.Matrix.one_apply,
      neg_div, Real.cos_neg, Real.sin_neg, eq_comm]

theorem planeMatrix_orthogonal {N : ℕ} (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    (planeMatrix i j theta).transpose * planeMatrix i j theta = 1 := by
  rw [planeMatrix_transpose i j distinct, planeMatrix_inverse i j distinct]

theorem rotateRows_preserves_orthogonal {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    (rotateRows A i j theta).transpose * rotateRows A i j theta = 1 := by
  rw [← planeMatrix_mul, _root_.Matrix.transpose_mul]
  calc
    (A.transpose * (planeMatrix i j theta).transpose) * (planeMatrix i j theta * A) =
        A.transpose * ((planeMatrix i j theta).transpose * planeMatrix i j theta) * A := by
      simp only [_root_.Matrix.mul_assoc]
    _ = 1 := by rw [planeMatrix_orthogonal i j distinct, _root_.Matrix.mul_one, orthogonal]

theorem splitAngle_real_firstColumn (x y : ℝ) :
    Real.cos ((splitAngle x y).eval / 2) * pairNorm x y = x ∧
    Real.sin ((splitAngle x y).eval / 2) * pairNorm x y = y := by
  have first := congrArg Complex.re (splitAngle_firstColumn x y 0)
  have second := congrArg Complex.re (splitAngle_firstColumn x y 1)
  rw [standardRyMatrix_eq_realRyPlaneBlock] at first second
  change Complex.re ((Real.cos ((splitAngle x y).eval / 2) : ℂ) *
    (pairNorm x y : ℂ)) = x at first
  change Complex.re ((Real.sin ((splitAngle x y).eval / 2) : ℂ) *
    (pairNorm x y : ℂ)) = y at second
  rw [← Complex.ofReal_mul, Complex.ofReal_re] at first second
  constructor
  · exact first
  · exact second

noncomputable def eliminationAngle (x y : ℝ) : ℝ := -(splitAngle x y).eval

@[simp] theorem eliminationAngle_zero : eliminationAngle 0 0 = 0 := by
  simp [eliminationAngle, splitAngle, pairNorm, ExactAngle.eval]

theorem eliminate_pair (x y : ℝ) :
    Real.cos (eliminationAngle x y / 2) * x -
        Real.sin (eliminationAngle x y / 2) * y = pairNorm x y ∧
    Real.sin (eliminationAngle x y / 2) * x +
        Real.cos (eliminationAngle x y / 2) * y = 0 := by
  obtain ⟨hx, hy⟩ := splitAngle_real_firstColumn x y
  have circle := Real.sin_sq_add_cos_sq ((splitAngle x y).eval / 2)
  simp only [eliminationAngle, neg_div, Real.cos_neg, Real.sin_neg]
  generalize (splitAngle x y).eval / 2 = a at *
  generalize pairNorm x y = r at *
  constructor
  · calc
      _ = (Real.sin a ^ 2 + Real.cos a ^ 2) * r := by rw [← hx, ← hy]; ring
      _ = r := by rw [circle, one_mul]
  · rw [← hx, ← hy]
    ring

theorem pairNorm_eq_zero_iff (x y : ℝ) : pairNorm x y = 0 ↔ x = 0 ∧ y = 0 := by
  constructor
  · intro zero
    have square := pairNorm_sq x y
    rw [zero] at square
    constructor <;> nlinarith [sq_nonneg x, sq_nonneg y]
  · rintro ⟨rfl, rfl⟩
    simp [pairNorm]

theorem pairNorm_pos_of_nonzero (x y : ℝ) (nonzero : x ≠ 0 ∨ y ≠ 0) :
    0 < pairNorm x y := by
  have nonneg := pairNorm_nonneg x y
  have notZero : pairNorm x y ≠ 0 := by
    intro zero
    obtain ⟨hx, hy⟩ := (pairNorm_eq_zero_iff x y).mp zero
    rcases nonzero with hx' | hy'
    · exact hx' hx
    · exact hy' hy
  exact lt_of_le_of_ne nonneg (Ne.symm notZero)

noncomputable def eliminateEntry {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (col : Fin M) : _root_.Matrix (Fin N) (Fin M) ℝ :=
  rotateRows A i j (eliminationAngle (A i col) (A j col))

theorem eliminateEntry_pivot {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (distinct : i ≠ j) (col : Fin M) :
    eliminateEntry A i j col i col = pairNorm (A i col) (A j col) ∧
    eliminateEntry A i j col j col = 0 := by
  simpa [eliminateEntry, rotateRows, distinct.symm] using eliminate_pair (A i col) (A j col)

theorem eliminateEntry_unchanged {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j row : Fin N) (col otherCol : Fin M) (hi : row ≠ i) (hj : row ≠ j) :
    eliminateEntry A i j col row otherCol = A row otherCol := by
  simp [eliminateEntry, rotateRows, hi, hj]

theorem eliminateEntry_preserves_zero_column {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (col oldCol : Fin M) (hi : A i oldCol = 0) (hj : A j oldCol = 0)
    (row : Fin N) : eliminateEntry A i j col row oldCol = A row oldCol := by
  by_cases ri : row = i <;> by_cases rj : row = j <;>
    simp_all [eliminateEntry, rotateRows]

theorem eliminateEntry_preserves_orthogonal {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (i j : Fin N) (distinct : i ≠ j) (col : Fin N) :
    (eliminateEntry A i j col).transpose * eliminateEntry A i j col = 1 :=
  rotateRows_preserves_orthogonal A orthogonal i j distinct _

/-- A zero pair produces an actual identity step, without division by zero. -/
theorem eliminateEntry_zero_pair {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (i j : Fin N) (col : Fin M) (firstZero : A i col = 0) (secondZero : A j col = 0) :
    eliminateEntry A i j col = A := by
  ext row otherCol
  by_cases hi : row = i <;> by_cases hj : row = j <;>
    simp_all [eliminateEntry, rotateRows]

/-- An actual adjacent-row rotation, carrying the precise ordered support. -/
structure Step (N : ℕ) where
  first : Fin N
  second : Fin N
  adjacent : first.val + 1 = second.val
  angle : ℝ

theorem Step.distinct {N : ℕ} (step : Step N) : step.first ≠ step.second := by
  intro equal
  have same := congrArg Fin.val equal
  have adjacent := step.adjacent
  omega

noncomputable def Step.matrix {N : ℕ} (step : Step N) :
    _root_.Matrix (Fin N) (Fin N) ℝ := planeMatrix step.first step.second step.angle

/-- Chronological action: the first listed matrix acts first. -/
noncomputable def applySteps {N M : ℕ} : List (Step N) →
    _root_.Matrix (Fin N) (Fin M) ℝ → _root_.Matrix (Fin N) (Fin M) ℝ
  | [], A => A
  | step :: rest, A => applySteps rest (step.matrix * A)

noncomputable def Step.inverse {N : ℕ} (step : Step N) : Step N :=
  { step with angle := -step.angle }

theorem applySteps_append {N M : ℕ} (left right : List (Step N))
    (A : _root_.Matrix (Fin N) (Fin M) ℝ) :
    applySteps (left ++ right) A = applySteps right (applySteps left A) := by
  induction left generalizing A with
  | nil => rfl
  | cons step rest ih => exact ih _

/-- Reversing the chronological list and negating every angle exactly undoes it. -/
theorem applySteps_reverse_inverse {N M : ℕ} (steps : List (Step N))
    (A : _root_.Matrix (Fin N) (Fin M) ℝ) :
    applySteps (steps.reverse.map Step.inverse) (applySteps steps A) = A := by
  induction steps generalizing A with
  | nil => rfl
  | cons step rest ih =>
      simp only [List.reverse_cons, List.map_append, List.map_cons, List.map_nil,
        applySteps_append, applySteps]
      rw [ih]
      change planeMatrix step.first step.second (-step.angle) *
        (planeMatrix step.first step.second step.angle * A) = A
      rw [← _root_.Matrix.mul_assoc, planeMatrix_inverse _ _ step.distinct,
        _root_.Matrix.one_mul]

noncomputable def columnSweep {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo : ℕ) : (count : ℕ) → lo + count < N →
    _root_.Matrix (Fin N) (Fin M) ℝ
  | 0, _ => A
  | count + 1, bound =>
      columnSweep (eliminateEntry A ⟨lo + count, by omega⟩
        ⟨lo + count + 1, by omega⟩ col) col lo count (by omega)

/-- The list is computed from the changing matrix, not supplied as a certificate. -/
noncomputable def columnSweepSteps {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo : ℕ) : (count : ℕ) → lo + count < N → List (Step N)
  | 0, _ => []
  | count + 1, bound =>
      let first : Fin N := ⟨lo + count, by omega⟩
      let second : Fin N := ⟨lo + count + 1, by omega⟩
      { first := first, second := second, adjacent := rfl,
        angle := eliminationAngle (A first col) (A second col) } ::
        columnSweepSteps (eliminateEntry A first second col) col lo count (by omega)

theorem columnSweepSteps_length {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo count : ℕ) (bound : lo + count < N) :
    (columnSweepSteps A col lo count bound).length = count := by
  induction count generalizing A with
  | zero => rfl
  | succ count ih => simp only [columnSweepSteps, List.length_cons, ih]

theorem columnSweepSteps_action {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo count : ℕ) (bound : lo + count < N) :
    applySteps (columnSweepSteps A col lo count bound) A = columnSweep A col lo count bound := by
  induction count generalizing A with
  | zero => rfl
  | succ count ih =>
      simp only [columnSweepSteps, applySteps, Step.matrix, planeMatrix_mul]
      exact ih _ _

/-- The original matrix is recovered from the computed residual. No identity
or full-decomposition assumption is hidden in this statement. -/
theorem columnSweep_exact_recovery {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo count : ℕ) (bound : lo + count < N) :
    applySteps ((columnSweepSteps A col lo count bound).reverse.map Step.inverse)
      (columnSweep A col lo count bound) = A := by
  rw [← columnSweepSteps_action, applySteps_reverse_inverse]

theorem columnSweep_outside {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo count : ℕ) (bound : lo + count < N)
    (row : Fin N) (otherCol : Fin M) (outside : row.val < lo ∨ lo + count < row.val) :
    columnSweep A col lo count bound row otherCol = A row otherCol := by
  induction count generalizing A with
  | zero => rfl
  | succ count ih =>
      rw [columnSweep, ih _ (by omega) (by omega)]
      apply eliminateEntry_unchanged
      · intro equal
        have := congrArg Fin.val equal
        change row.val = lo + count at this
        omega
      · intro equal
        have := congrArg Fin.val equal
        change row.val = lo + count + 1 at this
        omega

theorem columnSweep_zeroed {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo count : ℕ) (bound : lo + count < N)
    (row : Fin N) (lower : lo < row.val) (upper : row.val ≤ lo + count) :
    columnSweep A col lo count bound row col = 0 := by
  induction count generalizing A with
  | zero => omega
  | succ count ih =>
      rw [columnSweep]
      by_cases inner : row.val ≤ lo + count
      · exact ih _ (by omega) inner
      · rw [columnSweep_outside _ _ _ _ _ _ _ (by omega)]
        have equal : row = (⟨lo + count + 1, by omega⟩ : Fin N) := by
          apply Fin.ext
          change row.val = lo + count + 1
          omega
        rw [equal]
        exact (eliminateEntry_pivot _ _ _ (by
          intro equal
          have := congrArg Fin.val equal
          change lo + count = lo + count + 1 at this
          omega) _).2

theorem columnSweep_preserves_zero_column {N M : ℕ}
    (A : _root_.Matrix (Fin N) (Fin M) ℝ) (col oldCol : Fin M)
    (lo count : ℕ) (bound : lo + count < N)
    (zeros : ∀ row : Fin N, lo ≤ row.val → row.val ≤ lo + count → A row oldCol = 0)
    (row : Fin N) : columnSweep A col lo count bound row oldCol = A row oldCol := by
  induction count generalizing A with
  | zero => rfl
  | succ count ih =>
      let first : Fin N := ⟨lo + count, by omega⟩
      let second : Fin N := ⟨lo + count + 1, by omega⟩
      have unchanged (r : Fin N) : eliminateEntry A first second col r oldCol = A r oldCol :=
        eliminateEntry_preserves_zero_column A first second col oldCol
          (zeros first (by dsimp [first]; omega) (by dsimp [first]; omega))
          (zeros second (by dsimp [second]; omega) (by dsimp [second]; omega)) r
      change columnSweep (eliminateEntry A first second col) col lo count _ row oldCol = _
      rw [ih _ (by omega) (by
        intro r lower upper
        rw [unchanged]
        exact zeros r lower (by omega)), unchanged]

theorem columnSweep_preserves_orthogonal {N : ℕ}
    (A : _root_.Matrix (Fin N) (Fin N) ℝ) (orthogonal : A.transpose * A = 1)
    (col : Fin N) (lo count : ℕ) (bound : lo + count < N) :
    (columnSweep A col lo count bound).transpose * columnSweep A col lo count bound = 1 := by
  induction count generalizing A with
  | zero => exact orthogonal
  | succ count ih =>
      rw [columnSweep]
      apply ih
      exact eliminateEntry_preserves_orthogonal A orthogonal _ _ (by
        intro equal
        have := congrArg Fin.val equal
        change lo + count = lo + count + 1 at this
        omega) col


theorem det_two_row_mix {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (i j : Fin N) (distinct : i ≠ j) (a b c d : ℝ) :
    (((A.updateRow i (a • A i + b • A j)).updateRow j (c • A i + d • A j))).det =
      (a * d - b * c) * A.det := by
  have sameI : ((A.updateRow j (A i)).updateRow i (A i)).det = 0 := by
    apply _root_.Matrix.det_zero_of_row_eq distinct
    simp [distinct.symm]
  have sameJ : ((A.updateRow j (A j)).updateRow i (A j)).det = 0 := by
    apply _root_.Matrix.det_zero_of_row_eq distinct
    simp [distinct.symm]
  have original : (A.updateRow j (A j)).updateRow i (A i) = A := by simp
  have swapEq : (A.updateRow j (A i)).updateRow i (A j) =
      A.submatrix (Equiv.swap i j) id := by
    ext row col
    by_cases hi : row = i <;> by_cases hj : row = j <;>
      simp_all [_root_.Matrix.updateRow_apply, _root_.Matrix.submatrix_apply,
        Equiv.swap_apply_def]
  have swapDet : ((A.updateRow j (A i)).updateRow i (A j)).det = -A.det := by
    rw [swapEq, _root_.Matrix.det_permute, Equiv.Perm.sign_swap distinct]
    simp
  simp only [_root_.Matrix.det_updateRow_add, _root_.Matrix.det_updateRow_smul]
  rw [_root_.Matrix.updateRow_comm A distinct, _root_.Matrix.updateRow_comm A distinct]
  simp only [_root_.Matrix.det_updateRow_add, _root_.Matrix.det_updateRow_smul,
    sameI, sameJ, original, swapDet]
  ring

theorem rotateRows_det {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    (rotateRows A i j theta).det = A.det := by
  have eqRows : rotateRows A i j theta =
      (A.updateRow i (Real.cos (theta / 2) • A i + (-Real.sin (theta / 2)) • A j)).updateRow j
        (Real.sin (theta / 2) • A i + Real.cos (theta / 2) • A j) := by
    ext row col
    by_cases hi : row = i <;> by_cases hj : row = j <;>
      simp_all [rotateRows, _root_.Matrix.updateRow_apply, sub_eq_add_neg]
  rw [eqRows, det_two_row_mix A i j distinct]
  have circle := Real.sin_sq_add_cos_sq (theta / 2)
  nlinarith [congrArg (fun t : ℝ => t * A.det) circle]


theorem planeMatrix_det {N : ℕ} (i j : Fin N) (distinct : i ≠ j) (theta : ℝ) :
    (planeMatrix i j theta).det = 1 := by
  rw [planeMatrix, rotateRows_det _ i j distinct, _root_.Matrix.det_one]

theorem columnSweep_preserves_det {N : ℕ}
    (A : _root_.Matrix (Fin N) (Fin N) ℝ) (col : Fin N)
    (lo count : ℕ) (bound : lo + count < N) :
    (columnSweep A col lo count bound).det = A.det := by
  induction count generalizing A with
  | zero => rfl
  | succ count ih =>
      rw [columnSweep, ih]
      apply rotateRows_det
      intro equal
      have := congrArg Fin.val equal
      change lo + count = lo + count + 1 at this
      omega


def PrefixIdentity {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ) (k : ℕ) : Prop :=
  ∀ col : Fin N, col.val < k → ∀ row : Fin N, A row col = if row = col then 1 else 0

theorem orthogonal_zero_of_fixed_column {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (old col : Fin N) (distinct : old ≠ col)
    (fixed : ∀ row : Fin N, A row old = if row = old then 1 else 0) : A old col = 0 := by
  have entry := congrFun (congrFun orthogonal old) col
  simpa [_root_.Matrix.mul_apply, _root_.Matrix.transpose_apply,
    fixed, _root_.Matrix.one_apply, distinct] using entry

theorem columnSweep_prefix {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (col : Fin N) (count : ℕ) (bound : col.val + count < N)
    (fixedPrefix : PrefixIdentity A col.val) : PrefixIdentity (columnSweep A col col.val count bound) col.val := by
  intro old oldLt row
  rw [columnSweep_preserves_zero_column]
  · exact fixedPrefix old oldLt row
  · intro r lower upper
    rw [fixedPrefix old oldLt r, if_neg]
    intro equal
    have same := congrArg Fin.val equal
    omega

theorem columnSweep_pivot_nonneg {N M : ℕ} (A : _root_.Matrix (Fin N) (Fin M) ℝ)
    (col : Fin M) (lo count : ℕ) (bound : lo + count < N) (positive : 0 < count) :
    0 ≤ columnSweep A col lo count bound ⟨lo, by omega⟩ col := by
  induction count generalizing A with
  | zero => omega
  | succ count ih =>
      rw [columnSweep]
      by_cases zero : count = 0
      · subst count
        rw [columnSweep]
        simp only [Nat.add_zero] at *
        rw [(eliminateEntry_pivot A ⟨lo, by omega⟩ ⟨lo + 1, by omega⟩ (by
          intro equal
          have same := congrArg Fin.val equal
          change lo = lo + 1 at same
          omega) _).1]
        exact RealAmplitudePreparation.pairNorm_nonneg _ _
      · exact ih _ (by omega) (by omega)

theorem orthogonal_supported_column_sq {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (col : Fin N)
    (support : ∀ row : Fin N, row ≠ col → A row col = 0) : A col col ^ 2 = 1 := by
  have entry := congrFun (congrFun orthogonal col) col
  have collapse : (∑ row, A row col * A row col) = A col col * A col col := by
    apply Finset.sum_eq_single col
    · intro row _ different
      rw [support row different]
      simp
    · intro missing
      exact False.elim (missing (Finset.mem_univ col))
  simp only [_root_.Matrix.mul_apply, _root_.Matrix.transpose_apply,
    _root_.Matrix.one_apply_eq] at entry
  rw [collapse] at entry
  simpa [sq] using entry

theorem columnSweep_prefix_succ {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (col : Fin N) (count : ℕ)
    (dimension : col.val + count + 1 = N) (positive : 0 < count)
    (fixedPrefix : PrefixIdentity A col.val) :
    PrefixIdentity (columnSweep A col col.val count (by omega)) (col.val + 1) := by
  let B := columnSweep A col col.val count (by omega)
  have orthoB : B.transpose * B = 1 := columnSweep_preserves_orthogonal A orthogonal _ _ _ _
  have prefixB : PrefixIdentity B col.val := columnSweep_prefix A col count (by omega) fixedPrefix
  have support (row : Fin N) (different : row ≠ col) : B row col = 0 := by
    by_cases below : col.val < row.val
    · exact columnSweep_zeroed A col col.val count _ row below (by omega)
    · have above : row.val < col.val := by
        have notEqual : row.val ≠ col.val := fun equal => different (Fin.ext equal)
        omega
      exact orthogonal_zero_of_fixed_column B orthoB row col different (prefixB row above)
  have normSq := orthogonal_supported_column_sq B orthoB col support
  have nonneg : 0 ≤ B col col := columnSweep_pivot_nonneg A col col.val count _ positive
  have pivot : B col col = 1 := by nlinarith
  intro old oldLt row
  by_cases same : old = col
  · subst old
    by_cases hit : row = col
    · simpa [hit] using pivot
    · simpa [hit] using support row hit
  · exact prefixB old (by
      have notEqual : old.val ≠ col.val := fun equal => same (Fin.ext equal)
      omega) row

theorem matrix_eq_one_of_full_prefix {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (fixedPrefix : PrefixIdentity A N) : A = 1 := by
  ext row col
  simpa only [_root_.Matrix.one_apply] using fixedPrefix col col.isLt row

theorem matrix_eq_one_of_last_prefix {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (determinant : A.det = 1)
    (k : ℕ) (dimension : k + 1 = N) (fixedPrefix : PrefixIdentity A k) : A = 1 := by
  let last : Fin N := ⟨k, by omega⟩
  have offDiagonal (row col : Fin N) (different : row ≠ col) : A row col = 0 := by
    by_cases early : col.val < k
    · simpa [different] using fixedPrefix col early row
    · have colLast : col = last := by apply Fin.ext; dsimp [last]; omega
      have rowEarly : row.val < k := by
        have notEqual : row.val ≠ col.val := fun equal => different (Fin.ext equal)
        omega
      exact orthogonal_zero_of_fixed_column A orthogonal row col different (fixedPrefix row rowEarly)
  have diagonal : A = _root_.Matrix.diagonal (fun i => A i i) := by
    ext row col
    by_cases same : row = col
    · simp [same]
    · simp [same, offDiagonal row col same]
  have diagEntry (i : Fin N) : A i i = if i = last then A last last else 1 := by
    by_cases same : i = last
    · simp [same]
    · have early : i.val < k := by
        have notEqual : i.val ≠ k := fun equal => same (Fin.ext equal)
        omega
      simpa [same] using fixedPrefix i early i
  have lastOne : A last last = 1 := by
    rw [diagonal, _root_.Matrix.det_diagonal] at determinant
    have product : (∏ i, A i i) = ∏ i, if i = last then A last last else 1 :=
      Finset.prod_congr rfl (fun i _ => diagEntry i)
    rw [product] at determinant
    simpa using determinant
  ext row col
  by_cases same : row = col
  · subst col
    rw [diagEntry, lastOne]
    simp
  · simp [same, offDiagonal row col same]

noncomputable def fullSweep {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (k : ℕ) : (remaining : ℕ) → k + remaining = N → _root_.Matrix (Fin N) (Fin N) ℝ
  | 0, _ => A
  | 1, _ => A
  | remaining + 2, dimension =>
      fullSweep (columnSweep A ⟨k, by omega⟩ k (remaining + 1) (by omega))
        (k + 1) (remaining + 1) (by omega)

noncomputable def fullSweepSteps {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (k : ℕ) : (remaining : ℕ) → k + remaining = N → List (Step N)
  | 0, _ => []
  | 1, _ => []
  | remaining + 2, dimension =>
      columnSweepSteps A ⟨k, by omega⟩ k (remaining + 1) (by omega) ++
        fullSweepSteps (columnSweep A ⟨k, by omega⟩ k (remaining + 1) (by omega))
          (k + 1) (remaining + 1) (by omega)

theorem fullSweepSteps_action {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (k remaining : ℕ) (dimension : k + remaining = N) :
    applySteps (fullSweepSteps A k remaining dimension) A = fullSweep A k remaining dimension := by
  induction remaining generalizing A k with
  | zero => rfl
  | succ remaining ih =>
      cases remaining with
      | zero => rfl
      | succ remaining =>
          simp only [fullSweepSteps, applySteps_append, columnSweepSteps_action, fullSweep]
          exact ih _ _ _

theorem fullSweepSteps_length_twice {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (k remaining : ℕ) (dimension : k + remaining = N) :
    (fullSweepSteps A k remaining dimension).length * 2 = remaining * (remaining - 1) := by
  induction remaining generalizing A k with
  | zero => rfl
  | succ remaining ih =>
      cases remaining with
      | zero => rfl
      | succ remaining =>
          simp only [fullSweepSteps, List.length_append, columnSweepSteps_length, Nat.add_mul]
          rw [ih]
          simp only [Nat.add_sub_cancel]
          ring

theorem fullSweepSteps_length {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (k remaining : ℕ) (dimension : k + remaining = N) :
    (fullSweepSteps A k remaining dimension).length = remaining * (remaining - 1) / 2 := by
  have twice := fullSweepSteps_length_twice A k remaining dimension
  omega

theorem fullSweep_eq_one {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (determinant : A.det = 1)
    (k remaining : ℕ) (dimension : k + remaining = N) (fixedPrefix : PrefixIdentity A k) :
    fullSweep A k remaining dimension = 1 := by
  induction remaining generalizing A k with
  | zero =>
      apply matrix_eq_one_of_full_prefix
      simpa only [Nat.add_zero] using dimension ▸ fixedPrefix
  | succ remaining ih =>
      cases remaining with
      | zero => exact matrix_eq_one_of_last_prefix A orthogonal determinant k dimension fixedPrefix
      | succ remaining =>
          rw [fullSweep]
          apply ih
          · exact columnSweep_preserves_orthogonal A orthogonal _ _ _ _
          · exact columnSweep_preserves_det A _ _ _ _ |>.trans determinant
          · exact columnSweep_prefix_succ A orthogonal ⟨k, by omega⟩ (remaining + 1)
              (by simpa [Nat.succ_eq_add_one, Nat.add_assoc] using dimension)
              (by omega) fixedPrefix

/-- A computed finite list of adjacent RY planes in chronological circuit order. -/
noncomputable def decomposeSO {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ) : List (Step N) :=
  (fullSweepSteps A 0 N (by omega)).reverse.map Step.inverse

/-- Every real determinant-one orthogonal matrix is exactly the action of the
constructed adjacent-plane list. The final identity is proved, not supplied. -/
theorem decomposeSO_action {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (determinant : A.det = 1) :
    applySteps (decomposeSO A) 1 = A := by
  have terminal := fullSweep_eq_one A orthogonal determinant 0 N (by omega) (by
    intro col impossible
    omega)
  rw [decomposeSO, ← terminal, ← fullSweepSteps_action, applySteps_reverse_inverse]

/-- Including harmless identity rotations at zero pivots gives an exact count. -/
theorem decomposeSO_length {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ) :
    (decomposeSO A).length = N * (N - 1) / 2 := by
  simp only [decomposeSO, List.length_map, List.length_reverse, fullSweepSteps_length]


/-- The ordered two-dimensional block uses exactly the selected-RY convention. -/
theorem planeMatrix_selected_entry {N : ℕ} (i j : Fin N) (distinct : i ≠ j)
    (theta : ℝ) (rowBit colBit : Fin 2) :
    planeMatrix i j theta (if rowBit = 0 then i else j) (if colBit = 0 then i else j) =
      realRyPlaneBlock theta rowBit colBit := by
  fin_cases rowBit <;> fin_cases colBit <;>
    simp [planeMatrix, rotateRows, _root_.Matrix.one_apply, distinct, distinct.symm,
      realRyPlaneBlock]

/-- Every basis vector outside the selected pair is fixed, including its sign. -/
theorem planeMatrix_fixed_column {N : ℕ} (i j col : Fin N) (theta : ℝ)
    (outsideFirst : col ≠ i) (outsideSecond : col ≠ j) (row : Fin N) :
    planeMatrix i j theta row col = (1 : _root_.Matrix (Fin N) (Fin N) ℝ) row col := by
  by_cases first : row = i <;> by_cases second : row = j <;>
    simp_all [planeMatrix, rotateRows, _root_.Matrix.one_apply, eq_comm]

/-- Chronological matrix product, matching the circuit list convention. -/
noncomputable def stepsMatrix {N : ℕ} : List (Step N) → _root_.Matrix (Fin N) (Fin N) ℝ
  | [] => 1
  | step :: rest => stepsMatrix rest * step.matrix

theorem applySteps_eq_matrix_mul {N M : ℕ} (steps : List (Step N))
    (A : _root_.Matrix (Fin N) (Fin M) ℝ) : applySteps steps A = stepsMatrix steps * A := by
  induction steps generalizing A with
  | nil => simp [applySteps, stepsMatrix]
  | cons step rest ih =>
      simp only [applySteps, stepsMatrix, ih, _root_.Matrix.mul_assoc]

theorem decomposeSO_matrix {N : ℕ} (A : _root_.Matrix (Fin N) (Fin N) ℝ)
    (orthogonal : A.transpose * A = 1) (determinant : A.det = 1) :
    stepsMatrix (decomposeSO A) = A := by
  have action := decomposeSO_action A orthogonal determinant
  simpa only [applySteps_eq_matrix_mul, _root_.Matrix.mul_one] using action

end QuantumBlockEncoding.AdjacentGivens
