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

## Current Run Directive: GHL Theorem Closure Under Cited Contracts

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

For local agent work, the GHL2025 TeX source is archived in the sibling
ARIS-style source store:

```text
../Auto-claude-code-research-in-sleep/paper-sources/GHL2025/main.tex
```

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
