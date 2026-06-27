# Export Plan: QBE-MAIN-CASE-HIER-COLD-001

## Lean Certificate

The export-facing Lean certificate is `mainCaseColdPartialPermVerified`.

The candidate record is `mainCaseColdPartialPermCandidate`.  The cost theorem
is `mainCaseColdPartialPermCandidate_cost`, which proves the logical-library
tuple `(gateCount=5, depth=5, auxiliaryQubits=1, oracleCalls=0)`.

Do not use `mainCasePro*` declarations or previous Qiskit/QASM exports as
evidence for this no-Pro COLD task.

## Concrete Instantiation

| Field | Value |
|---|---|
| task | `QBE-MAIN-CASE-HIER-COLD-001` |
| target | `E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S` |
| parameters | `r=1`, `k=1`, `passiveQubits=1` |
| system registers | `(T,tau,S)` |
| system index | `4*T + 2*tau + S` |
| full index | `8*signal + 4*T + 2*tau + S` |
| Lean/full-index bit weights | `S=0`, `tau=1`, `T=2`, `signal=3` |
| Qiskit integer wires for basis checks | `q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal` |
| clean signal | `mainCaseColdCleanSignal = 0` |
| normalizer | `mainCaseColdExactNormalizer = 1` |
| exact error | `mainCaseColdExactError = 0` |
| projector | `mainCaseColdBlockProjection` |
| certified image | `mainCaseColdCircuitImage_eq_partialPermImage` |

## Transcript

The COLD transcript is:

```text
X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal
```

In Lean, the circuit is `mainCaseColdCircuit`, the schedule is
`mainCaseColdSchedule`, and the certified finite image is
`mainCaseColdPartialPermImage`.

Export implementations may choose language-specific display labels, but their
manifest and deterministic basis-action check must preserve the Lean index
convention `8*signal + 4*T + 2*tau + S`.  For Qiskit integer-basis checks, use
`q[0]=S`, `q[1]=tau`, `q[2]=T`, and `q[3]=signal`.  In particular, do not reuse
the stale map `T=0`, `tau=1`, `S=2`, `signal=3` as integer wire weights.

For a Qiskit qubit list ordered as `[S, tau, T, signal]`, the five operations
are:

```text
x(q[2]);
ccx(q[1], q[2], q[3]);
x(q[1]);
cx(q[3], q[2]);
cx(q[1], q[3]);
```

## Target Languages

| Target | Artifact | Check |
|---|---|---|
| Qiskit | `qiskit/export.py` | basis action equals `mainCaseColdPartialPermImage`; clean block equals `mainCaseColdTarget` |
| QASM3 | `qasm3/main_case_cold_partial_perm.qasm3` | transcript preserves the repaired wire map and agrees with the Qiskit basis action |
| Manifest/checker | `export-manifest.json`; `main_case_cold_export_check.py` | normalizer, resource tuple, clean support, and full-index convention are recorded |

## Export Checks

The export verifier must check:

1. The generated basis action equals `mainCaseColdPartialPermImage` on all 16
   basis states.
2. The clean block equals `mainCaseColdTarget` with clean signal `0`.
3. The normalizer is `1` and exact error is `0`.
4. The resource tuple is `(5,5,1,0)` at the high-level logical tier.
5. No generated artifact cites `mainCasePro*` declarations or previous
   task-specific Qiskit/QASM exports as evidence.

After generated files are added, run the export checker, then run:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```
