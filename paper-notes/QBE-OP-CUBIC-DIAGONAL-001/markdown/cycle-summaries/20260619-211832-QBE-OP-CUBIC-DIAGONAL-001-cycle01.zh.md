# 中文循环总结：QBE-OP-CUBIC-DIAGONAL-001 cycle 1

生成时间：`2026-06-19 23:55:37`

Run 目录：`runs/20260619-211832-QBE-OP-CUBIC-DIAGONAL-001-cycle01`

任务标题：Cubic diagonal oracle block encoding

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

- DIAG-PRIM-UNITARY-001: Name the primitive oracle-label matrix, unitarity obligation, clean-block extraction obligation, and prove the contract implies target clean-block equality.; status: compiled conditional bridge; Lean: `primitiveAmplitudeOracleSemanticContract`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target`
- DIAG-PRIM-WITNESS-001: Supply or explicitly accept a proof of `primitiveAmplitudeOracleSemanticContract n`, but not as a standard exact `Rat` one-signal/no-workspace completion.; status: blocked subroute; exact rational completion rejected and not assigned this cycle; Lean: target proof of `primitiveAmplitudeOracleSemanticContract n`
- DIAG-EXPANDED-CONTRACT-001: Define the expanded arithmetic route contract: compute $a_j=(j/2^n)^3$, apply the correct controlled rotation, uncompute workspace, and extract the diagonal clean block.; status: compiled conditional interface; semantic obligations open; Lean: `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target`
- DIAG-ROOT-001: Exact operator block-encoding certificate for the selected primitive or expanded route.; status: blocked until a route certificate exists; Lean: `primitiveAmplitudeOracleVerified n h` for the primitive path, or planned expanded certificate
- DIAG-EXPORT-001: Qiskit, QuantumKatas-style, and QASM3 export plan tied to the named Lean certificate.; status: blocked downstream; Lean: planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet

## 当前未完成义务信号

- Keep the target diagonal, not rank-one state preparation.: Lean `CubicDiagonalOracle.cubicDiagonalOperator`, `cubicDiagonalTarget`; class source/operator contract; status compiled; reviewer must reject rank-one routes
- Record exact normalizer $\alpha = 1$.: Lean `CubicDiagonalOracle.exactNormalizer`; class normalizer; status compiled
- Prove amplitude range $0 \le (j/2^n)^3 \le 1$.: Lean `cubicAmplitude_nonneg`, `cubicAmplitude_le_one`; class internal Lean lemma; status compiled
- Record one-signal primitive oracle-label resources.: Lean `amplitudeOracleLayout`, `amplitudeOracleResourceTuple_eq`, `primitiveAmplitudeOracleCandidate_costTuple_eq`; class resource equality; status compiled
- Bridge a clean-block contract to the target operator.: Lean `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target`; class internal Lean lemma; status compiled; gate passed 2026-06-19 20:44 JST
- State primitive one-signal oracle unitarity and clean-block extraction without hiding semantics.: Lean `primitiveAmplitudeOracleUnitary`, `primitiveAmplitudeOracleIsUnitary`, `primitiveAmplitudeOracleCleanBlockExtracts`, `primitiveAmplitudeOracleSemanticContract`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target`; class oracle/circuit semantics; status compiled conditional contract; does not prove the primitive semantics
- Provide a proof or accepted primitive-tier source for the semantic contract.: Lean `primitiveAmplitudeOracleSemanticContract n`; class external primitive contract; status blocked; not assigned this cycle without explicit primitive-tier acceptance
- Retire the exact standard rational one-signal/no-workspace primitive witness subroute.: Lean verifier packet `DIAG-PRIM-WITNESS-001.rat-one-signal.*`; class necessary-condition rejection; status rejected for `n = 1, 2, 3` by determinant-square obstruction; target diagonal still passes
- State the expanded reversible-arithmetic plus controlled-rotation contract.: Lean `expandedAmplitudeOracleLayout`, `expandedAmplitudeOracleCleanBlockContract`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target`; class QBE-local semantic glue; status compiled conditional interface; semantic obligations open
- Produce an exact primitive block-encoding certificate or equivalent project-local certificate.: Lean `primitiveAmplitudeOracleVerified n h`; class root certificate; status conditional transformer compiled; unconditional certificate blocked on `h : primitiveAmplitudeOracleSemanticContract n`
- Prove the expanded route's clean-block bridge once the interface exists.: Lean `expandedAmplitudeOracleCleanBlockContract_diagonal`, `expandedAmplitudeOracleCleanBlockContract_eq_target`, `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target`; class internal Lean lemma after interface selection; status compiled conditional bridge; root certificate still blocked
- Create Qiskit, QuantumKatas-style, and QASM3 exports.: Lean planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet; class post-Lean export; status blocked until a Lean certificate is named

## 最近 typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| DIAG-EXPANDED-CONTRACT-001 | symbolic_bridge_gap |  | True | Prove or refine one compiled expanded semantic obligation: expandedArithmeticComputesCubicAmplitude, expandedControlledRyUsesCubicAngle, expandedWorkspaceCleanUncomputed, or expandedAmplitudeOracleCleanBlockExtracts; no exports before DIAG-ROOT-001 closes. |
| DIAG-EXPANDED-CONTRACT-001 | symbolic_bridge_gap | True | True | Use the expanded-route interface/bridge if present, then prove or instantiate the concrete backend obligations expandedArithmeticComputesCubicAmplitude, expandedControlledRyUsesCubicAngle, expandedWorkspaceCleanUncomputed, and expandedAmplitudeOracleCleanBlockExtracts before packaging an expanded candidate. |
| DIAG-EXPANDED-CONTRACT-001 | source_translation_gap |  |  | Compile DIAG-EXP-REG-001 expanded layout/workspace interface and DIAG-EXP-BRIDGE-001 conditional bridge to diagonalCleanBlockContract; do not reopen Rat primitive witness or create exports. |
| DIAG-EXPANDED-CONTRACT-001 | symbolic_bridge_gap | True | True | Compile a Lean interface for the expanded route: reversible compute/uncompute, standard controlled-R_y with theta_j = 2 arccos((j/2^n)^3), and a clean-block predicate implying diagonalCleanBlockContract n block. |
| DIAG-EXPANDED-CONTRACT-001 | symbolic_bridge_gap | None | None | prove expanded arithmetic/Ry/clean-uncompute obligations for a concrete workspace backend, then package an expanded candidate without primitiveAmplitudeOracleVerified |
| DIAG-PRIM-WITNESS-001 | shape_or_register_gap | True | True | Do not ask Lean to prove primitiveAmplitudeOracleSemanticContract n as a standard Rat one-signal/no-workspace unitary; either retarget the primitive contract to an explicitly accepted Real/Complex amplitude-oracle semantics, or open the expanded arithmetic route with a source-backed unitary convention. |
| DIAG-CANDIDATE-SCORE-001 | external_contract_gap | None | None | DIAG-PRIM-WITNESS-001: provide or explicitly accept h : primitiveAmplitudeOracleSemanticContract n; otherwise route to expanded arithmetic. |
| DIAG-PRIM-WITNESS-001 | external_contract_gap | None | True | Either record an accepted primitive-tier witness for primitiveAmplitudeOracleSemanticContract n, or open an expanded arithmetic/rotation leaf with an explicit scalar convention. |

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
py check.

## 2026-06-19 21:58:41 - lower

Correction to verifier next_route after concurrent Lean interface closure: expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target is now present, so the DIAG-EXPANDED-CONTRACT-001 finite diagnostic should route the next worker to concrete backend obligations expandedArithmeticComputesCubicAmplitude, expandedControlledRyUsesCubicAngle, expandedWorkspaceCleanUncomputed, and expandedAmplitudeOracleCleanBlockExtracts, not to recompile the interface. Regenerated JSON/markdown feedback and reran python3 tools/qbe.py check successfully.

## 2026-06-19 22:01:22 - lower

Lower natural-language architect follow-up: synchronized DIAG-EXPANDED-CONTRACT-001 proof maps with the concurrent compiled Lean interface. Markdown now references expandedAmplitudeOracleLayout, expandedAmplitudeOracleCleanBlockContract, expandedAmplitudeOracleCleanBlockContract_eq_target, and expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target. Remaining route is to prove/refine one expanded semantic obligation: arithmetic computation, controlled-R_y scalar-tier semantics, clean uncompute, or extraction. Final gate passed via python3 tools/qbe.py check.

## 2026-06-19 22:05:29 - reviewer

Reviewer gate passed: python3 tools/qbe.py check succeeded with lake build and lake build Tests. No blocking issue in the cubic diagonal diff: the new Lean route is conditional, keeps the diagonal target and alpha=1, and does not package a VerifiedOperatorBlockEncoding without h. Advisory: expanded route still lacks a root certificate and should add or name an explicit expanded unitarity/circuit obligation before packaging or export; the task packet Current Lean Surface lags the expanded declarations; pre-existing unrelated RobinMatrix sorries remain outside this diff.
```

