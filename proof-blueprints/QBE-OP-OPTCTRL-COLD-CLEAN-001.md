# Proof Blueprint: QBE-OP-OPTCTRL-COLD-CLEAN-001

Task id: `QBE-OP-OPTCTRL-COLD-CLEAN-001`
Title: Task: QBE-OP-OPTCTRL-COLD-CLEAN-001
Mode: `exploratoryConstruction`
Updated: `2026-06-21 01:23:31`
Blueprint stage: `Stage 2 DAG proof discharge`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
# Task: QBE-OP-OPTCTRL-COLD-CLEAN-001

Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## Clean-Start Rule

This task is a strict clean-start benchmark for the harness. Agents must not use previous optctrl solutions, previous ChatGPT Pro suggestions, previous Qiskit exports, previous candidate names, or old run memory. Use only this task packet, the current Lean environment, and declarations that are already present in the sandbox target file.

## Target Operator

Registers:

- time register `T`: one qubit;
- type register `tau`: one qubit;
- state register `S`: one passive qubit;
- block-encoding ancilla: start with one clean ancilla unless upper explicitly explores alternatives.

Target operator:

$$
E_1 = |0\rangle\langle 1|_T \otimes |0\rangle\langle 1|_{\tau} \otimes I_S.
$$

The system must construct a unitary candidate `U_E` and prove in Lean that its clean block equals `E_1`.

## Resource Order

Inside the same asymptotic tier, rank Lean-certified candidates lexicographically by:

1. gate count,
2. depth,
3. auxiliary qubits,
4. unresolved oracle calls.

Only Lean-certified candidates may be plotted as achieved solutions.

## Harness Requirements

- Upper and middle layers should spend real budget on construction strategy, candidate population, proof-DAG frontier, and resource-score interpretation before lower workers edit Lean.
- Natural-language lower workers may propose constructions and proofs, but acceptance requires Lean.
- Lean lower workers should prove one active leaf at a time.
- Reviewer rejects changed targets, hidden oracles, unproved optimality, and simulator-only claims.

## Required Closeout Artifacts

If unresolved, write a selected-language summary and a self-contained ChatGPT Pro prompt. If resolved, additionally write:

- a step-by-step LaTeX proof note;
- a certified evolution curve and circuit storyboard;
- Qiskit export and finite executable checks for the certified construction.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| COLD-E1-SCOPE-AUDIT-001: Audit worktree scope and unrelated legacy/tooling changes before accepting this clean-start operator closeout.; status: active reviewer audit; Lean: no Lean declaration expected | candidate |

## Open Obligation Signals

