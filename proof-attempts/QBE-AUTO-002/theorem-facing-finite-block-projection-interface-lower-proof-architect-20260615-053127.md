# Theorem-Facing Finite Block Projection Interface Lower Proof Architect

Task: `QBE-AUTO-002`  
Run: `20260615-052017-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `faithfulPaper`  
Created: `2026-06-15 05:31 JST`

## Source Fragment

The source fragment is GHL2025 Eq. `arbitrary sparcity`, Eq. `angles for Ry`,
Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and Definition `def:block-encoding`.

The sparse-preparation line is:

$$
H_W^{(\kappa)}\ket{0}^{\lceil \log_2 \kappa \rceil}
=
\frac{1}{\sqrt{\kappa}}
\sum_{s=0}^{\kappa - 1}\ket{s}^{\lceil \log_2 \kappa \rceil}.
$$

The boundary rotation line is:

$$
\theta_j^s =
\arccos\left(\frac{D_j^{(s)}}{\mathcal{N}_D}\right),
\quad
s=0,\dots,\kappa-1,\quad
j=0,\dots,K_1-1,K_2+1,\dots,2^n-1.
$$

The one-term Robin theorem states a
$(\mathcal{N}_D\mathcal{N}_f\kappa,
\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+
\lceil\log_2\kappa\rceil+4,0)$ block-encoding of
$A_k \sim f(x)\partial^m/\partial x^m$.

The focused displayed branch is the boundary part of
Eq. `ROBIN clarified`:

$$
\ket{\gamma_3}
=
\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
\sum_{\substack{s=0,\dots,\kappa-1\\
0 \leq j < K_1 \cup K_2 < j < 2^n}}
f(x_i)(D)_i^{(s)}\sigma^{(s)}
\ket{0}^{m_f+1}
\ket{s}^{\lceil\log_2\kappa\rceil}
\ket{0}^{n-\lceil\log_2\kappa\rceil}
\ket{j}^n
\ket{0}^1
+ \cdots .
$$

Definition `def:block-encoding` is the clean projection condition:

$$
(\bra{0}^s \otimes I)\ket{\phi}^{n+s}
=
\tilde{A}\ket{\psi},
\qquad
\|A-\alpha\tilde{A}\|\leq\epsilon .
$$

Fig. `fig:1 term ROBIN` supplies the theorem-facing transcript.  The figure
audit records the sparse-preparation side `H_W^(kappa)`, the derivative and
boundary middle, `O_f`, `SWAP`, sparse-access cleanup, and the final
`(H_W^(kappa))^dagger` projection side.  This is not identical to the active
seven-gate backend object used by the current finite matrix contract.

## Definitions

`SourcePreparedProjectionTarget(H, env)` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

Its prepared clean entry is the clean-clean entry of:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H
```

at:

```lean
oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

`FiniteBlockContract` is:

```lean
oneTermRobinFiniteBlockCompositionContract 3
```

The current contract claim uses:

```lean
oneTermRobinCircuitSemantics 3
```

which is the active seven-gate backend semantics.

`CompiledContractAudit(H, env)` is:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env
```

It records that:

```lean
GHL2025.oneTermRobinTheoremFacingFig4Circuit
```

is distinct from:

```lean
GHL2025.oneTermRobinCircuit
```

and keeps product-to-coefficient, normalized-block equality, LCU correctness,
block projection, block correctness, final extraction, oracle correctness,
unitarity, and resource claims false.

## Natural-Language Proof Of The Active Local Theorem

The active local theorem is an interface packet, not a finite block equality.
Its job is to make the source-prepared projection target, the finite
block-composition contract, and the compiled contract audit simultaneously
visible to Lean without changing any theorem-facing semantic flag.

First, instantiate `SourcePreparedProjectionTarget(H, env)`.  This fixes the
theorem-facing clean entry selected by the prepared sandwich
`H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)`.  For the current finite
branch, the source map remains system entry `(0,0)`, sparse slot `2`, signal
block `[0,0]`, branch basis `[32,32]`, and normalizer
$N_D N_f \kappa$.

Second, instantiate `FiniteBlockContract`.  Its source anchors are the one-term
Robin theorem, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`, but its current `claim.semantics` is
`oneTermRobinCircuitSemantics 3`.  Therefore the interface packet must record
the active backend wiring instead of silently replacing it with the full Fig. 4
circuit.

Third, instantiate `CompiledContractAudit(H, env)`.  The audit already checks
the ten-gate theorem-facing transcript guard, the seven-gate active backend
guard, and the fact that the finite block contract still consumes the active
backend.  The interface packet can reuse that audit as route memory.

Fourth, the transcript theorem for the new interface packet should unfold the
record and prove only field equalities and false-flag equalities.  It should
not assert the missing theorem-facing finite block/projection equality.  The
remaining obstruction field should state that a corrected finite
block/projection equality is still required before
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` can be attempted.

