import QuantumBlockEncoding.BlockEncoding
import QuantumBlockEncoding.StatePreparation
import QuantumBlockEncoding.GHL2025

/-!
# Semantic round-trip and theorem repair evidence

This module adds a Lean-native evidence layer for checking that a paper-facing or
user-facing theorem still means the same thing after formalization.

The protocol is deliberately asymmetric:

1. preserve the original statement and source anchor;
2. formalize it in Lean;
3. reconstruct a theorem statement from the Lean declaration while hiding the
   original prose from the decoder;
4. compare ASPBE-specific semantic slots;
5. record any repair as a review-gated proposal rather than overwriting source
   mathematics.

The audited slots include target identity and dimensions, normalization,
ancilla/register order, the clean-projection convention, exact versus
approximate status, the error norm, oracle assumptions, theorem conclusion,
resource scope, and the same-semantic-fibre requirement for circuit comparison.

These declarations are public graph leaves.  Because this module imports the
mathematical branches it audits, the Underlying Lean Graph displays real import
edges from those branches into this evidence branch.
-/

namespace QuantumBlockEncoding
namespace SemanticFidelity

/-- Whether the natural-language reconstruction was produced without seeing the source prose. -/
inductive ReconstructionProtocol where
  | blindLeanOnly
  | sourceAssisted
  deriving Repr, DecidableEq

/-- ASPBE-specific theorem slots whose meaning must survive formalization. -/
inductive SemanticSlot where
  | targetObject
  | scalarAndDimensions
  | quantifiers
  | normalization
  | ancillaLayout
  | registerOrder
  | cleanProjection
  | exactness
  | errorNorm
  | oracleAssumptions
  | conclusion
  | resourceScope
  | sameSemanticFibre
  deriving Repr, DecidableEq

/-- Slotwise verdict for the complete source-to-Lean-to-text round trip. -/
inductive FidelityVerdict where
  | exactMatch
  | equivalentAfterElaboration
  | sourceUnderspecified
  | leanStrongerAssumptions
  | leanWeakerConclusion
  | manualReview
  deriving Repr, DecidableEq

/-- Review state of a proposed clarification or theorem repair. -/
inductive RepairStatus where
  | proposed
  | needsSourceCheck
  | reviewerAccepted
  | rejected
  deriving Repr, DecidableEq

/-- One explicit semantic discrepancy between the source reading and blind reconstruction. -/
structure SemanticDelta where
  slot : SemanticSlot
  originalReading : String
  reconstructedReading : String
  consequence : String
  deriving Repr, DecidableEq

/-- A non-destructive replacement candidate.  It never mutates `RoundTripAudit.originalText`. -/
structure RepairProposal where
  proposedText : String
  rationale : String
  status : RepairStatus
  deriving Repr, DecidableEq

/--
A theorem-fidelity certificate record.

`originalText` is immutable evidence. `reconstructedText` must come from the
Lean declaration and imported definitions under `blindLeanOnly`. Any suggested
repair is stored separately and requires an independent reviewer.
-/
structure RoundTripAudit where
  auditId : String
  sourceAnchor : String
  originalText : String
  leanDeclaration : String
  decoderInput : String
  reconstructedText : String
  protocol : ReconstructionProtocol
  reviewerSeparated : Bool
  checkedSlots : List SemanticSlot
  deltas : List SemanticDelta
  verdict : FidelityVerdict
  repair : Option RepairProposal
  deriving Repr, DecidableEq

namespace RoundTripAudit

/-- Minimal admission contract for a publishable semantic round-trip record. -/
def Admissible (audit : RoundTripAudit) : Prop :=
  audit.auditId ≠ "" ∧
  audit.sourceAnchor ≠ "" ∧
  audit.originalText ≠ "" ∧
  audit.leanDeclaration ≠ "" ∧
  audit.decoderInput ≠ "" ∧
  audit.reconstructedText ≠ "" ∧
  audit.protocol = .blindLeanOnly ∧
  audit.reviewerSeparated = true ∧
  audit.checkedSlots ≠ []

/-- The statement exposed as source evidence remains the original, never an automatic repair. -/
def publishedStatement (audit : RoundTripAudit) : String :=
  audit.originalText

/-- The repair candidate is available separately for human/source review. -/
def proposedStatement (audit : RoundTripAudit) : Option String :=
  audit.repair.map RepairProposal.proposedText

