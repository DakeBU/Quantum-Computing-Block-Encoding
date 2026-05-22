# Proof Obligations: QBE-AUTO-002 — Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Updated: `2026-05-20`

This ledger tracks the unproved semantic claims introduced by the circuit
matrix semantics backend layer.

## Gate Matrix Placeholders

Each of the 7 circuit gates has a `GateMatrix` record with a nonzero matrix
semantics.  `U_indic` has a proved permutation-matrix certificate; the other
gate unitarity claims remain explicit proof obligations.

| Gate | Lean declaration | Paper source | Status |
|---|---|---|---|
| U_indic | `GHL2025.oneTermRobinGate_U_indic` | main.tex:1088-1099 | honest permutation matrix, **unitary proved** (cycle 2 → run 02 cycle 12 bijection + run 02 cycle 02 permutation bridge) |
| O_DT^S | `GHL2025.oneTermRobinGate_O_DT_S` | main.tex:822-849 | honest diagonal matrix conditioned on indicator, unitary unproved (cycle 7) |
| Ry_boundary | `GHL2025.oneTermRobinGate_Ry_boundary` | main.tex:1115-1120 | honest symbolic controlled rotation matrix, unitary unproved (cycle 8) |
| O_D^BS | `GHL2025.oneTermRobinGate_O_D_BS` | Lemma 1, arXiv:2506.20478 | contract drift under audit: current Lean helper maps $|s\rangle|i\rangle$ to $|s\rangle|\mathrm{col}(s,i)\rangle$, while the paper maps $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to $|r_{si}\rangle^n|i\rangle^n$ |
| O_f | `GHL2025.oneTermRobinGate_O_f` | main.tex:870-910 | honest diagonal matrix encoding f(x_j), unitary unproved (cycle 6, fixed cycle 9) |
| SWAP | `GHL2025.oneTermRobinGate_SWAP` | main.tex:1140 | honest permutation matrix, unitarity pending proof-DAG bit-slice lemmas |
| (O_D^BS)^dagger | `GHL2025.oneTermRobinGate_O_D_BS_dagger` | Fig. 1-term Robin caption, arXiv:2506.20478 | transpose-style matrix for interim helper; faithful inverse/cleanup proof blocked until forward contract is corrected |

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
- Unitarity is proved for `U_indic` and still unproved for the remaining six gate matrices.
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
| Unitarity of U_indic | **proved** (`unitary.proved := true`, via `indicatorOracleMatrix_is_permutation`) |
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

## Cycle 3: SWAP Matrix (unitarity pending proof-DAG bit-slice lemmas)

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
| Unitarity of SWAP | unproved (`unitary.proved := false`); previous flat proof attempt was demoted to a proof-DAG obligation |
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

### Faithfulness Correction: 2026-05-22

The current Lean `bandedSparseAccessMatrix` is an interim column-map helper, not
yet the paper's full register-level sparse-access oracle.  The paper's Lemma 1
states:

$$
\hat O_D^{BS}|0\rangle^{n-l}|s\rangle^l|i\rangle^n
=
|r_{si}\rangle^n|i\rangle^n.
$$

The Lean helper instead keeps the sparse-index register and overwrites the
system register using `robinSparseColumnMap`.  Its boundary non-injectivity
witness is evidence that this simplified contract should not be used as the
paper oracle's unitarity target.  The next faithful-mode cycle must correct the
register layout and image formula before lower agents attempt `O_D^BS` or
`(O_D^BS)^dagger` unitarity.

### Source-Contract Audit Record

`GHL2025.BandedSparseAccessPaperContract` now records the paper target as data
separate from the interim helper.  The default one-term contract is
`GHL2025.defaultBandedSparseAccessPaperContract p`.

