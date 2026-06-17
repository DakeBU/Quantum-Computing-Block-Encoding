# Theorem-Facing Corrected Prepared Projection Entry Lower1 DAG

Task: `QBE-AUTO-002`  
Run: `20260617-030416-QBE-AUTO-002-cycle01`  
Role: lower natural-language proof architect  
Mode: `paperBenchmark`  
Leaf: `theorem_facing_corrected_prepared_projection_entry`

## Source Fragment

The baseline source target is GHL2025 Theorem `theorem: 1 term robin`, the
one-term block-encoding theorem for
$A_k \sim f(x)\partial^m/\partial x^m$ with Robin boundaries.  The theorem
claims a
$(\mathcal{N}_D\mathcal{N}_f\kappa,\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+\lceil\log_2\kappa\rceil+4,0)$
block-encoding.

The local source fragment for this leaf is the boundary $\gamma_3$ line of Eq.
`ROBIN clarified`:

$$
\ket{\gamma_3}
=
\frac{1}{\mathcal{N}_D\mathcal{N}_f\kappa}
\sum_{\substack{s=0,\dots,\kappa-1 \\
0 \leq j < K_1 \cup K_2 < j < 2^n}}
f(x_i)(D)_i^{(s)}\sigma^{(s)}
\ket{0}^{m_f+1}\ket{s}^{\lceil\log_2\kappa\rceil}
\ket{0}^{n-\lceil\log_2\kappa\rceil}\ket{j}^n\ket{0}^1
+ \dots .
$$

The supporting source anchors are Eq. `arbitrary sparcity`, which defines
$H_W^{(\kappa)}\ket{0}$ as the uniform sparse-register superposition; Eq.
`angles for Ry`, which supplies the boundary rotation coefficient; Fig.
`fig:1 term ROBIN`, which is the theorem-facing prepared circuit with both
$H_W^{(\kappa)}$ sides; and Definition `def:block-encoding`, whose clean
projection is represented by the source-prepared entry in Lean.

## Definitions

For fixed `H : Matrix 8 8 Coeff` and `env : String -> Rat`, define
`ProjectionInterface(H, env)` to be
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3 H env`.

Define `PreparedEntry(H, env)` to be
`ProjectionInterface(H, env).sourcePreparedProjectionEntry`.

Define `ProjectedBridgeProduct(H, env)` to be
`ProjectionInterface(H, env).normalizedProjectionBridge.projectedBranchProduct`.

The explicit source contracts for this local leaf are:

| Contract | Lean hypothesis | Role |
|---|---|---|
| Eq. `arbitrary sparcity` | `hUniform : oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | supplies the clean sparse-register column |
| Eq. `angles for Ry`, boundary slot `2` | `hentry : env "boundary_cos_half_0_2" = Coeff.evalWith env (GHL2025.boundaryRotationNormalizedCoefficient (oneTermParameters 3) 0 2)` | supplies the selected boundary rotation value |

## Local Claim

The next Lean worker should prove exactly:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3
```

with conclusion:

```lean
let interface :=
  oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
    H env
Coeff.evalWith env interface.sourcePreparedProjectionEntry =
    Coeff.evalWith env interface.normalizedProjectionBridge.projectedBranchProduct
```

together with the definitional identity
`interface.sourcePreparedProjectionEntry =
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry`
and the required false theorem flags.  This is an interface wrapper only.  It
does not prove `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Natural-Language Proof

The prepared route is source-correct because Fig. `fig:1 term ROBIN` prepares
the sparse register with $H_W^{(\kappa)}$, applies the theorem-facing circuit,
and projects back onto the clean prepared state used by Definition
`def:block-encoding`.  The active seven-gate backend is only a component, so
the proof must not use the retired generic backend projection statement.

Apply the compiled theorem
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
to `H`, `env`, `hUniform`, and `hentry`.  This gives the evaluated equality
between the source-prepared projection entry and the slot-`2` projected branch
product:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
=
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

