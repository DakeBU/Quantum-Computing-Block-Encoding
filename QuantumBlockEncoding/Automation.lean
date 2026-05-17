/-!
# Automation protocol

This file makes the deployment workflow part of the compiled Lean project.
It does not run agents.  Instead, it defines the artifact contracts that agents
must satisfy while turning papers, ideas, and open oracle assumptions into
Lean-checked block-encoding certificates.
-/

namespace QuantumBlockEncoding

inductive AutomationStage where
  | literatureTriage
  | formalSpec
  | circuitSearch
  | leanProof
  | review
  | documented
deriving Repr, DecidableEq

inductive TaskKind where
  | paperFormalization
  | oracleRealization
  | blockEncodingSearch
  | openProblemProposal
  | conversionWindow
  | proofRepair
deriving Repr, DecidableEq

inductive TaskStatus where
  | planned
  | active
  | blocked
  | leanCompiles
  | merged
deriving Repr, DecidableEq

inductive ArtifactLanguage where
  | lean
  | latex
  | markdown
  | json
  | csv
deriving Repr, DecidableEq

inductive AgentRole where
  | upper
  | middle
  | lower
  | reviewer
deriving Repr, DecidableEq

inductive TrialKind where
  | plan
  | attempt
  | build
  | review
  | proposal
  | compression
  | handoff
deriving Repr, DecidableEq

inductive TrialStatus where
  | queued
  | running
  | blocked
  | failed
  | compiled
  | accepted
  | rejected
deriving Repr, DecidableEq

structure ArtifactSpec where
  path : String
  language : ArtifactLanguage
  purpose : String
  mustCompile : Bool
deriving Repr, DecidableEq

structure AcceptanceGate where
  name : String
  command : String
  required : Bool
  note : String
deriving Repr, DecidableEq

structure AutomationTask where
  id : String
  title : String
  kind : TaskKind
  status : TaskStatus
  stage : AutomationStage
  source : String
  targetLean : String
  artifacts : List ArtifactSpec
  gates : List AcceptanceGate
deriving Repr, DecidableEq

structure AgentContract where
  role : AgentRole
  responsibility : String
  writes : List String
  mustLogTrial : Bool
deriving Repr, DecidableEq

structure TrialRecordSpec where
  logPath : String
  summaryPath : String
  requiredFields : List String
  note : String
deriving Repr, DecidableEq

def leanBuildGate : AcceptanceGate where
  name := "Lean build"
  command := "lake build && lake build Tests"
  required := true
  note := "Every automation run must leave the repository compiling."

def noSorryGate : AcceptanceGate where
  name := "No new sorry by default"
  command := "grep -R \"sorry\" QuantumBlockEncoding Tests || true"
  required := false
  note := "Skeleton files may use proposition-valued obligations, but finished tasks should avoid new sorry."

def defaultGates : List AcceptanceGate :=
  [leanBuildGate, noSorryGate]

def trialRecordSpec : TrialRecordSpec where
  logPath := "runs/trials.jsonl"
  summaryPath := "runs/trials_summary.csv"
  requiredFields := [
    "timestamp",
    "trial_id",
    "task_id",
    "role",
    "kind",
    "status",
    "lean_gate",
    "artifact",
    "changed_files",
    "notes"
  ]
  note := "Inspired by Learning Beyond Gradients trial logs; used here as proof-search memory."

def threeLayerAgentContracts : List AgentContract :=
  [
    {
      role := AgentRole.upper,
      responsibility := "Choose the next formalization objective, compress trial memory, and reject weak directions.",
      writes := ["runs/<run-id>/10_upper_director.md", "runs/<run-id>/90_handoff.md"],
      mustLogTrial := true
    },
    {
      role := AgentRole.middle,
      responsibility := "Maintain the LaTeX/Markdown/Lean conversion window and proof-obligation ledger.",
      writes := ["conversion-windows/", "proof-obligations/", "tasks/"],
      mustLogTrial := true
    },
    {
      role := AgentRole.lower,
      responsibility := "Attempt one concrete circuit construction, proof repair, or open-problem promotion.",
      writes := ["QuantumBlockEncoding/", "Tests/", "paper-notes/"],
      mustLogTrial := true
    },
    {
      role := AgentRole.reviewer,
      responsibility := "Review diffs, oracle assumptions, resources, citations, and Lean build results.",
      writes := ["reviews/", "runs/<run-id>/dialogue.md"],
      mustLogTrial := true
    }
  ]

def conversionArtifacts (stem : String) : List ArtifactSpec :=
  [
    {
      path := "tasks/" ++ stem ++ ".md",
      language := ArtifactLanguage.markdown,
      purpose := "Human-readable task contract and progress log.",
      mustCompile := false
    },
    {
      path := "paper-notes/" ++ stem ++ ".tex",
      language := ArtifactLanguage.latex,
      purpose := "Optional LaTeX statement/proof sketch synchronized with Lean names.",
      mustCompile := false
    },
    {
      path := "QuantumBlockEncoding/" ++ stem ++ ".lean",
      language := ArtifactLanguage.lean,
      purpose := "Lean formulation or certificate target.",
      mustCompile := true
    }
  ]

def seedAutomationTasks : List AutomationTask :=
  [
    {
      id := "QBE-AUTO-001",
      title := "Complete the Guseynov-Huang-Liu Robin one-term block encoding skeleton",
      kind := TaskKind.paperFormalization,
      status := TaskStatus.active,
      stage := AutomationStage.formalSpec,
      source := "Guseynov-Huang-Liu 2026 primary target",
      targetLean := "QuantumBlockEncoding/GHL2025.lean",
      artifacts := conversionArtifacts "GHL2025_RobinOneTerm",
      gates := defaultGates
    },
    {
      id := "QBE-AUTO-002",
      title := "Create a concrete gate-semantics backend for the circuit IR",
      kind := TaskKind.oracleRealization,
      status := TaskStatus.planned,
      stage := AutomationStage.circuitSearch,
      source := "Project automation roadmap",
      targetLean := "QuantumBlockEncoding/Circuit.lean",
      artifacts := conversionArtifacts "CircuitSemantics",
      gates := defaultGates
    },
    {
      id := "QBE-AUTO-003",
      title := "Generate new open block-encoding problems from failed oracle assumptions",
      kind := TaskKind.openProblemProposal,
      status := TaskStatus.planned,
      stage := AutomationStage.literatureTriage,
      source := "Open problem registry",
      targetLean := "QuantumBlockEncoding/OpenProblems.lean",
      artifacts := conversionArtifacts "OpenProblemDiscovery",
      gates := defaultGates
    }
  ]

def automationTaskCount : Nat := seedAutomationTasks.length

end QuantumBlockEncoding
