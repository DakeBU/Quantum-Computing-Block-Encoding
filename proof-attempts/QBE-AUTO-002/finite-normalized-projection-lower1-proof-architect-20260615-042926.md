# Finite Normalized Projection Lower1 Proof Architect Packet

Task: `QBE-AUTO-002`
Run: `20260615-041049-QBE-AUTO-002-cycle01`
Role: lower natural-language proof architect
Mode: `faithfulPaper`
Created: `2026-06-15 04:29 JST`

## Source Fragment

The active source fragment is GHL2025 Theorem `theorem: 1 term robin`,
Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, Eq. `angles for Ry`,
Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`.

The translated paper equations are these anchored fragments.

Eq. `arbitrary sparcity` prepares the sparse slot register:

$$
H_W^{(\kappa)}\ket{0}^{\lceil \log_2 \kappa \rceil}
  = \frac{1}{\sqrt{\kappa}}
    \sum_{s=0}^{\kappa-1}\ket{s}^{\lceil \log_2 \kappa \rceil}.
$$

Eq. `angles for Ry` gives the boundary rotation convention:

$$
\theta_j^s =
  \arccos\left(\frac{D_j^{(s)}}{\mathcal{N}_D}\right),
\quad
s=0,\ldots,\kappa-1,
\quad
j < K_1 \text{ or } K_2 < j.
$$

Theorem `theorem: 1 term robin` claims a
$(\mathcal{N}_D\mathcal{N}_f\kappa,
\lceil\log_2 n\rceil+\lceil\log_2G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$
block-encoding of the one-term operator.

Eq. `ROBIN clarified` gives the displayed gamma3 boundary branch:

$$
\ket{\gamma_3}
= \frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
  \sum_{\substack{s=0,\ldots,\kappa-1\\ j<K_1\ \mathrm{or}\ K_2<j}}
  f(x_i)(D)_i^{(s)}\sigma^{(s)}
  \ket{0}^{m_f+1}\ket{s}^{\lceil\log_2\kappa\rceil}
  \ket{0}^{n-\lceil\log_2\kappa\rceil}\ket{j}^n\ket{0}^1
  + \cdots .
$$

Definition `def:block-encoding` selects the clean signal projection: after
applying $U$ to clean ancillas and the input state, the signal-clean component
is $\tilde A\ket{\psi}$ and the target matrix satisfies
$\|A-\alpha \tilde A\|\leq \epsilon$.

For the current finite witness the source branch is fixed as:

| Source object | Lean-facing value |
|---|---|
| system entry | `(0,0)` |
| sparse slot | `2` |
| branch-local full basis | `[32,32]` |
| signal block entry | `[0,0]` |
| normalizer | `N_D*N_f*kappa` |

## Definitions

`FixedProductObligation` is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`SourcePreparedProjection(H, env)` is:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env)
  .preparedProjectionEntry
```

`ConditionalNormalizerBridge` is:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
```

It proves, under the explicit hypotheses `hUniform`, `hentry`, `hND`, `hNF`,
`hkappa`, and `hkappaSqrt`, that:

```lean
Coeff.evalWith env SourcePreparedProjection(H, env) *
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.theoremNormalizer =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.expectedTargetEntry
```

`FiniteProjectionProductBridge` is:

```lean
oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
```

It records that Definition `def:block-encoding` reads the signal-zero block
entry at full `[0,0]`, while the focused branch product has been calculated at
the embedded sparse-slot entry `[32,32]`.  This is an index and obligation
packet, not the missing sparse-branch summation theorem.

## Natural-Language Proof Of The Active Local Theorem

The active local theorem should be a non-promoting packet:

```lean
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3
```

The packet should depend on `H` and `env`, because the source-prepared
projection object depends on both.  Its transcript theorem may also take the
same explicit hypotheses as `ConditionalNormalizerBridge` when it wants to
reuse the evaluated normalizer equality.

The proof starts by unfolding the proposed packet, the existing
source-prepared product/projection obligation, the finite projection product
bridge, the product-under-contracts route, and
`oneTermRobinFiniteBlockCompositionContract 3`.

First, reuse
`oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript`
to identify the source-prepared projection object and the fixed product
obligation.  This proves that the packet is attached to
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` and that the product
obligation remains unproved.

Second, reuse
`oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript` and
`oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3`.  These facts
fix the signal block row and column at `0`, fix the branch basis at `32`, and
prove that the signal block entry is not being identified directly with the
branch-local entry.  This is the faithful projection shape required by
Definition `def:block-encoding`.

Third, reuse
`oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` only
under its explicit hypotheses.  This supplies the conditional equality between
`SourcePreparedProjection(H, env) * theoremNormalizer` and the expected target
entry.  The hypotheses enter exactly as follows: `hUniform` supplies the sparse
clean-column amplitude from Eq. `arbitrary sparcity`; `hentry` supplies the
boundary `R_y` coefficient convention from Eq. `angles for Ry`; `hND`, `hNF`,
`hkappa`, and `hkappaSqrt` are the coefficient normalizer identities.  No
normalizer-free theorem is obtained.

