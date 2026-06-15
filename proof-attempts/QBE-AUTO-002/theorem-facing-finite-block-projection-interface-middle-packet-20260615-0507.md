# Theorem-Facing Finite Block Projection Interface Middle Packet

Task: `QBE-AUTO-002`  
Mode: `faithfulPaper`  
Prepared: `2026-06-15 05:07 JST`

## Definitions

`TheoremFacingFig4Circuit` is
`GHL2025.oneTermRobinTheoremFacingFig4Circuit`.

`ActiveBackendCircuit` is `GHL2025.oneTermRobinCircuit`, the active seven-gate
backend used by `oneTermRobinCircuitSemantics 3`.

`FiniteBlockContract` is `oneTermRobinFiniteBlockCompositionContract 3`.  Its
source anchor names the one-term Robin theorem, Fig. 4, and Definition
`def:block-encoding`, but its current `claim.semantics` is
`oneTermRobinCircuitSemantics 3`.

`SourcePreparedProjectionTarget(H, env)` is
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.  It is
the theorem-facing clean projection target for the prepared sandwich
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)`.

`CompiledContractAudit(H, env)` is
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env`.
It is compiled route memory.  It records the Fig. 4 versus active-backend
transcript split and keeps every theorem-facing semantic flag false.

## Source Audit

The source anchors remain:

| Anchor | Source-facing role | Lean-facing status |
|---|---|---|
| Eq. `arbitrary sparcity` | $H_W^{(\kappa)}$ sparse-slot state preparation | external contract route only |
| Theorem `theorem: 1 term robin` | normalizer $N_D N_f \kappa$ and resource claim | root theorem open |
| Eq. `ROBIN clarified` | focused boundary gamma3 branch coefficient | finite branch route only |
| Fig. `fig:1 term ROBIN` | full theorem-facing circuit transcript | transcript guard compiled |
| Definition `def:block-encoding` | clean block projection equation | finite interface still needs correction |

The compiled audit shows a source-translation gap: the paper fragment is
theorem-facing, while the finite block-composition contract is wired to the
active backend component.  The next packet must name this interface explicitly
without substituting the Fig. 4 circuit into the active backend contract and
without proving normalized-block equality.

## Proof-DAG Frontier

| Node | Interface statement | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `finite_source_prepared_normalized_projection_bridge` | source-prepared normalized projection packet for system entry `(0,0)`, sparse slot `2`, branch `[32,32]` | conditional normalizer bridge, finite projection product bridge, source-prepared product/projection packet, finite block contract | none | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` | finite-normalized-projection packets | previous `python3 tools/qbe.py check` | compiled route memory; stale as lower work |
| `theorem_facing_finite_block_contract_audit` | audit of Fig. 4 source transcript versus active backend finite contract wiring | transcript guards, finite block contract, normalized projection bridge | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | theorem-facing audit packets | previous `python3 tools/qbe.py check` | compiled route memory |
| `theorem_facing_finite_block_projection_interface` | non-promoting interface tying `SourcePreparedProjectionTarget(H, env)` to `FiniteBlockContract` while recording the active-backend wiring gap | compiled contract audit; source-prepared projection target; finite block contract transcript; false theorem flags | lower2 after lower1/lower3 checks | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `root_product_to_coefficient` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | corrected theorem-facing finite block/projection interface and final coefficient bridge | later | existing obligation only | proof-obligation ledger | full gate plus proof-map sync | blocked; `proved = false` |

## Lower-Agent Packet

### lower1

Validate the source dependency map for the interface leaf.  Keep the focused
finite branch fixed to system entry `(0,0)`, sparse slot `2`, signal block
entry `[0,0]`, branch basis `[32,32]`, source-prepared projection target, and
normalizer $N_D N_f \kappa$.  Confirm that this packet records an interface
gap; it is not a normalized-block equality proof and not a replacement circuit.

### lower3

Before lower2 edits Lean, verify these necessary conditions:

- `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and
  `GHL2025.oneTermRobinActiveBackendCircuit_gateList` remain distinct compiled
  guards;
- `oneTermRobinFiniteBlockCompositionContract 3` still consumes
  `oneTermRobinCircuitSemantics 3`;
- `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` and
  `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3`
  compile and keep product, LCU, block, final, oracle, unitary, resource, and
  normalized equality flags false;
- the source-prepared projection target still selects the prepared clean entry
  before the backend fold;
- raw backend expansion, `SignalEntryFold` equivalents, diagnostic `sorry`
  routes, root product-to-coefficient closure, normalized-block equality, final
  extraction, oracle correctness, unitarity, and resource claims remain
  forbidden.

### lower2

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.

Planned declarations:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
```

The packet should be non-promoting.  It should record:

- `SourcePreparedProjectionTarget(H, env)`;
- `FiniteBlockContract`;
- `CompiledContractAudit(H, env)`;
- the theorem-facing and active backend transcript guards;
- the fact that the current contract still uses active backend semantics;
- the exact remaining obstruction: a corrected theorem-facing finite
  block/projection equality is still missing before
  `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

The packet must not replace the paper circuit, mutate the active backend
contract, add hypotheses, or promote normalized-block equality, LCU
correctness, block projection, block correctness, final extraction, oracle
correctness, unitarity, resource claims, or product-to-coefficient closure.

If the planned declarations already exist, lower2 should make no Lean edit and
log `error_class=stale_leaf`.

## Source-Dependency Classification

The blocker is an internal paper-step interface problem.  The paper has a
theorem-facing Fig. 4 circuit and a block-encoding projection definition; the
current Lean finite block-composition contract is source-anchored to that
fragment but still bound to active backend semantics.  This is a
`source_translation_gap`, not an external cited theorem gap and not a tactic
failure.

The next route is to compile the non-promoting interface packet above.  Only
after that packet exists should lower work target a real finite
block/projection equality or final coefficient bridge for the root obligation.
