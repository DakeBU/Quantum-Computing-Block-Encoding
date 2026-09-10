import QuantumBlockEncoding.HermiteBinaryCutoff
import QuantumBlockEncoding.StoredHermiteCoefficients

/-!
Cached Hermite tail supplier. Source width is N=n+1, fixed bond D=2*k+6.
Levels are stored by remaining width r (ascending), and consumed MSB-first as
r=n,...,0; this does not change the public little-endian convention.

All real work uses charged primitives. In particular no natural address or
power of two is cast to a real by the producer: dyadic widths are carried by
division and multiplication. Exact comparison, natural index/bit arithmetic,
proof and counter bookkeeping use the existing exact-real word model, not a
finite-bit implementation. Persistent vector extension copies every entry.
Small fixed-size records are stored words (references), as in StoredGivens.
This file closes cached free tails and guarded left injection, not the full
boundarySchedule geometry producer or the assembled raw source chain.
-/

namespace QuantumBlockEncoding.StoredHermiteGeometry

open StoredGivens StoredHermiteCoefficients HermiteBoundaryInjection
open scoped BigOperators

structure TailLevel where
  width : ℝ
  factor : ℝ

/-- Full-copy persistent extension; each copied record is a stored word. -/
def appendLevel {m : ℕ} (xs : Vector TailLevel (m + 1)) (last : TailLevel) :
    Run (Vector TailLevel (m + 2)) :=
  collect fun i =>
    let result := if h : i.val < m + 1 then read xs ⟨i.val, h⟩ else pure last
    ⟨result.value, tick .compare + result.cost⟩

theorem appendLevel_value {m : ℕ} (xs : Vector TailLevel (m + 1))
    (last : TailLevel) (i : Fin (m + 2)) :
    (appendLevel xs last).value[i.val] =
      if h : i.val < m + 1 then xs[i.val] else last := by
  simp only [appendLevel, collect_value]
  split <;> rfl

/-- Repeated charged division, never an uncharged cast of 2^n. -/
noncomputable def halve : ℕ → ℝ → Run ℝ
  | 0, x => pure x
  | n + 1, x => do
      let y ← halve n x
      StoredGivens.div y 2

theorem halve_value (n : ℕ) (x : ℝ) :
    (halve n x).value = x / (2 : ℝ)^n := by
  induction n with
  | zero => simp [halve, pure, Run.pure]
  | succ n ih =>
      simp [halve, bind, Run.bind, StoredGivens.div, charge, ih, pow_succ, div_div]

theorem halve_cost (n : ℕ) (x : ℝ) (op : Op) :
    (halve n x).cost op = n * tick .field op := by
  induction n with
  | zero => simp [halve, pure, Run.pure]
  | succ n ih =>
      simp [halve, bind, Run.bind, StoredGivens.div, charge, ih]
      ring

noncomputable def step (n : ℕ) (L : ℝ) : Run ℝ := do
  let width ← StoredGivens.mul Real.pi L
  halve n width

theorem step_value (n : ℕ) (L : ℝ) : (step n L).value = gridStep n L := by
  simp only [step, bind, Run.bind, StoredGivens.mul, charge, halve_value,
    gridStep, gridSize, pow_succ]
  field_simp
  push_cast
  ring

theorem step_cost (n : ℕ) (L : ℝ) (op : Op) :
    (step n L).cost op = (n + 1) * tick .field op := by
  simp [step, bind, Run.bind, StoredGivens.mul, charge, halve_cost]
  ring

/-- Public root-width identity for geometry integration. -/
theorem root_width (n : ℕ) (L : ℝ) :
    gridStep n L * (2 : ℝ)^n = Real.pi * L := by
  rw [← step_value]
  simp only [step, bind, Run.bind, StoredGivens.mul, charge, halve_value]
  exact div_mul_cancel₀ _ (pow_ne_zero _ (by norm_num))

