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
- Bo Xue, Yuanyu Wan, Zhichao Lu, Qingfu Zhang,
  [Beyond the Lower Bound: Bridging Regret Minimization and Best Arm Identification in Lexicographic Bandits](https://xueb1996.github.io/pdf/AAAI-2026-Xue.pdf).
  Similar pattern studied for elimination-based lexicographic active-set
  selection.  QBE adapts the scheduler idea to candidate block encodings and
  proof routes: hard Lean/necessary-condition gates dominate resource and
  process signals.  QBE does not inherit the paper's stochastic-bandit
  assumptions or sample-complexity theorems.
- [Optima-CityU/LLM4AD_Next](https://github.com/Optima-CityU/LLM4AD_Next).
  Similar pattern studied for low-entry-barrier problem-to-configuration user
  interfaces.  QBE adapts this as a static oracle-to-task-packet web builder
  for users who do not want to begin from GitHub commands.
- [math-ai-org/mathcode](https://github.com/math-ai-org/mathcode).
  Similar patterns studied for Lean proof diagnostics, theorem-store-like reuse
  memory, persistent Lean feedback, tree-of-subgoals proving, multi-planner
  proof search, and skills/tools/plugins.  QBE adapts those ideas to
  Lean-checked quantum circuit and block-encoding formalization; it does not
  copy MathCode code.  The local checkout did not include a top-level license
  file at the time of inspection, so QBE records source links and citation
  metadata rather than license-dependent reuse.
- Xiyu Zhai, Xinyi Chen, Yiping Wang, Runlong Zhou, Liao Zhang, Simon S. Du,
  [Visored: A Controlled-Natural-Language Prover for LLM-Generated Mathematics](https://arxiv.org/abs/2606.17581)
  and [xiyuzhai-husky-lang/visored](https://github.com/xiyuzhai-husky-lang/visored).
  Similar patterns studied for a controlled-natural-language proof surface,
  localized elaboration/solver diagnostics, rule-driven closure of routine
  proof steps, and optional Lean emission.  QBE adapts this as a discipline for
  structured proof packets that allow natural-language construction workers and
  Lean workers to exchange ideas in both directions, while middle agents keep
  Lean-facing leaves and human-readable proof exports aligned.  QBE does not
  use Visored as a correctness gate and does not copy Visored source code.
- Yuanhe Zhang, Yuekai Sun, Taiji Suzuki, Jason D. Lee, Fanghui Liu,
  [LeanMarathon: Toward Reliable AI Co-Mathematicians through Long-Horizon Lean Autoformalization](https://arxiv.org/abs/2606.05400)
  and [YuanheZ/LeanMarathon](https://github.com/YuanheZ/LeanMarathon).
  Similar patterns studied for Lean blueprint-as-system-of-record design,
  target-review before proof discharge, dynamic proof-DAG leaves, bounded
  worker/refiner roles, and deterministic CI gates.  QBE adapts these control
  ideas to quantum block-encoding/oracle-circuit formalization while retaining
  its own ARIS/LBG/EoH-style local memory, hierarchy, reviewer loop, and
  exploration modes.
- Ruida Wang, Jerry Huang, Pengcheng Wang, Xuanqing Liu, Luyang Kong,
  Tong Zhang,
  [Lean4Agent: Formal Modeling and Verification for Agent Workflow and Trajectory](https://arxiv.org/abs/2606.06523).
  Similar pattern studied for Lean-level workflow and trajectory verification.
  QBE adapts this only to process contracts and future log-invariant checks;
  it does not treat workflow verification as a substitute for the quantum
  theorem.

## Layered Design Summary

QBE combines these references as a layered system:

- ARIS-like substrate: plain files, local skills, manifests, research wiki, and
  inspectable artifacts.
- Learning-Beyond-Gradients-like controller: upper/middle/lower/reviewer
  iterations, trial memory, failure compression, and ongoing proof-system
  maintenance.
- EoH-like exploration: candidate populations for new circuit/oracle
  constructions, used only after the target predicate is fixed.
- LexElim-like selection: active-set filtering for candidate/proof-route
  populations under hard/soft lexicographic feedback.
- Visored-like interface discipline: controlled proof packets and localized
  diagnostics as a two-way exchange format between natural-language proof
  search, Lean proof search, and human proof exports.
- LeanMarathon-like harness control: proof-blueprint snapshots, target review,
  dynamic proof leaves, refiner-style repair, and deterministic gates.

QBE's domain-specific advantage is that all of those automation patterns are
specialized to gate-level quantum oracle and block-encoding proofs, where
register maps, ancilla cleanup, normalizers, resource counts, and
Lean/Markdown/LaTeX correspondence must be tracked explicitly.

## Lean And Problem-Registry References

- [duckki/quantum-computing-lean](https://github.com/duckki/quantum-computing-lean).
  Used as a reference for finite-dimensional quantum Lean organization:
  matrices, named states, basic gates, projectors, gate actions,
  decompositions, and small theorem examples.  The inspected local checkout did
  not include a top-level license file, so QBE records source links and uses it
  as a style/reference atlas rather than copying code into this repository.
- [Timeroot/Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo),
  MIT License. Used as a style reference for finite-dimensional quantum
  formalization over matrices.
- [Hayata-Yamasaki-Group/lean-quantum](https://github.com/Hayata-Yamasaki-Group/lean-quantum),
  Apache-2.0 License. Used as a reference library for quantum states, qudits,
  quantum channels, partial traces, entropy, trace inequalities, and
  operator-theoretic Lean conventions. It is not currently imported as a QBE
  dependency.
- [teorth/optimizationproblems](https://github.com/teorth/optimizationproblems).
  Used as a style reference for concise open-problem registries.

## Literature Links

The compiled literature registry with paper links lives in
`QuantumBlockEncoding/Literature.lean`; the README mirrors that list for
clickable browsing.

Future versions can optionally depend on Mathlib or Physlib once the project is
ready to prove stronger matrix-level unitary and norm statements.
