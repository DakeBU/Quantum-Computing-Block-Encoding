import QuantumBlockEncoding.StoredGivens
import QuantumBlockEncoding.RectangularGivens

/-!
# Costed stored rectangular elimination and accumulated transform

The producer refines `RectangularGivens` on all rectangular dimensions. Its
matrix and log are obtained by one fused sweep. Persistent list append pays
for every copied prefix record. The transform is then accumulated from a
materialized identity by replaying the recorded two-row operations, never
by evaluating the dense matrix-product specification. All bounds use the
extended exact-real model of `StoredGivens`; they are not bit complexity.
-/

namespace QuantumBlockEncoding.StoredRectangularGivens

open StoredGivens AdjacentGivens

/-- Copy the left list spine, sharing the right list. Cost-counter traversal
is bookkeeping; the data append's reads and writes are charged here. -/
def append (xs ys : List α) : Run (List α) :=
  ⟨xs ++ ys, xs.length • (tick .read + tick .write)⟩

noncomputable def sweep {N M : ℕ} (A : StoredMatrix N M)
    (k : ℕ) : (remaining : ℕ) → k + remaining ≤ M → Run (Sweep N M)
  | 0, _ => pure ⟨A, []⟩
  | remaining + 1, columns =>
      let result := if h : k < N then do
        let first ← StoredGivens.columnSweep A ⟨k, by omega⟩ k (N - 1 - k) (by omega)
        let rest ← sweep first.matrix (k + 1) remaining (by omega)
        let steps ← append first.steps rest.steps
        pure ⟨rest.matrix, steps⟩
      else sweep A (k + 1) remaining (by omega)
      ⟨result.value, tick .compare + result.cost⟩

theorem sweep_matrix {N M : ℕ} (A : StoredMatrix N M)
    (k remaining : ℕ) (columns : k + remaining ≤ M) :
    denote (sweep A k remaining columns).value.matrix =
      RectangularGivens.sweep (denote A) k remaining columns := by
  induction remaining generalizing A k with
  | zero => rfl
  | succ remaining ih =>
    by_cases h : k < N
    · simp only [sweep, RectangularGivens.sweep, dif_pos h,
        bind, pure, Run.bind, Run.pure, append]
      rw [ih, StoredGivens.columnSweep_matrix]
    · simp only [sweep, RectangularGivens.sweep, dif_neg h]
      exact ih A (k + 1) _

theorem sweep_steps {N M : ℕ} (A : StoredMatrix N M)
    (k remaining : ℕ) (columns : k + remaining ≤ M) :
    (sweep A k remaining columns).value.steps =
      RectangularGivens.sweepSteps (denote A) k remaining columns := by
  induction remaining generalizing A k with
  | zero => rfl
  | succ remaining ih =>
    by_cases h : k < N
    · simp only [sweep, RectangularGivens.sweepSteps, dif_pos h,
        bind, pure, Run.bind, Run.pure, append]
      rw [ih, StoredGivens.columnSweep_matrix, StoredGivens.columnSweep_steps]
    · simp only [sweep, RectangularGivens.sweepSteps, dif_neg h]
      exact ih A (k + 1) _

def columnBudget (N M : ℕ) : Cost := fun op =>
  N * stepBudget N M op + N * (tick .read op + tick .write op) + tick .compare op

theorem sweep_cost_le {N M : ℕ} (A : StoredMatrix N M)
    (k remaining : ℕ) (columns : k + remaining ≤ M) (op : Op) :
    (sweep A k remaining columns).cost op ≤ remaining * columnBudget N M op := by
  induction remaining generalizing A k with
  | zero => simp [sweep, pure, Run.pure]
  | succ remaining ih =>
    by_cases h : k < N
    · simp only [sweep, dif_pos h, bind, pure, Run.bind, Run.pure, append,
        Pi.add_apply, add_zero, Pi.smul_apply, smul_eq_mul,
        StoredGivens.columnSweep_steps_length]
      have first := StoredGivens.columnSweep_cost_le A ⟨k, by omega⟩ k
        (N - 1 - k) (by omega) op
      have rest := ih (StoredGivens.columnSweep A ⟨k, by omega⟩ k
        (N - 1 - k) (by omega)).value.matrix (k + 1) (by omega)
      have small : N - 1 - k ≤ N := by omega
      have fieldBound := Nat.mul_le_mul_right (stepBudget N M op) small
      have copyBound := Nat.mul_le_mul_right (tick .read op + tick .write op) small
      simp only [columnBudget] at *
      nlinarith
    · simp only [sweep, dif_neg h, Pi.add_apply]
      have rest := ih A (k + 1) (by omega)
      simp only [columnBudget] at *
      nlinarith

