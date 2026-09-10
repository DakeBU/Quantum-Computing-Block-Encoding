import QuantumBlockEncoding.StoredHermiteRawSource

/-!
same-producer work certificate for StoredHermiteRawSource.raw.
This module does not construct a second raw chain or change any supplier.
The ordinary budget includes all stored cache, stage, two-bit field, core,
boundary and chain operations, including the collectStages projection passes.
Exponential and selected integer counters are read from the same RawRun.

Integer quotient/remainder/doubling/addition counts retain the exact supplier
scope: they do not count every index operation, arbitrary-precision bit work,
proof checking or ledger bookkeeping. No finite-bit runtime or normalized
state-preparation compiler claim is made here.
-/

namespace QuantumBlockEncoding.StoredHermiteRawCost

open StoredGivens StoredTensorTrain StoredHermiteRawSource
open scoped BigOperators

def ordinary (cost : Cost) : ℕ := ∑ op : Op, cost op

/-- Eight-operation enumeration adapter; no producer or counter is altered. -/
theorem ordinary_eq_total (cost : Cost) :
    ordinary cost = StoredRectangularGivens.total cost := by
  have enum : (Finset.univ : Finset Op) =
      {.field, .sqrt, .angle, .trig, .compare, .read, .write, .emit} := by decide
  simp [ordinary, enum, StoredRectangularGivens.total]
  omega

theorem ordinary_add (a b : Cost) : ordinary (a+b) = ordinary a + ordinary b := by
  simp [ordinary, Pi.add_apply, Finset.sum_add_distrib]

theorem ordinary_zero : ordinary 0 = 0 := by simp [ordinary]

theorem ordinary_tick (op : Op) : ordinary (tick op) = 1 := by simp [ordinary, tick]

def stageBudget (k : ℕ) : ℕ :=
  40*(2*k+1)^3 + 84*(2*k+1)^2 + 64*(2*k+1) + 194 + 576*(2*k+6)^2

