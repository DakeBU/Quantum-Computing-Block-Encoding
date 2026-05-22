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

## Not Proved Yet

The symmetric block identity

$$
b_2(S(j))=b_1(j)
$$

is not yet proved.  Therefore the full SWAP self-inverse theorem,
bijection/permutation theorem, and gate unitarity remain obligations.
