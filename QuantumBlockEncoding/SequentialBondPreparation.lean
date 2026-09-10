import QuantumBlockEncoding.RealAmplitudePreparation

/-!
# Sequential finite-bond state action

A stage acts on a fresh zero bit and a finite, padded bond register. Previously
emitted bits are passive. The new bit is appended at the highest wire, so the
emission order is wire 0, wire 1, and so on. Matrix rows are output indices.

This module proves the finite-sum bridge from such local matrix actions to
tensor-core contraction, including exact terminal-bond cleanup. It does not
construct Hermite cores, their orthogonalization, or a primitive compiler.
The local clean-column equality required by `run_eq_transfer` remains a
separate obligation for each concrete small-isometry circuit.

`run` is recursive matrix action with fresh-zero wires. A separate wire-placement
bridge is needed to identify it with one flattened `PrimitiveCircuit (n + q)`;
no synthesis algorithm, preprocessing complexity, or gate-count claim is made here.
-/

namespace QuantumBlockEncoding.SequentialBondPreparation

open scoped Kronecker
open RealAmplitudePreparation

variable {B : Type*} [Fintype B] [DecidableEq B]

/-- A core emits one bit and changes the bond. -/
abbrev Core (B : Type*) := _root_.Matrix (Fin 2 × B) B ℂ

/-- The square, full local matrix; its nonzero-bit input columns are not
specified by a tensor core and must be supplied by an actual completion. -/
abbrev Stage (B : Type*) := _root_.Matrix (Fin 2 × B) (Fin 2 × B) ℂ

/-- State amplitudes after exactly `n` output bits have been emitted. -/
abbrev BondState (n : Nat) (B : Type*) := PrimitiveBasis n × B → ℂ

/-- Add the next output bit in zero, without changing any existing amplitude. -/
def freshZero {n : Nat} (v : BondState n B) :
    PrimitiveBasis n × (Fin 2 × B) → ℂ :=
  fun x => if x.2.1 = 0 then v (x.1, x.2.2) else 0

/-- Local stage tensored with the identity on all already emitted bits. -/
noncomputable def liftStage (n : Nat) (U : Stage B) :
    _root_.Matrix (PrimitiveBasis n × (Fin 2 × B))
      (PrimitiveBasis n × (Fin 2 × B)) ℂ :=
  (1 : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ) ⊗ₖ U

omit [Fintype B] [DecidableEq B] in
@[simp] theorem liftStage_apply (n : Nat) (U : Stage B)
    (r c : PrimitiveBasis n × (Fin 2 × B)) :
    liftStage n U r c = if r.1 = c.1 then U r.2 c.2 else 0 := by
  simp [liftStage, _root_.Matrix.one_apply, ite_mul]

/-- A genuine matrix-vector action followed only by a basis regrouping. -/
noncomputable def step {n : Nat} (U : Stage B) (v : BondState n B) :
    BondState (n + 1) B := fun x =>
  ((liftStage n U).mulVec (freshZero v))
    (Fin.init x.1, (x.1 (Fin.last n), x.2))

omit [DecidableEq B] in
/-- Only the clean-input columns of a local stage affect an emitted state.
The sum over passive prefixes and fresh-bit inputs collapses exactly. -/
theorem step_apply {n : Nat} (U : Stage B) (v : BondState n B)
    (x : PrimitiveBasis (n + 1)) (b : B) :
    step U v (x, b) =
      ∑ a, U (x (Fin.last n), b) (0, a) * v (Fin.init x, a) := by
  simp [step, _root_.Matrix.mulVec, dotProduct, Fintype.sum_prod_type, freshZero]

/-- Unitarity of the full local completion gives unitarity after adding
arbitrarily many passive emitted wires. -/
theorem liftStage_unitary (n : Nat) (U : Stage B)
    (hU : U ∈ _root_.Matrix.unitaryGroup (Fin 2 × B) ℂ) :
    liftStage n U ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis n × (Fin 2 × B)) ℂ := by
  apply _root_.Matrix.kronecker_mem_unitary
  · exact (_root_.Matrix.unitaryGroup (PrimitiveBasis n) ℂ).one_mem
  · exact hU

