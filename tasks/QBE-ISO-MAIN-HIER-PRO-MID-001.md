# Isolated main case transfer-operator block encoding, Pro-mid Hierarchical Harness

Task id: `QBE-ISO-MAIN-HIER-PRO-MID-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-28`

## Goal

Run the same main transfer-operator benchmark as the cold arm, but inject an
external Pro construction packet after one ordinary cycle as an official
human/Pro upper-layer input.  The target is

```text
E_k = |0><k|_T ⊗ |0><1|_tau ⊗ I_S
```

for benchmark instance `r = 1`, `k = 1`, and one passive qubit in `S`.
Construct a unitary `U_E` and prove

```text
(<0^a| ⊗ I) U_E (|0^a> ⊗ I) = E_k
```

with normalizer `alpha = 1`.

## Isolation Rule

This task is a fresh Pro-mid reproducibility arm.  Agents may use the current
compiled ABEIS library, Mathlib, and the block-encoding textbook memory/skill
cards, but must not use previous main-case task ids, previous candidate names,
previous proof scripts, previous run summaries, or previous Qiskit exports as
shortcuts.  The Pro packet is an input event, not a theorem.

## Pro Intervention Protocol

After the first ordinary cycle, inject:

```text
task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md
```

The packet proposes the four-gate transcript

```text
CCX012; CX21; CX20; X2
```

for bit order `bit 0 = tau`, `bit 1 = T`, `bit 2 = a`.  Upper/middle may use
it as a candidate-family seed only after translating it into this task's own
Lean proof leaves and reviewer-checkable resource claims.

## Harness Policy

Use the Hierarchical Harness.  Upper/middle/reviewer should compare the Pro
packet against the partial-permutation, entrywise clean-block, and passive
identity-lift memory cards.  Only Lean-certified candidates may be plotted as
achieved solutions or used as certified parents.

After exact convergence, enter the approximate phase with the exact champion as
the `epsilon = 0` incumbent.

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

