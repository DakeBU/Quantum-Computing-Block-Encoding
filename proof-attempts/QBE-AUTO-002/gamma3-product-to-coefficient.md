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

## Lower Attempt: 2026-05-26 Boundary Corrected Product Expansion

Lean declarations compiled:

- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedCoefficientExpanded_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryAkEntry_matches_globalSlot2_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3_transcript`

For the branch-correct boundary target $n=3$, system entry $(0,0)$, and sparse
slot `2`, the corrected-entry hypothesis rewrites the seven-gate product as

$$
\text{product}_{32,32}
= (f_3(0) N_f^{-1})(D_0^{(2)} N_D^{-1}).
$$

The target-side local stencil comparison is also compiled:

$$
(A_k)_{0,0} = f_3(0)D_0^{(2)}.
$$

This is not yet the theorem-facing product-to-coefficient equality, because the
current Lean route still lacks an exact symbolic quotient/projection convention
for converting the branch-local product into the block-entry normalization by
$N_D N_f \kappa$.

Remaining exact blockers:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| quotient convention | `normalizedQuotientConvention.proved = false` in `oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3` | state how `N_D_inv` and `N_f_inv` implement division by the `N_D*N_f` part of `GHL2025.oneTermRobinNormalizer` without proving analytic nonzero bounds |
| sparse-register projection factor | `sparseRegisterProjectionConvention.proved = false` in the same obstruction packet | state how the sparse-slot summation/projection contributes the theorem's `kappa` denominator for the focused boundary entry |
| final product flag | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | prove only after the quotient and projection conventions are typed |

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale half-angle boundary route | low | superseded by source-backed corrected angle | do not retry |
| corrected boundary product expansion | useful | branch-local product and target entry both compiled | add quotient/projection convention for $N_DN_f\kappa$ |
| full theorem product-to-coefficient equality | blocked | exact product obligation remains false | wait for normalized-entry convention |

## Middle Follow-up: 2026-05-27 Normalizer/Projection Convention Packet

Middle re-read GHL2025 Theorem `1 term robin`, Eq.
`eq: ROBIN clarified`, Fig. `fig:1 term ROBIN`, and Definition
`def:block-encoding`.  The next lower target is not another product expansion
and not another $R_y$ convention audit.  The branch-local product and target
entry are already compiled:

$$
\text{product}_{32,32}
= (f_3(0) N_f^{-1})(D_0^{(2)} N_D^{-1}),
$$

and

$$
(A_k)_{0,0} = f_3(0)D_0^{(2)}.
$$

The missing interface is the theorem-level normalized-entry convention for
the denominator $N_DN_f\kappa$ in Eq. `eq: ROBIN clarified`.

Fixed lower packet:

| Field | Requirement |
|---|---|
| fixed Lean target | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` |
| immediate file | `QuantumBlockEncoding/RobinMatrix.lean` |
| starting declaration | `oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3` |
| suggested new declarations | `oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3`, `oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3_transcript` |
| quotient obligation | state how `N_D_inv` and `N_f_inv` implement the $N_DN_f$ part of the theorem normalizer without proving analytic nonzero bounds |
| projection obligation | state how the sparse-register sum/projection contributes the $\kappa$ denominator for the focused boundary slot |
| build expectation | run `lake build && lake build Tests` after any Lean edit |

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct seven-gate expansion | done | corrected boundary expansion compiled | do not repeat |
| corrected boundary product expansion | useful | product and Ak entry agree up to normalization | feed into normalizer/projection convention |
| symbolic quotient convention | pending | missing typed Lean interface for `N_D_inv`, `N_f_inv`, and theorem normalizer | add narrow convention packet |
| sparse-register projection factor | pending | missing typed Lean interface for the $\kappa$ denominator | add narrow convention packet |
| full theorem product-to-coefficient equality | blocked | product obligation remains false | resume only after the two convention fields are typed |

## Lower Attempt: 2026-05-27 Boundary Normalizer/Projection Convention

Lean declarations added:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3_transcript`

The packet wraps the existing obstruction
`oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3` and ties the
focused boundary route to the finite-composition normalizer
`GHL2025.oneTermRobinNormalizer`.

The compiled data now states:

$$
\text{product}_{32,32}=(f_3(0)N_f^{-1})(D_0^{(2)}N_D^{-1}),
\qquad
(A_k)_{0,0}=f_3(0)D_0^{(2)},
$$

with theorem normalizer $N_DN_f\kappa$.

This is still not the product-to-coefficient theorem.  The two remaining
convention fields are explicitly false:

| Blocker | Lean status | Needed next interface |
|---|---|---|
| quotient convention | `oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3.quotientConvention.proved = false` | define or prove the symbolic inverse convention for `N_D_inv` and `N_f_inv` against the $N_DN_f$ part of the theorem normalizer |
| sparse-register projection factor | `.sparseProjectionConvention.proved = false` | state or prove how the sparse-register projection/summation supplies the $1/\kappa$ factor for the focused slot-`2` boundary entry |
| normalized block equality | `.finiteCompositionNormalizedEquality.proved = false` | close only after the quotient/projection conventions and finite block-composition route are formalized |

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | useful | product and target entry agree up to normalization | reuse through the new convention packet |
| normalizer/projection convention packet | useful | compiled; quotient and sparse-projection fields remain false | prove or refine the two convention fields |
| full theorem product-to-coefficient equality | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after quotient/projection conventions are typed strongly enough |

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

## Middle Correction: 2026-05-26 Branch-Correct Population Reset

The slot-`5` endpoint audit is retained, but it is no longer the active
displayed-boundary target.  The source column `j = 5` is bulk for `n = 3`,
`K_1 = 2`, and `K_2 = 5`; it belongs to the omitted `+ ...` branch in Eq.
`eq: ROBIN clarified`.  The displayed gamma3 branch must be checked with a
boundary column such as `j = 0`.

New compiled branch map:
`Examples.RobinHeat.oneTermRobinGamma3BranchCorrectSourceMap_n3_transcript`.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| old slot-`5` boundary comparison `228` versus `84` | rejected as boundary target | branch mismatch identified | do not continue as displayed-boundary proof |
| boundary gamma3 branch with `j = 0` | active | branch endpoint and indicator facts compiled | isolate the seven-gate boundary path and zero-support facts |
| omitted bulk gamma3 branch with `j = 5` | queued separately | bulk indicator `1` compiled and source-backed | state a separate bulk product target after the boundary packet |
| generic unique-path product lemma | useful | compiled earlier | reuse only after branch-specific endpoints are fixed |

The next lower packet should start from the branch-correct transcript, not from
the superseded human-freeze state.  It must keep product, LCU, cleanup,
unitarity, projection, block-correctness, normalized equality, and final
extraction flags false unless an exact branch-specific Lean theorem proves the
corresponding statement.

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

## Lower Attempt: 2026-05-26 Boundary Branch Path Audit

Accepted artifact:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryBranchPathAudit_n3`.

The attempt followed the middle branch-correct packet instead of the superseded
bulk endpoint comparison.  For displayed boundary column `j = 0`, the
indicator remains `0`.  For the target entry `(0,0)`, the active global-slot
table selects sparse slot `2`:

| Slot | Address fact | Route status |
|---|---|---|
| `0` | `oneTermRobinGlobalSparseAddress 3 0 0 = 6` | not the `(0,0)` coefficient slot |
| `2` | `oneTermRobinGlobalSparseAddress 3 2 0 = 0` | compiled boundary path packet |

The compiled slot-`2` ket-zero state list is
`32 -> 32 -> 32 -> 32 -> 0 -> 0 -> 0 -> 32`, with the adjacent ket-one boundary
rotation path `33 -> 1 -> 1 -> 33`.  The path audit records the
`boundary_cos_half_0_2`, `boundary_sin_half_0_2`, and `f_3_0 * N_f_inv`
entries, but it does not multiply them into the normalized Ak coefficient.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| branch-correct boundary path | useful path isolation | compiled | attempt product-entry multiplication for `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` |
| branch-correct bulk path | useful omitted-branch memory | compiled for old `j = 5` audit | schedule separately after boundary target |
| direct old `228` versus `84` comparison | rejected planning route | superseded by branch split | do not resume as boundary evidence |
| LCU/block extraction route | parked | external/contract-only | keep out of lower boundary packet |

Remaining blocker for this route is a QBE-local finite product-entry theorem
under the existing false oracle contracts, especially the `Ry_boundary`
angle-normalizer semantics.  No semantic flag was promoted.

## Middle Packet: 2026-05-26 Boundary Product Interface

The next lower attempt should not specialize the older bulk-shaped product
interface blindly.  That interface is useful proof-route memory, but its
`O_DT^S` ket-zero hypotheses require the indicator field to be `1`.  The
branch-correct boundary target has indicator `0`, so `O_DT^S` contributes the
identity entry and `Ry_boundary` carries the boundary coefficient.

Fixed Lean target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3`.

Allowed stronger target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientEquality_n3`,
only if the exact equality builds.

Boundary packet data:

| Datum | Value |
|---|---|
| system size | `n = 3` |
| system entry | `(0,0)` |
| source branch | displayed boundary branch, `j = 0` |
| sparse slot | `2` |
| clean source | `32` |
| `U_indic` endpoint | `32`, indicator `0` |
| `O_DT^S` entry | identity at `32` |
| `Ry_boundary` entries | `boundary_cos_half_0_2`, `boundary_sin_half_0_2` |
| `O_D^{BS}` images | `32 -> 0`, `33 -> 1` |
| $O_f$ clean amplitude | `f_3_0 * N_f_inv` |
| dagger cleanup | `0 -> 32`, `1 -> 33` |

The attempt should either isolate the finite nonzero product path using the
compiled path audit and `Matrix.evalWith_mul_unique_path`, or record the first
missing zero-support fact.  It must keep every semantic flag false unless an
exact build-tested theorem proves that flag.

## Lower Attempt: 2026-05-26 Boundary Product Interface

Accepted artifact:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3`.

The attempt did not try to unfold the full symbolic seven-gate product after an
interactive check of the row `32`, column `32` product entry failed to return
quickly.  Instead it compiled a boundary-specific product interface and made
the first missing finite support theorem explicit:
`uniquePathSupportObligation.proved = false`.

Boundary factor packet:

| Gate | Ket-zero factor |
|---|---|
| `U_indic` | `1` |
| `O_DT^S` | `1` |
| `Ry_boundary` | `boundary_cos_half_0_2` |
| `O_D^BS` | `1` |
| `O_f` | `f_3_0 * N_f_inv` |
| `SWAP` | `1` |
| `O_D^BS` dagger | `1` |

The adjacent ket-one branch is also recorded, but because the $O_{D^T}^S$
ket-one entry from the boundary source is `0`, the branch is not counted as a
proved product contribution.  The next mutation should prove zero support for
all other intermediate states and then apply `Matrix.evalWith_mul_unique_path`
to the boundary product entry, or record the first support fact that blocks.

No product-to-coefficient, projection-slot, boundary-normalizer, LCU, cleanup,
unitarity, block-projection, block-correctness, normalized-equality, or
final-extraction flag was promoted.

## Middle Packet: 2026-05-26 Boundary Unique-Path Support

The active population is now fixed on the boundary branch for $n=3$, system
entry $(0,0)$, displayed column $j=0$, sparse slot `2`, full source column
`32`, and full target row `32`.  This is a local finite matrix-support problem
under existing typed oracle contracts; it is not a new cited result and it
must not mutate the paper construction.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| branch-correct boundary product interface | useful factor packet | `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3` compiled | consume it in a support theorem |
| unique-path fold reducer | reusable local lemma | `Matrix.evalWith_mul_unique_path` compiled | apply after all non-slot-`2` path contributions are zero |
| staged support proof | preferred | not started | prove gate-by-gate zero support for the row-`32`, column-`32` product |
| direct full product evaluation | risky | previously slow | avoid unless a small support theorem reduces the search space |
| old bulk endpoint route | rejected for boundary | branch mismatch fixed | keep only as omitted-bulk memory |

Suggested target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupport_n3`.

The support theorem should show that all evaluated seven-gate contributions
from column `32` to row `32` vanish except the ket-zero state list
`32 -> 32 -> 32 -> 32 -> 0 -> 0 -> 0 -> 32`.  If this blocks, record the first
unproved zero entry with its gate index and intermediate indices rather than
trying a new construction or promoting a semantic flag.

## Lower Attempt: 2026-05-26 Boundary Support Audit

Compiled declarations:

- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupportAudit_n3`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupport_n3`

The attempt proved concrete support facts for the adjacent ket-one branch in
the displayed boundary packet:

| Fact | Lean value |
|---|---|
| surviving ket-zero path | `[32, 32, 32, 32, 0, 0, 0, 32]` |
| adjacent ket-one path | `[32, 32, 32, 33, 1, 1, 1, 33]` |
| $O_{D^T}^S$ ket-one probe | `sparseAmplitudeOracleDTRotationMatrix p 33 32 = 0` |
| target $O_f$ adjacent entry | `functionOraclePaperMatrix p 0 1 = 0` |
| target dagger adjacent entry | `bandedSparseAccessPaperDaggerMatrix p 32 1 = 0` |

The full all-path unique-support theorem is still blocked.  First missing
interface:

| Field | Missing support fact |
|---|---|
| gate index | `3`, the prefix through `O_D^BS` before the `O_f` split |
| column | `32` |
| intermediate rows | all `k` not in `{0,1}` after `O_D^BS` |
| matrix entry | `(O_D^BS * Ry_boundary * O_DT^S * U_indic)[k,32] = 0` |

Next mutation: prove the four-gate prefix support theorem above, then use
`Matrix.evalWith_mul_unique_path` in staged form for the full seven-gate
row-`32`, column-`32` product.  Product-to-coefficient, projection, LCU,
cleanup, unitarity, block-correctness, normalized equality, and final
extraction flags remain false.