| Field / obligation | Paper source | Lean field | Status |
|---|---|---|---|
| input registers | Lemma 1, arXiv:2506.20478 | `inputKet = "|0>^(n-l)|s>^l|i>^n"` | recorded |
| output registers | Lemma 1, arXiv:2506.20478 | `outputKet = "|r_si>^n|i>^n"` | recorded |
| image formula | Lemma 1, arXiv:2506.20478 | `imageFormula = "r_si = r_s0 + i mod 2^n"` | recorded |
| padded width equation | Lemma 1, arXiv:2506.20478 | `widthCompatible` | unproved (`proved := false`) |
| forward oracle correctness | Lemma 1, arXiv:2506.20478 | `forwardCorrect` | unproved (`proved := false`) |
| dagger cleanup | Fig. 1-term Robin and Lemma 1, arXiv:2506.20478 | `daggerCleanup` | unproved (`proved := false`) |

### O_D^BS Register Proof-DAG

These blocks are the faithful-paper path for replacing the interim
`bandedSparseAccessMatrix`.  They do not change any `proved` flag until the
corresponding Lean declaration compiles and matches Lemma 1.

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `odbs_width_compatible` | show that the padded sparse-index register has width $n$ | `clog2 p.kappa <= p.n` or a recorded parameter-family proof | `defaultBandedSparseAccessPaperContract p`.widthCompatible | register extraction, paper image | unproved |
| `odbs_extract_registers` | extract padded-zero, sparse-index, and row fields from the one-term compound index | `oneTermRobinTotalQubits`, `defaultRobinRegisterPartition` | planned `bandedSparseAccessPaperRegisters` | paper image, dagger cleanup | planned |
| `odbs_forward_image` | preserve the row register and replace the padded sparse-index register by $r_{si}$ | `odbs_width_compatible`, `odbs_extract_registers` | planned `bandedSparseAccessPaperImage` | forward matrix, cleanup | planned |
| `odbs_forward_matrix` | define matrix entries from the paper image rather than the interim column-map helper | `odbs_forward_image` | planned `bandedSparseAccessPaperMatrix` | `oneTermRobinGate_O_D_BS` correction | planned |
| `odbs_dagger_cleanup` | prove or record that $(O_D^{BS})^\dagger$ cleans the padded sparse-index register after SWAP | `odbs_forward_image`, SWAP block lemmas | `defaultBandedSparseAccessPaperContract p`.daggerCleanup | block extraction | unproved |

### Next Lower Packet

Target only `odbs_extract_registers` and an executable
`bandedSparseAccessPaperImage` skeleton.  Allowed write scope:
`QuantumBlockEncoding/GHL2025.lean`; optional focused examples:
`Tests/Basic.lean`.

| Required item | Acceptance |
|---|---|
| `bandedSparseAccessPaperRegisters` | exposes the padded sparse-index register and row register used by Lemma 1 |
| `bandedSparseAccessPaperImage` | states the basis-image formula $|0\rangle^{n-l}|s\rangle^l|i\rangle^n \mapsto |r_{si}\rangle^n|i\rangle^n$ without changing `unitary.proved` |
| examples for `n = 3`, `kappa = 7` | check row preservation and address-register replacement for one bulk row and one boundary row |

Do not change the paper contract, introduce side conditions silently, or promote
`oneTermRobinGate_O_D_BS.unitary.proved`,
`oneTermRobinGate_O_D_BS_dagger.unitary.proved`, `forwardCorrect`, or
`daggerCleanup`.

For the concrete test parameters `n = 3`, `kappa = 7`, the recorded widths are
`paddedZeroQubits = 0` and `sparseIndexQubits = 3`.  This does not discharge
the general width obligation for arbitrary `OneTermRobinParameters`.

| Declaration | Role | Status |
|---|---|---|
| `BandedSparseAccessPaperContract` | faithful Lemma 1 source contract | defined; correctness fields unproved |
| `defaultBandedSparseAccessPaperContract` | instantiates the contract for one-term Robin parameters | defined; width and cleanup obligations explicit |
| `robinSparseColumnMap` | column mapping col(s,i) for Robin stencil | implemented; helper only |
| `bandedSparseAccessMatrix` | interim sparse-access matrix | implemented; contract drift under audit |
| updated `oneTermRobinGate_O_D_BS` | uses interim matrix | updated; do not promote unitarity |
| `bandedSparseAccessDaggerMatrix` | transpose-style matrix for interim map | implemented; faithful inverse blocked |
| updated `oneTermRobinGate_O_D_BS_dagger` | uses interim matrix | updated; do not promote unitarity |

