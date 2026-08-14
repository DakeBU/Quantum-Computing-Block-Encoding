# GHL2025 Open Contribution Todo

Rows here are GHL2025 source-paper objects whose Lean reproduction is not yet
closed.  They should not be mixed with external technical lemma todo items.

| id | main.tex anchor | paper object | Lean/status | depends on external? |
| --- | --- | --- | --- | --- |
| Uindic | main.tex:1056-1066 | Indicator unitary $U_{\mathrm{indic}}(K_1,K_2)$ | permutation/self-inverse helper 和 theorem-facing $U_{\mathrm{indic}}^\dagger$ slot 已编译；它仍不是 final block-encoding proof。 | False |
| RyBoundary | main.tex:1077-1085 | Boundary controlled $R_y$ rotations | fixed-N8 standard-Ry corrected route 已编译；原文单 arccos 仅保留为 source-typo transcript。 | True |
| RobinTheorem | main.tex:1098-1109 | Theorem：one-term Robin block-encoding | main active target：还没有作为 theorem-facing Lean statement 闭合。 | True |
| GammaSlices | main.tex:1111-1119 | Eq. ROBIN clarified | finite boundary instance 已有不少 route lemma；最终 projection/product bridge 还没闭合。 | True |
| FigRobin | main.tex:1122-1164 | Fig. 1-term Robin circuit caption | theorem-facing transcript guard 已编译：显式 $U_{\mathrm{indic}}^\dagger$ 和两侧 $H_W$ prepared route 可见；active backend 七门列表仍是独立 H-free component。 | True |
| OneD | main.tex:1171-1278 | One-dimensional Hamiltonian block-encoding | one-term Robin 闭合之后再做；不是当前 active theorem blocker。 | False |
| MultiD | main.tex:1596-1649 | Multi-dimensional block-encoding | planned；依赖 one-term 和 LCU abstractions。 | False |
