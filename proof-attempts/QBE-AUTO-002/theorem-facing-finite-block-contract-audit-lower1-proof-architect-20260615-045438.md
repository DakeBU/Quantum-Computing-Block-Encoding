# Theorem-Facing Finite Block Contract Audit Lower1 Packet

Task: `QBE-AUTO-002`
Run: `20260615-043649-QBE-AUTO-002-cycle01`
Role: lower natural-language proof architect
Mode: `faithfulPaper`
Created: `2026-06-15 04:54 JST`

## Stale-Leaf Check

The prompt-level finite normalized projection leaf is already compiled route
memory:

```lean
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript
```

The current task, conversion window, proof-obligation ledger, and dialogue
board all route the next lower work to:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript
```

This lower1 packet therefore validates the source map for the new audit leaf.
It does not assign the retired finite normalized projection packet again.

## Source Fragment

The active source-paper fragment is GHL2025 Theorem
`theorem: 1 term robin`, Eq. `arbitrary sparcity`, Eq. `angles for Ry`,
Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.

The local TeX check gives these anchors:

| Source anchor | Local source range | Proof role |
|---|---:|---|
| Eq. `arbitrary sparcity` | `main.tex:948-955` | $H_W^{(\kappa)}$ prepares the sparse slot register uniformly. |
| Eq. `angles for Ry` | `main.tex:1077-1085` | Boundary branch coefficients are routed through controlled $R_y$ rotations. |
| Theorem `theorem: 1 term robin` | `main.tex:1098-1109` | The theorem normalizer is $\mathcal{N}_D\mathcal{N}_f\kappa$ and the theorem is about the one-term Robin circuit. |
| Eq. `ROBIN clarified` | `main.tex:1111-1119` | The displayed $\gamma_3$ boundary branch carries the coefficient factor $1/(\mathcal{N}_D\mathcal{N}_f\kappa)$. |
| Fig. `fig:1 term ROBIN` | `main.tex:1122-1164` | The theorem-facing circuit includes sparse preparation/cleanup, indicator cleanup, boundary rotations, $O_f$, swap, and sparse-access cleanup. |
| Definition `def:block-encoding` | `main.tex:2027-2035` | The clean signal projection defines the block-encoding target. |

For the focused finite witness, the branch remains fixed:

| Object | Value |
|---|---|
| system entry | `(0,0)` |
| sparse slot | `2` |
| branch-local full basis | `[32,32]` |
| signal block entry | `[0,0]` |
| source-prepared projection | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| normalizer | `N_D*N_f*kappa` |

## Definitions

`TheoremFacingFig4Circuit` is:

```lean
GHL2025.oneTermRobinTheoremFacingFig4Circuit
```

Its transcript guard is:

```lean
GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList
```

`ActiveBackendCircuit` is:

```lean
GHL2025.oneTermRobinCircuit
```

Its transcript guard is:

```lean
GHL2025.oneTermRobinActiveBackendCircuit_gateList
```

`ActiveBackendSemantics` is:

```lean
oneTermRobinCircuitSemantics 3
```

`FiniteBlockContract` is:

```lean
oneTermRobinFiniteBlockCompositionContract 3
```

It is source-anchored to the GHL2025 one-term theorem and Fig. 4, but its
claim is currently built from `defaultOneTermRobinCircuitBlockClaim 3`, hence
from `oneTermRobinCircuitSemantics 3` and the active backend circuit.

`CompiledNormalizedProjectionBridge(H, env)` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 H env
```

It attaches the source-prepared projection route to the finite block contract
without proving `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Natural-Language Proof Of The Active Local Theorem

The active local theorem is an audit packet, not a block-encoding theorem:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3
```

The recommended Lean interface takes `(H : Matrix 8 8 Coeff)` and
`(env : String -> Rat)` if the record stores the compiled normalized projection
bridge object itself.  If lower2 stores only declaration names, those arguments
are not needed.  The source-faithful option is to store the bridge object and
use the same `(H, env)` parameters.

The proof is a record/transcript proof.

First, unfold the theorem-facing and active backend transcript guards.  The
theorem-facing list begins with `H_W^(kappa)` and ends with
`(H_W^(kappa))^dagger`; the active backend list is the seven-gate component
used by `oneTermRobinCircuitSemantics 3`.  These lists are distinct.  This
matches the Fig. 4 visual audit and prevents calling the active backend the
full theorem-facing circuit.

Second, unfold `oneTermRobinCircuitSemantics 3`.  Its `circuit` field is
`GHL2025.oneTermRobinCircuit`.  Therefore any finite block-composition
contract whose claim uses `oneTermRobinCircuitSemantics 3` is wired to the
active backend component.

Third, unfold `oneTermRobinFiniteBlockCompositionContract 3` and reuse
`oneTermRobinFiniteBlockCompositionContract_transcript 3`.  This confirms the
theorem source anchor and the normalizer `GHL2025.oneTermRobinNormalizer`, but
it also confirms that `circuitUnitary`, `lcuComposition`, `blockProjection`,
`normalizedBlockEquality`, and `finalExtraction` all have `proved = false`.

Fourth, attach the compiled normalized projection bridge by reusing
`oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 H env`
and its transcript theorem.  This carries the focused branch data
`(0,0)`, sparse slot `2`, signal block `[0,0]`, branch basis `[32,32]`, and
the fixed product obligation, while keeping `FixedProductObligation.proved`,
`productToCoefficientProved`, and every downstream semantic flag false.