### O_D^BS Matrix Obligations

| Obligation | Status |
|---|---|
| Bulk row column mapping col(s,i) = i-2+s | tested (native_decide) |
| Left boundary rows (i=0: 3 entries, i=1: 4 entries) | tested (native_decide) |
| Right boundary rows (i=N-2, i=N-1) | tested (native_decide) |
| Unused sparse indices → identity | tested (native_decide) |
| Dagger matrix entry relation | tested on concrete entries; full inverse proof blocked |
| Unitarity of O_D^BS | unproved (`unitary.proved := false`) |
| Unitarity of (O_D^BS)^† | unproved (`unitary.proved := false`) |
| No promoted obligations from cycle 3 | verified |

Boundary non-injectivity witness for the current simplified Lean column-map contract:
`robinSparseColumnMap 3 0 0 = robinSparseColumnMap 3 0 1 =
robinSparseColumnMap 3 0 2 = 0`.  This prevents the permutation-matrix proof
route for the simplified helper.  It should now be treated as a reviewer
finding that the Lean contract must be reconciled with the paper's padded
sparse-index oracle, not as a claim that GHL's construction is missing.

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

## Cycle 11: Coeff.rat Arithmetic Lemmas and U_indic Bijection Stepping Stone

### A. Coeff.rat Arithmetic Lemmas (Core.lean)

Added simplification lemmas enabling future matrix-multiplication normalization:

| Lemma | Role | Status |
|---|---|---|
| `Coeff.evalWith_rat_zero` | `evalWith env (Coeff.rat 0) = 0` | proved (rfl) |
| `Coeff.evalWith_rat_one` | `evalWith env (Coeff.rat 1) = 1` | proved (rfl) |
| `Coeff.evalWith_rat_add` | `evalWith env (Coeff.add (Coeff.rat a) (Coeff.rat b)) = a + b` | proved (simp) |
| `Coeff.evalWith_rat_mul` | `evalWith env (Coeff.mul (Coeff.rat a) (Coeff.rat b)) = a * b` | proved (simp) |
| `Coeff.evalWith_rat_neg` | `evalWith env (Coeff.neg (Coeff.rat a)) = -a` | proved (simp) |

These lemmas close the `Coeff.rat` → `Rat` evaluation gap for arithmetic compositions. They are prerequisites for proving that permutation-matrix products evaluate correctly under `evalWith`.

### B. U_indic Bijection Stepping Stone (GHL2025.lean)

| Declaration | Role | Status |
|---|---|---|
| `indicatorOracleImage` | Extracted image function: `j → expectedImage` for U_indic | implemented |
| `indicatorOracleMatrix_eq_image` | Matrix entry = `if i = image j then 1 else 0` | proved (by simp) |
| `indicatorOracleImage_self_inverse_n1` | Self-inverse for n=1: `image(image(j)) = j` | proved (native_decide) |
| `indicatorOracleImage_self_inverse_n3` | Self-inverse for n=3: `image(image(j)) = j` | proved (native_decide) |

The self-inverse property (`image ∘ image = id`) is the key stepping stone toward proving U_indic is a permutation matrix and hence unitary. A self-inverse function on a finite set is automatically a bijection, and a bijection matrix with 0/1 entries is unitary.

### Cycle 11 Tests Added

