# Main case transfer-operator block encoding, Pro-assisted isolated Game Harness

Task id: `QBE-MAIN-CASE-GAME-PRO-001`
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
qubit in `S`.  The exact clean-block contract is

```text
(<0^a| ⊗ I) U_E (|0^a> ⊗ I) = E_k
```

with normalizer `alpha = 1`.

## Harness Profile

Use the Game Harness.  The Lean Hierarchical Team and Natural-Language
Hierarchical Team compete on constructions and proof routes, while the Game
Council transfers useful insight between teams and asks the reviewer to reject
incorrect, stale, or overfitted routes.  Only Lean-certified candidates may be
plotted as achieved solutions.

## Pro Intervention Protocol

This is the Pro-assisted arm.  Start from the same initial Game Harness setup
as the no-Pro arm, then inject the external Pro construction packet as an
official upper-level input event after the first ordinary cycle.  The packet is
located at:

```text
task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md
```

The packet proposes the four-gate transcript

```text
CCX012; CX21; CX20; X2
```

for bit order `bit 0 = tau`, `bit 1 = T`, `bit 2 = a`.  This packet is an
extra input, not a theorem.  The Game Council may use it only after translating
it into this task's own Lean proof leaves and executable exports.

## Candidate Score

First compare asymptotic tier.  Inside one tier, compare certified candidates
lexicographically by:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

## Required Closeout Artifacts

- Lean theorem naming the block-entry and unitarity certificate.
- Resource tuple and candidate comparison.
- Qiskit and QASM3 exports after Lean certification.
- Circuit storyboard and evolution curve plotting only Lean-certified
  candidates.
- Selected-language summary and ChatGPT Pro prompt if not fully closed.

