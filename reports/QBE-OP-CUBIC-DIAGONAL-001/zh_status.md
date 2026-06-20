# 立方对角 oracle block-encoding 状态

生成时间：2026-06-20 12:44 JST

## 目标

令 `N = 2^n`。目标算子是对角矩阵 $D_n$：基态 `j` 上的对角元为
$(j/N)^3$，非对角元为零。归一化因子是 `alpha = 1`。这个任务不是
把立方向量归一化后的秩一态制备问题。

## Lean 当前支持的结论

Lean 中的 `cubicDiagonalOperator`、`cubicDiagonalTarget` 和
`exactNormalizer` 已经固定了目标算子和归一化因子。

固定分母算术路线已有若干逐点算术叶子关闭：
`fixedDenomCubicPayload_lt_capacity`、`fixedDenomCubicAmplitude_eq`、
`fixedDenomCubicArithmeticBackend`、`fixedDenomCubicArithmeticBackend_computes`、
`expandedArithmeticComputesCubicAmplitudeTransparent` 和
`fixedDenomCubicArithmeticRouteTransparent`。

透明 controlled-`R_y` 记账也已经关闭：
`expandedControlledRyUsesCubicAngleTransparent`、
`fixedDenomControlledRyRouteTransparent`，以及让
`expandedAmplitudeOracleCleanBlockContract` 使用透明 rotation 谓词的合同重构。
这些声明只是 expanded 路线的接口证据；它们不是旧的不透明谓词证明，也不是
block-encoding 根证书。

透明 clean-uncompute 接口现在已经编译：
`ExpandedArithmeticCleanUncomputeWitness`、
`expandedWorkspaceCleanUncomputedTransparent` 和
`expandedWorkspaceCleanUncomputedTransparent_of_witness`。这只是接口证据，不是
不透明 cleanup 谓词的证明，也还没有实例化固定分母路线。

当前 proof-DAG 活跃叶子是
`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`。下一步 Lean 工作是用固定分母
modular add/sub 的 compute/uncompute 步骤来实例化
`expandedWorkspaceCleanUncomputedTransparent n (3 * n)`。另一个独立依赖
`DIAG-RY-WORKSPACE-READONLY-001` 仍需要一个命名 Lean 陈述；在这之前，route-level
cleanup 或 extraction 不能依赖这个 cleanup 见证。

clean-block extraction、unitarity/circuit semantics、根证书 `DIAG-ROOT-001` 和
可执行导出仍然阻塞。

## 人类读者入口

| 文件 | 用途 |
|---|---|
| `tasks/QBE-OP-CUBIC-DIAGONAL-001.md` | 用户目标和算子合同 |
| `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | Lean 与自然语言对应关系 |
| `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md` | 未关闭的证明义务 |
| `candidate-populations/QBE-OP-CUBIC-DIAGONAL-001.md` | certified、finite-executable 与 insight-pool 的区分 |
| `reports/QBE-OP-CUBIC-DIAGONAL-001/zh_status.md` | 首选语言状态页 |
| `reports/QBE-OP-CUBIC-DIAGONAL-001/latest.md` | 英文状态镜像 |
| `paper-notes/problem-exports/QBE-OP-CUBIC-DIAGONAL-001/latest.tex` | closeout LaTeX 证明/状态说明 |

## 当前阻塞点

expanded 路线已经有透明算术、透明 rotation 记账和透明 cleanup 接口，但还没有
固定分母 cleanup 见证，也没有 Lean 中命名的 rotation workspace-readonly 陈述。之后
还需要 route-level cleanup、clean-block extraction 和 unitarity，根证书才能关闭。

## 目前不能写进手稿的主张

不能声称这个任务已经有 Lean 认证的 exact block encoding。也不能声称
primitive oracle 语义已经证明、expanded gate circuit 已经完整证明为 unitary、
Qiskit/QuantumKatas-style/QASM3 导出已经认证、该构造资源最优，或者把对角算子目标
替换成秩一态制备目标。

## 可执行导出

用户请求的 Qiskit、QuantumKatas-style 和 QASM3 导出仍然阻塞。只有在某个命名的
Lean 证书关闭 `DIAG-ROOT-001` 之后，才应创建
`executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` 导出包。
