import QuantumBlockEncoding.StoredRectangularGivens
import QuantumBlockEncoding.ConstructiveThinLQ

/-!
# Stored exact-real thin LQ

Transpose, elimination, and both factor extractions are materialized counted
operations. The returned matrices refine the deterministic thin-LQ factors.
Bounds use the extended exact-real model of `StoredGivens`, not bit complexity.
-/

namespace QuantumBlockEncoding.StoredThinLQ

open StoredGivens

structure Factors (m n k : ℕ) where
  R : StoredMatrix m k
  Q : StoredMatrix k n

def entry {N M : ℕ} (A : StoredMatrix N M) (i : Fin N) (j : Fin M) : Run ℝ := do
  let row ← read A i
  read row j

@[simp] theorem entry_value {N M : ℕ} (A : StoredMatrix N M) (i : Fin N) (j : Fin M) :
    (entry A i j).value = denote A i j := rfl

@[simp] theorem entry_cost {N M : ℕ} (A : StoredMatrix N M) (i : Fin N) (j : Fin M)
    (op : Op) : (entry A i j).cost op = 2 * tick .read op := by
  simp [entry, bind, Run.bind, StoredGivens.read, charge]
  omega

def transpose {m n : ℕ} (A : StoredMatrix m n) : Run (StoredMatrix n m) :=
  materialize (fun i j => entry A j i)

theorem transpose_value {m n : ℕ} (A : StoredMatrix m n) :
    denote (transpose A).value = (denote A).transpose := by
  ext i j
  simp [transpose, materialize, denote]

def extractionBudget (N M : ℕ) : Cost := fun op =>
  2 * N * M * tick .read op + (N * M + N) * (2 * tick .read op + 2 * tick .write op)

theorem transpose_cost {m n : ℕ} (A : StoredMatrix m n) (op : Op) :
    (transpose A).cost op = extractionBudget n m op := by
  simp [transpose, materialize_cost, extractionBudget]
  ring

def extractR {m n : ℕ} (h : m ≤ n) (C : StoredMatrix n m) : Run (StoredMatrix m m) :=
  materialize (fun i j => entry C (Fin.castLE h j) i)

def extractQ {m n : ℕ} (h : m ≤ n) (E : StoredMatrix n n) : Run (StoredMatrix m n) :=
  materialize (fun i j => entry E (Fin.castLE h i) j)

theorem extractR_value {m n : ℕ} (h : m ≤ n) (C : StoredMatrix n m) :
    denote (extractR h C).value = fun i j => denote C (Fin.castLE h j) i := by
  ext i j
  simp [extractR, materialize, denote]

theorem extractQ_value {m n : ℕ} (h : m ≤ n) (E : StoredMatrix n n) :
    denote (extractQ h E).value = fun i j => denote E (Fin.castLE h i) j := by
  ext i j
  simp [extractQ, materialize, denote]

theorem extractR_cost {m n : ℕ} (h : m ≤ n) (C : StoredMatrix n m) (op : Op) :
    (extractR h C).cost op = extractionBudget m m op := by
  simp [extractR, materialize_cost, extractionBudget]
  ring

theorem extractQ_cost {m n : ℕ} (h : m ≤ n) (E : StoredMatrix n n) (op : Op) :
    (extractQ h E).cost op = extractionBudget m n op := by
  simp [extractQ, materialize_cost, extractionBudget]
  ring

noncomputable def wide {m n : ℕ} (h : m ≤ n) (A : StoredMatrix m n) :
    Run (Factors m n m) := do
  let At ← transpose A
  let result ← StoredRectangularGivens.compile At
  let R ← extractR h result.reduced
  let Q ← extractQ h result.transform
  pure ⟨R, Q⟩

theorem wide_R {m n : ℕ} (h : m ≤ n) (A : StoredMatrix m n) :
    denote (wide h A).value.R = ConstructiveThinLQ.wideR h (denote A) := by
  simp only [wide, bind, pure, Run.bind, Run.pure, extractR_value,
    StoredRectangularGivens.compile_reduced, transpose_value]
  rfl

theorem wide_Q {m n : ℕ} (h : m ≤ n) (A : StoredMatrix m n) :
    denote (wide h A).value.Q = ConstructiveThinLQ.wideQ h (denote A) := by
  simp only [wide, bind, pure, Run.bind, Run.pure, extractQ_value,
    StoredRectangularGivens.compile_transform, transpose_value]
  rfl

theorem wide_correct {m n : ℕ} (h : m ≤ n) (A : StoredMatrix m n) :
    denote A = denote (wide h A).value.R * denote (wide h A).value.Q ∧
      denote (wide h A).value.Q * (denote (wide h A).value.Q).transpose = 1 := by
  rw [wide_R, wide_Q]
  exact ⟨ConstructiveThinLQ.wide_factorization h _, ConstructiveThinLQ.wide_orthogonal h _⟩

def wideBudget (m n : ℕ) : Cost :=
  extractionBudget n m + StoredRectangularGivens.polynomialBudget n m +
    extractionBudget m m + extractionBudget m n

theorem wide_cost_le {m n : ℕ} (h : m ≤ n) (A : StoredMatrix m n) (op : Op) :
    (wide h A).cost op ≤ wideBudget m n op := by
  have bound := StoredRectangularGivens.compile_polynomial_cost_le (transpose A).value op
  simp only [wide, bind, pure, Run.bind, Run.pure, Pi.add_apply, add_zero,
    transpose_cost, extractR_cost, extractQ_cost, wideBudget]
  omega

noncomputable def compileBody {m n : ℕ} (A : StoredMatrix m n) :
    Run (Factors m n (min m n)) := by
  by_cases h : m ≤ n
  · rw [min_eq_left h]
    exact wide h A
  · rw [min_eq_right (show n ≤ m by omega)]
    exact do
      let Q ← StoredRectangularGivens.identity n
      pure ⟨A, Q⟩