| Test | Parameters | Method | Status |
|---|---|---|---|
| Coeff.rat addition evaluates | `evalWith (add (rat 1) (rat 2)) = 3` | native_decide | proved |
| Coeff.rat multiplication evaluates | `evalWith (mul (rat 2) (rat 3)) = 6` | native_decide | proved |
| Coeff.rat negation evaluates | `evalWith (neg (rat 5)) = -5` | native_decide | proved |
| Coeff.rat compound evaluates | `evalWith (add (mul (rat 2) (rat 3)) (rat 1)) = 7` | native_decide | proved |
| Image boundary j=0 → 0 | n=3, κ=7 | native_decide | proved |
| Image bulk j=4 → 132 | n=3, κ=7 | native_decide | proved |
| Image round-trip 132 → 4 | n=3, κ=7 | native_decide | proved |
| Self-inverse n=3 | full space 2^13 | native_decide | proved |
| Self-inverse n=1 | full space 2^7 | native_decide | proved |

## Cycle 12: General U_indic Self-Inverse and Bijection

### Proof-DAG Block: Bit-Arithmetic Reusable Lemmas

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `shiftLeft_land_mask_eq_zero` | `(b <<< pos) &&& mask = 0` when `pos >= n` | none | `shiftLeft_land_mask_eq_zero` | `xor_shift_preserve_low`, SWAP/O_D^BS bijection | proved |
| `xor_shift_preserve_low` | XOR with high bit preserves low `n` bits | `shiftLeft_land_mask_eq_zero` | `xor_shift_preserve_low` | `systemVal_preserved` | proved |
| `xor_shift_preserve_shift_low` | Shifted variant: high-XOR preserves shifted low bits | none | `xor_shift_preserve_shift_low` | `systemVal_preserved` | proved |
| `robinIndicatorBitPosition_ge` | `robinIndicatorBitPosition >= 1 + p.n` | none | `robinIndicatorBitPosition_ge` | `systemVal_preserved` | proved |
| `systemVal_preserved` | `systemVal(image(j)) = systemVal(j)` for all `p` | `xor_shift_preserve_shift_low`, `robinIndicatorBitPosition_ge` | `indicatorOracleImage_systemVal_preserved` | `isBulk_preserved`, `self_inverse` | proved |
| `isBulk_preserved` | Bulk membership unchanged by image | `systemVal_preserved` | `indicatorOracleImage_isBulk_preserved` | `self_inverse` | proved |
| `self_inverse_gen` | `image(image(j)) = j` for all `p, j` | `isBulk_preserved` | `indicatorOracleImage_self_inverse` | `injective_gen`, `bijective` | proved |
| `injective_gen` | Injectivity from self-inverse | `self_inverse_gen` | `indicatorOracleImage_injective` | `bijective_gen` | proved |
| `lt_totalQubits` | Image preserves `qubitDim` bound | `robinIndicatorBitPosition_lt_totalQubits` | `indicatorOracleImage_lt` | `bijective_gen` | proved |
| `bijective_gen` | `image` is bijective on `Fin (qubitDim total)` | `self_inverse_gen`, `injective_gen`, `lt_totalQubits` | `indicatorOracleImage_bijective` | U_indic unitarity | proved |

### Remaining Obligations After Cycle 12

| Obligation | Status |
|---|---|
| U_indic full unitarity proof (bijection → permutation → unitary) | **proved** (run 02 cycle 02: `indicatorOracleMatrix_is_permutation`) |
| SWAP permutation unitarity | pending proof-DAG bit-slice lemmas; previous flat proof attempt was demoted |
| O_D^BS permutation unitarity | **blocked by contract drift**: the current helper is not the paper's padded sparse-index oracle; revise the register-level image formula before unitarity proof search |
| (O_D^BS)^† unitarity | blocked until the forward oracle contract and cleanup statement are corrected |
| O_DT^S diagonal unitarity | unproved, requires normalizer bound |
| Ry_boundary rotation unitarity | unproved, requires trig identity |
| O_f diagonal unitarity | unproved, requires |f(x)| ≤ N_f bound |
| Block extraction correctness | unproved |
| No promoted obligations from cycle 11 | verified |

## Run 02 Cycle 02: U_indic Permutation-Matrix Unitarity Bridge

