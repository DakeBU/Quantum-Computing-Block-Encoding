# ChatGPT Pro Prompt: ABEIS QBE-AUTO-002 cycle 13

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

Run label: `20260617-060327-QBE-AUTO-002-cycle01`

Cycle: `13`

ABEIS is in paper-benchmark mode.  Do not add assumptions, change the
oracle contract, change the gate order, or replace the paper's construction by
a different construction.  If the paper relies on a previous theorem or a
standard quantum primitive, classify it as an external technical lemma rather
than silently proving a stronger or different statement.

## What remains open according to the current retrieval index

### Active proof-DAG leaves

- prepared_composite_source_projection_audit: non-promoting wrapper that exposes `PreparedCompositeSemantics(H)`, the rejected active/prepared field, lower3 finite obstruction, and false theorem flags; status: active audit-only leaf; Lean: planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3`
- source_contract_repair: restate the theorem-facing projection contract so it does not equate the H-free active backend entry with the prepared singleton clean entry; status: active source-contract repair; Lean: Markdown/Lean contract target not yet fixed

### Open obligation signals

- prepared-composite source field: Lean `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; source target `activeToPreparedSingletonEvalStatement`; class direct active/prepared equality; status rejected by finite matrix counterexample; do not assign
- prepared-composite source projection audit: Lean planned `oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3`; class QBE-local false-flag wrapper over source-prepared route memory and lower3 obstruction; status active audit-only leaf; no semantic promotion
- source-contract repair: Lean corrected theorem-facing projection contract that avoids equating the H-free seven-gate entry with the prepared singleton clean entry; class internal GHL step plus QBE-local finite projection semantics; status active middle/lower1 route; no Lean proof search until exact contract is fixed
- evaluated backend-fold source bridge audit: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3`; class non-promoting route wrapper; status compiled; retired as lower target
- direct H-free evaluated fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class active seven-gate backend shortcut; status rejected by finite matrix counterexample; do not assign
- generic backend projection/expansion route: Lean `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`; `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`; class invalid route / no-go guard; status refuted; do not assign
- `H_W^(kappa)` clean column: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula; status contract-only; do not mark formalized
- fixed gamma3 product-to-coefficient root: Lean `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; class coefficient equality plus finite normalized-block/projection bridge; status blocked; do not assign directly
- product, normalized block, LCU, block projection, block correctness, final extraction, oracle, unitarity, and resources: Lean finite block contract fields and theorem-facing flags; class downstream theorem obligations; status false/unproved; no promotion
- post-baseline candidate population: Lean score `(depth, gateCount, auxiliaryQubits, oracleCalls)` for the same operator; class baseline theorem must close first; status deferred
- fallback `QBE-OP-OPTCTRL-001`: Lean rank-one time/type partial-isometry operator tensored with `I_n`; class fallback only after baseline closure and improvement stagnation; status planned; not active

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

- `QuantumBlockEncoding/RobinMatrix.lean:26968:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26998:  sorry`

### Recent typed verifier feedback

