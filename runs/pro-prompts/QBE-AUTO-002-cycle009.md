# ChatGPT Pro Prompt: ABEIS QBE-AUTO-002 cycle 9

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

Run label: `20260614-004100-QBE-AUTO-002-cycle01`

Cycle: `9`

ABEIS is in faithful-reproduction mode.  Do not add assumptions, change the
oracle contract, change the gate order, or replace the paper's construction by
a different construction.  If the paper relies on a previous theorem or a
standard quantum primitive, classify it as an external technical lemma rather
than silently proving a stronger or different statement.

## What remains open according to the current retrieval index

### Active proof-DAG leaves

- source_prepared_active_field_contract: source-prepared active/prepared field is the paper-facing object under audit; status: active source-correspondence leaf; Lean: `SourceActiveField(H, env)`
- source_prepared_active_field_forces_selected_zero_guard: `Uniform(H)` and `ActivePreparedEval(H, env)` imply `SelectedSlot(env) = 0`; status: active guard leaf; Lean: proposed `oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3`

### Open obligation signals

- selected-slot nonzero obstruction: Lean `oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3`; class QBE-local finite evaluator witness for the selected gamma3 branch; status proved; stale as lower work
- H-free evaluated backend fold: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`; class compiled normal form plus nonzero selected-slot witness; status retired as active target; `finite_matrix_counterexample`
- direct H-free selected-slot feeder: Lean proposed `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env`; class active row `0` versus selected sparse slot `2` / full index `32`; status retired; `shape_or_register_gap`
- source-prepared active-field contract: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` and equivalents; class GHL Fig. `fig:1 term ROBIN` / Definition `def:block-encoding` source-correspondence audit; status active middle/lower1/lower3 contract leaf; not theorem closure
- active field forces selected-zero guard: Lean proposed `oneTermRobinGamma3BoundarySourcePreparedActiveEval_forces_selectedSlotContribution_zero_n3 H env hUniform hActive`; class QBE-local diagnostic consequence of source-prepared-to-fold wiring plus selected-zero normal form; status active lower2 guard leaf
- corrected source-prepared target: Lean restated theorem-facing clean projection after the guard/source audit; class source-contract audit plus finite branch/register diagnostics; status blocked until guard or reviewer restatement
- all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula; status contract-only; downstream-only

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

- `QuantumBlockEncoding/RobinMatrix.lean:24871:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:24901:  sorry`

### Recent typed verifier feedback

| leaf | error class | finite matrix ok | block entry ok | next route |
| --- | --- | --- | --- | --- |
| source_prepared_active_field_contract | source_translation_gap | selected_slot_counterexample_compiled | False | Lower1 maps the source-prepared contract; lower3 checks branch/register shape; lower2 may prove only the source-prepared-active-field-forces-selected-zero guard, then middle must restate the theorem-facing source-prepared target. |
| branch_correct_evaluated_backend_fold_obstruction | finite_matrix_counterexample | False | False | Lower2 should formalize the all-one selected-slot nonzero witness, with the fold-forces-selected-zero guard as fallback; then middle/reviewer should restate the source-prepared target before any new proof search. |
| branch_correct_evaluated_backend_fold_obstruction | finite_matrix_counterexample | False | False | Middle/reviewer should restate the source-prepared row/register target before assigning more lower2 proof search; keep hUniform downstream-only and do not revive the direct row-0 to slot-2 feeder. |
| branch_correct_evaluated_backend_fold_obstruction | finite_matrix_counterexample | False | False | Lower2 should formalize exactly one obstruction leaf: preferably oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3, or the fallback fold-forces-selected-zero guard. After that, middle/reviewer should restate the source-prepared target before renewed fold proof search. |
| branch_correct_evaluated_backend_fold_route_guard | finite_matrix_counterexample | False | False | Prove the necessary-condition route guard or formalize the selected-slot nonzero counterexample, then middle should retire or restate the H-free evaluated fold. Source-prepared recovery remains valid only under explicit hUniform after a valid fold theorem. |
| branch_correct_evaluated_backend_fold | finite_matrix_counterexample | False | False | Do not assign lower2 to prove oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env as an all-env theorem in the current row-0/slot-2 finite witness. Middle should repair the source contract or proof-DAG leaf: either change the active row/register target to the branch-correct selected source entry, add an explicit source-backed coefficient/vanish obligation for selectedSlotContribution = 0 if that is truly intended, or record a source_translation_gap before further Lean proof search. |
| branch_correct_evaluated_backend_fold_selected_slot_zero_normal_form | symbolic_bridge_gap |  |  | prove selected-slot scalar eval zero or classify it as the next source/register obstruction |
| branch_correct_evaluated_backend_fold | symbolic_bridge_gap | pending_lower3 | False | Lower2 should prove exactly one evalWith-level branch-correct full backend-fold leaf, preferably ActiveEntry(env) = BackendFold(env), without adding hUniform or reviving the selected-slot shortcut. |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | None | False | prove the unwrapped sparse-clean evaluated equality or a source-backed finite-composition lemma feeding it; do not revive the H-free row-0 to slot-2 feeder |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | True | False | Lower2 should prove exactly one source-prepared active/prepared finite-composition leaf, preferably oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env or (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement. Do not add Uniform(H) to the active/prepared field and do not revive the H-free row-0 to selected slot-2 feeder. |

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

- `HUMAN_STATUS.md`
- `MANIFEST.md`
- `QuantumBlockEncoding/RobinMatrix.lean`
- `REPORTS.zh.md`
- `conversion-windows/QBE-AUTO-002.md`
- `paper-notes/GHL2025/latex/sections/00_status.tex`
- `paper-notes/GHL2025/markdown/00_status.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/20260614-004100-QBE-AUTO-002-cycle01.md`
- `paper-notes/GHL2025/markdown/cycle-summaries/latest.md`
- `paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`
- `paper-notes/GHL2025/markdown/unresolved-failures.zh.md`
- `paper-notes/project-paper/cycle-updates/20260613-170242-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-170242-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260613-172255-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-172255-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260613-174250-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-174250-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260613-180059-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-180059-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260613-182230-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260613-182230-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/20260614-004100-QBE-AUTO-002-cycle01.md`
- `paper-notes/project-paper/cycle-updates/20260614-004100-QBE-AUTO-002-cycle01.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower1-dag-20260613-173942.md`
- `proof-attempts/QBE-AUTO-002/finite-path-feeder-lower3-necessary-condition-20260613-173848.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-active-field-source-contract-20260614-0102.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-lower1-route-guard-20260613-181816.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-lower2-20260613-181849.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-lower3-necessary-condition-20260613-181816.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-middle-packet-20260613-180059.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-obstruction-lower1-20260613-183730.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-obstruction-lower2-20260613-184156.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-obstruction-lower3-necessary-condition-20260613-183628.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-backend-fold-obstruction-middle-packet-20260613-182230.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-col0-diagnostic-lower1-20260613-165304.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-col0-diagnostic-lower2-20260613-170051.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-col0-diagnostic-lower3-necessary-condition-20260613-165208.md`
- `proof-attempts/QBE-AUTO-002/source-prepared-contract-retarget-20260613-171137.md`
