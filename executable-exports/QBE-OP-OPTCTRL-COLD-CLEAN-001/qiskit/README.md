# QBE-OP-OPTCTRL-COLD-CLEAN-001 Qiskit Export

This directory contains the Qiskit export check for the no-Pro Hierarchical
Harness transfer-operator attempt.

Lean source:

```text
QuantumBlockEncoding.ColdStartTransferE1
```

Lean certificates:

```text
coldE1Candidate_blockProjection
coldE1CandidateImage_permutation_certificate
coldE1HighLevelSeedCost_gateCount
coldE1HighLevelSeedCost_depth
coldE1HighLevelSeedCost_auxiliaryQubits
coldE1HighLevelSeedCost_oracleCalls
```

Run:

```bash
python executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/qiskit/export.py --json
```

The Qiskit check is a post-Lean executable artifact for this finite instance.
It is not a replacement for the Lean theorem.
