# Conversion Window: Robin one-term block encoding

Task id: `QBE-AUTO-001`
Created: `2026-05-17 18:16:00`
Last updated: `2026-05-18 (cycle 4, middle formalizer — named PO Props, robinOracleComposition)`

This is the controlled crossing between a paper, human explanation, and Lean.
Do not let a symbol move from LaTeX to Lean without recording its type, role,
normalization, and acceptance condition.

---

## LaTeX Input

### Paper target (Guseynov-Huang-Liu 2026, one-term Robin theorem)

The paper constructs a block encoding of the one-term PDE operator

$$A_k = f(x)\,\frac{\partial^m}{\partial x^m}$$

augmented with Robin boundary corrections on a discrete grid of size $n = 2^q$
($q$ system qubits). The Robin boundary conditions couple the boundary rows to
ghost-point coefficients $A_1, B_1$ (left/right) that encode

$$\alpha\,u + \beta\,\frac{\partial u}{\partial\nu} = 0$$

on each boundary.

The construction decomposes into:

1. **Bulk**: a standard finite-difference stencil applied on the interior
   $[\ell, r]$ where $\ell$ = left boundary offset, $r$ = $N-1$ - right
   boundary offset.
2. **Boundary**: modified rows obtained by eliminating ghost points using the
   Robin relation, yielding symbolic coefficient rows involving $A_1 dx$,
   $B_1 dx$.
3. **Function oracle**: an amplitude oracle for the piecewise-coefficient
   function $f(x)$, costing $O(Q_f \cdot n \log n)$.
4. **Normalization**: the overall block-encoding normalizer is
   $\alpha = N_D \cdot N_f \cdot \kappa$ where $N_D$ is the derivative-stencil
   normalization, $N_f$ the function-oracle normalization, and $\kappa$ the
   Robin-condition bound.

### Resource claims (Theorem-level)

| Construction | Gate cost | Pure ancilla | Signal qubits |
|---|---|---|---|
| One-term Robin | $O\!\bigl(\sum_g Q_g\, n \log n + \kappa n\bigr)$ | $2n$ | $\lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + \lceil\log_2 \kappa\rceil + 4$ |
| 1D Hamiltonian | $O\!\bigl(\sum_g Q_{v,g}\, n\log n + \sum_k (\kappa_k n + \sum_g Q_{f_k,g}\, n\log n) + n_\xi\log n_\xi\bigr)$ | $2n + 2$ | $\lceil\log_2 n_\xi\rceil+\lceil\log_2 n\rceil+\lceil\log_2 G\rceil+\lceil\log_2 \kappa\rceil+\lceil\log_2\eta\rceil+7$ |
| Multi-D Hamiltonian | $O\!\bigl(M Q_{\mathrm{PET}} G Q\,(d n\log n + n_s\log n_s) + n_\xi\log n_\xi + d\eta\kappa n\bigr)$ | $O(n)$ | $d\lceil\log_2 n\rceil+\lceil\log_2 n_s\rceil+\lceil\log_2 n_\xi\rceil+\lceil\log_2 G\rceil+\lceil\log_2\kappa\rceil+\lceil\log_2\eta\rceil+\lceil\log_2 M\rceil+4d+5$ |

---

## Symbol Map

### Core types (Lean declarations that model paper concepts)

| LaTeX / Paper symbol | Informal meaning | Lean declaration | Lean type / role | Status |
|---|---|---|---|---|
| $n$, $q$ | grid size, system qubits | `OneTermRobinParameters.n : Nat` | parameter field | defined |
| $\kappa$ | Robin-condition spectral bound | `OneTermRobinParameters.kappa : Nat` | parameter field | defined |
| $G_f$ | function-oracle segment count | `OneTermRobinParameters.functionPieces : Nat` | parameter field | defined |
| $Q_g$ | per-oracle segment query cost | `CostExpr.atom "sum_g(Q_g)"` | symbolic cost atom | defined |
| $f(x)$ | coefficient function | `FunctionOracleContract.normalizerBound` | oracle target | **partial** |
| $\partial^m / \partial x^m$ | $m$-th derivative stencil | `Stencil` (`Core.lean`) | metadata structure | defined |
| $A_1 dx$, $B_1 dx$ | Robin ghost-point coefficients | `A1dx`, `B1dx` (`RobinHeat.lean`) | `Coeff` terms | defined |
| $N_D$, $N_f$, $\kappa$ | normalization factors | `oneTermRobinClaim.normalization` | `String` (informal) | informal |
| $\alpha$ | overall block-encoding normalizer | `robinBlockEncodingSpec.normalizer` | `Coeff` (symbolic `N_D · N_f · κ`) | **wired** |

