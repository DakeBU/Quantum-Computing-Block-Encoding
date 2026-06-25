import QuantumBlockEncoding.BlockEncoding

/-!
# Classic block-encoding proof leaves

This file turns the first ABEIS block-encoding memory cards into compiled Lean
objects.  The goal is deliberately modest and reusable: formalize the proof
leaves that many papers use implicitly before later files attach richer
Mathlib/quantum semantics.

The declarations here are the Lean anchors for the memory cards in
`research-wiki/block-encoding-library/`.
-/

namespace QuantumBlockEncoding
namespace BlockEncodingClassics

/-- Permutation-matrix entries for a finite basis map. -/
def permMatrix {n : Nat} (p : Fin n -> Fin n) : Matrix n n Rat :=
  fun row col => if row = p col then 1 else 0

/-- Clean block induced by an embedding of the system basis into a larger basis. -/
def cleanBlockBy {system total : Nat} (embed : Fin system -> Fin total)
    (U : Matrix total total Rat) : Matrix system system Rat :=
  fun row col => U (embed row) (embed col)

/--
Canonical product-register embedding.  If the full Hilbert basis is represented
as `ancilla × system`, this maps `(a, s)` to the flattened index
`a * system + s`.
-/
def productIndex {ancilla system : Nat} (a : Fin ancilla) (s : Fin system) :
    Fin (ancilla * system) :=
  ⟨a.val * system + s.val, by
    have hspos : 0 < system := Nat.lt_of_le_of_lt (Nat.zero_le s.val) s.isLt
    have hlt : a.val * system + s.val < (a.val + 1) * system := by
      rw [Nat.succ_mul]
      omega
    have hle : (a.val + 1) * system ≤ ancilla * system :=
      Nat.mul_le_mul_right system (Nat.succ_le_of_lt a.isLt)
    exact Nat.lt_of_lt_of_le hlt hle⟩

/-- Clean block for a flattened `ancilla × system` matrix. -/
def cleanBlockProduct {ancilla system : Nat} (zero : Fin ancilla)
    (U : Matrix (ancilla * system) (ancilla * system) Rat) :
    Matrix system system Rat :=
  cleanBlockBy (productIndex zero) U

/--
Core `BE.PermMatrix.CleanBlock` leaf: the clean block of a permutation matrix is
just the finite image predicate restricted to clean embedded rows and columns.
-/
theorem cleanBlockBy_permMatrix_entry {system total : Nat}
    (embed : Fin system -> Fin total) (p : Fin total -> Fin total)
    (row col : Fin system) :
    cleanBlockBy embed (permMatrix p) row col =
      if embed row = p (embed col) then 1 else 0 := by
  rfl

/--
Product-register version of `cleanBlockBy_permMatrix_entry`.  This is the
standard entrywise bridge for block encodings whose clean ancilla is explicitly
one register of a flattened product basis.
-/
theorem cleanBlockProduct_permMatrix_entry {ancilla system : Nat}
    (zero : Fin ancilla) (p : Fin (ancilla * system) -> Fin (ancilla * system))
    (row col : Fin system) :
    cleanBlockProduct zero (permMatrix p) row col =
      if productIndex zero row = p (productIndex zero col) then 1 else 0 := by
  rfl

/--
Entrywise bridge from a finite image calculation to an exact clean block.  This
is the leaf that converts a successful finite reversible construction into the
block-entry theorem lower agents usually need.
-/
theorem cleanBlockBy_permMatrix_eq_target_of_entry {system total : Nat}
    (embed : Fin system -> Fin total) (p : Fin total -> Fin total)
    (A : Matrix system system Rat)
    (h :
      forall row col : Fin system,
        (if embed row = p (embed col) then 1 else 0) = A row col) :
    Matrix.PointwiseEq (cleanBlockBy embed (permMatrix p)) A := by
  intro row col
  exact h row col

/-- Pointwise extension principle for product-register clean blocks. -/
theorem cleanBlockProduct_eq_target_of_entry {ancilla system : Nat}
    (zero : Fin ancilla) (p : Fin (ancilla * system) -> Fin (ancilla * system))
    (A : Matrix system system Rat)
    (h :
      forall row col : Fin system,
        (if productIndex zero row = p (productIndex zero col) then 1 else 0) =
          A row col) :
    Matrix.PointwiseEq (cleanBlockProduct zero (permMatrix p)) A := by
  intro row col
  exact h row col

