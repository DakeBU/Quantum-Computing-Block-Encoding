# Verifier Feedback: COLD Resource Schema Cycle 3

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Leaf: `MAIN-RESOURCE-001`

## Result

The resource leaf now compiles under task-local `mainCaseCold*` declarations.
The COLD logical transcript is

```text
X_T; CCX_{tau,T -> signal}; X_tau; CX_{signal -> T}; CX_{tau -> signal}
```

with full wire layout `S = 0`, `tau = 1`, `T = 2`, and `signal = 3`.
The reduced active-register convention is `(tau,T,signal)`, encoded as
`4*signal + 2*T + tau`.

Lean proves:

```lean
theorem mainCaseColdReducedGateImages_eval :
    forall x : Fin 8,
      mainCaseColdCircuitReducedImage x =
        mainCaseColdPartialPermReducedImage x

theorem mainCaseColdCircuitImage_eq_partialPermImage :
    forall x : Fin 16,
      mainCaseColdCircuitImage x = mainCaseColdPartialPermImage x
```

The high-level logical resource tuple is certified by:

```lean
mainCaseColdPartialPermCost_gateCount       -- 5
mainCaseColdPartialPermCost_depth           -- 5
mainCaseColdPartialPermCost_auxiliaryQubits -- 1
mainCaseColdPartialPermCost_oracleCalls     -- 0
```

The old `mainCaseColdResourceSchemaObligation` boolean was not promoted.  The
accepted resource evidence is the compiled circuit-image theorem plus the cost
field theorems.

## Typed Fields

| Field | Value |
|---|---|
| `leaf` | `MAIN-RESOURCE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` |
| `lean_build_ok` | `true` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `finite_permutation_tier_true` |
| `resource_score` | `{ "gate_count": 5, "depth": 5, "auxiliary_qubits": 1, "oracle_calls": 0 }` |
| `closed_theorem_ok` | `true` |
| `error_class` | `null` |
| `next_route` | `MAIN-CANDIDATE-PACKAGE-001`: package `mainCaseColdPartialPermCandidate` and `mainCaseColdPartialPermVerified` from the compiled finite-permutation, block-projection, and resource declarations. |

Gate: `python3 tools/qbe.py check` passed.