## Lower Attempt: 2026-05-26 Boundary Prefix Support

Compiled declarations:

- `Matrix.evalWith_mul_eq_zero_of_all_paths_zero`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixSupport_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixSupport_n3`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryPrefixSupport_n3`

The successful route was staged rather than a direct symbolic product
expansion.  The final theorem proves the evaluated support statement
`Coeff.evalWith env (prefix[row,32]) = 0` for every row outside `{0,1}`.  This
matches the existing matrix backend, where symbolic `Coeff` products are
reduced through `Coeff.evalWith` before applying path-isolation lemmas.

Next mutation: compose this prefix support with the already recorded $O_f$,
`SWAP`, and dagger zero entries to isolate the full seven-gate row-`32`,
column-`32` path.  Do not promote product-to-coefficient, projection-slot, LCU,
cleanup, unitarity, block-correctness, normalized equality, or final extraction
flags until the exact evaluated product theorem builds.

## Middle Packet: 2026-05-26 Seven-Gate Support

The proof-attempt population remains fixed on the displayed boundary branch for
$n=3$, $j=0$, system entry $(0,0)$, sparse slot `2`, source column `32`, and
target row `32`.  The successful route should be staged:

| Route block | Status | Next use |
|---|---|---|
| branch-correct source map | compiled | fixes boundary `j=0` and keeps the old `j=5` audit as omitted-bulk memory |
| boundary product interface | compiled | supplies the ket-zero factor packet |
| four-gate prefix support | compiled | shows prefix support only at rows `0` and `1` |
| suffix support through $O_f$, `SWAP`, and dagger | not started | prove row `1` and all non-row-`0` suffix-prefix contributions vanish |
| exact product equality | blocked | attempt only after suffix support is explicit |

Suggested Lean target:
`Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateSupport_n3`.

Suggested helper names:
`oneTermRobinGamma3BoundarySuffixMatrix_n3` for
$(O_D^{BS})^\dagger * SWAP * O_f`, and
`oneTermRobinGamma3BoundarySevenGateMatrix_n3` for suffix times prefix.

The support theorem should prove that every evaluated suffix-prefix
contribution into row `32` from column `32` is zero except the row-`0` prefix
branch.  Rows outside `{0,1}` should be killed by
`oneTermRobinBlockEncodingProofRoute_gamma3BoundaryPrefixSupport_n3`; row `1`
should be killed using the compiled $O_f$ and dagger zero entries from the
boundary support audit.

If this blocks, record the first unproved row `q`, whether the obstruction is
in the suffix factor or prefix factor, and the exact matrix entry.  Do not
resume the old bulk endpoint comparison, add hypotheses, or promote any
semantic flag.

## Lower Attempt: 2026-05-26 Seven-Gate Support

Compiled declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapRow0Col1_zero_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixRow32Col1_zero_n3`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateSupport_n3`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateUniquePath_n3`

The route succeeded by composing the compiled prefix support with suffix-side
zero facts.  Rows outside `{0,1}` are killed by the prefix theorem, and the
row-`1` branch is killed by the `O_f`, SWAP, and dagger support lemmas.  The
unique-path theorem reduces the evaluated row-`32`, column-`32` product to the
row-`0` intermediate branch.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| branch-correct boundary product interface | useful factor packet | compiled | use it to identify the prefix and suffix factor values |
| staged prefix support | successful | compiled | reused by seven-gate support |
| seven-gate support isolation | successful | compiled | feed product-entry evaluation |
| exact product-entry evaluation | preferred next | not started | prove row-`0` prefix factor, row-`32` suffix factor, then combine |
| direct normalized coefficient theorem | premature | blocked | wait for product-entry evaluation plus boundary normalizer/projection contracts |
| old bulk endpoint route | rejected for boundary | branch mismatch fixed | keep only as omitted-bulk memory |

No product-to-coefficient, projection-slot, boundary-normalizer, LCU, cleanup,
unitarity, block-projection, block-correctness, normalized-equality, circuit
unitarity, or final-extraction flag was promoted.

## Middle Packet: 2026-05-26 Boundary Product-Entry Eval

The next fixed statement should evaluate the isolated row-`0` branch, not
mutate the theorem route.  Suggested target:

```lean
theorem oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3
    (env : String -> Rat) :
    Coeff.evalWith env
      (oneTermRobinGamma3BoundarySevenGateMatrix_n3
        oneTermRobinGamma3BoundaryPrefixSource_n3
        oneTermRobinGamma3BoundaryPrefixSource_n3) =
      Coeff.evalWith env
        (Coeff.mul
          (Coeff.mul (Coeff.symbol "f_3_0") (Coeff.symbol "N_f_inv"))
          (Coeff.symbol "boundary_cos_half_0_2"))
```

Suggested helper route:

| Helper | Purpose |
|---|---|
| `oneTermRobinGamma3BoundaryPrefixRow0Col32_eval_n3` | evaluate the compiled prefix entry from column `32` to row `0` |
| `oneTermRobinGamma3BoundarySuffixRow32Col0_eval_n3` | evaluate the suffix entry from column `0` to row `32` |
| `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` | combine both helpers with the unique-path reduction |

If this target blocks, record the first failed helper statement and the exact
Lean goal.  Do not change the circuit product, do not re-enter the old `j = 5`
boundary comparison, and do not promote semantic flags.

## Lower Attempt: 2026-05-26 Boundary Product-Entry Eval

Compiled declaration:

- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3`

The route succeeded after the seven-gate support isolation.  The theorem
evaluates the row-`32`, column-`32` branch-local product as
`(f_3_0 * N_f_inv) * boundary_cos_half_0_2` for every coefficient environment.
This is still below the product-to-coefficient theorem: the boundary half-angle
symbol has not been identified with the correct global-slot derivative
coefficient divided by `N_D`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| branch-correct boundary product interface | useful factor packet | compiled | keep as product factor source |
| staged prefix support | successful | compiled | reused by product-entry eval |
| seven-gate support isolation | successful | compiled | reused by product-entry eval |
| boundary product-entry evaluation | successful | compiled | reuse after coefficient-source correction |
| direct product-to-coefficient theorem | blocked | contract drift | wait for global sparse-slot amplitude source |
| old bulk endpoint route | rejected for boundary | branch mismatch fixed | keep only as omitted-bulk memory |

Source drift found by middle: active `O_D^BS` uses the global sparse-slot table,
but the coefficient contracts still interpret the sparse index with
`robinSparseAmplitudeValue`.  For the focused boundary branch,
`oneTermRobinGlobalSparseAddress 3 2 0 = 0`, so global slot `2` is the
diagonal coefficient.  The current contract value
`robinSparseAmplitudeValue 3 2 0 = -1/6` is the row-dependent third boundary
entry.  The next mutation is to introduce and wire a global sparse-slot
coefficient source before any product-to-coefficient proof.

## Middle Audit: 2026-05-26 Boundary Ry Angle Convention

The global sparse-slot coefficient source is now wired, so the old
coefficient-source drift is no longer the active blocker.  The remaining
product-to-coefficient route is blocked by the boundary `R_y` angle convention.

Current route state:

| Route block | Status | Next use |
|---|---|---|
| branch-correct boundary product entry | compiled | gives `(f_3_0 * N_f_inv) * boundary_cos_half_0_2` |
| global sparse-slot coefficient source | compiled | gives `robinGlobalSparseAmplitudeValue 3 2 0` |
| normalized coefficient source | typed contract | `boundaryRotationNormalizedCoefficient p 0 2 = robinGlobalSparseAmplitudeValue 3 2 0 * N_D_inv` |
| bridge from `boundary_cos_half_0_2` to normalized coefficient | source-contract gap | add a focused false obligation before any equality proof |
| product-to-coefficient theorem | blocked | keep `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` false |

Source audit: Eq. `eq:angles for Ry` states
$\theta_j^s=\arccos(D_j^{(s)}/\mathcal{N}_D)$, and the current Lean gate uses
`boundary_cos_half_0_2` as the standard half-angle entry.  Eq.
`eq: ROBIN clarified` needs $D_0^{(2)}/\mathcal{N}_D$.  This bridge is not a
local finite-product lemma and should not be attacked by more product search.

Next mutation: add a focused record, for example
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3`, with
`cosHalfEntry`, `normalizedCoefficient`, source anchors, and an obligation field
with `proved = false`.  Add a test that the normalized coefficient unfolds to
the global source times `N_D_inv` and that the bridge/product flags remain
false.  Do not change the `R_y` matrix convention or promote semantic flags.

## Lower Attempt: 2026-05-26 Boundary Ry Coefficient Bridge

Compiled declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3_transcript`

The bridge records the current blocker as a source-contract gap.  It ties the
compiled product factor `boundary_cos_half_0_2` to the normalized coefficient
contract `GHL2025.boundaryRotationNormalizedCoefficient p 0 2`, and proves that
the normalized coefficient unfolds to
`GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 * N_D_inv`.  The bridge
obligation remains false, as do the product-to-coefficient, boundary division,
arccos, half-angle, normalizer-bound, two-by-two-unitary, LCU, projection,
block-correctness, and final-extraction fields.

## Middle Stabilization: 2026-05-26 Stop Product Search

The current attempt population is now frozen on the product-to-coefficient
target until the `Ry_boundary` convention is source-backed:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| boundary product-entry evaluation | successful local lemma | compiled as `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` | reuse only after convention gap is resolved |
| global sparse-slot coefficient source | successful contract wiring | compiled as `robinGlobalSparseAmplitudeValue` and shared normalizer bridges | keep; analytic flags false |
| boundary Ry coefficient bridge | blocker named | compiled as `oneTermRobinGamma3BoundaryRyCoefficientBridge_n3`; obligation false | await source/human convention decision |
| direct product-to-coefficient theorem | blocked | source-contract gap, not a tactic gap | do not resume local product search |
| old bulk endpoint route | rejected for displayed boundary branch | retained only as omitted-bulk memory | do not use for boundary proof |

## Middle Packet: 2026-05-26 Human/Source Decision Freeze

The active product-to-coefficient proof population is frozen.  The current
compiled decision packet is
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3`,
with transcript theorem
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3_transcript`.

The paper-side blocker is fixed:

| Source fact | Lean artifact | Status |
|---|---|---|
| Eq. `eq:angles for Ry` defines $\theta_0^2=\arccos(D_0^{(2)}/\mathcal{N}_D)$ | `boundaryRotationAngleNormalizerProofRoute p 0 2` | contract data; analytic flags false |
| seven-gate product exposes `boundary_cos_half_0_2` | `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` | compiled local lemma |
| Eq. `eq: ROBIN clarified` needs $D_0^{(2)}/(\mathcal{N}_D\mathcal{N}_f\kappa)$ | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |
| decision required before proof search resumes | `oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3` | compiled; `humanInputRequired = true` |

Do not mutate this population with additional local matrix-product attempts.
The next mutation must be one of:

| Mutation | Acceptance condition |
|---|---|
| source-backed convention | a cited equation, author clarification, or paper-backed contract explains how the half-angle entry supplies the displayed coefficient |
| theorem-gap closeout | a human/source decision keeps standard $R_y$ and records the bridge as a persistent theorem gap |
| non-semantic guard | add tests or transcript checks that the decision packet blocks product search and leaves all semantic flags false |

Rejected mutations: changing `boundaryRotationMatrix`, returning to the old
bulk `j = 5` boundary comparison, marking the bridge with `proved = true`, or
using the half-angle identity as if $\cos(\theta/2)=D/\mathcal{N}_D$.

## Middle Sync: 2026-05-26 Lower Guard Accepted

The accepted guard
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3` freezes
the direct product-to-coefficient route as a proof-attempt population member,
not as a failed Lean tactic script.  The population now has a single active
blocker: a source-backed or human decision for the boundary $R_y$ half-angle
convention.

| Route | Score | Status | Next mutation |
|---|---|---|---|
| boundary product-entry evaluation | successful local lemma | compiled | reuse only after convention gap is resolved |
| global sparse-slot coefficient source | successful contract wiring | compiled | keep; analytic fields false |
| boundary Ry coefficient bridge | blocker named | compiled; obligation false | wait for source-backed convention |
| lower packet guard | useful freeze guard | compiled; product lower packet disabled | keep as regression check |
| direct product-to-coefficient theorem | blocked | source-contract gap | do not resume tactic search |

Allowed next mutation: source-backed convention decision, or human/source
decision to keep the standard $R_y$ entry and preserve the bridge as an open
theorem gap.  Rejected mutations remain unchanged: no `boundaryRotationMatrix`
mutation, no old bulk endpoint route, no semantic flag promotion, and no
identification of $\cos(\theta/2)$ with $D/\mathcal{N}_D$ without a source
contract.

## Middle Sync: 2026-05-26 Source-Evidence Guard Accepted

