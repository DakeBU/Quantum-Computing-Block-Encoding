# ChatGPT Pro 注入的 `E_k` 构造摘要

任务 `QBE-OP-OPTCTRL-001` 的目标算子是

```text
E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n
```

也就是说，它只在输入分支 `time = k` 且 `type = 1` 时有作用，把该分支送到
`time = 0` 且 `type = 0`，同时完全保留 state register；其他输入分支在目标算子
里应当被消掉。因为这不是 system register 上的酉矩阵，所以必须把它嵌入到一个
更大的酉矩阵里，再取 clean-ancilla block。

## 新构造的直观流程

ChatGPT Pro 注入的构造可以理解成三个步骤。

第一步是 `O_eq`。它是一个等值检测/flag oracle，用来检查当前 basis branch 是否
满足

```text
T = k, tau = 1
```

这里 `T` 是 time register，`tau` 是 type register。检测结果写入 flag。只有满足
`(T = k, tau = 1)` 的分支被标为“选中”；所有其他分支保持为“未选中”。这一层本身
不应该声称已经实现了 `E_k`，它只是把目标分支标出来。

第二步是 `V_k`。它只对被 `O_eq` 标出的分支做转移，把该分支的标签从

```text
(T = k, tau = 1)
```

转到

```text
(T = 0, tau = 0)
```

state register 不变。因此，在选中分支上，`V_k` 实现了 `E_k` 要求的
`|k,1,s>` 到 `|0,0,s>` 的搬运。未选中分支不能也落入同一个 clean block，否则会污染
目标 block；它们后续必须被隔离到 ancilla 非零区域。

第三步是 `X_a`。它把被选中并已搬运到 `(T = 0, tau = 0)` 的分支移动到 clean
ancilla block，也就是最后投影时会读出的 `a = 0` 区域。所有没有被选中的分支都被
送到 `a = 1` 或其他 ancilla 非 clean 区域。因此，从 clean 输入到 clean 输出的矩阵
块只看见选中分支的贡献；其他分支虽然仍存在于完整酉矩阵中，但不会出现在
`(<0^a| ⊗ I) U (|0^a> ⊗ I)` 这个 clean block 里。

用一句话说：`O_eq` 标记目标输入分支，`V_k` 把目标分支搬到目标输出标签，
`X_a` 把目标分支送入 clean block，并把所有非目标分支送出 clean block。

## 对非 Lean 读者的关键点

完整电路必须是可逆/酉的，但目标算子 `E_k` 本身不是酉的。这个矛盾通过 ancilla
解决：完整空间里每个输入 basis state 都仍然被一一映射；只是 clean block 投影只
保留目标分支。非目标分支没有被删除，而是被安排到 ancilla `1`，因此在 clean block
里贡献为零。

这个构造如果成立，normalizer 应为 `alpha = 1`，因为目标是一个精确的 partial
isometry block，而不是近似缩放后的 block。本轮已经在具体 `r = 1, k = 1`、一个
state bit 的实例上用 Lean 验证了 clean-block 等式。

## 本轮 Lean 验证后的结论

需要区分两个目标：

1. 复现旧的某一个 permutation completion，也就是旧的 `exampleImage`。
2. 找任意一个 unitary/permutation completion，只要 clean block 等于 `E_1`。

Block encoding 只要求第二个目标。Pro 给出的四门构造并不等于旧的 `exampleImage`
permutation，但它仍然可以是合法 block encoding completion，因为非 clean-block 的
矩阵元有自由度。

Lean 中现在记录了 Pro 候选：

```text
CCX(type,time;aux);
CX(aux,time);
CX(aux,type);
X(aux)
```

在 Lean 的 reduced bit order 中是：

```text
CCX012; CX21; CX20; X2
```

它已经通过：

- `proEqTransferFull_isPermutation`：完整 active-plus-state completion 是 permutation；
- `proEqTransfer_cleanBlock`：clean block 等于具体 `E_1`；
- `proEqTransferCost_gateCount`：逻辑门数为 `4`；
- `proEqTransferCost_betterThan_depth5`：在同一逻辑门库下严格优于旧 depth-5 候选。

