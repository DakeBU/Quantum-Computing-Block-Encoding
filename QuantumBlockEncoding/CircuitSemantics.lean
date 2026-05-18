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

/--
A circuit-level block encoding claim bundling a circuit matrix semantics
with a block extraction target and a dimension compatibility proof.

The `blockCorrect` obligation tracks the main mathematical claim:
(⟨signalIdx| ⊗ I) U (|signalIdx⟩ ⊗ I) = targetMatrix / normalizer.
This does not assert the claim is true; it records what needs proving.
-/
structure CircuitBlockEncodingClaim (α : Type u) [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    (qubits : Nat) (dim signalDim : Nat) where
  semantics : CircuitMatrixSemantics α qubits
  target : BlockExtractionTarget α dim dim signalDim
  dimCompat : qubitDim qubits = signalDim * dim
  blockCorrect : SemanticObligation

/--
Block projection: extract the `(signalIdx, signalIdx)` block from a
signal × system matrix.

Given a matrix M of size `(signalDim * rows) × (signalDim * cols)`,
`signalSystemBlockIndex signalDim dim idx` maps a pair `(i, j)` of
system indices to the compound index in the full matrix that corresponds
to signal register value `idx` and system indices `(i, j)`.

The block `(⟨signalIdx| ⊗ I) M (|signalIdx⟩ ⊗ I)` is then:
  blockMatrix i j = M (signalIdx * rows + i) (signalIdx * cols + j)
-/
def signalSystemBlockProjection {α : Type u} [OfNat α 0]
    (signalDim rows cols : Nat)
    (M : Matrix (signalDim * rows) (signalDim * cols) α)
    (signalIdx : Fin signalDim) :
    Matrix rows cols α :=
  fun i j =>
    have hRows : signalIdx.val * rows + i.val < signalDim * rows := by
      have h1 := i.isLt
      have h2 := signalIdx.isLt
      exact Nat.lt_of_succ_le (by
        show signalIdx.val * rows + i.val + 1 ≤ signalDim * rows
        calc signalIdx.val * rows + i.val + 1
            ≤ signalIdx.val * rows + rows := by omega
          _ = (signalIdx.val + 1) * rows := by
              exact Nat.succ_mul signalIdx.val rows |>.symm
          _ ≤ signalDim * rows := by
              exact Nat.mul_le_mul_right rows (Nat.succ_le_of_lt h2))
    have hCols : signalIdx.val * cols + j.val < signalDim * cols := by
      have h1 := j.isLt
      have h2 := signalIdx.isLt
      exact Nat.lt_of_succ_le (by
        show signalIdx.val * cols + j.val + 1 ≤ signalDim * cols
        calc signalIdx.val * cols + j.val + 1
            ≤ signalIdx.val * cols + cols := by omega
          _ = (signalIdx.val + 1) * cols := by
              exact Nat.succ_mul signalIdx.val cols |>.symm
          _ ≤ signalDim * cols := by
              exact Nat.mul_le_mul_right cols (Nat.succ_le_of_lt h2))
    M ⟨signalIdx.val * rows + i.val, hRows⟩
      ⟨signalIdx.val * cols + j.val, hCols⟩

/--
Total qubits needed for a circuit operating on `system` system qubits
and `signal` signal qubits.
-/
def totalCircuitQubits (system signal : Nat) : Nat :=
  system + signal

/--
Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing
the block projection. The circuit matrix is square with dimension
`signalDim * dim`, and we extract the `(signalIdx, signalIdx)` block.
-/
def CircuitMatrixSemantics.blockExtractionTarget
    {α : Type u} [OfNat α 0] [OfNat α 1]
    [HAdd α α α] [HMul α α α]
    {qubits : Nat}
    (sem : CircuitMatrixSemantics α qubits)
    (dim signalDim : Nat)
    (hDim : qubitDim qubits = signalDim * dim)
    (targetMatrix : Matrix dim dim α)
    (normalizer : α)
    (signalIdx : Fin signalDim) :
    BlockExtractionTarget α dim dim signalDim where
  unitaryMatrix := cast (by rw [hDim]) sem.matrix
  targetMatrix := targetMatrix
  normalizer := normalizer
  signalIndex := signalIdx
  blockMatrix := signalSystemBlockProjection signalDim dim dim
    (cast (by rw [hDim]) sem.matrix) signalIdx
  blockProjection := {
    description := "block projection extracts the correct signal×system submatrix"
    source := "CircuitSemantics.lean"
    proved := false
  }
  blockCorrect := {
    description := "extracted block equals targetMatrix / normalizer"
    source := "CircuitSemantics.lean"
    proved := false
  }

end QuantumBlockEncoding
