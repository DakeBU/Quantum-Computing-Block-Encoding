# ChatGPT Pro Prompt: ABEIS QBE-AUTO-002 cycle 1

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

Run label: `20260617-024407-QBE-AUTO-002-cycle01`

Cycle: `1`

ABEIS is in paper-benchmark mode.  Do not add assumptions, change the
oracle contract, change the gate order, or replace the paper's construction by
a different construction.  If the paper relies on a previous theorem or a
standard quantum primitive, classify it as an external technical lemma rather
than silently proving a stronger or different statement.

## What remains open according to the current retrieval index

### Active proof-DAG leaves

- 1. **Close the GHL paper benchmark baseline first.** Locate the paper theorem corresponding to the Guseynov--Huang--Liu block-encoding theorem (the run should treat this as Theorem 3 / the main BE construction theorem, using the local source map if numberin...
- 2. **After the baseline is Lean-closed, start improvement search for the same operator.** Create or update a candidate population for the same target operator and compare candidates by the current QBE score order: `(depth, gateCount, auxiliaryQubits, oracle...
- 3. **If the GHL baseline is closed and improvement search stagnates for many generations, switch to the fallback operator-construction task** `QBE-OP-OPTCTRL-001`, titled `Operator of optimal control paper`. Its target is the operator shown in the user's im...

### Open obligation signals

- theorem-facing prepared projection contract: Lean `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`; class QBE-local interface glue over source-prepared slot-`2` product bridge; status compiled; route memory only
- branch-sum projection theorem: Lean planned `oneTermRobinGamma3BoundaryBranchContribution_sum_n3`; equivalent `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`; class internal paper step plus QBE finite matrix/projection lemma; status active frontier after lower1/lower3 checks
- unchanged raw backend expansion: Lean `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`; class old H-free route guarded by finite no-go theorem; status forbidden direct lower2 target
- fixed product-to-coefficient theorem for `(0,0)`: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus branch-sum projection and normalizer bridges; status open; blocked
- finite block-composition closure: Lean `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`, `.blockProjection`, `.lcuComposition`, `.finalExtraction`; class contract-only LCU/block background plus local finite projection theorem; status false; forbidden as this leaf
- post-baseline candidate population: Lean score `(depth, gateCount, auxiliaryQubits, oracleCalls)` for same operator; class baseline theorem must close first; status deferred
- fallback `QBE-OP-OPTCTRL-001`: Lean OPTCTRL rank-one time/type partial-isometry operator tensored with `I_n`; class fallback only after baseline closure and improvement stagnation; status planned; not active

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

- `QuantumBlockEncoding/RobinMatrix.lean:26248:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26278:  sorry`

### Recent typed verifier feedback

| leaf | error class | finite matrix ok | block entry ok | next route |
| --- | --- | --- | --- | --- |
| theorem_facing_branch_sum_projection_leaf | symbolic_bridge_gap | pending_lower3; unchanged backendExpansionStatement has existing no-go guard oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3 | False | lower1 writes the source-backed branch-sum proof map; lower3 checks finite branch-sum necessary conditions and the no-go guard; lower2 proves exactly one projection-summation leaf or a smaller typed obstruction without promoting product, block, oracle, unitary, resource, or final-extraction flags. |
| theorem_facing_prepared_projection_contract | symbolic_bridge_gap | None | True | retire this leaf and assign the corrected theorem-facing finite block/projection equality before oneTermRobinGamma3ProductToCoefficientObligation 3 0 0 |
| theorem_facing_prepared_projection_contract | symbolic_bridge_gap | pending_lower3_shape_check; rejected_universal_active_prepared_route_has_finite_counterexample | prepared_projection_route_compiled_as_route_memory_not_root_closure | lower3 checks preparedProjectionEntry shape and false flags, then lower2 compiles oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3 using oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3 without promoting product/block/oracle/unitary/resource flags. |
| prepared_projection_contract_leaf | symbolic_bridge_gap | True | True | Release lower2 to compile exactly one non-promoting wrapper theorem, oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3, using interface.sourcePreparedProjectionEntry and oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3. Do not target activeToPreparedSingletonEvalStatement, oneTermRobinGamma3ProductToCoefficientObligation 3 0 0, backendExpansionStatement, normalizedBlockEquality, blockProjection, LCU, finalExtraction, oracle, unitary, or resource closure. |
| theorem_facing_prepared_projection_contract | source_translation_gap | lower3_rejected_universal_active_prepared_target; prepared_projection_contract_pending_lower3_check | prepared_projection_route_compiled_as_route_memory_not_root_closure | lower1 confirms the prepared projection contract source map, lower3 checks the preparedProjectionEntry shape and false flags, then lower2 compiles only oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3 without promoting product/block/oracle/unitary/resource flags. |
| theorem_facing_corrected_finite_block_projection_equality | finite_matrix_counterexample | False | False | Middle should retarget the leaf to a corrected prepared finite block/projection contract whose block entry is the source-prepared singleton projection entry, or first add a source-backed statement explaining exactly how the theorem-facing Fig. 4 prepared circuit maps to the finite block contract. Do not use the H-free active backend expansion or promote normalizedBlockEquality, blockProjection, LCU, finalExtraction, oracle, unitary, or resource flags. |
| theorem_facing_corrected_finite_block_projection_equality | source_translation_gap | pending_lower3_necessary_condition_check | not_closed | lower1 must classify the source-backed active/prepared equality, lower3 must check active/prepared shape, H_W side-gate absence, no-go guard, and false flags, then middle should either release this exact leaf to lower2 or name a non-promoting corrected prepared finite block/projection contract. |
| theorem_facing_projection_interface_normalizer_bridge | stale_leaf |  |  | retire normalizer bridge as accepted route memory; middle prepares next coefficient bridge; lower2 should not duplicate the existing theorem |
| theorem_facing_projection_interface_normalizer_bridge | stale_leaf | None | None | Retire this leaf for further lower2 assignment. Middle should update the DAG to the next narrow source-backed blocker after the interface-field normalizer bridge, without promoting product-to-coefficient, normalized-block, LCU, block, final-extraction, oracle, unitarity, or resource flags. |
| theorem_facing_projection_interface_normalizer_bridge | symbolic_bridge_gap | None | None | prove corrected theorem-facing finite block/projection equality before oneTermRobinGamma3ProductToCoefficientObligation 3 0 0 |

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
- `paper-notes/GHL2025/markdown/cycle-summaries/20260617-015528-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260617-024407-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`
- `paper-notes/project-paper/cycle-updates/20260617-015528-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260617-015528-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260617-024407-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260617-024407-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `proof-attempts/QBE-AUTO-002/theorem-facing-branch-sum-projection-middle-packet-20260617-025033.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-lower1-dag-20260617-021925.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-lower2-blocked-20260617-021800.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-middle-packet-20260617-0205.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-prepared-projection-contract-lower1-dag-20260617-023713.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-prepared-projection-contract-middle-packet-20260617-0227.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-lower1-dag-20260617-015141.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-middle-packet-20260617-0145.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `proof-obligations/QBE-AUTO-002.md`
- `research-wiki/retrieval-index/QBE-AUTO-002.json`
- `runs/pro-prompts/QBE-AUTO-002-cycle001.md`
- `runs/pro-prompts/QBE-AUTO-002-latest.md`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-branch-sum-projection-middle-20260617-025033.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-lower1-20260617-021925.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-lower2-blocked-20260617-021800.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-lower3-20260617-021813.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-corrected-finite-block-projection-equality-middle-20260617-0205.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-prepared-projection-contract-lower1-20260617-023713.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-prepared-projection-contract-lower3-20260617-023645.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-prepared-projection-contract-middle-20260617-0227.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-lower1-20260617-015141.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-lower3-postcompile-20260617-015301.json`
- `verifier-feedback/QBE-AUTO-002/theorem-facing-projection-interface-normalizer-bridge-middle-20260617-0145.json`
