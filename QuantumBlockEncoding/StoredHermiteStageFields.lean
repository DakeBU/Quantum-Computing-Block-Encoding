import QuantumBlockEncoding.StoredHermiteSharedTables
import QuantumBlockEncoding.StoredHermiteChildGeometry
import QuantumBlockEncoding.StoredHermiteKernelTable

/-! stage-field supplier. Source coefficients, shared matrices,
one tail level, both child records, and grid spacing are previously stored
inputs. `load` explicitly charges every input record/reference/payload read.
Its `Loaded` result is a register-local tuple, not an additional heap cache.
The seven output Fields payloads are explicitly written. Each source call
uses the existing guarded left injection and stored middle-row restriction;
the tail factor is read, never recomputed. Exponentials remain separate.

Construction of the input caches, child integer additions, natural/finite
index arithmetic, local tuple projections and counter bookkeeping are outside
this supplier's counters. In particular this is not a finite-bit runtime or
an unconditional constructor of the entire Hermite source chain. -/

namespace QuantumBlockEncoding.StoredHermiteStageFields

open scoped BigOperators
open StoredGivens StoredHermiteCoefficients HermiteBoundaryInjection
open StoredHermiteKernelTable

structure Cache (k : ℕ) where
  source : Vector ℝ (2*k+1+1)
  shared : StoredHermiteSharedTables.Tables (2*k+1)
  tail : StoredHermiteGeometry.TailLevel
  children : Vector StoredHermiteChildGeometry.Child 2
  grid : ℝ

/-- Register-local results of the charged input reads. -/
structure Loaded (k : ℕ) where
  source : Vector ℝ (2*k+1+1)
  shared : StoredMatrix (2*k+1+1) (2*k+1+1)
  lower : ℝ
  upper : ℝ
  width : ℝ
  factor : ℝ
  grid : ℝ
  leftFull : Bool
  leftPartial : Bool
  middleFull : Bool
  middlePartial : Bool
  bit : Bool

def view {k : ℕ} (cache : Cache k) (bit : Fin 2) : Loaded k :=
  let b := decide (bit = 1)
  let child := cache.children[bit.val]
  ⟨cache.source, if b then cache.shared.trueTable else cache.shared.falseTable,
    child.lower, child.upper, cache.tail.width, cache.tail.factor, cache.grid,
    child.leftFull, child.leftPartial, child.middleFull, child.middlePartial, b⟩

def load {k : ℕ} (cache : Cache k) (bit : Fin 2) : Run (Loaded k) := do
  let b ← charge .compare (decide (bit = 1))
  let children ← charge .read cache.children
  let child ← read children bit
  let lower ← charge .read child.lower
  let upper ← charge .read child.upper
  let lf ← charge .read child.leftFull
  let lp ← charge .read child.leftPartial
  let mf ← charge .read child.middleFull
  let mp ← charge .read child.middlePartial
  let source ← charge .read cache.source
  let tables ← charge .read cache.shared
  let selected ← charge .compare (if b then tables.trueTable else tables.falseTable)
  let shared ← charge .read selected
  let tail ← charge .read cache.tail
  let width ← charge .read tail.width
  let factor ← charge .read tail.factor
  let grid ← charge .read cache.grid
  pure ⟨source, shared, lower, upper, width, factor, grid, lf, lp, mf, mp, b⟩

theorem load_value {k : ℕ} (cache : Cache k) (bit : Fin 2) :
    (load cache bit).value = view cache bit := rfl

theorem load_cost {k : ℕ} (cache : Cache k) (bit : Fin 2) (op : Op) :
    (load cache bit).cost op = 15 * tick .read op + 2 * tick .compare op := by
  simp [load, bind, pure, Run.bind, Run.pure, charge, StoredGivens.read]
  ring

/-- Four Boolean selections, including the n=0 first-stage right selector. -/
def selectTails (first bit : Bool) (factor : ℝ) : Run (ℝ × ℝ) := do
  let left ← charge .compare (if bit then 1 else factor)
  let rightFree ← charge .compare (if bit then factor else 1)
  let rightFirst ← charge .compare (if bit then 1 else 0)
  let right ← charge .compare (if first then rightFirst else rightFree)
  pure (left, right)

