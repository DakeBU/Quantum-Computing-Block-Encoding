# LeanMarathon Reference Notes

QBE keeps a local development checkout of
[YuanheZ/LeanMarathon](https://github.com/YuanheZ/LeanMarathon) as a design
reference, together with the paper
[LeanMarathon: Toward Reliable AI Co-Mathematicians through Long-Horizon Lean Autoformalization](https://arxiv.org/abs/2606.05400).
When a local checkout is present, the shared external-root convention places it
under `../outer_repos/automation_systems/LeanMarathon`; the corresponding paper
belongs under `../outer_papers/automation_systems/`.

## Similar Patterns Studied

LeanMarathon is aimed at research-level Lean autoformalization.  The patterns
most relevant to QBE are:

- an evolving blueprint as a system of record;
- an adversarial target-review stage before broad proving;
- proof DAG extraction and discharge from dynamic leaves;
- bounded worker scopes, one node per worker;
- refiner passes that repair connected illness areas rather than independent
  symptoms;
- deterministic CI as the only merge authority;
- context discipline: agents read the active phase and required files, not the
  entire repository.

## QBE Adaptation

QBE cannot use the exact LeanMarathon blueprint format as-is because a
block-encoding proof must track source-paper notation, quantum registers,
oracle contracts, normalizers, circuit matrices, resource claims, and
Markdown/LaTeX exposition.  QBE therefore uses a split blueprint:

- Lean declarations in `QuantumBlockEncoding/` are the formal core;
- `conversion-windows/` preserve symbol and source-paper correspondence;
- `proof-obligations/` record open semantic, circuit, and cited-result gaps;
- `paper-notes/` export accepted Lean proof blocks to human mathematics;
- `proof-blueprints/` provide compact system-of-record snapshots for agents.

The command

```bash
python3 tools/qbe.py blueprint-refresh <task-id>
```

refreshes that compact snapshot.  `run-cycle` and `sleep-run` can refresh it
before generating prompts with `--blueprint-refresh`.

## Differences From LeanMarathon

LeanMarathon is a general paper-level Lean autoformalization harness using
GitHub PRs, worktrees, target reviewers, workers, refiners, and CI merges.  QBE
uses a lighter local harness because the current target is a domain-specific
quantum library, not a generic Mathlib formalization benchmark.

QBE's distinctive requirements are:

- faithful paper mode must not mutate the paper construction;
- exploratory mode may evolve circuit candidates, but only under a fixed
  Lean-checkable block-encoding predicate;
- external quantum subroutines can be recorded as typed cited contracts before
  they are recursively formalized;
- middle agents must maintain Lean/Markdown/LaTeX translation, not only Lean
  proof nodes;
- reviewer agents must check oracle register semantics, ancilla cleanup,
  normalizers, resource counts, and hidden oracle assumptions.

## Combined Strategy

The current QBE orchestration combines several similar patterns:

| Layer | Similar pattern | QBE role |
|---|---|---|
| Plain-file substrate | ARIS | Project-local skills, task files, conversion windows, manifests, research wiki pages, and run logs. |
| Iterative controller | Learning Beyond Gradients | Upper/middle/lower plus reviewer cycles, trial memory, failure compression, and proof-system maintenance. |
| Exploratory search | EoH | Candidate circuit/oracle populations with mutation, recombination, selection, and archives, only in exploratory construction mode. |
| Lean harness control | LeanMarathon | Proof-blueprint snapshots, target review before broad proving, dynamic leaves, refiner-style repair, and deterministic Lean gates. |
| Proof diagnostics | MathCode | Hidden-assumption scans, theorem-reuse memory, and proof-attempt diagnostics. |

LeanMarathon strengthens QBE's harness engineering, but it does not replace the
older QBE design.  The LBG-like role hierarchy still decides and compresses
the iterative proof process; the EoH-like population layer remains the search
tool for new circuit constructions; ARIS-style plain files remain the human
and agent interface.

The final authority remains Lean plus explicit correspondence artifacts.  A
candidate score, an agent self-assessment, or a prose explanation is never a
proof of a block-encoding theorem.