### New Theorems

| Declaration | Role | Status |
|---|---|---|
| `indicatorOracleMatrix_col_has_one` | For each column j, entry at row image(j) = 1 | proved |
| `indicatorOracleMatrix_col_unique` | For each column j, the 1-entry row is unique | proved |
| `indicatorOracleMatrix_row_has_one` | For each row i, there exists a column j with M[i][j] = 1 (surjectivity) | proved |
| `indicatorOracleMatrix_row_unique` | For each row i, the 1-entry column is unique (injectivity) | proved |
| `indicatorOracleMatrix_is_permutation` | Main theorem: exactly one 1 per row and per column | proved |

### Updated Gate Matrix

| Declaration | Change | Status |
|---|---|---|
| `oneTermRobinGate_U_indic` | `unitary.proved := true` | updated |

### Obligation Resolution

| Obligation | Previous Status | New Status |
|---|---|---|
| U_indic unitarity | `proved := false` | `proved := true` |

### Documentation Promotions

| Item | Previous Status | New Status |
|---|---|---|
| Cycle 12 proof-DAG block entries | "in progress" / "assigned to lower" | "proved" |
| Cycle 12 paper correspondence | "assigned to lower" | "proved" |

### No Promoted Obligations

All other gate matrices remain `unitary.proved := false`. The `RobinProofObligations` defaults are unchanged.

## Cycle 1 (Run 03): SWAP Permutation-Matrix Unitarity via Proof-DAG

### Proof-DAG Block: SWAP Bit-Slice Reusable Lemmas

The SWAP oracle `swapOracleImage` exchanges two n-qubit register blocks at
positions `[1, 1+n)` and `[1+n, 1+2n)`.  The self-inverse proof decomposes into
bit-slice lemmas showing that after swap, block1' = block2 and block2' = block1,
hence diff' = diff and applying the XOR pattern twice cancels.

| Block | Interface | Dependencies | Lean declaration | Reused by | Status |
|---|---|---|---|---|---|
| `swap_diff_bounded` | `diff < 2^n` where `diff = block1 XOR block2` | `Nat.xor_lt_two_pow`, `Nat.and_lt_two_pow` | `swapOracleDiff_lt_two_pow` | `swap_block1_image`, `swap_block2_image`, `swap_lt` | proved |
| `swap_diff_shift_right_zero` | `diff >>> n = 0` for the SWAP block difference | `swap_diff_bounded`, `Nat.shiftRight_eq_zero` | `swapOracleDiff_shiftRight_eq_zero` | `swap_block2_image`, `swap_lt` | proved |
| `swap_diff_shift_left_mask_zero` | `(diff <<< n) &&& mask = 0` for `mask = 2^n - 1` | `shiftLeft_land_mask_eq_zero` | `swapOracleDiff_shiftLeft_mask_eq_zero` | `swap_block1_image` | proved |
| `shiftLeft_shiftRight_self` | `(b <<< k) >>> k = b` when no bits are lost | none | new lemma | `swap_block2_image` | planned |
| `swap_block1_image` | After swap, block1' = block2 | bit-test proof over `swapOracleImage` and mask facts | `swapOracleImage_block1_eq_block2` | `swap_diff_preserved` | proved |
| `swap_block2_image` | After swap, block2' = block1 | `swap_diff_bounded` | `swapOracleImage_block2_eq_block1` | `swap_diff_preserved` | planned |
| `swap_diff_preserved` | diff' = diff after swap | `swap_block1_image`, `swap_block2_image` | `swapOracleImage_diff_preserved` | `swap_self_inverse` | planned |
| `swap_self_inverse` | `image(image(j)) = j` for all `p, j` | `swap_diff_preserved` | `swapOracleImage_self_inverse` | `swap_injective`, `swap_bijective` | planned |
| `swap_injective` | Injectivity from self-inverse | `swap_self_inverse` | `swapOracleImage_injective` | `swap_bijective` | planned |
| `swap_lt` | Image preserves `qubitDim` bound | `swap_diff_bounded` | `swapOracleImage_lt` | `swap_bijective` | planned |
| `swap_bijective` | Bijective on `Fin (qubitDim total)` | `swap_self_inverse`, `swap_injective`, `swap_lt` | `swapOracleImage_bijective` | permutation proof | planned |
| `swap_col_has_one` | For each column j, entry at row image(j) = 1 | `swap_bijective` | `swapOracleMatrix_col_has_one` | `swap_is_permutation` | planned |
| `swap_col_unique` | For each column j, the 1-entry row is unique | `swap_bijective` | `swapOracleMatrix_col_unique` | `swap_is_permutation` | planned |
| `swap_row_has_one` | For each row i, surjectivity: ∃j with M[i][j]=1 | `swap_bijective` | `swapOracleMatrix_row_has_one` | `swap_is_permutation` | planned |
| `swap_row_unique` | For each row i, the 1-entry column is unique | `swap_bijective` | `swapOracleMatrix_row_unique` | `swap_is_permutation` | planned |
| `swap_is_permutation` | Exactly one 1 per row and per column | all above | `swapOracleMatrix_is_permutation` | gate proved update | planned |

