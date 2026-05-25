# Gamma3 Product-To-Coefficient Equality Attempt

Task: `QBE-AUTO-002`

Mode: `faithfulPaper`

Status: partial lemma compiled; full focused equality blocked

Paper anchors: GHL2025 Theorem `1 term robin`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`, arXiv:2506.20478.

## Fixed Target

The fixed theorem-facing obligation is
`Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation n i j`.
The first lower proof attempt should focus on the existing $n=3$ regression
data:

| Datum | Value |
|---|---|
| system size | `n = 3` |
| active `O_D^BS` source | `48` |
| clean `O_f` column | `36` |
| `O_DT^S` column | `132` |
| boundary `R_y` column | `0` |
| target system entry | `(2,5)` |

Suggested Lean declaration name:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientEquality_n3`.

## Route Contract

The attempt must start from
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface`.
That interface already exposes:

- the signal-zero `evalGateMatrices` product entry;
- the Ak target expansion from `oneTermRobinAkMatrix_apply`;
- the factor-entry data for `O_f`, `O_DT^S`, `Ry_boundary`, and active
  `O_D^BS`;
- the false flags for normalized block equality, LCU, cleanup, unitarity,
  projection, block correctness, circuit unitarity, and final extraction.

## Acceptance

An accepted attempt compiles one of the following:

| Result type | Requirement |
|---|---|
| equality lemma | a focused equality that materially advances the proof that the projected seven-gate product entry equals `(A_k)_{ij}/(N_D*N_f*kappa)` |
| path-isolation lemma | a focused lemma isolating the relevant nonzero product path from `evalGateMatrices` for the fixed entry |
| blocked proof record | an update to this file with the exact Lean goal, error, and missing interface if the equality cannot yet be stated or proved |

Do not accept a new false-flag guard as the main result.

## Current Dependency Classification

| Ingredient | Classification | Status |
|---|---|---|
| finite seven-gate product entry | `classical-lean-lemma` | next proof attempt |
| quotient by `N_D*N_f*kappa` | `internal-paper-step`; possible Lean contract gap for the symbolic quotient convention | record precisely if missing |
| `O_f` clean amplitude | `external-cited-result` | use cited row `GL2024.Thm5.AmplitudeOracle`; do not promote |
| derivative and boundary amplitude factors | `contract-only` internal transcript | use rows `GHL2025.Lemma3.ODTS` and `GHL2025.RyBoundary`; do not promote |
| active sparse-access cleanup entry | `contract-only` restricted global-source data | use row `QBE.ODBS.GlobalSparseSlotAddress`; do not promote |
| LCU/block extraction | `external-cited-result` plus QBE finite theorem obligation | use row `LCU.StandardBlockEncoding`; do not promote |

## Forbidden Promotions

Keep these false unless an exact build-tested Lean theorem proves them:

- `oneTermRobinGamma3ProductToCoefficientObligation.proved`;
- `oneTermRobinGamma3SignalBlockEntryObligation.proved`;
- `oneTermRobinFiniteBlockCompositionContract.normalizedBlockEquality.proved`;
- LCU composition;
- `O_f` amplitude correctness;
- `O_D^BS` cleanup and unitarity;
- `O_DT^S` and `Ry_boundary` unitarity;
- block projection, block correctness, circuit unitarity, and final extraction.

## Lower Attempt: 2026-05-25 Evaluated Single-Step Product Block

Lean declaration compiled:
`QuantumBlockEncoding.Matrix.evalWith_mul_apply`.

Definition first: for `Coeff`-valued matrices, raw `Matrix.mul` builds a
syntactic `Coeff.add` fold over all intermediate basis states.  The compiled
lemma evaluates one product entry under an environment and rewrites it as a
finite fold in `Rat`:

$$
\operatorname{evalWith}((AB)_{ij})
=
\sum_k \operatorname{evalWith}(A_{ik})\operatorname{evalWith}(B_{kj}).
$$

This is a proof-DAG block for future path isolation.  It does not identify the
seven-gate Robin path and does not prove the product-to-coefficient equality.

Focused proof probe:

```lean
#eval (repr ((evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders
    (Examples.RobinHeat.oneTermParameters 3)))
  ⟨2, by native_decide⟩ ⟨5, by native_decide⟩))
