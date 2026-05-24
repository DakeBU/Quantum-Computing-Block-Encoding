---
name: qbe-formalize-paper
description: Turn one block-encoding/oracle-construction paper into a compiled Lean skeleton or proof increment.
argument-hint: "[paper key or URL] --target: Lean file"
---

# QBE Formalize Paper

Use this when implementing one paper from `QuantumBlockEncoding/Literature.lean`.

## Workflow

1. Identify the exact construction: matrix target, circuit/oracle, normalizer,
   ancilla layout, resource statement.
2. Classify the phase.  In Phase 1, produce a faithful paper transcript and
   exact Lean contract map first.  Avoid broad library organization,
   future-paper abstractions, and non-critical proof polishing until the paper's
   theorem/equation/circuit/oracle map is complete.  In Phase 2, reorganize
   shared APIs and teaching/reuse structure.
3. Run a source-contract audit before writing Lean: for every oracle or named
   gate, record the paper anchor, exact input registers, exact output registers,
   clean ancilla condition, normalizer, and resource claim.  Public artifacts
   should cite the paper, arXiv URL, theorem/lemma/equation/figure labels, or
   bundled paper-note sections, not a local absolute source path.  If the
   current Lean declaration implements a simplified register map, mark it as
   contract drift and correct that contract before proof search.
   For sparse-access oracles, distinguish index slots from coefficient values:
   if the paper includes zero-amplitude entries in a fixed sparse enumeration,
   keep the sparse slot in the oracle domain and put the zero in the amplitude
   layer.  Do not delete the slot or fold it to an identity image unless the
   paper explicitly states that register-level rule.
4. Maintain two-way translation.  Before lower-agent Lean work, translate the
   relevant paper LaTeX theorem/equation/circuit fragment into a Lean-facing
   contract.  After lower-agent work, translate the actual Lean declarations,
   proof status, failed goals, and remaining obligations back into Markdown and
   LaTeX so the next upper/reviewer reflection can compare against the paper.
5. Audit cited results.  If the paper uses a prior theorem, named subroutine,
   standard lemma, or classical result, update `research-wiki/cited-results/`
   with its source, exact statement used, Lean target, QBE status, and
   dependent proof blocks.  Do not treat a cited result as proved unless a
   build-tested Lean declaration exists.
6. When a faithful-paper proof block fails, run
   `.agents/skills/qbe-source-dependency-audit/SKILL.md` before assigning more
   lower-agent tactic search.  Middle should read the local TeX source and
   bibliography around the failing statement, then classify the missing
   ingredient as an internal paper step, external cited result, classical Lean
   lemma, or source-contract gap.  Lower agents may continue only after that
   classification is written into the conversion window or proof-obligation
   ledger.
7. If the source TeX contains a proof or proof sketch, translate the proof
   structure before lower work.  Each source proof step should map to an
   existing Lean declaration, a new local lemma target, an external cited-result
   row, or a source-contract gap.  This map, not free-form theorem search, is
   the lower-agent work queue.
8. Identify reusable proof blocks before writing Lean.  Use the lesson of
   Sonoda--Akiyama--Uezato, arXiv:2602.10512v2: a hierarchical prover gains
   sample efficiency when repeated local arguments are represented as a proof
   DAG and solved once, rather than flattened into repeated tactic traces.
   In QBE, typical reusable blocks include dimension arithmetic, bit-slice
   extraction, block projection, gate-list alignment, sparse-index maps, and
   normalizer lemmas.
9. Create a task:
   `python3 tools/qbe.py new-task <id> --title "<paper construction>"`.
10. Create a conversion window:
   `python3 tools/qbe.py conversion-window <id> --title "<paper construction>"`.
11. Add a proof-DAG/reuse map to the conversion window: each block should have
   an interface, dependencies, Lean declaration name, paper citation, proof
   status, and reuse sites.
12. Add or update Lean definitions in the target file, preferring references to
   existing shared declarations over duplicate local definitions.
13. Add at least one small test in `Tests/Basic.lean` when possible.
14. Run `python3 tools/qbe.py check`.

## Hierarchical Proof Policy

- Upper chooses one reusable block or one block interface per cycle.
- Middle maintains the proof DAG and sends lower agents narrow local proof
  packets.
- Middle also keeps the Markdown/LaTeX proof map synchronized with Lean after
  each cycle; compilation alone is not a completed faithful-paper step.
- Lower agents solve local blocks; a successful block should be promoted to a
  named Lean declaration and reused by calls, not copied.
- Reviewer checks whether a failed or expensive flat proof should be split into
  a reusable lemma before more search is spent.
- In faithful paper mode, the DAG decomposes the paper construction; it must not
  add hypotheses, substitute circuits, or weaken the theorem.
- Reviewer treats source-contract drift as blocking: a Lean proof of a
  simplified oracle is not progress on the faithful paper target until the
  register-level transformation matches the paper.
- Reviewer treats sparse-slot deletion as contract drift when the paper uses a
  fixed diagonal/band enumeration and merely sets some coefficients to zero.
- Reviewer treats missing cited-results memory as blocking when a proof uses
  prior work or a "standard" fact that is not already formalized in QBE.
- Reviewer treats missing source-dependency audit as blocking after a
  faithful-paper proof block gets stuck.  It is not enough to say "Lean failed";
  middle must identify whether the missing ingredient is in the local paper,
  in cited literature, in classical Lean arithmetic/algebra, or in a stricter
  QBE source-contract gap.
- In Phase 1, reusable proof blocks are recorded when useful, but they should
  not displace completing the paper transcript and contract map.  Full library
  cleanup and generalized APIs wait for Phase 2.

## Acceptance

- `lake build && lake build Tests` succeeds.
- The implementation status in `Literature.lean` is not advanced beyond what
  has actually been compiled.
- Unproved mathematical content is represented as explicit proof obligations,
  not as vague prose.
- Repeated proof fragments are represented by reusable declarations or proof
  obligations, not repeated ad hoc definitions.
