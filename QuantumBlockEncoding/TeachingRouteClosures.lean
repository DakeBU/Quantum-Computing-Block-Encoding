import QuantumBlockEncoding.ConcreteSemantics
import QuantumBlockEncoding.PrimitiveRefinement
import QuantumBlockEncoding.TextbookStatePreparation
import QuantumBlockEncoding.BlockEncodingClassics

/-!
# Proof-carrying closures for the teaching routes

These constructors close the reusable routes presented by QuantumComputinglib.
They do not synthesize proofs for arbitrary inputs: promotion requires the
normalization, unitarity, block, or first-column proof named by the contract.
Hardware-specific routing and general QSVT phase synthesis remain downstream.
-/

namespace QuantumBlockEncoding

/-- Backend-neutral cost evidence computed from the canonical primitive IR. -/
structure ExecutableResourceCertificate (qubits : Nat) where
  program : PrimitiveProgram qubits
  auxiliaryQubits : Nat

namespace ExecutableResourceCertificate

def resource (certificate : ExecutableResourceCertificate qubits) : Resource :=
  certificate.program.resource

def cost (certificate : ExecutableResourceCertificate qubits) : BlockEncodingCost where
  auxiliaryQubits := certificate.auxiliaryQubits
  gateCount := certificate.resource.gates
  depth := certificate.resource.depth
  oracleCalls := certificate.resource.oracleCalls

@[simp] theorem resource_eq_program_resource
    (certificate : ExecutableResourceCertificate qubits) :
    certificate.resource = certificate.program.resource := rfl

@[simp] theorem cost_auxiliaryQubits
    (certificate : ExecutableResourceCertificate qubits) :
    certificate.cost.auxiliaryQubits = certificate.auxiliaryQubits := rfl

@[simp] theorem cost_gateCount
    (certificate : ExecutableResourceCertificate qubits) :
    certificate.cost.gateCount = certificate.program.resource.gates := rfl

@[simp] theorem cost_depth
    (certificate : ExecutableResourceCertificate qubits) :
    certificate.cost.depth = certificate.program.resource.depth := rfl

@[simp] theorem cost_oracleCalls
    (certificate : ExecutableResourceCertificate qubits) :
    certificate.cost.oracleCalls = certificate.program.resource.oracleCalls := rfl

end ExecutableResourceCertificate

namespace StatePreparationCandidate

/-- Promote a candidate only after all three state-preparation obligations are supplied. -/
def certify (candidate : StatePreparationCandidate α qubits)
    (normalizationProof : candidate.target.normalization)
    (unitaryProof : candidate.isUnitary)
    (preparationProof : candidate.preparesTarget) :
    VerifiedStatePreparation α qubits where
  candidate := candidate
  normalizationProof := normalizationProof
  unitaryProof := unitaryProof
  preparationProof := preparationProof

theorem certify_firstColumn (candidate : StatePreparationCandidate α qubits)
    (normalizationProof : candidate.target.normalization)
    (unitaryProof : candidate.isUnitary)
    (preparationProof : candidate.preparesTarget) :
    (candidate.certify normalizationProof unitaryProof preparationProof).candidate.preparesTarget :=
  preparationProof

theorem certify_unitary (candidate : StatePreparationCandidate α qubits)
    (normalizationProof : candidate.target.normalization)
    (unitaryProof : candidate.isUnitary)
    (preparationProof : candidate.preparesTarget) :
    (candidate.certify normalizationProof unitaryProof preparationProof).candidate.isUnitary :=
  unitaryProof

theorem certify_normalization (candidate : StatePreparationCandidate α qubits)
    (normalizationProof : candidate.target.normalization)
    (unitaryProof : candidate.isUnitary)
    (preparationProof : candidate.preparesTarget) :
    (candidate.certify normalizationProof unitaryProof preparationProof).candidate.target.normalization :=
  normalizationProof

end StatePreparationCandidate

namespace ConcreteSemantics.ComplexStatePreparationCertificate

/-- Build concrete state-preparation evidence from the equivalent first-column statement. -/
def ofFirstColumn (target : StatePreparationTarget ℂ qubits)
    (gate : ComplexUnitaryGate qubits)
    (normalizationProof : target.normalization)
    (firstColumnProof : FirstColumnMatches gate.matrix target) :
    ComplexStatePreparationCertificate qubits where
  target := target
  gate := gate
  normalizationProof := normalizationProof
  preparationProof :=
    (ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet gate.matrix target).mp
      firstColumnProof

/-- Promote first-column evidence through the concrete finite-matrix backend. -/
def verifiedOfFirstColumn (target : StatePreparationTarget ℂ qubits)
    (gate : ComplexUnitaryGate qubits)
    (normalizationProof : target.normalization)
    (firstColumnProof : FirstColumnMatches gate.matrix target)
    (circuit : Circuit) (schedule : LayeredCircuit) (resource : Resource)
    (auxiliaryQubits : Nat := 0) : VerifiedStatePreparation ℂ qubits :=
  (ofFirstColumn target gate normalizationProof firstColumnProof).verified
    circuit schedule resource auxiliaryQubits

