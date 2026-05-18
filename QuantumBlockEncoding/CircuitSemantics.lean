import QuantumBlockEncoding.BlockEncoding

/-!
# Circuit matrix semantics

This file is the first concrete bridge from the certificate-oriented circuit IR
to finite matrices.  It deliberately starts with externally supplied gate
matrices: oracle calls, rotations, and multi-control decompositions still need
separate certificates, but a circuit-level product now has a Lean object and a
checkable gate-to-matrix alignment condition.
-/

namespace QuantumBlockEncoding

/-- A finite-dimensional basis size for an `n`-qubit register. -/
def qubitDim (qubits : Nat) : Nat :=
  gridSize qubits

/--
Structured semantic obligation for the matrix layer.

This mirrors `GHL2025.ObligationRecord` without importing `GHL2025`, so the
semantics backend can stay below paper-specific files in the import graph.
-/
structure SemanticObligation where
  description : String
  source : String
  proved : Bool := false
deriving Repr, DecidableEq

/--
One gate together with its matrix on the full `qubits`-qubit Hilbert space.
The matrix is supplied by a lower-level certificate for the gate family.
-/
structure GateMatrix (α : Type u) (qubits : Nat) where
  gate : Gate
  matrix : Matrix (qubitDim qubits) (qubitDim qubits) α
  unitary : SemanticObligation

/-- Check that a list of gate matrices labels exactly the same circuit gates. -/
def gateMatricesMatchCircuit {α : Type u} {qubits : Nat} :
    Circuit → List (GateMatrix α qubits) → Bool
  | [], [] => true
  | gate :: circuitTail, gateMatrix :: matrixTail =>
      gateMatrix.gate == gate && gateMatricesMatchCircuit circuitTail matrixTail
  | _, _ => false

/--
Evaluate a list of full-space gate matrices to a circuit matrix.

The fold uses the usual right-action convention for a circuit list
`[g₁, g₂, ...]`: the resulting matrix is `g_k * ... * g₂ * g₁`.
-/
def evalGateMatrices {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α] {qubits : Nat}
    (gates : List (GateMatrix α qubits)) :
    Matrix (qubitDim qubits) (qubitDim qubits) α :=
  gates.foldl (fun acc gateMatrix => Matrix.mul gateMatrix.matrix acc)
    (Matrix.identity (qubitDim qubits) α)

/--
Circuit-level matrix semantics assembled from gate-level matrices.

This does not certify that individual oracle matrices are correct; it gives the
project a stable Lean target for composing those certificates once they exist.
-/
structure CircuitMatrixSemantics (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α] (qubits : Nat) where
  circuit : Circuit
  gateMatrices : List (GateMatrix α qubits)
  gateListMatches : gateMatricesMatchCircuit circuit gateMatrices = true
  matrix : Matrix (qubitDim qubits) (qubitDim qubits) α
  matrix_eq_eval : Matrix.PointwiseEq matrix (evalGateMatrices gateMatrices)

namespace CircuitMatrixSemantics

/-- Build circuit semantics directly from aligned gate matrices. -/
def ofGateMatrices {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α] {qubits : Nat}
    (circuit : Circuit) (gateMatrices : List (GateMatrix α qubits))
    (h : gateMatricesMatchCircuit circuit gateMatrices = true) :
    CircuitMatrixSemantics α qubits where
  circuit := circuit
  gateMatrices := gateMatrices
  gateListMatches := h
  matrix := evalGateMatrices gateMatrices
  matrix_eq_eval := by intro _ _; rfl

end CircuitMatrixSemantics

/--
A paper-level block-extraction target against a concrete circuit matrix.

The current project can now state the missing equation in matrix terms.  The
actual block projection from signal/system registers remains a later proof
obligation, tracked explicitly by `blockProjection` and `blockCorrect`.
-/
structure BlockExtractionTarget (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    (rows cols signalDim : Nat) where
  unitaryMatrix : Matrix (signalDim * rows) (signalDim * cols) α
  targetMatrix : Matrix rows cols α
  normalizer : α
  signalIndex : Fin signalDim
  blockMatrix : Matrix rows cols α
  blockProjection : SemanticObligation
  blockCorrect : SemanticObligation

end QuantumBlockEncoding
