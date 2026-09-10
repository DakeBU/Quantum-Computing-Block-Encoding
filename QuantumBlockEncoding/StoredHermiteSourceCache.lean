import QuantumBlockEncoding.StoredHermiteGeometry
import QuantumBlockEncoding.StoredHermiteSharedTables
import QuantumBlockEncoding.StoredBinaryCoordinates
import QuantumBlockEncoding.StoredDyadicSpans

/-!
cycle-05 fixed source cache. Every supplier is executed once and
its actual returned value and counters are composed. No semantic source
kernel, coordinate power/cast callback or all-grid array is evaluated here.
The source coefficient dimensions 2*k+2 and 2*k+1+1 are definitionally equal;
no copy or numerical conversion is needed for this type presentation.

Each field read from the stored tail cache is charged, including the root
width. The final six-field Cache record writes six words/references. Small
local result tuples and proof/counter bookkeeping follow the existing Run
model; this is not a complete allocator or finite-bit runtime certificate.
Selected quotient/remainder counts are inherited from the SAME parent
coordinate run, and integerDoublings from the SAME span run. They do not
cover all natural-index operations: cutoff index arithmetic, powers and
address multiplication inside parents, loop indexing and counter arithmetic
remain outside those selected counters, as their suppliers document.
-/

namespace QuantumBlockEncoding.StoredHermiteSourceCache

open StoredGivens StoredHermiteCoefficients HermiteBoundaryInjection
open scoped BigOperators

structure Cache (k n : ℕ) where
  source : Vector ℝ (2 * k + 1 + 1)
  shared : StoredHermiteSharedTables.Tables (2 * k + 1)
  tails : StoredHermiteGeometry.TailCache n
  origin : ℝ
  parents : Vector StoredBinaryCoordinates.Point (n + 1)
  spans : Vector ℕ (n + 1)

/-- SourceRun's ordinary and exponential fields are inherited unchanged.
The additional counters describe only selected integer supplier operations. -/
structure CacheRun (α : Type) extends SourceRun α where
  quotientCalls : ℕ
  remainderCalls : ℕ
  integerDoublings : ℕ

structure Inputs where
  origin : ℝ
  grid : ℝ
  cutoff : ℕ

/-- Reuse the actual root-level tail width, never recompute pi*L or cast an
integer address. Root/table and numeric payload reads are separately charged. -/
noncomputable def inputs {n : ℕ} (tail : StoredHermiteGeometry.TailCache n) : Run Inputs := do
  let root ← StoredHermiteGeometry.atStage tail 0
  let width ← charge .read root.width
  let origin ← StoredGivens.sub 0 width
  let grid ← charge .read tail.grid
  let cutoff ← charge .read tail.cutoff
  pure ⟨origin, grid, cutoff⟩

theorem inputs_value (n : ℕ) (L : ℝ) (hL : 0 < L) :
    (inputs (StoredHermiteGeometry.tailCache n L).run.value).value.origin = -Real.pi * L ∧
    (inputs (StoredHermiteGeometry.tailCache n L).run.value).value.grid = gridStep n L ∧
    (inputs (StoredHermiteGeometry.tailCache n L).run.value).value.cutoff = cutIndex n L := by
  have root : (StoredHermiteGeometry.atStage
      (StoredHermiteGeometry.tailCache n L).run.value 0).value.width = Real.pi * L := by
    rw [(StoredHermiteGeometry.atStage_value n L hL 0).1]
    simpa using StoredHermiteGeometry.root_width n L
  simp only [inputs, bind, pure, Run.bind, Run.pure, charge, StoredGivens.sub,
    root, zero_sub, neg_mul]
  exact ⟨trivial, (StoredHermiteGeometry.tailCache_value n L hL).2.1,
    (StoredHermiteGeometry.tailCache_value n L hL).1⟩

theorem inputs_cost {n : ℕ} (tail : StoredHermiteGeometry.TailCache n) (op : Op) :
    (inputs tail).cost op = 4 * tick .read op + tick .field op := by
  simp [inputs, bind, pure, Run.bind, Run.pure, charge, StoredGivens.sub,
    StoredHermiteGeometry.atStage_cost]
  ring

