import QuantumBlockEncoding.HermiteBinaryCutoff

/-!
# Charged binary conversion for source coordinates

No natural-to-real cast is evaluated by these producers. Binary quotient and
remainder calls are counted separately; real arithmetic and comparisons use
the unchanged StoredGivens counters. These are unit-operation counts, not
integer bit complexity or complete loop/allocation/counter bookkeeping.
This unpublished draft does not participate in a publication gate.
-/

namespace QuantumBlockEncoding.StoredBinaryCoordinates

open StoredGivens HermiteBoundaryInjection

structure IndexedRun (α : Type) where
  run : Run α
  quotientCalls : ℕ
  remainderCalls : ℕ

/-- Read exactly `width` low binary digits using quotient/remainder, then
Horner arithmetic. The legal-input theorem requires the integer to fit. -/
noncomputable def binaryReal : (width j : ℕ) → IndexedRun ℝ
  | 0, _ => ⟨pure 0, 0, 0⟩
  | width + 1, j =>
      let quotient := j / 2
      let remainder := j % 2
      let previous := binaryReal width quotient
      let bit : Run ℝ := charge .compare (if remainder = 0 then 0 else 1)
      let result : Run ℝ := do
        let twice ← StoredGivens.mul previous.run.value 2
        StoredGivens.add twice bit.value
      ⟨⟨result.value, previous.run.cost + bit.cost + result.cost⟩,
        previous.quotientCalls + 1, previous.remainderCalls + 1⟩

theorem binaryReal_value (width j : ℕ) (h : j < 2 ^ width) :
    (binaryReal width j).run.value = (j : ℝ) := by
  induction width generalizing j with
  | zero =>
      have hj : j = 0 := by simpa using h
      subst j
      simp [binaryReal, pure, Run.pure]
  | succ width ih =>
      have hq : j / 2 < 2 ^ width := by
        rw [pow_succ] at h
        omega
      have hr : j % 2 < 2 := Nat.mod_lt _ (by decide)
      have hd := Nat.mod_add_div j 2
      simp only [binaryReal, bind, Run.bind, StoredGivens.mul, StoredGivens.add,
        charge, ih _ hq]
      by_cases hz : j % 2 = 0
      · simp only [hz, if_true, add_zero]
        have eq : j / 2 * 2 = j := by omega
        exact_mod_cast eq
      · have ho : j % 2 = 1 := by omega
        simp only [hz, if_false]
        have eq : j / 2 * 2 + 1 = j := by omega
        exact_mod_cast eq

theorem binaryReal_cost (width j : ℕ) (op : Op) :
    (binaryReal width j).run.cost op =
      2 * width * tick .field op + width * tick .compare op := by
  induction width generalizing j with
  | zero => simp [binaryReal, pure, Run.pure]
  | succ width ih =>
      simp only [binaryReal, Pi.add_apply, charge, bind, Run.bind,
        StoredGivens.mul, StoredGivens.add, ih]
      ring

theorem binaryReal_quotients (width j : ℕ) :
    (binaryReal width j).quotientCalls = width := by
  induction width generalizing j with
  | zero => rfl
  | succ width ih => simp [binaryReal, ih]

theorem binaryReal_remainders (width j : ℕ) :
    (binaryReal width j).remainderCalls = width := by
  induction width generalizing j with
  | zero => rfl
  | succ width ih => simp [binaryReal, ih]

/-- Coordinate supplier from explicit real origin/step and a binary index.
Origin and step are supplied values; their production is not charged here. -/
noncomputable def coordinate (width j : ℕ) (origin step : ℝ) : IndexedRun ℝ :=
  let index := binaryReal width j
  let result : Run ℝ := do
    let offset ← StoredGivens.mul step index.run.value
    StoredGivens.add origin offset
  ⟨⟨result.value, index.run.cost + result.cost⟩,
    index.quotientCalls, index.remainderCalls⟩

theorem coordinate_value (width j : ℕ) (origin step : ℝ) (h : j < 2 ^ width) :
    (coordinate width j origin step).run.value = affinePoint origin step j := by
  simp only [coordinate, bind, Run.bind, StoredGivens.mul, StoredGivens.add,
    charge, binaryReal_value _ _ h, affinePoint]

theorem coordinate_cost (width j : ℕ) (origin step : ℝ) (op : Op) :
    (coordinate width j origin step).run.cost op =
      (2 * width + 2) * tick .field op + width * tick .compare op := by
  simp [coordinate, bind, Run.bind, StoredGivens.mul, StoredGivens.add,
    charge, binaryReal_cost]
  ring

theorem coordinate_quotients (width j : ℕ) (origin step : ℝ) :
    (coordinate width j origin step).quotientCalls = width := by
  simp [coordinate, binaryReal_quotients]

theorem coordinate_remainders (width j : ℕ) (origin step : ℝ) :
    (coordinate width j origin step).remainderCalls = width := by
  simp [coordinate, binaryReal_remainders]

