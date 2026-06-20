# Open External Technical Lemma Todo

These are not GHL2025's new contributions.  They are cited primitives,
standard facts, or reusable technical lemmas that current and future ABEIS
tasks may need.

| id | source | status | used by | next action |
| --- | --- | --- | --- | --- |
| tl-ghl-lemma1-banded-sparse-access | GHL2025 main.tex:784-798; previous PDE block-encoding construction | contract-only | GHL2025 Fig. 4; Robin boundary ODBS dagger cleanup | Keep as explicit external contract until the exact cited construction is formalized or imported as a theorem. |
| tl-ghl-lemma3-sparse-amplitude | GHL2025 main.tex:822-843 | contract-only | GHL2025 gamma_1/gamma_2/gamma_3 slices | Maintain the clean-branch contract and isolate any missing unitarity proof as an external technical lemma. |
| tl-ghl-theorem5-piecewise-polynomial-of | GHL2025 main.tex:870-908 | contract-only | GHL2025 one-term Robin operator A_k = f(x) partial_x^m | Use only as a named contract in the current theorem; do not invent stronger smoothness or range assumptions. |
| tl-uniform-sparse-register-preparation | GHL2025 main.tex:948-955; Shukla--Vedula 2024 | contract-only | GHL2025 Fig. 4 left/right sparse-register preparation | Keep as a theorem-facing contract unless the exact state-preparation proof is needed to close a resource theorem. |
| tl-ry-boundary-amplitude-convention | GHL2025 main.tex:1077-1085 | obligation | GHL2025 boundary-entry branch; active gamma_3 coefficient leaf | Do not silently change the paper angle; prove the convention bridge or record the exact cited convention. |
| tl-qsvt-blockencoding-simulation | GHL2025 main.tex:1676-1694; Gilyen et al. 2019 | paper-cited | GHL2025 Hamiltonian simulation section | Defer until the one-term Robin theorem and LCU combination are closed. |
| tl-clean-block-definition | GHL2025 main.tex:2027-2035 | contract-only | all theorem-facing block-encoding statements | Use as the final target predicate; ensure circuit entry lemmas are bridged to this semantic definition. |
| tl-cubic-diagonal-ry-clean-entry | QBE-OP-CUBIC-DIAGONAL-001 user operator target plus standard `R_y(theta)` convention | obligation | QBE-OP-CUBIC-DIAGONAL-001 `DIAG-EXP-RY-001`; `DIAG-RY-BRIDGE-001` | Scalar-tier specialization and conditional bridge are compiled; concrete backend witness remains an explicit open obligation. |
| tl-cubic-diagonal-reversible-cube-arithmetic | QBE-OP-CUBIC-DIAGONAL-001 expanded arithmetic route | obligation | QBE-OP-CUBIC-DIAGONAL-001 `DIAG-EXP-ARITH-001` | Active next leaf: prove or refine the reversible computation of `CubicStatePreparation.cubicAmplitude n j` into route workspace while preserving the system index. |
| tl-cubic-diagonal-clean-uncompute | QBE-OP-CUBIC-DIAGONAL-001 expanded arithmetic route | obligation | QBE-OP-CUBIC-DIAGONAL-001 `DIAG-EXP-UNCOMP-001` | Prove or refine that inverse arithmetic restores every workspace register to zero after controlled rotation and preserves the system index. |
