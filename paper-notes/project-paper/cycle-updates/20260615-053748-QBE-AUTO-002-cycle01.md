# Project Article Update: QBE-AUTO-002 cycle 14

Generated: `2026-06-15 13:23:02`

Run directory: `runs/20260615-053748-QBE-AUTO-002-cycle01`

Task title: Concrete Circuit Matrix Semantics Backend

This file is the article-facing update packet for the technical report
`Auto-Lean-in-Sleep: Block Encoding for Quantum Computing`.  It is written at
the end of an active proof cycle so the project paper can track what the Lean
system actually proved, failed, or learned.  It is not a polished manuscript
section; middle agents should fold stable claims into
the ABEIS technical report directory only when the claims are supported by
Lean declarations, source anchors, or explicit obligations.

## Article-facing delta

- Keep the main system claim: ABEIS is an auto-proof harness for turning
  quantum oracle assumptions into Lean-checked block-encoding/circuit
  certificates.
- Keep the first case study honest: Guseynov--Huang--Liu 2025 is the first
  faithful reproduction target, but final completion depends on the current
  Lean gate and `sorry` status below.
- If this cycle only changes proof-route memory or obstruction analysis, update
  the report's evidence/appendix status, not the headline contribution.
- If this cycle closes a named Lean theorem, middle should export the theorem
  to Markdown and LaTeX proof notes before strengthening the project-paper
  claim.

## Lean status signal

- `QuantumBlockEncoding/RobinMatrix.lean:26125:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26155:  sorry`

## Plain-language status for readers

The current GHL case study is not blocked because the paper lacks a proof sketch.  It is blocked because ABEIS must turn the circuit in the paper into an exact matrix statement and prove that the clean block entry has the coefficient claimed by the paper.  In ordinary terms, the paper says that a specific path through the circuit leaves the desired coefficient, while Lean requires the corresponding matrix entry and all unwanted branches to be proved exactly.

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  They are useful
because a failing exact finite check usually means the Lean target, circuit
transcript, or index map is wrong.  A passing check only means the candidate
survived this cheaper test; the final claim still needs a Lean theorem.

| proof part | fast check | why this is a necessary condition | what Lean still proves |
| --- | --- | --- | --- |
| active [0,0] entry | exact rational matrix or path-sum evaluation | if the exact finite entry is not the target coefficient, the Lean equality for that entry cannot be true | a passing check is only a counterexample filter; Lean must still prove the named entry lemma |
| remaining branch vanish/cancel | support and path checker for the remaining backend slots | if an unwanted clean-branch path survives numerically, the block projection cannot match the paper target | Lean must still prove the zero/cancellation lemma in the formal circuit semantics |
| Ry boundary convention | symbolic 2-by-2 rotation check | a mismatched half-angle convention changes the boundary amplitude before any Lean tactic is relevant | Lean must still record the convention bridge as a source-supported theorem |
| sparse-access map | finite range/injectivity/permutation check | a reversible oracle cannot exist for a colliding or out-of-range finite map | Lean must still prove the reversible extension and cleanup obligations |
| coefficient oracle clean branch | exact finite evaluator for f(x_i)/N_f | the final block entry uses this coefficient, so a wrong clean branch invalidates the target theorem | Lean must still prove bounds, orthogonality, and unitary completion or keep them as contracts |

## Current proof-DAG frontier

- 1. lower1 validates the source map and keeps the focused branch fixed to system entry `(0,0)`, sparse slot `2`, source-prepared projection, branch basis `[32,32]`, signal block `[0,0]`, and normalizer `N_D*N_f*kappa`.
- 2. lower3 verifies the compiled interface, normalizer bridge inputs, transcript split, active-backend contract wiring, and all false theorem flags before lower2 edits Lean.
- 3. lower2 may edit only `QuantumBlockEncoding/RobinMatrix.lean` and only for the one bridge theorem above. If it already exists, lower2 should make no Lean edit and log `error_class=stale_leaf`.

## Open obligation signal

