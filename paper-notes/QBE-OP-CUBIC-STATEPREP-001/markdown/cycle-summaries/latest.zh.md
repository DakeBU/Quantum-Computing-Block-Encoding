# 中文循环总结：QBE-OP-CUBIC-STATEPREP-001 cycle 3

生成时间：`2026-06-19 17:48:54`

Run 目录：`runs/20260619-171933-QBE-OP-CUBIC-STATEPREP-001-cycle03`

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
- Qiskit export 已生成在 `executable-exports/QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py`，但它只是 finite dense baseline，不是 final symbolic certificate。
- QASM-Eval、QUASAR、AI-Mandel 在本地 artifact 中没有 direct same-task BE constructor/verifier route；它们仍可作为 typed feedback / harness 设计对比。
- ABEIS 自己还没有 final cubic BE，因此不能说 cubic 最终构造已经优于外部系统；当前优势说法应限于目标：Lean 证明 symbolic family，避免大规模 dense statevector/unitary materialization。

## 当前 Lean 编译/`sorry` 状态

- 当前没有检测到 `sorry`。

## 当前动态 proof-DAG leaf

- # Proof Obligations: QBE-OP-CUBIC-STATEPREP-001
- ## Target Obligations
- | Obligation | Lean declaration or artifact | Status |
- | Prove closed form for `sum_j (j/2^n)^6` | planned `CubicStatePreparation.cubicNormSq_closedForm`; DAG node CUBIC-NORM-001; proof design in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` | proof design recorded; diagnostic backlog, not a ser...
- | Choose sharper normalizer `alpha` for final candidate, if useful | planned candidate-specific declaration | open |
- ## Candidate Obligations
- | Obligation | Status |
- | CUBIC-NORM-001 | Closed rational formula for `cubicNormSq n`. | CUBIC-NORM-001A, `classical-sixth-power-sum` | future lower Lean | planned `cubicNormSq_closedForm`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` | proof design recorded; dia...
- | CUBIC-HCOUNT-UNITARY-001 | Prove the repaired transcript is unitary as Hadamards plus reversible arithmetic/permutation labels. | CUBIC-HCOUNT-COUNT-001, future semantics for oracle labels | future lower Lean | planned semantic theorem | next symbolic bri...
- | CUBIC-HCOUNT-BLOCK-001 | Prove the repaired clean block satisfies the route-specific clean-block contract. | CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001, Hadamard-sandwich semantic lemma | future lower Lean | planned clean-block theorem | blocked int...

## 当前未完成义务信号

