# Robin boundary block encoding, isolated cold start

Task id: `QBE-ROBIN-BE-COLD-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-08-12`
Evaluation mode: `isolated-abeis`
Population gate: `required`
Tolerance ladder: `0`, `1e-10`, `1e-9`, `1e-8`, `1e-7`, `1e-6`
Lean acceptance anchors: `RobinEvolution.coldRobinExactVerified`
Executable acceptance command: `python3 tools/export_robin_evolution.py --task QBE-ROBIN-BE-COLD-001 --arm cold`

## Isolation rule

This arm receives the mathematical target below, the generic ASPBE contract
types, Mathlib, and generic state-preparation/block-encoding memory cards.  It
does not receive the source paper's circuit, previous Robin attempts, warm-arm
population data, or declarations from `GHL2025.lean`, `RobinHeat.lean`, or
`RobinMatrix.lean`.  An agent that retrieves or cites those files contaminates
the arm; the run must be rejected and restarted.

## Fixed benchmark

Let `N = 8`.  The target `A_R : Matrix (Fin 8) (Fin 8) Rat` is the fourth-order
second-derivative stencil with homogeneous Robin parameters in this finite
instance.  Its nonzero rows are

```text
row 0: A[0,0] = -5/2,  A[0,1] = 8/3,  A[0,2] = -1/6
row 1: A[1,0] = 4/3,   A[1,1] = -31/12,
       A[1,2] = 4/3,   A[1,3] = -1/12
rows 2..5: A[i,i-2] = -1/12, A[i,i-1] = 4/3,
           A[i,i] = -5/2, A[i,i+1] = 4/3, A[i,i+2] = -1/12
row 6: A[6,4] = -1/12, A[6,5] = 4/3,
       A[6,6] = -31/12, A[6,7] = 4/3
row 7: A[7,5] = -1/6, A[7,6] = 8/3, A[7,7] = -5/2
```

Every unspecified entry is zero.  Use normalizer `alpha = 56/3`, clean signal
index zero, and exact error `epsilon = 0`.  A candidate `U` is accepted only if
Lean proves unitarity at the declared semantic tier and

```text
(<0^a| tensor I_8) U (|0^a> tensor I_8) = A_R / (56/3)
```

pointwise.  Register order and the embedding map must be explicit.

## Search and score

Maintain independent candidate families and mutation provenance.  Compare
asymptotic/semantic tier first.  Inside one tier, compare certified candidates
lexicographically by

```text
(gateCount, depth, auxiliaryQubits, oracleCalls).
```

An unresolved matrix-table or oracle call is not an elementary gate and cannot
be ranked against an expanded circuit.  Exact search comes first.  Approximate
search may open only after a signed reviewer decision and must preserve the
target, projector, register order, and normalizer while recording epsilon.

## Completion gate

Completion requires the named Lean anchor, `lake build`, `lake build Tests`, a
Qiskit `Operator` check of unitarity and the clean block, an export manifest,
candidate metrics with provenance, and an isolation audit showing no forbidden
Robin source was used.