The latest lower test in `Tests/Basic.lean` is accepted as a non-semantic
regression around
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3`.  It does
not add a new proof route for the product-to-coefficient theorem.  It checks
the source-evidence boundary: the source-backed options are either to keep the
standard $R_y$ matrix convention and leave the bridge open, or to supply a
paper-backed amplitude convention.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| boundary product-entry evaluation | successful local lemma | compiled | reuse only after the convention gap is resolved |
| global sparse-slot coefficient source | successful contract wiring | compiled | keep; analytic fields false |
| boundary Ry coefficient bridge | blocker named | compiled; obligation false | wait for source-backed convention or human decision |
| boundary Ry decision packet | useful freeze packet | compiled; `humanInputRequired = true` | keep as the active decision boundary |
| source-evidence guard test | useful regression | compiled in `Tests/Basic.lean`; product lower packet disabled | keep; reviewer may use it to reject product-search packets |
| direct product-to-coefficient theorem | blocked | source-contract gap | do not resume tactic search |

No mutation of `boundaryRotationMatrix`, no old bulk `j = 5` boundary route,
and no semantic flag promotion are allowed from this population.  A future
accepted mutation must provide a source-backed convention, or record a
human/source decision to keep the theorem gap open.

## Lower Source Audit: 2026-05-26 Boundary Ry Convention

I checked the source neighborhood for GHL2025 Eq. `eq:angles for Ry`,
Theorem `theorem: 1 term robin`, Eq. `eq: ROBIN clarified`, and Fig.
`fig:1 term ROBIN`.  The paper states
$\theta_j^s=\arccos(D_j^{(s)}/\mathcal{N}_D)$ for boundary indices and then
uses the displayed coefficient $D_0^{(2)}/\mathcal{N}_D$ in the focused
boundary branch.  The figure caption says the boundary part is handled
element-wise using $R_y$ with those angles, but it does not give a direct rule
identifying the standard half-angle entry `boundary_cos_half_0_2` with
$D_0^{(2)}/\mathcal{N}_D$.

This lower attempt therefore makes no Lean mutation.  The active proof-route
classification remains `source-contract-gap`, represented by
`oneTermRobinGamma3BoundaryRyCoefficientBridge_n3.angleConventionObligation`,
`oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3`, and
`oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3`.  The direct
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` route stays blocked
until a source-backed convention or human decision is recorded.

## Middle Closeout: 2026-05-26 No Product Packet

The proof-attempt population is frozen.  The successful local members are the
branch-correct boundary product path, the seven-gate product-entry evaluation,
and the global sparse-slot coefficient source.  The active blocker is not a
missing support lemma: it is the source-contract gap between the standard
half-angle factor `boundary_cos_half_0_2` and the displayed coefficient
$D_0^{(2)}/\mathcal{N}_D$.

| Route | Status | Next mutation |
|---|---|---|
| boundary product-entry evaluation | compiled | reuse only after the convention gap is resolved |
| global sparse-slot coefficient source | compiled | keep as the active coefficient source |
| boundary Ry coefficient bridge | compiled false obligation | wait for source-backed convention or human decision |
| boundary Ry lower-packet guard | compiled; product packet disabled | keep as regression guard |
| direct product-to-coefficient theorem | blocked | no tactic search until the convention is resolved |

No lower product packet should be assigned from this population.  Accepted next
mutations are a source-backed convention packet, a human/source decision that
leaves the bridge open, or reviewer closeout with all semantic flags false.

## Middle Persistent Gap Closeout: 2026-05-26

The population remains frozen after a second middle source audit.  The local
TeX source around Eq. `eq:angles for Ry`, Eq. `eq: ROBIN clarified`, Fig.
`fig:1 term ROBIN`, and Theorem `theorem: 1 term robin` still does not give a
rule identifying the standard half-angle entry `boundary_cos_half_0_2` with
$D_0^{(2)}/\mathcal{N}_D$.

| Route | Score | Status | Next mutation |
|---|---|---|---|
| boundary product-entry evaluation | successful local lemma | compiled as `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` | reuse only after a convention decision |
| global sparse-slot coefficient source | successful contract wiring | compiled as `GHL2025.robinGlobalSparseAmplitudeValue` and shared normalizer bridges | keep as the active coefficient source |
| boundary Ry coefficient bridge | blocker named | compiled; `angleConventionObligation.proved = false` | wait for source-backed convention or human/source theorem-gap decision |
| boundary Ry lower-packet guard | useful regression | compiled; `lowerProductProofPacketAllowed = false` | keep for reviewer rejection of product-search packets |
| direct product-to-coefficient theorem | blocked | source-contract gap, not a tactic gap | no local product search |

Accepted future mutations are limited to a source-backed convention packet, a
human/source theorem-gap packet, or reviewer closeout.  Rejected mutations are
unchanged: no edit to `boundaryRotationMatrix`, no old bulk `j = 5` boundary
route, no use of $\cos(\theta/2)=D/\mathcal{N}_D$, and no semantic flag
promotion.

## Middle Mutation: 2026-05-26 Corrected-Angle Interface

The source-backed correction route is now active, so the old frozen population
is superseded for the displayed boundary branch.  The compiled interface is
conditional rather than semantic: it rewrites the seven-gate product only after
the corrected boundary entry is supplied for the coefficient environment.

Compiled declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3_transcript`
- `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedAngle_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| boundary product-entry evaluation | successful local lemma | compiled as `oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3` | reuse through the corrected-angle theorem |
| corrected-angle decision | useful source route | compiled as `oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3` | keep as the active route |
| corrected coefficient interface | useful conditional bridge | compiled; `correctedEntryHypothesis.proved = false` | try the focused product-to-coefficient theorem from this interface |
| focused product-to-coefficient theorem | open | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | prove it or record the smallest remaining Lean-local obstruction |
| old half-angle guard | rejected as active blocker | retained only as stale-route memory | do not use it to block corrected-angle work |
| old bulk endpoint route | rejected for displayed boundary branch | retained only as omitted-bulk memory | keep separate from boundary proof |

Likely next obstruction: the product side now has
`(f_3_0 * N_f_inv) * boundaryRotationNormalizedCoefficient`, while the theorem
route still needs an exact normalized-entry convention for $N_D N_f \kappa$
and the sparse-slot summation/projection factor.  Do not promote product,
LCU, projection, cleanup, unitarity, block-correctness, normalized-equality,
circuit-unitarity, or final-extraction flags unless the exact Lean theorem
builds.

## Lower Result and Middle Split: 2026-05-27 Boundary Normalizer Target

The lower normalizer/projection convention compiled and is accepted as route
memory, not as the product theorem.  Middle added a split target so future
attempts do not merge the symbolic inverse issue with the sparse-register
projection issue.

Compiled declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3_transcript`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | keep as fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | keep as fixed target-side input |
| normalizer/projection convention packet | useful theorem route packet | compiled; all semantic flags false | reuse, do not duplicate |
| symbolic inverse split | open local convention | `symbolicInverseObligation.proved = false` | state/prove the exact `N_D_inv` and `N_f_inv` semantics before the $\kappa$ factor |
| sparse-register projection split | open projection convention | `kappaProjectionObligation.proved = false` | state/prove how the sparse-register branch contributes $1/\kappa$ |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after one split subgoal is materially reduced |

No accepted mutation may change the circuit, reuse the old bulk `j = 5` route
as boundary evidence, recurse into cited primitive formalization, or promote
LCU, projection, cleanup, unitarity, block correctness, normalized equality,
circuit unitarity, or final extraction.

## Lower Result: 2026-05-27 Symbolic Inverse Split

The symbolic-inverse branch of the split target is now reduced to a compiled
conditional algebra lemma.  The new theorem
`Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseEval_n3` proves
that, for any coefficient environment satisfying
`env "N_D_inv" * env "N_D" = 1` and
`env "N_f_inv" * env "N_f" = 1`, the corrected branch-local product multiplied
by the $N_DN_f$ normalizer part evaluates to the target entry.

Route population update:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | `oneTermRobinGamma3BoundarySymbolicInverseEval_n3` compiled under explicit inverse hypotheses | supply or contract-map actual inverse semantics, or move to $1/\kappa$ projection |
| sparse-register projection split | open projection convention | `kappaProjectionObligation.proved = false` | state/prove how the sparse-register branch contributes $1/\kappa$ |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this lower packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics and $1/\kappa$ projection are both available |

The companion record
`oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3` keeps the actual
inverse semantics, kappa projection, normalized block equality, and product
obligation false.

## Middle Packet: 2026-05-27 Kappa Projection Target

The next population member isolates the remaining sparse-register factor.
Middle added:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUniformSparseRegisterPreparationObligation_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3_transcript`

The target records the source-backed convention that
$H_W^{(\kappa)}$ prepares the sparse register with amplitude
$1/\sqrt{\kappa}$ on each slot, and that matching projection onto the focused
slot should supply another $1/\sqrt{\kappa}$.  For the focused boundary route,
the compiled packet fixes $\kappa=7$, sparse slot `2`, and clean basis index
`32`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection split | active | `oneTermRobinGamma3BoundaryKappaProjectionTarget_n3` compiled; cited uniform-preparation dependency recorded | prove/refine the $1/\kappa$ projection convention or record the exact obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics and $1/\kappa$ projection are both available |

The next lower packet must not formalize the full Shukla-Vedula state
preparation paper.  It should state the QBE-local projection interface needed
by the fixed boundary branch, using the cited-results row
`ShuklaVedula2024.HWkappaUniformSuperposition` only as a contract source.

## Lower Result: 2026-05-27 Kappa Projection Conditional Algebra

The sparse-register projection branch now has a compiled conditional algebra
lemma:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3_transcript`

The theorem inserts a symbolic `kappa_inv` factor into the branch-local product
and proves cancellation against the full theorem normalizer under explicit
environment hypotheses:

$$
\mathrm{env}(N_D^{-1})\mathrm{env}(N_D)=1,\quad
\mathrm{env}(N_f^{-1})\mathrm{env}(N_f)=1,\quad
\mathrm{env}(\kappa^{-1})\mathrm{env}(\kappa)=1.
$$

Route population update:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection split | improved | conditional `kappa_inv` algebra compiled | supply the actual `H_W^{(\kappa)}` preparation/projection semantics or record the exact projection-index obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after actual inverse semantics and sparse-register projection semantics are available |

The conditional lemma is not a proof of the uniform sparse-register state
preparation, the matching projection, or final block extraction.  All semantic
flags remain false.

## Lower Result: 2026-05-27 Projection Source Contract

The sparse-register projection branch now has a compiled source-contract
packet:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3_transcript`

The packet does not prove the projection theorem. It records that the intended
source of `Coeff.symbol "kappa_inv"` is the product of the
$H_W^{(\kappa)}$ preparation amplitude $1/\sqrt{\kappa}$ and the matching
projection amplitude $1/\sqrt{\kappa}$ for focused sparse slot `2`.

Route population update:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection split | improved | source contract for `kappa_inv` compiled | prove the actual finite projection convention or keep it as the smallest obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, sparse projection semantics, and finite composition equality are supplied |

## Middle Packet: 2026-05-27 Projection-Factor Semantics Target

Middle accepted the projection source contract as useful route memory.  The
next mutation is no longer to explain where `kappa_inv` comes from in prose;
that source is recorded.  The next mutation is to state the finite QBE
projection-factor interface that would let the focused boundary route use that
source contract.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | reuse as the fixed source contract |
| projection-factor semantics | active | `projectionFactorSemantics.proved = false` | state/prove a narrow finite projection convention for focused slot `2`, or record the exact finite-index obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

## Lower Result: 2026-05-27 Projection-Amplitude Factor Bridge

The next mutation compiled the conditional bridge from accepted amplitude
factors to the existing `kappa_inv` normalizer lemma:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3_transcript`

The bridge is conditional. It uses explicit coefficient-environment
hypotheses for `N_D_inv`, `N_f_inv`, `kappa_inv`, and
`sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv`. It does not prove the cited
ket amplitude, the local bra projection amplitude, the factor-semantics
obligation, finite normalized equality, or the product-to-coefficient theorem.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-amplitude semantics contract | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3` compiled | fixed ket and bra factor symbols |
| projection-amplitude factor bridge | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3` compiled | prove or contract-map actual amplitude and factor semantics before using hypotheses |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after amplitude semantics, factor semantics, and finite composition equality are supplied |

## Middle Sync: 2026-05-27 Matching Projection Next Mutation

The matching-projection convention packet is accepted as route memory:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript`

The population is still over the fixed statement
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. The next mutation is
not another finite slot-index proof and not recursive Shukla-Vedula
formalization. It should target the local matching projection amplitude for
sparse slot `2`, or split `factorSemanticsObligation` into a still smaller
Lean-facing obstruction.

| Route | Score | Status | Next mutation |
|---|---|---|---|
| matching sparse-slot projection convention | improved | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` compiled | prove or classify the bra-side $1/\sqrt{\kappa}$ projection amplitude |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| product represented by `kappa_inv` | blocked | `factorSemanticsObligation.proved = false` | identify preparation amplitude times projection amplitude with `Coeff.symbol "kappa_inv"` only after both amplitude contracts are available |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

Forbidden promotions remain unchanged: product-to-coefficient, LCU, cleanup,
unitarity, block projection, block correctness, normalized equality,
circuit-unitarity, and final extraction all stay false.

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`.  Do not mutate the theorem route, switch
back to the old bulk `j = 5` branch, recursively formalize Shukla-Vedula, or
promote product-to-coefficient, LCU, projection, cleanup, unitarity,
block-correctness, normalized-equality, circuit-unitarity, or final-extraction
flags.

## Lower Result: 2026-05-27 Projection-Factor Interface

The lower projection-factor packet compiled and is accepted as route memory:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorIndex_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3_transcript`

The packet proves only finite index agreement for the focused boundary route:
the prepared sparse slot and projected sparse slot are both slot `2`, and both
use clean basis index `32`.  It leaves the actual amplitude and
block-projection semantics of `Coeff.symbol "kappa_inv"` as false obligations.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-factor finite interface | improved | `oneTermRobinGamma3BoundaryProjectionFactorIndex_n3` and factor semantics packet compiled | prove or classify the actual factor semantics for focused slot `2` |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

The next mutation must stay on the fixed boundary statement.  It should either
prove a finite theorem identifying the prepared/projection amplitudes with
`kappa_inv`, or record a smaller obstruction separating the cited
$H_W^{(\kappa)}$ amplitude theorem from QBE's block-projection convention.  No
semantic flag is promoted by the current packet.

## Lower Result: 2026-05-27 Projection-Factor Obstruction Split

The next mutation was recorded as a compiled obstruction packet:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3_transcript`