```

Result: timed out after 30 seconds.  The direct unfolded entry attempts to
expand the full $2^{13}$-dimensional product and is not a usable route for the
fixed theorem.

Remaining exact blockers:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| seven-gate path isolation | only a one-step evaluated product fold is compiled | a stepwise path lemma that composes `Matrix.evalWith_mul_apply` without expanding all intermediate basis states |
| normalized quotient convention | `Coeff` has `N_D_inv` and `N_f_inv` symbols but no theorem tying them to division by `oneTermRobinNormalizer` | a typed normalized-entry convention for `A_k/(N_DN_f\kappa)` |
| `O_DT^S` ket-zero coefficient | `ketZeroEntry = odts_cos_half_2_0`, while `normalizedCoefficient = D_j^(s) * N_D_inv` remains an obligation | a theorem or contract bridge from the symbolic ket-zero entry to the normalized derivative coefficient |
| `Ry_boundary` coefficient | `cosHalfEntry = boundary_cos_half_0_0`, while the arccos/half-angle relation remains an obligation | a theorem or contract bridge from the symbolic half-angle entry to the recorded derivative coefficient |

## Middle Follow-up: Unique-Path Product Block

The lower result is accepted as a reusable proof-DAG block, but it is only the
single-step evaluated product expansion.  The next attempt should first prove
the generic unique-path form before returning to the $n=3$ Robin entry.

Planned generic target:
`QuantumBlockEncoding.Matrix.evalWith_mul_unique_path`.

Expected interface:

| Input | Requirement |
|---|---|
| matrices | `A : Matrix rows mid Coeff` and `B : Matrix mid cols Coeff` |
| indices | row `i`, column `j`, and chosen intermediate path `k0 : Fin mid` |
| zero-support hypothesis | for every `k != k0`, the evaluated contribution `Coeff.evalWith env (A i k) * Coeff.evalWith env (B k j)` is zero |
| conclusion | the evaluated product entry equals the surviving contribution at `k0` |

After that generic block compiles, apply it to the fixed gamma3 data or record
the exact missing support facts.  The application should still start from
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of the seven-gate entry | low | timed out after 30 seconds | do not retry globally |
| one-step evaluated product expansion | partial | `Matrix.evalWith_mul_apply` compiled | extend to unique-path fold |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | reuse as the one-step path-isolation block |
| focused $n=3$ gamma3 path application | pending | support facts not isolated | choose the intermediate states for the seven-gate path and prove zero-support facts gate-by-gate |

## Middle Follow-up: Projection-Slot Convention

The slot-alignment audit showed that the focused coefficient $D_{2,5}$ uses
global sparse slot `5`, not slot `0`.  Middle added the contract map
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3`.
It records slot-`5` endpoints `90` and `84`, while the generic signal-zero
projection endpoints remain `5` and `2`.

The remaining convention is named by
`Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation` and
has `proved = false`.  Do not apply `Matrix.evalWith_mul_unique_path` to the
seven-gate product until a lower packet audits the slot-`5` adjacent states
from source column `90` to candidate row `84` and lists the required
zero-support facts.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| slot-zero paper-basis path | low | compiled mismatch, reaches row `198` instead of row `4` | do not retry as the coefficient path for $D_{2,5}$ |
| slot-`5` endpoint convention | partial | projection-slot contract map compiled, convention still false | audit the seven-gate adjacent states for source `90` and row `84` |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | apply only after the slot-`5` path and zero-support facts are fixed |

## Lower Attempt: 2026-05-25 Slot-5 Path Audit

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3`.

The audit shows that the coefficient-specific clean subchain for $D_{2,5}$ is

$$
90 \xrightarrow{O_D^{BS}} 42 \xrightarrow{\mathrm{SWAP}} 84,
$$

but the actual Fig. `fig:1 term ROBIN` circuit first applies `U_indic`.  The
ket-zero branch of the seven-gate path is

$$
90 \to 218 \to 218 \to 218 \to 170 \to 170 \to 212 \to 228.
$$

The final dagger entry at row `228`, column `212` is `1`, while the entry at
the clean slot-`5` row `84`, column `212` is `0`.  The final row has
sparse-index value `6`, while the clean row has sparse-index value `5`.

This is not a failure of `Matrix.evalWith_mul_unique_path`.  The current proof
attempt is blocked earlier by the missing projection/register convention that
relates the full circuit endpoint to the clean Eq. `eq: ROBIN clarified`
endpoint or to a sparse-register summation.

## Middle Follow-up: Projection/Register Audit

The next mutation is a typed register-field audit, not another product
expansion.

Suggested target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3`.

Expected output:

| Input state | Required comparison |
|---|---|
| clean source `90` | indicator bit, trailing ancilla bit, system value `5`, sparse slot `5`, padded-zero field, clean `m_f` workspace |
| after `U_indic` state `218` | changed indicator/upper qubit fields and preserved system/sparse fields |
| after `O_D^BS` state `170` | written address and preserved source row/sparse fields |
| post-SWAP state `212` | system/address registers after the swap |
| final endpoint `228` | row value, sparse-index value, active-source predicate, and any high-workspace fields |
| clean endpoint `84` | the same fields, with the first mismatch named explicitly |

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of the seven-gate entry | low | timed out after 30 seconds | do not retry globally |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | keep for after the projection/register convention is fixed |
| slot-zero paper-basis path | low | compiled mismatch, reaches row `198` instead of row `4` | retained as negative evidence |
| slot-`5` path audit | partial | compiled mismatch, reaches row `228` instead of row `84` | add field-level projection/register audit |
| projection-slot convention bridge | blocked | `oneTermRobinGamma3ProjectionSlotConventionObligation.proved = false` | state exact theorem convention before product multiplication |

## Lower Attempt: 2026-05-25 Generic Unique-Path Product Block

Lean declaration compiled:
`QuantumBlockEncoding.Matrix.evalWith_mul_unique_path`.

Definition first: for `Coeff`-valued matrices $A$ and $B$, an environment
`env`, row `i`, column `j`, and an intermediate index `k0`, the lemma states
that if every evaluated path contribution for `k != k0` is zero, then the
evaluated product entry is the single surviving contribution:

$$
\operatorname{evalWith}((AB)_{ij})
=
\operatorname{evalWith}(A_{ik})\operatorname{evalWith}(B_{kj}).
$$

The proof reuses `Matrix.evalWith_mul_apply` and proves the finite
`List.finRange` fold arithmetic over `Rat`.  `Tests/Basic.lean` now has a
two-by-two symbolic matrix example where the unique path is index `1`.

This is a path-isolation lemma, not the Robin seven-gate equality.  No
product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

