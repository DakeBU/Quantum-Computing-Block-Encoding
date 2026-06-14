# GHL2025 未完成与失败原因中文地图

生成时间：`2026-06-14 01:30:28`

任务：`QBE-AUTO-002`

对应 run：`runs/20260614-004100-QBE-AUTO-002-cycle01`

这个文件回答一个很具体的问题：**GHL 原文里哪些地方还没有被成功翻译成 Lean code，失败原因是什么，失败记录在哪里？**

它不是正式论文证明，也不是 Lean 证明。它是给人类上层 agent、合作者和不熟悉 Lean 的读者看的导航页。正式可信状态仍以 `QuantumBlockEncoding/` 里的 Lean 编译和 `sorry` 数量为准。

配套图像审计：`paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`

## 先读结论

- GHL2025 的 one-term Robin block-encoding 还没有完整 Lean 复现完成。
- 当前没有完成的是 Fig. 4 / Eq. ROBIN clarified / one-term theorem 之间的最后矩阵条目桥接：论文说线路的 clean branch 会留下目标系数；Lean 需要我们把具体门矩阵相乘，并证明指定 entry 正好等于这个系数。
- 视觉审计已确认：完整 Fig. 4 包含左右两侧 `H_W^(kappa)` / `(H_W^(kappa))^T` 和显式 `U_indic^dagger`。当前 active seven-gate backend 只是子组件，不能被当成完整 Fig. 4 theorem。
- 现在剩下的主要失败不是“论文没有写证明”，而是 ABEIS 当前 Lean 表达层级还差一个语义桥：不能继续强证 raw `Coeff` symbolic matrix 的构造子相等，应该在 `Coeff.evalWith` 后的矩阵语义层证明 entry equality。
- 外部 oracle、$H_W$ sparse-register preparation、$O_f$、QSVT 等还没有都从零 formalize；当前它们被明确记录为 contract 或 external technical lemma，不应冒充为已经由 GHL 本文贡献证明。

## 当前 Lean 明确未闭合处

- `QuantumBlockEncoding/RobinMatrix.lean:24871:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:24901:  sorry`

这两个 `sorry` 是显式诊断 blocker，不是隐藏在文字里的假设。它们阻止我们声称 GHL one-term Robin theorem 已经闭合。

## GHL 原文到 Lean 失败地图