theorem stage_total_cost_le {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : ordinary (stage cache t).run.cost ≤ stageBudget k := by
  have hi : ordinary (StoredHermiteStageInput.input cache t).run.cost = 86 :=
    StoredHermiteStageInput.input_total_cost cache t
  have hf : ordinary (StoredHermiteStageFields.two
      (StoredHermiteStageInput.input cache t).run.value t.val).run.cost ≤
      40*(2*k+1)^3 + 84*(2*k+1)^2 + 64*(2*k+1) + 108 := by
    rw [ordinary_eq_total]
    exact StoredHermiteStageFields.two_total_cost_le _ _
  have hk : ordinary (StoredHermiteKernelTable.assemble
      (StoredHermiteStageFields.two (StoredHermiteStageInput.input cache t).run.value
        t.val).run.value).cost ≤ 576*(2*k+6)^2 :=
    StoredHermiteKernelTable.assemble_total_cost_le _
  simp only [stage, ordinary_add]
  rw [hi]
  calc
    _ ≤ 86 + (40*(2*k+1)^3 + 84*(2*k+1)^2 + 64*(2*k+1) + 108) +
        576*(2*k+6)^2 := Nat.add_le_add (Nat.add_le_add_left hf 86) hk
    _ = _ := by unfold stageBudget; ring

theorem stage_exponentialCalls {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) :
    (stage cache t).exponentialCalls = ∑ bit : Fin 2,
      if ((StoredHermiteStageInput.input cache t).run.value.children[bit.val]).leftFull
        then 1 else 0 := by
  simp only [stage, StoredHermiteStageFields.two,
    StoredHermiteStageFields.collectSource_exponentialCalls,
    StoredHermiteStageFields.one_exponentialCalls]

theorem stage_exponentialCalls_le {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : (stage cache t).exponentialCalls ≤ 2 :=
  StoredHermiteStageFields.two_exponentialCalls_le _ _

theorem stage_integerAdditions {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : (stage cache t).integerAdditions = 4 :=
  StoredHermiteStageInput.input_integerAdditions cache t

/-- The ledger table is materialized once. Its projection adds exactly three
reads and three writes per stage, including its initial stored record. -/
theorem collectStages_cost {m : ℕ} (f : Fin m → StageRun α) (op : Op) :
    (collectStages f).run.cost op = (∑ i : Fin m, (f i).run.cost op) +
      m * (3*tick .read op + 3*tick .write op) := by
  simp [collectStages, collect_cost, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge]
  ring

theorem collectStages_total_cost {m : ℕ} (f : Fin m → StageRun α) :
    ordinary (collectStages f).run.cost =
      (∑ i : Fin m, ordinary (f i).run.cost) + 6*m := by
  simp only [ordinary, collectStages_cost, Finset.sum_add_distrib]
  rw [Finset.sum_comm]
  have ht (op : Op) : (∑ q : Op, tick op q) = 1 := by simp [tick]
  simp only [← Finset.mul_sum, Finset.sum_add_distrib, ht]
  ring

theorem collectStages_exponentialCalls {m : ℕ} (f : Fin m → StageRun α) :
    (collectStages f).exponentialCalls = ∑ i : Fin m, (f i).exponentialCalls := by
  simp [collectStages]

theorem collectStages_integerAdditions {m : ℕ} (f : Fin m → StageRun α) :
    (collectStages f).integerAdditions = ∑ i : Fin m, (f i).integerAdditions := by
  simp [collectStages]

theorem tables_total_cost_le {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) :
    ordinary (tables cache).run.cost ≤ (n+1)*(stageBudget k + 6) := by
  rw [tables, collectStages_total_cost]
  have h : (∑ t : Fin (n+1), ordinary (stage cache t).run.cost) ≤
      (n+1)*stageBudget k := by
    have h := Finset.sum_le_sum
      (fun t (_ : t ∈ Finset.univ) => stage_total_cost_le cache t)
    simpa using h
  calc
    _ ≤ (n+1)*stageBudget k + 6*(n+1) := Nat.add_le_add_right h _
    _ = _ := by ring

theorem tables_exponentialCalls_le {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) :
    (tables cache).exponentialCalls ≤ 2*(n+1) := by
  rw [tables, collectStages_exponentialCalls]
  have h := Finset.sum_le_sum
    (fun t (_ : t ∈ Finset.univ) => stage_exponentialCalls_le cache t)
  simpa [Nat.mul_comm] using h

theorem tables_integerAdditions {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) :
    (tables cache).integerAdditions = 4*(n+1) := by
  simp [tables, collectStages_integerAdditions, stage_integerAdditions, Nat.mul_comm]

theorem boundaryInputs_cost {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) (op : Op) :
    (boundaryInputs cache).cost op = 4*tick .read op := by
  simp [boundaryInputs, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge]
  ring

theorem boundaries_total_cost {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) :
    ordinary (boundaries cache).cost = 32*(2*k+6)+6 := by
  rw [ordinary_eq_total]
  simp [boundaries, bind, pure, Run.bind, Run.pure, StoredRectangularGivens.total,
    boundaryInputs_cost, StoredHermiteBoundaries.initial_cost,
    StoredHermiteBoundaries.terminal_cost, tick]
  ring

def rawBudget (k n : ℕ) : ℕ :=
  3200*(k+1)^2 + 256*(n+1)^2 +
    (n+1)*(40*(2*k+1)^3 + 84*(2*k+1)^2 + 64*(2*k+1) + 200 + 576*(2*k+6)^2) +
    20*(2*k+6)^2 + 62*(2*k+6) + 5*n^2 + 7*n + 37

/-- Every summand is a proved cost of a subrun actually used by raw. No
dimension-only or hypothetical source-entry budget is substituted. -/
theorem raw_total_cost_le (k n : ℕ) (L : ℝ) :
    ordinary (raw k n L).run.cost ≤ rawBudget k n := by
  have hc : ordinary (StoredHermiteSourceCache.compile k n L).run.cost ≤
      3200*(k+1)^2 + 256*(n+1)^2 := StoredHermiteSourceCache.compile_total_cost_le k n L
  have ht := tables_total_cost_le (StoredHermiteSourceCache.compile k n L).run.value
  have he := boundaries_total_cost (StoredHermiteSourceCache.compile k n L).run.value
  have hchain : ordinary (StoredMatrixProductChain.ofTable
      (tables (StoredHermiteSourceCache.compile k n L).run.value).run.value
      (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.1
      (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.2).cost ≤
        20*(2*k+6)^2 + 30*(2*k+6) + 5*n^2 + 7*n + 31 := by
    rw [ordinary_eq_total]
    exact StoredMatrixProductChain.ofTable_total_cost_le _ _ _
  simp only [raw, ordinary_add]
  rw [he]
  calc
    _ ≤ (3200*(k+1)^2 + 256*(n+1)^2) + (n+1)*(stageBudget k+6) +
        (32*(2*k+6)+6) + (20*(2*k+6)^2+30*(2*k+6)+5*n^2+7*n+31) :=
      Nat.add_le_add (Nat.add_le_add_right (Nat.add_le_add hc ht) _) hchain
    _ = _ := by unfold stageBudget rawBudget; ring

theorem raw_stored_total_cost_le (k n : ℕ) (L : ℝ) :
    StoredRectangularGivens.total (raw k n L).run.cost ≤ rawBudget k n := by
  rw [← ordinary_eq_total]
  exact raw_total_cost_le k n L

theorem raw_cost_le (k n : ℕ) (L : ℝ) (op : Op) :
    (raw k n L).run.cost op ≤ rawBudget k n := by
  calc
    _ ≤ ordinary (raw k n L).run.cost :=
      Finset.single_le_sum (fun _ _ => Nat.zero_le _) (Finset.mem_univ op)
    _ ≤ _ := raw_total_cost_le k n L

/-- Exact exponential ledger: one coefficient call, n+1 cached tail calls,
and the actual stage injection calls (zero on disabled Full guards). -/
theorem raw_exponentialCalls (k n : ℕ) (L : ℝ) :
    (raw k n L).exponentialCalls = n+2 + ∑ t : Fin (n+1),
      (stage (StoredHermiteSourceCache.compile k n L).run.value t).exponentialCalls := by
  simp only [raw, StoredHermiteSourceCache.compile_exponentialCalls,
    tables, collectStages_exponentialCalls]

theorem raw_exponentialCalls_le (k n : ℕ) (L : ℝ) :
    (raw k n L).exponentialCalls ≤ 3*(n+1)+1 := by
  have h := tables_exponentialCalls_le (StoredHermiteSourceCache.compile k n L).run.value
  simp only [raw, StoredHermiteSourceCache.compile_exponentialCalls]
  omega

theorem raw_quotientCalls (k n : ℕ) (L : ℝ) :
    (raw k n L).quotientCalls = (n+1)*(n+2) :=
  StoredHermiteSourceCache.compile_quotientCalls k n L

theorem raw_remainderCalls (k n : ℕ) (L : ℝ) :
    (raw k n L).remainderCalls = (n+1)^2 :=
  StoredHermiteSourceCache.compile_remainderCalls k n L

theorem raw_integerDoublings (k n : ℕ) (L : ℝ) :
    (raw k n L).integerDoublings = n :=
  StoredHermiteSourceCache.compile_integerDoublings k n L

theorem raw_integerAdditions (k n : ℕ) (L : ℝ) :
    (raw k n L).integerAdditions = 4*(n+1) :=
  tables_integerAdditions _

/-- Sum of precisely the four named integer counters, not all integer work. -/
theorem raw_selected_integer_total (k n : ℕ) (L : ℝ) :
    (raw k n L).quotientCalls + (raw k n L).remainderCalls +
      (raw k n L).integerDoublings + (raw k n L).integerAdditions = 2*n^2+10*n+7 := by
  rw [raw_quotientCalls, raw_remainderCalls, raw_integerDoublings, raw_integerAdditions]
  ring

/-- Same-run source equality, polynomial ordinary work, exponential cap, and
the four accurately scoped integer counters. This is an unnormalized source. -/
theorem raw_certified (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    let result := raw k n L
    denoteChain result.run.value = HermiteExplicitBond.rawSourceChain k n L ∧
    ordinary result.run.cost ≤ rawBudget k n ∧
    result.exponentialCalls ≤ 3*(n+1)+1 ∧
    result.quotientCalls = (n+1)*(n+2) ∧ result.remainderCalls = (n+1)^2 ∧
    result.integerDoublings = n ∧ result.integerAdditions = 4*(n+1) :=
  ⟨raw_value k n L hL, raw_total_cost_le k n L, raw_exponentialCalls_le k n L,
    raw_quotientCalls k n L, raw_remainderCalls k n L,
    raw_integerDoublings k n L, raw_integerAdditions k n L⟩

end QuantumBlockEncoding.StoredHermiteRawCost
