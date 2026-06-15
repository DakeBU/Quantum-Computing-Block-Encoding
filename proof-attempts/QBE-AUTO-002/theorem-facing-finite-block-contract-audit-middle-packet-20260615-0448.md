# Theorem-Facing Finite Block Contract Audit Middle Packet

Task: `QBE-AUTO-002`  
Mode: `faithfulPaper`  
Prepared: `2026-06-15 04:48`

## Definitions

`GHL2025.oneTermRobinTheoremFacingFig4Circuit` is the source-facing Fig. 4
transcript.  It includes the $\kappa$-uniform preparation/unpreparation gates,
the indicator uncomputation, the diagonal and boundary sparse oracles, the
coefficient oracle, and the swap layer.

`GHL2025.oneTermRobinCircuit` is the active seven-gate backend component used
by `oneTermRobinCircuitSemantics`.  It is useful compiled route memory, but it
is not the full theorem-facing Fig. 4 transcript.

`oneTermRobinFiniteBlockCompositionContract 3` is currently source-anchored to
the one-term Robin theorem/Fig. 4 and the block-encoding definition, but its
`claim.semantics` is wired through `oneTermRobinCircuitSemantics 3`, hence
through the active seven-gate backend.

`oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` is now
compiled route memory.  It records the finite normalized projection bridge
without promoting any theorem-facing equality.

## Source Audit

The local GHL2025 source supports the following anchors:

| Anchor | Source-facing role | Lean-facing status |
|---|---|---|
| Eq. `arbitrary sparcity` | $\kappa$-uniform sparse-slot state preparation $H_W^{(\kappa)}$ | external contract route only |
| Theorem `theorem: 1 term robin` | block-encoding normalizer $N_D N_f \kappa$ and resource statement | root theorem still open |
| Eq. `ROBIN clarified` | boundary $\gamma_3$ coefficient branch plus omitted bulk branches | finite boundary branch route only |
| Fig. `fig:1 term ROBIN` | full theorem-facing circuit transcript | Lean transcript guard exists |
| Definition `def:block-encoding` | block projection equation | finite block-composition contract target |

The Fig. 4 visual audit separates the full theorem-facing transcript from the
active seven-gate backend.  This makes the current finite block-composition
contract a source-translation gap for theorem closure: it has theorem-facing
anchors but active-backend semantics.

## Proof-DAG Frontier

| Node | Interface statement | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `finite_source_prepared_normalized_projection_bridge` | source-prepared normalized projection packet for system entry `(0,0)`, sparse slot `2`, branch `[32,32]` | conditional normalizer bridge, finite projection product bridge, source-prepared product/projection obligation, `oneTermRobinFiniteBlockCompositionContract 3` | compiled lower2 route | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` | this packet, prior finite-normalized-projection packet | `python3 tools/qbe.py check` | compiled route memory |
| `theorem_facing_finite_block_contract_audit` | audit that the finite block-composition contract is source-anchored to Fig. 4 while wired to the active backend | theorem-facing and active backend transcript guards, normalized projection packet, false theorem flags | next lower2 | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | this packet and conversion-window update | `python3 tools/qbe.py check` | active leaf |
| `root_product_to_coefficient` | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | corrected theorem-facing finite block/projection contract, final coefficient bridge | blocked | existing obligation only | proof-obligation ledger | full build gate | blocked |

## Lower-Agent Packet

### lower1

Validate the source dependency map.  Keep the proof branch fixed to the
boundary $\gamma_3$ finite example: system entry `(0,0)`, sparse slot `2`,
branch basis `[32,32]`, source-prepared projection, and normalizer
$N_D N_f \kappa$.  Confirm that the next Lean packet is a contract audit, not a
normalized-block equality proof.

### lower3

Before lower2 edits Lean, verify these necessary conditions:

- theorem-facing Fig. 4 transcript and active seven-gate backend transcript are
  distinct compiled guards;
- `oneTermRobinFiniteBlockCompositionContract 3` still uses
  `oneTermRobinCircuitSemantics 3`;
- `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` is
  compiled route memory with product, LCU, block, final, and normalized equality
  flags false;
- raw backend expansion, `SignalEntryFold` equivalents, normalized-block
  equality, final extraction, oracle correctness, unitarity, and resource
  claims remain forbidden.

### lower2

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Planned declarations:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript
```

The packet should be non-promoting.  It may record the theorem-facing gate-list
guard, the active backend gate-list guard, the current finite block-composition
contract wiring, the compiled normalized-projection bridge, and all false
theorem flags.  It must not replace the circuit, mutate the paper contract, or
promote normalized-block equality, LCU correctness, block projection, block
correctness, final extraction, oracle correctness, unitarity, resource claims,
or `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

If the declaration already exists, lower2 should make no Lean edit and log
`error_class=stale_leaf`.

## Source-Dependency Classification

This blocker is an internal paper-step interface problem: the paper has a
theorem-facing Fig. 4 circuit and a block-encoding projection definition, while
the current Lean finite block-composition contract is still bound to the active
backend component.  It is not an external cited theorem gap and not a tactic
failure.  The next route is to compile an explicit contract-audit leaf, then
prepare a corrected theorem-facing finite block/projection interface before
attempting the root product-to-coefficient obligation.
