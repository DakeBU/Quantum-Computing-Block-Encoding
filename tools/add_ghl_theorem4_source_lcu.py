#!/usr/bin/env python3
from pathlib import Path

path = Path('QuantumBlockEncoding/GHLHamiltonian.lean')
text = path.read_text(encoding='utf-8')
if 'theorem theorem4_source_lcu_route_closed' in text:
    raise SystemExit(0)

anchor = '''/-- Matrix identity on an arbitrary finite basis. -/\ndef identity (ι : Type*) [DecidableEq ι] : CMatrix ι ι :=\n  fun i j => if i = j then 1 else 0\n'''
if anchor not in text:
    raise SystemExit('identity anchor missing')

insert = anchor + r'''

/--
The clean-block matrix contributed by `N_A L₁(φ)` or `N_A L₂(φ)` in Eq. (29).
The upper block is already rescaled from `A/N_A` to `A`; the lower filler block
is `N_A e^{iφ} I`.  We expose the filler because cancellation of these entries
is a real source-level proof obligation in the next LCU.
-/
def scaledControlledPhaseSource [DecidableEq ι]
    (upper : CMatrix ι ι) (normalizer phase : ℂ) :
    CMatrix (Sum ι ι) (Sum ι ι) :=
  fun row col =>
    match row, col with
    | Sum.inl i, Sum.inl j => upper i j
    | Sum.inr i, Sum.inr j => if i = j then normalizer * phase else 0
    | _, _ => 0

/-- `X ⊗ B` in the paper's Eq. (30), written on the `ι ⊕ ι` basis. -/
def pauliXTensor (B : CMatrix ι ι) : CMatrix (Sum ι ι) (Sum ι ι) :=
  fun row col =>
    match row, col with
    | Sum.inl i, Sum.inr j => B i j
    | Sum.inr i, Sum.inl j => B i j
    | _, _ => 0

/-- `Y ⊗ B` in the paper's Eq. (30), written on the `ι ⊕ ι` basis. -/
def pauliYTensor (B : CMatrix ι ι) : CMatrix (Sum ι ι) (Sum ι ι) :=
  fun row col =>
    match row, col with
    | Sum.inl i, Sum.inr j => -Complex.I * B i j
    | Sum.inr i, Sum.inl j => Complex.I * B i j
    | _, _ => 0

/--
Literal clean-block algebra of the first line of the printed Eq. (30): both
filler phases are `e^{±iπ} = -1`.  The selected `A,A†,B` entries are correct,
but the lower-right filler blocks add instead of canceling.
-/
def eq29PrintedClean [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ) :
    CMatrix (Sum ι ι) (Sum ι ι) :=
  add
    (scale (1 / 2 : ℂ) (scaledControlledPhaseSource A normalizerA (-1)))
    (add
      (scale (1 / 2 : ℂ)
        (scaledControlledPhaseSource (adjoint A) normalizerA (-1)))
      (scale (1 / 2 : ℂ) (pauliXTensor B)))

/--
Phase-balanced interpretation of the first line of Eq. (30).  Replacing one of
the two equal `π,-π` filler phases by phase `0` makes the irrelevant identity
blocks cancel while preserving the desired `A` and `A†` clean blocks.
-/
def eq29PhaseBalancedClean [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ) :
    CMatrix (Sum ι ι) (Sum ι ι) :=
  add
    (scale (1 / 2 : ℂ) (scaledControlledPhaseSource A normalizerA 1))
    (add
      (scale (1 / 2 : ℂ)
        (scaledControlledPhaseSource (adjoint A) normalizerA (-1)))
      (scale (1 / 2 : ℂ) (pauliXTensor B)))

/-- The printed Eq. (29) leaves the lower-right clean filler equal to `-N_A`. -/
theorem eq29PrintedClean_lowerRight [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ) (i : ι) :
    eq29PrintedClean A B normalizerA (Sum.inr i) (Sum.inr i) = -normalizerA := by
  simp [eq29PrintedClean, add, scale, scaledControlledPhaseSource]
  ring

/-- Therefore the literal printed phase choice cannot equal `S₁` when `N_A ≠ 0`. -/
theorem eq29PrintedClean_ne_S1 [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ) (i : ι)
    (hN : normalizerA ≠ 0) :
    eq29PrintedClean A B normalizerA ≠ S1 A B := by
  intro h
  have hentry := congrFun (congrFun h (Sum.inr i)) (Sum.inr i)
  rw [eq29PrintedClean_lowerRight] at hentry
  simp [S1, hermitianPart, homogenizedS] at hentry
  exact hN (neg_eq_zero.mp hentry)

/--
The phase-balanced Eq. (29) clean block is exactly the paper's `S₁` whenever
`B` is Hermitian (in the PDE theorem `B` is real diagonal).
-/
theorem eq29PhaseBalancedClean_eq_S1 [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ)
    (hB : IsHermitian B) :
    eq29PhaseBalancedClean A B normalizerA = S1 A B := by
  funext row col
  cases row with
  | inl i =>
      cases col with
      | inl j =>
          simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,
            pauliXTensor, S1, hermitianPart, homogenizedS, adjoint]
          ring
      | inr j =>
          simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,
            pauliXTensor, S1, hermitianPart, homogenizedS]
          ring
  | inr i =>
      cases col with
      | inl j =>
          simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,
            pauliXTensor, S1, hermitianPart, homogenizedS, ← hB i j]
          ring
      | inr j =>
          by_cases hij : i = j
          · subst j
            simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,
              pauliXTensor, S1, hermitianPart, homogenizedS]
            ring
          · have hji : j ≠ i := fun h => hij h.symm
            simp [eq29PhaseBalancedClean, add, scale, scaledControlledPhaseSource,
              pauliXTensor, S1, hermitianPart, homogenizedS, hij, hji]

/-- Literal clean-block algebra of the second line of Eq. (30). -/
def eq30Clean [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ) :
    CMatrix (Sum ι ι) (Sum ι ι) :=
  add
    (scale (Complex.I / 2)
      (scaledControlledPhaseSource (adjoint A) normalizerA 1))
    (add
      (scale (-Complex.I / 2)
        (scaledControlledPhaseSource A normalizerA 1))
      (scale (1 / 2 : ℂ) (pauliYTensor B)))

/-- The second line of Eq. (30) has the required filler cancellation and equals `S₂`. -/
theorem eq30Clean_eq_S2 [DecidableEq ι]
    (A B : CMatrix ι ι) (normalizerA : ℂ)
    (hB : IsHermitian B) :
    eq30Clean A B normalizerA = S2 A B := by
  funext row col
  cases row with
  | inl i =>
      cases col with
      | inl j =>
          simp [eq30Clean, add, scale, scaledControlledPhaseSource,
            pauliYTensor, S2, antiHermitianPart, homogenizedS, adjoint]
          have hI : Complex.I ≠ 0 := Complex.I_ne_zero
          field_simp [hI]
          ring
      | inr j =>
          simp [eq30Clean, add, scale, scaledControlledPhaseSource,
            pauliYTensor, S2, antiHermitianPart, homogenizedS]
          have hI : Complex.I ≠ 0 := Complex.I_ne_zero
          field_simp [hI]
          ring
  | inr i =>
      cases col with
      | inl j =>
          simp [eq30Clean, add, scale, scaledControlledPhaseSource,
            pauliYTensor, S2, antiHermitianPart, homogenizedS, ← hB i j]
          have hI : Complex.I ≠ 0 := Complex.I_ne_zero
          field_simp [hI]
          ring
      | inr j =>
          by_cases hij : i = j
          · subst j
            simp [eq30Clean, add, scale, scaledControlledPhaseSource,
              pauliYTensor, S2, antiHermitianPart, homogenizedS]
            ring
          · have hji : j ≠ i := fun h => hij h.symm
            simp [eq30Clean, add, scale, scaledControlledPhaseSource,
              pauliYTensor, S2, antiHermitianPart, homogenizedS, hij, hji]

/-- Theorem 4's source normalization is registered exactly. -/
theorem oneDimHamiltonianClaim_normalization_closed :
    oneDimHamiltonianClaim.normalization = "O(kappa * ||H||_max)" := by
  rfl

/-- Theorem 4's source signal-qubit expression is registered exactly. -/
theorem oneDimHamiltonianClaim_layout_closed :
    oneDimHamiltonianClaim.layout =
      "ceil(log2 n_xi)+ceil(log2 n)+ceil(log2 G)+ceil(log2 kappa)+ceil(log2 eta)+7 signal qubits" := by
  rfl

/-- Theorem 4's source pure-ancilla expression is exactly `2n+2`. -/
theorem oneDimHamiltonianResource_pureAncilla_closed :
    oneDimHamiltonianResourceExpr.pureAncilla =
      (2 : CostExpr) * CostExpr.atom "n" + 2 := by
  rfl

/--
Single proof root for the paper-level Theorem 4 composition.  This closes the
source clean-block algebra of Eqs. (29)-(30), the final `H` formula, and the
normalization/layout/resource records.  Primitive arbitrary-width realization
of every Theorem-3 input oracle remains a separate compiler layer.
-/
theorem theorem4_source_lcu_route_closed [DecidableEq ι] [DecidableEq ξ]
    {η : Type*} [Fintype η]
    (cert : OneDimCompositionCertificate η ι ξ)
    (normalizerA : ℂ) :
    eq29PhaseBalancedClean cert.A cert.B normalizerA = cert.first ∧
    eq30Clean cert.A cert.B normalizerA = cert.second ∧
    cert.H = add (tensor cert.first cert.xXi)
      (tensor cert.second (identity ξ)) ∧
    oneDimHamiltonianClaim.normalization = "O(kappa * ||H||_max)" ∧
    oneDimHamiltonianClaim.resource = oneDimHamiltonianResourceExpr := by
  refine ⟨?_, ?_, ?_, oneDimHamiltonianClaim_normalization_closed, ?_⟩
  · exact eq29PhaseBalancedClean_eq_S1 cert.A cert.B normalizerA cert.B_hermitian
  · exact eq30Clean_eq_S2 cert.A cert.B normalizerA cert.B_hermitian
  · exact cert.H_eq_S1_tensor_xXi_add_S2_tensor_I
  · rfl
'''

