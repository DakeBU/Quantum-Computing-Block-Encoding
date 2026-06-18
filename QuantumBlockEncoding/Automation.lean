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
  | candidateScoring
  | leanProof
  | review
  | documented
deriving Repr, DecidableEq

inductive TaskKind where
  | operatorBlockEncoding
  | paperBenchmark
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

inductive PostCycleArtifactKind where
  | chineseSummary
  | chatgptProPrompt
  | retrievalIndex
  | technicalReportUpdate
  | verifierFeedback
deriving Repr, DecidableEq

structure PostCycleArtifactSpec where
  kind : PostCycleArtifactKind
  pathPattern : String
  selfContainedForExternalModel : Bool
  note : String
deriving Repr, DecidableEq

structure WorkflowCheckSpec where
  name : String
  checks : List String
  inspiredBy : String
  note : String
deriving Repr, DecidableEq

inductive CandidatePool where
  | insight
  | certified
deriving Repr, DecidableEq

structure WorkflowInvariantSpec where
  name : String
  precondition : String
  requiredEvidence : List String
  rejectionReason : String
  inspiredBy : String
deriving Repr, DecidableEq

def leanBuildGate : AcceptanceGate where
  name := "Lean build"
  command := "lake build && lake build Tests"
  required := true
  note := "Every automation run must leave the repository compiling."

def noSorryGate : AcceptanceGate where
  name := "No new sorry by default"
  command := "rg -n \"\\bsorry\\b\" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true"
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

def postCycleArtifactSpecs : List PostCycleArtifactSpec :=
  [
    {
      kind := PostCycleArtifactKind.chineseSummary
      pathPattern := "paper-notes/GHL2025/markdown/cycle-summaries/latest.md"
      selfContainedForExternalModel := false
      note := "Human-facing Chinese source audit for the latest long run."
    },
    {
      kind := PostCycleArtifactKind.chatgptProPrompt
      pathPattern := "runs/pro-prompts/<task-id>-latest.md"
      selfContainedForExternalModel := true
      note := "Prompt assumes ChatGPT Pro cannot read local files."
    },
    {
      kind := PostCycleArtifactKind.retrievalIndex
      pathPattern := "research-wiki/retrieval-index/<task-id>.json"
      selfContainedForExternalModel := false
      note := "Compact upper/middle memory for the next cycle."
    },
    {
      kind := PostCycleArtifactKind.technicalReportUpdate
      pathPattern := "paper-notes/project-paper/cycle-updates/latest.tex"
      selfContainedForExternalModel := false
      note := "Middle-agent public writing update; must not overclaim theorem closure."
    }
  ]

def workflowCheckSpecs : List WorkflowCheckSpec :=
  [
    {
      name := "Blueprint DAG refinement"
      checks := ["active leaf recorded", "solved nodes preserved", "failed route classified"]
      inspiredBy := "arXiv:2606.06468"
      note := "Goedel-Architect-like blueprint control, specialized to oracle/block-encoding leaves."
    },
    {
      name := "Agent trajectory audit"
      checks := ["required artifacts exist", "role handoff recorded", "stale route not reassigned unchanged"]
      inspiredBy := "arXiv:2606.06523"
      note := "Lean4Agent-like workflow verification; separate from the quantum theorem."
    }
  ]

def workflowInvariantSpecs : List WorkflowInvariantSpec :=
  [
    {
      name := "Certified candidate promotion"
      precondition := "candidate is proposed by a lower architect, simulator, Python search, ChatGPT Pro, or paper baseline",
      requiredEvidence := ["Lean theorem closes the advertised unitarity/block-entry target", "resource record is attached", "reviewer confirms target operator did not change"],
      rejectionReason := "candidate remains in insight pool and cannot be plotted as solved or used as an evolutionary parent",
      inspiredBy := "arXiv:2606.06523 process verification plus EoH-style candidate archives"
    },
    {
      name := "Closeout artifacts for unfinished long run"
      precondition := "six-hour or convergence closeout ends with unfinished target",
      requiredEvidence := ["Chinese summary exists", "self-contained ChatGPT Pro prompt exists", "retrieval index or todo is refreshed"],
      rejectionReason := "next upper cycle lacks a reliable handoff",
      inspiredBy := "arXiv:2606.06523 trajectory audit"
    },
    {
      name := "No stale route replay"
      precondition := "reviewer rejects a proof route or finite verifier contradicts a target",
      requiredEvidence := ["error class recorded", "next route changes statement, dependency, semantic level, or finite witness"],
      rejectionReason := "lower agent is repeating a known failed route",
      inspiredBy := "arXiv:2606.06468 blueprint refinement and arXiv:2606.06523 failure localization"
    }
  ]

def threeLayerAgentContracts : List AgentContract :=
  [
    {
      role := AgentRole.upper,
      responsibility := "Fix the operator target, choose candidate families or proof leaves, compress trial memory, and reject weak directions.",
      writes := ["runs/<run-id>/10_upper_director.md", "runs/<run-id>/90_handoff.md"],
      mustLogTrial := true
    },
    {
      role := AgentRole.middle,
      responsibility := "Maintain the operator/candidate Lean--Markdown--LaTeX conversion window and proof-obligation ledger.",
      writes := ["conversion-windows/", "proof-obligations/", "tasks/"],
      mustLogTrial := true
    },
    {
      role := AgentRole.lower,
      responsibility := "Attempt one concrete candidate unitary/circuit construction, resource-score improvement, proof repair, or open-problem promotion.",
      writes := ["QuantumBlockEncoding/", "Tests/", "paper-notes/"],
      mustLogTrial := true
    },
    {
      role := AgentRole.reviewer,
      responsibility := "Review diffs, operator targets, hidden oracle assumptions, BlockEncodingCost, citations, and Lean build results.",
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
      title := "Construct and score a block encoding for a user-specified query operator",
      kind := TaskKind.operatorBlockEncoding,
      status := TaskStatus.active,
      stage := AutomationStage.circuitSearch,
      source := "User-provided operator/matrix A, normalizer alpha, and block projector",
      targetLean := "QuantumBlockEncoding/BlockEncoding.lean",
      artifacts := conversionArtifacts "OperatorBlockEncodingCandidate",
      gates := defaultGates
    },
    {
      id := "QBE-AUTO-002",
      title := "Benchmark the Guseynov-Huang-Liu Robin block-encoding construction",
      kind := TaskKind.paperBenchmark,
      status := TaskStatus.planned,
      stage := AutomationStage.leanProof,
      source := "Guseynov-Huang-Liu 2025/2026 paper benchmark",
      targetLean := "QuantumBlockEncoding/GHL2025.lean",
      artifacts := conversionArtifacts "GHL2025_RobinOneTerm",
      gates := defaultGates
    },
    {
      id := "QBE-AUTO-003",
      title := "Improve a fixed operator block encoding against a baseline score",
      kind := TaskKind.blockEncodingSearch,
      status := TaskStatus.planned,
      stage := AutomationStage.candidateScoring,
      source := "Candidate population and baseline BlockEncodingCost",
      targetLean := "QuantumBlockEncoding/OpenProblems.lean",
      artifacts := conversionArtifacts "BlockEncodingImprovement",
      gates := defaultGates
    }
  ]

def automationTaskCount : Nat := seedAutomationTasks.length

end QuantumBlockEncoding