/-- Kronecker delta over the project-local rational matrix backend. -/
def kroneckerRat {n : Nat} (i j : Fin n) : Rat :=
  if i = j then 1 else 0

/--
Column one-sparse matrix with support map `c`: column `j` has its possible
nonzero entry at row `c j`, with amplitude `amp j`.
-/
def oneSparseMatrix {n : Nat} (c : Fin n -> Fin n) (amp : Fin n -> Rat) :
    Matrix n n Rat :=
  fun row col => amp col * kroneckerRat row (c col)

theorem oneSparseMatrix_entry_if {n : Nat}
    (c : Fin n -> Fin n) (amp : Fin n -> Rat) (row col : Fin n) :
    oneSparseMatrix c amp row col = if row = c col then amp col else 0 := by
  by_cases h : row = c col
  · simp [oneSparseMatrix, kroneckerRat, h]
  · simp [oneSparseMatrix, kroneckerRat, h]

/--
One-sparse reconstruction leaf.  If a target matrix is supported only at
`row = c col`, then its support map and column amplitudes reconstruct it
entrywise.
-/
theorem oneSparse_from_support {n : Nat}
    (A : Matrix n n Rat) (c : Fin n -> Fin n)
    (hSupport : forall row col : Fin n, row ≠ c col -> A row col = 0) :
    Matrix.PointwiseEq (oneSparseMatrix c (fun col => A (c col) col)) A := by
  intro row col
  by_cases h : row = c col
  · subst row
    simp [oneSparseMatrix, kroneckerRat]
  · simp [oneSparseMatrix, kroneckerRat, h, hSupport row col h]


/--
Proof-carrying one-sparse certificate.  This is the exact finite leaf behind
the textbook one-sparse block-encoding route after the amplitude and location
oracles have been reduced to a support map.
-/
structure OneSparseCertificate (n : Nat) where
  supportMap : Fin n -> Fin n
  target : Matrix n n Rat
  supportProof :
    forall row col : Fin n, row ≠ supportMap col -> target row col = 0

namespace OneSparseCertificate

def cleanBlock {n : Nat} (cert : OneSparseCertificate n) : Matrix n n Rat :=
  oneSparseMatrix cert.supportMap (fun col => cert.target (cert.supportMap col) col)

theorem correct {n : Nat} (cert : OneSparseCertificate n) :
    Matrix.PointwiseEq cert.cleanBlock cert.target :=
  oneSparse_from_support cert.target cert.supportMap cert.supportProof

end OneSparseCertificate

/--
Column sparse clean-entry expression: a finite sum over slot indices of value
oracle entries times location deltas.  This is the entrywise target for
Lin-style sparse column proofs before a task attaches its uniqueness lemmas.
-/
def sparseColumnCleanEntry {rows cols slots : Nat}
    (loc : Fin cols -> Fin slots -> Fin rows)
    (value : Fin slots -> Fin cols -> Rat) : Matrix rows cols Rat :=
  fun row col =>
    (List.finRange slots).foldl
      (fun acc slot => acc + value slot col * kroneckerRat row (loc col slot))
      0

private theorem foldlRat_add_zero_of_all_zero {β : Type u}
    (xs : List β) (f : β -> Rat) (acc : Rat)
    (hzero : forall x, x ∈ xs -> f x = 0) :
    xs.foldl (fun acc x => acc + f x) acc = acc := by
  induction xs generalizing acc with
  | nil => rfl
  | cons x xs ih =>
      have hxzero : f x = 0 := hzero x (by simp)
      have htail : forall y, y ∈ xs -> f y = 0 := by
        intro y hy
        exact hzero y (by simp [hy])
      calc
        (x :: xs).foldl (fun acc x => acc + f x) acc =
            xs.foldl (fun acc x => acc + f x) (acc + f x) := rfl
        _ = xs.foldl (fun acc x => acc + f x) acc := by
            rw [hxzero, Rat.add_zero]
        _ = acc := ih acc htail

