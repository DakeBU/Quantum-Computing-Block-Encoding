# ChatGPT Pro Prompt: ABEIS QBE-AUTO-002 cycle 14

Copy everything below this line into ChatGPT Pro.

---

You are helping with ABEIS, an Auto-Block-Encoding-in-Sleep Lean 4 project for
quantum oracle and block-encoding circuit formalization.  You cannot access my
local files.  Please use only the public links below and the self-contained
status copied into this prompt.  Local Lean names and file paths are labels to
help me patch my repository later; do not assume you can open them.

## Public sources you may use

- Guseynov--Huang--Liu, "Quantum framework for simulating linear PDEs with
  Robin boundary conditions": https://arxiv.org/abs/2506.20478
- PDF: https://arxiv.org/pdf/2506.20478
- The relevant source-paper region is the one-term Robin block-encoding circuit
  around the paper's Fig. 4 and the theorem/equations corresponding to the
  Robin boundary construction.  In my local source map this is tracked as
  `main.tex:1098-1164`, but you should cite the public paper by theorem,
  equation, figure, and page/section rather than relying on local line numbers.

## Current ABEIS task

Task: `QBE-AUTO-002`

Title: Concrete Circuit Matrix Semantics Backend

Run label: `20260615-053748-QBE-AUTO-002-cycle01`

Cycle: `14`

ABEIS is in faithful-reproduction mode.  Do not add assumptions, change the
oracle contract, change the gate order, or replace the paper's construction by
a different construction.  If the paper relies on a previous theorem or a
standard quantum primitive, classify it as an external technical lemma rather
than silently proving a stronger or different statement.

## What remains open according to the current retrieval index

### Active proof-DAG leaves

- 1. lower1 validates the source map and keeps the focused branch fixed to system entry `(0,0)`, sparse slot `2`, source-prepared projection, branch basis `[32,32]`, signal block `[0,0]`, and normalizer `N_D*N_f*kappa`.
- 2. lower3 verifies the compiled interface, normalizer bridge inputs, transcript split, active-backend contract wiring, and all false theorem flags before lower2 edits Lean.
- 3. lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and only for the one bridge theorem above. If it already exists, lower2 should make no Lean edit and log `error_class=stale_leaf`.

### Open obligation signals

