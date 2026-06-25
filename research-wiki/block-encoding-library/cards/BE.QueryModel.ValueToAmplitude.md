# Card: BE.QueryModel.ValueToAmplitude

## When To Try This Route

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

## Intuition

The value oracle does not itself block-encode the matrix.  It only writes a
classical value or angle into workspace.  The controlled rotation converts that
value into a signal-qubit amplitude, and the uncompute step removes the
workspace so the clean block is not entangled with garbage.

## Normalizer and Error Notes

- `alpha` is usually the value bound used before rotation.
- Fixed-point arithmetic, angle synthesis, and rotation synthesis errors must
  appear as explicit epsilon sources.
- If cleanup is missing, this route is invalid even if the signal amplitude
  looks correct on a small simulation.

## Lean Anchor

- `BlockEncodingClassics.ValueToAmplitudeContract`

The contract requires both cleanup and amplitude-entry proofs.  It is not a
fake theorem: a task cannot use it unless it supplies those proofs.

## Source Memory

Lin 2201.08309 query-model discussion for matrix-entry amplitude oracles.