private theorem foldlRat_add_unique_of_nodup {β : Type u} [DecidableEq β]
    (xs : List β) (f : β -> Rat) (hit : β)
    (hnodup : xs.Nodup)
    (hmem : hit ∈ xs)
    (hzero : forall x, x ∈ xs -> x ≠ hit -> f x = 0) :
    xs.foldl (fun acc x => acc + f x) 0 = f hit := by
  induction xs with
  | nil => cases hmem
  | cons x xs ih =>
      rw [List.nodup_cons] at hnodup
      rcases hnodup with ⟨hx_not_mem, hxs_nodup⟩
      rw [List.mem_cons] at hmem
      rcases hmem with hhead | htail
      · subst hhead
        have htail_zero : forall y, y ∈ xs -> f y = 0 := by
          intro y hy
          have hy_ne : y ≠ hit := by
            intro hy_eq
            apply hx_not_mem
            simpa [hy_eq] using hy
          exact hzero y (by simp [hy]) hy_ne
        calc
          (hit :: xs).foldl (fun acc x => acc + f x) 0 =
              xs.foldl (fun acc x => acc + f x) (0 + f hit) := rfl
          _ = xs.foldl (fun acc x => acc + f x) (f hit) := by
              rw [Rat.zero_add]
          _ = f hit := foldlRat_add_zero_of_all_zero xs f (f hit) htail_zero
      · have hxzero : f x = 0 := by
          have hx_ne : x ≠ hit := by
            intro hx_eq
            apply hx_not_mem
            simpa [hx_eq] using htail
          exact hzero x (by simp) hx_ne
        have htail_zero : forall y, y ∈ xs -> y ≠ hit -> f y = 0 := by
          intro y hy hy_ne
          exact hzero y (by simp [hy]) hy_ne
        calc
          (x :: xs).foldl (fun acc x => acc + f x) 0 =
              xs.foldl (fun acc x => acc + f x) (0 + f x) := rfl
          _ = xs.foldl (fun acc x => acc + f x) 0 := by
              rw [hxzero, Rat.zero_add]
          _ = f hit := ih hxs_nodup htail htail_zero

private theorem nodupMap_of_injective {α : Type u} {β : Type v}
    [DecidableEq β] {f : α -> β} (hf : Function.Injective f)
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
        have hyx : y = x := hf hy_eq
        simpa [hyx] using hy_mem
      · exact ih hxs_nodup

private theorem finRangeNodup (n : Nat) : (List.finRange n).Nodup := by
  induction n with
  | zero => simp [List.finRange_zero]
  | succ n ih =>
      rw [List.finRange_succ]
      rw [List.nodup_cons]
      constructor
      · intro hmem
        rcases List.mem_map.mp hmem with ⟨k, _hk_mem, hk_zero⟩
        exact Fin.succ_ne_zero k hk_zero
      · apply nodupMap_of_injective
        · intro a b h
          apply Fin.eq_of_val_eq
          have hv := congrArg (fun x : Fin (n + 1) => x.val) h
          simpa using Nat.succ.inj hv
        · exact ih

theorem sparseColumnCleanEntry_no_hit {rows cols slots : Nat}
    (loc : Fin cols -> Fin slots -> Fin rows)
    (value : Fin slots -> Fin cols -> Rat)
    (row : Fin rows) (col : Fin cols)
    (hmiss : forall slot : Fin slots, row ≠ loc col slot) :
    sparseColumnCleanEntry loc value row col = 0 := by
  exact foldlRat_add_zero_of_all_zero (List.finRange slots)
    (fun slot => value slot col * kroneckerRat row (loc col slot))
    0
    (by
      intro slot _hmem
      simp [kroneckerRat, hmiss slot])

