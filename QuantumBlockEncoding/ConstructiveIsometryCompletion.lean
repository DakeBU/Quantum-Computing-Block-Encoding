import QuantumBlockEncoding.AdjacentGivens
import QuantumBlockEncoding.RealIsometryCompletion
import QuantumBlockEncoding.RectangularGivens

/-!+# Deterministic completion of prescribed real isometry columns

The producers in this module use explicit finite rotations and permutations,
not orthonormal-basis extension or an existential matrix witness. The exact
real formulas are noncomputable Lean definitions; no classical evaluation-cost
bound is asserted here.
-/

namespace QuantumBlockEncoding.ConstructiveIsometryCompletion

open scoped BigOperators
open AdjacentGivens

/-- The first `k` rectangular columns are their corresponding coordinate vectors. -/
def PrefixColumns {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r ≤ N) (k : ℕ) : Prop :=
  ∀ col : Fin r, col.val < k → ∀ row : Fin N,
    V row col = if row = Fin.castLE hr col then 1 else 0

theorem rotateRows_isometry {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hV : V.transpose * V = 1) (i j : Fin N) (hij : i ≠ j) (theta : ℝ) :
    (rotateRows V i j theta).transpose * rotateRows V i j theta = 1 := by
  rw [← planeMatrix_mul, _root_.Matrix.transpose_mul]
  calc
    _ = V.transpose * ((planeMatrix i j theta).transpose * planeMatrix i j theta) * V := by
      simp only [_root_.Matrix.mul_assoc]
    _ = 1 := by rw [planeMatrix_orthogonal i j hij, _root_.Matrix.mul_one, hV]

theorem columnSweep_isometry {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hV : V.transpose * V = 1) (col : Fin r) (lo count : ℕ) (bound : lo + count < N) :
    (columnSweep V col lo count bound).transpose * columnSweep V col lo count bound = 1 := by
  induction count generalizing V with
  | zero => exact hV
  | succ count ih =>
    rw [columnSweep]
    apply ih
    apply rotateRows_isometry V hV
    intro equal
    have := congrArg Fin.val equal
    change lo + count = lo + count + 1 at this
    omega

theorem zero_of_fixed_column {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r ≤ N) (hV : V.transpose * V = 1) (old col : Fin r) (different : old ≠ col)
    (fixed : ∀ row, V row old = if row = Fin.castLE hr old then 1 else 0) :
    V (Fin.castLE hr old) col = 0 := by
  have entry := congrFun (congrFun hV old) col
  simpa [_root_.Matrix.mul_apply, _root_.Matrix.transpose_apply,
    fixed, _root_.Matrix.one_apply, different] using entry

theorem columnSweep_prefix {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r ≤ N) (col : Fin r) (count : ℕ) (bound : col.val + count < N)
    (fixed : PrefixColumns V hr col.val) :
    PrefixColumns (columnSweep V col col.val count bound) hr col.val := by
  intro old oldLt row
  rw [columnSweep_preserves_zero_column]
  · exact fixed old oldLt row
  · intro i lower upper
    rw [fixed old oldLt i, if_neg]
    intro equal
    have := congrArg Fin.val equal
    change i.val = old.val at this
    omega

theorem supported_column_sq {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r ≤ N) (hV : V.transpose * V = 1) (col : Fin r)
    (support : ∀ row, row ≠ Fin.castLE hr col → V row col = 0) :
    V (Fin.castLE hr col) col ^ 2 = 1 := by
  have entry := congrFun (congrFun hV col) col
  have collapse : (∑ row, V row col * V row col) =
      V (Fin.castLE hr col) col * V (Fin.castLE hr col) col := by
    apply Finset.sum_eq_single (Fin.castLE hr col)
    · intro row _ different
      rw [support row different]
      simp
    · intro missing
      exact False.elim (missing (Finset.mem_univ _))
  simp only [_root_.Matrix.mul_apply, _root_.Matrix.transpose_apply,
    _root_.Matrix.one_apply_eq] at entry
  rw [collapse] at entry
  simpa [sq] using entry

