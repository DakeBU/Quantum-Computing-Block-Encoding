# 用户原始输入：QBE-OP-CUBIC-STATEPREP-001

假设 `n` 为正整数，是量子比特数。现在想要构造一个 state preparation
operator `O`，它实现：

```text
O |0^n> = sum_{j=0}^{2^n-1} f(x_j) |j^n>
```

其中：

```text
f(x) = x^3
x_j = j / 2^n
```

目标：构造这个 operator `O` 的 block-encoding `U_O`。

用户初始 tolerate precision:

```text
epsilon = 1e-10
```

系统要求：

- 规范地按照 ABEIS 规则测试；
- 这个例子可能会触发 Scenario 2；
- 适合测试 exact search 收敛不了后增加并行 agent 数量的功能；
- 尽量公平地对比其他公开库，判断是否 ABEIS 更适合构造这类 block encoding。
