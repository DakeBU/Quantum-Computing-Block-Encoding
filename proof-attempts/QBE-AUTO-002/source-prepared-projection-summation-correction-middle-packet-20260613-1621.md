# 2026-06-13 Middle Packet: Source-Prepared Projection/Summation Correction

Task: `QBE-AUTO-002`  
Run: `20260613-161435-QBE-AUTO-002-cycle01`  
Mode: `faithfulPaper`

## Source Anchors

Use GHL2025 Eq. `arbitrary sparcity`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Theorem `theorem: 1 term robin`, and Definition
`def:block-encoding`.  The local Fig. 4 audit remains
`paper-notes/GHL2025/markdown/fig4-visual-audit.zh.md`.

The full source route is the prepared sparse-register projection route.  The
H-free seven-gate backend component is only a component of the route; it is not
the full Fig. `fig:1 term ROBIN` prepared circuit.

## Retired Leaf

Do not assign:

```lean
oneTermRobinGamma3BoundaryActiveSelectedSlotEvalFeeder_n3 env
```

as a lower2 theorem target.  Lower1 and lower3 showed that this strict feeder
compares different finite paths:

| Side | Lean object | Path |
|---|---|---|
| left | `evalGateMatrices ... row0 row0` | active H-free full-basis entry `[0,0]` |
| right | `selectedSlotContribution` | selected sparse slot `2`, full index `32`, with sparse projection amplitudes |

This is `shape_or_register_gap`.  It is not a raw `Coeff` bridge gap.

## Definitions

- `Uniform(H)` is
  `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
- `SourcePreparedField(H, env)` is
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.
- `PreparedSparseCleanEntry(H, env)` is
  `Coeff.evalWith env (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
  oneTermRobinGamma3BoundarySparseCleanIndex_n3
  oneTermRobinGamma3BoundarySparseCleanIndex_n3)`.
- `ActiveEval(env)` is
  `Coeff.evalWith env ((evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3)`.

The source-shaped active leaf is the field `SourcePreparedField(H, env)`, or
the equivalent uncast sparse-clean equality exposed by:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3
  H env
```

The theorem-facing recovery under the explicit source contract is:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3
  H env hUniform hActive
```

or equivalently:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3
  H env hUniform
```

## Source-Dependency Classification

| Source anchor | Missing ingredient | Classification | Lower decision |
|---|---|---|---|
| Eq. `arbitrary sparcity`; Shukla--Vedula 2024 | clean-column behavior of `H_W^(kappa)` | external cited contract | keep `Uniform(H)` explicit; do not formalize Shukla--Vedula here |
| Eq. `ROBIN clarified` | prepared gamma3 sparse-slot contribution | internal paper step plus QBE-local finite matrix semantics | target prepared sparse-register projection, not H-free row-0 to slot-2 equality |
| Fig. `fig:1 term ROBIN` | both `H_W^(kappa)` sides around the backend component | source circuit transcript | keep full prepared circuit separate from the active seven-gate backend |
| Definition `def:block-encoding` | clean projection of the prepared output | QBE-local finite projection/composition theorem | active lower work |

## Lower-Agent Split

### lower1: Natural-Language Proof Architect

Write a short addendum:

```text
proof-attempts/QBE-AUTO-002/source-prepared-projection-summation-lower1-<timestamp>.md
```

Required content:

| Required item | Expected output |
|---|---|
| corrected proof path | Eq. `arbitrary sparcity` -> prepared sparse register -> Fig. `fig:1 term ROBIN` backend -> prepared clean entry -> backend fold |
| Lean names | map `SourcePreparedField`, `PreparedSparseCleanEntry`, `Uniform(H)`, and evaluated backend recovery to existing declarations |
| retired route note | record why `ActiveEval(env) = SelectedContribution(env)` is `shape_or_register_gap` |
| lower2 recommendation | name exactly one source-shaped Lean target or the diagnostic active column-0 bridge |

Do not edit Lean.  Do not introduce a second register layout.

### lower3: Necessary-Condition Verifier

Write:

```text
verifier-feedback/QBE-AUTO-002/source-prepared-projection-summation-lower3-<timestamp>.json
```

Required fields:

```json
{
  "leaf": "source_prepared_projection_summation_correction",
  "source_correspondence_ok": true,
  "strict_hfree_feeder_retired": true,
  "finite_matrix_ok": "checked|blocked|not_checked",
  "prepared_projection_shape_ok": "checked|blocked|not_checked",
  "uniform_contract_explicit": true,
  "raw_coeff_route_rejected": true,
  "block_entry_ok": false,
  "closed_theorem_ok": false,
  "error_class": "shape_or_register_gap",
  "next_route": "..."
}
```

Use `shape_or_register_gap` if a worker revives the H-free row-0 to slot-2
strict feeder.  Use `symbolic_bridge_gap` only after the target is
source-shaped and the remaining blocker is finite algebra.

### lower2: Lean Implementation Worker

Edit only `QuantumBlockEncoding/RobinMatrix.lean`.

Allowed targets, in priority order:

1. a source-shaped theorem proving `SourcePreparedField(H, env)` under the
   explicit paper contract `hUniform : Uniform(H)`;
2. one strict finite lemma that directly feeds
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSparseCleanEntry_n3 H env`;
3. the diagnostic active `[0,0]` bridge:

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatricesColumn0Entry_eq_sevenGateMatrix_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      ((evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (oneTermParameters 3)))
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3) =
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3
        oneTermRobinGamma3BoundaryPrefixRow0_n3)
```

The diagnostic bridge is a guard only.  It must not be used to claim the
theorem-facing projection, evaluated backend fold, or final one-term theorem.

After any Lean edit, run:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
```

## Reject Routes

Reviewer should reject any attempt that:

- proves `ActiveEval(env) = SelectedContribution(env)` directly;
- adds `hUniform` to the retired strict feeder instead of using it only in the
  source-prepared route;
- treats the H-free seven-gate backend component as the full Fig. 4 circuit;
- uses `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` or
  `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as theorem
  closure;
- changes the paper circuit, gate order, oracle contracts, normalizer, or
  theorem assumptions;
- promotes oracle, `H_W`, `R_y`, LCU/QSVT, unitarity, block-projection,
  product-to-coefficient, final-extraction, or normalizer flags.

The first-case-study one-term theorem remains open.
