import QuantumBlockEncoding
import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

set_option linter.hashCommand false
set_option linter.style.longLine false
set_option verso.blueprint.externalCode.strictResolve true

#doc (Manual) "Declaration catalog: AutomationAndMemory" =>
%%%
file := "catalog-automation-and-memory"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

# QuantumBlockEncoding/Automation.lean

39 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.AutomationStage" (lean := "QuantumBlockEncoding.AutomationStage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:12](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L12).
:::

:::definition "QuantumBlockEncoding.TaskKind" (lean := "QuantumBlockEncoding.TaskKind")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:22](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L22).
:::

:::definition "QuantumBlockEncoding.TaskStatus" (lean := "QuantumBlockEncoding.TaskStatus")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:33](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L33).
:::

:::definition "QuantumBlockEncoding.ArtifactLanguage" (lean := "QuantumBlockEncoding.ArtifactLanguage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:41](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L41).
:::

:::definition "QuantumBlockEncoding.AgentRole" (lean := "QuantumBlockEncoding.AgentRole")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:49](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L49).
:::

:::definition "QuantumBlockEncoding.AgentBackendKind" (lean := "QuantumBlockEncoding.AgentBackendKind")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:56](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L56).
:::

:::definition "QuantumBlockEncoding.TrialKind" (lean := "QuantumBlockEncoding.TrialKind")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:67](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L67).
:::

:::definition "QuantumBlockEncoding.TrialStatus" (lean := "QuantumBlockEncoding.TrialStatus")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:77](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L77).
:::

:::definition "QuantumBlockEncoding.ArtifactSpec" (lean := "QuantumBlockEncoding.ArtifactSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:87](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L87).
:::

:::definition "QuantumBlockEncoding.AcceptanceGate" (lean := "QuantumBlockEncoding.AcceptanceGate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:94](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L94).
:::

:::definition "QuantumBlockEncoding.AutomationTask" (lean := "QuantumBlockEncoding.AutomationTask")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:101](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L101).
:::

:::definition "QuantumBlockEncoding.AgentContract" (lean := "QuantumBlockEncoding.AgentContract")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:113](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L113).
:::

:::definition "QuantumBlockEncoding.TrialRecordSpec" (lean := "QuantumBlockEncoding.TrialRecordSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:120](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L120).
:::

:::definition "QuantumBlockEncoding.PostCycleArtifactKind" (lean := "QuantumBlockEncoding.PostCycleArtifactKind")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:127](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L127).
:::

:::definition "QuantumBlockEncoding.PostCycleArtifactSpec" (lean := "QuantumBlockEncoding.PostCycleArtifactSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:135](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L135).
:::

:::definition "QuantumBlockEncoding.WorkflowCheckSpec" (lean := "QuantumBlockEncoding.WorkflowCheckSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:142](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L142).
:::

:::definition "QuantumBlockEncoding.CandidatePool" (lean := "QuantumBlockEncoding.CandidatePool")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L149).
:::

:::definition "QuantumBlockEncoding.LexElimSchedulerMode" (lean := "QuantumBlockEncoding.LexElimSchedulerMode")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:154](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L154).
:::

:::definition "QuantumBlockEncoding.LexObjectiveClass" (lean := "QuantumBlockEncoding.LexObjectiveClass")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:159](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L159).
:::

