import QuantumBlockEncoding.StoredHermiteGeometry

namespace QuantumBlockEncoding.StoredHermiteGeometry.Regression

open StoredGivens HermiteBoundaryInjection StoredHermiteCoefficients


/-- Smallest source width N=1 retains the first-stage right-half selector. -/
example (L : ℝ) (hL : 0 < L) (bit : Bool) :
    rightCore 0 (gridStep 0 L) 0 bit = if bit then 1 else 0 := by
  simpa using (atStage_rightCore 0 L hL 0 bit).symm

example (L : ℝ) : (tailCache 0 L).exponentialCalls = 1 := by
  exact tailCache_exponentialCalls 0 L

/-- Exact -1 at the first sample gives cutoff zero, not a left-tail point. -/
example (n : ℕ) : (tailCache n (1 / Real.pi)).run.value.cutoff = 0 := by
  rw [(tailCache_value n _ (by positivity)).1]
  simp [cutIndex, neg_mul]

/-- A one-cell left half wholly below -1 has cutoff at the midpoint; its
middle interval is empty and no extra level is allocated. -/
example : (tailCache 0 (2 / Real.pi)).run.value.cutoff = 1 := by
  have he : Real.pi * (2 / Real.pi) = 2 := by field_simp
  change (HermiteBinaryCutoff.compute 0 (2 / Real.pi)).value = 1
  norm_num [HermiteBinaryCutoff.compute, HermiteBinaryCutoff.search,
    HermiteBinaryCutoff.below, StoredGivens.mul, StoredGivens.sub,
    charge, bind, pure, Run.bind, Run.pure, he]

/-- Width and factor use the same stored last level even for large n. -/
example (L : ℝ) (hL : 0 < L) :
    (atStage (tailCache 127 L).run.value 0).value.width = Real.pi * L := by
  rw [(atStage_value 127 L hL 0).1]
  exact root_width 127 L

example (L : ℝ) : (tailCache 127 L).exponentialCalls = 128 :=
  tailCache_exponentialCalls 127 L

example (x w s : ℝ) : (leftInjection false x w s).run.value = 0 ∧
    (leftInjection false x w s).exponentialCalls = 0 ∧
    (leftInjection false x w s).run.cost .field = 0 := by
  simp [leftInjection, tick]

/-- Only the last included sample is exponentiated, not the excluded bound. -/
example : (leftInjection true (-3) 2 1).run.value = Real.exp (-2) := by
  norm_num [leftInjection, bind, Run.bind, StoredGivens.add, StoredGivens.sub,
    exponential, charge]

example (x w s : ℝ) : (leftInjection true x w s).run.cost .field = 2 ∧
    (leftInjection true x w s).exponentialCalls = 1 := by
  simp [leftInjection_cost, leftInjection_exponentialCalls, tick]

#print axioms tailCache_value
#print axioms tailCache_cost_le
#print axioms tailCache_total_cost_le
#print axioms atStage_rightCore
#print axioms leftInjection_value
#print axioms leftInjection_bounds


end QuantumBlockEncoding.StoredHermiteGeometry.Regression