/-- Fixing an emitted bit leaves a bond-to-bond transfer matrix. -/
def coreSlice (K : Core B) (bit : Fin 2) : _root_.Matrix B B ℂ :=
  fun b a => K (bit, b) a

/-- Chronological tensor contraction. The last emitted core multiplies on
the left, in the same convention as `evalPrimitiveCircuit`. -/
noncomputable def transfer (K : Nat → Core B) :
    (n : Nat) → PrimitiveBasis n → _root_.Matrix B B ℂ
  | 0, _ => 1
  | n + 1, x => coreSlice (K n) (x (Fin.last n)) * transfer K n (Fin.init x)

/-- Explicit initial boundary, followed by sequential matrix actions.
At stage zero there are no output bits and the bond amplitude is `boundary`. -/
noncomputable def run (U : Nat → Stage B) (boundary : B → ℂ) :
    (n : Nat) → BondState n B
  | 0 => fun x => boundary x.2
  | n + 1 => step (U n) (run U boundary n)

/-- Local clean-column equalities suffice to identify the complete state
with the tensor contraction at every length; no global state action is assumed. -/
theorem run_eq_transfer (U : Nat → Stage B) (K : Nat → Core B)
    (cleanColumns : ∀ t bit b a, U t (bit, b) (0, a) = K t (bit, b) a)
    (boundary : B → ℂ) (n : Nat) (x : PrimitiveBasis n) (b : B) :
    run U boundary n (x, b) = (transfer K n x).mulVec boundary b := by
  induction n generalizing b with
  | zero => simp [run, transfer]
  | succ n ih =>
    rw [run, step_apply]
    simp_rw [cleanColumns, ih]
    rw [transfer, ← _root_.Matrix.mulVec_mulVec]
    rfl

/-- Initial computational-basis boundary for the bond. -/
def basisBoundary (initial : B) : B → ℂ := fun b => if b = initial then 1 else 0

/-- Starting from a basis boundary extracts the corresponding transfer column. -/
theorem run_basisBoundary (U : Nat → Stage B) (K : Nat → Core B)
    (cleanColumns : ∀ t bit b a, U t (bit, b) (0, a) = K t (bit, b) a)
    (initial : B) (n : Nat) (x : PrimitiveBasis n) (b : B) :
    run U (basisBoundary initial) n (x, b) = transfer K n x b initial := by
  rw [run_eq_transfer U K cleanColumns]
  simp [basisBoundary, _root_.Matrix.mulVec, dotProduct]

/-- If every core is zero outside the next active bond set, its contracted
state has that support. This allows ranks to shrink inside a fixed register. -/
theorem transfer_boundary_supported (K : Nat → Core B)
    (active : Nat → B → Prop) (boundary : B → ℂ)
    (initialSupport : ∀ b, ¬ active 0 b → boundary b = 0)
    (coreSupport : ∀ t bit b a, ¬ active (t + 1) b → K t (bit, b) a = 0)
    (n : Nat) (x : PrimitiveBasis n) (b : B) (inactive : ¬ active n b) :
    (transfer K n x).mulVec boundary b = 0 := by
  cases n with
  | zero => simpa [transfer] using initialSupport b inactive
  | succ n =>
    rw [transfer, ← _root_.Matrix.mulVec_mulVec]
    simp [coreSlice, _root_.Matrix.mulVec, dotProduct, coreSupport n _ b _ inactive]

/-- Rank-changing version of `run_eq_transfer`: only columns for occupied
input bond labels must agree. Unused completion columns may be arbitrary.
The support invariant is proved from the cores, not assumed of the full run. -/
theorem run_eq_transfer_of_supported (U : Nat → Stage B) (K : Nat → Core B)
    (active : Nat → B → Prop) (boundary : B → ℂ)
    (initialSupport : ∀ b, ¬ active 0 b → boundary b = 0)
    (coreSupport : ∀ t bit b a, ¬ active (t + 1) b → K t (bit, b) a = 0)
    (cleanColumns : ∀ t bit b a, active t a → U t (bit, b) (0, a) = K t (bit, b) a)
    (n : Nat) (x : PrimitiveBasis n) (b : B) :
    run U boundary n (x, b) = (transfer K n x).mulVec boundary b := by
  classical
  induction n generalizing b with
  | zero => simp [run, transfer]
  | succ n ih =>
    rw [run, step_apply, transfer, ← _root_.Matrix.mulVec_mulVec]
    simp only [_root_.Matrix.mulVec, dotProduct, coreSlice]
    apply Finset.sum_congr rfl
    intro a _
    rw [ih]
    by_cases ha : active n a
    · rw [cleanColumns n _ b a ha]
      rfl
    · have hz := transfer_boundary_supported K active boundary initialSupport
        coreSupport n (Fin.init x) a ha
      change _ * (transfer K n (Fin.init x)).mulVec boundary a =
        _ * (transfer K n (Fin.init x)).mulVec boundary a
      rw [hz, mul_zero, mul_zero]

