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
Theorem 1-term Robin resource shape:
`O(sum_g Q_g n log n + kappa n)` gates and `2n` pure ancillas.
-/
def oneTermRobinResourceExpr : AsymptoticResource where
  gates :=
    (CostExpr.atom "sum_g(Q_g)") * (CostExpr.atom "n") * (CostExpr.log (CostExpr.atom "n")) +
    (CostExpr.atom "kappa") * (CostExpr.atom "n")
  pureAncilla := (2 : CostExpr) * CostExpr.atom "n"

/-- Numeric placeholder useful for concrete search runs with fixed parameters. -/
def oneTermRobinResource (p : OneTermRobinParameters) : Resource :=
  Resource.ofCounts
    (p.polynomialDegreeCost * p.n * clog2 p.n + p.kappa * p.n)
    0
    (2 * p.n)

theorem oneTermRobin_pureAncilla (p : OneTermRobinParameters) :
    (oneTermRobinResource p).pureAncilla = 2 * p.n := rfl

/--
Register layout for the one-term Robin block encoding.
System qubits address `n` grid points; signal qubits encode the function-oracle
piece selector and Robin-condition indicator; pure ancillas are workspace.
-/
def oneTermRobinLayout (p : OneTermRobinParameters) : RegisterLayout where
  systemQubits := clog2 (gridSize p.n)
  signalQubits := clog2 p.functionPieces + clog2 p.kappa + 4
  pureAncillas := 2 * p.n

/--
Placeholder circuit for the one-term Robin block encoding.
The real circuit will be synthesized by future search; this records the oracle
subroutines that must appear.
-/
def oneTermRobinCircuit : Circuit :=
  [ Gate.oracleCall "O_D"
  , Gate.oracleCall "O_f"
  , Gate.oracleCall "compose"
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

/-- The spec's circuit resource is the oracle-call placeholder (zero local cost). -/
theorem oneTermRobinSpec_circuitCost :
    Circuit.resource oneTermRobinCircuit = 0 := rfl

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
  layout := "ceil(log2 n) + ceil(log2 G_f) + ceil(log2 kappa) + 4 signal qubits"
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

/-- Contract for the derivative oracle O_D: sparse-access oracle for the banded
stencil matrix. Records stencil metadata, bandwidth, and a correctness Prop. -/
structure DerivativeOracleContract (n : Nat) where
  stencil : Stencil
  bandwidth : Nat
  matrix : Matrix (gridSize n) (gridSize n) Coeff
  sparseCorrect : Prop
  bandwidth_eq : bandwidth = stencil.width

/-- Contract for the function oracle O_f: amplitude oracle encoding f(x) on the
grid. Records the piece count, normalization bound, and a correctness Prop. -/
structure FunctionOracleContract (n : Nat) where
  functionPieces : Nat
  normalizerBound : Coeff
  amplitudeCorrect : Prop

/-- Resource for the derivative oracle O_D using the banded sparse-access formula
from Lemma 1 of Guseynov-Huang-Liu 2025. The half-bandwidth parameter is
`stencil.leftRadius` (assumes a symmetric stencil where leftRadius = rightRadius). -/
def derivativeOracleResource (n : Nat) (s : Stencil) : Resource :=
  bandedSparseAccessResource n s.leftRadius

/-- The derivative oracle's pure ancilla count is n - 1 (from Lemma 1). -/
@[simp] theorem derivativeOracleResource_pureAncilla (n : Nat) (s : Stencil) :
    (derivativeOracleResource n s).pureAncilla = n - 1 := rfl

def importedClaims : List ConstructionClaim :=
  [oneTermRobinClaim, oneDimHamiltonianClaim, multiDimHamiltonianClaim]

end GHL2025
end QuantumBlockEncoding
