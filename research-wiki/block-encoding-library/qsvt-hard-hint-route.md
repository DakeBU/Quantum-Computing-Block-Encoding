# QSVT Hard-Hint Route

Use this card when the user or upper agent suggests:

```text
first construct a block encoding of O_0 = sum_j x_j |j><j|,
then use QSVT to obtain x^3 or another polynomial transform
```

This is a route memory, not a completed theorem unless the referenced Lean
contracts are closed.

## Route Sketch

1. Target a diagonal value oracle:
   $$
   O_0 = \sum_{j=0}^{2^n-1} x_j |j\rangle\langle j|,
   \qquad x_j = j/2^n.
   $$
2. Build or cite a value-to-amplitude or diagonal controlled-rotation block
   encoding of `O_0`.
3. Treat QSVT as a consumer of this proved block encoding.  For
   $P(x)=x^3$, the polynomial is bounded on `[-1,1]` and has odd parity.
4. Produce a proof DAG:
   `O_0 BE -> QSVT admissibility of x^3 -> QSVT consumer contract -> BE of O_0^3`.
5. If the full QSVT theorem is not formalized, mark that node
   `contract-only`; do not claim final Lean certification beyond the contract
   boundary.

## Lean Anchors

- `QuantumBlockEncoding/BlockEncodingClassics.lean`
- `chebyshevT`
- `QubitizationChebyshevContract`
- `QSVTConsumerContract`
- `exactAsZeroErrorApproxCleanBlock`

## Reviewer Checklist

- Is the input block encoding of `O_0` actually certified?
- Are QSVT side conditions stated, not hidden?
- Is the theorem claiming a closed Lean proof, or only a contract skeleton?
- If Scenario 2 approximate search is active, is the epsilon tier explicit?
- Are non-Lean simulator/Qiskit checks used only as diagnostics or exports?

## Suggested Lower Tasks

- Lean lower: formalize the diagonal clean-block entry for the proposed
  `O_0` construction.
- Natural-language lower: write the proof DAG and identify which QSVT
  side conditions are textbook/contract-only.
- Reviewer: decide whether the active goal is exact `O_0^3`, an approximate
  polynomial route, or a contract skeleton pending QSVT formalization.
