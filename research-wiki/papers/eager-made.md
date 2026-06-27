# EAGER and MADE Paper Notes

This note records two automation-system references that are useful for ABEIS
failure handling and reviewer scoring.

## Efficient Failure Management with Reasoning Traces

- arXiv: `2603.21522`
- Local PDF:
  `outer_papers/automation_systems/failure_judge_systems/2603.21522/EAGER_reasoning_trace_failure_management.pdf`
- Code status: no public repository found during inspection; rechecked
  2026-06-27 against arXiv pages and web search.
  Repository-status note:
  `outer_repos/automation_systems/failure_judge_systems/README.md`.

ABEIS counterpart design:

- convert long proof-search logs into typed failure packets;
- separate fine-grained leaf failures from coarse route failures;
- retrieve prior failures before assigning a repeated lower task;
- use failure as mathematical signal: false statement, missing assumption,
  wrong semantic tier, or missing external contract.

## Evolution without an Oracle / MADE

- arXiv: `2511.19489v1`
- Local PDF:
  `outer_papers/automation_systems/failure_judge_systems/2511.19489/MADE_evolution_without_oracle.pdf`
- Code status: no public repository found during inspection; rechecked
  2026-06-27 against arXiv pages and web search.
  Repository-status note:
  `outer_repos/automation_systems/failure_judge_systems/README.md`.

ABEIS counterpart design:

- decompose reviewer judgment into requirement vectors instead of one vague
  score;
- render each candidate into artifacts before judging: Lean statement,
  proof-DAG leaves, resource tuple, verifier packet, and human proof sketch;
- keep hard gates and soft signals separate;
- use judge feedback to mutate/recombine candidates, but require Lean
  promotion before a candidate joins the certified population.