Fourth, reuse `oneTermRobinFiniteBlockCompositionContract_transcript 3` to
check that the finite block-composition contract has the theorem normalizer
`GHL2025.oneTermRobinNormalizer` and that its
`normalizedBlockEquality.proved` field remains `false`.  The packet may store
the normalized equality obligation, but it must not turn that obligation into a
proof.

The conclusion is a route record and transcript: the source-prepared
projection, the finite projection product bridge, the finite composition
contract, and the fixed product obligation are synchronized.  The transcript
also records that `FixedProductObligation.proved = false`, that
`normalizedBlockEquality.proved = false`, and that all LCU, block projection,
block correctness, final extraction, oracle, unitary, and resource flags remain
false.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` projection times theorem normalizer equals expected target entry under explicit hypotheses | source slot-`2` product equality; focused clean column; coefficient identities | none | `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | product-to-coefficient normalizer packets | previous full gate | compiled route memory |
| `finite_projection_product_bridge` | signal block entry `[0,0]` and branch-local product `[32,32]` are recorded with false theorem flags | product route; finite index lemma | none | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3` and transcript | middle finite projection packet | previous full gate | compiled route memory |
| `branch_contribution_sum_obstruction` | typed sparse-branch family exists, but signal block entry equals branch sum is not proved | selected slot theorem; projection obstruction | none | `oneTermRobinGamma3BoundaryBranchContributionObstruction_n3` | Lean route memory | previous full gate | open obstruction; do not bypass |
| `finite_source_prepared_normalized_projection_bridge` | package source-prepared projection with finite block-composition target and normalized equality obligation while preserving false flags | conditional normalizer bridge; finite projection product bridge; source-prepared packet; finite composition contract | lower2 after lower3 verifier | planned `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` plus transcript | this lower1 packet and middle packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | next active Lean leaf |
| `fixed_product_to_coefficient_3_0_0` | close the exact focused product-to-coefficient root | normalized projection bridge plus future branch-summation or accepted finite block-composition proof | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | proof-obligation ledger | full gate plus proof-map sync | open root; `proved = false` |
| `backend_expansion_raw_no_go` | raw backend expansion or any `SignalEntryFold`-equivalent proposition | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | backend-expansion correction packets | none | refuted; forbidden |

The next active leaf for a Lean worker is:

```lean
oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3
```

## Ordered Lean Lemma Plan

1. Reuse `oneTermRobinFiniteBlockCompositionContract_transcript 3` to expose
   the target matrix, normalizer, and false finite-composition flags.
2. Reuse `oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3` to
   fix signal block row and column `0`, branch basis index `32`, and the
   non-identity between signal index `0` and branch index `32`.
3. Reuse `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript`
   to import the finite projection product bridge fields and false flags.
4. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3_transcript`
   to attach the source-prepared projection packet to the fixed product
   obligation.
5. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`
   if the transcript needs the already compiled non-promoting fixed-product
   guard under `hUniform` and `hentry`.
6. Reuse
   `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3`
   only as the focused clean-column feeder consumed by the conditional
   normalizer bridge.
7. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
   for the conditional normalizer equality under explicit normalizer
   hypotheses.
8. Reuse `oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`
   only for the typed block-entry index equality.  Do not use it as a
   branch-summation theorem.
9. Reuse
   `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`
   and `oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3` only as
   selected slot route memory.  They do not prove
   `oneTermRobinGamma3BoundaryBranchContribution_sum_n3`.
10. Add exactly one new packet layer:
    `OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge`,
    `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3`,
    and
    `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript`.

## Failure Analysis

The planned target is mathematically valid only as a non-promoting bridge
packet.  It is wrong to implement it as a theorem that closes
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, because the finite
sparse-branch summation theorem is still absent.  The current Lean route has
only typed the selected slot and the placeholder branch family; it has not
proved that the signal-zero block entry equals the branch-contribution sum.

The following routes remain invalid for this leaf:

- proving the unchanged raw `backendExpansionStatement`;
- using any proposition equivalent to `SignalEntryFold`;
- using `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` or
  `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3` as
  theorem-facing closure;
- identifying the branch-local `[32,32]` entry directly with the signal block
  `[0,0]` entry;
- promoting `normalizedBlockEquality`, `product_to_coefficient`, LCU, block,
  final extraction, oracle, unitary, resource, or normalizer-free flags.

The current error class for theorem closure is `symbolic_bridge_gap`: the
source correspondence and finite indices are shaped, and the conditional
normalizer bridge compiles, but the symbolic finite projection/summation bridge
into the normalized block remains an explicit obligation.

## Handoff

Lower1 validates the middle finite-normalized-projection packet.  The next
Lean worker may implement exactly
`oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3` as a
non-promoting packet and transcript, after lower3 verifies the finite shape
conditions.  The root
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains open with
`product_to_coefficient=false`; do not revive `backendExpansionStatement` or
`SignalEntryFold`.