/-- A nonfinal rectangular isometry column is swept to a positive unit pivot. -/
theorem columnSweep_prefix_succ {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r ≤ N) (hV : V.transpose * V = 1) (col : Fin r) (count : ℕ)
    (dimension : col.val + count + 1 = N) (positive : 0 < count)
    (fixed : PrefixColumns V hr col.val) :
    PrefixColumns (columnSweep V col col.val count (by omega)) hr (col.val + 1) := by
  let W := columnSweep V col col.val count (by omega)
  have hW : W.transpose * W = 1 := columnSweep_isometry V hV _ _ _ _
  have prefixW : PrefixColumns W hr col.val := columnSweep_prefix V hr col count _ fixed
  have support (row : Fin N) (different : row ≠ Fin.castLE hr col) : W row col = 0 := by
    by_cases below : col.val < row.val
    · exact columnSweep_zeroed V col col.val count _ row below (by omega)
    · have above : row.val < col.val := by
        have notEqual : row.val ≠ col.val := fun equal => different (Fin.ext equal)
        omega
      let old : Fin r := ⟨row.val, lt_trans above col.isLt⟩
      have oldLt : old.val < col.val := above
      have distinct : old ≠ col := by
        intro equal
        have := congrArg Fin.val equal
        omega
      have castOld : Fin.castLE hr old = row := Fin.ext rfl
      rw [← castOld]
      exact zero_of_fixed_column W hr hW old col distinct (prefixW old oldLt)
  have normSq := supported_column_sq W hr hW col support
  have nonneg : 0 ≤ W (Fin.castLE hr col) col :=
    columnSweep_pivot_nonneg V col col.val count _ positive
  have pivot : W (Fin.castLE hr col) col = 1 := by nlinarith
  intro old oldLt row
  by_cases same : old = col
  · subst old
    by_cases hit : row = Fin.castLE hr col
    · simpa [hit] using pivot
    · simpa [hit] using support row hit
  · exact prefixW old (by
      have notEqual : old.val ≠ col.val := fun equal => same (Fin.ext equal)
      omega) row

