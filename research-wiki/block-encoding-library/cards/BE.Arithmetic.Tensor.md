# BE.Arithmetic.Tensor

Priority: P0

Source: tensor-product arithmetic of block encodings.

## Detect When

The target is a tensor product:

$$
C = A \otimes B.
$$

## Construction

Run the two block-encoding unitaries in parallel on disjoint registers:

$$
U_C = U_A \otimes U_B.
$$

Then the clean block is

$$
\mathrm{cleanBlock}(U_A \otimes U_B)
=
\mathrm{cleanBlock}(U_A)\otimes \mathrm{cleanBlock}(U_B).
$$

## Lean Proof Shape

```lean
theorem blockEncoding_tensor_exact :
  IsBlockEncodingExact alpha a UA A ->
  IsBlockEncodingExact beta b UB B ->
  IsBlockEncodingExact (alpha * beta) (a + b) (UA tensor UB) (A tensor B)
```

## Proof-DAG Leaves

- tensor index splitting;
- clean auxiliary split;
- tensor entry theorem;
- normalizer multiplication.

Compiled Lean declarations:

- `BlockEncodingClassics.tensorResourceCost`
- `BlockEncodingClassics.tensorResourceCost_depth`
- `BlockEncodingClassics.tensorResourceCost_gateCount`

## Resource Notes

Gate counts add, but depth is the maximum of the two depths if the schedules
are disjoint and parallel execution is allowed.