## 当前未提交文件

- `MANIFEST.md`
- `QuantumBlockEncoding/CubicStatePreparation.lean`
- `README.md`
- `agent-profiles/README.md`
- `candidate-populations/QBE-OP-CUBIC-DIAGONAL-001.md`
- `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md`
- `docs/agent_orchestration.md`
- `docs/lexelim_scheduler_notes.md`
- `paper-notes/QBE-OP-CUBIC-DIAGONAL-001/`
- `paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-001/`
- `proof-attempts/QBE-OP-CUBIC-DIAGONAL-001-diag-amplitude-proof-dag.md`
- `proof-blueprints/QBE-OP-CUBIC-DIAGONAL-001.md`
- `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md`
- `research-wiki/retrieval-index/QBE-OP-CUBIC-DIAGONAL-001.json`
- `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`
- `tasks/QBE-OP-CUBIC-STATEPREP-001.md`
- `tools/qbe.py`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXPANDED-CONTRACT-001.expanded-controlled-ry.feedback.json`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXPANDED-CONTRACT-001.expanded-controlled-ry.md`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-PRIM-WITNESS-001.rat-one-signal.feedback.json`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-PRIM-WITNESS-001.rat-one-signal.md`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/expanded_controlled_ry_check.py`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/lower-candidate-cost-20260619.md`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/lower1-prim-witness-20260619.json`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/lower1-prim-witness-20260619.md`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/middle-primitive-contract-20260619.json`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/middle-primitive-contract-20260619.md`
- `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/primitive_signal_unitary_check.py`
- `web/README.md`
- `web/app.js`

## 人类检查建议

1. 如果某个图或 README 说 cubic 已经有 final exact/approx BE，要求它给出 Lean theorem 名、资源 theorem 名、`python3 tools/qbe.py check` 结果和 problem export。
2. 如果外部系统对比说“ABEIS 更好”，要求它说明是否已经同 prompt、同 tolerance、同 metric 跑完 end-to-end，而不是只做了 scaling forecast。
3. 如果 agent 直接把用户中文问题翻译成英文后才进系统，要求改为 `ingest-user-problem` 或 web ingestion 入口，让原始母语输入成为系统 artifact。
