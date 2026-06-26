# External Lean Library Card: lean-quantum

Upstream: <https://github.com/Hayata-Yamasaki-Group/lean-quantum>

Development checkout: `outer_repos/quantum/lean-quantum`

License: Apache-2.0, according to the inspected checkout.

## Public Surface

The inspected checkout exposes `Quantum.lean` and a project website.  The
project is useful to ABEIS as a broader quantum-formalization reference, with
emphasis on quantum states, channels, qudits, operator-style conventions, and
future AI-assisted formalization interfaces.

## ABEIS-Relevant Use

ABEIS currently keeps its block-encoding certificates local.  Agents should
use lean-quantum as a reference when a task begins to require higher-level
semantics beyond explicit finite matrix entries, such as:

- channels or trace-like operations;
- state families and qudit conventions;
- norm, positivity, or operator-theoretic side conditions;
- reusable quantum facts that should not be hidden inside a block-encoding
  example.

## Retrieval Rule

If a proof leaf looks like a general quantum-state/channel/operator theorem,
middle should check this card and the local checkout before assigning a
task-local theorem.  Any useful declaration should be recorded with its module,
status, and adapter plan; ABEIS should avoid duplicating large generic quantum
infrastructure inside block-encoding examples.
