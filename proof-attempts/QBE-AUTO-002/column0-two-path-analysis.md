# Column-0 Two-Path Analysis for [0,0] Entry

Task: QBE-AUTO-002, Cycle 1
Date: 2026-06-07
Status: partial — prefix support compiled, suffix/entry remains open

## Compiled Lemmas

1. `oneTermRobinGamma3BoundaryODBSImage1_n3`: `bandedSparseAccessPaperImage(p, 1) = 97` (native_decide)
2. `oneTermRobinGamma3BoundaryODBSCol1_support_n3`: `O_D^BS[i, Row1] = 0` for `i.val ≠ 97`
3. `oneTermRobinGamma3BoundaryRyCol0_support_n3`: `Ry[i, Row0] = 0` for `i ∉ {Row0, Row1}`
4. `oneTermRobinGamma3BoundaryRDUPrefixCol0Support_n3`: `RDU[i, Row0] evalWith = 0` for `i ∉ {Row0, Row1}`
5. `oneTermRobinGamma3BoundaryPrefixCol0Support_n3`: `prefix[i, Row0] evalWith = 0` for `i.val ∉ {96, 97}`

## Two-Path Decomposition

The prefix at column 0 has nonzero entries only at rows 96 and 97:

```
sevenGateMatrix[0, 0] = suffixMatrix[0, 96] * prefixMatrix[96, 0]
                      + suffixMatrix[0, 97] * prefixMatrix[97, 0]
```

This is NOT a unique-path decomposition (unlike [32,32] which has a single path through row 0).
The two paths arise because `Ry_boundary` at column 0 produces nonzero entries at rows {0, 1},
which `O_D^BS` maps to {image(0), image(1)} = {96, 97}.

## Suffix-Side Analysis (not yet compiled)

The suffix at row 0 concentrates at column 96 via the dagger:
- `(O_D^BS)^†[Row0, k] = 0` for `k ≠ 96` (since `bandedSparseAccessPaperImage(0) = 96`)
- `suffixMatrix[Row0, k] = OfSwap[96, k]`
- `OfSwap[96, k] = SWAP[96, :] * O_f[:, k]`
- `SWAP[96, j] = 1` iff `j = 12` (since `swapOracleImage(12) = 96`)
- So `suffixMatrix[Row0, k] = O_f[12, k]`

Therefore:
```
sevenGateMatrix[0, 0] = O_f[12, 96] * prefixMatrix[96, 0]
                      + O_f[12, 97] * prefixMatrix[97, 0]
```

The next worker needs to:
1. Prove the dagger row-0 support lemma
2. Prove the SWAP at row 96 maps to row 12
3. Compute or bound the O_f[12, 96] and O_f[12, 97] values
4. Compare the two-path result with the backend fold

## Blocking Issue for Diagonal Uniformity

The [32,32] unique-path gives: `sevenGateMatrix[32,32] = suffixMatrix[32,0] * prefixMatrix[0,32]`
The [0,0] two-path gives: a sum of two products involving O_f entries.
Proving these are equal (diagonal uniformity) requires explicit computation of the matrix entries,
which native_decide cannot handle (OOM at 128x128 with symbolic Coeff).

## Gate

`python3 tools/qbe.py check` passes with the new lemmas. Two pre-existing sorry warnings remain.
