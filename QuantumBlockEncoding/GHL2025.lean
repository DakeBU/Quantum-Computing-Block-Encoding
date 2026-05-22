import QuantumBlockEncoding.BlockEncoding
import QuantumBlockEncoding.CircuitSemantics

/-!
# Guseynov-Huang-Liu 2025 construction skeleton

This file turns the paper's main block-encoding construction into Lean data.
It does not yet prove matrix-level correctness; instead it fixes the statement
shape, resource formulas, and decomposition targets that future AI-generated
gate-level circuits must satisfy.
-/

namespace QuantumBlockEncoding
namespace GHL2025

open CostExpr

structure OneTermRobinParameters where
  n : Nat
  kappa : Nat
  functionPieces : Nat
  polynomialDegreeCost : Nat
deriving Repr, DecidableEq

/--
Classical specification of the indicator oracle U_indic(K1,K2).
Returns `true` when row index `i` is in the bulk region [K1, K2],
meaning U_indic maps |i⟩|0⟩ → |i⟩|1⟩.
Returns `false` for boundary rows (0 ≤ i < K1 or K2 < i),
meaning U_indic maps |i⟩|0⟩ → |i⟩|0⟩.
main.tex:1060-1065 --/
def isBulkRow (K1 K2 i : Nat) : Bool :=
  K1 ≤ i && i ≤ K2

/--
Complement of isBulkRow: returns true for boundary rows (j < K1 or K2 < j).
The paper's boundary set is {0,...,K1-1} union {K2+1,...,2^n-1}.
main.tex:1113, 1035-1038 --/
def isBoundaryRow (K1 K2 _gridSize : Nat) (j : Nat) : Bool :=
  j < K1 || K2 < j

/--
Detailed register partition matching the wavefunction ket labels
in Eq. ROBIN clarified (main.tex:1113-1117).
Each field is the qubit count for one register in the circuit.
Total signal qubits = m_f + 1 + ceil(log2 kappa) + 4 (indicator + ancilla + 1),
plus n system qubits. Pure ancillas appear in two groups totaling 2n.
figure:1_term_ROBIN caption --/
structure RobinRegisterPartition where
  /-- m_f = ceil(log2 n) + ceil(log2 G_f) + 3 qubits for function oracle O_f.
  main.tex:1141 --/
  mfQubits : Nat
  /-- 1 indicator ancilla qubit set by U_indic. main.tex:1060-1065, 1113 --/
  indicatorQubit : Nat
  /-- ceil(log2 kappa) qubits for sparse index s. main.tex:1113 --/
  sparseIndexQubits : Nat
  /-- n - ceil(log2 kappa) qubits used as pure ancillas for O_D^BS register.
  main.tex:1113, 1149 --/
  odPureAncillaQubits : Nat
  /-- n system qubits for row index j. main.tex:1113 --/
  systemQubits : Nat
  /-- 1 ancilla qubit (also pure ancilla after cleanup). main.tex:1113, 1159 --/
  ancillaQubit : Nat
deriving Repr, DecidableEq

/--
Total qubits used by the register partition (all registers summed).
-/
def RobinRegisterPartition.totalQubits (rp : RobinRegisterPartition) : Nat :=
  rp.mfQubits + rp.indicatorQubit + rp.sparseIndexQubits +
  rp.odPureAncillaQubits + rp.systemQubits + rp.ancillaQubit

/--
Default register partition from concrete parameters.
figure:1_term_ROBIN --/
def defaultRobinRegisterPartition (p : OneTermRobinParameters) : RobinRegisterPartition where
  mfQubits := clog2 p.n + clog2 p.functionPieces + 3
  indicatorQubit := 1
  sparseIndexQubits := clog2 p.kappa
  odPureAncillaQubits := p.n - clog2 p.kappa
  systemQubits := p.n
  ancillaQubit := 1

/--
Pure ancilla qubits visible in the Eq. ROBIN register partition:
`(n - ceil(log2 kappa)) + 1` from the O_D^BS register plus the trailing
ancilla.

This is intentionally narrower than the theorem's full `2n` pure-ancilla
budget.  The theorem-level count in `oneTermRobinLayout` and
`oneTermRobinResourceExpr` also includes internal workspace required by the
banded sparse-access and oracle subcircuits.  Keep this distinction explicit to
avoid treating the ket-level register partition as the full resource proof.
figure:1_term_ROBIN caption, main.tex:1149, main.tex:1131-1136
-/
def RobinRegisterPartition.totalPureAncillas (rp : RobinRegisterPartition) : Nat :=
  rp.odPureAncillaQubits + rp.ancillaQubit

/--
Theorem 1-term Robin resource shape:
`O(sum_g Q_g n log n + kappa n)` gates and `2n` pure ancillas.
-/
def oneTermRobinResourceExpr : AsymptoticResource where
  gates :=
    (CostExpr.atom "sum_g(Q_g)") * (CostExpr.atom "n") * (CostExpr.log (CostExpr.atom "n")) +
    (CostExpr.atom "kappa") * (CostExpr.atom "n")
  pureAncilla := (2 : CostExpr) * CostExpr.atom "n"

/-- Number of deviating (boundary) indices: K1 + 2^n - K2.
The paper notes this is O(1) as it depends on the finite-difference accuracy order.
main.tex:1092-1095 --/
def deviatingIndices (K1 K2 gridSize : Nat) : Nat :=
  K1 + gridSize - K2

/--
Precise gate cost formula from the text (main.tex:1088-1089), before absorbing the
O(1) boundary deviation count into the Theorem's simplified formula.
`O(sum_g Q_g n log n + kappa * (K1 + 2^n - K2) * n)` gates.
The term `K1 + 2^n - K2` is the number of deviating rows, which is O(1).
main.tex:1088-1089 --/
def oneTermRobinPreciseResourceExpr : AsymptoticResource where
  gates :=
    (CostExpr.atom "sum_g(Q_g)") * (CostExpr.atom "n") * (CostExpr.log (CostExpr.atom "n")) +
    (CostExpr.atom "kappa") * (CostExpr.atom "(K1 + 2^n - K2)") * (CostExpr.atom "n")
  pureAncilla := (2 : CostExpr) * CostExpr.atom "n"

/-- deviatingIndices computes K1 + gridSize - K2, the number of boundary rows.
For the fourth-order stencil with K1=2, K2=gridSize(n)-3, this gives 2+3=5.
main.tex:1092-1095 --/
theorem deviatingIndices_example :
    deviatingIndices 2 (gridSize 3 - 3) (gridSize 3) = 5 := rfl

/-- Numeric resource useful for concrete search runs with fixed parameters. -/
def oneTermRobinResource (p : OneTermRobinParameters) : Resource :=
  Resource.ofCounts
    (p.polynomialDegreeCost * p.n * clog2 p.n + p.kappa * p.n)
    0
    (2 * p.n)

theorem oneTermRobin_pureAncilla (p : OneTermRobinParameters) :
    (oneTermRobinResource p).pureAncilla = 2 * p.n := rfl

/--
Register layout for the one-term Robin block encoding.
Signal qubits = ⌈log₂ n⌉ + ⌈log₂ G_f⌉ + ⌈log₂ κ⌉ + 4
match the paper's Theorem (main.tex:1098-1109).
System qubits address `n` grid points; pure ancillas are workspace.
-/
def oneTermRobinLayout (p : OneTermRobinParameters) : RegisterLayout where
  systemQubits := clog2 (gridSize p.n)
  signalQubits := clog2 p.n + clog2 p.functionPieces + clog2 p.kappa + 4
  pureAncillas := 2 * p.n

/--
Placeholder circuit for the one-term Robin block encoding.
Gate order matches Fig. 1_term_ROBIN (main.tex:1125-1163):
  1. U_indic sets bulk/boundary indicator ancilla.
  2. O_DT^S encodes D^T amplitudes (bulk) via sparse-amplitude oracle.
  3. Ry_boundary applies controlled rotations for boundary entries.
  4. O_D^BS is the banded-sparse-access oracle for D.
  5. O_f encodes f(x_j) via amplitude oracle.
  6. SWAP between two n-qubit registers.
  7. (O_D^BS)^† uncomputes the sparse-access register.
Oracle names match `defaultRobinCircuitSkeleton` field values.
figure:1_term_ROBIN --/
def oneTermRobinCircuit : Circuit :=
  [ Gate.oracleCall "U_indic"
  , Gate.oracleCall "O_DT^S"
  , Gate.oracleCall "Ry_boundary"
  , Gate.oracleCall "O_D^BS"
  , Gate.oracleCall "O_f"
  , Gate.swap 0 0   -- placeholder qubit indices; SWAP is a native gate
  , Gate.oracleCall "(O_D^BS)^†"
  ]

/-- Symbolic normalizer α = N_D · N_f · κ for the one-term Robin construction. -/
def oneTermRobinNormalizer : Coeff :=
  Coeff.mul (Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "N_f")) (Coeff.symbol "kappa")

/--
Block-encoding spec for the one-term Robin derivative operator.
Takes the target matrix as a parameter so the spec is reusable across different
stencil choices and boundary data without creating import cycles.
Normalizer: symbolic `N_D · N_f · κ`.
Error: zero (exact encoding, no approximation yet).
-/
def oneTermRobinSpec (p : OneTermRobinParameters)
    (mat : Matrix (gridSize p.n) (gridSize p.n) Coeff) :
    BlockEncodingSpec Coeff (gridSize p.n) (gridSize p.n) where
  matrix := mat
  normalizer := oneTermRobinNormalizer
  error := Coeff.rat 0
  layout := oneTermRobinLayout p
  circuit := oneTermRobinCircuit
  resource := oneTermRobinResource p

/-- The spec's pure ancilla matches the resource formula. -/
theorem oneTermRobinSpec_ancilla (p : OneTermRobinParameters)
    (mat : Matrix (gridSize p.n) (gridSize p.n) Coeff) :
    (oneTermRobinSpec p mat).resource.pureAncilla = 2 * p.n := rfl

/-- The spec's circuit local cost: oracle calls are free, the SWAP placeholder costs 3 CNOTs. figure:1_term_ROBIN --/
theorem oneTermRobinSpec_circuitCost :
    Circuit.resource oneTermRobinCircuit = Resource.ofCounts 0 3 0 := rfl

/-- Evaluating the symbolic normalizer `N_D · N_f · κ` under an environment gives
the product of the three symbol values. -/
@[simp] theorem oneTermRobinNormalizer_eval (env : String → Rat) :
    Coeff.evalWith env oneTermRobinNormalizer = env "N_D" * env "N_f" * env "kappa" := by
  simp [oneTermRobinNormalizer]

/-- The paper's one-term Robin block-encoding construction claim. -/
def oneTermRobinClaim : ConstructionClaim where
  name := "one-term-robin-block-encoding"
  source := "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding"
  target := "A_k = f(x) * d^m/dx^m with Robin boundary corrections"
  normalization := "N_D * N_f * kappa"
  layout := "ceil(log2 n) + ceil(log2 G_f) + ceil(log2 kappa) + 4 signal qubits, 2n pure ancillas"
  resource := oneTermRobinResourceExpr

/-- One-dimensional Hamiltonian block-encoding resource shape. -/
def oneDimHamiltonianResourceExpr : AsymptoticResource where
  gates :=
    CostExpr.atom "sum_g(Q_v_g) * n * log(n)" +
    CostExpr.sum "k < eta" (CostExpr.atom "kappa_k * n + sum_g(Q_fkg) * n * log(n)") +
    CostExpr.atom "n_xi * log(n_xi)"
  pureAncilla := (2 : CostExpr) * CostExpr.atom "n" + (2 : CostExpr)

/-- The paper's 1D Hamiltonian block-encoding construction claim. -/
def oneDimHamiltonianClaim : ConstructionClaim where
  name := "one-dimensional-pde-hamiltonian-block-encoding"
  source := "Guseynov-Huang-Liu 2025, Theorem one-dimensional block-encoding"
  target := "H = S1 tensor x_xi + S2 tensor I_xi"
  normalization := "O(kappa * ||H||_max)"
  layout := "ceil(log2 n_xi)+ceil(log2 n)+ceil(log2 G)+ceil(log2 kappa)+ceil(log2 eta)+7 signal qubits"
  resource := oneDimHamiltonianResourceExpr

/-- Multidimensional Hamiltonian block-encoding resource shape. -/
def multiDimHamiltonianResourceExpr : AsymptoticResource where
  gates :=
    CostExpr.atom "M * Q_PET * G * Q * (d*n*log(n)+n_s*log(n_s))" +
    CostExpr.atom "n_xi * log(n_xi)" +
    CostExpr.atom "d * eta * kappa * n"
  pureAncilla := CostExpr.atom "O(n)"

/-- The paper's multidimensional Hamiltonian block-encoding construction claim. -/
def multiDimHamiltonianClaim : ConstructionClaim where
  name := "multidimensional-pde-hamiltonian-block-encoding"
  source := "Guseynov-Huang-Liu 2025, Theorem multi-dimensional block-encoding"
  target := "H = I tensor p_s tensor I_xi + S1^(d) tensor x_xi + S2^(d) tensor I_xi"
  normalization := "O(kappa * ||H||_max)"
  layout := "d*ceil(log2 n)+ceil(log2 n_s)+ceil(log2 n_xi)+ceil(log2 G)+ceil(log2 kappa)+ceil(log2 eta)+ceil(log2 M)+4d+5 signal qubits"
  resource := multiDimHamiltonianResourceExpr

/-- A proof obligation tracked by description and paper source anchor.
`proved` is `Bool` (not `Prop`) so that unproved obligations are honest data,
not mathematically false claims. main.tex --/
structure ObligationRecord where
  description : String
  source : String
  proved : Bool := false
deriving Repr, DecidableEq

/-- Circuit skeleton matching Fig. 1_term_ROBIN (main.tex:1137-1167).
Each field corresponds to a labeled box or operation in the figure.
All oracles are recorded as symbolic names; their implementation is delegated
to separate oracle-contract structures. figure:1_term_ROBIN --/
structure RobinCircuitSkeleton where
  /-- Bulk/boundary indicator unitary U_indic(K1,K2). main.tex:1088-1099 --/
  indicatorOracle : String
  /-- Bulk window lower bound K1. main.tex:1095 --/
  K1 : Nat
  /-- Bulk window upper bound K2. main.tex:1095 --/
  K2 : Nat
  /-- Sparse-amplitude oracle for transposed derivative D^T.
  Lemma 3 (main.tex:822-849). --/
  sparseAmplitudeOracleDT : String
  /-- Banded-sparse-access oracle for D. Lemma 1 (main.tex:784-801). --/
  bandedSparseAccessOracleD : String
  /-- Hermitian conjugate of the banded-sparse-access oracle (O_D^BS)^†.
  figure:1_term_ROBIN caption, main.tex:1148 --/
  bandedSparseAccessOracleD_dagger : String
  /-- Boundary-controlled R_y rotations with angles theta_j^s = arccos(D_j^(s)/N_D).
  main.tex:1115-1120 --/
  controlledRyBoundary : String
  /-- Amplitude oracle O_f for piecewise polynomial f(x). Thm 5 (main.tex:870-910). --/
  functionOracle : String
  /-- SWAP between two n-qubit registers. figure:1_term_ROBIN, main.tex:1140 --/
  swapOperation : String
  /-- Y-frame register merge (no quantum operation). figure:1_term_ROBIN caption --/
  mergeFrame : String
  /-- m_f = ceil(log2 n) + ceil(log2 G_f) + 3 qubits reserved for O_f. main.tex:1141 --/
  mfSignalQubits : Nat
  /-- ceil(log2 kappa) qubits for sparse indexing. figure:1_term_ROBIN caption --/
  kappaSignalQubits : Nat
  /-- n - ceil(log2 kappa) pure ancilla qubits for O_D^BS register.
  figure:1_term_ROBIN caption, main.tex:1149 --/
  pureAncillaODRegister : Nat
deriving Repr, DecidableEq

/-- Eq. ROBIN clarified, gamma_1 component (main.tex:1113).
State after U_indic sets the indicator ancilla.
The boundary and bulk summation terms have different normalizers:
  boundary: 1/(N_D · sqrt(kappa)), indicator |0>
  bulk:     1/sqrt(kappa),        indicator |1>
main.tex:1113 --/
structure RobinGamma1 where
  /-- Sparse index upper bound: s in {0, ..., kappa-1}. main.tex:1113 --/
  kappa : Nat
  /-- Bulk window lower bound. main.tex:1095, 1113 --/
  K1 : Nat
  /-- Bulk window upper bound. main.tex:1095, 1113 --/
  K2 : Nat
  /-- Grid size = 2^n. main.tex:1113 --/
  gridSize : Nat
  /-- Boundary normalizer N_D · sqrt(kappa) (symbolic).
  The boundary summation in gamma_1 is scaled by 1/(N_D · sqrt(kappa)). main.tex:1113 --/
  boundaryNormalizer : Coeff
  /-- Bulk normalizer sqrt(kappa) (symbolic).
  The bulk summation in gamma_1 is scaled by 1/sqrt(kappa) — notably
  without the N_D factor, because the sparse-amplitude oracle has not yet
  been applied. main.tex:1113 --/
  bulkNormalizer : Coeff
  /-- Number of m_f qubits reserved for O_f. main.tex:1141 --/
  mfQubits : Nat
deriving Repr, DecidableEq

