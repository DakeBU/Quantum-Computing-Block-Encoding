# External Lean Library Card: Lean-QuantumInfo

Upstream: <https://github.com/Timeroot/Lean-QuantumInfo>

Development checkout: `outer_repos/quantum/Lean-QuantumInfo`

License: MIT, according to the inspected checkout.

## Public Surface

The inspected checkout contains finite-dimensional quantum-information and
classical-information modules, including:

```text
QuantumInfo.lean
QuantumInfo/ForMathlib.lean
QuantumInfo/Regularized.lean
ClassicalInfo/Channel.lean
ClassicalInfo/Distribution.lean
ClassicalInfo/Entropy.lean
ClassicalInfo/Prob.lean
ClassicalInfo/Capacity.lean
```

## ABEIS-Relevant Use

Lean-QuantumInfo is not imported by ABEIS at present.  Agents should use it as
a reference for finite-dimensional quantum-information APIs and proof style,
especially when a block-encoding task starts to need:

- finite-dimensional distributions or channels;
- entropy or capacity vocabulary;
- facts that may belong in Mathlib or a shared quantum-information layer rather
  than in a task-local ABEIS file.

## Retrieval Rule

When a task needs a general quantum-information statement rather than a
block-encoding-specific construction, upper/middle agents should inspect this
card before inventing local definitions.  If a Lean-QuantumInfo declaration is
useful but not directly imported, record the exact module and declaration in a
Mathlib/technical lemma card and assign only the narrow ABEIS adapter.
