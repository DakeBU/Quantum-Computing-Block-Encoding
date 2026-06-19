# Cubic grid state-preparation operator

Task id: `QBE-OP-CUBIC-STATEPREP-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## User Target

For a positive integer `n`, let `N = 2^n`, `x_j = j / N`, and
`f(x) = x^3`.  The user-level statement is

```text
O |0^n> = sum_{j=0}^{N-1} f(x_j) |j>
```

The right hand side is generally not normalized, so ABEIS fixes the
Lean-checkable operator as the rank-one map

```text
O_n = |v_n><0^n|,      v_n[j] = (j / 2^n)^3.
```

This means `O_n` maps `|0^n>` to the requested unnormalized vector and maps
all other computational basis inputs to zero.  If a user wants a normalized
state-preparation unitary instead, that is a different target
`|v_n / ||v_n||><0^n|` and must be stated separately.

## Error And Search Policy

Requested tolerance:

```text
epsilon = 1e-10
```

ABEIS should run the usual adaptive policy:

1. try exact block encodings first;
2. if exact search stalls or cannot meet the resource floor, enter Scenario 2;
3. in Scenario 2, search for an approximate block encoding satisfying

   ```text
   || O_n - alpha * ((<0^a| tensor I) U (|0^a> tensor I)) || <= epsilon;
   ```

4. if no improvement appears after the configured stall window, increase
   parallel upper/middle/lower agents up to the configured maximum and record
   whether the extra agents improved the certified population.

The initial policy is compiled in Lean as
`CubicStatePreparation.defaultPolicy`.

## Score

Within one asymptotic/backend tier, candidates are ranked by

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

The asymptotic tier must be recorded first.  A dense-table state preparation
candidate and an arithmetic polynomial candidate are not in the same tier.

## Expected Baselines

- **Generic dense baseline.**  Materialize all amplitudes and use a generic
  state-preparation routine.  This is useful for small `n`, but its description
  and verifier cost scale with `2^n`.
- **Universal block-encoding completion.**  Use the generic block matrix
  completion for a scaled matrix.  This is a correctness seed but is not
  expected to be resource-competitive.
- **ABEIS target route.**  Use reversible arithmetic to compute `j / 2^n`,
  approximate the cubic amplitude, and synthesize controlled rotations or an
  equivalent approximate state-preparation block.  The intended scaling target
  is polynomial in `n` and `log(1/epsilon)`, not table size.

## Lean Surface

Current compiled declarations:

```lean
QuantumBlockEncoding.CubicStatePreparation.taskId
QuantumBlockEncoding.CubicStatePreparation.requestedEpsilon
QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude
QuantumBlockEncoding.CubicStatePreparation.cubicOperator
QuantumBlockEncoding.CubicStatePreparation.cubicNormSq
QuantumBlockEncoding.CubicStatePreparation.cubicTarget
QuantumBlockEncoding.CubicStatePreparation.defaultPolicy
QuantumBlockEncoding.CubicStatePreparation.initialExpectedPhase
```

These are target declarations and diagnostics, not a final block-encoding
certificate.

## Next Agent Packet

- lower natural-language architect: write the approximate arithmetic synthesis
  route and the error budget decomposition.
- lower Lean worker: implement one small exact diagnostic lemma or one
  reusable rational norm lemma; do not try to close the full analytic theorem
  in a single pass.
- lower verifier worker: dense statevector/unitary scaling for `n = 4, 8, 12,
  16, 20` is recorded in
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`;
  wait for a concrete candidate before running new finite block-entry checks.
- reviewer: reject any candidate that treats the unnormalized vector as a
  unitary output state without either normalization or block-encoding scaling.
