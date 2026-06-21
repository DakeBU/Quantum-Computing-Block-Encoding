# 中文总结：clean-start transfer-operator 主例子

本报告对应任务 `QBE-OP-OPTCTRL-COLD-CLEAN-001`。它和之前受到
ChatGPT Pro 启发的 `QBE-OP-OPTCTRL-001` 是同一个类型的 operator 目标，
但这次隔离运行不允许使用旧解、Pro 提示或旧 Qiskit 代码。

## 目标

要构造

$$
E_1 = |0\rangle\langle 1|_T \otimes |0\rangle\langle 1|_\tau \otimes I_S
$$

的 block encoding。也就是说，要找一个带一个 clean signal qubit 的
unitary/permutation matrix，使得它的 clean block 正好等于上面的
operator。

## 当前是否成功

成功。Lean 里已经有：

- `coldE1Candidate_blockProjection`：证明 clean block 正好等于目标
  operator；
- `coldE1CandidateImage_permutation_certificate`：证明候选矩阵来自一个
  16 个 basis state 上的 permutation，因此是 unitary；
- `coldE1HighLevelSeedCost_*`：证明资源记录为
  `(gateCount, depth, auxiliaryQubits, oracleCalls) = (4,4,1,0)`；
- Qiskit/export 检查也通过，说明导出的有限矩阵和 Lean 证书对应。

## 和旧的 Pro-assisted 结果有什么区别

| 路线 | 是否用 Pro 提示 | 最终分数 |
| --- | --- | --- |
| 这次 clean-start Hierarchical Harness | 否 | `(4,4,1,0)` |
| 之前 Pro-assisted/evolved 路线 | 是 | `(4,2,1,0)` |

所以这次证明了系统自己能从目标 operator 出发构造并 Lean 验证一个正确
BE；之前 Pro 提示则显示外部专家/Pro 给一个好结构后，系统能进一步演化出
更浅的电路。

## 人类该怎么读这个结果

不要把这次结果理解成“已经证明最优”。它只证明：

1. 这个具体 `r=1,k=1` 例子有一个正确的 finite permutation block
   encoding；
2. 这个候选的 clean block、permutation 性质和资源字段都已通过 Lean；
3. Qiskit 代码是 post-Lean 的可执行导出，不是替代 Lean 证明。

## 关键文件

- Lean：`QuantumBlockEncoding/ColdStartTransferE1.lean`
- 中文/英文状态：`reports/QBE-OP-OPTCTRL-COLD-CLEAN-001/`
- 可复制到论文的 LaTeX：
  `paper-notes/problem-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/latest.tex`
- Qiskit/export：
  `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/`