/-- The shared rectangular sweep fixes every processed isometry column. -/
theorem sweep_prefix {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r < N) (hV : V.transpose * V = 1)
    (k remaining : ℕ) (columns : k + remaining ≤ r) (fixed : PrefixColumns V hr.le k) :
    PrefixColumns (RectangularGivens.sweep V k remaining columns) hr.le (k + remaining) := by
  induction remaining generalizing V k with
  | zero => simpa [RectangularGivens.sweep] using fixed
  | succ remaining ih =>
    have hk : k < N := by omega
    rw [RectangularGivens.sweep, dif_pos hk]
    have next := columnSweep_prefix_succ V hr.le hV ⟨k, by omega⟩ (N - 1 - k)
      (by change k + (N - 1 - k) + 1 = N; omega) (by omega) fixed
    have result := ih _ (columnSweep_isometry V hV _ _ _ _) (k + 1) (by omega) next
    simpa only [Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using result

theorem reduced_prefix {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r < N) (hV : V.transpose * V = 1) :
    PrefixColumns (RectangularGivens.reduced V) hr.le r := by
  simpa [RectangularGivens.reduced] using
    sweep_prefix V hr hV 0 r (by omega) (by intro col impossible; omega)

/-- Inverse of the explicitly computed row rotations; no matrix witness is chosen. -/
noncomputable def prefixCompletion {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ) :
    _root_.Matrix (Fin N) (Fin N) ℝ := (RectangularGivens.transform V).transpose

theorem prefixCompletion_orthogonal {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ) :
    (prefixCompletion V).transpose * prefixCompletion V = 1 := by
  simp only [prefixCompletion, _root_.Matrix.transpose_transpose]
  exact mul_eq_one_comm.mp (RectangularGivens.transform_orthogonal V)

theorem prefixCompletion_det {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ) :
    (prefixCompletion V).det = 1 := by
  rw [prefixCompletion, _root_.Matrix.det_transpose, RectangularGivens.transform_det]

theorem prefixCompletion_columns {N r : ℕ} (V : _root_.Matrix (Fin N) (Fin r) ℝ)
    (hr : r < N) (hV : V.transpose * V = 1) (row : Fin N) (col : Fin r) :
    prefixCompletion V row (Fin.castLE hr.le col) = V row col := by
  have h := congrFun (congrFun (RectangularGivens.exact_recovery V) row) col
  have hc := reduced_prefix V hr hV col col.isLt
  simpa [prefixCompletion, _root_.Matrix.mul_apply, hc] using h

/-- Greedy swaps deterministically extend a finite prefix injection. -/
def extendPrefix {N r : ℕ} (hr : r ≤ N) (e : Fin r ↪ Fin N) :
    (k : ℕ) → k ≤ r → Equiv.Perm (Fin N)
  | 0, _ => Equiv.refl _
  | k + 1, hk =>
      let p := extendPrefix hr e k (by omega)
      p.trans (Equiv.swap (p ⟨k, by omega⟩) (e ⟨k, by omega⟩))

theorem extendPrefix_agrees {N r : ℕ} (hr : r ≤ N) (e : Fin r ↪ Fin N)
    (k : ℕ) (hk : k ≤ r) (a : Fin r) (ha : a.val < k) :
    extendPrefix hr e k hk (Fin.castLE hr a) = e a := by
  induction k with
  | zero => omega
  | succ k ih =>
    simp only [extendPrefix, Equiv.trans_apply]
    by_cases last : a.val = k
    · have ea : (⟨k, by omega⟩ : Fin r) = a := Fin.ext last.symm
      have ia : (⟨k, by omega⟩ : Fin N) = Fin.castLE hr a := Fin.ext last.symm
      rw [ea, ia, Equiv.swap_apply_left]
    · have early : a.val < k := by omega
      have agree := ih (by omega) early
      rw [Equiv.swap_apply_of_ne_of_ne, agree]
      · intro equal
        have same := (extendPrefix hr e k (by omega)).injective equal
        have := congrArg Fin.val same
        change a.val = k at this
        omega
      · intro equal
        rw [agree] at equal
        have same := e.injective equal
        have := congrArg Fin.val same
        change a.val = k at this
        omega

/-- The first unused original coordinate is carried to an unused physical label. -/
def unusedPosition {N r : ℕ} (hr : r < N) (e : Fin r ↪ Fin N) : Fin N :=
  extendPrefix hr.le e r le_rfl ⟨r, hr⟩

theorem unusedPosition_ne {N r : ℕ} (hr : r < N) (e : Fin r ↪ Fin N) (a : Fin r) :
    e a ≠ unusedPosition hr e := by
  rw [← extendPrefix_agrees hr.le e r le_rfl a a.isLt]
  intro equal
  have same := (extendPrefix hr.le e r le_rfl).injective equal
  have := congrArg Fin.val same
  change a.val = r at this
  omega

/-- Send original column `a` to physical column `p a`. -/
def permuteColumns {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (p : Equiv.Perm (Fin N)) : _root_.Matrix (Fin N) (Fin N) ℝ :=
  U.submatrix id p.symm

@[simp] theorem permuteColumns_apply {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (p : Equiv.Perm (Fin N)) (row col : Fin N) :
    permuteColumns U p row (p col) = U row col := by
  simp [permuteColumns, _root_.Matrix.submatrix_apply]

theorem permuteColumns_orthogonal {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (hU : U.transpose * U = 1) (p : Equiv.Perm (Fin N)) :
    (permuteColumns U p).transpose * permuteColumns U p = 1 := by
  ext i j
  have h := congrFun (congrFun hU (p.symm i)) (p.symm j)
  simpa [permuteColumns, _root_.Matrix.submatrix_apply, _root_.Matrix.mul_apply,
    _root_.Matrix.transpose_apply, _root_.Matrix.one_apply] using h

theorem permuteColumns_det {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (p : Equiv.Perm (Fin N)) :
    (permuteColumns U p).det = (Equiv.Perm.sign p : ℤ) * U.det := by
  simpa [permuteColumns] using _root_.Matrix.det_permute' p.symm U

/-- Correct only an unused column, using finite permutation parity, not a determinant test. -/
noncomputable def orientColumns {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (p : Equiv.Perm (Fin N)) (unused : Fin N) : _root_.Matrix (Fin N) (Fin N) ℝ :=
  if Equiv.Perm.sign p = 1 then permuteColumns U p
  else permuteColumns U p * RealIsometryCompletion.signFlip unused

theorem orientColumns_orthogonal {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (hU : U.transpose * U = 1) (p : Equiv.Perm (Fin N)) (unused : Fin N) :
    (orientColumns U p unused).transpose * orientColumns U p unused = 1 := by
  unfold orientColumns
  split_ifs
  · exact permuteColumns_orthogonal U hU p
  · rw [_root_.Matrix.transpose_mul]
    calc
      _ = (RealIsometryCompletion.signFlip unused).transpose *
          ((permuteColumns U p).transpose * permuteColumns U p) *
          RealIsometryCompletion.signFlip unused := by simp only [_root_.Matrix.mul_assoc]
      _ = 1 := by rw [permuteColumns_orthogonal U hU p, _root_.Matrix.mul_one,
        RealIsometryCompletion.signFlip_orthogonal]

theorem orientColumns_det {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (hU : U.det = 1) (p : Equiv.Perm (Fin N)) (unused : Fin N) :
    (orientColumns U p unused).det = 1 := by
  unfold orientColumns
  split_ifs with positive
  · rw [permuteColumns_det, hU, positive]
    norm_num
  · have negative : Equiv.Perm.sign p = -1 :=
      (Int.units_eq_one_or (Equiv.Perm.sign p)).resolve_left positive
    rw [_root_.Matrix.det_mul, permuteColumns_det, RealIsometryCompletion.signFlip_det,
      hU, negative]
    norm_num

theorem orientColumns_preserves {N : ℕ} (U : _root_.Matrix (Fin N) (Fin N) ℝ)
    (p : Equiv.Perm (Fin N)) (unused row col : Fin N) (hcol : p col ≠ unused) :
    orientColumns U p unused row (p col) = U row col := by
  unfold orientColumns
  split_ifs
  · exact permuteColumns_apply U p row col
  · rw [RealIsometryCompletion.mul_signFlip_preserves _ _ _ _ hcol,
      permuteColumns_apply]

/-- Explicit physical-column placement of a prefix SO completion. -/
noncomputable def placeColumns {N r : ℕ} (hr : r < N) (e : Fin r ↪ Fin N)
    (U : _root_.Matrix (Fin N) (Fin N) ℝ) : _root_.Matrix (Fin N) (Fin N) ℝ :=
  orientColumns U (extendPrefix hr.le e r le_rfl) (unusedPosition hr e)

theorem placeColumns_spec {N r : ℕ} (hr : r < N) (e : Fin r ↪ Fin N)
    (U : _root_.Matrix (Fin N) (Fin N) ℝ) (hU : U.transpose * U = 1) (hd : U.det = 1) :
    (placeColumns hr e U).transpose * placeColumns hr e U = 1 ∧
    (placeColumns hr e U).det = 1 ∧
    ∀ row a, placeColumns hr e U row (e a) = U row (Fin.castLE hr.le a) := by
  refine ⟨orientColumns_orthogonal U hU _ _, orientColumns_det U hd _ _, ?_⟩
  intro row a
  have agree := extendPrefix_agrees hr.le e r le_rfl a a.isLt
  change orientColumns U _ _ row (e a) = _
  rw [← agree]
  apply orientColumns_preserves
  rw [agree]
  exact unusedPosition_ne hr e a

/-- Actual deterministic SO matrix with columns at the prescribed physical positions. -/
noncomputable def complete {N r : ℕ} (hr : r < N)
    (V : _root_.Matrix (Fin N) (Fin r) ℝ) (e : Fin r ↪ Fin N) :
    _root_.Matrix (Fin N) (Fin N) ℝ := placeColumns hr e (prefixCompletion V)

/-- The supplied hypothesis is only the input column isometry; the returned
matrix is computed by the named producer, not supplied or selected existentially. -/
theorem complete_spec {N r : ℕ} (hr : r < N)
    (V : _root_.Matrix (Fin N) (Fin r) ℝ) (e : Fin r ↪ Fin N)
    (hV : V.transpose * V = 1) :
    (complete hr V e).transpose * complete hr V e = 1 ∧
    (complete hr V e).det = 1 ∧ ∀ row a, complete hr V e row (e a) = V row a := by
  obtain ⟨ho, hd, hc⟩ := placeColumns_spec hr e (prefixCompletion V)
    (prefixCompletion_orthogonal V) (prefixCompletion_det V)
  refine ⟨ho, hd, ?_⟩
  intro row a
  exact (hc row a).trans (prefixCompletion_columns V hr hV row a)

/-- Transport using a supplied explicit coordinate equivalence, not an arbitrary
enumeration chosen for the named basis. -/
noncomputable def completeNamed {I : Type*} [Fintype I] [DecidableEq I] {N r : ℕ}
    (coordinates : I ≃ Fin N) (hr : r < N)
    (V : _root_.Matrix I (Fin r) ℝ) (e : Fin r ↪ I) : _root_.Matrix I I ℝ :=
  _root_.Matrix.reindex coordinates.symm coordinates.symm
    (complete hr (V.submatrix coordinates.symm id) (e.trans coordinates.toEmbedding))

theorem completeNamed_spec {I : Type*} [Fintype I] [DecidableEq I] {N r : ℕ}
    (coordinates : I ≃ Fin N) (hr : r < N)
    (V : _root_.Matrix I (Fin r) ℝ) (e : Fin r ↪ I) (hV : V.transpose * V = 1) :
    (completeNamed coordinates hr V e).transpose * completeNamed coordinates hr V e = 1 ∧
    (completeNamed coordinates hr V e).det = 1 ∧
    ∀ row a, completeNamed coordinates hr V e row (e a) = V row a := by
  let W := V.submatrix coordinates.symm id
  have hW : W.transpose * W = 1 := by
    ext a b
    have h := congrFun (congrFun hV a) b
    simp only [_root_.Matrix.mul_apply, _root_.Matrix.transpose_apply] at h ⊢
    exact ((coordinates.symm).sum_comp (fun i => V i a * V i b)).trans h
  let U := complete hr W (e.trans coordinates.toEmbedding)
  obtain ⟨ho, hd, hc⟩ := complete_spec hr W (e.trans coordinates.toEmbedding) hW
  let tr := _root_.Matrix.reindexAlgEquiv ℝ ℝ coordinates.symm
  change (tr U).transpose * tr U = 1 ∧ (tr U).det = 1 ∧
    ∀ row a, tr U row (e a) = V row a
  refine ⟨?_, ?_, ?_⟩
  · change tr U.transpose * tr U = 1
    rw [← map_mul, ho, map_one]
  · simpa [tr, _root_.Matrix.reindexAlgEquiv_apply] using hd
  · intro row a
    simpa [tr, U, W, _root_.Matrix.reindexAlgEquiv_apply,
      _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply] using hc (coordinates row) a

end QuantumBlockEncoding.ConstructiveIsometryCompletion
