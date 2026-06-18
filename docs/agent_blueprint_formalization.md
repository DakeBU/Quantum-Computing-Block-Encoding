# Agent Blueprint Formalization Notes

ABEIS now treats the agent workflow as an object that can be audited, and later
formalized, separately from the quantum theorem being proved.

## Goedel-Architect Similar Pattern

[arXiv:2606.06468](https://arxiv.org/abs/2606.06468) motivates a stronger
blueprint discipline: a proof task should be a dependency DAG, solved nodes
should be preserved, and failed nodes should be diagnosed as wrong statement,
missing dependency, proof too hard, or stale route.  ABEIS applies this to
block-encoding proof leaves: oracle contracts, finite matrix entries, cleanup
conditions, normalizers, and source-paper correspondence are distinct nodes.

## Lean4Agent Similar Pattern

[arXiv:2606.06523](https://arxiv.org/abs/2606.06523) motivates verifying the
agent workflow itself.  ABEIS uses this now at the process-contract level and
keeps a stronger formalization as a next step.

Already implemented in ABEIS:

- `QuantumBlockEncoding/Automation.lean` compiles role types, task kinds,
  acceptance gates, post-cycle artifact kinds, and workflow check specs.
- The harness distinguishes certified candidates from insight-pool candidates:
  only Lean-closed candidates can be plotted as solved or used as evolutionary
  parents.
- Six-hour closeouts require a Chinese human summary and a self-contained
  ChatGPT Pro prompt when the target remains unfinished.
- Inner cycles maintain Lean/natural-language correspondence; LaTeX proof
  notes are closeout artifacts, not per-lemma distractions.

Next process-verification target:

- structural checks: required agents and artifact edges exist;
- semantic checks: every lower task has a precondition and postcondition;
- trajectory checks: failed routes are recorded and not reassigned unchanged.

This workflow formalization must not weaken the quantum theorem.  It only checks
the process that produces proof attempts; `lake build` and the Lean theorem
statements remain the mathematical authority.
