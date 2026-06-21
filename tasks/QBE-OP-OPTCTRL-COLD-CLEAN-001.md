# Task: QBE-OP-OPTCTRL-COLD-CLEAN-001

Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## Clean-Start Rule

This task is a strict no-Pro Hierarchical Harness benchmark for the
transfer-operator target.  Agents must not use previous optctrl solutions,
previous ChatGPT Pro suggestions, previous Qiskit exports, previous candidate
names, or old run memory.  Use only this task packet, the current Lean
environment, and declarations that are already present in the sandbox target
file.

## Target Operator

Registers:

- time register `T`: one qubit;
- type register `tau`: one qubit;
- state register `S`: one passive qubit;
- block-encoding ancilla: start with one clean ancilla unless upper explicitly
  explores alternatives.

Target operator:

$$
E_1 = |0\rangle\langle 1|_T \otimes |0\rangle\langle 1|_{\tau} \otimes I_S.
$$

The system must construct a unitary candidate `U_E` and prove in Lean that its
clean block equals `E_1`.

## Resource Order

Inside the same asymptotic tier, rank Lean-certified candidates
lexicographically by:

1. gate count,
2. depth,
3. auxiliary qubits,
4. unresolved oracle calls.

Only Lean-certified candidates may be plotted as achieved solutions.

## Harness Requirements

- Upper and middle layers should spend real budget on construction strategy,
  candidate population, proof-DAG frontier, and resource-score interpretation
  before lower workers edit Lean.
- Natural-language lower workers may propose constructions and proofs, but
  acceptance requires Lean.
- Lean lower workers should prove one active leaf at a time.
- Reviewer rejects changed targets, hidden oracles, unproved optimality, and
  simulator-only claims.
- This attempt is not complete merely because it found `COLD-CLEAN-PERM-001`.
  That candidate is a Lean-certified checkpoint.  Continue exact search until
  the configured no-improvement budget is exhausted; only then enter the
  approximate-BE phase with the best exact candidate as the `epsilon = 0`
  incumbent.  If no exact improvement appears, the closeout must say so
  explicitly and must plot the no-Pro exact checkpoint separately from the
  approximate phase.
- The run remains isolated from the Pro-assisted attempt.  Do not import the
  Pro equality-transfer construction, its candidate names, or its Qiskit export
  unless a future human directive explicitly changes this arm.
- Human control override, 2026-06-21: `COLD-E1-SCOPE-AUDIT-001` is closed as an
  out-of-band worktree hygiene issue for this isolated experiment.  It must not
  block the search-convergence run.  Upper should classify the next objective
  as exact candidate improvement around the current certified checkpoint
  `(4,4,1,0)`.  If the configured no-improvement budget is exhausted, upper
  must open `COLD-E1-APPROX-PHASE-001`, beginning with the exact checkpoint as
  the `epsilon = 0` incumbent.  Only if an approximate candidate with a
  different certified resource tuple is found should the epsilon ladder move
  away from zero.

## Required Closeout Artifacts

If unresolved, write a selected-language summary and a self-contained ChatGPT
Pro prompt.  If resolved or partially resolved, additionally write:

- a step-by-step LaTeX proof note;
- a certified evolution curve and circuit storyboard;
- Qiskit export and finite executable checks for the certified construction.
