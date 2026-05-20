# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Updated: `2026-05-20`

This ledger tracks the unproved semantic claims introduced by the circuit
matrix semantics backend layer.

## Gate Matrix Placeholders

Each of the 7 circuit gates has a `GateMatrix` record with a nonzero matrix
semantics.  The matrices are intentionally still proof-obligation carriers:
all carry `unitary.proved := false`.

| Gate | Lean declaration | Paper source | Status |
|---|---|---|---|
| U_indic | `GHL2025.oneTermRobinGate_U_indic` | main.tex:1088-1099 | honest permutation matrix, unitary unproved (cycle 2) |
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | main.tex:822-849 | honest diagonal matrix conditioned on indicator, unitary unproved (cycle 7) |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | main.tex:1115-1120 | honest symbolic controlled rotation matrix, unitary unproved (cycle 8) |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | main.tex:784-801 | honest permutation matrix, unitary unproved (cycle 4) |
| O_f | `GHL2025.oneTermRobinGate_O_f` | main.tex:870-910 | honest diagonal matrix encoding f(x_j), unitary unproved (cycle 6, fixed cycle 9) |
| SWAP | `GHL2025.oneTermRobinGate_SWAP` | main.tex:1140 | honest permutation matrix, unitary unproved (cycle 3) |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | main.tex:1148 | inverse permutation matrix, unitary unproved (cycle 4) |

## Circuit Semantics

| Obligation | Declaration | Status |
|---|---|---|
| Gate list matches circuit | `GHL2025.oneTermRobinPlaceholdersMatch` | proved |
| Circuit matrix = product of gate matrices | `oneTermRobinCircuitSemantics.matrix_eq_eval` | proved (by rfl on gate matrices) |

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
- Unitarity is still unproved for the seven gate matrices.
- The composed circuit matrix is now nontrivial, but the extracted block has not yet been proved equal to $A_k/(N_DN_f\kappa)$.
- The diagonal encodings for $O_{D^T}^S$ and the symbolic $R_y^{boundary}$ entries still need to be reconciled with the paper's rotation-based oracle semantics.

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

## Cycle 4: O_D^BS and (O_D^BS)^† Matrices

| Declaration | Role | Status |
|---|---|---|
| `robinSparseColumnMap` | column mapping col(s,i) for Robin stencil | implemented |
| `bandedSparseAccessMatrix` | honest O_D^BS permutation matrix | implemented |
| updated `oneTermRobinGate_O_D_BS` | uses honest matrix | updated |
| `bandedSparseAccessDaggerMatrix` | inverse permutation (transpose) | implemented |
| updated `oneTermRobinGate_O_D_BS_dagger` | uses honest matrix | updated |

### O_D^BS Matrix Obligations

| Obligation | Status |
|---|---|
| Bulk row column mapping col(s,i) = i-2+s | tested (native_decide) |
| Left boundary rows (i=0: 3 entries, i=1: 4 entries) | tested (native_decide) |
| Right boundary rows (i=N-2, i=N-1) | tested (native_decide) |
| Unused sparse indices → identity | tested (native_decide) |
| Dagger is inverse permutation | tested (native_decide) |
| Unitarity of O_D^BS | unproved (`unitary.proved := false`) |
| Unitarity of (O_D^BS)^† | unproved (`unitary.proved := false`) |
| No promoted obligations from cycle 3 | verified |

### Cycle 4 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk i=4, s=0 → col=2 | n=3, κ=7 | native_decide | proved |
| Bulk i=4, s=4 → col=6 | n=3, κ=7 | native_decide | proved |
| Diagonal i=3, s=2 → col=3 (identity) | n=3, κ=7 | native_decide | proved |
| Boundary i=0, s=0 → identity | n=3, κ=7 | native_decide | proved |
| Boundary i=0, s=5 unused → identity | n=3, κ=7 | native_decide | proved |
| Right boundary i=7, s=0 → col=5 | n=3, κ=7 | native_decide | proved |
| Dagger transpose (8,4) = 1 | n=3, κ=7 | native_decide | proved |
| O_D^BS unitary.proved = false | n=3, κ=7 | rfl | proved |
| (O_D^BS)^† unitary.proved = false | n=3, κ=7 | rfl | proved |
| Placeholder match with honest O_D^BS | general p | theorem | proved |

## Cycle 5: Sparse Amplitude Data Layer

