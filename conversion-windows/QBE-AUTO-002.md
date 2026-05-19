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
| O_DT^S placeholder matrix | `GHL2025.oneTermRobinGate_O_DT_S` | GateMatrix with proved := false | defined |
| Ry_boundary placeholder matrix | `GHL2025.oneTermRobinGate_Ry_boundary` | GateMatrix with proved := false | defined |
| O_D^BS placeholder matrix | `GHL2025.oneTermRobinGate_O_D_BS` | GateMatrix with proved := false | defined |
| O_f placeholder matrix | `GHL2025.oneTermRobinGate_O_f` | GateMatrix with proved := false | defined |
| SWAP placeholder matrix | `GHL2025.oneTermRobinGate_SWAP` | GateMatrix with proved := false | defined (cycle 3 update: honest permutation) |
| SWAP honest matrix | `GHL2025.swapOracleMatrix` | Permutation swapping system/O_D^BS blocks | defined (cycle 3) |
| (O_D^BS)^† placeholder matrix | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | GateMatrix with proved := false | defined |
| All 7 placeholders | `GHL2025.oneTermRobinGateMatrixPlaceholders` | List GateMatrix | defined |
| Placeholder alignment theorem | `GHL2025.oneTermRobinPlaceholdersMatch` | gateMatricesMatchCircuit = true | proved |
| Robin circuit semantics | `Examples.RobinHeat.oneTermRobinCircuitSemantics` | CircuitMatrixSemantics for the Robin circuit | defined |
| Robin block extraction target | `Examples.RobinHeat.oneTermRobinBlockExtractionTarget` | BlockExtractionTarget with unproved obligations | defined |
| Circuit block encoding claim | `CircuitBlockEncodingClaim` | Schema bundling semantics + target + dim proof + obligation | defined |
| Robin circuit block claim | `Examples.RobinHeat.oneTermRobinCircuitBlockClaim` | CircuitBlockEncodingClaim for Robin, takes dim proof parameter | defined |
| Robin dimension theorem | `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | full dimension = effective signal dim × system dim | proved (cycle 2 update) |
| Default Robin block claim | `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | Robin claim using reusable dimension theorem | defined |

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
```

Next declarations should fill in the actual oracle matrices:

```lean
-- Replace placeholder matrices with real oracle implementations:
def GHL2025.indicatorOracleMatrix ...
def GHL2025.swapOracleMatrix ...
def GHL2025.bandedSparseAccessMatrix ...
def GHL2025.sparseAmplitudeOracleMatrix ...
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
  `O_f`, `SWAP`, and `(O_D^BS)^†` (as placeholders with `proved := false`).
- [ ] Prove or explicitly track unitarity of each gate matrix.
- [x] Prove or explicitly track that the matrix product matches the paper
  circuit order (placeholders match by construction, theorem proved).
- [ ] Prove or explicitly track block correctness:
  $(\langle 0^a| \otimes I) U (|0^a\rangle \otimes I)=A_k/\alpha$.
- [ ] Replace placeholder zero matrices with real oracle matrices.
- [x] Update `paper-notes/GHL2025_RobinOneTerm.tex` whenever the Lean semantics
  statement changes.
- [x] Edge-case tests for n=1 dim compat, n=1 circuit block claim, 1×1 block
  projection, n=2 field roundtrip, n=2 circuit identity (cycle 1 lower).

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

## Build Gate

```bash
python3 tools/qbe.py check
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```