/-- Eq. ROBIN clarified, gamma_2 component (main.tex:1115).
State after sparse-amplitude oracle encodes D^T values. main.tex:1115 --/
structure RobinGamma2 where
  /-- Sparse index upper bound. main.tex:1115 --/
  kappa : Nat
  /-- Bulk window lower bound. main.tex:1115 --/
  K1 : Nat
  /-- Bulk window upper bound. main.tex:1115 --/
  K2 : Nat
  /-- Grid size. main.tex:1115 --/
  gridSize : Nat
  /-- Normalization factor N_D * sqrt(kappa) (symbolic). main.tex:1115 --/
  normalizer : Coeff
  /-- Whether this includes the orthogonal remainder "+ ...". main.tex:1115 --/
  hasOrthogonalRemainder : Bool
deriving Repr, DecidableEq

/-- Eq. ROBIN clarified, gamma_3 component (main.tex:1117).
State after O_f encodes f(x_j) values. main.tex:1117 --/
structure RobinGamma3 where
  /-- Sparse index upper bound. main.tex:1117 --/
  kappa : Nat
  /-- Bulk window lower bound. main.tex:1117 --/
  K1 : Nat
  /-- Bulk window upper bound. main.tex:1117 --/
  K2 : Nat
  /-- Grid size. main.tex:1117 --/
  gridSize : Nat
  /-- Normalization factor N_D * N_f * kappa (symbolic). main.tex:1117 --/
  normalizer : Coeff
  /-- Whether this includes the orthogonal remainder "+ ...". main.tex:1117 --/
  hasOrthogonalRemainder : Bool
  /-- Number of pure ancilla qubits identified: n - ceil(log2 kappa) + 1. main.tex:1117, 1149 --/
  pureAncillaQubits : Nat
deriving Repr, DecidableEq

/-- Bundle of the three intermediate wavefunction states from Eq. ROBIN clarified.
Captures the full circuit state evolution from input through U_indic, O_DT^S, and O_f.
main.tex:1113-1117, figure:1_term_ROBIN --/
structure RobinWavefunctionDecomposition where
  /-- gamma_1: state after U_indic. main.tex:1113 --/
  gamma1 : RobinGamma1
  /-- gamma_2: state after sparse-amplitude oracle. main.tex:1115 --/
  gamma2 : RobinGamma2
  /-- gamma_3: state after function oracle O_f. main.tex:1117 --/
  gamma3 : RobinGamma3
  /-- The shared sparse index upper bound. --/
  kappa : Nat
  /-- The shared bulk window lower bound. --/
  K1 : Nat
  /-- The shared bulk window upper bound. --/
  K2 : Nat
  /-- The shared grid size 2^n. --/
  gridSize : Nat
deriving Repr, DecidableEq

/-- Default wavefunction decomposition from concrete parameters.
figure:1_term_ROBIN, main.tex:1113-1117 --/
def defaultRobinWavefunctionDecomposition (p : OneTermRobinParameters) : RobinWavefunctionDecomposition where
  gamma1 := {
    kappa := p.kappa
    K1 := 2
    K2 := gridSize p.n - 3
    gridSize := gridSize p.n
    boundaryNormalizer := Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "sqrt(kappa)")
    bulkNormalizer := Coeff.symbol "sqrt(kappa)"
    mfQubits := clog2 p.n + clog2 p.functionPieces + 3
  }
  gamma2 := {
    kappa := p.kappa
    K1 := 2
    K2 := gridSize p.n - 3
    gridSize := gridSize p.n
    normalizer := Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "sqrt(kappa)")
    hasOrthogonalRemainder := true
  }
  gamma3 := {
    kappa := p.kappa
    K1 := 2
    K2 := gridSize p.n - 3
    gridSize := gridSize p.n
    normalizer := Coeff.mul (Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "N_f")) (Coeff.symbol "kappa")
    hasOrthogonalRemainder := true
    pureAncillaQubits := p.n - clog2 p.kappa + 1
  }
  kappa := p.kappa
  K1 := 2
  K2 := gridSize p.n - 3
  gridSize := gridSize p.n

/-- Bundle of proof obligations for the one-term Robin block encoding.
Each obligation references a specific claim in the paper and tracks whether
it has been formally proved. None are proved in the current version.
Guseynov-Huang-Liu 2025, one-term Robin theorem, arXiv:2506.20478. --/
structure RobinProofObligations where
  /-- U_indic is unitary and implements the bulk-window predicate. --/
  indicatorUnitary : ObligationRecord := {
    description := "U_indic(K1,K2) implements the bulk/boundary indicator correctly"
    source := "Guseynov-Huang-Liu 2025, U_indic definition and Fig. 1-term Robin, arXiv:2506.20478"
    proved := false
  }
  /-- Sparse-amplitude oracle O_D^S is unitary and encodes D^(s)/N_D. --/
  sparseAmplitudeOracleCorrect : ObligationRecord := {
    description := "O_DT^S prepares the D^T sparse-amplitude branch D_j^(s)/N_D from Lemma 3, Eq. (20)"
    source := "Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), arXiv:2506.20478"
    proved := false
  }
  /-- Banded-sparse-access oracle O_D^BS is unitary and writes r_si. --/
  bandedSparseAccessCorrect : ObligationRecord := {
    description := "O_D^BS maps |0>^(n-l)|s>^l|i>^n to |r_si>^n|i>^n and supports dagger cleanup"
    source := "Guseynov-Huang-Liu 2025, Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478"
    proved := false
  }
  /-- Function oracle O_f is unitary and block-encodes f(x_j)/N_f. --/
  functionOracleCorrect : ObligationRecord := {
    description := "O_f block-encodes the piecewise polynomial f(x) discretized on the grid"
    source := "Guseynov-Huang-Liu 2025, Lemma 4 and Fig. 1-term Robin, arXiv:2506.20478"
    proved := false
  }
  /-- Controlled R_y angles encode boundary D_j^(s)/N_D correctly. --/
  controlledRyCorrect : ObligationRecord := {
    description := "R_y rotation angles theta_j^s = arccos(D_j^(s)/N_D) are correct"
    source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and boundary Ry angle formula, arXiv:2506.20478"
    proved := false
  }
  /-- Full circuit U_Ak^(1) is unitary. --/
  circuitUnitary : ObligationRecord := {
    description := "The full one-term Robin circuit U_Ak^(1) is unitary"
    source := "Guseynov-Huang-Liu 2025, one-term Robin theorem, arXiv:2506.20478"
    proved := false
  }
  /-- Block extraction: (⟨0|⊗I) U (|0⟩⊗I) = A_k / (N_D * N_f * kappa). --/
  blockExtraction : ObligationRecord := {
    description := "Block extraction yields A_k / alpha where alpha = N_D * N_f * kappa"
    source := "Guseynov-Huang-Liu 2025, one-term Robin theorem, arXiv:2506.20478"
    proved := false
  }
  /-- Resource bound: O(sum Q_g n log n + kappa n) gates, 2n pure ancillas. --/
  resourceBound : ObligationRecord := {
    description := "Gate count O(sum_g Q_g n log n + kappa n), pure ancillas 2n"
    source := "Guseynov-Huang-Liu 2025, one-term Robin theorem resource claim, arXiv:2506.20478"
    proved := false
  }
  /-- Pure ancilla cleanup: 2n ancillas returned to |0⟩. figure:1_term_ROBIN caption --/
  ancillaCleanup : ObligationRecord := {
    description := "All 2n pure ancilla qubits are returned to |0⟩ state"
    source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin caption, arXiv:2506.20478"
    proved := false
  }
  /-- Ghost-point elimination yields correct Robin boundary row coefficients. --/
  ghostPointElimination : ObligationRecord := {
    description := "Ghost-point elimination via Robin boundary relation produces correct boundary rows"
    source := "Guseynov-Huang-Liu 2025, Robin boundary-row derivation, arXiv:2506.20478"
    proved := false
  }
deriving Repr, DecidableEq

/-- Default circuit skeleton for the one-term Robin construction,
with oracle names matching the paper's notation. figure:1_term_ROBIN --/
def defaultRobinCircuitSkeleton (p : OneTermRobinParameters) : RobinCircuitSkeleton where
  indicatorOracle := "U_indic"
  K1 := 2  -- depends on stencil accuracy order; main.tex:1095
  K2 := gridSize p.n - 3  -- symmetric boundary; main.tex:1095
  sparseAmplitudeOracleDT := "O_DT^S"
  bandedSparseAccessOracleD := "O_D^BS"
  bandedSparseAccessOracleD_dagger := "(O_D^BS)^†"
  controlledRyBoundary := "Ry_boundary"
  functionOracle := "O_f"
  swapOperation := "SWAP"
  mergeFrame := "merge"
  mfSignalQubits := clog2 p.n + clog2 p.functionPieces + 3
  kappaSignalQubits := clog2 p.kappa
  pureAncillaODRegister := p.n - clog2 p.kappa

/--
Paper-level source contract for the banded sparse-access oracle in Lemma 1.

The input register is the padded sparse-index register
`|0>^(n-l)|s>^l` followed by the row register `|i>^n`; the output is
`|r_si>^n|i>^n`.  This record is intentionally separate from the current
`bandedSparseAccessMatrix` helper, which overwrites the system register with a
Robin column map and therefore does not yet implement this paper contract.
Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478. -/
structure BandedSparseAccessPaperContract where
  sourceAnchor : String
  rowRegisterQubits : Nat
  paddedZeroQubits : Nat
  sparseIndexQubits : Nat
  outputAddressQubits : Nat
  inputKet : String
  outputKet : String
  imageFormula : String
  cleanInputDomain : ObligationRecord
  widthCompatible : ObligationRecord
  addressRange : ObligationRecord
  noSpill : ObligationRecord
  forwardCorrect : ObligationRecord
  daggerCleanup : ObligationRecord
  unitaryExtension : ObligationRecord
deriving Repr, DecidableEq

/--
Default Lemma 1 register contract for the one-term Robin parameters.

The `widthCompatible` obligation stays explicit because the current parameter
type does not enforce `clog2 kappa <= n`; faithful proofs should discharge that
side condition or specialize to a parameter family where it is available.
-/
def defaultBandedSparseAccessPaperContract
    (p : OneTermRobinParameters) : BandedSparseAccessPaperContract where
  sourceAnchor := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
  rowRegisterQubits := p.n
  paddedZeroQubits := p.n - clog2 p.kappa
  sparseIndexQubits := clog2 p.kappa
  outputAddressQubits := p.n
  inputKet := "|0>^(n-l)|s>^l|i>^n"
  outputKet := "|r_si>^n|i>^n"
  imageFormula := "r_si = r_s0 + i mod 2^n"
  cleanInputDomain := {
    description := "Lemma 1 source equation applies to columns whose padded zero register is |0>^(n-l)"
    source := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
    proved := false
  }
  widthCompatible := {
    description := "padded zero register plus sparse-index register has width n"
    source := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
    proved := false
  }
  addressRange := {
    description := "the written address r_si is an n-bit value before it is placed in the O_D^BS register"
    source := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
    proved := false
  }
  noSpill := {
    description := "bandedSparseAccessPaperImage changes only the n-bit O_D^BS address register and does not spill into indicator or m_f bits"
    source := "Guseynov-Huang-Liu 2025, Lemma 1 and Fig. 1-term Robin, arXiv:2506.20478"
    proved := false
  }
  forwardCorrect := {
    description := "O_D^BS maps |0>^(n-l)|s>^l|i>^n to |r_si>^n|i>^n"
    source := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
    proved := false
  }
  daggerCleanup := {
    description := "(O_D^BS)^dagger cleans the padded sparse-index register after SWAP"
    source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Lemma 1, arXiv:2506.20478"
    proved := false
  }
  unitaryExtension := {
    description := "extend the Lemma 1 clean-input image to a full unitary on non-clean padded-register columns"
    source := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
    proved := false
  }

/-- Contract for the derivative oracle O_D: sparse-access oracle for the banded
stencil matrix. Records stencil metadata, bandwidth, and a correctness obligation. main.tex:784-801 --/
structure DerivativeOracleContract (n : Nat) where
  stencil : Stencil
  bandwidth : Nat
  matrix : Matrix (gridSize n) (gridSize n) Coeff
  /-- Obligation: O_D^BS correctly maps sparse indices to matrix entries.
  main.tex:784-801 --/
  sparseCorrect : ObligationRecord
  bandwidth_eq : bandwidth = stencil.width

/-- Contract for the function oracle O_f: amplitude oracle encoding f(x) on the
grid. Records the piece count, normalization bound, and a correctness obligation. main.tex:870-910 -/
structure FunctionOracleContract (n : Nat) where
  functionPieces : Nat
  normalizerBound : Coeff
  /-- Obligation: O_f correctly block-encodes f(x_j)/N_f on the grid.
  main.tex:870-910 --/
  amplitudeCorrect : ObligationRecord

/-- Resource for the derivative oracle O_D using the banded sparse-access formula
from Lemma 1 of Guseynov-Huang-Liu 2025. The half-bandwidth parameter is
`stencil.leftRadius` (assumes a symmetric stencil where leftRadius = rightRadius). -/
def derivativeOracleResource (n : Nat) (s : Stencil) : Resource :=
  bandedSparseAccessResource n s.leftRadius

/-- The derivative oracle's pure ancilla count is n - 1 (from Lemma 1). -/
@[simp] theorem derivativeOracleResource_pureAncilla (n : Nat) (s : Stencil) :
    (derivativeOracleResource n s).pureAncilla = n - 1 := rfl

/-- Typed theorem data for Theorem one-term block-encoding (main.tex:1098-1109).
Captures the exact block-encoding tuple (α, m, a) from the paper:
  α = N_D · N_f · κ    (normalizer)
  m = ⌈log₂ n⌉ + ⌈log₂ G_f⌉ + ⌈log₂ κ⌉ + 4   (signal ancilla qubits)
  a = 0                (zero approximation error)
along with the gate-count and pure-ancilla resource claims. -/
structure OneTermRobinTheoremData where
  /-- Block-encoding normalizer α = N_D · N_f · κ. main.tex:1102 --/
  alpha : Coeff
  /-- Signal ancilla qubits m = ⌈log₂ n⌉ + ⌈log₂ G_f⌉ + ⌈log₂ κ⌉ + 4. main.tex:1102 --/
  signalQubits : Nat
  /-- Approximation error a = 0 (exact block encoding). main.tex:1098-1109 --/
  error : Coeff
  /-- Gate-count bound: O(∑_g Q_g n log n + κ n). main.tex:1105-1108 --/
  gatesBound : String
  /-- Pure ancilla qubits: 2n. main.tex:1107 --/
  pureAncillas : Nat
  /-- All proof obligations for this theorem. main.tex:1098-1109 --/
  obligations : RobinProofObligations
deriving Repr, DecidableEq

/-- Default theorem data instance from concrete parameters. main.tex:1098-1109 --/
def defaultOneTermRobinTheoremData (p : OneTermRobinParameters) : OneTermRobinTheoremData where
  alpha := oneTermRobinNormalizer
  signalQubits := clog2 p.n + clog2 p.functionPieces + clog2 p.kappa + 4
  error := Coeff.rat 0
  gatesBound := "O(sum_g Q_g n log n + kappa n)"
  pureAncillas := 2 * p.n
  obligations := {}

/--
A controlled R_y rotation angle for a single boundary row entry.
The paper (Eq. angles for Ry, main.tex:1081-1083) defines:
  theta_j^s = arccos(D_j^(s) / N_D)
for sparse index s in {0,...,kappa-1} and boundary row j.
main.tex:1081-1083 --/
structure RobinBoundaryRotationAngle where
  /-- Row index j (boundary row: j < K1 or j > K2). main.tex:1082 --/
  row : Nat
  /-- Sparse index s in {0,...,kappa-1}. main.tex:1082 --/
  sparseIndex : Nat
  /-- The matrix entry D_j^(s) being encoded. main.tex:1082 --/
  matrixEntry : Coeff
  /-- The argument to arccos: D_j^(s) / N_D (symbolic Coeff).
  The caller must ensure this evaluates to a value in [-1, 1].
  main.tex:1081-1083 --/
  arccosArgument : Coeff
deriving Repr, DecidableEq

/--
The set of all boundary-controlled rotation angles for a given Robin construction.
For each boundary row j and sparse index s, there is one angle theta_j^s.
Total count = kappa * (K1 + gridSize - K2) = kappa * deviatingIndices.
main.tex:1081-1083, 1088-1089 --/
structure RobinBoundaryRotationSet where
  /-- Bulk window lower bound. main.tex:1095 --/
  K1 : Nat
  /-- Bulk window upper bound. main.tex:1095 --/
  K2 : Nat
  /-- Grid size = 2^n. main.tex:1082 --/
  gridSize : Nat
  /-- Diagonal sparsity bound (number of nonzero entries per row). main.tex:1075 --/
  kappa : Nat
  /-- Normalizer N_D >= ||D||_max. main.tex:1085 --/
  normalizerND : Coeff
  /-- Individual rotation angles, one per (boundary_row, sparse_index) pair.
  main.tex:1081-1083 --/
  angles : List RobinBoundaryRotationAngle
deriving Repr, DecidableEq