/-- One exponential is evaluated and stored per level. The same factor is
shared by the left zero-bit and right one-bit transitions. -/
noncomputable def tails (grid : ℝ) : (n : ℕ) → SourceRun (Vector TailLevel (n + 1))
  | 0 =>
      let result : Run (Vector TailLevel 1) := do
        let negative ← StoredGivens.sub 0 grid
        let factor ← (exponential negative).run
        collect fun _ => pure (⟨grid, factor⟩ : TailLevel)
      ⟨result, 1⟩
  | n + 1 =>
      let previous := tails grid n
      let result : Run (Vector TailLevel (n + 2)) := do
        let last ← read previous.run.value (Fin.last n)
        let width ← StoredGivens.mul last.width 2
        let negative ← StoredGivens.sub 0 width
        let factor ← (exponential negative).run
        appendLevel previous.run.value ⟨width, factor⟩
      ⟨⟨result.value, previous.run.cost + result.cost⟩,
        previous.exponentialCalls + 1⟩

theorem tails_value (grid : ℝ) (n : ℕ) (r : Fin (n + 1)) :
    ((tails grid n).run.value[r.val]).width = grid * (2 : ℝ)^r.val ∧
    ((tails grid n).run.value[r.val]).factor = Real.exp (-grid * (2 : ℝ)^r.val) := by
  induction n with
  | zero =>
      have hr : r = 0 := Fin.eq_zero r
      subst r
      simp [tails, bind, pure, Run.bind, Run.pure, StoredGivens.sub,
        charge, exponential, collect]
  | succ n ih =>
      simp only [tails, bind, Run.bind, StoredGivens.read, StoredGivens.mul,
        StoredGivens.sub, charge, exponential, appendLevel_value]
      split_ifs with h
      · exact ih ⟨r.val, h⟩
      · have hr : r.val = n + 1 := by omega
        have hw := (ih (Fin.last n)).1
        simp only [Fin.val_last] at hw
        simp [hr, Fin.val_last, hw, pow_succ, mul_assoc]

theorem tails_exponentialCalls (grid : ℝ) (n : ℕ) :
    (tails grid n).exponentialCalls = n + 1 := by
  induction n with
  | zero => rfl
  | succ n ih => simp [tails, ih]

private theorem tick_le_one (a b : Op) : tick a b ≤ 1 := by
  unfold tick
  split <;> omega

theorem appendLevel_cost_le {m : ℕ} (xs : Vector TailLevel (m + 1))
    (last : TailLevel) (op : Op) :
    (appendLevel xs last).cost op ≤ 6 * (m + 2) := by
  unfold appendLevel
  rw [collect_cost]
  have entry : ∀ i : Fin (m + 2),
      (let result := if h : i.val < m + 1 then read xs ⟨i.val, h⟩ else pure last
       (⟨result.value, tick .compare + result.cost⟩ : Run TailLevel)).cost op ≤ 2 := by
    intro i
    have hc := tick_le_one .compare op
    have hr := tick_le_one .read op
    by_cases h : i.val < m + 1 <;>
      simp [h, StoredGivens.read, charge, pure, Run.pure, Pi.add_apply] <;> omega
  have hs := Finset.sum_le_sum (fun i (_ : i ∈ Finset.univ) => entry i)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul] at hs
  have hr := tick_le_one .read op
  have hw := tick_le_one .write op
  nlinarith

theorem tails_cost_le (grid : ℝ) (n : ℕ) (op : Op) :
    (tails grid n).run.cost op ≤ 12 * (n + 1)^2 := by
  induction n with
  | zero =>
      have hf := tick_le_one .field op
      have hr := tick_le_one .read op
      have hw := tick_le_one .write op
      simp [tails, bind, pure, Run.bind, Run.pure, StoredGivens.sub,
        charge, exponential, collect_cost]
      omega
  | succ n ih =>
      have hx := appendLevel_cost_le (tails grid n).run.value
        ⟨((tails grid n).run.value[n]).width * 2,
          Real.exp (0 - ((tails grid n).run.value[n]).width * 2)⟩ op
      have hf := tick_le_one .field op
      have hr := tick_le_one .read op
      simp only [tails, bind, Run.bind, StoredGivens.read, StoredGivens.mul,
        StoredGivens.sub, charge, exponential, Pi.add_apply, zero_add]
      nlinarith

