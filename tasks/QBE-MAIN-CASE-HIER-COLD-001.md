# Main case transfer-operator block encoding, no-Pro isolated Hierarchical Harness

Task id: `QBE-MAIN-CASE-HIER-COLD-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-25 22:24`

## Goal

State the query-operator target precisely.  The preferred input is a finite
matrix/operator `A`, a normalizer `alpha`, and the requested block-entry
contract:

```text
(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha
```

The system should construct a unitary candidate `U_A`, prove in Lean that it
contains the requested operator block, and score the candidate by:

1. asymptotic tier first, especially polylogarithmic versus polynomial growth,
2. gate count inside one tier,
3. depth / parallel schedule length,
4. auxiliary qubits `a`,
5. unresolved oracle calls.

State whether this is a direct operator-to-block-encoding construction task, a
paper benchmark task, or an exploratory improvement task.  Paper benchmark
tasks reproduce a cited construction as a baseline; improvement tasks may
search for a better construction only after the original target is fixed.

Hybrid strategy:

- `operatorBlockEncoding`: given `A`, search for candidate `U_A`
  constructions, prove the block-entry and unitarity contracts, and rank
  candidates by asymptotic tier, then gate count, depth, auxiliary qubits, and
  unresolved oracle calls.
- `paperBenchmark` / `faithfulPaper`: reproduce a cited construction as a
  source-faithful baseline.  Do not mutate the paper construction while proving
  the baseline.
- `exploratoryConstruction`: use Learning-Beyond-Gradients-style trial memory
  plus EoH-style candidate populations for circuit ideas.  Candidate scores are
  search hints only; Lean proof obligations decide acceptance.  This mode may
  improve a baseline after the original operator target is fixed.

LexElim scheduler discipline:

- Use LexElim-Out for faithful paper/theorem closure: filter routes by source
  faithfulness, correct Lean statement, necessary diagnostics, then proof
  progress/resources.
- Use LexElim-In for exploratory operator construction: read all feedback
  fields each round, but do not let lower-priority soft rewards override hard
  Lean correctness or necessary-condition diagnostics.

## Source

- Paper/open problem: `main case transfer operator E_k := |0><k|_time ⊗ |0><1|_type ⊗ I`
- Lean target: `QuantumBlockEncoding/MainCase.lean`

## Operator Contract

- Operator/matrix `A`:

  ```text
  E_k = |0><k|_T ⊗ |0><1|_tau ⊗ I_S
  ```

  For the reproducible main-case benchmark use `r = 1`, `k = 1`, and one
  passive qubit in `S`.
- System qubits `n`: two active qubits (`T`, `tau`) plus one passive qubit in
  the benchmark instantiation.
- Normalizer `alpha`: exact target uses `alpha = 1`.
- Required block: clean block on the block-encoding ancilla state `|0>`.
- Free parameters allowed in the oracle: candidate completion of the unitary,
  block ancilla convention, and reversible gate scheduling.  The target
  operator itself may not be changed.
- Required exactness or error tolerance: exact first.  After configured exact
  convergence, enter the approximate phase with the exact champion as
  `epsilon = 0` incumbent.

## Isolation Rule

This is the no-Pro isolated Hierarchical Harness arm.  Agents may use the
current compiled Lean library, the textbook memory cards, and general quantum
computing knowledge, but they must not use previous main-case candidate names,
previous Pro answers, previous task-specific proof scripts, or previous
Qiskit exports as a shortcut.  If they rediscover a known construction, they
must prove it under this task's own names and record it as an independent
attempt.

## Textbook-Memory Guidance

Upper agents should first consider partial permutation and clean-block
entrywise routes, because the target is a matrix-unit tensor identity.  LCU,
QSVT, and sparse access may remain in the insight pool only as comparison
routes; they should not be the first proof route unless the partial-permutation
route is shown to be blocked.

## Post-Lean Executable Exports

- Requested targets: `qiskit,qasm3`
- Export policy: Lean-first.  Generate executable code only after a named Lean
  declaration proves the advertised block-encoding theorem at the task's
  semantic tier.
- Concrete export instantiation: `r=1,k=1,passiveQubits=1`
- Expected artifact root: `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`

Supported target labels include `qiskit`, `quantum-katas`, and `qasm3`.
Each export must state its Lean source declaration, register sizes, parameter
values, normalizer, projector, resource tuple, and export check command.

## Candidate Score

The default candidate score is defined in Lean as `BlockEncodingCost`.
ABEIS first compares asymptotic tiers, because polylogarithmic growth in
the system size is qualitatively different from polynomial growth.  Inside
one fixed asymptotic/logical-library tier, the concrete comparison tuple is:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Selection is lexicographic in that order after the asymptotic tier check.
In particular, fewer gates beats a shallower schedule; depth breaks
gate-count ties; auxiliary qubits break gate/depth ties.

## Conversion Window

### Markdown

Human explanation, scope, and dependencies.

### LaTeX

Paste-ready theorem/proof statement.  Keep notation synchronized with Lean names.

### Lean

Expected file and declarations:

```lean
-- target: QuantumBlockEncoding/MainCase.lean
```

## Proof Obligations

- [ ] Matrix/operator target `A` is defined.
- [ ] Candidate unitary `U_A` or circuit schema is defined.
- [ ] Block-entry contract is stated with the exact ancilla projector.
- [ ] Unitarity of `U_A` is proved or recorded as a named obligation.
- [ ] Normalization `alpha` is explicit.
- [ ] Auxiliary qubit count `a` is explicit.
- [ ] Asymptotic tier and concrete resource score `(gateCount, depth, a, oracleCalls)` are explicit.
- [ ] Candidate comparison against the current baseline is recorded when relevant.
- [ ] `lake build && lake build Tests` succeeds.

## Agent Notes

Do not mark this task complete unless the Lean build gate passes.

Use trial logging for every substantial attempt:

```bash
python3 tools/qbe.py trial-log --task QBE-MAIN-CASE-HIER-COLD-001 --role lower --kind attempt --status running --notes "starting construction search"
python3 tools/qbe.py trial-summary
```
