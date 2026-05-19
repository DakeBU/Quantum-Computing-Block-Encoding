# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Updated: `2026-05-18`

This ledger tracks the unproved semantic claims introduced by the circuit
matrix semantics backend layer.

## Gate Matrix Placeholders

Each of the 7 circuit gates has a `GateMatrix` placeholder with a zero matrix
and `unitary.proved := false`. These must be replaced with real oracle matrices.

| Gate | Lean declaration | Paper source | Status |
|---|---|---|---|
| U_indic | `GHL2025.oneTermRobinGate_U_indic` | main.tex:1088-1099 | placeholder |
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | main.tex:822-849 | placeholder |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | main.tex:1115-1120 | placeholder |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | main.tex:784-801 | placeholder |
| O_f | `GHL2025.oneTermRobinGate_O_f` | main.tex:870-910 | placeholder |
| SWAP | `GHL2025.oneTermRobinGate_SWAP` | main.tex:1140 | placeholder |
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
