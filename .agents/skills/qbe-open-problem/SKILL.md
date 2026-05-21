---
name: qbe-open-problem
description: Propose or refine a new open block-encoding/oracle construction problem from current Lean artifacts and literature gaps.
argument-hint: "[gap or target oracle]"
---

# QBE Open Problem

Use this when a paper assumes an oracle but does not provide a gate-level
construction, or when current Lean artifacts expose a reusable construction gap.

## Required Output

Add or update an entry in `QuantumBlockEncoding/OpenProblems.lean` with:

- stable id,
- short title,
- precise statement,
- Lean-checkable acceptance test,
- references.

Also add a Markdown expansion in `docs/open_problems.md` if the problem is
important enough for human readers.

## Candidate Representation

Use a hierarchical candidate representation, not only a flat list of gates or
tactics.  The relevant lesson from Sonoda--Akiyama--Uezato,
arXiv:2602.10512v2, is that reusable proof structure can reduce effective
search/sample complexity when repeated local arguments are memoized as proof
blocks.

For each candidate open-problem direction, record:

- graph-level target: which oracle/circuit/proof blocks should exist;
- block interfaces: input registers, output matrix condition, normalizer, and
  assumptions already present in the original target;
- local proof obligations: unitarity, block extraction, sparse access,
  arithmetic bounds, resource accounting;
- reuse opportunities: existing QBE lemmas or blocks that should be called;
- flat-risk estimate: what would be duplicated if the candidate were pursued as
  one monolithic Lean proof;
- acceptance predicate: the Lean statement that must compile.

Exploratory candidate populations may mutate or recombine graph structure, but
they must not weaken the acceptance predicate or add new assumptions to make a
candidate pass.

## Acceptance

- The new problem has a concrete target matrix/oracle/circuit condition.
- The acceptance test is not "write a proof"; it states what Lean artifact
  would certify success.
- `python3 tools/qbe.py check` succeeds.
- Reusable blocks and dependencies are explicit enough that lower agents can
  work on one local proof obligation at a time.