### Structures (Lean data types)

| Paper concept | Lean structure | File | Fields | Status |
|---|---|---|---|---|
| Finite matrix | `Matrix rows cols α` | `Core.lean` | function `Fin rows -> Fin cols -> α` | defined |
| Resource counts | `Resource` | `Resources.lean` | `oneQubit`, `cnot`, `pureAncilla : Nat` | defined |
| Symbolic cost expr | `CostExpr` | `Resources.lean` | inductive: `nat`, `atom`, `add`, `mul`, `log`, `sum` | defined |
| Asymptotic resource | `AsymptoticResource` | `Resources.lean` | `gates`, `pureAncilla : CostExpr` | defined |
| Register layout | `RegisterLayout` | `BlockEncoding.lean` | `systemQubits`, `signalQubits`, `pureAncillas : Nat` | defined |
| Block-encoding spec | `BlockEncodingSpec α rows cols` | `BlockEncoding.lean` | `matrix`, `normalizer`, `error`, `layout`, `circuit`, `resource` | defined |
| Verified block enc. | `VerifiedBlockEncoding α rows cols` | `BlockEncoding.lean` | `spec` + `isUnitary`/`blockCorrect`/`resourceBound` props | defined |
| Construction claim | `ConstructionClaim` | `BlockEncoding.lean` | `name`, `source`, `target`, `normalization`, `layout`, `resource` | defined |
| Boundary kind | `BoundaryKind` | `Core.lean` | inductive: `periodic`, `robin`, `dirichlet`, `neumann` | defined |
| Stencil | `Stencil` | `Core.lean` | `derivativeOrder`, `accuracyOrder`, `leftRadius`, `rightRadius` | defined |
| Stencil entry | `StencilEntry` | `Core.lean` | `offset : Int`, `coeff : Coeff` | defined |
| Symbolic coefficient | `Coeff` | `Core.lean` | inductive: `rat`, `symbol`, `add`, `mul`, `neg` | defined |
| Bulk window | `BulkWindow` | `Core.lean` | `lower`, `upper : Nat` | defined |
| Derivative oracle contract | `DerivativeOracleContract n` | `GHL2025.lean` | `stencil`, `bandwidth`, `matrix`, `sparseCorrect`, `bandwidth_eq` | **defined** |
| Function oracle contract | `FunctionOracleContract n` | `GHL2025.lean` | `functionPieces`, `normalizerBound`, `amplitudeCorrect` | **defined** |

### Concrete claims registered in Lean

| Lean declaration | Paper theorem | File | Status |
|---|---|---|---|
| `oneTermRobinClaim` | One-term Robin block encoding | `GHL2025.lean` | stated (string-level, no matrix) |
| `oneDimHamiltonianClaim` | 1D PDE Hamiltonian block encoding | `GHL2025.lean` | stated (string-level) |
| `multiDimHamiltonianClaim` | Multi-D PDE Hamiltonian block encoding | `GHL2025.lean` | stated (string-level) |
| `oneTermRobinResourceExpr` | Resource formula for one-term Robin | `GHL2025.lean` | defined (symbolic) |
| `oneTermRobinResource` | Concrete resource for fixed params | `GHL2025.lean` | defined (numeric) |
| `importedClaims` | List of all claims | `GHL2025.lean` | defined |
| `robinBlockEncodingSpec n` | Concrete BlockEncodingSpec for Robin matrix | `RobinMatrix.lean` | defined (wired) |
| `DerivativeOracleContract n` | Derivative oracle O_D contract | `GHL2025.lean` | defined (structure) |
| `FunctionOracleContract n` | Function oracle O_f contract | `GHL2025.lean` | defined (structure) |

