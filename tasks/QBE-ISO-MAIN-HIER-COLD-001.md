# Isolated main case transfer-operator block encoding, cold Hierarchical Harness

Task id: `QBE-ISO-MAIN-HIER-COLD-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-28`

## Goal

Cold-start the main transfer-operator benchmark under the current ABEIS
Hierarchical Harness.  The target operator is

```text
E_k = |0><k|_T ⊗ |0><1|_tau ⊗ I_S
```

with benchmark instance `r = 1`, `k = 1`, and one passive qubit in `S`.
Construct a unitary `U_E` and prove the exact clean-block contract

```text
(<0^a| ⊗ I) U_E (|0^a> ⊗ I) = E_k
```

with normalizer `alpha = 1`.

## Isolation Rule

This task is a fresh reproducibility arm.  Agents may use the current compiled
ABEIS library, Mathlib, and the block-encoding textbook memory/skill cards, but
must not use previous main-case task ids, previous candidate names, previous
Pro answers, previous task-specific proof scripts, previous run summaries, or
previous Qiskit exports as shortcuts.  If the same construction is rediscovered,
it must be stated, proved, scored, and exported under this task's own names.

## Harness Policy

Use the Hierarchical Harness.  Upper and middle should spend enough effort on
semantic route selection, proof-DAG organization, and insight-pool maintenance
before lower workers implement a leaf.  The expected first inspiration is the
partial-permutation / clean-block entrywise route, but it is inspiration only,
not a forced recipe.

If exact search stagnates, upper/reviewer may increase upper, middle, or lower
capacity according to the adaptive policy.  After exact convergence, enter the
approximate phase with the exact champion as the `epsilon = 0` incumbent.

## Candidate Score

First compare asymptotic tier.  Inside one tier, compare Lean-certified
candidates lexicographically by:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

## Required Closeout Artifacts

- Lean block-entry and unitarity certificate.
- Resource tuple and candidate comparison.
- Qiskit and QASM3 exports after Lean certification.
- Circuit storyboard and evolution curve plotting only Lean-certified
  candidates.
- Selected-language summary and ChatGPT Pro prompt if unresolved.

## Initial Proof Obligations

- [ ] Matrix/operator target `E_k` is defined for this isolated task.
- [ ] Candidate unitary/circuit schema is defined under this task's own names.
- [ ] Block-entry contract is stated with the exact ancilla projector.
- [ ] Unitarity is proved or recorded as an explicit obligation.
- [ ] Normalizer `alpha = 1` is explicit.
- [ ] Auxiliary qubit count `a` is explicit.
- [ ] Resource score `(gateCount, depth, a, oracleCalls)` is explicit.
- [ ] `lake build && lake build Tests` succeeds.
- [ ] Post-Lean Qiskit/QASM3 export passes its deterministic checker.

