# ASTIS Reference Notes

Sibling local reference:

```text
/home/nitanda_sub/mark/repos/Auto-Sampling-Theory-In-Sleep
```

ABEIS and ASTIS are separate auto-Lean-in-sleep projects.  ASTIS targets
sampling theory and SDE/probability formalization; ABEIS targets quantum
oracle and block-encoding circuit formalization.  The useful overlap is the
automation harness, not the mathematical domain.

## Similar Patterns Reused

| Similar pattern | ASTIS practice | ABEIS adaptation |
|---|---|---|
| Shared external roots | ASTIS keeps reference repositories and papers under shared `outer_repos` and `outer_papers` roots. | ABEIS now uses the same categorized external-root convention: `outer_repos/automation_systems`, `outer_repos/quantum`, `outer_repos/sampling_theory_sde`, `outer_papers/quantum`, `outer_papers/sampling_theory_sde`, and `outer_papers/automation_systems`. |
| Compact status artifacts | ASTIS writes blueprint/status files so agents do not replay a long history before every run. | ABEIS adds `python3 tools/qbe.py blueprint-status <task> --refresh`, writing Markdown and JSON over the active proof blueprint. |
| Token-lean context packs | ASTIS uses context packs for focused long-run prompts. | ABEIS adds `python3 tools/qbe.py write-context-pack <task> --cycle <n>` with block-encoding-specific paper-source, blueprint, and trial context. |
| Efficiency reports | ASTIS uses post-run reports to detect broad replay, quota waste, or stale blockers. | ABEIS adds `python3 tools/qbe.py efficiency-report --task <task>` to summarize logs, build signals, stale leaves, and next-run controls. |
| Source dependency discipline | ASTIS checks local paper sources before inventing missing proof infrastructure. | ABEIS applies the same discipline to faithful paper reproduction: blocked oracle/circuit proofs must be classified as internal paper steps, external cited results, classical Lean lemmas, contract drift, or source-contract gaps. |

## ABEIS-Specific Differences

ABEIS cannot copy ASTIS's mathematical packet structure directly.  A
block-encoding proof must track:

- circuit matrices and gate placement,
- register order and ancilla cleanup,
- block-projection entries,
- normalizers and resource counts,
- oracle contract boundaries,
- Lean/Markdown/LaTeX correspondence to the source paper.

Therefore, ABEIS keeps its domain-specific directories such as
`conversion-windows/`, `proof-obligations/`, `proof-blueprints/`,
`paper-notes/`, `candidate-populations/`, and
`research-wiki/cited-results/`.

## Current ABEIS Commands Added From This Lesson

```bash
python3 tools/qbe.py blueprint-status QBE-AUTO-002 --refresh
python3 tools/qbe.py write-context-pack QBE-AUTO-002 --cycle 1
python3 tools/qbe.py efficiency-report --task QBE-AUTO-002
```

These commands should be used around long faithful-paper or exploratory runs:
first inspect the blueprint/status, then run agents from a compact context, and
finally write an efficiency report before assigning the next batch.
