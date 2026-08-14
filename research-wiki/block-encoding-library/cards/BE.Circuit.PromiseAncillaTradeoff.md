# BE.Circuit.PromiseAncillaTradeoff

Priority: P1 when auxiliary-qubit count or controlled-conjugation cost is active.

Source: arXiv:2603.12917, promise gates and the ancilla/control tradeoff.

Status: literature-backed planning card. No general Lean theorem is claimed.

## Detect When

Try this mutation only when a candidate contains a controlled conjugation

$$
W = V^\dagger U V
$$

and either uses clean work qubits inside `V`/`U` or pays to control all three
parts. It is especially relevant when the lexicographic comparison has already
fixed correctness and gate count, but auxiliary qubits or controlled depth are
still expensive.

## Candidate Mutation

1. Treat qubits known to be zero on the accepted input subspace as a promise
   register.
2. Replace the clean-ancilla implementations of `V` and `V^dagger` by matching
   weak promise-gate implementations.
3. Control the middle operation, not the outer conjugating pair.
4. Preserve the compute-uncompute relation so the promise/work register is
   restored on the accepted branch.
5. If `U^2 = I` and both implementations preserve workspace on every input,
   consider the stronger dirty-ancilla variant.

## Required Proof Leaves

- exact factorization `W = V^dagger * U * V`;
- a precise promise predicate and proof that accepted inputs satisfy it;
- promised-subspace semantics for both `V` and `V^dagger`;
- restoration/compute-uncompute theorem;
- involution `U^2 = I` before any dirty-ancilla mutation;
- same-tier resource count under the selected primitive compiler;
- clean-block or state-preparation certificate after the rewrite.

Failure of any leaf keeps this as an exploratory population member. A Qiskit
match may reject or prioritize it, but cannot establish the promise or cleanup
theorems.

## Upper-Agent Rule

When this card matches, upper should ask middle for two candidates: the current
clean-ancilla route and one promise-register mutation. Do not replace the
baseline until the verifier confirms the promise, restoration, and comparable
cost convention. This is a targeted crossover/mutation, not permission to
increase agent count or relax epsilon automatically.

## Circuit-LaTeX Pattern

Use `quantikz` so the construction remains editable:

```latex
\begin{quantikz}[row sep=.45cm, column sep=.35cm]
\lstick{$\ket{p}$} & \gate[wires=2]{\widetilde V} &
  \ctrl{1} & \gate[wires=2]{\widetilde V^\dagger} & \qw \\
\lstick{$\ket{\psi}$} &                         &
  \gate{U} &                                      & \qw
\end{quantikz}
```

## Retrieval Keywords

promise gate, conditionally clean ancilla, dirty ancilla, controlled
conjugation, compute-uncompute, involution, auxiliary qubit, register reuse.