/-- Mismatches and underspecified statements must enter the independent review queue. -/
def requiresHumanReview (audit : RoundTripAudit) : Bool :=
  match audit.verdict with
  | .exactMatch => false
  | .equivalentAfterElaboration => false
  | .sourceUnderspecified => true
  | .leanStrongerAssumptions => true
  | .leanWeakerConclusion => true
  | .manualReview => true

@[simp] theorem publishedStatement_eq_original (audit : RoundTripAudit) :
    audit.publishedStatement = audit.originalText := rfl

end RoundTripAudit

/--
**Equivalent after elaboration.** The source contract says that a verified exact
operator block encoding consists of a candidate unitary plus proofs of
unitarity and clean-block containment. The blind reconstruction recovers the
same claim while making target dimensions, normalizer, layout, circuit,
resources, and `layoutMatches` explicit. No repair is proposed.
-/
def verifiedOperatorBlockEncodingRoundTrip : RoundTripAudit where
  auditId := "core-exact-operator-block-encoding"
  sourceAnchor := "QuantumBlockEncoding/BlockEncoding.lean: VerifiedOperatorBlockEncoding"
  originalText := "An exact operator block encoding contains a candidate unitary together with proofs that the candidate is unitary and that its designated clean block contains the target operator."
  leanDeclaration := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding"
  decoderInput := "The Lean declaration and imported definitions only; the original prose is hidden."
  reconstructedText := "For a scalar type and system-qubit count, the record stores an OperatorBlockEncodingCandidate, a proof of candidate.isUnitary, and a proof of candidate.blockContainsTarget. The candidate also fixes the operator target, normalizer, auxiliary-qubit count, register layout, circuit, resource record, and layout-matching equality."
  protocol := .blindLeanOnly
  reviewerSeparated := true
  checkedSlots := [.targetObject, .scalarAndDimensions, .normalization, .ancillaLayout, .registerOrder, .cleanProjection, .exactness, .conclusion, .resourceScope]
  deltas := []
  verdict := .equivalentAfterElaboration
  repair := none

/-- The core exact block-encoding round trip satisfies the independent-audit contract. -/
theorem verifiedOperatorBlockEncodingRoundTrip_admissible :
    RoundTripAudit.Admissible verifiedOperatorBlockEncodingRoundTrip := by
  simp [RoundTripAudit.Admissible, verifiedOperatorBlockEncodingRoundTrip]

/--
**Lean conclusion is weaker than the public analytic formula.** The public route
states `‖A - α Π U Π†‖ ≤ ε` in a declared norm and register convention. The
current Lean interface stores `epsilon` and an arbitrary proposition
`approximationBound`; it deliberately does not yet identify that proposition
with a concrete norm, projector, or register order. The repair proposal lists
what must be fixed before a theorem is advertised as an analytic approximate
block encoding.
-/
def approximateBlockEncodingNormRoundTrip : RoundTripAudit where
  auditId := "approximate-block-encoding-norm-boundary"
  sourceAnchor := "README Route II and QuantumBlockEncoding/BlockEncoding.lean: ApproximateOperatorBlockEncodingCandidate"
  originalText := "Construct a larger unitary U satisfying ‖A - α Π U Π†‖ ≤ ε in the declared norm and clean ancilla/register convention."
  leanDeclaration := "QuantumBlockEncoding.ApproximateOperatorBlockEncodingCandidate"
  decoderInput := "The Lean declaration and imported definitions only; the README formula is hidden."
  reconstructedText := "The interface stores an exact-candidate payload, a value epsilon, and a backend-supplied proposition approximationBound. The declaration itself does not fix a norm, define Π, connect approximationBound to A - α Π U Π†, or state the register ordering used by the projection."
  protocol := .blindLeanOnly
  reviewerSeparated := true
  checkedSlots := [.targetObject, .normalization, .ancillaLayout, .registerOrder, .cleanProjection, .exactness, .errorNorm, .conclusion]
  deltas := [
    {
      slot := .errorNorm
      originalReading := "A concrete declared norm controls the approximation error."
      reconstructedReading := "The error condition is an unconstrained proposition supplied by a backend."
      consequence := "Compilation of this interface alone is not a proof of the displayed norm inequality."
    },
    {
      slot := .cleanProjection
      originalReading := "Π and the clean-register convention are part of the theorem."
      reconstructedReading := "The approximate proposition is not definitionally tied to a projector or register ordering."
      consequence := "A backend bridge theorem is required before theorem-level promotion."
    }
  ]
  verdict := .leanWeakerConclusion
  repair := some {
    proposedText := "Fix the norm, the clean projector Π, register ordering, α, and ε, and prove that approximationBound is exactly the inequality ‖A - α Π U Π†‖ ≤ ε before advertising a verified approximate block-encoding theorem."
    rationale := "This turns the abstract backend hook into the analytic statement shown to readers without pretending that the generic interface already proves it."
    status := .proposed
  }

