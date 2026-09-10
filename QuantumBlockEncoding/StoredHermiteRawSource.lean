import QuantumBlockEncoding.StoredHermiteStageInput
import QuantumBlockEncoding.StoredHermiteBoundaries
import QuantumBlockEncoding.StoredMatrixProductChain

/-!
actual stored raw-source assembly. Every source cache, stage,
field table and boundary contraction is produced once and its returned work
ledger is composed. Semantic kernels appear only in refinement statements.
Ordinary operations and exponential calls retain the upstream exact-real
model; the additional integer counters cover only their named operations,
not complete machine or finite-bit runtime. No normalization is performed.
-/

namespace QuantumBlockEncoding.StoredHermiteRawSource

open StoredGivens StoredTensorTrain StoredHermiteCoefficients
open scoped BigOperators

structure StageRun (α : Type) extends SourceRun α where
  integerAdditions : ℕ

noncomputable def stage {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n)
    (t : Fin (n+1)) : StageRun (StoredCore (2*k+6) (2*k+6)) :=
  let input := StoredHermiteStageInput.input cache t
  let fields := StoredHermiteStageFields.two input.run.value t.val
  let core := StoredHermiteKernelTable.assemble fields.run.value
  { run := ⟨core.value, input.run.cost + fields.run.cost + core.cost⟩
    exponentialCalls := fields.exponentialCalls
    integerAdditions := input.integerAdditions }

theorem stage_source (k n : ℕ) (L : ℝ) (hL : 0 < L) (t : Fin (n+1))
    (a : Fin (2*k+6)) (out : Fin 2 × Fin (2*k+6)) :
    denoteCore (stage (StoredHermiteSourceCache.compile k n L).run.value t).run.value a out =
      HermiteExplicitBond.kernel k n L t.val out.1 a out.2 := by
  apply StoredHermiteKernelTable.assemble_source
  intro bit
  exact StoredHermiteStageFields.two_source _ t L
    (StoredHermiteStageInput.inputCorrect k n L hL t) bit

/-- Materialize the stage records once, then project cores and their ledgers.
The full records are not recomputed when integer/exp counters are summed. -/
def collectStages {m : ℕ} (f : Fin m → StageRun α) : StageRun (Vector α m) :=
  let entries : Vector (StageRun α) m := Vector.ofFn f
  let projected := collect fun i => do
    let entry ← read entries i
    pure entry.run.value
  { run := ⟨projected.value,
      (fun op => ∑ i : Fin m, entries[i.val].run.cost op) +
        m • tick .write + projected.cost⟩
    exponentialCalls := ∑ i : Fin m, entries[i.val].exponentialCalls
    integerAdditions := ∑ i : Fin m, entries[i.val].integerAdditions }

theorem collectStages_value {m : ℕ} (f : Fin m → StageRun α) (i : Fin m) :
    (collectStages f).run.value[i.val] = (f i).run.value := by
  simp [collectStages, collect_value, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge]

noncomputable def tables {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) :
    StageRun (Vector (StoredCore (2*k+6) (2*k+6)) (n+1)) := collectStages (stage cache)

theorem tables_window (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    StoredMatrixProductChain.Window
      (tables (StoredHermiteSourceCache.compile k n L).run.value).run.value
      (HermiteExplicitBond.kernel k n L) 0 := by
  apply StoredMatrixProductChain.window_of_entries
  intro t a b bit
  simp only [tables, collectStages_value, Nat.zero_add]
  exact stage_source k n L hL t a (bit,b)

def boundaryInputs {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) : Run (ℕ × ℕ) := do
  let tails ← charge .read cache.tails
  let cut ← charge .read tails.cutoff
  let spans ← charge .read cache.spans
  let midpoint ← read spans (Fin.last n)
  pure (cut, midpoint)

def boundaries {k n : ℕ} (cache : StoredHermiteSourceCache.Cache k n) :
    Run (Vector ℝ (2*k+6) × Vector ℝ (2*k+6)) := do
  let params ← boundaryInputs cache
  let left ← StoredHermiteBoundaries.initial k params.1 params.2
  let right ← StoredHermiteBoundaries.terminal k
  pure (left, right)

theorem boundaries_initial (k n : ℕ) (L : ℝ) (hL : 0 < L) (i : Fin (2*k+6)) :
    (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.1[i.val] =
      HermiteExplicitBond.initial k n L i := by
  change (StoredHermiteBoundaries.initial k
    (StoredHermiteSourceCache.compile k n L).run.value.tails.cutoff
    (StoredHermiteSourceCache.compile k n L).run.value.spans[n]).value[i.val] = _
  rw [StoredHermiteBoundaries.initial_get]
  have hmid := StoredHermiteSourceCache.compile_spans k n L (Fin.last n)
  simp only [Fin.val_last] at hmid
  rw [hmid]
  simpa only [StoredHermiteBoundaries.initial_get] using
    StoredHermiteBoundaries.initial_value k n L _
      (StoredHermiteSourceCache.compile_tails k n L hL).1 i

theorem boundaries_terminal (k n : ℕ) (L : ℝ) (i : Fin (2*k+6)) :
    (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.2[i.val] =
      HermiteExplicitBond.terminal k i :=
  StoredHermiteBoundaries.terminal_value k i

structure RawRun (α : Type) extends StoredHermiteSourceCache.CacheRun α where
  integerAdditions : ℕ

noncomputable def raw (k n : ℕ) (L : ℝ) : RawRun (StoredChain (n+1) 1 1) :=
  let cache := StoredHermiteSourceCache.compile k n L
  let cores := tables cache.run.value
  let ends := boundaries cache.run.value
  let chain := StoredMatrixProductChain.ofTable cores.run.value ends.value.1 ends.value.2
  { run := ⟨chain.value, cache.run.cost + cores.run.cost + ends.cost + chain.cost⟩
    exponentialCalls := cache.exponentialCalls + cores.exponentialCalls
    quotientCalls := cache.quotientCalls
    remainderCalls := cache.remainderCalls
    integerDoublings := cache.integerDoublings
    integerAdditions := cores.integerAdditions }

theorem raw_value (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    denoteChain (raw k n L).run.value = HermiteExplicitBond.rawSourceChain k n L := by
  change denoteChain (StoredMatrixProductChain.ofTable
    (tables (StoredHermiteSourceCache.compile k n L).run.value).run.value
    (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.1
    (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.2).value = _
  rw [StoredMatrixProductChain.ofTable_refines _ _ _ _ 0 (tables_window k n L hL)]
  have hl : (fun i => (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.1[i.val]) =
      HermiteExplicitBond.initial k n L := funext (boundaries_initial k n L hL)
  have hr : (fun i => (boundaries (StoredHermiteSourceCache.compile k n L).run.value).value.2[i.val]) =
      HermiteExplicitBond.terminal k := funext (boundaries_terminal k n L)
  rw [hl, hr]
  rfl

theorem raw_contract (k n : ℕ) (L : ℝ) (hL : 0 < L)
    (x : TensorTrainCanonical.Word (n+1)) :
    TensorTrainCanonical.contract (denoteChain (raw k n L).run.value) x 0 0 =
      HermiteStatePreparation.sampledAmplitude k (n+1) L (TensorTrainWord.sampleEquiv (n+1) x) := by
  rw [raw_value k n L hL]
  exact HermiteExplicitBond.rawSourceChain_contract k n L hL x

end QuantumBlockEncoding.StoredHermiteRawSource
