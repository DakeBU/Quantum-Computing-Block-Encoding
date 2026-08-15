import QuantumBlockEncoding.GHLHamiltonian

namespace QuantumBlockEncoding.GHL2025.Hamiltonian

variable {η ι ξ : Type*} [Fintype η] [DecidableEq ξ]

example (A B : CMatrix ι ι) :
    ∀ i j,
      homogenizedS A B i j =
        S1 A B i j + Complex.I * S2 A B i j :=
  homogenizedS_eq_S1_add_iS2 A B

example (A B : CMatrix ι ι) : IsHermitian (S1 A B) :=
  S1_isHermitian A B

example (A B : CMatrix ι ι) : IsHermitian (S2 A B) :=
  S2_isHermitian A B

example (cert : OneDimCompositionCertificate η ι ξ) :
    cert.Adagger = sumTerms (fun k => adjoint (cert.terms k)) :=
  cert.Adagger_eq_sum_term_adjoints

example (cert : OneDimCompositionCertificate η ι ξ) :
    ∀ i j,
      cert.S i j = cert.first i j + Complex.I * cert.second i j :=
  cert.S_decomposition

example (cert : OneDimCompositionCertificate η ι ξ) :
    IsHermitian cert.H :=
  cert.H_isHermitian

example (cert : OneDimCompositionCertificate η ι ξ) :
    cert.H = add (tensor cert.first cert.xXi)
      (tensor cert.second (identity ξ)) :=
  cert.H_eq_S1_tensor_xXi_add_S2_tensor_I

end QuantumBlockEncoding.GHL2025.Hamiltonian