/-- Explicit fixed-size record materialization; arrays and tables are already
stored and are preserved by reference rather than regenerated. -/
def storeCache {k n : ℕ} (source : Vector ℝ (2*k+1+1))
    (shared : StoredHermiteSharedTables.Tables (2*k+1))
    (tails : StoredHermiteGeometry.TailCache n) (origin : ℝ)
    (parents : Vector StoredBinaryCoordinates.Point (n+1))
    (spans : Vector ℕ (n+1)) : Run (Cache k n) :=
  ⟨⟨source, shared, tails, origin, parents, spans⟩, 6 • tick .write⟩

/-- Actual deterministic source cache, with no hypothetical supplier input. -/
noncomputable def compile (k n : ℕ) (L : ℝ) : CacheRun (Cache k n) :=
  let source := StoredHermiteCoefficients.compile k
  let shared := StoredHermiteSharedTables.compile (2*k+1)
  let tails := StoredHermiteGeometry.tailCache n L
  let scalar := inputs tails.run.value
  let parents := StoredBinaryCoordinates.parents n scalar.value.cutoff
    scalar.value.origin scalar.value.grid
  let spans := StoredDyadicSpans.spans n
  let stored := storeCache source.run.value shared.value tails.run.value
    scalar.value.origin parents.run.value spans.run.value
  ⟨⟨⟨stored.value,
      source.run.cost + shared.cost + tails.run.cost + scalar.cost +
        parents.run.cost + spans.run.cost + stored.cost⟩,
      source.exponentialCalls + tails.exponentialCalls⟩,
    parents.quotientCalls, parents.remainderCalls, spans.integerDoublings⟩

theorem compile_source (k n : ℕ) (L : ℝ) (i : Fin (2*k+1+1)) :
    (compile k n L).run.value.source[i.val] =
      HermiteBernstein.sourceBernsteinCoefficient k i.val :=
  StoredHermiteCoefficients.compile_value k i

theorem compile_shared_false (k n : ℕ) (L : ℝ) :
    denote (compile k n L).run.value.shared.falseTable = sharedCore (2*k+1) false :=
  StoredHermiteSharedTables.compile_false (2*k+1)

theorem compile_shared_true (k n : ℕ) (L : ℝ) :
    denote (compile k n L).run.value.shared.trueTable = sharedCore (2*k+1) true :=
  StoredHermiteSharedTables.compile_true (2*k+1)

theorem compile_tails (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    (compile k n L).run.value.tails.cutoff = cutIndex n L ∧
    (compile k n L).run.value.tails.grid = gridStep n L ∧
    ∀ r : Fin (n+1),
      ((compile k n L).run.value.tails.levels[r.val]).width = gridStep n L * (2 : ℝ)^r.val ∧
      ((compile k n L).run.value.tails.levels[r.val]).factor =
        Real.exp (-gridStep n L * (2 : ℝ)^r.val) :=
  StoredHermiteGeometry.tailCache_value n L hL

theorem compile_origin (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    (compile k n L).run.value.origin = -Real.pi * L :=
  (inputs_value n L hL).1

theorem compile_parents_first (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1)) :
    ((compile k n L).run.value.parents[t.val]).first =
      boundarySchedule (cutIndex n L) (n - t.val + 1) := by
  change ((StoredBinaryCoordinates.parents n _ _ _).run.value[t.val]).first = _
  rw [StoredBinaryCoordinates.parents_first, (inputs_value n L hL).2.2]

theorem compile_parents_lower (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1)) :
    ((compile k n L).run.value.parents[t.val]).lower =
      affinePoint (-Real.pi * L) (gridStep n L)
        (boundarySchedule (cutIndex n L) (n - t.val + 1)) := by
  change ((StoredBinaryCoordinates.parents n _ _ _).run.value[t.val]).lower = _
  rw [(inputs_value n L hL).1, (inputs_value n L hL).2.1,
    (inputs_value n L hL).2.2]
  exact StoredBinaryCoordinates.parents_lower n (cutIndex n L) _ _
    (cutIndex_le_midpoint n L hL) t

theorem compile_spans (k n : ℕ) (L : ℝ) (r : Fin (n+1)) :
    (compile k n L).run.value.spans[r.val] = 2^r.val :=
  StoredDyadicSpans.spans_value n r

