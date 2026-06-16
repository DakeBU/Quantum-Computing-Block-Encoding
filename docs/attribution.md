# Attribution

This project cites external work by original source link. Local checkouts may
be used during development, but the public reference is always the upstream
paper or repository.

## Primary Mathematical Target

- Nikita Guseynov, Xiajie Huang, Nana Liu,
  [Quantum framework for simulating linear PDEs with Robin boundary conditions](https://arxiv.org/abs/2506.20478).

## Automation References

- [wanshuiyin/Auto-claude-code-research-in-sleep](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep),
  MIT License. Borrowed ideas: plain-file agent workflow, artifact contracts,
  conversion windows, research wiki layout, and review gates.
- Jiayi Weng,
  [Learning Beyond Gradients](https://trinkle23897.github.io/learning-beyond-gradients/)
  and [artifact repository](https://github.com/Trinkle23897/learning-beyond-gradients).
  Borrowed ideas: append-only trial JSONL, rewritten summary CSV, explicit
  failure memory, and iterative upper/middle/lower plus reviewer maintenance
  of a heuristic proof system.
- [FeiLiu36/EoH](https://github.com/FeiLiu36/EoH).
  Similar patterns studied for evolutionary search over structured candidates:
  initialization, mutation, recombination/crossover, selection pressure, and
  population archives.  QBE keeps this idea for operator-construction and
  exploratory-improvement modes,
  where candidate circuit/oracle families may evolve under a fixed
  Lean-checkable acceptance predicate.  Paper-benchmark mode does not use
  EoH-style mutation to alter a paper's construction.
- [math-ai-org/mathcode](https://github.com/math-ai-org/mathcode).
  Similar patterns studied for Lean proof diagnostics, theorem-store-like reuse
  memory, persistent Lean feedback, tree-of-subgoals proving, multi-planner
  proof search, and skills/tools/plugins.  QBE adapts those ideas to
  Lean-checked quantum circuit and block-encoding formalization; it does not
  copy MathCode code.  The local checkout did not include a top-level license
  file at the time of inspection, so QBE records source links and citation
  metadata rather than license-dependent reuse.
- Yuanhe Zhang, Yuekai Sun, Taiji Suzuki, Jason D. Lee, Fanghui Liu,
  [LeanMarathon: Toward Reliable AI Co-Mathematicians through Long-Horizon Lean Autoformalization](https://arxiv.org/abs/2606.05400)
  and [YuanheZ/LeanMarathon](https://github.com/YuanheZ/LeanMarathon).
  Similar patterns studied for Lean blueprint-as-system-of-record design,
  target-review before proof discharge, dynamic proof-DAG leaves, bounded
  worker/refiner roles, and deterministic CI gates.  QBE adapts these control
  ideas to quantum block-encoding/oracle-circuit formalization while retaining
  its own ARIS/LBG/EoH-style local memory, hierarchy, reviewer loop, and
  exploration modes.

## Layered Design Summary

QBE combines these references as a layered system:

- ARIS-like substrate: plain files, local skills, manifests, research wiki, and
  inspectable artifacts.
- Learning-Beyond-Gradients-like controller: upper/middle/lower/reviewer
  iterations, trial memory, failure compression, and ongoing proof-system
  maintenance.
- EoH-like exploration: candidate populations for new circuit/oracle
  constructions, used only after the target predicate is fixed.
- LeanMarathon-like harness control: proof-blueprint snapshots, target review,
  dynamic proof leaves, refiner-style repair, and deterministic gates.

QBE's domain-specific advantage is that all of those automation patterns are
specialized to gate-level quantum oracle and block-encoding proofs, where
register maps, ancilla cleanup, normalizers, resource counts, and
Lean/Markdown/LaTeX correspondence must be tracked explicitly.

## Lean And Problem-Registry References

- [Timeroot/Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo),
  MIT License. Used as a style reference for finite-dimensional quantum
  formalization over matrices.
- [teorth/optimizationproblems](https://github.com/teorth/optimizationproblems).
  Used as a style reference for concise open-problem registries.

## Literature Links

The compiled literature registry with paper links lives in
`QuantumBlockEncoding/Literature.lean`; the README mirrors that list for
clickable browsing.

Future versions can optionally depend on Mathlib or Physlib once the project is
ready to prove stronger matrix-level unitary and norm statements.
