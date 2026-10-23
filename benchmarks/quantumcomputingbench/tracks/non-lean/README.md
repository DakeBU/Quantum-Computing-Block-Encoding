# Non-Lean contribution track

This folder is the contribution inbox for natural-language questions, derivations,
counterexamples, explanations and source reviews. It is not a second dataset.
Readers do not need Lean to use these exercises. Contributors still ground every
claim in the shared graph and exact mathematical sources.

Read [the shared contract](../../shared/CONTRACT.md) and
[the executable agent goal](AGENT_GOAL.md). Export the current registry with:

```sh
python benchmarks/quantumcomputingbench/scripts/curriculum.py export --output _out/qcb-cores.json
```

Use `proposals/<UUID>.json` for a contribution, following
[the proposal example](../../shared/proposal.example.json). Existing-core views
must preserve the exact contract hash, family, split and snapshot. New targets
use `candidate:<UUID>` and remain uncounted until semantic reconciliation.
Reservations are advisory, not distributed locks: check other open PRs before
starting and reconcile concurrent work at admission. Do not edit frozen releases.

Pure mathematics comes first: explain the objects, assumptions, mechanism and
failure cases, not just the name of a Lean declaration. A planned graph node is
a research/source anchor, not evidence of a completed formalization. Source-backed
NL questions may be useful without any present Lean counterpart.

The generated website exposes these views at `quantumcomputingbench/non-lean/`.
Every exercise has one canonical core page; a later Lean view links to that same
page and does not inflate the core count. Public solutions mean that these are
open training and diagnostic resources, not a secret held-out evaluation set.
