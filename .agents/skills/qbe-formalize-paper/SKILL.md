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
2. Identify reusable proof blocks before writing Lean.  Use the lesson of
   Sonoda--Akiyama--Uezato, arXiv:2602.10512v2: a hierarchical prover gains
   sample efficiency when repeated local arguments are represented as a proof
   DAG and solved once, rather than flattened into repeated tactic traces.
   In QBE, typical reusable blocks include dimension arithmetic, bit-slice
   extraction, block projection, gate-list alignment, sparse-index maps, and
   normalizer lemmas.
3. Create a task:
   `python3 tools/qbe.py new-task <id> --title "<paper construction>"`.
4. Create a conversion window:
   `python3 tools/qbe.py conversion-window <id> --title "<paper construction>"`.
5. Add a proof-DAG/reuse map to the conversion window: each block should have
   an interface, dependencies, Lean declaration name, paper citation, proof
   status, and reuse sites.
6. Add or update Lean definitions in the target file, preferring references to
   existing shared declarations over duplicate local definitions.
7. Add at least one small test in `Tests/Basic.lean` when possible.
8. Run `python3 tools/qbe.py check`.

## Hierarchical Proof Policy

- Upper chooses one reusable block or one block interface per cycle.
- Middle maintains the proof DAG and sends lower agents narrow local proof
  packets.
- Lower agents solve local blocks; a successful block should be promoted to a
  named Lean declaration and reused by calls, not copied.
- Reviewer checks whether a failed or expensive flat proof should be split into
  a reusable lemma before more search is spent.
- In faithful paper mode, the DAG decomposes the paper construction; it must not
  add hypotheses, substitute circuits, or weaken the theorem.

## Acceptance

- `lake build && lake build Tests` succeeds.
- The implementation status in `Literature.lean` is not advanced beyond what
  has actually been compiled.
- Unproved mathematical content is represented as explicit proof obligations,
  not as vague prose.
- Repeated proof fragments are represented by reusable declarations or proof
  obligations, not repeated ad hoc definitions.
