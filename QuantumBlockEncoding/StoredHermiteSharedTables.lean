import QuantumBlockEncoding.StoredHermiteCoefficients
import QuantumBlockEncoding.StoredBernstein
import QuantumBlockEncoding.HermiteBoundaryInjection

/-!
cycle-05 supplier: cached shared Bernstein matrices and one stored
boundary injection row. The eight `StoredGivens.Op` counters retain their
existing meaning. Index-word arithmetic, proof and counter bookkeeping, and
fixed record projections are outside this exact-real model; no finite-bit
runtime is claimed. Every numeric table lookup and materialized vector write
is charged. No semantic subdivision callback is executed to create a table.
-/

namespace QuantumBlockEncoding.StoredHermiteSharedTables

set_option maxHeartbeats 200000

open scoped BigOperators
open StoredGivens
open HermiteBoundaryInjection

/-- Cache `1 / 2^j` by one real division per extension, with full-copy writes. -/
noncomputable def inversePowers : (d : ℕ) → Run (Vector ℝ (d + 1))
  | 0 => collect (fun _ : Fin 1 => pure (1 : ℝ))
  | d + 1 => do
      let previous ← inversePowers d
      let last ← StoredGivens.read previous (Fin.last d)
      let next ← StoredGivens.div last 2
      StoredHermiteCoefficients.extend previous next

theorem inversePowers_value (d : ℕ) (i : Fin (d + 1)) :
    (inversePowers d).value[i.val] = 1 / (2 : ℝ) ^ i.val := by
  induction d with
  | zero =>
      have hi : i = 0 := Fin.eq_zero i
      subst i
      simp [inversePowers, pure, Run.pure, collect]
  | succ d ih =>
      simp only [inversePowers, bind, Run.bind, StoredGivens.read,
        StoredGivens.div, charge, StoredHermiteCoefficients.extend_value]
      split_ifs with h
      · exact ih ⟨i.val, h⟩
      · have hi : i.val = d + 1 := by omega
        rw [ih (Fin.last d), hi]
        simp [pow_succ, div_eq_mul_inv, mul_comm]

structure Tables (d : ℕ) where
  falseTable : StoredMatrix (d + 1) (d + 1)
  trueTable : StoredMatrix (d + 1) (d + 1)

noncomputable def falseEntry {d : ℕ} (F H : Vector ℝ (d + 1))
    (i j : Fin (d + 1)) : Run ℝ := do
  let _ ← charge .compare ()
  if h : i.val ≤ j.val then do
    let binomial ← StoredHermiteCoefficients.chooseFrom F j.val i.val h (by omega)
    let power ← StoredGivens.read H j
    StoredGivens.mul binomial power
  else pure 0

noncomputable def trueEntry {d : ℕ} (F H : Vector ℝ (d + 1))
    (i j : Fin (d + 1)) : Run ℝ := do
  let _ ← charge .compare ()
  if h : j.val ≤ i.val then do
    let binomial ← StoredHermiteCoefficients.chooseFrom F (d - j.val)
      (i.val - j.val) (by omega) (by omega)
    let power ← StoredGivens.read H ⟨d - j.val, by omega⟩
    StoredGivens.mul binomial power
  else pure 0

theorem falseEntry_value {d : ℕ} (F H : Vector ℝ (d + 1))
    (hF : ∀ i : Fin (d + 1), F[i.val] = (i.val.factorial : ℝ))
    (hH : ∀ i : Fin (d + 1), H[i.val] = 1 / (2 : ℝ) ^ i.val)
    (i j : Fin (d + 1)) : (falseEntry F H i j).value = sharedCore d false i j := by
  rw [sharedCore_false]
  by_cases h : i.val ≤ j.val
  · simp [falseEntry, h, bind, Run.bind, charge,
      StoredHermiteCoefficients.chooseFrom_value F hF, StoredGivens.read,
      StoredGivens.mul, hH, div_eq_mul_inv]
  · simp [falseEntry, h, bind, pure, Run.bind, Run.pure, charge]