theorem selectTails_value (first bit : Bool) (factor : ℝ) :
    (selectTails first bit factor).value =
      (if bit then 1 else factor,
       if first then (if bit then 1 else 0) else (if bit then factor else 1)) := rfl

theorem selectTails_cost (first bit : Bool) (factor : ℝ) (op : Op) :
    (selectTails first bit factor).cost op = 4 * tick .compare op := by
  simp [selectTails, bind, pure, Run.bind, Run.pure, charge]
  ring

/-- Actual scalar suppliers followed by seven output payload writes. -/
noncomputable def fromLoaded {k : ℕ} (t : ℕ) (x : Loaded k) : SourceRun (Fields k) :=
  let first := charge .compare (decide (t = 0))
  let tails := selectTails first.value x.bit x.factor
  let left := StoredHermiteGeometry.leftInjection x.leftFull x.lower x.width x.grid
  let middle := StoredHermiteSharedTables.injectionRow x.source x.lower x.upper x.middleFull
  let output : Fields k := ⟨x.leftPartial, left.run.value, tails.value.1,
    x.middlePartial, middle.value, x.shared, tails.value.2⟩
  ⟨⟨output, first.cost + tails.cost + left.run.cost + middle.cost + 7 • tick .write⟩,
    left.exponentialCalls⟩

noncomputable def fieldsView {k : ℕ} (t : ℕ) (x : Loaded k) : Fields k :=
  ⟨x.leftPartial,
    (StoredHermiteGeometry.leftInjection x.leftFull x.lower x.width x.grid).run.value,
    if x.bit then 1 else x.factor,
    x.middlePartial,
    (StoredHermiteSharedTables.injectionRow x.source x.lower x.upper x.middleFull).value,
    x.shared,
    if t = 0 then (if x.bit then 1 else 0) else (if x.bit then x.factor else 1)⟩

theorem fromLoaded_value {k : ℕ} (t : ℕ) (x : Loaded k) :
    (fromLoaded t x).run.value = fieldsView t x := by
  simp only [fromLoaded, fieldsView, selectTails_value, charge, decide_eq_true_eq]

def addCost (cost : Cost) (x : SourceRun α) : SourceRun α :=
  ⟨StoredHermiteSharedTables.withCost cost x.run, x.exponentialCalls⟩

theorem addCost_value (cost : Cost) (x : SourceRun α) :
    (addCost cost x).run.value = x.run.value := rfl

theorem addCost_cost (cost : Cost) (x : SourceRun α) (op : Op) :
    (addCost cost x).run.cost op = cost op + x.run.cost op := rfl

noncomputable def one {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) :
    SourceRun (Fields k) :=
  let loaded := load cache bit
  addCost loaded.cost (fromLoaded t loaded.value)

theorem one_value {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) :
    (one cache t bit).run.value = fieldsView t (view cache bit) := by
  rw [one, addCost_value, load_value, fromLoaded_value]

/-- Cache conditions, not a SourceCorrect assumption. Child geometry is
independently supplied by children_refines; no child computation is repeated. -/
structure CacheCorrect {k : ℕ} (n t : ℕ) (L : ℝ) (cache : Cache k) : Prop where
  source : ∀ i : Fin (2*k+1+1),
    cache.source[i.val] = HermiteBernstein.sourceBernsteinCoefficient k i.val
  sharedFalse : denote cache.shared.falseTable = sharedCore (2*k+1) false
  sharedTrue : denote cache.shared.trueTable = sharedCore (2*k+1) true
  grid : cache.grid = gridStep n L
  width : cache.tail.width = gridStep n L * (2 : ℝ)^(n-t)
  factor : cache.tail.factor = Real.exp (-gridStep n L * (2 : ℝ)^(n-t))
  children : ∀ bit : Fin 2,
    StoredHermiteChildGeometry.Refines cache.children[bit.val] (cutIndex n L) n (n-t)
      (-Real.pi * L) (gridStep n L) (decide (bit = 1))

