# Theorem-Facing Finite Block Normalizer Bridge: Lower1 Proof DAG

Task: `QBE-AUTO-002`  
Run: `20260617-032739-QBE-AUTO-002-cycle01`  
Role: lower1 natural-language proof architect  
Mode: `paperBenchmark`  
Timestamp: `2026-06-17 03:43:12 JST`  
Leaf: `theorem_facing_finite_block_normalizer_bridge`

## Source Fragment

The active paper source is GHL2025 Theorem `theorem: 1 term robin` at
`../outer_papers/quantum/GHL2025/main.tex:1098-1109`.  The theorem states a
one-term Robin block-encoding with normalizer
$\mathcal{N}_D \mathcal{N}_f \kappa$.

The local equation being translated is the displayed boundary $\gamma_3$
branch in Eq. `eq: ROBIN clarified`, at
`../outer_papers/quantum/GHL2025/main.tex:1111-1119`.  Its coefficient has the
same normalizer:

$$
\ket{\gamma_3}
  =
  \frac{1}{\mathcal{N}_D \mathcal{N}_f \kappa}
  \sum_{\substack{s=0,\dots,\kappa-1 \\
    0 \leq j < K_1 \cup K_2 < j < 2^n}}
    f(x_i) (D)^{(s)}_i \sigma^{(s)}
    \ket{0}^{m_f+1}\ket{s}^{\lceil \log_2 \kappa\rceil}
    \ket{0}^{n-\lceil \log_2 \kappa\rceil}\ket{j}^n\ket{0}^1
  + \cdots .
$$

The circuit anchor is Fig. `fig:1 term ROBIN` at
`../outer_papers/quantum/GHL2025/main.tex:1122-1164`.  The block-selection
anchor is Definition `def:block-encoding` at
`../outer_papers/quantum/GHL2025/main.tex:2027-2035`, which selects the clean
signal block and uses $\alpha \tilde A$ with $\alpha$ as the theorem
normalizer.  This leaf translates only the equality between the theorem-facing
normalizer field and the finite-block contract normalizer.  It does not prove
the finite normalized-block equality.

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define:

| Name | Lean object |
|---|---|
| `ProjectionInterface(H, env)` | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env` |
| `PreparedEntry(H, env)` | `ProjectionInterface(H, env).sourcePreparedProjectionEntry` |
| `BridgeNormalizer(H, env)` | `ProjectionInterface(H, env).normalizedProjectionBridge.theoremNormalizer` |
| `FiniteBlockNormalizer(H, env)` | `ProjectionInterface(H, env).finiteBlockNormalizer` |
| `ExpectedTargetEntry(H, env)` | `ProjectionInterface(H, env).normalizedProjectionBridge.expectedTargetEntry` |
| `FixedProductObligation` | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` |

The theorem-facing interface is compiled route memory.  Its definition sets
`finiteBlockNormalizer := (oneTermRobinFiniteBlockCompositionContract 3).normalizer`.
Its normalized projection bridge is the compiled audit field
`audit.normalizedProjectionBridge`, whose `theoremNormalizer` is routed through
`oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3` and the product
under contracts route.

## Local Theorem

The next Lean worker should compile exactly:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
```

with interface statement:

```lean
let interface :=
  oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
    H env
Coeff.evalWith env interface.sourcePreparedProjectionEntry *
    Coeff.evalWith env interface.finiteBlockNormalizer =
  Coeff.evalWith env
    interface.normalizedProjectionBridge.expectedTargetEntry
  /\ interface.finiteBlockNormalizer =
    interface.normalizedProjectionBridge.theoremNormalizer
  /\ all downstream theorem-facing flags remain false
```

The hypotheses should be the existing explicit contracts used by the compiled
normalizer bridge:

```lean
hUniform :
  oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
hentry :
  env "boundary_cos_half_0_2" =
    Coeff.evalWith env
      (GHL2025.boundaryRotationNormalizedCoefficient
        (oneTermParameters 3) 0 2)
hND : env "N_D_inv" * env "N_D" = 1
hNF : env "N_f_inv" * env "N_f" = 1
hkappa : env "kappa_inv" * env "kappa" = 1
hkappaSqrt :
  env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
    env "kappa_inv"
```

## Natural-Language Proof

The compiled theorem
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`
already proves the evaluated product
`PreparedEntry(H, env) * BridgeNormalizer(H, env) = ExpectedTargetEntry(H, env)`
under exactly the source contracts above.  That theorem is the formal version
of the source normalizer cancellation for the focused $\gamma_3$ boundary
branch: Eq. `eq: ROBIN clarified` and Theorem `theorem: 1 term robin` use the
same factor $\mathcal{N}_D \mathcal{N}_f \kappa$.

It remains to expose that same normalizer through the finite block-composition
contract field.  By unfolding
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`,
`FiniteBlockNormalizer(H, env)` is the normalizer of
`oneTermRobinFiniteBlockCompositionContract 3`.  By unfolding the compiled
audit and normalized-projection bridge fields,
`BridgeNormalizer(H, env)` is the theorem normalizer carried by
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`.  These unfold to
the same Lean coefficient, so the equality
`FiniteBlockNormalizer(H, env) = BridgeNormalizer(H, env)` is `rfl` after
`dsimp` over the same definitions used in the middle packet.

