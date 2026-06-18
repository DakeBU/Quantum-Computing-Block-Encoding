# Memory Digest: QBE-OP-OPTCTRL-001 cycle 1

Generated: `2026-06-18 20:23:41`

Run directory: `runs/manual-multiagent/20260618-lexelim-ek-convergence`

Task title: Operator of optimal control paper

This is the compact retrieval packet for the next upper/middle cycle.  It keeps
the long log, paper-source map, typed verifier feedback, and Lean `sorry` scan
separate from the next lower-agent task package.

## Plain-language status

This cycle is an exploratory block-encoding construction task.  The target is the concrete optimal-control transfer operator E_1.  The current report should state the best Lean-certified concrete logical reversible permutation-matrix block encoding, its resource score, and the remaining generalization, lower-bound, and hardware-decomposition obligations.

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  A failure is useful
because it usually means the current target, index map, or circuit transcript
is wrong.  A pass only says that the target survived this exact finite check;
Lean must still close the theorem or keep the dependency as an explicit
contract.

| proof part | fast check | why this is a necessary condition | what Lean still proves |
| --- | --- | --- | --- |
| active [0,0] entry | exact rational matrix or path-sum evaluation | if the exact finite entry is not the target coefficient, the Lean equality for that entry cannot be true | a passing check is only a counterexample filter; Lean must still prove the named entry lemma |
| remaining branch vanish/cancel | support and path checker for the remaining backend slots | if an unwanted clean-branch path survives numerically, the block projection cannot match the paper target | Lean must still prove the zero/cancellation lemma in the formal circuit semantics |
| Ry boundary convention | symbolic 2-by-2 rotation check | a mismatched half-angle convention changes the boundary amplitude before any Lean tactic is relevant | Lean must still record the convention bridge as a source-supported theorem |
| sparse-access map | finite range/injectivity/permutation check | a reversible oracle cannot exist for a colliding or out-of-range finite map | Lean must still prove the reversible extension and cleanup obligations |
| coefficient oracle clean branch | exact finite evaluator for f(x_i)/N_f | the final block entry uses this coefficient, so a wrong clean branch invalidates the target theorem | Lean must still prove bounds, orthogonality, and unitary completion or keep them as contracts |

## Lean theorem closure signal

- `QuantumBlockEncoding/RobinMatrix.lean:26968:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26998:  sorry`

## Active proof-DAG leaves

- No dynamic proof-DAG leaf detected.

## Open current-task contribution obligations

| id | main.tex anchor | paper object | Lean/status | external lemma? |
| --- | --- | --- | --- | --- |
| Uindic | main.tex:1056-1066 | Indicator unitary $U_{\mathrm{indic}}(K_1,K_2)$ | permutation/self-inverse helper 和 theorem-facing $U_{\mathrm{indic}}^\dagger$ slot 已编译；它仍不是 final block-encoding proof。 | False |
| RyBoundary | main.tex:1077-1085 | Boundary controlled $R_y$ rotations | active convention audit：标准 $R_y(\theta)$ 给出 $\cos(\theta/2)$，所以 Lean route 必须确认论文 convention，或使用有原文/引用支持的 doubled-angle 修正。 | True |
| RobinTheorem | main.tex:1098-1109 | Theorem：one-term Robin block-encoding | main active target：还没有作为 theorem-facing Lean statement 闭合。 | True |
| GammaSlices | main.tex:1111-1119 | Eq. ROBIN clarified | finite boundary instance 已有不少 route lemma；最终 projection/product bridge 还没闭合。 | True |
| FigRobin | main.tex:1122-1164 | Fig. 1-term Robin circuit caption | theorem-facing transcript guard 已编译：显式 $U_{\mathrm{indic}}^\dagger$ 和两侧 $H_W$ prepared route 可见；active backend 七门列表仍是独立 H-free component。 | True |
| OneD | main.tex:1171-1278 | One-dimensional Hamiltonian block-encoding | one-term Robin 闭合之后再做；不是当前 active theorem blocker。 | False |
| MultiD | main.tex:1596-1649 | Multi-dimensional block-encoding | planned；依赖 one-term 和 LCU abstractions。 | False |

## Open current-task cited-contract obligations

| id | source | status | used by | next action |
| --- | --- | --- | --- | --- |
| tl-ghl-lemma1-banded-sparse-access | GHL2025 main.tex:784-798; previous PDE block-encoding construction | contract-only | GHL2025 Fig. 4; Robin boundary ODBS dagger cleanup | Keep as explicit external contract until the exact cited construction is formalized or imported as a theorem. |
| tl-ghl-lemma3-sparse-amplitude | GHL2025 main.tex:822-843 | contract-only | GHL2025 gamma_1/gamma_2/gamma_3 slices | Maintain the clean-branch contract and isolate any missing unitarity proof as an external technical lemma. |
| tl-ghl-theorem5-piecewise-polynomial-of | GHL2025 main.tex:870-908 | contract-only | GHL2025 one-term Robin operator A_k = f(x) partial_x^m | Use only as a named contract in the current theorem; do not invent stronger smoothness or range assumptions. |
| tl-uniform-sparse-register-preparation | GHL2025 main.tex:948-955; Shukla--Vedula 2024 | contract-only | GHL2025 Fig. 4 left/right sparse-register preparation | Keep as a theorem-facing contract unless the exact state-preparation proof is needed to close a resource theorem. |
| tl-ry-boundary-amplitude-convention | GHL2025 main.tex:1077-1085 | obligation | GHL2025 boundary-entry branch; active gamma_3 coefficient leaf | Do not silently change the paper angle; prove the convention bridge or record the exact cited convention. |
| tl-qsvt-blockencoding-simulation | GHL2025 main.tex:1676-1694; Gilyen et al. 2019 | paper-cited | GHL2025 Hamiltonian simulation section | Defer until the one-term Robin theorem and LCU combination are closed. |
| tl-clean-block-definition | GHL2025 main.tex:2027-2035 | contract-only | all theorem-facing block-encoding statements | Use as the final target predicate; ensure circuit entry lemmas are bridged to this semantic definition. |

## Recent typed verifier feedback

| time | leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- | --- |
| 2026-06-18 20:11:35 | lexelim-convergence-finite-search-20260618 | manual-packet |  |  |  |
| 2026-06-17 17:06:44 | pro-construction-search | manual-packet |  |  |  |
| 2026-06-17 17:06:23 | evolved-cleanblock-search | manual-packet |  |  |  |
| 2026-06-17 16:21:20 | reduced-depth-search | manual-packet |  |  |  |

## Next lower-agent task split

| role | goal | artifact |
| --- | --- | --- |
| lower-1-natural-language-proof-architect | Translate the active source-paper proof step into a dependency DAG with exact source anchors and external-lemma calls. | proof-attempts/<task>/...-natural-language-dag.md |
| lower-2-lean-implementation-worker | Close one active Lean leaf only, preferably the smallest entry/evalWith bridge selected by the blueprint. | Lean declaration plus trial-log verifier-feedback fields |
| lower-3-necessary-condition-verifier | Check exact finite matrix/path/support conditions that must hold before the active Lean leaf can be true. | verifier-feedback/<task>/... plus trial-log feedback fields |