Remaining exact blockers:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| seven-gate path support for the fixed $n=3$ entry | generic one-step unique-path lemma compiled, but no Robin intermediate-state sequence has been fixed | choose the sequence of six intermediate basis states for source `48`, clean `O_f` column `36`, `O_DT^S` column `132`, boundary column `0`, and target entry `(2,5)` |
| zero-support facts for each gate multiplication | no per-gate support lemmas yet | for each adjacent product step, prove all nonchosen intermediate contributions evaluate to zero without unfolding the full $2^{13}$ product |
| normalized quotient convention | `Coeff` has `N_D_inv` and `N_f_inv` symbols but no theorem tying them to division by `oneTermRobinNormalizer` | a typed normalized-entry convention for `A_k/(N_DN_f\kappa)` |
| `O_DT^S` ket-zero coefficient | `ketZeroEntry = odts_cos_half_2_0`, while `normalizedCoefficient = D_j^(s) * N_D_inv` remains an obligation | a theorem or contract bridge from the symbolic ket-zero entry to the normalized derivative coefficient |
| `Ry_boundary` coefficient | `cosHalfEntry = boundary_cos_half_0_0`, while the arccos/half-angle relation remains an obligation | a theorem or contract bridge from the symbolic half-angle entry to the recorded derivative coefficient |

## Middle Audit: 2026-05-25 Focused Path-State Mismatch

Definition first: the focused product entry is the signal-zero projection entry
for `n = 3`, target system row `2`, and source system column `5`.  The current
projection helpers make this the full matrix entry `(2,5)`:

| Quantity | Value |
|---|---|
| `signalSystemBlockRowIndex (gridSize 3) 0 2` | `2` |
| `signalSystemBlockColIndex (gridSize 3) 0 5` | `5` |
| product convention | `(O_D^BS)^dagger * SWAP * O_f * O_D^BS * Ry_boundary * O_DT^S * U_indic` |

The current factor-entry ledger columns do not yet form one coherent path for
that full entry.  This is the exact finite-state audit:

| Audit route | States or entries | Consequence |
|---|---|---|
| forward from projected column `5` | `5 -> 133` under `U_indic`; ket-zero `O_DT^S` branch `133 -> 132` has entry `-odts_sin_half_2_0`; `Ry_boundary` is identity at `132`; `O_D^BS` keeps `132`; clean `O_f` keeps `132`; `SWAP` sends `132` to `160`; `(O_D^BS)^dagger` sends column `160` to row `192`, and row `2` at column `160` is zero | this is not the desired row-`2` gamma3 path |
| active `O_D^BS` source witness `48` | `48 -> 16` under `O_D^BS`; clean `O_f` at `16` is for system value `0`; `SWAP 16 = 2`; dagger cleanup uses preimage row `18` with entry `(18,2)=1` | this is a valid cleanup ledger witness, not the projected product path |
| clean `O_f` witness `36` | clean branch is `f_3_2 * N_f_inv` | this supplies the target factor but is not reached from source `48` or projected column `5` |
| `O_DT^S` witness `132` | `(132,132)` gives `odts_cos_half_2_0` | the projected-column branch uses `(132,133)` instead |
| `Ry_boundary` witness `0` | `(0,0)` gives `boundary_cos_half_0_0` | the projected-column branch has indicator bit `1`, so the boundary gate is identity |
| backward from final row `2` | previous dagger column must be `114`; previous SWAP column is `30`; clean `O_f` at `30` is for system value `7`; `O_D^BS` preimage of `30` is `78` | this reverse path does not start from projected column `5` |

Classification: `block-projection/register-layout gap`.  The source paper's
Eq. `eq: ROBIN clarified` ket order and the current
`signalSystemBlockRowIndex`/`signalSystemBlockColIndex` convention have not
yet been connected by a Lean register-layout theorem.  A lower agent should
not multiply the ledger entries as though they are one unique path.

Next fixed lower target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionPathAudit_n3`.

Expected lower output:

| Item | Required result |
|---|---|
| path audit theorem | compile the state equalities above, including the mismatch facts `18 != 2`, `16 != 36`, and the row-`2` dagger entry at column `160` being zero |
| projection decision | either name the missing register-layout bridge for the clean gamma3 branch or state a corrected theorem-facing block-index convention |
| zero-support route | postpone `Matrix.evalWith_mul_unique_path` application until the coherent path and its adjacent support facts are fixed |

Forbidden: do not add another false-flag guard as the main result, do not
unfold the full seven-gate product, and do not promote product-to-coefficient,
signal-block, LCU, cleanup, unitarity, projection, block correctness, circuit
unitarity, normalized equality, or final extraction.

No product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

## Middle Follow-up: Paper-Basis Path Audit Packet

The accepted layout bridge fixes the next proof attempt to full-space endpoint
`(row, column) = (4, 10)` for the focused `n = 3`, sparse-slot-zero branch.
The older projected endpoint `(2,5)` remains a mismatch audit and should not be
used for unique-path multiplication.

Next fixed target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3`.

Expected output:

| Item | Requirement |
|---|---|
| adjacent states | compute the candidate states through `U_indic`, `O_DT^S`, `Ry_boundary`, `O_D^BS`, `O_f`, `SWAP`, and `(O_D^BS)^dagger` starting from column `10` and ending at row `4` |
| first mismatch | if the executable path does not end at row `4`, record the first gate where the paper-basis branch and active Lean image diverge |
| next proof block | classify the next needed interface as either a projection-layout bridge, a gate-entry support lemma, or a source-contract gap |
| forbidden work | do not retry direct full product expansion and do not promote semantic flags |

Proof-attempt population update:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| current projected entry `(2,5)` | rejected for gamma3 clean branch | compiled mismatch audit | keep as regression memory |
| paper-basis endpoint `(4,10)` | useful | endpoints compiled | audit adjacent path states |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | apply only after the path-state audit fixes support facts |