/--
Number of boundary rows = K1 + gridSize - K2.
Each boundary row has kappa rotation angles (one per sparse index).
main.tex:1092-1095 --/
def RobinBoundaryRotationSet.expectedCount (rs : RobinBoundaryRotationSet) : Nat :=
  rs.kappa * deviatingIndices rs.K1 rs.K2 rs.gridSize

def importedClaims : List ConstructionClaim :=
  [oneTermRobinClaim, oneDimHamiltonianClaim, multiDimHamiltonianClaim]

/-! ## Gate matrix placeholders for the one-term Robin circuit

Each gate in `oneTermRobinCircuit` gets a placeholder `GateMatrix` record.
The placeholder matrices are identity matrices on the full Hilbert space;
each carries a `SemanticObligation` with `proved := false` tracking that
the real matrix implementation is still pending.
figure:1_term_ROBIN, main.tex:1125-1163 --/

/--
Total number of qubits in the one-term Robin circuit.
Uses the register partition total: sum of all register widths.
main.tex:1098-1109 --/
def oneTermRobinTotalQubits (p : OneTermRobinParameters) : Nat :=
  (defaultRobinRegisterPartition p).totalQubits

/--
Effective signal qubits: total circuit qubits minus the system register width.
This is the number of non-system qubits in the register partition.
main.tex:1098-1109 --/
def effectiveRobinSignalQubits (p : OneTermRobinParameters) : Nat :=
  (defaultRobinRegisterPartition p).totalQubits - clog2 (gridSize p.n)

/--
Bit position of the indicator qubit in the compound register.
= ancillaQubit + systemQubits + odPureAncillaQubits + sparseIndexQubits
= 1 + n + (n - clog2 κ) + clog2 κ = 1 + 2n
main.tex:1113 --/
def robinIndicatorBitPosition (p : OneTermRobinParameters) : Nat :=
  let rp := defaultRobinRegisterPartition p
  rp.ancillaQubit + rp.systemQubits + rp.odPureAncillaQubits + rp.sparseIndexQubits

/--
Column mapping for the banded sparse access oracle O_D^BS.
Returns the column index for sparse index s in row i of the Robin derivative matrix.

For bulk rows (K1 ≤ i ≤ K2): 5 entries, col(s,i) = i - 2 + s for s < 5.
For left boundary:
  - Row 0 (3 entries): col(s,0) = s for s < 3
  - Row 1 (4 entries): col(s,1) = s for s < 4
For right boundary (N = gridSize n):
  - Row N-2 (4 entries): col(s,N-2) = N-4+s for s < 4
  - Row N-1 (3 entries): col(s,N-1) = N-3+s for s < 3
For unused sparse indices (s ≥ entry count): returns i (identity on system register).
main.tex:784-801 --/
def robinSparseColumnMap (n s i : Nat) : Nat :=
  let N := gridSize n
  let K1 := 2
  let K2 := N - 3
  if K1 ≤ i ∧ i ≤ K2 then
    if s < 5 then i - 2 + s else i
  else if i = 0 then
    if s < 3 then s else i
  else if i = 1 then
    if s < 4 then s else i
  else if i = N - 2 then
    if s < 4 then N - 4 + s else i
  else if i = N - 1 then
    if s < 3 then N - 3 + s else i
  else i

/--
Proof-DAG block for the Lemma 1 address-range route.

For the fourth-order Robin stencil, if the input row is an `n`-bit value and
`n >= 2`, then the executable one-term column map also returns an `n`-bit
value.  The paper-level contract still records `addressRange.proved := false`
because the parameter-family side condition is not yet part of
`OneTermRobinParameters`.
-/
theorem robinSparseColumnMap_lt_gridSize_of_row_lt
    {n s i : Nat} (hn : 2 ≤ n) (hi : i < gridSize n) :
    robinSparseColumnMap n s i < gridSize n := by
  have hpow : 2 ^ 2 ≤ 2 ^ n :=
    Nat.pow_le_pow_right (by decide : 0 < 2) hn
  have hN4 : 4 ≤ gridSize n := by
    simpa [gridSize] using hpow
  unfold robinSparseColumnMap
  by_cases hbulk : 2 ≤ i ∧ i ≤ gridSize n - 3
  · simp [hbulk]
    by_cases hs : s < 5
    · simp [hs]
      omega
    · simp [hs, hi]
  · simp [hbulk]
    by_cases hi0 : i = 0
    · simp [hi0]
      by_cases hs : s < 3
      · simp [hs]
        omega
      · simp [hs]
        omega
    · simp [hi0]
      by_cases hi1 : i = 1
      · simp [hi1]
        by_cases hs : s < 4
        · simp [hs]
          omega
        · simp [hs]
          omega
      · simp [hi1]
        by_cases hiN2 : i = gridSize n - 2
        · simp [hiN2]
          by_cases hs : s < 4
          · simp [hs]
            omega
          · simp [hs]
            omega
        · simp [hiN2]
          by_cases hiN1 : i = gridSize n - 1
          · simp [hiN1]
            by_cases hs : s < 3
            · simp [hs]
              omega
            · simp [hs]
              omega
          · simp [hiN1, hi]

/--
Register values used by the faithful Lemma 1 `O_D^BS` contract.

The current compound-index convention stores the row register in bits
`[1, 1+n)` and the paper's padded sparse-address register in bits
`[1+n, 1+2n)`.  Inside that address block, the low `n - clog2 kappa` bits are
the padded-zero workspace and the remaining bits encode the sparse index `s`.
Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478. -/
structure BandedSparseAccessPaperRegisters where
  odRegisterValue : Nat
  paddedZeroValue : Nat
  sparseIndexValue : Nat
  rowValue : Nat
deriving Repr, DecidableEq

/--
Extract the Lemma 1 padded sparse-address and row registers from a compound
basis index.  This is a source-contract skeleton only; it does not alter the
interim `bandedSparseAccessMatrix` helper and does not prove unitarity.
-/
def bandedSparseAccessPaperRegisters (p : OneTermRobinParameters) (j : Nat) :
    BandedSparseAccessPaperRegisters :=
  let n := p.n
  let κbits := clog2 p.kappa
  let odPure := n - κbits
  let nMask := (1 <<< n) - 1
  let zeroMask := (1 <<< odPure) - 1
  let sparseMask := (1 <<< κbits) - 1
  let odValue := (j >>> (1 + n)) &&& nMask
  {
    odRegisterValue := odValue
    paddedZeroValue := odValue &&& zeroMask
    sparseIndexValue := (odValue >>> odPure) &&& sparseMask
    rowValue := (j >>> 1) &&& nMask
  }

/-- The row field extracted for Lemma 1 is always an `n`-bit row value. -/
theorem bandedSparseAccessPaperRegisters_row_lt_gridSize
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperRegisters p j).rowValue < gridSize p.n := by
  simp [bandedSparseAccessPaperRegisters, gridSize]
  rw [Nat.one_shiftLeft]
  apply Nat.and_lt_two_pow
  exact Nat.sub_lt (Nat.pow_pos (by decide : 0 < 2) : 0 < 2 ^ p.n) (by decide)

/--
Paper address value `r_si` for the one-term Robin sparse-access oracle.

For the Robin stencil this reuses `robinSparseColumnMap` as the one-term
instance of the paper's banded-sparse matrix index `r_si`.  The active gate
matrix uses this paper-image skeleton, while the correctness obligations remain
undischarged.
-/
def bandedSparseAccessPaperAddress (p : OneTermRobinParameters) (j : Nat) : Nat :=
  let regs := bandedSparseAccessPaperRegisters p j
  robinSparseColumnMap p.n regs.sparseIndexValue regs.rowValue

/-- Executable check that the paper address `r_si` fits in the n-bit address register. -/
def bandedSparseAccessPaperAddressInRange (p : OneTermRobinParameters) (j : Nat) : Bool :=
  decide (bandedSparseAccessPaperAddress p j < (1 <<< p.n))

/-- Boolean form of the executable `O_D^BS` address-range check. -/
theorem bandedSparseAccessPaperAddressInRange_iff
    (p : OneTermRobinParameters) (j : Nat) :
    bandedSparseAccessPaperAddressInRange p j = true ↔
      bandedSparseAccessPaperAddress p j < (1 <<< p.n) := by
  unfold bandedSparseAccessPaperAddressInRange
  exact decide_eq_true_iff

/--
The executable paper address is in range for the fourth-order grid regime
`2 <= n`.  This is a reusable arithmetic block; it does not promote the
paper-level semantic obligation.
-/
theorem bandedSparseAccessPaperAddress_lt_gridSize_of_two_le
    (p : OneTermRobinParameters) (j : Nat) (hn : 2 ≤ p.n) :
    bandedSparseAccessPaperAddress p j < gridSize p.n := by
  unfold bandedSparseAccessPaperAddress
  exact robinSparseColumnMap_lt_gridSize_of_row_lt hn
    (bandedSparseAccessPaperRegisters_row_lt_gridSize p j)

/--
The executable address-range Boolean evaluates to true for the fourth-order
grid regime `2 <= n`.  The contract flag remains false until the paper
parameter family records this side condition.
-/
theorem bandedSparseAccessPaperAddressInRange_eq_true_of_two_le
    (p : OneTermRobinParameters) (j : Nat) (hn : 2 ≤ p.n) :
    bandedSparseAccessPaperAddressInRange p j = true := by
  unfold bandedSparseAccessPaperAddressInRange
  have h := bandedSparseAccessPaperAddress_lt_gridSize_of_two_le p j hn
  simpa [gridSize, Nat.one_shiftLeft] using h

/--
Executable Lemma 1 image skeleton for `O_D^BS`.

It preserves the row/system register and replaces the padded sparse-address
register by `r_si`.  Correctness, unitarity, and dagger cleanup remain recorded
in `defaultBandedSparseAccessPaperContract p` with `proved := false`.
-/
def bandedSparseAccessPaperImage (p : OneTermRobinParameters) (j : Nat) : Nat :=
  let lowWidth := 1 + p.n
  let highWidth := 1 + 2 * p.n
  let lowBase := 2 ^ lowWidth
  let highBase := 2 ^ highWidth
  let lowPrefix := j % lowBase
  let highTail := j / highBase
  let address := bandedSparseAccessPaperAddress p j
  lowPrefix + address * lowBase + highTail * highBase

/--
Bit-slice extraction as arithmetic division followed by an `n`-bit remainder.
This keeps later register-splice proofs in ordinary arithmetic form.
-/
theorem bandedSparseAccessPaperRegisterValue_eq_mod
    (x offset n : Nat) :
    ((x >>> offset) &&& ((1 <<< n) - 1)) =
      (x / 2 ^ offset) % 2 ^ n := by
  apply Nat.eq_of_testBit_eq
  intro i
  simp only [Nat.testBit_and, Nat.testBit_shiftRight, Nat.one_shiftLeft,
    Nat.testBit_two_pow_sub_one, Nat.testBit_mod_two_pow]
  by_cases hi : i < n
  · simp [hi]
    rw [Nat.add_comm offset i, Nat.testBit_add]
  · simp [hi]

/-- The O_D^BS address block ends before the full one-term Robin basis width. -/
theorem bandedSparseAccessPaperHighWidth_le_totalQubits
    (p : OneTermRobinParameters) :
    1 + 2 * p.n ≤ oneTermRobinTotalQubits p := by
  simp only [oneTermRobinTotalQubits, RobinRegisterPartition.totalQubits,
    defaultRobinRegisterPartition]
  omega