structure TailCache (n : ℕ) where
  cutoff : ℕ
  grid : ℝ
  levels : Vector TailLevel (n + 1)

/-- The actual binary-search cutoff and actual width cache are supplied in
the same run. No precomputed cutoff or coordinate callback is an input. -/
noncomputable def tailCache (n : ℕ) (L : ℝ) : SourceRun (TailCache n) :=
  let cutoff := HermiteBinaryCutoff.compute n L
  let spacing := step n L
  let cached := tails spacing.value n
  ⟨⟨⟨cutoff.value, spacing.value, cached.run.value⟩,
    cutoff.cost + spacing.cost + cached.run.cost⟩, cached.exponentialCalls⟩

theorem tailCache_value (n : ℕ) (L : ℝ) (hL : 0 < L) :
    (tailCache n L).run.value.cutoff = cutIndex n L ∧
    (tailCache n L).run.value.grid = gridStep n L ∧
    ∀ r : Fin (n + 1),
      ((tailCache n L).run.value.levels[r.val]).width = gridStep n L * (2 : ℝ)^r.val ∧
      ((tailCache n L).run.value.levels[r.val]).factor =
        Real.exp (-gridStep n L * (2 : ℝ)^r.val) := by
  refine ⟨HermiteBinaryCutoff.compute_value n L hL, step_value n L, ?_⟩
  intro r
  simpa only [tailCache, step_value] using tails_value (step n L).value n r

theorem tailCache_exponentialCalls (n : ℕ) (L : ℝ) :
    (tailCache n L).exponentialCalls = n + 1 := tails_exponentialCalls _ _

theorem tailCache_cost_le (n : ℕ) (L : ℝ) (op : Op) :
    (tailCache n L).run.cost op ≤ 16 * (n + 1)^2 := by
  have ht := tails_cost_le (step n L).value n op
  have hf := tick_le_one .field op
  have hc := tick_le_one .compare op
  simp only [tailCache, Pi.add_apply, HermiteBinaryCutoff.compute_cost, step_cost]
  nlinarith

theorem tailCache_total_cost_le (n : ℕ) (L : ℝ) :
    (∑ op : Op, (tailCache n L).run.cost op) ≤ 128 * (n + 1)^2 := by
  have h := Finset.sum_le_sum
    (fun op (_ : op ∈ Finset.univ) => tailCache_cost_le n L op)
  have hc : Fintype.card Op = 8 := by decide
  calc
    _ ≤ 8 * (16 * (n + 1)^2) := by simpa [hc] using h
    _ = _ := by ring

/-- The cache is physically indexed by r, but consumers use chronological
source stage t=0,...,n and access r=n-t with a charged stored-word read. -/
def atStage {n : ℕ} (cache : TailCache n) (t : Fin (n + 1)) : Run TailLevel :=
  read cache.levels ⟨n - t.val, by omega⟩

theorem atStage_value (n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n + 1)) :
    (atStage (tailCache n L).run.value t).value.width =
      gridStep n L * (2 : ℝ)^(n - t.val) ∧
    (atStage (tailCache n L).run.value t).value.factor =
      Real.exp (-gridStep n L * (2 : ℝ)^(n - t.val)) :=
  (tailCache_value n L hL).2.2 ⟨n - t.val, by omega⟩

theorem atStage_cost {n : ℕ} (cache : TailCache n) (t : Fin (n + 1)) (op : Op) :
    (atStage cache t).cost op = tick .read op := rfl

theorem atStage_leftFree (n : ℕ) (L : ℝ) (hL : 0 < L)
    (t : Fin (n + 1)) (bit : Bool) :
    (if bit then 1 else (atStage (tailCache n L).run.value t).value.factor) =
      leftFree (gridStep n L) (n - t.val) bit := by
  rw [(atStage_value n L hL t).2]
  rfl

theorem atStage_rightFree (n : ℕ) (L : ℝ) (hL : 0 < L)
    (t : Fin (n + 1)) (bit : Bool) :
    (if bit then (atStage (tailCache n L).run.value t).value.factor else 1) =
      rightFree (gridStep n L) (n - t.val) bit := by
  rw [(atStage_value n L hL t).2]
  rfl

