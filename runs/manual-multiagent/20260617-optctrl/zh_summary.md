# QBE-OP-OPTCTRL-001 中文摘要

## 目标算子是什么

本轮 explore-mode 任务研究最优控制论文里的查询算子族

```text
E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n
```

直观地说，`E_k` 只在一个很窄的输入分支上有作用：

- `time` 寄存器必须处在 `|k>`；
- `type` 寄存器必须处在 `|1>`；
- `state` 寄存器上的向量保持不变，也就是乘上 `I_n`。

在这个分支上，算子把状态搬到

```text
|0>_time |0>_type |state>
```

其他输入分支全部被送到零。因此 `E_k` 不是系统寄存器上的酉矩阵，而是一个部分等距/秩受限的线性算子。要把它用于量子线路，需要把它嵌入到更大的酉矩阵里，并证明干净辅助比特块满足

```text
(<0^a| ⊗ I) U (|0^a> ⊗ I) = E_k / alpha
```

当前具体实例取 `k = 1`，一个 time 比特、一个 type 比特、一个 state 比特，所以系统维度是 `8`，再加一个辅助比特后酉矩阵维度是 `16`。归一化因子 `alpha = 1`。

## Lean 已经验证了什么

Lean 中已经有一个具体的、一辅助比特的排列补全候选：

- `exampleOperator` 定义了具体的 `E_1`：它把 `|1>_time |1>_type |s>` 映到 `|0>_time |0>_type |s>`，其中 `s = 0, 1`。
- `exampleImage` 定义了 16 个基态上的排列补全。活跃分支用四循环补全；其他分支交换辅助比特。
- `exampleImage_isPermutation` 证明了这个映射确实是有限排列，因此对应一个排列酉。
- `exampleUnitary` 把这个排列写成矩阵。
- `example_cleanBlock` 证明了干净辅助比特块正好等于 `exampleOperator`。
- `exampleVerified` 把“酉性代理证明”和“块等式证明”打包成已验证候选。

这个基线的资源分数是

```text
depth = 1, gateCount = 1, auxiliaryQubits = 1, oracleCalls = 1
```

这里的 `gateCount = 1` 不是说已经有一个基础硬件门实现，而是说整个排列补全还被当作一个未展开的 oracle 调用。它是正确性基线，不是硬件级线路。

Lean 还验证了一个展开后的逻辑可逆线路：

```text
CCX(0,1;2);
CX(0,1);
CX(1,0);
X(0);
{X(2), CX(0,1)}
```

这里的三个活跃比特是 `(aux, time, type)`，`state` 比特是被动的。Lean 中的 `reducedDepth5Image_eq_target` 已经证明：这个深度 5 的逻辑可逆线路，在 8 个 reduced basis state 上实现了与目标排列相同的映射。`reducedDepth5Cost_gateCount` 和 `reducedDepth5Cost_oracleFree` 记录了它的逻辑资源：

```text
depth = 5
logical gate count = 6
auxiliaryQubits = 1
oracleCalls = 0
gate library = {X, CNOT, Toffoli}
```

本轮之后还补上了一个关键提升证明：`reducedDepth5_lifts_exampleImage` 证明这个三比特 reduced 线路在加上被动 `state` 比特以后，确实等于完整 16 维排列 `exampleImage`。因此当前已经不只是 reduced 层面的有限等式，而是“reduced 线路 + 被动 state bit”到完整 permutation 的 Lean 检查等式。

## 还只是有限检查或逻辑层面的内容

当前 depth-5 结果还不是完整的块编码定理。

已经 Lean 验证的是 reduced 三比特排列等式，以及它提升到完整 16 维 permutation 的 passive-state lift。还没有完成以下提升：

- 把每个 `X`、`CNOT`、`Toffoli` 门接入项目里的完整线路语义，而不只是用手写的有限函数表示。
- 证明由这些门组成的完整矩阵的 clean block 等于 `E_1`。
- 把具体的一个 state 比特推广到任意 `n` 个 state 比特。
- 把 Toffoli 分解到选定的硬件门库并重新计算硬件深度和门数。
- 证明 depth 5 或 gate count 6 在当前逻辑门库下是可由 Lean 信任的最优结论。

所以目前可以说：depth-5 逻辑线路是一个 Lean 检查过的有限候选，并且已经提升到完整 16 维 permutation；但它还不是完整 gate-semantics block-encoding 证明，因为每个逻辑门的矩阵语义和最终 clean-block 推导还没有接上。

## population search 找到了什么

搜索把 oracle 基线和展开逻辑线路分成两个层级比较：

- oracle 基线：`(depth, gateCount, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1)`，正确但含一个未解析 oracle。
- 展开逻辑层级：目标是消除 oracle，并在 `{X, CNOT, Toffoli}` 逻辑可逆门库里优化。

搜索过程的主要结果：

- 第 1 代找到一个顺序展开线路，分数 `(6, 6, 1, 0)`。
- 第 2 代通过调度把最后的 `X(2)` 和 `CX(0,1)` 并行化，得到当前 champion：`(5, 6, 1, 0)`。
- 第 3 代尝试零额外辅助比特，被必要条件排除：目标算子本身不是系统寄存器上的酉矩阵。
- 第 4 代尝试两个辅助比特，没有降低 depth 或 gate count，辅助比特反而增加。
- 第 5 代尝试按 state bit 拆分 source-target cycles，结果仍然归约到同一个 active reduced permutation，没有严格改进。

短程结论是：在当前具体实例和当前逻辑门库下，搜索在三轮后没有找到严格优于 `(5, 6, 1, 0)` 的 oracle-free 逻辑候选。这只是 population 管理结论，不是数学上的最优性证明。

独立 lower verifier 还做了一个穷举层搜索：在 `{X, CNOT, Toffoli}` 三比特逻辑可逆门库和“不共享 qubit 的门才可并行”的规则下，depth `< 5` 的所有层序列都没有达到目标 permutation；depth 5 下找到了当前 champion，并且在 depth 5 的目标 witness 里没有找到少于 6 个逻辑门的实现。这是很强的有限搜索证据，但还不是 Lean 内部的 lower-bound theorem。

## 下一步最值得做的事

下一步应优先把现有 depth-5 逻辑候选变成完整 Lean 语义定理：

1. 用项目里的 circuit/gate 语义表达这个线路，而不是只用 finite function。
2. 从完整线路语义推出 clean-block 等式 `E_1`。
3. 再考虑推广到任意 state 寄存器维度。
4. 最后才讨论 Toffoli 分解和硬件资源评分。
