import QuantumBlockEncoding.HermiteBernstein
import QuantumBlockEncoding.StoredGivens
import QuantumBlockEncoding.StoredRectangularGivens

/-!
# Stored, costed Bernstein restriction

Each row is materialized before the next de Casteljau row is evaluated.
The deliberately simple edge extractor recomputes rows for each edge entry;
its cubic bound is still polynomial and counts these repetitions. This is
not a cost theorem for producing the source coefficients, cutoffs or exp.
The primitive model is the extended exact-real model of `StoredGivens`.
-/

namespace QuantumBlockEncoding.StoredBernstein

open StoredGivens HermiteBernstein
open scoped BigOperators

noncomputable def cell {n : ℕ} (xs : Vector ℝ n) (u t : ℝ) (i : Fin n) : Run ℝ := do
  let _ ← charge .compare ()
  if h : i.val + 1 < n then do
    let x ← StoredGivens.read xs i
    let y ← StoredGivens.read xs ⟨i.val + 1, h⟩
    let ux ← StoredGivens.mul u x
    let ty ← StoredGivens.mul t y
    add ux ty
  else pure 0

/-- Truncated row; the last entry is zero and is never read by a valid cone. -/
noncomputable def step {n : ℕ} (xs : Vector ℝ n) (t : ℝ) : Run (Vector ℝ n) := do
  let u ← sub 1 t
  collect (cell xs u t)

theorem step_value {n : ℕ} (xs : Vector ℝ n) (t : ℝ)
    (i : Fin n) (hi : i.val + 1 < n) :
    (step xs t).value[i.val] =
      (1 - t) * xs[i.val] + t * xs[i.val + 1] := by
  simp [step, cell, bind, Run.bind, sub, StoredGivens.mul, add, StoredGivens.read, charge, hi]

/-- Every scalar entry of the previous row is cached, not a nested callback. -/
noncomputable def rows {n : ℕ} (xs : Vector ℝ n) (t : ℝ) : ℕ → Run (Vector ℝ n)
  | 0 => pure xs
  | k + 1 => do
      let previous ← rows xs t k
      step previous t