The packet separates the missing `kappa_inv` factor theorem into two inputs:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| cited uniform sparse-register amplitude | narrowed | `ShuklaVedula2024.HWkappaUniformSuperposition` remains contract-only through `uniformPreparationObligation` | either keep as external contract or later formalize the state-preparation circuit in a separate task |
| matching sparse-slot projection | narrowed | QBE block-projection convention remains false through `matchingProjectionObligation` | prove the focused projection-bra amplitude for slot `2` |
| product represented by `kappa_inv` | narrowed | `factorSemanticsObligation` remains false | prove the product of the two amplitude contracts equals `Coeff.symbol "kappa_inv"` |
| finite index bookkeeping | stable | `oneTermRobinGamma3BoundaryProjectionFactorIndex_n3` compiled | no further mutation needed |
| conditional cancellation | stable | `oneTermRobinGamma3BoundaryKappaProjectionEval_n3` compiled under explicit inverse hypotheses | reuse after projection-factor semantics is supplied |

No product-to-coefficient, LCU, cleanup, unitarity, block projection,
block-correctness, normalized-equality, circuit-unitarity, or final-extraction
flag was promoted.

## Middle Packet: 2026-05-27 Matching Projection Convention

The obstruction split is accepted as the fixed proof-attempt state.  The next
mutation should not revisit the cited uniform-preparation row unless a reviewer
finds the contract imprecise.  The useful next local move is to state QBE's
matching projection convention for sparse slot `2`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-factor finite interface | improved | `oneTermRobinGamma3BoundaryProjectionFactorIndex_n3` compiled | no further finite index mutation needed |
| projection-factor obstruction split | improved | `oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3` compiled | target the local matching-projection convention |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, matching projection, factor semantics, and finite composition equality are supplied |

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`. Suggested declarations:
`OneTermRobinGamma3BoundaryMatchingProjectionConvention` and
`oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3`.  They should reuse
`oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3`,
`oneTermRobinGamma3BoundaryProjectionFactorIndex_n3`, and
`oneTermRobinGamma3BoundaryKappaProjectionEval_n3`, and they must keep all
semantic proof flags false unless a build-tested projection theorem is added.

## Lower Result: 2026-05-27 Matching Projection Convention

The matching-projection convention packet compiled:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript`

It reuses the projection-factor obstruction, source contract, finite index
lemma, and conditional `kappa_inv` cancellation lemma.  The convention pins the
projection bra to sparse slot `2` and clean basis index `32`, matching the
prepared branch.  It does not prove the projection amplitude or the
projection-factor semantic theorem.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-factor obstruction split | improved | `oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3` compiled | fixed separation of cited preparation and local projection |
| matching sparse-slot projection convention | improved | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` compiled | prove or classify the actual projection amplitude for slot `2` |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

## Lower Result: 2026-05-27 Matching Projection Amplitude Obstruction

The next mutation compiled the active obstruction packet:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3_transcript`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3`

This packet improves the route by separating the two sparse-register amplitude
sources.  The ket-side factor remains the contract-only cited
`H_W^(kappa)` preparation amplitude.  The bra-side factor is QBE's local
matching projection amplitude for sparse slot `2`.  The product lemma is only
symbolic coefficient algebra under an explicit environment hypothesis.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-factor obstruction split | improved | `oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3` compiled | fixed separation of cited preparation and local projection |
| matching sparse-slot projection convention | improved | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` compiled | fixed slot and basis-index convention |
| matching projection amplitude obstruction | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3` compiled | prove or contract-map the bra-side `sqrt_kappa_inv` amplitude |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| symbolic product of amplitude factors | conditional local lemma | `oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3` compiled | use only after both amplitude contracts are available |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`.  The next mutation should target the
bra-side matching projection amplitude for sparse slot `2` or introduce a
more precise projection contract for that amplitude.  It should not create a
new route, revisit the old bulk `j = 5` boundary comparison, recursively
formalize Shukla-Vedula, or promote product-to-coefficient, LCU, cleanup,
unitarity, block projection, block correctness, normalized equality, circuit
unitarity, or final extraction.

## Lower Result: 2026-05-27 Matching Projection Amplitude Contract

The next mutation compiled a focused QBE-local contract for the bra-side
projection amplitude:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3_transcript`

This packet narrows the local projection side to one finite branch: sparse
slot `2`, clean basis index `32`, expected factor
`Coeff.symbol "sqrt_kappa_inv"`.  It remains a contract; the finite
block-projection amplitude theorem and product-factor semantics are still
false.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| matching sparse-slot projection convention | improved | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` compiled | fixed slot and basis-index convention |
| matching projection amplitude obstruction | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3` compiled | separated ket, bra, and product factors |
| matching projection amplitude contract | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3` compiled | prove or contract-accept the finite bra-side `sqrt_kappa_inv` amplitude |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| symbolic product of amplitude factors | conditional local lemma | `oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3` compiled | use only after both amplitude sources are available |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

## Lower Result: 2026-05-27 Projection-Amplitude Semantics Contract

The next mutation compiled a Phase-1 semantics contract for the two sparse
register amplitude factors:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3_transcript`

This packet accepts the ket-side cited amplitude and the bra-side matching
projection amplitude only as explicit contracts, both represented by
`Coeff.symbol "sqrt_kappa_inv"`.  The conditional product lemma rewrites their
symbolic product to `Coeff.symbol "kappa_inv"` only when the coefficient
environment supplies `env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
env "kappa_inv"`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| matching projection amplitude contract | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3` compiled | fixed bra-side amplitude contract |
| projection-amplitude semantics contract | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3` compiled | prove or contract-map `factorSemanticsObligation` |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| symbolic product of amplitude factors | conditional local lemma | `oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3` compiled | use only under the explicit product hypothesis |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after inverse semantics, projection-factor semantics, and finite composition equality are supplied |

## Middle Sync: 2026-05-27 Projection-Amplitude Factor Bridge

The latest lower mutation compiled the conditional factor bridge:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3_transcript`

This improves the route by combining the accepted ket/bra
`sqrt_kappa_inv` contracts with the existing `kappa_inv` normalizer lemma under
explicit environment hypotheses. It does not prove the ket-side
`H_W^(kappa)` amplitude, the bra-side matching projection amplitude, the
factor-semantics obligation, finite normalized equality, or the focused product
theorem.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| matching projection amplitude contract | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3` compiled | fixed bra-side amplitude contract |
| projection-amplitude semantics contract | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3` compiled | supplied accepted ket and bra `sqrt_kappa_inv` factors |
| projection-amplitude factor bridge | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` compiled | prove or contract-map the semantic source of the factor hypotheses |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| symbolic product of amplitude factors | conditional local lemma | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3` compiled | use only under explicit inverse and product hypotheses |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after factor semantics and finite composition equality are supplied |

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`. The next mutation should target
`oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3.factorSemanticsObligation`
or record a smaller obstruction separating the ket amplitude, bra projection
amplitude, symbolic product hypothesis, and finite normalized block equality.
It should not add a new route, revisit the old bulk `j = 5` boundary
comparison, recursively formalize Shukla-Vedula, or promote
product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction.

## Middle Sync: 2026-05-27 Factor-Semantics Contract Map

The latest lower result compiled the source-backed contract map:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3_transcript`

This improves the population by connecting the current factor-semantics
blocker directly to the fixed target
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, but it does not
prove the target.  The conditional evaluation lemma still requires four
explicit source or convention inputs: ket amplitude, bra projection amplitude,
the square-root product convention, and finite normalized block equality.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| matching projection amplitude contract | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3` compiled | fixed bra-side amplitude contract shape |
| projection-amplitude factor bridge | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` compiled | replaced by the contract map as active packet |
| factor-semantics contract map | active | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3` compiled | prove or reduce the local bra-side projection amplitude |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize in this packet |
| square-root product convention | explicit hypothesis | `productHypothesisObligation.proved = false` | keep as coefficient-environment obligation unless a concrete environment theorem is added |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after the factor-semantics inputs and finite composition equality are supplied |

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`.  The next mutation should target the
bra-side matching projection amplitude for sparse slot `2`, clean basis index
`32`, using `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3` as the
starting object.  If it cannot be proved, record a smaller obstruction inside
the projection convention; do not add another status-only map.

## Middle Sync: 2026-05-27 HW-Dagger Embedded-Entry Interface

The latest accepted packet narrows the bra-side projection amplitude to the
finite adjoint-entry interface:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3_transcript`

This is better than the previous broad bra-amplitude contract because the
finite sparse-register data are now fixed: row `0`, column `2`,
$\kappa=7$, sparse width `3`, sparse dimension `8`, and clean gamma3 basis
index `32`.  It is not a proof of the entry.  The current missing object is a
matrix/adjoint interface for $H_W^{(\kappa)}$ or an equivalent typed contract
that derives
$\langle 0|(H_W^{(\kappa)})^\dagger|2\rangle=1/\sqrt{\kappa}$ from the
uniform clean-column statement in Eq. `arbitrary sparcity`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| matching sparse-slot projection convention | improved | `oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3` compiled | fixed slot and basis-index convention |
| matching projection amplitude contract | improved | `oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3` compiled | replaced by stricter HW-dagger entry interfaces |
| bra-projection amplitude source map | improved | `oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3` compiled | fixed need for an `H_W^(kappa)^dagger` entry |
| HW-dagger projection-entry contract | improved | `oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3` compiled | parent contract for row `0`, column `2` |
| HW-dagger embedded-entry interface | active | `oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3` compiled | derive or contract-map the row-`0`, column-`2` dagger entry from a uniform-column matrix interface |
| cited uniform sparse-register amplitude | contract-only | `ShuklaVedula2024.HWkappaUniformSuperposition` recorded | do not recursively formalize Shukla--Vedula in this packet |
| adjoint-entry conversion | planned | no local `H_W^(kappa)` matrix or adjoint-entry API exists yet | add `oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3` or a stricter compiled obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after the dagger entry, factor semantics, inverse semantics, and finite composition equality are supplied |

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`.  The next mutation should not add another
status-only wrapper around the embedded-entry interface.  It should either
provide a reusable adjoint-entry lemma from a typed uniform-column contract, or
record the smaller missing interface as a compiled obstruction.  Keep all
product-to-coefficient, LCU, cleanup, unitarity, block-projection,
block-correctness, normalized-equality, circuit-unitarity, and
final-extraction flags false.

## Lower Result: 2026-05-27 Uniform-Column Adjoint-Entry Split

The latest packet provided the requested reusable adjoint-entry bridge:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3_transcript`

The theorem is conditional.  It proves the focused dagger entry from two
source inputs:

| Input | Status | Lean field |
|---|---|---|
| uniform clean-column entry $H_W^{(\kappa)}[2,0] = 1/\sqrt{\kappa}$ | false | `uniformColumnObligation` |
| adjoint-entry convention $H_W^{(\kappa)\dagger}[0,2] = H_W^{(\kappa)}[2,0]$ | false | `adjointEntryConventionObligation` |
| conditional row-`0`, column-`2` dagger entry lemma | compiled | `oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3` |

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still a false obligation |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-amplitude factor bridge | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` compiled | factor source inputs still false |
| factor-semantics contract map | improved | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3` compiled | use after amplitude and finite-composition inputs are supplied |
| HW-dagger embedded-entry interface | improved | `oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3` compiled | refined by uniform-column split |
| uniform-column adjoint-entry split | active | conditional lemma and contract split compiled | instantiate the uniform-column and adjoint-entry obligations from an actual `H_W^(kappa)` matrix interface |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after the uniform-column/adjoint inputs, factor semantics, inverse semantics, and finite composition equality are supplied |

No product-to-coefficient, LCU, cleanup, unitarity, block-projection,
block-correctness, normalized-equality, circuit-unitarity, or
final-extraction flag was promoted.

## Middle Sync: 2026-05-27 Uniform-Column Split Audit

The latest lower packet improved the active route by compiling the conditional
bridge
`Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3`
and the contract split
`Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3`.

This mutation does not prove the focused dagger entry. It separates the route
into an external clean-column contract and a local QBE adjoint-entry
convention. The clean-column side should stay contract-only in this batch
because GHL2025 cites Shukla--Vedula for $H_W^{(\kappa)}$ preparation. The
next useful mutation is the local adjoint-entry convention or a stricter
compiled obstruction for the missing `H_W^(kappa)` matrix interface.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still false |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-amplitude factor bridge | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` compiled | factor source inputs still false |
| factor-semantics contract map | improved | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3` compiled | use only after amplitude and finite-composition inputs are supplied |
| HW-dagger embedded-entry interface | improved | `oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3` compiled | refined by uniform-column split |
| uniform-column adjoint-entry split | active | conditional lemma and contract split compiled | instantiate or block `adjointEntryConventionObligation` |
| clean-column uniform amplitude | contract-only | `uniformColumnObligation.proved = false` via Shukla--Vedula row | do not recursively formalize in this packet |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after adjoint convention, uniform-column contract, factor semantics, inverse semantics, and finite composition equality are supplied |

Allowed next write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
wiring tests in `Tests/Basic.lean`. The next mutation should target
`oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3.adjointEntryConventionObligation`
with a local theorem or a stricter obstruction. It should not add a new route,
revisit the old bulk `j = 5` boundary comparison, recursively formalize
Shukla--Vedula, or promote product-to-coefficient, LCU, cleanup, unitarity,
block projection, block correctness, normalized equality, circuit unitarity, or
final extraction.

## Lower Result: 2026-05-27 HW-Dagger Adjoint Convention

The local adjoint-entry route succeeded for the focused symbolic matrix
interface:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeEntryConvention_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromTransposeUniformColumn_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3`

