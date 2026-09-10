import QuantumBlockEncoding.StoredHermiteChildGeometry

namespace QuantumBlockEncoding.StoredHermiteChildGeometryTests
open StoredGivens StoredBinaryCoordinates StoredHermiteGeometry StoredHermiteChildGeometry
open HermiteBoundaryInjection

noncomputable def point (first : ℕ) (lower : ℝ) : Point := ⟨first, lower⟩
noncomputable def width (w : ℝ) : TailLevel := ⟨w, 99⟩

/-- n=0, cutoff at midpoint: empty middle; the last left sample is -2. -/
example :
    let c := (child (point 0 (-2)) (width 1) 1 1 1 false).run.value
    c.first = 0 ∧ c.lower = -2 ∧ c.upper = -1 ∧
      c.leftFull = true ∧ c.leftPartial = false ∧
      c.middleFull = false ∧ c.middlePartial = false := by
  norm_num [child, point, width, flags, bind, Run.bind, charge,
    StoredGivens.mul, StoredGivens.add]

/-- The coordinate exactly at -1 is not accidentally injected into an empty middle. -/
example :
    let c := (child (point 0 (-2)) (width 1) 1 1 1 true).run.value
    c.first = 1 ∧ c.lower = -1 ∧ c.upper = 0 ∧
      c.leftFull = false ∧ c.leftPartial = false ∧
      c.middleFull = false ∧ c.middlePartial = false := by
  norm_num [child, point, width, flags, bind, Run.bind, charge,
    StoredGivens.mul, StoredGivens.add]

/-- Cutoff zero: left disabled and first middle singleton enabled. -/
example :
    let c := (child (point 0 (-1)) (width 1) 1 0 1 false).run.value
    c.leftFull = false ∧ c.leftPartial = false ∧
      c.middleFull = true ∧ c.middlePartial = false := by
  norm_num [child, point, width, flags, bind, Run.bind, charge]

/-- One child straddles the common cut: both boundary states remain Partial. -/
example :
    let c := (child (point 0 (-4)) (width 2) 2 3 4 true).run.value
    c.first = 2 ∧ c.lower = -2 ∧ c.upper = 0 ∧
      c.leftFull = false ∧ c.leftPartial = true ∧
      c.middleFull = false ∧ c.middlePartial = true := by
  norm_num [child, point, width, flags, bind, Run.bind, charge,
    StoredGivens.mul, StoredGivens.add]

example (p : Point) (w : TailLevel) (span cut mid : ℕ) :
    (children p w span cut mid).integerAdditions = 4 ∧
    (children p w span cut mid).run.cost .field = 6 ∧
    (children p w span cut mid).run.cost .compare = 20 ∧
    (∑ op : Op, (children p w span cut mid).run.cost op) = 70 := by
  rw [children_total_cost]
  simp [children_integerAdditions, children_cost, tick]

example (bit : Bool) :
    Refines ((children (point 0 (-4)) (width 2) 2 3 4).run.value[
      if bit then 1 else 0]'(by cases bit <;> decide)) 3 2 1 (-4) 1 bit := by
  apply children_refines
  all_goals norm_num [point, width, boundarySchedule, affinePoint]

/-- No small fixed cutoff/word-width assumption hides in the range theorem. -/
example (p : Point) (w : TailLevel) (cut : ℕ) (bit : Bool)
    (hp : p.first = boundarySchedule cut 128) (hc : cut ≤ 2^127) :
    (child p w (2^127) cut (2^127) bit).run.value.first + 2^127 < 2^129 := by
  exact child_index_word_bound p w _ cut _ 127 127 bit hp rfl hc (le_refl _)

#print axioms child_refines
#print axioms children_refines
#print axioms children_cost
#print axioms children_certified
#print axioms child_index_word_bound

end QuantumBlockEncoding.StoredHermiteChildGeometryTests
