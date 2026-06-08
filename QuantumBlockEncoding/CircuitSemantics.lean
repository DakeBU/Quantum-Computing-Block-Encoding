import QuantumBlockEncoding.BlockEncoding

/-!
# Circuit matrix semantics

This file is the first concrete bridge from the certificate-oriented circuit IR
to finite matrices.  It deliberately starts with externally supplied gate
matrices: oracle calls, rotations, and multi-control decompositions still need
separate certificates, but a circuit-level product now has a Lean object and a
checkable gate-to-matrix alignment condition.
-/

namespace QuantumBlockEncoding

/-- A finite-dimensional basis size for an `n`-qubit register. -/
def qubitDim (qubits : Nat) : Nat :=
  gridSize qubits

/--
Structured semantic obligation for the matrix layer.

This mirrors `GHL2025.ObligationRecord` without importing `GHL2025`, so the
semantics backend can stay below paper-specific files in the import graph.
-/
structure SemanticObligation where
  description : String
  source : String
  proved : Bool := false
deriving Repr, DecidableEq

/--
One gate together with its matrix on the full `qubits`-qubit Hilbert space.
The matrix is supplied by a lower-level certificate for the gate family.
-/
structure GateMatrix (α : Type u) (qubits : Nat) where
  gate : Gate
  matrix : Matrix (qubitDim qubits) (qubitDim qubits) α
  unitary : SemanticObligation

/-- Check that a list of gate matrices labels exactly the same circuit gates. -/
def gateMatricesMatchCircuit {α : Type u} {qubits : Nat} :
    Circuit → List (GateMatrix α qubits) → Bool
  | [], [] => true
  | gate :: circuitTail, gateMatrix :: matrixTail =>
      gateMatrix.gate == gate && gateMatricesMatchCircuit circuitTail matrixTail
  | _, _ => false

/--
Evaluate a list of full-space gate matrices to a circuit matrix.

The fold uses the usual right-action convention for a circuit list
`[g₁, g₂, ...]`: the resulting matrix is `g_k * ... * g₂ * g₁`.
-/
def evalGateMatrices {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α] {qubits : Nat}
    (gates : List (GateMatrix α qubits)) :
    Matrix (qubitDim qubits) (qubitDim qubits) α :=
  gates.foldl (fun acc gateMatrix => Matrix.mul gateMatrix.matrix acc)
    (Matrix.identity (qubitDim qubits) α)

namespace Matrix

/--
Evaluate one symbolic matrix-product entry as a concrete finite Rat fold.

The project-local `Coeff` matrices are syntactic, so a raw `Matrix.mul` entry
does not simplify away zero summands.  This lemma moves the finite product
entry through `Coeff.evalWith`, where later path-isolation proofs can use
ordinary rational arithmetic without expanding the whole symbolic expression.
-/
theorem evalWith_foldl_add_mul
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) (ks : List (Fin mid)) (acc : Coeff) :
    Coeff.evalWith env
        (ks.foldl (fun acc k => acc + A i k * B k j) acc) =
      ks.foldl
        (fun acc k => acc + Coeff.evalWith env (A i k) *
          Coeff.evalWith env (B k j))
        (Coeff.evalWith env acc) := by
  induction ks generalizing acc with
  | nil => rfl
  | cons k ks ih =>
      simp [List.foldl_cons, ih, Coeff.evalWith]

/--
Evaluate one entry of `Matrix.mul` by evaluating each path contribution.

This is the local matrix-semantics block needed before a focused Robin
seven-gate path proof can avoid syntactic `Coeff.add` blow-up.
-/
theorem evalWith_mul_apply
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      (List.finRange mid).foldl
        (fun acc k => acc + Coeff.evalWith env (A i k) *
          Coeff.evalWith env (B k j))
        0 := by
  unfold Matrix.mul
  rw [evalWith_foldl_add_mul]
  rfl

