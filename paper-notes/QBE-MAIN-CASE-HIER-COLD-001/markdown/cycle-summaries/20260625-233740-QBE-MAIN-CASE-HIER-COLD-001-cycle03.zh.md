# 中文循环总结：QBE-MAIN-CASE-HIER-COLD-001 cycle 3

生成时间：`2026-06-26 00:25:42`

Run 目录：`runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03`

任务标题：Main case transfer-operator block encoding, no-Pro isolated Hierarchical Harness

这个文件是每轮长跑/收敛循环的人类审计入口。它不替代 Lean 证明；它负责告诉人类和下一轮 agent：当前有没有真正的 block-encoding 证书、哪些只是诊断、哪些曲线不能画成最终结果。

## 本轮验收结论

当前任务是 operator-first block-encoding construction，不是 GHL 论文复现。人类应首先检查：目标 operator、normalizer、clean projector、误差 tolerance、资源排序和 candidate population 是否清楚。

## 母语输入与系统入口

- 输出语言由 `--report-language <lang>` 或 `QBE_REPORT_LANGUAGE=<lang>` 控制；原始用户输入应通过 `task-inbox/` 或 `ingest-user-problem` 保留。

## Exact / Approximate / 自适应阶段曲线状态

- 尚未检测到该任务的专用 certified evolution curve；只有 Lean 命名 theorem 支持的 candidate 才能画成 achieved point。

## 外部系统公平对比状态

- 外部 verifier 可作为 pre-Lean diagnostic 或 post-Lean executable export；不能替代 Lean theorem closure。

## 当前 Lean 编译/`sorry` 状态

- 当前没有检测到 `sorry`。

## 当前动态 proof-DAG leaf

- MAIN-CANDIDATE-PACKAGE-001: Package the COLD candidate and verified certificate without changing the target or hiding resource assumptions.; status: active leaf; Lean: `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`
- MAIN-EXPORT-001: Create Qiskit and QASM3 exports for `r=1,k=1,passiveQubits=1`.; status: blocked until Lean certificate; Lean: export manifest and checks

## 当前未完成义务信号

- add COLD task-local Lean target surface: Lean `mainCaseCold*` declarations in `QuantumBlockEncoding/MainCase.lean`; class internal construction leaf; status proved
- keep task file imported into the library: Lean `import QuantumBlockEncoding.MainCase` in `QuantumBlockEncoding.lean`; class build integration; status present
- define matrix/operator target `A`: Lean `mainCaseColdTarget`; class source translation; status proved
- define clean projector/embedding: Lean `mainCaseColdCleanEmbed`; class shape/register; status proved
- define candidate unitary matrix: Lean `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`; class candidate construction; status proved
- prove clean-block equality: Lean `mainCaseColdPartialPerm_clean_eq_target`; class symbolic bridge; status proved
- prove permutation/unitarity: Lean `mainCaseColdPartialPermImage_bijective`; later unitary theorem if needed; class unitarity layer; status finite bijection proved; retired from active queue
- state operator-first target metadata: Lean `mainCaseColdQueryTarget`; class source translation; status proved
- state project-local block projection and prove candidate matrix satisfies it: Lean `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection`; class semantic bridge; status proved
- make normalizer explicit: Lean `mainCaseColdExactNormalizer = 1`; class source translation; status compiled
- make auxiliary qubit count explicit: Lean `mainCaseColdSourceLayout_auxiliaryQubits`, `mainCaseColdPartialPermCost_auxiliaryQubits`; class resource layer; status proved
- make resource tuple explicit: Lean field theorems for `(gateCount, depth, auxiliaryQubits, oracleCalls)`; class resource layer; status proved as `(5,5,1,0)` after COLD-local circuit schema
- package COLD candidate and verified certificate: Lean `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`; class candidate packaging; status active next leaf; resource tuple now ready
- compare against baseline: Lean candidate-population row for `MAIN-PARTIAL-PERM-001`; class exploratory memory; status updated with compiled resource tuple; full candidate ranking still awaits verified package
- run gate: Lean `python3 tools/qbe.py check`; class project gate; status required after edits

## 最近 typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| MAIN-RESOURCE-001 | None | True | True | MAIN-CANDIDATE-PACKAGE-001: package mainCaseColdPartialPermCandidate and mainCaseColdPartialPermVerified from the compiled finite-permutation, block-projection, and resource declarations. |
| MAIN-RESOURCE-001 | symbolic_bridge_gap | True | True | Implement MAIN-RESOURCE-SCHEMA-001: mainCaseColdCircuit, mainCaseColdSchedule, mainCaseColdLogicalResource, mainCaseColdPartialPermCost, and cost field theorems; then gate. |
| MAIN-RESOURCE-001 | symbolic_bridge_gap | True | True | MAIN-RESOURCE-001: derive a COLD-local circuit/schedule or named resource model, then prove mainCaseColdPartialPermCost_* field theorems before candidate packaging or export. |
| MAIN-BLOCK-PROJECTION-001 | None | True | True | MAIN-RESOURCE-001: derive a COLD-local circuit/schedule and honest resource tuple, prove cost field theorems, and keep candidate packaging/export blocked until those compile. |
| MAIN-PERM-UNITARY-001 | None | True | True | MAIN-BLOCK-PROJECTION-001: define the COLD QueryOperatorTarget and block-projection predicate; keep resource/candidate packaging and the matrix-unitary bridge conditional unless the reviewer requires a stronger semantic tier. |
| MAIN-PERM-UNITARY-001 | None | True | True | MAIN-BLOCK-PROJECTION-001: define mainCaseColdQueryTarget, mainCaseColdBlockProjection, and prove mainCaseColdPartialPerm_blockProjection before resource or export work. |
| MAIN-PERM-UNITARY-001 | None | True | True | MAIN-RESOURCE-001 or a narrow matrix-unitary bridge if the next semantic tier requires it |
| MAIN-PERM-UNITARY-001 | symbolic_bridge_gap | True | True | Prove mainCaseColdPartialPermImage_bijective by finite native_decide/case split over Fin 16, then connect that task-local permutation certificate to the project unitary/verified-candidate layer before resource or export work. |