/--
The low block of the paper image fits below the high-tail boundary whenever the
written O_D^BS address is an n-bit value.
-/
theorem bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt
    (p : OneTermRobinParameters) (j : Nat)
    (haddr : bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    let lowWidth := 1 + p.n
    let highWidth := 1 + 2 * p.n
    let lowBase := 2 ^ lowWidth
    let highBase := 2 ^ highWidth
    let lowPrefix := j % lowBase
    let address := bandedSparseAccessPaperAddress p j
    lowPrefix + address * lowBase < highBase := by
  rw [Nat.one_shiftLeft] at haddr
  dsimp
  have hlowPos : 0 < 2 ^ (1 + p.n) :=
    Nat.pow_pos (by decide : 0 < 2)
  have hlow : j % 2 ^ (1 + p.n) < 2 ^ (1 + p.n) :=
    Nat.mod_lt j hlowPos
  have hbase : 2 ^ (1 + 2 * p.n) = 2 ^ (1 + p.n) * 2 ^ p.n := by
    rw [← Nat.pow_add]
    congr 1
    omega
  rw [hbase]
  have hlt1 :
      j % 2 ^ (1 + p.n) +
          bandedSparseAccessPaperAddress p j * 2 ^ (1 + p.n) <
        2 ^ (1 + p.n) +
          bandedSparseAccessPaperAddress p j * 2 ^ (1 + p.n) := by
    exact Nat.add_lt_add_right hlow
      (bandedSparseAccessPaperAddress p j * 2 ^ (1 + p.n))
  have hsucc : bandedSparseAccessPaperAddress p j + 1 ≤ 2 ^ p.n :=
    Nat.succ_le_of_lt haddr
  have hle :
      (bandedSparseAccessPaperAddress p j + 1) * 2 ^ (1 + p.n) ≤
        2 ^ p.n * 2 ^ (1 + p.n) := by
    exact Nat.mul_le_mul_right (2 ^ (1 + p.n)) hsucc
  have heq :
      2 ^ (1 + p.n) +
          bandedSparseAccessPaperAddress p j * 2 ^ (1 + p.n) =
        (bandedSparseAccessPaperAddress p j + 1) * 2 ^ (1 + p.n) := by
    rw [Nat.add_comm]
    exact (Nat.succ_mul (bandedSparseAccessPaperAddress p j)
      (2 ^ (1 + p.n))).symm
  rw [heq] at hlt1
  rw [Nat.mul_comm (2 ^ (1 + p.n)) (2 ^ p.n)]
  exact Nat.lt_of_lt_of_le hlt1 hle

/-- The paper image preserves the low ancilla-and-row block modulo its width. -/
theorem bandedSparseAccessPaperImage_mod_lowBase
    (p : OneTermRobinParameters) (j : Nat) :
    bandedSparseAccessPaperImage p j % 2 ^ (1 + p.n) =
      j % 2 ^ (1 + p.n) := by
  unfold bandedSparseAccessPaperImage
  let lowWidth := 1 + p.n
  let highWidth := 1 + 2 * p.n
  let lowBase := 2 ^ lowWidth
  let highBase := 2 ^ highWidth
  let lowPrefix := j % lowBase
  let highTail := j / highBase
  let address := bandedSparseAccessPaperAddress p j
  have hbase : highBase = lowBase * 2 ^ p.n := by
    dsimp [highBase, lowBase, highWidth, lowWidth]
    rw [← Nat.pow_add]
    congr 1
    omega
  have hlow : lowPrefix % lowBase = lowPrefix := by
    dsimp [lowPrefix]
    exact Nat.mod_eq_of_lt (Nat.mod_lt j (Nat.pow_pos (by decide : 0 < 2)))
  calc
    (lowPrefix + address * lowBase + highTail * highBase) % lowBase
        = (lowPrefix + lowBase * address + highTail * highBase) % lowBase := by
          rw [Nat.mul_comm address lowBase]
    _ = (lowPrefix + lowBase * address + highTail * (lowBase * 2 ^ p.n)) % lowBase := by
          rw [hbase]
    _ = (lowPrefix + lowBase * (address + highTail * 2 ^ p.n)) % lowBase := by
          congr 1
          rw [Nat.mul_add]
          ac_rfl
    _ = lowPrefix % lowBase := by
          rw [Nat.add_mul_mod_self_left]
    _ = lowPrefix := hlow
    _ = j % 2 ^ (1 + p.n) := by rfl

/--
After shifting past the low block, the paper image exposes the written address
modulo the n-bit O_D^BS register.
-/
theorem bandedSparseAccessPaperImage_div_lowBase_mod_eq
    (p : OneTermRobinParameters) (j : Nat)
    (haddr : bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    bandedSparseAccessPaperImage p j / 2 ^ (1 + p.n) % 2 ^ p.n =
      bandedSparseAccessPaperAddress p j := by
  unfold bandedSparseAccessPaperImage
  rw [Nat.one_shiftLeft] at haddr
  let lowWidth := 1 + p.n
  let highWidth := 1 + 2 * p.n
  let lowBase := 2 ^ lowWidth
  let highBase := 2 ^ highWidth
  let lowPrefix := j % lowBase
  let highTail := j / highBase
  let address := bandedSparseAccessPaperAddress p j
  have hlowPos : 0 < lowBase := by
    dsimp [lowBase, lowWidth]
    exact Nat.pow_pos (by decide : 0 < 2)
  have hlow : lowPrefix < lowBase := by
    dsimp [lowPrefix]
    exact Nat.mod_lt j hlowPos
  have hbase : highBase = lowBase * 2 ^ p.n := by
    dsimp [highBase, lowBase, highWidth, lowWidth]
    rw [← Nat.pow_add]
    congr 1
    omega
  have himage : lowPrefix + address * lowBase + highTail * highBase =
      lowPrefix + lowBase * (address + highTail * 2 ^ p.n) := by
    rw [hbase]
    rw [Nat.mul_add]
    ac_rfl
  have hdiv :
      (lowPrefix + lowBase * (address + highTail * 2 ^ p.n)) / lowBase =
        address + highTail * 2 ^ p.n := by
    rw [Nat.add_mul_div_left _ _ hlowPos]
    rw [Nat.div_eq_of_lt hlow]
    simp
  have hlowWidth : 2 ^ (1 + p.n) = lowBase := by rfl
  rw [hlowWidth]
  rw [himage]
  rw [hdiv]
  rw [Nat.add_mul_mod_self_right]
  exact Nat.mod_eq_of_lt haddr

/--
The executable paper image remains inside the full finite basis when the input
column is in range and the written O_D^BS address is n-bit.
-/
theorem bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt
    (p : OneTermRobinParameters) (j : Nat)
    (hj : j < qubitDim (oneTermRobinTotalQubits p))
    (haddr : bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    bandedSparseAccessPaperImage p j < qubitDim (oneTermRobinTotalQubits p) := by
  simp only [qubitDim, gridSize] at hj ⊢
  unfold bandedSparseAccessPaperImage
  let lowWidth := 1 + p.n
  let highWidth := 1 + 2 * p.n
  let lowBase := 2 ^ lowWidth
  let highBase := 2 ^ highWidth
  let lowPrefix := j % lowBase
  let highTail := j / highBase
  let address := bandedSparseAccessPaperAddress p j
  have hsmall :
      lowPrefix + address * lowBase < highBase :=
    bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt p j haddr
  have hwidth : highWidth ≤ oneTermRobinTotalQubits p := by
    dsimp [highWidth]
    exact bandedSparseAccessPaperHighWidth_le_totalQubits p
  have hpowTotal : highBase * 2 ^ (oneTermRobinTotalQubits p - highWidth) =
      2 ^ oneTermRobinTotalQubits p := by
    dsimp [highBase]
    rw [← Nat.pow_add]
    congr 1
    omega
  have htail_lt : highTail < 2 ^ (oneTermRobinTotalQubits p - highWidth) := by
    dsimp [highTail]
    apply Nat.div_lt_of_lt_mul
    rwa [hpowTotal]
  have htail_succ : highTail + 1 ≤ 2 ^ (oneTermRobinTotalQubits p - highWidth) :=
    Nat.succ_le_of_lt htail_lt
  have hblock :
      lowPrefix + address * lowBase + highTail * highBase <
        highBase * (highTail + 1) := by
    rw [Nat.mul_succ, Nat.mul_comm highBase highTail]
    omega
  have htotal : highBase * (highTail + 1) ≤ 2 ^ oneTermRobinTotalQubits p := by
    have hmul := Nat.mul_le_mul_left highBase htail_succ
    rwa [hpowTotal] at hmul
  exact Nat.lt_of_lt_of_le hblock htotal

/--
Finite-basis index for the executable Lemma 1 `O_D^BS` paper image.

This constructor is available only when the source column is already in the
full finite basis and the written `O_D^BS` address is n-bit.  It is a bridge
from the arithmetic image function to matrix entries, not a unitarity proof.
-/
def bandedSparseAccessPaperImageFin
    (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (haddr : bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    Fin (qubitDim (oneTermRobinTotalQubits p)) :=
  ⟨bandedSparseAccessPaperImage p j.val,
    bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt p j.val j.2 haddr⟩

@[simp] theorem bandedSparseAccessPaperImageFin_val
    (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (haddr : bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (bandedSparseAccessPaperImageFin p j haddr).val =
      bandedSparseAccessPaperImage p j.val := rfl

/-- Register extraction from the paper image preserves the row register. -/
theorem bandedSparseAccessPaperImage_rowValue_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperRegisters p
      (bandedSparseAccessPaperImage p j)).rowValue =
      (bandedSparseAccessPaperRegisters p j).rowValue := by
  unfold bandedSparseAccessPaperRegisters
  simp only []
  rw [bandedSparseAccessPaperRegisterValue_eq_mod,
    bandedSparseAccessPaperRegisterValue_eq_mod]
  have hpow : 2 * 2 ^ p.n = 2 ^ (1 + p.n) := by
    rw [show 1 + p.n = p.n + 1 by omega, Nat.pow_succ]
    omega
  have hmod := bandedSparseAccessPaperImage_mod_lowBase p j
  rw [← hpow] at hmod
  rw [← Nat.mod_mul_right_div_self (bandedSparseAccessPaperImage p j) 2 (2 ^ p.n)]
  rw [← Nat.mod_mul_right_div_self j 2 (2 ^ p.n)]
  rw [hmod]

/-- Register extraction from the paper image reports the written O_D^BS address. -/
theorem bandedSparseAccessPaperImage_odRegisterValue_eq
    (p : OneTermRobinParameters) (j : Nat)
    (haddr : bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    (bandedSparseAccessPaperRegisters p
      (bandedSparseAccessPaperImage p j)).odRegisterValue =
      bandedSparseAccessPaperAddress p j := by
  unfold bandedSparseAccessPaperRegisters
  simp only []
  rw [bandedSparseAccessPaperRegisterValue_eq_mod]
  exact bandedSparseAccessPaperImage_div_lowBase_mod_eq p j haddr

/-- High signal/workspace bits above the n-bit `O_D^BS` address register. -/
def bandedSparseAccessPaperHighTail (p : OneTermRobinParameters) (j : Nat) : Nat :=
  j >>> (1 + 2 * p.n)

/--
The arithmetic register-splice form of `bandedSparseAccessPaperImage` preserves
all bits above the `O_D^BS` address register when the written address is n-bit.

This is a proof-DAG block for Lemma 1 register safety.  It does not promote the
paper-level `noSpill` obligation because the parameter-family side conditions
are still tracked by `defaultBandedSparseAccessPaperContract`.
-/
theorem bandedSparseAccessPaperImage_highTail_eq_of_address_lt
    (p : OneTermRobinParameters) (j : Nat)
    (haddr : bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    bandedSparseAccessPaperHighTail p (bandedSparseAccessPaperImage p j) =
      bandedSparseAccessPaperHighTail p j := by
  unfold bandedSparseAccessPaperHighTail
  rw [Nat.shiftRight_eq_div_pow, Nat.shiftRight_eq_div_pow]
  unfold bandedSparseAccessPaperImage
  let lowWidth := 1 + p.n
  let highWidth := 1 + 2 * p.n
  let lowBase := 2 ^ lowWidth
  let highBase := 2 ^ highWidth
  let lowPrefix := j % lowBase
  let highTail := j / highBase
  let address := bandedSparseAccessPaperAddress p j
  have hhighPos : 0 < highBase := by
    dsimp [highBase, highWidth]
    exact Nat.pow_pos (by decide : 0 < 2)
  have hsmall : lowPrefix + address * lowBase < highBase :=
    bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt p j haddr
  have hdivsmall : (lowPrefix + address * lowBase) / highBase = 0 :=
    Nat.div_eq_of_lt hsmall
  calc
    (lowPrefix + address * lowBase + highTail * highBase) / highBase
        = (lowPrefix + address * lowBase + highBase * highTail) / highBase := by
          rw [Nat.mul_comm highTail highBase]
    _ = (lowPrefix + address * lowBase) / highBase + highTail := by
          rw [Nat.add_mul_div_left _ _ hhighPos]
    _ = highTail := by simp [hdivsmall]
    _ = j / highBase := rfl

/--
Executable check that the paper-image skeleton does not write past the n-bit
`O_D^BS` address register into the indicator or `m_f` bits above it.
-/
def bandedSparseAccessPaperImageNoSpill (p : OneTermRobinParameters) (j : Nat) : Bool :=
  bandedSparseAccessPaperHighTail p (bandedSparseAccessPaperImage p j) ==
    bandedSparseAccessPaperHighTail p j

/--
Boolean form of the executable high-tail no-spill check.

The high-tail theorem above discharges this Boolean under an n-bit written
address, while the paper-level semantic obligation remains a separate flag.
-/
theorem bandedSparseAccessPaperImageNoSpill_iff
    (p : OneTermRobinParameters) (j : Nat) :
    bandedSparseAccessPaperImageNoSpill p j = true ↔
      bandedSparseAccessPaperHighTail p (bandedSparseAccessPaperImage p j) =
        bandedSparseAccessPaperHighTail p j := by
  unfold bandedSparseAccessPaperImageNoSpill
  exact beq_iff_eq

/-- The no-spill Boolean follows from the executable n-bit address bound. -/
theorem bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt
    (p : OneTermRobinParameters) (j : Nat)
    (haddr : bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    bandedSparseAccessPaperImageNoSpill p j = true := by
  rw [bandedSparseAccessPaperImageNoSpill_iff]
  exact bandedSparseAccessPaperImage_highTail_eq_of_address_lt p j haddr

/--
The no-spill Boolean is true in the fourth-order grid regime `2 <= n`, reusing
the address-range proof-DAG block.  Semantic obligation flags remain false.
-/
theorem bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le
    (p : OneTermRobinParameters) (j : Nat) (hn : 2 ≤ p.n) :
    bandedSparseAccessPaperImageNoSpill p j = true := by
  apply bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt
  have h := bandedSparseAccessPaperAddress_lt_gridSize_of_two_le p j hn
  simpa [gridSize, Nat.one_shiftLeft] using h

/--
Clean-domain predicate for the Lemma 1 `O_D^BS` source equation.

The paper specifies columns whose padded zero register is `|0>^(n-l)`.
Columns outside this domain still need a separate unitary-completion proof;
the current paper-image matrix is only a Phase 1 skeleton for that full-space
extension.
-/
def bandedSparseAccessPaperCleanInput (p : OneTermRobinParameters) (j : Nat) : Bool :=
  (bandedSparseAccessPaperRegisters p j).paddedZeroValue == 0

/--
Boolean form of the Lemma 1 clean-input domain.

The executable predicate is exactly the statement that the padded part of the
`O_D^BS` sparse-address register is zero.  This only classifies columns; it
does not prove the clean-input source equation or a unitary extension.
-/
theorem bandedSparseAccessPaperCleanInput_iff
    (p : OneTermRobinParameters) (j : Nat) :
    bandedSparseAccessPaperCleanInput p j = true ↔
      (bandedSparseAccessPaperRegisters p j).paddedZeroValue = 0 := by
  unfold bandedSparseAccessPaperCleanInput
  exact beq_iff_eq

/--
Per-column audit record for the executable Lemma 1 paper image.

This records the source-domain flag, the image index, and the two register
properties expected from the paper equation.  The Boolean fields are executable
checks for the current skeleton; they are not promoted to theorem-level
correctness.  The obligation fields keep the clean-domain and full-unitary
extension gaps explicit.
-/
structure BandedSparseAccessPaperColumnContract where
  sourceAnchor : String
  inputRegisters : BandedSparseAccessPaperRegisters
  cleanInput : Bool
  imageIndex : Nat
  imageRegisters : BandedSparseAccessPaperRegisters
  rowPreserved : Bool
  addressWritten : Bool
  addressInRange : Bool
  imageNoSpill : Bool
  cleanInputDomain : ObligationRecord
  addressRange : ObligationRecord
  noSpill : ObligationRecord
  unitaryExtension : ObligationRecord
deriving Repr, DecidableEq

/--
Default per-column contract for the `O_D^BS` paper image skeleton.
-/
def bandedSparseAccessPaperColumnContract
    (p : OneTermRobinParameters) (j : Nat) :
    BandedSparseAccessPaperColumnContract :=
  let regs := bandedSparseAccessPaperRegisters p j
  let image := bandedSparseAccessPaperImage p j
  let imageRegs := bandedSparseAccessPaperRegisters p image
  let paperContract := defaultBandedSparseAccessPaperContract p
  {
    sourceAnchor := paperContract.sourceAnchor
    inputRegisters := regs
    cleanInput := bandedSparseAccessPaperCleanInput p j
    imageIndex := image
    imageRegisters := imageRegs
    rowPreserved := imageRegs.rowValue == regs.rowValue
    addressWritten := imageRegs.odRegisterValue == bandedSparseAccessPaperAddress p j
    addressInRange := bandedSparseAccessPaperAddressInRange p j
    imageNoSpill := bandedSparseAccessPaperImageNoSpill p j
    cleanInputDomain := paperContract.cleanInputDomain
    addressRange := paperContract.addressRange
    noSpill := paperContract.noSpill
    unitaryExtension := paperContract.unitaryExtension
  }

/-- The per-column contract uses the shared Lemma 1 register extractor. -/
theorem bandedSparseAccessPaperColumnContract_inputRegisters_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).inputRegisters =
      bandedSparseAccessPaperRegisters p j := rfl

/-- The per-column clean-domain flag is the executable padded-zero predicate. -/
theorem bandedSparseAccessPaperColumnContract_cleanInput_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).cleanInput =
      bandedSparseAccessPaperCleanInput p j := rfl

/--
The per-column clean-domain flag is true exactly on Lemma 1 clean columns.

Columns with a nonzero padded register are still covered only by the explicit
unitary-extension obligation.
-/
theorem bandedSparseAccessPaperColumnContract_cleanInput_iff
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).cleanInput = true ↔
      (bandedSparseAccessPaperRegisters p j).paddedZeroValue = 0 := by
  rw [bandedSparseAccessPaperColumnContract_cleanInput_eq]
  exact bandedSparseAccessPaperCleanInput_iff p j

/--
The per-column audit keeps the full-space unitary extension as an open
obligation for every column, including non-clean padded-register inputs.
-/
theorem bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).unitaryExtension.proved = false := rfl

/-- The per-column contract records the same image index as the paper-image skeleton. -/
theorem bandedSparseAccessPaperColumnContract_imageIndex_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).imageIndex =
      bandedSparseAccessPaperImage p j := rfl

/-- The per-column contract records the executable n-bit address range check. -/
theorem bandedSparseAccessPaperColumnContract_addressInRange_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).addressInRange =
      bandedSparseAccessPaperAddressInRange p j := rfl

/-- The per-column contract records the executable high-bit no-spill check. -/
theorem bandedSparseAccessPaperColumnContract_imageNoSpill_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (bandedSparseAccessPaperColumnContract p j).imageNoSpill =
      bandedSparseAccessPaperImageNoSpill p j := rfl

/--
Matrix entries for the faithful Lemma 1 `O_D^BS` paper-image skeleton.

The column `j` has a candidate `1` entry at
`bandedSparseAccessPaperImage p j.val`, which replaces the padded sparse-address
register by `r_si` and preserves the row register.  This declaration is the
active `oneTermRobinGate_O_D_BS` matrix, but it does not prove that the image is
in range, injective, unitary, or cleaned up by the dagger.
-/
def bandedSparseAccessPaperMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    if i.val = bandedSparseAccessPaperImage p j.val then Coeff.rat 1 else Coeff.rat 0

/-- The paper-image matrix entry is governed by `bandedSparseAccessPaperImage`. -/
theorem bandedSparseAccessPaperMatrix_eq_image (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p))) :
    bandedSparseAccessPaperMatrix p i j =
      if i.val = bandedSparseAccessPaperImage p j.val then Coeff.rat 1 else Coeff.rat 0 := by
  rfl

/--
Forward paper-image matrix entry at the finite image column.

The hypotheses are the same explicit range hypotheses used to construct
`bandedSparseAccessPaperImageFin`.  This theorem does not assert that the
image function is injective or that the matrix is unitary.
-/
theorem bandedSparseAccessPaperMatrix_imageFin_eq_one
    (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (haddr : bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    bandedSparseAccessPaperMatrix p (bandedSparseAccessPaperImageFin p j haddr) j =
      Coeff.rat 1 := by
  simp [bandedSparseAccessPaperMatrix, bandedSparseAccessPaperImageFin]

/--
Transpose-style matrix for the faithful Lemma 1 `O_D^BS` paper-image skeleton.

The entry `M†[i,j]` is `1` exactly when column index `j` is the forward
paper image of row index `i`.  This is only the matrix-level transpose of the
current executable image skeleton; the inverse, unitarity, and post-SWAP cleanup
claims remain tracked by `defaultBandedSparseAccessPaperContract p` with
`proved := false`.
-/
def bandedSparseAccessPaperDaggerMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    if j.val = bandedSparseAccessPaperImage p i.val then Coeff.rat 1 else Coeff.rat 0

/-- The paper-image dagger matrix is the transpose-style matrix for the image skeleton. -/
theorem bandedSparseAccessPaperDaggerMatrix_eq_image (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p))) :
    bandedSparseAccessPaperDaggerMatrix p i j =
      if j.val = bandedSparseAccessPaperImage p i.val then Coeff.rat 1 else Coeff.rat 0 := by
  rfl

/--
Transpose-style paper-image matrix entry paired with the finite forward image.

This is the entry relation needed before an inverse-on-range proof.  It does
not prove that the transpose-style matrix cleans the ancillas after SWAP.
-/
theorem bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one
    (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (haddr : bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    bandedSparseAccessPaperDaggerMatrix p j (bandedSparseAccessPaperImageFin p j haddr) =
      Coeff.rat 1 := by
  simp [bandedSparseAccessPaperDaggerMatrix, bandedSparseAccessPaperImageFin]

/--
Sparse amplitude value: the s-th nonzero stencil coefficient of row i in the
Robin derivative matrix, returned as a Coeff value.

This is the data layer that both O_DT^S (sparse amplitude oracle, Lemma 3)
and Ry_boundary (boundary-controlled rotations) need.  The column index
corresponding to each (s, i) pair is given by `robinSparseColumnMap`.

For the fourth-order central second-derivative stencil:
- Bulk rows (K1 ≤ i ≤ K2): 5 entries at offsets {-2,-1,0,1,2}
- Left boundary row 0: 3 entries with Robin correction (A1*dx term)
- Left boundary row 1: 4 entries with Robin correction (A1*dx term)
- Right boundary row N-2: 4 entries with Robin correction (B1*dx term)
- Right boundary row N-1: 3 entries with Robin correction (B1*dx term)
- Unused sparse indices (s ≥ entry count): Coeff.rat 0

main.tex:822-849, 1081-1083, 1113-1117 --/
def robinSparseAmplitudeValue (n s i : Nat) : Coeff :=
  let N := gridSize n
  let K1 := 2
  let K2 := N - 3
  if K1 ≤ i ∧ i ≤ K2 then
    match s with
    | 0 => Coeff.rat ((-1 : Rat) / 12)
    | 1 => Coeff.rat ((4 : Rat) / 3)
    | 2 => Coeff.rat ((-5 : Rat) / 2)
    | 3 => Coeff.rat ((4 : Rat) / 3)
    | 4 => Coeff.rat ((-1 : Rat) / 12)
    | _ => Coeff.rat 0
  else if i = 0 then
    match s with
    | 0 => Coeff.add (Coeff.rat ((-5 : Rat) / 2))
        (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx"))
    | 1 => Coeff.rat ((8 : Rat) / 3)
    | 2 => Coeff.rat ((-1 : Rat) / 6)
    | _ => Coeff.rat 0
  else if i = 1 then
    match s with
    | 0 => Coeff.add (Coeff.rat ((4 : Rat) / 3))
        (Coeff.neg (Coeff.mul (Coeff.rat ((1 : Rat) / 6)) (Coeff.symbol "A1*dx")))
    | 1 => Coeff.rat ((-31 : Rat) / 12)
    | 2 => Coeff.rat ((4 : Rat) / 3)
    | 3 => Coeff.rat ((-1 : Rat) / 12)
    | _ => Coeff.rat 0
  else if i = N - 2 then
    match s with
    | 0 => Coeff.rat ((-1 : Rat) / 12)
    | 1 => Coeff.rat ((4 : Rat) / 3)
    | 2 => Coeff.rat ((-31 : Rat) / 12)
    | 3 => Coeff.add (Coeff.rat ((4 : Rat) / 3))
        (Coeff.mul (Coeff.rat ((1 : Rat) / 6)) (Coeff.symbol "B1*dx"))
    | _ => Coeff.rat 0
  else if i = N - 1 then
    match s with
    | 0 => Coeff.rat ((-1 : Rat) / 6)
    | 1 => Coeff.rat ((8 : Rat) / 3)
    | 2 => Coeff.add (Coeff.rat ((-5 : Rat) / 2))
        (Coeff.neg (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "B1*dx")))
    | _ => Coeff.rat 0
  else
    Coeff.rat 0

/--
Honest U_indic matrix: controlled-X on the indicator qubit, conditioned on
the system register being in the bulk window [K1, K2].
For each basis state |j⟩:
  - Extract systemVal = bits [1, 1+n) of j
  - If K1 ≤ systemVal ≤ K2 (bulk row): flip indicator bit
  - Otherwise (boundary row): identity
main.tex:1088-1099 --/
def indicatorOracleMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let n := p.n
    let indPos := robinIndicatorBitPosition p
    let systemVal := (j.val >>> 1) &&& ((1 <<< n) - 1)
    let K1 := 2
    let K2 := gridSize n - 3
    let isBulk := if K1 ≤ systemVal ∧ systemVal ≤ K2 then (1 : Nat) else 0
    let expectedImage := j.val ^^^ (isBulk <<< indPos)
    if i.val = expectedImage then Coeff.rat 1 else Coeff.rat 0

/--
Gate matrix for U_indic using the honest permutation matrix.
Controlled-X on indicator bit at position 1+2n, conditioned on bulk membership.
Unitarity proved: indicatorOracleMatrix_is_permutation shows each row and column
has exactly one entry equal to 1, so the matrix is a permutation matrix (hence unitary).
main.tex:1088-1099 --/
def oneTermRobinGate_U_indic (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.oracleCall "U_indic"
  matrix := indicatorOracleMatrix p
  unitary := {
    description := "U_indic(K1,K2) permutation matrix: unitarity proved via indicatorOracleMatrix_is_permutation"
    source := "main.tex:1088-1099"
    proved := true
  }

/--
Honest O_DT^S diagonal matrix: encodes the sparse amplitude data on the diagonal
for bulk rows (indicator=1) and acts as identity for boundary rows (indicator=0).

For each compound basis state |j⟩:
  - If indicator bit = 0 (boundary row): diagonal entry = Coeff.rat 1 (identity)
  - If indicator bit = 1 (bulk row): diagonal entry = robinSparseAmplitudeValue(n, s, i)
  - Off-diagonal entries are zero.

NOTE: The paper's actual O_{D^T}^S (Lemma 3, main.tex:822-849) is a controlled
rotation on the ancilla qubit, not a diagonal matrix.  This diagonal encoding
exercises the amplitude data pathway; the rotation structure is a proof obligation.
main.tex:822-849 --/
def sparseAmplitudeOracleDTMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    if i.val ≠ j.val then Coeff.rat 0
    else
      let n := p.n
      let indPos := robinIndicatorBitPosition p
      let indBit := (j.val >>> indPos) &&& 1
      if indBit = 0 then
        Coeff.rat 1
      else
        let kappa := p.kappa
        let κbits := clog2 kappa
        let odPure := n - κbits
        let sysMask := (1 <<< n) - 1
        let sysVal := (j.val >>> 1) &&& sysMask
        let sparseStart := 1 + n + odPure
        let sparseMask := (1 <<< κbits) - 1
        let sparseVal := (j.val >>> sparseStart) &&& sparseMask
        robinSparseAmplitudeValue n sparseVal sysVal

/--
Register values used by the faithful Lemma 3 `O_DT^S` contract.

The compound-index convention stores the rotation ancilla in bit 0, the system
row in bits `[1, 1+n)`, the padded sparse register in bits `[1+n, 1+2n)`, and
the indicator bit at `robinIndicatorBitPosition p`.  The `nonAncillaValue`
field is `j >>> 1`; preserving it means that only the ancilla bit may change.
Guseynov-Huang-Liu 2025, Lemma 3, arXiv:2506.20478. -/
structure SparseAmplitudeOracleDTPaperRegisters where
  ancillaBit : Nat
  indicatorBit : Nat
  rowValue : Nat
  sparseIndexValue : Nat
  nonAncillaValue : Nat
deriving Repr, DecidableEq

/--
Extract the Lemma 3 sparse-amplitude oracle registers from a compound basis
index.  This is a source-contract skeleton for the paper's controlled rotation
on the ancilla qubit; it leaves the legacy diagonal data helper available.
-/
def sparseAmplitudeOracleDTPaperRegisters (p : OneTermRobinParameters) (j : Nat) :
    SparseAmplitudeOracleDTPaperRegisters :=
  let n := p.n
  let indPos := robinIndicatorBitPosition p
  let κbits := clog2 p.kappa
  let odPure := n - κbits
  let sysMask := (1 <<< n) - 1
  let sparseStart := 1 + n + odPure
  let sparseMask := (1 <<< κbits) - 1
  {
    ancillaBit := j &&& 1
    indicatorBit := (j >>> indPos) &&& 1
    rowValue := (j >>> 1) &&& sysMask
    sparseIndexValue := (j >>> sparseStart) &&& sparseMask
    nonAncillaValue := j >>> 1
  }

/-- Symbolic cosine half-angle entry for the Lemma 3 O_DT^S rotation. -/
def sparseAmplitudeOracleDTCosHalf (row sparse : Nat) : Coeff :=
  Coeff.symbol s!"odts_cos_half_{row}_{sparse}"

/-- Symbolic sine half-angle entry for the Lemma 3 O_DT^S rotation. -/
def sparseAmplitudeOracleDTSinHalf (row sparse : Nat) : Coeff :=
  Coeff.symbol s!"odts_sin_half_{row}_{sparse}"

/--
Explicit unresolved source obligation for the symbolic entries in the Lemma 3
`O_DT^S` rotation skeleton.

Equation (20) of Guseynov-Huang-Liu 2025 maps `|0>|s>` to an amplitude whose
`|0>` component is `D^(s) / N_D` and whose complementary component is the
square-root normalizer term.  The Lean symbols
`sparseAmplitudeOracleDTCosHalf row sparse` and
`sparseAmplitudeOracleDTSinHalf row sparse` are only placeholders until this
coefficient/normalizer relation and the corresponding two-by-two unitarity
identity are formalized.
-/
def sparseAmplitudeOracleDTCoefficientNormalizerObligation : ObligationRecord := {
  description := "O_DT^S symbolic rotation entries match Eq. (20): D^(s)/N_D amplitude and complementary normalizer term"
  source := "Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), arXiv:2506.20478"
  proved := false
}

/--
Typed Eq. (20) coefficient-normalizer contract for one `O_DT^S` rotation block.

This binds the symbolic rotation entries to the concrete Robin sparse
coefficient data and the paper's `N_D` normalizer without proving the analytic
identities.  The three obligations stay false until Lean has a coefficient
language with the required division, square-root, absolute-value, and unitarity
facts.
-/
structure SparseAmplitudeOracleDTCoefficientNormalizerContract where
  sourceAnchor : String
  rowValue : Nat
  sparseIndexValue : Nat
  coefficient : Coeff
  normalizerND : Coeff
  ketZeroEntry : Coeff
  ketOneEntry : Coeff
  ketZeroFormula : String
  ketOneFormula : String
  coefficientRelation : ObligationRecord
  complementRelation : ObligationRecord
  twoByTwoUnitary : ObligationRecord
deriving Repr, DecidableEq

/--
Default Eq. (20) coefficient-normalizer contract for a Robin row and sparse
index.  The coefficient is `robinSparseAmplitudeValue p.n sparse row`; the
rotation entries are the symbols used by `sparseAmplitudeOracleDTRotationMatrix`.
-/
def sparseAmplitudeOracleDTCoefficientNormalizerContract
    (p : OneTermRobinParameters) (row sparse : Nat) :
    SparseAmplitudeOracleDTCoefficientNormalizerContract where
  sourceAnchor := "Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), arXiv:2506.20478"
  rowValue := row
  sparseIndexValue := sparse
  coefficient := robinSparseAmplitudeValue p.n sparse row
  normalizerND := Coeff.symbol "N_D"
  ketZeroEntry := sparseAmplitudeOracleDTCosHalf row sparse
  ketOneEntry := sparseAmplitudeOracleDTSinHalf row sparse
  ketZeroFormula := "D_j^(s) / N_D"
  ketOneFormula := "sqrt(1 - |D_j^(s)|^2 / N_D^2)"
  coefficientRelation := {
    description := "ket-zero rotation entry equals D_j^(s) / N_D"
    source := "Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), arXiv:2506.20478"
    proved := false
  }
  complementRelation := {
    description := "ket-one rotation entry equals sqrt(1 - |D_j^(s)|^2 / N_D^2)"
    source := "Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), arXiv:2506.20478"
    proved := false
  }
  twoByTwoUnitary := {
    description := "the Eq. (20) two-by-two ancilla block is unitary under the N_D bound"
    source := "Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), arXiv:2506.20478"
    proved := false
  }

/--
Faithful Lemma 3 controlled-rotation skeleton for `O_DT^S`.

For columns whose indicator bit is 0, the matrix acts as identity.  For columns
whose indicator bit is 1, it preserves every non-ancilla bit and applies a
symbolic two-by-two rotation on ancilla bit 0.  The symbols are indexed by the
extracted row and sparse-index values; their connection to the Eq. (20)
amplitudes determined by `robinSparseAmplitudeValue p.n sparse row / N_D`
remains the coefficient-normalizer proof obligation.
Guseynov-Huang-Liu 2025, Lemma 3, arXiv:2506.20478. -/
def sparseAmplitudeOracleDTRotationMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let regs := sparseAmplitudeOracleDTPaperRegisters p j.val
    if regs.indicatorBit = 0 then
      if i.val = j.val then Coeff.rat 1 else Coeff.rat 0
    else if i.val >>> 1 ≠ regs.nonAncillaValue then
      Coeff.rat 0
    else
      let cosHalf := sparseAmplitudeOracleDTCosHalf regs.rowValue regs.sparseIndexValue
      let sinHalf := sparseAmplitudeOracleDTSinHalf regs.rowValue regs.sparseIndexValue
      let anc_i := i.val &&& 1
      match regs.ancillaBit, anc_i with
      | 0, 0 => cosHalf
      | 0, 1 => sinHalf
      | 1, 0 => Coeff.neg sinHalf
      | _, _ => cosHalf

/--
Gate matrix for O_DT^S using the faithful controlled-rotation skeleton.
The legacy diagonal helper `sparseAmplitudeOracleDTMatrix` remains available as
the coefficient-data path, but the active gate now preserves all non-ancilla
bits and rotates bit 0 when the indicator bit is 1.  Unitarity and the
normalizer-bound trigonometric identity are not yet formally proved.
main.tex:822-849 --/
def oneTermRobinGate_O_DT_S (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.oracleCall "O_DT^S"
  matrix := sparseAmplitudeOracleDTRotationMatrix p
  unitary := {
    description := "O_DT^S controlled-rotation skeleton on ancilla bit: unitarity and normalizer bound not yet proved"
    source := "Guseynov-Huang-Liu 2025, Lemma 3, arXiv:2506.20478"
    proved := false
  }

/--
Register values used by the faithful `Ry_boundary` source contract.

The compound-index convention is the same one used by the active matrix:
ancilla bit 0 is the rotated qubit, bits `[1, 1+n)` contain the Robin row,
the high part of the O_D register contains sparse index `s`, and the indicator
bit determines whether the boundary rotation is active.  The `nonAncillaValue`
field is preserved by the controlled rotation.
Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Eq. angles for Ry,
arXiv:2506.20478. -/
structure BoundaryRotationPaperRegisters where
  ancillaBit : Nat
  indicatorBit : Nat
  rowValue : Nat
  sparseIndexValue : Nat
  nonAncillaValue : Nat
deriving Repr, DecidableEq

/--
Extract the `Ry_boundary` register fields from a compound basis index.
This is a source-contract skeleton; it does not prove the angle identities or
unitarity of the symbolic rotation block.
-/
def boundaryRotationPaperRegisters (p : OneTermRobinParameters) (j : Nat) :
    BoundaryRotationPaperRegisters :=
  let n := p.n
  let indPos := robinIndicatorBitPosition p
  let κbits := clog2 p.kappa
  let odPure := n - κbits
  let sysMask := (1 <<< n) - 1
  let sparseStart := 1 + n + odPure
  let sparseMask := (1 <<< κbits) - 1
  {
    ancillaBit := j &&& 1
    indicatorBit := (j >>> indPos) &&& 1
    rowValue := (j >>> 1) &&& sysMask
    sparseIndexValue := (j >>> sparseStart) &&& sparseMask
    nonAncillaValue := j >>> 1
  }

/-- Symbolic cosine half-angle entry for the `Ry_boundary` rotation. -/
def boundaryRotationCosHalf (row sparse : Nat) : Coeff :=
  Coeff.symbol s!"boundary_cos_half_{row}_{sparse}"

/-- Symbolic sine half-angle entry for the `Ry_boundary` rotation. -/
def boundaryRotationSinHalf (row sparse : Nat) : Coeff :=
  Coeff.symbol s!"boundary_sin_half_{row}_{sparse}"

/--
Explicit unresolved source obligation for the `Ry_boundary` angle/normalizer
relation.

The paper uses angles `theta_j^s = arccos(D_j^(s) / N_D)` for boundary rows.
The Lean symbols `boundaryRotationCosHalf row sparse` and
`boundaryRotationSinHalf row sparse` are placeholders until the half-angle
identities and the two-by-two unitarity relation are formalized.
-/
def boundaryRotationAngleNormalizerObligation : ObligationRecord := {
  description := "Ry_boundary symbolic entries match theta_j^s = arccos(D_j^(s) / N_D) and the half-angle formulas"
  source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478"
  proved := false
}

/--
Typed angle/normalizer contract for one `Ry_boundary` rotation block.

This binds the symbolic half-angle entries used by `boundaryRotationMatrix` to
the Robin sparse coefficient source and the paper normalizer `N_D`.  It records
the exact obligations without asserting the arccos relation, half-angle
formulas, control condition, or unitarity.
-/
structure BoundaryRotationAngleNormalizerContract where
  sourceAnchor : String
  rowValue : Nat
  sparseIndexValue : Nat
  coefficient : Coeff
  normalizerND : Coeff
  thetaFormula : String
  cosHalfEntry : Coeff
  sinHalfEntry : Coeff
  cosHalfFormula : String
  sinHalfFormula : String
  boundaryControl : ObligationRecord
  arccosArgumentRelation : ObligationRecord
  cosHalfRelation : ObligationRecord
  sinHalfRelation : ObligationRecord
  twoByTwoUnitary : ObligationRecord
deriving Repr, DecidableEq

/--
Default `Ry_boundary` angle/normalizer contract for one Robin row and sparse
index.  The coefficient is `robinSparseAmplitudeValue p.n sparse row`; the
rotation entries are the symbols used by `boundaryRotationMatrix`.
-/
def boundaryRotationAngleNormalizerContract
    (p : OneTermRobinParameters) (row sparse : Nat) :
    BoundaryRotationAngleNormalizerContract where
  sourceAnchor := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478"
  rowValue := row
  sparseIndexValue := sparse
  coefficient := robinSparseAmplitudeValue p.n sparse row
  normalizerND := Coeff.symbol "N_D"
  thetaFormula := "theta_j^s = arccos(D_j^(s) / N_D)"
  cosHalfEntry := boundaryRotationCosHalf row sparse
  sinHalfEntry := boundaryRotationSinHalf row sparse
  cosHalfFormula := "sqrt((1 + D_j^(s) / N_D) / 2)"
  sinHalfFormula := "sqrt((1 - D_j^(s) / N_D) / 2)"
  boundaryControl := {
    description := "Ry_boundary acts only on boundary rows selected by indicator bit 0"
    source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin, arXiv:2506.20478"
    proved := false
  }
  arccosArgumentRelation := {
    description := "theta_j^s is arccos(D_j^(s) / N_D) for the recorded Robin coefficient; blocked until Coeff has division and real arccos semantics"
    source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
    proved := false
  }
  cosHalfRelation := {
    description := "cos(theta_j^s / 2) equals sqrt((1 + D_j^(s) / N_D) / 2); blocked until Coeff has square-root and half-angle semantics"
    source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
    proved := false
  }
  sinHalfRelation := {
    description := "sin(theta_j^s / 2) equals sqrt((1 - D_j^(s) / N_D) / 2); blocked until Coeff has square-root and half-angle semantics"
    source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
    proved := false
  }
  twoByTwoUnitary := {
    description := "the Ry_boundary two-by-two block is unitary under the N_D bound"
    source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
    proved := false
  }

/--
The coefficient source of the `Ry_boundary` angle contract is definitionally
the Robin sparse amplitude data layer.
-/
theorem boundaryRotationAngleNormalizerContract_coefficient
    (p : OneTermRobinParameters) (row sparse : Nat) :
    (boundaryRotationAngleNormalizerContract p row sparse).coefficient =
      robinSparseAmplitudeValue p.n sparse row := rfl

/--
Symbolic stand-in for the paper argument `D_j^(s) / N_D`.

The factor `Coeff.symbol "N_D_inv"` is not a proof that `N_D` is invertible.
It only records the intended normalized coefficient while the required division
semantics and nonzero normalizer condition remain explicit obligations.
-/
def boundaryRotationNormalizedCoefficient
    (p : OneTermRobinParameters) (row sparse : Nat) : Coeff :=
  Coeff.mul (robinSparseAmplitudeValue p.n sparse row) (Coeff.symbol "N_D_inv")

/--
Refined proof route for the `ryb_angle_normalizer` block.

This record separates the typed data already present in
`BoundaryRotationAngleNormalizerContract` from the missing analytic semantics:
division by `N_D`, real arccos, square roots, the paper's normalizer bound, and
the resulting two-by-two unitarity identity.  All proof obligations stay false
in Phase 1.
-/
structure BoundaryRotationAngleNormalizerProofRoute where
  sourceAnchor : String
  rowValue : Nat
  sparseIndexValue : Nat
  coefficient : Coeff
  normalizerND : Coeff
  arccosArgument : Coeff
  arccosArgumentFormula : String
  thetaFormula : String
  cosHalfEntry : Coeff
  sinHalfEntry : Coeff
  cosHalfFormula : String
  sinHalfFormula : String
  coefficientDivision : ObligationRecord
  realArccosSemantics : ObligationRecord
  halfAngleSemantics : ObligationRecord
  normalizerBound : ObligationRecord
  twoByTwoUnitary : ObligationRecord
deriving Repr, DecidableEq

/--
Default refined proof route for one `Ry_boundary` angle-normalizer block.

The route keeps the construction fixed to the paper formula
`theta_j^s = arccos(D_j^(s) / N_D)`.  It does not introduce a replacement angle
or promote the gate-level unitarity claim.
-/
def boundaryRotationAngleNormalizerProofRoute
    (p : OneTermRobinParameters) (row sparse : Nat) :
    BoundaryRotationAngleNormalizerProofRoute :=
  let c := boundaryRotationAngleNormalizerContract p row sparse
  {
    sourceAnchor := c.sourceAnchor
    rowValue := c.rowValue
    sparseIndexValue := c.sparseIndexValue
    coefficient := c.coefficient
    normalizerND := c.normalizerND
    arccosArgument := boundaryRotationNormalizedCoefficient p row sparse
    arccosArgumentFormula := "D_j^(s) / N_D"
    thetaFormula := c.thetaFormula
    cosHalfEntry := c.cosHalfEntry
    sinHalfEntry := c.sinHalfEntry
    cosHalfFormula := c.cosHalfFormula
    sinHalfFormula := c.sinHalfFormula
    coefficientDivision := {
      description := "interpret the formal coefficient times N_D_inv as D_j^(s) / N_D"
      source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
      proved := false
    }
    realArccosSemantics := {
      description := "connect theta_j^s to real arccos of the normalized coefficient"
      source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
      proved := false
    }
    halfAngleSemantics := {
      description := "derive the displayed cosine and sine half-angle formulas from theta_j^s"
      source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
      proved := false
    }
    normalizerBound := {
      description := "prove the N_D bound placing D_j^(s) / N_D in the arccos domain"
      source := "Guseynov-Huang-Liu 2025, Eq. angles for Ry, arXiv:2506.20478"
      proved := false
    }
    twoByTwoUnitary := c.twoByTwoUnitary
  }

theorem boundaryRotationAngleNormalizerProofRoute_coefficient
    (p : OneTermRobinParameters) (row sparse : Nat) :
    (boundaryRotationAngleNormalizerProofRoute p row sparse).coefficient =
      (boundaryRotationAngleNormalizerContract p row sparse).coefficient := rfl

theorem boundaryRotationAngleNormalizerProofRoute_arccosArgument
    (p : OneTermRobinParameters) (row sparse : Nat) :
    (boundaryRotationAngleNormalizerProofRoute p row sparse).arccosArgument =
      boundaryRotationNormalizedCoefficient p row sparse := rfl

/--
Honest Ry_boundary matrix: controlled R_y rotation on the ancilla qubit (bit 0),
conditioned on the indicator bit being 0 (boundary row).

For bulk rows (indicator=1): acts as identity (no rotation).
For boundary rows (indicator=0): applies R_y(θ_j^s) on the ancilla qubit,
where θ_j^s = arccos(D_j^(s) / N_D) (main.tex:1115-1120, Eq. angles for Ry).

The R_y(θ) matrix on the ancilla qubit:
  M(|0⟩, |0⟩) = cos(θ/2),  M(|1⟩, |0⟩) = sin(θ/2)
  M(|0⟩, |1⟩) = -sin(θ/2), M(|1⟩, |1⟩) = cos(θ/2)

Rotation entries are symbolic since the exact trigonometric values involve
square roots: cos(θ/2) = √((1 + D/N_D)/2), sin(θ/2) = √((1 - D/N_D)/2).
main.tex:1115-1120 --/
def boundaryRotationMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let n := p.n
    let indPos := robinIndicatorBitPosition p
    let indBit_j := (j.val >>> indPos) &&& 1
    if indBit_j = 1 then
      if i.val = j.val then Coeff.rat 1 else Coeff.rat 0
    else
      let anc_j := j.val &&& 1
      let anc_i := i.val &&& 1
      if i.val >>> 1 ≠ j.val >>> 1 then Coeff.rat 0
      else
        let kappa := p.kappa
        let κbits := clog2 kappa
        let odPure := n - κbits
        let sysMask := (1 <<< n) - 1
        let sysVal := (j.val >>> 1) &&& sysMask
        let sparseStart := 1 + n + odPure
        let sparseMask := (1 <<< κbits) - 1
        let sparseVal := (j.val >>> sparseStart) &&& sparseMask
        let cosHalf := boundaryRotationCosHalf sysVal sparseVal
        let sinHalf := boundaryRotationSinHalf sysVal sparseVal
        match anc_j, anc_i with
        | 0, 0 => cosHalf
        | 0, 1 => sinHalf
        | 1, 0 => Coeff.neg sinHalf
        | _, _ => cosHalf

/--
Gate matrix for Ry_boundary using the honest controlled rotation matrix.
R_y rotation on the ancilla qubit for boundary rows (indicator=0);
identity for bulk rows (indicator=1).
Unitarity not yet formally proved.
main.tex:1115-1120 --/
def oneTermRobinGate_Ry_boundary (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.oracleCall "Ry_boundary"
  matrix := boundaryRotationMatrix p
  unitary := {
    description := "Ry_boundary honest controlled rotation matrix: unitarity not yet proved"
    source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478"
    proved := false
  }

/--
Interim O_D^BS column-map helper, not the faithful Lemma 1 paper oracle.
It maps |s⟩|i⟩ → |s⟩|col(s,i)⟩ by replacing the system register bits.
Bits outside the system register are preserved.  The paper contract
|0>^(n-l)|s>^l|i>^n -> |r_si>^n|i>^n is recorded separately in
`defaultBandedSparseAccessPaperContract`; do not use this helper as the
unitarity or block-extraction target for the paper oracle.
main.tex:784-801 --/
def bandedSparseAccessMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let n := p.n
    let kappa := p.kappa
    let κbits := clog2 kappa
    let odPure := n - κbits
    let sysMask := (1 <<< n) - 1
    let sysVal := (j.val >>> 1) &&& sysMask
    let sparseStart := 1 + n + odPure
    let sparseMask := (1 <<< κbits) - 1
    let sparseVal := (j.val >>> sparseStart) &&& sparseMask
    let col := robinSparseColumnMap n sparseVal sysVal
    let expectedImage := j.val - (j.val &&& (sysMask <<< 1)) + (col <<< 1)
    if i.val = expectedImage then Coeff.rat 1 else Coeff.rat 0

/--
Gate record for the faithful Lemma 1 O_D^BS paper-image matrix skeleton.

The matrix uses `bandedSparseAccessPaperMatrix`, which preserves the row
register and writes `r_si` into the padded sparse-address register.  Unitarity,
forward correctness, and block extraction remain unproved obligations.
Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478. -/
def oneTermRobinGate_O_D_BS (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.oracleCall "O_D^BS"
  matrix := bandedSparseAccessPaperMatrix p
  unitary := {
    description := "O_D^BS paper-image matrix skeleton: unitarity and cleanup not yet proved"
    source := "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478"
    proved := false
  }

/-- Active forward `O_D^BS` gate entry at the finite paper image. -/
theorem oneTermRobinGate_O_D_BS_imageFin_eq_one
    (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (haddr : bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (oneTermRobinGate_O_D_BS p).matrix
        (bandedSparseAccessPaperImageFin p j haddr) j =
      Coeff.rat 1 := by
  simpa [oneTermRobinGate_O_D_BS]
    using bandedSparseAccessPaperMatrix_imageFin_eq_one p j haddr

/--
Symbolic function value at grid point j.
Returns Coeff.symbol "f_x_j" for each grid index.
The paper's O_f (Lemma 4, main.tex:870-910) encodes f(x_j)/N_f;
the 1/N_f factor is absorbed into the normalizer α = N_D · N_f · κ.
main.tex:870-910 --/
def robinFunctionValue (n i : Nat) : Coeff :=
  Coeff.symbol s!"f_{n}_{i}"

/--
Register values used by the paper-level function oracle `O_f` contract.

The compound-index convention stores the system row in bits `[1, 1+n)` and
stores the `m_f` function-oracle workspace immediately above the indicator bit,
starting at `robinIndicatorBitPosition p + 1`.  This record is a source-contract
skeleton for the paper's clean-workspace equation; it does not assert the
amplitude relation or workspace cleanup.
Guseynov-Huang-Liu 2025, function-oracle construction, arXiv:2506.20478. -/
structure FunctionOraclePaperRegisters where
  systemValue : Nat
  mfWorkspaceValue : Nat
  nonMFValue : Nat
  cleanWorkspace : Bool
deriving Repr, DecidableEq

/--
Extract the system register and the `m_f` function workspace from a compound
basis index for the `O_f` source contract.

The `nonMFValue` field is the input index with the `m_f` workspace bits cleared.
For clean-workspace columns this is the clean-branch basis index appearing in
the paper equation.
-/
def functionOraclePaperRegisters (p : OneTermRobinParameters) (j : Nat) :
    FunctionOraclePaperRegisters :=
  let n := p.n
  let rp := defaultRobinRegisterPartition p
  let sysMask := (1 <<< n) - 1
  let mfStart := robinIndicatorBitPosition p + 1
  let mfMask := (1 <<< rp.mfQubits) - 1
  let mfValue := (j >>> mfStart) &&& mfMask
  {
    systemValue := (j >>> 1) &&& sysMask
    mfWorkspaceValue := mfValue
    nonMFValue := j - (j &&& (mfMask <<< mfStart))
    cleanWorkspace := mfValue == 0
  }

/--
Symbolic normalized clean-branch amplitude for the paper's function oracle.

The reciprocal symbol records the intended factor `1 / N_f` without proving
that `N_f` is nonzero or that the amplitude is bounded.
-/
def functionOracleNormalizedValue (p : OneTermRobinParameters) (i : Nat) : Coeff :=
  Coeff.mul (robinFunctionValue p.n i) (Coeff.symbol "N_f_inv")

/--
Paper-image source contract for one column of the function oracle `O_f`.

The clean branch records the displayed paper component
`(f(x_i)/N_f)|0>^mf|i>`.  The orthogonal component and all analytic side
conditions are tracked as false obligations; this record is not a matrix proof
and does not promote the current diagonal helper to a faithful oracle.
-/
structure FunctionOraclePaperImage where
  sourceAnchor : String
  inputRegisters : FunctionOraclePaperRegisters
  cleanBranchBasisIndex : Nat
  cleanBranchSystemValue : Nat
  cleanBranchWorkspaceValue : Nat
  cleanBranchAmplitude : Coeff
  orthogonalComponent : String
  systemPreserved : Bool
  cleanWorkspaceBranch : Bool
  normalizedAmplitudeCorrect : ObligationRecord
  orthogonalComponentCorrect : ObligationRecord
  normalizerBound : ObligationRecord
  unitaryCompletion : ObligationRecord
  diagonalHelperIsolation : ObligationRecord
deriving Repr, DecidableEq

/--
Build the paper-level `O_f` image contract for one compound basis column.

This captures the register-level target
`|0>^mf|i> ↦ (f(x_i)/N_f)|0>^mf|i> + |orth_f(i)>` as data and keeps every
unproved semantic claim explicit.
-/
def functionOraclePaperImage (p : OneTermRobinParameters) (j : Nat) :
    FunctionOraclePaperImage :=
  let regs := functionOraclePaperRegisters p j
  {
    sourceAnchor := "Guseynov-Huang-Liu 2025, function oracle O_f, arXiv:2506.20478"
    inputRegisters := regs
    cleanBranchBasisIndex := regs.nonMFValue
    cleanBranchSystemValue := regs.systemValue
    cleanBranchWorkspaceValue := 0
    cleanBranchAmplitude := functionOracleNormalizedValue p regs.systemValue
    orthogonalComponent := s!"orth_f_{p.n}_{regs.systemValue}"
    systemPreserved := regs.systemValue == ((regs.nonMFValue >>> 1) &&& ((1 <<< p.n) - 1))
    cleanWorkspaceBranch := regs.cleanWorkspace
    normalizedAmplitudeCorrect := {
      description := "clean O_f branch amplitude equals f(x_i) / N_f"
      source := "Guseynov-Huang-Liu 2025, function oracle O_f, arXiv:2506.20478"
      proved := false
    }
    orthogonalComponentCorrect := {
      description := "O_f orthogonal component has zero overlap with the clean m_f workspace branch and preserves the system label"
      source := "Guseynov-Huang-Liu 2025, function oracle O_f, arXiv:2506.20478"
      proved := false
    }
    normalizerBound := {
      description := "N_f bounds the coefficient-function amplitudes used by O_f"
      source := "Guseynov-Huang-Liu 2025, function oracle O_f, arXiv:2506.20478"
      proved := false
    }
    unitaryCompletion := {
      description := "O_f paper image extends to a unitary with the recorded orthogonal component"
      source := "Guseynov-Huang-Liu 2025, function oracle O_f, arXiv:2506.20478"
      proved := false
    }
    diagonalHelperIsolation := {
      description := "functionOracleMatrix is helper-only until the paper O_f image is wired to a full matrix"
      source := "QBE-AUTO-002 O_f source-contract audit"
      proved := false
    }
  }

/-- Bridge lemma: the `O_f` paper image uses the shared register extractor. -/
theorem functionOraclePaperImage_inputRegisters_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (functionOraclePaperImage p j).inputRegisters =
      functionOraclePaperRegisters p j := rfl

/-- Bridge lemma: the clean `O_f` branch clears only the `m_f` workspace bits. -/
theorem functionOraclePaperImage_cleanBranchBasisIndex_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (functionOraclePaperImage p j).cleanBranchBasisIndex =
      (functionOraclePaperRegisters p j).nonMFValue := rfl

/-- Bridge lemma: the clean `O_f` branch preserves the extracted system value. -/
theorem functionOraclePaperImage_cleanBranchSystemValue_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (functionOraclePaperImage p j).cleanBranchSystemValue =
      (functionOraclePaperRegisters p j).systemValue := rfl

/-- Bridge lemma: the clean `O_f` branch has zero `m_f` workspace value. -/
theorem functionOraclePaperImage_cleanBranchWorkspaceValue_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (functionOraclePaperImage p j).cleanBranchWorkspaceValue = 0 := rfl

/--
Bridge lemma: the clean `O_f` branch amplitude is the normalized function value
at the system value extracted from the same column.
-/
theorem functionOraclePaperImage_cleanBranchAmplitude_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (functionOraclePaperImage p j).cleanBranchAmplitude =
      functionOracleNormalizedValue p (functionOraclePaperRegisters p j).systemValue := rfl

/-- Bridge lemma: the clean-workspace branch flag is inherited from the extractor. -/
theorem functionOraclePaperImage_cleanWorkspaceBranch_eq
    (p : OneTermRobinParameters) (j : Nat) :
    (functionOraclePaperImage p j).cleanWorkspaceBranch =
      (functionOraclePaperRegisters p j).cleanWorkspace := rfl

/--
Symbolic matrix entry for the unresolved orthogonal component of `O_f`.

The paper only fixes the clean `m_f` branch amplitude
`f(x_i) / N_f`; the remaining orthogonal completion is a unitarity obligation.
This symbol records one placeholder entry for that unresolved completion without
proving orthogonality, normalizer bounds, or unitarity.
-/
def functionOracleOrthogonalEntry
    (p : OneTermRobinParameters) (systemValue row col : Nat) : Coeff :=
  Coeff.symbol s!"orth_f_entry_{p.n}_{systemValue}_{row}_{col}"

/--
Faithful Phase 1 matrix skeleton for the paper-level function oracle `O_f`.

For each clean-workspace input column, the clean `m_f` branch entry is the
normalized amplitude recorded by `functionOraclePaperImage`, namely
`f(x_i) / N_f` represented as `functionOracleNormalizedValue`.  Other
clean-workspace output rows are zero, matching the paper statement that the
unresolved component is orthogonal to the clean workspace branch.
Non-clean-workspace rows carry symbolic completion entries.  For non-clean
input columns, the paper does not fix a branch equation, so this skeleton leaves
all entries symbolic.

The symbolic completion does not prove amplitude correctness, the `N_f` bound,
orthogonality, or unitarity; those obligations remain false in
`functionOraclePaperImage` and the gate record.
-/
def functionOraclePaperMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let image := functionOraclePaperImage p j.val
    if image.cleanWorkspaceBranch then
      if i.val = image.cleanBranchBasisIndex then
        image.cleanBranchAmplitude
      else if (functionOraclePaperRegisters p i.val).mfWorkspaceValue = 0 then
        Coeff.rat 0
      else
        functionOracleOrthogonalEntry p image.cleanBranchSystemValue i.val j.val
    else
      functionOracleOrthogonalEntry p image.cleanBranchSystemValue i.val j.val

/-- The `O_f` paper matrix exposes the clean branch amplitude for clean input columns. -/
theorem functionOraclePaperMatrix_cleanBranch_entry
    (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hClean : (functionOraclePaperImage p j.val).cleanWorkspaceBranch = true)
    (h : i.val = (functionOraclePaperImage p j.val).cleanBranchBasisIndex) :
    functionOraclePaperMatrix p i j =
      (functionOraclePaperImage p j.val).cleanBranchAmplitude := by
  simp [functionOraclePaperMatrix, hClean, h]

/-- Other clean-workspace rows have zero `O_f` orthogonal-completion entry. -/
theorem functionOraclePaperMatrix_cleanWorkspace_offBranch_zero
    (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hInputClean : (functionOraclePaperImage p j.val).cleanWorkspaceBranch = true)
    (hBranch : i.val ≠ (functionOraclePaperImage p j.val).cleanBranchBasisIndex)
    (hClean : (functionOraclePaperRegisters p i.val).mfWorkspaceValue = 0) :
    functionOraclePaperMatrix p i j = Coeff.rat 0 := by
  simp [functionOraclePaperMatrix, hInputClean, hBranch, hClean]

/-- Non-clean input columns are left in the symbolic `O_f` completion branch. -/
theorem functionOraclePaperMatrix_nonCleanInput_entry
    (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (hInputNonClean : (functionOraclePaperImage p j.val).cleanWorkspaceBranch = false) :
    functionOraclePaperMatrix p i j =
      functionOracleOrthogonalEntry p
        (functionOraclePaperImage p j.val).cleanBranchSystemValue i.val j.val := by
  simp [functionOraclePaperMatrix, hInputNonClean]

/--
Helper-only O_f diagonal matrix: records function values f(x_j) on the diagonal.

For each compound basis state |j⟩, extracts the system register value i
and sets the diagonal entry to `robinFunctionValue n i` = Coeff.symbol "f_x_i".
All off-diagonal entries are zero.  The entry depends only on the system
register (grid point index), not on the sparse index.

The paper's O_f (Lemma 4, main.tex:870-910) encodes f(x_j)/N_f via amplitude
oracle.  The 1/N_f normalization is absorbed into the block-encoding normalizer
α = N_D · N_f · κ.  This diagonal matrix is not the paper image; the
paper-level clean branch and orthogonal-component obligations are recorded by
`functionOraclePaperImage`, and the active gate keeps `unitary.proved := false`.

main.tex:870-910 --/
def functionOracleMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    if i.val = j.val then
      let n := p.n
      let sysMask := (1 <<< n) - 1
      let sysVal := (j.val >>> 1) &&& sysMask
      robinFunctionValue n sysVal
    else Coeff.rat 0

/--
Gate matrix for `O_f` using the faithful paper-image matrix skeleton.

The active matrix now exposes the clean `m_f` branch amplitude from
`functionOraclePaperImage`.  The legacy diagonal helper `functionOracleMatrix`
remains available only as a function-value data check.  Unitarity, amplitude
correctness, the `N_f` bound, and the orthogonal completion are still unproved.
Guseynov-Huang-Liu 2025, Lemma 4 and Fig. 1-term Robin, arXiv:2506.20478. -/
def oneTermRobinGate_O_f (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.oracleCall "O_f"
  matrix := functionOraclePaperMatrix p
  unitary := {
    description := "O_f paper-image matrix skeleton: clean branch wired, orthogonal completion and unitarity not yet proved"
    source := "Guseynov-Huang-Liu 2025, Lemma 4 and Fig. 1-term Robin, arXiv:2506.20478"
    proved := false
  }

/--
Honest SWAP matrix: permutation matrix swapping the system register
(n qubits at bits [1, 1+n)) with the O_D^BS register (n qubits at bits [1+n, 1+2n)).

For each basis state |j⟩:
  - Extract block1 = bits [1, 1+n) of j  (system register value)
  - Extract block2 = bits [1+n, 1+2n) of j (O_D^BS register value)
  - diff = block1 XOR block2
  - Swapped index = j XOR (diff <<< 1) XOR (diff <<< (1+n))

When block1 = block2 the SWAP is the identity.  All bits outside the two
n-qubit blocks (ancilla bit 0, indicator bit 1+2n, mf MSBs) are preserved.

Unitarity remains a proof obligation; the SWAP image-level proof is tracked in
the proof-DAG notes rather than promoted here.
figure:1_term_ROBIN, main.tex:1140 --/
def swapOracleMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let n := p.n
    let blockMask := (1 <<< n) - 1
    let block1 := (j.val >>> 1) &&& blockMask
    let block2 := (j.val >>> (1 + n)) &&& blockMask
    let diff := block1 ^^^ block2
    let swapped := j.val ^^^ (diff <<< 1) ^^^ (diff <<< (1 + n))
    if i.val = swapped then Coeff.rat 1 else Coeff.rat 0

/--
Image function for the SWAP oracle: swaps two n-qubit register blocks.
For each basis state j, swaps block1 (bits [1,1+n)) with block2 (bits [1+n,1+2n))
by XORing with the block difference shifted to each block position.
main.tex:1140 --/
def swapOracleImage (p : OneTermRobinParameters) (j : Nat) : Nat :=
  let n := p.n
  let blockMask := (1 <<< n) - 1
  let block1 := (j >>> 1) &&& blockMask
  let block2 := (j >>> (1 + n)) &&& blockMask
  let diff := block1 ^^^ block2
  j ^^^ (diff <<< 1) ^^^ (diff <<< (1 + n))

/-- swapOracleMatrix entry equals image function check. -/
theorem swapOracleMatrix_eq_image (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p))) :
    swapOracleMatrix p i j =
      if i.val = swapOracleImage p j.val then Coeff.rat 1 else Coeff.rat 0 := by
  simp [swapOracleMatrix, swapOracleImage]

/--
Gate matrix for SWAP using the honest permutation matrix.
Swaps system register (bits [1,n+1)) with O_D^BS register (bits [n+1,2n+1)).
Unitarity is still a proof obligation.  A previous flat proof attempt was
demoted because the bit-slice lemmas need a smaller proof-DAG interface.
main.tex:1140 --/
def oneTermRobinGate_SWAP (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.swap 0 0
  matrix := swapOracleMatrix p
  unitary := {
    description := "SWAP permutation matrix: unitarity proof pending proof-DAG bit-slice lemmas"
    source := "main.tex:1140"
    proved := false
  }

/--
Transpose-style matrix for O_D^BS, sharing the forward sparse-access image map.
For each i: compute image(i) using the forward mapping, then check if j = image(i).
This is the matrix transpose of bandedSparseAccessMatrix.  The inverse/unitarity
proof is blocked until the forward boundary column-map contract is reconciled.
main.tex:1148 --/
def bandedSparseAccessDaggerMatrix (p : OneTermRobinParameters) :
    Matrix (qubitDim (oneTermRobinTotalQubits p)) (qubitDim (oneTermRobinTotalQubits p)) Coeff :=
  fun i j =>
    let n := p.n
    let kappa := p.kappa
    let κbits := clog2 kappa
    let odPure := n - κbits
    let sysMask := (1 <<< n) - 1
    let sysVal := (i.val >>> 1) &&& sysMask
    let sparseStart := 1 + n + odPure
    let sparseMask := (1 <<< κbits) - 1
    let sparseVal := (i.val >>> sparseStart) &&& sparseMask
    let col := robinSparseColumnMap n sparseVal sysVal
    let image := i.val - (i.val &&& (sysMask <<< 1)) + (col <<< 1)
    if j.val = image then Coeff.rat 1 else Coeff.rat 0

/--
Gate matrix for `(O_D^BS)^†` using the transpose-style paper-image matrix.

This is paired with `bandedSparseAccessPaperMatrix`; it does not prove that the
transpose is a true inverse on the relevant post-SWAP states.
figure:1_term_ROBIN and Lemma 1, arXiv:2506.20478. -/
def oneTermRobinGate_O_D_BS_dagger (p : OneTermRobinParameters) : GateMatrix Coeff (oneTermRobinTotalQubits p) where
  gate := Gate.oracleCall "(O_D^BS)^†"
  matrix := bandedSparseAccessPaperDaggerMatrix p
  unitary := {
    description := "(O_D^BS)^† paper-image transpose matrix: cleanup and unitarity not yet proved"
    source := "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Lemma 1, arXiv:2506.20478"
    proved := false
  }

/-- Active `(O_D^BS)^†` gate entry paired with the finite forward image. -/
theorem oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one
    (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (haddr : bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (oneTermRobinGate_O_D_BS_dagger p).matrix j
        (bandedSparseAccessPaperImageFin p j haddr) =
      Coeff.rat 1 := by
  simpa [oneTermRobinGate_O_D_BS_dagger]
    using bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one p j haddr

/--
List of all 7 gate matrix placeholders for the one-term Robin circuit,
in the same order as `oneTermRobinCircuit`.
figure:1_term_ROBIN --/
def oneTermRobinGateMatrixPlaceholders (p : OneTermRobinParameters) :
    List (GateMatrix Coeff (oneTermRobinTotalQubits p)) :=
  [ oneTermRobinGate_U_indic p
  , oneTermRobinGate_O_DT_S p
  , oneTermRobinGate_Ry_boundary p
  , oneTermRobinGate_O_D_BS p
  , oneTermRobinGate_O_f p
  , oneTermRobinGate_SWAP p
  , oneTermRobinGate_O_D_BS_dagger p
  ]

/--
The placeholder gate matrices match the circuit gate labels.
This is trivially true because the placeholders were constructed
with matching gate constructors.
figure:1_term_ROBIN --/
theorem oneTermRobinPlaceholdersMatch (p : OneTermRobinParameters) :
    gateMatricesMatchCircuit oneTermRobinCircuit (oneTermRobinGateMatrixPlaceholders p) = true := by
  simp [oneTermRobinCircuit, oneTermRobinGateMatrixPlaceholders,
    oneTermRobinGate_U_indic, oneTermRobinGate_O_DT_S,
    oneTermRobinGate_Ry_boundary, oneTermRobinGate_O_D_BS,
    oneTermRobinGate_O_f, oneTermRobinGate_SWAP,
    oneTermRobinGate_O_D_BS_dagger,
    gateMatricesMatchCircuit]

/--
Indicator oracle image function: for each basis state j, computes the image
by XORing the indicator bit at position indPos when the system register value
is in the bulk window [K1, K2]. This is a self-inverse permutation.
main.tex:1088-1099 --/
def indicatorOracleImage (p : OneTermRobinParameters) (j : Nat) : Nat :=
  let n := p.n
  let indPos := robinIndicatorBitPosition p
  let systemVal := (j >>> 1) &&& ((1 <<< n) - 1)
  let K1 := 2
  let K2 := gridSize n - 3
  let isBulk := if K1 ≤ systemVal ∧ systemVal ≤ K2 then (1 : Nat) else 0
  j ^^^ (isBulk <<< indPos)

/--
The indicator oracle matrix entry is 1 exactly when i = indicatorOracleImage j.
main.tex:1088-1099 --/
theorem indicatorOracleMatrix_eq_image (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p))) :
    indicatorOracleMatrix p i j =
      if i.val = indicatorOracleImage p j.val then Coeff.rat 1 else Coeff.rat 0 := by
  simp [indicatorOracleMatrix, indicatorOracleImage]

/--
Self-inverse property for n=1: applying indicatorOracleImage twice returns the
original value for all j in Fin domain (128 elements).
Checked by native_decide over the finite Fin type.
main.tex:1088-1099 --/
theorem indicatorOracleImage_self_inverse_n1 :
    ∀ j : Fin (qubitDim (oneTermRobinTotalQubits
      { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 })),
      indicatorOracleImage
        { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 }
        (indicatorOracleImage
          { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 } j) = j := by
  native_decide

/--
Self-inverse property for n=3: applying indicatorOracleImage twice returns the
original value for all j in Fin domain (8192 elements).
Checked by native_decide over the finite Fin type.
main.tex:1088-1099 --/
theorem indicatorOracleImage_self_inverse_n3 :
    ∀ j : Fin (qubitDim (oneTermRobinTotalQubits
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 })),
      indicatorOracleImage
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
        (indicatorOracleImage
          { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } j) = j := by
  native_decide

/--
Injectivity for n=1: derived from self-inverse property.
main.tex:1088-1099 --/
theorem indicatorOracleImage_injective_n1 {j₁ j₂ : Fin (qubitDim (oneTermRobinTotalQubits
      { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 }))}
    (h : indicatorOracleImage
        { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 } j₁ =
      indicatorOracleImage
        { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 } j₂) :
    j₁ = j₂ := by
  have h1 := indicatorOracleImage_self_inverse_n1 j₁
  have h2 := indicatorOracleImage_self_inverse_n1 j₂
  apply Fin.ext
  show (j₁ : Nat) = j₂
  rw [← h1, ← h2, h]

/--
Injectivity for n=3: derived from self-inverse property.
main.tex:1088-1099 --/
theorem indicatorOracleImage_injective_n3 {j₁ j₂ : Fin (qubitDim (oneTermRobinTotalQubits
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }))}
    (h : indicatorOracleImage
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } j₁ =
      indicatorOracleImage
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } j₂) :
    j₁ = j₂ := by
  have h1 := indicatorOracleImage_self_inverse_n3 j₁
  have h2 := indicatorOracleImage_self_inverse_n3 j₂
  apply Fin.ext
  show (j₁ : Nat) = j₂
  rw [← h1, ← h2, h]

/--
Cycle 12 helper: (b <<< pos) &&& ((1 <<< n) - 1) = 0 when pos >= n,
because b <<< pos has all zeros in bits [0, pos) >= [0, n).
-/
theorem shiftLeft_land_mask_eq_zero (b pos n : Nat) (h : pos ≥ n) :
    (b <<< pos) &&& ((1 <<< n) - 1) = 0 := by
  have key : ∀ i, i < n → (b <<< pos).testBit i = false := by
    intro i hi; simp [Nat.testBit_shiftLeft]; omega
  have all_false : ∀ i, (b <<< pos &&& (1 <<< n - 1)).testBit i = (0 : Nat).testBit i := by
    intro i; simp only [Nat.testBit_and]
    by_cases h1 : i < n
    · rw [key i h1]; simp
    · have : (1 <<< n - 1).testBit i = false := by
        rw [Nat.one_shiftLeft, Nat.testBit_two_pow_sub_one]; simp [h1]
      simp [this]
  exact Nat.eq_of_testBit_eq all_false

/--
Cycle 12 helper: XOR with a value shifted left by `pos` preserves the low `n` bits
when `pos >= n`.  Uses AND-XOR distributivity and the zero mask lemma.
-/
theorem xor_shift_preserve_low (x b pos n : Nat) (h : pos ≥ n) :
    (x ^^^ (b <<< pos)) &&& ((1 <<< n) - 1) = x &&& ((1 <<< n) - 1) := by
  rw [Nat.and_xor_distrib_right]
  have := shiftLeft_land_mask_eq_zero b pos n h
  rw [this, Nat.xor_zero]

/--
Cycle 12 helper: XOR with a high-shifted value preserves low bits after right-shifting.
((x ^^^ (b <<< pos)) >>> 1) &&& ((1 <<< n) - 1) = (x >>> 1) &&& ((1 <<< n) - 1)
when pos >= 1 + n.
-/
theorem xor_shift_preserve_shift_low (x b pos n : Nat) (h : pos ≥ 1 + n) :
    ((x ^^^ (b <<< pos)) >>> 1) &&& ((1 <<< n) - 1) =
    (x >>> 1) &&& ((1 <<< n) - 1) := by
  have key : ∀ i, i < n →
      ((x ^^^ (b <<< pos)) >>> 1).testBit i = (x >>> 1).testBit i := by
    intro i hi
    simp only [Nat.testBit_shiftRight, Nat.testBit_xor]
    have : (b <<< pos).testBit (1 + i) = false := by
      simp [Nat.testBit_shiftLeft]; omega
    simp [this]
  have eq_bits : ∀ i,
      ((x ^^^ (b <<< pos)) >>> 1 &&& (1 <<< n - 1)).testBit i =
      ((x >>> 1) &&& (1 <<< n - 1)).testBit i := by
    intro i; simp only [Nat.testBit_and]
    by_cases h1 : i < n
    · simp [key i h1]
    · have : (1 <<< n - 1).testBit i = false := by
        rw [Nat.one_shiftLeft, Nat.testBit_two_pow_sub_one]; simp [h1]
      simp [this]
  exact Nat.eq_of_testBit_eq eq_bits

/--
SWAP proof-DAG helper: the XOR difference between the two n-bit blocks is
itself an n-bit value.
main.tex:1140 --/
theorem swapOracleDiff_lt_two_pow (p : OneTermRobinParameters) (j : Nat) :
    let n := p.n
    let blockMask := (1 <<< n) - 1
    let block1 := (j >>> 1) &&& blockMask
    let block2 := (j >>> (1 + n)) &&& blockMask
    block1 ^^^ block2 < 2 ^ n := by
  dsimp
  apply Nat.xor_lt_two_pow
  · apply Nat.and_lt_two_pow
    rw [Nat.one_shiftLeft]
    exact Nat.sub_lt (Nat.pow_pos (by decide : 0 < 2) : 0 < 2 ^ p.n) (by decide)
  · apply Nat.and_lt_two_pow
    rw [Nat.one_shiftLeft]
    exact Nat.sub_lt (Nat.pow_pos (by decide : 0 < 2) : 0 < 2 ^ p.n) (by decide)

/--
SWAP proof-DAG helper: right-shifting the n-bit block difference by n removes it.
main.tex:1140 --/
theorem swapOracleDiff_shiftRight_eq_zero (p : OneTermRobinParameters) (j : Nat) :
    let n := p.n
    let blockMask := (1 <<< n) - 1
    let block1 := (j >>> 1) &&& blockMask
    let block2 := (j >>> (1 + n)) &&& blockMask
    let diff := block1 ^^^ block2
    diff >>> n = 0 := by
  have hdiff := swapOracleDiff_lt_two_pow p j
  dsimp at hdiff ⊢
  exact Nat.shiftRight_eq_zero _ _ hdiff

/--
SWAP proof-DAG helper: shifting the block difference into the high block leaves
zero in the low n-bit mask.
main.tex:1140 --/
theorem swapOracleDiff_shiftLeft_mask_eq_zero (p : OneTermRobinParameters) (j : Nat) :
    let n := p.n
    let blockMask := (1 <<< n) - 1
    let block1 := (j >>> 1) &&& blockMask
    let block2 := (j >>> (1 + n)) &&& blockMask
    let diff := block1 ^^^ block2
    (diff <<< n) &&& blockMask = 0 := by
  dsimp
  exact shiftLeft_land_mask_eq_zero
    (((j >>> 1) &&& (1 <<< p.n) - 1) ^^^ ((j >>> (1 + p.n)) &&& (1 <<< p.n) - 1))
    p.n p.n (by omega)

/--
SWAP proof-DAG block: after `swapOracleImage`, the low n-bit register equals
the old high n-bit register.  This is the first register-level bit-slice lemma
needed for the eventual SWAP self-inverse/permutation proof.
main.tex:1140 --/
theorem swapOracleImage_block1_eq_block2 (p : OneTermRobinParameters) (j : Nat) :
    let n := p.n
    let blockMask := (1 <<< n) - 1
    ((swapOracleImage p j) >>> 1) &&& blockMask =
      (j >>> (1 + n)) &&& blockMask := by
  dsimp [swapOracleImage]
  apply Nat.eq_of_testBit_eq
  intro i
  simp only [Nat.testBit_and]
  by_cases hi : i < p.n
  · have hmask : ((1 <<< p.n) - 1).testBit i = true := by
      rw [Nat.one_shiftLeft, Nat.testBit_two_pow_sub_one]
      simp [hi]
    have hnle : ¬p.n ≤ i := Nat.not_le_of_gt hi
    simp only [Nat.testBit_shiftRight, Nat.testBit_xor, Nat.testBit_shiftLeft,
      Nat.testBit_and]
    simp [hmask, hnle, Nat.add_comm, Nat.add_left_comm]
  · have hmask : ((1 <<< p.n) - 1).testBit i = false := by
      rw [Nat.one_shiftLeft, Nat.testBit_two_pow_sub_one]
      simp [hi]
    simp [hmask]

/--
Cycle 12: robinIndicatorBitPosition = 1 + 2*p.n, hence >= 1 + p.n.
-/
theorem robinIndicatorBitPosition_ge (p : OneTermRobinParameters) :
    robinIndicatorBitPosition p ≥ 1 + p.n := by
  unfold robinIndicatorBitPosition defaultRobinRegisterPartition
  simp only
  omega

/--
Cycle 12: The system register value is preserved by indicatorOracleImage.
XORing with a bit at position indPos = 1 + 2n does not affect bits [1, 1+n).
main.tex:1088-1099 --/
theorem indicatorOracleImage_systemVal_preserved (p : OneTermRobinParameters) (j : Nat) :
    ((indicatorOracleImage p j) >>> 1) &&& ((1 <<< p.n) - 1) =
    (j >>> 1) &&& ((1 <<< p.n) - 1) := by
  show (j ^^^ (if (2 : Nat) ≤ (j >>> 1) &&& (1 <<< p.n - 1) ∧
      (j >>> 1) &&& (1 <<< p.n - 1) ≤ gridSize p.n - 3 then 1 else 0) <<<
      robinIndicatorBitPosition p) >>> 1 &&& (1 <<< p.n - 1) =
    j >>> 1 &&& (1 <<< p.n - 1)
  apply xor_shift_preserve_shift_low
  exact robinIndicatorBitPosition_ge p

/--
Cycle 12: The isBulk predicate gives the same result for j and indicatorOracleImage p j,
because isBulk only depends on the system register value, which is preserved.
main.tex:1088-1099 --/
theorem indicatorOracleImage_isBulk_preserved (p : OneTermRobinParameters) (j : Nat) :
    (if (2 : Nat) ≤ ((indicatorOracleImage p j) >>> 1) &&& ((1 <<< p.n) - 1) ∧
        ((indicatorOracleImage p j) >>> 1) &&& ((1 <<< p.n) - 1) ≤ gridSize p.n - 3
     then (1 : Nat) else 0) =
    (if (2 : Nat) ≤ (j >>> 1) &&& ((1 <<< p.n) - 1) ∧
        (j >>> 1) &&& ((1 <<< p.n) - 1) ≤ gridSize p.n - 3
     then (1 : Nat) else 0) := by
  have h := indicatorOracleImage_systemVal_preserved p j
  split <;> split <;> simp_all

/--
Cycle 12: General self-inverse property for indicatorOracleImage.
Applying the indicator oracle image twice returns the original value for all j,
because the indicator bit is XORed twice (and isBulk is preserved).
main.tex:1088-1099 --/
theorem indicatorOracleImage_self_inverse (p : OneTermRobinParameters) (j : Nat) :
    indicatorOracleImage p (indicatorOracleImage p j) = j := by
  simp only [indicatorOracleImage]
  have h_pres := indicatorOracleImage_isBulk_preserved p j
  simp only [indicatorOracleImage] at h_pres
  rw [h_pres]
  rw [Nat.xor_assoc, Nat.xor_self, Nat.xor_zero]

/--
Cycle 12: General injectivity for indicatorOracleImage, derived from self-inverse.
main.tex:1088-1099 --/
theorem indicatorOracleImage_injective (p : OneTermRobinParameters) {j₁ j₂ : Nat}
    (h : indicatorOracleImage p j₁ = indicatorOracleImage p j₂) :
    j₁ = j₂ := by
  have h1 := indicatorOracleImage_self_inverse p j₁
  have h2 := indicatorOracleImage_self_inverse p j₂
  rw [← h1, ← h2, h]

/--
Cycle 12: robinIndicatorBitPosition is strictly below oneTermRobinTotalQubits.
indPos = 1 + 2n < 2n + clog2 n + clog2 fp + 5 = totalQubits, since clog2 ≥ 0 and 5 > 1.
-/
theorem robinIndicatorBitPosition_lt_totalQubits (p : OneTermRobinParameters) :
    robinIndicatorBitPosition p < oneTermRobinTotalQubits p := by
  simp only [robinIndicatorBitPosition, oneTermRobinTotalQubits,
    RobinRegisterPartition.totalQubits, defaultRobinRegisterPartition]
  omega

/--
Cycle 12: indicatorOracleImage preserves the qubitDim bound.
When j < 2^totalQubits, the image is also < 2^totalQubits, because the XOR
operand is either 0 or a single bit at position indPos < totalQubits.
-/
theorem indicatorOracleImage_lt (p : OneTermRobinParameters) {j : Nat}
    (hj : j < qubitDim (oneTermRobinTotalQubits p)) :
    indicatorOracleImage p j < qubitDim (oneTermRobinTotalQubits p) := by
  simp only [qubitDim, gridSize] at *
  show j ^^^ (if (2 : Nat) ≤ (j >>> 1) &&& (1 <<< p.n - 1) ∧
      (j >>> 1) &&& (1 <<< p.n - 1) ≤ gridSize p.n - 3 then 1 else 0) <<<
      robinIndicatorBitPosition p < 2 ^ oneTermRobinTotalQubits p
  split
  · apply Nat.xor_lt_two_pow hj
    rw [Nat.one_shiftLeft]
    exact Nat.pow_lt_pow_of_lt (by omega) (robinIndicatorBitPosition_lt_totalQubits p)
  · simp only [Nat.zero_shiftLeft, Nat.xor_zero]; exact hj

/--
Cycle 12: Bijectivity of indicatorOracleImage on the Fin domain.
A self-inverse function on a finite type is bijective:
injective by cancellation, surjective because image(image(j)) = j.
main.tex:1088-1099 --/
theorem indicatorOracleImage_bijective (p : OneTermRobinParameters) :
    (∀ (a b : Fin (qubitDim (oneTermRobinTotalQubits p))),
        (⟨indicatorOracleImage p a.val, indicatorOracleImage_lt p a.2⟩ :
          Fin (qubitDim (oneTermRobinTotalQubits p))) =
        ⟨indicatorOracleImage p b.val, indicatorOracleImage_lt p b.2⟩ →
        a = b) ∧
    ∀ (y : Fin (qubitDim (oneTermRobinTotalQubits p))),
      ∃ (x : Fin (qubitDim (oneTermRobinTotalQubits p))),
        (⟨indicatorOracleImage p x.val, indicatorOracleImage_lt p x.2⟩ :
          Fin (qubitDim (oneTermRobinTotalQubits p))) = y := by
  constructor
  · intro a b h
    apply Fin.ext
    exact indicatorOracleImage_injective p (Fin.ext_iff.mp h)
  · intro y
    refine ⟨⟨indicatorOracleImage p y.val, indicatorOracleImage_lt p y.2⟩, ?_⟩
    apply Fin.ext
    exact indicatorOracleImage_self_inverse p y.val

/--
Cycle 12: For each column j, there is exactly one row i with M[i][j] = 1,
namely i = ⟨indicatorOracleImage p j.val, ...⟩.
main.tex:1088-1099 --/
theorem indicatorOracleMatrix_col_has_one (p : OneTermRobinParameters)
    (j : Fin (qubitDim (oneTermRobinTotalQubits p))) :
    indicatorOracleMatrix p
      (⟨indicatorOracleImage p j.val, indicatorOracleImage_lt p j.2⟩ :
        Fin (qubitDim (oneTermRobinTotalQubits p))) j = Coeff.rat 1 := by
  rw [indicatorOracleMatrix_eq_image]
  simp

/--
Cycle 12: For each column j, any row i with M[i][j] = 1 must equal
⟨indicatorOracleImage p j.val, ...⟩, so the 1-entry is unique per column.
main.tex:1088-1099 --/
theorem indicatorOracleMatrix_col_unique (p : OneTermRobinParameters)
    (i j : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (h : indicatorOracleMatrix p i j = Coeff.rat 1) :
    i = ⟨indicatorOracleImage p j.val, indicatorOracleImage_lt p j.2⟩ := by
  rw [indicatorOracleMatrix_eq_image] at h
  split at h
  · next h_cond => exact Fin.ext h_cond
  · next h_cond => simp at h

/--
Cycle 12: For each row i, there exists a column j with M[i][j] = 1,
from surjectivity of indicatorOracleImage.
main.tex:1088-1099 --/
theorem indicatorOracleMatrix_row_has_one (p : OneTermRobinParameters)
    (i : Fin (qubitDim (oneTermRobinTotalQubits p))) :
    ∃ (j : Fin (qubitDim (oneTermRobinTotalQubits p))),
      indicatorOracleMatrix p i j = Coeff.rat 1 := by
  have h_surj := (indicatorOracleImage_bijective p).2 i
  have ⟨⟨xval, xprop⟩, hx⟩ := h_surj
  refine ⟨⟨xval, xprop⟩, ?_⟩
  rw [indicatorOracleMatrix_eq_image]
  have h_eq : i.val = indicatorOracleImage p xval := by
    have := Fin.ext_iff.mp hx
    simp at this
    exact this.symm
  simp [h_eq]

/--
Cycle 12: For each row i, the column j with M[i][j] = 1 is unique,
from injectivity of indicatorOracleImage.
main.tex:1088-1099 --/
theorem indicatorOracleMatrix_row_unique (p : OneTermRobinParameters)
    (i : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (j₁ j₂ : Fin (qubitDim (oneTermRobinTotalQubits p)))
    (h₁ : indicatorOracleMatrix p i j₁ = Coeff.rat 1)
    (h₂ : indicatorOracleMatrix p i j₂ = Coeff.rat 1) :
    j₁ = j₂ := by
  have key₁ := indicatorOracleMatrix_col_unique p i j₁ h₁
  have key₂ := indicatorOracleMatrix_col_unique p i j₂ h₂
  have h_inj := (indicatorOracleImage_bijective p).1
  exact h_inj j₁ j₂ (key₁.symm.trans key₂)

/--
Cycle 12: indicatorOracleMatrix is a permutation matrix: each row has exactly
one entry equal to 1, and each column has exactly one entry equal to 1.
This follows from indicatorOracleImage being a bijection on the Fin domain.
main.tex:1088-1099 --/
theorem indicatorOracleMatrix_is_permutation (p : OneTermRobinParameters) :
    (∀ (i : Fin (qubitDim (oneTermRobinTotalQubits p))),
      ∃ (j : Fin (qubitDim (oneTermRobinTotalQubits p))),
        indicatorOracleMatrix p i j = Coeff.rat 1 ∧
        ∀ (j' : Fin (qubitDim (oneTermRobinTotalQubits p))),
          indicatorOracleMatrix p i j' = Coeff.rat 1 → j' = j) ∧
    (∀ (j : Fin (qubitDim (oneTermRobinTotalQubits p))),
      ∃ (i : Fin (qubitDim (oneTermRobinTotalQubits p))),
        indicatorOracleMatrix p i j = Coeff.rat 1 ∧
        ∀ (i' : Fin (qubitDim (oneTermRobinTotalQubits p))),
          indicatorOracleMatrix p i' j = Coeff.rat 1 → i' = i) := by
  constructor
  · intro i
    have ⟨j, hj⟩ := indicatorOracleMatrix_row_has_one p i
    exact ⟨j, hj, fun j' hj' => (indicatorOracleMatrix_row_unique p i j j' hj hj').symm⟩
  · intro j
    let row := (⟨indicatorOracleImage p j.val, indicatorOracleImage_lt p j.2⟩ :
                  Fin (qubitDim (oneTermRobinTotalQubits p)))
    exact ⟨row, indicatorOracleMatrix_col_has_one p j,
           fun i' hi' => indicatorOracleMatrix_col_unique p i' j hi'⟩

end GHL2025
end QuantumBlockEncoding
