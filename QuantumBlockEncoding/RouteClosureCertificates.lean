import QuantumBlockEncoding.TeachingRouteClosures

/-!
# Generic route-closure certificates

This module supplies the missing promotion functions for the approximate
state-preparation and operator block-encoding interfaces.  Together with the
exact constructors in `TeachingRouteClosures`, these declarations make the
shared public workflow proof-carrying in both directions:

* a candidate is promoted only after each proposition-valued obligation is
  supplied as a Lean proof; and
* an exact certificate has a canonical zero-error approximate certificate.

The results are generic interface theorems.  They do not manufacture
normalization, unitarity, first-column, clean-block, or norm proofs for an
arbitrary candidate.
-/

namespace QuantumBlockEncoding

universe u

namespace ApproximateStatePreparationCandidate

/--
Promote an approximate state-preparation candidate only after normalization,
unitarity, and the backend-specific approximation bound have all been proved.
-/
def certify {α : Type u} {qubits : Nat}
    (candidate : ApproximateStatePreparationCandidate α qubits)
    (normalizationProof : candidate.candidate.target.normalization)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    VerifiedApproximateStatePreparation α qubits where
  approxCandidate := candidate
  normalizationProof := normalizationProof
  unitaryProof := unitaryProof
  approximationProof := approximationProof

@[simp] theorem certify_candidate {α : Type u} {qubits : Nat}
    (candidate : ApproximateStatePreparationCandidate α qubits)
    (normalizationProof : candidate.candidate.target.normalization)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify normalizationProof unitaryProof approximationProof).approxCandidate =
      candidate := rfl

@[simp] theorem certify_normalization {α : Type u} {qubits : Nat}
    (candidate : ApproximateStatePreparationCandidate α qubits)
    (normalizationProof : candidate.candidate.target.normalization)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify normalizationProof unitaryProof approximationProof)
      .approxCandidate.candidate.target.normalization :=
  normalizationProof

@[simp] theorem certify_unitary {α : Type u} {qubits : Nat}
    (candidate : ApproximateStatePreparationCandidate α qubits)
    (normalizationProof : candidate.candidate.target.normalization)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify normalizationProof unitaryProof approximationProof)
      .approxCandidate.candidate.isUnitary :=
  unitaryProof

@[simp] theorem certify_approximation {α : Type u} {qubits : Nat}
    (candidate : ApproximateStatePreparationCandidate α qubits)
    (normalizationProof : candidate.candidate.target.normalization)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify normalizationProof unitaryProof approximationProof)
      .approxCandidate.approximationBound :=
  approximationProof

end ApproximateStatePreparationCandidate

namespace VerifiedApproximateStatePreparation

/-- Recover the normalization proof carried by a verified approximate route. -/
theorem normalization {α : Type u} {qubits : Nat}
    (verified : VerifiedApproximateStatePreparation α qubits) :
    verified.approxCandidate.candidate.target.normalization :=
  verified.normalizationProof

/-- Recover the unitarity proof carried by a verified approximate route. -/
theorem unitary {α : Type u} {qubits : Nat}
    (verified : VerifiedApproximateStatePreparation α qubits) :
    verified.approxCandidate.candidate.isUnitary :=
  verified.unitaryProof

/-- Recover the approximation proof carried by a verified approximate route. -/
theorem approximation {α : Type u} {qubits : Nat}
    (verified : VerifiedApproximateStatePreparation α qubits) :
    verified.approxCandidate.approximationBound :=
  verified.approximationProof

end VerifiedApproximateStatePreparation

namespace ApproximateOperatorBlockEncodingCandidate

/--
Promote an approximate operator block-encoding candidate only after the
candidate unitary and the selected approximation predicate have been proved.
-/
def certify {α : Type u} {systemQubits : Nat}
    (candidate : ApproximateOperatorBlockEncodingCandidate α systemQubits)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    VerifiedApproximateOperatorBlockEncoding α systemQubits where
  approxCandidate := candidate
  unitaryProof := unitaryProof
  approximationProof := approximationProof

@[simp] theorem certify_candidate {α : Type u} {systemQubits : Nat}
    (candidate : ApproximateOperatorBlockEncodingCandidate α systemQubits)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify unitaryProof approximationProof).approxCandidate = candidate := rfl