### Key Bit-Arithmetic Facts

1. `(diff <<< n) &&& mask = 0` is now `swapOracleDiff_shiftLeft_mask_eq_zero`, reusing `shiftLeft_land_mask_eq_zero` from cycle 12 with `pos = n`.
2. `diff >>> n = 0` is now `swapOracleDiff_shiftRight_eq_zero`, derived from `swapOracleDiff_lt_two_pow` and `Nat.shiftRight_eq_zero`.
3. Right-shift distributes over XOR: `(a ^^^ b) >>> k = (a >>> k) ^^^ (b >>> k)` (Lean std `Nat.shiftRight_xor_distrib` or similar).
4. AND distributes over XOR: already used in `xor_shift_preserve_low` from cycle 12.
5. `(b <<< k) >>> k = b` when `b < 2^m` and no bits are lost: shift-left then shift-right cancels.

### Self-Inverse Proof Sketch

For `result = swapOracleImage p j`:
- `block1' = (result >>> 1) & mask = block2` (because `(diff <<< n) & mask = 0` and `diff & mask = diff`).
- `block2' = (result >>> (1+n)) & mask = block1` (because `diff >>> n = 0` and `diff & mask = diff`).
- `diff' = block1' XOR block2' = block2 XOR block1 = diff` (XOR is commutative).
- `swap(swap(j)) = j XOR (diff <<< 1) XOR (diff <<< (1+n)) XOR (diff <<< 1) XOR (diff <<< (1+n)) = j`.

### Non-Goals

- Do not touch O_D^BS, O_f, O_DT^S, Ry_boundary, or (O_D^BS)^†.
- Do not add assumptions, side conditions, or sorry.
- Do not change the paper's circuit or oracle construction.

### Middle Update: 2026-05-22

The first SWAP diff block is now Lean-proved without promoting the SWAP gate
obligation.  The paper source remains main.tex:1140, and the Lean declarations
only expose bit facts about the existing `swapOracleImage` formula:

| Declaration | Claim | Status |
|---|---|---|
| `swapOracleDiff_lt_two_pow` | the XOR diff of the two extracted n-bit blocks is below $2^n$ | proved |
| `swapOracleDiff_shiftRight_eq_zero` | the diff has no bits at positions $\geq n$ | proved |
| `swapOracleDiff_shiftLeft_mask_eq_zero` | shifting the diff into the high block contributes zero under the low n-bit mask | proved |

The lower packet proved `swapOracleImage_block1_eq_block2` only.  The remaining
planned symmetric block is `swapOracleImage_block2_eq_block1`.  The acceptance
gate is `python3 tools/qbe.py check`; `oneTermRobinGate_SWAP.unitary.proved`
must remain `false`.
