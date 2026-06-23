# BE.Density.FromPurification

Priority: P1

Sources: density-operator block encodings and purification/Gram matrix
constructions in the QSVT/block-encoding literature.

## Detect When

The target is a density matrix, Gram matrix, kernel matrix, or partial trace of
a prepared pure state.

## Construction

Prepare a purification

$$
|\Psi\rangle = \sum_i \sqrt{\lambda_i}|i\rangle|v_i\rangle.
$$

Then the reduced density matrix or an equivalent swap construction provides a
block encoding of

$$
\rho = \mathrm{Tr}_{\mathrm{env}}(|\Psi\rangle\langle\Psi|).
$$

## Lean Proof Shape

```lean
theorem density_from_purification_entry :
  reducedDensity preparedState row col =
    sum env, preparedState (row, env) * conj (preparedState (col, env))
```

Use entrywise finite sums first.

## Proof-DAG Leaves

- preparation normalization;
- partial-trace entry theorem;
- clean projection/swap bridge;
- Hermitian and positive semidefinite side facts only if needed.

## Resource Notes

The state-preparation circuit dominates the cost.  Keep density-block
construction separate from the preparation backend.
