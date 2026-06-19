# QBE-OP-CUBIC-DIAGONAL-001 Diagonal Amplitude Oracle Proof DAG

Updated: 2026-06-19 20:44 JST

Role: lower natural-language proof architect.

Status update after final readback: `DIAG-BLOCK-BRIDGE-001` has been closed in
Lean as `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target`.  This file
keeps the bridge proof design for auditability and routes the next active leaf
to `DIAG-PRIM-UNITARY-001`.

## Source Fragment

The source is the user-provided operator target, not a paper archive.  The
fragment being translated is:

$$
D_n = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j><j|.
$$

Equivalently, for $N = 2^n$ and basis indices `row` and `col`,

$$
D_n[row,col] =
\begin{cases}
(row/N)^3, & row = col,\\
0, & row \ne col.
\end{cases}
$$

The Lean source of truth for this fragment is
`CubicDiagonalOracle.cubicDiagonalOperator n`, with normalizer
`CubicDiagonalOracle.exactNormalizer n = 1`.

## Definitions

For a fixed `n : Nat`, let `gridSize n = 2^n`.  The grid point attached to
`j : Fin (gridSize n)` is `CubicStatePreparation.gridPoint n j`.  The cubic
amplitude is `CubicStatePreparation.cubicAmplitude n j`.

The target matrix is:

```lean
CubicDiagonalOracle.cubicDiagonalOperator n row col =
  if row = col then CubicStatePreparation.cubicAmplitude n row else 0
```

The clean-block predicate for an oracle-supplied block is:

```lean
CubicDiagonalOracle.diagonalCleanBlockContract n block :=
  forall row col,
    block row col =
      if row = col then CubicStatePreparation.cubicAmplitude n row else 0
```

The operator-first target record is `CubicDiagonalOracle.cubicDiagonalTarget n`,
whose `operator` field unfolds to `CubicDiagonalOracle.cubicDiagonalOperator n`.

## Retired Local Theorem

The bridge theorem is now compiled as:

```lean
theorem CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target
    (n : Nat) (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : CubicDiagonalOracle.diagonalCleanBlockContract n block) :
    Matrix.PointwiseEq block (CubicDiagonalOracle.cubicDiagonalTarget n).operator
```

Natural-language proof:

Fix `n`, `block`, and a proof `h` of
`diagonalCleanBlockContract n block`.  For each pair of indices `row` and
`col`, the hypothesis `h row col` states that `block row col` equals the
diagonal cubic entry if `row = col`, and equals zero otherwise.  This is
exactly the entry definition of `cubicDiagonalOperator n`.  The existing Lean
theorem `diagonalCleanBlockContract_pointwise_eq n block h` packages this
entrywise equality as `Matrix.PointwiseEq block (cubicDiagonalOperator n)`.
Finally, unfolding `cubicDiagonalTarget` identifies
`(cubicDiagonalTarget n).operator` with `cubicDiagonalOperator n`.

The theorem closes with the existing bridge:

```lean
by
  simpa [CubicDiagonalOracle.cubicDiagonalTarget] using
    CubicDiagonalOracle.diagonalCleanBlockContract_pointwise_eq n block h
```

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target matrix. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget` | `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove $0 \le (j/2^n)^3 \le 1$ for every grid index. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-RESOURCE-001` | Record primitive oracle-label score `(1, 1, 1, 1)`. | `amplitudeOracleLayout`, `amplitudeOracleCircuit`, `Circuit.resource` | existing Lean | `amplitudeOracleResourceTuple_eq` | candidate-population ledger | `python3 tools/qbe.py check` | proved |
| `DIAG-BLOCK-BRIDGE-001` | Any clean block satisfying the diagonal contract equals the target operator. | `DIAG-TGT-001`, `diagonalCleanBlockContract_pointwise_eq` | existing Lean | `primitiveOracleCleanBlock_eq_target` | this file, Retired Local Theorem | `python3 tools/qbe.py check` | proved |
| `DIAG-PRIM-UNITARY-001` | State a one-signal primitive amplitude-oracle semantic contract that supplies a unitary and a block satisfying `diagonalCleanBlockContract`. | `DIAG-RANGE-001`, `DIAG-BLOCK-BRIDGE-001` | next lower architect then Lean worker | planned primitive contract | this file, Failure Analysis | `python3 tools/qbe.py check` | active leaf |
| `DIAG-ROOT-001` | Package an exact primitive operator block-encoding certificate without semantic flag promotion. | `DIAG-RESOURCE-001`, `DIAG-PRIM-UNITARY-001` | future lower Lean worker | planned `VerifiedOperatorBlockEncoding`-compatible artifact | proof-obligation ledger | `python3 tools/qbe.py check` | blocked internal |
| `DIAG-EXPORT-001` | Export Qiskit, QuantumKatas-style, and QASM3 artifacts tied to a named Lean certificate. | `DIAG-ROOT-001` | future verifier/export worker | planned export packet | candidate-population ledger | Lean gate plus export checks | blocked downstream |

Next active Lean leaf: `DIAG-PRIM-UNITARY-001`.

## Intermediate Lean Lemmas

1. Reuse `CubicDiagonalOracle.diagonalCleanBlockContract_pointwise_eq`.
   This already converts a clean-block entry contract into pointwise equality
   with `cubicDiagonalOperator n`.

2. Reuse `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target`.
   This only unfolds `cubicDiagonalTarget` and reuses the previous lemma.  It
   does not define a unitary, a circuit expansion, or a verified certificate.

3. Reuse `CubicDiagonalOracle.cubicAmplitude_nonneg` and
   `CubicDiagonalOracle.cubicAmplitude_le_one`.
   These are needed by the next primitive oracle semantic contract, not by the
   active bridge proof.

4. Reuse `CubicDiagonalOracle.amplitudeOracleResourceTuple_eq`.
   This proves the unexpanded primitive oracle-label score and should feed the
   root certificate only after the semantic contract exists.

5. Later, define a primitive semantic contract with two nontrivial fields:
   unitarity of the advertised primitive oracle and clean-block extraction
   satisfying `diagonalCleanBlockContract n block`.
   The contract must not encode either field as `True`.

## Failure Analysis

The bridge theorem is mathematically correct and now routes through the
existing pointwise equality lemma.  It is not a full block-encoding
certificate, so it only retires `DIAG-BLOCK-BRIDGE-001`.

The root certificate is still blocked because the current Lean surface has an
oracle label and resource tuple, but not a verified primitive unitary semantics.
In the current `Rat` matrix surface, a literal one-signal two-by-two rotation
with top-left entry $a = (j/2^n)^3$ would normally require a complementary
entry involving $\sqrt{1-a^2}$, which is not generally rational.  Therefore a
Lean worker should not fake the unitary field or set semantic propositions to
`True`.  The next route is either to state a precise primitive oracle contract
as an accepted unexpanded tier, or to move to an expanded backend with a scalar
type and rotation semantics that can represent the required amplitudes.

The user stated that `n` is positive.  The current Lean declarations accept all
`n : Nat`; this does not break the active bridge theorem because the matrix
definition is valid for `n = 0`.  A future theorem should add a positive-qubit
hypothesis only if the primitive oracle semantics or executable export needs
it.

## Typed Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `DIAG-PRIM-UNITARY-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `null`, not run by this natural-language worker |
| `block_entry_ok` | `true`, via compiled `primitiveOracleCleanBlock_eq_target` |
| `ancilla_cleanup_ok` | `null`, primitive semantic contract still open |
| `normalizer_ok` | `true`, `exactNormalizer n = 1` is compiled |
| `closed_theorem_ok` | `false`, next primitive semantic theorem is not closed |
| `error_class` | `external_contract_gap` |
| `next_route` | `State a primitive one-signal amplitude-oracle semantic contract with explicit unitarity and clean-block extraction fields; do not set semantic fields to True.` |
