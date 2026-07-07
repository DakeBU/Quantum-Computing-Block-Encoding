# Tasks

Task contracts for AI-assisted Lean formalization work.

Create a task with:

```bash
python3 tools/qbe.py new-task QBE-AUTO-004 \
  --kind statePreparation \
  --mode statePreparation \
  --title "Prepare my target quantum state"
```

Each task should record:

- mode: state preparation, operator block-encoding construction, paper
  benchmark, or exploratory improvement,
- for state preparation: target state `|psi>`, normalization status, initial
  state usually `|0^n>`, and the acceptance equation
  `U |0^n> = |psi>`,
- for block encoding: target operator/matrix `A`, normalizer `alpha`, and
  required block projector, usually
  `(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha`,
- accepted approximation budget, usually
  `|| A - alpha * ((<0^a| ⊗ I) U_A (|0^a> ⊗ I)) || <= epsilon`,
- exact-search budget, stall budget, and whether epsilon relaxation is allowed,
- candidate unitary/circuit family,
- auxiliary qubit count `a`,
- score ordered as `(gateCount, depth, auxiliaryQubits, oracleCalls)` inside
  one semantic/asymptotic tier,
- source paper or open problem,
- Lean declarations to create or repair,
- proof obligations,
- build-gate status.

Paper-benchmark tasks must state the paper construction being reproduced and
must not ask lower agents to invent substitutes.  Exploratory improvement tasks
must state the same Lean-checkable operator target before construction search
starts.

State-preparation, operator-construction, and exploratory tasks should use
`candidate-populations/` to keep competing circuit families and partial
Lean/resource scores.  State-preparation tasks must preserve the first-column
invariant: the first column of the candidate unitary is the target state.  They
should reject unnormalized unitary-output claims unless the vector is
normalized or the task is restated as a rank-one operator.

Operator block-encoding tasks should prefer exact block encodings first.  If
exact search reaches the user's resource floor, keep that exact champion as an
`epsilon = 0` approximate incumbent and continue only if approximate search can
find a cheaper certified candidate.  If exact search stalls or misses the
floor, switch to approximate search and report any relaxed epsilon explicitly.
Paper benchmark tasks may use `proof-attempts/` to keep several proof routes
for the same source theorem.

Do not mark a task complete unless:

```bash
lake build && lake build Tests
```

succeeds.