The proof route uses the QBE transpose-style dagger convention for `Coeff`
matrices:
$H^\dagger_{\mathrm{local}}[0,2] = H[2,0]$.  It then compiles the conditional
focused entry theorem from the remaining clean-column hypothesis
$H_W^{(\kappa)}[2,0] = \sqrt{\kappa}^{-1}$.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| corrected boundary product expansion | successful local lemma | compiled | fixed product-side input |
| boundary target-entry match | successful local stencil lemma | compiled | fixed target-side input |
| symbolic inverse split | improved | conditional algebra compiled under explicit inverse hypotheses | actual inverse semantics still false |
| sparse-register projection source | improved | `oneTermRobinGamma3BoundaryProjectionSourceContract_n3` compiled | fixed source contract for `kappa_inv` |
| projection-amplitude factor bridge | improved | `oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3` compiled | factor source inputs still false |
| factor-semantics contract map | improved | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3` compiled | use only after amplitude and finite-composition inputs are supplied |
| HW-dagger embedded-entry interface | improved | `oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3` compiled | refined by uniform-column split and adjoint convention |
| uniform-column adjoint-entry split | improved | conditional lemma and contract split compiled | local adjoint convention supplied; uniform source still false |
| adjoint-entry conversion | successful local lemma | `oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3` compiled with `.adjointEntryConventionObligation.proved = true` | instantiate or contract-accept the clean-column uniform amplitude |
| clean-column uniform amplitude | contract-only | `uniformColumnObligation.proved = false` via Shukla--Vedula row | do not recursively formalize in this packet |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | no recursive LCU proof in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after uniform-column contract, factor semantics, inverse semantics, and finite composition equality are supplied |

No product-to-coefficient, LCU, cleanup, unitarity, block-projection,
block-correctness, normalized-equality, circuit-unitarity, or final-extraction
flag was promoted.

## Middle Sync: 2026-05-27 Product Bridge Next Target

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest
successful mutation is
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`;
do not replace it with a new theorem route.

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | active | route object, conditional eval theorem, transcript, and focused tests compiled | target `productBridgeObligation` |
| external amplitudes | contract-only | clean-column and ket amplitude obligations remain false through Shukla--Vedula row | do not recursively formalize |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | use `LCU.StandardBlockEncoding` only as a typed contract |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | supply finite projection/product bridge first |

Next mutation: compile a finite projection/product bridge consuming
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`, or return a smaller
compiled obstruction naming the absent projection field.

## Lower Result: 2026-05-28 Typed Projection-Summation Target

The latest accepted packet compiled a typed target rather than a final branch
sum theorem:

- `Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSummationTarget`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3_transcript`

The target exposes two separate `Coeff` entries.  The signal-zero block entry
is the full unitary entry at `[0,0]`, and the focused branch-local entry is the
seven-gate matrix entry at `[32,32]`.  Lean proves only the `[0,0]`
block-entry indexing equality.  It does not prove that the branch entry is the
route's `projectedBranchProduct`, and it does not prove that the sparse-branch
summation selects the slot-`2` contribution.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | useful | conditional coefficient route compiled under external amplitude and coefficient hypotheses | keep as upstream evidence |
| finite projection/product bridge | useful | signal-zero block entry `[0,0]` and branch basis `[32,32]` exposed | reused by typed target |
| branch-decomposition slot-`2` interface | useful | projection-summation obligation named; proof false | reused by typed target |
| typed projection-summation target | active | typed `Coeff` entries exposed; block-entry equality proved | first target `branchEntrySelectionObligation`, then projection/summation |
| branch-entry selection | pending | `branchEntrySelectionObligation.proved = false` | relate `oneTermRobinGamma3BoundarySevenGateMatrix_n3[32,32]` to `projectedBranchProduct` under existing contracts |
| sparse-register projection/summation | blocked | `projectionSummationObligation.proved = false` | state/prove finite branch-sum theorem for slot `2`, or record smaller missing field |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch selection and projection/summation |

Next mutation: use
`oneTermRobinGamma3BoundaryProjectionSummationTarget_n3_transcript` as the
starting point.  The first acceptable step is a theorem or smaller obstruction
for `branchEntrySelectionObligation`; the second is the finite
projection-summation theorem for slot `2`.  Do not formalize Shukla-Vedula or
LCU recursively, and do not promote any theorem-facing semantic flag.

## Middle Sync: 2026-05-27 After Finite Projection/Product Bridge

The finite projection/product bridge mutation succeeded as an obstruction
sharpening step, not as a product proof.  The accepted declarations are:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | useful | conditional coefficient calculation compiled under explicit external and coefficient contracts | keep as upstream coefficient route |
| finite projection/product bridge | active | finite signal-zero block index `[0,0]` and branch basis `[32,32]` are separated by a compiled bridge | target branch-decomposition/projection theorem |
| branch-decomposition/projection theorem | pending | exact relation between `projectedBranchProduct` and the signal-zero block entry is absent | define/prove a typed finite branch-summation/projection interface |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` through `LCU.StandardBlockEncoding` | keep as external contract unless an exact finite theorem is added |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch decomposition and normalized equality |

Smallest remaining obstruction:

| Missing field | Lean location | Status |
|---|---|---|
| branch-decomposition/projection theorem from the slot-`2` projected branch product to the signal-zero block entry | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3.branchDecompositionObligation` and `.productBridgeObligation` | false |
| composed-circuit normalized block equality | `.finiteCompositionNormalizedEquality` | false |

The next mutation must stay on the fixed statement
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  It should not
formalize Shukla--Vedula or LCU recursively, revisit the old bulk endpoint, or
promote product-to-coefficient, projection, normalized equality, block
correctness, circuit unitarity, or final extraction flags.

## Lower Result: 2026-05-27 Finite Projection/Product Bridge

The finite projection/product bridge packet compiled:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript`

Result: the finite signal-zero block entry for system `(0,0)` is indexed at
compound row and column `0`, while the focused boundary branch product remains
the embedded slot-`2` basis entry `[32,32]`.  The bridge consumes
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3` and records the
missing branch-decomposition/projection theorem as the next obstruction.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | active | conditional coefficient route compiled under explicit external and coefficient contracts | feed through finite branch-decomposition/projection theorem |
| finite projection/product bridge | improved | finite signal block index compiled; branch basis `32` separated from signal block index `0` | define/prove branch-decomposition contract |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` until exact theorem is available |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch-decomposition and normalized equality |

Smallest remaining obstruction:

| Missing field | Lean location | Status |
|---|---|---|
| finite branch-decomposition/projection theorem identifying `projectedBranchProduct` with the signal-zero block entry | `oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3.branchDecompositionObligation` and `.productBridgeObligation` | false |
| composed-circuit normalized block equality | `.finiteCompositionNormalizedEquality` | false |

No product-to-coefficient, LCU, cleanup, unitarity, block-projection,
block-correctness, normalized-equality, circuit-unitarity, or final-extraction
flag was promoted.

## Middle Sync: 2026-05-27 Product Bridge Next Target

The active proof-attempt population is still over the fixed statement
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The successful
mutation is the compiled product-under-contracts route
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`.
It should not be replaced by a new theorem route.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| corrected boundary product expansion | useful | product and target entry compiled up to normalization/projection | keep as upstream evidence |
| clean-column-to-factor route | useful | factor-semantics route and eval theorem compiled | reused by product-under-contracts route |
| product-under-contracts route | active | route object, conditional eval theorem, transcript, and focused tests compiled | target `productBridgeObligation` |
| external amplitudes | contract-only | clean-column and ket amplitude obligations remain false through Shukla--Vedula row | do not recursively formalize |
| square-root product convention | conditional | coefficient algebra compiles under explicit environment hypothesis | keep as coefficient-environment obligation |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | use `LCU.StandardBlockEncoding` only as a typed contract |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | supply finite projection/product bridge first |

The next mutation should either compile a finite projection/product bridge
consuming `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`, or return
a smaller compiled obstruction naming the absent projection field.  It should
not formalize Shukla--Vedula or LCU recursively, revisit the old bulk endpoint,
or promote any semantic flag without a build-tested theorem.

## Middle Follow-up: 2026-05-27 Clean-Column To Bra-Route Contract

The latest compiled bridge is
`Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3`.
It accepts the clean-column source
$H_W^{(\kappa)}[2,0] = 1/\sqrt{\kappa}$ as the contract-only input from
GHL2025 Eq. `arbitrary sparcity` and the cited Shukla--Vedula row. The theorem
`oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_feedsTransposeBridge_n3`
shows that this exact input feeds the local transpose-style dagger bridge.

This is useful, but it still does not prove the focused product route. The
remaining Lean-local connection is:

| Step | Lean object | Status |
|---|---|---|
| accepted clean-column contract | `oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3` | compiled; source obligation false |
| dagger entry from clean-column hypothesis | `oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_feedsTransposeBridge_n3` | compiled conditionally |
| bra projection amplitude route | `oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3.amplitudeContractObligation` | false |
| factor-semantics route | `oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3.braAmplitudeObligation` | false |
| focused product-to-coefficient target | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` | false |

Fixed next target:
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, routed through a
new or refined contract map that connects the clean-column bridge to
`oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3` and
`oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3`.

Suggested declaration:
`Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3`.

Acceptance for the next attempt:

| Result type | Requirement |
|---|---|
| route contract | compiled Lean record/theorem showing how the clean-column bridge supplies or precisely refines the bra-amplitude and factor-map obligations |
| smaller obstruction | compiled record naming the exact absent projection-entry field if the bridge cannot yet be connected |
| forbidden result | another guard-only theorem that does not touch the bra-amplitude or factor-map obligations |

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| corrected boundary product expansion | useful | product and target entry compiled up to normalization/projection | keep as upstream evidence |
| HW dagger adjoint convention | done | local transpose convention compiled | no further work here |
| HW clean-column bridge | useful | external clean-column contract feeds transpose bridge conditionally | connect to bra-amplitude source map |
| clean-column-to-bra route contract | pending | no Lean route map yet | next lower packet |

## Lower Result: 2026-05-27 Clean-Column To Factor-Semantics Route

The latest packet compiled the under-contract factor-semantics route:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3_transcript`

The route uses
`oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3` as the bra-factor
input for `oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3`.
The evaluation theorem is conditional on the external clean-column entry
$H_W^{(\kappa)}[2,0]=1/\sqrt{\kappa}$ and on the coefficient-environment
identities for `N_D_inv`, `N_f_inv`, `kappa_inv`, and `sqrt_kappa_inv`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| corrected boundary product expansion | useful | product and target entry compiled up to normalization/projection | keep as upstream evidence |
| HW dagger adjoint convention | done | local transpose convention compiled | no further work here |
| HW clean-column bridge | useful | external clean-column contract feeds transpose bridge conditionally | source remains contract-only |
| clean-column-to-bra route contract | useful | route map compiled | reused by factor-semantics route |
| clean-column-to-factor route | active | `oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3` and eval theorem compiled | connect to fixed product obligation under exact contracts, or record the smallest missing field |
| ket-side uniform amplitude | contract-only | `ketAmplitudeObligation.proved = false` through Shukla--Vedula family | do not recursively formalize in this packet |
| square-root product convention | partial | coefficient calculation compiles under explicit `sqrt_kappa_inv * sqrt_kappa_inv = kappa_inv` hypothesis | either add a coefficient-environment contract or keep as named obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | use `LCU.StandardBlockEncoding` only as a typed contract |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | next lower packet targets product-under-contracts route or smaller obstruction |

No product-to-coefficient, LCU, cleanup, unitarity, block-projection,
block-correctness, normalized-equality, circuit-unitarity, or
final-extraction flag was promoted.

## Middle Follow-up: 2026-05-27 Product Under Contracts Packet

The next lower packet should keep the fixed target
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` and start from
`oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3`.  It should
either compile a conditional product-under-contracts route or return a smaller
compiled obstruction naming the first absent field among the ket amplitude,
the square-root product convention, the finite normalized equality, and the
projection/product bridge.

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` and focused
false-flag checks in `Tests/Basic.lean`.  Do not add another route wrapper
around the already compiled clean-column-to-bra bridge, do not revisit the old
bulk `j = 5` boundary comparison, do not recursively formalize Shukla--Vedula
or LCU, and do not promote product-to-coefficient, LCU, cleanup, unitarity,
block projection, block correctness, normalized equality, circuit unitarity,
or final extraction.

## Lower Result: 2026-05-27 Product Under Contracts Route

The product-under-contracts packet compiled:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3_transcript`

The new route starts from
`oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3` and points to
the fixed obligation `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.
The conditional theorem proves only the local coefficient calculation under
the external clean-column hypothesis and the environment identities
`N_D_inv*N_D=1`, `N_f_inv*N_f=1`, `kappa_inv*kappa=1`, and
`sqrt_kappa_inv*sqrt_kappa_inv=kappa_inv`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| corrected boundary product expansion | useful | product and target entry compiled up to normalization/projection | keep as upstream evidence |
| clean-column-to-factor route | useful | factor semantics route and eval theorem compiled | reused by product-under-contracts route |
| product-under-contracts route | improved | route object, conditional eval theorem, transcript, and focused tests compiled | supply finite block-composition projection/product bridge |
| external amplitudes | contract-only | clean-column and ket amplitude obligations remain false through Shukla--Vedula row | do not recursively formalize in this packet |
| square-root product convention | partial | conditional algebra compiles under explicit environment hypothesis | keep as obligation until coefficient semantics are fixed |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | use `LCU.StandardBlockEncoding` only as a typed contract |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | next target is `productBridgeObligation`/finite projection interface |

Smallest remaining obstruction:

| Missing field | Lean location | Status |
|---|---|---|
| bridge from the conditional projected branch product to the exact block entry used by the finite composition contract | `oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3.productBridgeObligation` | false |
| normalized block equality for the composed circuit | `.finiteCompositionNormalizedEquality` | false |

No product-to-coefficient, LCU, cleanup, unitarity, block-projection,
block-correctness, normalized-equality, circuit-unitarity, or final-extraction
flag was promoted.