## Middle Follow-up: 2026-05-25 Projection Layout Contract Drift

The lower path audit is accepted as mismatch evidence.  It changes the next
mutation: do not apply `Matrix.evalWith_mul_unique_path` to full entry `(2,5)`
yet.  The current projection convention is not aligned with the paper ket order
in Eq. `eq: ROBIN clarified`.

Paper-to-Lean map for the clean gamma3 ket:

| Paper component | Lean bit range | Clean value | Contribution |
|---|---|---|---|
| trailing ancilla | bit `0` | `0` | none |
| system $j$ | bits `[1, 1+n)` | `j` | `j <<< 1` |
| O_D pure ancillas | bits `[1+n, 1+n+odPure)` | `0` | none |
| sparse slot $s$ | bits `[1+n+odPure, 1+n+odPure+sparse)` | `s` | `s <<< (1+n+odPure)` |
| indicator and $m_f$ workspace | higher bits | `0` | none |

For `n = 3`, `kappa = 7`, this is `(s <<< 4) + (j <<< 1)`.  The focused
zero-sparse system indices `2` and `5` therefore correspond to full indices
`4` and `10`, whereas `signalSystemBlockProjection` used `2` and `5`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of seven-gate entry | low | timed out | do not retry globally |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | keep as reusable block |
| current projected entry `(2,5)` | rejected for now | compiled audit shows mismatch | do not multiply factor ledger on this entry |
| paper-basis layout bridge | high priority | not yet implemented | target `oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3` |
| coherent gamma3 path after layout bridge | pending | full row/column not fixed | choose adjacent states after paper-basis theorem compiles |

The next lower result should be a layout/index contract or a blocked statement
for why that contract cannot yet be expressed.  It should not be another
false-flag guard and must not promote any semantic flag.

## Lower Attempt: 2026-05-25 Gamma3 Projection Path Audit

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionPathAudit_n3`.

Definition first: for the fixed $n=3$ projection entry, the current
signal-zero convention sends system entry $(2,5)$ to full entry `(2,5)`.
The executable forward branch from column `5` is:

$$
5 \to 133 \to 132 \to 132 \to 132 \to 132 \to 160.
$$

At the final dagger step, row `192` has entry `1` at column `160`, while row
`2` has entry `0` at column `160`.  The existing cleanup witness from source
`48` remains separate: `48 -> 16 -> 2` with preimage candidate `18`, and the
audit records `18 != 2` and `16 != 36`.

This confirms the previous middle classification as a
`block-projection/register-layout gap`.  The standalone clean `O_f` witness at
column `36`, the standalone `O_DT^S` cosine witness at `(132,132)`, and the
standalone `Ry_boundary` cosine witness at `(0,0)` should not be multiplied as
one path for the projected full entry `(2,5)`.

`Tests/Basic.lean` checks the indicator step, the sine branch at `(132,133)`,
the zero dagger entry `(2,160)`, the source-`48` preimage candidate, and the
reverse-chain fact `bandedSparseAccessPaperImage p 78 = 30`.

Remaining exact blockers:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| paper ket order versus QBE signal-zero full-basis index | focused audit compiled, mismatch confirmed | a register-layout bridge for the clean gamma3 branch before any unique-path application |
| coherent seven-gate path | not yet selected for the current projection convention | either revise the theorem-facing block-index convention or prove the paper-to-Lean layout translation |
| zero-support facts | still postponed | prove only after a coherent adjacent-state sequence is fixed |
| product-to-coefficient equality | still obligation-only | do not attempt until layout/path bridge and normalized quotient contract exist |

No product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

## Lower Attempt: 2026-05-25 Gamma3 Paper-Basis Layout

Lean declarations compiled:

- `Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3`

Definition first: the clean Eq. `eq: ROBIN clarified` basis index is now named
as

$$
(s \ll (1+n+odPure)) + (j \ll 1),
\qquad odPure = n-\lceil\log_2\kappa\rceil .
$$

For the focused `n = 3`, `kappa = 7`, sparse-slot-zero entry `(2,5)`, the
compiled layout theorem records:

| Quantity | Value |
|---|---|
| paper-basis row for system `2` | `4` |
| paper-basis column for system `5` | `10` |
| current signal-zero projected row | `2` |
| current signal-zero projected column | `5` |
| paper row versus projected row | different |
| paper column versus projected column | different |
| `U_indic` on paper column `10` | `138` |
| `O_DT^S` registers at `138` | indicator `1`, ancilla `0`, row `5`, sparse slot `0` |

The theorem also checks that the existing `GHL2025` `O_D^BS` and `O_f`
register extractors see clean global-slot source data at full indices `4` and
`10`.  This is a layout/index contract only.  It does not identify the final
seven-gate product path, does not apply `Matrix.evalWith_mul_unique_path`, and
does not promote any semantic flag.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| current projected entry `(2,5)` | rejected for now | compiled audit shows the path misses row `2` | do not multiply factor ledger on this entry |
| paper-basis layout bridge | useful | `oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3` compiled | choose adjacent full-space states for row `4`, column `10` |
| coherent gamma3 path after layout bridge | pending | paper-basis endpoints fixed, intermediate states not yet fixed | audit the seven-gate path from column `10` to row `4` before unique-path search |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | reuse only after adjacent support facts are stated |

Remaining exact blockers:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| coherent seven-gate path for paper-basis endpoints | endpoints `4` and `10` are compiled; adjacent states are not yet selected | a path-state audit from column `10` through the Fig. `fig:1 term ROBIN` gate order to determine whether row `4` is reachable |
| zero-support facts | still postponed | prove one gate-adjacent support lemma only after the coherent state sequence is fixed |
| normalized quotient convention | unchanged | typed convention tying `N_D_inv`, `N_f_inv`, and `kappa` to division by `N_DN_f\kappa` |
| analytic oracle bridges | unchanged | keep $O_f$, $O_{D^T}^S$, and `Ry_boundary` relations as contract-only until formalized |

## Lower Attempt: 2026-05-25 Gamma3 Paper-Basis Path Audit

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3`.

