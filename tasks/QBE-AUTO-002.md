# Concrete Circuit Matrix Semantics Backend

Task id: `QBE-AUTO-002`
Kind: `oracleRealization`
Mode: `faithfulPaper`
Status: `active`
Created: `2026-05-18`

## Goal

Build the minimal Lean matrix-semantics backend needed to turn the faithful
GHL2025 Robin circuit skeleton into a checkable block-encoding statement.

This is not an innovation/open-problem task.  It is infrastructure required to
finish the paper-reproduction mode for `QBE-AUTO-001`.

## Phase Discipline

This task is currently in **Phase 1: faithful paper transcript and contract
capture**.  The immediate goal is to reproduce the paper's proof structure
faithfully and quickly:

- map every relevant theorem, lemma, equation, circuit fragment, oracle
  contract, normalizer, register layout, and resource claim to a Lean
  declaration or explicit proof obligation;
- keep unproved gate-level facts as `proved := false`;
- keep Markdown/LaTeX proof maps synchronized with the Lean declarations.

Do not use Phase 1 to reorganize the whole library, introduce broad reusable
APIs, polish non-critical proofs, or optimize for future papers.  Those belong
to **Phase 2: library organization and reuse**, after the GHL transcript and
contracts are complete.

Proof-route populations are allowed only for fixed Lean statements whose
failure produced useful lemmas.  They must not mutate the paper construction or
displace the Phase 1 transcript objective.

## Immediate 6h Focus: Source-Faithful Fig. 4 Transcript And EvalWith Bridge (2026-06-08)

This directive supersedes all earlier immediate directives for the next
active-time theorem-closure batch.

The current blocker is not a missing external theorem.  The GHL source gives
the Robin one-term construction in:

| Source | Role |
|---|---|
| `main.tex:1098-1109` | Theorem `1 term robin`, target block-encoding claim |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`, especially the `gamma_3` clean coefficient |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`, theorem-facing gate order and cleanup |
| `main.tex:948-955` | `H_W^(kappa)` sparse-register preparation contract |
| `main.tex:2027-2035` | block-encoding projection definition |

The next batch has one scientific objective: make the Lean theorem-facing
circuit transcript match Fig. `1 term ROBIN`, then close the remaining
entry/projection bridge at the `Coeff.evalWith` semantic level.

Required source-correction work before more proof search:

1. Add an explicit theorem-facing `U_indic^dagger` gate slot.  The existing
   `U_indic` permutation/self-inverse lemmas may justify using the same matrix,
   but the gate label and circuit transcript must match Fig. 4.
2. Keep the two `H_W^(kappa)` sides visible as theorem-facing boundary gates or
   as a clearly named prepared-sandwich contract.  Do not let lower agents
   prove a seven-gate theorem while claiming it is the full Fig. 4 circuit.
3. Distinguish the pre-SWAP `O_{D^T}^{BS}` role from the post-SWAP
   `(O_D^{BS})^dagger` cleanup role in the conversion window and proof notes.
4. Demote the raw symbolic `Coeff` constructor-equality route to diagnostic
   memory.  The active route must be an `evalWith` entry bridge.

After the transcript correction, the Lean proof target should be one of:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

or a strictly smaller theorem that directly feeds
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

Lower-agent population:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Translate `main.tex:1098-1164` into a dependency-ordered proof-DAG packet: source line, Lean declaration, existing lemma, missing lemma, and whether each dependency is GHL-internal or cited-contract. |
| lower 2: Lean implementation worker | Implement exactly one ready Lean leaf from lower 1's packet, preferably the circuit transcript correction or the smallest `evalWith` bridge. |

Reviewer requirements:

- Reject any cycle that keeps proving the old raw `Coeff` equality as the main
  theorem.
- Reject any claim that the full GHL Fig. 4 circuit is formalized while the
  explicit `U_indic^dagger` slot or the `H_W^(kappa)` sides are absent from the
  theorem-facing transcript.
- Reject any promotion of ODBS/ODTS/O_f/H_W/R_y contract flags to proved unless
  there is a corresponding Lean theorem and source/citation row.
- Require the generated Chinese summary at
  `paper-notes/GHL2025/markdown/cycle-summaries/latest.md` to name the source
  lines, Lean state, and remaining obligations.

Non-goals:

- Do not recursively formalize Shukla--Vedula, Gilyén et al., LCU, or the
  prior PDE sparse-access paper in this batch.
- Do not work on 1D Hamiltonian, multidimensional theorem, QSVT, or project
  article polish until the one-term Robin theorem-facing route is closed under
  cited contracts.
- Do not add assumptions, weaken the target, or replace the paper oracle.

## Immediate 6h Focus: Active/Prepared Composition Closure

This directive supersedes earlier projection-bridge and H-free backend-fold
directives for the next active-time theorem-closure batch.

The source-correct route is now:

1. Prove the active/prepared selected-entry equality
   `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`,
   preferably via the reduced target
   `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`.
2. Feed that theorem into the already compiled route
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.
3. Keep the H-free theorem
   `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` frozen as a
   diagnostic/backlog route unless a proof explicitly recovers it through the
   prepared projection target.

The exact active mathematical target is QBE-local finite matrix composition:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

or the equivalent uncast target:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

Source interpretation:

- GHL2025 supplies the Robin boundary seven-gate product and the prepared sparse
  register route in Fig. `1 term ROBIN`, Eq. `ROBIN clarified`, and Eq.
  `arbitrary sparcity`.
- The Shukla--Vedula uniform superposition subroutine is an external typed
  contract for the `H_W^(kappa)` column shape.  Do not recursively formalize it
  in this batch.
- The active Lean work is to show that the prepared sandwich clean entry matches
  the active seven-gate selected entry under that typed contract, not to invent
  a new oracle or add an assumption.

Lower-agent population for this batch:

| Lower profile | Role | Allowed outputs |
|---|---|---|
| lower 1: natural-language proof architect | Translate the relevant source proof and current Lean DAG into a dependency-ordered proof plan. | `proof-attempts/`, `conversion-windows/`, `proof-obligations/`, dialogue handoff. Minimal Lean only if unavoidable. |
| lower 2: Lean implementation worker | Implement the smallest theorem or lemma from that plan and run the gate. | `QuantumBlockEncoding/RobinMatrix.lean`, focused tests, proof-attempt record for failed Lean routes. |

Natural-language proof work is not second-class.  A good proof architect should
state definitions before claims, identify existing Lean declarations to reuse,
and propose one or two small intermediate lemmas that make the Lean proof
obvious.  The Lean worker should avoid broad search when the proof architect has
already isolated a sharper lemma.

Current known compiled inputs:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3` | compiled conditional closure of the evaluated backend fold from the active/prepared theorem |
| `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` | compiled prepared clean-entry backend bridge under `hUniform` |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3` | compiled reduction to the uncast active/prepared theorem |
| `oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3` | compiled prepared sandwich expansion route |
| column-0 support lemmas for indicator, `O_DT^S`, DU prefix, and `O_D^BS` | compiled fallback fragments; `R_y`, RDU, suffix, and unique-path support remain open |

Non-goals:

- Do not spend the batch proving the frozen H-free raw fold directly.
- Do not promote `productToCoefficientProved`, `lcuCorrectProved`,
  `blockProjectionProved`, `blockCorrectProved`,
  `normalizedBlockEqualityProved`, `circuitUnitarityProved`, or
  `finalExtractionProved`.
- Do not recursively formalize Shukla--Vedula, LCU, or block-composition.
- Do not polish the project article or broad library organization.
- Do not add hypotheses, change the paper circuit, or replace the oracle.

Acceptance for this batch:

- Best outcome: a sorry-free theorem proving
  `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` or
  the equivalent uncast theorem under the existing contracts, with
  `python3 tools/qbe.py check` passing.
- Acceptable partial outcome: a strictly smaller compiled intermediate lemma
  that the next Lean worker can directly use, plus a natural-language proof map
  explaining exactly how it closes the active/prepared target.
- Rejected outcome: more status records, broad diagnostics, or prose that does
  not reduce the active theorem.

## Current Run Directive: 2026-05-28 Focused Projection Bridge Closure

This directive supersedes older broad run directives for the next overnight
batch.  The active mathematical blocker is no longer the boundary `R_y`
convention, Shukla--Vedula state preparation, standard LCU, or the old bulk
endpoint comparison.  Those are either source-backed, contract-only, or
backlog.  The current target is the QBE-local finite-register projection bridge
for the focused GHL2025 Robin boundary branch.

Source anchors:

| Source item | Role in this run |
|---|---|
| GHL2025 Theorem `theorem: 1 term robin` | theorem being faithfully reproduced under cited contracts |
| Eq. `eq: ROBIN clarified`, displayed `gamma_3` boundary branch | source coefficient and register branch |
| Fig. `fig:1 term ROBIN` | gate/order/register source for the product route |
| Definition `def:block-encoding` | signal-zero block projection convention |
| Eq. `arbitrary sparcity` and Shukla--Vedula cited result | external clean sparse-register amplitude contract only |
| Standard LCU/block-composition | external/standard contract only for this run |

