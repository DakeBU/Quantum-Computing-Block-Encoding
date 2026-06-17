# QBE-OP-OPTCTRL-001 Pro Construction Verification

## Scope

This report independently checks the proposed ChatGPT Pro reduced-register
sequence for the concrete `r = 1`, `k = 1`, one-state-bit target.  I used the
bit order implied by the current Lean code:

```text
full index = 2 * reduced index + state
reduced bit 0 = type
reduced bit 1 = time
reduced bit 2 = aux
```

The target reduced permutation is the Lean `reducedTargetImage`, written as
outputs on inputs `0..7`:

```text
[7, 5, 6, 0, 3, 1, 2, 4]
```

## Proposed Pro Sequence

The named sequence

```text
CCX(type,time -> aux)
CNOT(aux -> time)
CNOT(aux -> type)
X(aux)
```

therefore translates to reduced-bit gates

```text
CCX(0,1;2); CX(2,1); CX(2,0); X(2)
```

under the current Lean bit order.

Its computed image is:

```text
[4, 5, 6, 0, 3, 2, 1, 7]
```

This does not match the target:

```text
target = [7, 5, 6, 0, 3, 1, 2, 4]
```

Pointwise trace:

| input | after CCX(0,1;2) | after CX(2,1) | after CX(2,0) | after X(2) | target |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 0 | 0 | 0 | 4 | 7 |
| 1 | 1 | 1 | 1 | 5 | 5 |
| 2 | 2 | 2 | 2 | 6 | 6 |
| 3 | 7 | 5 | 4 | 0 | 0 |
| 4 | 4 | 6 | 7 | 3 | 3 |
| 5 | 5 | 7 | 6 | 2 | 1 |
| 6 | 6 | 4 | 5 | 1 | 2 |
| 7 | 3 | 3 | 3 | 7 | 4 |

So the proposed four-gate construction is not a valid realization of
`reducedTargetImage`.

Important distinction: this rejects the sequence only as an implementation of
the fixed permutation completion `reducedTargetImage` / `exampleImage`.  It may
still satisfy the concrete clean-block partial-isometry contract as a different
unitary completion, because the clean block constrains only selected matrix
entries while leaving many completion entries free.

## Bit-Order and Composition Checks

I also tested whether the mismatch is caused by a simple convention error:

- all six assignments of the labels `{type,time,aux}` to reduced bit positions;
- forward circuit application order;
- reverse circuit application order.

None of these variants of the same four named gates realizes
`[7, 5, 6, 0, 3, 1, 2, 4]`.  I therefore do not see a bit-order correction that
rescues this Pro sequence as stated.

## Depth of the Pro Sequence

Although the sequence is incorrect, its depth would be:

- disjoint-qubit layer model: depth `4`;
- relaxed shared-control broadcast model: depth `3`, with
  `{CX(2,1), CX(2,0)}` in one broadcast layer.

These depths are only resource counts for the wrong permutation.

## Comparison With Current Champion

The current Lean champion is still valid:

```text
CCX(0,1;2); CX(0,1); CX(1,0); X(0); X(2); CX(0,1)
```

with the disjoint-qubit schedule

```text
1. CCX(0,1;2)
2. CX(0,1)
3. CX(1,0)
4. X(0)
5. {X(2), CX(0,1)}
```

Its image is exactly:

```text
[7, 5, 6, 0, 3, 1, 2, 4]
```

Under the standard disjoint-qubit layer model this remains a depth-5,
six-gate realization.

## Relaxed Broadcast Model Side Check

I enumerated layers again under a relaxed model that allows gates to share a
control qubit in one layer, provided no target is shared and no target is used
as another simultaneous gate's control.  This adds the broadcast CNOT layers

```text
{CX(0,1), CX(0,2)}
{CX(1,0), CX(1,2)}
{CX(2,0), CX(2,1)}
```

to the standard disjoint layer set.

Exhaustive endpoint counts by exact depth:

| model | unique nonempty layers | depth 0 | depth 1 | depth 2 | depth 3 | depth 4 | first target depth |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| disjoint qubits | 22 | 1 | 22 | 245 | 1,736 | 8,614 | 5 |
| shared-control broadcast | 25 | 1 | 25 | 305 | 2,228 | 11,031 | 5 |

Thus even with shared-control broadcast layers, I found no depth `< 5`
realization in the `{X,CNOT,Toffoli}` three-bit library.

The relaxed model does have a different depth-5 witness:

```text
1. CX(0,1)
2. X(0)
3. CCX(0,1;2)
4. CX(1,0)
5. {CX(0,1), CX(0,2)}
```

Sequentially:

```text
CX(0,1); X(0); CCX(0,1;2); CX(1,0); CX(0,1); CX(0,2)
```

Its image is the target:

```text
[7, 5, 6, 0, 3, 1, 2, 4]
```

This is not a disjoint-qubit schedule, because the last two CNOTs share control
bit `0`.  It should only be treated as an improvement candidate if the project
accepts shared-control broadcast as a legal one-layer operation.

## Verdict

The Pro four-gate sequence is rejected for the current Lean bit order: it
realizes `[4, 5, 6, 0, 3, 2, 1, 7]`, not the target
`[7, 5, 6, 0, 3, 1, 2, 4]`.

The current depth-5 champion remains the valid standard disjoint-qubit
candidate for the fixed target permutation.  A relaxed shared-control broadcast
model does not reduce target-permutation depth below `5`, but it exposes a
separate depth-5, five-gate witness under that model.

## Controller Update After Lean Integration

The rejection above is only a rejection as an implementation of the old fixed
completion `exampleImage`.  After reviewer feedback, the controller switched
the acceptance predicate to the actual block-encoding contract: clean block
equals `E_1`.

Under that correct predicate, the Pro sequence is accepted in Lean as a
different unitary completion:

- `OptimalControl.proEqTransfer_cleanBlock`
- `OptimalControl.proEqTransferFull_isPermutation`
- `OptimalControl.proEqTransferCost_betterThan_depth5`

The Pro candidate then seeded an EoH-style mutation:

```text
CCX(0,1;2); { X(0), X(1), X(2) }
```

Lean accepts the mutated depth-2 candidate by:

- `OptimalControl.evolvedEqFlip_cleanBlock`
- `OptimalControl.evolvedEqFlipFull_isPermutation`
- `OptimalControl.evolvedEqFlipCost_betterThan_pro`
- `OptimalControl.evolvedEqFlipCost_betterThan_depth5`

This is the current finite logical champion for the concrete clean-block task.