Definition first: the focused clean paper-basis entry is still the sparse-slot
`0` endpoint pair `(row, column) = (4,10)` from
`oneTermRobinGamma3PaperBasisIndex`.

The active executable branch from column `10` does not end at row `4`.  The
ket-zero branch is:

$$
10 \to 138 \to 138 \to 138 \to 186 \to 186 \to 214 \to 198 .
$$

The final dagger column is `214`.  The active dagger matrix has entry `1` at
row `198` and entry `0` at the target row `4`.  The theorem also checks the
ket-one side branch through `139`, `187`, and `215`.

First mismatch: after `U_indic`, the active `O_D^BS` step sees row `5` and
sparse slot `0`, then writes global sparse address `3`.  SWAP then exposes
system row `3`, so the cleanup preimage is row `198` rather than the paper
clean row `4`.

Updated blockers:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| sparse-slot choice for target `(2,5)` | sparse slot `0` path compiled and misses row `4` | map the paper coefficient $D_{ij}$ to the correct sparse slot before product multiplication |
| coherent seven-gate path | still not selected | audit the corrected sparse slot or introduce the precise projection/basis bridge that explains the intended row |
| zero-support facts | still postponed | prove only after a coherent adjacent-state sequence is fixed |
| product-to-coefficient equality | still obligation-only | keep `oneTermRobinGamma3ProductToCoefficientObligation.proved = false` |

No product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

## Middle Follow-Up: Sparse-Slot Alignment

Definition first: for a fixed target matrix entry $(i,j)$, the active global
sparse-access contract should choose a sparse slot $s$ satisfying
`GHL2025.oneTermRobinGlobalSparseAddress n s j = i`, or the conversion window
must record why the theorem route uses a different projection over the sparse
register.

For the focused entry `(i,j) = (2,5)` at `n = 3`, slot `0` satisfies
`GHL2025.oneTermRobinGlobalSparseAddress 3 0 5 = 3`, so it cannot be the
coherent path to row `2`.  The next lower attempt should audit the candidate
`-3` slot, currently global sparse slot `5`, before any unique-path product
lemma is applied.

Planned Lean target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3`.

Expected facts:

| Fact | Purpose |
|---|---|
| `GHL2025.oneTermRobinGlobalSparseAddress 3 0 5 = 3` | preserve the accepted slot-zero mismatch audit |
| candidate slot `5` maps source column `5` to target row `2` | identify the sparse slot for coefficient $D_{2,5}$ |
| `oneTermRobinGamma3PaperBasisIndex p 5 5` is the clean paper-basis source index for that slot | choose a coherent endpoint before path isolation |
| all theorem-level semantic flags remain false | keep this as transcript alignment, not a proof of the block equality |

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of the seven-gate entry | low | timed out after 30 seconds | do not retry globally |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | reuse only after a coherent path is fixed |
| generic signal-zero endpoint `(2,5)` | low | projection path audit compiled mismatch | superseded by paper-basis audit |
| slot-zero paper-basis endpoint `(4,10)` | partial negative | path reaches row `198`, not row `4` | preserve as mismatch evidence |
| sparse-slot alignment for target `(2,5)` | pending | slot candidate not yet compiled | audit slot `5` and the resulting paper-basis endpoint |

## Lower Attempt: 2026-05-25 Sparse-Slot Alignment

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3`.

Definition first: for the focused coefficient $D_{2,5}$, the sparse slot must
satisfy `GHL2025.oneTermRobinGlobalSparseAddress 3 s 5 = 2`.

The compiled audit keeps the slot-zero path as negative evidence:
`GHL2025.oneTermRobinGlobalSparseAddress 3 0 5 = 3`.  It then records that
slot `5`, the `-3` global slot, maps source column `5` to target row `2`:
`GHL2025.oneTermRobinGlobalSparseAddress 3 5 5 = 2`.

Slot-specific clean endpoint facts now available:

| Fact | Lean value |
|---|---:|
| `oneTermRobinGamma3PaperBasisIndex p 5 5` | `90` |
| `oneTermRobinGamma3PaperBasisIndex p 5 2` | `84` |
| `GHL2025.bandedSparseAccessPaperAddress p 90` | `2` |
| `GHL2025.bandedSparseAccessPaperImage p 90` | `42` |
| `GHL2025.swapOracleImage p 42` | `84` |

The source column `90` is in the active global-slot clean source domain with
row value `5`, padded-zero value `0`, and sparse slot `5`.  The theorem also
preserves the earlier slot-zero mismatch: after `U_indic`, the slot-zero
branch uses column `138`, the active `O_D^BS` image is `186`, and the final
dagger entry at target row `4`, column `214` is `0`.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of the seven-gate entry | low | timed out after 30 seconds | do not retry globally |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | reuse only after a coherent path is fixed |
| generic signal-zero endpoint `(2,5)` | low | projection path audit compiled mismatch | superseded by paper-basis audits |
| slot-zero paper-basis endpoint `(4,10)` | partial negative | path reaches row `198`, not row `4` | preserve as mismatch evidence |
| sparse-slot alignment for target `(2,5)` | useful | slot `5` endpoint audit compiled | state the projection-slot convention or audit the slot-`5` seven-gate adjacent states |

