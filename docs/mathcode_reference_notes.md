# MathCode Reference Notes

Reference repository: [math-ai-org/mathcode](https://github.com/math-ai-org/mathcode)

Local development checkout, when present:

```text
../outer_repos/automation_systems/mathcode
```

Public QBE documentation should cite the upstream repository link above, not a
machine-local checkout path.

## Why It Is Relevant

MathCode is a terminal AI coding assistant with a math formalization engine. It
turns natural-language mathematical goals into Lean 4 theorem statements and
then attempts formal proofs. QBE has a narrower target: formalizing concrete
quantum oracle and block-encoding circuit matrices. The useful overlap is the
Lean proof workflow, not the scientific task.

## Similar Patterns Worth Adapting

| Similar pattern | MathCode design | QBE adaptation |
|---|---|---|
| Fast Lean feedback | Persistent Lean REPL / Lean LSP support for low-latency compile checks and structured diagnostics. | Keep `python3 tools/qbe.py check` as the project gate, but plan a future QBE-local fast-check path for focused files and proof goals. |
| Proof diagnostics | Tools such as `axiom_checker.py`, `sorry_analyzer.py`, and `proof_stats.py` scan Lean files for hidden assumptions, placeholders, and proof structure. | Extend reviewer checks beyond `lake build`: scan for forbidden axioms/constants, `sorry`/`admit`, hidden semantic closures, and unexpectedly broad proof edits. |
| Reuse memory | The theorem-store idea records proved theorems so future proof attempts can import and reuse them. | QBE should maintain a domain-specific theorem/proof-block library for reusable matrix-index, projection, LCU-contract, and gate-semantics lemmas. |
| Lemma discovery | Lean LSP plus external lemma search gives the prover structured suggestions before tactic search. | Middle agents should search existing QBE declarations and Mathlib-style names before creating duplicate circuit/projection lemmas. |
| Tree-of-subgoals | Hard proofs can be decomposed into `have ... := by sorry` skeletons, solved independently, then stitched back and checked. | QBE can use the same idea only as an internal proof-attempt workflow: placeholders must not remain in committed accepted proof targets, and every stitched result must pass `lake build`. |
| Multi-planner | Several planners propose different proof strategies before a prover chooses one. | In faithful mode, multiple plans may compete only for the same fixed theorem. In exploratory mode, this becomes candidate construction search under a Lean-checkable acceptance predicate. |
| Extensibility | Skills, tools, and plugins provide domain-specific strategies and analysis commands. | QBE already has `.agents/skills/`; new skills should encode block-encoding-specific proof diagnostics, source-dependency audits, and projection proof patterns. |
| Scheduled loops | Recurring agent loops can continue monitoring or proving over time. | QBE's `sleep-run` is the corresponding overnight proof loop, with upper/middle/lower/reviewer roles and trial memory. |

## What QBE Should Not Copy

- QBE should not become a general natural-language-to-Lean service.
- QBE should not store conversational assumptions as accepted axioms for
  faithful paper reproduction. If an assumption is needed, it must be a cited
  contract or explicit proof obligation with `proved := false`.
- QBE should not accept proof-search scores as correctness. The Lean theorem
  and all required semantic obligations remain the final judge.
- QBE should not copy MathCode code without a license audit. The local checkout
  currently exposes a README citation and acknowledgment, but no top-level
  license file was found.

## QBE Implementation Backlog

1. Add a QBE proof-diagnostics skill for reviewer and middle agents.
2. Add a theorem/proof-block registry for reusable QBE lemmas, analogous to a
   theorem-store but scoped to block-encoding matrix semantics.
3. Add a lightweight Lean scan command to `tools/qbe.py` for:
   - `sorry` and `admit`,
   - forbidden `axiom`, `constant`, or `postulate` in proof files,
   - hidden semantic flag promotions,
   - proof statistics for changed Lean files.
4. Add a focused-file check mode after the GHL2025 proof route stabilizes, so
   lower agents can iterate faster without weakening the full build gate.
5. Extend proof-attempt memory with tree-of-subgoals records: source statement,
   subgoal skeleton, solved leaves, failed leaves, and final stitched theorem
   status.

## Citation

MathCode's README requests citation as:

```bibtex
@misc{mathcode2026,
  title = {MathCode: A Frontier Mathematical Coding Agent},
  author = {Team Math-AI},
  journal = {math-ai-org.github.io},
  year = {2026},
  month = {April},
  url = "https://github.com/math-ai-org/mathcode"
}
```
