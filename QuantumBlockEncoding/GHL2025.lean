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

def importedClaims : List ConstructionClaim :=
  [oneTermRobinClaim, oneDimHamiltonianClaim, multiDimHamiltonianClaim]

end GHL2025
end QuantumBlockEncoding
