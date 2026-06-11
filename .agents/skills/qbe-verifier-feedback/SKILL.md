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
python3 tools/qbe.py trial-log --task QBE-AUTO-002 \
  --role lower \
  --kind attempt \
  --status failed \
  --artifact proof-attempts/QBE-AUTO-002/<file>.md \
  --feedback-field leaf=slot-three-branch-vanish \
  --feedback-field source_correspondence_ok=true \
  --feedback-field lean_parse_ok=true \
  --feedback-field lean_build_ok=false \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=false \
  --feedback-field error_class=symbolic_bridge_gap \
  --feedback-field next_route="prove evalWith-level entry bridge for full index 48"
```

For larger payloads, write a JSON file under `verifier-feedback/<task-id>/` and
pass it with `--feedback-json`.

## What Is Useful For GHL2025 Now

The current GHL2025 one-term Robin closure is a finite matrix-semantics proof
route, not a hardware scheduling problem.  The useful diagnostics are:

- Lean parser/build checks;
- small finite matrix-entry checks for `n = 3`;
- support/vanish/cancellation checks for backend slots;
- register and branch correspondence checks against Fig. 4 and the one-term
  theorem source;
- symbolic bridge checks, especially raw `Coeff` constructor equality versus
  evaluated `evalWith` semantics;
- proof-DAG stale-leaf checks.

The following are not useful for the current GHL blocker:

- timeline/scheduling checks;
- pulse-level checks;
- hardware transpilation checks;
- output-distribution-only tests that ignore the full linear operator;
- reward scores that treat a near miss as proof.

## Good GHL Leaf Decomposition

For GHL-style gate-product entries, split failures this way:

1. `source`: Does this leaf correspond to the paper's boundary or bulk branch?
2. `shape`: Are row/column indices, sparse slot, and full-basis index correct?
3. `support`: Does the relevant gate entry vanish by support?
4. `finite-eval`: Does the finite evaluated matrix entry reduce to the expected
   scalar?
5. `symbolic-bridge`: Is the remaining task only to connect evaluated semantics
   to the named Lean theorem?
6. `theorem`: Does a named Lean declaration close the exact target without new
   assumptions?

Middle should put this classification into the proof-obligation or
conversion-window table before assigning another broad lower proof attempt.

