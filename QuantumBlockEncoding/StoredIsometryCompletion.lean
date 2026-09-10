import QuantumBlockEncoding.StoredRectangularGivens
import QuantumBlockEncoding.ConstructiveIsometryCompletion

/-!
# Stored, costed completion of prescribed isometry columns

The active matrix and its physical column positions are stored input data.
The prefix completion is obtained from the stored rectangular transform and
a charged transpose. Finite permutation images and inverse images are stored
and updated by explicit swaps; orientation is tracked as a real sign using
one charged negation per nontrivial swap. No determinant or permutation-sign
specification is evaluated. Costs use the extended exact-real model from
`StoredGivens`, not finite-bit runtime.
-/

namespace QuantumBlockEncoding.StoredIsometryCompletion

open StoredGivens

structure Positions (N r : ℕ) where
  values : Vector (Fin N) r
  injective : Function.Injective (fun i : Fin r => values[i.val])

def Positions.embedding {N r : ℕ} (e : Positions N r) : Fin r ↪ Fin N :=
  ⟨fun i => e.values[i.val], e.injective⟩

/-- Materialize a counted physical-label generator. Injectivity is an input
contract, not a charged search for a proof or a freely evaluated embedding. -/
def Positions.materialize {N r : ℕ} (f : Fin r → Run (Fin N))
    (injective : Function.Injective (fun i => (f i).value)) : Run (Positions N r) :=
  let entries := collect f
  ⟨⟨entries.value, by
      intro a b equal
      apply injective
      simpa [entries] using equal⟩, entries.cost⟩

theorem Positions.materialize_value {N r : ℕ} (f : Fin r → Run (Fin N))
    (injective : Function.Injective (fun i => (f i).value)) (i : Fin r) :
    (Positions.materialize f injective).value.embedding i = (f i).value := by
  simp [Positions.materialize, Positions.embedding]

theorem Positions.materialize_cost {N r : ℕ} (f : Fin r → Run (Fin N))
    (injective : Function.Injective (fun i => (f i).value)) (op : Op) :
    (Positions.materialize f injective).cost op = (∑ i : Fin r, (f i).cost op) +
      r * (2 * tick .read op + 2 * tick .write op) := by
  simp [Positions.materialize, collect_cost]

def transpose {N M : ℕ} (A : StoredMatrix N M) : Run (StoredMatrix M N) :=
  materialize fun i j => do
    let row ← read A j
    read row i

theorem transpose_value {N M : ℕ} (A : StoredMatrix N M) :
    denote (transpose A).value = (denote A).transpose := by
  ext i j
  simp [transpose, materialize, denote, bind, Run.bind, StoredGivens.read, charge,
    _root_.Matrix.transpose_apply]

def transposeBudget (N M : ℕ) : Cost := fun op =>
  (4 * N * M + 2 * M) * tick .read op + (2 * N * M + 2 * M) * tick .write op

theorem transpose_cost {N M : ℕ} (A : StoredMatrix N M) (op : Op) :
    (transpose A).cost op = transposeBudget N M op := by
  simp [transpose, materialize_cost, bind, Run.bind, StoredGivens.read, charge, transposeBudget]
  ring

noncomputable def prefixCompletion {N r : ℕ} (V : StoredMatrix N r) :
    Run (StoredMatrix N N) := do
  let result ← StoredRectangularGivens.compile V
  transpose result.transform

theorem prefixCompletion_value {N r : ℕ} (V : StoredMatrix N r) :
    denote (prefixCompletion V).value =
      ConstructiveIsometryCompletion.prefixCompletion (denote V) := by
  simp [prefixCompletion, bind, Run.bind, transpose_value,
    StoredRectangularGivens.compile_transform,
    ConstructiveIsometryCompletion.prefixCompletion]

def prefixBudget (N r : ℕ) : Cost :=
  StoredRectangularGivens.polynomialBudget N r + transposeBudget N N

theorem prefixCompletion_cost_le {N r : ℕ} (V : StoredMatrix N r) (op : Op) :
    (prefixCompletion V).cost op ≤ prefixBudget N r op := by
  have h := StoredRectangularGivens.compile_polynomial_cost_le V op
  simp [prefixCompletion, bind, Run.bind, transpose_cost, prefixBudget]
  omega

