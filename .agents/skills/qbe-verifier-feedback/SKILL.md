---
name: qbe-verifier-feedback
description: Use typed parser/build/finite-matrix/symbolic-proof feedback to classify QBE lower-agent attempts before final Lean theorem closure.
argument-hint: "[task id or active leaf]"
---

# QBE Verifier Feedback

Use this skill when a lower attempt partially succeeds, fails, or needs to be
ranked against other proof routes.  The goal is to convert vague failure prose
into a small set of fields that upper, middle, reviewer, and future lower
agents can reuse.

This skill borrows the useful shape of non-Lean quantum-circuit verifier systems
such as QASM-Eval, Qiskit QuantumKatas, QUASAR, and AI-Mandel: parsers, unit
tests, simulators, tool errors, pass@k-style populations, and structured failure
types.  QBE adapts that shape to block-encoding formalization.  These
diagnostics guide search; they do not prove correctness.

## Core Rule

Lean theorem closure is the only acceptance gate.  Parser, test, simulator,
finite-case, reward, and pass@k signals are search feedback.

In faithful paper-reproduction mode, these signals may rank proof routes for the
same fixed statement.  They must not mutate the paper's theorem, circuit,
oracle contract, normalizer, or assumptions.

In exploratory construction mode, these signals may rank candidate circuit
families.  A candidate is accepted only when the Lean target and proof
obligations are closed.

## Feedback Fields

Record these fields when applicable:

| Field | Meaning |
|---|---|
| `leaf` | Active proof-DAG leaf or circuit subproblem. |
| `source_correspondence_ok` | The Lean target matches the cited paper/source step. |
| `lean_parse_ok` | Lean file parses after the attempt. |
| `lean_build_ok` | The relevant build/check gate passes. |
| `finite_matrix_ok` | Small finite matrix check agrees with the intended semantics. |
| `block_entry_ok` | The tested/targeted top-left block or entry equality holds. |
| `ancilla_cleanup_ok` | The clean-ancilla condition is checked or irrelevant. |
| `normalizer_ok` | The alpha/normalizer statement is checked or irrelevant. |
| `closed_theorem_ok` | A named Lean theorem closes the exact target. |
| `error_class` | One controlled failure class. |
| `next_route` | The next narrow route, not a broad aspiration. |

Use `null` for irrelevant fields, not `true`.

## Error Classes

Use exactly one primary class:

- `source_translation_gap`: the paper/source step has not been mapped into a
  Lean-facing statement.
- `shape_or_register_gap`: dimensions, registers, wires, basis indices, or
  ancilla layout are wrong or underspecified.
- `finite_matrix_counterexample`: a concrete finite check contradicts the
  proposed statement.
- `symbolic_bridge_gap`: finite checks look right, but the Lean statement needs
  a bridge between symbolic constructors and evaluated semantics.
- `lean_tactic_gap`: the statement is believed correct and well-shaped, but the
  proof script has not been found.
- `external_contract_gap`: the paper relies on a cited theorem or primitive not
  yet formalized locally.
- `stale_leaf`: the assigned target is already compiled or no longer on the
  active proof route.
- `invalid_route`: the attempt changes the paper construction, weakens the
  theorem, or adds an assumption.

## QBE Logging

Use `trial-log` with structured feedback:

```bash
python3 tools/qbe.py trial-log --task <task-id> \
  --role lower \
  --kind attempt \
  --status failed \
  --artifact verifier-feedback/<task-id>/<file>.md \
  --feedback-field leaf=<active-leaf-id> \
  --feedback-field source_correspondence_ok=true \
  --feedback-field lean_parse_ok=true \
  --feedback-field lean_build_ok=false \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=false \
  --feedback-field error_class=symbolic_bridge_gap \
  --feedback-field next_route="<one narrow next proof or diagnostic route>"
```

For larger payloads, write a JSON file under `verifier-feedback/<task-id>/` and
pass it with `--feedback-json`.

## Choosing Useful Diagnostics

Choose diagnostics that are necessary for the target and cheaper than the next
large Lean proof attempt.  A diagnostic is useful when failure proves the
candidate or proof route is wrong, malformed, stale, or too underspecified to
send to the Lean worker.

Useful diagnostics often include:

- parser/build checks for files touched by the attempt;
- dimension, register-layout, projector, and ancilla-count checks;
- small finite matrix or statevector checks when the task has a finite
  executable instance;
- block-entry extraction checks for the clean block named in the target;
- unitarity or reversibility checks for a proposed candidate circuit;
- normalizer and error-budget checks for approximate block encodings;
- schedule/depth/gate-count checks when resource ranking is part of the task;
- proof-DAG stale-leaf checks against the current retrieval index.

Avoid diagnostics that do not constrain the active target.  For example,
hardware transpilation, pulse-level timing, or output-distribution-only tests
are usually irrelevant unless the user explicitly asks for that semantic tier.

## Leaf Decomposition Pattern

Split a failing lower attempt into this task-independent chain:

1. `target`: Does the Lean or executable statement encode the same operator,
   projector, normalizer, and error tolerance as the user or source target?
2. `shape`: Are dimensions, registers, indices, ancillas, and basis order
   correct?
3. `support`: Do impossible branches or zero entries vanish for the stated
   reason?
4. `finite-eval`: Do small checked instances agree with the intended matrix or
   block-entry semantics?
5. `symbolic-bridge`: If finite checks look right, what semantic bridge remains
   between executable/numeric evidence and the named Lean declaration?
6. `theorem`: Does a named Lean declaration close the exact or approximate
   target without new assumptions?

Middle should put this classification into the proof-obligation,
candidate-population, verifier-feedback, or conversion-window table before
assigning another broad lower proof attempt.