private theorem foldl_add_zero_of_all_zero {β : Type u}
    (ks : List β) (f : β → Rat) (acc : Rat)
    (hzero : ∀ k, k ∈ ks → f k = 0) :
    ks.foldl (fun acc k => acc + f k) acc = acc := by
  induction ks generalizing acc with
  | nil => rfl
  | cons k ks ih =>
      have hkzero : f k = 0 := hzero k (by simp)
      have htail : ∀ k', k' ∈ ks → f k' = 0 := by
        intro k' hk'
        exact hzero k' (by simp [hk'])
      calc
        (k :: ks).foldl (fun acc k => acc + f k) acc =
            ks.foldl (fun acc k => acc + f k) (acc + f k) := rfl
        _ = ks.foldl (fun acc k => acc + f k) acc := by
            rw [hkzero, Rat.add_zero]
        _ = acc := ih acc htail

/--
Evaluate one matrix-product entry as zero when every evaluated path contribution
is zero.

This is the zero-support companion to `evalWith_mul_unique_path`.  It lets
paper-specific product proofs avoid expanding a large symbolic `Coeff` fold
when they have already isolated gate-local support facts.
-/
theorem evalWith_mul_eq_zero_of_all_paths_zero
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols)
    (hzero : ∀ k : Fin mid,
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) = 0 := by
  rw [evalWith_mul_apply]
  exact foldl_add_zero_of_all_zero (List.finRange mid)
    (fun k => Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j))
    0 (by
      intro k _hmem
      exact hzero k)

private theorem foldl_add_unique_of_nodup {β : Type u} [DecidableEq β]
    (ks : List β) (f : β → Rat) (k0 : β)
    (hnodup : ks.Nodup)
    (hmem : k0 ∈ ks)
    (hzero : ∀ k, k ∈ ks → k ≠ k0 → f k = 0) :
    ks.foldl (fun acc k => acc + f k) 0 = f k0 := by
  induction ks with
  | nil => cases hmem
  | cons k ks ih =>
      rw [List.nodup_cons] at hnodup
      rcases hnodup with ⟨hk_not_mem, hks_nodup⟩
      rw [List.mem_cons] at hmem
      rcases hmem with hhead | htailmem
      · subst hhead
        have htail_zero : ∀ k', k' ∈ ks → f k' = 0 := by
          intro k' hk'
          have hne : k' ≠ k0 := by
            intro h_eq
            apply hk_not_mem
            simpa [h_eq] using hk'
          exact hzero k' (by simp [hk']) hne
        calc
          (k0 :: ks).foldl (fun acc k => acc + f k) 0 =
              ks.foldl (fun acc k => acc + f k) (0 + f k0) := rfl
          _ = ks.foldl (fun acc k => acc + f k) (f k0) := by
              rw [Rat.zero_add]
          _ = f k0 := foldl_add_zero_of_all_zero ks f (f k0) htail_zero
      · have hk_zero : f k = 0 := by
          have hne : k ≠ k0 := by
            intro h_eq
            apply hk_not_mem
            simpa [h_eq] using htailmem
          exact hzero k (by simp) hne
        have htail_zero : ∀ k', k' ∈ ks → k' ≠ k0 → f k' = 0 := by
          intro k' hk' hne
          exact hzero k' (by simp [hk']) hne
        calc
          (k :: ks).foldl (fun acc k => acc + f k) 0 =
              ks.foldl (fun acc k => acc + f k) (0 + f k) := rfl
          _ = ks.foldl (fun acc k => acc + f k) 0 := by
              rw [hk_zero, Rat.zero_add]
          _ = f k0 := ih hks_nodup htailmem htail_zero

private theorem nodup_map_of_injective {α : Type u} {β : Type v}
    [DecidableEq β] {f : α → β} (hf : Function.Injective f)
    {xs : List α} (hxs : xs.Nodup) :
    (xs.map f).Nodup := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
      rw [List.nodup_cons] at hxs
      rcases hxs with ⟨hx_not_mem, hxs_nodup⟩
      change (f x :: xs.map f).Nodup
      rw [List.nodup_cons]
      constructor
      · intro hmem
        rcases List.mem_map.mp hmem with ⟨y, hy_mem, hy_eq⟩
        apply hx_not_mem
        have hxy : y = x := hf hy_eq
        simpa [hxy] using hy_mem
      · exact ih hxs_nodup