Fifth, record the no-go route by name:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
```

The audit packet must not consume the raw backend expansion, any
`SignalEntryFold`-equivalent statement, or any diagnostic theorem with `sorry`
to close the paper-facing route.

The conclusion is not a proof of normalized-block equality.  It is a checked
audit statement: the source-facing anchors point to the full Fig. 4 circuit,
while the current finite block-composition contract is wired to the active
backend component.  The next Lean worker should compile this as non-promoting
route memory and leave the root product-to-coefficient obligation open.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `finite_source_prepared_normalized_projection_bridge` | Source-prepared normalized projection packet for system `(0,0)`, sparse slot `2`, branch `[32,32]`. | conditional normalizer bridge; finite projection product bridge; source-prepared product/projection packet; finite block contract | none | `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` | finite-normalized-projection packets | previous `python3 tools/qbe.py check` | compiled route memory; stale as lower work |
| `theorem_facing_transcript_guard` | Full Fig. 4 source transcript is represented separately from the active backend. | Fig. 4 source audit | none | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | Fig. 4 visual audit and current middle packet | previous gate | compiled guard |
| `active_backend_transcript_guard` | Active backend is the seven-gate component used by finite semantics. | active backend source map | none | `GHL2025.oneTermRobinActiveBackendCircuit_gateList` | Fig. 4 visual audit and current middle packet | previous gate | compiled guard |
| `finite_block_contract_active_wiring` | `oneTermRobinFiniteBlockCompositionContract 3` is source-anchored to the theorem but wired through `oneTermRobinCircuitSemantics 3`. | finite block contract transcript; active backend semantics | lower2 audit packet | planned audit transcript field | this packet | `python3 tools/qbe.py check` | active dependency inside audit leaf |
| `theorem_facing_finite_block_contract_audit` | Non-promoting packet recording theorem-facing anchors, active backend wiring, compiled normalized projection bridge, and false theorem flags. | transcript guards; finite block contract; normalized projection bridge; raw backend no-go | lower2 after lower3 verifier | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | this packet and middle packet | `python3 tools/qbe.py check` | next active Lean leaf |
| `root_product_to_coefficient` | Close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. | corrected theorem-facing finite block/projection interface plus final coefficient bridge | later | existing obligation only | proof-obligation ledger | full gate plus proof-map sync | blocked; `proved = false` |

The next active leaf for a Lean worker is exactly:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3
```

## Ordered Lean Lemma Plan

1. Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`.
2. Reuse `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
3. Prove inside the audit transcript, by `native_decide` after unfolding the
   two lists if needed, that the theorem-facing and active backend circuits
   are distinct.  This can remain a field in the packet rather than a global
   theorem unless it recurs.
4. Reuse `oneTermRobinCircuitSemantics 3` to expose that the active finite
   semantics consumes `GHL2025.oneTermRobinCircuit`.
5. Reuse `defaultOneTermRobinCircuitBlockClaim 3` to expose that the finite
   block claim is built from `oneTermRobinCircuitSemantics 3`.
6. Reuse `oneTermRobinFiniteBlockCompositionContract 3` and
   `oneTermRobinFiniteBlockCompositionContract_transcript 3` for the theorem
   anchor, target matrix, normalizer, and false finite-composition flags.
7. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 H env`
   and
   `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript H env`
   to attach the compiled finite normalized projection packet without
   promoting product-to-coefficient closure.
8. Reuse `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` only as
   a no-go guard for the raw backend-expansion route.
9. Add only the audit record, the `n = 3` audit packet, and its transcript:
   `OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit`,
   `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3`, and
   `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript`.

## Failure Analysis

The current root target should not be attacked directly.  The paper fragment
is theorem-facing: Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`,
Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding` refer to the
full Fig. 4 construction.  The current Lean finite block-composition contract
is still wired through `oneTermRobinCircuitSemantics 3`, whose circuit is the
active seven-gate backend.  That is a source-translation gap, not a Lean tactic
gap and not an external cited theorem gap.

It would be mathematically wrong to close `normalizedBlockEquality` or
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` using the drifted
active-backend contract.  It would also be wrong to replace the paper circuit
with the active backend, to add assumptions, or to revive the refuted raw
backend expansion route.

The correct route is to compile the non-promoting audit packet first, then
prepare a corrected theorem-facing finite block/projection interface.  The
finite normalized projection bridge remains useful route memory, but it is not
the final theorem-facing block-encoding proof.

## Typed Feedback

```text
leaf=theorem_facing_finite_block_contract_audit
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=not_attempted_contract_audit_only
block_entry_ok=blocked_by_theorem_facing_vs_active_backend_wiring
ancilla_cleanup_ok=null
normalizer_ok=N_D*N_f*kappa_preserved_no_equality_promoted
closed_theorem_ok=false
error_class=source_translation_gap
next_route=lower3 verifies transcript guards and false flags; lower2 compiles only one non-promoting audit packet in QuantumBlockEncoding/RobinMatrix.lean
```

## Handoff

Lower2 should not reassign
`oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3`; it is
compiled.  The active leaf is the theorem-facing finite block contract audit.
The audit should record the Fig. 4 transcript guard, the active backend guard,
the active wiring of `oneTermRobinFiniteBlockCompositionContract 3`, the
compiled normalized projection bridge, and all false theorem flags.  The root
product-to-coefficient theorem remains open.