theorem trueEntry_value {d : ℕ} (F H : Vector ℝ (d + 1))
    (hF : ∀ i : Fin (d + 1), F[i.val] = (i.val.factorial : ℝ))
    (hH : ∀ i : Fin (d + 1), H[i.val] = 1 / (2 : ℝ) ^ i.val)
    (i j : Fin (d + 1)) : (trueEntry F H i j).value = sharedCore d true i j := by
  rw [sharedCore_true]
  by_cases h : j.val ≤ i.val
  · have hh := hH ⟨d - j.val, by omega⟩
    simp [trueEntry, h, bind, Run.bind, charge,
      StoredHermiteCoefficients.chooseFrom_value F hF, StoredGivens.read,
      StoredGivens.mul, hh, div_eq_mul_inv]
  · simp [trueEntry, h, bind, pure, Run.bind, Run.pure, charge]

/-- Both tables share a single factorial table and a single inverse-power table. -/
noncomputable def compile (d : ℕ) : Run (Tables d) := do
  let F ← StoredHermiteCoefficients.factorials d
  let H ← inversePowers d
  let left ← materialize (falseEntry F.values H)
  let right ← materialize (trueEntry F.values H)
  pure ⟨left, right⟩

theorem compile_false (d : ℕ) :
    denote (compile d).value.falseTable = sharedCore d false := by
  ext i j
  simp only [compile, bind, pure, Run.bind, Run.pure, denote, materialize, collect_value]
  exact falseEntry_value _ _ (StoredHermiteCoefficients.factorials_value d)
    (inversePowers_value d) i j

theorem compile_true (d : ℕ) :
    denote (compile d).value.trueTable = sharedCore d true := by
  ext i j
  simp only [compile, bind, pure, Run.bind, Run.pure, denote, materialize, collect_value]
  exact trueEntry_value _ _ (StoredHermiteCoefficients.factorials_value d)
    (inversePowers_value d) i j

def withCost (extra : Cost) (result : Run α) : Run α :=
  ⟨result.value, extra + result.cost⟩

theorem withCost_value (extra : Cost) (result : Run α) :
    (withCost extra result).value = result.value := rfl

theorem withCost_cost (extra : Cost) (result : Run α) (op : Op) :
    (withCost extra result).cost op = extra op + result.cost op := rfl

/-- Parameter arithmetic is an explicit, separately reusable supplier. -/
noncomputable def shiftedRestriction {d : ℕ} (xs : Vector ℝ (d + 1))
    (childLower childUpper : ℝ) : Run (Vector ℝ (d + 1)) :=
  let u := StoredGivens.add 1 childLower
  let v := StoredGivens.add 1 childUpper
  withCost (u.cost + v.cost) (StoredBernstein.restrict xs u.value v.value)

theorem shiftedRestriction_value {d : ℕ} (xs : Vector ℝ (d + 1)) (c : ℕ → ℝ)
    (hx : ∀ i : Fin (d + 1), xs[i.val] = c i.val)
    (a b : ℝ) (i : Fin (d + 1)) :
    (shiftedRestriction xs a b).value[i.val] =
      HermiteBernstein.restrictCoefficients d (1 + a) (1 + b) c i.val := by
  rw [shiftedRestriction, withCost_value]
  simp only [StoredGivens.add, charge]
  exact StoredBernstein.restrict_value xs c hx (1 + a) (1 + b) i

theorem shiftedRestriction_cost {d : ℕ} (xs : Vector ℝ (d + 1)) (a b : ℝ) (op : Op) :
    (shiftedRestriction xs a b).cost op =
      2 * tick .field op + (StoredBernstein.restrict xs (1 + a) (1 + b)).cost op := by
  simp only [shiftedRestriction, withCost, StoredGivens.add, charge, Pi.add_apply]
  omega

/-- Cached coordinates are real inputs. Their source construction is separate.
The guard is supplied by geometry; it is charged as a control comparison here.
Disabled rows still have all zero entries explicitly materialized. -/
noncomputable def injectionRow {d : ℕ} (xs : Vector ℝ (d + 1))
    (childLower childUpper : ℝ) (enabled : Bool) : Run (Vector ℝ (d + 1)) :=
  withCost (tick .compare) (if enabled then shiftedRestriction xs childLower childUpper
    else collect (fun _ => pure 0))

theorem injectionRow_value {d : ℕ} (xs : Vector ℝ (d + 1)) (c : ℕ → ℝ)
    (hx : ∀ i : Fin (d + 1), xs[i.val] = c i.val)
    (childLower childUpper : ℝ) (enabled : Bool) (i : Fin (d + 1)) :
    (injectionRow xs childLower childUpper enabled).value[i.val] =
      if enabled then HermiteBernstein.restrictCoefficients d
        (1 + childLower) (1 + childUpper) c i.val else 0 := by
  rw [injectionRow, withCost_value]
  cases enabled
  · change (collect (fun _ : Fin (d + 1) => pure (0 : ℝ))).value[i.val] = 0
    exact collect_value _ i
  · simp only [if_true]
    exact shiftedRestriction_value xs c hx childLower childUpper i