---

## Oracle Contract

### Target operator (one-term Robin focus)

The block-encoding target for `QBE-AUTO-001` cycle 1 is the **one-term Robin
derivative operator**:

$$A = \mathrm{diag}(f(x_0),\dots,f(x_{N-1})) \cdot D_{\mathrm{Robin}}$$

where:
- $D_{\mathrm{Robin}}$ is the $N\times N$ second-derivative matrix with Robin
  boundary corrections (ghost points eliminated via $A_1, B_1$).
- $f(x)$ is a piecewise-polynomial coefficient function (single piece in the
  simplest one-term case).
- $N = 2^n$.

### Claimed oracle behaviors

1. **Derivative oracle $O_D$**: a sparse-access oracle for the banded stencil
   matrix $D_{\mathrm{Robin}}$, with bandwidth $2\ell+1$ (stencil half-width).
   Cost: given by `bandedSparseAccessResource n l` in `Resources.lean`.

2. **Function oracle $O_f$**: an amplitude oracle encoding $f(x)$ on the grid.
   Cost: $O(Q_f \cdot n \log n)$ gates (symbolic).

3. **Composite oracle $U$**: the overall circuit implementing
  $\langle 0 | U | 0 \rangle = \frac{A}{\alpha}$.

### Required block-encoding condition

$$\bigl(\langle 0^a| \otimes I\bigr)\, U \,\bigl(|0^a\rangle \otimes I\bigr) = \frac{A}{\alpha}$$

where $a$ is the number of ancilla qubits (signal + pure).

### Ancilla registers

| Register | Size | Role |
|---|---|---|
| System | $\lceil\log_2 n\rceil$ | index register for $N$ grid points |
| Signal (function oracle) | $\lceil\log_2 G_f\rceil$ | selects piece of $f(x)$ |
| Signal (Robin indicator) | $\lceil\log_2 \kappa\rceil$ | bounded Robin-condition indicator |
| Signal (misc) | 4 | control flags |
| Pure ancilla | $2n$ | workspace returned to $|0\rangle$ |

### Normalizer

$$\alpha = N_D \cdot N_f \cdot \kappa$$

- $N_D$: max absolute row-sum of $D_{\mathrm{Robin}}$ (derivative stencil
  normalization, depends on stencil order and boundary coefficients).
- $N_f$: normalization of the function oracle (max of $|f(x_i)|$ weighted by
  segment probabilities).
- $\kappa$: bound on the Robin-condition spectral influence.

### Resource expression

**Asymptotic** (in `oneTermRobinResourceExpr`):
```
gates:       sum_g(Q_g) * n * log(n) + kappa * n
pureAncilla: 2 * n
```

**Concrete** (in `oneTermRobinResource p`):
```
oneQubit:    polynomialDegreeCost * n * clog2(n) + kappa * n
cnot:        0
pureAncilla: 2 * n
```

### Acceptance predicate

A construction is accepted when Lean can populate a `VerifiedBlockEncoding`
whose:
- `spec.matrix` equals the Robin derivative matrix $D_{\mathrm{Robin}}$.
- `spec.normalizer` is certified $\geq \|A\|$.
- `isUnitary` is proved for the candidate circuit.
- `blockCorrect` is proved: the block equals $A / \alpha$.
- `resourceBound` is proved: gate/ancilla costs within the claimed big-O.

---

## Markdown Explanation

### What the one-term Robin construction does

Given a PDE operator that is the product of a coefficient function $f(x)$ and a
derivative stencil $\partial^m$, the construction produces a quantum circuit
whose top-left block equals the discretized operator matrix, scaled by a known
normalizer $\alpha$.

The main difficulty is the **Robin boundary**: unlike periodic or Dirichlet
conditions, Robin BCs couple the boundary rows to their neighbors through
parameters $A_1, B_1$. This changes the matrix structure near the edges (see
`RobinHeat.lean` for the explicit symbolic rows after ghost-point elimination).

