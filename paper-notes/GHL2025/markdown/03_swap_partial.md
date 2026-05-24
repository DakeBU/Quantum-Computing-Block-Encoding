# SWAP Partial Proof Blocks

Paper anchor: GHL2025 one-term Robin circuit SWAP between the system register
and the $O_D^{BS}$ address register.

Lean declarations:

- `swapOracleImage`
- `swapOracleMatrix`
- `swapOracleDiff_lt_two_pow`
- `swapOracleDiff_shiftRight_eq_zero`
- `swapOracleDiff_shiftLeft_mask_eq_zero`
- `swapOracleImage_block1_eq_block2`
- `swapOracleImage_block2_eq_block1`
- `swapOracleImage_lt_qubitDim`
- `swapOracleDiff`
- `swapOracleImage_eq_xor_diff`
- `swapOracleDiff_preserved`
- `xor_two_shifted_masks_cancel`
- `swapOracleImage_self_inverse`

## Definitions

Let

$$
\operatorname{mask}=2^n-1.
$$

For a basis index $j$, define

$$
b_1(j)= (j\gg 1)\mathbin{\&}\operatorname{mask},
\qquad
b_2(j)= (j\gg(1+n))\mathbin{\&}\operatorname{mask}.
$$

Let

$$
d(j)=b_1(j)\oplus b_2(j).
$$

The SWAP image function is

$$
S(j)=j\oplus(d(j)\ll 1)\oplus(d(j)\ll(1+n)).
$$

## Proved Blocks

Both $b_1(j)$ and $b_2(j)$ are $n$-bit values.  Lean proves that their XOR is
also $n$-bit:

$$
d(j)<2^n.
$$

This is `swapOracleDiff_lt_two_pow`.

It follows that

$$
d(j)\gg n=0,
$$

proved by `swapOracleDiff_shiftRight_eq_zero`, and

$$
(d(j)\ll n)\mathbin{\&}(2^n-1)=0,
$$

proved by `swapOracleDiff_shiftLeft_mask_eq_zero`.

Using these bit facts, Lean proves the first SWAP block identity:

$$
b_1(S(j))=b_2(j).
$$

This is `swapOracleImage_block1_eq_block2`.

Lean also proves the symmetric block identity:

$$
b_2(S(j))=b_1(j).
$$

This is `swapOracleImage_block2_eq_block1`.

The finite-range lemma
`swapOracleImage_lt_qubitDim` proves that the SWAP image stays inside the same
full basis whenever the input index is inside the full basis.  This is a range
block only; it is not a bijection proof.

Lean then names the block difference as `swapOracleDiff`, proves that
`swapOracleImage` is exactly XOR by that difference in the two register
positions, and proves that the difference is preserved by one SWAP application:

$$
d(S(j))=d(j).
$$

This is `swapOracleDiff_preserved`.  The local Boolean cancellation lemma
`xor_two_shifted_masks_cancel` proves that applying the two shifted masks twice
returns the original basis index.  Together these give the self-inverse theorem

$$
S(S(j))=j
$$

as `swapOracleImage_self_inverse`.

## Finite Permutation Bridge

Lean now packages `swapOracleImage` as a map on
`Fin (qubitDim (oneTermRobinTotalQubits p))`, derives injectivity and
surjectivity from `swapOracleImage_self_inverse` and
`swapOracleImage_lt_qubitDim`, and proves the row and column uniqueness lemmas
for `swapOracleMatrix`.  The gate-level field
`(GHL2025.oneTermRobinGate_SWAP p).unitary.proved` is `true`, backed by
`GHL2025.swapOracleMatrix_is_permutation`.