/-- Strong row refinement, with a previously stored source coefficient vector.
No source coefficients, dyadic addresses, or real coordinates are regenerated.
Geometry separately certifies the valid restriction domain when interpreting
this row as a polynomial; algebraic equality of the returned entries is total. -/
theorem injectionRow_eq_injectionCore (k : ℕ) (xs : Vector ℝ (2 * k + 1 + 1))
    (hx : ∀ i : Fin (2 * k + 1 + 1),
      xs[i.val] = HermiteBernstein.sourceBernsteinCoefficient k i.val)
    (origin step : ℝ) (lower upper : ℕ) (schedule : ℕ → ℕ) (r : ℕ) (bit : Bool)
    (childLower childUpper : ℝ) (enabled : Bool)
    (hl : childLower = affinePoint origin step (selectedChild schedule r bit))
    (hu : childUpper = affinePoint origin step (selectedChild schedule r bit + 2 ^ r))
    (he : enabled = true ↔ Full lower upper (selectedChild schedule r bit) (2 ^ r))
    (i : Fin (2 * k + 1 + 1)) :
    (injectionRow xs childLower childUpper enabled).value[i.val] =
      injectionCore k origin step lower upper schedule r bit none (some i) := by
  rw [injectionRow_value xs _ hx, hl, hu]
  simp only [injectionCore, blockInjectionRow, he]

private theorem tick_le_one (a b : Op) : tick a b ≤ 1 := by
  unfold tick
  split <;> omega

private theorem collect_cost_le {n : ℕ} (f : Fin n → Run α) (op : Op) (B : ℕ)
    (bound : ∀ i, (f i).cost op ≤ B) : (collect f).cost op ≤ n * (B + 4) := by
  rw [collect_cost]
  have hs : (∑ i : Fin n, (f i).cost op) ≤ n * B := by
    calc
      _ ≤ ∑ _i : Fin n, B := Finset.sum_le_sum (fun i _ => bound i)
      _ = _ := by simp
  have hr := tick_le_one .read op
  have hw := tick_le_one .write op
  nlinarith

theorem inversePowers_cost_le (d : ℕ) (op : Op) :
    (inversePowers d).cost op ≤ 8 * (d + 1) ^ 2 := by
  induction d with
  | zero =>
      have hr := tick_le_one .read op
      have hw := tick_le_one .write op
      simp [inversePowers, pure, Run.pure, collect_cost]
      omega
  | succ d ih =>
      have he := StoredHermiteCoefficients.extend_cost_le (inversePowers d).value
        ((inversePowers d).value[d] / 2) op
      have hr := tick_le_one .read op
      have hf := tick_le_one .field op
      simp only [inversePowers, bind, Run.bind, StoredGivens.read,
        StoredGivens.div, charge, Pi.add_apply]
      nlinarith

theorem falseEntry_cost_le {d : ℕ} (F H : Vector ℝ (d + 1))
    (i j : Fin (d + 1)) (op : Op) : (falseEntry F H i j).cost op ≤ 8 := by
  have hr := tick_le_one .read op
  have hf := tick_le_one .field op
  have hc := tick_le_one .compare op
  by_cases h : i.val ≤ j.val <;>
    simp [falseEntry, h, bind, pure, Run.bind, Run.pure, charge,
      StoredHermiteCoefficients.chooseFrom_cost, StoredGivens.read,
      StoredGivens.mul, Pi.add_apply] <;> omega

theorem trueEntry_cost_le {d : ℕ} (F H : Vector ℝ (d + 1))
    (i j : Fin (d + 1)) (op : Op) : (trueEntry F H i j).cost op ≤ 8 := by
  have hr := tick_le_one .read op
  have hf := tick_le_one .field op
  have hc := tick_le_one .compare op
  by_cases h : j.val ≤ i.val <;>
    simp [trueEntry, h, bind, pure, Run.bind, Run.pure, charge,
      StoredHermiteCoefficients.chooseFrom_cost, StoredGivens.read,
      StoredGivens.mul, Pi.add_apply] <;> omega