| Declaration | Role | Status |
|---|---|---|
| `robinSparseAmplitudeValue` | s-th nonzero stencil coefficient per row, as Coeff | implemented (cycle 5) |

### Cycle 5 Obligations

| Obligation | Status |
|---|---|
| Bulk row amplitudes match stencil coefficients | tested (native_decide) |
| All 4 boundary row amplitudes match matrix entries with symbolic correction terms | tested (native_decide) |
| Unused sparse indices return Coeff.rat 0 | tested (native_decide) |
| Coherence: amplitude = matrix entry at column from robinSparseColumnMap | tested (native_decide, 5 instances covering bulk + all boundary types) |
| No promoted obligations | verified |

### Cycle 5 Tests Added

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

## Cycle 6: O_f Function Oracle Diagonal Matrix

| Declaration | Role | Status |
|---|---|---|
| `functionOracleMatrix` | diagonal matrix encoding function values f(x_j) on the diagonal | implemented (cycle 6, fixed cycle 9) |
| updated `oneTermRobinGate_O_f` | uses honest diagonal matrix instead of zero placeholder | updated (cycle 6, fixed cycle 9) |

### O_f Matrix Obligations

| Obligation | Status |
|---|---|
| Diagonal entries are Coeff.symbol "f_{n}_{sysVal}" for each grid point | tested (native_decide) |
| Off-diagonal entries are zero | tested (native_decide) |
| Same sysVal produces same symbol regardless of sparse index | tested (native_decide) |
| Different sysVal produces different symbols | tested (native_decide) |
| Unitarity of O_f | unproved (`unitary.proved := false`) |
| No promoted obligations from cycle 8 | verified |

### Cycle 9 O_f Fix Tests

| Test | Parameters | Method | Status |
|---|---|---|---|
| Diagonal j=36 (sysVal=2) = f_3_2 | n=3, κ=7 | native_decide | proved |
| Diagonal j=0 (sysVal=0) = f_3_0 | n=3, κ=7 | native_decide | proved |
| Diagonal j=4 (sysVal=2) = f_3_2 (same as j=36) | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(0,1) = 0 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(36,0) = 0 | n=3, κ=7 | native_decide | proved |
| Diagonal j=60 (sysVal=6) = f_3_6 | n=3, κ=7 | native_decide | proved |
| Diagonal j=14 (sysVal=7) = f_3_7 | n=3, κ=7 | native_decide | proved |
| robinFunctionValue 3 0 = f_3_0 | n=3 | native_decide | proved |
| robinFunctionValue 3 2 = f_3_2 | n=3 | native_decide | proved |
| robinFunctionValue 3 7 = f_3_7 | n=3 | native_decide | proved |
| O_f unitary.proved = false | general p | rfl | proved |
| Placeholder match with honest O_f | general p | theorem | proved |

## Cycle 7: O_DT^S Diagonal Matrix Conditioned on Indicator

| Declaration | Role | Status |
|---|---|---|
| `sparseAmplitudeOracleDTMatrix` | diagonal matrix encoding amplitude data for bulk rows (indicator=1), identity for boundary rows (indicator=0) | implemented (cycle 7) |
| updated `oneTermRobinGate_O_DT_S` | uses honest diagonal matrix | updated (cycle 7) |

### O_DT^S Matrix Obligations

| Obligation | Status |
|---|---|
| Boundary row (indicator=0): diagonal entry = Coeff.rat 1 (identity) | tested (native_decide) |
| Bulk row (indicator=1): diagonal entry = robinSparseAmplitudeValue(n, s, i) | tested (native_decide) |
| Off-diagonal entries are zero | tested (native_decide) |
| Unitarity of O_DT^S | unproved (`unitary.proved := false`) |
| Paper uses controlled rotation on ancilla, not diagonal encoding | tracked as proof obligation |
| No promoted obligations from cycle 6 | verified |

### Cycle 7 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Boundary row j=4 (indicator=0) = 1 | n=3, κ=7 | native_decide | proved |
| Bulk row j=132 (s=0, i=2) = -1/12 | n=3, κ=7 | native_decide | proved |
| Bulk diagonal j=164 (s=2, i=2) = -5/2 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(132,133) = 0 | n=3, κ=7 | native_decide | proved |
| Bulk indicator=1 with boundary data j=128 = -5/2 + 7/3·A1·dx | n=3, κ=7 | native_decide | proved |
| O_DT^S unitary.proved = false | general p | rfl | proved |
| Placeholder match with honest O_DT^S | general p | theorem | proved |