- # Proof Obligations: QBE-OP-CUBIC-STATEPREP-001
- ## Target Obligations
- | Obligation | Lean declaration or artifact | Status |
- | State block projector and clean-ancilla convention for first candidate | `CubicStatePreparation.rankOneCleanBlockContract`, `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract`, `CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq`, `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | compiled contract bridge; semantic clean-block proof open |
- ## Candidate Obligations
- | Obligation | Status |
- | Repair Hadamard-counting nonzero-column rejection | compiled in `CubicStatePreparation.hadamardCountingCubicCircuit`, `hadamardCountingCubicResource_eq`, `hadamardCountingCubicResourceTuple_n2`, and focused `Tests/Basic.lean` checks; the repaired transcript uses a separate nonzero-column reject signal before `nz` cleanup |
- | Block-entry theorem for `O_n` | target-shape bridge compiled: `rankOneCleanBlockContract_pointwise_eq`; semantic zero-filter, row-generation, amplitude, and unitarity proofs remain open |
- | Resource score `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled for the unexpanded-oracle tier as `CubicStatePreparation.arithmeticCubicResourceTuple` and wrapper tuple `CubicStatePreparation.arithmeticRankOneCubicResourceTuple`; semantic expansion score open |
- | CUBIC-CAND-001 | Arithmetic cubic amplitude-transduction interface plus rank-one wrapper shape audit. | CUBIC-TGT-001 | lower worker 5 / lower proof architect | `arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`, `arithmeticCubicResourceTuple`, `arithmeticCubicClaim`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md` | compiled middle interface; semantic block proof open |
- | CUBIC-CAND-SHAPE-001 | Rank-one wrapper transcript, resource tuple, clean-block contract, and target-shape bridge. | CUBIC-CAND-001, CUBIC-TGT-001 | lower worker 5 / lower Lean | `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`, `arithmeticRankOneCubicClaim`, `rankOneCleanBlockContract_pointwise_eq`, `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | compiled interface and pointwise bridge; zero-filter/row-generation semantics open |
- | CUBIC-HCOUNT-IFACE-001 | Hadamard-counting layout, transcript, normalizer, resource tuple, clean-block contract bridge, and normalizer bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | compiled interface; not a certificate |
- | CUBIC-HCOUNT-REJECT-REPAIR-001 | Repair the zero-input rejection convention so nonzero input columns cannot return clean identity entries. | CUBIC-HCOUNT-IFACE-001, CUBIC-HCOUNT-RATIO-001, CUBIC-VER-CAND-001:HCOUNT-SEMANTIC | lower Lean | `hadamardCountingCubicCircuit_rejectSignalRepair`, `hadamardCountingCubicResource_eq`, `hadamardCountingCubicResourceTuple_n2`, focused `Tests/Basic.lean` checks, `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-REJECT-REPAIR-001.md` | compiled interface repair; finite repaired diagnostic passed; retired as active target |
- | CUBIC-HCOUNT-UNITARY-001 | Prove the repaired transcript is unitary as Hadamards plus reversible arithmetic/permutation labels. | CUBIC-HCOUNT-COUNT-001, future semantics for oracle labels | future lower Lean | planned semantic theorem | next symbolic bridge leaf |
- | CUBIC-HCOUNT-BLOCK-001 | Prove the repaired clean block satisfies the route-specific clean-block contract. | CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001, Hadamard-sandwich semantic lemma | future lower Lean | planned clean-block theorem | blocked internal |
- ## Source-Correspondence Contract
- | Source anchor | User/task contract in `tasks/QBE-OP-CUBIC-STATEPREP-001.md`; no paper archive is active. |
- | Active lower leaves | `CUBIC-HCOUNT-COUNT-001` is compiled.  `CUBIC-HCOUNT-RATIO-001` and `CUBIC-HCOUNT-REJECT-REPAIR-001` are compiled, finite checks for the repaired reject convention remain clean for `n = 1, 2`, and the old daggered route remains rejected.  The next symbolic bridge is `CUBIC-HCOUNT-UNITARY-001` or an equivalent Hadamard-sandwich semantic lemma before `CUBIC-HCOUNT-BLOCK-001`. |
- | External technical lemma | `classical-sixth-power-sum` in `research-wiki/cited-results/classical-power-sums.md`, status `obligation` unless a Lean helper builds. |
- | QBE-local glue | Block-encoding records, clean-block projector convention, normalizer bookkeeping, resource tuple, verifier-feedback fields. |

## 最近 typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| CUBIC-HCOUNT-COUNT-001 | symbolic_bridge_gap | True | True | CUBIC-HCOUNT-UNITARY-001 or an equivalent Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001 |
| CUBIC-HCOUNT-COUNT-001 | symbolic_bridge_gap | True | True | CUBIC-HCOUNT-UNITARY-001 or equivalent Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001 |
| CUBIC-HCOUNT-COUNT-001 | symbolic_bridge_gap | True | True | Keep CUBIC-HCOUNT-COUNT-001; schedule CUBIC-HCOUNT-UNITARY-001 or a Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001. |
| CUBIC-HCOUNT-COUNT-001 | symbolic_bridge_gap | True | True | Schedule CUBIC-HCOUNT-UNITARY-001 or the Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001; do not promote the candidate from count diagnostics alone. |
| CUBIC-HCOUNT-COUNT-001 | symbolic_bridge_gap | True | True | Prove gridSize_three_mul_eq_cube, gridSize_four_mul_eq_fourth, hadamardCountingCubic_threshold_le_pathCapacity, and hadamardCountingCubic_thresholdPathCount in Lean. |
| CUBIC-HCOUNT-REJECT-REPAIR-001 | symbolic_bridge_gap | True | True | Promote the separate-reject convention into symbolic Hadamard-counting semantics before attempting CUBIC-HCOUNT-BLOCK-001. |
| CUBIC-HCOUNT-REJECT-REPAIR-001 | symbolic_bridge_gap | True | True | Promote one symbolic bridge leaf: CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001 before CUBIC-HCOUNT-BLOCK-001. |
| CUBIC-HCOUNT-REJECT-REPAIR-001 | symbolic_bridge_gap | True | True | Promote one symbolic bridge leaf: CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001 before CUBIC-HCOUNT-BLOCK-001 |