/-- Both equality decisions are actual charged operations; the second is
skipped if the first comparison succeeds. -/
def swapIndex {N : ℕ} (x y z : Fin N) : Run (Fin N) := do
  let first ← charge .compare (decide (z = x))
  if first then pure y else do
    let second ← charge .compare (decide (z = y))
    if second then pure x else pure z

theorem swapIndex_value {N : ℕ} (x y z : Fin N) :
    (swapIndex x y z).value = Equiv.swap x y z := by
  by_cases hx : z = x <;> by_cases hy : z = y <;>
    simp_all [swapIndex, bind, pure, Run.bind, Run.pure, charge,
      Equiv.swap_apply_def]

theorem swapIndex_cost_le {N : ℕ} (x y z : Fin N) (op : Op) :
    (swapIndex x y z).cost op ≤ 2 * tick .compare op := by
  by_cases hx : z = x <;> by_cases hy : z = y <;>
    simp_all [swapIndex, bind, pure, Run.bind, Run.pure, charge] <;> omega

structure PermutationTable (N : ℕ) where
  forward : Vector (Fin N) N
  inverse : Vector (Fin N) N
  polarity : ℝ

def identityPermutation (N : ℕ) : Run (PermutationTable N) := do
  let forward ← collect (fun i : Fin N => pure i)
  let inverse ← collect (fun i : Fin N => pure i)
  pure ⟨forward, inverse, 1⟩

noncomputable def swapPermutation {N : ℕ} (p : PermutationTable N) (x y : Fin N) :
    Run (PermutationTable N) := do
  let forward ← collect fun i => do
    let old ← read p.forward i
    swapIndex x y old
  let inverse ← collect fun i => do
    let oldIndex ← swapIndex x y i
    read p.inverse oldIndex
  let same ← charge .compare (decide (x = y))
  let polarity ← if same then pure p.polarity else StoredGivens.sub 0 p.polarity
  pure ⟨forward, inverse, polarity⟩

theorem swapPermutation_forward {N : ℕ} (p : PermutationTable N) (x y i : Fin N) :
    (swapPermutation p x y).value.forward[i.val] = Equiv.swap x y p.forward[i.val] := by
  by_cases h : x = y <;>
    simp [swapPermutation, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge,
      swapIndex_value, h, StoredGivens.sub]

theorem swapPermutation_inverse {N : ℕ} (p : PermutationTable N) (x y i : Fin N) :
    (swapPermutation p x y).value.inverse[i.val] = p.inverse[(Equiv.swap x y i).val] := by
  by_cases h : x = y <;>
    simp [swapPermutation, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge,
      swapIndex_value, h, StoredGivens.sub]

theorem swapPermutation_polarity {N : ℕ} (p : PermutationTable N) (x y : Fin N) :
    (swapPermutation p x y).value.polarity = if x = y then p.polarity else -p.polarity := by
  by_cases h : x = y <;>
    simp [swapPermutation, bind, pure, Run.bind, Run.pure, charge, h, StoredGivens.sub]

/-- A proof-only interpretation of permutation orientation. -/
def realSign {N : ℕ} (p : Equiv.Perm (Fin N)) : ℝ := (Equiv.Perm.sign p : ℤ)