```text
target and clean projector match the task packet: Lean `coldE1Target`, `coldE1BlockProjection`; class existing Lean target; status proved target-side
stale source metadata is repaired to the clean-start task id: Lean `coldE1QueryTarget.source`; class contract drift repair; status patched and compiled in prior gate
define candidate image and matrix: Lean `coldE1CandidateImage`, `coldE1CandidateMatrix`; class internal construction leaf; status proved by lower cycle 1
finite candidate diagnostics: Lean `cold-e1-finite-verify-cycle01.feedback.json`; class verifier-feedback diagnostic; status passed; downstream block theorem proved
prove permutation or unitarity: Lean `coldE1CandidateImage_permutation_certificate`; class acceptance proof leaf; status proved as task-local image permutation package
prove clean-block equality: Lean `coldE1Candidate_blockProjection`; class root block-entry proof; status proved
certify resource tuple: Lean `coldE1HighLevelSeedCost_gateCount`, `coldE1HighLevelSeedCost_depth`, `coldE1HighLevelSeedCost_auxiliaryQubits`, `coldE1HighLevelSeedCost_oracleCalls`; class resource equality; status proved
prepare executable export: Lean export packet under `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/`; class post-Lean export; status passed finite/Qiskit diagnostic
closeout proof/status sync: Lean problem proof note, storyboard/evolution memory, and final report guardrails; class closeout documentation; status passed closeout sync
closeout scope audit: Lean current worktree contains unrelated legacy deletions plus tooling/manifest churn outside this operator construction; class reviewer/human acceptance scope; status active reviewer audit
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| structure | `BandedSparseAccessCleanupScopeDecision` | `QuantumBlockEncoding/GHL2025.lean:8059` |
| def | `bandedSparseAccessCleanupScopeDecision` | `QuantumBlockEncoding/GHL2025.lean:8079` |
| theorem | `bandedSparseAccessCleanupScopeDecision_activeGlobalSource` | `QuantumBlockEncoding/GHL2025.lean:8100` |
| theorem | `bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard` | `QuantumBlockEncoding/GHL2025.lean:8131` |
| theorem | `bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked` | `QuantumBlockEncoding/GHL2025.lean:8161` |
| theorem | `defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3` | `QuantumBlockEncoding/GHL2025.lean:8200` |
| theorem | `robinIndicatorBitPosition_ge` | `QuantumBlockEncoding/GHL2025.lean:8249` |
| theorem | `indicatorOracleImage_systemVal_preserved` | `QuantumBlockEncoding/GHL2025.lean:8259` |
| theorem | `indicatorOracleImage_isBulk_preserved` | `QuantumBlockEncoding/GHL2025.lean:8273` |
| theorem | `indicatorOracleImage_self_inverse` | `QuantumBlockEncoding/GHL2025.lean:8288` |
| theorem | `oneTermRobinGate_U_indic_dagger_selfInverseBridge` | `QuantumBlockEncoding/GHL2025.lean:8303` |
| theorem | `indicatorOracleImage_injective` | `QuantumBlockEncoding/GHL2025.lean:8314` |
| theorem | `robinIndicatorBitPosition_lt_totalQubits` | `QuantumBlockEncoding/GHL2025.lean:8325` |
| theorem | `indicatorOracleImage_lt` | `QuantumBlockEncoding/GHL2025.lean:8336` |
| theorem | `indicatorOracleImage_bijective` | `QuantumBlockEncoding/GHL2025.lean:8354` |
| theorem | `indicatorOracleMatrix_col_has_one` | `QuantumBlockEncoding/GHL2025.lean:8377` |
| theorem | `indicatorOracleMatrix_col_unique` | `QuantumBlockEncoding/GHL2025.lean:8389` |
| theorem | `indicatorOracleMatrix_row_has_one` | `QuantumBlockEncoding/GHL2025.lean:8402` |
| theorem | `indicatorOracleMatrix_row_unique` | `QuantumBlockEncoding/GHL2025.lean:8420` |
| theorem | `indicatorOracleMatrix_is_permutation` | `QuantumBlockEncoding/GHL2025.lean:8436` |
| inductive | `ImplementationStatus` | `QuantumBlockEncoding/Literature.lean:11` |
| inductive | `PaperRole` | `QuantumBlockEncoding/Literature.lean:17` |
| structure | `PaperEntry` | `QuantumBlockEncoding/Literature.lean:27` |
| def | `literature` | `QuantumBlockEncoding/Literature.lean:39` |
| def | `literatureCount` | `QuantumBlockEncoding/Literature.lean:219` |
| def | `primaryPapers` | `QuantumBlockEncoding/Literature.lean:221` |
| inductive | `ProblemStatus` | `QuantumBlockEncoding/OpenProblems.lean:13` |
| structure | `OpenProblem` | `QuantumBlockEncoding/OpenProblems.lean:19` |
| def | `openProblems` | `QuantumBlockEncoding/OpenProblems.lean:28` |
| def | `problemCount` | `QuantumBlockEncoding/OpenProblems.lean:88` |
| def | `IsPermutation` | `QuantumBlockEncoding/OptimalControl.lean:16` |
| def | `permutationMatrix` | `QuantumBlockEncoding/OptimalControl.lean:20` |
| def | `targetState0` | `QuantumBlockEncoding/OptimalControl.lean:24` |
| def | `targetState1` | `QuantumBlockEncoding/OptimalControl.lean:27` |
| def | `sourceState0` | `QuantumBlockEncoding/OptimalControl.lean:30` |
| def | `sourceState1` | `QuantumBlockEncoding/OptimalControl.lean:33` |
| def | `exampleOperator` | `QuantumBlockEncoding/OptimalControl.lean:40` |
| def | `cleanIndex` | `QuantumBlockEncoding/OptimalControl.lean:49` |
| def | `cleanBlock` | `QuantumBlockEncoding/OptimalControl.lean:53` |
| def | `IsExactTransferBlockEncoding` | `QuantumBlockEncoding/OptimalControl.lean:57` |
| def | `exampleTarget` | `QuantumBlockEncoding/OptimalControl.lean:61` |
| def | `exampleLayout` | `QuantumBlockEncoding/OptimalControl.lean:68` |
| theorem | `exampleOperator_source0` | `QuantumBlockEncoding/OptimalControl.lean:73` |
| theorem | `exampleOperator_source1` | `QuantumBlockEncoding/OptimalControl.lean:77` |
| theorem | `exampleOperator_reverse0` | `QuantumBlockEncoding/OptimalControl.lean:81` |
| theorem | `exampleOperator_reverse1` | `QuantumBlockEncoding/OptimalControl.lean:85` |
| structure | `Resource` | `QuantumBlockEncoding/Resources.lean:21` |
| def | `gates` | `QuantumBlockEncoding/Resources.lean:32` |
| def | `add` | `QuantumBlockEncoding/Resources.lean:34` |
| def | `parallel` | `QuantumBlockEncoding/Resources.lean:45` |
| def | `scale` | `QuantumBlockEncoding/Resources.lean:55` |
| def | `ofCounts` | `QuantumBlockEncoding/Resources.lean:62` |
| def | `ofCountsWithDepth` | `QuantumBlockEncoding/Resources.lean:68` |
| inductive | `CostExpr` | `QuantumBlockEncoding/Resources.lean:96` |
| def | `atoms` | `QuantumBlockEncoding/Resources.lean:116` |
| structure | `AsymptoticResource` | `QuantumBlockEncoding/Resources.lean:122` |
| def | `add` | `QuantumBlockEncoding/Resources.lean:129` |
| def | `bandedSparseAccessResource` | `QuantumBlockEncoding/Resources.lean:138` |
| def | `sparseAmplitudeOracleResource` | `QuantumBlockEncoding/Resources.lean:145` |
| def | `indicatorResource` | `QuantumBlockEncoding/Resources.lean:149` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-OP-OPTCTRL-COLD-CLEAN-001.md` | task/proof map |
| `conversion-windows/QBE-OP-OPTCTRL-COLD-CLEAN-001.md` | Lean/natural-language conversion |
| `proof-obligations/QBE-OP-OPTCTRL-COLD-CLEAN-001.md` | open obligations |

