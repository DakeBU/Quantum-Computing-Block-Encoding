import QuantumBlockEncoding.StoredHermiteSourceCache
import QuantumBlockEncoding.StoredHermiteStageFields

/-! global-cache to stage-cache supplier. Exactly eleven charged
reads fetch source/shared/tails references, the atStage tail level, parent
table and entry, spans table and remaining-width entry, spans[n] midpoint,
cutoff and grid. atStage retains its existing single-read contract. No new
Nat.pow, scalar exponential, or source coefficient construction is evaluated.

The same run calls children once (70 ordinary operations and four separately
counted integer additions), then writes the five output StageFields.Cache
payloads. Loaded is a local register tuple, not a new stored cache. Natural
index subtraction and proof/counter/local tuple bookkeeping retain the
upstream word-model boundary; this is not a finite-bit runtime theorem. -/

namespace QuantumBlockEncoding.StoredHermiteStageInput

open StoredGivens HermiteBoundaryInjection
open scoped BigOperators

structure Loaded (k : ℕ) where
  source : Vector ℝ (2*k+1+1)
  shared : StoredHermiteSharedTables.Tables (2*k+1)
  level : StoredHermiteGeometry.TailLevel
  parent : StoredBinaryCoordinates.Point
  span : ℕ
  midpoint : ℕ
  cutoff : ℕ
  grid : ℝ

def view {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : Loaded k :=
  ⟨cache.source, cache.shared, (StoredHermiteGeometry.atStage cache.tails t).value,
    cache.parents[t.val], cache.spans[n-t.val], cache.spans[n],
    cache.tails.cutoff, cache.tails.grid⟩

def load {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : Run (Loaded k) := do
  let source ← charge .read cache.source
  let shared ← charge .read cache.shared
  let tails ← charge .read cache.tails
  let level ← StoredHermiteGeometry.atStage tails t
  let parents ← charge .read cache.parents
  let parent ← read parents t
  let spans ← charge .read cache.spans
  let span ← read spans ⟨n-t.val, by omega⟩
  let midpoint ← read spans (Fin.last n)
  let cutoff ← charge .read tails.cutoff
  let grid ← charge .read tails.grid
  pure ⟨source, shared, level, parent, span, midpoint, cutoff, grid⟩

theorem load_value {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : (load cache t).value = view cache t := rfl

theorem load_cost {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) (op : Op) : (load cache t).cost op = 11 * tick .read op := by
  simp [load, bind, pure, Run.bind, Run.pure, charge, StoredGivens.read,
    StoredHermiteGeometry.atStage_cost]
  ring

def store {k : ℕ} (x : Loaded k) (children : Vector StoredHermiteChildGeometry.Child 2) :
    Run (StoredHermiteStageFields.Cache k) :=
  ⟨⟨x.source, x.shared, x.level, children, x.grid⟩, 5 • tick .write⟩

noncomputable def input {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : StoredHermiteChildGeometry.ChildRun (StoredHermiteStageFields.Cache k) :=
  let x := load cache t
  let children := StoredHermiteChildGeometry.children x.value.parent x.value.level
    x.value.span x.value.cutoff x.value.midpoint
  let result := store x.value children.run.value
  ⟨⟨result.value, x.cost + children.run.cost + result.cost⟩, children.integerAdditions⟩

/-- Mathematical view of the same returned data, not an executable callback. -/
noncomputable def stageView {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : StoredHermiteStageFields.Cache k :=
  let x := view cache t
  ⟨x.source, x.shared, x.level,
    (StoredHermiteChildGeometry.children x.parent x.level x.span x.cutoff x.midpoint).run.value,
    x.grid⟩

theorem input_value {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : (input cache t).run.value = stageView cache t := by
  simp only [input, load_value, store, stageView]

theorem input_cost {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) (op : Op) :
    (input cache t).run.cost op = 6 * tick .field op + 20 * tick .compare op +
      29 * tick .read op + 31 * tick .write op := by
  simp [input, store, load_cost, StoredHermiteChildGeometry.children_cost]
  ring

theorem input_integerAdditions {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : (input cache t).integerAdditions = 4 :=
  StoredHermiteChildGeometry.children_integerAdditions _ _ _ _ _

theorem input_total_cost {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : (∑ op : Op, (input cache t).run.cost op) = 86 := by
  simp only [input_cost, Finset.sum_add_distrib, ← Finset.mul_sum]
  have ht (op : Op) : (∑ q : Op, tick op q) = 1 := by simp [tick]
  simp only [ht]
  norm_num

/-- The final bridge is unconditional apart from L>0: source, shared tables,
tails, parent first/lower, and integer spans all come from global compile. -/
theorem inputCorrect (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1)) :
    StoredHermiteStageFields.CacheCorrect n t.val L
      (input (StoredHermiteSourceCache.compile k n L).run.value t).run.value := by
  have tails := StoredHermiteSourceCache.compile_tails k n L hL
  have level := tails.2.2 ⟨n-t.val, by omega⟩
  have parentFirst := StoredHermiteSourceCache.compile_parents_first k n L hL t
  have parentLower := StoredHermiteSourceCache.compile_parents_lower k n L hL t
  rw [input_value]
  constructor
  · dsimp only [stageView, view]
    exact StoredHermiteSourceCache.compile_source k n L
  · dsimp only [stageView, view]
    exact StoredHermiteSourceCache.compile_shared_false k n L
  · dsimp only [stageView, view]
    exact StoredHermiteSourceCache.compile_shared_true k n L
  · exact tails.2.1
  · exact level.1
  · exact level.2
  · intro bit
    dsimp only [stageView, view]
    have hi : (if decide (bit = 1) then 1 else 0) = bit.val := by
      fin_cases bit <;> decide
    have hp : ((StoredHermiteSourceCache.compile k n L).run.value.parents[t.val]).first =
        boundarySchedule (StoredHermiteSourceCache.compile k n L).run.value.tails.cutoff
          (n-t.val+1) := by
      rw [tails.1]
      exact parentFirst
    have hl : ((StoredHermiteSourceCache.compile k n L).run.value.parents[t.val]).lower =
        affinePoint (-Real.pi*L) (gridStep n L)
          ((StoredHermiteSourceCache.compile k n L).run.value.parents[t.val]).first := by
      rw [parentFirst]
      exact parentLower
    simpa only [hi, tails.1] using StoredHermiteChildGeometry.children_refines
      (StoredHermiteSourceCache.compile k n L).run.value.parents[t.val]
      (StoredHermiteGeometry.atStage (StoredHermiteSourceCache.compile k n L).run.value.tails t).value
      (StoredHermiteSourceCache.compile k n L).run.value.spans[n-t.val]
      (StoredHermiteSourceCache.compile k n L).run.value.tails.cutoff
      (StoredHermiteSourceCache.compile k n L).run.value.spans[n]
      n (n-t.val) (-Real.pi*L) (gridStep n L) (decide (bit = 1)) hp hl level.1
      (StoredHermiteSourceCache.compile_spans k n L ⟨n-t.val, by omega⟩)
      (StoredHermiteSourceCache.compile_spans k n L (Fin.last n))

/-- Correctness and both operation counters refer to this very input run. -/
theorem input_certified (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1)) :
    let result := input (StoredHermiteSourceCache.compile k n L).run.value t
    StoredHermiteStageFields.CacheCorrect n t.val L result.run.value ∧
      (∑ op : Op, result.run.cost op) = 86 ∧ result.integerAdditions = 4 :=
  ⟨inputCorrect k n L hL t, input_total_cost _ t, input_integerAdditions _ t⟩

end QuantumBlockEncoding.StoredHermiteStageInput