theorem realSign_swap_trans {N : ℕ} (p : Equiv.Perm (Fin N)) (x y : Fin N) :
    realSign (p.trans (Equiv.swap x y)) = if x = y then realSign p else -realSign p := by
  by_cases h : x = y <;>
    simp [realSign, Equiv.Perm.sign_trans, Equiv.Perm.sign_swap', h]

theorem realSign_one_iff {N : ℕ} (p : Equiv.Perm (Fin N)) :
    realSign p = 1 ↔ Equiv.Perm.sign p = 1 := by
  rcases Int.units_eq_one_or (Equiv.Perm.sign p) with h | h <;>
    norm_num [realSign, h]

noncomputable def permutation {N r : ℕ} (hr : r ≤ N) (e : Positions N r) :
    (k : ℕ) → k ≤ r → Run (PermutationTable N)
  | 0, _ => identityPermutation N
  | k + 1, hk => do
      let p ← permutation hr e k (by omega)
      let x ← read p.forward ⟨k, by omega⟩
      let y ← read e.values ⟨k, by omega⟩
      swapPermutation p x y

theorem permutation_forward {N r : ℕ} (hr : r ≤ N) (e : Positions N r)
    (k : ℕ) (hk : k ≤ r) (i : Fin N) :
    (permutation hr e k hk).value.forward[i.val] =
      ConstructiveIsometryCompletion.extendPrefix hr e.embedding k hk i := by
  induction k generalizing i with
  | zero => simp [permutation, identityPermutation, bind, pure, Run.bind, Run.pure,
      ConstructiveIsometryCompletion.extendPrefix]
  | succ k ih =>
    simp only [permutation, bind, Run.bind, StoredGivens.read, charge, swapPermutation_forward,
      ConstructiveIsometryCompletion.extendPrefix, Equiv.trans_apply]
    rw [ih (by omega) ⟨k, by omega⟩, ih]
    rfl

theorem permutation_inverse {N r : ℕ} (hr : r ≤ N) (e : Positions N r)
    (k : ℕ) (hk : k ≤ r) (i : Fin N) :
    (permutation hr e k hk).value.inverse[i.val] =
      (ConstructiveIsometryCompletion.extendPrefix hr e.embedding k hk).symm i := by
  induction k generalizing i with
  | zero => simp [permutation, identityPermutation, bind, pure, Run.bind, Run.pure,
      ConstructiveIsometryCompletion.extendPrefix]
  | succ k ih =>
    simp only [permutation, bind, Run.bind, StoredGivens.read, charge, swapPermutation_inverse,
      ConstructiveIsometryCompletion.extendPrefix, Equiv.symm_trans_apply]
    rw [permutation_forward hr e k (by omega) ⟨k, by omega⟩, ih]
    rfl

theorem permutation_polarity {N r : ℕ} (hr : r ≤ N) (e : Positions N r)
    (k : ℕ) (hk : k ≤ r) :
    (permutation hr e k hk).value.polarity =
      realSign (ConstructiveIsometryCompletion.extendPrefix hr e.embedding k hk) := by
  induction k with
  | zero => simp [permutation, identityPermutation, bind, pure, Run.bind, Run.pure,
      ConstructiveIsometryCompletion.extendPrefix, realSign]
  | succ k ih =>
    simp only [permutation, bind, Run.bind, StoredGivens.read, charge, swapPermutation_polarity,
      ConstructiveIsometryCompletion.extendPrefix, realSign_swap_trans]
    rw [permutation_forward hr e k (by omega) ⟨k, by omega⟩, ih]
    rfl

theorem collect_cost_le {n : ℕ} (f : Fin n → Run α) (op : Op) (cap : ℕ)
    (bounded : ∀ i, (f i).cost op ≤ cap) :
    (collect f).cost op ≤ n * (cap + 2 * tick .read op + 2 * tick .write op) := by
  rw [collect_cost]
  have h := Finset.sum_le_sum (s := Finset.univ) (fun i _ => bounded i)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul] at h
  nlinarith

def swapBudget (N : ℕ) : Cost := fun op =>
  tick .field op + (4 * N + 1) * tick .compare op +
    6 * N * tick .read op + 4 * N * tick .write op

theorem swapPermutation_cost_le {N : ℕ} (p : PermutationTable N) (x y : Fin N) (op : Op) :
    (swapPermutation p x y).cost op ≤ swapBudget N op := by
  have forward := collect_cost_le (fun i : Fin N => do
    let old ← StoredGivens.read p.forward i
    swapIndex x y old) op (tick .read op + 2 * tick .compare op) (by
      intro i
      have h := swapIndex_cost_le x y p.forward[i.val] op
      simp [bind, Run.bind, StoredGivens.read, charge]
      omega)
  have inverse := collect_cost_le (fun i : Fin N => do
    let oldIndex ← swapIndex x y i
    StoredGivens.read p.inverse oldIndex) op (tick .read op + 2 * tick .compare op) (by
      intro i
      have h := swapIndex_cost_le x y i op
      simp [bind, Run.bind, StoredGivens.read, charge]
      omega)
  by_cases same : x = y <;>
    simp only [swapPermutation, bind, pure, Run.bind, Run.pure, charge, StoredGivens.sub,
      decide_eq_true_eq, Pi.add_apply, add_zero] <;>
    simp only [same, ↓reduceIte, Pi.zero_apply, add_zero] <;>
    simp only [bind, Run.bind, same] at forward inverse <;>
    simp only [swapBudget] <;> nlinarith