## Lower Attempt: 2026-05-25 Slot-5 Path Audit

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3`.

The audit starts from the compiled slot-`5` endpoint facts:
`oneTermRobinGamma3PaperBasisIndex p 5 5 = 90` and
`oneTermRobinGamma3PaperBasisIndex p 5 2 = 84`.  It then applies the actual
Fig. `fig:1 term ROBIN` gate order.  The ket-zero branch follows
`90 -> 218 -> 218 -> 218 -> 170 -> 170 -> 212 -> 228`, not `90 -> 42 -> 84`.
The ket-one side branch follows
`90 -> 218 -> 219 -> 219 -> 171 -> 171 -> 213 -> 229`.

The first mismatch with the clean endpoint chain is `U_indic`: column `90`
has indicator bit `0`, while `GHL2025.indicatorOracleImage p 90 = 218` has
indicator bit `1`.  At the final dagger step, row `228` has entry `1` at
column `212`, while row `84` has entry `0`.  The row `228` preimage also has
sparse-index value `6`, not the slot-`5` value of row `84`.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of the seven-gate entry | low | timed out after 30 seconds | do not retry globally |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | reuse only after a coherent path and projection convention are fixed |
| generic signal-zero endpoint `(2,5)` | low | projection path audit compiled mismatch | superseded by paper-basis audits |
| slot-zero paper-basis endpoint `(4,10)` | partial negative | path reaches row `198`, not row `4` | preserve as mismatch evidence |
| sparse-slot alignment for target `(2,5)` | useful | slot `5` endpoint audit compiled | consumed by slot-`5` path audit |
| slot-`5` full seven-gate path | useful negative | path reaches row `228`, not clean row `84` | state the projection/register convention before applying unique-path multiplication |

No product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

No product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

## Lower Attempt: 2026-05-25 Projection/Register Audit

Lean declarations compiled:

- `Examples.RobinHeat.oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3`

The audit consumes the slot-`5` path result and compares the final endpoint
`228` with the clean Eq. `eq: ROBIN clarified` endpoint `84` field by field.
The first mismatch in the requested order is the indicator bit: final endpoint
`228` has indicator `1`, while clean endpoint `84` has indicator `0`.  The
sparse-index field also differs, with `228` carrying sparse index `6` and `84`
carrying sparse index `5`.  Ancilla bit, system row, padded-zero field,
`m_f` cleanliness, and active-source status agree for those two endpoints.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct full `#eval`/unfold of the seven-gate entry | low | timed out after 30 seconds | do not retry globally |
| generic unique-path product lemma | useful | `Matrix.evalWith_mul_unique_path` compiled | reuse only after a coherent projection/register convention is fixed |
| slot-zero paper-basis endpoint `(4,10)` | partial negative | path reaches row `198`, not row `4` | preserve as mismatch evidence |
| sparse-slot alignment for target `(2,5)` | useful | slot `5` endpoint audit compiled | consumed by slot-`5` path and register audits |
| slot-`5` full seven-gate path | useful negative | path reaches row `228`, not clean row `84` | consumed by projection/register audit |
| slot-`5` projection/register audit | useful negative | compiled; first mismatch is indicator bit, sparse index also mismatches | state the projection/summation convention before product multiplication |

No product-to-coefficient, signal-block, LCU, cleanup, unitarity, block
projection, block correctness, circuit unitarity, normalized equality, or final
extraction flag was promoted.

## Middle Decision: 2026-05-25 Projection/Register Convention

Lean decision record compiled:
`Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`.
Transcript theorem compiled:
`Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript`.

The product route is now explicitly blocked.  The source paper gives the clean
Eq. `eq: ROBIN clarified` branch and the full Fig. `fig:1 term ROBIN` circuit,
but the local audit shows that the actual seven-gate endpoint `228` is not the
clean endpoint `84`.  The first mismatch is the indicator bit, and the sparse
index also differs.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but blocked | `Matrix.evalWith_mul_unique_path` compiled in isolation | wait for an exact projection/register convention |
| slot-`5` projection/register audit | useful negative | compiled; endpoint mismatch classified | consumed by decision record |
| projection/register convention decision | blocker | compiled with `productSearchBlocked = true` and false semantic flags | human or upper-agent must choose sparse-register summation, basis permutation, or revised projection layout |

No further product-to-coefficient attempts should run until that convention is
stated as a fixed Lean target.

## Lower Attempt: 2026-05-25 Convention Blocker Recheck

No Lean product proof was attempted in this lower packet.  The active compiled
decision record
`Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`
already classifies the focused gamma3 endpoint mismatch as a
`source-contract-gap plus internal-paper-step`, with
`productSearchBlocked = true`.

The next admissible Lean target is not another
`Matrix.evalWith_mul_unique_path` route.  It must first be one exact
projection/register convention statement: sparse-register summation,
basis-permutation bridge, or revised block-projection layout.  Until that
statement is chosen, keep
`oneTermRobinGamma3ProjectionSlotConventionObligation.proved = false`,
`oneTermRobinGamma3ProductToCoefficientObligation.proved = false`, and all
LCU, cleanup, unitarity, block-projection, block-correctness, circuit-unitary,
normalized-equality, and final-extraction flags false.

## Middle Sync: 2026-05-25 Upper Directive