### O_f vs O_DT^S Double Encoding Audit (Resolved Cycle 9)

**Finding (cycle 7):** Both `functionOracleMatrix` (O_f) and `sparseAmplitudeOracleDTMatrix` (O_DT^S)
used `robinSparseAmplitudeValue` as their diagonal data source, encoding the same derivative data twice.

**Fix (cycle 9):** O_f now uses `robinFunctionValue` (symbolic function values $f(x_j)$), while
O_DT^S continues to use `robinSparseAmplitudeValue` (derivative stencil data). The double encoding is resolved.
Both gates carry `unitary.proved := false` because the diagonal encoding does not match the paper's
rotation-based oracle structure.

## Cycle 8: Ry_boundary Controlled Rotation Matrix

| Declaration | Role | Status |
|---|---|---|
| `boundaryRotationMatrix` | honest controlled R_y rotation on ancilla for boundary rows | implemented (cycle 8) |
| updated `oneTermRobinGate_Ry_boundary` | uses honest matrix instead of zero placeholder | updated (cycle 8) |

### Ry_boundary Matrix Obligations

| Obligation | Status |
|---|---|
| Bulk row (indicator=1): diagonal entry = Coeff.rat 1 (identity) | tested (native_decide) |
| Boundary row (indicator=0): diagonal cos entry = Coeff.symbol "boundary_cos_half_{i}_{s}" | tested (native_decide) |
| Boundary row: ancilla off-diagonal entries are sin/neg-sin | tested (native_decide) |
| Different boundary rows produce different symbols | tested (native_decide) |
| Off-diagonal between different rest bits is zero | tested (native_decide) |
| Unitarity of Ry_boundary | unproved (`unitary.proved := false`) |
| Paper uses rotation angles $\theta_j^s = \arccos(D_j^{(s)}/N_D)$, symbolic entries track cos/sin | tracked as proof obligation |
| No promoted obligations from cycle 7 | verified |

### Cycle 8 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Bulk identity M(132,132) = 1 | n=3, κ=7 | native_decide | proved |
| Bulk off-diagonal M(133,132) = 0 | n=3, κ=7 | native_decide | proved |
| Boundary cos M(0,0) = cos_half_0_0 | n=3, κ=7 | native_decide | proved |
| Boundary sin M(1,0) = sin_half_0_0 | n=3, κ=7 | native_decide | proved |
| Boundary neg-sin M(0,1) = -sin_half_0_0 | n=3, κ=7 | native_decide | proved |
| Boundary cos M(1,1) = cos_half_0_0 | n=3, κ=7 | native_decide | proved |
| Different sysVal: M(2,2) = cos_half_1_0 | n=3, κ=7 | native_decide | proved |
| Different sparseVal: M(16,16) = cos_half_0_1 | n=3, κ=7 | native_decide | proved |
| Off-diagonal M(0,2) = 0 | n=3, κ=7 | native_decide | proved |
| Ry_boundary unitary.proved = false | general p | rfl | proved |
| Placeholder match with honest Ry_boundary | general p | theorem | proved |

## Cycle 10: Product/Projection Pipeline Obligations

| Object | Lean status | Remaining obligation |
|---|---|---|
| Full circuit matrix | `oneTermRobinCircuitSemantics n`.matrix is `evalGateMatrices` over all seven gate matrices | prove the product matches the paper's intended $U$ |
| Dimension split | `oneTermRobinCircuitDimCompat n` proves $2^q = 2^m \cdot N$ | none for the arithmetic bridge |
| Block target | `oneTermRobinBlockExtractionTarget n` derives `unitaryMatrix` and `blockMatrix` from the product/projection API | prove the extracted block equals $A_k/(N_DN_f\kappa)$ |
| Runtime test policy | structural tests compile quickly | full $n=3$ entry-level product checks are deferred to focused proof attempts |

Concrete entry-level normalization of the full $n=3$ product is not a build-gate test. The matrix has dimension $8192 \times 8192$, so `native_decide` on composed entries is too expensive for routine CI. Future lower agents should introduce intermediate lemmas for individual gates, row support, and projection algebra before attempting product-entry proofs.