private theorem materialize_cost_le {d : ℕ} (f : Fin (d + 1) → Fin (d + 1) → Run ℝ)
    (op : Op) (bound : ∀ i j, (f i j).cost op ≤ 8) :
    (materialize f).cost op ≤ 16 * (d + 1) ^ 2 := by
  have h := collect_cost_le (fun i => collect (f i)) op ((d + 1) * 12)
    (fun i => collect_cost_le (f i) op 8 (bound i))
  change (collect _).cost op ≤ _
  nlinarith

/-- Quadratic per-counter bound of the actual two-table producer. -/
theorem compile_cost_le (d : ℕ) (op : Op) :
    (compile d).cost op ≤ 50 * (d + 1) ^ 2 := by
  have hf := StoredHermiteCoefficients.factorials_cost_le d op
  have hp := inversePowers_cost_le d op
  have hl := materialize_cost_le
    (falseEntry (StoredHermiteCoefficients.factorials d).value.values (inversePowers d).value)
    op (fun i j => falseEntry_cost_le _ _ i j op)
  have hr := materialize_cost_le
    (trueEntry (StoredHermiteCoefficients.factorials d).value.values (inversePowers d).value)
    op (fun i j => trueEntry_cost_le _ _ i j op)
  simp only [compile, bind, pure, Run.bind, Run.pure, Pi.add_apply, add_zero]
  omega

theorem compile_total_cost_le (d : ℕ) :
    StoredRectangularGivens.total (compile d).cost ≤ 400 * (d + 1) ^ 2 := by
  have h1 := compile_cost_le d .field
  have h2 := compile_cost_le d .sqrt
  have h3 := compile_cost_le d .angle
  have h4 := compile_cost_le d .trig
  have h5 := compile_cost_le d .compare
  have h6 := compile_cost_le d .read
  have h7 := compile_cost_le d .write
  have h8 := compile_cost_le d .emit
  simp only [StoredRectangularGivens.total]
  omega

theorem injectionRow_cost_le {d : ℕ} (xs : Vector ℝ (d + 1))
    (childLower childUpper : ℝ) (enabled : Bool) (op : Op) :
    (injectionRow xs childLower childUpper enabled).cost op ≤
      2 * StoredBernstein.edgeBudget d op + 5 * tick .field op +
        tick .compare op := by
  cases enabled
  · simp only [injectionRow, withCost_cost, Bool.false_eq_true, if_false, collect_cost,
      pure, Run.pure, Pi.zero_apply, Finset.sum_const_zero, zero_add]
    have base : 2 * tick .read op + 2 * tick .write op ≤
        2 * (d * StoredBernstein.rowBudget (d + 1) op +
          3 * tick .read op + 2 * tick .write op) := by omega
    have h := Nat.mul_le_mul_left (d + 1) base
    unfold StoredBernstein.edgeBudget
    nlinarith
  · have h := StoredBernstein.restrict_cost_le xs (1 + childLower) (1 + childUpper) op
    simp only [injectionRow, withCost_cost, if_true, shiftedRestriction_cost]
    omega

theorem injectionRow_total_cost_le {d : ℕ} (xs : Vector ℝ (d + 1))
    (childLower childUpper : ℝ) (enabled : Bool) :
    StoredRectangularGivens.total (injectionRow xs childLower childUpper enabled).cost ≤
      20 * d ^ 3 + 42 * d ^ 2 + 32 * d + 16 := by
  have hf := injectionRow_cost_le xs childLower childUpper enabled .field
  have hs := injectionRow_cost_le xs childLower childUpper enabled .sqrt
  have ha := injectionRow_cost_le xs childLower childUpper enabled .angle
  have ht := injectionRow_cost_le xs childLower childUpper enabled .trig
  have hc := injectionRow_cost_le xs childLower childUpper enabled .compare
  have hr := injectionRow_cost_le xs childLower childUpper enabled .read
  have hw := injectionRow_cost_le xs childLower childUpper enabled .write
  have he := injectionRow_cost_le xs childLower childUpper enabled .emit
  simp [StoredBernstein.edgeBudget, StoredBernstein.rowBudget, tick] at hf hs ha ht hc hr hw he
  simp only [StoredRectangularGivens.total]
  nlinarith

end QuantumBlockEncoding.StoredHermiteSharedTables
