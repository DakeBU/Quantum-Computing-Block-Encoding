# Tasks

Task contracts for AI-assisted Lean formalization work.

Create a task with:

```bash
python3 tools/qbe.py new-task QBE-AUTO-004 \
  --mode faithfulPaper \
  --title "Formalize sparse access oracle"
```

Each task should record:

- mode: faithful paper reproduction or exploratory construction,
- target oracle or block encoding,
- source paper or open problem,
- Lean declarations to create or repair,
- proof obligations,
- build-gate status.

Faithful paper-reproduction tasks must state the paper construction being
reproduced and must not ask lower agents to invent substitutes.  Exploratory
tasks must state the Lean-checkable acceptance predicate before construction
search starts.

Faithful tasks may use `proof-attempts/` to keep several proof routes for the
same theorem.  Exploratory tasks may use `candidate-populations/` to keep
competing circuit families and partial Lean scores.

Do not mark a task complete unless:

```bash
lake build && lake build Tests
```

succeeds.
