import QuantumBlockEncoding.StoredGivens

/-! dyadic integer-span cache. The producer starts at one and
reads/doubles the stored last span at each extension; it does not evaluate
Nat.pow or an all-entry power callback. Integer doubling has its own counter
and is never counted as a real field operation. Persistent extension copies
all previous values and charges comparison, reads and materialization writes.

Integer operations assume a word large enough for the proved n+1-bit range.
This is not a finite-bit runtime bound. Finite loop indexing, chronological
index subtraction, local control, proof and cost bookkeeping are outside the
selected operation counters, consistently with the surrounding draft model.
-/
namespace QuantumBlockEncoding.StoredDyadicSpans
open StoredGivens
open scoped BigOperators

structure SpanRun (α : Type) where
  run : Run α
  integerDoublings : ℕ

/-- Complete persistent copy, including the appended last value. -/
def append {m : ℕ} (xs : Vector ℕ (m + 1)) (last : ℕ) : Run (Vector ℕ (m + 2)) :=
  collect fun i =>
    let result := if h : i.val < m + 1 then read xs ⟨i.val, h⟩ else pure last
    ⟨result.value, tick .compare + result.cost⟩

theorem append_value {m : ℕ} (xs : Vector ℕ (m + 1)) (last : ℕ) (i : Fin (m + 2)) :
    (append xs last).value[i.val] = if h : i.val < m + 1 then xs[i.val] else last := by
  simp only [append, collect_value]
  split <;> rfl

theorem append_cost {m : ℕ} (xs : Vector ℕ (m + 1)) (last : ℕ) (op : Op) :
    (append xs last).cost op =
      (m + 2) * tick .compare op + (3 * m + 5) * tick .read op +
        (2 * m + 4) * tick .write op := by
  have copied : (∑ i : Fin (m + 2), if i.val < m + 1 then tick .read op else 0) =
      (m + 1) * tick .read op := by
    rw [Fin.sum_univ_castSucc]
    simp only [Fin.val_castSucc, Fin.val_last, Fin.isLt, if_true,
      lt_self_iff_false, if_false, add_zero, Finset.sum_const,
      Finset.card_univ, Fintype.card_fin, smul_eq_mul]
  have entry (i : Fin (m + 2)) :
      (let result := if h : i.val < m + 1 then read xs ⟨i.val, h⟩ else pure last
       (⟨result.value, tick .compare + result.cost⟩ : Run ℕ)).cost op =
      tick .compare op + if i.val < m + 1 then tick .read op else 0 := by
    by_cases h : i.val < m + 1 <;>
      simp [h, StoredGivens.read, charge, pure, Run.pure]
  unfold append
  rw [collect_cost]
  rw [Finset.sum_congr rfl (fun i (_ : i ∈ Finset.univ) => entry i)]
  rw [Finset.sum_add_distrib, copied]
  simp
  ring

def spans : (n : ℕ) → SpanRun (Vector ℕ (n + 1))
  | 0 => ⟨collect (fun _ => pure 1), 0⟩
  | n + 1 =>
      let previous := spans n
      let result : Run (Vector ℕ (n + 2)) := do
        let last ← read previous.run.value (Fin.last n)
        append previous.run.value (last * 2)
      ⟨⟨result.value, previous.run.cost + result.cost⟩,
        previous.integerDoublings + 1⟩

theorem spans_value (n : ℕ) (r : Fin (n + 1)) :
    (spans n).run.value[r.val] = 2^r.val := by
  induction n with
  | zero =>
      have hr : r = 0 := Fin.eq_zero r
      subst r
      simp [spans, collect, pure, Run.pure]
  | succ n ih =>
      simp only [spans, bind, Run.bind, StoredGivens.read, charge, append_value]
      split_ifs with h
      · exact ih ⟨r.val, h⟩
      · have hr : r.val = n + 1 := by omega
        have hl := ih (Fin.last n)
        simp only [Fin.val_last] at hl
        simp [hr, hl, pow_succ]