- theorem-facing finite block/projection interface: Lean `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`; class QBE-local non-promoting interface packet; status compiled; stale as lower work
- source-prepared slot-`2` normalizer route: Lean `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`; class QBE-local semantic bridge under explicit source contracts; status compiled route memory
- theorem-facing projection-interface normalizer bridge: Lean planned `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`; class internal paper-step interface glue plus local coefficient normalizer bridge; status active lower2 leaf after lower1/lower3 checks
- fixed product-to-coefficient theorem for `(0,0)`: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus corrected theorem-facing finite block/projection route; status open; blocked
- finite block-composition closure: Lean `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`, `.blockProjection`, `.lcuComposition`, `.finalExtraction`; class contract-only LCU/block composition background plus local finite projection theorem; status false; forbidden as this leaf
- diagnostic raw equality route: Lean `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class existing diagnostic `sorry` route; status forbidden as dependency

## Open GHL contribution obligations

| id | source anchor | paper object | Lean/status |
| --- | --- | --- | --- |
| Uindic | main.tex:1056-1066 | Indicator unitary | Permutation and self-inverse helpers compile, but this is not yet the final block-encoding proof. |
| RyBoundary | main.tex:1077-1085 | Boundary-controlled Ry rotations | Active convention audit: the Ry angle convention must be source-supported before closing the boundary amplitude proof. |
| RobinTheorem | main.tex:1098-1109 | One-term Robin block-encoding theorem | Main active target: the theorem-facing Lean statement is not closed. |
| GammaSlices | main.tex:1111-1119 | Gamma wavefunction slices and coefficient product | Several finite boundary lemmas exist; the final projection/product bridge is still open. |
| FigRobin | main.tex:1122-1164 | Figure 4 Robin circuit transcript | Transcript guard compiles for visible indicator dagger and H preparation; the active seven-gate backend remains a component. |
| OneD | main.tex:1171-1278 | One-dimensional Hamiltonian block encoding | Deferred until the one-term Robin theorem closes. |
| MultiD | main.tex:1596-1649 | Multidimensional block encoding | Planned; depends on one-term and LCU abstractions. |

## Open external technical lemma obligations

| id | source | status | next action |
| --- | --- | --- | --- |
| tl-ghl-lemma1-banded-sparse-access | GHL2025 main.tex:784-798; previous PDE block-encoding construction | contract-only | Keep as explicit external contract until the exact cited construction is formalized or imported as a theorem. |
| tl-ghl-lemma3-sparse-amplitude | GHL2025 main.tex:822-843 | contract-only | Maintain the clean-branch contract and isolate any missing unitarity proof as an external technical lemma. |
| tl-ghl-theorem5-piecewise-polynomial-of | GHL2025 main.tex:870-908 | contract-only | Use only as a named contract in the current theorem; do not invent stronger smoothness or range assumptions. |
| tl-uniform-sparse-register-preparation | GHL2025 main.tex:948-955; Shukla--Vedula 2024 | contract-only | Keep as a theorem-facing contract unless the exact state-preparation proof is needed to close a resource theorem. |
| tl-ry-boundary-amplitude-convention | GHL2025 main.tex:1077-1085 | obligation | Do not silently change the paper angle; prove the convention bridge or record the exact cited convention. |
| tl-qsvt-blockencoding-simulation | GHL2025 main.tex:1676-1694; Gilyen et al. 2019 | paper-cited | Defer until the one-term Robin theorem and LCU combination are closed. |
| tl-clean-block-definition | GHL2025 main.tex:2027-2035 | contract-only | Use as the final target predicate; ensure circuit entry lemmas are bridged to this semantic definition. |

## Recent typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| theorem_facing_projection_interface_normalizer_bridge | symbolic_bridge_gap | None | None | lower1 and lower3 should validate the theorem-facing projection-interface normalizer bridge; lower2 should prove only oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3 in QuantumBlockEncoding/RobinMatrix.lean or log stale_leaf if it already exists. |
| theorem_facing_finite_block_projection_interface | stale_leaf | True | True | Retire theorem_facing_finite_block_projection_interface as compiled non-promoting route memory. Middle should prepare the corrected theorem-facing finite block/projection equality or final coefficient bridge before any attempt at oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | lower2 may compile only OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface, oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3, and oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript in QuantumBlockEncoding/RobinMatrix.lean as a non-promoting interface packet. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | interface_only | lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean; if the declarations already exist, lower2 logs stale_leaf and makes no Lean edit. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | Prepare the corrected theorem-facing finite block/projection equality before attempting oneTermRobinGamma3ProductToCoefficientObligation 3 0 0. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | interface_only | lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. Do not target root product-to-coefficient, backendExpansionStatement, diagnostic sorry routes, or any semantic-flag promotion. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | True | True | lower2 may compile only OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface, oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3, and its transcript in QuantumBlockEncoding/RobinMatrix.lean as a non-promoting interface packet. Do not target oneTermRobinGamma3ProductToCoefficientObligation 3 0 0 or backendExpansionStatement. |
| theorem_facing_finite_block_projection_interface | source_translation_gap | not_attempted_interface_packet_only | blocked_by_missing_theorem_facing_finite_block_projection_equality | lower3 verifies the source-prepared projection target, compiled audit, active backend wiring, and false flags; then lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean. |

## Recent proof-attempt memory

- `proof-attempts/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-middle-packet-20260615-0558.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-lower-proof-architect-20260615-053127.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-middle-synthesis-20260615-0525.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-lower1-proof-architect-20260615-051627.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-middle-packet-20260615-0507.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-contract-audit-lower1-proof-architect-20260615-045438.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-contract-audit-middle-packet-20260615-0448.md`
- `proof-attempts/QBE-AUTO-002/finite-normalized-projection-lower1-proof-architect-20260615-042926.md`

## Suggested project-paper edits

| Report location | Safe update |
|---|---|
| `main/evidence.tex` | Add only stable harness lessons from this cycle, with no stronger claim than the Lean gate supports. |
| `main/ghl_case_study.tex` | Update the case-study status if a theorem, source-contract correction, or obstruction was accepted by reviewer. |
| `appendix/generated_cycle_status.tex` | This file is overwritten automatically and can be included as the latest machine-generated status appendix. |
| Figures/tables | Add or revise a figure only if the cycle changed the system design, proof-DAG frontier, or article-facing evidence. |

## Do not claim

- Do not say the Guseynov--Huang--Liu one-term theorem is complete while any
  theorem-facing `sorry` or root block-extraction obligation remains.
- Do not present a cited oracle/state-preparation/LCU/QSVT primitive as proved
  unless a build-tested Lean declaration is named.
- Do not turn proof-search scores, agent self-assessments, or natural-language
  proof sketches into accepted mathematical claims.

## Dialogue tail

```text
dback JSON; active leaf remains theorem_facing_projection_interface_normalizer_bridge with planned lower2 target oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3; no Lean or article update edit; gate passed via python3 tools/qbe.py check with only the two known RobinMatrix diagnostic sorry warnings.

