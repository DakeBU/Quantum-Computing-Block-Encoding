# Proof Blueprint: QBE-OP-CUBIC-DIAGONAL-CLEAN-001

Task id: `QBE-OP-CUBIC-DIAGONAL-CLEAN-001`
Title: Task: QBE-OP-CUBIC-DIAGONAL-CLEAN-001
Mode: `exploratoryConstruction`
Updated: `2026-06-21 20:25:44`
Blueprint stage: `Stage unknown; upper must classify before broad lower work`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
# Task: QBE-OP-CUBIC-DIAGONAL-CLEAN-001

Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## Clean-Start Rule

This task is a clean harness-comparison benchmark. Agents must not use previous cubic diagonal attempts, previous ChatGPT Pro suggestions, old candidate names, or old run memory. Use only this task packet, the current Lean environment, and standard ABEIS rules.

## Raw User Problem

假设 `n` 为正整数，是量子比特数。构造一个 oracle/operator

$$
O_n = \sum_{j=0}^{2^n-1} f(x_j) |j\rangle\langle j|,
\qquad f(x)=x^3,
\qquad x_j = j/2^n.
$$

请构造这个 operator `O_n` 的 block-encoding `U_O`。

## Lean-Checkable Target

For `N = 2^n`, define the diagonal operator

$$
D_n[j,j] = (j/N)^3, \qquad D_n[j,k] = 0 \text{ for } j \ne k.
$$

The exact normalizer target is initially `alpha = 1`, since `0 <= (j/2^n)^3 < 1` for all grid points.

Default adaptive policy for this hard benchmark:

- spend only a short exact-search patience budget before broad expansion;
- with the default `sleep-run --exact-stall-cycles 2`, if no Lean-certified exact candidate exists after that budget and upper/reviewer memory records stagnation or a blocked proof route, open Scenario 2 approximate-BE search;
- initialize Scenario 2 at `epsilon = 1e-10`;
- if no candidate can meet `1e-10` within the next bounded generation budget, upper may relax epsilon, but every relaxation must be recorded as an explicit epsilon-ladder decision in the memory digest, candidate population, selected-language summary, and Pro prompt.

## Resource Order

Inside the same asymptotic tier, rank Lean-certified candidates lexicographically by:

1. gate count,
2. depth,
3. auxiliary qubits,
4. unresolved oracle calls.

Asymptotic tier must be recorded before constant-factor comparisons. Only Lean-certified exact or approximate candidates may be plotted as achieved solutions.

## Adaptive Capacity Rule

There is no user-visible easy/hard preset. Upper reads the logs and may increase upper, middle, or lower parallelism when the bottleneck justifies it:

- increase upper capacity for semantic-tier choice, exact-vs-approx strategy, or candidate-family strategy;
- increase middle capacity for Lean/natural-language translation, stale memory, or candidate-population bookkeeping;
- increase lower capacity when several independent proof leaves or candidate families are ready.

Every increase receives a fixed generation budget and must report whether it improved the certified population, finite verifier population, or insight pool.

## Required Closeout Artifacts

If unresolved, write a selected-language summary and a self-contained ChatGPT Pro prompt. If resolved or partially resolved, write:

- a step-by-step LaTeX proof note for the best Lean-certified exact/approximate candidate;
- certified exact/approximate evolution curves;
- circuit storyboards for Lean-certified candidates only;
- Qiskit export and finite executable checks for each exported certified construction.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| none detected | upper must refresh the task directive |

## Open Obligation Signals

