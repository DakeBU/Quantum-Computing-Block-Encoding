# 中文循环总结：QBE-OP-CUBIC-STATEPREP-001 cycle 1

生成时间：`2026-06-19 13:39:09`

Run 目录：`runs/20260619-120936-QBE-OP-CUBIC-STATEPREP-001-cycle01`

任务标题：Cubic grid state-preparation operator

这个文件是每轮长跑/收敛循环的人类审计入口。它不替代 Lean 证明；它负责告诉人类和下一轮 agent：当前有没有真正的 block-encoding 证书、哪些只是诊断、哪些曲线不能画成最终结果。

## 本轮验收结论

当前结论：这个 cubic 例子已经进入 Hard Mode / Scenario 2 的任务轨道，但还没有完成最终 block encoding。系统已经识别出它不是普通 unitary state preparation，因为

```text
sum_j (j / 2^n)^3 |j>
```

一般不是归一化量子态。因此 Lean 目标被固定为秩一算子

```text
O_n = |v_n><0^n|,  v_n[j] = (j / 2^n)^3.
```

这一步是正确的目标澄清，不是最终构造。当前还没有任何 cubic 候选进入 certified population；因此不能画“已经找到 final exact/approx BE”的曲线，也不能声称已经优于外部系统的最终构造。

## 母语输入与系统入口

- 用户中文原文已保存到 `task-inbox/QBE-OP-CUBIC-STATEPREP-001/user_prompt.zh.md`。
- 输出语言可以用 `--report-language <lang>` 或 `QBE_REPORT_LANGUAGE=<lang>` 控制。
- 本地和未来 web 的共同入口应使用 `python3 tools/qbe.py ingest-user-problem ...`，让原始母语输入成为系统 artifact，而不是由人类在系统外预处理。

## Exact / Approximate / Hard Mode 曲线状态

- 简单主例 `QBE-OP-OPTCTRL-001` 已有 Lean-certified evolution curve：`docs/assets/optctrl_evolution.png`。
- cubic hard benchmark 目前只有 Hard Mode 诊断曲线/表格：`reports/cubic-stateprep/latest.md` 和 dense verifier scaling；还没有 certified exact-phase / approximate-phase champion 曲线。
- 任何 README 或技术报告中关于 cubic 的曲线，都必须标注为“diagnostic / not final BE certificate”，直到 Lean 证明候选 `U_n` 的 unitary、clean block、误差和资源。

## 外部系统公平对比状态

- 已安装并使用 Qiskit 环境；cubic 同目标 finite external comparison 已完成，见 `reports/cubic-stateprep/external_comparison.md` 和 `reports/cubic-stateprep/external_comparison_scaling.png`。
- NumPy dense completion 通过 `n = 1..6`，Qiskit `Operator` 通过 `n = 1..4`，Qiskit-QuantumKatas-style evaluator 通过 `n = 3`；这些都是 fixed small-n executable evidence。
- QASM-Eval、QUASAR、AI-Mandel 在本地 artifact 中没有 direct same-task BE verifier route；它们仍可作为 typed feedback / harness 设计对比。
- ABEIS 自己还没有 final cubic BE，因此不能说 cubic 最终构造已经优于外部系统；当前优势说法应限于目标：Lean 证明 symbolic family，避免大规模 dense statevector/unitary materialization。

## 当前 Lean 编译/`sorry` 状态

- `QuantumBlockEncoding/RobinMatrix.lean:26968:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26998:  sorry`

## 当前动态 proof-DAG leaf

- # Proof Obligations: QBE-OP-CUBIC-STATEPREP-001
- ## Target Obligations
- | Obligation | Lean declaration or artifact | Status |
- | Prove closed form for `sum_j (j/2^n)^6` | planned `CubicStatePreparation.cubicNormSq_closedForm`; DAG node CUBIC-NORM-001 | active leaf |
- | Prove placeholder normalizer is sufficient | planned `CubicStatePreparation.cubicNormSq_le_conservativeNormalizer_sq`; DAG node CUBIC-ALPHA-001 | blocked on norm bridge |
- | Choose sharper normalizer `alpha` for final candidate, if useful | planned candidate-specific declaration | open |
- | State block projector and clean-ancilla convention for first candidate | planned candidate contract | open |
- ## Candidate Obligations
- | Obligation | Status |
- | CUBIC-NORM-001 | Closed rational formula for `cubicNormSq n`. | CUBIC-TGT-001, `classical-sixth-power-sum` | lower Lean | planned `cubicNormSq_closedForm` | active leaf |

## 当前未完成义务信号

- # Proof Obligations: QBE-OP-CUBIC-STATEPREP-001
- ## Target Obligations
- | Obligation | Lean declaration or artifact | Status |
- | State block projector and clean-ancilla convention for first candidate | planned candidate contract | open |
- ## Candidate Obligations
- | Obligation | Status |
- | Resource score `(gateCount, depth, auxiliaryQubits, oracleCalls)` | open |

## 最近 typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| CUBIC-ERR-001 | symbolic_bridge_gap |  | False | Close CUBIC-NORM-001 and CUBIC-ALPHA-001 before encoding the first-column entry-error-to-operator-error lemma. |
| CUBIC-NORM-001 | symbolic_bridge_gap | True | None | Prove CUBIC-NORM-001 in Lean using the sixth-power sum bridge, or prove the conservative normalizer bound directly; do not run block-entry diagnostics until U_n, alpha, projector, and ancilla layout exist. |
| CUBIC-DIAG-001 | None |  |  | CUBIC-NORM-001: formalize classical sixth-power-sum bridge for cubicNormSq_closedForm |
| CUBIC-VER-001 | symbolic_bridge_gap | True | None | Send lower 2 to CUBIC-NORM-001; use dense rows only as future finite smoke tests. |

