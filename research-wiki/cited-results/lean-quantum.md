# lean-quantum

Source:
[Hayata-Yamasaki-Group/lean-quantum](https://github.com/Hayata-Yamasaki-Group/lean-quantum)

Local checkout:
`../outer_repos/quantum/lean-quantum`

Status:
`reference-only`

## Memory Card

| Field | Value |
| --- | --- |
| `id` | `lean-quantum-hayata-yamasaki` |
| `source` | GitHub repository, Apache-2.0 license |
| `statement` | External Lean project formalizing quantum information and quantum computation: qudits, states, channels, partial traces, entropy, and trace inequalities. |
| `lean_decl` | No ABEIS import yet. |
| `lean_status` | `reference-only` |
| `used_by` | Future finite-matrix/operator bridge work; quantum-state/channel semantic checks. |
| `dependencies` | Mathlib, external `Quantum` lake project. |
| `next_action` | Compare its unitary/trace/tensor conventions against ABEIS finite matrix circuit semantics before adding any dependency. |
| `tags` | `quantum-formalization`, `lean-reference`, `operator-semantics`, `not-a-certificate` |

## ABEIS Use

Use `lean-quantum` as a memory library when an ABEIS task needs a
quantum-information definition or operator-theoretic lemma.  Do not use it as
evidence that a candidate circuit is a block encoding until a local Lean bridge
imports or restates the needed declaration and the ABEIS block-entry theorem
closes.

