# Theorem-Facing Finite Block Projection Interface Middle Synthesis

Task: `QBE-AUTO-002`  
Run: `20260615-052017-QBE-AUTO-002-cycle01`  
Role: middle coordinator synthesis  
Mode: `faithfulPaper`  
Prepared: `2026-06-15 05:25 JST`

## Definitions

`SourcePreparedProjectionTarget(H, env)` is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.

`FiniteBlockContract` is `oneTermRobinFiniteBlockCompositionContract 3`.
Its current claim uses `oneTermRobinCircuitSemantics 3`, so it remains tied to
the active seven-gate backend.

`CompiledContractAudit(H, env)` is
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env`.
It records that the theorem-facing Fig. 4 transcript and the active backend
transcript are distinct, and it keeps all theorem-facing semantic flags false.

## Source Correspondence

The source anchors remain GHL2025 Eq. `arbitrary sparcity`, Eq. `angles for
Ry`, Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term
ROBIN`, and Definition `def:block-encoding`.

The focused finite branch is fixed to system entry `(0,0)`, sparse slot `2`,
signal block `[0,0]`, branch basis `[32,32]`, the source-prepared projection
target, and normalizer $N_D N_f \kappa$.

Lower1 validated this source map in
`proof-attempts/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-lower1-proof-architect-20260615-051627.md`.
Lower3 accepted the necessary guards in
`verifier-feedback/QBE-AUTO-002/theorem-facing-finite-block-projection-interface-lower3-20260615-051821.json`.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_projection_target` | Clean source-prepared projection for system `(0,0)`, sparse slot `2`, branch `[32,32]`. | prepared composite semantics, clean sparse index, $H_W^{(\kappa)}$ clean-column contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | source-prepared projection packets | previous gate | compiled route memory |
| `theorem_facing_contract_audit` | Records theorem-facing Fig. 4 versus active backend transcript split and false theorem flags. | theorem-facing gate-list guard, active backend guard, finite block contract | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | theorem-facing audit packets | previous gate | compiled route memory; stale as lower work |
| `theorem_facing_finite_block_projection_interface` | Non-promoting packet tying `SourcePreparedProjectionTarget(H, env)`, `FiniteBlockContract`, and `CompiledContractAudit(H, env)` together while recording the missing corrected projection equality. | source-prepared projection target, finite block contract, compiled contract audit, lower3 guard checks | lower2 | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | this synthesis plus lower1 and lower3 artifacts | `python3 tools/qbe.py check` | active Lean leaf |
| `root_product_to_coefficient` | Close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. | corrected theorem-facing finite block/projection equality and final coefficient bridge | later | existing obligation only | proof-obligation ledger | full gate plus proof-map sync | blocked; `proved = false` |

## Lower2 Implementation Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Add only these declarations if they do not already exist:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
```

The interface record should name the source-prepared projection target, the
finite block-composition contract, the compiled theorem-facing contract audit,
the theorem-facing and active backend transcript guards, and the exact
remaining obstruction: a corrected theorem-facing finite block/projection
equality is still missing before
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` can be attempted.

The packet must not replace the Fig. 4 circuit, mutate the active backend
contract, add hypotheses, or promote normalized-block equality, LCU
correctness, block projection, block correctness, final extraction, oracle
correctness, unitarity, resource claims, or product-to-coefficient closure.

If the planned declarations already exist, lower2 should make no Lean edit and
log `error_class=stale_leaf`.

## Source-Dependency Classification

The current blocker is an internal paper-step interface problem:
`source_translation_gap`.  It is not an external cited theorem gap, finite
matrix counterexample, or Lean tactic gap.  The next route is lower2 compiling
the non-promoting projection-interface packet, followed by a separate middle
packet for the corrected theorem-facing finite block/projection equality or
final coefficient bridge.