/-- The approximate-interface audit is blind, explicit, and independently review-gated. -/
theorem approximateBlockEncodingNormRoundTrip_admissible :
    RoundTripAudit.Admissible approximateBlockEncodingNormRoundTrip := by
  simp [RoundTripAudit.Admissible, approximateBlockEncodingNormRoundTrip]

/--
**Equivalent after elaboration.** State preparation is reconstructed as a proof
that the target is normalized, the candidate matrix is unitary, and its first
computational-basis column equals the target amplitudes. This is exactly the
finite-matrix form of `U |0…0⟩ = |ψ⟩`; no extra assumption or weakened
conclusion appears.
-/
def verifiedStatePreparationRoundTrip : RoundTripAudit where
  auditId := "core-exact-state-preparation"
  sourceAnchor := "QuantumBlockEncoding/StatePreparation.lean: VerifiedStatePreparation"
  originalText := "For a normalized target state |ψ⟩, construct a unitary U satisfying U|0…0⟩ = |ψ⟩."
  leanDeclaration := "QuantumBlockEncoding.VerifiedStatePreparation"
  decoderInput := "The Lean declaration, FirstColumnMatches, zeroBasisIndex, and imported definitions only; the original prose is hidden."
  reconstructedText := "The certificate stores a state-preparation candidate, a proof of target normalization, a proof that the candidate matrix is unitary, and a proof that every row of column zero equals the requested amplitude function."
  protocol := .blindLeanOnly
  reviewerSeparated := true
  checkedSlots := [.targetObject, .scalarAndDimensions, .normalization, .registerOrder, .exactness, .conclusion, .resourceScope]
  deltas := []
  verdict := .equivalentAfterElaboration
  repair := none

/-- The exact state-preparation round trip satisfies the independent-audit contract. -/
theorem verifiedStatePreparationRoundTrip_admissible :
    RoundTripAudit.Admissible verifiedStatePreparationRoundTrip := by
  simp [RoundTripAudit.Admissible, verifiedStatePreparationRoundTrip]

/--
**Paper theorem is not yet reconstructed as a proved block encoding.** The GHL
source-facing branch records the one-term Robin claim, normalizer, register and
resource formulas, and the full theorem-facing transcript. The blind
reconstruction also sees the explicit repository boundary: matrix-level oracle
correctness and the claimed resource theorem are not yet proved, and the active
seven-gate backend is not identical to the full source transcript. The proposed
repair prevents a compiled skeleton from being described as a completed paper
theorem.
-/
def oneTermRobinClaimRoundTrip : RoundTripAudit where
  auditId := "ghl-one-term-robin-source-fidelity"
  sourceAnchor := "Guseynov-Huang-Liu 2025 one-term Robin theorem; QuantumBlockEncoding/GHL2025.lean"
  originalText := "The one-term Robin construction block-encodes A_k with normalizer N_D N_f κ, the stated signal-qubit layout, 2n pure ancillas, and the advertised gate complexity."
  leanDeclaration := "QuantumBlockEncoding.GHL2025.oneTermRobinClaim together with oneTermRobinTheoremFacingFig4Circuit_gateList"
  decoderInput := "The GHL2025 Lean declarations, their imported definitions, and declaration documentation only; the paper theorem prose is hidden."
  reconstructedText := "Lean records a ConstructionClaim, symbolic normalization/layout/resource data, and a theorem-facing gate transcript. The module explicitly does not yet prove matrix-level block correctness. It also distinguishes the full source transcript from the active seven-gate backend product."
  protocol := .blindLeanOnly
  reviewerSeparated := true
  checkedSlots := [.targetObject, .normalization, .ancillaLayout, .registerOrder, .cleanProjection, .oracleAssumptions, .conclusion, .resourceScope]
  deltas := [
    {
      slot := .conclusion
      originalReading := "A complete block-encoding theorem is asserted."
      reconstructedReading := "The current Lean branch records the claim shape and transcript but not matrix-level block correctness."
      consequence := "The declaration is compiled evidence about the specification, not yet a proof of the full paper theorem."
    },
    {
      slot := .oracleAssumptions
      originalReading := "Source oracles are treated as valid circuit components."
      reconstructedReading := "Their unitary action, cleanup, and matrix semantics remain explicit compiler obligations."
      consequence := "Oracle correctness and unitarity assumptions must be stated or discharged."
    },
    {
      slot := .resourceScope
      originalReading := "The theorem-level gate and ancilla bounds are advertised."
      reconstructedReading := "Lean stores formulas and local circuit costs; the arbitrary-width primitive resource theorem remains open."
      consequence := "A symbolic formula record must not be promoted to a proved complexity theorem."
    }
  ]
  verdict := .leanWeakerConclusion
  repair := some {
    proposedText := "State that Lean currently certifies the source-aligned claim data, transcript guards, normalization/layout formulas, and closed algebraic sublemmas; keep full matrix-level oracle correctness and the arbitrary-width resource theorem as explicit obligations. Before promotion, add the oracle action/unitarity assumptions, register order, clean projector, cleanup gates, and the exact normalization convention."
    rationale := "This is the minimal source-faithful wording supported by the present GHL branch and exposes exactly what must be added for a complete theorem."
    status := .needsSourceCheck
  }

