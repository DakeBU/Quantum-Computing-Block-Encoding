# Middle Lower Packets: MAIN-EXPORT-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Run: `20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01`

## Root Served

The root theorem package is `mainCaseColdPartialPermVerified`.  The export leaf
must not prove a new block encoding and must not use executable checks as
evidence for the Lean theorem.  It translates the certified concrete COLD
construction into Qiskit and QASM3 artifacts for `r=1`, `k=1`, and
`passiveQubits=1`.

## Fixed Lean Source

| Role | Declaration |
|---|---|
| verified certificate | `mainCaseColdPartialPermVerified` |
| candidate record | `mainCaseColdPartialPermCandidate` |
| target matrix | `mainCaseColdTarget` |
| finite image | `mainCaseColdPartialPermImage` |
| circuit transcript | `mainCaseColdCircuit`, `mainCaseColdSchedule` |
| image bridge | `mainCaseColdCircuitImage_eq_partialPermImage` |
| cost theorem | `mainCaseColdPartialPermCandidate_cost` |
| resource fields | `mainCaseColdPartialPermCost_*` |
| clean signal | `mainCaseColdCleanSignal = 0` |
| normalizer | `mainCaseColdExactNormalizer = 1` |

## Shared Export Contract

The exported circuit must implement:

```text
X_T; CCX_tau,T->signal; X_tau; CX_signal->T; CX_tau->signal
```

Use Lean integer bit positions `S=0`, `tau=1`, `T=2`, `signal=3`.  For Qiskit
integer-basis checks, use `q[0]=S`, `q[1]=tau`, `q[2]=T`, and `q[3]=signal`.
The passive `S` wire is present and untouched.  The finite-basis check must
compare against the Lean full index convention `8*signal + 4*T + 2*tau + S`,
not a Qiskit display-order default or the stale map `T=0`, `tau=1`, `S=2`,
`signal=3` as integer wire weights.

For Qiskit, use `q[0]=S`, `q[1]=tau`, `q[2]=T`, and `q[3]=signal`.  The
certified transcript then becomes:

```text
x(q[2]);
ccx(q[1], q[2], q[3]);
x(q[1]);
cx(q[3], q[2]);
cx(q[1], q[3]);
```

Allowed write scope:

- `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`
- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`
- `runs/20260627-122318-QBE-MAIN-CASE-HIER-COLD-001-cycle01/`
- `runs/20260627-125940-QBE-MAIN-CASE-HIER-COLD-001-cycle02/`

Do not edit Lean for this export leaf unless the export check exposes a
source-correspondence mismatch in the already compiled COLD declarations.

Required gate after generated files:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

## Lower 1: Export Map Packet

Write a concise export map under the export root that names:

| Field | Required value |
|---|---|
| Lean certificate | `mainCaseColdPartialPermVerified` |
| target | `E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S` |
| registers | `T`, `tau`, `S`, `signal` |
| normalizer | `1` |
| clean projector | signal qubit at `0` |
| resource tuple | `(5,5,1,0)` |
| target languages | `qiskit`, `qasm3` |
| check command | the export verifier plus the project gate |

Do not create manuscript LaTeX in this packet.

## Lower 2: Export Implementation Packet

Create executable artifacts for exactly the certified COLD transcript:

- Qiskit Python under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qiskit/`.
- QASM3 text under `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/qasm3/`.
- A manifest that repeats the Lean certificate, register map, normalizer,
  projector, resource tuple, and check command.

The generated implementation must expose a deterministic basis-action function
or checker that can be run without relying on a hardware backend.

## Lower 3: Necessary-Condition Verifier Packet

Write and run an export verifier that checks:

1. The exported basis action equals `mainCaseColdPartialPermImage` on all 16
   basis states.
2. The clean block support is exactly system pairs `(0,6)` and `(1,7)`.
3. The passive `S` bit is preserved by all exported gates.
4. The normalizer is `1`, exact error is `0`, and the resource tuple is
   `(5,5,1,0)`.
5. The export artifacts do not cite `mainCasePro*` declarations or previous
   Qiskit/QASM files as evidence.

Log typed feedback with:

```bash
python3 tools/qbe.py trial-log --task QBE-MAIN-CASE-HIER-COLD-001 \
  --role lower --kind attempt --status accepted \
  --artifact verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/<export-feedback>.md \
  --feedback-field leaf=MAIN-EXPORT-001 \
  --feedback-field source_correspondence_ok=true \
  --feedback-field finite_matrix_ok=true \
  --feedback-field block_entry_ok=true \
  --feedback-field normalizer_ok=true \
  --feedback-field resource_score="(5,5,1,0)" \
  --feedback-field closed_theorem_ok=false \
  --feedback-field error_class=null \
  --feedback-field next_route="review export artifacts and gate"
```

Use `closed_theorem_ok=false` for the export verifier because it is a post-Lean
artifact check, not a new Lean theorem.
