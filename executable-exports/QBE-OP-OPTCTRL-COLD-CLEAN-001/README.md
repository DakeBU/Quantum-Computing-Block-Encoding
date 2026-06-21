# Cold E1 Executable Export

This directory is the post-Lean export packet for
`QBE-OP-OPTCTRL-COLD-CLEAN-001`, leaf `COLD-E1-EXPORT-001`.

The executable matrix uses the same basis order as
`QuantumBlockEncoding/ColdStartTransferE1.lean`:

$$
\mathrm{index} = 8 \cdot \mathrm{signal} + 4 \cdot T + 2 \cdot \tau + S.
$$

The exported candidate image is

```text
[8, 9, 10, 11, 12, 13, 0, 1, 2, 3, 4, 5, 6, 7, 14, 15]
```

The finite check constructs the corresponding `16 x 16` permutation matrix,
builds a Qiskit `UnitaryGate` from that matrix, and verifies:

- the image table is a permutation preserving the passive `S` bit;
- the clean signal block equals
  $|0><1|_T \otimes |0><1|_\tau \otimes I_S$;
- the matrix is unitary;
- the exported Qiskit operator equals the same matrix;
- the advertised high-level tuple is `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)`.

Run:

```bash
python3 executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/cold_e1_export_check.py --write-feedback
```

Named Lean certificates used by this export:

- `coldE1Candidate_blockProjection`
- `coldE1CandidateImage_permutation_certificate`
- `coldE1HighLevelSeedCost_gateCount`
- `coldE1HighLevelSeedCost_depth`
- `coldE1HighLevelSeedCost_auxiliaryQubits`
- `coldE1HighLevelSeedCost_oracleCalls`

This export is not a primitive gate decomposition, transpilation result, or
hardware-optimality proof.