/-- No leakage to inactive labels at any intermediate stage. -/
theorem run_supported (U : Nat → Stage B) (K : Nat → Core B)
    (active : Nat → B → Prop) (boundary : B → ℂ)
    (initialSupport : ∀ b, ¬ active 0 b → boundary b = 0)
    (coreSupport : ∀ t bit b a, ¬ active (t + 1) b → K t (bit, b) a = 0)
    (cleanColumns : ∀ t bit b a, active t a → U t (bit, b) (0, a) = K t (bit, b) a)
    (n : Nat) (x : PrimitiveBasis n) (b : B) (inactive : ¬ active n b) :
    run U boundary n (x, b) = 0 := by
  rw [run_eq_transfer_of_supported U K active boundary initialSupport coreSupport cleanColumns]
  exact transfer_boundary_supported K active boundary initialSupport coreSupport n x b inactive

/-- A terminal bond of dimension one, embedded at a chosen padded label. -/
def terminalCore (clean : B) (T : _root_.Matrix (Fin 2) B ℂ) : Core B :=
  fun out a => if out.2 = clean then T out.1 a else 0

/-- Appending a rank-one terminal bond factors the *whole* state as a clean
bond times the contracted output amplitude; this is not a projection theorem. -/
theorem step_terminalCore {n : Nat} (U : Stage B) (v : BondState n B)
    (clean : B) (T : _root_.Matrix (Fin 2) B ℂ)
    (cleanColumns : ∀ bit b a, U (bit, b) (0, a) = terminalCore clean T (bit, b) a)
    (x : PrimitiveBasis (n + 1)) (b : B) :
    step U v (x, b) = if b = clean then
      ∑ a, T (x (Fin.last n)) a * v (Fin.init x, a) else 0 := by
  rw [step_apply]
  simp_rw [cleanColumns, terminalCore]
  by_cases h : b = clean <;> simp [h]

/-- Zero leakage to every non-clean bond label, with no measurement or
postselection. Local terminal-column synthesis is the explicit prerequisite. -/
theorem step_terminalCore_no_leakage {n : Nat} (U : Stage B) (v : BondState n B)
    (clean : B) (T : _root_.Matrix (Fin 2) B ℂ)
    (cleanColumns : ∀ bit b a, U (bit, b) (0, a) = terminalCore clean T (bit, b) a)
    (x : PrimitiveBasis (n + 1)) (b : B) (h : b ≠ clean) :
    step U v (x, b) = 0 := by
  rw [step_terminalCore U v clean T cleanColumns, if_neg h]

/-- Padded-register terminal cleanup on the occupied input subspace only.
Requiring this terminal action on *all* padded input columns would be
incompatible with unitarity for bond dimension greater than two. -/
theorem step_terminalCore_of_supported {n : Nat} (U : Stage B) (v : BondState n B)
    (active : B → Prop) (clean : B) (T : _root_.Matrix (Fin 2) B ℂ)
    (support : ∀ p a, ¬ active a → v (p, a) = 0)
    (cleanColumns : ∀ bit b a, active a →
      U (bit, b) (0, a) = terminalCore clean T (bit, b) a)
    (x : PrimitiveBasis (n + 1)) (b : B) :
    step U v (x, b) = if b = clean then
      ∑ a, T (x (Fin.last n)) a * v (Fin.init x, a) else 0 := by
  classical
  rw [step_apply]
  have he : (∑ a, U (x (Fin.last n), b) (0, a) * v (Fin.init x, a)) =
      ∑ a, terminalCore clean T (x (Fin.last n), b) a * v (Fin.init x, a) := by
    apply Finset.sum_congr rfl
    intro a _
    by_cases ha : active a
    · rw [cleanColumns _ b a ha]
    · rw [support _ a ha, mul_zero, mul_zero]
  rw [he]
  by_cases hb : b = clean <;> simp [terminalCore, hb]

