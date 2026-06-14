# Prompt for ChatGPT Pro: Source-Prepared Product/Projection Retarget

Paste the following prompt into ChatGPT Pro. It is self-contained and assumes ChatGPT Pro cannot access local files.

```text
You are helping plan a Lean 4 proof for a quantum block-encoding formalization. Please think deeply in natural language and produce a proof blueprint, not code edits.

Paper context:

We are formalizing the one-term Robin boundary block-encoding construction from:

Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum framework for simulating linear PDEs with Robin boundary conditions", arXiv:2506.20478.

The focused case is the paper's Robin boundary circuit for one term, with n = 3, gamma3 boundary branch, system row/column (0,0), focused sparse slot 2. The paper's Fig. 4 is essential: the theorem-facing circuit contains the sparse-register preparation and unpreparation on the two sides:

  (H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa).

Therefore the theorem-facing block-encoding entry is a clean projection entry of the source-prepared composite circuit, not merely an H-free backend seven-gate entry.

Important source anchors in the paper:

- Eq. "arbitrary sparcity": the sparse-register preparation contract for H_W^(kappa).
- Eq. "ROBIN clarified": the Robin boundary sparse summand/backend branch fold.
- Fig. 4 / "fig:1 term ROBIN": the source-prepared circuit with H_W^(kappa) and its dagger.
- Definition "block-encoding": the clean ancilla projection entry selected from the full circuit.

Current Lean state, summarized:

1. The uniform sparse-preparation contract is represented as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Treat it as an explicit hypothesis/contract from the paper's sparse preparation statement. Do not try to prove it in this leaf.

2. The prepared composite source object and clean index are:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H
oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

The theorem-facing prepared clean entry is:

```lean
Coeff.evalWith env
  ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

The backend branch fold is:

```lean
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

3. The prepared clean-entry/backend-fold equality is already compiled under the uniform contract:

```lean
oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
  H env hUniform
```

There is also a source-prepared target record:

```lean
OneTermRobinGamma3BoundarySourcePreparedProjectionTarget
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
```

Relevant fields:

```lean
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).backendBranchFold
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedSingletonToBackendEvalStatement
```

The field-level prepared projection backend bridge is already compiled:

```lean
oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
  H env hUniform
```

4. The fixed product obligation still open is:

```lean
oneTermRobinGamma3ProductToCoefficientObligation
  3 ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
```

The boundary product interface fixes these data:

```text
system row = 0
system column = 0
sparse slot = 2
clean source full index = 32
branch entry = oneTermRobinGamma3BoundarySevenGateMatrix_n3[32,32]
ket-zero factors = [1, 1, boundary_cos_half_0_2, 1, f_3_0 * N_f_inv, 1, 1]
```

The strongest existing branch-entry evaluator has the following shape:

```lean
oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedCoefficientExpanded_n3
  (env : String → Rat)
  (hentry :
    env "boundary_cos_half_0_2" =
      Coeff.evalWith env
        (GHL2025.boundaryRotationNormalizedCoefficient
          (oneTermParameters 3) 0 2)) :
  Coeff.evalWith env
    (oneTermRobinGamma3BoundarySevenGateMatrix_n3
      oneTermRobinGamma3BoundaryPrefixSource_n3
      oneTermRobinGamma3BoundaryPrefixSource_n3) =
    Coeff.evalWith env
      (Coeff.mul
        (Coeff.mul (GHL2025.robinFunctionValue 3 0)
          (Coeff.symbol "N_f_inv"))
        (GHL2025.boundaryRotationNormalizedCoefficient
          (oneTermParameters 3) 0 2))
```

5. Refuted target:

Do not prove or revive this H-free target:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

It has a Lean no-go theorem:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3 :
  ¬ oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Why it is false as a theorem target:

If the H-free backend expansion held, existing bridges would imply the evaluated backend fold for every environment. A compiled normal-form lemma then forces the selected slot contribution to evaluate to zero. But a concrete all-one selected-branch environment evaluates the same contribution to one. Therefore this is not a missing Lean trick; the H-free theorem target is wrong.

6. Forbidden diagnostic routes:

Do not use these as theorem closure:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3
oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic
```

Also do not use source/active names that compare the old H-free active signal-zero entry against the prepared entry as the main theorem target:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

Those are useful diagnostics, but under the uniform contract they route back to the retired selected-slot-zero obstruction if used incorrectly.