## 2026-06-15 06:22:50 - reviewer

reviewer gate: python3 tools/qbe.py check passed, running lake build and lake build Tests, with only the two known RobinMatrix diagnostic sorry warnings. Lean interface packet is compiled non-promoting route memory: source-prepared projection is attached, active backend contract remains oneTermRobinCircuitSemantics 3, Fig. 4 and active backend guards remain distinct, and theorem-facing product/LCU/block/final/oracle/unitary/resource flags remain false. Blocking review finding: human-facing proof exports and project-paper latest packet are stale relative to the current task/conversion/blueprint; paper-notes/GHL2025 markdown/latex status and project-paper latest still describe the retired projection-interface leaf instead of active theorem_facing_projection_interface_normalizer_bridge / planned oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3. Next route: refresh those exports, then lower1/lower3 validate source/normalizer guards before lower2 proves only the planned normalizer bridge theorem.
```

## Current changed files

- `MANIFEST.md`
- `paper-notes/project-paper/cycle-updates/20260615-053748-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260615-053748-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `runs/20260517-181600-QBE-AUTO-001-cycle01/`
- `runs/20260517-213858-QBE-AUTO-001-cycle01/`
- `runs/20260517-214705-QBE-AUTO-001-cycle01/`
- `runs/20260517-234836-QBE-AUTO-001-cycle01/`
- `runs/20260518-001604-QBE-AUTO-001-cycle02/`
- `runs/20260518-004234-QBE-AUTO-001-cycle03/`
- `runs/20260518-010257-QBE-AUTO-001-cycle04/`
- `runs/20260518-020239-QBE-AUTO-001-cycle01/`
- `runs/20260518-051657-QBE-AUTO-001-cycle02/`
- `runs/20260518-052832-QBE-AUTO-001-cycle03/`
- `runs/20260518-101100-QBE-AUTO-001-cycle04/`
- `runs/20260518-124930-QBE-AUTO-002-cycle01/`
- `runs/20260518-125623-QBE-AUTO-002-cycle01/`
- `runs/20260519-133457-QBE-AUTO-002-cycle01/`
- `runs/20260519-133901-QBE-AUTO-002-cycle01/`
- `runs/20260519-135334-QBE-AUTO-002-cycle02/`
- `runs/20260519-143514-QBE-AUTO-002-cycle03/`
- `runs/20260520-030521-QBE-AUTO-002-cycle01/`
- `runs/20260520-033720-QBE-AUTO-002-cycle02/`
- `runs/20260520-035340-QBE-AUTO-002-cycle03/`
- `runs/20260520-125217-QBE-AUTO-002-cycle01/`
- `runs/20260520-125343-QBE-AUTO-002-cycle01/`
- `runs/20260520-132745-QBE-AUTO-002-cycle02/`
- `runs/20260520-134806-QBE-AUTO-002-cycle03/`
- `runs/20260520-234624-QBE-AUTO-002-cycle01/`