@[simp] theorem certify_unitary {α : Type u} {systemQubits : Nat}
    (candidate : ApproximateOperatorBlockEncodingCandidate α systemQubits)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify unitaryProof approximationProof)
      .approxCandidate.candidate.isUnitary :=
  unitaryProof

@[simp] theorem certify_approximation {α : Type u} {systemQubits : Nat}
    (candidate : ApproximateOperatorBlockEncodingCandidate α systemQubits)
    (unitaryProof : candidate.candidate.isUnitary)
    (approximationProof : candidate.approximationBound) :
    (candidate.certify unitaryProof approximationProof)
      .approxCandidate.approximationBound :=
  approximationProof

end ApproximateOperatorBlockEncodingCandidate

namespace VerifiedApproximateOperatorBlockEncoding

/-- Recover the unitarity proof carried by a verified approximate block encoding. -/
theorem unitary {α : Type u} {systemQubits : Nat}
    (verified : VerifiedApproximateOperatorBlockEncoding α systemQubits) :
    verified.approxCandidate.candidate.isUnitary :=
  verified.unitaryProof

/-- Recover the approximation proof carried by a verified approximate block encoding. -/
theorem approximation {α : Type u} {systemQubits : Nat}
    (verified : VerifiedApproximateOperatorBlockEncoding α systemQubits) :
    verified.approxCandidate.approximationBound :=
  verified.approximationProof

end VerifiedApproximateOperatorBlockEncoding

namespace BlockEncodingSpec

/--
Generic proof-carrying promotion for the matrix-first `BlockEncodingSpec`
interface.  The three propositions remain backend choices, but none may be
omitted at promotion time.
-/
def certify {α : Type u} {rows cols : Nat}
    (spec : BlockEncodingSpec α rows cols)
    (isUnitary blockCorrect resourceBound : Prop)
    (unitaryProof : isUnitary)
    (blockProof : blockCorrect)
    (resourceProof : resourceBound) :
    VerifiedBlockEncoding α rows cols where
  spec := spec
  isUnitary := isUnitary
  blockCorrect := blockCorrect
  resourceBound := resourceBound
  unitaryProof := unitaryProof
  blockProof := blockProof
  resourceProof := resourceProof

@[simp] theorem certify_spec {α : Type u} {rows cols : Nat}
    (spec : BlockEncodingSpec α rows cols)
    (isUnitary blockCorrect resourceBound : Prop)
    (unitaryProof : isUnitary)
    (blockProof : blockCorrect)
    (resourceProof : resourceBound) :
    (spec.certify isUnitary blockCorrect resourceBound
      unitaryProof blockProof resourceProof).spec = spec := rfl

end BlockEncodingSpec

/-- Every exact state-preparation certificate canonically closes the zero-error approximate route. -/
theorem exactStatePreparation_hasZeroErrorApprox
    {α : Type u} {qubits : Nat} [OfNat α 0]
    (verified : VerifiedStatePreparation α qubits) :
    ∃ approximate : VerifiedApproximateStatePreparation α qubits,
      approximate.approxCandidate.candidate = verified.candidate ∧
      approximate.approxCandidate.epsilon = 0 := by
  exact ⟨verified.asZeroErrorApprox, rfl, rfl⟩

/-- Every exact operator block encoding canonically closes the zero-error approximate route. -/
theorem exactOperatorBlockEncoding_hasZeroErrorApprox
    {α : Type u} {systemQubits : Nat} [OfNat α 0]
    (verified : VerifiedOperatorBlockEncoding α systemQubits) :
    ∃ approximate : VerifiedApproximateOperatorBlockEncoding α systemQubits,
      approximate.approxCandidate.candidate = verified.candidate ∧
      approximate.approxCandidate.epsilon = 0 := by
  exact ⟨verified.asZeroErrorApprox, rfl, rfl⟩

/-- Concrete regression witness for the generic exact-to-approximate state route. -/
def textbookPauliXZeroErrorApprox : VerifiedApproximateStatePreparation ℂ 1 :=
  textbookPauliXVerifiedOfFirstColumn.asZeroErrorApprox

@[simp] theorem textbookPauliXZeroErrorApprox_epsilon :
    textbookPauliXZeroErrorApprox.approxCandidate.epsilon = 0 := rfl

@[simp] theorem textbookPauliXZeroErrorApprox_preparesTarget :
    textbookPauliXZeroErrorApprox.approxCandidate.approximationBound :=
  textbookPauliXVerifiedOfFirstColumn.preparationProof

end QuantumBlockEncoding