## 下一轮 lower-agent 分工

| 角色 | 目标 | 产物 |
| --- | --- | --- |
| lower-1-natural-language-proof-architect | Translate the active source-paper proof step into a dependency DAG with exact source anchors and external-lemma calls. | proof-attempts/<task>/...-natural-language-dag.md |
| lower-2-lean-implementation-worker | Close one active Lean leaf only, preferably the smallest entry/evalWith bridge selected by the blueprint. | Lean declaration plus trial-log verifier-feedback fields |
| lower-3-necessary-condition-verifier | Check exact finite matrix/path/support conditions that must hold before the active Lean leaf can be true. | verifier-feedback/<task>/... plus trial-log feedback fields |

## 下一轮计划

- upper 先刷新目标和资源 metric；middle 写 proof-DAG；lower 每次只关闭一个 active leaf。

## 本轮 dialogue 末尾

```text
ialPermImage, proposed logical tuple is (gateCount,depth,auxiliaryQubits,oracleCalls)=(5,4,1,0), but closed_theorem_ok=false until mainCaseColdCircuit/mainCaseColdSchedule/mainCaseColdLogicalResource/mainCaseColdPartialPermCost_* compile. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 2026-06-26 00:20:17 - lower

Closed MAIN-RESOURCE-001 at the high-level logical resource tier. Added COLD-local circuit/schema declarations in QuantumBlockEncoding/MainCase.lean: mainCaseColdCircuit, mainCaseColdSchedule, mainCaseColdCircuitImage_eq_partialPermImage, mainCaseColdHighLevelResource, mainCaseColdPartialPermCost, and cost field theorems for score (gateCount,depth,auxiliaryQubits,oracleCalls)=(5,5,1,0). Did not promote mainCaseColdResourceSchemaObligation.proved and did not package a candidate. Next exact Lean leaf: MAIN-CANDIDATE-PACKAGE-001, define mainCaseColdPartialPermCandidate and mainCaseColdPartialPermVerified from existing finite-permutation, block-projection, and resource declarations. Gate passed: python3 tools/qbe.py check.

## 2026-06-26 00:25:04 - reviewer

Reviewer gate: accepted COLD cycle-3 progress only through MAIN-RESOURCE-001 high-level logical resource tier. Compiled evidence includes mainCaseColdPartialPerm_blockProjection, mainCaseColdCircuitImage_eq_partialPermImage, and mainCaseColdPartialPermCost_* score (5,5,1,0). Blocking for full task/export: no mainCaseColdPartialPermCandidate or mainCaseColdPartialPermVerified package yet; Qiskit/QASM3 remains blocked. Advisory: hidden-shortcut scan finds pre-existing RobinMatrix diagnostic sorry outside this COLD diff; COLD did not promote a proved semantic boolean. Next leaf MAIN-CANDIDATE-PACKAGE-001, with optional COLD rational-orthogonality bridge if semantic tier requires it.
```

## 当前未提交文件

- `.github/workflows/pages.yml`
- `MANIFEST.md`
- `QuantumBlockEncoding/BlockEncodingClassics.lean`
- `QuantumBlockEncoding/MainCase.lean`
- `Tests/Basic.lean`
- `candidate-populations/QBE-MAIN-CASE-HIER-COLD-001.md`
- `candidate-populations/QBE-MAIN-CASE-HIER-PRO-001.md`
- `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`
- `conversion-windows/QBE-MAIN-CASE-HIER-PRO-001.md`
- `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle02-main-perm-unitary.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle03-main-resource.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-resource-schema-cycle03.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-lower-packets-cycle03-main-resource.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle02.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle03.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-circuit-image-lower-architect-20260625-2327.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-middle-source-contract-cycle01.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-middle-source-contract-cycle02.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-middle-source-contract-cycle03.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-ortho-bridge-lower-architect-cycle02.md`
- `proof-blueprints/QBE-MAIN-CASE-HIER-COLD-001.md`
- `proof-blueprints/QBE-MAIN-CASE-HIER-PRO-001.md`
- `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md`
- `proof-obligations/QBE-MAIN-CASE-HIER-PRO-001.md`
- `reports/QBE-MAIN-CASE-HIER-COLD-001/`
- `research-wiki/retrieval-index/QBE-MAIN-CASE-HIER-COLD-001.json`
- `research-wiki/retrieval-index/QBE-MAIN-CASE-HIER-PRO-001.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-block-projection-cycle03.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-block-projection-cycle03.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-clean-entry-cycle02.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-clean-entry-cycle02.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-bijection-cycle03.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-bijection-cycle03.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle02.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle02.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle02.py`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle03-sync.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-perm-unitary-cycle03-sync.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-resource-cycle03.feedback.json`

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