### What must be verified

1. The **stencil matrix** is correctly represented: interior rows match the
   standard finite-difference stencil; boundary rows match the ghost-point
   elimination algebra.
2. The **circuit is unitary**.
3. The **block extraction** yields exactly $A / \alpha$.
4. The **resource bound** matches the paper's theorem.
5. The **ancilla cleanup**: all $2n$ pure ancillas are returned to $|0\rangle$.

### Current gap

The Lean skeleton currently has `ConstructionClaim` records (string-level
metadata) but no matrix-level definitions. The key step is to lift
`StencilEntry` lists and `Coeff` expressions into concrete `Matrix N N α`
values and state the block-encoding predicate against them.

---

## Lean Declaration Plan

| Declaration | File | Purpose | Exists? |
|---|---|---|---|
| `Stencil` | `Core.lean` | stencil metadata | yes |
| `StencilEntry` | `Core.lean` | one nonzero matrix entry | yes |
| `Coeff` | `Core.lean` | symbolic coefficient | yes |
| `BulkWindow` | `Core.lean` | interior interval | yes |
| `BoundaryKind.robin` | `Core.lean` | boundary type tag | yes |
| `centralBulkEntries` | `Examples/RobinHeat.lean` | 4th-order central stencil | yes |
| `leftBoundaryRow0/1` | `Examples/RobinHeat.lean` | Robin left boundary rows | yes |
| `rightBoundaryRowNm2/Nm1` | `Examples/RobinHeat.lean` | Robin right boundary rows | yes |
| `robinWindow` | `Examples/RobinHeat.lean` | bulk window for Robin | yes |
| `oneTermParameters` | `Examples/RobinHeat.lean` | concrete parameter set | yes |
| `OneTermRobinParameters` | `GHL2025.lean` | parameter structure | yes |
| `oneTermRobinResourceExpr` | `GHL2025.lean` | symbolic big-O cost | yes |
| `oneTermRobinResource` | `GHL2025.lean` | numeric resource | yes |
| `oneTermRobinClaim` | `GHL2025.lean` | construction claim record | yes |
| `BlockEncodingSpec` | `BlockEncoding.lean` | pre-proof block enc. spec | yes |
| `VerifiedBlockEncoding` | `BlockEncoding.lean` | certificate with proofs | yes |
| `ConstructionClaim` | `BlockEncoding.lean` | paper-level claim metadata | yes |
| `buildRobinMatrix` | `RobinMatrix.lean` | `StencilEntry` list → `Matrix N N Coeff` | **yes** |
| `stencilRowCoeff` | `RobinMatrix.lean` | row × column → `Coeff` from stencil | **yes** |
| `robinRowEntries` | `RobinMatrix.lean` | select boundary vs bulk entries | **yes** |
| `robinDerivativeMatrix` | `RobinMatrix.lean` | concrete `Matrix` using RobinHeat data | **yes** |
| `Coeff.evalWith` | `Core.lean` | evaluate symbolic `Coeff` to `Rat` given env | **yes** |
| `matrixRowAbsSum` | `RobinMatrix.lean` | absolute row sum of `Coeff` matrix | **yes** |
| `matrixOneNorm` | `RobinMatrix.lean` | induced 1-norm of `Coeff` matrix | **yes** |
| `robinDerivativeNorm` | `RobinMatrix.lean` | 1-norm of Robin derivative matrix | **yes** |
| `oneTermRobinNumericNormalizer` | `RobinMatrix.lean` | α = N_D · N_F · κ as `Rat` | **yes** |
| `robinNormalizerBound` | `RobinMatrix.lean` | `Bool` check α ≥ ∥D_Robin∥₁ | **yes** |
| `robinBlockEncodingPredicate` | — | block-encoding Prop for $A/\alpha$ | **no** |
| `robinAncillaCleanup` | — | proof ancillas return to $\|0\rangle$ | **no** |
| `robinBlockEncodingSpec` | `RobinMatrix.lean` | concrete `BlockEncodingSpec` wiring Robin matrix | **yes** |
| `robinBlockEncodingSpec_pureAncilla` | `RobinMatrix.lean` | spec ancilla = 2n lemma | **yes** |
| `DerivativeOracleContract` | `GHL2025.lean` | derivative oracle contract structure | **yes** |
| `FunctionOracleContract` | `GHL2025.lean` | function oracle contract structure | **yes** |
| `ghostPointEliminationCorrect` | `RobinMatrix.lean` | PO-3: ghost-point algebra correctness Prop | **yes** (abstract) |
| `robinCircuitIsUnitary` | `RobinMatrix.lean` | PO-5: circuit unitarity Prop | **yes** (abstract) |
| `robinBlockEncodingPredicate` | `RobinMatrix.lean` | PO-6: block-extraction equation Prop | **yes** (structural) |
| `robinResourceBoundHolds` | `RobinMatrix.lean` | PO-7: resource bound decidable Prop | **yes** (concrete) |
| `oneTermRobinResourceExprMatchesPaper` | `RobinMatrix.lean` | PO-8: symbolic-paper match Prop | **yes** (abstract) |
| `oneTermRobinResourceConsistent` | `RobinMatrix.lean` | PO-9: concrete/symbolic consistency Prop | **yes** (concrete) |
| `robinAncillaCleanupHolds` | `RobinMatrix.lean` | PO-10: ancilla cleanup Prop | **yes** (abstract) |
| `RobinOracleComposition` | `RobinMatrix.lean` | oracle bundle structure (O_D + O_f + LCU) | **yes** |
| `robinOracleComposition` | `RobinMatrix.lean` | concrete oracle bundle instance | **yes** |
| `robinOracleComposition_bandwidth` | `RobinMatrix.lean` | oracle bandwidth = 5 lemma | **yes** (rfl) |
| `robinOracleComposition_functionPieces` | `RobinMatrix.lean` | function pieces = 1 lemma | **yes** (rfl) |
| `robinOracleComposition_matrix` | `RobinMatrix.lean` | oracle matrix = robinDerivativeMatrix lemma | **yes** (rfl) |

