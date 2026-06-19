# Candidate Population: QBE-OP-CUBIC-STATEPREP-001

Target:

```text
O_n = |v_n><0^n|,  v_n[j] = (j / 2^n)^3,  epsilon = 1e-10.
```

## Certified Population

No full block-encoding candidate has been promoted yet.  The compiled Lean
surface currently certifies only the target declarations and small norm
diagnostics.

Retired non-candidates:

| Artifact | Reason |
|---|---|
| `cubicNormSq_n1`, `cubicNormSq_n2` | Useful exact diagnostics, but they do not define a scalable candidate or a normalizer proof. |

## Insight Pool

| Candidate | Tier | Current role | Reason kept |
|---|---|---|---|
| dense table state preparation | finite executable baseline | competitor/smoke-test baseline | simple for small `n`, but scales with `2^n` |
| universal block-matrix completion | mathematical seed | correctness seed | generic BE construction, not resource-competitive |
| reversible arithmetic cubic amplitude | symbolic/scalable route | primary Scenario 2 route | plausible `poly(n, log(1/epsilon))` construction |
| polynomial/Chebyshev approximation | symbolic/scalable route | alternate Scenario 2 route | may reduce rotation synthesis cost |

## Active Candidate Records

| Candidate family | Tier | Partial score fields | Current blocker | Next mutation or proof step |
|---|---|---|---|---|
| target-only norm bridge | diagnostic, not a BE candidate | `gateCount = 0`, `depth = 0`, `auxiliaryQubits = 0`, `oracleCalls = 0` only as a diagnostic artifact | no closed rational formula or normalizer proof yet | prove CUBIC-NORM-001 in Lean |
| dense table state preparation | finite executable baseline | typed scaling feedback recorded in `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`; resource scales with `2^n` data movement and dense unitary memory reaches 64 TiB at `n = 20` with one auxiliary qubit | no symbolic family certificate and no candidate block-entry theorem | keep as smoke-test baseline for later finite candidate instances |
| reversible arithmetic cubic amplitude | symbolic/scalable route | resource tuple open | missing `alpha`, block projector, clean ancilla, and epsilon budget | lower architect drafts CUBIC-ERR-001 after CUBIC-ALPHA-001 is ready |
| universal block-matrix completion | mathematical seed | resource tuple open and expected noncompetitive | no candidate matrix completion theorem named | keep as fallback after normalizer bridge |

## Promotion Rule

A candidate can enter the certified population only after Lean proves:

1. the candidate is unitary at the advertised semantic tier;
2. its clean block approximates `O_n` with the stated `epsilon`;
3. its resource score is computed under the fixed metric order;
4. any Qiskit/QASM/QuantumKatas export is downstream of the Lean theorem, not a
   substitute for it.