text = text.replace(anchor, insert, 1)
path.write_text(text, encoding='utf-8')

# Add regression examples.
test = Path('ABEISTests/GHLHamiltonian.lean')
t = test.read_text(encoding='utf-8')
if 'theorem4_source_lcu_route_closed' not in t:
    marker = '''example (cert : OneDimCompositionCertificate η ι ξ) :\n    cert.H = add (tensor cert.first cert.xXi)\n      (tensor cert.second (identity ξ)) :=\n  cert.H_eq_S1_tensor_xXi_add_S2_tensor_I\n'''
    block = marker + '''\nexample [DecidableEq ι] (cert : OneDimCompositionCertificate η ι ξ)\n    (normalizerA : ℂ) :\n    eq29PhaseBalancedClean cert.A cert.B normalizerA = cert.first :=\n  eq29PhaseBalancedClean_eq_S1 cert.A cert.B normalizerA cert.B_hermitian\n\nexample [DecidableEq ι] (cert : OneDimCompositionCertificate η ι ξ)\n    (normalizerA : ℂ) :\n    eq30Clean cert.A cert.B normalizerA = cert.second :=\n  eq30Clean_eq_S2 cert.A cert.B normalizerA cert.B_hermitian\n\nexample [DecidableEq ι] (cert : OneDimCompositionCertificate η ι ξ)\n    (normalizerA : ℂ) :\n    eq29PhaseBalancedClean cert.A cert.B normalizerA = cert.first ∧\n    eq30Clean cert.A cert.B normalizerA = cert.second ∧\n    cert.H = add (tensor cert.first cert.xXi)\n      (tensor cert.second (identity ξ)) ∧\n    oneDimHamiltonianClaim.normalization = "O(kappa * ||H||_max)" ∧\n    oneDimHamiltonianClaim.resource = oneDimHamiltonianResourceExpr :=\n  theorem4_source_lcu_route_closed cert normalizerA\n'''
    if marker not in t:
        raise SystemExit('GHL Hamiltonian test anchor missing')
    t = t.replace(marker, block, 1)
    test.write_text(t, encoding='utf-8')
