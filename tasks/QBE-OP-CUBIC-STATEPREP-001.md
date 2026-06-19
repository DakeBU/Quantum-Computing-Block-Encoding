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

Hard Mode escalation is also recorded in Lean:

```text
CubicStatePreparation.hardModeUpperAgentSchedule = [1, 3, 4]
CubicStatePreparation.hardModeMiddleAgentSchedule = [1, 2, 3]
CubicStatePreparation.hardModeLowerAgentSchedule = [3, 5, 8]
CubicStatePreparation.hardModeExactStallWindow = 2
CubicStatePreparation.hardModeConstructionStallWindow = 3
CubicStatePreparation.hardModeLevelCycleBudget = [2, 3, 4]
CubicStatePreparation.relaxedEpsilonLadder = [1e-10, 1e-8, 1e-6]
```

The upper panel must not jump directly to the largest panel.  The intended
schedule is:

| Phase | Trigger | Agent allocation | Goal |
|---|---|---|---|
| L0 exact contraction and candidate seeding | task starts or memory was stale | upper=1, middle=1, lower=3: candidate architect, Lean worker, verifier | seed at least one concrete `U_n` family while also closing target/norm leaves and rejecting wrong exact state-prep interpretations |
| L1 requested-epsilon Scenario 2 | no closed leaf or no concrete candidate for 2 cycles | upper=3, middle=2, lower=5: 2 architects, 2 Lean workers, 1 verifier/export worker | find or repair a symbolic approximate candidate at `1e-10` |
| L2 relaxed waypoint search | no improving certified/finite candidate for 3 cycles | upper=4, middle=3, lower=8 | try `1e-8`, then `1e-6` as waypoints, while keeping the final requested target visible |

Every escalation must record whether the extra agents improved the certified
population, the finite verifier population, or only the insight pool.

## Population And Mutation Policy

ABEIS keeps three separate populations:

- **certified population**: Lean-proved candidates only; these are the only
  candidates that may appear on achieved-resource curves;
- **finite executable population**: Qiskit/NumPy/QuantumKatas-style candidates
  that pass fixed-instance checks for small `n`; these may guide search but are
  not accepted as family certificates;
- **insight pool**: failed or unproved routes with a reusable idea, such as a
  normalizer trick or an arithmetic transduction plan.

At L1 and L2, lower agents should spend each generation on a mixture of:

- mutation: alter one candidate route while preserving the target operator;
- crossover: combine two useful ingredients, for example a normalizer bound
  from one route and an arithmetic state-preparation skeleton from another;
- repair: close exactly one Lean proof leaf or turn a failed finite check into
  a smaller counterexample;
- export: write Qiskit/QuantumKatas/QASM artifacts only for a concrete
  candidate, with a clear semantic label.

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

## External Tool Boundary

Local public artifacts checked so far do not expose a direct generic function
"given operator `O_n`, synthesize and prove a block encoding family."  The fair
comparison therefore has two categories:

- **direct fixed-instance executable checks**: NumPy dense completion, Qiskit
  `Operator`, and a Qiskit-QuantumKatas-style evaluator can verify a concrete
  small-`n` dense candidate;
- **not direct BE constructors**: QASM-Eval provides useful typed QASM
  feedback, QUASAR is a tool/reward-loop reference without a runnable same-task
  local route, and AI-Mandel is a quantum-physics idea-to-tool loop rather than
  a block-encoding verifier.

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

- lower candidate architect: immediately propose one Lean-checkable candidate
  family `U_n`, with register layout, block projector, normalizer `alpha`,
  unitary argument, resource tier, and approximate error budget.  It is fine
  if some analytic leaves remain obligations; do not wait for `CUBIC-NORM-001`
  before naming a candidate.
- lower Lean worker: close one small exact diagnostic lemma or reusable
  rational normalizer lemma in parallel with candidate design.  Do not use this
  leaf as a serial gate that blocks candidate seeding.
- lower verifier/export worker: use the existing dense/Qiskit comparison as a
  baseline and, once a candidate architect names `U_n`, run fixed-instance
  necessary-condition checks for that candidate.  If no concrete candidate is
  available, write a typed feedback packet saying the blocker is
  `candidate_interface_gap`, not another norm-only retry.
- reviewer: reject any candidate that treats the unnormalized vector as a
  unitary output state without either normalization or block-encoding scaling.
