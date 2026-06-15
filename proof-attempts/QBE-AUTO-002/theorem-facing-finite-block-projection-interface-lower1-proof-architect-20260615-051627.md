# Theorem-Facing Finite Block Projection Interface Lower1 Packet

Task: `QBE-AUTO-002`  
Run: `20260615-050133-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`  
Created: `2026-06-15 05:16 JST`

## Stale-Leaf Check

The prompt-level theorem-facing finite block contract audit is already compiled
route memory:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript
```

The current task file and proof blueprint select the next non-promoting packet:

```lean
OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
```

This lower1 packet validates the source map and gives the implementation
shape for that projection-interface leaf.  It does not edit Lean and does not
attempt `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Source Fragment

The active paper fragment is GHL2025 Eq. `arbitrary sparcity`, Eq. `angles for
Ry`, Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term
ROBIN`, and Definition `def:block-encoding`.

The sparse-preparation equation is:

$$
H_W^{(\kappa)}\ket{0}^{\lceil \log_2 \kappa \rceil}
=
\frac{1}{\sqrt{\kappa}}
\sum_{s=0}^{\kappa - 1}
\ket{s}^{\lceil \log_2 \kappa \rceil}.
$$

The theorem states a $(\mathcal{N}_D\mathcal{N}_f\kappa,
\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$
block-encoding for the one-term Robin construction.

The focused boundary branch in Eq. `ROBIN clarified` is the $\gamma_3$
boundary summand:

$$
\ket{\gamma_3}
=
\frac{1}{\mathcal{N}_D \mathcal{N}_f \kappa}
\sum_{\substack{s=0,\dots,\kappa-1 \\
0 \leq j < K_1 \cup K_2 < j < 2^n}}
f(x_i) (D)^{(s)}_i \sigma^{(s)}
\ket{0}^{m_f+1}
\ket{s}^{\lceil \log_2 \kappa \rceil}
\ket{0}^{n-\lceil \log_2 \kappa \rceil}
\ket{j}^n
\ket{0}^1
+ \cdots .
$$

Definition `def:block-encoding` says that the clean signal projection of the
unitary supplies the normalized matrix action.  For this packet, the clean
projection must be the theorem-facing source-prepared projection, not the raw
active seven-gate backend entry.

The focused finite branch remains fixed:

| Object | Value |
|---|---|
| system entry | `(0,0)` |
| sparse slot | `2` |
| signal block entry | `[0,0]` |
| branch-local full basis | `[32,32]` |
| source-prepared projection | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env` |
| normalizer | `N_D*N_f*kappa` |

## Definitions

`SourcePreparedProjectionTarget(H, env)` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

Its selected entry is:

```lean
(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
  oneTermRobinGamma3BoundarySparseCleanIndex_n3
  oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

`FiniteBlockContract` is:

```lean
oneTermRobinFiniteBlockCompositionContract 3
```

Its `claim` is built from `defaultOneTermRobinCircuitBlockClaim 3`, hence from
`oneTermRobinCircuitSemantics 3`.

`CompiledContractAudit(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env
```

It records the compiled source fact that
`GHL2025.oneTermRobinTheoremFacingFig4Circuit` is distinct from
`GHL2025.oneTermRobinCircuit`, and it also records that the finite block
contract still uses the active backend.

## Natural-Language Proof Of The Active Local Theorem

The active local theorem is a non-promoting interface packet.  It should
record which theorem-facing projection object must eventually feed the finite
block contract.  It should not assert that the finite block projection equality
is proved.

First, use `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`
and its transcript theorem.  This fixes the clean prepared entry selected by
the full prepared sandwich
`(H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)`.  The target already
records that `preparedSingletonEntrySelected = true`, while
`activeProjectionBackendUsesPreparedEntry = false`,
`activePreparedEntryEqualityProved = false`,
`fullProductFoldProved = false`, and all product, LCU, block, and final flags
remain false.

Second, use `oneTermRobinFiniteBlockCompositionContract 3` and
`oneTermRobinFiniteBlockCompositionContract_transcript 3`.  This supplies the
normalizer `GHL2025.oneTermRobinNormalizer`, the target matrix, and the
contract obligations.  The transcript also keeps `circuitUnitary`,
`lcuComposition`, `blockProjection`, `normalizedBlockEquality`, and
`finalExtraction` false.

Third, use the compiled audit
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env` and
its transcript theorem.  This prevents the interface packet from silently
substituting the active backend for Fig. 4.  The theorem-facing transcript guard
has ten entries, including the sparse-preparation and cleanup sides.  The
active backend has seven entries and is the circuit consumed by
`oneTermRobinCircuitSemantics 3`.

Fourth, attach the existing normalized projection bridge only as route memory:

```lean
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 H env
```

This preserves the fixed branch data and the fixed product obligation, but it
does not prove the finite theorem-facing block/projection equality.

The conclusion is a checked interface statement: the theorem-facing source
projection object and the active finite block contract are both named in one
packet, and the remaining obstruction is explicit.  A corrected theorem-facing
finite block/projection equality is still missing before the root
product-to-coefficient theorem can be attempted.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_projection_target` | Clean theorem-facing prepared projection for system `(0,0)`, slot `2`, branch `[32,32]`. | prepared composite semantics, clean sparse index, `H_W^(kappa)` clean-column contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | source-prepared projection packets | previous gate | compiled route memory |
| `finite_block_contract_active_wiring` | Finite block contract is source-anchored but wired through `oneTermRobinCircuitSemantics 3`. | `defaultOneTermRobinCircuitBlockClaim 3`, finite block contract transcript | none | `oneTermRobinFiniteBlockCompositionContract 3` | conversion window and obligation ledger | previous gate | compiled contract, gap recorded |
| `theorem_facing_contract_audit` | Records Fig. 4 transcript versus active backend split and false theorem flags. | theorem-facing gate-list guard, active backend guard, finite contract, normalized bridge | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | theorem-facing audit packet | previous gate | compiled route memory; stale as lower work |
| `theorem_facing_finite_block_projection_interface` | Non-promoting packet tying `SourcePreparedProjectionTarget(H, env)` to `FiniteBlockContract` and the compiled audit, while keeping all theorem flags false. | source projection target, finite block contract, compiled audit, transcript guards | next lower2 after lower3 | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | this packet and middle 05:07 packet | `python3 tools/qbe.py check` | next active Lean leaf |
| `root_product_to_coefficient` | Close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. | corrected theorem-facing finite block/projection equality and final coefficient bridge | later | existing obligation only | proof-obligation ledger | full gate plus proof-map sync | blocked; `proved = false` |

The next active leaf for a Lean worker is exactly:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
```

## Ordered Lean Lemma Plan

1. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.
2. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript H env` to expose the clean prepared entry, compiled target flags, and false theorem flags.
3. Reuse `oneTermRobinFiniteBlockCompositionContract 3`.
4. Reuse `oneTermRobinFiniteBlockCompositionContract_transcript 3` to expose the normalizer and false finite-composition obligations.
5. Reuse `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env`.
6. Reuse `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript H env` to expose the ten-gate theorem-facing transcript, seven-gate active backend transcript, and active wiring.
7. Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and `GHL2025.oneTermRobinActiveBackendCircuit_gateList` as guard names in the record.
8. Reuse `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 H env` only as compiled route memory.
9. Add only the planned interface structure, `n = 3` packet, and transcript theorem.  The proof should be a record/transcript proof by unfolding the packet and using the transcript lemmas above.

The planned interface record should include fields for the source-prepared
target, finite block contract, compiled audit, `contract.claim.semantics`,
theorem-facing and active backend guard strings, and false flags for
normalized-block equality, product-to-coefficient, LCU correctness, block
projection, block correctness, final extraction, oracle correctness, unitarity,
and resource claims.

## Failure Analysis

The prompt-level audit target is stale because it already compiled.  Repeating
it would be `stale_leaf`.

The root product-to-coefficient target is still not assignable.  The paper
source uses the theorem-facing Fig. 4 route and Definition `def:block-encoding`
for a clean source-prepared projection, while the current finite block contract
still consumes the active backend semantics.  Closing the root theorem through
that active backend contract would hide a source-translation gap.  Proving
`normalizedBlockEquality` or any final coefficient statement here would be an
invalid route.

The corrected route is to compile the non-promoting projection-interface
packet first.  After that, middle should prepare a real finite
block/projection equality or a final coefficient bridge as a separate leaf.

## Typed Feedback

```text
leaf=theorem_facing_finite_block_projection_interface
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=not_attempted_interface_packet_only
block_entry_ok=blocked_by_missing_theorem_facing_finite_block_projection_equality
ancilla_cleanup_ok=null
normalizer_ok=N_D*N_f*kappa_preserved_no_equality_promoted
closed_theorem_ok=false
error_class=source_translation_gap
next_route=lower3 verifies source-prepared projection target, compiled audit, active backend wiring, and false flags; lower2 compiles only the non-promoting projection-interface packet in QuantumBlockEncoding/RobinMatrix.lean
```

## Handoff

Lower2 should not reassign the compiled audit packet and should not attack
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The active Lean
leaf is the theorem-facing finite block/projection interface.  Its purpose is
to place the source-prepared clean projection target, the active-wired finite
block contract, and the compiled audit in one non-promoting record, leaving the
corrected finite block/projection equality open.
