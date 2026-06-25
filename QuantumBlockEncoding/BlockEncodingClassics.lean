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

/-- Chebyshev polynomial values, kept as a small executable recurrence. -/
def chebyshevT : Nat -> Rat -> Rat
  | 0, _ => 1
  | 1, x => x
  | n + 2, x => 2 * x * chebyshevT (n + 1) x - chebyshevT n x

@[simp] theorem chebyshevT_zero (x : Rat) : chebyshevT 0 x = 1 := rfl

@[simp] theorem chebyshevT_one (x : Rat) : chebyshevT 1 x = x := rfl

theorem chebyshevT_two (x : Rat) : chebyshevT 2 x = 2 * x * x - 1 := rfl

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
