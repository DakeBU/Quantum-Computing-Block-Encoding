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

Reader orientation: Typed controller state, agent contracts, literature memory, and explicit open-problem records. Each card separates an accessible
reading cue from formal status, the source docstring, and the authoritative Lean panel.
The standalone Library Explorer adds full-text search and filters across every chapter.

# QuantumBlockEncoding/Automation.lean

39 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.AutomationStage" (lean := "QuantumBlockEncoding.AutomationStage")
*Plain-English reading.* This type lists the allowed alternatives for “automation stage”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:12](../../../../library/modules/automation/#decl-quantumblockencoding-automationstage). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TaskKind" (lean := "QuantumBlockEncoding.TaskKind")
*Plain-English reading.* This type lists the allowed alternatives for “task kind”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:22](../../../../library/modules/automation/#decl-quantumblockencoding-taskkind). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TaskStatus" (lean := "QuantumBlockEncoding.TaskStatus")
*Plain-English reading.* This type lists the allowed alternatives for “task status”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:33](../../../../library/modules/automation/#decl-quantumblockencoding-taskstatus). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ArtifactLanguage" (lean := "QuantumBlockEncoding.ArtifactLanguage")
*Plain-English reading.* This type lists the allowed alternatives for “artifact language”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:41](../../../../library/modules/automation/#decl-quantumblockencoding-artifactlanguage). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AgentRole" (lean := "QuantumBlockEncoding.AgentRole")
*Plain-English reading.* This type lists the allowed alternatives for “agent role”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:49](../../../../library/modules/automation/#decl-quantumblockencoding-agentrole). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AgentBackendKind" (lean := "QuantumBlockEncoding.AgentBackendKind")
*Plain-English reading.* This type lists the allowed alternatives for “agent backend kind”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:56](../../../../library/modules/automation/#decl-quantumblockencoding-agentbackendkind). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TrialKind" (lean := "QuantumBlockEncoding.TrialKind")
*Plain-English reading.* This type lists the allowed alternatives for “trial kind”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:67](../../../../library/modules/automation/#decl-quantumblockencoding-trialkind). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TrialStatus" (lean := "QuantumBlockEncoding.TrialStatus")
*Plain-English reading.* This type lists the allowed alternatives for “trial status”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:77](../../../../library/modules/automation/#decl-quantumblockencoding-trialstatus). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ArtifactSpec" (lean := "QuantumBlockEncoding.ArtifactSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “artifact spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:87](../../../../library/modules/automation/#decl-quantumblockencoding-artifactspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AcceptanceGate" (lean := "QuantumBlockEncoding.AcceptanceGate")
*Plain-English reading.* This record groups the data and proof fields needed for “acceptance gate”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:94](../../../../library/modules/automation/#decl-quantumblockencoding-acceptancegate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AutomationTask" (lean := "QuantumBlockEncoding.AutomationTask")
*Plain-English reading.* This record groups the data and proof fields needed for “automation task”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:101](../../../../library/modules/automation/#decl-quantumblockencoding-automationtask). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AgentContract" (lean := "QuantumBlockEncoding.AgentContract")
*Plain-English reading.* This record groups the data and proof fields needed for “agent contract”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:113](../../../../library/modules/automation/#decl-quantumblockencoding-agentcontract). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TrialRecordSpec" (lean := "QuantumBlockEncoding.TrialRecordSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “trial record spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:120](../../../../library/modules/automation/#decl-quantumblockencoding-trialrecordspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PostCycleArtifactKind" (lean := "QuantumBlockEncoding.PostCycleArtifactKind")
*Plain-English reading.* This type lists the allowed alternatives for “post cycle artifact kind”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:127](../../../../library/modules/automation/#decl-quantumblockencoding-postcycleartifactkind). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PostCycleArtifactSpec" (lean := "QuantumBlockEncoding.PostCycleArtifactSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “post cycle artifact spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:135](../../../../library/modules/automation/#decl-quantumblockencoding-postcycleartifactspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.WorkflowCheckSpec" (lean := "QuantumBlockEncoding.WorkflowCheckSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “workflow check spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:142](../../../../library/modules/automation/#decl-quantumblockencoding-workflowcheckspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CandidatePool" (lean := "QuantumBlockEncoding.CandidatePool")
*Plain-English reading.* This type lists the allowed alternatives for “candidate pool”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:149](../../../../library/modules/automation/#decl-quantumblockencoding-candidatepool). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.LexElimSchedulerMode" (lean := "QuantumBlockEncoding.LexElimSchedulerMode")
*Plain-English reading.* This type lists the allowed alternatives for “lex elim scheduler mode”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:154](../../../../library/modules/automation/#decl-quantumblockencoding-lexelimschedulermode). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.LexObjectiveClass" (lean := "QuantumBlockEncoding.LexObjectiveClass")
*Plain-English reading.* This type lists the allowed alternatives for “lex objective class”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Automation.lean:159](../../../../library/modules/automation/#decl-quantumblockencoding-lexobjectiveclass). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.LexObjectiveSpec" (lean := "QuantumBlockEncoding.LexObjectiveSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “lex objective spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:168](../../../../library/modules/automation/#decl-quantumblockencoding-lexobjectivespec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.LexElimSchedulerSpec" (lean := "QuantumBlockEncoding.LexElimSchedulerSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “lex elim scheduler spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:176](../../../../library/modules/automation/#decl-quantumblockencoding-lexelimschedulerspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AgentPanelSizeSpec" (lean := "QuantumBlockEncoding.AgentPanelSizeSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “agent panel size spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:185](../../../../library/modules/automation/#decl-quantumblockencoding-agentpanelsizespec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.AgentBackendProfileSpec" (lean := "QuantumBlockEncoding.AgentBackendProfileSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “agent backend profile spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:195](../../../../library/modules/automation/#decl-quantumblockencoding-agentbackendprofilespec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.WorkflowInvariantSpec" (lean := "QuantumBlockEncoding.WorkflowInvariantSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “workflow invariant spec”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Automation.lean:203](../../../../library/modules/automation/#decl-quantumblockencoding-workflowinvariantspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.leanBuildGate" (lean := "QuantumBlockEncoding.leanBuildGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “lean build gate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:211](../../../../library/modules/automation/#decl-quantumblockencoding-leanbuildgate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.noSorryGate" (lean := "QuantumBlockEncoding.noSorryGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “no sorry gate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:217](../../../../library/modules/automation/#decl-quantumblockencoding-nosorrygate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.defaultGates" (lean := "QuantumBlockEncoding.defaultGates")
*Plain-English reading.* This definition gives the library's named construction or computation for “default gates”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:223](../../../../library/modules/automation/#decl-quantumblockencoding-defaultgates). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.trialRecordSpec" (lean := "QuantumBlockEncoding.trialRecordSpec")
*Plain-English reading.* This definition gives the library's named construction or computation for “trial record spec”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:226](../../../../library/modules/automation/#decl-quantumblockencoding-trialrecordspec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.postCycleArtifactSpecs" (lean := "QuantumBlockEncoding.postCycleArtifactSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “post cycle artifact specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:243](../../../../library/modules/automation/#decl-quantumblockencoding-postcycleartifactspecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.workflowCheckSpecs" (lean := "QuantumBlockEncoding.workflowCheckSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “workflow check specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:271](../../../../library/modules/automation/#decl-quantumblockencoding-workflowcheckspecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.blockEncodingLexObjectiveSpecs" (lean := "QuantumBlockEncoding.blockEncodingLexObjectiveSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “block encoding lex objective specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:287](../../../../library/modules/automation/#decl-quantumblockencoding-blockencodinglexobjectivespecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.lexElimSchedulerSpecs" (lean := "QuantumBlockEncoding.lexElimSchedulerSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “lex elim scheduler specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:333](../../../../library/modules/automation/#decl-quantumblockencoding-lexelimschedulerspecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.agentPanelSizeSpecs" (lean := "QuantumBlockEncoding.agentPanelSizeSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “agent panel size specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:353](../../../../library/modules/automation/#decl-quantumblockencoding-agentpanelsizespecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.agentBackendProfileSpecs" (lean := "QuantumBlockEncoding.agentBackendProfileSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “agent backend profile specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:393](../../../../library/modules/automation/#decl-quantumblockencoding-agentbackendprofilespecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.workflowInvariantSpecs" (lean := "QuantumBlockEncoding.workflowInvariantSpecs")
*Plain-English reading.* This definition gives the library's named construction or computation for “workflow invariant specs”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:493](../../../../library/modules/automation/#decl-quantumblockencoding-workflowinvariantspecs). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.threeLayerAgentContracts" (lean := "QuantumBlockEncoding.threeLayerAgentContracts")
*Plain-English reading.* This definition gives the library's named construction or computation for “three layer agent contracts”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:518](../../../../library/modules/automation/#decl-quantumblockencoding-threelayeragentcontracts). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.conversionArtifacts" (lean := "QuantumBlockEncoding.conversionArtifacts")
*Plain-English reading.* This definition gives the library's named construction or computation for “conversion artifacts”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:546](../../../../library/modules/automation/#decl-quantumblockencoding-conversionartifacts). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.seedAutomationTasks" (lean := "QuantumBlockEncoding.seedAutomationTasks")
*Plain-English reading.* This definition gives the library's named construction or computation for “seed automation tasks”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:568](../../../../library/modules/automation/#decl-quantumblockencoding-seedautomationtasks). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.automationTaskCount" (lean := "QuantumBlockEncoding.automationTaskCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “automation task count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Automation.lean:605](../../../../library/modules/automation/#decl-quantumblockencoding-automationtaskcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/AutomationTrace.lean

15 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ThreeLayerPhase" (lean := "QuantumBlockEncoding.ThreeLayerPhase")
*Plain-English reading.* This type lists the allowed alternatives for “three layer phase”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/AutomationTrace.lean:15](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayerphase). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerHandoff" (lean := "QuantumBlockEncoding.ThreeLayerHandoff")
*Plain-English reading.* This record groups the data and proof fields needed for “three layer handoff”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/AutomationTrace.lean:24](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayerhandoff). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerHandoff.validFlag" (lean := "QuantumBlockEncoding.ThreeLayerHandoff.validFlag")
*Plain-English reading.* This definition gives the library's named construction or computation for “valid flag”. Executable transition guard.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Executable transition guard. Acceptance is possible only from review.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:35](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayerhandoff-validflag). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerHandoff.valid" (lean := "QuantumBlockEncoding.ThreeLayerHandoff.valid")
*Plain-English reading.* This definition gives the library's named construction or computation for “valid”. Propositional view of the executable transition guard.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Propositional view of the executable transition guard.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:48](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayerhandoff-valid). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerTrace" (lean := "QuantumBlockEncoding.ThreeLayerTrace")
*Plain-English reading.* This record groups the data and proof fields needed for “three layer trace”. A proposition-valued field is a requirement until a constructor supplies it. One execution trace with an explicit starting phase.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* One execution trace with an explicit starting phase.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/AutomationTrace.lean:56](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayertrace). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerTrace.advance" (lean := "QuantumBlockEncoding.ThreeLayerTrace.advance")
*Plain-English reading.* This definition gives the library's named construction or computation for “advance”. Follow a handoff only when it starts at the current phase and is valid.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Follow a handoff only when it starts at the current phase and is valid.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:62](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayertrace-advance). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerTrace.finalPhase" (lean := "QuantumBlockEncoding.ThreeLayerTrace.finalPhase")
*Plain-English reading.* This definition gives the library's named construction or computation for “final phase”. Execute a trace left-to-right, rejecting the first invalid handoff.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Execute a trace left-to-right, rejecting the first invalid handoff.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:68](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayertrace-finalphase). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ThreeLayerTrace.allValid" (lean := "QuantumBlockEncoding.ThreeLayerTrace.allValid")
*Plain-English reading.* This definition gives the library's named construction or computation for “all valid”. Every handoff in a trace is locally valid.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Every handoff in a trace is locally valid.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:72](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayertrace-allvalid). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.threeLayerCanonicalTrace" (lean := "QuantumBlockEncoding.threeLayerCanonicalTrace")
*Plain-English reading.* This definition gives the library's named construction or computation for “three layer canonical trace”. Canonical upper-to-reviewer trace used as the finite teaching witness.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Canonical upper-to-reviewer trace used as the finite teaching witness.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:76](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayercanonicaltrace). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.threeLayerCanonicalTrace_allValid" (lean := "QuantumBlockEncoding.threeLayerCanonicalTrace_allValid")
*Plain-English reading.* Lean checks the proposition indexed as “three layer canonical trace all valid”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/AutomationTrace.lean:109](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayercanonicaltrace-allvalid). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.threeLayerCanonicalTrace_reachesAccepted" (lean := "QuantumBlockEncoding.threeLayerCanonicalTrace_reachesAccepted")
*Plain-English reading.* Lean checks the proposition indexed as “three layer canonical trace reaches accepted”; the hypotheses and conclusion in the code panel fix its exact scope. The canonical trace reaches acceptance without an external semantic axiom.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The canonical trace reaches acceptance without an external semantic axiom.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/AutomationTrace.lean:117](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayercanonicaltrace-reachesaccepted). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.threeLayerAccepted_requiresLeanGate" (lean := "QuantumBlockEncoding.threeLayerAccepted_requiresLeanGate")
*Plain-English reading.* Lean checks the proposition indexed as “three layer accepted requires lean gate”; the hypotheses and conclusion in the code panel fix its exact scope. Any locally valid acceptance transition records a passing Lean gate.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Any locally valid acceptance transition records a passing Lean gate.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/AutomationTrace.lean:122](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayeraccepted-requiresleangate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.threeLayerAccepted_requiresReviewerApproval" (lean := "QuantumBlockEncoding.threeLayerAccepted_requiresReviewerApproval")
*Plain-English reading.* Lean checks the proposition indexed as “three layer accepted requires reviewer approval”; the hypotheses and conclusion in the code panel fix its exact scope. Any locally valid acceptance transition also records reviewer approval.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Any locally valid acceptance transition also records reviewer approval.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/AutomationTrace.lean:134](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayeraccepted-requiresreviewerapproval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.threeLayerFailedGateTrace" (lean := "QuantumBlockEncoding.threeLayerFailedGateTrace")
*Plain-English reading.* This definition gives the library's named construction or computation for “three layer failed gate trace”. Removing the final Lean gate prevents the same trace from being accepted.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Removing the final Lean gate prevents the same trace from being accepted.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/AutomationTrace.lean:146](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayerfailedgatetrace). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.threeLayerFailedGateTrace_notAccepted" (lean := "QuantumBlockEncoding.threeLayerFailedGateTrace_notAccepted")
*Plain-English reading.* Lean checks the proposition indexed as “three layer failed gate trace not accepted”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/AutomationTrace.lean:158](../../../../library/modules/automationtrace/#decl-quantumblockencoding-threelayerfailedgatetrace-notaccepted). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/Literature.lean

6 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ImplementationStatus" (lean := "QuantumBlockEncoding.ImplementationStatus")
*Plain-English reading.* This type lists the allowed alternatives for “implementation status”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Literature.lean:11](../../../../library/modules/literature/#decl-quantumblockencoding-implementationstatus). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PaperRole" (lean := "QuantumBlockEncoding.PaperRole")
*Plain-English reading.* This type lists the allowed alternatives for “paper role”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Literature.lean:17](../../../../library/modules/literature/#decl-quantumblockencoding-paperrole). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PaperEntry" (lean := "QuantumBlockEncoding.PaperEntry")
*Plain-English reading.* This record groups the data and proof fields needed for “paper entry”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Literature.lean:27](../../../../library/modules/literature/#decl-quantumblockencoding-paperentry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.literature" (lean := "QuantumBlockEncoding.literature")
*Plain-English reading.* This definition gives the library's named construction or computation for “literature”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Literature.lean:39](../../../../library/modules/literature/#decl-quantumblockencoding-literature). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.literatureCount" (lean := "QuantumBlockEncoding.literatureCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “literature count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Literature.lean:230](../../../../library/modules/literature/#decl-quantumblockencoding-literaturecount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primaryPapers" (lean := "QuantumBlockEncoding.primaryPapers")
*Plain-English reading.* This definition gives the library's named construction or computation for “primary papers”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Literature.lean:232](../../../../library/modules/literature/#decl-quantumblockencoding-primarypapers). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/OpenProblems.lean

4 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ProblemStatus" (lean := "QuantumBlockEncoding.ProblemStatus")
*Plain-English reading.* This type lists the allowed alternatives for “problem status”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/OpenProblems.lean:13](../../../../library/modules/openproblems/#decl-quantumblockencoding-problemstatus). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.OpenProblem" (lean := "QuantumBlockEncoding.OpenProblem")
*Plain-English reading.* This record groups the data and proof fields needed for “open problem”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/OpenProblems.lean:19](../../../../library/modules/openproblems/#decl-quantumblockencoding-openproblem). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.openProblems" (lean := "QuantumBlockEncoding.openProblems")
*Plain-English reading.* This definition gives the library's named construction or computation for “open problems”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OpenProblems.lean:28](../../../../library/modules/openproblems/#decl-quantumblockencoding-openproblems). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.problemCount" (lean := "QuantumBlockEncoding.problemCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “problem count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OpenProblems.lean:88](../../../../library/modules/openproblems/#decl-quantumblockencoding-problemcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/OpenProblemsAudit.lean

6 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.openProblemIds" (lean := "QuantumBlockEncoding.openProblemIds")
*Plain-English reading.* This definition gives the library's named construction or computation for “open problem ids”. Stable list of the published problem identifiers.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Stable list of the published problem identifiers.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OpenProblemsAudit.lean:18](../../../../library/modules/openproblemsaudit/#decl-quantumblockencoding-openproblemids). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.OpenProblem.actionable" (lean := "QuantumBlockEncoding.OpenProblem.actionable")
*Plain-English reading.* This definition gives the library's named construction or computation for “actionable”. Every public registry entry carries enough data to be actionable.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Every public registry entry carries enough data to be actionable.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OpenProblemsAudit.lean:21](../../../../library/modules/openproblemsaudit/#decl-quantumblockencoding-openproblem-actionable). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.openProblems_count" (lean := "QuantumBlockEncoding.openProblems_count")
*Plain-English reading.* Lean checks the proposition indexed as “open problems count”; the hypotheses and conclusion in the code panel fix its exact scope. The current registry contains seven explicitly scoped problems.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The current registry contains seven explicitly scoped problems.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OpenProblemsAudit.lean:33](../../../../library/modules/openproblemsaudit/#decl-quantumblockencoding-openproblems-count). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.openProblemIds_nodup" (lean := "QuantumBlockEncoding.openProblemIds_nodup")
*Plain-English reading.* Lean checks the proposition indexed as “open problem ids nodup”; the hypotheses and conclusion in the code panel fix its exact scope. Problem identifiers are unique, so memories and task packets cannot collide.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Problem identifiers are unique, so memories and task packets cannot collide.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OpenProblemsAudit.lean:37](../../../../library/modules/openproblemsaudit/#decl-quantumblockencoding-openproblemids-nodup). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.openProblems_all_actionable" (lean := "QuantumBlockEncoding.openProblems_all_actionable")
*Plain-English reading.* Lean checks the proposition indexed as “open problems all actionable”; the hypotheses and conclusion in the code panel fix its exact scope. Every current problem has a nonempty statement, acceptance test, and source list.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* Every current problem has a nonempty statement, acceptance test, and source list.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OpenProblemsAudit.lean:41](../../../../library/modules/openproblemsaudit/#decl-quantumblockencoding-openproblems-all-actionable). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.openProblemRegistry_compiled" (lean := "QuantumBlockEncoding.openProblemRegistry_compiled")
*Plain-English reading.* Lean checks the proposition indexed as “open problem registry compiled”; the hypotheses and conclusion in the code panel fix its exact scope. The registry itself is a compiled artifact even though its entries remain open research.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Typed controller state, agent contracts, literature memory, and explicit open-problem records.

*Technical source note.* The registry itself is a compiled artifact even though its entries remain open research.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OpenProblemsAudit.lean:49](../../../../library/modules/openproblemsaudit/#decl-quantumblockencoding-openproblemregistry-compiled). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::
