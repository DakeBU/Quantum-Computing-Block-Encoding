---
name: qbe-block-encoding-library
description: Select and reuse ABEIS block-encoding construction memories when a task asks for a quantum query operator, oracle, matrix unit, sparse matrix, LCU, tensor/product construction, dilation, QSVT input, resource score, or Lean proof-DAG route.
argument-hint: "[operator target or task id]"
---

# QBE Block-Encoding Library

Use this skill before proposing a new block-encoding circuit or proof route.
The goal is not to survey papers.  The goal is to choose a reusable
construction card, instantiate it, and emit Lean-checkable proof-DAG leaves.

## Required Routing Step

Read `research-wiki/block-encoding-library/route-selector.md`, then choose at
least one card from `research-wiki/block-encoding-library/cards/`.

Prefer exact, entrywise clean-block proofs before approximate norm proofs:

```text
U(clean row, clean col) = A(row, col) / alpha
```

Only after exact search stalls should the upper layer open an approximate
block-encoding objective with an explicit epsilon tier.

## Route Priority

1. Matrix unit, projector, partial injection, or controlled reset with identity
   factor: use `BE.PartialPermutation.MatrixUnitTensorId` and
   `BE.PermMatrix.CleanBlock`.
2. Operator acts on an active register and leaves another register unchanged:
   add `BE.Tensor.PassiveRegister`.
3. Finite sum of already encodable terms: use `BE.LCU.PrepareSelect`.
4. Product, tensor, or direct composition of known block encodings: use the
   arithmetic cards.
5. Sparse matrix with row/column/value access: use
   `BE.SparseAccess.GramConstruction`.
6. Density or Gram matrix from a purification/state preparation: use
   `BE.Density.FromPurification`.
7. Arbitrary contraction or small dense fallback: use dilation cards.
8. QSVT, inverse, sign, filter, or polynomial transformation: treat QSVT as a
   downstream consumer contract unless the task explicitly asks to formalize
   QSVT itself.

## Output Packet

Every construction packet should include:

- target operator and normalizer;
- chosen card ids and why other routes were rejected;
- candidate unitary/circuit family;
- clean block theorem statement;
- unitarity theorem statement;
- resource tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)`;
- proof-DAG leaves small enough for lower agents;
- external cited contracts and their memory ids.

Lean is the acceptance gate.  Qiskit, QASM, simulator, or finite Python checks
may be used as necessary-condition diagnostics or post-Lean software exports,
but they do not certify the advertised theorem.
