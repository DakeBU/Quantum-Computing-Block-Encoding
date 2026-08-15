import QuantumBlockEncoding.GHL2025
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

/-!
# GHL one-dimensional Hamiltonian composition

This module formalizes the composition step that follows the one-term Robin
block encodings in Guseynov--Huang--Liu. The paper first combines the
one-term matrices `A_k` into `A`, homogenizes the inhomogeneous system as
`S = [[A,B],[0,0]]`, splits `S` into Hermitian pieces `S₁,S₂`, and finally
forms `H = S₁ ⊗ x_ξ + S₂ ⊗ I_ξ`.

The scope here is deliberately source-level matrix algebra and composition.
Primitive synthesis for arbitrary-width input oracles is a different layer;
the fixed `N = 8` Robin source circuits are certified in `Robin/Figure4T3.lean`.
-/

namespace QuantumBlockEncoding
namespace GHL2025
namespace Hamiltonian

open scoped BigOperators ComplexConjugate

noncomputable section

/-- Complex conjugation fixes the real scalar two. -/
@[simp] theorem conj_two : conj (2 : ℂ) = 2 := by
  simpa using (Complex.conj_ofNat 2)

/-- Complex finite matrix with arbitrary finite basis type. -/
abbrev CMatrix (ι κ : Type*) := _root_.Matrix ι κ ℂ

/-- Entrywise addition, kept explicit so source formulas remain readable. -/
def add (A B : CMatrix ι κ) : CMatrix ι κ :=
  fun i j => A i j + B i j

/-- Entrywise subtraction. -/
def sub (A B : CMatrix ι κ) : CMatrix ι κ :=
  fun i j => A i j - B i j

/-- Scalar multiplication. -/
def scale (c : ℂ) (A : CMatrix ι κ) : CMatrix ι κ :=
  fun i j => c * A i j

/-- The matrix adjoint written directly as conjugate transpose. -/
def adjoint (A : CMatrix ι ι) : CMatrix ι ι :=
  fun i j => conj (A j i)

/-- Source-level Hermitian predicate. -/
def IsHermitian (A : CMatrix ι ι) : Prop :=
  ∀ i j, A i j = conj (A j i)

/-- The Hermitian part `(A + A†)/2`. -/
def hermitianPart (A : CMatrix ι ι) : CMatrix ι ι :=
  fun i j => (A i j + conj (A j i)) / 2

/-- The second Hermitian piece `(A - A†)/(2i)`. -/
def antiHermitianPart (A : CMatrix ι ι) : CMatrix ι ι :=
  fun i j => (A i j - conj (A j i)) / (2 * Complex.I)

/-- The two canonical pieces reconstruct the original matrix. -/
theorem hermitian_decomposition (A : CMatrix ι ι) :
    ∀ i j, A i j = hermitianPart A i j + Complex.I * antiHermitianPart A i j := by
  intro i j
  simp only [hermitianPart, antiHermitianPart]
  have hI : (2 : ℂ) * Complex.I ≠ 0 :=
    mul_ne_zero (by norm_num) Complex.I_ne_zero
  field_simp [hI]
  ring

/-- `(A + A†)/2` is Hermitian for every complex matrix `A`. -/
theorem hermitianPart_isHermitian (A : CMatrix ι ι) :
    IsHermitian (hermitianPart A) := by
  intro i j
  simp [hermitianPart, add_comm]

/-- `(A - A†)/(2i)` is Hermitian for every complex matrix `A`. -/
theorem antiHermitianPart_isHermitian (A : CMatrix ι ι) :
    IsHermitian (antiHermitianPart A) := by
  intro i j
  simp [antiHermitianPart]
  have hI : Complex.I ≠ 0 := Complex.I_ne_zero
  field_simp [hI]
  ring

/-- Sum of the paper's one-term matrices `A_k`. -/
def sumTerms {η : Type*} [Fintype η]
    (terms : η → CMatrix ι ι) : CMatrix ι ι :=
  fun i j => ∑ k, terms k i j

@[simp] theorem sumTerms_entry {η : Type*} [Fintype η]
    (terms : η → CMatrix ι ι) (i j : ι) :
    sumTerms terms i j = ∑ k, terms k i j := rfl

/-- Taking the adjoint commutes with the paper's finite sum of one-term matrices. -/
theorem adjoint_sumTerms {η : Type*} [Fintype η]
    (terms : η → CMatrix ι ι) :
    adjoint (sumTerms terms) = sumTerms (fun k => adjoint (terms k)) := by
  funext i j
  simp [adjoint, sumTerms]

/--
Homogenized matrix from the paper, on the direct-sum basis `ι ⊕ ι`:
`S = [[A,B],[0,0]]`.
-/
def homogenizedS (A B : CMatrix ι ι) : CMatrix (Sum ι ι) (Sum ι ι) :=
  fun row col =>
    match row, col with
    | Sum.inl i, Sum.inl j => A i j
    | Sum.inl i, Sum.inr j => B i j
    | Sum.inr _, Sum.inl _ => 0
    | Sum.inr _, Sum.inr _ => 0