/-- Materialized identity, including its finite-index equality decisions. -/
def identity (N : ℕ) : Run (StoredMatrix N N) :=
  materialize (fun i j => charge .compare (if i = j then 1 else 0))

theorem identity_value (N : ℕ) : denote (identity N).value = 1 := by
  ext i j
  simp [identity, materialize, denote, _root_.Matrix.one_apply]
  rfl

def identityBudget (N : ℕ) : Cost := fun op =>
  N * N * tick .compare op + (N * N + N) * (2 * tick .read op + 2 * tick .write op)

theorem identity_cost (N : ℕ) (op : Op) :
    (identity N).cost op = identityBudget N op := by
  simp [identity, materialize_cost, charge, identityBudget]
  ring

/-- Replay uses only a pair of stored row updates. Reading the end marker is
charged in the empty case; each cons record is charged in the nonempty case. -/
noncomputable def replay {N M : ℕ} : List (Step N) → StoredMatrix N M → Run (StoredMatrix N M)
  | [], A => charge .read A
  | step :: rest, A => do
      let current ← charge .read step
      let half ← StoredGivens.div current.angle 2
      let c ← StoredGivens.cos half
      let s ← StoredGivens.sin half
      let B ← rotate A current.first current.second c s
      replay rest B

theorem replay_value {N M : ℕ} (steps : List (Step N)) (A : StoredMatrix N M) :
    denote (replay steps A).value = applySteps steps (denote A) := by
  induction steps generalizing A with
  | nil => rfl
  | cons step rest ih =>
    simp only [replay, bind, Run.bind, charge, StoredGivens.div,
      StoredGivens.cos, StoredGivens.sin]
    rw [ih, rotate_value]
    simp only [applySteps, Step.matrix, planeMatrix_mul]

def replayStepBudget (N M : ℕ) : Cost := fun op =>
  tick .field op + 2 * tick .trig op +
    M * (6 * tick .field op + 10 * tick .read op + 6 * tick .write op) +
    2 * N * (tick .read op + tick .write op) + 3 * tick .read op

theorem replay_cost {N M : ℕ} (steps : List (Step N)) (A : StoredMatrix N M) (op : Op) :
    (replay steps A).cost op = steps.length * replayStepBudget N M op + tick .read op := by
  induction steps generalizing A with
  | nil => simp [replay, charge]
  | cons step rest ih =>
    simp only [replay, bind, Run.bind, charge, StoredGivens.div,
      StoredGivens.cos, StoredGivens.sin, Pi.add_apply, rotate_cost, ih,
      List.length_cons, replayStepBudget]
    ring

structure Result (N M : ℕ) where
  reduced : StoredMatrix N M
  transform : StoredMatrix N N
  steps : List (Step N)

noncomputable def compile {N M : ℕ} (A : StoredMatrix N M) : Run (Result N M) := do
  let result ← sweep A 0 M (by omega)
  let initial ← identity N
  let E ← replay result.steps initial
  pure ⟨result.matrix, E, result.steps⟩

theorem compile_reduced {N M : ℕ} (A : StoredMatrix N M) :
    denote (compile A).value.reduced = RectangularGivens.reduced (denote A) := by
  simp only [compile, bind, pure, Run.bind, Run.pure, sweep_matrix]
  rfl

theorem compile_steps {N M : ℕ} (A : StoredMatrix N M) :
    (compile A).value.steps = RectangularGivens.decompose (denote A) := by
  simp only [compile, bind, pure, Run.bind, Run.pure, sweep_steps]
  rfl

theorem compile_transform {N M : ℕ} (A : StoredMatrix N M) :
    denote (compile A).value.transform = RectangularGivens.transform (denote A) := by
  simp only [compile, bind, pure, Run.bind, Run.pure, replay_value, identity_value,
    applySteps_eq_matrix_mul, _root_.Matrix.mul_one, sweep_steps]
  rfl

