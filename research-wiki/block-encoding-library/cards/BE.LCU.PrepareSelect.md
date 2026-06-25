# BE.LCU.PrepareSelect

Priority: P0

Sources: Childs--Wiebe linear-combination method; Berry--Childs--Cleve--Kothari--Somma truncated Taylor simulation; Gilyen--Su--Low--Wiebe block-encoding arithmetic.

## Detect When

The target is a finite weighted sum:

$$
A = \sum_j \alpha_j A_j,
$$

where each $A_j$ is unitary or already block-encoded.

## Construction

Prepare coefficients and select terms:

$$
\mathrm{PREP}|0\rangle
=
\sum_j \sqrt{\alpha_j/\alpha}|j\rangle,
\qquad
\mathrm{SELECT}
=
\sum_j |j\rangle\langle j| \otimes U_j.
$$

Then

$$
(\langle 0|\mathrm{PREP}^\dagger \otimes I)
\mathrm{SELECT}
(\mathrm{PREP}|0\rangle \otimes I)
=
A/\alpha.
$$

This displayed formula is the nonnegative real coefficient version.  For
negative or complex coefficients, phases/signs must be represented explicitly,
usually in the selected unitary or in the preparation convention, and
`alpha` is normally an absolute-value sum or another stated coefficient norm.

## Intuition

PREPARE puts square-root coefficient amplitudes on the index register.
SELECT applies the corresponding block or unitary.  Projecting the index
register back onto the prepared state contributes the second square-root
factor, so the clean branch contains the weighted sum.

## Lean Proof Shape

```lean
theorem lcu_cleanBlock :
  cleanBlock ((PREP.conjTranspose tensor I) * SELECT * (PREP tensor I))
    =
  (1 / alpha) smul sum j, alpha_j j smul cleanBlock (U_j j) := by
  ext row col
  simp [Matrix.mul_apply, SELECT, PREP]
```

Use a state-preparation-pair version when left and right coefficient states
are different.

Compiled Lean declarations:

- `BlockEncodingClassics.oneTermLCU_cleanBlock`
- `BlockEncodingClassics.LCUCertificate`
- `BlockEncodingClassics.LCUCertificate.correct`
- `BlockEncodingClassics.weightedSum2_entry`
- `BlockEncodingClassics.weightedSum2`
- `BlockEncodingClassics.twoTermLCUCertificate`
- `BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry`
- `BlockEncodingClassics.ExactCleanBlock.toLCUCertificate`
- `BlockEncodingClassics.productExactCleanBlockCertificate`

## Proof-DAG Leaves

- coefficient normalization;
- `PREP` clean-entry theorem;
- `SELECT` controlled-entry theorem;
- finite-sum simplification;
- error propagation if approximate terms are used.

## Resource Notes

Resource tuple includes prepare depth, select depth, term block encodings, and
additional index ancillas.

## Rejected Routes

If the target is a single matrix unit or partial permutation, use the partial
permutation route instead.