/-- One materialized indexed pass, followed by value projection. Scalar and
index-call counters read stored results; callbacks are not rerun. -/
def collectIndexed {m : ℕ} (f : Fin m → IndexedRun α) : IndexedRun (Vector α m) :=
  let entries : Vector (IndexedRun α) m := Vector.ofFn f
  ⟨⟨entries.map (fun e => e.run.value),
      (fun op => ∑ i : Fin m, entries[i.val].run.cost op) +
        m • (2 • tick .read + 2 • tick .write)⟩,
    ∑ i : Fin m, entries[i.val].quotientCalls,
    ∑ i : Fin m, entries[i.val].remainderCalls⟩

@[simp] theorem collectIndexed_value {m : ℕ} (f : Fin m → IndexedRun α) (i : Fin m) :
    (collectIndexed f).run.value[i.val] = (f i).run.value := by simp [collectIndexed]

@[simp] theorem collectIndexed_cost {m : ℕ} (f : Fin m → IndexedRun α) (op : Op) :
    (collectIndexed f).run.cost op = (∑ i : Fin m, (f i).run.cost op) +
      m * (2 * tick .read op + 2 * tick .write op) := by simp [collectIndexed]; ring

structure Point where
  first : ℕ
  lower : ℝ

/-- The schedule uses one separately counted integer quotient. Powers and
integer address multiplication remain outside the two selected index counters.
The real coordinate itself is built by charged binary arithmetic. -/
noncomputable def parent (n cut r : ℕ) (origin step : ℝ) : IndexedRun Point :=
  let scale := 2 ^ (r + 1)
  let block := cut / scale
  let first := scale * block
  let result := coordinate (n + 1) first origin step
  ⟨⟨⟨first, result.run.value⟩, result.run.cost⟩,
    result.quotientCalls + 1, result.remainderCalls⟩

theorem parent_first (n cut r : ℕ) (origin step : ℝ) :
    (parent n cut r origin step).run.value.first = boundarySchedule cut (r + 1) := rfl

private theorem schedule_le (cut r : ℕ) : boundarySchedule cut r ≤ cut := by
  have h := Nat.mod_add_div cut (2 ^ r)
  unfold boundarySchedule
  omega

theorem parent_lower (n cut r : ℕ) (origin step : ℝ) (hc : cut ≤ 2 ^ n) :
    (parent n cut r origin step).run.value.lower =
      affinePoint origin step (boundarySchedule cut (r + 1)) := by
  apply coordinate_value
  have hs := schedule_le cut (r + 1)
  have hp : 0 < 2 ^ n := pow_pos (by decide) _
  change 2 ^ (r + 1) * (cut / 2 ^ (r + 1)) ≤ cut at hs
  simp only [pow_succ] at hs ⊢
  omega

theorem parent_cost (n cut r : ℕ) (origin step : ℝ) (op : Op) :
    (parent n cut r origin step).run.cost op =
      (2 * n + 4) * tick .field op + (n + 1) * tick .compare op := by
  simp only [parent, coordinate_cost]
  ring

theorem parent_quotients (n cut r : ℕ) (origin step : ℝ) :
    (parent n cut r origin step).quotientCalls = n + 2 := by
  simp [parent, coordinate_quotients]

theorem parent_remainders (n cut r : ℕ) (origin step : ℝ) :
    (parent n cut r origin step).remainderCalls = n + 1 := by
  simp [parent, coordinate_remainders]

/-- Chronological parent rows: index `t` corresponds to residual width `n-t`.
Only `n+1` coordinates are stored, not a grid-sized coordinate table. -/
noncomputable def parents (n cut : ℕ) (origin step : ℝ) :
    IndexedRun (Vector Point (n + 1)) :=
  collectIndexed fun t => parent n cut (n - t.val) origin step

theorem parents_first (n cut : ℕ) (origin step : ℝ) (t : Fin (n + 1)) :
    (parents n cut origin step).run.value[t.val].first =
      boundarySchedule cut (n - t.val + 1) := by
  simp only [parents, collectIndexed_value, parent_first]

theorem parents_lower (n cut : ℕ) (origin step : ℝ) (hc : cut ≤ 2 ^ n)
    (t : Fin (n + 1)) :
    (parents n cut origin step).run.value[t.val].lower =
      affinePoint origin step (boundarySchedule cut (n - t.val + 1)) := by
  simp only [parents, collectIndexed_value, parent_lower _ _ _ _ _ hc]

theorem parents_cost (n cut : ℕ) (origin step : ℝ) (op : Op) :
    (parents n cut origin step).run.cost op =
      (n + 1) * ((2 * n + 4) * tick .field op + (n + 1) * tick .compare op +
        2 * tick .read op + 2 * tick .write op) := by
  simp [parents, collectIndexed_cost, parent_cost]
  ring

theorem parents_quotients (n cut : ℕ) (origin step : ℝ) :
    (parents n cut origin step).quotientCalls = (n + 1) * (n + 2) := by
  simp [parents, collectIndexed, parent_quotients]

theorem parents_remainders (n cut : ℕ) (origin step : ℝ) :
    (parents n cut origin step).remainderCalls = (n + 1) ^ 2 := by
  simp [parents, collectIndexed, parent_remainders, pow_two]

end QuantumBlockEncoding.StoredBinaryCoordinates
