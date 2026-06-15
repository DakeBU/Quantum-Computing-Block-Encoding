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
The same arXiv item is also cited in some bibliographies under the
cut-elimination framing "Don't Eliminate Cut"; QBE treats this as the same
source, not a second independent reference.

Use the companion statistical-provability lesson from arXiv:2602.10538 when
reviewing run efficiency: a local proof route is improving if it raises the
finite-budget chance of a Lean-verified proof, reduces average truncated proof
length, or moves work to a reusable high-mass proof state.  It is not improving
merely because it creates more prose or longer prompt context.

It also studies the similar blueprint/DAG-control pattern in LeanMarathon:
target review first, then proof discharge from dynamic leaves with worker and
refiner roles.  QBE uses this pattern through `proof-blueprints/` and
`tools/qbe.py blueprint-refresh`, not through LeanMarathon's full GitHub
worktree/PR harness.

## QBE Translation

- The verifier is Lean.
- Low-level actions are local tactics, rewrites, `simp`/`omega`/`native_decide`,
  matrix-entry calculations, and theorem applications.
- High-level actions are decomposition choices: introduce a lemma, choose a
  reusable block interface, schedule dependencies, or call an already proved
  block.
- The proof DAG consists of named Lean declarations and proof obligations.
- Memoization means proving a block once and referencing it everywhere else.

## What DAG Means

A DAG is a directed acyclic graph.  In a Lean proof project, nodes are
definitions, lemmas, theorem targets, external contracts, or explicit proof
obligations.  A directed edge `A -> B` means that block `B` depends on block
`A`.  Acyclic means there is no circular dependency: agents must prove leaves
first, then reuse those proved leaves to close higher nodes.

For QBE this is not just a diagram.  It is the scheduling object:

```text
source equation
  -> register/index lemmas
  -> gate-entry lemmas
  -> product/sandwich entry equality
  -> normalized block-encoding theorem
```

If a natural-language decomposition makes the dependency order obvious, use it
before Lean tactic search.  A lower natural-language proof architect may write
the DAG and proof sketch first; a lower Lean worker then implements exactly one
dynamic leaf from that DAG.

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

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|

The interface should state exactly what the block proves or constructs.  For
QBE, useful interfaces include:

- `dimension`: a qubit/register dimension equality;
- `index`: a bit-slice or sparse-column mapping lemma;
- `gate`: a matrix semantics declaration for one circuit gate;
- `unitary`: a gate unitarity obligation;
- `projection`: a signal-system block extraction lemma;
- `normalizer`: an alpha/resource bound;
- `composition`: a product-of-gates or block-correctness step.

Every active node should be classified as one of:

- `proved`: named Lean declaration exists and the project gate passes;
- `active leaf`: next lower-agent target with all dependencies ready;
- `blocked internal`: paper-local step needs a new Lean interface;
- `blocked external`: cited result needs a cited-results contract;
- `contract drift`: Lean statement does not match the paper source;
- `stale`: previous lower packet is already proved or no longer on the route.

The active leaf must be small enough that one lower Lean worker can plausibly
attempt it without changing the theorem statement.

## Agent Protocol

- Upper chooses the proof frontier: the highest theorem, the unproved
  dependency nodes, and one or two active leaves.
- Upper and middle refresh the proof blueprint before a long run and retire
  stale dynamic leaves.
- Middle keeps the DAG table synchronized with Lean, Markdown, LaTeX, cited
  results, and the proof blueprint.  Middle should translate the relevant
  source proof into node statements before lower proof search.
- Lower natural-language agents prove or refactor the dependency plan in prose,
  naming existing declarations and the exact next Lean node.
- Lower Lean agents prove or refine one active leaf at a time.
- Reviewer rejects duplicated definitions, repeated flat proof scripts, and
  changes that add assumptions instead of proving a block.
- Reviewer groups related failures into one refiner-style illness area when a
  shared dependency is wrong or missing.
- Reviewer also rejects lower-agent work that ignores the active leaf, repeats
  a stale route, or fails to record the natural-language-to-Lean dependency
  map after a blocked proof.
- Reviewer records whether the attempted leaf shortened future proof search:
  new reusable block, reused existing block, stale duplicate, or flat replay.

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

If the task is genuinely exploratory, borrow the split used by
Conjecturing-Proving Loop and LeanConjecturer: generate candidate oracle or
circuit statements first, filter them by syntax/dimension/non-triviality and
small finite block-entry diagnostics, then spend lower-agent proof effort only
on survivors.  Do not use conjecture generation to alter a faithful paper
theorem.