theorem verifiedOfFirstColumn_preparesTarget
    (target : StatePreparationTarget ℂ qubits)
    (gate : ComplexUnitaryGate qubits)
    (normalizationProof : target.normalization)
    (firstColumnProof : FirstColumnMatches gate.matrix target)
    (circuit : Circuit) (schedule : LayeredCircuit) (resource : Resource)
    (auxiliaryQubits : Nat := 0) :
    (verifiedOfFirstColumn target gate normalizationProof firstColumnProof
      circuit schedule resource auxiliaryQubits).candidate.preparesTarget :=
  (verifiedOfFirstColumn target gate normalizationProof firstColumnProof
    circuit schedule resource auxiliaryQubits).preparationProof

end ConcreteSemantics.ComplexStatePreparationCertificate

/-- Finite witness that the generic first-column route reuses the Pauli-X proof. -/
def textbookPauliXVerifiedOfFirstColumn : VerifiedStatePreparation ℂ 1 :=
  ConcreteSemantics.ComplexStatePreparationCertificate.verifiedOfFirstColumn
    TextbookStatePreparation.oneTarget TextbookStatePreparation.pauliXGate
    TextbookStatePreparation.oneTarget_normalized
    ((ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet
      TextbookStatePreparation.pauliX TextbookStatePreparation.oneTarget).mpr
        TextbookStatePreparation.pauliX_prepares_one)
    TextbookStatePreparation.pauliXCircuit
    [[Gate.oneQubit "X" 0]] TextbookStatePreparation.pauliXCircuit.resource

theorem textbookPauliXVerifiedOfFirstColumn_preparesTarget :
    textbookPauliXVerifiedOfFirstColumn.candidate.preparesTarget :=
  textbookPauliXVerifiedOfFirstColumn.preparationProof

namespace ConcreteSemantics

/-- Convert a signal-register projection proof into an exact clean-block certificate. -/
def exactCleanBlockOfSignalProjection {signalDim systemDim : Nat}
    (operator : Matrix (signalDim * systemDim) (signalDim * systemDim) Rat)
    (signalIndex : Fin signalDim)
    (target : Matrix systemDim systemDim Rat)
    (projectionProof :
      Matrix.PointwiseEq
        (signalSystemBlockProjection
          signalDim systemDim systemDim operator signalIndex)
        target) :
    BlockEncodingClassics.ExactCleanBlock systemDim (signalDim * systemDim) where
  U := operator
  A := target
  embed := BlockEncodingClassics.productIndex signalIndex
  blockProof := by
    intro row column
    exact (signalSystemBlockProjection_eq_cleanBlockProduct
      operator signalIndex row column).symm.trans (projectionProof row column)

theorem exactCleanBlockOfSignalProjection_correct {signalDim systemDim : Nat}
    (operator : Matrix (signalDim * systemDim) (signalDim * systemDim) Rat)
    (signalIndex : Fin signalDim)
    (target : Matrix systemDim systemDim Rat)
    (projectionProof :
      Matrix.PointwiseEq
        (signalSystemBlockProjection
          signalDim systemDim systemDim operator signalIndex)
        target) :
    Matrix.PointwiseEq
      (exactCleanBlockOfSignalProjection operator signalIndex target projectionProof).clean
      target :=
  (exactCleanBlockOfSignalProjection operator signalIndex target projectionProof).blockProof

end ConcreteSemantics

/-- A circuit block extraction whose selected block equality is carried as a proof. -/
structure CertifiedCircuitBlockExtraction (qubits dim signalDim : Nat) where
  semantics : CircuitMatrixSemantics Rat qubits
  dimCompat : qubitDim qubits = signalDim * dim
  targetMatrix : Matrix dim dim Rat
  normalizer : Rat
  normalizer_ne_zero : normalizer ≠ 0
  signalIndex : Fin signalDim
  blockProof :
    ∀ row column,
      signalSystemBlockProjection signalDim dim dim
        (cast (by rw [dimCompat]) semantics.matrix)
        signalIndex row column = targetMatrix row column / normalizer

namespace CertifiedCircuitBlockExtraction

def extractionTarget (certificate : CertifiedCircuitBlockExtraction qubits dim signalDim) :
    BlockExtractionTarget Rat dim dim signalDim where
  unitaryMatrix := cast (by rw [certificate.dimCompat]) certificate.semantics.matrix
  targetMatrix := certificate.targetMatrix
  normalizer := certificate.normalizer
  signalIndex := certificate.signalIndex
  blockMatrix := signalSystemBlockProjection signalDim dim dim
    (cast (by rw [certificate.dimCompat]) certificate.semantics.matrix)
    certificate.signalIndex
  blockProjection := {
    description := "selected signal-system block is computed from certified circuit semantics"
    source := "TeachingRouteClosures.lean"
    proved := true
  }
  blockCorrect := {
    description := "selected block equals targetMatrix / normalizer"
    source := "TeachingRouteClosures.lean"
    proved := true
  }