private theorem finRange_nodup (n : Nat) : (List.finRange n).Nodup := by
  induction n with
  | zero => simp [List.finRange_zero]
  | succ n ih =>
      rw [List.finRange_succ]
      rw [List.nodup_cons]
      constructor
      · intro hmem
        rcases List.mem_map.mp hmem with ⟨k, _hk_mem, hk_zero⟩
        exact Fin.succ_ne_zero k hk_zero
      · apply nodup_map_of_injective
        · intro a b h
          apply Fin.eq_of_val_eq
          have hv := congrArg (fun x : Fin (n + 1) => x.val) h
          simpa using Nat.succ.inj hv
        · exact ih

private theorem foldl_add_extract_init {β : Type u}
    (ks : List β) (f : β → Rat) (init : Rat) :
    ks.foldl (fun acc k => acc + f k) init = init + ks.foldl (fun acc k => acc + f k) 0 := by
  induction ks generalizing init with
  | nil => simp [List.foldl_nil, Rat.add_zero]
  | cons k ks ih =>
      simp only [List.foldl_cons]
      rw [ih, ih (0 + f k)]
      simp only [Rat.zero_add]
      exact Rat.add_assoc init (f k) _

private theorem foldl_add_two_of_nodup {β : Type u} [DecidableEq β]
    (ks : List β) (f : β → Rat) (k0 k1 : β)
    (hnodup : ks.Nodup)
    (hmem0 : k0 ∈ ks)
    (hmem1 : k1 ∈ ks)
    (hk0_ne_k1 : k0 ≠ k1)
    (hzero : ∀ k, k ∈ ks → k ≠ k0 → k ≠ k1 → f k = 0) :
    ks.foldl (fun acc k => acc + f k) 0 = f k0 + f k1 := by
  induction ks with
  | nil => cases hmem0
  | cons k ks ih =>
      rw [List.nodup_cons] at hnodup
      obtain ⟨hk_not_mem, hks_nodup⟩ := hnodup
      rw [List.mem_cons] at hmem0 hmem1
      -- Case: k0 = k = head
      rcases hmem0 with rfl | htail0
      · rcases hmem1 with hhead1 | htail1
        -- Sub-case: k1 = k = head (impossible, k0 ≠ k1)
        · exfalso; exact hk0_ne_k1 hhead1.symm
        -- Sub-case: k1 ∈ tail
        · have htail1_zero : ∀ k', k' ∈ ks → k' ≠ k1 → f k' = 0 := by
            intro k' hk' hne
            exact hzero k' (by simp [hk']) (by
              intro h_eq; apply hk_not_mem; simpa [h_eq] using hk') hne
          have h := foldl_add_unique_of_nodup ks f k1 hks_nodup htail1 htail1_zero
          calc
            (k0 :: ks).foldl (fun acc k => acc + f k) 0 =
                ks.foldl (fun acc k => acc + f k) (0 + f k0) := rfl
            _ = f k0 + ks.foldl (fun acc k => acc + f k) 0 := by
                rw [Rat.zero_add, foldl_add_extract_init]
            _ = f k0 + f k1 := by rw [h]
      -- Case: k0 ∈ tail
      · rcases hmem1 with rfl | htail1
        -- Sub-case: k1 = k = head
        · have htail0_zero : ∀ k', k' ∈ ks → k' ≠ k0 → f k' = 0 := by
            intro k' hk' hne
            exact hzero k' (by simp [hk']) hne (by
              intro h_eq; apply hk_not_mem; simpa [h_eq] using hk')
          have h := foldl_add_unique_of_nodup ks f k0 hks_nodup htail0 htail0_zero
          calc
            (k1 :: ks).foldl (fun acc k => acc + f k) 0 =
                ks.foldl (fun acc k => acc + f k) (0 + f k1) := rfl
            _ = f k1 + ks.foldl (fun acc k => acc + f k) 0 := by
                rw [Rat.zero_add, foldl_add_extract_init]
            _ = f k1 + f k0 := by rw [h]
            _ = f k0 + f k1 := by exact Rat.add_comm (f k1) (f k0)
        -- Sub-case: k1 ∈ tail, head is neither
        · have hk_zero : f k = 0 := by
            refine hzero k (by simp) ?_ ?_
            · intro h_eq; apply hk_not_mem; simpa [h_eq] using htail0
            · intro h_eq; apply hk_not_mem; simpa [h_eq] using htail1
          have htail_zero : ∀ k', k' ∈ ks → k' ≠ k0 → k' ≠ k1 → f k' = 0 := by
            intro k' hk' hne0 hne1
            exact hzero k' (by simp [hk']) hne0 hne1
          calc
            (k :: ks).foldl (fun acc k => acc + f k) 0 =
                ks.foldl (fun acc k => acc + f k) (0 + f k) := rfl
            _ = ks.foldl (fun acc k => acc + f k) 0 := by
                rw [hk_zero, Rat.zero_add]
            _ = f k0 + f k1 := ih hks_nodup htail0 htail1 htail_zero

