# 中文循环总结：QBE-MAIN-CASE-HIER-COLD-001 cycle 2

生成时间：`2026-06-27 13:32:26`

Run 目录：`runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

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

- MAIN-EXPORT-IMPLEMENT-001: Create Qiskit and QASM3 exports for `r=1,k=1,passiveQubits=1`.; status: active post-Lean leaf; code/checks pending; Lean: `qiskit/`, `qasm3/`, manifest

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
- package COLD candidate and verified certificate: Lean `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`, `mainCaseColdPartialPermCandidate_cost`; class candidate packaging; status proved
- compare against baseline: Lean candidate-population row for `MAIN-PARTIAL-PERM-001`; class exploratory memory; status updated with compiled verified package and resource tuple
- run gate: Lean `python3 tools/qbe.py check`; class project gate; status passed after candidate-package and test updates

## 最近 typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| MAIN-EXPORT-VERIFY-001 | None | True | True | Reviewer should audit the post-Lean executable artifacts against the named Lean certificate. |
| MAIN-EXPORT-VERIFY-001 | source_translation_gap | False | False | Generate qiskit/qasm3/manifest artifacts for mainCaseColdPartialPermVerified using q[0]=S,q[1]=tau,q[2]=T,q[3]=signal, then rerun this verifier. |
| MAIN-EXPORT-MAP-001 | shape_or_register_gap | None | None | Generate Qiskit/QASM3/manifest artifacts from mainCaseColdPartialPermVerified using q[0]=S, q[1]=tau, q[2]=T, q[3]=signal, then rerun the export verifier. |
| MAIN-EXPORT-MAP-001 | None | None | None | MAIN-EXPORT-IMPLEMENT-001: generate Qiskit/QASM3/manifest artifacts using q[0]=S, q[1]=tau, q[2]=T, q[3]=signal, then rerun the export verifier. |
| MAIN-EXPORT-001 | stale_leaf |  |  | Generate Qiskit/QASM3 artifacts from mainCaseColdPartialPermVerified and run deterministic export verifier against mainCaseColdPartialPermImage |
| MAIN-EXPORT-001 | source_translation_gap | False | False | Generate qiskit/qasm3/manifest artifacts for mainCaseColdPartialPermVerified, then rerun this verifier. |
| MAIN-CANDIDATE-PACKAGE-001 | stale_leaf | True | True | MAIN-EXPORT-001: generate Qiskit/QASM3 artifacts from mainCaseColdPartialPermVerified and verify finite image, clean block, alpha=1, epsilon=0, and resource tuple. |
| MAIN-CANDIDATE-PACKAGE-001 | None | True | True | MAIN-EXPORT-001: generate Qiskit/QASM3 artifacts from mainCaseColdPartialPermVerified and check them against the COLD finite image, clean block, normalizer, and resource tuple. |

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
, clean support is {(0,6),(1,7)}, passive S is preserved, normalizer=1, epsilon=0, and resource tuple=(5,5,1,0). Compatibility verifier main-case-cold-export-cycle01.py now exits 0. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests. Next route: reviewer audit of generated export artifacts against mainCaseColdPartialPermVerified.

## 2026-06-27 13:31:40 - reviewer

Reviewer audit: accept Lean COLD candidate package and post-Lean export artifacts at the current finite-permutation/logical-export tier. Checked current diff, task/conversion/proof ledgers, trial memory, export manifest/code/QASM3/checkers, hidden shortcut scans, semantic-flag scan, markdown math delimiters, blueprint refresh, and gates. python3 tools/qbe.py check passed; lake build && lake build Tests passed. Export artifacts pass deterministic checks against mainCaseColdPartialPermVerified/mainCaseColdPartialPermCandidate_cost with basis action [14,15,8,9,10,11,0,1,2,3,4,5,6,7,12,13], clean support {(0,6),(1,7)}, passive S preserved, alpha=1, epsilon=0, resource tuple=(5,5,1,0), and q[0]=S,q[1]=tau,q[2]=T,q[3]=signal. Blocking for export closeout/status only: conversion window, proof obligations, reports/latest, memory_digest/todo, retrieval index, and stale main-case-cold-export-verify-cycle02.md/json still say qiskit/qasm3/manifest are pending or rejected even though current artifacts and verifier script now pass; update those maps before marking MAIN-EXPORT-VERIFY-001 complete in human-facing memory. Hidden-shortcut scan found only pre-existing RobinMatrix sorries/CubicStatePreparation prose outside this COLD diff; semantic flag promotion mainCaseColdResourceSchemaObligation.proved=true is backed by compiled circuit-image and cost declarations at the stated high-level logical tier.
```

## 当前未提交文件

- `MANIFEST.md`
- `QuantumBlockEncoding/MainCase.lean`
- `README.md`
- `Tests/Basic.lean`
- `candidate-populations/QBE-MAIN-CASE-HIER-COLD-001.md`
- `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`
- `docs/assets/abeis_lean_leaf_module_graph.png`
- `docs/assets/abeis_lean_leaf_module_graph.svg`
- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`
- `executable-exports/README.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle01-main-export.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle02-main-export-implement.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-lower-packets-cycle01-main-export.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-lower-packets-cycle02-main-export.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle01-main-candidate-package.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle02-main-export-map.md`
- `proof-blueprints/QBE-MAIN-CASE-HIER-COLD-001.md`
- `proof-blueprints/QBE-MAIN-CASE-HIER-PRO-001.md`
- `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md`
- `reports/QBE-MAIN-CASE-HIER-COLD-001/cycle02-20260627-report-export-audit.md`
- `reports/QBE-MAIN-CASE-HIER-COLD-001/latest.md`
- `research-wiki/block-encoding-library/compiled-lean-leaf-index.json`
- `research-wiki/block-encoding-library/compiled-lean-leaf-index.md`
- `research-wiki/block-encoding-library/index.md`
- `research-wiki/block-encoding-library/lean-leaf-module-graph.md`
- `research-wiki/block-encoding-library/lin-2201-08309.md`
- `research-wiki/block-encoding-library/qsvt-hard-hint-route.md`
- `research-wiki/block-encoding-library/quantum-lean-leaf-atlas.md`
- `research-wiki/block-encoding-library/route-selector.md`
- `research-wiki/papers/eager-made.md`
- `research-wiki/retrieval-index/QBE-MAIN-CASE-HIER-COLD-001.json`
- `tasks/QBE-MAIN-CASE-HIER-COLD-001.md`
- `tools/draw_abeis_figures.py`
- `tools/export_lean_leaf_index.py`
- `tools/qbe.py`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-candidate-package-cycle01.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-candidate-package-cycle01.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-cycle01.feedback.json`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-cycle01.md`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-export-cycle01.py`

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
