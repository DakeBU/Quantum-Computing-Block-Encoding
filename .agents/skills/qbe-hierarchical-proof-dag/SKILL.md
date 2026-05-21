---
name: qbe-hierarchical-proof-dag
description: Plan and review QBE proof work as reusable Lean proof DAGs instead of flat repeated traces, using arXiv:2602.10512v2 as the guiding theorem-prover methodology.
argument-hint: "[task id or Lean theorem]"
---

# QBE Hierarchical Proof DAG

Use this when a faithful paper-reproduction task or exploratory construction
has repeated subarguments, expensive local proof search, or many similar Lean
goals.

This skill adapts the main lesson of Sonoda, Akiyama, and Uezato,
"Exponential Sample Complexity Separation between Flat and Hierarchical
Agentic Theorem Provers", arXiv:2602.10512v2.  The paper models theorem proving
as verifier-guided search and explains why a hierarchical prover can need far
less successful trace data when it represents repeated subproofs as a reusable
proof DAG with memoized blocks instead of flattening every occurrence.

## QBE Translation

- The verifier is Lean.
- Low-level actions are local tactics, rewrites, `simp`/`omega`/`native_decide`,
  matrix-entry calculations, and theorem applications.
- High-level actions are decomposition choices: introduce a lemma, choose a
  reusable block interface, schedule dependencies, or call an already proved
  block.
- The proof DAG consists of named Lean declarations and proof obligations.
- Memoization means proving a block once and referencing it everywhere else.

## When To Apply

Apply this skill when:

- a lower agent repeats the same proof idea in several places;
- `native_decide` or symbolic matrix computation is expensive for a full
  product but cheap for local blocks;
- several gates share the same bit-slice, register-layout, or matrix-index
  lemma;
- a paper theorem naturally factors through intermediate lemmas;
- an exploratory candidate has reusable oracle components.

## Required Artifact

Add or update a proof-DAG table in the relevant conversion window or
proof-obligation ledger:

| Block | Interface | Dependencies | Lean declaration | Reused by | Local gate | Status |
|---|---|---|---|---|---|---|

The interface should state exactly what the block proves or constructs.  For
QBE, useful interfaces include:

- `dimension`: a qubit/register dimension equality;
- `index`: a bit-slice or sparse-column mapping lemma;
- `gate`: a matrix semantics declaration for one circuit gate;
- `unitary`: a gate unitarity obligation;
- `projection`: a signal-system block extraction lemma;
- `normalizer`: an alpha/resource bound;
- `composition`: a product-of-gates or block-correctness step.

## Agent Protocol

- Upper chooses the next block whose reuse would reduce the largest flat
  duplication.
- Middle keeps the DAG table synchronized with Lean, Markdown, and LaTeX.
- Lower proves or refines one block interface at a time.
- Reviewer rejects duplicated definitions, repeated flat proof scripts, and
  changes that add assumptions instead of proving a block.

## Faithful Paper Mode

The DAG is only a decomposition of the paper's construction.  It must not
change the theorem, add side conditions, replace an oracle, or introduce a new
assumption.  If a block cannot be proved, leave the original statement intact
and record the block as a proof obligation.

## Exploratory Mode

Candidate populations should evolve proof/oracle DAGs, not just flat scripts.
Scores may include smaller flat-risk estimates, more reused blocks, fewer
obligations, faster Lean checks, and better local test coverage.  A score is
not a proof; Lean-checked acceptance remains final.