/-- Complete state action after a supported sequential run and one terminal
stage. The target is the explicit transfer contraction, and every non-clean
bond amplitude is zero. No postselection, target-state oracle, or global
state-action equality is among the hypotheses. -/
theorem run_terminal_clean (U : Nat → Stage B) (K : Nat → Core B)
    (active : Nat → B → Prop) (boundary : B → ℂ)
    (initialSupport : ∀ b, ¬ active 0 b → boundary b = 0)
    (coreSupport : ∀ t bit b a, ¬ active (t + 1) b → K t (bit, b) a = 0)
    (cleanColumns : ∀ t bit b a, active t a → U t (bit, b) (0, a) = K t (bit, b) a)
    (n : Nat) (lastU : Stage B) (clean : B) (T : _root_.Matrix (Fin 2) B ℂ)
    (lastColumns : ∀ bit b a, active n a →
      lastU (bit, b) (0, a) = terminalCore clean T (bit, b) a)
    (x : PrimitiveBasis (n + 1)) (b : B) :
    step lastU (run U boundary n) (x, b) = if b = clean then
      ∑ a, T (x (Fin.last n)) a *
        (transfer K n (Fin.init x)).mulVec boundary a else 0 := by
  rw [step_terminalCore_of_supported lastU (run U boundary n) (active n) clean T
    (fun p a ha => run_supported U K active boundary initialSupport coreSupport
      cleanColumns n p a ha) lastColumns]
  simp_rw [run_eq_transfer_of_supported U K active boundary initialSupport
    coreSupport cleanColumns]

/-- The local primitive circuit uses the low `q` wires for the bond and its
highest wire for the fresh emitted bit. This equivalence makes that order explicit. -/
def localBasisEquiv (q : Nat) : PrimitiveBasis (q + 1) ≃ Fin 2 × PrimitiveBasis q :=
  (lastBasisEquiv q).trans (Equiv.prodComm _ _)

/-- Exact local stage supplied by a primitive circuit, not an opaque oracle. -/
noncomputable def circuitStage {q : Nat} (c : PrimitiveCircuit (q + 1)) :
    Stage (PrimitiveBasis q) :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (localBasisEquiv q) (evalPrimitiveCircuit c)