| GHL 原文位置 | 原文在说什么 | Lean/ABEIS 对应位置 | 当前状态 | 失败或未完成原因（普通话） | 失败记录在哪里 | 下一步 |
| --- | --- | --- | --- | --- | --- | --- |
| `main.tex:1098-1109` | one-term Robin block-encoding theorem：最终要证明 Fig. 4 的 circuit 是 $A_k=f(x)\partial_x^m$ 的 block-encoding。 | `QuantumBlockEncoding/RobinMatrix.lean`；目标链包含 `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` 和 source-prepared theorem-facing wrapper。 | 未完成。 | 最后还没证明 active clean branch 的矩阵 entry 等于论文需要的 block-encoding 系数。已有很多局部 feeder，但最终 theorem 不能因为 feeder 编译就算完成。 | `runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md`；`runs/20260614-004100-QBE-AUTO-002-cycle01/memory_digest.md`；`proof-attempts/QBE-AUTO-002/post-lower2-evaluated-fold-semantic-bridge-middle-packet-20260611-2352.md` | 只攻击一个最小 leaf：`semantic_eval_product_bridge` 或 `evaluated_backend_fold_leaf`，证明 evalWith 后的矩阵乘积 entry 等于 backend fold。 |
| `main.tex:1111-1119` | Eq. ROBIN clarified：给出 $\gamma_1,\gamma_2,\gamma_3$，其中关键 clean branch 是 $f(x_i)D_i^{(s)}/(N_DN_f\kappa)$。 | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`；backend branch fold；selected slot `2`。 | 部分完成。 | backend 侧很多 branch vanish/support lemma 已编译，但还没把 active evaluated entry 和 backend fold 完全接上。也就是说，论文里的“这个分支留下目标系数”还没被 Lean 证明成最终等式。 | `verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md`；`proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md` | 用 `Matrix.evalWith_mul_apply`、`Matrix.evalWith_mul_unique_path`、`Matrix.evalWith_mul_two_path` 这一类语义引理，不再走 raw constructor equality。 |
| `main.tex:1122-1164` | Fig. 4 circuit caption：完整线路顺序，包括左侧 $H_W^{(\kappa)}$、`U_indic`、boundary $R_y$、$O_f$、SWAP、$(O_D^{BS})^\dagger$、右侧 $H_W^T$。 | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`；另有 H-free active backend seven-gate component。 | 图的 transcript guard 已有；最终语义 theorem 未完成。 | ABEIS 已经把“图里应出现哪些门”守住了，但“这些门相乘后的目标 entry 正确”还没完全证明。七门 backend 是中间组件，不等于完整 Fig. 4 theorem。 | `runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md` 的 `FigRobin` 行；`conversion-windows/QBE-AUTO-002.md`；`proof-obligations/QBE-AUTO-002.md` | 保持图的门顺序不变；把 H-free 七门 backend 当作组件，不把它误报为完整线路。 |
| `main.tex:1077-1085` | Robin boundary 的 controlled $R_y$ 旋转，论文写 $\theta_j^s=\arccos(D_j^{(s)}/N_D)$。 | boundary rotation convention lemmas；`tl-ry-boundary-amplitude-convention`。 | 仍是 obligation。 | 标准量子计算里的 `R_y(\theta)` 振幅常出现半角 $\cos(\theta/2)$。如果论文采用不同 convention 或隐含 doubled-angle，Lean 必须明确桥接，不能硬改公式。 | `research-wiki/technical-lemmas/todo.md`；`research-wiki/paper-contributions/GHL2025/todo.md` | 查论文定义和引用文献，确认 convention 后写成 Lean lemma；不能自己加新假设。 |
| `main.tex:948-955` | $H_W^{(\kappa)}$ 制备 sparse register 的 uniform superposition。 | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`。 | contract-only。 | 这是论文引用的已有 state-preparation primitive，不是当前 GHL 自己新证明的核心。为了先复现 GHL 主线，可以把它作为显式 contract，但不能说 gate-level proof 已完成。 | `research-wiki/technical-lemmas/todo.md`；`runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md` 的 `HW` 行 | 先保持 theorem-facing contract；若以后做资源定理或完整 gate-level primitive，再 formalize 引用文献。 |
| `main.tex:784-798` | Lemma 1：banded-sparse-access oracle $\hat O_D^{BS}$。 | `tl-ghl-lemma1-banded-sparse-access`；sparse-access oracle contract。 | contract/backlog。 | 论文引用前人 PDE block-encoding 构造；ABEIS 还没有从零证明 reversible extension、injectivity、dagger cleanup、unitarity。 | `research-wiki/technical-lemmas/todo.md`；`research-wiki/cited-results/GHL2025.md` | 保持为 external technical lemma；后续做 oracle library 时补完整证明。 |
| `main.tex:822-843` | Lemma 3：sparse-amplitude oracle $\hat O^S_{D^T}$，clean branch 给出 $D^{(s)}/N_D$。 | `tl-ghl-lemma3-sparse-amplitude`。 | contract/backlog。 | clean branch contract 可用于 GHL 主 theorem；sqrt complement、normalizer、unitarity 还没完整形式化。 | `research-wiki/technical-lemmas/todo.md` | 不在 one-term theorem 阶段重做全部 oracle primitive；只保留明确 contract。 |
| `main.tex:870-908` | Theorem 5：piecewise-polynomial $O_f$ amplitude oracle，clean branch 给出 $f(x_i)/N_f$。 | `tl-ghl-theorem5-piecewise-polynomial-of`；$O_f$ clean branch contract。 | contract/backlog。 | 这是外部/前置 oracle construction；当前没有完整 formalize $N_f$ bound、workspace orthogonality、unitary completion。 | `research-wiki/technical-lemmas/todo.md`；`runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md` 的 `Of` 行 | 先用于 theorem-facing contract；不要把它和 GHL one-term proof 的完成混淆。 |
| `main.tex:1171-1278` | 1D Hamiltonian block-encoding，用 LCU 组合多个 one-term operator。 | planned module / proof obligations。 | 未开始主体证明。 | 它依赖 one-term Robin theorem。当前 one-term 没闭合，所以 1D Hamiltonian 不是本轮 blocker。 | `runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md` 的 `OneD` 行；`proof-obligations/QBE-AUTO-002.md` | one-term theorem 关闭后再启动 LCU abstraction。 |
| `main.tex:1596-1649` | 多维推广。 | planned。 | 未开始主体证明。 | 依赖 one-term、1D Hamiltonian 和 LCU generalization。 | `runs/20260614-004100-QBE-AUTO-002-cycle01/zh_summary.md` 的 `MultiD` 行 | 暂不分配 lower agent。 |
| `main.tex:1676-1694` | Hamiltonian simulation / QSVT 引用。 | `tl-qsvt-blockencoding-simulation`。 | paper-cited/backlog。 | 这是把 block-encoding 用于 simulation 的外部 theorem application，不是 Fig. 4 gate-level closure。 | `research-wiki/technical-lemmas/todo.md` | 等 block-encoding theorem 完成后再接 QSVT。 |

## 最近一次失败到底失败在哪里？

最近 lower2 试图证明：

```lean
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
```

它尝试用 `rfl` 或 definitional equality 证明“由 gate list 乘出来的矩阵”和“手写的 seven-gate matrix”完全相等。Lean 返回：

```text
maximum recursion depth has been reached
```

普通解释是：这不是单纯算不过去，而是路线不对。我们现在的 `Coeff` 是 symbolic expression tree；同一个数学矩阵乘法，如果括号嵌套不同，raw constructor 级别不一定长得完全一样。论文需要的是“矩阵语义相等”，不是“Lean 表达式树长得一模一样”。所以正确路线是先用 `Coeff.evalWith` 把 symbolic coefficient 解释成语义值，再证明对应 entry 相等。

对应失败记录：

- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-lower2-blocked-20260611-2348.md`
- `verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md`
- `proof-attempts/QBE-AUTO-002/post-lower2-evaluated-fold-semantic-bridge-middle-packet-20260611-2352.md`