theorem casteljau_succ (k : ℕ) (c : ℕ → ℝ) (t : ℝ) (i : ℕ) :
    casteljau (k + 1) c t i =
      (1 - t) * casteljau k c t i + t * casteljau k c t (i + 1) := by
  simp only [casteljau, pow_succ', Module.End.mul_apply, casteljauStep_apply]

theorem rows_value {n : ℕ} (xs : Vector ℝ n) (c : ℕ → ℝ)
    (hx : ∀ i : Fin n, xs[i.val] = c i.val) (t : ℝ) (k : ℕ)
    (i : Fin n) (hi : i.val + k < n) :
    (rows xs t k).value[i.val] = casteljau k c t i.val := by
  induction k generalizing i with
  | zero => simpa [rows, pure, Run.pure, casteljau] using hx i
  | succ k ih =>
    simp only [rows, bind, Run.bind]
    rw [step_value _ _ i (by omega), casteljau_succ,
      ih i (by omega), ih ⟨i.val + 1, by omega⟩ (by change i.val + 1 + k < n; omega)]

def rowBudget (n : ℕ) : Cost := fun op =>
  tick .field op + n * (3 * tick .field op + tick .compare op +
    4 * tick .read op + 2 * tick .write op)

theorem step_cost_le {n : ℕ} (xs : Vector ℝ n) (t : ℝ) (op : Op) :
    (step xs t).cost op ≤ rowBudget n op := by
  simp only [step, bind, Run.bind, sub, charge, Pi.add_apply, collect_cost]
  have terms : (∑ i : Fin n, (cell xs (1 - t) t i).cost op) ≤
      n * (3 * tick .field op + tick .compare op + 2 * tick .read op) := by
    calc
      _ ≤ ∑ _i : Fin n, (3 * tick .field op + tick .compare op + 2 * tick .read op) := by
        apply Finset.sum_le_sum
        intro i _
        simp only [cell, bind, Run.bind, charge]
        split_ifs <;> simp [StoredGivens.read, StoredGivens.mul, add, charge,
          pure, Run.pure] <;> omega
      _ = _ := by simp
  simp only [rowBudget]
  nlinarith

theorem rows_cost_le {n : ℕ} (xs : Vector ℝ n) (t : ℝ) (k : ℕ) (op : Op) :
    (rows xs t k).cost op ≤ k * rowBudget n op := by
  induction k with
  | zero => simp [rows, pure, Run.pure]
  | succ k ih =>
    simp only [rows, bind, Run.bind, Pi.add_apply]
    have hs := step_cost_le (rows xs t k).value t op
    nlinarith

noncomputable def left {d : ℕ} (xs : Vector ℝ (d + 1)) (u : ℝ) :
    Run (Vector ℝ (d + 1)) :=
  collect fun i => do
    let row ← rows xs u i.val
    read row ⟨0, by omega⟩

noncomputable def right {d : ℕ} (xs : Vector ℝ (d + 1)) (u : ℝ) :
    Run (Vector ℝ (d + 1)) :=
  collect fun i => do
    let row ← rows xs u (d - i.val)
    read row i

theorem left_value {d : ℕ} (xs : Vector ℝ (d + 1)) (c : ℕ → ℝ)
    (hx : ∀ i : Fin (d + 1), xs[i.val] = c i.val) (u : ℝ) (i : Fin (d + 1)) :
    (left xs u).value[i.val] = leftRestriction u c i.val := by
  simp only [left, collect_value, bind, Run.bind, StoredGivens.read, charge]
  exact rows_value xs c hx u i.val ⟨0, by omega⟩ (by change 0 + i.val < d + 1; omega)

theorem right_value {d : ℕ} (xs : Vector ℝ (d + 1)) (c : ℕ → ℝ)
    (hx : ∀ i : Fin (d + 1), xs[i.val] = c i.val) (u : ℝ) (i : Fin (d + 1)) :
    (right xs u).value[i.val] = rightRestriction d u c i.val := by
  simp only [right, collect_value, bind, Run.bind, StoredGivens.read, charge]
  rw [rightRestriction_eq_casteljau d i.val (by omega)]
  exact rows_value xs c hx u (d - i.val) i (by omega)

def edgeBudget (d : ℕ) : Cost := fun op =>
  (d + 1) * (d * rowBudget (d + 1) op + 3 * tick .read op + 2 * tick .write op)

theorem left_cost_le {d : ℕ} (xs : Vector ℝ (d + 1)) (u : ℝ) (op : Op) :
    (left xs u).cost op ≤ edgeBudget d op := by
  simp only [left, collect_cost, bind, Run.bind, StoredGivens.read, charge, Pi.add_apply]
  have hs : (∑ i : Fin (d + 1), ((rows xs u i.val).cost op + tick .read op)) ≤
      (d + 1) * (d * rowBudget (d + 1) op + tick .read op) := by
    calc
      _ ≤ ∑ _i : Fin (d + 1), (d * rowBudget (d + 1) op + tick .read op) := by
        apply Finset.sum_le_sum
        intro i _
        have hr := rows_cost_le xs u i.val op
        have hl := Nat.mul_le_mul_right (rowBudget (d + 1) op) (show i.val ≤ d by omega)
        omega
      _ = _ := by simp
  simp only [edgeBudget]
  nlinarith

theorem right_cost_le {d : ℕ} (xs : Vector ℝ (d + 1)) (u : ℝ) (op : Op) :
    (right xs u).cost op ≤ edgeBudget d op := by
  simp only [right, collect_cost, bind, Run.bind, StoredGivens.read, charge, Pi.add_apply]
  have hs : (∑ i : Fin (d + 1), ((rows xs u (d - i.val)).cost op + tick .read op)) ≤
      (d + 1) * (d * rowBudget (d + 1) op + tick .read op) := by
    calc
      _ ≤ ∑ _i : Fin (d + 1), (d * rowBudget (d + 1) op + tick .read op) := by
        apply Finset.sum_le_sum
        intro i _
        have hr := rows_cost_le xs u (d - i.val) op
        have hl := Nat.mul_le_mul_right (rowBudget (d + 1) op) (Nat.sub_le d i.val)
        omega
      _ = _ := by simp
  simp only [edgeBudget]
  nlinarith

/-- The actual two-edge producer, with three charged parameter operations. -/
noncomputable def restrict {d : ℕ} (xs : Vector ℝ (d + 1)) (u v : ℝ) :
    Run (Vector ℝ (d + 1)) := do
  let first ← right xs u
  let delta ← sub v u
  let complement ← sub 1 u
  let parameter ← div delta complement
  left first parameter

theorem restrict_value {d : ℕ} (xs : Vector ℝ (d + 1)) (c : ℕ → ℝ)
    (hx : ∀ i : Fin (d + 1), xs[i.val] = c i.val)
    (u v : ℝ) (i : Fin (d + 1)) :
    (restrict xs u v).value[i.val] = restrictCoefficients d u v c i.val := by
  simp only [restrict, bind, Run.bind, sub, div, charge]
  exact left_value (right xs u).value (rightRestriction d u c)
    (right_value xs c hx u) _ i

theorem restrict_cost_le {d : ℕ} (xs : Vector ℝ (d + 1)) (u v : ℝ) (op : Op) :
    (restrict xs u v).cost op ≤ 2 * edgeBudget d op + 3 * tick .field op := by
  simp only [restrict, bind, Run.bind, sub, div, charge, Pi.add_apply]
  have hr := right_cost_le xs u op
  have hl := left_cost_le (right xs u).value ((v - u) / (1 - u)) op
  omega

/-- All eight counted operation classes; source coefficient generation is separate. -/
theorem restrict_total_cost_le {d : ℕ} (xs : Vector ℝ (d + 1)) (u v : ℝ) :
    StoredRectangularGivens.total (restrict xs u v).cost ≤
      20 * d ^ 3 + 42 * d ^ 2 + 32 * d + 13 := by
  have hf := restrict_cost_le xs u v .field
  have hs := restrict_cost_le xs u v .sqrt
  have ha := restrict_cost_le xs u v .angle
  have ht := restrict_cost_le xs u v .trig
  have hc := restrict_cost_le xs u v .compare
  have hr := restrict_cost_le xs u v .read
  have hw := restrict_cost_le xs u v .write
  have he := restrict_cost_le xs u v .emit
  simp [edgeBudget, rowBudget, tick] at hf hs ha ht hc hr hw he
  simp only [StoredRectangularGivens.total]
  nlinarith

end QuantumBlockEncoding.StoredBernstein
