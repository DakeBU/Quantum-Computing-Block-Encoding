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
  failure memory, and iterative upper/middle/lower maintenance of a heuristic
  system.

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