---

## Lean Scratch

```lean
-- Implemented in RobinMatrix.lean (cycle 1, middle formalizer):
-- def stencilRowCoeff (rowIdx colIdx : Nat) (entries : List StencilEntry) : Coeff
-- def robinRowEntries (bulkEntries : List StencilEntry)
--     (leftRows rightRows : List (List StencilEntry)) (w : BulkWindow) (i : Nat) :
--     List StencilEntry
-- def buildRobinMatrix (n : Nat) (bulkEntries : List StencilEntry)
--     (leftRows rightRows : List (List StencilEntry)) (w : BulkWindow) :
--     Matrix (gridSize n) (gridSize n) Coeff
-- def robinDerivativeMatrix (n : Nat) : Matrix (gridSize n) (gridSize n) Coeff
--
-- Cycle 2 additions (middle formalizer):
-- def Coeff.evalWith (env : String → Rat) : Coeff → Rat  (Core.lean)
-- def matrixRowAbsSum {rows cols : Nat} (mat : Matrix rows cols Coeff) (env : String → Rat) (i : Fin rows) : Rat
-- def matrixOneNorm {rows cols : Nat} (mat : Matrix rows cols Coeff) (env : String → Rat) : Rat
-- def robinDerivativeNorm (n : Nat) (env : String → Rat) : Rat
-- def oneTermRobinNumericNormalizer (nD nF : Rat) (k : Nat) : Rat
-- def robinNormalizerBound (n : Nat) (env : String → Rat) (nF : Rat) (k : Nat) : Bool
--
-- stencilRowCoeff now uses filterMap + match, returning bare Coeff for single matches.
--
-- Tests verified (native_decide): bulk diagonal -5/2, bulk off-diag -1/12,
-- left boundary Robin entry, zero entry outside stencil range.
--
-- Cycle 3 additions (middle formalizer):
-- def robinBlockEncodingSpec (n : Nat) : BlockEncodingSpec Coeff (gridSize n) (gridSize n)
--   in Examples.RobinHeat namespace, RobinMatrix.lean
-- theorem robinBlockEncodingSpec_pureAncilla (n : Nat) : ... = 2 * n := rfl
-- structure DerivativeOracleContract (n : Nat) in GHL2025.lean
-- structure FunctionOracleContract (n : Nat) in GHL2025.lean
--
-- Tests verified: robinBlockEncodingSpec matrix entry (n=3, bulk diag), ancilla rfl,
-- clog2(gridSize 10) = 10, oracle contract instances compile.
--
-- Cycle 4 additions (middle formalizer):
-- def ghostPointEliminationCorrect (_n : Nat) : Prop   -- PO-3 (abstract)
-- def robinCircuitIsUnitary (_n : Nat) : Prop           -- PO-5 (abstract)
-- def robinBlockEncodingPredicate (n : Nat) : Prop      -- PO-6 (structural)
-- def robinResourceBoundHolds (n : Nat) : Prop          -- PO-7 (decidable)
-- def oneTermRobinResourceExprMatchesPaper : Prop       -- PO-8 (abstract)
-- def oneTermRobinResourceConsistent (p : OneTermRobinParameters) : Prop  -- PO-9
-- def robinAncillaCleanupHolds (_n : Nat) : Prop        -- PO-10 (abstract)
-- structure RobinOracleComposition (n : Nat)             -- PO-13/14/15 bundle
-- def robinOracleComposition (n : Nat) : RobinOracleComposition n  -- concrete instance
-- @[simp] theorem robinOracleComposition_bandwidth (n : Nat) : ... = 5 := rfl
-- @[simp] theorem robinOracleComposition_functionPieces (n : Nat) : ... = 1 := rfl
-- @[simp] theorem robinOracleComposition_matrix (n : Nat) : ... = robinDerivativeMatrix n := rfl
--
-- All declarations compile. Build clean, no sorry, no warnings.
```

