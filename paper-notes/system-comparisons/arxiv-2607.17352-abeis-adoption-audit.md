# arXiv:2607.17352 与 ABEIS 的外部工作借鉴审计

审计对象：ABEIS（Auto-Block-Encoding-In-Sleep）
外部工作：[Self-Modifying Lean Proof Agents with Verifier-Grounded Benchmark Coevolution](https://arxiv.org/abs/2607.17352)，[PDF](https://arxiv.org/pdf/2607.17352v1)
审计日期：2026-07-27
结论状态：**审计完成；不据此声称任何尚未运行的机制能够提升 ABEIS。**

## 0. 审计口径

ABEIS 的目标链是

$$
\text{state/operator specification}
\to
\text{candidate construction}
\to
\text{Lean certificate}
\to
\text{resource ranking}
\to
\text{Qiskit/QASM export}.
$$

论文的主要实验对象则是：给定 Lean theorem 后，进化 theorem-proof workflow，
并在 miniF2F/PutnamBench 课程与 held-out miniF2F 上评价。两者共享 Lean
verification，却不共享完整任务分布。本文因此分别回答：

1. 论文作者声称什么；
2. 论文实验实际支持什么；
3. 机制是否在通用 Lean proof completion 中有效；
4. 机制能否迁移到 ABEIS 的 construction、certificate、resource、export 链；
5. ABEIS 是否已有等价或更强机制；
6. ABEIS 的代码、测试和运行产物是否显示了相应问题。

### 0.1 证据等级

| 记号 | 含义 |
|---|---|
| `I` | 代码中存在实现 |
| `T` | 有单元/回归测试 |
| `R` | 有 controller replay 或确定性自检 |
| `A` | 有可识别的真实 agent route/run 记录 |
| `L` | 当前或冻结记录表明 Lean root/leaf 编译关闭 |
| `X` | post-Lean executable acceptance 通过 |
| `G` | 在未参与开发/检索的 held-out task 上有 generalization 证据 |

`I/T/R` 不能自动提升为 `A/L/X/G`。目录存在、Markdown 声称、controller
replay 通过或 finite Qiskit test 通过，分别不能替代真实 synthesis、symbolic
Lean family certificate 或 held-out generalization。

### 0.2 本次审计的硬限制

- 当前公开 checkout 的 `runs/` 只有 `runs/README.md`。`.gitignore` 明确忽略
  `runs/**`、`runs/trials.jsonl` 和 `runs/trials_summary.csv`；Git 历史也没有
  这些文件。因此无法从本 checkout 重建全量 model-call、token、repair、每轮
  controller decision 和 wall-clock 序列。
- 一些 task 文件指向仓库外的 isolated-run control state；这些外部状态不在本次
  可复现证据集合中。
- 可用的运行证据是经过整理的 cycle summaries、retrieval snapshots、route
  ablation、verifier feedback、proof attempts、candidate populations、frozen
  acceptance 和 executable artifacts。本文不会把这些摘要扩写成不存在的原始数据。
- 当前仓库没有 training/dev/held-out split，也没有跨任务 workflow
  generalization run。因此本仓库的最高可达证据等级是部分任务的 `X`，不是 `G`。

## 1. Executive conclusion

### 1.1 论文确实领先 ABEIS 的维度

1. **工作流是显式的进化对象。** 论文把 prompt、proof workflow 和工具放在
   mutable workspace，并维护 agent archive/champion。ABEIS 有 construction
   candidate population，但没有 workflow version population、workflow archive
   或 held-out workflow selection。
2. **有真正隔离的 held-out evaluation。** 论文用 244 个不参与课程和选择的
   miniF2F test problems 评价 selected agents。ABEIS 当前所有成熟 task、route
   card、proof artifact 和根 theorem 都可被本仓库检索，不能组成未污染
   held-out set。
3. **对 workflow effectiveness 有直接消融。** 论文比较固定 benchmark 与
   coevolving benchmark，并记录 lineage 中实际保留下来的 repair/tool changes。
   ABEIS 只有一个有价值但规模很小的 route ablation；没有多 workflow、多 seed、
   多 task-family 的选择实验。

论文报告 seed 的 held-out solve rate 为 `12.7%`，最佳 coevolving agent 为
`45.1%`，最佳 fixed-benchmark agent 为 `32.0%`（论文 §4.1–4.2，Table 1）。
但 held-out 轨迹是 `12.7, 38.9, 29.9, 29.9, 11.9, 25.4, 40.6, 25.4, 45.1`，
并不单调。论文附录还明确说明这是 single-run study、一个 backend、没有 variance
estimate，time/token penalty 均设为 0。因此这些数字支持“该实验中出现了改进”，
不支持“该机制普遍优于固定 workflow”，更不支持量子 construction 的直接迁移。

### 1.2 ABEIS 已经更强的维度

1. **量子领域形式知识。** ABEIS 有 state preparation、clean-block extraction、
   permutation、LCU、product、dilation、sparse access、QSVT supplier/consumer、
   resource 和 task-specific paper contracts；论文只处理既定 Lean theorem。
2. **candidate 与 proof 的双层选择。** ABEIS 明确区分 insight pool、finite
   diagnostics、conditional interface 和 Lean-certified population，并使用
   exact/approximate phase、epsilon ladder、route lock 和 resource tuple。
3. **post-Lean acceptance。** ABEIS 能把命名 Lean certificate 继续送入独立
   Qiskit/QASM checker。BE Case 1 和 BE Case 2 均有这种产物；论文的 reward
   止于 Lean final proof。
4. **对过度声明的防护语义更丰富。** ABEIS 的 feedback 区分
   `symbolic_bridge_gap`、`source_translation_gap`、`external_contract_gap`、
   `shape_or_register_gap`、`stale_leaf` 等，且能够记录 finite test 与 symbolic
   certificate 的边界。

### 1.3 最值得借鉴的三项

1. **先建立 workflow-versioned、family-stratified 的 held-out evaluation。**
   这是 outer workflow evolution 和 benchmark coevolution 的前置条件，而不是
   两者的附属功能。
2. **采用小型 deterministic theorem-signature repair 工具。** 输出 exact
   namespace、完整 type、import、source location、成功实例和失败替换；不要先加
   新 agent 层。
3. **运行 fast repair 与 hierarchical/game harness 的受控对照。** 论文的真实
   lineage 和 ABEIS 自身单个 route ablation 都提示小 Lean leaf 可能不需要完整
   hierarchy，但当前证据只够支持实验，不够支持默认切换。

### 1.4 最不应照搬的三项

1. **不采用可修改 verifier/scoring/benchmark split 的无限制 self-modification。**
2. **不采用 final-proof-only reward，也不把 monolithic repair 变成所有量子任务
   的默认策略。**
3. **不采用单 champion、单 scalar difficulty、miniF2F→PutnamBench 的量级映射
   作为量子 construction 难度。**

### 1.5 是否支持立即修改系统

证据只支持三类立即动作：

- Phase 0 instrumentation 与 held-out split 的设计；
- trusted-boundary 硬化；
- deterministic signature retrieval/failure cache。

证据**不支持**立即上线 outer self-evolution、benchmark coevolution 或新的
production reward。fast repair、representation-free context 和 reuse-aware
fitness 应先做对照实验。本轮没有修改 production controller。

## 2. Evidence inventory

### 2.1 论文证据

| 论文位置 | 可支持的结论 | 不能推出的结论 |
|---|---|---|
| §3.1，pp. 4–5 | trusted runtime 与 mutable workspace 分离；code validity 与 proof success 分离 | ABEIS 当前已经隔离 |
| §3.2，pp. 5–6 | proof context 可选 representation；root、dependency、mathematical node、Lean grounding 被强制验证 | 任意图结构都会提高 solve rate |
| §3.3–3.4，pp. 6–7；Appendix B | 76-task active curriculum、mastery-throttled update、archive/champion 和 single-anchor recalibration 的具体算法 | 相同 scalar difficulty 适合 construction/resource/export |
| §4.1–4.2，pp. 7–8 | single run 中 coevolving best `45.1%`，fixed best `32.0%` | 有统计显著性、跨模型普适性 |
| §4.3–4.5，pp. 8–10 | 胜出的 lineage 主要保留 bounded repair、name checking；深 DAG 多数浅且脆弱 | decomposition 无用；monolithic 对 ABEIS 全任务最优 |
| Appendix A，pp. 10–12 | 单 backend、单 run、无 variance；1200s workflow cap；time/token penalty 为 0 | 可以据论文数值直接制定 ABEIS reward 权重 |

### 2.2 Controller、orchestration 与 trusted boundary

| 文件 | 观察到的实现/证据 | 等级 |
|---|---|---|
| `tools/qbe_control.py:20-23` | controller v5、任务种类、容量上限 | `I` |
| `tools/qbe_control.py:369-404` | newest feedback reduction 与 content digest | `I` |
| `tools/qbe_control.py:423-547` | epsilon ladder、route lock、root anchor、executable contract、population gate parsing | `I` |
| `tools/qbe_control.py:559-650` | middle proposal/mutation/crossover/retirement 与 upper/reviewer selection 的 typed reduction | `I` |
| `tools/qbe_control.py:662-712` | `leaf_signature` + `evidence_digest` 签名授权 | `I` |
| `tools/qbe_control.py:763-1207` | replay protection、逐级 capacity、逐 rung epsilon、stale/route/no-progress/external stop、post-Lean 和 population scheduling | `I` |
| `tools/test_qbe_control.py` | 33 个 controller/retrieval/accounting tests；本次全部通过 | `T` |
| `reports/ABEIS-CONTROL-V5/cold-start-population-audit.json` | population gate replay 通过；文件自己明确 `not a mathematical synthesis benchmark` | `R` |
| `tools/qbe.py:966-993` | build result 与 whole Lean workspace digest 缓存 | `I` |
| `tools/qbe.py:8889-9027` | executable command 独立执行、source/artifact/environment digest、失败输入不重复执行 | `I`, 部分 `X` |
| `tools/qbe.py:9030-9089` | root theorem presence + current successful build digest 才算 root acceptance | `I` |
| `tools/qbe.py:8711-8827` | external agent 以 repository root 为 cwd，直接作用于共享 worktree | `I`，也是隔离缺口 |

关键缺口：

- agent process 可修改 `tools/qbe.py`、`tools/qbe_control.py`、task 中的 acceptance
  anchors、评分文本和所有 Lean 源；没有 worker checkout/sandbox 与 parent-owned
  immutable manifest。
- `cmd_check` 只运行 Lean build；Lean 对 `sorry` 给 warning 而不是 failure。
  `QuantumBlockEncoding/RobinMatrix.lean` 当前有两个真实 `sorry`，而历史 build
  记录仍标为 passed。因此“prompt 禁止 sorry”不是 trusted-runtime rejection。
- root-presence helper 把 fully-qualified anchor 截成 short name 后在相关文件中搜索
  declaration kind；它没有由 evaluator `#check` exact fully-qualified name/type。
  当前 anchors 没有因此被证明错误，但该实现不足以成为 self-evolution 的抗伪造边界。
- root anchor 来自可编辑 task Markdown。虽然要求当前 digest 重新 build，但 agent
  仍可能同时修改 target/anchor 和证明；缺少 evaluator-owned frozen target digest。
- executable command 来自可编辑 task Markdown。它不通过 shell 执行且检查 artifact，
  这是优点；但 command/expected semantics 本身没有 parent-owned frozen benchmark
  contract。

### 2.3 运行、日志和验收产物

| 证据 | 可复现观察 |
|---|---|
| `runs/README.md`, `.gitignore` | raw runs、trial JSONL/CSV 是本地状态；本 checkout 不含这些数据 |
| `reports/route-ablation/QBE-OP-OPTCTRL-001/latest_results.json` | 同一小型 target 上，real-agent Lean-only route `356.3s`，ABEIS multi-agent route `851.4s`；两者均通过 Lean；input/output token 均为 proxy，不是 provider accounting |
| 同上 | Qiskit-only route 通过 finite executable，但不可作为 Lean dependency |
| `research-wiki/retrieval-index/*.json` | 保存每个 snapshot 最近 10 条 trial/feedback，而不是完整日志 |
| `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/*.json` | 92 个可解析 leaf feedback；59 个 `lean_build_ok=true`，18 个 `closed_theorem_ok=true`，73 个 `symbolic_bridge_gap` |
| 同上 | `DIAG-ARITH-BACKEND-BRIDGE-001` + `symbolic_bridge_gap` 出现 14 次 |
| `paper-notes/QBE-OP-CUBIC-DIAGONAL-001/markdown/cycle-summaries/` | 11 个带日期的 curated cycle summary；不能由此推出完整 model-call 数 |
| `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/*.json` | 14 个 feedback；11 个 build true，6 个 closed theorem；包含一次 export wire-map drift 和后续 repair |
| `verifier-feedback/QBE-MAIN-CASE-HIER-PRO-001/*.json` | 11 个 feedback；8 个 build true，5 个 closed theorem；包含 circuit-image counterexample 和 semantic-tier split |
| `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-IFACE-001.md` | 一次明确的 `Unknown identifier`/declaration-order failure，经移动声明后关闭 interface |
| `failure-memory/README.md` | 只有模板，没有实际 failure packet |
| `research-wiki/mathlib-lemmas/README.md` | 只有模板，没有实际 theorem-use/failed-query card |

### 2.4 Formal knowledge substrate

| 证据 | 观察 |
|---|---|
| `docs/blueprint-coverage.json` | 1646 个 public declarations：791 theorem、646 def、171 structure、21 inductive、10 abbrev、7 opaque |
| 同上 | 1299 个 source docstring、1646 个 generated reader cue；这是文档覆盖，不是 reuse 质量 |
| `research-wiki/block-encoding-library/compiled-lean-leaf-index.json` | 旧索引只有 1084 个 declaration，缺少后来模块，且行记录只有 kind/name/file/line，没有 exact type/import/namespace/use example |
| `research-wiki/block-encoding-library/cards/` | 20 个 construction card，覆盖 product、LCU、sparse、dilation、QSVT 等 |
| `research-wiki/block-encoding-library/lean-lemma-tree.md`、`proof-network.md`、`route-selector.md` | 有 domain DAG、route 和 supplier/consumer 组织 |
| `tools/qbe.py:1741-1817` | task-specific file selection 和 name-only declaration index；可减少 RobinMatrix 上下文污染，但不返回完整 signature |
| `tools/test_qbe_control.py:834-857` | cubic query 会检索 product/state-preparation module，QSVT hint 优先 compiled product，exact root 可进入 memory card | `T`，不是因果 solve-rate 证据 |

以文件归属作一个**粗糙代理**：1646 个 public declarations 中，270 个位于
core/circuit/block-encoding/classics/resources/state-preparation/automation 基础模块，
1376 个位于 paper、task consumer、experimental 或 registry 模块。该比例不能判定
后者“低质量”，但足以说明 declaration 总数不能代替 cross-task reuse。仓库没有
“producer theorem → later distinct task consumer → unchanged successful instantiation”的
统一记录字段，因此无法计算真实 reuse rate。

### 2.5 当前 Lean gate

本次审计运行：

```text
python -m unittest tools.test_qbe_control -v
```

结果：33/33 通过。完整 `lake build && lake build Tests` 的本次结果记录在报告末尾。
当前源代码扫描发现：

```text
QuantumBlockEncoding/RobinMatrix.lean:26968: sorry
QuantumBlockEncoding/RobinMatrix.lean:26998: sorry
```

这两个 theorem 被文档明确标成 diagnostic/H-free route；它们仍证明当前 build
成功不等于 repository-wide sorry-free。

## 3. Benchmark case audit

“lower attempts”若无 raw JSONL，只报告可核实 snapshot/feedback 数，不从文件数量
猜测 agent call 数。

| Task/case | Root target 与 route | Population / harness / attempts | Lean root | Executable | Resource | Reuse 与 held-out 判断 |
|---|---|---|---|---|---|---|
| **BE Case 1 / `QBE-OP-OPTCTRL-001`** | concrete transfer operator；permutation completion → depth-5 → Pro equality-transfer → evolved parallel flip | candidate ledger 记录 Gen 0–9；Gen 6 有 Pro intervention；route ablation 有 real Lean-only 与 3-lower multi-agent run | `OptimalControl.evolvedEqFlipVerified` 等关闭 | Qiskit export reported passed | champion `(4,2,1,0)`；由 `(6,5,1,0)`、`(4,4,1,0)` 改善 | 有 candidate evolution 证据；task 与 solution 已公开污染，不是 held-out |
| **BE Case 1 cold clean / `QBE-OP-OPTCTRL-COLD-CLEAN-001`** | 独立 finite permutation | Hierarchical Harness；retrieval snapshot 最近 10 条中 4 failed、4 accepted、1 compiled、1 queued；不能视为完整 run | `coldE1Candidate_blockProjection` 与 permutation package 关闭 | finite/Qiskit pass | `(4,4,1,0)` | 不用 Pro candidate；仍使用当前 library，因此是 cold route evidence，不是 empty-library discovery |
| **Main-case COLD / `QBE-MAIN-CASE-HIER-COLD-001`** | task-local partial permutation → clean entry → bijection → projection → resource → package | 2 个 dated summaries；14 feedback，11 build true，6 theorem closed | `mainCaseColdPartialPermVerified` 关闭 | Qiskit/QASM/manifest/checker pass；wire map 曾漂移后修复 | `(5,5,1,0)` | 明确复用 `BlockEncodingClassics.partialPermutationCertificate`；是一个真实 cross-file reuse example，但未形成 held-out statistic |
| **Main-case PRO / `QBE-MAIN-CASE-HIER-PRO-001`** | Pro four-gate transcript；Lean 发现 transcript image 与 matrix-table candidate 不同，拆成两个 semantic tier | 1 个 dated summary；11 feedback，8 build true，5 theorem closed；有 Pro intervention | export-facing `mainCaseProCircuitVerified` 已命名；matrix-table 与 transcript 分离 | 当前 snapshot 的 Qiskit/QASM export 仍是 active/pending；目录只有不完整产物 | transcript `(4,4,1,0)` | 很好地证明 reviewer/counterexample 能阻止错误等同；不构成 held-out |
| **Historical cubic diagonal / `QBE-OP-CUBIC-DIAGONAL-001`** | primitive route 与 expanded arithmetic/controlled-$R_y$/uncompute route | 11 个 summaries；92 feedback；同一 bridge error 重复；candidate population 明确为 0 certified | 当时 `DIAG-ROOT-001` 未关闭 | export blocked | primitive conditional `(1,1,1,1)`；expanded 未可排名 | 证明 proof-DAG 能保存部分进展，也证明 assembly/semantic bridge 可长期阻塞 |
| **BE Case 2 hard cold** | exact rational diagonal Householder family | task 标记 Hierarchical；但 frozen final closeout input token `0`，population state 为空 | `cubicDiagonalHouseholderExactBEContract_complete` 关闭 | $n=2$ Qiskit/QASM pass；clean error 0；QASM operator error约 `1.86e-12` | 3 aux；QASM 638 gates/depth 465 是 finite transpiled count | 是“compiled root reuse + deterministic acceptance”，不是新的 agent synthesis |
| **BE Case 2 hard hinted** | linear $O_0$ Householder supplier + exact cubic root；QSVT optional | 同上：最终 0 input token、population empty | linear 与 cubic 两个 roots 关闭 | $n=2$ 两条 route 均 pass | linear 634/461，cubic 638/465（finite QASM） | hint 没有因 root 已存在而触发新的 QSVT discovery；不能评价 hint workflow 优劣 |
| **Cubic state preparation** | rank-one target；dense baseline、arithmetic transduction、Hadamard counting | 3 summaries；14 Markdown feedback；没有 full certified population | interface/count/ratio leaves 关闭；root block/unitarity 未关闭 | NumPy $n=1..6$、Qiskit Operator $n=1..4$、Katas-style $n=3$ 是 finite diagnostics | dense memory 指数增长；symbolic candidates `(10,10,52,10)` 与 `(8,8,21,8)` 仍未 certified | 可作为 training/evolution case；不能作为 solved benchmark，也不能把 finite pass 当 family certificate |
| **GHL2025 / RobinHeat / RobinMatrix** | one-term Robin、sparse access、function oracle、boundary rotation、LCU/block extraction | 没有可复现 raw run；大量 obligation/audit structures；external contracts 与 source convention blockers | one-term theorem-facing root 未关闭；两处 `sorry`；多项 `proved=false` | 无 root-tied executable acceptance | resource formulas 多为 contract/record，不是最终 certified resource | 强 external-contract benchmark；当前已深度污染，适合 training/diagnostic，不适合 held-out |
| **其他 initialized Game/isolated tasks** | task packets 存在 | 无对应可复现 closeout/log evidence | 未证实 | 未证实 | 未证实 | `INSUFFICIENT EVIDENCE`；目录存在不计 capability |

### 3.1 可组成 benchmark 的现有材料

- Level 1 候选：generic finite-index、matrix entry、permutation、sum collapse、
  first-column、clean-block leaves。必须新取 statement 或生成未见实例，不能直接用
  已公开 proof。
- Level 2 候选：partial permutation、product、two-term LCU、Householder、
  sparse row/column、dilation、QSVT supplier/consumer contracts。
- Level 3 training 候选：BE Case 1、historical cubic diagonal、cubic state
  preparation、GHL/Robin。

现有成熟 tasks **都不适合作为 held-out**：它们的 proofs、route cards、feedback、
candidate names 和 acceptance roots 均在检索空间。BE Case 2 hard arms 尤其不能被
误称为 held-out synthesis，因为 root 已在当前 compiled library 中。

## 4. Mechanism-by-mechanism verdict table

| Mechanism | Paper evidence | ABEIS evidence | Verdict | Main risk | Minimal action |
|---|---|---|---|---|---|
| A. Agent workflow evolution | single run 中 workflow/tool lineage 改善，best held-out 45.1%；主要胜者是 bounded repair | 只有 construction population；无 workflow version/archive/held-out score | **RUN CONTROLLED EXPERIMENT** | agent 改 verifier/target；在公开 tasks 上过拟合 | 固定 trusted runtime，只变 prompt/repair/retrieval/compression/leaf choice，先跑 Experiment 2 |
| B. Agent–benchmark coevolution | 76-task curriculum 对 fixed baseline 有更高 best held-out；结果非单调且单 run | 有足够 training task 家族，但没有 held-out split、task-family solve matrix | **RUN CONTROLLED EXPERIMENT** | curriculum 污染、family collapse、single champion 误校准 | 先冻结 static held-out，再运行 Experiment 4；不先改 production benchmark |
| C. Trusted runtime / mutable workspace isolation | 论文把 verifier、score、benchmark、context validation 放在 immutable parent；worker copy 隔离 | digest、root/executable recheck 已有；agent 仍直接写主 worktree，task/score/controller 可改，`sorry` 不 fail | **ADOPT NOW** | self-report/target mutation/acceptance spoof | 加 parent-owned trust manifest、isolated worktree、changed-path allowlist、new-sorry rejection；不开放 self-evolution |
| D. Fast repair lane | winning lineage 是 generate–compile–error–name-check–bounded-repair | 一个同 target ablation 中 Lean-only 356s，multi-agent 851s；cubic deep route有重复 bridge cycles | **RUN CONTROLLED EXPERIMENT** | 小 leaf 规则主观化；绕过 scientific construction | 用可测试 eligibility + bounded failures，运行 Experiment 1 |
| E. Representation-free proof context | verifier 能验证 root/node；实际 deep graph 很少，常为 shallow star | ABEIS 有 DAG/table/supplier-consumer/monolithic theorem，但 controller 只归一化 Markdown frontier rows，未独立编译任意 node context | **RUN CONTROLLED EXPERIMENT** | 丧失审计、binder/context node 伪关闭 | 只增加 representation adapter，统一降到 trusted node schema；不取消 root/dependency/stale rules |
| F. Reward redesign | final-proof-only 偏向 monolithic repair；论文没有实证证明 decomposition reward 更好 | ABEIS 已有 correctness/resource/export gates，但没有 workflow held-out/reuse/cost reward | **RUN CONTROLLED EXPERIMENT** | trivial lemma farming、牺牲 construction/resource、不可复现人工分 | 先补 instrumentation，再做 Experiment 3；不按 leaf 数奖励 |
| G. Lemma-name/signature repair | lineage 的高价值 mutable tools 是 `#check`、source grep、namespace/signature cache、bad-name ban | 有 name-only index、Mathlib grep、route cards；索引陈旧且无完整 type/import/example；failure cache 为空；仅找到一次明确 unknown identifier | **ADOPT NOW** | stale signature、错误 namespace、索引成为长上下文 | 建 deterministic `exact-signature` 输出与 success/failure cache，并做 Experiment 5 |
| H. Difficulty calibration | champion scalar difficulty 从 1.00 到 3.17；single-anchor、单 run | 无 held-out、无 task-stage response matrix、无多 anchor workflow | **INSUFFICIENT EVIDENCE** | 把 proof、construction、resource、export 压成一个错误 scalar | 只记录 stage vector；累计足够数据后再比较 family-specific/IRT |

## 5. Detailed mechanism audit

### A. Agent workflow evolution — `RUN CONTROLLED EXPERIMENT`

1. **论文依据。** §3.1 使 workflow/prompts/tools 可变；§4.3–4.4 显示 selected
   lineage 实际保留了 compiler repair、lemma-name checks、bounded retry。论文没有
   展示量子 construction policy 的进化。
2. **ABEIS 对应机制。** `candidate-populations/` 进化 construction candidate；
   `agent-profiles/`、prompt deck 和 `qbe.py` workflow 是手写静态机制。
3. **仓库证据。** candidate population 有真实资源改进；trial schema 没有
   `workflow_id`、`parent_workflow_id`、prompt hash、retrieval-policy version 或
   workflow held-out score。故“只进化 candidate、不进化 proof workflow”的判断成立。
4. **迁移风险。** ABEIS workflow 同时影响 scientific target、construction、
   Lean、resource、export；一个在 local leaves 上强的 repair loop 可能不会发现新
   Householder/LCU/QSVT route。共享 worktree 还使 unrestricted mutation 不安全。
5. **最小动作。** 定义 mutable manifest，仅包含 prompt、repair steps、retrieval
   policy、context compression、leaf-selection heuristic；其余全部 parent-owned。
   先做 Experiment 2，不上线 autonomous meta-agent。

### B. Agent–benchmark coevolution — `RUN CONTROLLED EXPERIMENT`

1. **论文依据。** §3.3 与 Appendix B 用 solve rate `0.30`、mastery `0.70`、
   每轮最多替换 6 task；§4.2 的 best held-out 高于 fixed，但轨迹非单调且无方差。
2. **ABEIS 对应机制。** task family、candidate population、epsilon stage 和
   exact/executable gates 已具备 curriculum 所需的结构，但没有 benchmark manager。
3. **仓库证据。** 现有 Level 1–3 材料充足；所有当前成熟 task 均可检索，且没有
   held-out manifest。hard cold/hinted 的 0-token closeout 证明 contamination/reuse
   必须显式标记。
4. **迁移风险。** 单纯按 Lean solve rate 会偏向局部 leaves；按 root rate 会因
   task family 极不均衡而失去信号；按 resource 改善又会混入 correctness 难度。
5. **最小动作。** 先创建 evaluator-owned static split：
   `train/evolution`, `development`, `held-out`; held-out proof 不进入 agent retrieval。
   更新依据用 certificate-stage vector，不直接复制 L1/L2/L3 scalar。

建议的 ABEIS 三层只用于分层采样，不用于假定难度：

- L1：局部 Lean leaves；
- L2：可复用 construction modules；
- L3：完整 scientific tasks。

每层再按 `family × stage` 分桶。benchmark 更新至少同时观察：

$$
(\text{spec valid},\text{candidate viable},\text{Lean root},
\text{export},\text{resource quality}).
$$

### C. Trusted runtime 与 mutable workspace — `ADOPT NOW`

1. **论文依据。** §3.1–3.2 明确规定 verifier、evaluation、benchmark、proof-context
   validation 不可变；worker 使用 copied workspace；parent 重验 final proof/node。
2. **ABEIS 对应机制。** current-source digest、typed feedback digest、root anchors、
   executable digest、artifact presence、no-progress 和 route lock 已是很好的逻辑边界。
3. **仓库证据。** `qbe.py` 直接以 repo root 启动 agent；没有 immutable path
   enforcement。task Markdown 决定 anchors/commands。Lean build 对两个 `sorry`
   仍返回成功。
4. **迁移风险。** 在引入 outer evolution 后，agent 可通过改 target、task anchor、
   controller 或 scoring 取得假胜；这不是理论风险，而是当前进程权限模型允许的路径。
5. **最小动作。**

   - parent 冻结 `target statement hash`、benchmark id/split、score version、
     verifier command、toolchain/package lock；
   - worker 使用独立 worktree/temp checkout；
   - allowlist 只允许 mutable workflow 和 task solution output；
   - parent 在干净 checkout 重跑 Lean 与 executable command；
   - 对 fully-qualified root/node 执行 evaluator-owned exact type check，不以 short-name
     文本存在代替 target equality；
   - reject 新增 `sorry`/`admit`/不允许的 `axiom`，并按 dependency closure 区分
     当前遗留 diagnostic sorry 与新 candidate；
   - success JSON 只作为输入，最终 JSON 由 parent 重建。

这一步采用的是**安全边界**，不是采用论文的无限制 self-modifying agent。

### D. Fast repair lane — `RUN CONTROLLED EXPERIMENT`

1. **论文依据。** §4.3 的 best lineage 是 full-proof generation、Lean compile、
   error/name inspection、bounded repair；10/12 次 repair 和复杂 subgoal assembly
   在一些 lineage 中反而退化。
2. **ABEIS 对应机制。** 当前 `execute` mode 仍通常安排 lower1、lower2、可能
   lower3/4 和 reviewer；小 leaf 没有独立、可测的 fast lane。
3. **仓库证据。**

   - 单个 route ablation：direct Lean `356.3s`，3-lower multi-agent `851.4s`；
     两者均 accepted。它只支持“值得复测”，不能给出普遍 speedup。
   - cubic diagonal 的 11 summaries、92 feedback 和 repeated bridge gaps 表明
     deep lane 可耗费大量状态同步，但这些 bridge 本身也不是小 theorem。
   - 一个 declaration-order unknown identifier 被一次局部移动修复，符合 fast
     repair 形状。

4. **迁移风险。** 把 construction discovery、external contract 或 resource
   redesign 误送 fast lane，会让 agent 只修表面 Lean error。
5. **最小动作。** eligibility 必须由可测试字段决定：

```text
scientific_target_hash unchanged
AND exact Lean statement present
AND imports fixed
AND no external_contract_gap
AND no construction/resource/export decision open
AND dependency count <= configured bound
AND prior failures on this statement < fast_repair_budget
```

最多 2 次 generate/compile/repair；随后自动升级 deep construction lane。fast lane
仍必须经过 parent Lean root 与 declared executable gate。

### E. Representation-free proof context — `RUN CONTROLLED EXPERIMENT`

1. **论文依据。** §3.2 允许 graph/tree/table，但强制 root、known dependencies、
   mathematical-node 区分和 Lean evidence；§4.5 显示多数 graph 浅且 node isolation
   失败。
2. **ABEIS 对应机制。** 已实际使用 proof DAG、obligation table、supplier-consumer
   card、route table、monolithic theorem + helpers。
3. **仓库证据。** controller 的可信输入是最新 Markdown frontier/obligation rows；
   verified leaf 依赖 feedback flag + declaration existence，而不是每个 arbitrary
   node 的独立 Lean file/context compilation。
4. **迁移风险。** binder、local hypotheses 和 imports 不完整会产生“主 proof 内可用、
   独立 node 不可用”的假复用；论文自己观察到这一失败。
5. **最小动作。** 允许前端 representation 多样，但都降到：

```text
node_id, kind, root?, statement, proof_body?, imports,
dependencies, diagnostic?, status, source_hash
```

solved mathematical node 必须在 evaluator 生成的独立 Lean context 中编译；diagnostic
node 不参与 dependency closure；source hash 改变后 stale node 不调度。

### F. Reward redesign — `RUN CONTROLLED EXPERIMENT`

1. **论文依据。** 论文 final-proof-oriented selection 保留 monolithic repair，却没有
   产生 deep reusable graph；作者将 decomposition reward 留作未来工作。
2. **ABEIS 对应机制。** candidate eligibility 要求 Lean correctness；同一 tier 内
   以 `(gateCount, depth, auxiliaryQubits, oracleCalls)` 排序；有 executable gate。
3. **仓库证据。** BE Case 1 证明 resource ranking 能产生 `(6,5,1,0)` →
   `(4,4,1,0)` → `(4,2,1,0)`；但无 workflow held-out、reuse、token、repair
   统一评分。route ablation 的 token 只是 proxy。
4. **迁移风险。** 奖励 leaf 数会制造 trivial wrappers；奖励 public declaration
   数会进一步放大 1646 count 的误导；奖励 local reuse 会鼓励同 task 自引用。
5. **最小动作。** 使用不可 gaming 的 staged lexicographic fitness，并先做
   Experiment 3。

#### 建议 fitness

所有比较先经过不可软化的 feasibility gate：

```text
F0 = target hash matches
   ∧ trusted Lean verification passes at claimed stage
   ∧ no forbidden proof shortcut in changed dependency closure
   ∧ declared executable gate passes when required
   ∧ benchmark split/score/runtime hashes unchanged
```

`F0=false` 的对象没有 fitness。其余按以下顺序比较：

1. `S`：certificate stage vector，依次为 spec、candidate semantics、Lean root、
   executable closure；
2. `Q`：task-family-specific resource Pareto rank；只在相同 semantic/asymptotic tier
   比较；
3. `H`：held-out success vector，按 family 和 stage 分层，不合并成单一平均数；
4. `U`：validated cross-task reuse，只计“该 workflow 新增的 theorem 被后续不同
   task 的 held-out consumer 在不修改 supplier statement 下成功 import/instantiate”；
5. `C`：在相同 `S/Q/H/U` 下最小化 model calls、provider tokens、wall time、
   Lean repair count 和 controller-only cycles；
6. `B`：robustness，要求 clean checkout replay、固定 evaluator/toolchain、多个
   run seed/backend sample 的下分位数，不用最佳单次。

现有日志可靠性：

| 分量 | 当前可计算性 |
|---|---|
| `F0` target/runtime immutable | 不完整；需要 trust manifest |
| Lean root / executable stage | 多个 task 可由 anchors、frozen acceptance 计算 |
| resource tuple | certified candidates 可计算 |
| held-out `H` | 不可计算；无 split |
| reuse `U` | 不可计算；无 producer-consumer event |
| model calls/tokens/repair/controller-only cycles | 仅 route ablation/本地 raw run 部分存在；公开 checkout 不可统一计算 |
| robustness `B` | 不可计算；没有多 seed/clean replay matrix |

### G. Lemma-name and signature repair — `ADOPT NOW`

1. **论文依据。** §4.4 的主要 tool evolution 是 `#check`、Mathlib source search、
   exact signatures、namespace cache、known-failed names 和 bad-name ban。
2. **ABEIS 对应机制。** `mathlib-search`、name-only local index、compiled leaf
   catalog、external atlas、route cards 已存在。
3. **仓库证据。**

   - generated compiled index 与 blueprint public count 不同步（1084 vs 1646）；
   - prompt-time index 只有 file/line/kind/name；
   - root-presence check 也使用 short-name 文本匹配，而不是 exact namespace/type；
   - Mathlib card 与 failure-memory 目录没有实际记录；
   - 找到一个明确 unknown-identifier 事件，它本质是声明顺序，不是名字幻觉；
   - 没有证据证明 theorem-name hallucination 是 ABEIS 当前最大瓶颈。当前最大可量化
     错误是 semantic bridge。

4. **迁移风险。** stale index 可能比无 index 更坏；长 signature dump 会增加 context；
   task-local theorem 被检索到也不代表允许跨 isolation boundary 作为 certificate。
5. **最小动作。** 增加 deterministic query：

```text
query -> fully qualified name
      -> exact pretty-printed type
      -> defining module/import
      -> source line/hash
      -> one repository-compiling use site
      -> isolation/reuse class
      -> known failed substitutions + Lean error digest
```

按 query 返回 top-k，不整库注入 prompt。每次命中/拒绝/repair 进入 Phase 0
instrumentation。先做 retrieval ablation，不能因论文结果直接宣称 solve-rate 提升。

### H. Difficulty calibration — `INSUFFICIENT EVIDENCE`

1. **论文依据。** single champion 在更新前后重测得到 scalar coefficient；论文自己
   报告 held-out 非单调和单 run 限制。
2. **ABEIS 对应机制。** exact/approximate phase、epsilon、capacity 和 task kind
   已显式，但不是 benchmark difficulty model。
3. **仓库证据。** 没有 held-out item response matrix、多 anchor workflow、
   repeated solve probabilities 或跨 family sample size。
4. **迁移风险。** 一个 scalar 会把 theorem repair、construction discovery、
   resource optimization、export 与 external-contract dependency 混为一谈。
5. **最小动作。** 暂只记录 difficulty vector：

$$
d_i=(d_{\rm spec},d_{\rm construction},d_{\rm proof},
d_{\rm exact/approx},d_{\rm resource},d_{\rm export},d_{\rm external}).
$$

先用多个固定 anchor workflows 收集分 family 的 stage success；数据足够后再比较
family-specific empirical rate、multi-anchor calibration 或 item-response model。

## 6. Current-system bottlenecks supported by logs

### 6.1 缺少可复现的公开 trial telemetry

这是最确定的元瓶颈。controller 能生成 trial JSONL、token proxy、control state，
但公开 checkout 刻意不保留。结果是 retrospective evaluation 无法回答：

- 每个 leaf 实际 model calls；
- repair 次数；
- controller-only cycles；
- prompt/provider tokens；
- workflow version；
- retrieval hit；
- theorem reuse；
- clean root/export closure latency。

这不说明本地日志不存在；只说明本次审计不能复算。

### 6.2 repeated semantic-bridge/no-progress

`QBE-OP-CUBIC-DIAGONAL-001` 的 92 个 JSON feedback 中，73 个是
`symbolic_bridge_gap`；`DIAG-ARITH-BACKEND-BRIDGE-001` 同类记录 14 次。11 个
curated summaries 后 root/export 仍未关闭。这里的问题不是 theorem-name guessing，
而是 route predicate、backend representation、workspace cleanup 和 clean-block
assembly 的接口不够可证或路线选择反复。

### 6.3 orchestration overhead 有一个正面信号，但证据量不足

同一个小型 transfer target 的 direct Lean route 为 356.3s，ABEIS multi-agent
route 为 851.4s，均通过。这支持 fast-repair experiment；一个 task、一次 route
不能支持全局简化 hierarchy。

### 6.4 external-contract 与 source-translation blockage

GHL/Robin 的 theorem-facing 10-gate circuit 与 active 7-gate backend 被显式记录为
不同；root flags 保持 false，并有 boundary-angle、sparse-access、function-oracle
external contracts。该阻塞由 Lean/audit fields 支持，不是 tactic 失败。继续增加
lower repair 不会自动解决来源约定。

### 6.5 proof-DAG assembly failure

historical cubic diagonal 和 cubic state-preparation 都关闭了多个 arithmetic、
ratio、interface、count 或 finite diagnostic leaf，却没有当时的 root certificate。
这说明“已有 DAG”不等于 dependency closure 自动组装成功。相反，Main-case COLD
展示了 reusable partial-permutation leaf 能顺利进入 task root；因此问题是
family/route-specific，不是所有 DAG 均无效。

### 6.6 retrieval 输出不完整，但未证实大规模 lemma hallucination

索引确实缺 exact signature/import/use cache，且有一个 unknown identifier repair。
然而当前 artifacts 没有大量 “unknown theorem” 记录；不能把论文的主要 failure
mode 直接宣布为 ABEIS 的主要 failure mode。deterministic retrieval 的理由是
低风险和可测，而不是已经证明它会解决 73 个 semantic bridges。

### 6.7 reuse attribution 不足

有明确个案，如 Main-case COLD 使用
`BlockEncodingClassics.partialPermutationCertificate`，hard BE Case 2 直接使用
compiled exact root。但没有统一 cross-task use event，无法衡量 route cards 是否
减少 calls，或 1646 declarations 中哪些实际贡献了新 task success。

### 6.8 trusted acceptance 对 `sorry` 不 fail

当前两处 `sorry` 与 successful build 可以同时存在。它们被正确标注为 diagnostic，
但 production self-evolution 不能只依赖 prompt discipline。需要 dependency-aware
new-sorry rejection。

## 7. Proposed experiments

### Experiment 1：Fast repair vs hierarchical vs game harness

- **Hypothesis**：对 statement/import/target 已冻结的小 leaf，bounded single-agent
  repair 的 closure/cost 优于 full harness；对 construction/semantic bridge 不成立。
- **Task split**：18–30 个 evaluator-owned、未见 proof 的 leaves；至少覆盖 finite
  index/permutation、matrix/sum、clean-block adapter 三 family。按 statement hash
  分 train calibration 与 held-out test；不使用已有 theorem 的改名副本。
- **Baseline**：current hierarchical harness；current game harness。
- **Treatment**：单 agent，最多 2 次 compile-repair；失败自动升级，但升级后的成本
  单独记账。
- **Metrics**：Lean closure rate、root consumer closure、wall time、model calls、
  provider tokens、invalid-name guesses、controller-only cycles、后续 distinct-task reuse。
- **Trusted boundary**：固定 Lean/toolchain/imports/statement/score；parent 重验；
  lane 不能写 task/benchmark/controller。
- **Stop condition**：每 arm 达预注册样本数；或某 arm 连续 6 个无合法输出；不因中期
  胜负提前挑选 task。
- **Expected artifacts**：split manifest、workflow hashes、per-attempt JSONL、
  Lean stdout digest、consumer test、aggregate confidence interval。
- **Failure interpretation**：fast lane 只在一个 family 胜，不推广；三者都低说明
  statement/retrieval 或 task sampling 有问题；fast lane leaf 成功但 consumer 失败
  说明生成的是局部不可复用 proof。

### Experiment 2：Static workflow vs evolved workflow

- **Hypothesis**：在 trusted runtime 固定时，prompt/repair/retrieval/compression/
  leaf-selection variants 能提升 held-out quantum Lean leaf success。
- **Task split**：training/evolution tasks、development tasks、严格 held-out tasks；
  family 和 certificate stage 分层。现有公开 tasks 只进 training。
- **Baseline**：当前 handwritten workflow，固定版本 hash。
- **Treatment**：自动 proposed variants；只允许修改五类 mutable files。
- **Metrics**：held-out stage success vector、root consumer success、resource regression、
  calls/tokens/time、invalid target mutation、failure-family distribution。
- **Trusted boundary**：verifier、target、split、score、logs、toolchain、acceptance
  command 全部 parent-owned；worker copy；变体输出由 parent 重验。
- **Stop condition**：固定 generation/population budget；三次连续 generation 无
  development Pareto improvement；held-out 只在预注册 checkpoint 运行。
- **Expected artifacts**：workflow archive、parent graph、diff allowlist、smoke results、
  active/dev/held-out score matrix。
- **Failure interpretation**：active gain/held-out loss 是过拟合；proof gain/resource
  loss 是 task-objective mismatch；大量 invalid variants 是 mutation interface 过宽。

### Experiment 3：Current scoring vs reuse-aware scoring

- **Hypothesis**：只奖励 validated cross-task consumer success，可提高 held-out
  composition，而不会制造 trivial lemmas。
- **Task split**：成对 supplier/consumer tasks；supplier family 不与 consumer proof
  同文件，consumer held-out。
- **Baseline**：root/resource/export lexicographic scoring。
- **Treatment**：加入上述 `U`，只在不同 task 的 unchanged supplier theorem 被成功
  import/instantiate 后给分。
- **Metrics**：held-out consumer closure、supplier theorem count、trivial/unused theorem
  rate、token cost、resource quality、root closure。
- **Trusted boundary**：consumer mapping evaluator-owned；agent 看不到计分 consumer；
  不按 leaf 数、docstring 或 declaration count 给分。
- **Stop condition**：固定 workflow generations；若 treatment 的 declaration 数增长
  2 倍但 consumer success 不增，触发 gaming stop。
- **Expected artifacts**：producer-consumer event log、theorem/source hashes、consumer
  imports、unused-declaration report。
- **Failure interpretation**：reuse 上升但 construction 下降说明 lexicographic 顺序
  错；lemma 数上升但 consumer 不升说明 metric 被 gaming。

### Experiment 4：Static benchmark vs coevolving benchmark

- **Hypothesis**：family-stratified benchmark refresh 能保持 active signal，同时不降低
  fixed held-out scientific-task performance。
- **Task split**：active pool 与永不参与 selection 的 held-out pool；按 family/stage
  配额。现有公开 tasks 只作为 training seed。
- **Baseline**：固定 active task set。
- **Treatment**：family/stage mastery-throttled replacement；不使用单一 scalar champion。
- **Metrics**：active solve/stage rate、held-out stage vector、catastrophic forgetting、
  family collapse、resource regression、external-contract abstention correctness。
- **Trusted boundary**：split、replacement pool、score、logs 不可变；agent 只能提交
  workflow。
- **Stop condition**：任一 family held-out success 连续两个 checkpoint 下降超过预注册
  阈值，或 resource Pareto rank 显著退化；先停止 replacement，不改 held-out。
- **Expected artifacts**：benchmark lineage、retirement/addition reason、multi-anchor
  response matrix、held-out checkpoint report。
- **Failure interpretation**：active 上升/held-out 不升说明 curriculum overfit；
  family collapse 说明 replacement 配额或 difficulty vector 错；两者均不升说明
  workflow mutation 没有有效自由度。

### Experiment 5：Retrieval ablation

- **Hypothesis**：exact signature + success/failure cache 比 README/route-card retrieval
  更少 invalid guesses，并提高相同成本下 closure。
- **Task split**：未见 proof 的 local adapters 与 Mathlib-dependent leaves；覆盖 namespace
  collision、import missing、polymorphic instantiation、declaration order。
- **Arms**：
  1. no retrieval；
  2. README/route cards；
  3. exact name/type/import/source；
  4. arm 3 + successful-use cache + failed-substitution/error cache。
- **Metrics**：closure、time/tokens、invalid names、wrong signatures、wrong imports、
  repeated failed substitutions、retrieval latency/context bytes。
- **Trusted boundary**：index 由 current trusted source 生成并带 source hash；agent
  不可写 index；cache event 由 verifier 生成。
- **Stop condition**：固定 query/attempt budget；stale index hash 立即 fail closed。
- **Expected artifacts**：query log、ranked result、selected theorem、Lean error mapping、
  source/use hashes、ablation table。
- **Failure interpretation**：arm 3 不优于 2 说明当前 bottleneck 不是 signature；
  arm 4 只省 token 不升 closure 仍可能有工程价值；context 增长抵消收益则降低 top-k。

## 8. Recommended implementation sequence

### Phase 0：不改行为，只补 instrumentation

每个 attempt/cycle 必须记录：

- `workflow_id`, `parent_workflow_id`, prompt/tool/retrieval hashes；
- model/backend/decoding、model-call count、provider input/output tokens；
- local prompt token proxy，明确与 provider tokens 分列；
- Lean compile/repair count 与 error digest；
- retrieval query/hits/selected signature/import/use-site；
- failed theorem/substitution cache event；
- controller mode 与 `controller_only_cycle`；
- candidate id/parent ids、scientific target hash、leaf/root id；
- root closure、executable closure、resource tuple；
- producer-consumer theorem reuse event；
- trusted runtime/split/score/toolchain hashes；
- clean checkout replay id。

raw logs 可以继续不公开，但应生成可提交的、去敏的 aggregate audit JSON，且不能只保留
最新 10 条 snapshot。

### Phase 1：低风险机制

1. parent-owned target/runtime/split/score manifest；
2. isolated worker worktree 与 changed-path allowlist；
3. dependency-aware new-`sorry`/`admit` rejection；
4. exact theorem signature/import/use lookup；
5. verifier-generated failed-name/substitution cache；
6. workflow version tracking；
7. static held-out split；
8. fast repair lane 仅作为 Experiment 1 treatment，不默认上线。

### Phase 2：受控 agent evolution

只允许修改：

- prompt；
- repair steps；
- retrieval policy；
- context compression；
- leaf-selection heuristic。

不允许修改 verifier、task statement、acceptance anchors、scoring、benchmark split、
trusted logs、toolchain lock 或 executable checker。selection 以 development 为主，
held-out 只在预注册 checkpoint 使用。

### Phase 3：benchmark coevolution

只有在以下条件满足后开始：

- static held-out 已冻结并能 clean replay；
- 至少两个 anchor workflows；
- 每个主要 family 有足够 item；
- stage vector、resource 和 cost telemetry 完整；
- Experiment 2 显示 workflow evolution 有 held-out 信号；
- Experiment 4 protocol 已预注册。

benchmark 更新应按 family/stage 配额，不用一个 champion scalar 决定全部难度。

## 9. Explicit rejection list

以下机制当前明确不采用，除非未来新证据推翻：

1. agent 可修改 Lean verifier、controller、acceptance anchors、score、split 或 logs；
2. 在共享主 worktree 内运行 self-modifying workflow；
3. 以 agent 自报 success JSON 作为 acceptance；
4. final-proof-only 作为 ABEIS 唯一 reward；
5. 按 leaf 数、public declaration 数或 docstring 数奖励 reuse；
6. 强制所有 task 使用 deep DAG；
7. 强制所有小 leaf 经过 upper/middle/lower/reviewer 或 Game Harness；
8. 强制所有 task 使用 monolithic repair；
9. 把 miniF2F/PutnamBench level 直接映射到 quantum construction；
10. 用一个 champion 的一次成绩作为唯一 difficulty anchor；
11. 在没有 static held-out 时启动 benchmark coevolution；
12. 把 controller replay 当 synthesis benchmark；
13. 把 finite $n=2$ Qiskit/QASM acceptance 当 symbolic family proof；
14. 把 hard BE Case 2 的 0-token root reuse 当 cold theorem discovery；
15. 把 1646 declaration count 当 theorem quality/reuse quality；
16. 删除 proof DAG、failure history、candidate population 或 executable acceptance；
17. 因论文 repair 胜出就删除 construction/decomposition lane；
18. 以不可复现人工判断决定 workflow champion；
19. 在无多 run/多 family 证据时宣布 outer evolution 提升 ABEIS；
20. 在现有 GHL/Robin diagnostic `sorry` 未做 dependency-aware 隔离时，把普通
    successful build 声称为 repository-wide sorry-free acceptance。

## 10. Final audit judgment

目标架构应是：

$$
\text{trusted ABEIS runtime}
\;-\;
\text{evolvable proof/construction workflow}
\;-\;
\text{quantum-domain formal knowledge}
\;-\;
\text{held-out scientific benchmark}.
$$

ABEIS 不需要变成 miniF2F prover。论文最值得借鉴的是：把 workflow 当可比较对象、
用 held-out 防止自我欺骗、在固定 verifier 外进行受限演化，以及认真对待 bounded
repair 的实际效率。ABEIS 必须保留并加强自己更关键的能力：construction route、
proof-DAG audit、exact/approximate control、certified population、resource ranking
和 post-Lean executable acceptance。

当前最科学的结论是：

- **立即硬化 trusted boundary 和 deterministic retrieval；**
- **立即补齐可复算 instrumentation 与 static held-out 设计；**
- **对 fast repair、workflow evolution、reuse reward、benchmark coevolution 做
  分阶段实验；**
- **在实验前不重构 production controller，不宣布性能提升。**

## 11. Changes and verification for this audit

### Changed files

- `paper-notes/system-comparisons/arxiv-2607.17352-abeis-adoption-audit.md`

### Exact behavior change

无 production behavior change；只新增可追踪审计报告。

### Tests run

```text
python -m unittest tools.test_qbe_control -v
lake build
lake build Tests
```

### Test results

- controller/retrieval/accounting unit tests：33/33 passed。
- Lean build：passed（1898 jobs；只有既有 linter warnings）。
- Lean Tests build：passed（1900 jobs；只有既有 linter warnings）。

### Remaining uncertainty

- raw trials/control/context packs 不在 checkout；
- 没有 held-out split；
- 没有多 seed、多 backend、多 workflow population；
- theorem reuse、provider tokens、repair count 和 controller-only cycle 无统一可复算数据；
- 论文自身是 single-run、single-backend study。

### Reversibility

本轮只新增一个 Markdown 文件，不改变 Lean、controller、task target、历史日志、
acceptance 或 executable artifact；删除该文件即可完全回滚。
