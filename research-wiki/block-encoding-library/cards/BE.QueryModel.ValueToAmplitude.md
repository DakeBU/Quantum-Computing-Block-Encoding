# Card: BE.QueryModel.ValueToAmplitude

## Detection

Use when entries are available through a reversible value oracle and must be
turned into a signal-qubit amplitude by a controlled rotation.

## Mathematical Pattern

The standard route is:

```text
compute value or angle
-> controlled rotation
-> uncompute work register
-> signal amplitude is the desired matrix entry
```

## Lean Anchor

- `BlockEncodingClassics.ValueToAmplitudeContract`

The contract requires both cleanup and amplitude-entry proofs.  It is not a
fake theorem: a task cannot use it unless it supplies those proofs.

## Source Memory

Lin 2201.08309 query-model discussion for matrix-entry amplitude oracles.