theorem compile_exponentialCalls (k n : ℕ) (L : ℝ) :
    (compile k n L).exponentialCalls = n + 2 := by
  simp [compile, StoredHermiteCoefficients.compile_exponentialCalls,
    StoredHermiteGeometry.tailCache_exponentialCalls]
  omega

/-- These are the selected calls in the exact parent run stored in compile. -/
theorem compile_quotientCalls (k n : ℕ) (L : ℝ) :
    (compile k n L).quotientCalls = (n+1)*(n+2) :=
  StoredBinaryCoordinates.parents_quotients _ _ _ _

theorem compile_remainderCalls (k n : ℕ) (L : ℝ) :
    (compile k n L).remainderCalls = (n+1)^2 :=
  StoredBinaryCoordinates.parents_remainders _ _ _ _

theorem compile_integerDoublings (k n : ℕ) (L : ℝ) :
    (compile k n L).integerDoublings = n := StoredDyadicSpans.spans_integerDoublings n

private theorem tick_le_one (a b : Op) : tick a b ≤ 1 := by
  unfold tick
  split <;> omega

private theorem parents_cost_le (n cut : ℕ) (origin grid : ℝ) (op : Op) :
    (StoredBinaryCoordinates.parents n cut origin grid).run.cost op ≤ 9*(n+1)^2 := by
  have hf := tick_le_one .field op
  have hc := tick_le_one .compare op
  have hr := tick_le_one .read op
  have hw := tick_le_one .write op
  rw [StoredBinaryCoordinates.parents_cost]
  nlinarith

/-- Conservative quadratic work bound for the SAME returned cache, including
all six suppliers, tail-field reads, origin subtraction and record writes. -/
private theorem cache_bound (k n a b c d e u v w : ℕ)
    (ha : a ≤ 108*(k+1)^2) (hb : b ≤ 50*(2*k+1+1)^2)
    (hc : c ≤ 16*(n+1)^2) (hd : d ≤ 9*(n+1)^2)
    (he : e ≤ 3*n^2+9*n+4) (hu : u ≤ 1) (hv : v ≤ 1) (hw : w ≤ 1) :
    a + b + c + (4*u+v) + d + e + 6*w ≤ 400*(k+1)^2+32*(n+1)^2 := by
  have hb' : b ≤ 200*(k+1)^2 := by
    convert hb using 1
    ring
  have he' : e ≤ 6*(n+1)^2 := by
    calc
      _ ≤ 3*n^2+9*n+4 := he
      _ ≤ _ := by nlinarith only []
  have hk : 1 ≤ (k+1)^2 := by
    have hpos : 0 < (k+1)^2 := by positivity
    omega
  omega

theorem compile_cost_le (k n : ℕ) (L : ℝ) (op : Op) :
    (compile k n L).run.cost op ≤ 400*(k+1)^2 + 32*(n+1)^2 := by
  have hs := StoredHermiteCoefficients.compile_cost_le k op
  have hb := StoredHermiteSharedTables.compile_cost_le (2*k+1) op
  have ht := StoredHermiteGeometry.tailCache_cost_le n L op
  have hp := parents_cost_le n
    (inputs (StoredHermiteGeometry.tailCache n L).run.value).value.cutoff
    (inputs (StoredHermiteGeometry.tailCache n L).run.value).value.origin
    (inputs (StoredHermiteGeometry.tailCache n L).run.value).value.grid op
  have hd := StoredDyadicSpans.spans_cost_le n op
  have hr := tick_le_one .read op
  have hf := tick_le_one .field op
  have hw := tick_le_one .write op
  simp only [compile, storeCache, inputs_cost, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  exact cache_bound k n _ _ _ _ _ _ _ _ hs hb ht hp hd hr hf hw

theorem compile_total_cost_le (k n : ℕ) (L : ℝ) :
    (∑ op : Op, (compile k n L).run.cost op) ≤
      3200*(k+1)^2 + 256*(n+1)^2 := by
  have h := Finset.sum_le_sum
    (fun op (_ : op ∈ Finset.univ) => compile_cost_le k n L op)
  have hc : Fintype.card Op = 8 := by decide
  calc
    _ ≤ 8*(400*(k+1)^2 + 32*(n+1)^2) := by simpa [hc] using h
    _ = _ := by ring

end QuantumBlockEncoding.StoredHermiteSourceCache
