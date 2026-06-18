# QBE-OP-OPTCTRL-001 Multi-Agent Convergence Run Summary

Generated: 2026-06-18 20:23:41

This is the formal convergence-run summary.  The live chat acted as the human
interaction top module; role-separated upper, middle, lower, and reviewer
handoffs are recorded in `dialogue.md`.  The default Chinese human entry is
`zh_summary.md`.

## Target Operator

```text
E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state
```

The task is not to assume an oracle exists.  The task is to construct a
specific unitary/circuit whose clean block is exactly `E_1`, and to have Lean
verify that statement.

## Convergence Plot

Only Lean-certified candidates are plotted as achieved constructions.  Python
searches, simulator traces, and ChatGPT Pro ideas stay in the insight pool
until Lean promotes them.

![E_1 block-encoding certified evolution](../../../docs/assets/optctrl_evolution.png)

## Lean-Verified Block-Encoding Circuits By Generation

These diagrams use the community-standard wire/control notation for quantum
circuits.  Only candidates with Lean certificates are shown as achieved
block-encoding constructions.

### Generation 0: oracle-level seed

![Oracle-level seed](../../../docs/assets/optctrl_oracle_baseline.png)

- Lean certificate: `OptimalControl.exampleVerified`
- Resource tuple: `(gateCount, depth, auxiliaryQubits, oracleCalls) = (1, 1, 1, 1)`
- Meaning: a correct one-ancilla seed, still containing one opaque
  permutation-completion oracle.

### Generation 2: depth-5 logical completion

![Depth-5 logical completion](../../../docs/assets/optctrl_depth5.png)

- Lean certificate: `OptimalControl.reducedDepth5Verified`
- Lean anchors: `reducedDepth5Unitary_isRationalOrthogonal`,
  `reducedDepth5Unitary_cleanBlock`, `reducedDepth5GateImages_eval`
- Resource tuple: `(6, 5, 1, 0)`
- Meaning: the first correct construction fully expanded in the logical
  `{X,CNOT,Toffoli}` gate library.

### Generation 6: ChatGPT Pro equality-transfer candidate

![Equality-transfer candidate](../../../docs/assets/optctrl_pro.png)

- Lean certificate: `OptimalControl.proEqTransferVerified`
- Lean anchors: `proEqTransferUnitary_isRationalOrthogonal`,
  `proEqTransferUnitary_cleanBlock`, `proEqTransferGateImages_eval`
- Resource tuple: `(4, 4, 1, 0)`
- Meaning: the Pro idea became a certified parent only after Lean proved it.
  It exposed the branch-selection invariant.

### Generation 7: evolved equality-flag plus parallel-flips champion

![Evolved champion](../../../docs/assets/optctrl_evolved.png)

- Lean certificate: `OptimalControl.evolvedEqFlipVerified`
- Lean anchors: `evolvedEqFlipUnitary_isRationalOrthogonal`,
  `evolvedEqFlipUnitary_cleanBlock`, `evolvedEqFlipGateImages_eval`,
  `evolvedEqFlipCandidate_cost`
- Resource tuple: `(4, 2, 1, 0)`
- Circuit:

```text
CCX(type,time -> auxiliary)
then parallel X_type, X_time, X_auxiliary
```

This is the current champion at the concrete logical `{X,CNOT,Toffoli}` tier.

## Why This Run Converged

The lower necessary-condition verifier exhaustively enumerated the reduced
three-bit logical `{X,CNOT,Toffoli}` orientation library:

- no correct clean-block candidate exists with at most 3 gates;
- correct 4-gate candidates exist;
- no depth-1 layered candidate exists with at most 4 gates;
- the depth-2 witness is exactly the current Lean-certified champion.

This is convergence evidence for the concrete `r = 1, k = 1` logical library.
It is not a Lean-formalized lower-bound theorem.

## Scope

This is not a hardware-optimality theorem, not a theorem for arbitrary `k` or
arbitrary time-register width, and not a Lean-formalized lower-bound theorem.
The next tasks are generalization, hardware decomposition, and optional Lean
formalization of the finite lower-bound search.