随后系统做了一次 EoH 风格 mutation：既然非目标分支只需要离开 clean block，不需要
保持旧 completion，就可以在 `O_eq = CCX(type,time;aux)` 之后直接并行翻转
`type,time,aux` 三个 active bit：

```text
Layer 1: CCX012
Layer 2: {X0, X1, X2}
```

这个 evolved 候选已经通过：

- `evolvedEqFlipFull_isPermutation`：完整 completion 是 permutation；
- `evolvedEqFlip_cleanBlock`：clean block 等于具体 `E_1`；
- `evolvedEqFlipCost_gateCount`：逻辑门数为 `4`；
- `evolvedEqFlipCost_betterThan_pro`：严格优于 Pro 候选；
- `evolvedEqFlipCost_betterThan_depth5`：严格优于旧 depth-5 候选。

当前 concrete finite champion 的逻辑评分是：

```text
depth = 2
gateCount = 4
auxiliaryQubits = 1
oracleCalls = 0
```

这里的 depth 2 来自两层：

1. Toffoli/CCX 标记唯一目标 clean 输入；
2. 三个互不共享 qubit 的 `X` 门并行执行。

## 必须 Lean 形式化的内容

需要在 Lean 中补齐以下对象和定理。

1. 定义一般的 register layout：time register、type register、state register、flag
   ancilla、clean/block ancilla，以及 `k` 的合法范围。
2. 定义目标矩阵 `E_k`：当且仅当输入列满足 `(T = k, tau = 1)` 且输出行满足
   `(T = 0, tau = 0)`、state 相同，矩阵元为 `1`；否则为 `0`。
3. 定义 `O_eq` 的有限置换或矩阵语义，并证明它正确设置 flag：flag 等于
   `((T = k) ∧ (tau = 1))`。
4. 定义 `V_k` 的置换/受控置换语义，并证明在 flag 为 true 的分支上，
   `(T, tau)` 被送到 `(0, 0)`，state register 不变。
5. 定义 `X_a` 的语义，并证明选中分支进入 clean block，未选中分支进入 ancilla `1`
   或其他非 clean block。
6. 证明组合 `U_k := X_a · V_k · O_eq` 是酉的，或者以有限置换双射证明作为酉性代理。
7. 证明 clean block 等式：

```text
(<0^a| ⊗ I) U_k (|0^a> ⊗ I) = E_k
```

8. 明确记录资源：ancilla 数、depth、gate count、oracle calls。若 `O_eq` 或 `V_k`
   仍是 oracle 级对象，必须在 score 中保留 unresolved oracle calls。

## 与先前 depth-5 有限候选的比较

先前已记录的有限候选是具体实例上的展开逻辑可逆电路：一个 time qubit、一个 type
qubit、一个 state qubit、`k = 1`，并且 active reduced register 为
`(aux,time,type)`。它有 Lean 检查过的 reduced permutation 证书和 passive-state lift
证书，expanded-tier score 为：

```text
depth = 5, gateCount = 6, auxiliaryQubits = 1, oracleCalls = 0
```

这个 depth-5 候选还不是一般 `k`、一般 state 维度的完整矩阵语义定理；它是一个已被
有限搜索和 Lean reduced-permutation 证书支持的具体候选。

新注入的 ChatGPT Pro 构造更像一般化的 proof architecture：它解释了如何用
`O_eq`、`V_k`、`X_a` 把任意 `E_k` 的选中分支放进 clean block，并把所有非选中分支
排除到 ancilla `1`。在具体实例上，它已经被 Lean 验证为优于 depth-5 候选；并且由它
启发出的 evolved 候选进一步把 depth 降到 `2`。

## 还没完成的事情

- 这些结论目前只针对具体 `r = 1, k = 1`、一个 state bit 的实例。
- 还没有把 `{X,CNOT,Toffoli}` 接入完整 gate-matrix semantics；当前证明使用有限
  permutation/function 语义和 clean-block 等式。
- 还没有把 depth-2 的 finite lower-bound 搜索反射进 Lean，只是 verifier feedback。
- 下一步应该把 evolved 思路推广到一般 time register width、一般 `k` 和任意 state
  dimension，并明确 MCX / mixed-polarity control 的资源模型。
