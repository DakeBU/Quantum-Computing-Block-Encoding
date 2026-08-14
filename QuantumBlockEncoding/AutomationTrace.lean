import QuantumBlockEncoding.Automation
import Mathlib.Tactic

/-!
# Verified three-layer automation traces

The external models and shell processes remain engineering components.  This
module closes the reusable Lean route by giving their handoffs a finite typed
state machine, a validity predicate, and a canonical accepted trace whose final
transition requires both review and a passing Lean gate.
-/

namespace QuantumBlockEncoding

inductive ThreeLayerPhase where
  | upperPlanning
  | middleRefinement
  | lowerAttempt
  | reviewerAudit
  | accepted
  | rejected
deriving Repr, DecidableEq

structure ThreeLayerHandoff where
  source : ThreeLayerPhase
  target : ThreeLayerPhase
  role : AgentRole
  trialLogged : Bool
  artifactCount : Nat
  leanGatePassed : Bool
  reviewerApproved : Bool
deriving Repr, DecidableEq

/-- Allowed phase transitions.  Acceptance is possible only from review. -/
def ThreeLayerHandoff.valid (handoff : ThreeLayerHandoff) : Prop :=
  handoff.trialLogged = true ∧
  handoff.artifactCount > 0 ∧
  match handoff.source, handoff.target, handoff.role with
  | .upperPlanning, .middleRefinement, .upper => True
  | .middleRefinement, .lowerAttempt, .middle => True
  | .lowerAttempt, .reviewerAudit, .lower => True
  | .reviewerAudit, .accepted, .reviewer =>
      handoff.leanGatePassed = true ∧ handoff.reviewerApproved = true
  | .reviewerAudit, .rejected, .reviewer => True
  | _, _, _ => False

/-- One execution trace with an explicit starting phase. -/
structure ThreeLayerTrace where
  start : ThreeLayerPhase
  handoffs : List ThreeLayerHandoff
deriving Repr, DecidableEq

/-- Follow a handoff only when it starts at the current phase and is valid. -/
def ThreeLayerTrace.advance :
    ThreeLayerPhase → ThreeLayerHandoff → Option ThreeLayerPhase
  | current, handoff =>
      if current = handoff.source ∧ handoff.valid then some handoff.target else none

/-- Execute a trace left-to-right, rejecting the first invalid handoff. -/
def ThreeLayerTrace.finalPhase (trace : ThreeLayerTrace) : Option ThreeLayerPhase :=
  trace.handoffs.foldlM ThreeLayerTrace.advance trace.start

/-- Every handoff in a trace is locally valid. -/
def ThreeLayerTrace.allValid (trace : ThreeLayerTrace) : Prop :=
  ∀ handoff ∈ trace.handoffs, handoff.valid

/-- Canonical upper-to-reviewer trace used as the finite teaching witness. -/
def threeLayerCanonicalTrace : ThreeLayerTrace where
  start := .upperPlanning
  handoffs :=
    [ { source := .upperPlanning
        target := .middleRefinement
        role := .upper
        trialLogged := true
        artifactCount := 2
        leanGatePassed := false
        reviewerApproved := false }
    , { source := .middleRefinement
        target := .lowerAttempt
        role := .middle
        trialLogged := true
        artifactCount := 3
        leanGatePassed := false
        reviewerApproved := false }
    , { source := .lowerAttempt
        target := .reviewerAudit
        role := .lower
        trialLogged := true
        artifactCount := 1
        leanGatePassed := true
        reviewerApproved := false }
    , { source := .reviewerAudit
        target := .accepted
        role := .reviewer
        trialLogged := true
        artifactCount := 2
        leanGatePassed := true
        reviewerApproved := true }
    ]

theorem threeLayerCanonicalTrace_allValid :
    threeLayerCanonicalTrace.allValid := by
  intro handoff membership
  simp [threeLayerCanonicalTrace] at membership
  rcases membership with rfl | rfl | rfl | rfl <;>
    decide

/-- The canonical trace reaches acceptance without an external semantic axiom. -/
theorem threeLayerCanonicalTrace_reachesAccepted :
    threeLayerCanonicalTrace.finalPhase = some .accepted := by
  native_decide

/-- Any locally valid acceptance transition records a passing Lean gate. -/
theorem threeLayerAccepted_requiresLeanGate
    (handoff : ThreeLayerHandoff)
    (valid : handoff.valid)
    (accepted : handoff.target = .accepted) :
    handoff.leanGatePassed = true := by
  rcases handoff with
    ⟨source, target, role, trialLogged, artifactCount,
      leanGatePassed, reviewerApproved⟩
  simp only [ThreeLayerHandoff.valid] at valid
  subst target
  cases source <;> cases role <;> simp_all

/-- Any locally valid acceptance transition also records reviewer approval. -/
theorem threeLayerAccepted_requiresReviewerApproval
    (handoff : ThreeLayerHandoff)
    (valid : handoff.valid)
    (accepted : handoff.target = .accepted) :
    handoff.reviewerApproved = true := by
  rcases handoff with
    ⟨source, target, role, trialLogged, artifactCount,
      leanGatePassed, reviewerApproved⟩
  simp only [ThreeLayerHandoff.valid] at valid
  subst target
  cases source <;> cases role <;> simp_all

/-- Removing the final Lean gate prevents the same trace from being accepted. -/
def threeLayerFailedGateTrace : ThreeLayerTrace where
  start := .upperPlanning
  handoffs :=
    threeLayerCanonicalTrace.handoffs.dropLast ++
      [ { source := .reviewerAudit
          target := .accepted
          role := .reviewer
          trialLogged := true
          artifactCount := 2
          leanGatePassed := false
          reviewerApproved := true } ]

theorem threeLayerFailedGateTrace_notAccepted :
    threeLayerFailedGateTrace.finalPhase ≠ some .accepted := by
  native_decide

end QuantumBlockEncoding