## 现在真正应该派给 lower agent 的任务

不要再派 raw `Coeff` matrix equality。下一步应该派一个更小、更符合论文证明含义的 leaf：

1. 目标：证明 active seven-gate evaluated entry 等于 backend branch fold。
2. 文件：`QuantumBlockEncoding/RobinMatrix.lean`。
3. 优先引理层级：`Coeff.evalWith` 后的语义矩阵 entry。
4. 可用工具：`Matrix.evalWith_mul_apply`、`Matrix.evalWith_mul_unique_path`、`Matrix.evalWith_mul_two_path`、`Matrix.evalWith_mul_eq_zero_of_all_paths_zero`。
5. 不允许：改 gate order、改 normalizer、给 oracle 加论文没有的假设、把 contract-only external primitive 标成 proved。

## 人类最快查看命令

```bash
cd <ABEIS repo root>

sed -n '1,260p' HUMAN_STATUS.md
sed -n '1,320p' paper-notes/GHL2025/markdown/unresolved-failures.zh.md
sed -n '1,220p' runs/20260611-234445-QBE-AUTO-002-cycle01/zh_summary.md
sed -n '1,180p' verifier-feedback/QBE-AUTO-002/evaluated-backend-fold-lower2-20260611-2348.md
```

以后每次 6h 循环结束，`python3 tools/qbe.py human-status QBE-AUTO-002` 会刷新 `HUMAN_STATUS.md` 和本文件。
