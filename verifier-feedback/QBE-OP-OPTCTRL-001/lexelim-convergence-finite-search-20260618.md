# Verifier Feedback: QBE-OP-OPTCTRL-001 LexElim Convergence Run

Date: 2026-06-18

Leaf: `evolved-eq-flip-r1-k1` convergence audit

Error class: none for current champion; this is a finite exact search
diagnostic for possible improvements.

## Target

Reduced active-register target for

```text
E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state
```

with bit order:

```text
bit 0 = type, bit 1 = time, bit 2 = block-encoding auxiliary
```

Clean-block predicate:

```text
f(3) = 0
f(0), f(1), f(2) ∈ {4,5,6,7}
```

The gates are reversible permutations, so any transcript satisfying this
predicate is a valid reduced clean-block completion candidate before lifting
the passive state bit.

## Gate Library Enumerated

```text
X0, X1, X2,
CX01, CX02, CX10, CX12, CX20, CX21,
CCX120, CCX021, CCX012
```

This is the full three-bit `{X,CNOT,Toffoli}` orientation library at the
logical reversible tier.

## Results

| Query | Result |
|---|---|
| Clean-block candidate with at most 3 gates | none |
| Clean-block candidate with exactly 4 gates | 36 ordered transcripts |
| Depth-1 layered candidate with at most 4 gates | none |
| Depth-2 layered candidate with at most 4 gates | `CCX012` then parallel `{X0,X1,X2}` |

## Interpretation

This is an exact finite necessary-condition verifier for the stated logical
library.  It does not replace Lean theorem closure, but it is strong enough
for scheduling:

- no gate-count improvement below 4 exists in this reduced library;
- no depth-1 improvement exists among candidates with at most 4 gates;
- the current Lean-certified champion matches the depth-2 witness found by
  exhaustive layered search.

The result should be treated as a convergence signal for the concrete
`r = 1, k = 1` logical-library case.  A later cycle may formalize this finite
lower bound in Lean if the paper needs a theorem rather than a verifier note.
