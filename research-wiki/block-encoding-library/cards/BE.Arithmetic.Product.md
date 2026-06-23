# BE.Arithmetic.Product

Priority: P0

Source: standard block-encoding product arithmetic, commonly cited through
Gilyen--Su--Low--Wiebe.

## Detect When

The target factors:

$$
C = AB.
$$

## Construction

If $U_A$ block-encodes $A/\alpha$ with $a$ auxiliary qubits and $U_B$
block-encodes $B/\beta$ with $b$ auxiliary qubits, embed them on disjoint
auxiliary registers and compose:

$$
U_C = (I_b \otimes U_A)(I_a \otimes U_B).
$$

The clean block encodes $AB/(\alpha\beta)$.

## Lean Proof Shape

```lean
theorem blockEncoding_product_exact :
  IsBlockEncodingExact alpha a UA A ->
  IsBlockEncodingExact beta b UB B ->
  IsBlockEncodingExact (alpha * beta) (a + b) (embedA UA * embedB UB) (A * B)
```

Approximate version should carry the error term explicitly rather than hiding
it in prose.

Compiled Lean declarations:

- `BlockEncodingClassics.matrix_mul_congr_pointwise`
- `BlockEncodingClassics.productCleanBlockCertificate`
- `BlockEncodingClassics.productResourceCost`

## Proof-DAG Leaves

- clean-index decomposition for combined auxiliary registers;
- matrix multiplication entry expansion;
- substitution of each clean-block theorem;
- normalizer multiplication;
- approximate error bound if needed.

## Resource Notes

Gate counts add.  Depth can be parallelized only when the two embedded circuits
act on disjoint registers and the target operator is tensor/parallel, not
ordinary product.
