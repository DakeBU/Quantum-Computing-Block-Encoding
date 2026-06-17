# QBE-OP-OPTCTRL-001 Evolved Clean-Block Search

## Scope

This verifier packet uses the same concrete target as `OptimalControl.lean`:

```text
E_1 = |0><1|_time \otimes |0><1|_type \otimes I_state
```

with one time bit, one type bit, one passive state bit, and one
block-encoding auxiliary bit.

The active reduced bit order is:

```text
bit 0 = type
bit 1 = time
bit 2 = auxiliary
```

The old depth-5 search targeted one fixed permutation completion
`exampleImage`.  This search uses the actual block-encoding acceptance
condition instead:

```text
clean input 3 = |aux=0,type=1,time=1> must map to clean output 0,
clean inputs 0,1,2 must map outside the clean block.
```

The passive state bit is ignored by the reduced search and later lifted by
the Lean definition `liftReducedImage`.

## Gate Library

Logical reversible gate library:

- `X(i)` for `i in {0,1,2}`;
- `CX(c,t)` for distinct `c,t`;
- `CCX(a,b;t)` for Toffoli with two controls and one target.

Layer rule: gates in the same layer must have disjoint qubit support.

## Search Result

Exhaustive layer search found the first clean-block solution at depth `2`.
The best depth-2 solution by gate count is:

```text
Layer 1: CCX(0,1;2)
Layer 2: { X(0), X(1), X(2) }
```

Sequential representative:

```text
CCX012; X0; X1; X2
```

Permutation on reduced inputs `0..7`:

```text
[7, 6, 5, 0, 3, 2, 1, 4]
```

Clean-block check:

| clean input | image | clean-block meaning |
| ---: | ---: | --- |
| 0 | 7 | outside clean block, contributes zero |
| 1 | 6 | outside clean block, contributes zero |
| 2 | 5 | outside clean block, contributes zero |
| 3 | 0 | selected branch maps to target output |

Thus the clean block equals `|0><1|_time \otimes |0><1|_type` on the active
register and tensored with identity on the passive state bit.

## Lean Certificates

The current Lean file records this candidate as:

- `OptimalControl.evolvedEqFlipImage`
- `OptimalControl.evolvedEqFlipImage_isPermutation`
- `OptimalControl.evolvedEqFlipFull_isPermutation`
- `OptimalControl.evolvedEqFlip_cleanBlock`
- `OptimalControl.evolvedEqFlipCost`
- `OptimalControl.evolvedEqFlipCost_betterThan_pro`
- `OptimalControl.evolvedEqFlipCost_betterThan_depth5`

Score in the logical reversible library:

```text
depth = 2
gateCount = 4
auxiliaryQubits = 1
oracleCalls = 0
```

## Interpretation

This does not contradict the earlier depth-5 lower-bound report.  That report
fixed the entire permutation completion `exampleImage`.  A block encoding has
more freedom: many different unitary completions can have the same clean block.
Once the search target is correctly relaxed to the clean-block condition, the
depth-2 completion is accepted and Lean checks the block equality directly.

The result is still scoped to the concrete `r = 1`, `k = 1`, one-state-bit
instance.  A later family theorem should prove the same idea for arbitrary
state dimension and time-register width.
