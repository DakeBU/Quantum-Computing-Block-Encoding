# Lower1 DAG: Source-Corrected Product Feeder

Task: `QBE-AUTO-002`  
Run: `20260617-044631-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `source_corrected_product_feeder`  
Role profile: natural-language proof architect  
Timestamp: `2026-06-17 05:09:33 JST`

## Source Fragment

The source theorem is GHL2025 Theorem `theorem: 1 term robin`
(`main.tex:1098-1109`).  It claims a one-term Robin block-encoding with
normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$, signal/ancilla size
$\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4$,
zero error, and $2n$ pure ancillas.

The source feeder translated in this leaf is the boundary `gamma_3` summand in
Eq. `ROBIN clarified` (`main.tex:1111-1119`):

$$
\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
\sum_s f(x_i)D_i^{(s)}\sigma^{(s)}
\ket{0}^{m_f+1}\ket{s}\ket{0}^{n-\lceil\log_2\kappa\rceil}\ket{j}\ket{0}.
$$

The focused finite instance is `n = 3`, system entry `(0,0)`, sparse slot `2`,
and branch basis `[32,32]`.  The sparse preparation equation
`arbitrary sparcity` (`main.tex:948-955`) is used only through
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.  The
boundary rotation equation `angles for Ry` (`main.tex:1077-1085`) is used only
through the explicit hypothesis `hentry` for `boundary_cos_half_0_2`.

Fig. `fig:1 term ROBIN` (`main.tex:1122-1164`) fixes the theorem-facing circuit
as the prepared sandwich with both `H_W^(kappa)` sides.  Definition
`def:block-encoding` (`main.tex:2027-2035`) fixes the clean signal projection.
Therefore the generic H-free backend projection/expansion statement is not a
valid closure route.

## Definitions For The Local Claim

Let `PreparedEntry(H, env)` be
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`.

Let `ProjectedProduct` be
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct`.

Let `ProductRoute` be
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`, whose normalizer is
the theorem normalizer and whose expected target entry is the focused Ak entry.

Let `Interface(H, env)` be
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env`.

Let `FixedObligation` be
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, expressed in Lean as
`oneTermRobinGamma3ProductToCoefficientObligation 3
  <0, by native_decide> <0, by native_decide>`.

The next Lean worker should prove the non-promoting audit wrapper
`oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`.  The wrapper
should package, under `hUniform`, `hentry`, `hND`, `hNF`, `hkappa`, and
`hkappaSqrt`, these already source-backed facts:

1. `PreparedEntry(H, env)` evaluates to `ProjectedProduct`.
2. `PreparedEntry(H, env) * ProductRoute.theoremNormalizer` evaluates to
   `ProductRoute.expectedTargetEntry`.
3. `Interface(H, env).sourcePreparedProjectionEntry *
   Interface(H, env).finiteBlockNormalizer` evaluates to
   `Interface(H, env).normalizedProjectionBridge.expectedTargetEntry`.
4. The interface and source-prepared packet both still point at
   `FixedObligation`, and `FixedObligation.proved = false`.
5. Both no-go guards are carried:
   `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` and
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3`.
6. Normalized-block, product-to-coefficient, LCU, block-projection,
   block-correctness, final-extraction, oracle, unitary, resource,
   post-baseline, and OPTCTRL flags remain false.

## Natural-Language Proof

Assume `hUniform :
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.  This is
the exact local form of Eq. `arbitrary sparcity`; it says every sparse slot in
the clean column has amplitude `sqrt_kappa_inv`.  Instantiating it at slot `2`
gives the ket-side sparse-register factor used by
`oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3`.
The transpose convention for the dagger side is already compiled in the
existing clean-column route, so lower2 does not need a new `H_W` definition.

Assume `hentry` for `boundary_cos_half_0_2`.  This is the only use of Eq.
`angles for Ry` in this leaf.  It feeds
`oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`, which
turns the backend fold into the focused slot-`2` projected product after the
selected-slot evaluator.

The compiled theorem
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
composes the prepared projection-to-backend fold bridge with the backend
fold-to-slot-`2` bridge.  This proves the first clause:
`PreparedEntry(H, env)` evaluates to `ProjectedProduct`.

The compiled theorem
`oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
then multiplies that projected product by the theorem normalizer.  The
hypotheses `hND`, `hNF`, `hkappa`, and `hkappaSqrt` are the only algebraic
normalizer inputs.  The theorem gives the second clause and confirms that the
source-prepared packet still points at `FixedObligation` with all product and
block flags false.

The compiled theorem
`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3` gives the
same source-prepared equality through `Interface(H, env)` and also records the
finite block normalizer equality beside the fixed product obligation.  It
carries the generic projection no-go guard and keeps the backend-gap flags
false.  The proposed audit wrapper should reuse this theorem rather than
reprove its fields.

The no-go theorems
`oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` and
`oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` show why this
wrapper must not assert the generic backend projection or expansion statement.
Those surfaces are refuted for the unchanged target.  The source-correct route
is the prepared slot-`2` product feeder, not the H-free signal-entry closure.

