# Middle Source Contract: QBE-MAIN-CASE-HIER-PRO-001

## Source Anchors And Object

The active source is the task packet plus the injected Pro construction packet:

- `tasks/QBE-MAIN-CASE-HIER-PRO-001.md`, sections `Operator Contract`,
  `Isolation Rule`, `External Pro Construction Packet`, and
  `Post-Lean Executable Exports`.
- `task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md`,
  sections `Target`, `Pro Construction Idea`, `Expected Proof Shape`, and
  `Expected Resource Claim`.

The translated object is the user/operator target

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S
$$

with `alpha = 1`, clean signal selector `a = 0`, one passive state qubit, and
the Pro transcript `CCX012; CX21; CX20; X2`.

The full Lean basis convention is
`signal * 8 + 4 * T + 2 * tau + S`.  The corresponding wire map is:

| Full wire | Register |
|---:|---|
| `0` | passive `S` |
| `1` | type `tau` |
| `2` | time `T` |
| `3` | signal ancilla `a` |

After dropping the passive state wire, the Pro reduced bits are
`bit 0 = tau`, `bit 1 = T`, and `bit 2 = a`.

## Lean Correspondence

The fixed target and finite-permutation clean-block tier already compile in
`QuantumBlockEncoding/MainCase.lean`.

| Source object | Lean declaration | Status |
|---|---|---|
| system index `(T,tau,S)` | `mainCaseProSystemIndex` | compiled |
| target matrix `E_1` | `mainCaseProTarget` | compiled |
| target metadata | `mainCaseProQueryTarget` | compiled |
| clean signal selector | `mainCaseProSignalIndex` | compiled |
| clean block predicate | `mainCaseProBlockProjection` | compiled |
| candidate image | `mainCaseProCandidateImage` | compiled |
| candidate matrix | `mainCaseProCandidateMatrix` | compiled |
| image bijection | `mainCaseProCandidateImage_permutation_certificate` | compiled |
| clean-entry theorem | `mainCaseProCandidate_cleanEntry` | compiled |
| clean-block theorem | `mainCaseProCandidate_blockProjection` | compiled |
| finite-permutation package | `mainCaseProVerified` | compiled at finite-permutation clean-block tier |
| resource tuple `(4,4,1,0)` | `mainCaseProCandidate_cost` | compiled |

The active source-correspondence gap is the missing task-local theorem that
the advertised Pro transcript realizes the candidate image:

```lean
def mainCaseProCircuitImage : Fin 16 -> Fin 16 := ...

theorem mainCaseProCircuitImage_eq_candidate :
    forall x : Fin 16,
      mainCaseProCircuitImage x = mainCaseProCandidateImage x := by
  ...
```

If the theorem is false, lower work should split the candidate record so
`mainCaseProCandidateImage` remains a finite-permutation clean-block candidate
and the gate-derived transcript becomes a separate candidate with its own image.

## External Lemmas And Cited Results

No external paper theorem is needed for the active circuit-image source
contract.  Lin 2201.08309 remains textbook memory for the entrywise clean-block
route, not a dependency row for this finite transcript check.

The queued rational-orthogonality bridge is QBE-local semantic glue.  It is not
owned by the Pro packet and should not block the circuit-image diagnostic.

## Ownership Split

| Layer | Owned by active task | External contract | QBE-local semantic glue |
|---|---|---|---|
| operator target | `E_1`, alpha `1`, clean signal `0` | none | `mainCaseProBlockProjection` |
| candidate image | task-local `mainCaseProCandidateImage` | none | finite bijection and permMatrix clean block |
| Pro transcript | task-local translation of `CCX012; CX21; CX20; X2` | none | reduced/full wire-map evaluator |
| resources | logical `{X,CNOT,Toffoli}` tuple `(4,4,1,0)` | no hardware decomposition claim | `BlockEncodingCost` field checks |
| executable exports | requested `qiskit,qasm3` | blocked until named Lean semantic tier is accepted | later export packet |

## Lower-Facing Source Contract

Leaf: `MAINCASE-PRO-CIRCUIT-IMAGE-001`.

Target file: `QuantumBlockEncoding/MainCase.lean`.  Read-only comparison to
`QuantumBlockEncoding/OptimalControl.lean` is allowed around
`proEqTransferImage`, `proEqTransferGateImages_eval`, `liftReducedImage`, and
the reduced gates, but those declarations may not be imported as certificates
for this isolated task.

Required contract:

1. Define the task-local image induced by `mainCaseProCircuit` under full wires
   `S=0`, `tau=1`, `T=2`, `signal=3`.
2. Check all `16` basis states against `mainCaseProCandidateImage`.
3. If equality holds, prove `mainCaseProCircuitImage_eq_candidate`.
4. If equality fails, record the mismatch set and split the finite-permutation
   candidate from the gate-derived candidate before using the circuit or export
   layer.

Typed feedback fields for this leaf should include `source_correspondence_ok`,
`lean_parse_ok`, `lean_build_ok`, `finite_matrix_ok`, `block_entry_ok`,
`ancilla_cleanup_ok`, `normalizer_ok`, `unitarity_ok`, `resource_score`,
`auxiliary_qubits`, `gate_count`, `depth`, `oracle_calls`,
`closed_theorem_ok`, `error_class`, and `next_route`.