:::definition "QuantumBlockEncoding.LexObjectiveSpec" (lean := "QuantumBlockEncoding.LexObjectiveSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:168](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L168).
:::

:::definition "QuantumBlockEncoding.LexElimSchedulerSpec" (lean := "QuantumBlockEncoding.LexElimSchedulerSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:176](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L176).
:::

:::definition "QuantumBlockEncoding.AgentPanelSizeSpec" (lean := "QuantumBlockEncoding.AgentPanelSizeSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:185](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L185).
:::

:::definition "QuantumBlockEncoding.AgentBackendProfileSpec" (lean := "QuantumBlockEncoding.AgentBackendProfileSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L195).
:::

:::definition "QuantumBlockEncoding.WorkflowInvariantSpec" (lean := "QuantumBlockEncoding.WorkflowInvariantSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:203](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L203).
:::

:::definition "QuantumBlockEncoding.leanBuildGate" (lean := "QuantumBlockEncoding.leanBuildGate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:211](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L211).
:::

:::definition "QuantumBlockEncoding.noSorryGate" (lean := "QuantumBlockEncoding.noSorryGate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:217](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L217).
:::

:::definition "QuantumBlockEncoding.defaultGates" (lean := "QuantumBlockEncoding.defaultGates")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:223](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L223).
:::

:::definition "QuantumBlockEncoding.trialRecordSpec" (lean := "QuantumBlockEncoding.trialRecordSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:226](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L226).
:::

:::definition "QuantumBlockEncoding.postCycleArtifactSpecs" (lean := "QuantumBlockEncoding.postCycleArtifactSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:243](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L243).
:::

:::definition "QuantumBlockEncoding.workflowCheckSpecs" (lean := "QuantumBlockEncoding.workflowCheckSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:271](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L271).
:::

:::definition "QuantumBlockEncoding.blockEncodingLexObjectiveSpecs" (lean := "QuantumBlockEncoding.blockEncodingLexObjectiveSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:287](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L287).
:::

:::definition "QuantumBlockEncoding.lexElimSchedulerSpecs" (lean := "QuantumBlockEncoding.lexElimSchedulerSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:333](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L333).
:::

:::definition "QuantumBlockEncoding.agentPanelSizeSpecs" (lean := "QuantumBlockEncoding.agentPanelSizeSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:353](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L353).
:::

:::definition "QuantumBlockEncoding.agentBackendProfileSpecs" (lean := "QuantumBlockEncoding.agentBackendProfileSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:393](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L393).
:::

:::definition "QuantumBlockEncoding.workflowInvariantSpecs" (lean := "QuantumBlockEncoding.workflowInvariantSpecs")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:493](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L493).
:::

:::definition "QuantumBlockEncoding.threeLayerAgentContracts" (lean := "QuantumBlockEncoding.threeLayerAgentContracts")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:518](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L518).
:::

:::definition "QuantumBlockEncoding.conversionArtifacts" (lean := "QuantumBlockEncoding.conversionArtifacts")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:546](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L546).
:::

:::definition "QuantumBlockEncoding.seedAutomationTasks" (lean := "QuantumBlockEncoding.seedAutomationTasks")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:568](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L568).
:::

:::definition "QuantumBlockEncoding.automationTaskCount" (lean := "QuantumBlockEncoding.automationTaskCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Automation.lean:605](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Automation.lean#L605).
:::

# QuantumBlockEncoding/Literature.lean

6 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ImplementationStatus" (lean := "QuantumBlockEncoding.ImplementationStatus")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Literature.lean:11](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Literature.lean#L11).
:::

:::definition "QuantumBlockEncoding.PaperRole" (lean := "QuantumBlockEncoding.PaperRole")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Literature.lean:17](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Literature.lean#L17).
:::

:::definition "QuantumBlockEncoding.PaperEntry" (lean := "QuantumBlockEncoding.PaperEntry")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Literature.lean:27](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Literature.lean#L27).
:::

:::definition "QuantumBlockEncoding.literature" (lean := "QuantumBlockEncoding.literature")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Literature.lean:39](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Literature.lean#L39).
:::

:::definition "QuantumBlockEncoding.literatureCount" (lean := "QuantumBlockEncoding.literatureCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Literature.lean:219](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Literature.lean#L219).
:::

:::definition "QuantumBlockEncoding.primaryPapers" (lean := "QuantumBlockEncoding.primaryPapers")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Literature.lean:221](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Literature.lean#L221).
:::

# QuantumBlockEncoding/OpenProblems.lean

4 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ProblemStatus" (lean := "QuantumBlockEncoding.ProblemStatus")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OpenProblems.lean:13](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OpenProblems.lean#L13).
:::

:::definition "QuantumBlockEncoding.OpenProblem" (lean := "QuantumBlockEncoding.OpenProblem")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OpenProblems.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OpenProblems.lean#L19).
:::

:::definition "QuantumBlockEncoding.openProblems" (lean := "QuantumBlockEncoding.openProblems")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OpenProblems.lean:28](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OpenProblems.lean#L28).
:::

:::definition "QuantumBlockEncoding.problemCount" (lean := "QuantumBlockEncoding.problemCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OpenProblems.lean:88](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OpenProblems.lean#L88).
:::
