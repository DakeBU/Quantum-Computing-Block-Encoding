import QuantumBlockEncoding.Circuit

/-!
# Block-encoding certificates

The paper's main issue is that an "oracle exists" statement is not enough for a
real quantum computer.  This file records the data that must ultimately be
certified: a matrix target, a circuit, normalization, ancilla layout, and proof
obligations for unitarity and block correctness.
-/

namespace QuantumBlockEncoding

structure RegisterLayout where
  systemQubits : Nat
  signalQubits : Nat
  pureAncillas : Nat
deriving Repr, DecidableEq

namespace RegisterLayout

/--
The auxiliary qubit count used by the block-encoding score.  This combines the
signal qubits selecting the block with pure ancillas that must be returned to a
clean state.
-/
def auxiliaryQubits (layout : RegisterLayout) : Nat :=
  layout.signalQubits + layout.pureAncillas

end RegisterLayout

/-- A block-encoding candidate before semantic proofs are attached. -/
structure BlockEncodingSpec (α : Type u) (rows cols : Nat) where
  matrix : Matrix rows cols α
  normalizer : α
  error : α
  layout : RegisterLayout
  circuit : Circuit
  resource : Resource

/--
Resource score for comparing two candidate block encodings of the same
operator.  The search order is deliberately domain-specific:

1. smaller circuit depth,
2. fewer gates,
3. fewer auxiliary qubits,
4. fewer unresolved oracle calls.
-/
structure BlockEncodingCost where
  auxiliaryQubits : Nat
  gateCount : Nat
  depth : Nat
  oracleCalls : Nat
deriving Repr, DecidableEq

namespace BlockEncodingCost

def fromLayoutAndResource (layout : RegisterLayout) (resource : Resource) :
    BlockEncodingCost where
  auxiliaryQubits := layout.auxiliaryQubits
  gateCount := resource.gates
  depth := resource.depth
  oracleCalls := resource.oracleCalls

def fromSpec (spec : BlockEncodingSpec α rows cols) : BlockEncodingCost :=
  fromLayoutAndResource spec.layout spec.resource

/-- Strict lexicographic improvement used by candidate-population selection. -/
def betterThan (x y : BlockEncodingCost) : Prop :=
  x.depth < y.depth ∨
  (x.depth = y.depth ∧
    (x.gateCount < y.gateCount ∨
      (x.gateCount = y.gateCount ∧
        (x.auxiliaryQubits < y.auxiliaryQubits ∨
          (x.auxiliaryQubits = y.auxiliaryQubits ∧
            x.oracleCalls < y.oracleCalls)))))

/-- Non-strict version for accepting a candidate as no worse than a baseline. -/
def noWorseThan (x y : BlockEncodingCost) : Prop :=
  x = y ∨ x.betterThan y

end BlockEncodingCost

/--
The concrete input ABEIS is meant to solve: a user gives an operator/query
oracle target, usually as a finite matrix together with a normalization
contract and optional free parameters.
-/
structure QueryOperatorTarget (α : Type u) (rows cols : Nat) where
  operator : Matrix rows cols α
  normalizer : α
  source : String
  semanticContract : String
  freeParameters : List String := []

/--
A candidate unitary for an `n`-qubit square operator.  The size of the unitary
is fixed by the chosen number of auxiliary qubits: if the target acts on
`N = 2^n` dimensions and the candidate uses `a` auxiliary qubits, then the
unitary acts on `2^(n+a)` dimensions.
-/
structure OperatorBlockEncodingCandidate (α : Type u) (systemQubits : Nat) where
  auxiliaryQubits : Nat
  target : QueryOperatorTarget α (gridSize systemQubits) (gridSize systemQubits)
  unitary :
    Matrix (gridSize (systemQubits + auxiliaryQubits))
      (gridSize (systemQubits + auxiliaryQubits)) α
  layout : RegisterLayout
  circuit : Circuit
  schedule : LayeredCircuit := []
  resource : Resource
  layoutMatches : layout.auxiliaryQubits = auxiliaryQubits
  isUnitary : Prop
  blockContainsTarget : Prop

namespace OperatorBlockEncodingCandidate

def cost (candidate : OperatorBlockEncodingCandidate α systemQubits) :
    BlockEncodingCost :=
  {
    auxiliaryQubits := candidate.auxiliaryQubits
    gateCount := candidate.resource.gates
    depth := candidate.resource.depth
    oracleCalls := candidate.resource.oracleCalls
  }

end OperatorBlockEncodingCandidate

/-- A verified candidate with explicit proofs of unitarity and block containment. -/
structure VerifiedOperatorBlockEncoding (α : Type u) (systemQubits : Nat) where
  candidate : OperatorBlockEncodingCandidate α systemQubits
  unitaryProof : candidate.isUnitary
  blockProof : candidate.blockContainsTarget

/--
A verified block encoding.  The three proposition fields are intentionally
parameters of the certificate so that early project files can state workflows
without committing to a specific matrix norm or unitary semantics.  A mathlib
backend should instantiate these propositions with concrete definitions.
-/
structure VerifiedBlockEncoding (α : Type u) (rows cols : Nat) where
  spec : BlockEncodingSpec α rows cols
  isUnitary : Prop
  blockCorrect : Prop
  resourceBound : Prop
  unitaryProof : isUnitary
  blockProof : blockCorrect
  resourceProof : resourceBound

namespace VerifiedBlockEncoding

theorem unitary {α : Type u} {rows cols : Nat}
    (v : VerifiedBlockEncoding α rows cols) : v.isUnitary :=
  v.unitaryProof

theorem correct {α : Type u} {rows cols : Nat}
    (v : VerifiedBlockEncoding α rows cols) : v.blockCorrect :=
  v.blockProof

theorem resource_ok {α : Type u} {rows cols : Nat}
    (v : VerifiedBlockEncoding α rows cols) : v.resourceBound :=
  v.resourceProof

end VerifiedBlockEncoding

/-- A high-level construction claim imported from a paper or generated by AI. -/
structure ConstructionClaim where
  name : String
  source : String
  target : String
  normalization : String
  layout : String
  resource : AsymptoticResource
deriving Repr, DecidableEq

end QuantumBlockEncoding