/-- Exact table equality is a specification, not the data producer. -/
theorem spans_vector_value (n : ℕ) :
    (spans n).run.value = Vector.ofFn (fun r : Fin (n + 1) => 2^r.val) := by
  ext i hi
  simpa using spans_value n ⟨i, hi⟩

theorem spans_integerDoublings (n : ℕ) : (spans n).integerDoublings = n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [spans, ih]

private theorem total_add (a b : Cost) :
    (∑ op : Op, (a + b) op) = (∑ op : Op, a op) + ∑ op : Op, b op := by
  simp only [Pi.add_apply, Finset.sum_add_distrib]

private theorem total_tick (op : Op) : (∑ q : Op, tick op q) = 1 := by simp [tick]

theorem append_total_cost {m : ℕ} (xs : Vector ℕ (m + 1)) (last : ℕ) :
    (∑ op : Op, (append xs last).cost op) = 6 * m + 11 := by
  simp only [append_cost, Finset.sum_add_distrib, ← Finset.mul_sum, total_tick]
  ring

/-- Ordinary work is exactly quadratic; the n integer doublings are separate. -/
theorem spans_total_cost (n : ℕ) :
    (∑ op : Op, (spans n).run.cost op) = 3 * n^2 + 9 * n + 4 := by
  induction n with
  | zero =>
      simp only [spans, collect_cost, pure, Run.pure, Pi.zero_apply]
      simp only [Finset.sum_const_zero, zero_add, Nat.one_mul, Finset.sum_add_distrib,
        ← Finset.mul_sum, total_tick]
      norm_num
  | succ n ih =>
      simp only [spans, bind, Run.bind, total_add, append_total_cost]
      simp only [StoredGivens.read, charge, total_tick, Fin.val_last, ih]
      ring

theorem spans_cost_le (n : ℕ) (op : Op) :
    (spans n).run.cost op ≤ 3 * n^2 + 9 * n + 4 := by
  rw [← spans_total_cost]
  exact Finset.single_le_sum (fun _ _ => Nat.zero_le _) (Finset.mem_univ op)

theorem spans_field_cost (n : ℕ) : (spans n).run.cost .field = 0 := by
  induction n with
  | zero => simp [spans, collect_cost, pure, Run.pure, tick]
  | succ n ih =>
      simp [spans, bind, Run.bind, StoredGivens.read, charge, append_cost, tick, ih]

/-- All stored spans fit an unsigned word of n+1 bits. -/
theorem spans_word_bound (n : ℕ) (r : Fin (n + 1)) :
    (spans n).run.value[r.val] ≤ 2^n ∧ (spans n).run.value[r.val] < 2^(n + 1) := by
  rw [spans_value]
  have hr : r.val ≤ n := by omega
  have hle : (2 : ℕ)^r.val ≤ 2^n := by
    gcongr
    norm_num
  have hp : 0 < (2 : ℕ)^n := pow_pos (by decide) _
  rw [pow_succ]
  omega

/-- This reads the existing ascending cache in chronological source order. -/
def atStage {n : ℕ} (xs : Vector ℕ (n + 1)) (t : Fin (n + 1)) : Run ℕ :=
  read xs ⟨n - t.val, by omega⟩

theorem atStage_value (n : ℕ) (t : Fin (n + 1)) :
    (atStage (spans n).run.value t).value = 2^(n - t.val) :=
  spans_value n ⟨n - t.val, by omega⟩

theorem atStage_cost {n : ℕ} (xs : Vector ℕ (n + 1)) (t : Fin (n + 1)) (op : Op) :
    (atStage xs t).cost op = tick .read op := rfl

theorem spans_certified (n : ℕ) :
    let result := spans n
    (∀ r : Fin (n + 1), result.run.value[r.val] = 2^r.val) ∧
    result.integerDoublings = n ∧
    (∑ op : Op, result.run.cost op) = 3 * n^2 + 9 * n + 4 ∧
    (∀ r : Fin (n + 1), result.run.value[r.val] ≤ 2^n ∧ result.run.value[r.val] < 2^(n + 1)) :=
  ⟨spans_value n, spans_integerDoublings n, spans_total_cost n, spans_word_bound n⟩

end QuantumBlockEncoding.StoredDyadicSpans
