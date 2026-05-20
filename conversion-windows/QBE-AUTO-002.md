# Conversion Window: Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Created: `2026-05-18`

This window connects the paper-level block-encoding equation to the Lean
matrix-semantics backend needed by `QBE-AUTO-001`.

---

## LaTeX Input

The GHL2025 Robin theorem ultimately requires a circuit matrix $U$ such that

$$
  (\langle 0^a| \otimes I) U (|0^a\rangle \otimes I)
  =
  \frac{A_k}{\alpha},
  \qquad
  \alpha = N_D N_f \kappa .
$$

The paper draws $U$ as a composition of labeled gates and oracle calls:

$$
  U
  =
  (O_D^{BS})^\dagger
  \cdot \mathrm{SWAP}
  \cdot O_f
  \cdot O_D^{BS}
  \cdot R_y^{\mathrm{boundary}}
  \cdot O_{D^T}^{S}
  \cdot U_{\mathrm{indic}}.
$$

The first semantics backend target is not to prove each oracle correct, but to
give this product a Lean matrix object once each labeled gate has a matrix.

---

## Markdown Explanation

The previous faithful-mode cycles represented the Robin circuit as Lean data:

- target matrix: `Examples.RobinHeat.robinDerivativeMatrix`
- circuit labels: `GHL2025.oneTermRobinCircuit`
- theorem tuple: `GHL2025.OneTermRobinTheoremData`
- obligations: `GHL2025.RobinProofObligations`

The missing layer was a way to say:

1. each circuit gate has a full-space matrix,
2. the list of matrices corresponds to the list of circuit labels,
3. the full circuit matrix is their ordered product,
4. a block projection of that full matrix should equal the target matrix divided
   by the normalizer.

`CircuitSemantics.lean` now starts this layer without pretending that oracle
correctness is already solved.

---

## Symbol Map