theorem sparseColumnCleanEntry_unique_slot {rows cols slots : Nat}
    (loc : Fin cols -> Fin slots -> Fin rows)
    (value : Fin slots -> Fin cols -> Rat)
    (row : Fin rows) (col : Fin cols) (hit : Fin slots)
    (hhit : row = loc col hit)
    (hmiss : forall slot : Fin slots, slot ≠ hit -> row ≠ loc col slot) :
    sparseColumnCleanEntry loc value row col = value hit col := by
  calc
    sparseColumnCleanEntry loc value row col =
        value hit col * kroneckerRat row (loc col hit) := by
          exact foldlRat_add_unique_of_nodup (List.finRange slots)
            (fun slot => value slot col * kroneckerRat row (loc col slot))
            hit (finRangeNodup slots) (List.mem_finRange hit)
            (by
              intro slot _hmem hne
              simp [kroneckerRat, hmiss slot hne])
    _ = value hit col := by
        simp [kroneckerRat, hhit]


/--
General row/column sparse delta expression.  A paper-specific route must prove
that row-location and column-location uniqueness collapse this finite double
sum to the target entry divided by the sparsity normalizer.
-/
def rowColumnSparseDeltaEntry {rows cols slots : Nat}
    (colLoc : Fin cols -> Fin slots -> Fin rows)
    (rowLoc : Fin rows -> Fin slots -> Fin cols)
    (value : Fin rows -> Fin cols -> Rat) : Matrix rows cols Rat :=
  fun row col =>
    (List.finRange slots).foldl
      (fun acc slot =>
        acc +
          (List.finRange slots).foldl
            (fun inner rowSlot =>
              inner +
                value (colLoc col slot) col *
                  kroneckerRat row (colLoc col slot) *
                  kroneckerRat col (rowLoc row rowSlot))
            0)
      0

/--
Proof-carrying sparse-column contract.  The contract is not a theorem by
itself; it records the exact clean-entry theorem a paper-specific lower agent
must supply.
-/
structure SparseColumnCertificate (rows cols slots : Nat) where
  cleanBlock : Matrix rows cols Rat
  target : Matrix rows cols Rat
  normalizer : Rat
  locationOracle : String
  valueOracle : String
  blockProof : Matrix.PointwiseEq cleanBlock target

namespace SparseColumnCertificate

theorem correct {rows cols slots : Nat}
    (cert : SparseColumnCertificate rows cols slots) :
    Matrix.PointwiseEq cert.cleanBlock cert.target :=
  cert.blockProof

end SparseColumnCertificate


/-- Proof-carrying row/column sparse contract for the general sparse route. -/
structure RowColumnSparseCertificate (rows cols slots : Nat) where
  cleanBlock : Matrix rows cols Rat
  target : Matrix rows cols Rat
  normalizer : Rat
  columnOracle : String
  rowOracle : String
  valueOracle : String
  blockProof : Matrix.PointwiseEq cleanBlock target

namespace RowColumnSparseCertificate

theorem correct {rows cols slots : Nat}
    (cert : RowColumnSparseCertificate rows cols slots) :
    Matrix.PointwiseEq cert.cleanBlock cert.target :=
  cert.blockProof

end RowColumnSparseCertificate

/--
Value-to-amplitude oracle contract.  A task may use this only after it supplies
both cleanup and amplitude-entry proofs; the record cannot close a proof by
itself.
-/
structure ValueToAmplitudeContract (rows cols : Nat) where
  cleanAmplitude : Matrix rows cols Rat
  targetAmplitude : Matrix rows cols Rat
  valueOracleDescription : String
  rotationDescription : String
  cleanupStatement : Prop
  cleanupProof : cleanupStatement
  amplitudeProof : Matrix.PointwiseEq cleanAmplitude targetAmplitude

namespace ValueToAmplitudeContract

theorem correct {rows cols : Nat} (cert : ValueToAmplitudeContract rows cols) :
    Matrix.PointwiseEq cert.cleanAmplitude cert.targetAmplitude :=
  cert.amplitudeProof

end ValueToAmplitudeContract

/-- Symmetric matrix predicate for the rational backend. -/
def IsSymmetric {n : Nat} (A : Matrix n n Rat) : Prop :=
  forall i j : Fin n, A i j = A j i

/-- A symmetric full matrix has a symmetric clean block under any embedding. -/
theorem cleanBlockBy_symmetric_of_symmetric {system total : Nat}
    (embed : Fin system -> Fin total) (U : Matrix total total Rat)
    (hU : IsSymmetric U) :
    IsSymmetric (cleanBlockBy embed U) := by
  intro row col
  exact hU (embed row) (embed col)

