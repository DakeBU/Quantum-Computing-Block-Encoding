# Lower Resource Schema Packet: QBE-MAIN-CASE-HIER-COLD-001 Cycle 3

Leaf: `MAIN-RESOURCE-001`

Root served: future `mainCaseColdPartialPermCandidate` and
`mainCaseColdPartialPermVerified` packaging for the fixed transfer operator
`E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S`.

## Register Map

The full flattened basis is `8*signal + 4*T + 2*tau + S`.  The passive `S`
bit is preserved.  The reduced active-register value is
`4*signal + 2*T + tau`, so reduced bit `0` is `tau`, bit `1` is `T`, and bit
`2` is `signal`.

## Circuit Schema

The COLD-local logical reversible transcript is:

```text
X_T; CCX_{tau,T -> signal}; X_tau; CX_{signal -> T}; CX_{tau -> signal}
```

Lean names:

```lean
mainCaseColdCircuit
mainCaseColdSchedule
mainCaseColdReducedGateImages
mainCaseColdCircuitReducedImage
mainCaseColdCircuitImage
```

## Closed Lean Leaves

```lean
theorem mainCaseColdReducedGateImages_eval :
    forall x : Fin 8,
      mainCaseColdCircuitReducedImage x =
        mainCaseColdPartialPermReducedImage x

theorem mainCaseColdCircuitImage_eq_partialPermImage :
    forall x : Fin 16,
      mainCaseColdCircuitImage x = mainCaseColdPartialPermImage x
```

The first theorem checks the reduced eight-state table.  The second theorem
lifts that table to the full `Fin 16` signal-system basis and proves it equals
the already certified COLD finite permutation.

## Resource Tuple

Counting convention: high-level logical `{X,CNOT,Toffoli}` tier.  Toffoli and
CNOT are counted together as controlled logical gates, matching the main-case
resource convention already used in `QuantumBlockEncoding/MainCase.lean`.

Compiled tuple in score order:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (5, 5, 1, 0)
```

Lean names:

```lean
mainCaseColdHighLevelResource
mainCaseColdPartialPermCost
mainCaseColdPartialPermCost_gateCount
mainCaseColdPartialPermCost_depth
mainCaseColdPartialPermCost_auxiliaryQubits
mainCaseColdPartialPermCost_oracleCalls
```

## Next Route

`MAIN-CANDIDATE-PACKAGE-001`: package a COLD-local
`OperatorBlockEncodingCandidate` and `VerifiedOperatorBlockEncoding` using the
compiled finite-permutation proof, block-projection proof, and resource cost.
Do not start Qiskit/QASM3 export until that named verified candidate compiles.

Gate: `python3 tools/qbe.py check` passed.