def permutationBudget (N k : ℕ) : Cost := fun op =>
  4 * N * (tick .read op + tick .write op) + k * (swapBudget N op + 2 * tick .read op)

theorem identityPermutation_cost (N : ℕ) (op : Op) :
    (identityPermutation N).cost op = 4 * N * (tick .read op + tick .write op) := by
  simp [identityPermutation, bind, pure, Run.bind, Run.pure, collect_cost]
  ring

theorem permutation_cost_le {N r : ℕ} (hr : r ≤ N) (e : Positions N r)
    (k : ℕ) (hk : k ≤ r) (op : Op) :
    (permutation hr e k hk).cost op ≤ permutationBudget N k op := by
  induction k with
  | zero => simp [permutation, identityPermutation_cost, permutationBudget]
  | succ k ih =>
    have h := swapPermutation_cost_le (permutation hr e k (by omega)).value
      (permutation hr e k (by omega)).value.forward[k] e.values[k] op
    have previous := ih (by omega)
    simp only [permutation, bind, Run.bind, StoredGivens.read, charge, Pi.add_apply]
    calc
      _ ≤ permutationBudget N k op +
          (tick .read op + (tick .read op + swapBudget N op)) :=
        Nat.add_le_add previous (Nat.add_le_add_left (Nat.add_le_add_left h _) _)
      _ = permutationBudget N (k + 1) op := by simp only [permutationBudget]; ring

/-- Every matrix entry reads its old column from the stored inverse table. -/
def permuteColumns {N : ℕ} (U : StoredMatrix N N) (inverse : Vector (Fin N) N) :
    Run (StoredMatrix N N) :=
  materialize fun row col => do
    let old ← StoredGivens.read inverse col
    let values ← StoredGivens.read U row
    StoredGivens.read values old

theorem permuteColumns_value {N : ℕ} (U : StoredMatrix N N) (inverse : Vector (Fin N) N)
    (row col : Fin N) :
    denote (permuteColumns U inverse).value row col = denote U row inverse[col.val] := by
  simp [permuteColumns, materialize, denote, bind, Run.bind, StoredGivens.read, charge]

def permuteBudget (N : ℕ) : Cost := fun op =>
  (5 * N * N + 2 * N) * tick .read op + (2 * N * N + 2 * N) * tick .write op

theorem permuteColumns_cost {N : ℕ} (U : StoredMatrix N N) (inverse : Vector (Fin N) N)
    (op : Op) : (permuteColumns U inverse).cost op = permuteBudget N op := by
  simp [permuteColumns, materialize_cost, bind, Run.bind, StoredGivens.read, charge,
    permuteBudget]
  ring

/-- Negate exactly the spare entry of each stored row. Full row copies are
charged, including the untouched entries, so no in-place storage is assumed. -/
noncomputable def signColumn {N : ℕ} (U : StoredMatrix N N) (spare : Fin N) :
    Run (StoredMatrix N N) :=
  collect fun row => do
    let values ← StoredGivens.read U row
    let old ← StoredGivens.read values spare
    let flipped ← StoredGivens.sub 0 old
    replace values spare flipped

theorem signColumn_value {N : ℕ} (U : StoredMatrix N N) (spare : Fin N) :
    denote (signColumn U spare).value = denote U * RealIsometryCompletion.signFlip spare := by
  ext row col
  by_cases h : col = spare
  · subst col
    simp [signColumn, denote, collect_value, bind, Run.bind, StoredGivens.read,
      StoredGivens.sub, charge, replace, RealIsometryCompletion.signFlip,
      _root_.Matrix.mul_diagonal]
  · have hval : spare.val ≠ col.val := by
      intro same
      exact h (Fin.ext same.symm)
    simp [signColumn, denote, collect_value, bind, Run.bind, StoredGivens.read,
      StoredGivens.sub, charge, replace, RealIsometryCompletion.signFlip,
      _root_.Matrix.mul_diagonal, h, hval]