```text
no compact obligation signals found
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| structure | `ExpandedCubicArithmeticBackend` | `QuantumBlockEncoding/CubicStatePreparation.lean:1020` |
| def | `symbolicExpandedCubicArithmeticBackend` | `QuantumBlockEncoding/CubicStatePreparation.lean:1035` |
| def | `expandedArithmeticBackendComputesCubicAmplitude` | `QuantumBlockEncoding/CubicStatePreparation.lean:1051` |
| theorem | `symbolicExpandedCubicArithmeticBackend_computes` | `QuantumBlockEncoding/CubicStatePreparation.lean:1065` |
| def | `expandedArithmeticBackendBridge` | `QuantumBlockEncoding/CubicStatePreparation.lean:1080` |
| theorem | `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | `QuantumBlockEncoding/CubicStatePreparation.lean:1086` |
| theorem | `expandedArithmeticBackendBridge_iff_of_computes` | `QuantumBlockEncoding/CubicStatePreparation.lean:1101` |
| theorem | `expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge` | `QuantumBlockEncoding/CubicStatePreparation.lean:1122` |
| theorem | `symbolicExpandedCubicArithmeticBackend_bridge_iff` | `QuantumBlockEncoding/CubicStatePreparation.lean:1142` |
| theorem | `fixedDenomCubicPayload_lt_capacity` | `QuantumBlockEncoding/CubicStatePreparation.lean:1155` |
| theorem | `fixedDenomCubicAmplitude_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:1167` |
| def | `fixedDenomCubicArithmeticBackend` | `QuantumBlockEncoding/CubicStatePreparation.lean:1183` |
| theorem | `fixedDenomCubicArithmeticBackend_computes` | `QuantumBlockEncoding/CubicStatePreparation.lean:1201` |
| def | `expandedArithmeticComputesCubicAmplitudeTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1220` |
| theorem | `fixedDenomCubicArithmeticRouteTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1232` |
| theorem | `fixedDenomCubicArithmeticBackend_bridge_iff` | `QuantumBlockEncoding/CubicStatePreparation.lean:1246` |
| def | `expandedControlledRyUsesCubicAngleTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1271` |
| theorem | `fixedDenomControlledRyRouteTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1282` |
| def | `expandedControlledRyBackendBridge` | `QuantumBlockEncoding/CubicStatePreparation.lean:1296` |
| theorem | `expandedControlledRyUsesCubicAngle_of_backendBridge` | `QuantumBlockEncoding/CubicStatePreparation.lean:1302` |
| theorem | `expandedControlledRyBackendBridge_iff_of_standardTier` | `QuantumBlockEncoding/CubicStatePreparation.lean:1318` |
| structure | `ExpandedControlledRyWorkspaceReadonlyWitness` | `QuantumBlockEncoding/CubicStatePreparation.lean:1340` |
| def | `expandedControlledRyWorkspaceReadonlyTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1360` |
| structure | `ExpandedArithmeticCleanUncomputeWitness` | `QuantumBlockEncoding/CubicStatePreparation.lean:1377` |
| def | `expandedWorkspaceCleanUncomputedTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1405` |
| theorem | `expandedWorkspaceCleanUncomputedTransparent_of_witness` | `QuantumBlockEncoding/CubicStatePreparation.lean:1409` |
| def | `fixedDenomCubicComputeStep` | `QuantumBlockEncoding/CubicStatePreparation.lean:1457` |
| def | `fixedDenomCubicUncomputeStep` | `QuantumBlockEncoding/CubicStatePreparation.lean:1465` |
| theorem | `fixedDenomCubicComputeStep_matches_backend_on_clean` | `QuantumBlockEncoding/CubicStatePreparation.lean:1472` |
| theorem | `fixedDenomCubicUncomputeStep_after_compute` | `QuantumBlockEncoding/CubicStatePreparation.lean:1481` |
| def | `fixedDenomExpandedArithmeticCleanUncomputeWitness` | `QuantumBlockEncoding/CubicStatePreparation.lean:1501` |
| theorem | `fixedDenomWorkspaceCleanUncomputedTransparent` | `QuantumBlockEncoding/CubicStatePreparation.lean:1520` |
| def | `expandedAmplitudeOracleCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:1539` |
| theorem | `expandedAmplitudeOracleCleanBlockContract_diagonal` | `QuantumBlockEncoding/CubicStatePreparation.lean:1548` |
| theorem | `expandedAmplitudeOracleCleanBlockContract_eq_target` | `QuantumBlockEncoding/CubicStatePreparation.lean:1555` |
| def | `expandedAmplitudeOracleSemanticContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:1567` |
| theorem | `expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target` | `QuantumBlockEncoding/CubicStatePreparation.lean:1572` |
| def | `primitiveAmplitudeOracleCandidate` | `QuantumBlockEncoding/CubicStatePreparation.lean:1584` |
| theorem | `primitiveAmplitudeOracleCandidate_costTuple_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:1601` |
| theorem | `primitiveAmplitudeOracleCandidate_unitary_from_contract` | `QuantumBlockEncoding/CubicStatePreparation.lean:1612` |
| theorem | `primitiveAmplitudeOracleCandidate_block_from_contract` | `QuantumBlockEncoding/CubicStatePreparation.lean:1618` |
| def | `primitiveAmplitudeOracleVerified` | `QuantumBlockEncoding/CubicStatePreparation.lean:1632` |
| def | `amplitudeOracleClaim` | `QuantumBlockEncoding/CubicStatePreparation.lean:1640` |
| structure | `RegisterLayout` | `QuantumBlockEncoding/BlockEncoding.lean:14` |
| structure | `BlockEncodingSpec` | `QuantumBlockEncoding/BlockEncoding.lean:33` |
| structure | `BlockEncodingCost` | `QuantumBlockEncoding/BlockEncoding.lean:50` |
| def | `fromLayoutAndResource` | `QuantumBlockEncoding/BlockEncoding.lean:59` |
| structure | `QueryOperatorTarget` | `QuantumBlockEncoding/BlockEncoding.lean:90` |
| structure | `OperatorBlockEncodingCandidate` | `QuantumBlockEncoding/BlockEncoding.lean:103` |
| structure | `VerifiedOperatorBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:131` |
| structure | `ApproximateOperatorBlockEncodingCandidate` | `QuantumBlockEncoding/BlockEncoding.lean:148` |
| structure | `VerifiedApproximateOperatorBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:159` |
| structure | `AdaptiveBlockEncodingPolicy` | `QuantumBlockEncoding/BlockEncoding.lean:195` |
| inductive | `BlockEncodingSearchPhase` | `QuantumBlockEncoding/BlockEncoding.lean:207` |
| structure | `VerifiedBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:220` |
| abbrev | `Matrix` | `QuantumBlockEncoding/Core.lean:15` |
| def | `gridSize` | `QuantumBlockEncoding/Core.lean:44` |
| abbrev | `Circuit` | `QuantumBlockEncoding/Circuit.lean:23` |
| abbrev | `CircuitLayer` | `QuantumBlockEncoding/Circuit.lean:50` |
| abbrev | `LayeredCircuit` | `QuantumBlockEncoding/Circuit.lean:60` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-OP-CUBIC-DIAGONAL-CLEAN-001.md` | task/proof map |

## Latest Dialogue Signal

````text
## 20260620-171545-QBE-OP-CUBIC-DIAGONAL-CLEAN-001-cycle01

# Dialogue: QBE-OP-CUBIC-DIAGONAL-CLEAN-001 cycle 1

Append short role-tagged handoffs here.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts inner-cycle progress only through `python3 tools/qbe.py check`
  and synchronized Lean-to-natural-language proof status.  LaTeX exports are
  checked at 6h/convergence closeout.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.
