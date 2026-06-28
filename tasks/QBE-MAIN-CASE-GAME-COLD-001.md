# Main case transfer-operator block encoding, no-Pro isolated Game Harness

Task id: `QBE-MAIN-CASE-GAME-COLD-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-28`

## Goal

Construct and Lean-certify a block encoding of

```text
E_k = |0><k|_T ⊗ |0><1|_tau ⊗ I_S
```

for the reproducible benchmark instance `r = 1`, `k = 1`, and one passive
qubit in `S`.  The block contract is

```text
(<0^a| ⊗ I) U_E (|0^a> ⊗ I) = E_k
```

with exact normalizer `alpha = 1`.

## Harness Profile

Use the Game Harness.  The Lean Hierarchical Team searches for Lean-first
constructions and proofs.  The Natural-Language Hierarchical Team searches for
mathematical constructions and proof sketches.  The Game Council compares both
teams, transfers useful insight between them, and sends only reviewer-approved
work packets to Lean implementation.  Candidate populations are ranked only
after Lean certification.

This is the no-Pro arm.  Agents may use the compiled ABEIS library, Mathlib,
and the block-encoding memory cards, but they must not use previous main-case
candidate names, previous Pro packets, previous task-specific proof scripts, or
previous Qiskit exports as a shortcut.

## Textbook-Memory Guidance

The target is a matrix-unit tensor identity, so upper agents should treat
partial-permutation completion, clean-block entrywise verification, and passive
identity lifting as the first inspiration cards.  LCU, sparse access, and QSVT
are allowed as comparison ideas but should not be the first active proof route
unless the partial-permutation route is mathematically blocked.

## Candidate Score

First compare asymptotic tier.  Inside one tier, compare certified candidates
lexicographically by:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Fewer gates wins before shallower depth; depth breaks gate-count ties.

## Required Closeout Artifacts

- Lean theorem naming the block-entry and unitarity certificate.
- Resource tuple and candidate comparison.
- Qiskit and QASM3 exports after Lean certification.
- Circuit storyboard and evolution curve plotting only Lean-certified
  candidates.
- Selected-language summary and ChatGPT Pro prompt if not fully closed.

