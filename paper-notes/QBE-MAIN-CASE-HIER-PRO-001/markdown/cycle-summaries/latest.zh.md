# 中文循环总结：QBE-MAIN-CASE-HIER-PRO-001 cycle 3

生成时间：`2026-06-26 00:43:49`

Run 目录：`runs/20260626-001055-QBE-MAIN-CASE-HIER-PRO-001-cycle03`

任务标题：Main case transfer-operator block encoding, Pro-assisted isolated Hierarchical Harness

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

- MAINCASE-PRO-EXPORT-001: Prepare Qiskit and QASM3 packets using only `mainCaseProCircuitVerified` as the Lean source declaration.; status: active export implementation pending; Lean: none yet

## 当前未完成义务信号

- # Proof Obligations: QBE-MAIN-CASE-HIER-PRO-001
- | Obligation | Lean declaration or artifact | Status |
- | auxiliary qubit count `a = 1` is explicit | `mainCaseProSourceLayout`, `mainCaseProSourceLayout_auxiliaryQubits` | proved |
- | resource score is explicit | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost`, `mainCaseProCandidate_uses_matrix_table_metadata`, `mainCaseProCircuitCandidate_cost` | proved; matrix-table incumbent has unresolved executable metadata, Pro transcript has `(4,4,1,0)` |
- | Pro four-gate transcript realizes the advertised image/resource layer | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | proved as candidate split; equality with `mainCaseProCandidateImage` is false |
- | full matrix rational-orthogonality bridge | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`, `mainCaseProCandidateMatrix_isRationalOrthogonal`, `mainCaseProCircuitMatrix_isRationalOrthogonal`, `mainCaseProRationalOrthogonalBridgeObligation` | proved |
- | accepted semantic-tier object for export | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | named; `mainCaseProVerified` is matrix-table only with `mainCaseProMatrixTableResource` |
- | `MAINCASE-PRO-SOURCE-001` | Fixed operator, layout, projector, alpha, and epsilon. | task packet | middle | `mainCaseProTarget`, `mainCaseProBlockProjection` | conversion window | `python3 tools/qbe.py check` | proved |
- | `MAINCASE-PRO-PERM-IMAGE-001` | Task-local finite image and permutation matrix. | `MAINCASE-PRO-SOURCE-001` | middle/lower 2 | `mainCaseProCandidateImage`, `mainCaseProCandidateMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
- | `MAINCASE-PRO-RESOURCE-001` | Score tuple `(4,4,1,0)` for the Pro transcript; matrix-table incumbent carries one unresolved oracle-call placeholder. | `MAINCASE-PRO-BLOCK-001` | middle | `mainCaseProHighLevelSeedCost_*`, `mainCaseProCandidate_cost`, `mainCaseProCandidate_uses_matrix_table_metadata`, `mainCaseProCircuitCandidate_cost` | candidate population | `python3 tools/qbe.py check` | proved |
- | `MAINCASE-PRO-CIRCUIT-IMAGE-001` | Prove the advertised Pro transcript `CCX012; CX21; CX20; X2` realizes the same image as the candidate, or record a corrected gate-derived image/candidate split. | `MAINCASE-PRO-PERM-IMAGE-001`, `MAINCASE-PRO-RESOURCE-001`, Pro packet | middle/lower 2/lower 3 | `mainCaseProCircuitImage_candidate_mismatch_set`, `mainCaseProCircuitVerified` | conversion window plus verifier feedback | `python3 tools/qbe.py check` | proved split |
- | `MAINCASE-PRO-SEMANTIC-TIER-001` | Select the export-facing Lean certificate whose circuit, schedule, unitary image, block theorem, and resource score refer to the same Pro transcript. | `MAINCASE-PRO-CIRCUIT-IMAGE-001`, `MAINCASE-PRO-ORTHO-BRIDGE-001`, `MAINCASE-PRO-RESOURCE-001` | middle/reviewer/lower 3 | `mainCaseProCircuitVerified`, `mainCaseProCircuitCandidate_cost` | `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-middle-source-contract-cycle03.md` | `python3 tools/qbe.py check`; `lake build && lake build Tests` | accepted semantic-tier gate; no new Lean theorem required |
- ## Active Source Contract
- `mainCaseProMatrixTableResource`, with cost `(1,1,1,1)` marking an unresolved
- closed and `mainCaseProRationalOrthogonalBridgeObligation.proved = true` is
- | `MAINCASE-PRO-ORTHO-BRIDGE-001` | Finite row/column Gram necessary condition for the rational-orthogonality bridge. | `MAINCASE-PRO-PERM-UNITARY-001`, `MAINCASE-PRO-CIRCUIT-IMAGE-001`, compiled block/resource leaves | lower 3 | no new Lean declaration; `maincase_pro_ortho_bridge_diag.py` diagnostic only | `verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/maincase-pro-ortho-bridge-cycle02.md` | `python3 tools/qbe.py check` and `lake build && lake build Tests` | finite diagnostic passed; symbolic bridge now closed in Lean |

## 最近 typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| MAINCASE-PRO-EXPORT-001 | none | True | True | Generate Qiskit/QASM3 artifacts from mainCaseProCircuitVerified only, then compare their 16-state basis action against the diagnostic circuit_image list. |
| MAINCASE-PRO-SEMANTIC-TIER-001 | None | True | True | Generate qiskit/qasm3 exports from mainCaseProCircuitVerified only; reject mainCaseProVerified/mainCaseProCandidate_cost for transcript export. |
| MAINCASE-PRO-SEMANTIC-TIER-001 | none | True | True | Implement and verify Qiskit/QASM3 exports rooted at mainCaseProCircuitVerified/mainCaseProCircuitCandidate. |
| MAINCASE-PRO-SEMANTIC-TIER-001 | none | True | True | Generate qiskit and qasm3 export artifacts from mainCaseProCircuitVerified only; verify the generated basis action against mainCaseProCircuitImage and keep the dirty-column mismatch set {8,9,12,13} as a stale-route rejection check. |
| MAINCASE-PRO-SEMANTIC-TIER-001 | stale_leaf | True | True | Create qiskit/qasm3 export packet only after reviewer accepts mainCaseProCircuitVerified/mainCaseProCircuitCandidate as the export-facing Pro transcript certificate. |
| MAINCASE-PRO-ORTHO-BRIDGE-001 | None |  |  | reviewer semantic-tier acceptance before qiskit/qasm3 export |
| MAINCASE-PRO-ORTHO-BRIDGE-001 | None | True | True | reviewer semantic-tier acceptance before qiskit/qasm3 export |
| MAINCASE-PRO-ORTHO-BRIDGE-001 | None | True | True | reviewer semantic-tier audit before qiskit/qasm3 export |

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
y check. Typed feedback: leaf=MAINCASE-PRO-SEMANTIC-TIER-001, lean_parse_ok=true, lean_build_ok=true, finite_matrix_ok=true, block_entry_ok=true, ancilla_cleanup_ok=true, normalizer_ok=true, unitarity_ok=true, resource_score=matrix-table:(1,1,1,1)/pro-transcript:(4,4,1,0), closed_theorem_ok=true, error_class=none, next_route=generate qiskit/qasm3 exports from mainCaseProCircuitVerified only.

## 2026-06-26 00:38:28 - lower

MAINCASE-PRO-EXPORT-001 verifier guard complete. Added verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/maincase_pro_export_guard_cycle03.py plus Markdown/JSON feedback. Diagnostic recomputes lifted Pro transcript action [8,9,10,11,12,13,0,1,6,7,4,5,2,3,14,15], clean block equals mainCaseProTarget, normalizer 1 and score (4,4,1,0) are named, and stale mismatch against mainCaseProCandidateImage remains exactly {8,9,12,13}. Reject exports rooted at mainCaseProVerified or mainCaseProCandidate_cost; next route is to generate qiskit/qasm3 artifacts from mainCaseProCircuitVerified only and compare their 16-state basis action against this diagnostic. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 2026-06-26 00:42:51 - reviewer

Reviewer cycle 3 gate: python3 tools/qbe.py check passed; lake build && lake build Tests passed; export guard script passed. No blocking finding for semantic-tier acceptance: use mainCaseProCircuitVerified/mainCaseProCircuitCandidate_cost for the Pro transcript, keep mainCaseProVerified/mainCaseProCandidate_cost matrix-table only. Blocking for full export completion remains: executable Qiskit/QASM3 artifacts are not generated yet, only export-plan.md exists. Advisory: retrieval-index keeps historical closed_theorem_ok=false symbolic_bridge_gap rows; active queue correctly points to MAINCASE-PRO-EXPORT-001.
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
- `paper-notes/QBE-MAIN-CASE-HIER-COLD-001/`
- `paper-notes/problem-exports/QBE-MAIN-CASE-HIER-COLD-001/`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle02-main-perm-unitary.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle03-main-resource.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-resource-schema-cycle03.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-lower-packets-cycle03-main-resource.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle02.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-middle-source-contract-cycle03.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-circuit-image-lower-architect-20260625-2327.md`
- `proof-attempts/QBE-MAIN-CASE-HIER-PRO-001-export-proof-map-lower-architect-cycle03.md`
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

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