This proves the active local theorem in the only faithful sense available for
this leaf: all relevant objects are named together, the source/backend mismatch
is explicit, and every semantic closure flag remains false.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_projection_target` | Clean source-prepared projection for system `(0,0)`, sparse slot `2`, signal block `[0,0]`, branch `[32,32]`. | prepared composite semantics, clean sparse index, external $H_W^{(\kappa)}$ clean-column contract | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` | source-prepared projection packets and current conversion window | previous `python3 tools/qbe.py check` | compiled route memory |
| `finite_block_contract_active_wiring` | Finite block contract remains wired to active seven-gate semantics. | `defaultOneTermRobinCircuitBlockClaim 3`, `oneTermRobinCircuitSemantics 3`, finite contract transcript | none | `oneTermRobinFiniteBlockCompositionContract 3` | conversion window and proof-obligation ledger | previous gate | compiled contract; source-translation gap recorded |
| `theorem_facing_contract_audit` | Guard theorem-facing Fig. 4 transcript versus active backend transcript and keep flags false. | theorem-facing gate-list guard, active backend gate-list guard, finite block contract, normalized projection bridge | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3` | theorem-facing contract-audit packet | previous gate | compiled route memory; stale as lower work |
| `theorem_facing_finite_block_projection_interface` | Non-promoting interface tying `SourcePreparedProjectionTarget(H, env)`, `FiniteBlockContract`, and `CompiledContractAudit(H, env)` together while recording the missing corrected projection equality. | source projection target, finite block contract, compiled audit, lower3 necessary-condition feedback | lower2 | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` | middle 05:25 synthesis plus this note | `python3 tools/qbe.py check` | next active Lean leaf |
| `corrected_finite_block_projection_equality` | Prove the theorem-facing clean projection equality that the interface only records as missing. | compiled interface packet, prepared-entry backend bridge, finite composition semantics | later middle/lower split | not yet named | future proof-attempt packet | full gate | blocked internal |
| `root_product_to_coefficient` | Close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. | corrected finite block/projection equality and final coefficient/normalizer bridge | later | existing obligation only | proof-obligation ledger | full gate plus proof-map sync | blocked; `proved = false` |

The next active leaf for a Lean worker is exactly:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
```

## Ordered Lean Lemma Plan

1. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.
2. Reuse `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript H env`.
3. Reuse `oneTermRobinFiniteBlockCompositionContract 3`.
4. Reuse `oneTermRobinFiniteBlockCompositionContract_transcript 3`.
5. Reuse `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3 H env`.
6. Reuse `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3_transcript H env`.
7. Reuse `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` and `GHL2025.oneTermRobinActiveBackendCircuit_gateList`.
8. Reuse `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3 H env` only as compiled route memory.
9. Add only `OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface`, `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`, and `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript`.

The new record should contain fields for the source-prepared projection target,
finite block contract, compiled audit, contract claim semantics, theorem-facing
and active backend guard names, the source/backend mismatch status, and false
flags for normalized-block equality, product-to-coefficient, LCU correctness,
block projection, block correctness, final extraction, oracle correctness,
unitarity, and resources.

The transcript proof should be a record-unfolding proof using existing
transcript theorems and reflexivity.  No new mathematical assumption is needed.

## Failure Analysis

The root target
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` is mathematically
premature for this leaf.  The paper source uses the clean theorem-facing Fig. 4
projection, while the current finite block contract still consumes the active
seven-gate backend semantics.  Proving the root through the active contract
before naming and correcting this interface would hide a source-translation
gap.

The unchanged backend-expansion route is also not an allowed substitute.  It
has compiled no-go memory and must stay diagnostic unless a future corrected
projection/backend theorem is named by middle.

If lower2 finds that the planned interface declarations already exist, the
right response is `error_class=stale_leaf` and no Lean edit.  If they do not
exist, lower2 should compile exactly the non-promoting interface packet above.

## Typed Feedback

```text
leaf=theorem_facing_finite_block_projection_interface
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=interface_only
ancilla_cleanup_ok=true
normalizer_ok=true
closed_theorem_ok=false
error_class=source_translation_gap
next_route=lower2 compiles only the non-promoting theorem-facing finite block/projection interface packet in QuantumBlockEncoding/RobinMatrix.lean; then middle prepares a separate corrected finite block/projection equality leaf
```

## Handoff

This lower proof-architect pass makes no Lean edit.  The active Lean leaf is
still the theorem-facing finite block/projection interface packet.  It should
name the source-prepared clean projection target, the active-wired finite block
contract, and the compiled contract audit in one record, while leaving the
corrected finite block/projection equality and the root product-to-coefficient
obligation open.