The proof-attempt population is paused at the convention-decision boundary.
The active compiled record is
`Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`,
with transcript theorem
`Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript`.

Current population after the upper directive:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | `Matrix.evalWith_mul_unique_path` compiled | reuse only after the projection/register convention is stated |
| slot-`5` endpoint and path audit | useful negative | clean endpoint `84`; full path endpoint `228` | retained as source-contract-gap evidence |
| slot-`5` projection/register audit | useful negative | first mismatch is indicator bit; sparse index also differs | consumed by the convention decision record |
| projection/register convention decision | active blocker | compiled; `productSearchBlocked = true` | choose sparse-register summation, basis-permutation bridge, or revised block-projection layout |
| direct product-to-coefficient search | blocked | no coherent endpoint convention | do not run |

Next allowed lower packet:

| Field | Requirement |
|---|---|
| fixed target | one exact convention statement selected from the source or approved by upper/human direction |
| allowed theorem shape | sparse-register summation rule, basis-permutation bridge, or revised block-projection layout |
| required reuse | `oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`, `oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3`, and the existing `oneTermRobinBlockEncodingProofRoute` |
| forbidden work | no new seven-gate multiplication, no full product unfolding, no new route record, no new sparse-offset table |
| forbidden promotion | keep product-to-coefficient, LCU, cleanup, unitarity, block projection, block correctness, circuit unitarity, normalized equality, and final extraction false |

## Middle Sync: 2026-05-25 Chosen Sparse-Summation Convention

The proof-attempt population is still blocked from product multiplication, but
the next convention target is no longer an open menu.  Middle selected
sparse-register summation because Eq. `eq: ROBIN clarified` writes the
$\gamma_3$ contribution as a sum over $s=0,\dots,\kappa-1$, and no inspected
source anchor states a basis permutation from `228` to `84` or a replacement
finite block-projection layout.

Updated population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | `Matrix.evalWith_mul_unique_path` compiled | reuse only after the convention theorem compiles |
| slot-`5` endpoint and path audit | useful negative | clean endpoint `84`; full path endpoint `228` | consumed by sparse-summation convention target |
| slot-`5` projection/register audit | useful negative | system row agrees; indicator and sparse index differ | required input to the convention target |
| sparse-register summation convention | selected | source-backed by Eq. `eq: ROBIN clarified`; indicator mismatch still explicit | state `oneTermRobinGamma3SparseRegisterSummationConvention_n3` |
| direct product-to-coefficient search | blocked | no accepted projection convention yet | do not run |

Next allowed lower packet:

| Field | Requirement |
|---|---|
| fixed target | `Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3` |
| required source anchor | Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding` |
| required reuse | `oneTermRobinGamma3ProjectionRegisterConventionDecision_n3`, `oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3`, and `oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3` |
| required statement | select sparse-register summation, list the endpoint field facts for `228` and `84`, and keep the indicator mismatch as an explicit handled-or-open field |
| forbidden work | no product multiplication, no full product unfolding, no new route record, and no semantic flag promotion |

## Lower Attempt: 2026-05-25 Indicator-Field Gap After Sparse Summation

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3`.

The theorem reuses the sparse-register summation convention and records that
the convention does not explain the indicator bit:

| Field | Clean endpoint `84` | Full endpoint `228` | Status |
|---|---:|---:|---|
| system row | `2` | `2` | agrees |
| indicator bit | `0` | `1` | remaining source-contract gap |
| sparse index | `5` | `6` | secondary mismatch |

This is not a product-to-coefficient proof. It keeps
`indicatorMismatchObligation.proved = false`,
`oneTermRobinGamma3ProductToCoefficientObligation.proved = false`, LCU
correctness, block projection, block correctness, normalized block equality,
and final extraction false.

## Middle Sync: 2026-05-25 Indicator Convention Packet

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | `Matrix.evalWith_mul_unique_path` compiled | reuse only after the projection/register convention is complete |
| sparse-register summation convention | useful contract | `oneTermRobinGamma3SparseRegisterSummationConvention_n3` compiled | consumed by the indicator-gap theorem |
| indicator-field gap | active blocker | `oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3` compiled | state the indicator projection/register convention |
| direct product-to-coefficient search | blocked | no accepted indicator convention | do not run |

Next fixed lower target:
`Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3`.

Expected lower output:

| Item | Requirement |
|---|---|
| source audit | inspect Eq. `eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding` for how the indicator field is projected, summed, reset, or ignored |
| convention record | state the indicator convention explicitly, or keep a named `SemanticObligation` with `proved = false` if the source gives no rule |
| regression facts | preserve endpoint `228`, endpoint `84`, indicator values `1` and `0`, and the false semantic flags |
| blocked work | no `Matrix.evalWith_mul_unique_path` application and no seven-gate product multiplication until this convention compiles |

## Lower Attempt: 2026-05-25 Indicator Projection Convention

Lean declaration compiled:
`Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3`.

The source audit did not find a reset, projection, summation, or basis
permutation rule for the indicator field after sparse-register summation.  The
new record therefore keeps the convention as a named false obligation:
`conventionObligation.proved = false`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | compiled | keep parked |
| sparse-register summation convention | useful contract | compiled | consumed by indicator convention |
| indicator projection convention | active blocker | compiled as false obligation | needs source-backed rule before product search |
| direct product-to-coefficient search | blocked | no accepted indicator convention | do not run |

## Middle Sync: 2026-05-25 Post-Indicator Projection

Accepted artifact:
`Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript`.