/-- Two-by-two scalar dilation block.  Unitarity requires a separate norm proof. -/
def fin2Zero : Fin 2 := ⟨0, by decide⟩

def fin2One : Fin 2 := ⟨1, by decide⟩

def scalarDilation (x y : Rat) : Matrix 2 2 Rat :=
  fun row col =>
    if row = fin2Zero ∧ col = fin2Zero then x
    else if row = fin2Zero ∧ col = fin2One then y
    else if row = fin2One ∧ col = fin2Zero then y
    else -x

@[simp] theorem scalarDilation_cleanEntry (x y : Rat) :
    scalarDilation x y fin2Zero fin2Zero = x := by
  simp [scalarDilation, fin2Zero]

@[simp] theorem scalarDilation_offdiag01 (x y : Rat) :
    scalarDilation x y fin2Zero fin2One = y := by
  simp [scalarDilation, fin2Zero, fin2One]

@[simp] theorem scalarDilation_offdiag10 (x y : Rat) :
    scalarDilation x y fin2One fin2Zero = y := by
  simp [scalarDilation, fin2Zero, fin2One]

@[simp] theorem scalarDilation_diag11 (x y : Rat) :
    scalarDilation x y fin2One fin2One = -x := by
  simp [scalarDilation, fin2Zero, fin2One]

/-- Two-entry row dot product for the scalar dilation block. -/
def scalarDilationRowDot (x y : Rat) (rowA rowB : Fin 2) : Rat :=
  scalarDilation x y rowA fin2Zero * scalarDilation x y rowB fin2Zero +
    scalarDilation x y rowA fin2One * scalarDilation x y rowB fin2One

theorem scalarDilation_row0_normSq (x y : Rat) :
    scalarDilationRowDot x y fin2Zero fin2Zero = x * x + y * y := by
  simp [scalarDilationRowDot]

theorem scalarDilation_row1_normSq (x y : Rat) :
    scalarDilationRowDot x y fin2One fin2One = x * x + y * y := by
  simp [scalarDilationRowDot]
  rw [show (-x) * (-x) = x * x by
    rw [Rat.neg_mul]
    rw [Rat.mul_neg]
    rw [Rat.neg_neg]]
  exact Rat.add_comm (y * y) (x * x)

theorem scalarDilation_row0_unit_norm_of (x y : Rat)
    (hunit : x * x + y * y = 1) :
    scalarDilationRowDot x y fin2Zero fin2Zero = 1 := by
  rw [scalarDilation_row0_normSq, hunit]

theorem scalarDilation_row1_unit_norm_of (x y : Rat)
    (hunit : x * x + y * y = 1) :
    scalarDilationRowDot x y fin2One fin2One = 1 := by
  rw [scalarDilation_row1_normSq, hunit]

theorem scalarDilation_rows01_orthogonal (x y : Rat) :
    scalarDilationRowDot x y fin2Zero fin2One = 0 := by
  simp [scalarDilationRowDot]
  rw [Rat.mul_neg]
  rw [Rat.mul_comm y x]
  exact Rat.add_neg_cancel (x * y)

theorem scalarDilation_rows10_orthogonal (x y : Rat) :
    scalarDilationRowDot x y fin2One fin2Zero = 0 := by
  simp [scalarDilationRowDot]
  rw [Rat.neg_mul]
  rw [Rat.mul_comm x y]
  exact Rat.add_neg_cancel (y * x)

/-- Chebyshev polynomial values, kept as a small executable recurrence. -/
def chebyshevT : Nat -> Rat -> Rat
  | 0, _ => 1
  | 1, x => x
  | n + 2, x => 2 * x * chebyshevT (n + 1) x - chebyshevT n x

@[simp] theorem chebyshevT_zero (x : Rat) : chebyshevT 0 x = 1 := rfl

@[simp] theorem chebyshevT_one (x : Rat) : chebyshevT 1 x = x := rfl

theorem chebyshevT_two (x : Rat) : chebyshevT 2 x = 2 * x * x - 1 := rfl