/-- `S₁ = (S + S†)/2`. -/
def S1 (A B : CMatrix ι ι) : CMatrix (Sum ι ι) (Sum ι ι) :=
  hermitianPart (homogenizedS A B)

/-- `S₂ = (S - S†)/(2i)`. -/
def S2 (A B : CMatrix ι ι) : CMatrix (Sum ι ι) (Sum ι ι) :=
  antiHermitianPart (homogenizedS A B)

/-- The homogenized matrix is exactly `S₁ + i S₂`. -/
theorem homogenizedS_eq_S1_add_iS2 (A B : CMatrix ι ι) :
    ∀ i j,
      homogenizedS A B i j =
        S1 A B i j + Complex.I * S2 A B i j := by
  exact hermitian_decomposition (homogenizedS A B)

/-- The two Schrödingerisation pieces are Hermitian. -/
theorem S1_isHermitian (A B : CMatrix ι ι) : IsHermitian (S1 A B) :=
  hermitianPart_isHermitian _

theorem S2_isHermitian (A B : CMatrix ι ι) : IsHermitian (S2 A B) :=
  antiHermitianPart_isHermitian _

/-- Paper Eq. (18), upper-left block of `S₁`. -/
theorem S1_upperLeft (A B : CMatrix ι ι) (i j : ι) :
    S1 A B (Sum.inl i) (Sum.inl j) =
      (A i j + conj (A j i)) / 2 := by
  rfl

/-- Paper Eq. (18), upper-right block of `S₁`. -/
theorem S1_upperRight (A B : CMatrix ι ι) (i j : ι) :
    S1 A B (Sum.inl i) (Sum.inr j) = B i j / 2 := by
  simp [S1, hermitianPart, homogenizedS]

/-- Under the paper's Hermitian `B`, the lower-left block of `S₁` is `B/2`. -/
theorem S1_lowerLeft_of_B_hermitian (A B : CMatrix ι ι)
    (hB : IsHermitian B) (i j : ι) :
    S1 A B (Sum.inr i) (Sum.inl j) = B i j / 2 := by
  simp [S1, hermitianPart, homogenizedS, ← hB i j]

@[simp] theorem S1_lowerRight (A B : CMatrix ι ι) (i j : ι) :
    S1 A B (Sum.inr i) (Sum.inr j) = 0 := by
  simp [S1, hermitianPart, homogenizedS]

/-- Paper Eq. (18), upper-left block of `S₂`. -/
theorem S2_upperLeft (A B : CMatrix ι ι) (i j : ι) :
    S2 A B (Sum.inl i) (Sum.inl j) =
      (A i j - conj (A j i)) / (2 * Complex.I) := by
  rfl

/-- Paper Eq. (18), upper-right block of `S₂`. -/
theorem S2_upperRight (A B : CMatrix ι ι) (i j : ι) :
    S2 A B (Sum.inl i) (Sum.inr j) = B i j / (2 * Complex.I) := by
  simp [S2, antiHermitianPart, homogenizedS]

/-- Under Hermitian `B`, the lower-left block is `-B/(2i)`. -/
theorem S2_lowerLeft_of_B_hermitian (A B : CMatrix ι ι)
    (hB : IsHermitian B) (i j : ι) :
    S2 A B (Sum.inr i) (Sum.inl j) = -(B i j) / (2 * Complex.I) := by
  simp [S2, antiHermitianPart, homogenizedS, ← hB i j]

@[simp] theorem S2_lowerRight (A B : CMatrix ι ι) (i j : ι) :
    S2 A B (Sum.inr i) (Sum.inr j) = 0 := by
  simp [S2, antiHermitianPart, homogenizedS]

/-- Matrix identity on an arbitrary finite basis. -/
def identity (ι : Type*) [DecidableEq ι] : CMatrix ι ι :=
  fun i j => if i = j then 1 else 0

/-- Kronecker product in explicit product-index form. -/
def tensor (A : CMatrix ι ι) (B : CMatrix κ κ) :
    CMatrix (ι × κ) (ι × κ) :=
  fun row col => A row.1 col.1 * B row.2 col.2

/-- The paper's one-dimensional Hamiltonian `H = S₁⊗x_ξ + S₂⊗I_ξ`. -/
def oneDimHamiltonian [DecidableEq ξ]
    (A B : CMatrix ι ι) (xXi : CMatrix ξ ξ) :
    CMatrix ((Sum ι ι) × ξ) ((Sum ι ι) × ξ) :=
  add (tensor (S1 A B) xXi) (tensor (S2 A B) (identity ξ))

@[simp] theorem oneDimHamiltonian_entry [DecidableEq ξ]
    (A B : CMatrix ι ι) (xXi : CMatrix ξ ξ)
    (row col : (Sum ι ι) × ξ) :
    oneDimHamiltonian A B xXi row col =
      S1 A B row.1 col.1 * xXi row.2 col.2 +
      S2 A B row.1 col.1 * (if row.2 = col.2 then 1 else 0) := by
  rfl

