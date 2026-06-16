# Tasks

Task contracts for AI-assisted Lean formalization work.

Create a task with:

```bash
python3 tools/qbe.py new-task QBE-AUTO-004 \
  --mode operatorBlockEncoding \
  --title "Construct a block encoding for my query operator"
```

Each task should record:

- mode: operator block-encoding construction, paper benchmark, or exploratory
  improvement,
- target operator/matrix `A` and normalizer `alpha`,
- required block projector, usually
  `(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha`,
- candidate unitary/circuit family,
- auxiliary qubit count `a`,
- score ordered as `(depth, gateCount, auxiliaryQubits, oracleCalls)`,
- source paper or open problem,
- Lean declarations to create or repair,
- proof obligations,
- build-gate status.

Paper-benchmark tasks must state the paper construction being reproduced and
must not ask lower agents to invent substitutes.  Exploratory improvement tasks
must state the same Lean-checkable operator target before construction search
starts.

Operator construction and exploratory tasks should use `candidate-populations/`
to keep competing circuit families and partial Lean/resource scores.  Paper
benchmark tasks may use `proof-attempts/` to keep several proof routes for the
same source theorem.

Do not mark a task complete unless:

```bash
lake build && lake build Tests
```

succeeds.