Desired retarget:

We need a source-prepared product/projection route:

```text
Uniform(H)
  -> clean projection of (H_W^(kappa))^dagger * U_gamma3_boundary * H_W^(kappa)
  -> backend branch fold
  -> focused slot-2 boundary product map
  -> product-to-coefficient equality for oneTermRobinGamma3ProductToCoefficientObligation 3 0 0
```

We do not want:

```text
H-free active row0,row0 seven-gate entry
  -> selected slot contribution
  -> raw H-free backend fold
  -> product-to-coefficient
```

Recommended next Lean object:

Before attempting a hard product-to-coefficient proof, we likely need a bookkeeping/proof-DAG structure:

```lean
structure OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation where
  sourceTarget : OneTermRobinGamma3BoundarySourcePreparedProjectionTarget
  productRoute : OneTermRobinGamma3BoundaryProductUnderContractsRoute
  productBridge : OneTermRobinGamma3BoundaryFiniteProjectionProductBridge
  preparedBackendEvalStatement : Prop
  fixedProductObligation : SemanticObligation
  forbiddenBackendExpansionParent : Bool
  preparedBackendEvalCompiled : Bool
  productRouteConsumed : Bool
  normalizedBlockEqualityProved : Bool
  productToCoefficientProved : Bool
  lcuCorrectProved : Bool
  blockProjectionProved : Bool
  blockCorrectProved : Bool
  finalExtractionProved : Bool
  exactRemainingObstruction : String
```

The corresponding n = 3 packet should:

- point `sourceTarget` to `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`;
- point `fixedProductObligation` to `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`;
- record that the prepared backend equality is supplied by `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3`;
- set `forbiddenBackendExpansionParent := true`;
- keep all final flags false.

Possible next mathematical leaf after that packet:

```lean
theorem oneTermRobinGamma3BoundaryProjectionSummation_slot2_to_signalBlock_n3
    (env : String → Rat) :
    Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalBlockEntry =
      Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.projectedBranchProduct
```

or a more source-prepared variant that starts from:

```lean
Coeff.evalWith env
  (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedProjectionEntry
```

and ends at the focused slot-2 projected branch product. The key is that the route must not depend on the refuted H-free backend expansion.

Normalizer/product equality leaf may require explicit algebraic contracts:

```lean
env "N_D_inv" * env "N_D" = 1
env "N_f_inv" * env "N_f" = 1
env "kappa_inv" * env "kappa" = 1
env "sqrt_kappa_inv" * env "sqrt_kappa_inv" = env "kappa_inv"
env "boundary_cos_half_0_2" =
  Coeff.evalWith env
    (GHL2025.boundaryRotationNormalizedCoefficient
      (oneTermParameters 3) 0 2)
```

Your task:

Please produce a natural-language Lean proof blueprint for the corrected source-prepared product/projection route. Do not write a final Lean patch. I want a plan that my local agents can implement.

Answer exactly in these sections:

1. Verdict
   - Name the recommended next Lean target.
   - Say whether the next target should be the bookkeeping obligation packet, the small projection lemma, or the full product-to-coefficient equality.

2. Proof DAG
   - List nodes in order.
   - For each node, say: claim, existing Lean names to reuse, status among `compiled`, `hypothesis`, `new lower2 leaf`, `later leaf`, or `forbidden`.

3. Lean Blueprint
   - Step-by-step implementation plan.
   - Suggested lemma names.
   - Expected proof methods, e.g. `dsimp`, field projection, existing bridge theorem, small finite index lemma, `Coeff.evalWith` algebra, not giant matrix unfolding.

4. Non-Implication Check
   - Explain why this source-prepared route does not imply the refuted H-free `backendExpansionStatement`.
   - Explain what field or hypothesis prevents the proof from silently returning to the old wrong target.

5. Normalizer Placement
   - Explain where `N_D`, `N_f`, `kappa`, and `sqrt_kappa_inv` assumptions should enter.
   - Clarify which of them belong to local finite algebra lemmas rather than to the paper theorem statement.

6. Forbidden Routes
   - Concise list of declarations or ideas lower2 must not use.

7. Verifier Checklist
   - Give checks that a reviewer/lower3 agent should run after lower2 modifies Lean.
   - Include checks for no `backendExpansionStatement` parent, source-prepared entry, fixed `(3,0,0)` product obligation, and all downstream flags still false.
```