def signBudget (N : ℕ) : Cost := fun op =>
  N * tick .field op + (N * N + 4 * N) * tick .read op +
    (N * N + 2 * N) * tick .write op

theorem signColumn_cost {N : ℕ} (U : StoredMatrix N N) (spare : Fin N) (op : Op) :
    (signColumn U spare).cost op = signBudget N op := by
  simp [signColumn, collect_cost, bind, Run.bind, StoredGivens.read, StoredGivens.sub,
    charge, replace, signBudget]
  ring

noncomputable def placeColumns {N r : ℕ} (hr : r < N) (e : Positions N r)
    (U : StoredMatrix N N) : Run (StoredMatrix N N) := do
  let p ← permutation hr.le e r le_rfl
  let spare ← StoredGivens.read p.forward ⟨r, hr⟩
  let moved ← permuteColumns U p.inverse
  let positive ← charge .compare (decide (p.polarity = 1))
  if positive then pure moved else signColumn moved spare

theorem placeColumns_value {N r : ℕ} (hr : r < N) (e : Positions N r)
    (U : StoredMatrix N N) :
    denote (placeColumns hr e U).value =
      ConstructiveIsometryCompletion.placeColumns hr e.embedding (denote U) := by
  let p := ConstructiveIsometryCompletion.extendPrefix hr.le e.embedding r le_rfl
  have moved : denote (permuteColumns U (permutation hr.le e r le_rfl).value.inverse).value =
      ConstructiveIsometryCompletion.permuteColumns (denote U) p := by
    ext row col
    rw [permuteColumns_value, permutation_inverse]
    rfl
  have parity : (permutation hr.le e r le_rfl).value.polarity = 1 ↔ Equiv.Perm.sign p = 1 := by
    rw [permutation_polarity]
    exact realSign_one_iff p
  by_cases h : Equiv.Perm.sign p = 1
  · have hp := parity.mpr h
    dsimp [p] at h
    simp only [placeColumns, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge,
      hp, decide_true, ↓reduceIte, moved,
      ConstructiveIsometryCompletion.placeColumns,
      ConstructiveIsometryCompletion.orientColumns]
    simp only [h, ↓reduceIte]
    rfl
  · have hp : (permutation hr.le e r le_rfl).value.polarity ≠ 1 := fun same => h (parity.mp same)
    dsimp [p] at h
    simp only [placeColumns, bind, Run.bind, StoredGivens.read, charge,
      hp, decide_false, Bool.false_eq_true, ↓reduceIte, signColumn_value, moved,
      ConstructiveIsometryCompletion.placeColumns,
      ConstructiveIsometryCompletion.orientColumns]
    simp only [h, ↓reduceIte]
    rw [permutation_forward hr.le e r le_rfl ⟨r, hr⟩]
    rfl

def placeBudget (N r : ℕ) : Cost :=
  permutationBudget N r + tick .read + permuteBudget N + tick .compare + signBudget N

theorem placeColumns_cost_le {N r : ℕ} (hr : r < N) (e : Positions N r)
    (U : StoredMatrix N N) (op : Op) :
    (placeColumns hr e U).cost op ≤ placeBudget N r op := by
  have perm := permutation_cost_le hr.le e r le_rfl op
  by_cases h : (permutation hr.le e r le_rfl).value.polarity = 1 <;>
    simp [placeColumns, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge,
      h, permuteColumns_cost, signColumn_cost, placeBudget] <;> omega

noncomputable def complete {N r : ℕ} (hr : r < N) (V : StoredMatrix N r)
    (e : Positions N r) : Run (StoredMatrix N N) := do
  let base ← prefixCompletion V
  placeColumns hr e base

theorem complete_value {N r : ℕ} (hr : r < N) (V : StoredMatrix N r)
    (e : Positions N r) :
    denote (complete hr V e).value =
      ConstructiveIsometryCompletion.complete hr (denote V) e.embedding := by
  simp [complete, bind, Run.bind, placeColumns_value, prefixCompletion_value,
    ConstructiveIsometryCompletion.complete]

def completeBudget (N r : ℕ) : Cost := prefixBudget N r + placeBudget N r

