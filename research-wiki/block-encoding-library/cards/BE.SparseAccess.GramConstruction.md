# BE.SparseAccess.GramConstruction

Priority: P1

Sources: sparse-access block-encoding theorem in Gilyen--Su--Low--Wiebe and
later explicit sparse-circuit papers.

## Detect When

The target matrix is sparse and the problem provides row/column/value access
oracles, or a paper defines sparse-access and sparse-amplitude oracles.

## Construction

Prepare two states whose inner product equals a scaled matrix entry:

$$
\langle \phi_i | \psi_j \rangle = A_{ij}/\alpha.
$$

A swap/projection construction then has clean block $A/\alpha$.

## Lean Proof Shape

```lean
theorem sparseAccess_cleanBlock :
  (forall i j, inner (phi i) (psi j) = A i j / alpha) ->
  cleanBlock sparseAccessUnitary = (1 / alpha) smul A
```

## Proof-DAG Leaves

- row/column support correctness;
- amplitude correctness;
- orthogonal garbage branch;
- inner-product computation;
- cleanup/uncompute of sparse registers;
- final clean-block bridge.

## Resource Notes

Track sparse index register size, value-oracle calls, state-preparation depth,
and cleanup calls.

## Reviewer Warning

Do not treat an oracle contract as a gate-level construction unless the paper
or Lean file actually proves the reversible implementation.
