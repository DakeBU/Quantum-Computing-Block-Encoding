# Proof Obligations: QBE-OP-CUBIC-DIAGONAL-001

Updated: 2026-06-19 20:44 JST

The source is the user-provided diagonal operator
$D_n = \sum_{j=0}^{2^n-1} (j/2^n)^3 |j\rangle\langle j|$.
There is no paper-source dependency for this task.

Current obligation state:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| Keep the target diagonal, not rank-one state preparation. | `CubicDiagonalOracle.cubicDiagonalOperator`, `cubicDiagonalTarget` | source/operator contract | compiled; reviewer must reject rank-one routes |
| Record exact normalizer $\alpha = 1$. | `CubicDiagonalOracle.exactNormalizer` | normalizer | compiled |
| Prove amplitude range $0 \le (j/2^n)^3 \le 1$. | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | internal Lean lemma | compiled |
| Record one-signal primitive oracle-label resources. | `amplitudeOracleLayout`, `amplitudeOracleResourceTuple_eq` | resource equality | compiled |
| Bridge a clean-block contract to the target operator. | `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` | internal Lean lemma | compiled; gate passed 2026-06-19 20:44 JST |
| State primitive one-signal oracle unitarity and clean-block extraction without hiding semantics. | planned primitive semantic contract | oracle/circuit semantics | active leaf; do not encode as `True` |
| Produce an exact primitive block-encoding certificate or equivalent project-local certificate. | planned `VerifiedOperatorBlockEncoding`-compatible artifact | root certificate | blocked on primitive oracle semantics |
| If primitive oracle contract is rejected, expand arithmetic and controlled rotations with a correct `R_y` convention. | planned expanded route | alternative circuit construction | backlog |
| Create Qiskit, QuantumKatas-style, and QASM3 exports. | planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet | post-Lean export | blocked until a Lean certificate is named |

## Proof-DAG Nodes

The scheduling frontier is maintained in
`conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md`.  The active Lean leaf for
cycle 1, `DIAG-BLOCK-BRIDGE-001`, is now closed.  The next route is the
primitive one-signal oracle semantic contract, without encoding the semantic
obligations as `True`.

## Verifier Feedback Route

Lower verifier work should log typed fields for the same fixed leaf rather
than changing the target:

```bash
python3 tools/qbe.py trial-log --task QBE-OP-CUBIC-DIAGONAL-001 \
  --role lower --kind attempt --status compiled \
  --feedback-field leaf=DIAG-PRIM-UNITARY-001 \
  --feedback-field source_correspondence_ok=true \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=true \
  --feedback-field normalizer_ok=true \
  --feedback-field error_class=external_contract_gap \
  --feedback-field next_route="state primitive oracle semantics without setting semantic obligations to True"
```

If a finite diagnostic contradicts the diagonal target, use
`error_class=finite_matrix_counterexample` and route back to this obligation
ledger before any Lean proof search continues.