theorem complete_cost_le {N r : ℕ} (hr : r < N) (V : StoredMatrix N r)
    (e : Positions N r) (op : Op) :
    (complete hr V e).cost op ≤ completeBudget N r op := by
  have prefixBound := prefixCompletion_cost_le V op
  have placed := placeColumns_cost_le hr e (prefixCompletion V).value op
  simp [complete, bind, Run.bind, completeBudget]
  omega

theorem complete_spec {N r : ℕ} (hr : r < N) (V : StoredMatrix N r)
    (e : Positions N r) (hV : (denote V).transpose * denote V = 1) :
    (denote (complete hr V e).value).transpose * denote (complete hr V e).value = 1 ∧
    (denote (complete hr V e).value).det = 1 ∧
    ∀ row a, denote (complete hr V e).value row (e.embedding a) = denote V row a := by
  rw [complete_value]
  exact ConstructiveIsometryCompletion.complete_spec hr (denote V) e.embedding hV

/-- Expanded bound including the stored prefix matrix, both permutation
tables, orientation tracking, column placement, and spare-column correction. -/
def polynomialBudget (N r : ℕ) : Cost
  | .field => N * r * (6 * r + 6 * N + 9) + r + N
  | .sqrt => N * r
  | .angle => N * r
  | .trig => 4 * N * r
  | .compare => 6 * N * r + 2 * r + N * N + 1
  | .read => N * r * (10 * r + 14 * N + 16) + 12 * N * N + 14 * N + 2 * r + 2
  | .write => N * r * (6 * r + 10 * N + 5) + 7 * N * N + 12 * N
  | .emit => N * r

theorem completeBudget_eq (N r : ℕ) : completeBudget N r = polynomialBudget N r := by
  funext op
  cases op <;>
    simp [completeBudget, prefixBudget, placeBudget, permutationBudget, swapBudget,
      transposeBudget, permuteBudget, signBudget, polynomialBudget,
      StoredRectangularGivens.polynomialBudget, tick] <;> ring

theorem complete_polynomial_cost_le {N r : ℕ} (hr : r < N) (V : StoredMatrix N r)
    (e : Positions N r) (op : Op) :
    (complete hr V e).cost op ≤ polynomialBudget N r op := by
  rw [← completeBudget_eq]
  exact complete_cost_le hr V e op

theorem complete_total_cost_le {N r : ℕ} (hr : r < N) (V : StoredMatrix N r)
    (e : Positions N r) :
    StoredRectangularGivens.total (complete hr V e).cost ≤
      N * r * (22 * r + 30 * N + 43) + 20 * N * N + 27 * N + 5 * r + 3 := by
  have hf := complete_polynomial_cost_le hr V e .field
  have hs := complete_polynomial_cost_le hr V e .sqrt
  have ha := complete_polynomial_cost_le hr V e .angle
  have ht := complete_polynomial_cost_le hr V e .trig
  have hc := complete_polynomial_cost_le hr V e .compare
  have hread := complete_polynomial_cost_le hr V e .read
  have hw := complete_polynomial_cost_le hr V e .write
  have he := complete_polynomial_cost_le hr V e .emit
  simp only [polynomialBudget] at *
  simp only [StoredRectangularGivens.total]
  nlinarith

/-- Source construction is composed as counted input producers, never an
unpriced callback hidden inside the completion. -/
noncomputable def completeFrom {N r : ℕ} (hr : r < N)
    (active : Run (StoredMatrix N r)) (positions : Run (Positions N r)) :
    Run (StoredMatrix N N) := do
  let V ← active
  let e ← positions
  complete hr V e

theorem completeFrom_value {N r : ℕ} (hr : r < N)
    (active : Run (StoredMatrix N r)) (positions : Run (Positions N r)) :
    denote (completeFrom hr active positions).value =
      ConstructiveIsometryCompletion.complete hr (denote active.value) positions.value.embedding := by
  simp [completeFrom, bind, Run.bind, complete_value]

theorem completeFrom_cost_le {N r : ℕ} (hr : r < N)
    (active : Run (StoredMatrix N r)) (positions : Run (Positions N r)) (op : Op) :
    (completeFrom hr active positions).cost op ≤
      active.cost op + positions.cost op + polynomialBudget N r op := by
  have h := complete_polynomial_cost_le hr active.value positions.value op
  simp [completeFrom, bind, Run.bind]
  omega

end QuantumBlockEncoding.StoredIsometryCompletion
