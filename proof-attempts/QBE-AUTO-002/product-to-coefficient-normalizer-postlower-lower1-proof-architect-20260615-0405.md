# Product-To-Coefficient Normalizer Post-Lower Proof Architect

Task: `QBE-AUTO-002`
Run: `20260615-034853-QBE-AUTO-002-cycle01`
Role: lower1 natural-language proof architect
Mode: `faithfulPaper`
Created: `2026-06-15 04:05 JST`

## Source Fragment

The repo-relative path `outer_papers/quantum/GHL2025/main.tex` is absent in
this checkout.  The parent source archive
`../outer_papers/quantum/GHL2025/main.tex` was inspected locally; public
correspondence should cite the stable GHL2025 anchors below and the maintained
source-map artifacts, not the parent path.

The translated fragment is the focused gamma3 boundary contribution in
GHL2025 Theorem `theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq.
`arbitrary sparcity`, Eq. `angles for Ry`, Fig. `fig:1 term ROBIN`, and
Definition `def:block-encoding`.

The sparse-preparation equation used as a contract is:

$$
H_W^{(\kappa)}\ket{0}^{\lceil \log_2 \kappa\rceil}
= \frac{1}{\sqrt{\kappa}}
  \sum_{s=0}^{\kappa-1}\ket{s}^{\lceil \log_2 \kappa\rceil}.
$$

The boundary rotation convention used for the selected boundary entry is:

$$
\theta_j^s =
\arccos\left(\frac{D_j^{(s)}}{\mathcal{N}_D}\right),
\qquad
s=0,\dots,\kappa-1,
\quad
j=0,\dots,K_1-1,K_2+1,\dots,2^n-1.
$$

The focused gamma3 boundary slice in Eq. `ROBIN clarified` has normalizer
$\mathcal{N}_D\mathcal{N}_f\kappa$ and contains the boundary branch
coefficient $f(x_i)D_i^{(s)}\sigma^{(s)}$ over the sparse slots.  For the
current Lean finite example the branch is system entry `(0,0)` and sparse
slot `2`; the block-encoding definition selects the signal-zero block entry,
not the raw branch-local entry.

## Definitions

`FixedProductObligation` is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation 3
  ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

`SourceSlot2Product(H, env)` is the compiled equality:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3
  H env hUniform hentry
```

`FocusedCleanColumn(H)` is the clean-column hypothesis required by:

```lean
oneTermRobinGamma3BoundaryProductUnderContractsEval_n3
```

It is obtained from
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` by
specializing the sparse slot to `⟨2, by native_decide⟩`.

`NormalizerEnv(env)` is the tuple of explicit coefficient identities:

```lean
hND : env "N_D_inv" * env "N_D" = 1
hNF : env "N_f_inv" * env "N_f" = 1
hkappa : env "kappa_inv" * env "kappa" = 1
hkappaSqrt :
  env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
    env "kappa_inv"
```

These hypotheses are the statement boundary of the compiled conditional
bridge. They are not promoted to normalizer-free source facts.

## Local Proof

The active local theorem was:

```lean
oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3
```

It is now compiled in `QuantumBlockEncoding/RobinMatrix.lean`, together with
the direct feeder:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3
```

The natural-language proof has four steps.

First, specialize the all-slot sparse-preparation contract to sparse slot `2`.
After unfolding the product route's recorded clean-column indices, this gives
the focused clean-column entry consumed by the coefficient evaluator.  This is
the compiled feeder
`oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3`.

Second, use the source-prepared slot-`2` bridge
`oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3`.
It rewrites the prepared clean projection entry from Fig. `fig:1 term ROBIN`
to the projected boundary branch product under the all-slot preparation
contract and the explicit boundary-entry convention `hentry`.

Third, apply
`oneTermRobinGamma3BoundaryProductUnderContractsEval_n3` with the focused
clean-column hypothesis and the four `NormalizerEnv(env)` identities.  The
second conjunct gives:

```lean
Coeff.evalWith env
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.projectedBranchProduct *
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.theoremNormalizer =
Coeff.evalWith env
    oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.expectedTargetEntry
```

