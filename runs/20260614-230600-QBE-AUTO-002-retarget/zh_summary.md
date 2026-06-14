# QBE-AUTO-002 retarget 中文总结：从 H-free backend 退回 source-prepared projection

日期：2026-06-14

本轮不是继续硬证明旧的 `backendExpansionStatement`。上层和中层重新检查后，结论是：旧目标已经被 Lean 否掉，后续证明必须改成忠实对应 Guseynov-Huang-Liu 2025 论文 Fig. 4 的 source-prepared product/projection theorem。

## 1. 当前最重要结论

旧目标：

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

不再是“还没找到 Lean 证明”的目标，而是一个已经被 no-go theorem 排除的错误目标：

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3 :
  ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

通俗地说，旧目标把论文 Fig. 4 中间的 backend 七门部分当成了整个 block-encoding projection。这个做法漏掉了 Fig. 4 两侧的 sparse-register preparation / unpreparation，也就是 `H_W^(kappa)` 和 `(H_W^(kappa))^dagger`。Lean 已经发现：如果强行证明这个 H-free backend expansion，会推出 selected slot contribution 在所有环境下等于 `0`；但我们已有一个 all-one witness 让同一项等于 `1`。所以旧路线不能再给 lower agent 当作正向目标。

## 2. 对应 GHL 原文哪里

本轮 retarget 对应 GHL2025 的这些位置：

| 原文位置 | 对我们 Lean 目标的含义 | 当前状态 |
| --- | --- | --- |
| Eq. `arbitrary sparcity` | `H_W^(kappa)` 的 sparse-register preparation contract | 作为外部合同 `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` 使用，不在本 leaf 内证明 |
| Eq. `ROBIN clarified` | Robin 边界 gamma3 sparse summand 和 backend branch fold | 已进入 backend branch contribution 的 Lean 数据 |
| Fig. `fig:1 term ROBIN` | theorem-facing 电路是 `(H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)` | 旧 H-free backend route 漏掉两侧 preparation，必须退役 |
| Definition `def:block-encoding` | block-encoding 读取 clean ancilla projection entry | 下一目标必须是 prepared clean-clean projection，不是裸 backend `[0,0]` entry |

## 3. 新 theorem 应该怎么说

新路线必须以 source-prepared clean projection 为左端：

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
=
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

这句话的数学意思是：在 sparse-preparation 合同 `hUniform` 下，比较完整 Fig. 4 source-prepared composite circuit 的 clean-clean entry 和 backend branch fold。它保留了 `H_W^(kappa)` 两侧电路，因此不会退化成已经被 Lean 否掉的 H-free backend expansion。

当前已经有可复用的 compiled bridge：

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
```

所以下一轮不应再证明一个同义 wrapper。真正应该新增的是一个 product/projection obligation packet，把这个 source-prepared projection 和固定的 product-to-coefficient obligation 接起来。

## 4. 建议新增的 Lean 结构

上层建议新增一个显式 obligation 结构，名字可用：

```lean
OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation
```

它应该记录：

- `sourceTarget`：`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`
- `productRoute`：现有 product-under-contracts route
- `productBridge`：`oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`
- `preparedBackendEvalStatement`：prepared clean projection 到 backend fold 的已编译 equality
- `fixedProductObligation`：固定为

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

- `forbiddenBackendExpansionParent := true`
- 所有最终证明 flag 仍为 `false`，包括 `productToCoefficientProved`、`normalizedBlockEqualityProved`、`blockProjectionProved`、`blockCorrectProved`、`finalExtractionProved`

这个结构的目的不是“证明完成”，而是把 proof DAG 的活跃节点从错误的 H-free backend expansion 切换到正确的 source-prepared product/projection theorem。

## 5. 下一轮 lower agents 应该做什么

lower1：自然语言 proof architect

- 写清楚新的 source-prepared proof DAG。
- 明确旧的 `backendExpansionStatement` 不允许作为 parent。
- 解释 Fig. 4 的 clean projection 如何进入 fixed slot-2 boundary product。

lower2：Lean implementation worker

- 先只添加 `OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation` 和对应 `_n3` packet / transcript theorem。
- transcript theorem 只做 definitional checks：固定 obligation 是 `(3,0,0)`，prepared backend equality 来自 source-prepared bridge，所有下游 theorem flags 保持 false。
- 暂时不要证明最终 product-to-coefficient equality，避免再次把目标展开成巨大矩阵。

lower3：verifier / reviewer

- 检查任何新 parent、hypothesis、transcript 字段里都不能出现被否掉的 `backendExpansionStatement`。
- 检查新 packet 的 entry 是 prepared composite clean entry，而不是 H-free signal-zero unitary entry。
- 检查 fixed product route 仍是 system row/column `(0,0)`、sparse slot `2`、full basis index `32`。

## 6. 还没完成什么

当前 GHL one-term Robin case study 仍未闭合。未完成的是：

1. source-prepared product/projection obligation packet 还没有正式进 Lean。
2. finite projection/summation theorem 还没有证明：也就是从 source-prepared clean projection 到 focused slot-2 branch product 的有限矩阵桥。
3. normalized product-to-coefficient equality 还没有证明：也就是把 branch product、`N_D`、`N_f`、`kappa`、boundary rotation coefficient 合并成论文目标系数。
4. LCU correctness、block projection、block correctness、final extraction 仍是后续 leaf。
5. 两个旧的 diagnostic `sorry` 仍存在，但它们属于 H-free diagnostic route，不能用于 theorem closure。

## 7. 给 ChatGPT Pro 的任务边界

ChatGPT Pro 应该帮我们用自然语言设计 corrected proof blueprint，而不是写最终 Lean patch。它需要判断：

- 下一个 lower2 target 应该是 full product-to-coefficient equality，还是更小的 slot-to-signal-block projection lemma。
- 新 target 为什么不会推出已经被否掉的 H-free backend expansion。
- `hUniform` 应该只作为 source-prepared projection bridge 的合同，而不是被本 leaf 证明。
- normalizer 假设应该放在哪一层 lemma，而不是塞进 GHL 原 theorem 增强假设。

一句话：本轮已经把错误门关掉；下一轮要把 proof DAG 切到论文真正的 prepared clean projection，再从那里接 fixed product-to-coefficient obligation。
