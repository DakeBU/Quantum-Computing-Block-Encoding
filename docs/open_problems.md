# Open Problems

The Lean source of truth is `QuantumBlockEncoding/OpenProblems.lean`.

## QBE-001

Gate-level Robin derivative block encoding for arbitrary finite-difference
stencil.

Acceptance: a Lean `VerifiedBlockEncoding` whose concrete matrix semantics
equals the requested derivative matrix and whose resource bound is
`O(kappa*n)` plus coefficient-oracle cost.

## QBE-002

Nonseparable multivariate amplitude oracle.

Acceptance: a Lean construction that takes a multivariate polynomial
certificate and returns a block encoding with explicit normalization and gate
count.

## QBE-003

Normalization optimization for PDE Hamiltonians.

Acceptance: a Lean theorem comparing two candidate constructions and proving a
smaller normalization or a lower bound.

## QBE-004

Pure-ancilla reuse certificates.

Acceptance: gate-semantics proofs that comparator, multi-control, and
sparse-access subcircuits return reusable work qubits to `|0>`.

## QBE-005

QSVT phase-factor certificate pipeline.

Acceptance: import generated phase factors and prove the requested polynomial
approximation error.

## QBE-006

Discrete Schrodingerisation clock error.

Acceptance: formal trace-norm or observable-error bound in terms of `sigma` and
Richardson order.

## QBE-007

Graph-to-circuit matrix construction search.

Acceptance: reproducible search artifact plus a Lean certificate linking graph
edges to matrix entries and gates.