This proves the active local theorem as a route audit.  It does not prove
`FixedObligation`; the remaining mathematical step is still the finite
normalized block/projection equality and final coefficient bridge required by
Definition `def:block-encoding`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_theorem_anchor` | GHL2025 Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding` | none | upper/middle | source labels only | this file; source map | no build | source fixed |
| `h_uniform_contract` | all sparse slots have clean-column amplitude `sqrt_kappa_inv` | Eq. `arbitrary sparcity`; cited Shukla-Vedula contract row | existing contract | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | this file | no build | contract-only input |
| `boundary_entry_hypothesis` | selected `Ry` coefficient for `boundary_cos_half_0_2` | Eq. `angles for Ry` | Lean worker consumes as hypothesis | `hentry` hypothesis | this file | no build | explicit input |
| `source_prepared_slot2_product` | `PreparedEntry(H,env)` evaluates to `ProjectedProduct` | `hUniform`; `hentry`; prepared-backend bridge; backend-fold-to-slot bridge | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | prior bridge notes; this file | previous gate | compiled route memory |
| `source_prepared_normalizer_eval` | `PreparedEntry * theoremNormalizer` evaluates to expected target entry | `source_prepared_slot2_product`; normalizer hypotheses | none | `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | this file | previous gate | compiled route memory |
| `fixed_product_pre_audit` | theorem-facing interface exposes prepared product, normalizer equality, fixed obligation, and no-go guard | branch bridge; finite normalizer bridge; backend gap transcript | none | `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3` | middle packet; this file | previous gate | compiled; retired as target |
| `source_corrected_product_feeder` | non-promoting audit wrapper packaging the corrected feeder beside `FixedObligation` and the no-go guards | compiled route memory above | lower2 after lower3 check | planned `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3` | this file | `python3 tools/qbe.py check` | next active leaf |
| `fixed_product_to_coefficient_3_0_0` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | corrected feeder plus finite normalized block/projection equality | later | existing semantic obligation | proof-obligation ledger | not run | blocked |
| `ghl_one_term_robin_root` | full one-term Robin block-encoding baseline | fixed product, block projection, external contracts, resource proof | later | root route through finite block contract | conversion window | full project gate | open |

Next active leaf for the Lean worker:
`oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`.

## Ordered Lean Lemma Plan

1. Reuse `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
   as the only sparse-preparation input.
2. Reuse
   `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3`
   to instantiate slot `2`.
3. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3`.
4. Reuse
   `oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3`.
5. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
6. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3`
   if lower2 wants the fixed-map clause before the normalizer clause.
7. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
   for the normalizer calculation.
8. Reuse
   `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript`
   for bridge bookkeeping if the wrapper includes bridge-field equalities.
9. Reuse
   `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3`
   and
   `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`
   for theorem-facing interface clauses.
10. Reuse
    `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3`
    and `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` as
    forbidden-route guards.
11. Compile only `oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`
    or a smaller wrapper with the same dependencies and false flags.

Suggested proof skeleton for lower2:

```text
have hSlot := oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  H env hUniform hentry
have hNorm := oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
  H env hUniform hentry hND hNF hkappa hkappaSqrt
have hPreAudit := oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3
  H env hUniform hentry hND hNF hkappa hkappaSqrt
have hNoProjection := oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3
have hNoExpansion := oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3
dsimp [the relevant packet/interface definitions] at hSlot hNorm hPreAudit |- 
exact tuple of reused equalities, no-go guards, and false flags
```

## Failure Analysis

The mathematical target is valid only as a non-promoting feeder audit.  It is
not valid to prove or assume
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`
or
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`;
both are refuted by compiled no-go theorems for the unchanged generic surface.

The fixed product obligation should remain open after this leaf.  A wrapper
that sets `FixedObligation.proved = true`, or promotes normalized-block, LCU,
block, oracle, unitary, resource, or final-extraction flags, would be contract
drift.  If lower3 determines that the proposed wrapper is entirely duplicated
by `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3_transcript`
plus `oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`, lower2
should either compile a smaller named alias for the exact missing feeder or log
`stale_leaf`; it should not move directly to the root theorem.

Typed verifier feedback:

```text
leaf=source_corrected_product_feeder
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=source_prepared_product_feeder_only
normalizer_ok=true_under_hND_hNF_hkappa_hkappaSqrt
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=lower3 checks the wrapper shape; lower2 compiles one non-promoting SourceCorrectedProductFeederAudit wrapper or logs stale/source_translation_gap with no Lean edit
```

## Handoff

Lower1 handoff: source proof map for `source_corrected_product_feeder` is
complete.  The source-paper fragment is GHL2025 Theorem `theorem: 1 term
robin`, Eq. `arbitrary sparcity`, Eq. `angles for Ry`, Eq. `ROBIN clarified`
boundary `gamma_3`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.  The next Lean leaf is the non-promoting wrapper
`oneTermRobinGamma3BoundarySourceCorrectedProductFeederAudit_n3`, reusing
`oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`,
`oneTermRobinGamma3BoundaryFixedProductToCoefficientPreAudit_n3`, and the two
no-go guards.  No Lean edit was made in this lower1 pass.
