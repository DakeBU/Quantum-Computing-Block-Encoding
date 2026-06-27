# Middle Coordinator Lower Packets: MAIN-EXPORT-001 Cycle 2

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02`

## Active Card-Memory Protocol For This Cycle

- Treat block-encoding textbook cards as route inspiration, not as fixed recipes. Upper and middle agents may propose several card-inspired routes, mutate or recombine them, and reject them when the target shape does not fit.
- Treat compiled Lean leaves as reusable proof tools. If a named theorem already closes the needed leaf, instantiate or adapt it locally; do not reprove it unless the reviewer explicitly asks for a stronger statement.
- Treat contract-only cards as explicit proof-DAG boundaries. They may guide planning, but they must not be reported as Lean-closed evidence.
- For this cycle, the block-encoding construction is already Lean-certified by `mainCaseColdPartialPermVerified`. The active work is executable export only, so do not reopen sparse, LCU, QSVT, dilation, approximate, or Pro-assisted construction routes.

## Coordinator Decision

The COLD Lean construction is closed at the finite-permutation semantic tier.
The export-facing certificate is `mainCaseColdPartialPermVerified`, and
`mainCaseColdPartialPermCandidate_cost` gives the resource tuple
`(gateCount=5, depth=5, auxiliaryQubits=1, oracleCalls=0)`.

The active frontier is post-Lean executable export only:

```text
MAIN-EXPORT-MAP-001 -> MAIN-EXPORT-IMPLEMENT-001 -> MAIN-EXPORT-VERIFY-001
```

Do not reopen `MAIN-CANDIDATE-PACKAGE-001`, clean-entry, finite-bijection,
block-projection, or resource proof leaves.  Do not use Pro-arm declarations,
previous export artifacts, LCU, sparse access, QSVT, dilation, approximate
search, or simulator-only evidence as acceptance.

## Fixed Source Contract

The task-owned operator is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The benchmark instance fixes one qubit each for `T`, `tau`, and passive `S`,
one clean signal qubit with value `0`, normalizer `1`, exact error `0`, and
resource tuple `(5,5,1,0)`.

The Lean system index is:

```text
4*T + 2*tau + S
```

The Lean full signal-system index is:

```text
8*signal + 4*T + 2*tau + S
```

Therefore executable integer bit weights are:

| Register | Bit weight | Qiskit integer-basis wire |
|---|---:|---|
| `S` | `0` | `q[0]` |
| `tau` | `1` | `q[1]` |
| `T` | `2` | `q[2]` |
| `signal` | `3` | `q[3]` |

The stale map `T=0`, `tau=1`, `S=2`, `signal=3` is retired for this task.

## Lean Declarations To Reuse

| Role | Declaration |
|---|---|
| verified certificate | `mainCaseColdPartialPermVerified` |
| candidate record | `mainCaseColdPartialPermCandidate` |
| target matrix | `mainCaseColdTarget` |
| finite image | `mainCaseColdPartialPermImage` |
| circuit transcript | `mainCaseColdCircuit`, `mainCaseColdSchedule` |
| circuit-to-table bridge | `mainCaseColdCircuitImage_eq_partialPermImage` |
| clean projector | `mainCaseColdBlockProjection`, `mainCaseColdCleanSignal` |
| normalizer and exact error | `mainCaseColdExactNormalizer`, `mainCaseColdExactError` |
| resource tuple | `mainCaseColdPartialPermCost_*`, `mainCaseColdPartialPermCandidate_cost` |

No new Lean declaration is requested in this packet.

## Certified Transcript

The exported circuit must implement exactly:

```text
X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal
```

For Qiskit with `[S, tau, T, signal]` as the qubit list, use:

```text
x(q[2]);
ccx(q[1], q[2], q[3]);
x(q[1]);
cx(q[3], q[2]);
cx(q[1], q[3]);
```

The passive `S` qubit must be present and untouched.

## Lower 1: Natural-Language Export Architect

Target leaf: `MAIN-EXPORT-MAP-001`.

Write or update the export manifest metadata under
`executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`.  The manifest must name:

| Field | Required value |
|---|---|
| Lean source theorem | `mainCaseColdPartialPermVerified` |
| candidate | `mainCaseColdPartialPermCandidate` |
| target | `E_1 = |0><1|_T \otimes |0><1|_tau \otimes I_S` |
| full index | `8*signal + 4*T + 2*tau + S` |
| Qiskit integer-basis wires | `q[0]=S`, `q[1]=tau`, `q[2]=T`, `q[3]=signal` |
| clean projector | signal qubit fixed to `0` |
| normalizer and error | `1`, `0` |
| resource tuple | `(5,5,1,0)` |
| target languages | `qiskit`, `qasm3` |

This packet is a manifest/source-correspondence task, not a Lean proof task.

## Lower 2: Export Implementation Worker

Target leaf: `MAIN-EXPORT-IMPLEMENT-001`.

Allowed write scope:

- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`
- `runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02/`

Generate:

- Qiskit Python under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/`.
- QASM3 text under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qasm3/`.
- A manifest that repeats the Lean certificate, register map, normalizer,
  projector, resource tuple, target languages, and check command.

The generated implementation must expose a deterministic basis-action function
or table over all 16 basis states.  It must not rely on a hardware backend.
Do not edit `QuantumBlockEncoding/MainCase.lean` unless deterministic export
verification finds a mismatch in the compiled COLD declarations.

## Lower 3: Necessary-Condition Verifier

Target leaf: `MAIN-EXPORT-VERIFY-001`.

Run or extend the export verifier so it checks:

1. The generated basis action equals `mainCaseColdPartialPermImage` on all 16
   basis states.
2. The clean-block support is exactly system pairs `(0,6)` and `(1,7)`.
3. The passive `S` bit is preserved.
4. The normalizer is `1`, exact error is `0`, and resource tuple is
   `(5,5,1,0)`.
5. QASM3 parser acceptance is recorded when the local tooling is available.
6. Generated artifacts do not cite `mainCasePro*` declarations or previous
   Qiskit/QASM files as evidence.

Use `closed_theorem_ok=false` for export feedback because this is post-Lean
artifact verification, not a new Lean theorem.

Suggested accepted feedback fields:

```bash
python3 tools/qbe.py trial-log --task QBE-MAIN-CASE-HIER-COLD-001 \
  --role lower --kind attempt --status accepted \
  --artifact verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/<export-feedback>.md \
  --feedback-field leaf=MAIN-EXPORT-VERIFY-001 \
  --feedback-field source_correspondence_ok=true \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=true \
  --feedback-field ancilla_cleanup_ok=true \
  --feedback-field normalizer_ok=true \
  --feedback-field resource_score="(5,5,1,0)" \
  --feedback-field auxiliary_qubits=1 \
  --feedback-field gate_count=5 \
  --feedback-field depth=5 \
  --feedback-field oracle_calls=0 \
  --feedback-field closed_theorem_ok=false \
  --feedback-field error_class=null \
  --feedback-field next_route="review export artifacts and run project gate"
```

If the verifier fails, classify the primary error as `shape_or_register_gap`,
`finite_matrix_counterexample`, `source_translation_gap`, or `invalid_route`
and return one narrow repair route.

## Required Gate

After generated files are added, run:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```
