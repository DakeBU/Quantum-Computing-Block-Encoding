# Notices

This project includes an automation workflow inspired by:

- `wanshuiyin/Auto-claude-code-research-in-sleep`
  - Repository: https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep
  - License: MIT

QBE adapts ARIS ideas including plain-file artifact contracts, manifest
tracking, project-local skills, conversion windows, research wiki layout, and
review gates. The implementation in `tools/qbe.py` is domain-specific to Lean
block-encoding proof automation.

This project also references:

- Jiayi Weng, Learning Beyond Gradients
  - Article: https://trinkle23897.github.io/learning-beyond-gradients/
  - Artifact repository: https://github.com/Trinkle23897/learning-beyond-gradients
  - Borrowed pattern: append-only trial logs, summary CSVs, explicit failure
    memory, and iterative upper/middle/lower plus reviewer maintenance of a
    heuristic proof system.
- `FeiLiu36/EoH`
  - Repository: https://github.com/FeiLiu36/EoH
  - Role: similar pattern for evolutionary search over structured candidates,
    including initialization, mutation, recombination/crossover, selection, and
    population archives.
  - QBE adaptation: exploratory block-encoding construction mode may maintain
    candidate circuit/oracle populations under a fixed Lean-checkable target.
    Faithful paper-reproduction mode does not mutate the paper construction.
- `Timeroot/Lean-QuantumInfo`
  - Repository: https://github.com/Timeroot/Lean-QuantumInfo
  - License: MIT
  - Role: style reference for finite-dimensional quantum formalization.
- `duckki/quantum-computing-lean`
  - Repository: https://github.com/duckki/quantum-computing-lean
  - Role: style reference for finite-dimensional quantum matrices, states,
    gates, projectors, gate actions, decompositions, and public module-graph
    organization.
  - Note: the inspected local checkout did not include a top-level license file,
    so QBE records source links and does not reuse source code.
- `teorth/optimizationproblems`
  - Repository: https://github.com/teorth/optimizationproblems
  - Role: style reference for open-problem registries.
- `math-ai-org/mathcode`
  - Repository: https://github.com/math-ai-org/mathcode
  - Role: similar pattern for Lean proof diagnostics, theorem reuse memory,
    persistent proof feedback, tree-of-subgoals decomposition, multi-planner
    proof search, and skills/tools/plugins.
  - Note: the local checkout inspected during development did not include a
    top-level license file, so QBE records citation/source links and does not
    reuse MathCode source code.
- Xiyu Zhai, Xinyi Chen, Yiping Wang, Runlong Zhou, Liao Zhang, Simon S. Du,
  Visored: A Controlled-Natural-Language Prover for LLM-Generated Mathematics
  - Paper: https://arxiv.org/abs/2606.17581
  - Repository: https://github.com/xiyuzhai-husky-lang/visored
  - Role: similar pattern for controlled-natural-language proof packets,
    localized diagnostics, rule-driven routine proof closure, and optional
    emission to Lean.
  - QBE adaptation: natural-language lower agents should produce constrained
    proof packets, while Lean lower agents may work directly in Lean in
    parallel.  Middle agents use the packet format as a two-way exchange
    object between natural-language insights, Lean proof leaves, and human
    proof exports.  QBE does not use Visored as an acceptance gate and does not
    reuse Visored source code.
- Yuanhe Zhang, Yuekai Sun, Taiji Suzuki, Jason D. Lee, Fanghui Liu,
  LeanMarathon: Toward Reliable AI Co-Mathematicians through Long-Horizon Lean
  Autoformalization
  - Paper: https://arxiv.org/abs/2606.05400
  - Repository: https://github.com/YuanheZ/LeanMarathon
  - Role: similar pattern for Lean blueprint system-of-record design,
    target-review before proof discharge, dynamic proof-DAG leaves,
    worker/refiner scoping, and deterministic CI gates.
  - QBE adaptation: local proof-blueprint snapshots, source-contract review,
    dynamic leaf queues, and proof-discharge prompts specialized to quantum
    oracle/block-encoding circuit matrices.