def normalizedTarget (certificate : CertifiedCircuitBlockExtraction qubits dim signalDim) :
    Matrix dim dim Rat :=
  fun row column => certificate.targetMatrix row column / certificate.normalizer

def exactCleanBlock (certificate : CertifiedCircuitBlockExtraction qubits dim signalDim) :
    BlockEncodingClassics.ExactCleanBlock dim (signalDim * dim) :=
  ConcreteSemantics.exactCleanBlockOfSignalProjection
    (cast (by rw [certificate.dimCompat]) certificate.semantics.matrix)
    certificate.signalIndex certificate.normalizedTarget (by
      intro row column
      exact certificate.blockProof row column)

@[simp] theorem extractionTarget_blockProjection_proved
    (certificate : CertifiedCircuitBlockExtraction qubits dim signalDim) :
    certificate.extractionTarget.blockProjection.proved = true := rfl

@[simp] theorem extractionTarget_blockCorrect_proved
    (certificate : CertifiedCircuitBlockExtraction qubits dim signalDim) :
    certificate.extractionTarget.blockCorrect.proved = true := rfl

theorem exactCleanBlock_correct
    (certificate : CertifiedCircuitBlockExtraction qubits dim signalDim) :
    Matrix.PointwiseEq certificate.exactCleanBlock.clean certificate.normalizedTarget :=
  certificate.exactCleanBlock.blockProof

end CertifiedCircuitBlockExtraction

/-- Empty-circuit semantics on the one-dimensional zero-qubit space. -/
def teachingIdentityCircuitSemantics : CircuitMatrixSemantics Rat 0 :=
  CircuitMatrixSemantics.ofGateMatrices [] [] rfl

/-- Finite witness for certified circuit block extraction. -/
def teachingIdentityBlockExtraction : CertifiedCircuitBlockExtraction 0 1 1 where
  semantics := teachingIdentityCircuitSemantics
  dimCompat := rfl
  targetMatrix := Matrix.identity 1 Rat
  normalizer := 1
  normalizer_ne_zero := by decide
  signalIndex := 0
  blockProof := by
    intro row column
    fin_cases row
    fin_cases column
    native_decide

theorem teachingIdentityBlockExtraction_correct :
    Matrix.PointwiseEq teachingIdentityBlockExtraction.exactCleanBlock.clean
      teachingIdentityBlockExtraction.normalizedTarget :=
  teachingIdentityBlockExtraction.exactCleanBlock_correct

namespace OperatorBlockEncodingCandidate

/-- Promote an operator candidate only after its unitary and block proofs are supplied. -/
def certify (candidate : OperatorBlockEncodingCandidate α systemQubits)
    (unitaryProof : candidate.isUnitary)
    (blockProof : candidate.blockContainsTarget) :
    VerifiedOperatorBlockEncoding α systemQubits where
  candidate := candidate
  unitaryProof := unitaryProof
  blockProof := blockProof

theorem cost_eq_fromLayoutAndResource
    (candidate : OperatorBlockEncodingCandidate α systemQubits) :
    candidate.cost =
      BlockEncodingCost.fromLayoutAndResource candidate.layout candidate.resource := by
  unfold cost BlockEncodingCost.fromLayoutAndResource
  rw [candidate.layoutMatches]

end OperatorBlockEncodingCandidate

namespace BlockEncodingClassics.QSVTConsumerContract

/-- Degree-one identity consumer: a proved clean block is returned unchanged. -/
def identity (input : ExactCleanBlock system total) :
    QSVTConsumerContract system total where
  input := input
  polynomialDescription := "p(x)=x; degree-one identity consumer"
  sideConditions := True
  outputStatement := Matrix.PointwiseEq input.clean input.A
  sideConditionProof := trivial
  outputProof := input.blockProof

theorem identity_sideConditions (input : ExactCleanBlock system total) :
    (identity input).sideConditions :=
  (identity input).sideConditionProof

theorem identity_output (input : ExactCleanBlock system total) :
    (identity input).outputStatement :=
  (identity input).outputProof

end BlockEncodingClassics.QSVTConsumerContract

/-- Finite witness that a certified clean block crosses the typed QSVT boundary. -/
def teachingIdentityQSVTConsumer :
    BlockEncodingClassics.QSVTConsumerContract 1 1 :=
  BlockEncodingClassics.QSVTConsumerContract.identity
    teachingIdentityBlockExtraction.exactCleanBlock

end QuantumBlockEncoding
