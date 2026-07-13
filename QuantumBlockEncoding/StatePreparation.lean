import QuantumBlockEncoding.BlockEncoding

/-!
# State-preparation certificates

State preparation is the first ABEIS application surface.  A target is a
normalized amplitude vector, and a candidate is a unitary whose first
computational-basis column equals that vector.  The analytic backend supplies
the concrete normalization, unitarity, and approximation predicates.
-/

namespace QuantumBlockEncoding

/-- The computational all-zero basis index in an `n`-qubit register. -/
def zeroBasisIndex (n : Nat) : Fin (gridSize n) :=
  ⟨0, Nat.pow_pos (by decide)⟩

/-- A normalized state requested by the user. -/
structure StatePreparationTarget (α : Type u) (qubits : Nat) where
  amplitudes : Fin (gridSize qubits) → α
  normalization : Prop
  source : String := ""

/-- The matrix-level first-column acceptance predicate. -/
def FirstColumnMatches {α : Type u} {qubits : Nat}
    (unitary : Matrix (gridSize qubits) (gridSize qubits) α)
    (target : StatePreparationTarget α qubits) : Prop :=
  ∀ row, unitary row (zeroBasisIndex qubits) = target.amplitudes row

/-- A state-preparation candidate before semantic proofs are attached. -/
structure StatePreparationCandidate (α : Type u) (qubits : Nat) where
  target : StatePreparationTarget α qubits
  unitary : Matrix (gridSize qubits) (gridSize qubits) α
  circuit : Circuit
  schedule : LayeredCircuit := []
  resource : Resource
  auxiliaryQubits : Nat := 0
  isUnitary : Prop

namespace StatePreparationCandidate

/-- The candidate's fixed semantic target; callers cannot replace it by a flag. -/
def preparesTarget (candidate : StatePreparationCandidate α qubits) : Prop :=
  FirstColumnMatches candidate.unitary candidate.target

/-- Reuse the block-encoding resource order for state-preparation candidates. -/
def cost (candidate : StatePreparationCandidate α qubits) : BlockEncodingCost :=
  {
    auxiliaryQubits := candidate.auxiliaryQubits
    gateCount := candidate.resource.gates
    depth := candidate.resource.depth
    oracleCalls := candidate.resource.oracleCalls
  }

end StatePreparationCandidate

/-- A candidate promoted by proofs of normalization, unitarity, and state action. -/
structure VerifiedStatePreparation (α : Type u) (qubits : Nat) where
  candidate : StatePreparationCandidate α qubits
  normalizationProof : candidate.target.normalization
  unitaryProof : candidate.isUnitary
  preparationProof : candidate.preparesTarget

/-- An approximate candidate with a backend-specific state-error predicate. -/
structure ApproximateStatePreparationCandidate
    (α : Type u) (qubits : Nat) where
  candidate : StatePreparationCandidate α qubits
  epsilon : α
  approximationBound : Prop

/-- A verified approximate state-preparation certificate. -/
structure VerifiedApproximateStatePreparation
    (α : Type u) (qubits : Nat) where
  approxCandidate : ApproximateStatePreparationCandidate α qubits
  normalizationProof : approxCandidate.candidate.target.normalization
  unitaryProof : approxCandidate.candidate.isUnitary
  approximationProof : approxCandidate.approximationBound

namespace VerifiedStatePreparation

/--
Package an exact state-preparation certificate as a zero-error approximate
certificate when the backend uses the exact first-column predicate as its
zero-error proposition.
-/
def asZeroErrorApprox [OfNat α 0]
    (verified : VerifiedStatePreparation α qubits) :
    VerifiedApproximateStatePreparation α qubits where
  approxCandidate := {
    candidate := verified.candidate
    epsilon := 0
    approximationBound := verified.candidate.preparesTarget
  }
  normalizationProof := verified.normalizationProof
  unitaryProof := verified.unitaryProof
  approximationProof := verified.preparationProof

theorem firstColumn
    (verified : VerifiedStatePreparation α qubits) :
    verified.candidate.preparesTarget :=
  verified.preparationProof

end VerifiedStatePreparation

end QuantumBlockEncoding
