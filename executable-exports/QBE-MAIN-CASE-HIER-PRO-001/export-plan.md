# Export Plan: QBE-MAIN-CASE-HIER-PRO-001

## Lean Certificate

The export-facing Lean certificate is `mainCaseProCircuitVerified`.

The cost theorem is `mainCaseProCircuitCandidate_cost`, which proves the
logical-library tuple
`(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

Do not use `mainCaseProVerified` or `mainCaseProCandidate_cost` as the Pro
transcript export certificate.  Those declarations belong to the matrix-table
incumbent `MAINCASE-PRO-PERM-001`.

## Concrete Instantiation

| Field | Value |
|---|---|
| task | `QBE-MAIN-CASE-HIER-PRO-001` |
| target | `E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S` |
| parameters | `r=1`, `k=1`, `passiveQubits=1` |
| system registers | `(T,tau,S)` |
| full wire map | `S=0`, `tau=1`, `T=2`, `signal=3` |
| clean signal | `mainCaseProSignalIndex = 0` |
| normalizer | `mainCaseProExactNormalizer = 1` |
| exact error | `mainCaseProExactError = 0` |
| projector | `mainCaseProBlockProjection` |

## Transcript

The Pro transcript is:

```text
CCX012; CX21; CX20; X2
```

In Lean, the aligned transcript image is `mainCaseProCircuitImage`, and the
matrix is `mainCaseProCircuitMatrix`.

## Target Languages

| Target | Artifact | Check |
|---|---|---|
| Qiskit | pending under this directory | basis action equals `mainCaseProCircuitImage`; clean block equals `mainCaseProTarget` |
| QASM3 | pending under this directory | parser accepts the circuit; basis action agrees with Qiskit and `mainCaseProCircuitImage` |

## Export Checks

The export verifier must check:

1. The generated basis action equals `mainCaseProCircuitImage` on all 16 basis
   states.
2. The clean block equals `mainCaseProTarget` with clean signal `0`.
3. The normalizer is `1` and exact error is `0`.
4. The resource tuple is `(4,4,1,0)` at the logical-library tier.
5. The stale all-state equality to `mainCaseProCandidateImage` remains rejected
   on dirty inputs `8`, `9`, `12`, and `13`.

After generated files are added, run the export checker, then run:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```
