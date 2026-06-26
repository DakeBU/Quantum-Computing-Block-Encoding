# External Lean Library Card: quantum-computing-lean

Upstream: <https://github.com/duckki/quantum-computing-lean>

Development checkout: `outer_repos/quantum/quantum-computing-lean`

Inspected commit: `2da8872` (`update module comments`)

License note: no top-level license file was found in the inspected checkout.
ABEIS therefore records this project as a reference surface and does not copy
source code into this repository.

## Public Module Shape

The project exposes a compact finite-dimensional quantum-computing module DAG:

```text
QuantumComputing.Matrix
  -> QuantumComputing.State / States
  -> QuantumComputing.Gates.Basic
  -> QuantumComputing.Gates.Properties / Actions / Projectors
  -> QuantumComputing.Gates.Decompositions
  -> QuantumComputing.Measurement.*
  -> QuantumComputing.Theorems.*
  -> QuantumComputing
```

The upstream rendered graph is in the upstream repository at
`docs/module-graph.svg`.

## ABEIS-Relevant Surfaces

| Upstream surface | Representative declarations | ABEIS counterpart design |
| --- | --- | --- |
| Matrix API | `Matrix.adjoint`, `Matrix.mul`, `Matrix.trace`, `Matrix.proj`, `Matrix.kron` | style reference for finite matrix extensionality and tensor notation |
| States | `ket0`, `ket1`, `ketPlus`, `ketMinus`, normalization lemmas | basis-state and state-preparation examples |
| Basic gates | `X`, `Z`, `H`, `CNOT`, `TOFFOLI`, `CZ`, `SWAP`, `controlledGate` | future finite gate library alignment |
| Gate properties | `X_isUnitary`, `H_isUnitary`, `CNOT_isUnitary`, `TOFFOLI_isUnitary`, `SWAP_isUnitary` | reference pattern for small unitarity leaves |
| Gate actions | `X_mul_ket0`, `H_mul_ket0`, `CNOT_mul_ket10`, `TOFFOLI_mul_basis`, `SWAP_kron` | reference pattern for basis-action leaves separated from matrix equality |
| Projectors | `P0`, `P1`, `PPlus`, `PMinus`, projector algebra lemmas | clean-projector proof style |
| Decompositions | `CNOT_decompose`, `CZ_decompose`, `H_Z_H_eq_X` | future gate-decomposition and resource leaves |

## Connection To ABEIS Leaves

ABEIS does not currently import this project.  The connection is conceptual:

- duckki gate actions suggest how to write small action lemmas for executable
  circuit semantics.
- duckki unitarity lemmas suggest how to separate unitarity from clean-block
  equality.
- duckki projectors suggest a clean style for ancilla projection lemmas.
- duckki module graph suggests that public documentation should show the
  dependency structure before listing individual files.

The accepted ABEIS theorem payload remains in
`QuantumBlockEncoding/BlockEncodingClassics.lean` and the corresponding cards
under `research-wiki/block-encoding-library/`.

## Agent Rule

When an ABEIS task mentions a named gate, projector, or finite state that looks
similar to a declaration in this library, the upper agent may inspect this
card and propose a matching local API.  The lower agent should still prove the
ABEIS theorem locally, with Mathlib-compatible names and hypotheses whenever
possible.
