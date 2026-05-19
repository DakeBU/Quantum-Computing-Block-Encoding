# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Updated: `2026-05-19`

This ledger tracks the unproved semantic claims introduced by the circuit
matrix semantics backend layer.

## Gate Matrix Placeholders

Each of the 7 circuit gates has a `GateMatrix` record.  Two have honest
permutation matrices (U_indic, SWAP); five remain zero placeholders.
All carry `unitary.proved := false`.

| Gate | Lean declaration | Paper source | Status |
|---|---|---|---|
| U_indic | `GHL2025.oneTermRobinGate_U_indic` | main.tex:1088-1099 | honest permutation matrix, unitary unproved (cycle 2) |
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | main.tex:822-849 | placeholder |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | main.tex:1115-1120 | placeholder |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | main.tex:784-801 | placeholder |
| O_f | `GHL2025.oneTermRobinGate_O_f` | main.tex:870-910 | placeholder |
| SWAP | `GHL2025.oneTermRobinGate_SWAP` | main.tex:1140 | honest permutation matrix, unitary unproved (cycle 3) |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | main.tex:1148 | placeholder |

## Circuit Semantics

| Obligation | Declaration | Status |
|---|---|---|
| Gate list matches circuit | `GHL2025.oneTermRobinPlaceholdersMatch` | proved |
| Circuit matrix = product of gate matrices | `oneTermRobinCircuitSemantics.matrix_eq_eval` | proved (by rfl on placeholders) |

## Block Extraction Target

| Obligation | Declaration | Status |
|---|---|---|
| Block projection extracts correct submatrix | `oneTermRobinBlockExtractionTarget.blockProjection` | unproved |
| Extracted block = targetMatrix / normalizer | `oneTermRobinBlockExtractionTarget.blockCorrect` | unproved |

## Dimension Bridge (Core.lean)

| Declaration | Role | Status |
|---|---|---|
| `clog2_gridSize` | `clog2 (gridSize n) = n` — arithmetic bridge from qubit counts to matrix dimensions | proved (by induction on n) |
| `log2_pred_two_pow_succ` | Supporting lemma: `log2 (2^(n+1) - 1) = n` | proved |

## Block Projection Infrastructure

| Declaration | Status |
|---|---|
| `signalSystemBlockProjection` | defined (total, constructive) |
| `totalCircuitQubits` | defined |
| `CircuitMatrixSemantics.blockExtractionTarget` | defined |

## Circuit Block Encoding Claim

| Declaration | Role | Status |
|---|---|---|
| `CircuitBlockEncodingClaim` | Schema: semantics + target + dimCompat + blockCorrect | defined |
| `Examples.RobinHeat.oneTermRobinCircuitBlockClaim` | Robin instance, takes `hDim` proof parameter | defined |
| `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | Reusable proof that full dimension = signal dimension × system dimension | proved |
| `Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim` | Robin instance using the reusable dimension proof | defined |

| Obligation | Declaration | Status |
|---|---|---|
| Dimension compatibility for general `n` | `oneTermRobinCircuitDimCompat` using `clog2_gridSize` | proved |
| Block correctness for Robin | `blockCorrect` field | unproved |

## Downstream Dependencies

These obligations block completion of `QBE-AUTO-001`:
- Real oracle matrices are needed before the block-correctness claim can be stated non-trivially.
- The placeholder alignment theorem (`oneTermRobinPlaceholdersMatch`) is a scaffolding result; it will need to be reproved once real matrices replace placeholders.

## Edge-Case Validation Tests (Cycle 1)

| Test | Parameters | Method | Status |
|---|---|---|---|
| n=1 dimension compatibility | `qubitDim total = signal * gridSize 1` | `native_decide` | proved |
| n=1 circuit block claim dim compat | `dimCompat` roundtrip | `rfl` | proved |
| 1×1 system block projection | `signalSystemBlockProjection 2 1 1` | `native_decide` | proved |
| n=2 field-access roundtrip | `targetMatrix` matches `robinDerivativeMatrix` | `rfl` | proved |
| n=2 circuit identity | `defaultClaim.semantics.circuit = oneTermRobinCircuit` | `rfl` | proved |

## Register Convention and F1 Fix (Cycle 2)

| Declaration | Role | Status |
|---|---|---|
| `oneTermRobinTotalQubits` | circuit-level total = register partition total | fixed (12 → 13 for n=3) |
| `effectiveRobinSignalQubits` | signal dim including visible ancillas | implemented |
| `robinIndicatorBitPosition` | indicator bit position = 1 + 2n | implemented |
| `indicatorOracleMatrix` | honest U_indic permutation matrix | implemented |
| `oneTermRobinGate_U_indic` | updated gate matrix with honest matrix | fixed |

### U_indic Matrix Obligations

| Obligation | Status |
|---|---|
| Matrix entries compute correctly for bulk rows | tested (native_decide) |
| Matrix entries compute correctly for boundary rows | tested (native_decide) |
| Unitarity of U_indic | unproved (`unitary.proved := false`) |
| No promoted obligations from cycle 1 | verified |

### Cycle 2 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Total qubits = 13 | n=3, κ=7 | rfl | proved |
| Total qubits = 7 | n=1, κ=1 | rfl | proved |
| Indicator bit = 7 | n=3, κ=7 | rfl | proved |
| Indicator bit = 3 | n=1, κ=1 | rfl | proved |
| Effective signal = 10 | n=3, κ=7 | rfl | proved |
| Effective signal = 6 | n=1, κ=1 | rfl | proved |
| U_indic bulk row → flips indicator | j=4 → image=132, n=3 | native_decide | proved |
| U_indic boundary row → identity | j=0 → image=0, n=3 | native_decide | proved |
| U_indic inverse mapping | j=132 → image=4, n=3 | native_decide | proved |
| U_indic off-diagonal = 0 | M(0,4)=0, n=3 | native_decide | proved |
| Dim compat n=3 | 2^13 = 2^10 × 8 | native_decide | proved |
| Dim compat n=1 | 2^7 = 2^6 × 2 | native_decide | proved |

## Cycle 3: SWAP Matrix

| Declaration | Role | Status |
|---|---|---|
| `swapOracleMatrix` | honest SWAP permutation matrix | implemented |
| updated `oneTermRobinGate_SWAP` | uses honest matrix | updated |

### SWAP Matrix Obligations

| Obligation | Status |
|---|---|
| Matrix entries swap two n-qubit register blocks correctly | tested (native_decide, 2 swap pairs) |
| Equal blocks → identity | tested (native_decide) |
| Preserves bits outside swapped blocks | tested (native_decide) |
| Unitarity of SWAP | unproved (`unitary.proved := false`) |
| No promoted obligations from cycle 2 | verified |

### Cycle 3 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Swap pair 86 ↔ 58 | n=3, κ=7 | native_decide | proved |
| Swap pair reverse 58 → 86 | n=3, κ=7 | native_decide | proved |
| Swap pair 2 ↔ 16 | n=3, κ=7 | native_decide | proved |
| Swap pair reverse 16 → 2 | n=3, κ=7 | native_decide | proved |
| Equal blocks → identity (j=54) | n=3, κ=7 | native_decide | proved |
| Preserves indicator bit (j=214 → 186) | n=3, κ=7 | native_decide | proved |
| Indicator bit of 186 = 1 | n=3, κ=7 | native_decide | proved |
| Ancilla bits preserved (even) | n=3, κ=7 | native_decide | proved |
| SWAP unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest SWAP | general p | theorem | proved |
