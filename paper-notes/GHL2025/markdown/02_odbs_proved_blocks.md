# O_D^BS Proved Register Blocks

Paper anchor: GHL2025 Lemma 1, banded sparse access oracle
$O_D^{BS}$.

Lean declarations:

- `bandedSparseAccessPaperRegisters`
- `bandedSparseAccessPaperAddress`
- `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`
- `bandedSparseAccessPaperImage`
- `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`
- `bandedSparseAccessPaperImage_rowValue_eq`
- `bandedSparseAccessPaperImage_odRegisterValue_eq`
- `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`
- `bandedSparseAccessPaperMatrix_imageFin_eq_one`
- `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`

## Definitions

The paper contract is

$$
O_D^{BS}|0\rangle^{n-\ell}|s\rangle^\ell |i\rangle^n
= |r_{si}\rangle^n |i\rangle^n .
$$

QBE stores the row register in bits $[1,1+n)$ and the full $O_D^{BS}$ address
register in bits $[1+n,1+2n)$.  The latter is split into a padded-zero part and
a sparse-index part.

For a compound basis index $j$, Lean extracts:

$$
\operatorname{row}(j)=
\left(j\gg 1\right)\mathbin{\&}(2^n-1),
$$

and

$$
\operatorname{od}(j)=
\left(j\gg(1+n)\right)\mathbin{\&}(2^n-1).
$$

The executable one-term address is

$$
r(j)=\operatorname{robinSparseColumnMap}
\bigl(n,\operatorname{sparse}(j),\operatorname{row}(j)\bigr).
$$

The current paper-image skeleton is the arithmetic splice

$$
F(j)=j\bmod 2^{1+n}
  + r(j)\,2^{1+n}
  + \left\lfloor \frac{j}{2^{1+2n}}\right\rfloor 2^{1+2n}.
$$

## Proved Address Range Block

Lean proves that the extracted row is an $n$-bit value:

$$
\operatorname{row}(j)<2^n.
$$

This is `bandedSparseAccessPaperRegisters_row_lt_gridSize`.

Under the explicit side condition $2\le n$, Lean proves

$$
r(j)<2^n.
$$

This is `bandedSparseAccessPaperAddress_lt_gridSize_of_two_le`, using
`robinSparseColumnMap_lt_gridSize_of_row_lt`.  The Boolean check
`bandedSparseAccessPaperAddressInRange` is then true by
`bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`.

The semantic obligation `addressRange.proved` remains false because the theorem
data structure has not yet promoted $2\le n$ as a closed paper-level
assumption.

## Proved Image Range Block

Assume $j$ is in the full finite basis and $r(j)<2^n$.  The low part

$$
j\bmod 2^{1+n}+r(j)2^{1+n}
$$

is strictly below $2^{1+2n}$.  Therefore the high-tail splice remains below the
full dimension whenever $j$ was below the full dimension.  Lean records this as

```lean
bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt
```

and packages the image as a `Fin` index with
`bandedSparseAccessPaperImageFin`.

## Proved Register Roundtrip Blocks

The low block of $F(j)$ is definitionally the low block of $j$:

$$
F(j)\bmod 2^{1+n}=j\bmod 2^{1+n}.
$$

This gives the row preservation theorem
`bandedSparseAccessPaperImage_rowValue_eq`:

$$
\operatorname{row}(F(j))=\operatorname{row}(j).
$$

If $r(j)<2^n$, then after shifting past the low block and reducing modulo
$2^n$, Lean obtains

$$
\operatorname{od}(F(j))=r(j).
$$

This is `bandedSparseAccessPaperImage_odRegisterValue_eq`.

## Proved No-Spill Block

Define the high tail above the $O_D^{BS}$ register by

$$
H(j)=j\gg(1+2n).
$$

If $r(j)<2^n$, then the low splice does not carry into the high tail, so

$$
H(F(j))=H(j).
$$

This is `bandedSparseAccessPaperImage_highTail_eq_of_address_lt`.  The Boolean
no-spill check is equivalent to this equality by
`bandedSparseAccessPaperImageNoSpill_iff`, hence
`bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt`.

## Proved Matrix Entry Bridge

The forward paper matrix is

$$
M_{i,j}=
\begin{cases}
1, & i=F(j),\\
0, & i\ne F(j).
\end{cases}
$$

Under the same finite-image hypotheses, Lean proves

$$
M_{F(j),j}=1.
$$

This is `bandedSparseAccessPaperMatrix_imageFin_eq_one`, and the active gate
version is `oneTermRobinGate_O_D_BS_imageFin_eq_one`.

The transpose-style dagger skeleton satisfies

$$
M^\dagger_{j,F(j)}=1,
$$

recorded by `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one` and
`oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one`.

## Not Proved Yet

The following are still obligations:

- injectivity of $F$ on the relevant finite domain;
- inverse-on-range for the dagger;
- post-SWAP cleanup of the padded sparse-index register;
- full unitarity of $O_D^{BS}$ and $(O_D^{BS})^\dagger$.