Current compiled Lean input:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsEval_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript`

The focused branch data is fixed:

| Item | Value |
|---|---|
| system entry | `(0,0)` |
| sparse slot | `2` |
| branch basis index | `32` |
| signal-zero block entry | full finite entry `[0,0]` |
| fixed theorem target | `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` |

This run has exactly one proof focus:

1. Produce a Lean-facing proof-translation packet that explains how the
   source's Dirac/register expression for the displayed `gamma_3` boundary
   branch is projected into Definition `def:block-encoding`.
2. Implement or refine the smallest QBE-local interface that connects the
   slot-`2` branch product at full basis `[32,32]` to the signal-zero block
   entry `[0,0]`.
3. If the existing finite matrix semantics cannot express that bridge, record
   the missing projection/summation field as the smallest obstruction and add a
   typed interface target for the next run.  Do not hide this by adding a new
   assumption to the GHL theorem.
4. Promote `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0` only if the
   bridge and normalized product equality are actually proved by Lean and the
   build gate passes.

Non-goals for this run:

- Do not recursively formalize the whole Shukla--Vedula state-preparation
  theorem.
- Do not recursively formalize standard LCU/block-composition.
- Do not revisit the old `j = 5` bulk endpoint mismatch.
- Do not write broad reusable APIs or project-paper prose unless the current
  proof interface needs a small reusable lemma.
- Do not add a replacement oracle, extra assumption, or easier theorem.
- Do not edit automation/process files unless the run command itself is broken.

Agent discipline for this run:

| Agent | Required behavior |
|---|---|
| upper | Keep the cycle focused on the projection bridge and reject broad detours. |
| middle | Translate the relevant source register/projection step into Lean targets before lower work; after Lean work, update Markdown/LaTeX/proof-obligation notes only for accepted changes. |
| lower | Work only on the fixed bridge or the smallest missing interface. Prefer `QuantumBlockEncoding/RobinMatrix.lean` and focused tests in `Tests/Basic.lean`. |
| reviewer | Check that no semantic flag is promoted without a Lean theorem, that cited contracts remain contract-only, and that Markdown math uses `$...$` or `$$...$$`. |

Known pre-existing diff boundary for the next continuation run:

- MathCode attribution, `qbe-proof-diagnostics`, and process-documentation
  edits are a separate process-docs/reference update already present before the
  GHL continuation run starts.
- The GHL faithful run must not edit those process-docs files further unless a
  build or prompt-generation failure makes it necessary.
- Reviewer should not reject the GHL proof cycle merely because those
  pre-existing process-docs files remain dirty.  Reviewer should reject only
  new out-of-scope edits made during the GHL continuation run or any attempt to
  use process-doc changes as evidence for a GHL theorem closure.

## Current Run Directive: GHL Theorem Closure Under Cited Contracts

### 2026-05-26 Boundary `R_y` Source-Audit Correction

The previous batch exposed a real convention mismatch in the displayed
boundary branch of Eq. `eq: ROBIN clarified`.  The local GHL2025 text writes
`theta_j^s = arccos(D_j^(s) / N_D)`, while the active Lean matrix uses the
standard quantum `R_y(theta)` convention with entries `cos(theta/2)` and
`sin(theta/2)`.  Under that standard convention the displayed coefficient
requires the input angle

$$
theta_j^s = 2 arccos(D_j^(s) / N_D).
$$

Source audit:

| Evidence | Status |
|---|---|
| GHL2025 Eq. `eq:angles for Ry` | local text says `arccos(D/N_D)` |
| GHL2025 Fig. `fig:1 term ROBIN` | labels the boundary gates as `R_y(theta_j^s)` |
| Prior PDE construction, arXiv:2405.12855, appendix `O_{p^m}^S` | uses `theta_s = 2 arccos(...)` for the same standard `R_y` sparse-amplitude pattern |
| Companion implementation `XiajieHuang/Hamiltonian-Simulation-of-1D-Heat-Equation-with-Robin-Boundary-Conditions` | README and `fundamental_gates_unitary.py` use the standard half-angle `ry(parameter)` convention; `Hamiltonian_of_1D_Heat_Equation.py` computes boundary correction angles with `2 * np.arccos(...)` |

Active decision: treat the GHL2025 boundary line as a source-backed correction
route, not as a theorem-ending gap.  The corrected route is compiled as
`Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3`.
It permits lower product-to-coefficient work to resume for the boundary branch
while keeping product-to-coefficient, LCU, block projection, cleanup, unitarity,
block correctness, normalized equality, circuit unitarity, and final extraction
flags false until Lean actually proves them.

The next lower focus is narrow:

1. Add a corrected-angle boundary coefficient interface for `Ry_boundary`.
2. Rewire the focused boundary product route so the clean ket-zero boundary
   factor is the normalized derivative coefficient
   `GHL2025.boundaryRotationNormalizedCoefficient p 0 2`, not an unresolved
   free symbol.
3. Prove the focused boundary product-to-coefficient statement for
   `oneTermRobinGamma3ProductToCoefficientObligation 3 0 0`, or record the
   smallest remaining Lean-local obstruction.
4. Only after that, continue to the bulk branch and finite block-composition
   route.  Do not spend this batch on broad library organization or recursive
   proof of cited primitives.

The 2026-05-25 next run is a hard pivot from route-guard maintenance and
recursive oracle formalization to theorem transcript closure for GHL2025
Theorem `1 term robin`, at the proof granularity of the paper itself.

Boundary of the faithful target:

- Close the theorem route for the paper's own contribution under precise typed
  contracts for cited primitives.
- Do not spend this run proving the cited papers' full gate-level implementations
  of $O_D^{BS}$, $O_f$, derivative-amplitude state preparation, or standard
  LCU/block-composition.  Those are backlog contract-formalization tasks after
  the GHL2025 theorem transcript is closed.
- Do not count an external cited contract as a missing GHL2025 proof unless the
  contract statement is absent, ambiguous, or inconsistent with the GHL source.
- The previous run's focused `gamma3` endpoint audit used `j = 5` for
  `n = 3`, `K_1 = 2`, `K_2 = 5`.  This is a **bulk endpoint**, while the
  displayed `gamma3` line in Eq. `ROBIN clarified` explicitly writes the
  boundary branch `0 <= j < K_1` or `K_2 < j < 2^n` and hides the bulk branch in
  `+ ...`.  Do not treat the resulting indicator mismatch (`228` versus `84`)
  as a human projection convention before correcting this branch mismatch.
- The main open internal issue for the next batch is branch-correct transcript
  closure: prove or contract-map the displayed boundary branch using a boundary
  entry, then separately state the bulk branch omitted by `+ ...` using the
  `U_indic` bulk rule.  Only after branch-correct endpoints are in Lean should
  lower agents resume product-to-coefficient search.

The objective of the next 6-hour batch is:

1. Treat the source proof around Theorem `1 term robin`, Eq. `ROBIN clarified`,
   Fig. `1 term ROBIN`, Lemma `Banded-sparse-access-oracle`, Lemma
   `Sparse-amplitude-oracle for a banded-sparse matrix`, and Theorem
   `Amplitude-oracle for piece-wise polynomial function` as the active proof
   transcript.
2. Map that transcript to the existing Lean route
   `Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute`, reusing existing
   declarations instead of defining another route record.
3. State cited oracle/subroutine results as precise typed contracts and
   `SemanticObligation`s when QBE has not yet formalized the cited paper.  Then
   continue the GHL2025 theorem route conditionally on those contracts.  This
   run should not recursively formalize all cited papers before closing the
   GHL2025 transcript.
4. Push lower agents toward one fixed theorem-facing target at a time:
   theorem data, register layout, normalizer, target matrix, gate list, external
   oracle contracts, block-projection convention, and final false-obligation
   ledger.  Lower agents should not spend this batch on broad reusable APIs,
   article polish, or additional rejected-model guards unless a build failure
   requires it.
5. Promote a `proved` flag only when the corresponding Lean theorem is actually
   build-tested.  Otherwise keep the flag false and add the exact contract or
   cited dependency to the proof transcript.
6. Correct the finite-example focus before any lower product proof: boundary
   statements must use a boundary `j`, and bulk statements must use a bulk `j`
   together with the bulk term hidden in `+ ...`.  A branch mismatch is a
   planning error, not a source-contract gap.

For this batch, middle must begin each lower packet from a source-proof
translation table:

| Source item | Lean destination |
|---|---|
| Theorem `1 term robin` statement | `oneTermRobinBlockEncodingProofRoute` theorem data and block target |
| Eq. `ROBIN clarified` states $\gamma_1,\gamma_2,\gamma_3$ | theorem-transcript/gamma-route lemmas on the existing route |
| Displayed `gamma3` boundary branch | boundary-focused endpoint theorem, e.g. choose `j < K_1` or `K_2 < j` |
| Omitted `gamma3` bulk branch `+ ...` | separate bulk transcript theorem using `U_indic` indicator `1` |
| Fig. `1 term ROBIN` gate order | `oneTermRobinCircuit`, `circuitSemantics`, and gate-list matching lemmas |
| Lemma `Banded-sparse-access-oracle` | active global-slot `O_D^BS` contract plus cleanup obligation |
| Lemma `Sparse-amplitude-oracle for a banded-sparse matrix` | derivative-amplitude oracle contract |
| Theorem `Amplitude-oracle for piece-wise polynomial function` | `functionOracleSource` contract and cited-results entry |
| LCU/block-encoding composition used by the theorem | finite block-composition contract or explicit obligation |

Reviewer should reject cycles that only add another status/guard theorem while
leaving this table unmapped or disconnected from the existing route.
Reviewer should also reject cycles that redirect the main lower packet to
gate-level proof of a cited primitive before the paper-internal
projection/register convention is resolved or explicitly recorded as the next
source-backed contract.
Reviewer should reject any cycle that continues the old `j = 5` endpoint
`228` versus `84` product search without first classifying it as the omitted
bulk branch and introducing a separate boundary-focused target for the
displayed Eq. `ROBIN clarified` branch.

## Completed Correction Memory: O_D^BS Sparse Slots

Keep the following as active faithfulness memory, not as the main objective for
the next batch unless contract drift reappears.

The previous run treated the concrete theorem
`oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3` as evidence for a
paper-level unused-branch image gap.  The source audit now shows that this is
too strong: the collision is evidence against the current **row-dependent Lean
address model**, not against the paper theorem.

Paper anchors:

- Lemma `Diagonal sparsity`: the sparse index $s$ denotes a band/diagonal slot
  chosen from the first-row band pattern.
- Lemma `Banded-sparse-access-oracle`: the oracle uses
  $r_{si}=r_{s0}+i \bmod 2^n$ and maps
  $|0\rangle^{n-l}|s\rangle^l|i\rangle^n$ to
  $|r_{si}\rangle^n|i\rangle^n$.
- Remark `sparsity maximum`: the Robin heat example has $\kappa=7$ diagonal
  slots, including two boundary-effect diagonals.
- Before Theorem `1 term robin`: zeros may be included and the theorem sums
  over $s=0,\dots,\kappa-1$.

Faithful interpretation for this task:

- `O_D^BS` must use a global sparse-slot/diagonal-offset enumeration.
- Boundary or zero-amplitude entries should have coefficient value `0` in the
  amplitude layer; their sparse slots must not be deleted from the clean
  source domain and must not be folded to an identity address.
- `robinSparseColumnMap` may remain as a rejected-model or matrix-entry helper,
  but it must not be the active paper address for `O_D^BS` unless it is
  refactored to implement the global formula $r_{s0}+i \bmod 2^n$.
- The compiled collision witness should become a regression test for the old
  row-dependent model, not a blocker that lower agents keep trying to prove
  around.

This correction was implemented during the 2026-05-24 and 2026-05-25 runs.
Future lower packets should only revisit it when a theorem-facing target still
references the old row-dependent model:

1. Introduce a paper-faithful global diagonal-offset table for the one-term
   Robin $\kappa=7$ construction.
2. Define the paper address from that table, e.g. an address equivalent to
   $r_{s0}+i \bmod 2^n$.
3. Rewire `bandedSparseAccessPaperAddress`/`bandedSparseAccessPaperImage` to
   the global-slot model only after middle records the source-contract map.
4. Add tests showing that the old collision is absent in the corrected active
   image while the old row-dependent helper still has its rejected-model
   witness.
5. Only then resume injectivity, dagger cleanup, and unitarity proof work.

Do not spend the current run on writing polish or broad library organization.
The documentation updates required in this run are only the minimal
Lean/Markdown/LaTeX synchronization needed to keep the theorem transcript
human-checkable.

## Source

- Primary paper target: Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum
  framework for simulating linear PDEs with Robin boundary conditions",
  arXiv:2506.20478.
- Lean target: `QuantumBlockEncoding/CircuitSemantics.lean`
- Downstream target: `QuantumBlockEncoding/GHL2025.lean` and
  `QuantumBlockEncoding/RobinMatrix.lean`

Development may use local working copies of the paper, but public proof maps
must cite the paper, arXiv URL, theorem/lemma/equation/figure labels, or bundled
paper notes.  Do not cite machine-specific absolute source paths.

For local agent work, the GHL2025 TeX source should be archived in the shared
external paper store:

```text
../outer_papers/quantum/GHL2025/main.tex
```

If the source uses a different GHL/Guseynov folder name, set
`QBE_PAPER_SOURCE_ROOT` before generating run prompts.

This local source is for planning and source-contract audits only.  Public QBE
artifacts should cite arXiv:2506.20478 and stable paper anchors.

## Cited Results Discipline

If a GHL proof step invokes prior work or a standard theorem, record it in
`research-wiki/cited-results/GHL2025.md` before a lower agent relies on it.
The entry must state the source, the exact statement used, the Lean declaration
or planned declaration, the QBE status, and dependent proof blocks.

Do not close a GHL obligation merely because the paper cites a previous paper or
because a result is considered classical.  Until QBE has a build-tested Lean
proof or a typed contract, the dependency remains an obligation.  Reviewer must
check this ledger when auditing O_f, LCU/block-composition, state-preparation,
arithmetic subroutines, QSVT/LCU background, and sparse-oracle claims.

## Source Dependency Audit

When a faithful-paper proof block fails or becomes blocked, upper and middle
must inspect the local TeX source and bibliography around the paper statement
before assigning more lower-agent proof search.  Classify the missing
ingredient as one of:

- `internal-paper-step`: the paper states or proves it locally;
- `external-cited-result`: the paper relies on another paper or named
  subroutine;
- `classical-lean-lemma`: the missing item is ordinary arithmetic, linear
  algebra, or finite-map reasoning that QBE should formalize directly;
- `source-contract-gap`: the paper does not specify enough gate-level data for
  QBE's stricter oracle contract.

External or standard dependencies must be recorded in
`research-wiki/cited-results/GHL2025.md` with exact source, statement, Lean
status, and dependent proof blocks before lower agents rely on them.  Reviewer
must reject invented assumptions, unstated paper conditions, or vague
"standard result" shortcuts.

If the local TeX source contains a proof or proof sketch, middle must translate
that proof structure before lower agents continue.  Each source proof step must
be mapped to an existing Lean declaration, a planned local Lean lemma, an
external cited-results row, or an explicit source-contract gap.  Upper should
plan from this proof-translation map every cycle.

## Required Human-Facing Artifacts

Every cycle that changes Lean declarations must update at least one of:

- `conversion-windows/QBE-AUTO-001.md`
- `paper-notes/GHL2025_RobinOneTerm.tex`
- `proof-obligations/`

The point of faithful mode is not only to compile Lean, but to leave a readable
Markdown/LaTeX trail that explains which paper formula each Lean declaration
implements.

Middle-agent cycles must translate in both directions:

- paper/LaTeX-to-Lean before lower work, including exact registers, normalizer,
  clean ancillas, and expected matrix/block entries;
- Lean-to-Markdown/LaTeX after lower work, including what was proved, what
  failed, and what remains an obligation.

Markdown math style is strict: use `$...$` for inline math and `$$...$$` for
display math in `.md` files. Do not use backslash-parenthesis or
backslash-bracket math delimiters in Markdown. The `.tex` proof map may use
normal LaTeX delimiters.

## Proof Export Cadence

For token efficiency, do not require a polished proof export after every small
lower-agent lemma.  During overnight or 5-hour runs, lower agents may update
conversion windows and proof obligations locally.  At the end of the batch,
middle must export all newly accepted proof blocks into:

- `paper-notes/GHL2025/markdown/`
- `paper-notes/GHL2025/latex/main.tex`
- `paper-notes/GHL2025/latex/sections/`

The export should be mathematical writing, not a changelog: definitions first,
then theorem statements, then proof explanations tied to Lean declarations.
Reviewer should audit this export only once per batch unless a proof flag or
oracle contract changes.

## Project-Paper Cadence

The GHL2025 LaTeX proof export is not the final top-level paper by itself.  It
is a case-study appendix for the project article:

```text
Auto-Lean-in-Sleep: Block Encoding for Quantum Computing
```

The main article should explain the automation system for Lean-checked
gate-level block-encoding proof work: upper/middle/lower/reviewer roles,
trial memory, source-dependency audit, proof-attempt memory, and the difference
between faithful paper reproduction and exploratory oracle construction.
GHL2025 is the first detailed appendix case.

Writing cadence:

- During Lean-heavy 6-hour cycles, do not spend lower-agent time polishing the
  project article.
- Middle should keep only the minimal conversion-window/proof-obligation notes
  required for correctness and traceability.
- After the 6-hour Lean-heavy loop completes, the final upper/middle/reviewer
  audit may update the project-paper appendix map and figure todo list.
- Full article-writing, figure drafting, and Overleaf-style polish are separate
  writing batches after proof-state stabilization.

Design references for the article:

- YuanheZ/lean-stat-learning-theory: use as a style reference for Lean theorem
  paper organization, appendices, and Lean-code exposition.
- ARIS: use as a style reference for automation-system exposition and rich
  diagrams.
- Learning Beyond Gradients: cite and compare the hierarchical iteration and
  memory-loop idea.

## Current Starting Point

`CircuitSemantics.lean` now provides:

- `qubitDim`
- `SemanticObligation`
- `GateMatrix`
- `gateMatricesMatchCircuit`
- `evalGateMatrices`
- `CircuitMatrixSemantics`
- `BlockExtractionTarget`

These are intentionally small.  They are a foundation, not the final proof.

## Next Lean Targets

0. Correct the branch mismatch in the focused `gamma3` route.  The old
   endpoint pair `228` versus `84` came from using bulk `j = 5` against the
   displayed boundary branch of Eq. `ROBIN clarified`.  Reclassify that audit as
   an omitted-bulk-branch memory item, not a human projection convention.
1. Add a boundary-focused `gamma3` transcript target using a concrete boundary
   column (`j < K_1` or `K_2 < j`) so the clean indicator `0` in the displayed
   Eq. `ROBIN clarified` branch is branch-correct.
2. Add a separate bulk-focused `gamma3` transcript target for a bulk column
   such as `j = 5`, explicitly tied to the `+ ...` branch and the
   `U_indic` indicator `1` rule.  Do not force the bulk endpoint to equal the
   boundary clean endpoint.
3. Complete the source-proof translation table for Theorem `1 term robin` and
   Eq. `ROBIN clarified`, using the local TeX source for planning and public
   paper anchors for committed notes.
4. On the existing `oneTermRobinBlockEncodingProofRoute`, add or complete the
   smallest theorem-facing Lean declarations that assert the transcript is
   wired to:
   - the Robin target matrix;
   - normalizer $\mathcal{N}_D\mathcal{N}_f\kappa$;
   - ancilla count $\lceil\log_2 n\rceil+\lceil\log_2 G_f\rceil+
     \lceil\log_2\kappa\rceil+4$ and the stated pure ancilla ledger;
   - Fig. `1 term ROBIN` gate order;
   - Eq. `ROBIN clarified` gamma-state route;
   - external `O_D^BS`, derivative-amplitude, `O_f`, and LCU contracts.
5. If a missing ingredient is from a cited result, create or refine the typed
   contract and cited-results entry, then continue the GHL theorem route
   conditionally on that contract.  Do not stall this batch by recursively
   proving the cited paper.
6. If a missing ingredient is local finite arithmetic, projection indexing, or
   matrix multiplication bookkeeping, make it a narrow lower-agent Lean target
   and run `lake build && lake build Tests`.
7. Keep all unproved semantic claims as obligations with `proved := false`.
   The output is successful only if the faithful transcript is more connected
   to the Lean route than at the start of the batch.

## Non-Goals

- Do not invent a new block encoding.
- Do not mark `RobinProofObligations` as proved.
- Do not use `Prop := True`, `trivial`, or `sorry` to close semantic gaps.
- Do not replace the paper's circuit by a different construction unless the
  reviewer explicitly records it as an exploratory-mode branch.
- Do not prove unitarity or block extraction for a simplified Lean oracle
  contract that does not match the paper's register-level transformation.

## Acceptance Gate

```bash
python3 tools/qbe.py check
rg -n "Prop := True|:= trivial|sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|\\bsorry\\b" QuantumBlockEncoding Tests -g '!QuantumBlockEncoding/Automation.lean' || true
```

The run is successful only if Lean builds and the Markdown/LaTeX correspondence
has been updated for the semantic declarations added in that cycle.

## Immediate 6h Focus: Close the Prepared Projection Backend

This batch is Lean-heavy faithful-paper reproduction.  Do not spend lower-agent
time creating broad new process notes, new alternative theorem routes, or large
educational rewrites.  The current reviewer-approved obstruction is exactly:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

Upper agent:

- Treat the above equality as the only primary target.
- Before assigning lower work, re-read the source proof context for Theorem
  `1 term robin`, Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, and Fig.
  `1 term ROBIN`.
- Decide whether the equality is just finite matrix/projection bookkeeping
  already encoded in QBE, or whether the paper is implicitly invoking the
  sparse-state-preparation convention for $H_W^{(\kappa)}$.
- Do not redirect this batch into Shukla--Vedula recursion, generic LCU
  formalization, bulk `j = 5`, or Ry-convention audit unless the source proof
  directly forces it.

Middle agent:

- Keep the conversion/proof-obligation notes minimal and synchronized.
- Translate only the relevant source-proof fragment into the Lean target and
  translate back only the newly accepted Lean theorem or the exact smaller
  obstruction.
- Do not polish the project article or appendix during this batch.
- In Markdown, use `$...$` and `$$...$$`; do not use backslash math delimiters.

Lower agent:

- Work only in the narrow files needed for the target, normally
  `QuantumBlockEncoding/RobinMatrix.lean`, a small generic helper in
  `QuantumBlockEncoding/CircuitSemantics.lean` if unavoidable, and focused
  checks in `Tests/Basic.lean`.
- Prefer proving a direct finite-fold/projection lemma over adding another
  record that merely names the same obstruction.
- If the equality cannot be closed, the acceptable fallback is a strictly
  smaller compiled lemma identifying the exact missing term in the prepared
  projection backend.  Do not add parallel obstruction hierarchies.
- Keep `productToCoefficientProved`, `lcuCorrectProved`, `blockCorrectProved`,
  `normalizedBlockEqualityProved`, `circuitUnitarityProved`, and
  `finalExtractionProved` false unless Lean directly proves them.

Reviewer:

- Reject new out-of-scope edits whose main effect is more documentation or
  another restatement of the same obstruction.
- Accept only if the run either proves the displayed equality, or reduces it to
  a genuinely smaller theorem with a build-tested Lean declaration.
- Audit that the paper source was used faithfully: no added assumptions, no
  invented oracle conditions, and no promotion of theorem-facing flags without
  compiled proof.

## Immediate 6h Focus: Source-Correct Prepared Projection Route

This directive supersedes the previous "prove the H-free active entry fold"
focus.  After re-reading the local source proof around Theorem
`theorem: 1 term robin`, Eq. `ROBIN clarified`, Eq. `arbitrary sparcity`, and
Fig. `fig:1 term ROBIN`, the correct faithful-paper route is:

1. `H_W^(kappa)` prepares the sparse register as in Eq. `arbitrary sparcity`.
2. The Fig. `1 term ROBIN` seven-gate product acts on the prepared sparse
   register and produces the `gamma_3` coefficient in Eq. `ROBIN clarified`.
3. The block-encoding projection from Definition `def:block-encoding` selects
   the prepared clean output, not the H-free seven-gate active entry by itself.

Therefore, the next batch must stop trying to prove the H-free active equality

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3)
=
Coeff.evalWith env
  (blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

as the primary theorem.  That equality is useful only as a diagnostic if the
active seven-gate matrix has already been source-prepared, which the current
Lean guard `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` shows is
not the case.

Primary target for this batch:

- Make the theorem-facing focused block/projection route use the prepared
  singleton clean entry
  `(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3`
  or the equivalent prepared sparse-matrix clean entry.
- Use the already compiled bridge
  `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`
  under the explicit contract
  `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` to
  prove the source-correct evaluated backend fold.
- If possible, route the focused `gamma_3` product-to-coefficient statement
  through this prepared projection target.  If not possible, add only the
  smallest missing route lemma and keep all theorem-facing flags false.

Source/background classification for agents:

- GHL2025 own contribution: the Robin boundary seven-gate construction,
  `gamma_1`/`gamma_2`/`gamma_3` coefficient bookkeeping, normalizer
  `N_D * N_f * kappa`, ancilla ledger, and resource count.
- External contract: Shukla--Vedula uniform superposition gives only the
  clean-column amplitude shape and `O(log kappa)` cost for `H_W^(kappa)`.
  Do not recursively formalize it in this batch.
- External/standard contract: LCU and block-composition are downstream
  contracts.  Do not use them to prove the local prepared projection entry.
- QBE-local work: finite matrix/projection bookkeeping that connects the
  source-prepared singleton clean entry to the branch fold and then to the
  focused product route.

Upper agent:

- Start from the prepared projection route above, not from the H-free active
  equality.
- Treat `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` as a guard
  that prevents false closure of the active route.
- Assign lower work to change the theorem-facing route, not to add another
  obstruction record.

Middle agent:

- Update the conversion window so the active H-free equality is marked
  "diagnostic/backlog" and the prepared singleton clean-entry route is marked
  "source-correct active route".
- Keep Markdown/LaTeX notes minimal: definitions first, theorem statement,
  source-proof map, and remaining obligations.
- Do not polish the project paper during this Lean-heavy batch.

Lower agent:

- Prefer direct theorem declarations over new records.
- Work in `QuantumBlockEncoding/RobinMatrix.lean` and focused
  `Tests/Basic.lean`; touch `CircuitSemantics.lean` only for a genuinely
  reusable finite-matrix helper.
- First try to prove a theorem of the form:

```lean
theorem ... (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H) :
    Coeff.evalWith env
      ((oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix
        oneTermRobinGamma3BoundarySparseCleanIndex_n3
        oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
    Coeff.evalWith env
      (blockExtractionBranchContributionSum
        oneTermRobinGamma3BoundaryBackendBranchContribution_n3)
```

  if the exact theorem is already present, route it into the focused
  product-to-coefficient proof map instead of duplicating it.
- Keep `productToCoefficientProved`, `lcuCorrectProved`,
  `blockProjectionProved`, `blockCorrectProved`, `normalizedBlockEqualityProved`,
  `circuitUnitarityProved`, and `finalExtractionProved` false unless Lean
  directly proves the corresponding theorem.

Reviewer:

- Reject a cycle that again spends its main effort on proving the H-free active
  equality without explaining why this matches Eq. `arbitrary sparcity`.
- Accept if the theorem-facing route is corrected to the prepared singleton
  clean entry and the prepared backend fold is build-tested under the explicit
  `H_W^(kappa)` clean-column contract.

## Automation Control: Avoid Full-Stack Token Waste

The current target is fixed enough for focused proof-burst mode.  A full
upper/middle/lower/reviewer cycle is useful when the source route is unclear;
it is too expensive when the remaining target is one Lean theorem.

## LeanMarathon-Style Blueprint Control Update

Before the next long run, refresh the QBE proof blueprint:

```bash
python3 tools/qbe.py blueprint-refresh QBE-AUTO-002
```

The latest focused burst reported that
`oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3` and
its focused product-map wrappers are already compiled and already tested.  This
means the next upper/middle checkpoint must retire the stale lower packet
"prove the prepared clean-entry backend fold" before more proof-search tokens
are spent.

The next dynamic leaf should be the smallest theorem-facing wrapper that is not
already compiled, such as the route from the prepared backend fold into the
focused `gamma_3` product-to-coefficient theorem, or a precise proof-obligation
row explaining why that wrapper cannot yet be stated without a missing
projection/summation interface.

Reviewer should treat this as a LeanMarathon-like target-review checkpoint:
the system must stabilize the active leaf before lower-only focused proof
bursts continue.

For the next automated run, prefer:

- `--context-mode focused`;
- `--blueprint-refresh`;
- lower every cycle;
- upper, middle, and reviewer every 6 cycles, or sooner only if Lean fails or
  lower reports a source-contract mismatch;
- `--check-each-cycle` so the Lean gate still runs every cycle.

The lower target remains the source-correct active/prepared selected-entry
equality:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

Equivalent wrappers are
`(oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env).activeToPreparedSingletonEvalStatement`
and
`(oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env).activePreparedCompositeEvalStatement`.
The H-free backend expansion may be used only as a recovery lemma for the
prepared route.  Do not spend a focused proof burst adding more process notes,
new route records, or repeated statements of the same obstruction.

## Immediate 6h Focus: Active/Prepared Composition Closure (2026-06-07)

This is the active directive for the next active-time theorem-closure run.  It
supersedes all earlier `Immediate 6h Focus` sections in this task file.

Target exactly one theorem family:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
```

preferably through the equivalent reduced target:

```lean
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

This is the missing active/prepared selected-entry equality needed by the
already compiled source-correct route
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

Use a two-lower-agent population:

- lower 1 is the natural-language proof architect.  It should translate the GHL
  source proof and the current Lean DAG into a dependency-ordered proof plan,
  naming existing declarations and the smallest new intermediate lemma.
- lower 2 is the Lean implementation worker.  It should implement that smallest
  theorem/lemma, run `python3 tools/qbe.py check`, and record useful failed
  routes under `proof-attempts/`.

Required proof-DAG frontier for this run:

| Node | Interface | Dependencies | Owner | Status |
|---|---|---|---|---|
| `GHL-root-active-prepared` | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` or uncast equivalent | evaluated backend bridge plus selected-entry expansion | upper/middle | root, do not attack directly unless all leaves below are proved |
| `GHL-two-path` | reduce the seven-gate selected entry to the two surviving paths through indices `96` and `97` | compiled support lemmas for the suffix/prefix split | lower 2 | mostly compiled; retire stale duplicates |
| `GHL-suffix-96-97` | prove/evaluate suffix entries `[0,96]` and `[0,97]` against the coefficient-oracle rows used by the paper branch | support lemmas and gate definitions | lower 2 | partially compiled |
| `GHL-prefix-96-97` | prove/evaluate prefix entries `[96,0]` and `[97,0]` as the boundary rotation factors | `Ry` convention audit, gate definitions, index support | lower 1 then lower 2 | active leaf candidate |
| `GHL-oracle-coeff-entries` | prove/evaluate `O_f[12,96]` and `O_f[12,97]` as the source coefficient factors | paper coefficient-oracle contract, cited-results status | middle then lower 2 | active leaf candidate |
| `GHL-backend-fold-compare` | combine the two-path expansion and compare it to the evaluated backend fold | all entry lemmas above | lower 2 | blocked until active leaves close |

Agent rule for this frontier:

- lower 1 should first write the natural-language proof map for
  `GHL-prefix-96-97` or `GHL-oracle-coeff-entries`, including definitions,
  source anchors, existing Lean declarations, and the exact next Lean lemma.
- lower 2 should then implement exactly one of those leaves.  It should not
  attack `GHL-root-active-prepared` directly unless middle marks all dependency
  nodes proved.
- middle must update the DAG table when a node becomes proved, stale, blocked
  internal, blocked external, or contract drift.
- reviewer must reject cycles that merely restate the root theorem, duplicate a
  compiled two-path route, or omit the natural-language-to-Lean dependency map.

Allowed mathematical route:

1. Reduce the active/prepared statement to the uncast form using the compiled
   equivalence.
2. Compare the raw active seven-gate selected entry with the prepared sandwich
   clean entry under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`.
3. Reuse the prepared clean-entry backend bridge already compiled in
   `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3`.
4. If direct HWKappa use is blocked, use the column-0 support lemmas as a
   fallback, but do not restart the frozen H-free raw fold as the main route.

Non-goals:

- Do not prove `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3` as a
  standalone H-free theorem this batch; it is diagnostic/backlog unless routed
  through the prepared projection target.
- Do not recursively formalize Shukla--Vedula, LCU, or block-composition.
- Do not add assumptions, replace the paper circuit, or promote semantic flags.
- Do not spend the cycle on project-paper polish or broad library refactors.

Success means a sorry-free proof of the active/prepared theorem or a strictly
smaller compiled theorem that the next Lean worker can use directly.

## Immediate 6h Focus: Source-Faithful Fig. 4 Transcript And EvalWith Bridge (2026-06-08 Active)

This is the active directive for the next active-time theorem-closure run.  It
supersedes the 2026-06-07 active/prepared directive above.

The current blocker is source transcript fidelity plus one semantic entry
bridge, not broad external-oracle formalization.  The source anchors are:

| Source | Role |
|---|---|
| `main.tex:1098-1109` | Theorem `1 term robin`, target block-encoding claim |
| `main.tex:1111-1119` | Eq. `ROBIN clarified`, especially the `gamma_3` clean coefficient |
| `main.tex:1122-1164` | Fig. `1 term ROBIN`, full theorem-facing gate order and cleanup |
| `main.tex:948-955` | `H_W^(kappa)` sparse-register preparation contract |
| `main.tex:2027-2035` | block-encoding projection definition |

Objective for this batch:

1. Correct the theorem-facing Fig. 4 transcript before further proof search.
   Add an explicit `U_indic^dagger` gate slot.  If the matrix is equal to
   `U_indic` because the indicator permutation is self-inverse, record that as
   a Lean lemma or explicit bridge, but keep the gate label and circuit role
   faithful to the paper.
2. Keep the two `H_W^(kappa)` sides visible as theorem-facing boundary gates
   or as a clearly named prepared-sandwich contract.  Do not claim the full
   Fig. 4 circuit from a seven-gate active product that omits those sides.
3. Distinguish pre-SWAP `O_{D^T}^{BS}` from post-SWAP `(O_D^{BS})^dagger` in
   the conversion window, proof notes, and any Lean labels introduced this
   batch.
4. Demote the raw symbolic `Coeff` constructor-equality route to
   diagnostic/backlog.  The active proof route is an `evalWith` semantic entry
   bridge.

After the transcript correction, lower agents may target one of:

```lean
oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
```

or a strictly smaller theorem that directly feeds
`oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Produce a proof-DAG packet translating `main.tex:1098-1164` into source line, Lean declaration, existing lemma, missing lemma, and dependency class (`GHL-internal`, `external-cited-contract`, `QBE-local semantic bridge`). |
| lower 2: Lean implementation worker | Implement exactly one ready Lean leaf from that packet: preferably `U_indic^dagger` transcript correction, `H_W` prepared-boundary naming, or the smallest `evalWith` bridge. |

Reviewer checklist:

- Reject any cycle that keeps the old raw `Coeff` equality as the main theorem.
- Reject any claim that the full GHL Fig. 4 circuit is formalized while
  explicit `U_indic^dagger` or the two `H_W^(kappa)` sides are absent from the
  theorem-facing transcript.
- Reject promotion of ODBS/ODTS/O_f/H_W/R_y contract flags without a Lean theorem
  and source/citation row.
- Require the generated Chinese cycle summary at
  `paper-notes/GHL2025/markdown/cycle-summaries/latest.md` to expose source
  lines, Lean status, and remaining obligations.

Non-goals:

- Do not recursively formalize Shukla--Vedula, Gilyén et al., LCU, or the prior
  PDE sparse-access paper in this batch.
- Do not work on the 1D Hamiltonian theorem, multidimensional theorem, QSVT, or
  project article polish until the one-term Robin theorem-facing route is
  closed under cited contracts.
- Do not add assumptions, weaken the target, or replace the paper oracle.

## Current Run Directive: 2026-06-09 Source-Prepared Backend Frontier

This directive supersedes the 2026-06-08 batch directive for the next lower
packet.  The Fig. 4 transcript correction, explicit `U_indic^dagger` role, and
prepared `H_W^(kappa)` boundary route are now compiled as transcript and route
guards.  The theorem-facing route remains open because the finite
active/prepared entry equality or an equivalent backend-expansion theorem is
still unproved.

Use the following compiled inputs:

| Declaration | Status |
|---|---|
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | compiled transcript guard with both `H_W` sides and explicit `U_indic^dagger` label |
| `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled bridge explaining why the dagger slot may use the same indicator matrix |
| `oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3 H env hUniform` | compiled prepared clean-entry backend fold under the external clean-column contract |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3 H env hUniform` | compiled theorem-facing prepared projection backend bridge |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_evaluatedBackendFold_n3 H env hUniform` | compiled equivalence; neither side is proved |
| `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3 H hUniform hEntry` | compiled conditional bridge from a future generic prepared-entry equality to backend expansion |

The next lower work is one local proof node:

1. Prefer the source-prepared alias leaf
   `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3`
   if middle wants a stable theorem name for the already compiled prepared
   clean-entry backend bridge.
2. If proving new mathematics, target exactly
   `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
   or a strictly smaller finite matrix-entry lemma feeding it.
3. Treat `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
   as an equivalent recovery leaf only through the compiled
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`
   bridge.
4. Retire the H-free eval leaf, column-0 two-path diagnostic, raw `Coeff`
   equalities, finite active/prepared composition guard, and backend-expansion
   bridge rediscovery as lower targets.
5. Lower 1 should reuse
   `proof-attempts/QBE-AUTO-002/source-faithful-prepared-route-correction-20260609-181431-lower1.md`
   and add only a narrow addendum if the selected theorem statement changes.
6. Lower 2 must edit only `QuantumBlockEncoding/RobinMatrix.lean` and must not
   change oracle contracts, theorem hypotheses, normalizers, or the paper
   circuit.
7. The accepted bridge from a future generic prepared-entry equality to
   backend expansion is
   `oneTermRobinGamma3BoundaryBackendExpansionStatement_of_activePreparedEntryTarget_n3`;
   rediscovering it is stale work.
8. The generated Chinese summary and project-article update must report that
   the one-term theorem is still open and that the current progress is only
   transcript/route wiring plus conditional bridges.
9. The gate for any Lean edit remains `python3 tools/qbe.py check`, then
   `lake build`, then `lake build Tests`.
10. No external primitive is formalized in this packet; all Shukla--Vedula,
    LCU, oracle, and block-composition rows remain contract-only obligations.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/source-faithful-prepared-route-correction-20260609-181431-lower1.md`; add only a narrow addendum if the selected entry target changes. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`, implement one selected leaf above, and run `python3 tools/qbe.py check`, `lake build`, and `lake build Tests`. |

No ODBS, ODTS, `O_f`, `H_W`, `R_y`, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, or final-extraction flag may be promoted from this packet.

## Current Run Directive: 2026-06-09 Source-Prepared Branch-Sum Frontier

This directive supersedes the previous source-prepared clean-entry packet for
the next lower work item. The theorem-facing Fig. 4 transcript guard, explicit
`U_indic^dagger` role, prepared `H_W^(kappa)` boundary route, and
`oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3`
alias are now compiled. The alias is stale as a lower target.

The remaining local theorem content is the finite projection/backend branch-sum
expansion:

```lean
oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
  oneTermRobinGamma3BoundaryBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

This is route-equivalent to
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
by `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3`.

Next lower work:

1. Lower 1 should reuse
   `proof-attempts/QBE-AUTO-002/source-prepared-branch-sum-dag-20260609-1835-lower1.md`
   and add only a narrow addendum if the selected theorem name changes.
2. Lower 2 must edit only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly the proposed branch-sum leaf
   `oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3`, or close
   the equivalent backend-expansion statement through the compiled branch-sum
   equivalence.
4. Retire the compiled source-prepared clean-entry alias, arbitrary-`H`
   generic prepared-entry target, H-free `evalWith` route, column-0 diagnostics,
   raw `Coeff` constructor equalities, finite active/prepared guard, and
   rediscovery of compiled conditional bridges as lower targets.
5. The generated Chinese summary and project-article update must state that
   the one-term theorem is still open; the cycle has only transcript guards,
   source-prepared route wiring, conditional bridges, and a branch-sum frontier.
6. The gate remains `python3 tools/qbe.py check`, then `lake build`, then
   `lake build Tests`.

No external primitive is formalized in this packet; all Shukla--Vedula, LCU,
oracle, and block-composition rows remain contract-only obligations.

## Current Run Directive: 2026-06-10 Branch-Sum Leaf Closure And Article-Facing Audit

This directive supersedes the 2026-06-09 branch-sum frontier.  The next
active-time batch should spend proof-search effort only on the remaining local
finite projection/backend branch-sum leaf for the first case study.  Do not
restart broad oracle formalization or project-wide refactoring.

Active Lean target:

```lean
oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_n3
```

Equivalent target, if it is easier through the compiled bridge:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

using:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3
```

Current compiled context:

| Declaration | Status |
|---|---|
| `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList` | compiled theorem-facing transcript guard with both `H_W` sides and explicit `U_indic^dagger` role |
| `GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge` | compiled bridge justifying that the dagger slot can use the indicator matrix while keeping the paper circuit role explicit |
| `oneTermRobinGamma3BoundarySourcePreparedCleanEntryEval_eq_backendFold_n3` | compiled safe alias for the prepared clean-entry backend fold route |
| `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3` | compiled equivalence between the branch-sum leaf and the backend-expansion formulation |

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Write a narrow proof-DAG addendum for the branch-sum leaf only.  It should say which terms survive, which vanish, which existing Lean declarations justify each step, and whether each ingredient is GHL-internal, cited-contract, or QBE-local matrix semantics. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the branch-sum leaf or one strictly smaller lemma that feeds it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, or the paper circuit. |

Middle-agent duties for this batch:

1. Keep the conversion window and proof-obligation ledger synchronized with the
   branch-sum proof-DAG.  Retire stale lower targets explicitly.
2. Generate the Chinese human audit page at:

   ```text
   paper-notes/GHL2025/markdown/cycle-summaries/latest.md
   ```

   and archive it under:

   ```text
   paper-notes/GHL2025/markdown/cycle-summaries/<run-id>.md
   ```

   The Chinese audit page may mention local TeX source line ranges because it
   is an internal human-control artifact.
3. Update the project article bridge after the batch.  The generated status
   must be mirrored into:

   ```text
   ../Auto_Proof_Papers/ABEIS/appendix/generated_cycle_status.tex
   ```

   and included by the ABEIS `main.tex`.  If this batch closes a stable theorem
   or changes a stable system lesson, update only the relevant included report
   section, such as `main/ghl_case_study.tex`, `main/evidence.tex`, or
   `appendix/ghl_correspondence.tex`.
4. The public ABEIS report must be readable by the original paper authors and
   by non-agent-system readers.  Use citations, theorem/equation/figure names,
   and prose descriptions.  Do not write local source line anchors such as
   `main.tex:1098-1164` in the public report or its generated appendix.

Reviewer checklist:

- Reject any cycle that changes the target theorem, adds assumptions, changes
  the normalizer, or treats a cited oracle primitive as proved without a named
  Lean theorem and source/citation row.
- Reject any cycle that works on raw symbolic `Coeff` matrix equality as the
  main route instead of the `Coeff.evalWith`/branch-sum semantic route.
- Reject any claim that the first-case-study one-term block-encoding theorem is
  complete while the theorem-facing root or any corresponding `sorry` remains.
- Confirm that `python3 tools/qbe.py check`, `lake build`, and
  `lake build Tests` pass after Lean edits.
- Confirm that the Chinese summary path above and the ABEIS generated appendix
  are updated.  The Chinese summary may cite local TeX line ranges; the public
  article must not.

Success for this 6h active-time batch means one of:

1. the branch-sum leaf is proved and the root proof-DAG frontier advances to
   the next named dependency; or
2. a strictly smaller compiled lemma is produced, with a proof-DAG addendum
   showing exactly how it feeds the branch-sum leaf in the next cycle.

Do not spend lower-agent time on prose polish.  Article updates are a
middle/reviewer end-of-cycle synchronization task and must only report what the
Lean gates, proof notes, source anchors, and explicit obligations support.

## Current Run Directive: 2026-06-10 Full-Unitary Fold Frontier And Generated Frontier Repair

This directive supersedes the branch-sum leaf packet for the next lower proof
attempt.  The bridge
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_unitaryEntryFold_n3`
is compiled, so the direct branch-sum wrapper is no longer the implementation
target.  The active local theorem is the full signal-zero unitary-entry fold:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The equivalent backend-expansion endpoint remains:

```lean
oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement
```

through:

```lean
oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3
```

The prepared clean-entry bridge
`oneTermRobinGamma3BoundarySignalBlockEntry_eq_backendBranchSum_iff_preparedCleanEntry_n3`
is useful only under the existing $H_W^{(\kappa)}$ clean-column contract; it
does not prove the fold or promote any external primitive.

Next lower work:

1. Lower 1 reuses
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`
   and adds only a narrow addendum if the selected theorem name changes.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean` and proves the
   `FullUnitaryFold` equation displayed above or the equivalent
   backend-expansion statement.
3. A strictly smaller named leaf is acceptable only if it directly feeds the
   full-unitary fold, for example an uncast active-entry fold lemma or a
   seven-slot support, vanish, or cancellation lemma.
4. Retire the branch-sum wrapper, conditional feeders, source-prepared
   clean-entry alias, arbitrary-`H` entry theorem, H-free `evalWith` route,
   column-`0` diagnostics, raw `Coeff` constructor equalities, and rediscovery
   of compiled bridges as lower targets.
5. The gate remains `python3 tools/qbe.py check`, then `lake build`, then
   `lake build Tests`.

Middle must repair generated frontier extraction so the Chinese cycle summary,
project article update, and ABEIS generated appendix name `unitary_fold_leaf`
as open and do not reprint branch-sum checklist text as the current proof-DAG
frontier.  The generated Chinese audit page may mention local TeX line ranges;
the public ABEIS report and generated appendix must use theorem, equation,
figure, citation, and Lean declaration names rather than local source-line
anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Directive: 2026-06-11 Post-Bridge Evaluated Backend Fold Frontier

This directive supersedes the post-feeder active/prepared composition packet
for the next lower proof attempt. Lower 2 has compiled the post-feeder bridge

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
```

which proves that, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
exact unwrapped active/prepared sparse-clean `evalWith` equality is equivalent
to:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The bridge is now stale as a lower target. The first-case-study one-term
theorem remains open.

Next lower work:

1. Lower 1 may append only a narrow postscript to Section 21.15 of
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`,
   naming the compiled bridge above and retiring it as a target.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, the
   exact unwrapped active/prepared sparse-clean equality exposed by the
   bridge, or one strictly smaller theorem that directly feeds one of these
   statements.
4. Retire the strict prepared-sparse feeder, the new sparse-clean-to-fold
   bridge, finite active/prepared reduction guards, H-free active-selected
   diagnostics, backend slot vanish/support work, raw `Coeff` constructor
   equalities, branch-sum wrappers, and compiled bridge rediscovery.
5. If the obstacle is the arbitrary-`H` route shape rather than a tactic gap,
   record typed verifier feedback as `source_translation_gap` or
   `shape_or_register_gap`; do not add hypotheses or change the paper circuit.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Generated Chinese summaries, the project article update, and the ABEIS
generated appendix must say that the first-case-study one-term theorem is
still open. This packet only narrows the source-prepared matrix-entry frontier
after one compiled equivalence bridge.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.

## Immediate 6h Focus: Post-Bridge Evaluated Backend Fold Frontier (2026-06-11)

This directive supersedes the post-feeder active/prepared composition packet
for the next lower proof attempt. Lower 2 has compiled the post-feeder bridge

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
```

which proves that, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
exact unwrapped active/prepared sparse-clean `evalWith` equality is equivalent
to:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The bridge is now stale as a lower target. The first-case-study one-term
theorem remains open.

Next lower work:

1. Lower 1 may append only a narrow postscript to Section 21.15 of
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`,
   naming the compiled bridge above and retiring it as a target.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, the
   exact unwrapped active/prepared sparse-clean equality exposed by the
   bridge, or one strictly smaller theorem that directly feeds one of these
   statements.
4. Retire the strict prepared-sparse feeder, the new sparse-clean-to-fold
   bridge, finite active/prepared reduction guards, H-free active-selected
   diagnostics, backend slot vanish/support work, raw `Coeff` constructor
   equalities, branch-sum wrappers, and compiled bridge rediscovery.
5. If the obstacle is the arbitrary-`H` route shape rather than a tactic gap,
   record typed verifier feedback as `source_translation_gap` or
   `shape_or_register_gap`; do not add hypotheses or change the paper circuit.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Generated Chinese summaries, the project article update, and the ABEIS
generated appendix must say that the first-case-study one-term theorem is
still open. This packet only narrows the source-prepared matrix-entry frontier
after one compiled equivalence bridge.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.

## Current Run Directive: 2026-06-11 Post-Feeder Active/Prepared Composition Field Frontier

This final directive supersedes the prepared-sandwich semantics gap packet and
all earlier active-side packets. The strict feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`
is compiled and retired as a lower target. The next lower work is the
unwrapped active/prepared equality exposed by that feeder:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Equivalent acceptable targets are
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`,
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`,
or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.
Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`; lower 1 may append
only a narrow proof-DAG postscript. Retire the strict feeder, H-free
active-selected diagnostics, backend slot vanish/support work, raw `Coeff`
routes, branch-sum wrappers, and compiled bridge rediscovery. The first-case
study one-term theorem remains open, and no oracle, `H_W`, `R_y`, LCU,
projection, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted.

## Current Run Directive: 2026-06-11 Post-Feeder Active/Prepared Composition Field Frontier

This directive supersedes the prepared-sandwich semantics gap packet for the
next lower proof attempt. Lower 2 has compiled the strict prepared-matrix
feeder

```lean
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3
```

so that feeder itself is now stale as a lower target. It proves only that the
named prepared-sandwich evaluated target is equivalent to comparing the active
seven-gate `[0,0]` evaluated entry with
`oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H` at the
clean-clean sparse index. The full prepared-sandwich equality, the active to
prepared matrix-entry field, the theorem-facing projection/backend fold, and
the one-term Robin theorem remain open.

The next precise objective is the unwrapped active/prepared composition field:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Equivalent acceptable targets are:

```lean
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

or one strictly smaller theorem that directly supplies this active/prepared
composition field. The smaller theorem must not change the paper circuit, the
normalizer, the `H_W` clean-column contract, or any oracle contract.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3 H env` | compiled strict feeder; retired as lower target |
| `oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_sparseEval_n3 H env` | compiled prepared singleton/sparse clean-entry alignment |
| `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3 H env` | compiled bridge from the uncast active/prepared target to the prepared-sandwich statement |
| `oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3 H env` | compiled gap record naming the missing finite composition field |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3 H env` | compiled wrapper/cast removal for the source-prepared projection target |
| `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` | external clean-column contract only; do not formalize Shukla--Vedula here |

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse Section 21.13 of `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow post-feeder note naming the unwrapped active/prepared equality above and retiring the strict feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove exactly the unwrapped active/prepared equality, one equivalent target above, or one smaller theorem that feeds it directly. Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, the paper circuit, or the `H_W` clean-column contract. |

Retired lower targets remain retired: the strict prepared-sparse feeder,
prepared clean-entry aliases, H-free active-selected diagnostics, selected-slot
backend-fold reduction, all backend slot vanish/support work, raw `Coeff`
constructor equalities, branch-sum wrappers, and compiled bridge rediscovery.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Generated Chinese summaries, the project article update, and the ABEIS
generated appendix must say that the first-case-study one-term theorem is still
open. This packet only narrows the source-prepared matrix-entry frontier after
one compiled feeder.

## Previous Run Directive: 2026-06-11 Prepared-Sandwich Semantics Gap Frontier

This directive supersedes the post-selected-slot active-uncast eval packet for
the next lower proof attempt. The latest lower feedback compiled the diagnostic
obstruction
`oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`
and classified the direct H-free `ActiveSelectedSlotEvalComparison` route as a
`shape_or_register_gap` unless a new source-faithful active path is found. Do
not keep spending lower proof search on that H-free comparison by default.

The next precise objective is the source-prepared matrix-entry semantics gap
for the paper's $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich, under the
already explicit clean-column contract:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Active Lean-facing targets are:

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
```

or a strictly smaller theorem that directly supplies the missing prepared
matrix field named by
`(oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H).missingPreparedMatrixField`.
An acceptable equivalent stronger leaf is the raw prepared-sandwich field:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

but only if it returns through the compiled prepared-sandwich bridge and keeps
`HUniform` contract-only.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H` | compiled transcript for the gap; records that the active seven-gate list omits both $H_W^{(\kappa)}$ sides |
| `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | compiled guard that the active placeholder list is H-free |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3 H env` | compiled mismatch witness exposing the uncast active left side and prepared-sandwich right side |
| `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3 H env hUniform` | compiled equivalence under the existing all-slot clean-column contract; proves neither side |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3 env hDiagnostic hActiveSelected` | compiled diagnostic obstruction; retired as lower target |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env` | compiled route packaging; retired as lower target |
| `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | compiled selected-slot backend-fold feeder; retired as lower target |

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow prepared-sandwich postscript. It must retire the H-free active-selected comparison as the default target, state the source fragment for $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$, and name the prepared-sandwich field or raw-field feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`, the raw prepared-sandwich field, or one strict prepared-matrix feeder named by the gap record. Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, the paper circuit, or the `H_W` clean-column contract. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free active selected-slot comparison as
the default target, raw `Coeff` constructor route, compiled bridge rediscovery,
selected-slot backend-fold reduction, all nonselected slot vanish/support work,
and the diagnostic seven-gate zero route.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet only records a shape/register reroute from the H-free
diagnostic path to the prepared-sandwich semantics gap. The public ABEIS report
must use theorem, equation, figure, citation, and Lean declaration names rather
than local source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-11 Prepared-Sandwich Semantics Gap Frontier

This directive supersedes the post-selected-slot active-uncast eval packet for
the next lower proof attempt. The latest lower feedback compiled the diagnostic
obstruction
`oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`
and classified the direct H-free `ActiveSelectedSlotEvalComparison` route as a
`shape_or_register_gap` unless a new source-faithful active path is found. Do
not keep spending lower proof search on that H-free comparison by default.

The next precise objective is the source-prepared matrix-entry semantics gap
for the paper's $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich, under the
already explicit clean-column contract:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Active Lean-facing targets are:

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
```

or a strictly smaller theorem that directly supplies the missing prepared
matrix field named by
`(oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H).missingPreparedMatrixField`.
An acceptable equivalent stronger leaf is the raw prepared-sandwich field:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

but only if it returns through the compiled prepared-sandwich bridge and keeps
`HUniform` contract-only.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H` | compiled transcript for the gap; records that the active seven-gate list omits both $H_W^{(\kappa)}$ sides |
| `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | compiled guard that the active placeholder list is H-free |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3 H env` | compiled mismatch witness exposing the uncast active left side and prepared-sandwich right side |
| `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3 H env hUniform` | compiled equivalence under the existing all-slot clean-column contract; proves neither side |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3 env hDiagnostic hActiveSelected` | compiled diagnostic obstruction; retired as lower target |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env` | compiled route packaging; retired as lower target |
| `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | compiled selected-slot backend-fold feeder; retired as lower target |

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow prepared-sandwich postscript. It must retire the H-free active-selected comparison as the default target, state the source fragment for $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$, and name the prepared-sandwich field or raw-field feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`, the raw prepared-sandwich field, or one strict prepared-matrix feeder named by the gap record. Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, the paper circuit, or the `H_W` clean-column contract. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free active selected-slot comparison as
the default target, raw `Coeff` constructor route, compiled bridge rediscovery,
selected-slot backend-fold reduction, all nonselected slot vanish/support work,
and the diagnostic seven-gate zero route.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet only records a shape/register reroute from the H-free
diagnostic path to the prepared-sandwich semantics gap. The public ABEIS report
must use theorem, equation, figure, citation, and Lean declaration names rather
than local source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Directive: 2026-06-10 Post-Slot-One Evaluated Remaining-Slots Frontier

This directive supersedes the post-remaining-slots support packet for the next
lower proof attempt.  The active-side target is unchanged, but the latest Lean
evidence now includes the full evaluated slot-`1` backend branch vanish theorem:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
```

This theorem is compiled support only.  It retires slot `1` as the next smaller
lower target.  It does not prove `ActiveUncastToPreparedEntry`,
`SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, the one-term Robin
theorem, or any oracle, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
block-correctness, or final-extraction flag.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; retired because full slot-`1` evaluated vanish is now compiled |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` | compiled full slot-`1` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled dagger-after-SWAP support mismatch for backend slots `3`, `4`, `5`, and `6`; support-only, retired as a lower target |

The preferred local theorem remains the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The next preferred smaller leaf is a true evaluated branch
vanish/cancellation theorem for the remaining backend slots `3`, `4`, `5`, or
`6`.  Prefer slot `3` first:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3
```

or a strict full-index `48` diagonal-factor lemma that directly feeds that
slot-`3` theorem.  Do not spend lower work on another support-only lemma for
slots `3`, `4`, `5`, or `6`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow Section 21 postscript for the remaining-slots evaluated frontier.  The postscript must retire slot `1`, classify slots `3` through `6` support as support-only, and name the slot-`3` evaluated vanish theorem or full-index `48` feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality, the full slot-`3` evaluated branch vanish/cancellation theorem, or one strict full-index `48` diagonal-factor lemma feeding the slot-`3` theorem directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support,
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`,
and `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only one full slot-`1` evaluated vanish feeder and
moves the proof-DAG frontier to remaining-slots evaluated vanish/cancellation
or the active-side uncast equality.  The public ABEIS report must use theorem,
equation, figure, citation, and Lean declaration names rather than local
source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Directive: 2026-06-11 Post-Slot-Three Evaluated Remaining-Slots Frontier

This directive supersedes the post-slot-one remaining-slots packet for the
next lower proof attempt.  The active-side target is unchanged, but the latest
Lean evidence now includes the full evaluated slot-`3` backend branch vanish
theorem:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3
```

This theorem is a QBE-local finite matrix-semantics feeder only.  It retires
slot `3` and the full-index `48` diagonal-factor route as lower targets.  It
does not prove `ActiveUncastToPreparedEntry`, `SourcePreparedEntry`,
`FullUnitaryFold`, backend expansion, the one-term Robin theorem, or any
oracle, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection, block-correctness, or
final-extraction flag.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` | compiled full slot-`1` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3` | compiled full slot-`3` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled dagger-after-SWAP support mismatch for backend slots `3`, `4`, `5`, and `6`; support-only, retired as a lower target |

The preferred local theorem remains the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The next preferred smaller leaf is a true evaluated branch vanish/cancellation
theorem for one of the remaining backend slots `4`, `5`, or `6`.  Prefer slot
`4` first:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3
```

or a strict full-index `64` diagonal-factor lemma that directly feeds that
slot-`4` theorem.  Do not spend lower work on another support-only lemma for
slots `4`, `5`, or `6`, and do not reassign the compiled slot-`3` theorem.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow Section 21.7 postscript for the post-slot-`3` frontier.  The postscript must retire slot `3`, classify slots `4` through `6` support as support-only, and name the slot-`4` evaluated vanish theorem or full-index `64` feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality, the full slot-`4` evaluated branch vanish/cancellation theorem, or one strict full-index `64` diagonal-factor lemma feeding the slot-`4` theorem directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`,
and `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only the compiled slot-`3` evaluated vanish feeder and
moves the proof-DAG frontier to slot-`4` or `ActiveUncastToPreparedEntry`.  The
public ABEIS report must use theorem, equation, figure, citation, and Lean
declaration names rather than local source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Post-Remaining-Slots Support Frontier

This directive is the final override for the next lower proof attempt.  The
active-side target remains:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

Compiled support now includes:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; support-only, not a full slot-`1` vanish theorem |
| `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled dagger-after-SWAP support mismatch for backend slots `3`, `4`, `5`, and `6`; support-only, retired as a lower target |

The next preferred smaller leaf is a full slot-`1` evaluated branch
vanish/cancellation theorem, preferably:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
```

or a strict diagonal-factor lemma at full index `16` that directly feeds that
slot-`1` theorem.  Lower 2 may instead prove the full active-side uncast entry
equality.  Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean` and must
not change oracle contracts, theorem hypotheses, normalizers, gate labels, or
the paper circuit.

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery, prepared-side backend fold,
active wrapper/cast removal, all-slot fold expansion, slot-`0` vanish support,
slot-`1` support-only theorem, and the slots `3` through `6` support-only
theorem.  Do not spend lower work on another support-only lemma for slots `3`,
`4`, `5`, or `6`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Post-Remaining-Slots Support Frontier

This directive supersedes the post-slot-one support frontier for the next
lower proof attempt.  The active-side target is unchanged, but the latest
compiled support now includes the dagger-after-SWAP zero support for backend
slots `3`, `4`, `5`, and `6`.  Those slot-support facts are retired as lower
targets.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; support-only, not a full slot-`1` vanish theorem |
| `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled dagger-after-SWAP support mismatch for backend slots `3`, `4`, `5`, and `6`; support-only, retired as a lower target |

The next preferred local theorem remains the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

The next preferred smaller leaf is a full slot-`1` evaluated branch
vanish/cancellation theorem, preferably:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3
```

or a strict diagonal-factor lemma at full index `16` that directly feeds that
slot-`1` backend contribution vanish theorem.  Do not spend lower work on
another support-only lemma for slots `3`, `4`, `5`, or `6`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; add only a narrow postscript if the selected slot-`1` theorem name changes. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality, the full slot-`1` evaluated branch vanish/cancellation theorem, or one strict diagonal-factor lemma feeding that slot-`1` theorem directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support,
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`, and
`oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only support routing for the finite active-side
prepared-entry frontier.  The public ABEIS report must use theorem, equation,
figure, citation, and Lean declaration names rather than local source-line
anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Directive: 2026-06-11 Post-Selected-Slot Active-Uncast Eval Frontier

This directive supersedes the post-slot-six active-uncast packet for the next
lower proof attempt. The remaining backend-slot vanish sequence is complete,
and the evaluated backend fold has now been reduced to the selected slot-`2`
contribution by the compiled theorem:

```lean
oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3
```

This theorem is a QBE-local finite matrix-semantics feeder only. It retires the
selected-slot backend-fold reduction as a lower target. It does not prove
`ActiveUncastToPreparedEntry`, `SourcePreparedEntry`, `FullUnitaryFold`,
backend expansion, the one-term Robin theorem, or any oracle,
$H_W^{(\kappa)}$, $R_y$, LCU, block-projection, block-correctness, or
final-extraction flag.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled slot-`0` evaluated branch vanish; retired |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` | compiled slot-`1` evaluated branch vanish; retired |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3` | compiled slot-`3` evaluated branch vanish; retired |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3` | compiled slot-`4` evaluated branch vanish; retired |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3` | compiled slot-`5` evaluated branch vanish; retired |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3` | compiled slot-`6` evaluated branch vanish; retired |
| `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3` | compiled evaluated backend-fold-to-selected-slot feeder; retired as a lower target |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3` | compiled route-packaging bridge from the active selected-slot comparison to the evaluated backend fold; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge from `SourcePreparedEntry` to the uncast active entry; do not rediscover |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |

The only preferred local theorem for the next lower proof attempt is the
active-side evaluated comparison between the seven-gate core entry and the
selected slot-`2` contribution:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution
```

An acceptable smaller leaf must feed this equality directly, such as an
active-side finite product support/cancellation lemma for the `[0,0]` entry.
It must not restart any backend slot vanish theorem, selected-slot backend
fold theorem, or compiled active/prepared bridge.

If a direct proof of this H-free active comparison collapses through the
diagnostic seven-gate column-zero route, classify the result as a
`shape_or_register_gap` and reroute to the prepared-sandwich semantics gap for
the source-facing $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ matrix entry. Do
not use that diagnostic route to claim theorem closure.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow Section 21.11 postscript if the active-side selected-slot theorem name changes. The postscript must treat slots `0`, `1`, `3`, `4`, `5`, `6`, and the backend-fold-to-selected-slot feeder as compiled and retired. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove the active-side evaluated comparison above, or one strict active-side feeder that directly proves it. Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3`,
`oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3`,
all slot-vanish/support/diagonal targets for slots `0`, `1`, `3`, `4`, `5`,
and `6`, and `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only the compiled selected-slot backend-fold feeder and
moves the proof-DAG frontier to the active-side evaluated selected-slot
comparison. The public ABEIS report must use theorem, equation, figure,
citation, and Lean declaration names rather than local source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Post-Slot-One Support Frontier

This directive supersedes the active-side uncast entry packet for the next
lower proof attempt.  The active-side target is unchanged, but the latest
compiled support now includes the slot-`0` evaluated vanish facts and the
slot-`1` dagger-after-SWAP support mismatch.  These support facts are retired
as lower targets.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast seven-gate active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; support-only, not a full slot-`1` vanish theorem |

The next preferred local theorem remains the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

An acceptable smaller leaf is one strict support, vanish, or cancellation lemma
that feeds this equality directly.  Slot `1` still needs a full branch-level
vanish or cancellation theorem if lower work chooses that route; otherwise
target slots `3`, `4`, `5`, or `6`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md` and the middle packet `proof-attempts/QBE-AUTO-002/active-side-slot-one-support-middle-packet-20260610-1448.md`; add only a narrow postscript if the selected slot or theorem name changes. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality, a full slot-`1` vanish/cancellation theorem, or one strict support, vanish, or cancellation lemma for slots `3`, `4`, `5`, or `6` feeding it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support, and
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only support routing for the finite active-side
prepared-entry frontier.  The public ABEIS report must use theorem, equation,
figure, citation, and Lean declaration names rather than local source-line
anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Post-Slot-One Support Frontier

This directive supersedes the active-side uncast entry packet for the next
lower proof attempt.  The active-side target is unchanged, but the latest
compiled support now includes the slot-`0` evaluated vanish facts and the
slot-`1` dagger-after-SWAP support mismatch.  These support facts are retired
as lower targets.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast seven-gate active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; support-only, not a full slot-`1` vanish theorem |

The next preferred local theorem remains the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

An acceptable smaller leaf is one strict support, vanish, or cancellation lemma
that feeds this equality directly.  Slot `1` still needs a full branch-level
vanish or cancellation theorem if lower work chooses that route; otherwise
target slots `3`, `4`, `5`, or `6`.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md` and the middle packet `proof-attempts/QBE-AUTO-002/active-side-slot-one-support-middle-packet-20260610-1448.md`; add only a narrow postscript if the selected slot or theorem name changes. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality, a full slot-`1` vanish/cancellation theorem, or one strict support, vanish, or cancellation lemma for slots `3`, `4`, `5`, or `6` feeding it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support, and
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only support routing for the finite active-side
prepared-entry frontier.  The public ABEIS report must use theorem, equation,
figure, citation, and Lean declaration names rather than local source-line
anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Sync: 2026-06-10 Slot-Zero Support Accepted

This sync refines the active-side uncast entry frontier after the current
lower pass.  Two strict support feeders are compiled:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled; the active seven-gate column-`0` entry evaluates to zero; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled; the slot-`0` backend branch contribution evaluates to zero; retired as a lower target |

These feeders do not prove `ActiveUncastToPreparedEntry`,
`SourcePreparedEntry`, `FullUnitaryFold`, backend expansion, or the one-term
Robin theorem.  They also do not justify erasing sparse slots `1` through `6`.

The next lower work remains the active-side equality

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

through the existing `HUniform`-visible route, or one strict support, vanish,
or cancellation lemma feeding that equality directly.  Retire slot-`0` vanish,
prepared-side backend fold, active wrapper/cast removal, all-slot fold
expansion, raw `Coeff`, H-free `evalWith`, and bridge rediscovery as lower
targets.

Middle packet:
`proof-attempts/QBE-AUTO-002/active-side-slot-zero-support-middle-packet-20260610-1420.md`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.  No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU,
block-projection, normalized-equality, product-to-coefficient,
circuit-unitarity, block-correctness, final-extraction, oracle, or external
primitive flag is promoted by this sync.

## Previous Run Directive: 2026-06-10 Active-Side Uncast Entry Frontier

This directive supersedes the source-prepared active/prepared entry packet for
the next lower proof attempt.  The prepared-side backend normal form and the
active wrapper/cast removal bridge are now compiled support.  They are not the
next lower targets.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast seven-gate active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |

The next preferred local theorem is the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

An acceptable smaller leaf is one support, vanish, or cancellation lemma that
feeds this equality directly.  If the equality is proved, recover
`SourcePreparedEntry` through
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
then recover `FullUnitaryFold` through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
under the existing `HUniform` contract.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Add only a narrow postscript to `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.  It should classify the new active-side uncast equality, state which seven-gate product terms are expected to survive or vanish, and keep `HUniform` contract-only. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality above, or one strictly smaller support, vanish, or cancellation lemma feeding it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper, source-prepared
clean-entry alias, H-free `evalWith` route, column-`0` diagnostics, raw
`Coeff` constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
and `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only active-side source-prepared routing for the finite
projection/backend fold.  The public ABEIS report must use theorem, equation,
figure, citation, and Lean declaration names rather than local source-line
anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Directive: 2026-06-11 Post-Bridge Evaluated Backend Fold Frontier

This directive supersedes the post-feeder active/prepared composition packet
for the next lower proof attempt. Lower 2 has compiled the post-feeder bridge

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
```

which proves that, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
exact unwrapped active/prepared sparse-clean `evalWith` equality is equivalent
to:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The bridge is now stale as a lower target. The first-case-study one-term
theorem remains open.

Next lower work:

1. Lower 1 may append only a narrow postscript to Section 21.15 of
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`,
   naming the compiled bridge above and retiring it as a target.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, the
   exact unwrapped active/prepared sparse-clean equality exposed by the
   bridge, or one strictly smaller theorem that directly feeds one of these
   statements.
4. Retire the strict prepared-sparse feeder, the new sparse-clean-to-fold
   bridge, finite active/prepared reduction guards, H-free active-selected
   diagnostics, backend slot vanish/support work, raw `Coeff` constructor
   equalities, branch-sum wrappers, and compiled bridge rediscovery.
5. If the obstacle is the arbitrary-`H` route shape rather than a tactic gap,
   record typed verifier feedback as `source_translation_gap` or
   `shape_or_register_gap`; do not add hypotheses or change the paper circuit.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Generated Chinese summaries, the project article update, and the ABEIS
generated appendix must say that the first-case-study one-term theorem is
still open. This packet only narrows the source-prepared matrix-entry frontier
after one compiled equivalence bridge.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.

## Current Run Directive: 2026-06-11 Post-Feeder Active/Prepared Composition Field Frontier

This final directive supersedes the prepared-sandwich semantics gap packet and
all earlier active-side packets. The strict feeder
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_preparedSparseCleanEntry_n3`
is compiled and retired as a lower target. The next lower work is the
unwrapped active/prepared equality exposed by that feeder:

```lean
Coeff.evalWith env
  ((evalGateMatrices
    (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
    oneTermRobinGamma3BoundaryPrefixRow0_n3
    oneTermRobinGamma3BoundaryPrefixRow0_n3) =
Coeff.evalWith env
  (oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
    oneTermRobinGamma3BoundarySparseCleanIndex_n3
    oneTermRobinGamma3BoundarySparseCleanIndex_n3)
```

Equivalent acceptable targets are
`oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`,
`oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env`,
or `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`.
Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`; lower 1 may append
only a narrow proof-DAG postscript. Retire the strict feeder, H-free
active-selected diagnostics, backend slot vanish/support work, raw `Coeff`
routes, branch-sum wrappers, and compiled bridge rediscovery. The first-case
study one-term theorem remains open, and no oracle, `H_W`, `R_y`, LCU,
projection, block-correctness, final-extraction, normalizer, or external
primitive flag is promoted.

## Previous Run Directive: 2026-06-11 Prepared-Sandwich Semantics Gap Frontier

This directive supersedes the post-selected-slot active-uncast eval packet for
the next lower proof attempt. The latest lower feedback compiled the diagnostic
obstruction
`oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3`
and classified the direct H-free `ActiveSelectedSlotEvalComparison` route as a
`shape_or_register_gap` unless a new source-faithful active path is found. Do
not keep spending lower proof search on that H-free comparison by default.

The next precise objective is the source-prepared matrix-entry semantics gap
for the paper's $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$ sandwich, under the
already explicit clean-column contract:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

Active Lean-facing targets are:

```lean
oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H
oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env
```

or a strictly smaller theorem that directly supplies the missing prepared
matrix field named by
`(oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H).missingPreparedMatrixField`.
An acceptable equivalent stronger leaf is the raw prepared-sandwich field:

```lean
(oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3 H).rawEntryPreparedSandwichStatement
```

but only if it returns through the compiled prepared-sandwich bridge and keeps
`HUniform` contract-only.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H` | compiled transcript for the gap; records that the active seven-gate list omits both $H_W^{(\kappa)}$ sides |
| `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | compiled guard that the active placeholder list is H-free |
| `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_exposesUncastSevenGate_n3 H env` | compiled mismatch witness exposing the uncast active left side and prepared-sandwich right side |
| `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3 H env hUniform` | compiled equivalence under the existing all-slot clean-column contract; proves neither side |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotComparison_diagnosticSevenGateObstruction_n3 env hDiagnostic hActiveSelected` | compiled diagnostic obstruction; retired as lower target |
| `oneTermRobinGamma3BoundaryActiveSelectedSlotEvalComparison_iff_evaluatedBackendFold_n3 env` | compiled route packaging; retired as lower target |
| `oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3 env` | compiled selected-slot backend-fold feeder; retired as lower target |

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow prepared-sandwich postscript. It must retire the H-free active-selected comparison as the default target, state the source fragment for $H_W^{(\kappa)\dagger} U H_W^{(\kappa)}$, and name the prepared-sandwich field or raw-field feeder. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove `oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3 H env`, the raw prepared-sandwich field, or one strict prepared-matrix feeder named by the gap record. Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, the paper circuit, or the `H_W` clean-column contract. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free active selected-slot comparison as
the default target, raw `Coeff` constructor route, compiled bridge rediscovery,
selected-slot backend-fold reduction, all nonselected slot vanish/support work,
and the diagnostic seven-gate zero route.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet only records a shape/register reroute from the H-free
diagnostic path to the prepared-sandwich semantics gap. The public ABEIS report
must use theorem, equation, figure, citation, and Lean declaration names rather
than local source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-11 Post-Slot-Six Active-Uncast Frontier

This directive supersedes the post-slot-five remaining-slots packet for the
next lower proof attempt. The remaining backend-slot vanish sequence is now
complete: the latest Lean evidence includes the full evaluated slot-`6`
backend branch vanish theorem:

```lean
oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3
```

This theorem is a QBE-local finite matrix-semantics feeder only. It retires
slot `6`, the full-index `96` diagonal-factor route, and every remaining-slot
vanish/cancellation target as lower targets. It does not prove
`ActiveUncastToPreparedEntry`, `SourcePreparedEntry`, `FullUnitaryFold`,
backend expansion, the one-term Robin theorem, or any oracle,
$H_W^{(\kappa)}$, $R_y$, LCU, block-projection, block-correctness, or
final-extraction flag.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3` | compiled full slot-`1` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3` | compiled full slot-`3` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3` | compiled full slot-`4` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3` | compiled full slot-`5` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3` | compiled full slot-`6` evaluated branch vanish; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3` | compiled dagger-after-SWAP support mismatch for backend slots `3`, `4`, `5`, and `6`; support-only, retired as a lower target |

The only preferred local theorem for the next lower proof attempt is the
active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

An acceptable smaller leaf must feed this equality directly. It may be an
active-side finite product support/cancellation lemma or a selected-slot-`2`
entry comparison that consumes the compiled vanish facts for slots `0`, `1`,
`3`, `4`, `5`, and `6`. It must not restart any slot-`6` support, diagonal,
or vanish theorem, and it must not rediscover the compiled active/prepared
bridges.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`; append only a narrow Section 21.10 postscript for the post-slot-`6` frontier. The postscript must retire slots `0`, `1`, `3`, `4`, `5`, and `6`, identify the selected slot-`2` contribution, and map the remaining proof route to `ActiveUncastToPreparedEntry`. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`. Prove `ActiveUncastToPreparedEntry` or one strict active-side evaluated/source-prepared feeder that directly feeds it. Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, raw `Coeff`
constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
slot-`0` evaluated vanish support,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3`,
`oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3`,
the full-index `96` diagonal-factor route,
and `oneTermRobinGamma3BoundaryBackendRemainingSlotsDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only the compiled slot-`6` evaluated vanish feeder and
moves the proof-DAG frontier to `ActiveUncastToPreparedEntry`. The
public ABEIS report must use theorem, equation, figure, citation, and Lean
declaration names rather than local source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Post-Slot-One Support Frontier

This directive supersedes the active-side uncast entry packet for the next
lower proof attempt.  The active-side target is unchanged, but the latest
compiled support now includes slot-`0` evaluated vanish and the slot-`1`
dagger-after-SWAP support mismatch.  These support facts are retired as lower
targets.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |
| `oneTermRobinGamma3BoundarySevenGateColumn0Eval_zero_n3` | compiled active column-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3` | compiled backend slot-`0` evaluated vanish support; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3` | compiled slot-`1` dagger-after-SWAP support mismatch; support-only, not a full slot-`1` vanish theorem |

The next preferred local theorem remains:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

An acceptable smaller leaf is a full slot-`1` vanish/cancellation theorem, or
one strict support, vanish, or cancellation lemma for slots `3`, `4`, `5`, or
`6` that feeds this equality directly.

Lower 2 must edit only `QuantumBlockEncoding/RobinMatrix.lean`.  It must not
change oracle contracts, theorem hypotheses, normalizers, gate labels, or the
paper circuit.  Retired lower targets remain retired: branch-sum wrappers,
source-prepared clean-entry aliases, H-free `evalWith`, raw `Coeff`, compiled
bridge rediscovery, prepared-side backend fold, active wrapper/cast removal,
slot-`0` support, and
`oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Expanded-All-Slots Feeder Accepted And Next Fold Reduction

This directive supersedes the full-unitary fold frontier packet for the next
lower proof attempt.  The active theorem is unchanged:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

The current run has accepted two strict support feeders:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3` | compiled; maps sparse slot `s : Fin 7` to full basis value `s.val * 16`; retired as a lower target |
| `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` | compiled; expands the backend branch fold into the seven weighted diagonal entries at full-basis values `0`, `16`, `32`, `48`, `64`, `80`, and `96`; retired as a lower target |

Neither feeder proves `FullUnitaryFold`, the backend-expansion endpoint, or the
one-term Robin theorem.  The known diagnostic sorries in
`QuantumBlockEncoding/RobinMatrix.lean` remain.

Next lower work:

1. Lower 1 should reuse
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`
   and add only a narrow addendum for `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`
   if the selected theorem name changes.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly one of:
   - the expanded uncast active-entry equality exposed by
     `oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`,
     using `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`
     as the backend RHS normal form; or
   - `(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement`
     under the already explicit
     `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`
     route.
4. The equivalent endpoint remains
   `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
   through `oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3`.
5. Retire the direct branch-sum wrapper, source-prepared clean-entry alias,
   H-free `evalWith` route, column-`0` diagnostics, raw `Coeff` constructor
   route, compiled bridge rediscovery, `oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
   and `oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3` as lower targets.
6. The gate remains `python3 tools/qbe.py check`, then `lake build`, then
   `lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this batch adds only support feeders and proof-DAG routing for the
finite projection/backend fold.  The public ABEIS report must use theorem,
equation, figure, citation, and Lean declaration names rather than local
source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Source-Prepared Active/Prepared Entry Frontier

This directive supersedes the expanded-all-slots feeder packet for the next
lower proof attempt.  The theorem-facing transcript guard, explicit
`U_indic^dagger` role, prepared `H_W^{(\kappa)}` route, full-index value lemma,
and expanded seven-slot backend fold are compiled.  They are support memory,
not the next lower target.

The next preferred local theorem is the source-prepared active/prepared entry
equality under the existing clean-column contract:

```lean
(oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).entryEqualityStatement
```

with the external contract kept explicit as:

```lean
oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H
```

The dependent root remains:

```lean
oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
  blockExtractionBranchContributionSum
    oneTermRobinGamma3BoundaryBackendBranchContribution_n3
```

and it is reached through:

```lean
oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3
```

Equivalent recovery through
`oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement`
or the expanded uncast equality exposed by
`oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3`
is allowed only if the proof returns through the prepared-entry or
`FullUnitaryFold` bridges.  The expanded uncast/backend fold route is not the
preferred lower target.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Reuse `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md` and add only a narrow source-prepared addendum if the selected theorem statement changes.  The addendum must say how `hUniform`, the prepared clean entry, and the active signal-zero entry feed the dependent fold. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active/prepared entry equality under `hUniform`, or one strictly smaller prepared-circuit semantics lemma that feeds it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, column-`0`
diagnostics, raw `Coeff` constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`, and
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this batch adds only source-prepared routing and support feeders for the
finite projection/backend fold.  The public ABEIS report must use theorem,
equation, figure, citation, and Lean declaration names rather than local
source-line anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Previous Run Directive: 2026-06-10 Active-Side Uncast Entry Frontier

This directive supersedes the source-prepared active/prepared entry packet for
the next lower proof attempt.  The prepared-side backend normal form and the
active wrapper/cast removal bridge are now compiled support.  They are not the
next lower targets.

Compiled support to reuse:

| Declaration | Status |
|---|---|
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3` | compiled prepared-side normal form under `oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`; retired as a lower target |
| `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3` | compiled bridge rewriting `SourcePreparedEntry` to the uncast seven-gate active `[0,0]` entry against the cached prepared entry; retired as a lower target |
| `oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3` | compiled conditional bridge from `SourcePreparedEntry` plus `HUniform` to `FullUnitaryFold`; do not rediscover |

The next preferred local theorem is the active-side uncast entry equality:

```lean
(evalGateMatrices
  (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters 3)))
  oneTermRobinGamma3BoundaryPrefixRow0_n3
  oneTermRobinGamma3BoundaryPrefixRow0_n3 =
    (oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H).preparedEntry
```

An acceptable smaller leaf is one support, vanish, or cancellation lemma that
feeds this equality directly.  If the equality is proved, recover
`SourcePreparedEntry` through
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`,
then recover `FullUnitaryFold` through
`oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3`
under the existing `HUniform` contract.

Lower-agent split:

| Lower profile | Required behavior |
|---|---|
| lower 1: natural-language proof architect | Add only a narrow postscript to `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`.  It should classify the new active-side uncast equality, state which seven-gate product terms are expected to survive or vanish, and keep `HUniform` contract-only. |
| lower 2: Lean implementation worker | Edit only `QuantumBlockEncoding/RobinMatrix.lean`.  Prove the active-side uncast entry equality above, or one strictly smaller support, vanish, or cancellation lemma feeding it directly.  Do not change oracle contracts, theorem hypotheses, normalizers, gate labels, or the paper circuit. |

Retired lower targets remain retired: direct branch-sum wrapper,
source-prepared clean-entry alias, H-free `evalWith` route, column-`0`
diagnostics, raw `Coeff` constructor route, compiled bridge rediscovery,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3`,
`oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3`,
`oneTermRobinGamma3BoundaryActivePreparedEntryTarget_preparedEntry_eq_backendFold_n3`,
and `oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_uncastActiveEntry_n3`.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Middle must keep the Chinese summary, project article update, and ABEIS
generated appendix honest: the first-case-study one-term theorem is still
open; this packet adds only active-side source-prepared routing for the finite
projection/backend fold.  The public ABEIS report must use theorem, equation,
figure, citation, and Lean declaration names rather than local source-line
anchors.

No ODBS, ODTS, `O_f`, $H_W^{(\kappa)}$, $R_y$, LCU, block-projection,
normalized-equality, product-to-coefficient, circuit-unitarity,
block-correctness, final-extraction, oracle, or external primitive flag is
promoted by this packet.

## Current Run Directive: 2026-06-11 Post-Bridge Evaluated Backend Fold Frontier

This directive supersedes the post-feeder active/prepared composition packet
for the next lower proof attempt. Lower 2 has compiled the post-feeder bridge

```lean
oneTermRobinGamma3BoundaryUncastPreparedSparseCleanEntryEval_iff_evaluatedBackendFold_n3
```

which proves that, under
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H`, the
exact unwrapped active/prepared sparse-clean `evalWith` equality is equivalent
to:

```lean
oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env
```

The bridge is now stale as a lower target. The first-case-study one-term
theorem remains open.

Next lower work:

1. Lower 1 may append only a narrow postscript to Section 21.15 of
   `proof-attempts/QBE-AUTO-002/unitary-fold-leaf-dag-addendum-20260610-1156-lower1.md`,
   naming the compiled bridge above and retiring it as a target.
2. Lower 2 edits only `QuantumBlockEncoding/RobinMatrix.lean`.
3. Lower 2 should prove exactly
   `oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3 env`, the
   exact unwrapped active/prepared sparse-clean equality exposed by the
   bridge, or one strictly smaller theorem that directly feeds one of these
   statements.
4. Retire the strict prepared-sparse feeder, the new sparse-clean-to-fold
   bridge, finite active/prepared reduction guards, H-free active-selected
   diagnostics, backend slot vanish/support work, raw `Coeff` constructor
   equalities, branch-sum wrappers, and compiled bridge rediscovery.
5. If the obstacle is the arbitrary-`H` route shape rather than a tactic gap,
   record typed verifier feedback as `source_translation_gap` or
   `shape_or_register_gap`; do not add hypotheses or change the paper circuit.

The gate remains `python3 tools/qbe.py check`, then `lake build`, then
`lake build Tests`.

Generated Chinese summaries, the project article update, and the ABEIS
generated appendix must say that the first-case-study one-term theorem is
still open. This packet only narrows the source-prepared matrix-entry frontier
after one compiled equivalence bridge.

No oracle, `H_W`, `R_y`, LCU, block-projection, normalized-equality,
product-to-coefficient, circuit-unitarity, block-correctness,
final-extraction, normalizer, or external primitive flag is promoted by this
packet.