theorem one_source {k n : ℕ} (cache : Cache k) (t : Fin (n+1)) (L : ℝ)
    (h : CacheCorrect n t.val L cache) (bit : Fin 2) :
    SourceCorrect k n t.val L bit (one cache t.val bit).run.value := by
  rcases h.children bit with ⟨_hfirst, hlo, hup, hlf, hlp, hmf, hmp⟩
  rw [one_value]
  constructor
  · exact hlp
  · change (StoredHermiteGeometry.leftInjection cache.children[bit.val].leftFull
      cache.children[bit.val].lower cache.tail.width cache.grid).run.value = _
    rw [h.grid, StoredHermiteGeometry.leftInjection_value _ (-Real.pi * L) _ _ _
      _ (n-t.val) hlo h.width]
    simp only [hlf, decide_eq_true_eq]
  · change (if decide (bit = 1) then 1 else cache.tail.factor) = _
    rw [h.factor]
    rfl
  · exact hmp
  · intro j
    change (StoredHermiteSharedTables.injectionRow cache.source cache.children[bit.val].lower
      cache.children[bit.val].upper cache.children[bit.val].middleFull).value[j.val] = _
    exact StoredHermiteSharedTables.injectionRow_eq_injectionCore k cache.source h.source
      (-Real.pi * L) (gridStep n L) (cutIndex n L) (2^n)
      (boundarySchedule (cutIndex n L)) (n-t.val) (decide (bit = 1))
      cache.children[bit.val].lower cache.children[bit.val].upper
      cache.children[bit.val].middleFull hlo hup (by simp only [hmf, decide_eq_true_eq]) j
  · intro i j
    change denote (if decide (bit = 1) then cache.shared.trueTable else cache.shared.falseTable)
      i j = _
    by_cases hb : bit = 1
    · simp [hb, h.sharedTrue]
    · simp [hb, h.sharedFalse]
  · change (if t.val = 0 then (if decide (bit = 1) then 1 else 0) else
        (if decide (bit = 1) then cache.tail.factor else 1)) = _
    have ht : n - t.val = n ↔ t.val = 0 := by have := t.isLt; omega
    simp only [rightCore, ht, rightFree, h.factor]

/-- Source runs are first physically cached, then their outputs projected.
Only counter summation is metadata. No second source producer evaluation is
used to obtain exponential counts or ordinary costs. -/
def collectSource {m : ℕ} (f : Fin m → SourceRun α) : SourceRun (Vector α m) :=
  let entries : Vector (SourceRun α) m := Vector.ofFn f
  let projected := collect fun i => do
    let entry ← read entries i
    pure entry.run.value
  ⟨⟨projected.value,
    (fun op => ∑ i : Fin m, entries[i.val].run.cost op) + m • tick .write + projected.cost⟩,
    ∑ i : Fin m, entries[i.val].exponentialCalls⟩

theorem collectSource_value {m : ℕ} (f : Fin m → SourceRun α) (i : Fin m) :
    (collectSource f).run.value[i.val] = (f i).run.value := by
  simp [collectSource, collect_value, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge]

theorem collectSource_cost {m : ℕ} (f : Fin m → SourceRun α) (op : Op) :
    (collectSource f).run.cost op = (∑ i : Fin m, (f i).run.cost op) +
      m * (3 * tick .read op + 3 * tick .write op) := by
  simp [collectSource, collect_cost, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge]
  ring

theorem collectSource_exponentialCalls {m : ℕ} (f : Fin m → SourceRun α) :
    (collectSource f).exponentialCalls = ∑ i : Fin m, (f i).exponentialCalls := by
  simp [collectSource]

noncomputable def two {k : ℕ} (cache : Cache k) (t : ℕ) :
    SourceRun (Vector (Fields k) 2) := collectSource (one cache t)

theorem two_value {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) :
    (two cache t).run.value[bit.val] = (one cache t bit).run.value :=
  collectSource_value _ bit

theorem two_source {k n : ℕ} (cache : Cache k) (t : Fin (n+1)) (L : ℝ)
    (h : CacheCorrect n t.val L cache) (bit : Fin 2) :
    SourceCorrect k n t.val L bit (two cache t.val).run.value[bit.val] := by
  rw [two_value]
  exact one_source cache t L h bit

