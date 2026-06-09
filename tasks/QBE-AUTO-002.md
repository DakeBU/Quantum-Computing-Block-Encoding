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