/--
Evaluate one matrix-product entry when all evaluated paths except `k0` vanish.

This is the reusable path-isolation block for later Robin gamma3 work: a
theorem about the seven-gate product can first prove zero-support facts for all
unwanted intermediate states, then reduce the evaluated product to the single
surviving contribution.
-/
theorem evalWith_mul_unique_path
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) (k0 : Fin mid)
    (hzero : ∀ k : Fin mid, k ≠ k0 →
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      Coeff.evalWith env (A i k0) * Coeff.evalWith env (B k0 j) := by
  rw [evalWith_mul_apply]
  exact foldl_add_unique_of_nodup (List.finRange mid)
    (fun k => Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j))
    k0 (finRange_nodup mid) (List.mem_finRange k0)
    (by
      intro k _hmem hne
      exact hzero k hne)

/--
Evaluate one matrix-product entry when all evaluated paths except `k0` and `k1`
vanish.

This is the two-path companion to `evalWith_mul_unique_path`.  A seven-gate
product proof can first establish that only two intermediate rows contribute,
then reduce the evaluated product to their sum using this theorem.
-/
theorem evalWith_mul_two_path
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) (k0 k1 : Fin mid)
    (hk0_ne_k1 : k0 ≠ k1)
    (hzero : ∀ k : Fin mid, k ≠ k0 → k ≠ k1 →
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      Coeff.evalWith env (A i k0) * Coeff.evalWith env (B k0 j) +
      Coeff.evalWith env (A i k1) * Coeff.evalWith env (B k1 j) := by
  rw [evalWith_mul_apply]
  exact foldl_add_two_of_nodup (List.finRange mid)
    (fun k => Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j))
    k0 k1 (finRange_nodup mid) (List.mem_finRange k0) (List.mem_finRange k1)
    hk0_ne_k1
    (by
      intro k _hmem hne0 hne1
      exact hzero k hne0 hne1)

/--
Evaluating a symbolic matrix after multiplying on the right by the identity
recovers the evaluated entry.

The statement is evaluation-level, not syntactic: `Coeff` deliberately stores
matrix products as explicit fold expressions, so the raw `Coeff` term still
contains zero summands.
-/
theorem evalWith_mul_identity_right_apply
    (env : String → Rat) {n : Nat}
    (A : Matrix n n Coeff) (i j : Fin n) :
    Coeff.evalWith env (Matrix.mul A (Matrix.identity n Coeff) i j) =
      Coeff.evalWith env (A i j) := by
  rw [evalWith_mul_unique_path env A (Matrix.identity n Coeff) i j j]
  · simp [Matrix.identity, Coeff.evalWith]
  · intro k hk
    simp [Matrix.identity, hk, Coeff.evalWith]

/--
Entry-level bridge for square matrix casts along a dimension equality.

This keeps paper-specific finite-entry proofs from unfolding a large casted
matrix when the only content is that the row and column values are unchanged.
-/
theorem cast_square_apply {α : Type u} {m n : Nat} (h : m = n)
    (M : Matrix m m α) (i j : Fin n) :
    (((cast (by rw [h]) M) : Matrix n n α) i j) =
      M ⟨i.val, by subst h; exact i.isLt⟩
        ⟨j.val, by subst h; exact j.isLt⟩ := by
  subst h
  rfl

end Matrix

/--
Evaluation-level single-gate reduction for `evalGateMatrices`.

