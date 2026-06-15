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

Run label: `20260613-054606-QBE-AUTO-002-cycle01`

Cycle: `1`

ABEIS is in faithful-reproduction mode.  Do not add assumptions, change the
oracle contract, change the gate order, or replace the paper's construction by
a different construction.  If the paper relies on a previous theorem or a
standard quantum primitive, classify it as an external technical lemma rather
than silently proving a stronger or different statement.

## What remains open according to the current retrieval index

### Active proof-DAG leaves

- finite_projection_feeder: prove the active clean projection equals the backend fold at evaluated level; status: active lower leaf; open; Lean: `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` or one strict finite theorem feeding it
- source_contract_target_correction: source-prepared field is recovered only with `Uniform(H)` explicit and a finite projection feeder; status: active correction; compiled bridge reused; Lean: `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold`; `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_i...

### Open obligation signals

- finite projection feeder: Lean `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, or one strict finite `CircuitMatrixSemantics`/`Coeff.evalWith` theorem feeding it; class QBE-local finite projection/backend fold theorem tied to GHL2025 Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`; status active lower2 target; open
- source-prepared recovery under `Uniform(H)`: Lean `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold`; class compiled route consuming the finite feeder under the explicit external clean-column contract; status compiled conditional; not closure without `hFold`
- arbitrary-`H` source-prepared field: Lean `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`; `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`; class needs a true all-`H` finite composition theorem or clean-column independence theorem; status retired as default lower target
- all-slot sparse preparation: Lean `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; class external cited contract from GHL2025 Eq. `arbitrary sparcity` and Shukla--Vedula 2024; status contract-only; allowed only as explicit `hUniform`; not formalized here
- direct H-free evaluated-fold route: Lean diagnostic `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`; `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`; class diagnostic route with register-shape drift risk; status rejected as default lower target; do not assign

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

- `QuantumBlockEncoding/RobinMatrix.lean:24334:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:24364:  sorry`

### Recent typed verifier feedback

| leaf | error class | finite matrix ok | block entry ok | next route |
| --- | --- | --- | --- | --- |
| finite_projection_feeder | source_translation_gap | not_checked_by_middle; recent lower2/lower3 feedback shows the arbitrary-H field depends on the prepared clean-column slots unless a true independence theorem is proved | False | Lower2 proves the finite projection feeder for oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env, or one strict theorem feeding it, and the result is consumed only through the explicit hUniform source-prepared bridge. |
| source_contract_target_correction | source_translation_gap | not_checked_by_middle; lower2/lower3 feedback shows arbitrary-H closure needs true independence or explicit Uniform(H) | False | Lower2 proves one finite projection feeder for oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env, or a strict theorem feeding it, and the feeder is consumed only through oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3 H env hUniform hFold. |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | not_checked_by_lower1 | False | lower2 proves SourcePreparedField(H, env), UncastActivePrepared(H, env), CachedPreparedEntry(H), the unwrapped sparse-clean evalWith equality, or one strict finite source-shaped feeder; return to middle if Uniform(H) is required |
| source_prepared_finite_composition_leaf | source_translation_gap | prepared_clean_entry_depends_on_seven_H_clean_column_slots | False | Middle should either restate the source-prepared active field with Uniform(H) explicit, or assign a genuine finite composition/independence theorem that proves the arbitrary-H target without using the downstream hUniform bridge. |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | shape_check_passed_no_counterexample; exact finite block-entry equality not proved | False | Prove SourcePreparedField(H, env), one accepted equivalent active/prepared target, the cached prepared-entry target, or one strict finite source-shaped theorem feeding those statements. If Uniform(H) is required for arbitrary H, ask middle to restate the contract-specific target rather than adding a lower-local hypothesis. |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | not_closed; lower3_source_shape_checks_remain_partial | False | lower2 proves SourcePreparedField(H, env), UncastActivePrepared(H, env), CachedPreparedEntry(H), or one strict finite source-shaped theorem feeding those statements without adding Uniform(H) to the arbitrary-H target |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | clean_column_transport_compiled | False | prove SourcePreparedField(H, env) or cached active/prepared entry equality; if Uniform(H) is required for arbitrary H, ask middle for contract-specific restatement |
| source_prepared_finite_composition_leaf | source_translation_gap | source_shape_checks_passed_but_arbitrary_H_not_closed | False | Lower2 should prove SourcePreparedField(H, env), the cached PreparedCircuitEntryTarget equality, or one strict finite composition theorem directly feeding those statements. If the proof only becomes source-backed under Uniform(H), middle should restate the target with Uniform(H) explicit or require an independence theorem; lower should not add a local hUniform hypothesis. |
| source_prepared_finite_composition_leaf | symbolic_bridge_gap | partial_lower3_source_shape_checks_passed | False | prove SourcePreparedField(H, env), an accepted active/prepared target, the cached prepared-entry equality, or one strict finite source-shaped feeder; use source_translation_gap if Uniform(H) is required for arbitrary H |
| source_prepared_finite_composition_leaf | source_translation_gap | partial_source_shape_checks_passed | False | Lower2 should prove SourcePreparedField(H, env), the cached PreparedCircuitEntryTarget equality, the uncast active/prepared sparse clean-entry evalWith equality, or one strict finite composition theorem directly feeding those statements. If the proof needs only the paper clean-column contract, middle should restate the source-backed target with hUniform explicit rather than adding a lower-edit hypothesis. |

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
- `README.md`
- `docs/agent_blueprint_formalization.md`
- `docs/pro_prompt_policy.md`
- `docs/prompts/`
- `proof-attempts/QBE-AUTO-002/chatgpt-pro-finite-path-feeder-deployment-20260613.md`
- `proof-blueprints/QBE-AUTO-002-status.json`
- `proof-blueprints/QBE-AUTO-002-status.md`
- `proof-blueprints/QBE-AUTO-002.md`
- `proof-obligations/QBE-AUTO-002.md`
- `research-wiki/retrieval-index/QBE-AUTO-002.json`
- `tasks/QBE-AUTO-002.md`
- `tools/qbe.py`
- `verifier-feedback/QBE-AUTO-002-current-ghl-feedback.md`
- `verifier-feedback/QBE-AUTO-002/chatgpt-pro-finite-path-feeder-deployment-20260613.json`