## 下一轮 lower-agent 分工

| 角色 | 目标 | 产物 |
| --- | --- | --- |
| lower-1-natural-language-proof-architect | Translate the active source-paper proof step into a dependency DAG with exact source anchors and external-lemma calls. | proof-attempts/<task>/...-natural-language-dag.md |
| lower-2-lean-implementation-worker | Close one active Lean leaf only, preferably the smallest entry/evalWith bridge selected by the blueprint. | Lean declaration plus trial-log verifier-feedback fields |
| lower-3-necessary-condition-verifier | Check exact finite matrix/path/support conditions that must hold before the active Lean leaf can be true. | verifier-feedback/<task>/... plus trial-log feedback fields |

## 下一轮计划

1. lower candidate architect 立刻给出第一个 concrete `U_n` 候选接口：register、projector、alpha、unitarity 证明形状、clean-block 证明形状、epsilon budget 和资源 tier。
2. lower Lean worker 并行关闭一个小 proof leaf：`CUBIC-NORM-001` 或直接 `CUBIC-ALPHA-001`，但不得把它当作阻止候选构造的串行闸门。
3. middle 把 active DAG 写成并行 frontier：`CUBIC-CAND-001`、`CUBIC-NORM-001/CUBIC-ALPHA-001`、`CUBIC-VER-CAND-001`。
4. verifier worker 一旦有具体 `U_n`，就运行有限 block-entry / Qiskit fixed-instance necessary-condition check；如果还没有 `U_n`，记录 `candidate_interface_gap`，不要重复 norm-only diagnostics。
5. reviewer 拒绝任何把未归一化向量当作 unitary output state 的候选，也拒绝没有 Lean theorem 的曲线点进入 certified population。

## 本轮 dialogue 末尾

```text
001-CUBIC-HCOUNT-COUNT-001.md; the shared Lean worktree now contains gridSize_three_mul_eq_cube, gridSize_four_mul_eq_fourth, hadamardCountingCubic_thresholdCountP_finRange, hadamardCountingCubic_thresholdFilterLength, hadamardCountingCubic_threshold_le_pathCapacity, and hadamardCountingCubic_thresholdPathCount. I repaired one focused Tests/Basic.lean example that had omitted the concrete proposition for threshold_le_pathCapacity, refreshed the blueprint, and synchronized the proof-attempt/conversion-window status. closed_theorem_ok=true for the count leaf only; closed_theorem_ok=false for the block certificate. error_class=symbolic_bridge_gap remains for the semantic route. next_route=CUBIC-HCOUNT-UNITARY-001 or an equivalent Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001. Gate passed: python3 tools/qbe.py check.

## 2026-06-19 17:48:20 - reviewer

Reviewer gate passed: python3 tools/qbe.py check ran lake build and lake build Tests. No blocking issue found for CUBIC-HCOUNT-COUNT-001: the Lean diff only adds grid-size/capacity/List.finRange threshold-count lemmas plus focused tests, the conversion window/proof obligations keep unitarity and clean-block semantics open, and candidate promotion remains blocked until a named Lean clean-block/unitarity certificate builds. Finite threshold diagnostic passes for n=1..5 and is correctly labeled as necessary-condition feedback. Scans found no new shortcut or semantic-flag pattern in the cubic diff; existing RobinMatrix sorry/flag matches are outside this task. Advisory: candidate-populations certified-population intro under-reports the new compiled count leaf, though later sections state it correctly. Next route remains CUBIC-HCOUNT-UNITARY-001 or Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001.
```

## 当前未提交文件

- `MANIFEST.md`
- `QuantumBlockEncoding/CubicStatePreparation.lean`
- `Tests/Basic.lean`
- `candidate-populations/QBE-OP-CUBIC-STATEPREP-001.md`
- `conversion-windows/QBE-OP-CUBIC-STATEPREP-001.md`
- `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-COUNT-001.md`
- `proof-blueprints/QBE-OP-CUBIC-STATEPREP-001.md`
- `proof-obligations/QBE-OP-CUBIC-STATEPREP-001.md`
- `research-wiki/retrieval-index/QBE-OP-CUBIC-STATEPREP-001.json`
- `tasks/QBE-OP-CUBIC-STATEPREP-001.md`
- `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-hcount-count-001-threshold.md`
- `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_hcount_count_001_threshold_check.py`

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
