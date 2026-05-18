import QuantumBlockEncoding.BlockEncoding

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
it has been formally proved. None are proved in the current version. main.tex:1131-1136 --/
structure RobinProofObligations where
  /-- U_indic is unitary. main.tex:1088-1099 --/
  indicatorUnitary : ObligationRecord := {
    description := "U_indic(K1,K2) implements the bulk/boundary indicator correctly"
    source := "main.tex:1088-1099"
    proved := false
  }
  /-- Sparse-amplitude oracle O_D^S is unitary and encodes D^(s)/N_D. main.tex:822-849 --/
  sparseAmplitudeOracleCorrect : ObligationRecord := {
    description := "O_D^S prepares amplitudes D^(s)/N_D for boundary rows"
    source := "main.tex:822-849"
    proved := false
  }
  /-- Banded-sparse-access oracle O_D^BS is unitary and maps sparse to normal indexing. main.tex:784-801 --/
  bandedSparseAccessCorrect : ObligationRecord := {
    description := "O_D^BS maps (r_si, i) to sparse index register correctly"
    source := "main.tex:784-801"
    proved := false
  }
  /-- Function oracle O_f is unitary and block-encodes f(x_j)/N_f. main.tex:870-910 --/
  functionOracleCorrect : ObligationRecord := {
    description := "O_f block-encodes the piecewise polynomial f(x) discretized on the grid"
    source := "main.tex:870-910"
    proved := false
  }
  /-- Controlled R_y angles encode boundary D_j^(s)/N_D correctly. main.tex:1115-1120 --/
  controlledRyCorrect : ObligationRecord := {
    description := "R_y rotation angles theta_j^s = arccos(D_j^(s)/N_D) are correct"
    source := "main.tex:1115-1120"
    proved := false
  }
  /-- Full circuit U_Ak^(1) is unitary. Theorem:1 term robin (main.tex:1131-1136) --/
  circuitUnitary : ObligationRecord := {
    description := "The full one-term Robin circuit U_Ak^(1) is unitary"
    source := "main.tex:1131-1136, theorem:1 term robin"
    proved := false
  }
  /-- Block extraction: (⟨0|⊗I) U (|0⟩⊗I) = A_k / (N_D * N_f * kappa). main.tex:1131-1136 --/
  blockExtraction : ObligationRecord := {
    description := "Block extraction yields A_k / alpha where alpha = N_D * N_f * kappa"
    source := "main.tex:1131-1136, theorem:1 term robin"
    proved := false
  }
  /-- Resource bound: O(sum Q_g n log n + kappa n) gates, 2n pure ancillas. main.tex:1131-1136 --/
  resourceBound : ObligationRecord := {
    description := "Gate count O(sum_g Q_g n log n + kappa n), pure ancillas 2n"
    source := "main.tex:1131-1136"
    proved := false
  }
  /-- Pure ancilla cleanup: 2n ancillas returned to |0⟩. figure:1_term_ROBIN caption --/
  ancillaCleanup : ObligationRecord := {
    description := "All 2n pure ancilla qubits are returned to |0⟩ state"
    source := "figure:1_term_ROBIN caption, main.tex:1149"
    proved := false
  }
  /-- Ghost-point elimination yields correct Robin boundary row coefficients. main.tex:989-1010 --/
  ghostPointElimination : ObligationRecord := {
    description := "Ghost-point elimination via Robin boundary relation produces correct boundary rows"
    source := "main.tex:989-1010"
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

end GHL2025
end QuantumBlockEncoding
