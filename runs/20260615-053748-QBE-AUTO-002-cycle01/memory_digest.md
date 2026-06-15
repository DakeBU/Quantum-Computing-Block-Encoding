# Memory Digest: QBE-AUTO-002 cycle 14

Generated: `2026-06-15 06:23:30`

Run directory: `runs/20260615-053748-QBE-AUTO-002-cycle01`

Task title: Concrete Circuit Matrix Semantics Backend

This is the compact retrieval packet for the next upper/middle cycle.  It keeps
the long log, paper-source map, typed verifier feedback, and Lean `sorry` scan
separate from the next lower-agent task package.

## Plain-language status

The current GHL case study is not blocked because the paper lacks a proof sketch.  It is blocked because ABEIS must turn the circuit in the paper into an exact matrix statement and prove that the clean block entry has the coefficient claimed by the paper.  In ordinary terms, the paper says that a specific path through the circuit leaves the desired coefficient, while Lean requires the corresponding matrix entry and all unwanted branches to be proved exactly.

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

- `QuantumBlockEncoding/RobinMatrix.lean:26125:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26155:  sorry`

## Active proof-DAG leaves

- 1. lower1 validates the source map and keeps the focused branch fixed to system entry `(0,0)`, sparse slot `2`, source-prepared projection, branch basis `[32,32]`, signal block `[0,0]`, and normalizer `N_D*N_f*kappa`.
- 2. lower3 verifies the compiled interface, normalizer bridge inputs, transcript split, active-backend contract wiring, and all false theorem flags before lower2 edits Lean.
- 3. lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and only for the one bridge theorem above. If it already exists, lower2 should make no Lean edit and log `error_class=stale_leaf`.

## Open GHL contribution obligations

| id | main.tex anchor | paper object | Lean/status | external lemma? |
| --- | --- | --- | --- | --- |
| Uindic | main.tex:1056-1066 | Indicator unitary $U_{\mathrm{indic}}(K_1,K_2)$ | permutation/self-inverse helper 和 theorem-facing $U_{\mathrm{indic}}^\dagger$ slot 已编译；它仍不是 final block-encoding proof。 | False |
| RyBoundary | main.tex:1077-1085 | Boundary controlled $R_y$ rotations | active convention audit：标准 $R_y(\theta)$ 给出 $\cos(\theta/2)$，所以 Lean route 必须确认论文 convention，或使用有原文/引用支持的 doubled-angle 修正。 | True |
| RobinTheorem | main.tex:1098-1109 | Theorem：one-term Robin block-encoding | main active target：还没有作为 theorem-facing Lean statement 闭合。 | True |
| GammaSlices | main.tex:1111-1119 | Eq. ROBIN clarified | finite boundary instance 已有不少 route lemma；最终 projection/product bridge 还没闭合。 | True |
| FigRobin | main.tex:1122-1164 | Fig. 1-term Robin circuit caption | theorem-facing transcript guard 已编译：显式 $U_{\mathrm{indic}}^\dagger$ 和两侧 $H_W$ prepared route 可见；active backend 七门列表仍是独立 H-free component。 | True |
| OneD | main.tex:1171-1278 | One-dimensional Hamiltonian block-encoding | one-term Robin 闭合之后再做；不是当前 active theorem blocker。 | False |
| MultiD | main.tex:1596-1649 | Multi-dimensional block-encoding | planned；依赖 one-term 和 LCU abstractions。 | False |

## Open external technical lemma obligations

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
| 2026-06-15 06:09:45 | theorem_facing_projection_interface_normalizer_bridge | symbolic_bridge_gap | None | None | lower1 and lower3 should validate the theorem-facing projection-interface normalizer bridge; lower2 should prove only oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3 in QuantumBlockEncoding/RobinMatrix.lean or log stale_leaf if it already exists. |
| 2026-06-15 05:37:04 | theorem_facing_finite_block_projection_interface | stale_leaf | True | True | Retire theorem_facing_finite_block_projection_interface as compiled non-promoting route memory. Middle should prepare the corrected theorem-facing finite block/projection equality or final coefficient bridge before any attempt at oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| 2026-06-15 05:34:48 | theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | lower2 may compile only OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface, oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3, and oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript in QuantumBlockEncoding/RobinMatrix.lean as a non-promoting interface packet. |
| 2026-06-15 05:34:40 | theorem_facing_finite_block_projection_interface | source_translation_gap | True | interface_only | lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean; if the declarations already exist, lower2 logs stale_leaf and makes no Lean edit. |
| 2026-06-15 05:34:35 | theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | Prepare the corrected theorem-facing finite block/projection equality before attempting oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| 2026-06-15 05:28:51 | theorem_facing_finite_block_projection_interface | source_translation_gap | True | interface_only | lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. Do not target root product-to-coefficient, backendExpansionStatement, diagnostic sorry routes, or any semantic-flag promotion. |
| 2026-06-15 05:19:33 | theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | lower2 may compile only OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface, oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3, and its transcript in QuantumBlockEncoding/RobinMatrix.lean as a non-promoting interface packet. Do not target oneTermRobinGamma3ProductToCoefficientObligation 3 0 0 or backendExpansionStatement. |
| 2026-06-15 05:18:27 | theorem_facing_finite_block_projection_interface | source_translation_gap | not_attempted_interface_packet_only | blocked_by_missing_theorem_facing_finite_block_projection_equality | lower3 verifies the source-prepared projection target, compiled audit, active backend wiring, and false flags; then lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. |

## Next lower-agent task split

| role | goal | artifact |
| --- | --- | --- |
| lower-1-natural-language-proof-architect | Translate the active source-paper proof step into a dependency DAG with exact source anchors and external-lemma calls. | proof-attempts/<task>/...-natural-language-dag.md |
| lower-2-lean-implementation-worker | Close one active Lean leaf only, preferably the smallest entry/evalWith bridge selected by the blueprint. | Lean declaration plus trial-log verifier-feedback fields |
| lower-3-necessary-condition-verifier | Check exact finite matrix/path/support conditions that must hold before the active Lean leaf can be true. | verifier-feedback/<task>/... plus trial-log feedback fields |