theorem chebyshevT_succ_succ (n : Nat) (x : Rat) :
    chebyshevT (n + 2) x = 2 * x * chebyshevT (n + 1) x - chebyshevT n x := by
  rfl

theorem chebyshevT_three_recurrence (x : Rat) :
    chebyshevT 3 x = 2 * x * (2 * x * x - 1) - x := rfl

theorem chebyshevT_four_recurrence (x : Rat) :
    chebyshevT 4 x = 2 * x * chebyshevT 3 x - chebyshevT 2 x := rfl

/--
Proof-carrying exact clean-block package.  This is smaller than the full
operator-candidate record and is intended for reusable theorem arithmetic.
-/
structure ExactCleanBlock (system total : Nat) where
  U : Matrix total total Rat
  A : Matrix system system Rat
  embed : Fin system -> Fin total
  blockProof : Matrix.PointwiseEq (cleanBlockBy embed U) A

namespace ExactCleanBlock

/-- The certified clean block associated with a proof-carrying package. -/
def clean {system total : Nat} (cert : ExactCleanBlock system total) :
    Matrix system system Rat :=
  cleanBlockBy cert.embed cert.U

theorem clean_eq_target {system total : Nat}
    (cert : ExactCleanBlock system total) :
    Matrix.PointwiseEq cert.clean cert.A :=
  cert.blockProof

end ExactCleanBlock

/--
Qubitization/Chebyshev proof-carrying contract.  The full qubitization theorem
will instantiate this after the two-dimensional invariant-subspace calculation
is formalized.
-/
structure QubitizationChebyshevContract (system total : Nat) where
  input : ExactCleanBlock system total
  degree : Nat
  output : Matrix system system Rat
  sideConditions : Prop
  chebyshevStatement : Prop
  sideConditionProof : sideConditions
  chebyshevProof : chebyshevStatement

/--
Abstract partial-permutation certificate.  A concrete task supplies the
embedding, finite image, target matrix, and image-entry theorem; this wrapper
returns a reusable exact clean-block certificate.
-/
def partialPermutationCertificate {system total : Nat}
    (embed : Fin system -> Fin total) (p : Fin total -> Fin total)
    (A : Matrix system system Rat)
    (h :
      forall row col : Fin system,
        (if embed row = p (embed col) then 1 else 0) = A row col) :
    ExactCleanBlock system total where
  U := permMatrix p
  A := A
  embed := embed
  blockProof := cleanBlockBy_permMatrix_eq_target_of_entry embed p A h

/--
One-term LCU leaf.  It is mathematically trivial, but useful for proof-DAG
normalization: when an LCU population collapses to one term, the selected block
is just that term.
-/
def oneTermLCU (A : Matrix system system Rat) : Matrix system system Rat :=
  A

theorem oneTermLCU_cleanBlock (A : Matrix system system Rat) :
    Matrix.PointwiseEq (oneTermLCU A) A := by
  intro row col
  rfl


/-- Pointwise scalar multiplication for the project-local matrix backend. -/
def matrixScale (c : Rat) (A : Matrix rows cols Rat) : Matrix rows cols Rat :=
  fun row col => c * A row col

/-- Pointwise addition for the project-local matrix backend. -/
def matrixAdd (A B : Matrix rows cols Rat) : Matrix rows cols Rat :=
  fun row col => A row col + B row col

/-- Two-term weighted sum, the finite clean-block algebra behind a 2-term LCU. -/
def weightedSum2 (leftWeight rightWeight : Rat)
    (left right : Matrix rows cols Rat) : Matrix rows cols Rat :=
  fun row col => leftWeight * left row col + rightWeight * right row col

theorem weightedSum2_entry {rows cols : Nat}
    (leftWeight rightWeight : Rat)
    (left right : Matrix rows cols Rat) (row : Fin rows) (col : Fin cols) :
    weightedSum2 leftWeight rightWeight left right row col =
      leftWeight * left row col + rightWeight * right row col := rfl