## Latest Dialogue Signal

````text
tion depends on source target, candidate image/matrix, finite diagnostic, permutation package, and resource field theorems; all are compiled. COLD-E1-EXPORT-001 finite/Qiskit check reports error_class=none, so next objective is closeout synchronization: refresh final audit/status, latest.tex, memory_digest.md, todo.md, and retrieval index. Do not reopen COLD-E1-BLOCK-001, COLD-E1-RESOURCE-001, or candidate search; do not accept unrelated legacy deletions/tool churn without explicit cleanup approval.

## 2026-06-21 01:07:34 - upper

Upper synthesis: exploratory operator construction with Lean core and COLD-E1-EXPORT-001 diagnostic closed. Retire COLD-E1-BLOCK-001, COLD-E1-RESOURCE-001, COLD-E1-PERM-UNITARY-001, and COLD-E1-EXPORT-001; next objective is middle/reviewer closeout synchronization of final audit, LaTeX proof note, memory_digest/todo/retrieval index, and explicit scope review for unrelated legacy deletions/tooling churn. No lower Lean proof search unless a concrete export/Lean mismatch appears.

## 2026-06-21 01:19:33 - middle

Middle source-correspondence closeout sync: COLD-E1-EXPORT-001 and COLD-E1-CLOSEOUT-SYNC-001 are retired for COLD-CLEAN-PERM-001. Refreshed conversion window, proof obligations, candidate population, blueprint, retrieval index, final audit, problem LaTeX proof note, certified evolution/storyboard report, current run digest/todo, and middle verifier memory. Lean target remains coldE1Candidate_blockProjection with permutation package coldE1CandidateImage_permutation_certificate and resource tuple from coldE1HighLevelSeedCost_*; export finite/Qiskit feedback has error_class=none. No lower proof search is active; next route is reviewer gate/scope audit for unrelated cleanup. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests.

## 2026-06-21 01:19:53 - middle

Middle report/export closeout sync complete: final audit page, problem LaTeX proof note plus run snapshot, proof blueprint/retrieval index, candidate/proof-obligation/conversion ledgers, memory_digest.md, and todo.md now mark COLD-E1-EXPORT-001 and COLD-E1-CLOSEOUT-SYNC-001 retired after finite/Qiskit feedback passed with error_class=none. Export diagnostic, python3 tools/qbe.py check, and lake build && lake build Tests passed. Remaining blocker is scope hygiene for unrelated legacy deletions/tooling churn; hardware optimality, primitive gate decomposition, lower bounds, and stronger matrix-unitarity remain forbidden claims.

## 2026-06-21 01:20:19 - middle

Middle memory handoff: COLD-E1-BLOCK-001, COLD-E1-PERM-UNITARY-001, COLD-E1-RESOURCE-001, COLD-E1-EXPORT-001, and COLD-E1-CLOSEOUT-SYNC-001 are retired/synchronized for COLD-CLEAN-PERM-001. No active lower proof leaf remains; next route is reviewer gate plus scope audit for unrelated legacy deletions/tooling churn. Typed memory card: verifier-feedback/QBE-OP-OPTCTRL-COLD-CLEAN-001/middle-cycle02-export-memory-card.md. Gates passed: python3 tools/qbe.py check; lake build; lake build Tests.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts inner-cycle progress only through `python3 tools/qbe.py check`
  and synchronized Lean-to-natural-language proof status.  LaTeX exports are
  checked at 6h/convergence closeout.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