The lower result is a useful theorem-facing source-contract record, not a
product route.  It records that the source audit found no reset, summation, or
basis-permutation rule that relates indicator `1` at full endpoint `228` to
indicator `0` at clean endpoint `84`.

Current population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | compiled | keep parked |
| sparse-register summation convention | useful contract | compiled | consumed by indicator convention |
| indicator projection convention | active blocker | compiled with `conventionObligation.proved = false` | only refine if a source-backed rule is found |
| direct product-to-coefficient search | blocked | indicator convention remains false | do not run |

Next allowed work is source-contract refinement only.  Do not apply
`Matrix.evalWith_mul_unique_path` to the gamma3 product until the indicator
convention obligation has a source-backed Lean statement.

## Lower Attempt: 2026-05-25 Indicator Source-Anchor Recheck

The lower pass rechecked the local TeX anchors around Eq. `eq: ROBIN
clarified`, Fig. `fig:1 term ROBIN`, Definition `def:block-encoding`, and the
paragraph defining $U_{\text{indic}}$.  The source again gives the clean
gamma3 branch and the indicator-setting operation, but it does not add a reset,
summation, ignored-register, or basis-permutation rule relating indicator `1`
at full endpoint `228` to indicator `0` at clean endpoint `84`.

No Lean convention was promoted.  `Tests/Basic.lean` now has a regression
example that locks the active source anchors, required convention text,
`conventionObligation.proved = false`, `indicatorRelationSpecifiedBySource =
false`, and the blocked product/final-extraction flags for
`Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3`.

Current population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | compiled | keep parked |
| sparse-register summation convention | useful contract | compiled | consumed by indicator convention |
| indicator projection convention | active blocker | source recheck preserves `conventionObligation.proved = false` | only refine if a source-backed rule is found |
| direct product-to-coefficient search | blocked | no accepted indicator convention | do not run |

## Middle Sync: 2026-05-25 Bulk-Indicator Audit

Accepted artifact:
`Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3_transcript`.

The audit improves the blocker description.  For focused source column `5`,
the source-backed $U_{\mathrm{indic}}$ value is indicator `1`, and the full
endpoint `228` matches it.  Clean endpoint `84` has indicator `0`.  Therefore
the next route cannot treat endpoint `228`'s indicator as accidental register
noise or silently reset it.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | useful but inactive | compiled | keep parked |
| sparse-register summation convention | useful contract | compiled | consumed by indicator convention |
| indicator projection convention | active blocker | false obligation with source-backed endpoint `228` indicator | needs a source-backed rule relating endpoint `228` to endpoint `84` |
| direct product-to-coefficient search | blocked | indicator convention remains false | do not run |

## Lower Attempt: 2026-05-25 Indicator Convention Recheck

This lower pass did not add a new Lean theorem.  It reused the compiled
contracts:

- `Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3`
- `Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3`

The local source anchors around Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, Definition `def:block-encoding`, and the
`U_{\mathrm{indic}}` paragraph still support indicator `1` for the focused
bulk source column `5`.  They do not state a reset, ignored-register,
summation, or basis-permutation rule relating full endpoint `228` to clean
endpoint `84`.

No source-backed replacement was found for
`oneTermRobinGamma3IndicatorProjectionConvention_n3.conventionObligation`.
The attempted route therefore remains blocked with `proved = false`; product
multiplication, LCU closure, block projection, block correctness, normalized
equality, cleanup, unitarity, and final extraction remain out of scope.

## Middle Freeze: 2026-05-25 Human/Source Convention Required

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| generic unique-path product lemma | parked | `Matrix.evalWith_mul_unique_path` compiled | reuse only after the projection/register convention is source-backed |
| sparse-register summation convention | useful transcript contract | `oneTermRobinGamma3SparseRegisterSummationConvention_n3` compiled | keep as input to the blocker |
| bulk-indicator source audit | useful negative refinement | endpoint `228` indicator `1` is source-backed for $K_1=2$, $K_2=5$, $j=5$ | any future convention must handle this value explicitly |
| indicator projection convention | active blocker | `oneTermRobinGamma3IndicatorProjectionConvention_n3.conventionObligation.proved = false`; `humanInputRequired = true` | replace only with a source-backed endpoint relation or human decision |
| direct product-to-coefficient search | blocked | no accepted indicator convention | do not run |

No lower proof-search packet is queued.  Product multiplication and
`Matrix.evalWith_mul_unique_path` applications remain forbidden until the
relation between endpoint `228` and endpoint `84` in the indicator field is
stated as a source-backed Lean convention.

## Middle Handoff: 2026-05-25 Source-Backed Indicator Freeze

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| `Matrix.evalWith_mul_unique_path` route | parked | generic finite product lemma compiled | reuse only after a source-backed projection/register convention exists |
| sparse-register summation convention | useful transcript contract | `oneTermRobinGamma3SparseRegisterSummationConvention_n3` compiled | keep as input; it does not handle the indicator field |
| bulk-indicator source audit | useful negative refinement | `oneTermRobinGamma3BulkIndicatorSourceAudit_n3` compiled; endpoint `228` indicator `1` is source-backed for column `5` | any future convention must explain this value explicitly |
| indicator projection convention | active blocker | `oneTermRobinGamma3IndicatorProjectionConvention_n3.conventionObligation.proved = false` and `humanInputRequired = true` | replace only with a source-backed or human-approved endpoint relation |
| direct product-to-coefficient search | blocked | no accepted relation between endpoint `228` and clean endpoint `84` | do not run |

No lower proof-search packet is queued.  The next accepted route is not a
matrix product mutation; it is one exact projection/register convention for
the source-backed indicator field.