This is the entry helper for prepared composite gates: the matrix semantics of
a singleton gate list evaluates to the supplied gate matrix entry, even though
the underlying symbolic `Coeff` expression is still a folded multiplication by
the identity matrix.
-/
theorem evalWith_evalGateMatrices_single
    (env : String → Rat) {qubits : Nat}
    (gateMatrix : GateMatrix Coeff qubits)
    (i j : Fin (qubitDim qubits)) :
    Coeff.evalWith env ((evalGateMatrices [gateMatrix]) i j) =
      Coeff.evalWith env (gateMatrix.matrix i j) := by
  dsimp [evalGateMatrices]
  exact Matrix.evalWith_mul_identity_right_apply env gateMatrix.matrix i j

/--
Circuit-level matrix semantics assembled from gate-level matrices.

This does not certify that individual oracle matrices are correct; it gives the
project a stable Lean target for composing those certificates once they exist.
-/
structure CircuitMatrixSemantics (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α] (qubits : Nat) where
  circuit : Circuit
  gateMatrices : List (GateMatrix α qubits)
  gateListMatches : gateMatricesMatchCircuit circuit gateMatrices = true
  matrix : Matrix (qubitDim qubits) (qubitDim qubits) α
  matrix_eq_eval : Matrix.PointwiseEq matrix (evalGateMatrices gateMatrices)

namespace CircuitMatrixSemantics

/-- Build circuit semantics directly from aligned gate matrices. -/
def ofGateMatrices {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α] {qubits : Nat}
    (circuit : Circuit) (gateMatrices : List (GateMatrix α qubits))
    (h : gateMatricesMatchCircuit circuit gateMatrices = true) :
    CircuitMatrixSemantics α qubits where
  circuit := circuit
  gateMatrices := gateMatrices
  gateListMatches := h
  matrix := evalGateMatrices gateMatrices
  matrix_eq_eval := by intro _ _; rfl

end CircuitMatrixSemantics

/--
Typed target for relating an active circuit-matrix entry to a prepared
composition entry.

This is intentionally only an interface.  It records the two matrix entries
and the exact equality a paper-specific composition backend must prove; it
does not assert that the active circuit already contains the prepared blocks.
-/
structure PreparedCircuitEntryTarget
    (α : Type u) (activeDim preparedDim : Nat) where
  activeMatrix : Matrix activeDim activeDim α
  preparedMatrix : Matrix preparedDim preparedDim α
  activeRow : Fin activeDim
  activeCol : Fin activeDim
  preparedRow : Fin preparedDim
  preparedCol : Fin preparedDim
  activeEntry : α
  activeEntry_eq : activeEntry = activeMatrix activeRow activeCol
  preparedEntry : α
  preparedEntry_eq : preparedEntry = preparedMatrix preparedRow preparedCol
  activeSource : SemanticObligation
  preparedComposition : SemanticObligation

namespace PreparedCircuitEntryTarget

/-- The prepared-composition equality required by the target. -/
def entryEqualityStatement {α : Type u} {activeDim preparedDim : Nat}
    (target : PreparedCircuitEntryTarget α activeDim preparedDim) : Prop :=
  target.activeEntry = target.preparedEntry

/-- The same equality stated directly on the backing matrices. -/
def matrixEntryEqualityStatement {α : Type u} {activeDim preparedDim : Nat}
    (target : PreparedCircuitEntryTarget α activeDim preparedDim) : Prop :=
  target.activeMatrix target.activeRow target.activeCol =
    target.preparedMatrix target.preparedRow target.preparedCol

/--
The cached entry equality is equivalent to the backing matrix-entry equality.

Paper-specific targets can prove whichever side their local backend exposes
without changing the semantic obligation being tracked.
-/
theorem entryEqualityStatement_iff_matrixEntryEqualityStatement
    {α : Type u} {activeDim preparedDim : Nat}
    (target : PreparedCircuitEntryTarget α activeDim preparedDim) :
    target.entryEqualityStatement ↔
      target.matrixEntryEqualityStatement := by
  unfold entryEqualityStatement matrixEntryEqualityStatement
  constructor
  · intro hentry
    calc
      target.activeMatrix target.activeRow target.activeCol =
          target.activeEntry := target.activeEntry_eq.symm
      _ = target.preparedEntry := hentry
      _ = target.preparedMatrix target.preparedRow target.preparedCol :=
          target.preparedEntry_eq
  · intro hmatrix
    calc
      target.activeEntry =
          target.activeMatrix target.activeRow target.activeCol :=
            target.activeEntry_eq
      _ = target.preparedMatrix target.preparedRow target.preparedCol :=
          hmatrix
      _ = target.preparedEntry := target.preparedEntry_eq.symm