/-- The GHL source-fidelity audit satisfies the independent-audit contract. -/
theorem oneTermRobinClaimRoundTrip_admissible :
    RoundTripAudit.Admissible oneTermRobinClaimRoundTrip := by
  simp [RoundTripAudit.Admissible, oneTermRobinClaimRoundTrip]

/--
**Source wording is underspecified without a correctness fibre.**
`BlockEncodingCost.betterThan` proves only a lexicographic comparison of gate
count, depth, auxiliary qubits, and unresolved oracle calls. It does not say
that two candidates encode the same target under the same normalization,
projection/error convention, or that both candidates are semantically
certified. Any natural-language claim that one algorithm is better must add
those assumptions.
-/
def candidateImprovementRoundTrip : RoundTripAudit where
  auditId := "same-semantic-fibre-before-resource-improvement"
  sourceAnchor := "QuantumBlockEncoding/BlockEncoding.lean: BlockEncodingCost.betterThan"
  originalText := "The evolved block-encoding candidate is better than the baseline."
  leanDeclaration := "QuantumBlockEncoding.BlockEncodingCost.betterThan"
  decoderInput := "The Lean definition and imported resource records only; the informal improvement claim is hidden."
  reconstructedText := "The relation is a strict lexicographic order on gateCount, depth, auxiliaryQubits, and oracleCalls. It contains no premise connecting the compared costs to equal targets or to certified block-encoding semantics."
  protocol := .blindLeanOnly
  reviewerSeparated := true
  checkedSlots := [.targetObject, .normalization, .cleanProjection, .exactness, .errorNorm, .conclusion, .resourceScope, .sameSemanticFibre]
  deltas := [
    {
      slot := .sameSemanticFibre
      originalReading := "Better means a resource improvement for the same mathematical task and correctness contract."
      reconstructedReading := "The Lean relation compares two cost records only."
      consequence := "A cheaper circuit for a different target, error tolerance, or projection convention would also satisfy the bare cost relation."
    }
  ]
  verdict := .sourceUnderspecified
  repair := some {
    proposedText := "Say that candidate X improves baseline Y only after proving that both are certified for the same target operator/state, normalization, register and clean-projection convention, and exact/approximate tolerance; then cite X.cost.betterThan Y.cost."
    rationale := "Correctness and target fidelity are admission gates, whereas betterThan is only the deterministic resource order inside that semantic fibre."
    status := .proposed
  }

/-- The same-semantic-fibre audit satisfies the independent-audit contract. -/
theorem candidateImprovementRoundTrip_admissible :
    RoundTripAudit.Admissible candidateImprovementRoundTrip := by
  simp [RoundTripAudit.Admissible, candidateImprovementRoundTrip]

/--
The initial public semantic-fidelity registry shown as declaration leaves in the
Underlying Lean Graph. Two core contracts round-trip faithfully; three records
enter the review queue because an analytic norm bridge, a paper theorem closure,
or a same-target premise is still required.
-/
def semanticRoundTripRegistry : List RoundTripAudit :=
  [ verifiedOperatorBlockEncodingRoundTrip
  , approximateBlockEncodingNormRoundTrip
  , verifiedStatePreparationRoundTrip
  , oneTermRobinClaimRoundTrip
  , candidateImprovementRoundTrip
  ]

@[simp] theorem semanticRoundTripRegistry_length :
    semanticRoundTripRegistry.length = 5 := rfl

end SemanticFidelity
end QuantumBlockEncoding