/-- The identity matrix is Hermitian. -/
theorem identity_isHermitian [DecidableEq ι] : IsHermitian (identity ι) := by
  intro i j
  by_cases h : i = j
  · subst j
    simp [identity]
  · have h' : j ≠ i := fun hji => h hji.symm
    simp [identity, h, h']

/-- Tensor products of Hermitian matrices are Hermitian. -/
theorem tensor_isHermitian (A : CMatrix ι ι) (B : CMatrix κ κ)
    (hA : IsHermitian A) (hB : IsHermitian B) :
    IsHermitian (tensor A B) := by
  intro row col
  simp only [tensor, map_mul]
  rw [← hA row.1 col.1, ← hB row.2 col.2]

/-- Sums of Hermitian matrices are Hermitian. -/
theorem add_isHermitian (A B : CMatrix ι ι)
    (hA : IsHermitian A) (hB : IsHermitian B) :
    IsHermitian (add A B) := by
  intro i j
  simp only [add, map_add]
  rw [← hA i j, ← hB i j]

/-- The paper's `H` is Hermitian whenever the coordinate operator is. -/
theorem oneDimHamiltonian_isHermitian [DecidableEq ξ]
    (A B : CMatrix ι ι) (xXi : CMatrix ξ ξ)
    (hx : IsHermitian xXi) :
    IsHermitian (oneDimHamiltonian A B xXi) := by
  apply add_isHermitian
  · exact tensor_isHermitian _ _ (S1_isHermitian A B) hx
  · exact tensor_isHermitian _ _ (S2_isHermitian A B) identity_isHermitian

/--
Proof-carrying source bundle for Theorem 4. It records the paper's exact
composition data: one-term matrices, the inhomogeneous block `B`, and
the Schrödingerisation coordinate `x_ξ`.
-/
structure OneDimCompositionCertificate (η ι ξ : Type*)
    [Fintype η] [DecidableEq ξ] where
  terms : η → CMatrix ι ι
  B : CMatrix ι ι
  xXi : CMatrix ξ ξ
  B_hermitian : IsHermitian B
  xXi_hermitian : IsHermitian xXi

namespace OneDimCompositionCertificate

variable {η ι ξ : Type*} [Fintype η] [DecidableEq ξ]

/-- `A = Σ_k A_k`, exactly as in Theorem 4. -/
def A (cert : OneDimCompositionCertificate η ι ξ) : CMatrix ι ι :=
  sumTerms cert.terms

/-- `A†`, exposed as a named stage because Theorem 4 combines both `A` and `A†`. -/
def Adagger (cert : OneDimCompositionCertificate η ι ξ) : CMatrix ι ι :=
  adjoint cert.A

/-- The adjoint assembled from the one-term adjoints equals the adjoint of `A`. -/
theorem Adagger_eq_sum_term_adjoints
    (cert : OneDimCompositionCertificate η ι ξ) :
    cert.Adagger = sumTerms (fun k => adjoint (cert.terms k)) := by
  exact adjoint_sumTerms cert.terms

/-- Homogenized source matrix `S = [[A,B],[0,0]]`. -/
def S (cert : OneDimCompositionCertificate η ι ξ) :
    CMatrix (Sum ι ι) (Sum ι ι) :=
  homogenizedS cert.A cert.B

/-- First Hermitian source block. -/
def first (cert : OneDimCompositionCertificate η ι ξ) :=
  S1 cert.A cert.B

/-- Second Hermitian source block. -/
def second (cert : OneDimCompositionCertificate η ι ξ) :=
  S2 cert.A cert.B

/-- Final Schrödingerised Hamiltonian. -/
def H (cert : OneDimCompositionCertificate η ι ξ) :=
  oneDimHamiltonian cert.A cert.B cert.xXi

/-- The certificate reconstructs `S` from the two Hermitian pieces. -/
theorem S_decomposition (cert : OneDimCompositionCertificate η ι ξ) :
    ∀ i j, cert.S i j = cert.first i j + Complex.I * cert.second i j := by
  exact homogenizedS_eq_S1_add_iS2 cert.A cert.B

/-- The final source-level Hamiltonian is Hermitian. -/
theorem H_isHermitian (cert : OneDimCompositionCertificate η ι ξ) :
    IsHermitian cert.H := by
  exact oneDimHamiltonian_isHermitian cert.A cert.B cert.xXi cert.xXi_hermitian

/-- Theorem 4 target formula is definitional in the proof-carrying bundle. -/
theorem H_eq_S1_tensor_xXi_add_S2_tensor_I
    (cert : OneDimCompositionCertificate η ι ξ) :
    cert.H = add (tensor cert.first cert.xXi)
      (tensor cert.second (identity ξ)) := by
  rfl

end OneDimCompositionCertificate

/-- The paper registry's 1D target is exactly the composition formalized here. -/
theorem oneDimHamiltonianClaim_target_closed :
    oneDimHamiltonianClaim.target = "H = S1 tensor x_xi + S2 tensor I_xi" := by
  rfl

/-- Theorem 4's resource expression is the registered source expression. -/
theorem oneDimHamiltonianClaim_resource_closed :
    oneDimHamiltonianClaim.resource = oneDimHamiltonianResourceExpr := by
  rfl

end

end Hamiltonian
end GHL2025
end QuantumBlockEncoding
