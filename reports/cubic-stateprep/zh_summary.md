# QBE-OP-CUBIC-STATEPREP-001 中文状态总结

这个任务的输入是：

```text
O |0^n> = sum_j (j / 2^n)^3 |j>
```

关键点：右边一般不是归一化量子态，所以它不能直接作为一个
unitary state-preparation circuit 的输出。ABEIS 当前把它严格建模为
秩一算子：

```text
O_n = |v_n><0^n|,  v_n[j] = (j / 2^n)^3.
```

也就是说，`O_n` 把输入 `|0^n>` 送到用户写的未归一化向量，把其他
输入基态送到 0。之后我们构造的是这个非 unitary operator 的
block encoding。

当前已经完成：

- Lean 中已定义目标 operator、误差 `epsilon = 1e-10`、Scenario 2 策略；
- 默认 `lake build && lake build Tests` 通过；
- `RobinMatrix` 历史未闭合证明不再进入默认检查；
- 文档已经明确：不能把未归一化向量误当成 unitary state preparation。

当前还没完成：

- 还没有找到并 Lean 证明最终 approximate block encoding；
- 还没有证明完整的误差预算；
- 还没有跑完和 Qiskit/QASM/QuantumKatas 等外部路线的公平对比。

下一步最合理的路线：

1.  exact BE 搜索只给很小预算；
2.  如果 exact synthesis 没有进展，进入 Scenario 2；
3.  用 reversible arithmetic 近似计算 `(j / 2^n)^3`；
4.  把 arithmetic approximation、rotation synthesis、block-entry error
    分配到总误差 `1e-10` 内；
5.  小规模用 executable verifier 做 fixed-instance executable check，大规模用 Lean 证明
    symbolic family。