Unfold the theorem-facing interface and its normalized projection bridge.  The
left side becomes `Coeff.evalWith env interface.sourcePreparedProjectionEntry`.
The right side becomes
`Coeff.evalWith env interface.normalizedProjectionBridge.projectedBranchProduct`
because the normalized bridge stores the same finite projection bridge
`projectedBranchProduct`.  The identity between `interface.sourcePreparedProjectionEntry`
and the source target's `preparedProjectionEntry` is definitional.

All remaining conjuncts are bookkeeping fields that must stay false.  They
follow by reflexivity after unfolding the interface, contract audit, normalized
projection bridge, source-prepared product/projection packet, finite projection
bridge, and product-under-contracts route.  These reflexivity proofs are the
guard against accidentally promoting finite block equality, product-to-
coefficient, LCU, block projection, block correctness, final extraction,
oracle correctness, unitarity, or resource claims.

A temporary `lake env lean --stdin` check passed for this exact wrapper shape
on 2026-06-17 03:24 JST.  No Lean source file was edited by this lower1 pass.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_prepared_slot2_product` | prepared projection entry evaluates to the slot-`2` projected product | `hUniform`, `hentry`, source-prepared target | none | `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3` | source-prepared projection/product packets | already gated | proved conditional |
| `generic_branch_sum_projection` | raw backend branch projection-summation statement | backend branch target | none | `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` | invalid-route packets | already gated | refuted; do not assign |
| `theorem_facing_prepared_projection_slot2_product` | source-prepared entry equals the global projected product field | source-prepared slot-`2` theorem; theorem-facing interface | none | `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3` | lower1/lower3/lower2 prepared-projection contract packets | already gated | proved route memory |
| `theorem_facing_corrected_prepared_projection_entry` | expose `PreparedEntry(H, env) = ProjectedBridgeProduct(H, env)` at the theorem-facing interface layer | source-prepared slot-`2` theorem; normalized projection bridge; false flags | lower3 then lower2 | planned `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3` | this packet | `python3 tools/qbe.py check`; `lake build`; `lake build Tests` | active leaf |
| `fixed_product_to_coefficient` | close `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | corrected prepared projection entry, normalizer bridge, finite normalized-block/projection theorem | later | existing obligation | proof-obligation ledger | not run | blocked |

Next active Lean leaf: `theorem_facing_corrected_prepared_projection_entry`.

## Ordered Lean Lemmas and Declarations to Reuse

1. `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3`
   exposes the theorem-facing finite block/projection interface.
2. `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3` supplies the
   source-prepared clean projection target.
3. `oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`
   proves the evaluated source-prepared slot-`2` equality under `hUniform` and
   `hentry`.
4. `oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3`
   stores the projected branch product used by the theorem-facing interface.
5. `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3` and
   `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` unfold the bridge
   RHS to the already proved slot-`2` product expression.
6. `oneTermRobinGamma3BoundaryTheoremFacingProjectionInterface_preparedProjectionSlot2Product_n3`
   is compiled route memory and can be cited, but the planned proof may use
   the slot-`2` theorem directly.
7. `oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3` and
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` must remain
   forbidden-route guards, not dependencies for the active wrapper.

## Failure Analysis

The current target is mathematically well-shaped as a non-promoting wrapper.
It translates the source-prepared clean projection route and avoids the known
bad H-free backend branch-sum surface.  The old target
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`
is not acceptable for theorem-facing closure because it implies the refuted
backend expansion statement.

This leaf does not close the GHL baseline.  After lower2 compiles the wrapper,
the remaining obstruction is still the finite normalized-block/projection and
product-to-coefficient route feeding
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

## Handoff

Release lower3 to recheck that the wrapper unfolds to
`interface.sourcePreparedProjectionEntry` on the left and
`interface.normalizedProjectionBridge.projectedBranchProduct` on the right,
with all listed theorem flags false.  Then lower2 may add only
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_correctedPreparedProjectionEntry_n3`
near the existing theorem-facing projection interface wrappers in
`QuantumBlockEncoding/RobinMatrix.lean`.

If lower2 finds that declaration already present, log `error_class=stale_leaf`
and make no Lean edit.  Do not target the generic branch-sum statement, the
root product-to-coefficient theorem, normalized block equality, LCU, block
projection, oracle correctness, unitarity, resource score, post-baseline
candidate population, or the OPTCTRL fallback from this leaf.
