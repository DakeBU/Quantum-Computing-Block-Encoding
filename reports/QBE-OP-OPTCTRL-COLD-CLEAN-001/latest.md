# QBE-OP-OPTCTRL-COLD-CLEAN-001 Closeout

This report records the clean-start Hierarchical Harness run for the transfer
operator

$$
E_1 = |0\rangle\langle 1|_T \otimes |0\rangle\langle 1|_\tau \otimes I_S .
$$

The run is intentionally isolated from the earlier ChatGPT Pro-assisted
`QBE-OP-OPTCTRL-001` run.  It proves that ABEIS can recover a correct
one-signal block encoding without reusing the Pro-supplied equality-transfer
construction.  The achieved cold-start construction is a finite permutation
matrix over `(signal,T,tau,S)`.

## Certified Result

| Field | Value |
| --- | --- |
| Candidate | `COLD-CLEAN-PERM-001` |
| Lean module | `QuantumBlockEncoding.ColdStartTransferE1` |
| Target theorem | `coldE1Candidate_blockProjection` |
| Permutation certificate | `coldE1CandidateImage_permutation_certificate` |
| Resource tuple | `(gateCount, depth, auxiliaryQubits, oracleCalls) = (4,4,1,0)` |
| Export check | `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/qiskit/export.py` |
| Qiskit/export status | `finite_matrix_ok=true`, `block_entry_ok=true`, `unitarity_ok=true`, `qiskit_export_ok=true` |

The construction is a certified high-level finite permutation block encoding.
It is not a primitive hardware decomposition theorem and it is not an
optimality theorem.

## Comparison With The Pro-Assisted Run

| Route | Outside hint? | Certified champion | Score | Interpretation |
| --- | --- | --- | --- | --- |
| Clean-start Hierarchical Harness | no | `COLD-CLEAN-PERM-001` | `(4,4,1,0)` | ABEIS found and certified a correct permutation completion from the task contract. |
| Earlier Pro-assisted evolution | yes | `evolved-eq-flip-r1-k1` | `(4,2,1,0)` | Pro's structured equality-transfer idea helped the population reach the lower-depth champion later certified in Lean. |

Both routes are useful evidence.  The clean-start result shows the harness can
close the operator contract unaided.  The Pro-assisted result shows that an
external high-level construction can materially improve the resource score once
Lean promotes it from insight pool to certified population.

## Proof Sketch

The system basis is ordered by

$$
\mathrm{idx}(T,\tau,S)=4T+2\tau+S.
$$

The full candidate basis adds one signal bit:

$$
\mathrm{full}(a,T,\tau,S)=8a+4T+2\tau+S.
$$

`coldE1CandidateImage` maps the two selected clean input columns
`(a,T,tau,S)=(0,1,1,S)` to `(0,0,0,S)`.  All other clean input columns are sent
to dirty-signal rows, so they vanish under the clean-block projection.  The
remaining dirty columns fill the unused rows, and Lean proves injectivity and
surjectivity by an explicit inverse table.

Therefore the clean block of the permutation matrix has exactly the two
nonzero entries of `E_1`.

## Artifacts

- Lean source: `QuantumBlockEncoding/ColdStartTransferE1.lean`
- Tests: `Tests/Basic.lean`
- Qiskit-backed export check:
  `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/qiskit/export.py`
- Manuscript proof note:
  `paper-notes/problem-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/latest.tex`