theorem weightedSum2_congr_pointwise {rows cols : Nat}
    {A A' B B' : Matrix rows cols Rat}
    (leftWeight rightWeight : Rat)
    (hA : Matrix.PointwiseEq A A') (hB : Matrix.PointwiseEq B B') :
    Matrix.PointwiseEq
      (weightedSum2 leftWeight rightWeight A B)
      (weightedSum2 leftWeight rightWeight A' B') := by
  intro row col
  simp [weightedSum2, hA row col, hB row col]

/--
Proof-carrying LCU contract.  Full PREPARE-SELECT algebra can later instantiate
`cleanBlock`; downstream arithmetic should only depend on the exposed
`blockProof`.
-/
structure LCUCertificate (system : Nat) where
  cleanBlock : Matrix system system Rat
  target : Matrix system system Rat
  normalizer : Rat
  termCount : Nat
  blockProof : Matrix.PointwiseEq cleanBlock target

namespace LCUCertificate

theorem correct {system : Nat} (cert : LCUCertificate system) :
    Matrix.PointwiseEq cert.cleanBlock cert.target :=
  cert.blockProof

end LCUCertificate


/--
Two-term LCU arithmetic after both selected clean blocks have already been
proved.  Full PREPARE-SELECT-PREPARE dagger semantics should instantiate this
leaf after proving the selected clean block equals the weighted sum.
-/
def twoTermLCUCertificate {system : Nat}
    (left right : LCUCertificate system)
    (leftWeight rightWeight : Rat) : LCUCertificate system where
  cleanBlock := weightedSum2 leftWeight rightWeight left.cleanBlock right.cleanBlock
  target := weightedSum2 leftWeight rightWeight left.target right.target
  normalizer := leftWeight * left.normalizer + rightWeight * right.normalizer
  termCount := left.termCount + right.termCount
  blockProof :=
    weightedSum2_congr_pointwise leftWeight rightWeight
      left.blockProof right.blockProof

theorem twoTermLCUCertificate_cleanBlock_entry {system : Nat}
    (left right : LCUCertificate system)
    (leftWeight rightWeight : Rat)
    (row col : Fin system) :
    (twoTermLCUCertificate left right leftWeight rightWeight).cleanBlock row col =
      leftWeight * left.target row col + rightWeight * right.target row col := by
  simp [twoTermLCUCertificate, weightedSum2,
    left.blockProof row col, right.blockProof row col]

/-- Promote an exact clean-block certificate to the LCU-style arithmetic layer. -/
def ExactCleanBlock.toLCUCertificate {system total : Nat}
    (cert : ExactCleanBlock system total) (normalizer : Rat := 1) :
    LCUCertificate system where
  cleanBlock := cert.clean
  target := cert.A
  normalizer := normalizer
  termCount := 1
  blockProof := cert.blockProof

/--
Product arithmetic at the exact clean-block level.  This is the shared proof
leaf behind GSLW-style product lemmas once the embedded clean-block identities
have been reduced to project-local matrices.
-/
private theorem matrix_mul_foldl_congr {rows mid cols : Nat}
    {A A' : Matrix rows mid Rat} {B B' : Matrix mid cols Rat}
    (hA : Matrix.PointwiseEq A A') (hB : Matrix.PointwiseEq B B')
    (row : Fin rows) (col : Fin cols) (xs : List (Fin mid))
    (acc acc' : Rat) (hacc : acc = acc') :
    xs.foldl (fun acc k => acc + A row k * B k col) acc =
      xs.foldl (fun acc k => acc + A' row k * B' k col) acc' := by
  induction xs generalizing acc acc' with
  | nil =>
      simp [hacc]
  | cons k ks ih =>
      apply ih
      simp [hacc, hA row k, hB k col]

theorem matrix_mul_congr_pointwise {rows mid cols : Nat}
    {A A' : Matrix rows mid Rat} {B B' : Matrix mid cols Rat}
    (hA : Matrix.PointwiseEq A A') (hB : Matrix.PointwiseEq B B') :
    Matrix.PointwiseEq (Matrix.mul A B) (Matrix.mul A' B') := by
  intro row col
  exact matrix_mul_foldl_congr hA hB row col (List.finRange mid) 0 0 rfl

