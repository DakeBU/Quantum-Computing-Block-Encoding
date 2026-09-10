import QuantumBlockEncoding.StoredHermiteStageFields

namespace QuantumBlockEncoding.StoredHermiteStageFieldsTests

open StoredGivens StoredHermiteStageFields HermiteBoundaryInjection

/-- A test fixture, not a new costed top-level constructor. Its caches come
from actual checked suppliers, and its parent coordinate remains explicit. -/
noncomputable def fixture (k n : ℕ) (L : ℝ) (t : Fin (n+1))
    (parent : StoredBinaryCoordinates.Point) : Cache k :=
  let level := (StoredHermiteGeometry.atStage
    (StoredHermiteGeometry.tailCache n L).run.value t).value
  ⟨(StoredHermiteCoefficients.compile k).run.value,
    (StoredHermiteSharedTables.compile (2*k+1)).value,
    level,
    (StoredHermiteChildGeometry.children parent level (2^(n-t.val))
      (cutIndex n L) (2^n)).run.value,
    gridStep n L⟩

theorem fixture_correct (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1))
    (parent : StoredBinaryCoordinates.Point)
    (hp : parent.first = boundarySchedule (cutIndex n L) (n-t.val+1))
    (hl : parent.lower = affinePoint (-Real.pi*L) (gridStep n L) parent.first) :
    CacheCorrect n t.val L (fixture k n L t parent) := by
  constructor
  · dsimp only [fixture]
    exact StoredHermiteCoefficients.compile_value k
  · dsimp only [fixture]
    exact StoredHermiteSharedTables.compile_false (2*k+1)
  · dsimp only [fixture]
    exact StoredHermiteSharedTables.compile_true (2*k+1)
  · rfl
  · dsimp only [fixture]
    exact (StoredHermiteGeometry.atStage_value n L hL t).1
  · dsimp only [fixture]
    exact (StoredHermiteGeometry.atStage_value n L hL t).2
  · intro bit
    dsimp only [fixture]
    have hi : (if decide (bit = 1) then 1 else 0) = bit.val := by
      fin_cases bit <;> decide
    simpa only [hi] using StoredHermiteChildGeometry.children_refines parent
      (StoredHermiteGeometry.atStage (StoredHermiteGeometry.tailCache n L).run.value t).value
      (2^(n-t.val)) (cutIndex n L) (2^n) n (n-t.val) (-Real.pi*L) (gridStep n L)
      (decide (bit = 1)) hp hl (StoredHermiteGeometry.atStage_value n L hL t).1 rfl rfl

-- Actual supplier composition, not a SourceCorrect input hypothesis.
example (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1))
    (parent : StoredBinaryCoordinates.Point)
    (hp : parent.first = boundarySchedule (cutIndex n L) (n-t.val+1))
    (hl : parent.lower = affinePoint (-Real.pi*L) (gridStep n L) parent.first)
    (bit : Fin 2) :
    StoredHermiteKernelTable.SourceCorrect k n t.val L bit
      (two (fixture k n L t parent) t.val).run.value[bit.val] :=
  two_source _ t L (fixture_correct k n L hL t parent hp hl) bit

-- Smallest source width uses the literal first-stage right selector.
example {k : ℕ} (cache : Cache k) : (one cache 0 0).run.value.rightCore = 0 := by
  rw [one_value]
  rfl

example {k : ℕ} (cache : Cache k) : (one cache 0 1).run.value.rightCore = 1 := by
  rw [one_value]
  rfl

example {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2)
    (h : cache.children[bit.val].leftFull = false) :
    (one cache t bit).exponentialCalls = 0 := by
  rw [one_exponentialCalls, h]
  rfl

example {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2)
    (h : cache.children[bit.val].leftFull = true) :
    (one cache t bit).exponentialCalls = 1 := by
  rw [one_exponentialCalls, h]
  rfl

example {k : ℕ} (cache : Cache k) (t : ℕ) (bit : Fin 2)
    (h : cache.children[bit.val].middleFull = false) (j : Fin (2*k+1+1)) :
    (one cache t bit).run.value.middleInjection[j.val] = 0 := by
  rw [one_value]
  change (StoredHermiteSharedTables.injectionRow cache.source cache.children[bit.val].lower
    cache.children[bit.val].upper cache.children[bit.val].middleFull).value[j.val] = 0
  rw [h, StoredHermiteSharedTables.injectionRow, StoredHermiteSharedTables.withCost_value]
  simp only [Bool.false_eq_true, if_false, collect_value]
  rfl

example {k n : ℕ} (cache : Cache k) (t : Fin (n+1)) (L : ℝ)
    (h : CacheCorrect n t.val L cache) (a : Fin (2*k+6))
    (out : Fin 2 × Fin (2*k+6)) :
    StoredTensorTrain.denoteCore
      (StoredHermiteKernelTable.assemble (two cache t.val).run.value).value a out =
        HermiteExplicitBond.kernel k n L t.val out.1 a out.2 :=
  StoredHermiteKernelTable.assemble_source _ (two_source cache t L h) a out

example {k : ℕ} (cache : Cache k) (t : ℕ) :
    (two cache t).exponentialCalls ≤ 2 := two_exponentialCalls_le cache t

example (cache : Cache 0) (t : ℕ) :
    StoredRectangularGivens.total (two cache t).run.cost ≤ 296 := by
  have h := two_total_cost_le cache t
  norm_num at h ⊢
  exact h

#print axioms one_source
#print axioms two_source
#print axioms two_total_cost_le
#print axioms two_exponentialCalls_le
#print axioms fixture_correct

end QuantumBlockEncoding.StoredHermiteStageFieldsTests
