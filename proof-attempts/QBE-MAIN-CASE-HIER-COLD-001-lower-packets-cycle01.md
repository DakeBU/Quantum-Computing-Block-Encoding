# Lower Packets: QBE-MAIN-CASE-HIER-COLD-001 Cycle 1

## Shared Fixed Target

The task is exploratory construction for the exact operator

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

Use system order `(T,tau,S)`, one qubit per register, system flattening
`4*T + 2*tau + S`, one clean signal qubit, and total flattening
`8*signal + 4*T + 2*tau + S`.  The normalizer is `alpha = 1`, the exact error
is `0`, and the clean block is selected by `signal = 0`.

The primary route is partial permutation.  Reuse
`BlockEncodingClassics.partialPermutationCertificate` and related generic
clean-block declarations.  Do not import, copy, or rename previous main-case
candidate declarations, previous Pro answers, or previous Qiskit exports.
Declarations with prefix `mainCasePro*` already belong to the separate Pro arm
and are not allowed as certificates for this no-Pro COLD task.

## Candidate Image

For each passive bit `s`, use the following active table:

| Input `(signal,T,tau,s)` | Output `(signal,T,tau,s)` |
|---|---|
| `(0,0,0,s)` | `(1,1,1,s)` |
| `(0,0,1,s)` | `(1,0,0,s)` |
| `(0,1,0,s)` | `(1,0,1,s)` |
| `(0,1,1,s)` | `(0,0,0,s)` |
| `(1,0,0,s)` | `(0,0,1,s)` |
| `(1,0,1,s)` | `(0,1,0,s)` |
| `(1,1,0,s)` | `(0,1,1,s)` |
| `(1,1,1,s)` | `(1,1,0,s)` |

The flattened image table is:

```text
0 -> 14, 1 -> 15, 2 -> 8, 3 -> 9,
4 -> 10, 5 -> 11, 6 -> 0, 7 -> 1,
8 -> 2, 9 -> 3, 10 -> 4, 11 -> 5,
12 -> 6, 13 -> 7, 14 -> 12, 15 -> 13
```

## Lower 1: Natural-Language Proof Architect

Write scope: `proof-attempts/`, `conversion-windows/`, or dialogue only.

Produce a compact proof packet for `MAIN-CLEAN-ENTRY-001`:

1. Define the system basis and clean embedding before stating the claim.
2. Prove in prose that the candidate table is a bijection on `Fin 16`.
3. Prove in prose that for clean columns `0..7`, the image is clean only for
   columns `6` and `7`, which map to clean rows `0` and `1`.
4. State the Lean endpoint:

```lean
theorem mainCaseColdPartialPerm_clean_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseColdPartialPermExactCleanBlock)
      mainCaseColdTarget
```

5. Name the next Lean leaf as `MAIN-CLEAN-ENTRY-001`; keep
   `MAIN-PERM-UNITARY-001` and `MAIN-RESOURCE-001` as later leaves unless the
   clean-entry proof exposes a smaller missing lemma.

Acceptance check: no Lean gate is required unless you edit Lean.  Log a handoff
with typed fields if the proof target is malformed.

## Lower 2: Lean Implementation Worker

Write scope:

- `QuantumBlockEncoding/MainCase.lean`
- `QuantumBlockEncoding.lean` only if the `MainCase` import is absent
- `Tests/Basic.lean` only for a small smoke example if needed

Implement exactly the active clean-entry leaf:

1. Add the COLD declarations to `QuantumBlockEncoding/MainCase.lean` or to a
   child file imported by it.
2. Import the generic library needed for matrix and block-encoding classics.
3. Define task-local declarations using `mainCaseCold*` names:
   `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`,
   `mainCaseColdExactError`, `mainCaseColdCleanSignal`, `mainCaseColdCleanEmbed`,
   `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`,
   `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, and
   `mainCaseColdPartialPerm_clean_eq_target`.
4. Use `BlockEncodingClassics.partialPermutationCertificate` for the exact
   clean-block package.  A finite `fin_cases` or `native_decide` proof is
   acceptable for the entry table.
5. Do not prove resource or export claims in this leaf unless the clean-entry
   theorem already compiles and the added theorem is a one-line field equality.

Required gate after Lean edits:

```bash
python3 tools/qbe.py check
```

Structured feedback fields: `leaf=MAIN-CLEAN-ENTRY-001`,
`source_correspondence_ok`, `lean_parse_ok`, `lean_build_ok`,
`block_entry_ok`, `normalizer_ok`, `closed_theorem_ok`, `error_class`, and
`next_route`.

## Lower 3: Necessary-Condition Verifier

Write scope:

- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`
- dialogue board

Create or run a small exact diagnostic for the table above.  It should check:

1. the image table is a permutation of `0..15`;
2. the table preserves passive `S`;
3. the clean block has ones exactly at `(row,col) = (0,6)` and `(1,7)`;
4. all other clean-block entries are zero;
5. `alpha = 1`, `auxiliary_qubits = 1`, and `oracle_calls = 0`;
6. `gate_count` and `depth` remain `null` unless a circuit schema is supplied.

Required typed feedback:

```text
leaf=MAIN-FINITE-DIAG-001
source_correspondence_ok=true
finite_matrix_ok=<true/false>
block_entry_ok=<true/false>
ancilla_cleanup_ok=true
normalizer_ok=true
unitarity_ok=<true if the table is a permutation>
resource_score=<partial tuple or null gate/depth fields>
auxiliary_qubits=1
oracle_calls=0
closed_theorem_ok=false
error_class=<none, finite_matrix_counterexample, shape_or_register_gap, or stale_leaf>
next_route=<one narrow next action>
```

This diagnostic is a necessary-condition filter.  It does not certify the
advertised theorem unless Lean names the corresponding theorem.

## Reviewer Checklist For This Packet

- Reject any use of previous main-case candidate names, Pro answers, or Qiskit
  exports as construction parents.
- Check that `mainCaseColdTarget` still represents
  `$|0><1|_T \otimes |0><1|_\tau \otimes I_S$`.
- Check that the clean block uses one signal qubit and `alpha = 1`.
- Check that no resource, unitarity, or export claim is marked proved without a
  named Lean declaration or typed diagnostic at the correct layer.
- Require `python3 tools/qbe.py check` after any Lean edit.
