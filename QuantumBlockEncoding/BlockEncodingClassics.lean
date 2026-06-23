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