Fourth, rewrite the left factor by the source-prepared slot-`2` equality and
close the remaining packet and theorem-flag conjuncts by definitional
reduction.  The resulting theorem keeps
`packet.fixedProductObligation.proved = false` and keeps the product,
normalized-block, LCU, block-projection, block-correctness, and
final-extraction flags false.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `source_sparse_uniform_contract` | all sparse slots have the clean-column amplitude required by the source preparation | GHL2025 Eq. `arbitrary sparcity`; Shukla--Vedula cited row | none | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | `research-wiki/cited-results/GHL2025.md` | contract only | external obligation |
| `source_slot2_product_fixed_map_guard` | attach the source-prepared slot-`2` equality to the fixed product map while flags stay false | source slot-`2` product equality | none | `oneTermRobinGamma3BoundarySourcePreparedProjectionSlot2Product_feedsFixedProductMap_n3` | route-retarget packet | previous full gate | compiled; stale |
| `focused_clean_column_from_all_slots` | instantiate the all-slot contract at sparse slot `2` for the product route clean column | `source_sparse_uniform_contract`; product-route transcript | none | `oneTermRobinGamma3BoundaryHWKappaUniformAllSlots_to_productRouteFocusedCleanColumn_n3` | product-to-coefficient normalizer packet | `python3 tools/qbe.py check` | compiled; route memory |
| `conditional_normalizer_product_bridge` | source-prepared slot-`2` product times theorem normalizer equals the expected target entry under explicit hypotheses | source slot-`2` product equality; focused clean column; product-under-contracts evaluator | none | `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` | product-to-coefficient normalizer packet and middle post-lower synthesis | `python3 tools/qbe.py check` | compiled; route memory |
| `finite_projection_product_bridge` | identify the signal-zero block entry indices and expose the missing branch-decomposition/projection field | Definition `def:block-encoding`; Eq. `ROBIN clarified`; product-under-contracts route | none | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`; transcript theorem | conversion window and proof obligations | previous full gate | finite index compiled; branch/projection fields false |
| `branch_decomposition_slot2_projection` | send the slot-`2` projected branch product at `[32,32]` into the signal-zero block entry `[0,0]` | finite projection bridge; Fig. `fig:1 term ROBIN`; Definition `def:block-encoding` | next lower1 or middle packet | `oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3`; `oneTermRobinGamma3BoundaryProjectionSummationTarget_n3` | conversion window section `2026-05-28 Lower Branch-Decomposition Slot-2 Interface` | next packet must require `python3 tools/qbe.py check` | active planning leaf; theorem field false |
| `fixed_product_to_coefficient_3_0_0` | close the focused root obligation | conditional normalizer bridge plus finite projection/summation bridge and finite normalized-block equality | later | `oneTermRobinGamma3ProductToCoefficientObligation 3 ⟨0,_⟩ ⟨0,_⟩` | proof-obligation ledger | full gate plus proof-map sync | open root |
| `backend_expansion_raw_no_go` | raw backend expansion and any `SignalEntryFold`-equivalent route | compiled finite counterexample | none | `oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3` | verifier feedback and correction packets | none | refuted; forbidden |

The next active leaf for a Lean worker is not the compiled conditional bridge.
It is a source-proof translation packet for
`branch_decomposition_slot2_projection`, or a smaller typed obstruction naming
the first missing projection/summation field.

## Intermediate Lean Lemmas

Ordered dependency list for the next Lean-focused worker:

1. Reuse `oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3` to keep
   the signal-zero block entry at full row and column `0`.
2. Reuse `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript`
   to keep the finite bridge, product route, branch basis index `32`, and
   false flags synchronized.
3. Reuse `oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3_transcript` to
   keep `[0,0]` and `[32,32]` separate and to expose
   `projectionSummationObligation.proved = false`.
4. Reuse `oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`
   for the typed block-entry side of Definition `def:block-encoding`.
5. Reuse `oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3`
   only after the projection/summation side identifies the projected branch
   product with the signal-zero block contribution.
6. Do not use `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`,
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
   or any `SignalEntryFold`-equivalent proposition as the next theorem route.

## Failure Analysis

The assigned target
`oneTermRobinGamma3BoundarySourcePreparedSlot2Product_normalizerEval_n3` is not
mathematically wrong.  It is now stale because lower2 already compiled it.  A
new lower2 run should not edit Lean until middle or lower1 names exactly one
new theorem for the remaining finite projection/summation bridge.

The root theorem is still open because the compiled conditional bridge proves
only an evaluated product equality under explicit hypotheses.  It does not
prove that the slot-`2` branch-local product at `[32,32]` is the signal-zero
block contribution at `[0,0]`, and it does not prove the finite normalized
block equality, LCU composition, block correctness, final extraction, oracle
correctness, unitarity, or resource claims.

Typed feedback:

```text
leaf=conditional_normalizer_product_bridge
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=null
normalizer_ok=compiled_conditional_under_explicit_hypotheses
closed_theorem_ok=true
product_to_coefficient=false
error_class=stale_leaf
next_route=prepare the finite projection/summation proof packet for oneTermRobinGamma3ProductToCoefficientObligation 3 0 0; do not revive backendExpansionStatement or SignalEntryFold
```

## Handoff

The conditional normalizer/product bridge and its focused clean-column feeder
are compiled route memory.  The next packet should translate the branch
decomposition/projection step that moves the slot-`2` projected branch product
from branch basis `[32,32]` into the signal-zero block entry `[0,0]`, while
keeping `product_to_coefficient=false` until a Lean theorem closes the root.

Changed files for this lower1 artifact:

```text
proof-attempts/QBE-AUTO-002/product-to-coefficient-normalizer-postlower-lower1-proof-architect-20260615-0405.md
verifier-feedback/QBE-AUTO-002/product-to-coefficient-normalizer-postlower-lower1-20260615-0405.json
```