## Middle Sync: 2026-05-27 Product Bridge Next Target

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest
successful mutation is
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`;
do not replace it with a new theorem route.

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | active | route object, conditional eval theorem, transcript, and focused tests compiled | target `productBridgeObligation` |
| external amplitudes | contract-only | clean-column and ket amplitude obligations remain false through Shukla--Vedula row | do not recursively formalize |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | use `LCU.StandardBlockEncoding` only as a typed contract |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | supply finite projection/product bridge first |

Next mutation: compile a finite projection/product bridge consuming
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`, or return a smaller
compiled obstruction naming the absent projection field.

## Middle Sync: 2026-05-28 Projection-Summation Obstruction

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation is the typed obstruction
`Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`.

Accepted Lean inputs:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | useful | conditional coefficient route compiled under explicit external and coefficient hypotheses | keep as upstream coefficient calculation |
| branch-entry selection | useful | selected slot contribution evaluates to `projectedBranchProduct` under corrected `Ry` hypothesis | feed into branch-contribution family |
| sparse-branch contribution family | active | absent from finite matrix semantics | define `branchContribution : Fin 7 -> Coeff`, prove slot `2` selection, and state/prove branch-sum theorem |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch-sum theorem and normalized equality |

Next lower packet: work only in `QuantumBlockEncoding/RobinMatrix.lean` and
focused transcript tests in `Tests/Basic.lean`.  Start from
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3`,
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`,
`oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`,
and `oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3`.  Suggested names
are `OneTermRobinGamma3BoundaryBranchContributionFamily`,
`oneTermRobinGamma3BoundaryBranchContributionFamily_n3`,
`oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3`, and either
`oneTermRobinGamma3BoundaryBranchContribution_sum_n3` or
`oneTermRobinGamma3BoundaryBranchContributionObstruction_n3`.

Do not formalize Shukla--Vedula or LCU recursively, do not revisit the old
bulk endpoint, and do not promote product-to-coefficient, LCU, cleanup,
unitarity, block projection, block correctness, normalized equality, circuit
unitarity, or final extraction flags.

## Middle Sync: 2026-05-28 Branch-Contribution Family

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation is the branch-contribution family interface:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| stale bulk `j = 5` boundary comparison | rejected | branch mismatch; bulk endpoint belongs to omitted `+ ...` branch | do not retry |
| product-under-contracts route | useful | conditional coefficient route compiled under explicit external and coefficient hypotheses | keep as upstream coefficient calculation |
| branch-entry selection | useful | selected slot contribution evaluates to `projectedBranchProduct` under corrected `Ry` hypothesis | reused by branch-contribution family |
| sparse-branch contribution family | improved | `branchContribution : Fin 7 -> Coeff` is typed and slot `2` is proved selected | prove or obstruct branch-sum theorem |
| branch-sum theorem | active | `oneTermRobinGamma3BoundaryBranchContribution_sum_n3` is absent | next lower target |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch-sum theorem and normalized equality |

Next lower packet: work only in `QuantumBlockEncoding/RobinMatrix.lean` and
focused transcript tests in `Tests/Basic.lean`.  Start from
`oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript`,
`oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3`,
`oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`,
and `oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3`.
The desired target is
`oneTermRobinGamma3BoundaryBranchContribution_sum_n3 :
oneTermRobinGamma3BoundaryBranchContributionFamily_n3.projectionSummationStatement`.
If the current finite matrix semantics cannot expose the branch sum, return a
smaller typed obstruction naming the absent projection-expanded entry family.

Do not formalize Shukla--Vedula or LCU recursively, do not revisit the old
bulk endpoint, and do not promote product-to-coefficient, LCU, cleanup,
unitarity, block projection, block correctness, normalized equality, circuit
unitarity, or final extraction flags.

## Lower Result: 2026-05-28 Backend Projection-Summation Field Target

The branch-sum theorem was not proved from the placeholder family.  The useful
mutation is a smaller backend target:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| placeholder branch family | typed only | selected slot compiles, but it is not backend-sourced | do not use it to prove the branch sum |
| backend branch-contribution predicate | improved | exact target predicate is typed for any `Fin 7 -> Coeff` candidate | define the family from finite projection semantics |
| backend field availability | blocked | `backendFieldAvailable = false` | extend or specialize `BlockExtractionTarget` with a sparse-branch expansion field |
| direct branch-sum theorem | blocked | `oneTermRobinGamma3BoundaryBranchContribution_sum_n3` remains absent | retry only after backend field exists |
| product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend branch sum and normalized equality |

Smallest remaining obstruction:

```text
BlockExtractionTarget exposes the signal-zero block entry but not a
backend-sourced sparse-branch contribution family for that entry
```

No theorem-facing semantic flag was promoted.

## Lower Result: 2026-06-03 Raw-Field Prepared-Sandwich Alignment

The fixed target
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`
was not proved.  The useful compiled fragment is a one-way bridge from the
stronger raw `Coeff` statement:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_rawEntryPreparedSandwichField_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_unitaryEntryFold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| source-prepared singleton field | active | equivalent to the uncast prepared-sandwich target | prove or reduce the prepared-sandwich equality |
| raw prepared-sandwich field | useful, stronger | implies the evaluated prepared-sandwich target after `Coeff.evalWith`; still unproved | try only if the backend can prove the raw `Coeff` equality directly |
| backend expansion | active equivalent | under the all-slot clean-column contract, equivalent to the raw prepared-sandwich field | prove `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` or return a smaller backend field |
| evaluated backend fold | aligned | equivalent to the active/prepared circuit-field statement under the clean-column contract | use as recovery route, not as a standalone H-free source route |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend expansion or raw prepared-sandwich field plus normalized block equality |

Remaining obstruction:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Equivalently, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, prove:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

No product-to-coefficient, LCU, block-projection, block-correctness,
normalized-equality, circuit-unitarity, or final-extraction flag was promoted.

## Lower Result: 2026-06-03 Raw Uncast Backend-Expansion Reduction

The fixed backend-expansion theorem was not proved.  The useful route mutation
is a smaller compiled equivalence:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3`

It states that
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
is equivalent to the raw uncast active `[0,0]` product entry equaling the
seven-slot backend fold:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
blockExtractionBranchContributionSum
  oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| raw backend expansion | improved | equivalent to the uncast active `[0,0]` product-entry fold; wrapper and cast removed | prove the displayed raw fold or isolate a smaller finite support term in that exact equality |
| evaluated backend fold | pending | follows from the raw fold and already has evaluated active-entry reductions | use only after the raw fold or an evaluated counterpart is proved |
| active/prepared route | aligned | equivalent to backend expansion under the all-slot clean-column contract | do not treat as a separate proof target |
| product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend expansion plus normalized block equality |

No theorem-facing semantic flag was promoted.

## Middle Update: 2026-06-03 Backend Expansion Dispatch

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, but lower work must
not attack that theorem directly.  The active subtarget is now the backend
expansion:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Equivalent raw fold:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| backend expansion / raw fold | active | fixed target; theorem absent | prove the seven-slot projection fold or return one smaller compiled support theorem |
| active/prepared backend alignment | useful | `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3` and `oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_iff_backendExpansion_n3` compile under `hUniform` | use only to prevent a duplicate active/prepared target |
| prepared-sandwich route | conditional | `oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_backendExpansion_n3` closes the evaluated prepared target after backend expansion | reuse after the fixed target is proved |
| Shukla-Vedula sparse preparation | contract-only | supplies `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; not formalized | do not recurse into this cited result in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | resume only after backend expansion plus normalizer/product algebra are available |

Next lower packet: work in `QuantumBlockEncoding/RobinMatrix.lean`, with
focused checks in `Tests/Basic.lean`.  Do not add a new GHL assumption, do not
prove a standard LCU or Shukla-Vedula theorem, and do not revisit the corrected
`R_y` audit, O_D^BS/O_f work, or the bulk `j = 5` route.  No theorem-facing
semantic flag has been promoted.

## Middle Sync: 2026-05-28 Backend-Sourced Branch Family

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation is the generic one-entry branch target:

- `QuantumBlockEncoding.blockExtractionBranchContributionSum`
- `QuantumBlockEncoding.BlockExtractionBranchContributionTarget`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_selected_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_selectedContribution_eq_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| placeholder branch family | rejected for closure | selected slot compiles, but `placeholderFamilyIsBackendSourced = false` | do not use it to prove the branch sum |
| generic branch target | improved | branch family, selected slot, branch fold, and block entry are typed in `BlockExtractionBranchContributionTarget` | source the family from the projection backend |
| backend branch predicate | active | `oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3` states the exact two conjuncts | prove it for a backend-sourced family |
| backend field availability | blocked | `oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3.exposesBranchContributionField = false` | add a minimal backend field or return a smaller obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend branch family and normalized equality |

Next lower packet: start from
`oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript`,
`oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_selectedContribution_eq_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3`, and
`oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`.
The preferred result is a backend-sourced
`branchContribution : Fin 7 -> Coeff` satisfying the predicate.  If the
current backend cannot expose that family, return a smaller typed obstruction
naming the missing projection field, branch-index map, or branch-summand
formula.

Do not formalize Shukla--Vedula or LCU recursively, do not revisit the old
bulk endpoint, do not add a new theorem route, and do not promote
product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction flags.

## Lower Attempt: 2026-05-29 Direct Active-to-Prepared Unfolding

The preferred target for this packet was the prepared clean-entry equality:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

I first checked whether Lean could close the active fold or the prepared
clean-entry equality by direct decidable unfolding of the symbolic `Coeff`
expressions.  The `#eval decide` route did not return in a useful time and was
killed before producing a theorem.  This was search data only; no Lean
declaration or semantic flag was changed.

Updated proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct decidable unfolding | rejected for now | full symbolic equality did not return quickly enough to be a viable lower proof route | use named matrix/projection lemmas instead of unfolding the full product |
| prepared clean-entry equality | active | still typed by `oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3 H.activeEntryToPreparedEntryStatement` and `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H` | prove the finite `CircuitMatrixSemantics` composition field or keep the compiled active/prepared obstruction |
| active/prepared obstruction packet | useful | `OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget` names the current missing field without promoting flags | reuse as the handoff target |

No product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction flag
was promoted.

## Middle Update: 2026-05-29 Prepared Composite Semantics

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation is not a product proof; it gives the prepared sparse-register
composite a singleton `CircuitMatrixSemantics` object and proves its clean
entry evaluation:

- `Matrix.evalWith_mul_identity_right_apply`
- `evalWith_evalGateMatrices_single`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| H-free seven-slot fold | active | equivalent to the prepared clean-entry equality under the clean-column contract | wait for active-to-prepared equality |
| prepared clean-entry reduction | improved | `oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3 H` compiled | reuse as recovery bridge only |
| prepared composite semantics | improved | singleton prepared `CircuitMatrixSemantics` exists and clean entry evaluation compiles | prove active signal-zero entry equals this prepared clean entry |
| Shukla-Vedula clean column | contract-only | supplies `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` only | do not recurse in this batch |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for prepared entry equality and normalized route |

Next lower packet:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

If that theorem cannot be closed, return a smaller compiled obstruction naming
the exact `CircuitMatrixSemantics` composition field missing between the active
Fig. `fig:1 term ROBIN` signal-zero entry and the prepared singleton clean
entry.  Do not add a GHL theorem assumption, do not create another parallel
active/prepared route, and do not promote product-to-coefficient, LCU, cleanup,
unitarity, block projection, block correctness, normalized equality, circuit
unitarity, or final extraction flags.

## Middle Sync: 2026-05-29 Prepared Clean-Entry Reduction Audit

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
route is an equivalence, not a proof: under the clean-column contract for
$H_W^{(\kappa)}$, the H-free fold is equivalent to the prepared sparse-matrix
clean-entry equality.

Accepted declaration:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| all-slot backend family | useful | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff` compiles and slot `2` is selected | keep as the backend summand family |
| H-free unitary-entry fold | active but reduced | equivalent to one prepared clean-entry equality under the clean-column contract | recover it via `oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3` after the prepared equality is proved |
| active/prepared target | route-only | `PreparedCircuitEntryTarget` and composition-field packets are equivalent to the H-free fold, not separate objectives | use only as duplicate-route guards |
| prepared clean-entry theorem | active | no theorem yet proves `signalUnitaryEntry = preparedSparseMatrix[0,0]` | prove the prepared clean-entry equality or return a smaller `CircuitMatrixSemantics` composition-field obstruction |
| Shukla-Vedula clean-column input | contract-only | `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` is typed but not formalized | use only as a hypothesis for the focused reduction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for prepared clean-entry equality, H-free fold, and normalized equality |

Next lower packet: target the prepared clean-entry equality directly.

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

After proving it, use
`oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3 H` to
recover the H-free fold.  If the theorem is still unavailable, return a
smaller compiled obstruction naming the missing finite `CircuitMatrixSemantics`
composition field for $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$.

Do not formalize Shukla-Vedula or LCU recursively, do not add a new route
record, and do not promote product-to-coefficient, LCU, cleanup, unitarity,
block projection, block correctness, normalized equality, circuit unitarity, or
final extraction flags from this equivalence.

## Lower Result: 2026-05-29 Active/Prepared Fold Equivalence

The preferred active/prepared theorem was not proved outright.  The compiled
mutation is a bidirectional reduction under the existing clean-column contract:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_of_unitaryEntryFold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| active/prepared entry target | simplified | equivalent to the H-free signal-entry fold once `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` is supplied | do not assign as an independent target |
| H-free signal-entry fold | active | same remaining backend content as the active/prepared target | prove the seven-slot fold equality |
| clean-column contract | contract-only | Eq. `arbitrary sparcity` / Shukla-Vedula supplies the external amplitude shape | do not recursively formalize in this packet |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for the fold equality and normalized equality |

Smallest remaining obstruction:

```text
prove the H-free finite projection/product equality
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

No theorem-facing semantic flag was promoted.

## Middle Sync: 2026-05-29 Active/Interface Equality Alignment

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The newest accepted
mutation is interface alignment for the same active/prepared equality; it does
not create a new scientific target.