| LaTeX / paper object | Lean declaration | Type / role | Status |
|---|---|---|---|
| `clog2 (gridSize n) = n` | `clog2_gridSize` | proved dimension bridge (Core.lean) | proved |
| `log2 (2^(n+1) - 1) = n` | `log2_pred_two_pow_succ` | supporting arithmetic lemma | proved |
| $2^q$ Hilbert-space dimension | `qubitDim q` | `Nat` | defined |
| Gate matrix $U_g$ | `GateMatrix α q` | gate label + full-space matrix + unitary obligation | defined |
| Gate/matrix alignment | `gateMatricesMatchCircuit` | `Circuit → List GateMatrix → Bool` | defined |
| Matrix product $U_k\cdots U_1$ | `evalGateMatrices` | folds gate matrices into a circuit matrix | defined |
| Circuit semantics | `CircuitMatrixSemantics α q` | circuit + gate matrices + product matrix | defined |
| Block extraction target | `BlockExtractionTarget α rows cols signalDim` | matrix-level statement container | defined |
| Unproved semantic claim | `SemanticObligation` | description/source/proved bool | defined |
| Block projection $(\langle 0^a| \otimes I)M(|0^a\rangle \otimes I)$ | `signalSystemBlockProjection` | extracts signal×system block | defined |
| Total circuit qubits | `totalCircuitQubits` | system + signal qubit count | defined |
| Circuit semantics builder | `CircuitMatrixSemantics.blockExtractionTarget` | builds BlockExtractionTarget from semantics | defined |
| Total Robin circuit qubits | `GHL2025.oneTermRobinTotalQubits` | register partition total = $2n + \lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + 5$ | defined (cycle 2 fix) |
| Effective signal qubits | `GHL2025.effectiveRobinSignalQubits` | totalQubits $- n$ | defined (cycle 2) |
| Indicator bit position | `GHL2025.robinIndicatorBitPosition` | bit position $= 1 + 2n$ | defined (cycle 2) |
| U_indic honest matrix | `GHL2025.indicatorOracleMatrix` | controlled-X permutation on indicator bit | defined (cycle 2) |
| U_indic gate matrix | `GHL2025.oneTermRobinGate_U_indic` | GateMatrix with honest matrix, proved := false | defined (cycle 2 update) |
| O_DT^S diagonal matrix | `GHL2025.sparseAmplitudeOracleDTMatrix` | diagonal encoding for bulk (indicator=1), identity for boundary (indicator=0) | defined (cycle 7) |
| O_DT^S gate matrix | `GHL2025.oneTermRobinGate_O_DT_S` | GateMatrix with honest diagonal matrix, proved := false | defined (cycle 7 update) |
| Ry_boundary honest matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with controlled R_y rotation, proved := false | defined (cycle 8 update) |
| O_D^BS honest permutation matrix | `GHL2025.oneTermRobinGate_O_D_BS` | GateMatrix with proved := false | defined (cycle 4 update: honest permutation) |
| O_D^BS column map | `GHL2025.robinSparseColumnMap` | col(s,i) for Robin stencil | defined (cycle 4) |
| O_D^BS forward matrix | `GHL2025.bandedSparseAccessMatrix` | permutation $|s\rangle|i\rangle \to |s\rangle|\mathrm{col}(s,i)\rangle$ | defined (cycle 4) |
| O_f honest matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix with function-value diagonal matrix, proved := false | defined (cycle 6, fixed cycle 9) |
| SWAP honest matrix | `GHL2025.oneTermRobinGate_SWAP` | GateMatrix with permutation matrix, proved := false | defined (cycle 3 update) |
| SWAP honest matrix | `GHL2025.swapOracleMatrix` | Permutation swapping system/O_D^BS blocks | defined (cycle 3) |
| (O_D^BS)^† inverse permutation matrix | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | GateMatrix with proved := false | defined (cycle 4 update: inverse permutation) |
| (O_D^BS)^† forward matrix | `GHL2025.bandedSparseAccessDaggerMatrix` | transpose of forward permutation | defined (cycle 4) |
| All 7 gate matrices | `GHL2025.oneTermRobinGateMatrixPlaceholders` | List GateMatrix | defined |
| Gate-list alignment theorem | `GHL2025.oneTermRobinPlaceholdersMatch` | gateMatricesMatchCircuit = true | proved |
| Robin circuit semantics | `Examples.RobinHeat.oneTermRobinCircuitSemantics` | CircuitMatrixSemantics for the Robin circuit | defined |
| Robin block extraction target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget` | BlockExtractionTarget with unproved obligations | defined |
| Circuit block encoding claim | `CircuitBlockEncodingClaim` | Schema bundling semantics + target + dim proof + obligation | defined |
| Robin circuit block claim | `Examples.RobinHeat.oneTermRobinCircuitBlockClaim` | CircuitBlockEncodingClaim for Robin, takes dim proof parameter | defined |
| Robin dimension theorem | `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | full dimension = effective signal dim × system dim | proved (cycle 2 update) |
| Default Robin block claim | `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | Robin claim using reusable dimension theorem | defined |
| Sparse amplitude value | `GHL2025.robinSparseAmplitudeValue` | s-th nonzero stencil coefficient for each row, as Coeff | defined (cycle 5) |
| Function value data | `GHL2025.robinFunctionValue` | symbolic f(x_j) = Coeff.symbol "f_{n}_{j}" for each grid point | defined (cycle 9) |
| O_f diagonal matrix | `GHL2025.functionOracleMatrix` | diagonal matrix encoding f(x_j) function values on the diagonal | defined (cycle 6, fixed cycle 9) |
| O_f honest gate matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix with honest function value matrix, proved := false | defined (cycle 6, fixed cycle 9) |
| Ry_boundary honest matrix | `GHL2025.boundaryRotationMatrix` | controlled R_y on ancilla for boundary rows (indicator=0) | defined (cycle 8) |
| Ry_boundary gate matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with honest rotation matrix, proved := false | defined (cycle 8 update) |

---

## Lean Declaration Plan

Already implemented:

```lean
def qubitDim (qubits : Nat) : Nat
structure SemanticObligation
structure GateMatrix (α : Type u) (qubits : Nat)
def gateMatricesMatchCircuit
def evalGateMatrices
structure CircuitMatrixSemantics
def CircuitMatrixSemantics.ofGateMatrices
structure BlockExtractionTarget
def signalSystemBlockProjection
def totalCircuitQubits
def CircuitMatrixSemantics.blockExtractionTarget
def GHL2025.oneTermRobinTotalQubits
def GHL2025.oneTermRobinGate_U_indic
def GHL2025.oneTermRobinGate_O_DT_S
def GHL2025.oneTermRobinGate_Ry_boundary
def GHL2025.oneTermRobinGate_O_D_BS
def GHL2025.oneTermRobinGate_O_f
def GHL2025.oneTermRobinGate_SWAP
def GHL2025.oneTermRobinGate_O_D_BS_dagger
def GHL2025.oneTermRobinGateMatrixPlaceholders
theorem GHL2025.oneTermRobinPlaceholdersMatch
def Examples.RobinHeat.oneTermRobinCircuitSemantics
def Examples.RobinHeat.oneTermRobinBlockExtractionTarget
structure CircuitBlockEncodingClaim
def Examples.RobinHeat.oneTermRobinCircuitBlockClaim
theorem Examples.RobinHeat.oneTermRobinCircuitDimCompat
def Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim
def GHL2025.robinSparseAmplitudeValue
def GHL2025.robinFunctionValue
```

Current oracle matrix declarations:

```lean
def GHL2025.indicatorOracleMatrix ...
def GHL2025.swapOracleMatrix ...
def GHL2025.bandedSparseAccessMatrix ...
def GHL2025.sparseAmplitudeOracleDTMatrix ...
def GHL2025.functionOracleMatrix ...
def GHL2025.boundaryRotationMatrix ...
```

Do not fill these with fake proofs. If the matrix equality is not proved, store
it as `SemanticObligation` or `ObligationRecord` with `proved := false`.

---

## Proof Obligations

- [x] Define the signal/system block projection indexing convention.
- [x] Define `CircuitBlockEncodingClaim` schema to bundle semantics + target.
- [x] Wire Robin circuit semantics to block extraction target via `oneTermRobinCircuitBlockClaim`.
- [x] Prove dimension compatibility `clog2(gridSize n) = n` for general `n`.
- [x] Assign gate matrices to `U_indic`, `O_DT^S`, `Ry_boundary`, `O_D^BS`,
  `O_f`, `SWAP`, and `(O_D^BS)^†` (all seven now have nonzero matrix
  semantics; all `proved := false` for unitarity).
- [ ] Prove or explicitly track unitarity of each gate matrix.
- [x] Prove or explicitly track that the matrix product matches the paper
  circuit order (gate-list match by construction, theorem proved).
- [ ] Prove or explicitly track block correctness:
  $(\langle 0^a| \otimes I) U (|0^a\rangle \otimes I)=A_k/\alpha$.
- [x] Replace placeholder zero matrices with real oracle matrices.
- [x] Update `paper-notes/GHL2025_RobinOneTerm.tex` whenever the Lean semantics
  statement changes.
- [x] Edge-case tests for n=1 dim compat, n=1 circuit block claim, 1×1 block
  projection, n=2 field roundtrip, n=2 circuit identity (cycle 1 lower).
- [x] Define `robinSparseAmplitudeValue` sparse amplitude data layer (cycle 5).
- [x] Replace O_f placeholder with honest diagonal matrix (cycle 6).
- [x] Replace O_DT^S placeholder with honest diagonal matrix conditioned on indicator bit (cycle 7).
- [x] Audit and correct O_f: should encode $f(x_j)/N_f$, not derivative amplitude data. (Fixed cycle 9: O_f now uses `robinFunctionValue`)
- [x] Implement Ry_boundary with honest nonzero matrix (cycle 8: controlled R_y rotation).
- [ ] Replace diagonal approximations with paper's rotation structure (O_DT^S, Ry_boundary).

---

## Edge-Case Tests (Cycle 1)

Five tests validating boundary conditions of the matrix-semantics backend:

1. **n=1 dimension compatibility**: `qubitDim` of total qubits equals signal dim × gridSize 1, checked by `native_decide`.
2. **n=1 circuit block claim dim compat**: `oneTermRobinCircuitDimCompat 1` composes correctly with `CircuitBlockEncodingClaim`, checked by `rfl`.
3. **1×1 system block projection**: `signalSystemBlockProjection` on a trivial 1×1 system returns the single entry, checked by `native_decide`.
4. **n=2 field-access roundtrip**: `targetMatrix` field of `CircuitBlockEncodingClaim` matches `robinDerivativeMatrix` at a bulk diagonal entry, checked by `rfl`.
5. **n=2 circuit identity**: `defaultOneTermRobinCircuitBlockClaim` preserves `oneTermRobinCircuit`, checked by `rfl`.

---

## Register Bit Layout (Cycle 2)

The Robin circuit operates on the qubit registers defined by
`RobinRegisterPartition`.  The bit-position convention (LSB = bit 0) is:

| Register | Bit range (LSB) | Width | Field |
|---|---|---|---|
| ancilla | [0] | 1 | `ancillaQubit` |
| system ($j$) | [1, 1+n) | n | `systemQubits` |
| od_pure_ancilla | [1+n, 1+n+odPure) | $n - \lceil\log_2\kappa\rceil$ | `odPureAncillaQubits` |
| sparse_index ($s$) | [1+n+odPure, 1+n+odPure+sparse) | $\lceil\log_2\kappa\rceil$ | `sparseIndexQubits` |
| indicator (ind) | [1+n+odPure+sparse] | 1 | `indicatorQubit` |
| mf | [2+n+odPure+sparse, totalQubits) | $\lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + 3$ | `mfQubits` |

Key bit positions:

$$\text{indicator\_pos} = 1 + n + (n - \lceil\log_2\kappa\rceil) + \lceil\log_2\kappa\rceil = 1 + 2n$$

$$\text{system\_start} = 1 \quad\text{(ancilla width)}$$

For $n=3, \kappa=7$ (odPure = 0, sparse = 3): indicator at bit 7, system at bits [1,4), total = 13 qubits.

### Total Qubits Fix (F1)

`oneTermRobinTotalQubits` must equal `RobinRegisterPartition.totalQubits`, which includes the `ancillaQubit` visible in the circuit diagram:

$$\text{totalQubits} = m_f + 1 + \lceil\log_2\kappa\rceil + (n - \lceil\log_2\kappa\rceil) + n + 1 = 2n + \lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + 5$$

For $n=3, G_f=1, \kappa=7$: $6 + 2 + 0 + 5 = 13$ (previously 12, which omitted the ancilla qubit).

### Effective Signal Dimension

The block extraction projects all non-system registers onto $|0\rangle$:

$$\text{effectiveSignalQubits} = \text{totalQubits} - n$$

For $n=3$: $13 - 3 = 10$ signal qubits, signal dim $= 2^{10} = 1024$.

The dimension compatibility theorem becomes:

$$2^{\text{totalQubits}} = 2^{\text{effectiveSignalQubits}} \cdot 2^n$$

---

## U_indic Indicator Oracle Matrix (Cycle 2)

The indicator oracle $U_{\mathrm{indic}}(K_1, K_2)$ is a permutation matrix on the full $2^{\text{totalQubits}}$-dimensional Hilbert space. It acts as a controlled-X on the indicator qubit, conditioned on the system register value being in the bulk window $[K_1, K_2]$:

$$U_{\mathrm{indic}} |mf\rangle|ind\rangle|s\rangle|od\rangle|j\rangle|anc\rangle = |mf\rangle|ind \oplus \mathrm{isBulk}(K_1, K_2, j)\rangle|s\rangle|od\rangle|j\rangle|anc\rangle$$

where $\mathrm{isBulk}(K_1, K_2, j) = 1$ iff $K_1 \leq j \leq K_2$, else $0$.

The matrix entries are:

$$M[i][j] = \begin{cases} 1 & \text{if } i = \mathrm{perm}(j) \\ 0 & \text{otherwise} \end{cases}$$

where the permutation $\mathrm{perm}$ extracts the system register value from the compound index $j$, determines if it is bulk, and flips the indicator bit at position $1 + 2n$:

```text
system_val = (j >> 1) & ((1 << n) - 1)
isBulk     = (K1 <= system_val) && (system_val <= K2)
perm(j)    = j XOR (isBulk << (1 + 2*n))
```

This is a unitary permutation matrix (self-inverse), but the `unitary.proved` obligation remains `false` until a formal unitarity proof is supplied.

---

## Cycle 2 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `robinIndicatorBitPosition` | GHL2025.lean | indicator bit position = $1 + 2n$ | implemented |
| `indicatorOracleMatrix` | GHL2025.lean | honest U_indic permutation matrix | implemented |
| updated `oneTermRobinTotalQubits` | GHL2025.lean | uses register partition total | fixed |
| `effectiveRobinSignalQubits` | GHL2025.lean | signal dim including visible ancillas | implemented |
| updated `oneTermRobinGate_U_indic` | GHL2025.lean | uses honest matrix, proved := false | fixed |
| updated `oneTermRobinCircuitDimCompat` | RobinMatrix.lean | uses effectiveRobinSignalQubits | fixed |
| updated downstream declarations | RobinMatrix.lean | block claim etc. | fixed |

---

## Cycle 2 Boundary Tests

1. **F1 fix**: `oneTermRobinTotalQubits { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } = 13` (was 12)
2. **F1 fix n=1**: `oneTermRobinTotalQubits { n := 1, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }` = register partition total
3. **Indicator bit position**: `robinIndicatorBitPosition { n := 3, ... } = 7`
4. **U_indic non-zero**: for a concrete bulk row (e.g. system j=2, K1=2, K2=5), the matrix entry `indicatorOracleMatrix ⟨image, h⟩ ⟨input, h⟩ = Coeff.rat 1` by `native_decide` or `decide`
5. **U_indic boundary**: for a boundary row (e.g. j=0), `indicatorOracleMatrix ⟨j, h⟩ ⟨j, h⟩ = Coeff.rat 1` (identity, indicator not flipped)
6. **Dim compat**: `qubitDim (oneTermRobinTotalQubits p) = qubitDim (effectiveRobinSignalQubits p) * gridSize n` for n=3, n=1
7. **No promoted obligations**: all `unitary.proved` fields remain `false`

---

## SWAP Oracle Matrix (Cycle 3)

The SWAP gate exchanges two n-qubit register blocks in the compound index:

$$\text{system register: bits } [1, 1+n), \quad \text{O\_D}^{BS}\text{ register: bits } [1+n, 1+2n)$$

The permutation uses an XOR construction that avoids masking issues with unsigned Nat:

```text
block1 = (j >>> 1) & ((1 <<< n) - 1)
block2 = (j >>> (1 + n)) & ((1 <<< n) - 1)
diff   = block1 XOR block2
swap(j) = j XOR (diff <<< 1) XOR (diff <<< (1 + n))
```

When `block1 = block2` the SWAP is the identity.  All bits outside the two n-qubit blocks (ancilla bit 0, indicator bit $1+2n$, mf MSBs) are preserved.

In Lean this is recorded as `GHL2025.swapOracleMatrix`.  The `unitary.proved` obligation remains `false`.

### Concrete Example ($n=3, \kappa=7$)

For $j = 86$:

$$\text{block1} = (86 \gg 1) \,\&\, 7 = 3, \quad \text{block2} = (86 \gg 4) \,\&\, 7 = 5$$

$$\text{diff} = 3 \oplus 5 = 6, \quad \text{swap}(86) = 86 \oplus 12 \oplus 96 = 58$$

Self-inverse confirmed by pair: $M(58, 86) = 1$ and $M(86, 58) = 1$.

---

## K1/K2 Derivation from Stencil (R1)

The bulk window bounds $K_1$ and $K_2$ are derived from the finite-difference stencil's radius:

$$K_1 = \text{stencil.leftRadius}, \quad K_2 = \text{gridSize}(n) - \text{stencil.rightRadius} - 1$$

For the fourth-order central second-derivative stencil (`fourthOrderSecondDerivative`):

- `leftRadius = 2`, `rightRadius = 2`
- $K_1 = 2$ (first bulk row after the left boundary)
- $K_2 = 2^n - 3$ (last bulk row before the right boundary)

The stencil requires `leftRadius` boundary rows on the left and `rightRadius` boundary rows on the right to handle non-standard entries near the domain edges.

This matches `defaultRobinCircuitSkeleton` and `defaultRobinWavefunctionDecomposition`, which hardcode `K1 := 2` and `K2 := gridSize p.n - 3`.

---

## gridSize Underflow Precondition (R2)

The bulk window upper bound $K_2 = \text{gridSize}(n) - 3 = 2^n - 3$ requires:

$$K_2 \geq K_1 \iff 2^n - 3 \geq 2 \iff 2^n \geq 5 \iff n \geq 3$$

The fourth-order stencil assumes $n \geq 3$.  For $n < 3$ the bulk window would be empty or inverted.  The Lean code does not enforce this as a type-level precondition; it is an implicit assumption carried by the stencil choice.

---

## Two Signal-Qubit Counts (R3)

The project uses two different signal-qubit counts that must not be conflated:

### Theorem-level signal qubits (from `oneTermRobinLayout`)

$$m_{\text{theorem}} = \lceil\log_2 n\rceil + \lceil\log_2 G_f\rceil + \lceil\log_2 \kappa\rceil + 4$$

This is the signal-qubit count from the paper's Theorem (main.tex:1098-1109).  It counts only the signal ancilla qubits that appear in the block-encoding statement, excluding visible ancilla workspace qubits.

### Circuit-level signal qubits (from `effectiveRobinSignalQubits`)

$$m_{\text{circuit}} = \text{totalQubits} - n$$

This counts all non-system qubits in the register partition, including:
- the 1-qubit ancilla register (bit 0)
- the $n - \lceil\log_2\kappa\rceil$ pure ancilla qubits for the O_D^BS register
- the indicator qubit
- the $m_f$ function oracle qubits
- the $\lceil\log_2\kappa\rceil$ sparse index qubits

The block extraction uses $m_{\text{circuit}}$ because the projection $(\langle 0^a| \otimes I)$ must zero out all non-system registers, not just the theorem's signal ancillas.

For $n=3, G_f=1, \kappa=7$: $m_{\text{theorem}} = 2 + 0 + 3 + 4 = 9$, $m_{\text{circuit}} = 13 - 3 = 10$.

---

## Cycle 3 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `swapOracleMatrix` | GHL2025.lean | honest SWAP permutation matrix | implemented |
| updated `oneTermRobinGate_SWAP` | GHL2025.lean | uses honest matrix, proved := false | updated |

---

## Cycle 3 SWAP Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Block swap pair (86 ↔ 58) | n=3, κ=7 | native_decide | proved |
| Block swap reverse (58 → 86) | n=3, κ=7 | native_decide | proved |
| Second swap pair (2 ↔ 16) | n=3, κ=7 | native_decide | proved |
| Round-trip (16 → 2) | n=3, κ=7 | native_decide | proved |
| Equal blocks → identity (j=54) | n=3, κ=7 | native_decide | proved |
| Preserves outside bits (j=214 → 186) | n=3, κ=7 | native_decide | proved |
| Indicator bit preserved (bit 7 of 186 = 1) | n=3, κ=7 | native_decide | proved |
| Ancilla bit preserved (214, 186 both even) | n=3, κ=7 | native_decide | proved |
| SWAP unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest SWAP | general p | theorem | proved |

---

## O_D^BS Banded Sparse Access Matrix (Cycle 4)

The banded sparse access oracle $O_D^{BS}$ is a permutation matrix that maps $|s\rangle|i\rangle \to |s\rangle|\mathrm{col}(s,i)\rangle$, where $\mathrm{col}(s,i)$ is the column index of the $s$-th nonzero entry in row $i$ of the Robin derivative matrix.

**Column mapping** (fourth-order stencil, half-bandwidth $l=2$):

$$\mathrm{col}(s, i) = \begin{cases} i - 2 + s & K_1 \leq i \leq K_2 \text{ and } s < 5 \\ s & i = 0 \text{ and } s < 3 \\ s & i = 1 \text{ and } s < 4 \\ N - 4 + s & i = N - 2 \text{ and } s < 4 \\ N - 3 + s & i = N - 1 \text{ and } s < 3 \\ i & \text{otherwise (unused sparse index, identity)} \end{cases}$$

where $K_1 = 2$, $K_2 = 2^n - 3$, $N = 2^n$.

**Matrix form**: permutation on $2^{\text{totalQubits}}$-dimensional space:

$$M[\text{image}(j)][j] = 1, \quad M[\text{other}][j] = 0$$

The image is computed by extracting system register (bits $[1, 1+n)$) and sparse index (bits $[1+n+\text{odPure}, 1+n+\text{odPure}+\text{clog2}(\kappa))$) from compound index $j$, computing $\mathrm{col}(s, i)$, and replacing the system register bits:

```text
image = j - (j & sysMask_shifted) + (col << 1)
```

**Concrete example** ($n=3, \kappa=7$, totalQubits=13):
- Bulk row $i=4$, $s=0$: col $= 2$. System register changes from 4 to 2.
- Bulk row $i=4$, $s=4$: col $= 6$. System register changes from 4 to 6.
- Boundary row $i=0$, $s=0$: col $= 0$ (identity).
- Boundary row $i=0$, $s=5$: unused, identity.

---

## (O_D^BS)^† Inverse Matrix (Cycle 4)

For a permutation matrix $P$ where $P[\text{image}(j)][j] = 1$, the Hermitian conjugate is the transpose: $P^\dagger[j][\text{image}(j)] = 1$. The Lean implementation computes $\text{image}(i)$ for the row index and checks whether $j = \text{image}(i)$.

This is the inverse permutation. For each basis state, if the forward matrix maps $|j\rangle \to |\text{image}(j)\rangle$, then the dagger maps $|\text{image}(j)\rangle \to |j\rangle$.

---

## Cycle 4 O_D^BS Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk row i=4, s=0 → col=2 | n=3, κ=7 | native_decide | proved |
| Bulk row i=4, s=4 → col=6 | n=3, κ=7 | native_decide | proved |
| Diagonal bulk i=3, s=2 → col=3 (identity) | n=3, κ=7 | native_decide | proved |
| Boundary row 0, s=0 → identity | n=3, κ=7 | native_decide | proved |
| Boundary row 0, s=5 unused → identity | n=3, κ=7 | native_decide | proved |
| Right boundary i=7, s=0 → col=5 | n=3, κ=7 | native_decide | proved |
| Dagger transpose (8,4) = 1 (inverse of forward (4,8)) | n=3, κ=7 | native_decide | proved |
| O_D^BS unitary.proved = false | n=3, κ=7 | rfl | proved |
| (O_D^BS)^† unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest O_D^BS | general p | theorem | proved |

---

## Sparse Amplitude Data Layer (Cycle 5)

The function `robinSparseAmplitudeValue` provides the s-th nonzero stencil coefficient for each row of the Robin derivative matrix as a `Coeff` value. This is the data layer shared by both O_DT^S (sparse amplitude oracle, Lemma 3) and Ry_boundary (boundary-controlled rotations).

The function mirrors the case structure of `robinSparseColumnMap` but returns coefficient values instead of column indices:

$$\text{amplitude}(s, i) = \begin{cases}
D_{i,i-2} = -1/12 & \text{bulk, } s=0 \\
D_{i,i-1} = 4/3 & \text{bulk, } s=1 \\
D_{i,i} = -5/2 & \text{bulk, } s=2 \\
D_{i,i+1} = 4/3 & \text{bulk, } s=3 \\
D_{i,i+2} = -1/12 & \text{bulk, } s=4 \\
0 & \text{bulk, } s \geq 5 \\
\text{boundary Coeff} & \text{boundary rows } 0, 1, N{-}2, N{-}1 \\
0 & \text{unused sparse index}
\end{cases}$$

Boundary row amplitudes include the Robin correction terms:
- Row 0, s=0: $-5/2 + (7/3) \cdot A_1 \Delta x$
- Row 1, s=0: $4/3 - (1/6) \cdot A_1 \Delta x$
- Row $N{-}2$, s=3: $4/3 + (1/6) \cdot B_1 \Delta x$
- Row $N{-}1$, s=2: $-5/2 - (7/3) \cdot B_1 \Delta x$

**Coherence property**: for all valid $n$, $s$, $i$:

$$\texttt{robinSparseAmplitudeValue}(n, s, i) = \texttt{robinDerivativeMatrix}(n)[i][\texttt{robinSparseColumnMap}(n, s, i)]$$

This is tested with `native_decide` for concrete instances.

## O_f Function Oracle Diagonal Matrix (Cycle 6)

The O_f gate matrix is now an honest diagonal matrix using `robinSparseAmplitudeValue` data. For each compound basis state $|j\rangle$, the matrix extracts the system register value $i$ and sparse index $s$ from the bit layout:

```text
sysVal     = (j >>> 1) & ((1 <<< n) - 1)
sparseVal  = (j >>> (1 + n + odPure)) & ((1 <<< clog2(kappa)) - 1)
M(j, j)    = robinSparseAmplitudeValue(n, sparseVal, sysVal)
M(i, j)    = 0  for i ≠ j
```

This is a diagonal matrix: it encodes the derivative matrix's sparse amplitude data on the diagonal of the full Hilbert space. Whether this correctly implements the paper's O_f (Lemma 4, main.tex:870-910) is tracked by `unitary.proved := false`.

**Register bit extraction** is consistent with `bandedSparseAccessMatrix`:
- System register: bits $[1, 1+n)$
- Sparse index: bits $[1+n+\text{odPure}, 1+n+\text{odPure}+\text{clog2}(\kappa))$

**Concrete example** ($n=3, \kappa=7$, totalQubits=13):
- Compound $j=36$: sysVal=2, sparseVal=2 → diagonal entry = $-5/2$
- Compound $j=0$: sysVal=0, sparseVal=0 → diagonal entry = $-5/2 + (7/3) A_1 \Delta x$
- Compound $j=60$: sysVal=6, sparseVal=3 → diagonal entry = $4/3 + (1/6) B_1 \Delta x$

### Cycle 6 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `functionOracleMatrix` | GHL2025.lean | diagonal matrix encoding amplitude data | implemented |
| updated `oneTermRobinGate_O_f` | GHL2025.lean | uses honest diagonal matrix | updated |

### Cycle 6 O_f Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk diagonal s=2, i=2, j=36 = -5/2 | n=3, κ=7 | native_decide | proved |
| Left boundary s=0, i=0, j=0 = -5/2 + 7/3·A1·dx | n=3, κ=7 | native_decide | proved |
| Bulk off-diagonal s=0, i=2, j=4 = -1/12 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(0,1) = 0 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(36,0) = 0 | n=3, κ=7 | native_decide | proved |
| Right boundary s=3, i=6, j=60 = 4/3 + 1/6·B1·dx | n=3, κ=7 | native_decide | proved |
| O_f unitary.proved = false | general p | rfl | proved |
| Placeholder match with honest O_f | general p | theorem | proved |

---

### Cycle 5 Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk diagonal s=2, i=2 = -5/2 | n=3 | native_decide | proved |
| Bulk off-diagonal s=0, i=2 = -1/12 | n=3 | native_decide | proved |
| Bulk off-diagonal s=1, i=3 = 4/3 | n=3 | native_decide | proved |
| Left boundary row 0, s=0 = -5/2 + 7/3·A1·dx | n=3 | native_decide | proved |
| Left boundary row 0, s=1 = 8/3 | n=3 | native_decide | proved |
| Left boundary row 1, s=0 = 4/3 - 1/6·A1·dx | n=3 | native_decide | proved |
| Left boundary row 1, s=1 = -31/12 | n=3 | native_decide | proved |
| Right boundary row 6, s=3 = 4/3 + 1/6·B1·dx | n=3 | native_decide | proved |
| Right boundary row 7, s=2 = -5/2 - 7/3·B1·dx | n=3 | native_decide | proved |
| Unused sparse index s=5, i=2 = 0 | n=3 | native_decide | proved |
| Unused sparse index s=3, i=0 = 0 | n=3 | native_decide | proved |
| Coherence: bulk s=2, i=2 | n=3 | native_decide | proved |
| Coherence: left boundary s=0, i=0 | n=3 | native_decide | proved |
| Coherence: right boundary s=2, i=7 | n=3 | native_decide | proved |
| Coherence: left boundary s=0, i=1 | n=3 | native_decide | proved |
| Coherence: right boundary s=3, i=6 | n=3 | native_decide | proved |

---

## O_DT^S Diagonal Matrix Conditioned on Indicator (Cycle 7)

The O_DT^S gate (Lemma 3, main.tex:822--849) is now an honest diagonal matrix on the full $2^{\text{totalQubits}}$-dimensional space. For each compound basis state $|j\rangle$:

- If indicator bit = 0 (boundary row): diagonal entry = `Coeff.rat 1` (identity)
- If indicator bit = 1 (bulk row): diagonal entry = `robinSparseAmplitudeValue(n, s, i)` (amplitude data)
- Off-diagonal entries are zero

The indicator bit is extracted from the compound index at position $1 + 2n$, set by $U_{\mathrm{indic}}$. For bulk rows, the same amplitude data used by `robinSparseAmplitudeValue` appears on the diagonal. For boundary rows, the matrix acts as identity.

```text
indBit = (j >>> (1 + 2*n)) & 1
if indBit == 0: M(j, j) = 1       (boundary: identity)
if indBit == 1: M(j, j) = amplitude (bulk: derivative stencil data)
M(i, j) = 0 for i ≠ j
```

**Note on paper faithfulness:** The paper's $O_{D^T}^S$ is a controlled rotation on the ancilla qubit with angle $\theta_j^s = \arcsin(D_j^{(s)}/N_D)$, not a diagonal matrix. This diagonal encoding exercises the amplitude data pathway. The rotation structure is tracked as a proof obligation (`unitary.proved := false`).

### Cycle 7 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `sparseAmplitudeOracleDTMatrix` | GHL2025.lean | diagonal matrix encoding amplitude data for bulk rows | implemented |
| updated `oneTermRobinGate_O_DT_S` | GHL2025.lean | uses honest diagonal matrix | updated |

### Cycle 7 Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Boundary row j=4 (indicator=0) = 1 | n=3, κ=7 | native_decide | proved |
| Bulk row j=132 (s=0, i=2) = -1/12 | n=3, κ=7 | native_decide | proved |
| Bulk diagonal j=164 (s=2, i=2) = -5/2 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(132,133) = 0 | n=3, κ=7 | native_decide | proved |
| Bulk indicator=1 with boundary data j=128 = -5/2 + 7/3·A1·dx | n=3, κ=7 | native_decide | proved |
| O_DT^S unitary.proved = false | general p | rfl | proved |
| Placeholder match with honest O_DT^S | general p | theorem | proved |

### O_f vs O_DT^S Double Encoding Audit (Resolved in Cycle 9)

**Finding (cycle 7):** Both `functionOracleMatrix` (O_f, cycle 6) and `sparseAmplitudeOracleDTMatrix` (O_DT^S, cycle 7) were using `robinSparseAmplitudeValue` as their diagonal data source. In the paper, these encode completely different quantities.

**Fix (cycle 9):** O_f now uses `robinFunctionValue` (symbolic $f(x_j)$), while O_DT^S continues to use `robinSparseAmplitudeValue` (derivative stencil data). The double encoding is resolved. Both gates still carry `unitary.proved := false` because the diagonal encoding does not match the paper's rotation-based oracle structure.

---

## Ry_boundary Controlled Rotation Matrix (Cycle 8)

The Ry_boundary gate (main.tex:1115--1120, Eq. angles for Ry) is now an honest matrix on the full $2^{\text{totalQubits}}$-dimensional Hilbert space. It applies controlled $R_y(\theta_j^s)$ rotations on the ancilla qubit (bit 0) for boundary rows:

- **Bulk rows** (indicator bit $= 1$): identity — the rotation is only for boundary entries.
- **Boundary rows** (indicator bit $= 0$): $R_y(\theta_j^s)$ on the ancilla qubit, where $\theta_j^s = \arccos(D_j^{(s)} / N_D)$.

The $R_y(\theta)$ matrix entries on the ancilla qubit:

$$R_y(\theta) = \begin{pmatrix} \cos(\theta/2) & -\sin(\theta/2) \\ \sin(\theta/2) & \cos(\theta/2) \end{pmatrix}$$

Using the half-angle formulas:

$$\cos(\theta/2) = \sqrt{\frac{1 + D_j^{(s)}/N_D}{2}}, \qquad \sin(\theta/2) = \sqrt{\frac{1 - D_j^{(s)}/N_D}{2}}$$

These involve square roots and cannot be represented as exact rationals, so the Lean implementation uses symbolic `Coeff.symbol` entries:

- `Coeff.symbol s!"boundary_cos_half_{sysVal}_{sparseVal}"` for $\cos(\theta_j^s/2)$
- `Coeff.symbol s!"boundary_sin_half_{sysVal}_{sparseVal}"` for $\sin(\theta_j^s/2)$

The compound index bit layout matches the existing convention: system register at bits $[1, 1+n)$, sparse index at bits $[1+n+\text{odPure}, 1+n+\text{odPure}+\text{clog2}(\kappa))$, indicator at bit $1+2n$. Only the ancilla qubit (bit 0) changes; all other bits are preserved.

**Concrete example** ($n=3, \kappa=7$, totalQubits=13):
- $j=0$: boundary row, $\text{sysVal}=0$, $\text{sparseVal}=0$, $\text{anc}=0$
  - $M(0, 0) = \texttt{boundary\_cos\_half\_0\_0}$ (cos entry)
  - $M(1, 0) = \texttt{boundary\_sin\_half\_0\_0}$ (sin entry)
  - $M(0, 1) = -\texttt{boundary\_sin\_half\_0\_0}$ (neg-sin entry)
  - $M(1, 1) = \texttt{boundary\_cos\_half\_0\_0}$ (cos entry)
- $j=132$: bulk row (indicator=1), $M(132, 132) = 1$ (identity)

### Cycle 8 Lean Declaration Targets

| Declaration | File | Role | Status |
|---|---|---|---|
| `boundaryRotationMatrix` | GHL2025.lean | honest controlled R_y rotation for boundary rows | implemented |
| updated `oneTermRobinGate_Ry_boundary` | GHL2025.lean | uses honest matrix, proved := false | updated |

---

## Cycle 10 Circuit Product and Block Extraction Pipeline

Cycle 10 connects the faithful one-term Robin circuit matrix semantics to the block-extraction target without pretending that block correctness has been proved.

| Paper object | Lean object | Status |
|---|---|---|
| Full circuit product $U$ | `Examples.RobinHeat.oneTermRobinCircuitSemantics n` | implemented as `evalGateMatrices` over all seven gate matrices |
| Dimension factorization $2^{q}=2^{m}\cdot N$ | `Examples.RobinHeat.oneTermRobinCircuitDimCompat n` | proved from `clog2_gridSize` and register arithmetic |
| Signal-zero block extraction | `CircuitMatrixSemantics.blockExtractionTarget` | reused generic API |
| Robin block target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget n` | derives `unitaryMatrix` and `blockMatrix` from the circuit product |
| Final theorem $U$ block equals $A_k/(N_DN_f\kappa)$ | `blockCorrect.proved` | still false |

### Cycle 10 Test Strategy

The compiled tests now check the wiring structurally:

- `oneTermRobinCircuitSemantics n`.matrix is definitionally `evalGateMatrices`.
- `oneTermRobinBlockExtractionTarget n`.unitaryMatrix is the cast circuit product.
- `oneTermRobinBlockExtractionTarget n`.blockMatrix is `signalSystemBlockProjection` at signal index 0.
- Existing target matrix, normalizer, signal index, and unproved-obligation tests still pass.

Concrete entry-level tests of the full $n=3$ product were removed from the build gate because they force Lean to normalize entries of a $8192 \times 8192$ symbolic matrix product. Those entry checks should return as focused lemmas or proof attempts once the block-correctness proof is decomposed, not as routine CI tests.

---

## Build Gate

```bash
python3 tools/qbe.py check
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```
