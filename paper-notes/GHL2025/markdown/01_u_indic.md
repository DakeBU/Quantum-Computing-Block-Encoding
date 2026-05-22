# Indicator Oracle Proof

Paper anchor: GHL2025 one-term Robin circuit, bulk indicator oracle
$U_{\mathrm{indic}}$.

Lean declarations:

- `GHL2025.indicatorOracleImage`
- `GHL2025.indicatorOracleMatrix`
- `GHL2025.indicatorOracleImage_systemVal_preserved`
- `GHL2025.indicatorOracleImage_isBulk_preserved`
- `GHL2025.indicatorOracleImage_self_inverse`
- `GHL2025.indicatorOracleImage_bijective`
- `GHL2025.indicatorOracleMatrix_is_permutation`
- `GHL2025.oneTermRobinGate_U_indic`

## Definitions

For parameters $p$, let $n=p.n$ and let

$$
\operatorname{indPos}=1+2n .
$$

For a computational-basis index $j$, define the system register value

$$
\operatorname{sys}(j)=
\left(j \gg 1\right) \mathbin{\&} (2^n-1).
$$

The bulk predicate is

$$
\operatorname{bulk}(j)=
\begin{cases}
1, & 2 \le \operatorname{sys}(j) \le 2^n-3,\\
0, & \text{otherwise}.
\end{cases}
$$

The image function is

$$
I(j)=j\oplus \left(\operatorname{bulk}(j)\ll \operatorname{indPos}\right).
$$

The matrix is the permutation-style matrix

$$
M_{i,j}=
\begin{cases}
1, & i=I(j),\\
0, & i\ne I(j).
\end{cases}
$$

## Theorem

The Lean theorem `indicatorOracleMatrix_is_permutation` proves that every row
and every column of `indicatorOracleMatrix p` contains exactly one entry equal
to `Coeff.rat 1`.

## Proof

The bit $\operatorname{indPos}$ is above the system register bits
$[1,1+n)$, so toggling it does not change the extracted system value:

$$
\operatorname{sys}(I(j))=\operatorname{sys}(j).
$$

This is Lean theorem `indicatorOracleImage_systemVal_preserved`, proved by the
bit lemma `xor_shift_preserve_shift_low`.

Since the bulk predicate depends only on the system value,

$$
\operatorname{bulk}(I(j))=\operatorname{bulk}(j).
$$

This is `indicatorOracleImage_isBulk_preserved`.  Applying the image twice gives

$$
I(I(j))
= j\oplus b\ll\operatorname{indPos}\oplus b\ll\operatorname{indPos}
=j,
$$

where $b=\operatorname{bulk}(j)$.  This is
`indicatorOracleImage_self_inverse`.

A self-inverse map is injective.  On the finite basis domain, it is also
surjective by choosing the preimage $I(y)$ for each $y$.  Lean packages these
two facts as `indicatorOracleImage_bijective`.

The matrix-entry theorem `indicatorOracleMatrix_eq_image` reduces each entry to
the condition $i=I(j)$.  Bijectivity gives a unique row for each column and a
unique column for each row.  This is exactly
`indicatorOracleMatrix_is_permutation`.

The gate record `oneTermRobinGate_U_indic` therefore carries
`unitary.proved = true`.
