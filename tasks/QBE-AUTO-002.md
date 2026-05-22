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

0a. Complete the faithful transcript/contract map before non-critical proof
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