@[simp] theorem circuitStage_apply {q : Nat} (c : PrimitiveCircuit (q + 1))
    (bit bit' : Fin 2) (b a : PrimitiveBasis q) :
    circuitStage c (bit, b) (bit', a) =
      evalPrimitiveCircuit c (Fin.snoc b bit) (Fin.snoc a bit') := by
  rfl

/-- Primitive stages have checked full unitarity, independently of whether
their active columns implement the intended tensor cores. -/
theorem circuitStage_unitary {q : Nat} (c : PrimitiveCircuit (q + 1)) :
    circuitStage c ∈ _root_.Matrix.unitaryGroup (Fin 2 × PrimitiveBasis q) ℂ :=
  Robin.ComplexLCU.reindex_unitary _ _ (evalPrimitiveCircuit_unitary c)

/-- Direct instantiation with primitive-circuit stages. The sole compiler
alignment premise is stated on active clean-input columns, in actual
`evalPrimitiveCircuit` semantics. This does not synthesize these circuits or
prove a gate-count bound. -/
theorem run_circuitStages_eq_transfer {q : Nat}
    (circuits : Nat → PrimitiveCircuit (q + 1)) (K : Nat → Core (PrimitiveBasis q))
    (active : Nat → PrimitiveBasis q → Prop) (boundary : PrimitiveBasis q → ℂ)
    (initialSupport : ∀ b, ¬ active 0 b → boundary b = 0)
    (coreSupport : ∀ t bit b a, ¬ active (t + 1) b → K t (bit, b) a = 0)
    (compilerColumns : ∀ t bit b a, active t a →
      evalPrimitiveCircuit (circuits t) (Fin.snoc b bit) (Fin.snoc a 0) = K t (bit, b) a)
    (n : Nat) (x : PrimitiveBasis n) (b : PrimitiveBasis q) :
    run (fun t => circuitStage (circuits t)) boundary n (x, b) =
      (transfer K n x).mulVec boundary b := by
  apply run_eq_transfer_of_supported _ K active boundary initialSupport coreSupport
  intro t bit b a ha
  exact compilerColumns t bit b a ha

/-- Sum of amplitude squared moduli, represented as a complex scalar with
zero imaginary part. Keeping the star-product form avoids norm rewrites. -/
noncomputable def amplitudeMass {I : Type*} [Fintype I] (v : I → ℂ) : ℂ :=
  ∑ i, star (v i) * v i

/-- Full unitary matrix action preserves total amplitude mass. -/
theorem amplitudeMass_mulVec {I : Type*} [Fintype I] [DecidableEq I]
    (M : _root_.Matrix I I ℂ) (v : I → ℂ)
    (hM : M ∈ _root_.Matrix.unitaryGroup I ℂ) :
    amplitudeMass (M.mulVec v) = amplitudeMass v := by
  change dotProduct (star (M.mulVec v)) (M.mulVec v) = dotProduct (star v) v
  rw [_root_.Matrix.star_mulVec, ← _root_.Matrix.dotProduct_mulVec,
    _root_.Matrix.mulVec_mulVec]
  have hm : M.conjTranspose * M = 1 := _root_.Matrix.mem_unitaryGroup_iff'.mp hM
  rw [hm, _root_.Matrix.one_mulVec]

omit [DecidableEq B] in
/-- Introducing a zero bit is norm-preserving, not a postselection. -/
theorem amplitudeMass_freshZero {n : Nat} (v : BondState n B) :
    amplitudeMass (freshZero v) = amplitudeMass v := by
  simp [amplitudeMass, freshZero, Fintype.sum_prod_type]

/-- The regrouping of passive prefix, newly emitted bit, and bond labels. -/
def stepBasisEquiv (n : Nat) (B : Type*) :
    PrimitiveBasis (n + 1) × B ≃ PrimitiveBasis n × (Fin 2 × B) :=
  (Equiv.prodCongr (lastBasisEquiv n) (Equiv.refl B)).trans
    (Equiv.prodAssoc _ _ _)

/-- Sequential stages preserve total mass even when their occupied bond
subspaces have different dimensions. -/
theorem amplitudeMass_step {n : Nat} (U : Stage B) (v : BondState n B)
    (hU : U ∈ _root_.Matrix.unitaryGroup (Fin 2 × B) ℂ) :
    amplitudeMass (step U v) = amplitudeMass v := by
  have he : amplitudeMass (step U v) =
      amplitudeMass ((liftStage n U).mulVec (freshZero v)) := by
    exact (stepBasisEquiv n B).sum_comp
      (fun z => star (((liftStage n U).mulVec (freshZero v)) z) *
        ((liftStage n U).mulVec (freshZero v)) z)
  rw [he, amplitudeMass_mulVec _ _ (liftStage_unitary n U hU), amplitudeMass_freshZero]

/-- Full sequential action is norm-preserving for every length. -/
theorem amplitudeMass_run (U : Nat → Stage B) (boundary : B → ℂ)
    (unitary : ∀ t, U t ∈ _root_.Matrix.unitaryGroup (Fin 2 × B) ℂ) (n : Nat) :
    amplitudeMass (run U boundary n) = amplitudeMass boundary := by
  induction n with
  | zero => simp [run, amplitudeMass, Fintype.sum_prod_type]
  | succ n ih => rw [run, amplitudeMass_step _ _ (unitary n), ih]

/-- A unitary sequential run starting at one bond basis label has total
probability one at every stage. -/
theorem amplitudeMass_run_basisBoundary (U : Nat → Stage B) (initial : B)
    (unitary : ∀ t, U t ∈ _root_.Matrix.unitaryGroup (Fin 2 × B) ℂ) (n : Nat) :
    amplitudeMass (run U (basisBoundary initial) n) = 1 := by
  rw [amplitudeMass_run U _ unitary]
  simp [amplitudeMass, basisBoundary]

end QuantumBlockEncoding.SequentialBondPreparation