## 下一轮 lower-agent 分工

| 角色 | 目标 | 产物 |
| --- | --- | --- |
| lower-1-natural-language-proof-architect | Translate the active source-paper proof step into a dependency DAG with exact source anchors and external-lemma calls. | proof-attempts/<task>/...-natural-language-dag.md |
| lower-2-lean-implementation-worker | Close one active Lean leaf only, preferably the smallest entry/evalWith bridge selected by the blueprint. | Lean declaration plus trial-log verifier-feedback fields |
| lower-3-necessary-condition-verifier | Check exact finite matrix/path/support conditions that must hold before the active Lean leaf can be true. | verifier-feedback/<task>/... plus trial-log feedback fields |

## 下一轮计划

1. lower Lean worker 先关闭 `CUBIC-NORM-001`：证明或绕过 `cubicNormSq` 的第六次幂求和/normalizer bridge。
2. middle 把 `CUBIC-NORM-001 -> CUBIC-ALPHA-001 -> CUBIC-ERR-001 -> candidate U_n` 的依赖 DAG 写清楚。
3. lower architect 给出第一个 approximate arithmetic/transduction candidate 的明确 register、projector、alpha、epsilon budget。
4. verifier worker 只在有具体 `U_n` 后运行有限 block-entry / Qiskit smoke test；不要把 dense scaling 当作 final proof。
5. reviewer 拒绝任何把未归一化向量当作 unitary output state 的候选，也拒绝没有 Lean theorem 的曲线点进入 certified population。

## 本轮 dialogue 末尾

```text
of-obligations ledger to retire n=1,2,3 diagnostics. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests. Feedback: leaf=CUBIC-DIAG-001, source_correspondence_ok=true, lean_parse_ok=true, lean_build_ok=true, closed_theorem_ok=true, error_class=none, next_route=CUBIC-NORM-001 classical sixth-power-sum bridge for cubicNormSq_closedForm.

## 2026-06-19 12:50:13 - lower

Lower necessary-condition verifier: added exact finite diagnostic for CUBIC-NORM-001 in verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-norm-001-necessary-condition.md plus executable script cubic_norm_001_diagnostic.py. Checks agree with planned sixth-power norm and rank-one support; no candidate block-entry check is valid yet because U_n, alpha, projector, and ancilla layout are still unstated. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 2026-06-19 12:51:00 - lower

CUBIC-ERR-001 architect pass complete: added proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md with source fragment, first-column error theorem, arithmetic/transduction/synthesis epsilon split, DAG table, Lean lemma order, and typed feedback. No Lean edits. CUBIC-NORM-001 remains next active Lean leaf, then CUBIC-ALPHA-001 before any candidate U_n proof search. Gate passed: python3 tools/qbe.py check.

## 2026-06-19 12:55:40 - reviewer

Reviewer gate: python3 tools/qbe.py check, lake build, and lake build Tests all pass. Blocking process findings: memory_digest/retrieval/blueprint index still omit cubicNormSq_n3 while obligations/window retire it; conversion-window blocked feedback list uses nonstandard classical_fact_gap. No cubic false proof or candidate promotion found; keep CUBIC-NORM-001 active and do not start U_n proof search before alpha/projector/ancilla/error budget.
```

## 当前未提交文件

- `MANIFEST.md`
- `QuantumBlockEncoding/CubicStatePreparation.lean`
- `candidate-populations/QBE-OP-CUBIC-STATEPREP-001.md`
- `conversion-windows/QBE-OP-CUBIC-STATEPREP-001.md`
- `paper-notes/QBE-OP-CUBIC-STATEPREP-001/markdown/cycle-summaries/20260619-120936-QBE-OP-CUBIC-STATEPREP-001-cycle01.zh.md`
- `paper-notes/QBE-OP-CUBIC-STATEPREP-001/markdown/cycle-summaries/latest.md`
- `paper-notes/QBE-OP-CUBIC-STATEPREP-001/markdown/cycle-summaries/latest.zh.md`
- `paper-notes/problem-exports/QBE-OP-CUBIC-STATEPREP-001/latest.tex`
- `proof-blueprints/QBE-OP-CUBIC-STATEPREP-001.md`
- `proof-obligations/QBE-OP-CUBIC-STATEPREP-001.md`
- `reports/cubic-stateprep/README.md`
- `reports/cubic-stateprep/competitor_protocol.md`
- `reports/cubic-stateprep/external_comparison.csv`
- `reports/cubic-stateprep/external_comparison.json`
- `reports/cubic-stateprep/external_comparison.md`
- `reports/cubic-stateprep/external_comparison_scaling.png`
- `reports/cubic-stateprep/latest.csv`
- `reports/external-quantum-verifier-comparison/latest.csv`
- `reports/external-quantum-verifier-comparison/latest.json`
- `reports/external-quantum-verifier-comparison/latest.md`
- `research-wiki/retrieval-index/QBE-OP-CUBIC-STATEPREP-001.json`
- `tasks/QBE-OP-CUBIC-STATEPREP-001.md`
- `tools/compare_cubic_external_quantum_verifiers.py`
- `tools/compare_external_quantum_verifiers.py`
- `tools/cubic_stateprep_diagnostics.py`
- `tools/qbe.py`
- `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