Accepted alignment declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_interfaceStatement_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| prepared-entry target | useful | active signal-zero entry and prepared clean entry are packaged by `PreparedCircuitEntryTarget` | keep as the fixed target carrier |
| matrix-entry equivalence | useful | cached equality and direct matrix-entry equality are equivalent | lower may prove either form |
| prepared-interface equivalence | improved | generic target equality and prepared-matrix interface equality are equivalent | avoid parallel routes; choose the easiest form for Lean |
| active/prepared composition theorem | active | no theorem yet proves the active seven-gate entry equals the prepared clean entry | prove `.entryEqualityStatement`, `.matrixEntryEqualityStatement`, or return a smaller backend-field obstruction |
| clean-column sparse preparation | contract-only | Shukla-Vedula supplies only the $H_W^{(\kappa)}$ clean-column amplitude contract | do not recurse into state-preparation formalization for this target |
| direct product-to-coefficient theorem | blocked | product-to-coefficient remains false | wait for active/prepared equality and normalized equality |

Next lower packet: start from
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_interfaceStatement_n3`,
`oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3`,
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`,
and `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_matrix_n3`.
The desired theorem is:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

The equivalent matrix and interface forms are also acceptable.  If the backend
still cannot prove the equality, return only a smaller compiled obstruction
naming the missing `CircuitMatrixSemantics` composition field for the active
seven-gate product surrounded by $H_W^{(\kappa)}$ and
$H_W^{(\kappa)\dagger}$.  Do not promote product-to-coefficient, LCU,
cleanup, unitarity, block projection, block correctness, normalized equality,
circuit unitarity, or final extraction flags.

## Middle Sync: 2026-05-29 Prepared Sparse-Matrix Interface

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation adds a prepared sparse-register matrix object and a clean-entry
unfolding theorem.  It is useful because it changes the next target from a
vague prepared-sandwich equality to a concrete active-entry-to-prepared-entry
field.

Accepted support declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedCircuitSparseMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| all-slot backend family | useful | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff` compiles and slot `2` is selected | keep as the backend fold family |
| prepared sandwich specialization | useful | the prepared sandwich fold specializes to the backend fold under the clean-column contract | reuse through the prepared sparse matrix |
| prepared sparse matrix | improved | `oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` exists and its clean-clean entry is the prepared fold | prove the active signal-zero entry equals this clean entry |
| active raw-entry source | useful | active `signalUnitaryEntry` is the seven-gate contract matrix entry and `H_W^(kappa)` gates are absent from that active list | use this to justify the missing prepared composition field |
| active-entry prepared-matrix equality | active | theorem is typed by `activeEntryToPreparedEntryStatement`, but absent | prove the equality or return a smaller `CircuitMatrixSemantics` composition-field obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for the active-entry prepared-matrix equality and normalized equality |

Next lower packet: start from
`oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3_transcript`,
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3`,
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedCircuitSparseMatrix_n3`,
`oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3`, and
`oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`.  The desired
theorem is:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
```

If the current backend cannot express this equality, the next result should be
a smaller compiled obstruction naming the missing `CircuitMatrixSemantics`
composition field for
$H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$.  Do not add a GHL assumption, do not
formalize Shukla--Vedula or LCU recursively, and do not promote
product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction flags.

## Lower Result: 2026-05-29 Prepared-Circuit Semantics Gap

The raw-entry prepared-sandwich equality was not proved.  The useful mutation
is a smaller compiled gap:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| raw-entry field | improved | raw statement remains typed by `oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H` | wait for prepared circuit matrix field |
| raw-entry source | proved | `signalUnitaryEntry` is the active seven-gate contract `unitaryMatrix[0,0]` | reuse before any prepared-sandwich proof |
| active gate-list audit | proved | `H_W^(kappa)` and its dagger are absent from `oneTermRobinGateMatrixPlaceholders` | do not try to unfold the active gate list to get the prepared sandwich |
| prepared circuit semantics | blocked | no matrix field for $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ is present | add the prepared circuit entry or prove the active raw entry equals it |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for prepared circuit semantics and normalized equality |

Smallest remaining obstruction:

```text
provide a QBE-local prepared circuit semantics entry for
H_W^(kappa)^dagger * oneTermRobinGamma3BoundarySevenGateMatrix_n3 * H_W^(kappa),
or prove that the active seven-gate raw entry selected by block extraction is
equal to that prepared entry
```

No theorem-facing semantic flag was promoted.

## Lower Result: 2026-05-28 Fold-Support Packet

The active proof-attempt population remains fixed on the full-unitary entry
fold for `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest
accepted mutation does not prove the fold; it isolates a smaller support fact:
slot `2` is a member of the seven-slot fold domain and is still the selected
`[32,32]` branch summand.

New compiled declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| unitary-entry fold interface | useful | target equality is typed on the full signal-zero entry `[0,0]` | keep as active theorem |
| fold-domain support | improved | `List.finRange 7` contains slot `2`, and slot `2` equals the selected summand | use when proving the full fold |
| off-branch support and summation | active | no theorem expands the full entry as all seven branch summands | prove the full fold or name a smaller finite product/projection field |
| direct product-to-coefficient theorem | blocked | product-to-coefficient remains false | wait for the full fold plus normalized equality |

Remaining theorem:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

## Middle Sync: 2026-05-28 Unitary-Entry Fold Target

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation is the unitary-entry fold target:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| placeholder branch family | rejected for closure | selected slot compiles but is not backend-sourced | do not use it to prove the branch sum |
| all-slot backend family | useful | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff` compiles and slot `2` is selected | keep as the branch fold family |
| backend expansion bridge | useful | backend expansion statement is typed and equivalent to the cached block-entry branch sum | keep as upstream bridge |
| unitary-entry fold target | active | full signal-zero unitary entry target is typed and equivalent to backend expansion | prove the full entry fold or return a smaller backend-field obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for the unitary-entry fold and normalized equality |

Next lower packet: start from
`oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3_transcript`,
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
`oneTermRobinGamma3BoundaryProjectionSummationObstruction_signalEntry_eq_unitary_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_n3`, and
`oneTermRobinGamma3BoundaryBackendExpansionBridge_n3_transcript`.  The desired
theorem is:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

This is equivalent to
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
If the backend cannot expose that equality yet, return a smaller compiled
obstruction naming the missing finite product/projection field for entry
`[0,0]`.

Do not formalize Shukla--Vedula or LCU recursively, do not revisit the old
bulk endpoint, do not add a new theorem route, and do not promote
product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction flags.

## Middle Sync: 2026-05-28 Post Fold-Support Packet

The proof-attempt population stays fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`. The latest support
mutation is accepted, but it is not a proof of the active fold.

Accepted support declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| all-slot backend family | useful | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff` compiles and slot `2` is selected | keep as the active fold family |
| unitary-entry fold target | active | full signal-zero entry `[0,0]` target is typed and equivalent to backend expansion | prove the fold theorem |
| fold-support block | improved | `List.finRange 7` contains slot `2`, and slot `2` is still the accepted `[32,32]` summand | reuse in the fold proof; no need to reprove membership |
| off-slot summation and backend expansion | blocked | no theorem expands entry `[0,0]` as all seven backend branch summands | prove the fold or return a smaller finite product/projection obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for the unitary-entry fold and normalized equality |

Next lower packet: start from
`oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3_transcript`,
`oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3`,
`oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`,
and `oneTermRobinGamma3BoundaryBackendBranchContribution_n3`. The desired
theorem remains:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

This is equivalent to
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
If the finite backend still cannot expose the equality, the next result should
be a smaller compiled obstruction naming the missing product/projection field
for entry `[0,0]`. Do not use the placeholder branch family and do not promote
product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction flags.

## Lower Result: 2026-05-28 Projection-Statement Bridge

The branch-sum equality was not proved.  The useful accepted mutation is a
conditional bridge from the generic backend target statement to the Robin-local
backend predicate:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_unfold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_targetProjection_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| all-slot backend family | improved | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff` compiles and slot `2` is selected | keep as the active backend family |
| generic projection statement | active | statement is typed by `BlockExtractionBranchContributionTarget.projectionSummationStatement` | prove this equality from finite projection semantics |
| signal-entry bridge | proved | Robin-local `signalBlockEntry` is the backend target block entry | reuse in branch-sum closure |
| predicate closure from target projection | improved | backend predicate closes if the generic projection statement is supplied | wait for projection/summation theorem |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch-sum theorem and normalized equality |

Smallest remaining obstruction:

```text
prove BlockExtractionBranchContributionTarget.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3 from the finite
projection backend; this is the signal-zero branch-sum equality for the
backend seven-slot family
```

No theorem-facing semantic flag was promoted.

## Lower Result: 2026-05-28 Branch-Index Map Obstruction

The backend-sourced branch family was not proved.  The useful mutation is a
smaller branch-index packet:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| placeholder branch family | rejected for closure | selected slot compiles but is not backend-sourced | do not use it to prove the branch sum |
| generic branch target | useful | block entry, branch fold, and selected contribution are typed | keep as target carrier |
| branch-to-full-index map | improved | `Fin 7 -> Fin fullDim` map compiled; slot $2$ maps to `32` | add all-slot summand formula |
| selected branch summand | improved | selected contribution formula compiles for slot $2$ | generalize only when backend supplies all summands |
| backend predicate closure | blocked | predicate is typed but no backend-sourced family satisfies it | wait for all-slot summand formula and branch sum |
| product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend branch sum and normalized equality |

Smallest remaining obstruction:

```text
all-slot backend summand formula: for every s : Fin 7, compute
branchContribution s from the backend full-basis branch entry and sparse-register
projection amplitudes, then prove the seven-branch fold equals
contract.expectedTarget.blockMatrix[0,0]
```

No theorem-facing semantic flag was promoted.

## Lower Result: 2026-05-28 Branch-Sum Closure Packet

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation is the branch-sum closure packet:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_selectedClause_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_branchSum_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3_transcript`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| placeholder branch family | rejected for closure | selected slot compiles but is not backend-sourced | do not use it to prove the branch sum |
| branch-to-full-index map | useful | every sparse slot has a clean full-basis index; slot `2` maps to `32` | keep as input to all-slot family |
| all-slot backend family | improved | `oneTermRobinGamma3BoundaryBackendBranchContribution_n3 : Fin 7 -> Coeff` compiles and slot `2` is selected | feed branch-sum closure |
| selected predicate clause | proved | first conjunct of the backend predicate is compiled | no further search needed here |
| branch-sum theorem | active | second conjunct is typed but absent | prove the signal-zero branch-sum equality or return a smaller projection-backend obstruction |
| finite normalized block equality | contract-only | `finiteCompositionNormalizedEquality.proved = false` | keep under `LCU.StandardBlockEncoding` |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for branch-sum theorem and normalized equality |

Next lower packet: start from
`oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3_transcript`,
`oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_selectedClause_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_branchSum_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3`, and
`oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3`.
The desired theorem is
`BlockExtractionBranchContributionTarget.projectionSummationStatement
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3`, equivalently
the second conjunct of
`oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3
oneTermRobinGamma3BoundaryBackendBranchContribution_n3`.

Do not formalize Shukla--Vedula or LCU recursively, do not revisit the old
bulk endpoint, do not add a new theorem route, and do not promote
product-to-coefficient, LCU, cleanup, unitarity, block projection, block
correctness, normalized equality, circuit unitarity, or final extraction flags.

## Middle Update: 2026-05-29 Active Circuit Entry Source

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
mutation does not prove the branch-sum equality, but it removes one wrapper
from the active side:

- `Examples.RobinHeat.oneTermRobinGamma3BoundarySignalUnitaryEntry_activeCircuitMatrix_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activeCircuitEntryEval_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| branch-sum theorem | active | backend branch family is typed, but the signal-zero fold is absent | prove the evaluated active-entry fold or return a smaller projection-backend obstruction |
| active entry source | proved | `signalUnitaryEntry` is the active seven-gate `[0,0]` entry and an `evalGateMatrices` entry | use as the left side of the evaluated fold |
| evaluated backend fold | active | `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` is typed and equivalent to active `[0,0]` entry evaluation | prove this equality before returning to product-to-coefficient |
| raw `Coeff` fold | stronger, pending | would imply every evaluated fold but is absent | prove only if the finite backend supports it directly |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for evaluated or raw backend fold plus normalized block equality |

Next lower packet: start from
`oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3`,
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activeCircuitEntryEval_n3`,
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_backendEval_n3`,
and `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3`.
The desired theorem is `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`,
or the stronger raw equality

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Do not use Shukla-Vedula, standard LCU, a new GHL assumption, the corrected
`R_y` audit, or the bulk `j = 5` route to close this local finite equality.
No theorem-facing semantic flag has been promoted.

## Lower Result: 2026-05-29 Uncast Active Entry Reduction

The target
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env` was not
proved.  The useful reduction is smaller than the previous active-entry source:
the remaining equality no longer contains the finite block-extraction dimension
cast on the active side.

Accepted compiled declarations:

- `Matrix.cast_square_apply`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCircuitEntryEval_uncast_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_uncastActiveCircuitEntryEval_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| active entry source | improved | signal-zero entry is the active seven-gate product entry, and the evaluated statement now rewrites to the uncast `evalGateMatrices` `[0,0]` entry | prove or reduce the uncast product/projection fold |
| evaluated backend fold | active | equivalent to the uncast active `[0,0]` entry against the backend seven-slot fold | target this statement directly |
| raw `Coeff` fold | stronger, pending | no symbolic fold proof | attempt only if backend can avoid full symbolic expansion |
| product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for evaluated/raw backend fold plus normalized equality |

Smallest remaining obstruction:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

No theorem-facing semantic flag was promoted.

