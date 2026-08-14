import QuantumBlockEncoding.RouteClosureCertificates

open QuantumBlockEncoding

/-- Zero-qubit finite witness used only to regression-test the generic state route. -/
def routeClosureTestStateTarget : StatePreparationTarget Rat 0 where
  amplitudes := fun _ => 1
  normalization := True
  source := "route-closure regression witness"

/-- Identity candidate for the one-dimensional state space. -/
def routeClosureTestStateCandidate : StatePreparationCandidate Rat 0 where
  target := routeClosureTestStateTarget
  unitary := Matrix.identity (gridSize 0) Rat
  circuit := []
  resource := 0
  isUnitary := True

private theorem routeClosureTestStateCandidate_prepares :
    routeClosureTestStateCandidate.preparesTarget := by
  intro row
  fin_cases row
  rfl

/-- Approximate wrapper whose predicate is the exact first-column statement. -/
def routeClosureTestApproxStateCandidate :
    ApproximateStatePreparationCandidate Rat 0 where
  candidate := routeClosureTestStateCandidate
  epsilon := 0
  approximationBound := routeClosureTestStateCandidate.preparesTarget

/-- The approximate promotion constructor consumes all three required proofs. -/
def routeClosureTestApproxStateVerified :
    VerifiedApproximateStatePreparation Rat 0 :=
  routeClosureTestApproxStateCandidate.certify
    trivial trivial routeClosureTestStateCandidate_prepares

example : routeClosureTestApproxStateVerified.approxCandidate.epsilon = 0 := rfl

example : routeClosureTestApproxStateVerified.approxCandidate.approximationBound :=
  routeClosureTestApproxStateVerified.approximation

/-- One-dimensional operator target for the generic operator route. -/
def routeClosureTestOperatorTarget : QueryOperatorTarget Rat 1 1 where
  operator := Matrix.identity 1 Rat
  normalizer := 1
  source := "route-closure regression witness"
  semanticContract := "the clean block is the one-dimensional identity"

/-- Exact one-dimensional operator block-encoding candidate. -/
def routeClosureTestOperatorCandidate : OperatorBlockEncodingCandidate Rat 0 where
  auxiliaryQubits := 0
  target := routeClosureTestOperatorTarget
  unitary := Matrix.identity 1 Rat
  layout := {
    systemQubits := 0
    signalQubits := 0
    pureAncillas := 0
  }
  circuit := []
  resource := 0
  layoutMatches := rfl
  isUnitary := True
  blockContainsTarget := True

/-- Exact promotion is proof-carrying. -/
def routeClosureTestOperatorVerified : VerifiedOperatorBlockEncoding Rat 0 :=
  routeClosureTestOperatorCandidate.certify trivial trivial

example :
    ∃ approximate : VerifiedApproximateOperatorBlockEncoding Rat 0,
      approximate.approxCandidate.candidate = routeClosureTestOperatorCandidate ∧
      approximate.approxCandidate.epsilon = 0 :=
  exactOperatorBlockEncoding_hasZeroErrorApprox routeClosureTestOperatorVerified

/-- Matrix-first certificate constructor regression witness. -/
def routeClosureTestSpec : BlockEncodingSpec Rat 1 1 where
  matrix := Matrix.identity 1 Rat
  normalizer := 1
  error := 0
  layout := {
    systemQubits := 0
    signalQubits := 0
    pureAncillas := 0
  }
  circuit := []
  resource := 0

/-- The matrix-first route also requires all three proof obligations. -/
def routeClosureTestSpecVerified : VerifiedBlockEncoding Rat 1 1 :=
  routeClosureTestSpec.certify True True True trivial trivial trivial

example : routeClosureTestSpecVerified.blockCorrect :=
  routeClosureTestSpecVerified.correct
