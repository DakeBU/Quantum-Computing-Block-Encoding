# Next Todo Packet: QBE-OP-OPTCTRL-001 cycle 1

Generated: `2026-06-18 20:23:41`

## Lower 1: Natural-language proof architect

1. Read the current construction status and candidate population row for the active optimal-control block-encoding witness.
2. Write the exact source-proof translation: source anchor, local theorem goal,
   dependency DAG, external technical lemmas, and route rejected by verifier.
3. Do not change Lean code.

## Lower 2: Lean implementation worker

1. Pick one active proof-DAG leaf from the retrieval index.
2. Prove the smallest build-testable declaration; do not refactor the paper
   construction or change assumptions.
3. Log typed verifier feedback with `trial-log --feedback-field`.

## Lower 3: Necessary-condition verifier

1. Do not try to close the theorem by broad Lean search.
2. Run or design a finite matrix/path/support check that must pass if the
   active Lean leaf is true.
3. Record typed verifier feedback: `finite_matrix_ok`, `block_entry_ok`,
   `source_correspondence_ok`, `error_class`, and `next_route`.
4. If the diagnostic fails, ask middle to repair the target before lower 2
   spends another large proof attempt.

## Open current-task contribution obligations

| id | main.tex anchor | paper object | Lean/status |
| --- | --- | --- | --- |
| Uindic | main.tex:1056-1066 | Indicator unitary $U_{\mathrm{indic}}(K_1,K_2)$ | permutation/self-inverse helper 和 theorem-facing $U_{\mathrm{indic}}^\dagger$ slot 已编译；它仍不是 final block-encoding proof。 |
| RyBoundary | main.tex:1077-1085 | Boundary controlled $R_y$ rotations | active convention audit：标准 $R_y(\theta)$ 给出 $\cos(\theta/2)$，所以 Lean route 必须确认论文 convention，或使用有原文/引用支持的 doubled-angle 修正。 |
| RobinTheorem | main.tex:1098-1109 | Theorem：one-term Robin block-encoding | main active target：还没有作为 theorem-facing Lean statement 闭合。 |
| GammaSlices | main.tex:1111-1119 | Eq. ROBIN clarified | finite boundary instance 已有不少 route lemma；最终 projection/product bridge 还没闭合。 |
| FigRobin | main.tex:1122-1164 | Fig. 1-term Robin circuit caption | theorem-facing transcript guard 已编译：显式 $U_{\mathrm{indic}}^\dagger$ 和两侧 $H_W$ prepared route 可见；active backend 七门列表仍是独立 H-free component。 |
| OneD | main.tex:1171-1278 | One-dimensional Hamiltonian block-encoding | one-term Robin 闭合之后再做；不是当前 active theorem blocker。 |
| MultiD | main.tex:1596-1649 | Multi-dimensional block-encoding | planned；依赖 one-term 和 LCU abstractions。 |

## Open current-task cited-contract obligations

| id | status | next action |
| --- | --- | --- |
| tl-ghl-lemma1-banded-sparse-access | contract-only | Keep as explicit external contract until the exact cited construction is formalized or imported as a theorem. |
| tl-ghl-lemma3-sparse-amplitude | contract-only | Maintain the clean-branch contract and isolate any missing unitarity proof as an external technical lemma. |
| tl-ghl-theorem5-piecewise-polynomial-of | contract-only | Use only as a named contract in the current theorem; do not invent stronger smoothness or range assumptions. |
| tl-uniform-sparse-register-preparation | contract-only | Keep as a theorem-facing contract unless the exact state-preparation proof is needed to close a resource theorem. |
| tl-ry-boundary-amplitude-convention | obligation | Do not silently change the paper angle; prove the convention bridge or record the exact cited convention. |
| tl-qsvt-blockencoding-simulation | paper-cited | Defer until the one-term Robin theorem and LCU combination are closed. |
| tl-clean-block-definition | contract-only | Use as the final target predicate; ensure circuit entry lemmas are bridged to this semantic definition. |