| leaf | error class | finite matrix ok | block entry ok | next route |
| --- | --- | --- | --- | --- |
| prepared_composite_source_projection_audit | finite_matrix_counterexample | false for ActivePreparedEval/UncastActivePreparedEval/SourcePreparedActiveEval; null for an audit-only wrapper | False | Repair the source-facing projection contract, or compile only a non-promoting prepared-composite source projection audit wrapper with all theorem flags false. |
| source_prepared_prepared_composite_field | finite_matrix_counterexample | False | False | Middle should repair the source contract or assign only a non-promoting obstruction/audit wrapper with all theorem flags false. Lower2 must not prove the active/prepared composite equality, the H-free evaluated backend fold, or generic backend expansion/projection surfaces. |
| source_prepared_prepared_composite_field | source_translation_gap | pending_lower3_for_prepared_composite_entry; direct H-free evaluated fold already rejected | prepared-composite audit route only; root block-encoding not closed | Lower3 should check the finite prepared-composite entry condition against the source branch. If it survives, lower2 may compile exactly one non-promoting PreparedCompositeSourceProjectionAudit wrapper with all theorem flags false; if it fails, lower2 should make no Lean edit and log finite_matrix_counterexample. |
| source_prepared_prepared_composite_field | finite_matrix_counterexample | False | False | Middle should repair the source contract or assign only a non-promoting audit wrapper that records this finite obstruction; lower2 must not prove the active/prepared composite equality or the H-free evaluated backend fold. |
| source_prepared_prepared_composite_field | source_translation_gap | pending lower3 prepared-composite clean-entry diagnostic | not checked by lower2; source-prepared prepared-composite field only | Run lower1 source-proof map and lower3 finite prepared-composite clean-entry diagnostic; if both confirm, compile exactly the non-promoting audit wrapper oneTermRobinGamma3BoundaryPreparedCompositeSourceProjectionAudit_n3. |
| evaluated_backend_fold_source_bridge | symbolic_bridge_gap | route packaging only; reuses compiled expanded slot-zero exposure and prepared clean-entry product-map route, no new finite equality proved | evaluated active signal entry / source-prepared singleton bridge only; root block encoding not closed | Use oneTermRobinGamma3BoundaryEvaluatedBackendFoldSourceBridgeAudit_n3 as route memory; the next narrow proof must supply the active/prepared finite entry field or raw prepared-sandwich equivalent without reviving generic projection/backend expansion. |
| evaluated_backend_fold_source_bridge | finite_matrix_counterexample | False | False | Do not prove the all-env EvaluatedFoldStatement(env), RawPreparedSandwichField(H), generic projection, or backend-expansion surface. If lower2 edits Lean, compile only a non-promoting EvaluatedBackendFoldSourceBridgeAudit wrapper recording the no-go facts, or wait for middle to restate the theorem-facing finite block/projection contract around prepared composite semantics. |
| evaluated_backend_fold_source_bridge | finite_matrix_counterexample | False | False | Lower2 should make no Lean edit for the direct H-free evaluated fold. Middle/lower1 should repair the active leaf to a source-prepared finite matrix field, or record the source/register contract gap before assigning another proof attempt. |
| evaluated_backend_fold_source_bridge | symbolic_bridge_gap | pending lower3 check for the evaluated active [0,0] equality exposed by oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_exposesExpandedSlotZeroFold_n3 | evaluated active signal entry / prepared singleton bridge only; no root block-encoding closure claimed | lower1 source-maps the evaluated backend-fold bridge, lower3 checks the finite evaluated [0,0] equality and no-go guards, then lower2 compiles at most one source-constrained non-promoting leaf; do not revive generic projection/backend expansion |
| source_corrected_product_feeder | symbolic_bridge_gap | True | prepared/product feeder only; no signal block branch-sum closure is claimed | Review/accept oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3 as a non-promoting source-corrected feeder if it was produced by lower2; then middle/lower1 should name the next source-backed finite normalized block/projection or product-to-coefficient leaf. Do not revive the generic projection/backend expansion surface. |

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
- `paper-notes/GHL2025/markdown/cycle-summaries/20260617-060327-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`
- `paper-notes/project-paper/cycle-updates/20260617-015528-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260617-015528-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260617-024407-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260617-024407-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260617-051350-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260617-051350-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `proof-attempts/QBE-AUTO-002/branch-decomposition-projection-bridge-lower1-dag-20260617-040339.md`
- `proof-attempts/QBE-AUTO-002/branch-decomposition-projection-bridge-lower3-postcompile-diagnostic-20260617-040616.md`
- `proof-attempts/QBE-AUTO-002/branch-decomposition-projection-bridge-middle-packet-20260617-035546.md`
- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-source-bridge-lower1-dag-20260617-053734.md`
- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-source-bridge-lower3-diagnostic-20260617-053733.md`
- `proof-attempts/QBE-AUTO-002/evaluated-backend-fold-source-bridge-middle-packet-20260617-052330.md`
- `proof-attempts/QBE-AUTO-002/fixed-product-to-coefficient-preaudit-lower1-dag-20260617-042216.md`
- `proof-attempts/QBE-AUTO-002/fixed-product-to-coefficient-preaudit-lower3-diagnostic-20260617-042237.md`
- `proof-attempts/QBE-AUTO-002/fixed-product-to-coefficient-preaudit-lower3-postcompile-diagnostic-20260617-042621.md`
- `proof-attempts/QBE-AUTO-002/fixed-product-to-coefficient-preaudit-middle-packet-20260617-041647.md`
- `proof-attempts/QBE-AUTO-002/prepared-circuit-contract-correction-lower1-dag-20260617-044334.md`
- `proof-attempts/QBE-AUTO-002/prepared-circuit-contract-correction-lower3-diagnostic-20260617-044406.md`
- `proof-attempts/QBE-AUTO-002/prepared-circuit-contract-correction-middle-packet-20260617-043449.md`
- `proof-attempts/QBE-AUTO-002/prepared-composite-source-projection-audit-middle-packet-20260617-062017.md`
- `proof-attempts/QBE-AUTO-002/source-contract-repair-middle-packet-20260617-063535.md`
- `proof-attempts/QBE-AUTO-002/source-corrected-product-feeder-lower1-dag-20260617-050933.md`
- `proof-attempts/QBE-AUTO-002/source-corrected-product-feeder-lower3-postcompile-diagnostic-20260617-051000.md`
- `proof-attempts/QBE-AUTO-002/source-corrected-product-feeder-middle-packet-20260617-0456.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-prepared-composite-field-lower1-dag-20260617-055706.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-prepared-composite-field-lower2-blocked-20260617-055658.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-prepared-composite-field-lower3-diagnostic-20260617-055759.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-prepared-composite-field-middle-packet-20260617-055020.md`
- `proof-attempts/QBE-AUTO-002/theorem-facing-branch-sum-projection-lower1-dag-20260617-030201.md`
