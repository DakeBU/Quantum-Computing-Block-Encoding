# QBE-OP-OPTCTRL-001 多 agent 收敛运行总结

生成日期：2026-06-18 20:23:41

这是正式的收敛运行总结。当前聊天框作为人类交互顶层模块；upper、
middle、lower、reviewer 的角色化交接记录在 `dialogue.md`。本文件是
默认中文人类入口；英文版同步写在 `summary.en.md`。

## 目标算子

```text
E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state
```

目标不是只说明 oracle 存在，而是给出一个具体 unitary/circuit，使它的
clean block 正好等于上面的 `E_1`，并且 Lean 证明这个说法。

## 收敛图

下图只画已经通过 Lean 证书的候选。Python 搜索、模拟器输出、ChatGPT
Pro 建议在通过 Lean 之前只属于 insight pool，不会被画成已完成结果。

![E_1 block-encoding certified evolution](../../../docs/assets/optctrl_evolution.png)

## 各代 Lean-verified block encoding 线路图

这些图使用量子线路社区通用的 wire/control 记号；只展示已经有 Lean
证书的 block-encoding 候选。

### Generation 0：oracle-level seed

![Oracle-level seed](../../../docs/assets/optctrl_oracle_baseline.png)

- Lean 证书：`OptimalControl.exampleVerified`
- 资源 tuple：`(gateCount, depth, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1)`
- 解释：这是正确的一辅助量子比特 block-encoding seed，但包含一个未展开的
  permutation-completion oracle，因此只作为 correctness baseline。

### Generation 2：depth-5 logical completion

![Depth-5 logical completion](../../../docs/assets/optctrl_depth5.png)

- Lean 证书：`OptimalControl.reducedDepth5Verified`
- 关键 Lean 锚点：`reducedDepth5Unitary_isRationalOrthogonal`,
  `reducedDepth5Unitary_cleanBlock`, `reducedDepth5GateImages_eval`
- 资源 tuple：`(6, 5, 1, 0)`
- 解释：这是第一个完全展开到逻辑 `{X,CNOT,Toffoli}` 门库的正确构造。

### Generation 6：ChatGPT Pro equality-transfer candidate

![Equality-transfer candidate](../../../docs/assets/optctrl_pro.png)

- Lean 证书：`OptimalControl.proEqTransferVerified`
- 关键 Lean 锚点：`proEqTransferUnitary_isRationalOrthogonal`,
  `proEqTransferUnitary_cleanBlock`, `proEqTransferGateImages_eval`
- 资源 tuple：`(4, 4, 1, 0)`
- 解释：Pro 的建议先进入 insight pool；Lean 证明通过后才升级为 certified
  population。它给出了“先标记选中 branch，再移动到 clean block”的结构。

### Generation 7：evolved equality-flag + parallel flips champion

![Evolved champion](../../../docs/assets/optctrl_evolved.png)

- Lean 证书：`OptimalControl.evolvedEqFlipVerified`
- 关键 Lean 锚点：`evolvedEqFlipUnitary_isRationalOrthogonal`,
  `evolvedEqFlipUnitary_cleanBlock`, `evolvedEqFlipGateImages_eval`,
  `evolvedEqFlipCandidate_cost`
- 资源 tuple：`(4, 2, 1, 0)`
- 线路：

```text
CCX(type,time -> auxiliary)
then parallel X_type, X_time, X_auxiliary
```

这是当前 concrete logical `{X,CNOT,Toffoli}` tier 的冠军构造。

## 为什么判断收敛

lower necessary-condition verifier 对 reduced 三比特 `{X,CNOT,Toffoli}` 全
方向逻辑门库做了精确枚举：

- 3 个门以内没有任何正确 clean-block 构造；
- 4 个门有正确构造；
- 4 个门以内没有 depth 1 的分层构造；
- depth 2 的 witness 正好是当前 Lean 已验证冠军。

因此，在具体 `r = 1, k = 1` 逻辑门库层面，继续 mutation/crossover 追求
更少门或更浅深度已经没有必要。这个 finite verifier 是收敛证据，不是
Lean 形式化的 lower-bound theorem。

## 边界

这不是硬件门分解最优性结论，不是任意 `k` 或任意 time-register 宽度的
通用 theorem，也不是 Lean 形式化 lower-bound theorem。下一步应该是：

1. 把有限枚举 lower bound 形式化进 Lean，如果论文需要 theorem；
2. 把 `r = 1, k = 1` 推广到更宽 time register；
3. 加硬件门分解 backend 并重新评分；
4. 把 operator-to-certificate 流程接到用户网页和母语报告接口。
