# QBE-OP-OPTCTRL-001 Qiskit Export

This directory contains the Qiskit export for the Lean-certified concrete
transfer-operator champion:

```text
E_1 = |0><1|_time tensor |0><1|_type tensor I_state.
```

Lean certificate:

```text
QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified
```

Run the finite executable check:

```bash
python executable-exports/QBE-OP-OPTCTRL-001/qiskit/export.py
```

The Qiskit check verifies that the exported four-qubit circuit has the same
clean block as the Lean-certified concrete matrix.  It is an executable export
check, not the source of the mathematical certificate.
