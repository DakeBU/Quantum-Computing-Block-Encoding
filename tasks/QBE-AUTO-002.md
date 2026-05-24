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

## Current Critical Correction: O_D^BS Sparse Slots

Before any more `O_D^BS` unitarity, dagger-cleanup, or block-extraction proof
search, fix the active formal target.

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

Next lower packets should implement this correction in order:

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

Do not spend this run on writing polish or broad library organization.  The
documentation updates required in this run are only the minimal Lean/Markdown/
LaTeX synchronization needed to record the corrected faithful contract.

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

0. Run a source-contract audit for the GHL one-term Robin gates before any more
   unitarity proof search.  In particular, Lemma 1 defines the banded sparse
   access oracle as
   `O_D^BS |0>^(n-l) |s>^l |i>^n = |r_si>^n |i>^n`.
   The current interim Lean contract for `bandedSparseAccessMatrix` instead
   preserves the sparse-index register and overwrites the system register with
   `col(s,i)`.  Treat this as contract drift until the register-level image
   formula is reconciled with the paper's padded sparse-index register and
   cleanup by `(O_D^BS)^dagger`.

0a. Correct the active `O_D^BS` address model as described in **Current
    Critical Correction: O_D^BS Sparse Slots**.  This is the top priority for
    the next 6-hour run.  Lower agents must not continue proving the old
    row-dependent unused-branch extension blocker as if it were a paper gap.

0a-fix. The 2026-05-24 6-hour run implemented the global sparse-slot address
        route, but final review found stale active-route guards that still
        freeze `QBE.ODBS.UnusedZeroBranchExtension` as the active blocker.
        The next run must retire those stale guards from
        `oneTermRobinBlockEncodingProofRoute` and tests.  Keep the old
        row-dependent collision only as rejected-model memory, and make active
        O_D^BS blockers refer to the global-slot source, restricted inverse/
        cleanup interfaces, encoded out-of-range sparse values such as
        `s = 7` for `kappa = 7`, or a precise full-space extension theorem.

0b. Complete the faithful transcript/contract map before non-critical proof
    polishing.  SWAP bit-slice lemmas are useful proof-route memory, but the
    next critical-path work is the GHL `O_D^BS` register contract and the
    paper-level one-term block-encoding proof map.

1. Add tests for the new matrix semantics layer.
2. Define a block-projection/indexing convention for signal and system
   registers.
3. Connect `GHL2025.oneTermRobinCircuit` to `CircuitMatrixSemantics` through
   gate-level matrix placeholders with honest `SemanticObligation` records.
4. State the exact block-extraction target for
   `Examples.RobinHeat.robinBlockEncodingSpec n`.
5. Keep every unproved semantic claim as an obligation with `proved := false`.
6. Keep cited-results memory synchronized for any prior theorem used by the
   paper or by our proof plan.

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