## Middle Update: 2026-06-03 Prepared Singleton Route Reset

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, but the next proof
mutation must pass through the source-prepared singleton clean entry.  The raw
H-free active `[0,0]` fold is now diagnostic/backlog unless it is recovered
from the prepared route.

Definitions:

- Source-prepared projection target:
  `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env`.
- Active-to-prepared field:
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`.
- Prepared backend bridge:
  `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).preparedSingletonToBackendEvalStatement`.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| source-prepared singleton field | active | target is typed; equality absent | prove or strictly reduce `.activeToPreparedSingletonEvalStatement` |
| prepared backend bridge | high, conditional | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3` compiles under the $H_W^{(\kappa)}$ clean-column contract | consume after the singleton field is proved |
| raw H-free active fold | diagnostic/backlog | slot-`0` diagnostic shows the raw active entry is one weighted summand, not the complete prepared projection route | use only as a route guard or if derived from the prepared field |
| slot-`0` summand diagnostic | useful guard | `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3` compiles | preserve as evidence against standalone H-free closure |
| product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for the active-to-prepared field plus normalized block equality |

Next lower packet:

```text
prove or reduce
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement,
equivalently
(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement
```

Allowed starting declarations include
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript`,
`oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3_transcript`,
`oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3`,
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`,
and
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedCircuitField_n3`.

No theorem-facing semantic flag was promoted.

## Middle Update: 2026-06-03 Raw-Field Backend-Expansion Sync

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The latest accepted
Lean mutation did not prove the prepared-sandwich target; it aligned the
stronger raw field with the unique backend-expansion target under the existing
all-slot clean-column contract for $H_W^{(\kappa)}$.

Accepted compiled declarations:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_unitaryEntryFold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| source-prepared singleton field | reduced | equivalent to the uncast prepared-sandwich target | keep as route context |
| evaluated prepared-sandwich target | active recovery target | follows from the raw field by `oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_rawEntryPreparedSandwichField_n3` | prove only after raw field or backend expansion is available |
| raw prepared-sandwich field | aligned | equivalent to the backend-expansion statement under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | prove via backend expansion or return a smaller obstruction |
| backend expansion | active fixed target | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` is still absent | prove this finite projection/backend equality |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend expansion plus downstream normalized equality |

Next lower packet:

```text
prove or strictly reduce
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

Equivalently, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, prove
`(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement`.
Do not use Shukla-Vedula, standard LCU, a new GHL assumption, O_D^BS/O_f work,
or the bulk `j = 5` route to close this local finite projection theorem.  No
theorem-facing semantic flag has been promoted.

## Middle Update: 2026-06-04 Prepared Product Route and Expanded Fold

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The prepared
singleton clean-entry route is now compiled into the focused product map by
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3`.
The raw H-free active fold remains diagnostic/backlog unless recovered through
that source-prepared route.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| prepared singleton product route | accepted route wiring | compiled under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; theorem-facing flags false | reuse as the product-map bridge after backend expansion |
| backend expansion | active fixed target | `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement` remains absent | prove or strictly reduce the finite projection/backend equality |
| expanded seven-summand fold | active mutation | `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3` compiles; equality absent | prove the expanded-fold right side or return one smaller obstruction |
| raw H-free active fold | diagnostic/backlog | useful only through the prepared route | keep as a guard against false source closure |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for backend expansion plus downstream normalized block equality |

Next lower packet:

```text
prove or strictly reduce the expanded-fold side of
oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3
```

An equivalent target is
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`.
Do not use Shukla--Vedula recursion, standard LCU, a new GHL assumption,
O_D^BS/O_f work, the raw H-free fold as an independent source route, or the
bulk `j = 5` route to close this local finite projection theorem.

## 2026-06-04 Middle Cycle 1 Closeout

The prepared singleton clean-entry route is the active theorem-facing route.
The compiled theorem
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3`
uses the explicit all-slot clean-column contract
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` to feed
the prepared backend bridge into the focused product map.

The raw H-free active fold remains diagnostic/backlog.  Future proof attempts
may target the expanded-fold side of
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`,
but only as a recovery lemma for the source-prepared route.  No attempt in this
population may promote product-to-coefficient, LCU, block projection,
normalized equality, block correctness, circuit unitarity, or final extraction
without a build-tested Lean theorem for that exact field.

## Middle Update: 2026-06-05 Source-Prepared Projection Fixed Target

The active proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, but the next lower
mutation must target the prepared projection route first. The accepted Lean
route witness is
`oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3`;
it consumes the prepared target-field bridge under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` and
keeps theorem-facing flags false.

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| prepared target-field backend bridge | accepted route wiring | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` compiled under `hUniform`; theorem-facing flags false | reuse, do not duplicate |
| active/prepared selected-entry equality | active fixed target | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` remains absent | prove or return one smaller compiled obstruction |
| active/prepared circuit field | equivalent fixed target | `(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement` is equivalent under existing route lemmas | prove if this shape is easier |
| expanded H-free fold | diagnostic recovery | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_uncastActiveEntryExpandedFold_n3` is conditional only | use only to recover the prepared route after proving the expanded equality |
| direct product-to-coefficient theorem | blocked | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` remains false | wait for active/prepared field plus downstream normalized equality |

Next lower packet:

```text
prove or strictly reduce
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

An equivalent target is
`(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`.
If lower works on
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`,
that work must be framed only as recovery for the prepared projection route.
Do not use Shukla--Vedula recursion, standard LCU, new GHL assumptions,
O_D^BS/O_f work, corrected `R_y` audit, bulk `j = 5`, or the raw H-free fold
as an independent source route.

## Middle Update: 2026-06-05 Focused Product-Obligation Prepared Bridge

The latest accepted lower bridge attaches the source-prepared backend equality
to the fixed focused product-obligation map.  The proof-attempt population is
still over the same theorem:
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.

Accepted compiled declaration:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFocusedProductObligation_preparedProjectionBackendEval_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| prepared target-field backend bridge | accepted route wiring | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3` compiles under `hUniform` | reuse, do not duplicate |
| focused product-obligation bridge | accepted route wiring | prepared backend equality is exposed at `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`; theorem-facing flags false | use as the fixed product map after the active/prepared field is proved |
| active/prepared selected-entry equality | active fixed target | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` remains absent | prove or return one smaller compiled obstruction |
| active/prepared circuit field | equivalent fixed target | `(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement` is the equivalent field target | prove if this shape is easier |
| H-free active fold | diagnostic recovery | useful only through the prepared projection route | do not treat as an independent source theorem |

Next lower packet:

```text
prove or strictly reduce
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The equivalent target is
`(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`.
If lower works on the backend expansion, it must be framed only as recovery for
the source-prepared route.  Product-to-coefficient, branch decomposition, LCU,
block projection, normalized equality, block correctness, circuit unitarity,
and final extraction remain false.

## Middle Update: 2026-06-05 Direct Prepared-Clean Product Route

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`.  The newest accepted
route exposes the literal prepared clean-clean entry selected by the source
projection at both the focused product-obligation layer and the
product-obligation wrapper:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFocusedProductObligation_preparedCompositeCleanEntryBackendEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| direct prepared clean product route | accepted route wiring | exact prepared clean-clean backend equality compiles under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; theorem-facing flags false | reuse as the theorem-facing projection route |
| focused product-obligation bridge | accepted route wiring | fixed product obligation is exposed but not proved | use after the active/prepared field is proved |
| active/prepared selected-entry equality | active fixed target | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` remains absent | prove or return one smaller compiled obstruction |
| active/prepared circuit field | equivalent fixed target | `(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement` remains absent | prove if this shape is easier |
| H-free active fold | diagnostic recovery | useful only through the prepared projection route | do not treat as an independent source theorem |

Next lower packet:

```text
prove or strictly reduce
(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement
```

The equivalent target is
`(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`.
Use backend expansion only as prepared-route recovery.  Product-to-coefficient,
branch decomposition, LCU, block projection, normalized equality, block
correctness, circuit unitarity, and final extraction remain false.

## Middle Update: 2026-06-05 Source-Prepared Target Product Map

The proof-attempt population remains fixed on
`oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, but the accepted
route witness now goes through the source-prepared target field:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| source-prepared target product map | accepted route wiring | `preparedSingletonToBackendEvalStatement` is exposed beside the fixed product map under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; theorem-facing flags false | reuse as the theorem-facing prepared projection path |
| direct prepared clean product route | accepted route wiring | exact prepared clean-clean backend equality compiles under the same clean-column contract | reuse; do not duplicate |
| active/prepared selected-entry equality | active fixed target | `(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement` remains absent | prove or return one smaller compiled obstruction |
| uncast active/prepared comparison | preferred reduced target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` remains absent | prove if this shape is easier |
| H-free active fold | diagnostic recovery | useful only through the prepared projection route | do not treat as an independent source theorem |

Next lower packet:

```text
prove or strictly reduce
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

Equivalent wrappers are
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`
and
`(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`.
Product-to-coefficient, branch decomposition, LCU, block projection, normalized
equality, block correctness, circuit unitarity, and final extraction remain
false.

## Lower Update: 2026-06-05 Uncast Recovery Route

The active/prepared selected-entry target remains the current fixed target:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

This attempt did not prove the target outright.  It added two conditional
recovery routes so any future backend-expansion proof feeds the preferred
source-prepared path directly rather than closing a standalone H-free theorem:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_backendExpansion_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_uncastActiveEntryExpandedFold_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| uncast recovery from backend expansion | small reduction | backend expansion now closes the preferred uncast active/prepared statement through the prepared-sandwich bridge | prove the backend-expansion theorem or reduce it further |
| expanded diagnostic fold recovery | small reduction | expanded H-free fold now closes the preferred uncast target only through the prepared route | use only as recovery, not as standalone closure |
| active/prepared selected-entry equality | active fixed target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` remains absent unconditionally | prove or reduce the finite matrix-composition theorem |
| source-prepared target product map | accepted route wiring | prepared backend field still feeds the fixed product map under the all-slot clean-column contract | reuse after active/prepared field is proved |

All theorem-facing product, LCU, block, normalized-equality, unitarity, and
final-extraction flags remain false.

## Lower Update: 2026-06-05 Raw-Field Active Route

The preferred active/prepared selected-entry target remains:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

This attempt did not prove the target outright.  It added a smaller conditional
route from the existing raw-entry prepared-sandwich field:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_rawEntryPreparedSandwichField_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3`

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| raw-field active route | small reduction | raw-entry prepared-sandwich field now closes the preferred uncast active/prepared target and the source-prepared projection target | prove or reduce `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` |
| uncast active/prepared selected-entry equality | active fixed target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` remains absent unconditionally | prove the finite matrix-composition theorem |
| expanded diagnostic fold recovery | conditional only | expanded H-free fold still feeds the preferred target only through the prepared route | use only as recovery, not standalone closure |
| source-prepared target product map | accepted route wiring | prepared backend field still feeds the fixed product map under the all-slot clean-column contract | reuse after active/prepared field is proved |

No product-to-coefficient, branch-decomposition, LCU, block-projection,
normalized-equality, block-correctness, unitarity, or final-extraction flag was
promoted.

## Middle Update: 2026-06-05 Raw-Field Route Sync

The raw-field route is accepted as conditional proof-DAG wiring, not a new
successful proof route.  The population remains fixed on the same theorem:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

Current proof-attempt population:

| Route | Score | Status | Next mutation |
|---|---|---|---|
| raw-field active route | conditional reduction | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_rawEntryPreparedSandwichField_n3` and `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3` compile | prove or strictly reduce `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` |
| uncast active/prepared selected-entry equality | active fixed target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` remains absent unconditionally | prove the finite matrix-composition theorem or return one smaller compiled obstruction |
| source-prepared target product map | accepted route wiring | `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3` exposes the prepared backend field beside the fixed product map | reuse only after the active/prepared field closes |
| H-free backend expansion | diagnostic recovery | may feed the prepared route, but is not a standalone source theorem | do not assign as the primary theorem unless the packet explicitly routes it through the prepared singleton target |

The Shukla--Vedula all-slot preparation dependency remains contract-only
through `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
No theorem-facing flags are promoted.

## Middle Update: 2026-06-05 Cycle 1 Final Population Freeze

The proof-attempt population remains fixed on the source-prepared route.  The
accepted bridge is the prepared clean-entry backend equality; the H-free active
fold is a recovery route only.

| Route | Score | Status | Next mutation |
|---|---|---|---|
| prepared clean-entry backend bridge | accepted route wiring | `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` and `oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3` compile under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; product theorem false | reuse as fixed theorem-facing backend path |
| uncast active/prepared selected-entry equality | active fixed target | `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` remains absent unconditionally | prove the finite matrix-composition theorem or return one smaller compiled obstruction |
| raw-entry prepared-sandwich field | smaller accepted target | `(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement` remains absent; conditional routes into the fixed target compile | prove or strictly reduce this field |
| H-free backend expansion | diagnostic recovery | may feed the prepared route through compiled recovery lemmas | do not treat as standalone theorem closure |

No product-to-coefficient, branch-decomposition, LCU, block-projection,
normalized-equality, block-correctness, circuit-unitarity, or final-extraction
flag is promoted.

## Lower Attempt: 2026-06-05 Direct Active/Prepared Closure Probe

Target:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

The direct proof route reduces immediately to the existing evaluated backend
fold target:

```lean
example (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env := by
  apply (oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
    H env hUniform).2
```

Lean residual goal:

```lean
⊢ oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The theorem-facing wrapper has the same residual goal:

```lean
example (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    (oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement := by
  apply (oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3
    H env hUniform).1
```

Lean residual goal:

```lean
⊢ oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

Classification: local Lean lemma gap.  The prepared singleton clean-entry
backend bridge is already compiled, but direct active/prepared closure still
requires the QBE-local finite projection theorem named by
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`.  No Lean
declaration was added in this attempt because the available equivalences
already expose this reduction, and adding another wrapper would only repeat the
same obstruction.
