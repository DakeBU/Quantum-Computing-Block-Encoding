# ChatGPT Pro Handoff: Remaining GHL2025 Lean Proof Problem

This document is intended to be copied into ChatGPT Pro.  The recipient will not
have the local repository, so the prompt below is self-contained enough to reason
about the remaining Lean proof route.  If possible, also give ChatGPT Pro the
Guseynov-Huang-Liu arXiv link and, if it has access, the project repository link.

Recommended external links to provide:

- Paper: Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum framework for
  simulating linear PDEs with Robin boundary conditions",
  <https://arxiv.org/abs/2506.20478>
- PDF: <https://arxiv.org/pdf/2506.20478>
- Optional repository link, if accessible:
  <https://github.com/DakeBU/Quantum-Computing-Block-Encoding>

## Copy-Paste Prompt For ChatGPT Pro

I am working on a Lean 4 formalization of the paper:

Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum framework for simulating linear
PDEs with Robin boundary conditions", arXiv:2506.20478.

Please read the arXiv paper, especially the one-term Robin boundary
block-encoding construction.  I need help finishing the remaining Lean proof
obligation.  I do not want new mathematical assumptions, a modified oracle
contract, or a different circuit.  The goal is faithful formalization of the
paper's circuit construction, with local finite matrix semantics in Lean.

### 1. Paper Anchors

Use the following paper locations as the source of truth.  If you do not have
the LaTeX source, locate the same material by lemma, theorem, equation, or figure
names in the arXiv PDF.

| Paper object | Local source anchor | What it supplies |
|---|---:|---|
| Banded sparse-access oracle | `main.tex:784-798` | Sparse access to banded derivative matrix entries |
| Sparse-amplitude oracle | `main.tex:822-843` | Amplitude oracle for sparse matrix entries |
| Piecewise polynomial function oracle | `main.tex:870-908` | The oracle for $f(x)$ |
| Sparse-register preparation $H_W^{(\kappa)}$ | `main.tex:948-955` | Uniform sparse-index preparation, cited from Shukla-Vedula |
| Indicator unitary $U_{\mathrm{indic}}$ | `main.tex:1056-1066` | Marks bulk versus boundary part |
| Boundary controlled $R_y$ rotations | `main.tex:1077-1085` | Boundary amplitude rotations using the Robin entries |
| One-term Robin theorem | `main.tex:1098-1109` | The target theorem for $A_k=f(x)\partial_x^m$ |
| Eq. `ROBIN clarified` and gamma slices | `main.tex:1111-1119` | The clarified Robin boundary branch decomposition |
| Fig. 4 and caption | `main.tex:1122-1164` | Full one-term Robin circuit diagram and explanation |
| Block-encoding definition | `main.tex:2027-2035` | What it means for the selected block to encode the operator |

Important interpretation:

- The paper gives a circuit construction.  The remaining Lean work is not to
  invent a new oracle and not to change the theorem assumptions.
- The current Lean formalization is focused on the finite $n=3$ gamma3 boundary
  packet of the one-term Robin construction.  This is a finite matrix proof
  problem extracted from Fig. 4 and Eq. `ROBIN clarified`.
- The sparse preparation $H_W^{(\kappa)}$ should be treated as an explicit
  cited contract, not recursively reproved from scratch inside this target.

### 2. Current Lean Status

The project check currently passes, but with two known diagnostic `sorry`s in
`QuantumBlockEncoding/RobinMatrix.lean`.

The two `sorry` declarations are:

```lean
theorem oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3 :
    oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3 := by
  sorry
```

and

```lean
theorem oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3 :
    evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)) =
      oneTermRobinGamma3BoundarySevenGateMatrix_n3 := by
  sorry
```

These are diagnostic/backlog statements.  They should not be used as the main
source-correct route unless you can prove them safely.  Previous attempts to
prove raw symbolic `Coeff` constructor equality by unfolding, `rfl`, or
`native_decide` hit max recursion or memory blow-up.  The intended route is an
evaluation-level finite matrix proof using `Coeff.evalWith`.

### 3. Active Target

The active target is a finite projection feeder:

```lean
def oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
    (env : String → Rat) : Prop :=
  Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

This says:

After evaluating symbolic coefficients in an environment `env`, the selected
signal-zero entry of the active seven-gate Robin boundary circuit equals the
backend branch summation for the gamma3 boundary branch.

In plain language: prove that the finite matrix product coming from the circuit
has the same selected entry as the branch formula extracted from the paper's
Robin boundary construction.

### 4. Already Compiled Bridges

Several useful bridges already compile.  Please use these as fixed facts, not
as things to rediscover.

The active target is equivalent to an uncast entry of the seven-gate circuit
semantics:

```lean
theorem
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3
    (env : String → Rat) :
    oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env ↔
      Coeff.evalWith env
        ((evalGateMatrices
          (GHL2025.oneTermRobinGateMatrixPlaceholders
            (oneTermParameters 3)))
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3) =
        Coeff.evalWith env
          (blockExtractionBranchContributionSum
            oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

The backend fold already collapses to the selected slot contribution:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
    (env : String → Rat) :
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3) =
    Coeff.evalWith env
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

Therefore a strict smaller feeder is:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders
      (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
  Coeff.evalWith env
    oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

This strict feeder is already connected to the named target by:

```lean
theorem
    oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3
    (env : String → Rat) :
    (Coeff.evalWith env
        ((evalGateMatrices
          (GHL2025.oneTermRobinGateMatrixPlaceholders
            (oneTermParameters 3)))
          oneTermRobinGamma3BoundaryPrefixRow0_n3
          oneTermRobinGamma3BoundaryPrefixRow0_n3) =
      Coeff.evalWith env
        oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution) ↔
      oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The source-prepared Fig. 4 route is also wired, but it still needs the finite
feeder above:

```lean
theorem
    oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H)
    (hFold :
      oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env) :
    (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

So the expected proof route is:

1. Prove the evaluation-level finite feeder.
2. Use
   `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3`
   to obtain `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.
3. Use
   `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3`
   under the explicit `hUniform` contract to connect back to the source-prepared
   Fig. 4 circuit.

### 5. Backend Branch Definition

The backend summand is:

```lean
def oneTermRobinGamma3BoundaryBackendBranchContribution_n3
    (s : Fin 7) : Coeff :=
  Coeff.mul
    (oneTermRobinGamma3BoundarySevenGateMatrix_n3
      (oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s)
      (oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s))
    oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor
```

The selected branch theorem already compiles:

```lean
theorem oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3 :
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        oneTermRobinGamma3BoundaryBranchContributionFocusedSlot =
      oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

The vanishing of the other slots and collapse to selected slot are already
compiled at evaluation level.  Do not spend effort reproving those unless your
proof needs a more precise named lemma.

### 6. Useful Matrix Semantics Lemmas

The codebase has local finite-matrix lemmas for evaluated symbolic products.
Use them instead of trying raw symbolic equality.

```lean
theorem Matrix.evalWith_mul_apply
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      (List.finRange mid).foldl
        (fun acc k => acc + Coeff.evalWith env (A i k) *
          Coeff.evalWith env (B k j))
        0
```

```lean
theorem Matrix.evalWith_mul_eq_zero_of_all_paths_zero
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols)
    (hzero : ∀ k : Fin mid,
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) = 0
```

```lean
theorem Matrix.evalWith_mul_unique_path
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) (k0 : Fin mid)
    (hzero : ∀ k : Fin mid, k ≠ k0 →
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      Coeff.evalWith env (A i k0) * Coeff.evalWith env (B k0 j)
```

```lean
theorem Matrix.evalWith_mul_two_path
    (env : String → Rat) {rows mid cols : Nat}
    (A : Matrix rows mid Coeff) (B : Matrix mid cols Coeff)
    (i : Fin rows) (j : Fin cols) (k0 k1 : Fin mid)
    (hk0_ne_k1 : k0 ≠ k1)
    (hzero : ∀ k : Fin mid, k ≠ k0 → k ≠ k1 →
      Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j) = 0) :
    Coeff.evalWith env (Matrix.mul A B i j) =
      Coeff.evalWith env (A i k0) * Coeff.evalWith env (B k0 j) +
      Coeff.evalWith env (A i k1) * Coeff.evalWith env (B k1 j)
```

```lean
theorem Matrix.evalWith_mul_identity_right_apply
    (env : String → Rat) {n : Nat}
    (A : Matrix n n Coeff) (i j : Fin n) :
    Coeff.evalWith env (Matrix.mul A (Matrix.identity n Coeff) i j) =
      Coeff.evalWith env (A i j)
```

### 7. Rejected Or Stale Routes

Please do not solve the problem by doing any of the following:

- Do not change the GHL theorem assumptions.
- Do not alter the gate order in Fig. 4.
- Do not treat the H-free seven-gate backend as the whole Fig. 4 circuit.  Fig. 4
  also has the sparse preparation/unpreparation $H_W^{(\kappa)}$ and
  $(H_W^{(\kappa)})^\dagger$ sides.
- Do not add `hUniform` to a target that was meant to be arbitrary in `H`,
  unless you explicitly route through the already compiled source-prepared bridge
  above.
- Do not mark the full oracle, $H_W$, $R_y$, LCU, QSVT, normalizer, or final
  block-correctness theorem as proved.  The current remaining target is much
  narrower: a finite matrix projection/evaluation equality for the focused
  gamma3 boundary packet.
- Do not try to close the proof by raw symbolic `Coeff` constructor equality
  unless you actually prove it without unfolding blow-up.  The intended route is
  semantic equality after `Coeff.evalWith`.
- Do not replace the paper circuit with a new circuit.

### 8. What I Need From You

Please give a patch-like proof plan, not only high-level philosophy.

I need:

1. A source-faithful natural-language proof strategy, explicitly tied to the
   paper anchors above.
2. A dependency-ordered list of small Lean lemma statements that should close
   the finite projection feeder.
3. Suggested Lean proof scripts or tactic skeletons for each lemma.
4. A minimal patch strategy for proving either:

   ```lean
   oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
   ```

   or the strict feeder:

   ```lean
   Coeff.evalWith env
     ((evalGateMatrices
       (GHL2025.oneTermRobinGateMatrixPlaceholders
         (oneTermParameters 3)))
       oneTermRobinGamma3BoundaryPrefixRow0_n3
       oneTermRobinGamma3BoundaryPrefixRow0_n3) =
     Coeff.evalWith env
       oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
   ```

5. If the two diagnostic `sorry` theorems should not be proved directly, explain
   how to refactor them truthfully so that the repo can have no `sorry` while
   not falsely claiming theorem closure.
6. For every proposed lemma, state whether it is:
   - a GHL paper contribution,
   - an external cited contract, or
   - QBE-local finite matrix semantics.

### 9. Expected Reasoning Shape

The best answer will probably isolate one or two surviving finite paths in the
evaluated seven-gate product, use `Matrix.evalWith_mul_unique_path` or
`Matrix.evalWith_mul_two_path`, and compare the resulting evaluated coefficient
with the already compiled selected backend slot.

Please be very explicit about which intermediate indices survive and which
entries vanish.  If the exact indices cannot be inferred without the local code,
give a parametric Lean lemma pattern that I can instantiate once I paste the
local definitions.

## Local Reintegration Notes For ABEIS

When ChatGPT Pro returns an answer, paste it back into the ABEIS conversation.
The answer should be checked against:

- `QuantumBlockEncoding/RobinMatrix.lean`
- `QuantumBlockEncoding/CircuitSemantics.lean`
- `proof-obligations/QBE-AUTO-002.md`
- `verifier-feedback/QBE-AUTO-002/finite-projection-feeder-final-middle-20260613-0624.json`

The local verification gate remains:

```bash
python3 tools/qbe.py check
lake build
lake build Tests
rg -n "\bsorry\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean'
```

The target outcome is not to claim full GHL reproduction immediately.  The target
outcome is to remove or truthfully retire the two diagnostic `sorry`s while
closing the finite projection feeder that supports the source-prepared one-term
Robin case-study route.