/-- Exact product certificate for already-extracted clean blocks. -/
def productCleanBlockCertificate {rows : Nat}
    (left : LCUCertificate rows) -- target square case used by current tasks
    (right : LCUCertificate rows) :
    LCUCertificate rows where
  cleanBlock := Matrix.mul left.cleanBlock right.cleanBlock
  target := Matrix.mul left.target right.target
  normalizer := left.normalizer * right.normalizer
  termCount := left.termCount * right.termCount
  blockProof := matrix_mul_congr_pointwise left.blockProof right.blockProof

/-- Product bridge for exact clean-block certificates via the arithmetic layer. -/
def productExactCleanBlockCertificate {system totalLeft totalRight : Nat}
    (left : ExactCleanBlock system totalLeft)
    (right : ExactCleanBlock system totalRight) : LCUCertificate system :=
  productCleanBlockCertificate
    (ExactCleanBlock.toLCUCertificate left)
    (ExactCleanBlock.toLCUCertificate right)

/-- Tensor-style resource score: parallel depth is the maximum of two depths. -/
def tensorResourceCost (x y : BlockEncodingCost) : BlockEncodingCost where
  auxiliaryQubits := x.auxiliaryQubits + y.auxiliaryQubits
  gateCount := x.gateCount + y.gateCount
  depth := max x.depth y.depth
  oracleCalls := x.oracleCalls + y.oracleCalls

theorem tensorResourceCost_gateCount (x y : BlockEncodingCost) :
    (tensorResourceCost x y).gateCount = x.gateCount + y.gateCount := rfl

theorem tensorResourceCost_depth (x y : BlockEncodingCost) :
    (tensorResourceCost x y).depth = max x.depth y.depth := rfl

/-- Product-style resource score: sequential depth adds. -/
def productResourceCost (x y : BlockEncodingCost) : BlockEncodingCost where
  auxiliaryQubits := x.auxiliaryQubits + y.auxiliaryQubits
  gateCount := x.gateCount + y.gateCount
  depth := x.depth + y.depth
  oracleCalls := x.oracleCalls + y.oracleCalls

theorem productResourceCost_depth (x y : BlockEncodingCost) :
    (productResourceCost x y).depth = x.depth + y.depth := rfl

/--
Hermitian-dilation target shape.  The complete block-matrix construction will
live in a richer matrix backend; the important reusable Lean leaf is that a
non-Hermitian target is explicitly converted into a named downstream target,
not silently treated as Hermitian.
-/
structure HermitianDilationContract (n : Nat) where
  source : Matrix n n Rat
  dilation : Matrix (2 * n) (2 * n) Rat
  entryFormula : Prop
  entryProof : entryFormula

/--
QSVT consumer contract.  QSVT is deliberately downstream of a proved block
encoding: this record cannot be built without an input block certificate.
-/
structure QSVTConsumerContract (system total : Nat) where
  input : ExactCleanBlock system total
  polynomialDescription : String
  sideConditions : Prop
  outputStatement : Prop
  sideConditionProof : sideConditions
  outputProof : outputStatement

/-- Zero-error approximate incumbent at the clean-block level. -/
structure ZeroErrorApproxCleanBlock (system total : Nat) where
  exact : ExactCleanBlock system total
  epsilon : Rat := 0
  approximationBound : Prop :=
    Matrix.PointwiseEq (cleanBlockBy exact.embed exact.U) exact.A
  approximationProof : approximationBound

/--
Any exact clean-block certificate can be used as a zero-error approximate
incumbent in the adaptive exact-to-approximate ABEIS policy.
-/
def exactAsZeroErrorApproxCleanBlock {system total : Nat}
    (cert : ExactCleanBlock system total) :
    ZeroErrorApproxCleanBlock system total where
  exact := cert
  epsilon := 0
  approximationBound := Matrix.PointwiseEq (cleanBlockBy cert.embed cert.U) cert.A
  approximationProof := cert.blockProof

theorem exactAsZeroErrorApproxCleanBlock_bound {system total : Nat}
    (cert : ExactCleanBlock system total) :
    (exactAsZeroErrorApproxCleanBlock cert).approximationBound :=
  cert.blockProof

end BlockEncodingClassics
end QuantumBlockEncoding