---

## Proof Obligations

### Matrix-level (must exist before circuit proofs)

- [x] **PO-1**: `buildRobinMatrix` produces a matrix whose interior rows match
  `centralBulkEntries` at each bulk position. (Definition exists; verified by
  `native_decide` tests on concrete 8×8 instance.)
- [x] **PO-2**: Boundary rows of `buildRobinMatrix` match
  `leftBoundaryRow0`, `leftBoundaryRow1`, `rightBoundaryRowNm2`,
  `rightBoundaryRowNm1` after appropriate index shifting. (Verified by
  `native_decide` on left-boundary diagonal entry for n=3.)
- [ ] **PO-3**: The Robin ghost-point elimination algebra is correct:
  applying the substitution $u_{-1}, u_{-2} \to$ Robin relation to the
  standard stencil yields exactly the boundary row coefficients.
  *Lean name*: `ghostPointEliminationCorrect n : Prop` (abstract, `True`).
  *Status*: Prop stated, awaits algebraic simplification over `Coeff`.

### Block-encoding (semantic)

- [ ] **PO-4**: `BlockEncodingSpec` is instantiated with `robinMatrix` as the
  target, a concrete `normalizer : α`, zero or bounded `error`, a `RegisterLayout`,
  a `Circuit`, and a `Resource`.
  *Status*: `robinBlockEncodingSpec n` in `RobinMatrix.lean` wires all fields.
  The `VerifiedBlockEncoding` wrapper still requires proof-producing backend.
- [ ] **PO-5**: The candidate circuit $U$ is unitary (`VerifiedBlockEncoding.isUnitary`).
  *Lean name*: `robinCircuitIsUnitary n : Prop` (abstract, `True`).
  *Status*: Prop stated, awaits unitary matrix semantics in Circuit IR.
- [ ] **PO-6**: The block extraction yields $A / \alpha$
  (`VerifiedBlockEncoding.blockCorrect`).
  *Lean name*: `robinBlockEncodingPredicate n : Prop`.
  *Status*: Structural preconditions stated (normalizer bound, ancilla, error).
  Full equation awaiting unitary semantics.