theorem one_exponentialCalls {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) :
    (one cache t bit).exponentialCalls = if cache.children[bit.val].leftFull then 1 else 0 := by
  simp only [one, addCost, fromLoaded, load_value, view,
    StoredHermiteGeometry.leftInjection_exponentialCalls]

theorem one_exponentialCalls_le {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) :
    (one cache t bit).exponentialCalls ≤ 1 := by
  rw [one_exponentialCalls]
  split <;> omega

theorem two_exponentialCalls_le {k : ℕ} (cache : Cache k) (t : ℕ) :
    (two cache t).exponentialCalls ≤ 2 := by
  rw [two, collectSource_exponentialCalls]
  have h := Finset.sum_le_sum (fun bit (_ : bit ∈ Finset.univ) =>
    one_exponentialCalls_le cache t bit)
  simpa using h

theorem fromLoaded_cost_le {k : ℕ} (t : ℕ) (x : Loaded k) (op : Op) :
    (fromLoaded t x).run.cost op ≤ 2 * StoredBernstein.edgeBudget (2*k+1) op +
      7 * tick .field op + 7 * tick .compare op + 7 * tick .write op := by
  have hm := StoredHermiteSharedTables.injectionRow_cost_le
    x.source x.lower x.upper x.middleFull op
  have hl := StoredHermiteGeometry.leftInjection_cost x.leftFull x.lower x.width x.grid op
  simp only [fromLoaded, charge, Pi.add_apply, Pi.smul_apply, smul_eq_mul, selectTails_cost]
  split_ifs at hl <;> omega

theorem one_cost_le {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) (op : Op) :
    (one cache t bit).run.cost op ≤ 2 * StoredBernstein.edgeBudget (2*k+1) op +
      7 * tick .field op + 9 * tick .compare op + 15 * tick .read op +
        7 * tick .write op := by
  have h := fromLoaded_cost_le t (load cache bit).value op
  rw [one, addCost_cost, load_cost]
  omega

theorem one_total_cost_le {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2) :
    StoredRectangularGivens.total (one cache t bit).run.cost ≤
      20*(2*k+1)^3 + 42*(2*k+1)^2 + 32*(2*k+1) + 48 := by
  have hf := one_cost_le cache t bit .field
  have hs := one_cost_le cache t bit .sqrt
  have ha := one_cost_le cache t bit .angle
  have ht := one_cost_le cache t bit .trig
  have hc := one_cost_le cache t bit .compare
  have hr := one_cost_le cache t bit .read
  have hw := one_cost_le cache t bit .write
  have he := one_cost_le cache t bit .emit
  simp [StoredBernstein.edgeBudget, StoredBernstein.rowBudget, tick] at hf hs ha ht hc hr hw he
  simp only [StoredRectangularGivens.total]
  nlinarith

theorem two_cost_le {k : ℕ} (cache : Cache k) (t : ℕ) (op : Op) :
    (two cache t).run.cost op ≤ 4 * StoredBernstein.edgeBudget (2*k+1) op +
      14 * tick .field op + 18 * tick .compare op + 36 * tick .read op +
        20 * tick .write op := by
  rw [two, collectSource_cost]
  have h := Finset.sum_le_sum (fun bit (_ : bit ∈ Finset.univ) => one_cost_le cache t bit op)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul] at h
  omega

theorem two_total_cost_le {k : ℕ} (cache : Cache k) (t : ℕ) :
    StoredRectangularGivens.total (two cache t).run.cost ≤
      40*(2*k+1)^3 + 84*(2*k+1)^2 + 64*(2*k+1) + 108 := by
  have hf := two_cost_le cache t .field
  have hs := two_cost_le cache t .sqrt
  have ha := two_cost_le cache t .angle
  have ht := two_cost_le cache t .trig
  have hc := two_cost_le cache t .compare
  have hr := two_cost_le cache t .read
  have hw := two_cost_le cache t .write
  have he := two_cost_le cache t .emit
  simp [StoredBernstein.edgeBudget, StoredBernstein.rowBudget, tick] at hf hs ha ht hc hr hw he
  simp only [StoredRectangularGivens.total]
  nlinarith

end QuantumBlockEncoding.StoredHermiteStageFields
