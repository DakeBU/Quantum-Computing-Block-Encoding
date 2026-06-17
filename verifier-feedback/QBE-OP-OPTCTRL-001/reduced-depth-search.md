# QBE-OP-OPTCTRL-001 Reduced Depth Search

## Target permutation

Source context read from `QuantumBlockEncoding/OptimalControl.lean`:
`OptimalControl.reducedTargetImage : Fin 8 -> Fin 8`.

The reduced three-bit target permutation, written as output image for inputs
`0..7`, is:

```text
[7, 5, 6, 0, 3, 1, 2, 4]
```

Equivalently:

| input | output |
| ---: | ---: |
| 0 | 7 |
| 1 | 5 |
| 2 | 6 |
| 3 | 0 |
| 4 | 3 |
| 5 | 1 |
| 6 | 2 |
| 7 | 4 |

Bit numbering follows the Lean reduced gates: bit 0 is the low bit of the
integer representative.

## Gate library and layer model

Searched logical reversible gates:

- `X(i)` for `i in {0,1,2}`.
- `CX(c,t)` for ordered distinct bit pairs `c != t`.
- `CCX(a,b;t)` for ordered controls and distinct target, with
  `{a,b,t} = {0,1,2}`.

Layer rule: gates in the same depth layer must have disjoint qubit supports.
On three bits this means:

- any nonempty subset of parallel `X` gates;
- one `CX(c,t)`, optionally with one `X` on the unused bit;
- one `CCX(a,b;t)` alone.

The raw library has 15 named gates: 3 `X`, 6 `CX`, and 6 ordered-control
`CCX` names. The two control orders of a Toffoli have identical semantics, so
the search deduplicated identical layer permutations after constructing layers
from the raw ordered library. This gives 25 raw layers and 22 unique layer
permutations. Deduplication changes only counting, not reachability.

## Exhaustive search performed

I exhaustively enumerated all sequences of nonempty unique layer permutations
through depth 5. Composition was checked as a function on all eight basis
states. Depths below 5 were searched exactly:

| exact depth | layer sequences expanded | unique endpoint permutations | target reached |
| ---: | ---: | ---: | :---: |
| 0 | 1 | 1 | no |
| 1 | 22 | 22 | no |
| 2 | 484 | 245 | no |
| 3 | 5,390 | 1,736 | no |
| 4 | 38,192 | 8,614 | no |
| 5 | 189,508 | 27,406 | yes |

Therefore no circuit of depth `< 5` exists under this layer model and gate
library.

## Best circuit found

The current Lean champion was independently verified:

```text
1. CCX(0,1;2)
2. CX(0,1)
3. CX(1,0)
4. X(0)
5. { X(2), CX(0,1) }
```

The final layer gates are disjoint, so their order is immaterial.

Cost:

- Depth: 5
- Gate count: 6
- Gate mix: 2 `X`, 3 `CX`, 1 `CCX`

Image of this circuit:

```text
[7, 5, 6, 0, 3, 1, 2, 4]
```

This matches the target permutation exactly.

As an additional check, exhaustive depth-5 enumeration found no target witness
with fewer than 6 gates. The first target witness encountered by endpoint
enumeration had 7 gates, but a gate-count pass over depth-5 witnesses recovered
the 6-gate champion above.

## Verdict

This supports the current depth-5 champion. The search refutes any depth `< 5`
implementation in the specified three-bit logical reversible library with
parallel layers restricted to disjoint-qubit gates. Within the searched
depth-5 space, the existing 6-gate champion is also gate-count minimal.