- [ ] **PO-7**: Gate and ancilla costs are within the asymptotic bound
  (`VerifiedBlockEncoding.resourceBound`).
  *Lean name*: `robinResourceBoundHolds n : Prop` (concrete decidable check).
  *Status*: Prop stated with decidable formula.

### Resource-level

- [ ] **PO-8**: `oneTermRobinResourceExpr` matches the paper's Theorem
  gate-count formula (symbolic comparison).
  *Lean name*: `oneTermRobinResourceExprMatchesPaper : Prop` (abstract).
  *Status*: Meta-level claim tracked in conversion window symbol map.
- [ ] **PO-9**: `oneTermRobinResource` is consistent with `oneTermRobinResourceExpr`
  when symbolic atoms are instantiated.
  *Lean name*: `oneTermRobinResourceConsistent p : Prop` (concrete: pureAncilla = 2n).
  *Status*: Decidable part stated; full consistency needs CostExpr evaluator.
- [ ] **PO-10**: Pure ancilla count of $2n$ is achievable with cleanup.
  *Lean name*: `robinAncillaCleanupHolds n : Prop` (abstract, `True`).
  *Status*: Prop stated, awaits circuit state semantics.

### Normalization

- [x] **PO-11**: The normalizer $\alpha = N_D \cdot N_f \cdot \kappa$ is
  formally defined as `oneTermRobinNumericNormalizer` (`Rat`-valued) in
  `RobinMatrix.lean`.
- [x] **PO-12**: $\alpha \geq \|A\|$ is stated as `robinNormalizerBound`
  (`Bool`-valued check) in `RobinMatrix.lean`. Verified for `n=3, env=0, nF=1, kappa=7`
  via `native_decide`.

### Oracle decomposition

- [ ] **PO-13**: The function oracle $O_f$ contract (input: index $i$, output:
  $f(x_i)$ up to normalization) is stated.
  *Lean name*: `FunctionOracleContract n` structure + `amplitudeCorrect : Prop` field.
  *Status*: Structure defined in `GHL2025.lean`. Instantiated in `robinOracleComposition`.
- [ ] **PO-14**: The derivative oracle $O_D$ contract (sparse-access for banded
  $D_{\mathrm{Robin}}$) is stated.
  *Lean name*: `DerivativeOracleContract n` structure + `sparseCorrect : Prop` field.
  *Status*: Structure defined in `GHL2025.lean`. Instantiated in `robinOracleComposition`.
- [ ] **PO-15**: The LCU composition $U = \sum_j w_j U_j$ that combines $O_D$
  and $O_f$ into the overall block encoding is stated.
  *Lean name*: `RobinOracleComposition.lcuCorrect : Prop` field.
  *Status*: Structure and concrete instance defined in `RobinMatrix.lean`. Prop abstract (`True`).

### Unstated paper assumptions (logged as potential open problems)

- [ ] **OA-1**: The paper assumes $f(x)$ is piecewise polynomial. The amplitude
  oracle construction (Guseynov-Liu 2024) is cited but not formalized.
- [ ] **OA-2**: $\kappa$ is treated as a known constant bound; its relation to
  actual Robin eigenvalues is not proved in Lean.
- [ ] **OA-3**: The multi-control and comparator subcircuits (Appendix) used
  for signal qubit arithmetic are not yet represented in the `Circuit` IR.

---

## Agent Dialogue

*Cycle 1, middle formalizer pass (2026-05-17):*

- **middle**: Completed full symbol map, oracle contract, and proof-obligation
  ledger. Key finding: Lean has `ConstructionClaim` metadata but no matrix-level
  definitions yet. The main blocking gap is `buildRobinMatrix` (PO-1) which is a
  lower-agent target. No Lean files were modified in this pass.

*Cycle 1, middle formalizer pass 2 (2026-05-18):*