/-- The all-shape dispatcher additionally charges its dimension comparison. -/
noncomputable def compile {m n : ℕ} (A : StoredMatrix m n) :
    Run (Factors m n (min m n)) :=
  let result := compileBody A
  ⟨result.value, tick .compare + result.cost⟩

private theorem cast_R {m n k k' : ℕ} (A : _root_.Matrix (Fin m) (Fin n) ℝ)
    (h : k = k') (stored : Run (Factors m n k'))
    (semantic : ConstructiveThinLQ.Factorization A k')
    (equal : denote stored.value.R = semantic.R) :
    denote (Eq.mpr (congrArg (fun d => Run (Factors m n d)) h) stored).value.R =
      (Eq.mpr (congrArg (fun d => ConstructiveThinLQ.Factorization A d) h) semantic).R := by
  subst k'
  exact equal

private theorem cast_Q {m n k k' : ℕ} (A : _root_.Matrix (Fin m) (Fin n) ℝ)
    (h : k = k') (stored : Run (Factors m n k'))
    (semantic : ConstructiveThinLQ.Factorization A k')
    (equal : denote stored.value.Q = semantic.Q) :
    denote (Eq.mpr (congrArg (fun d => Run (Factors m n d)) h) stored).value.Q =
      (Eq.mpr (congrArg (fun d => ConstructiveThinLQ.Factorization A d) h) semantic).Q := by
  subst k'
  exact equal

theorem compile_R {m n : ℕ} (A : StoredMatrix m n) :
    denote (compile A).value.R = (ConstructiveThinLQ.factor (denote A)).R := by
  by_cases h : m ≤ n
  · simp only [compile, compileBody, ConstructiveThinLQ.factor, dif_pos h]
    exact cast_R _ (min_eq_left h) _ _ (wide_R h A)
  · simp only [compile, compileBody, ConstructiveThinLQ.factor, dif_neg h]
    exact cast_R _ (min_eq_right (show n ≤ m by omega)) _ _ rfl

theorem compile_Q {m n : ℕ} (A : StoredMatrix m n) :
    denote (compile A).value.Q = (ConstructiveThinLQ.factor (denote A)).Q := by
  by_cases h : m ≤ n
  · simp only [compile, compileBody, ConstructiveThinLQ.factor, dif_pos h]
    exact cast_Q _ (min_eq_left h) _ _ (wide_Q h A)
  · simp only [compile, compileBody, ConstructiveThinLQ.factor, dif_neg h]
    exact cast_Q _ (min_eq_right (show n ≤ m by omega)) _ _
      (StoredRectangularGivens.identity_value n)

theorem compile_correct {m n : ℕ} (A : StoredMatrix m n) :
    denote A = denote (compile A).value.R * denote (compile A).value.Q ∧
      denote (compile A).value.Q * (denote (compile A).value.Q).transpose = 1 := by
  rw [compile_R, compile_Q]
  exact ConstructiveThinLQ.factor_correct _

private theorem cast_cost_le {m n k k' : ℕ} (h : k = k') (stored : Run (Factors m n k'))
    (op : Op) (budget : ℕ) (bound : stored.cost op ≤ budget) :
    (Eq.mpr (congrArg (fun d => Run (Factors m n d)) h) stored).cost op ≤ budget := by
  subst k'
  exact bound

def compileBudget (m n : ℕ) : Cost := tick .compare +
  if m ≤ n then wideBudget m n else StoredRectangularGivens.identityBudget n

theorem compile_cost_le {m n : ℕ} (A : StoredMatrix m n) (op : Op) :
    (compile A).cost op ≤ compileBudget m n op := by
  by_cases h : m ≤ n
  · simp only [compile, compileBody, dif_pos h, Pi.add_apply,
      compileBudget, if_pos h]
    exact Nat.add_le_add_left (cast_cost_le (min_eq_left h) _ op _
      (wide_cost_le h A op)) _
  · simp only [compile, compileBody, dif_neg h, Pi.add_apply, compileBudget, if_neg h]
    apply Nat.add_le_add_left
    apply cast_cost_le (min_eq_right (show n ≤ m by omega))
    simp [bind, pure, Run.bind, Run.pure, StoredRectangularGivens.identity_cost]

/-- Uniform cubic polynomial, including transpose/extraction and dispatch. -/
theorem compile_total_cost_le {m n : ℕ} (A : StoredMatrix m n) :
    StoredRectangularGivens.total (compile A).cost ≤
      n * m * (22 * m + 30 * n + 41) + 5 * n * n + 6 * m * m +
        8 * n + 9 * m + 2 := by
  have hf := compile_cost_le A .field
  have hs := compile_cost_le A .sqrt
  have ha := compile_cost_le A .angle
  have ht := compile_cost_le A .trig
  have hc := compile_cost_le A .compare
  have hr := compile_cost_le A .read
  have hw := compile_cost_le A .write
  have he := compile_cost_le A .emit
  by_cases h : m ≤ n
  · simp [compileBudget, h, wideBudget, extractionBudget,
      StoredRectangularGivens.polynomialBudget, tick] at hf hs ha ht hc hr hw he
    simp only [StoredRectangularGivens.total]
    nlinarith
  · simp [compileBudget, h, StoredRectangularGivens.identityBudget, tick] at hf hs ha ht hc hr hw he
    simp only [StoredRectangularGivens.total]
    calc
      _ ≤ 5 * n * n + 4 * n + 1 := by nlinarith
      _ ≤ _ := by omega

end QuantumBlockEncoding.StoredThinLQ