Substitute this definitional equality into the compiled evaluated product.
Because the target theorem asks for the product with `finiteBlockNormalizer`,
the existing equality from
`oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`
becomes the first conjunct.  The second conjunct is the definitional
normalizer equality.  Every remaining conjunct is a false semantic flag already
stored in the theorem-facing interface.  Each of those fields reduces to
`false = false` after the same `dsimp`, so each closes by `rfl`.

This proof does not use, prove, or alter:

- `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`;
- `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`;
- `(oneTermRobinFiniteBlockCompositionContract 3).blockProjection`;
- any LCU, final extraction, oracle, unitarity, or resource theorem;
- the rejected universal active/prepared field; or
- the refuted generic backend projection/expansion route.

## Proof-DAG Table

| Node | Interface | Dependencies | Status | Owner | Lean declaration | Next action |
|---|---|---|---|---|---|---|
| `source_anchor_normalizer` | Theorem and Eq. `ROBIN clarified` use normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$ | GHL2025 main.tex lines 1098-1119 | source checked | none | source map only | no Lean edit |
| `source_prepared_slot2_product` | prepared projection entry evaluates to focused slot-`2` projected product | `hUniform`, `hentry` | proved | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | reuse |
| `theorem_facing_prepared_entry` | theorem-facing source-prepared entry equals normalized bridge projected product | `source_prepared_slot2_product`, interface unfolding | proved | none | `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` | reuse |
| `theorem_facing_normalizer_bridge` | `PreparedEntry * BridgeNormalizer = ExpectedTargetEntry` | `source_prepared_slot2_product`, coefficient inverse hypotheses | proved | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3` | reuse |
| `finite_block_normalizer_alias` | `FiniteBlockNormalizer = BridgeNormalizer` | interface, audit, finite contract, product-route unfoldings | active leaf subclaim | lower2 | part of planned `..._finiteBlockNormalizerEval_n3` | prove by `dsimp`; expected `rfl` |
| `theorem_facing_finite_block_normalizer_bridge` | `PreparedEntry * FiniteBlockNormalizer = ExpectedTargetEntry` and all flags false | `theorem_facing_normalizer_bridge`, `finite_block_normalizer_alias` | next active leaf | lower2 after lower3 shape check | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3` | compile one wrapper theorem |
| `branch_decomposition_projection_bridge` | identify source-prepared projected branch product with the signal-zero block entry | finite block index and branch family checks | blocked | later lower1/lower3 | not released | assign after normalizer wrapper |
| `fixed_product_to_coefficient` | close focused product/coefficient root for `(n,i,j)=(3,0,0)` | normalizer wrapper, branch decomposition bridge, final coefficient algebra | blocked | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | not current target |

The next active leaf for the Lean worker is
`theorem_facing_finite_block_normalizer_bridge`, specifically the alias
subclaim `finite_block_normalizer_alias` plus the product wrapper around the
already compiled normalizer theorem.

## Ordered Lean Lemmas and Reuse

1. Reuse
   `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_normalizerEval_n3`
   to obtain the evaluated product with
   `interface.normalizedProjectionBridge.theoremNormalizer`.
2. Unfold
   `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`
   and
   `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3`
   to expose the finite contract and normalized-projection bridge fields.
3. Unfold
   `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3`,
   `oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3`,
   `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`,
   `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`,
   `oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3`,
   `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3`,
   `oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3`, and
   `oneTermRobinFiniteBlockCompositionContract`.
4. Prove
   `interface.finiteBlockNormalizer =
    interface.normalizedProjectionBridge.theoremNormalizer`
   by `rfl` after the unfoldings.
5. Return the evaluated product equality from step 1, now with the finite
   block normalizer field, and close every false-flag conjunct by `rfl`.

No new reusable Lean definition is needed.  If `rfl` fails after the proposed
unfolding list, the route should be classified as `symbolic_bridge_gap`, and
lower2 should report the first non-definitional normalizer mismatch instead of
adding a hypothesis.

## Failure Analysis

This target is mathematically well-routed as a non-promoting normalizer alias.
It is not the paper's full block-encoding theorem, and it must not be reported
as proving Definition `def:block-encoding`.  It only aligns two Lean field
names for the same source normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$.

The following routes remain wrong for this leaf:

- attacking the root `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`;
- promoting `(oneTermRobinFiniteBlockCompositionContract 3).normalizedBlockEquality`;
- reviving the universal active/prepared field rejected by the finite
  counterexample;
- using
  `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`;
- using
  `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.

The local source archive path in the run prompt,
`outer_papers/quantum/GHL2025/main.tex`, is relative to the parent repository
in this checkout.  The file used here is
`../outer_papers/quantum/GHL2025/main.tex`, with source-map confirmation in
`research-wiki/paper-contributions/GHL2025/source-map.md`.

## Typed Feedback

```text
leaf=theorem_facing_finite_block_normalizer_bridge
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=null
block_entry_ok=normalizer_bridge_only
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
resource_score=null
auxiliary_qubits=null
gate_count=theorem_facing:10,active_backend:7
depth=null
oracle_calls=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=lower3 checks normalizer alias/false-flag shape, then lower2 compiles exactly one wrapper theorem oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_finiteBlockNormalizerEval_n3
```