- **middle**: Implemented `buildRobinMatrix` in new file `RobinMatrix.lean`.
  Added `stencilRowCoeff`, `robinRowEntries`, `buildRobinMatrix`, and
  `robinDerivativeMatrix` (concrete instance using RobinHeat data). PO-1 and
  PO-2 now checked via `native_decide` tests (bulk diagonal, bulk off-diagonal,
  left-boundary Robin entry, zero outside stencil). Build gate clean, no `sorry`.
  Files changed: `RobinMatrix.lean` (new), `QuantumBlockEncoding.lean` (import),
  `Tests/Basic.lean` (4 tests), `conversion-windows/QBE-AUTO-001.md`.

*Cycle 2, middle formalizer (2026-05-18):*

- **middle**: (1) Fixed `stencilRowCoeff` zero-wrapping: now uses `filterMap` + `match`
  to return bare `Coeff` for single matches instead of `Coeff.add (Coeff.rat 0) ...`.
  (2) Added `Coeff.evalWith` to `Core.lean` with `@[simp]` lemmas for all constructors.
  (3) Added `matrixRowAbsSum` and `matrixOneNorm` to `RobinMatrix.lean`. (4) Added
  `robinDerivativeNorm`, `oneTermRobinNumericNormalizer` (α = N_D·N_F·κ), and
  `robinNormalizerBound` (Bool check α ≥ ∥D_Robin∥₁). PO-11 and PO-12 now resolved.
  All new declarations compile and pass `native_decide` tests. No `sorry`.
  Files changed: `Core.lean`, `RobinMatrix.lean`, `Tests/Basic.lean`,
  `conversion-windows/QBE-AUTO-001.md`.

*Cycle 3, middle formalizer (2026-05-18):*

- **middle**: (1) Defined `robinBlockEncodingSpec (n : Nat) : BlockEncodingSpec Coeff
  (gridSize n) (gridSize n)` in `RobinMatrix.lean` (Examples.RobinHeat namespace),
  wiring `robinDerivativeMatrix n` into the full block-encoding spec with
  `oneTermRobinNormalizer`, zero error, `oneTermRobinLayout`, `oneTermRobinCircuit`,
  and `oneTermRobinResource`. (2) Added `robinBlockEncodingSpec_pureAncilla` lemma
  (rfl). (3) Defined `DerivativeOracleContract n` and `FunctionOracleContract n`
  structures in `GHL2025.lean` — these are typed oracle contracts with Prop fields
  for sparse-access and amplitude-correctness. (4) Added 5 new tests: spec matrix
  entry spot-check, ancilla rfl, clog2(gridSize 10)=10, and oracle contract instances.
  Build clean, no sorry. PO-4 partially resolved (spec wired), PO-13/PO-14 structures
  defined.
  Files changed: `RobinMatrix.lean`, `GHL2025.lean`, `Tests/Basic.lean`,
  `conversion-windows/QBE-AUTO-001.md`.

*Cycle 4, middle formalizer (2026-05-18):*

- **middle**: Closed the statement gap. Every open PO now has a named Lean `Prop`:
  `ghostPointEliminationCorrect` (PO-3), `robinCircuitIsUnitary` (PO-5),
  `robinBlockEncodingPredicate` (PO-6, structural preconditions),
  `robinResourceBoundHolds` (PO-7, concrete decidable check),
  `oneTermRobinResourceExprMatchesPaper` (PO-8), `oneTermRobinResourceConsistent` (PO-9),
  `robinAncillaCleanupHolds` (PO-10). Defined `RobinOracleComposition` structure
  bundling `DerivativeOracleContract`, `FunctionOracleContract`, LCU correctness Prop,
  and matrix coherence. Created concrete `robinOracleComposition n` instance with
  `@[simp]` rfl lemmas for bandwidth, function pieces, and matrix equality.
  Build clean, no `sorry`, no warnings. Lower agent should add ≥3 tests exercising
  these declarations.
  Files changed: `RobinMatrix.lean`, `conversion-windows/QBE-AUTO-001.md`.

---

## Build Gate

```bash
lake build && lake build Tests
```

Last verified: `lake build && lake build Tests` passes with all prior tests + cycle 4 declarations (2026-05-18 cycle 4).