def compileBudget (N M : ℕ) : Cost := fun op =>
  M * columnBudget N M op + identityBudget N op +
    (N * M) * replayStepBudget N N op + tick .read op

/-- A componentwise polynomial operation bound for residual, log, and the
fully stored accumulated transform produced by this actual algorithm. -/
theorem compile_cost_le {N M : ℕ} (A : StoredMatrix N M) (op : Op) :
    (compile A).cost op ≤ compileBudget N M op := by
  simp only [compile, bind, pure, Run.bind, Run.pure, Pi.add_apply,
    add_zero, identity_cost, replay_cost]
  have swept := sweep_cost_le A 0 M (by omega) op
  have length := RectangularGivens.decompose_length_le (denote A)
  have replayBound := Nat.mul_le_mul_right (replayStepBudget N N op) length
  rw [sweep_steps]
  simp only [RectangularGivens.decompose] at replayBound
  simp only [compileBudget]
  omega

theorem compile_exact_recovery {N M : ℕ} (A : StoredMatrix N M) :
    (denote (compile A).value.transform).transpose * denote (compile A).value.reduced =
      denote A := by
  rw [compile_transform, compile_reduced]
  exact RectangularGivens.exact_recovery _

theorem compile_transform_orthogonal {N M : ℕ} (A : StoredMatrix N M) :
    (denote (compile A).value.transform).transpose * denote (compile A).value.transform = 1 := by
  rw [compile_transform]
  exact RectangularGivens.transform_orthogonal _

theorem compile_transform_det {N M : ℕ} (A : StoredMatrix N M) :
    (denote (compile A).value.transform).det = 1 := by
  rw [compile_transform]
  exact RectangularGivens.transform_det _

theorem compile_zero_below {N M : ℕ} (A : StoredMatrix N M)
    (row : Fin N) (col : Fin M) (below : col.val < row.val) :
    denote (compile A).value.reduced row col = 0 := by
  rw [compile_reduced]
  exact RectangularGivens.reduced_zero_below _ _ _ below

/-- Expanded polynomial form of every operation category. -/
def polynomialBudget (N M : ℕ) : Cost
  | .field => N * M * (6 * M + 6 * N + 9)
  | .sqrt => N * M
  | .angle => N * M
  | .trig => 4 * N * M
  | .compare => 2 * N * M + M + N * N
  | .read => N * M * (10 * M + 14 * N + 10) + 2 * N * N + 2 * N + 1
  | .write => N * M * (6 * M + 10 * N + 1) + 2 * N * N + 2 * N
  | .emit => N * M

theorem compileBudget_eq (N M : ℕ) : compileBudget N M = polynomialBudget N M := by
  funext op
  cases op <;>
    simp [compileBudget, polynomialBudget, columnBudget, identityBudget,
      replayStepBudget, stepBudget, eliminationBudget, coefficientBudget, angleBudget, tick] <;>
    ring

theorem compile_polynomial_cost_le {N M : ℕ} (A : StoredMatrix N M) (op : Op) :
    (compile A).cost op ≤ polynomialBudget N M op := by
  rw [← compileBudget_eq]
  exact compile_cost_le A op

/-- Sum of the eight explicitly separated operation counters. -/
def total (cost : Cost) : ℕ :=
  cost .field + cost .sqrt + cost .angle + cost .trig +
    cost .compare + cost .read + cost .write + cost .emit

theorem compile_total_cost_le {N M : ℕ} (A : StoredMatrix N M) :
    total (compile A).cost ≤
      N * M * (22 * M + 30 * N + 29) + 5 * N * N + 4 * N + M + 1 := by
  have hf := compile_polynomial_cost_le A .field
  have hs := compile_polynomial_cost_le A .sqrt
  have ha := compile_polynomial_cost_le A .angle
  have ht := compile_polynomial_cost_le A .trig
  have hc := compile_polynomial_cost_le A .compare
  have hr := compile_polynomial_cost_le A .read
  have hw := compile_polynomial_cost_le A .write
  have he := compile_polynomial_cost_le A .emit
  simp only [polynomialBudget] at *
  simp only [total]
  nlinarith

end QuantumBlockEncoding.StoredRectangularGivens
