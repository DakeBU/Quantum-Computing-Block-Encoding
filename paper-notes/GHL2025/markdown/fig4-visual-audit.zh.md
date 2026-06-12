# GHL2025 Fig. 4 视觉审计

生成时间：`2026-06-13 01:20:14`

任务：`QBE-AUTO-002`

对应 run：`runs/20260611-234445-QBE-AUTO-002-cycle01`

图源：`outer_papers/quantum/GHL2025/Figures/1_term_ROBIN.pdf`

对应原文：`outer_papers/quantum/GHL2025/main.tex:1086-1164`

这个文件记录一次明确的视觉审计：Fig. 4 不是一个普通线性七门列表。它包含左右两侧 sparse-register preparation/cleanup、bulk/boundary 分支、indicator cleanup、function oracle、SWAP 和 sparse-access dagger cleanup。ABEIS 之前容易慢，是因为报告没有把“完整 Fig. 4 transcript”和“当前 H-free seven-gate backend 子组件”分得足够清楚。

## 图中从左到右的主结构

| 阶段 | 图中门/操作 | 普通解释 | Lean 中的对应 |
| --- | --- | --- | --- |
| 输入准备 | `H_W^(kappa)` 作用在 sparse index register，`U_indic` 作用在 system + indicator qubit | sparse register 制备均匀叠加；indicator 标记 bulk region | 完整 transcript: `oneTermRobinTheoremFacingFig4Circuit`; backend 子组件通常不含 `H_W` |
| `gamma_1` 到 `gamma_2` | bulk branch 用 `O^S_{D^T}`；boundary branch 用一组 controlled `R_y(theta_j^s)`；随后 `O^{BS}_{D^T}` 和 `U_indic^dagger` | 这一段负责 derivative operator 的 bulk/boundary 系数和地址 | Lean 中被拆成 sparse-amplitude/boundary Ry/ODBS/indicator cleanup 的 contract 与局部矩阵语义 |
| `gamma_2` 后 | `O_f`、SWAP、`(O_D^{BS})^dagger` | 加上 $f(x_i)$ 系数，交换两个 $n$-qubit register，再清理 sparse-access address | backend fold / branch contribution 相关 lemmas |
| 输出清理 | `(H_W^(kappa))^T` 作用在 sparse register；pure ancilla 返回 zero | 把 sparse register 和 pure ancilla 恢复到 block-encoding clean branch 所需状态 | source-prepared theorem-facing route 需要 `H_W` clean-column contract |

## 关键视觉事实

- `O_f` 不作用在 indicator qubit 上；caption 明说对应那根 1-qubit wire goes above the box。
- 图中 `O^{BS}_{D^T}` 和后面的 `(O_D^{BS})^dagger` 不是同一个方向的随意占位；前者写 transposed derivative sparse address，后者在 SWAP 后做 cleanup。
- `U_indic^dagger` 在图里是显式门，位于 `O^{BS}_{D^T}` 后、`O_f` 前；它不能被旧七门 backend 的不完整标签悄悄吞掉。
- 左右两侧 `H_W^(kappa)` / `(H_W^(kappa))^T` 是完整 Fig. 4 的一部分。当前 active backend seven-gate matrix 是为了局部有限矩阵语义而抽出的子组件，不能被称为完整 Fig. 4 proof。

## Lean 中两个 circuit list 的区别

| Lean 名称 | 角色 | 包含什么 | 不应怎么用 |
| --- | --- | --- | --- |
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit` | 完整 Fig. 4 transcript guard | `H_W^(kappa)`, `U_indic`, `O_DT^S`, `Ry_boundary`, `O_DT^BS`, `U_indic^dagger`, `O_f`, `SWAP`, `(O_D^BS)^dagger`, `(H_W^(kappa))^dagger` | 目前只是 transcript guard，不等于完整 semantic proof |
| `GHL2025.oneTermRobinCircuit` | active seven-gate backend 子组件 | `U_indic`, `O_DT^S`, `Ry_boundary`, `O_D^BS`, `O_f`, `SWAP`, `(O_D^BS)^dagger` | 不能叫完整 Fig. 4，也不能用它直接替代 source-prepared route |

## 当前没解决的真正 Lean 问题

现在不是“看不懂原文有没有证明”。问题更具体：

1. 完整 Fig. 4 要通过 `H_W` prepared route 进入 clean sparse branch。
2. 当前 Lean 已经有很多 feeder，能把目标化到 active seven-gate evaluated entry / prepared sparse clean entry / backend fold 之间。
3. 还缺一个语义矩阵 entry bridge：在 `Coeff.evalWith` 后证明这个 active entry 等于 backend fold，或等价地证明 source-prepared active entry 等于 prepared sparse clean entry。
4. 不能继续证明 raw `Coeff` expression tree 的 constructor equality，因为那不是论文语义，且已被 verifier 记录为 `symbolic_bridge_gap`。

## 下一轮 agent 任务约束

- upper：只选择一个 leaf：`semantic_eval_product_bridge` 或 `evaluated_backend_fold_leaf`。
- middle：必须先引用本文件，声明完整 Fig. 4 和 seven-gate backend 的区别。
- lower1 natural-language proof architect：把 Fig. 4 视觉路径写成依赖 DAG，不写 Lean。
- lower2 Lean worker：只在 `QuantumBlockEncoding/RobinMatrix.lean` 证明一个 `Coeff.evalWith` semantic entry lemma。
- lower3 necessary-condition verifier：先做 finite matrix/path/support 诊断，确认 active entry、branch vanish、register shape 没有反例，再把 typed feedback 写进 `verifier-feedback/`。
- reviewer：拒绝任何把 seven-gate backend 当完整 Fig. 4、把 external oracle contract 当 proved、或重试 raw `Coeff` equality 的路线。