theorem atStage_rightCore (n : ℕ) (L : ℝ) (hL : 0 < L)
    (t : Fin (n + 1)) (bit : Bool) :
    (if t.val = 0 then (if bit then 1 else 0) else
      (if bit then (atStage (tailCache n L).run.value t).value.factor else 1)) =
      rightCore n (gridStep n L) (n - t.val) bit := by
  have ht : n - t.val = n ↔ t.val = 0 := by have := t.isLt; omega
  simp only [rightCore, ht, ← atStage_rightFree n L hL t bit]

theorem atStage_bounds (n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n + 1)) :
    0 ≤ (atStage (tailCache n L).run.value t).value.factor ∧
      (atStage (tailCache n L).run.value t).value.factor ≤ 1 := by
  rw [(atStage_value n L hL t).2]
  exact leftFree_bounds _ (gridStep_pos n L hL).le _ false

/-- A disabled injection performs no scalar arithmetic and no exponential.
An enabled injection uses the cached child's excluded endpoint minus one
grid step. The enabling Full guard is supplied by the geometry cache. -/
noncomputable def leftInjection (enabled : Bool) (lower width grid : ℝ) : SourceRun ℝ :=
  if enabled then
    let result : Run ℝ := do
      let upper ← StoredGivens.add lower width
      let last ← StoredGivens.sub upper grid
      (exponential last).run
    ⟨⟨result.value, tick .compare + result.cost⟩, 1⟩
  else ⟨⟨0, tick .compare⟩, 0⟩

theorem leftInjection_value (enabled : Bool) (origin grid lower width : ℝ)
    (first r : ℕ) (hl : lower = affinePoint origin grid first)
    (hw : width = grid * (2 : ℝ)^r) :
    (leftInjection enabled lower width grid).run.value =
      if enabled then leftInject origin grid first r else 0 := by
  cases enabled
  · rfl
  · simp only [leftInjection, if_true, bind, Run.bind, StoredGivens.add,
      StoredGivens.sub, charge, exponential, leftInject, hl, hw]
    congr 1
    ring

theorem leftInjection_lastPoint (origin grid lower width : ℝ)
    (first r : ℕ) (hl : lower = affinePoint origin grid first)
    (hw : width = grid * (2 : ℝ)^r) :
    (leftInjection true lower width grid).run.value =
      Real.exp (affinePoint origin grid (first + 2^r - 1)) := by
  rw [leftInjection_value true origin grid lower width first r hl hw]
  exact leftInject_eq_last origin grid first r

theorem leftInjection_exponentialCalls (enabled : Bool) (lower width grid : ℝ) :
    (leftInjection enabled lower width grid).exponentialCalls = if enabled then 1 else 0 := by
  cases enabled <;> rfl

theorem leftInjection_cost (enabled : Bool) (lower width grid : ℝ) (op : Op) :
    (leftInjection enabled lower width grid).run.cost op = tick .compare op +
      (if enabled then 2 * tick .field op else 0) := by
  cases enabled <;>
    simp [leftInjection, bind, Run.bind, StoredGivens.add, StoredGivens.sub,
      charge, exponential]
  ring

theorem leftInjection_bounds (n : ℕ) (L : ℝ) (hL : 0 < L)
    (enabled : Bool) (lower width : ℝ) (first r : ℕ)
    (hl : lower = affinePoint (-Real.pi * L) (gridStep n L) first)
    (hw : width = gridStep n L * (2 : ℝ)^r)
    (guard : enabled = true → Full 0 (cutIndex n L) first (2^r)) :
    0 ≤ (leftInjection enabled lower width (gridStep n L)).run.value ∧
      (leftInjection enabled lower width (gridStep n L)).run.value ≤ 1 := by
  rw [leftInjection_value enabled (-Real.pi * L) (gridStep n L) lower width first r hl hw]
  cases enabled
  · norm_num
  · exact leftInject_bounds n L hL first r (guard rfl)


end QuantumBlockEncoding.StoredHermiteGeometry