- theorem-facing finite block/projection interface: Lean `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`; class QBE-local non-promoting interface packet; status compiled; stale as lower work
- source-prepared slot-`2` normalizer route: Lean `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`; class QBE-local semantic bridge under explicit source contracts; status compiled route memory
- theorem-facing projection-interface normalizer bridge: Lean planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`; class internal paper-step interface glue plus local coefficient normalizer bridge; status active lower2 leaf after lower1/lower3 checks
- fixed product-to-coefficient theorem for `(0,0)`: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus corrected theorem-facing finite block/projection route; status open; blocked
- finite block-composition closure: Lean `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`, `.blockProjection`, `.lcuComposition`, `.finalExtraction`; class contract-only LCU/block composition background plus local finite projection theorem; status false; forbidden as this leaf
- diagnostic raw equality route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class existing diagnostic `sorry` route; status forbidden as dependency

### Open GHL paper-contribution obligations

| id | paper anchor | paper object | Lean/status | external lemma? |
| --- | --- | --- | --- | --- |
| Uindic | main.tex:1056-1066 | Indicator unitary $U_{\mathrm{indic}}(K_1,K_2)$ | permutation/self-inverse helper 和 theorem-facing $U_{\mathrm{indic}}^\dagger$ slot 已编译；它仍不是 final block-encoding proof。 | False |
| RyBoundary | main.tex:1077-1085 | Boundary controlled $R_y$ rotations | active convention audit：标准 $R_y(\theta)$ 给出 $\cos(\theta/2)$，所以 Lean route 必须确认论文 convention，或使用有原文/引用支持的 doubled-angle 修正。 | True |
| RobinTheorem | main.tex:1098-1109 | Theorem：one-term Robin block-encoding | main active target：还没有作为 theorem-facing Lean statement 闭合。 | True |
| GammaSlices | main.tex:1111-1119 | Eq. ROBIN clarified | finite boundary instance 已有不少 route lemma；最终 projection/product bridge 还没闭合。 | True |
| FigRobin | main.tex:1122-1164 | Fig. 1-term Robin circuit caption | theorem-facing transcript guard 已编译：显式 $U_{\mathrm{indic}}^\dagger$ 和两侧 $H_W$ prepared route 可见；active backend 七门列表仍是独立 H-free component。 | True |
| OneD | main.tex:1171-1278 | One-dimensional Hamiltonian block-encoding | one-term Robin 闭合之后再做；不是当前 active theorem blocker。 | False |
| MultiD | main.tex:1596-1649 | Multi-dimensional block-encoding | planned；依赖 one-term 和 LCU abstractions。 | False |

### Open external technical-lemma obligations

| id | source | status | used by | next action |
| --- | --- | --- | --- | --- |
| tl-ghl-lemma1-banded-sparse-access | GHL2025 main.tex:784-798; previous PDE block-encoding construction | contract-only | GHL2025 Fig. 4; Robin boundary ODBS dagger cleanup | Keep as explicit external contract until the exact cited construction is formalized or imported as a theorem. |
| tl-ghl-lemma3-sparse-amplitude | GHL2025 main.tex:822-843 | contract-only | GHL2025 gamma_1/gamma_2/gamma_3 slices | Maintain the clean-branch contract and isolate any missing unitarity proof as an external technical lemma. |
| tl-ghl-theorem5-piecewise-polynomial-of | GHL2025 main.tex:870-908 | contract-only | GHL2025 one-term Robin operator A_k = f(x) partial_x^m | Use only as a named contract in the current theorem; do not invent stronger smoothness or range assumptions. |
| tl-uniform-sparse-register-preparation | GHL2025 main.tex:948-955; Shukla--Vedula 2024 | contract-only | GHL2025 Fig. 4 left/right sparse-register preparation | Keep as a theorem-facing contract unless the exact state-preparation proof is needed to close a resource theorem. |
| tl-ry-boundary-amplitude-convention | GHL2025 main.tex:1077-1085 | obligation | GHL2025 boundary-entry branch; active gamma_3 coefficient leaf | Do not silently change the paper angle; prove the convention bridge or record the exact cited convention. |
| tl-qsvt-blockencoding-simulation | GHL2025 main.tex:1676-1694; Gilyen et al. 2019 | paper-cited | GHL2025 Hamiltonian simulation section | Defer until the one-term Robin theorem and LCU combination are closed. |
| tl-clean-block-definition | GHL2025 main.tex:2027-2035 | contract-only | all theorem-facing block-encoding statements | Use as the final target predicate; ensure circuit entry lemmas are bridged to this semantic definition. |

### Current Lean `sorry` scan

- `QuantumBlockEncoding/RobinMatrix.lean:26125:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26155:  sorry`

### Recent typed verifier feedback

| leaf | error class | finite matrix ok | block entry ok | next route |
| --- | --- | --- | --- | --- |
| theorem_facing_projection_interface_normalizer_bridge | symbolic_bridge_gap | None | None | lower1 and lower3 should validate the theorem-facing projection-interface normalizer bridge; lower2 should prove only oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3 in QuantumBlockEncoding/RobinMatrix.lean or log stale_leaf if it already exists. |
| theorem_facing_finite_block_projection_interface | stale_leaf | True | True | Retire theorem_facing_finite_block_projection_interface as compiled non-promoting route memory. Middle should prepare the corrected theorem-facing finite block/projection equality or final coefficient bridge before any attempt at oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | lower2 may compile only OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface, oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3, and oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript in QuantumBlockEncoding/RobinMatrix.lean as a non-promoting interface packet. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | interface_only | lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean; if the declarations already exist, lower2 logs stale_leaf and makes no Lean edit. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | Prepare the corrected theorem-facing finite block/projection equality before attempting oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | interface_only | lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. Do not target root product-to-coefficient, backendExpansionStatement, diagnostic sorry routes, or any semantic-flag promotion. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | lower2 may compile only OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface, oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3, and its transcript in QuantumBlockEncoding/RobinMatrix.lean as a non-promoting interface packet. Do not target oneTermRobinGamma3ProductToCoefficientObligation 3 0 0 or backendExpansionStatement. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | not_attempted_interface_packet_only | blocked_by_missing_theorem_facing_finite_block_projection_equality | lower3 verifies the source-prepared projection target, compiled audit, active backend wiring, and false flags; then lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. |
| oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 | stale_leaf | None | None | Retire the theorem-facing finite block contract audit as compiled route memory; prepare or validate oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 before attempting oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | pending lower3 necessary-condition check | pending non-promoting interface; no block equality promoted | lower1 validates the source map and lower3 verifies necessary conditions, then lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. |

## Important local lesson from previous failed attempts

Do not try to prove raw symbolic `Coeff` constructor equality between two large
matrices if the route only differs by associativity or expression-tree shape.
The current intended route is semantic: prove the finite evaluated entry/path
identity at the `evalWith` or block-entry level, then bridge it to the named
Lean theorem.  A fast finite matrix/path-sum check is useful only as a necessary
condition; Lean still has to prove the final theorem.

## What I need from you

Please return a source-faithful plan that I can paste back into my local ABEIS
system.  I need concrete proof engineering, not a high-level summary.

1. Identify the exact paper theorem/figure/equation that should close the
   currently open one-term Robin block-entry equality.
2. Split the proof into a small dependency DAG.  Mark each node as one of:
   paper contribution, external technical lemma, local matrix-semantics lemma,
   finite-index arithmetic lemma, or rejected/stale route.
3. For the smallest next Lean leaf, propose a Lean-facing statement shape and a
   proof route.  You may use pseudo-Lean if exact local names are unavailable,
   but keep the variables, hypotheses, and equality target precise.
4. Explain which finite non-Lean checks are necessary-condition filters before
   spending Lean time, and why they cannot reject a theorem that Lean could
   actually prove.
5. List any theorem from the paper's references that must be treated as an
   external technical lemma rather than being assumed silently.
6. Do not claim the whole GHL theorem is complete unless every item above is
   closed by a Lean-level theorem route.

## Current dirty files, for context only

- `MANIFEST.md`
- `QuantumBlockEncoding/RobinMatrix.lean`
- `conversion-windows/QBE-AUTO-002.md`
- `paper-notes/GHL2025/latex/sections/00_status.tex`
- `paper-notes/GHL2025/markdown/00_status.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260615-053748-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`
- `paper-notes/GHL2025_RobinOneTerm.tex`
- `paper-notes/project-paper/cycle-updates/20260615-010153-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-010153-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-013025-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-013025-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-015440-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-015440-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-021428-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-021428-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-022953-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-022953-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-024629-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-024629-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-030358-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-030358-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-034853-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-034853-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-041049-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-041049-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-050133-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-050133-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260615-052017-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-052017-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `proof-attempts/QBE-AUTO-002/backend-expansion-correction-lower1-dag-20260615-024629.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-correction-lower2-blocked-20260615-024629.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-correction-middle-packet-20260615-0233.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-correction-middle-packet-20260615-024629.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-route-retarget-lower-proof-architect-20260615-032040.md`
- `proof-attempts/QBE-AUTO-002/backend-expansion-route-retarget-middle-packet-20260615-030358.md`
- `proof-attempts/QBE-AUTO-002/finite-normalized-projection-lower1-proof-architect-20260615-042926.md`
- `proof-attempts/QBE-AUTO-002/finite-normalized-projection-middle-packet-20260615-0419.md`