end PreparedCircuitEntryTarget

/--
A paper-level block-extraction target against a concrete circuit matrix.

The current project can now state the missing equation in matrix terms.  The
actual block projection from signal/system registers remains a later proof
obligation, tracked explicitly by `blockProjection` and `blockCorrect`.
-/
structure BlockExtractionTarget (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    (rows cols signalDim : Nat) where
  unitaryMatrix : Matrix (signalDim * rows) (signalDim * cols) α
  targetMatrix : Matrix rows cols α
  normalizer : α
  signalIndex : Fin signalDim
  blockMatrix : Matrix rows cols α
  blockProjection : SemanticObligation
  blockCorrect : SemanticObligation

/--
Fold a finite family of branch contributions into one projected block entry.

This is deliberately minimal: it provides a typed target for paper-specific
projection/summation proofs without assuming commutativity, a ring structure,
or a normal form for symbolic coefficients.
-/
def blockExtractionBranchContributionSum {α : Type u} [OfNat α 0]
    [HAdd α α α] {branchDim : Nat}
    (branchContribution : Fin branchDim → α) : α :=
  (List.finRange branchDim).foldl
    (fun acc branch => acc + branchContribution branch) 0

/--
Typed interface for decomposing one block-extracted matrix entry into finite
branch contributions.

The interface records the candidate contribution family and the exact
block-entry and branch-sum propositions that must be proved.  It is not itself
a proof that the family is sourced from the backend or that the branch sum
equals the block entry; those remain explicit semantic obligations.
-/
structure BlockExtractionBranchContributionTarget
    (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    (rows cols signalDim branchDim : Nat) where
  extractionTarget : BlockExtractionTarget α rows cols signalDim
  systemRow : Fin rows
  systemCol : Fin cols
  selectedBranch : Fin branchDim
  branchContribution : Fin branchDim → α
  selectedContribution : α
  selectedContribution_eq :
    selectedContribution = branchContribution selectedBranch
  branchSum : α
  branchSum_eq :
    branchSum = blockExtractionBranchContributionSum branchContribution
  blockEntry : α
  blockEntry_eq : blockEntry = extractionTarget.blockMatrix systemRow systemCol
  backendSource : SemanticObligation
  selectedBranchCorrect : SemanticObligation
  branchSummationCorrect : SemanticObligation

namespace BlockExtractionBranchContributionTarget

/-- The selected-branch identity exposed by the target. -/
def selectedBranchStatement {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim) :
    Prop :=
  target.selectedContribution =
    target.branchContribution target.selectedBranch

/-- The projection/summation theorem still required for the target. -/
def projectionSummationStatement {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim) :
    Prop :=
  target.blockEntry = target.branchSum

/--
The backend expansion theorem needed to close `projectionSummationStatement`.

This version is stated directly in terms of the extraction target's block
matrix entry and the candidate branch-contribution fold.  It is useful as a
proof-DAG interface because paper-specific projection backends can target this
statement without depending on the record's cached `blockEntry` and `branchSum`
fields.
-/
def backendExpansionStatement {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim) :
    Prop :=
  target.extractionTarget.blockMatrix target.systemRow target.systemCol =
    blockExtractionBranchContributionSum target.branchContribution

theorem selectedBranchStatement_of_eq {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim) :
    target.selectedBranchStatement := by
  exact target.selectedContribution_eq

theorem projectionSummationStatement_iff_backendExpansionStatement
    {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim) :
    target.projectionSummationStatement ↔
      target.backendExpansionStatement := by
  unfold projectionSummationStatement backendExpansionStatement
  constructor
  · intro hprojection
    calc
      target.extractionTarget.blockMatrix target.systemRow target.systemCol =
          target.blockEntry := target.blockEntry_eq.symm
      _ = target.branchSum := hprojection
      _ = blockExtractionBranchContributionSum target.branchContribution :=
          target.branchSum_eq
  · intro hexpansion
    calc
      target.blockEntry =
          target.extractionTarget.blockMatrix target.systemRow target.systemCol :=
            target.blockEntry_eq
      _ = blockExtractionBranchContributionSum target.branchContribution :=
          hexpansion
      _ = target.branchSum := target.branchSum_eq.symm

theorem projectionSummationStatement_of_backendExpansionStatement
    {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim)
    (hexpansion : target.backendExpansionStatement) :
    target.projectionSummationStatement :=
  (projectionSummationStatement_iff_backendExpansionStatement target).2
    hexpansion

theorem backendExpansionStatement_of_projectionSummationStatement
    {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {rows cols signalDim branchDim : Nat}
    (target :
      BlockExtractionBranchContributionTarget α rows cols signalDim branchDim)
    (hprojection : target.projectionSummationStatement) :
    target.backendExpansionStatement :=
  (projectionSummationStatement_iff_backendExpansionStatement target).1
    hprojection

end BlockExtractionBranchContributionTarget

/--
A circuit-level block encoding claim bundling a circuit matrix semantics
with a block extraction target and a dimension compatibility proof.

The `blockCorrect` obligation tracks the main mathematical claim:
(⟨signalIdx| ⊗ I) U (|signalIdx⟩ ⊗ I) = targetMatrix / normalizer.
This does not assert the claim is true; it records what needs proving.
-/
structure CircuitBlockEncodingClaim (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    (qubits : Nat) (dim signalDim : Nat) where
  semantics : CircuitMatrixSemantics α qubits
  target : BlockExtractionTarget α dim dim signalDim
  dimCompat : qubitDim qubits = signalDim * dim
  blockCorrect : SemanticObligation

/--
Typed contract for a finite-dimensional LCU/block-composition step.

This is intentionally contract-only: it states the exact matrix objects and
obligations that a later theorem must connect, without treating a cited LCU
result or a paper theorem as a Lean proof.
-/
structure FiniteBlockCompositionContract (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    (qubits dim signalDim : Nat) where
  sourceAnchor : String
  lcuSourceAnchor : String
  theoremAnchor : String
  claim : CircuitBlockEncodingClaim α qubits dim signalDim
  expectedTarget : BlockExtractionTarget α dim dim signalDim
  targetMatrix : Matrix dim dim α
  normalizer : α
  claimTargetMatches : claim.target = expectedTarget
  targetMatrixMatches : expectedTarget.targetMatrix = targetMatrix
  targetNormalizerMatches : expectedTarget.normalizer = normalizer
  circuitUnitary : SemanticObligation
  lcuComposition : SemanticObligation
  blockProjection : SemanticObligation
  normalizedBlockEquality : SemanticObligation
  finalExtraction : SemanticObligation

/-- Compound row index for a signal value and a system-row index. -/
def signalSystemBlockRowIndex (rows : Nat) (signalIdx systemIdx : Nat) : Nat :=
  signalIdx * rows + systemIdx

/-- Compound column index for a signal value and a system-column index. -/
def signalSystemBlockColIndex (cols : Nat) (signalIdx systemIdx : Nat) : Nat :=
  signalIdx * cols + systemIdx

@[simp] theorem signalSystemBlockRowIndex_zero (rows systemIdx : Nat) :
    signalSystemBlockRowIndex rows 0 systemIdx = systemIdx := by
  simp [signalSystemBlockRowIndex]

@[simp] theorem signalSystemBlockColIndex_zero (cols systemIdx : Nat) :
    signalSystemBlockColIndex cols 0 systemIdx = systemIdx := by
  simp [signalSystemBlockColIndex]

/-- The row compound index stays inside a signal × row matrix. -/
theorem signalSystemBlockRowIndex_lt {signalDim rows : Nat}
    (signalIdx : Fin signalDim) (i : Fin rows) :
    signalSystemBlockRowIndex rows signalIdx.val i.val < signalDim * rows := by
  exact Nat.lt_of_succ_le (by
    show signalSystemBlockRowIndex rows signalIdx.val i.val + 1 ≤ signalDim * rows
    calc signalSystemBlockRowIndex rows signalIdx.val i.val + 1
        ≤ signalIdx.val * rows + rows := by
            simp [signalSystemBlockRowIndex]
            omega
      _ = (signalIdx.val + 1) * rows := by
          exact Nat.succ_mul signalIdx.val rows |>.symm
      _ ≤ signalDim * rows := by
          exact Nat.mul_le_mul_right rows (Nat.succ_le_of_lt signalIdx.isLt))

/-- The column compound index stays inside a signal × column matrix. -/
theorem signalSystemBlockColIndex_lt {signalDim cols : Nat}
    (signalIdx : Fin signalDim) (j : Fin cols) :
    signalSystemBlockColIndex cols signalIdx.val j.val < signalDim * cols := by
  exact Nat.lt_of_succ_le (by
    show signalSystemBlockColIndex cols signalIdx.val j.val + 1 ≤ signalDim * cols
    calc signalSystemBlockColIndex cols signalIdx.val j.val + 1
        ≤ signalIdx.val * cols + cols := by
            simp [signalSystemBlockColIndex]
            omega
      _ = (signalIdx.val + 1) * cols := by
          exact Nat.succ_mul signalIdx.val cols |>.symm
      _ ≤ signalDim * cols := by
          exact Nat.mul_le_mul_right cols (Nat.succ_le_of_lt signalIdx.isLt))

/--
Block projection: extract the `(signalIdx, signalIdx)` block from a
signal × system matrix.

Given a matrix M of size `(signalDim * rows) × (signalDim * cols)`, the helpers
`signalSystemBlockRowIndex` and `signalSystemBlockColIndex` map a pair `(i, j)`
of system indices to the compound row and column indices in the full matrix
that correspond to signal register value `idx` and system indices `(i, j)`.

The block `(⟨signalIdx| ⊗ I) M (|signalIdx⟩ ⊗ I)` is then:
  blockMatrix i j = M (signalIdx * rows + i) (signalIdx * cols + j)
-/
def signalSystemBlockProjection {α : Type u} [OfNat α 0]
    (signalDim rows cols : Nat)
    (M : Matrix (signalDim * rows) (signalDim * cols) α)
    (signalIdx : Fin signalDim) :
    Matrix rows cols α :=
  fun i j =>
    M ⟨signalSystemBlockRowIndex rows signalIdx.val i.val,
        signalSystemBlockRowIndex_lt signalIdx i⟩
      ⟨signalSystemBlockColIndex cols signalIdx.val j.val,
        signalSystemBlockColIndex_lt signalIdx j⟩

@[simp] theorem signalSystemBlockProjection_apply {α : Type u} [OfNat α 0]
    {signalDim rows cols : Nat}
    (M : Matrix (signalDim * rows) (signalDim * cols) α)
    (signalIdx : Fin signalDim) (i : Fin rows) (j : Fin cols) :
    signalSystemBlockProjection signalDim rows cols M signalIdx i j =
      M ⟨signalSystemBlockRowIndex rows signalIdx.val i.val,
          signalSystemBlockRowIndex_lt signalIdx i⟩
        ⟨signalSystemBlockColIndex cols signalIdx.val j.val,
          signalSystemBlockColIndex_lt signalIdx j⟩ := rfl

/--
Total qubits needed for a circuit operating on `system` system qubits
and `signal` signal qubits.
-/
def totalCircuitQubits (system signal : Nat) : Nat :=
  system + signal

/--
Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing
the block projection. The circuit matrix is square with dimension
`signalDim * dim`, and we extract the `(signalIdx, signalIdx)` block.
-/
def CircuitMatrixSemantics.blockExtractionTarget
    {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {qubits : Nat}
    (sem : CircuitMatrixSemantics α qubits)
    (dim signalDim : Nat)
    (hDim : qubitDim qubits = signalDim * dim)
    (targetMatrix : Matrix dim dim α)
    (normalizer : α)
    (signalIdx : Fin signalDim) :
    BlockExtractionTarget α dim dim signalDim where
  unitaryMatrix := cast (by rw [hDim]) sem.matrix
  targetMatrix := targetMatrix
  normalizer := normalizer
  signalIndex := signalIdx
  blockMatrix := signalSystemBlockProjection signalDim dim dim
    (cast (by rw [hDim]) sem.matrix) signalIdx
  blockProjection := {
    description := "block projection extracts the correct signal×system submatrix"
    source := "CircuitSemantics.lean"
    proved := false
  }
  blockCorrect := {
    description := "extracted block equals targetMatrix / normalizer"
    source := "CircuitSemantics.lean"
    proved := false
  }

end QuantumBlockEncoding
