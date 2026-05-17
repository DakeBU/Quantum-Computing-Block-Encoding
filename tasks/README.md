# Tasks

Task contracts for AI-assisted Lean formalization work.

Create a task with:

```bash
python3 tools/qbe.py new-task QBE-AUTO-004 --title "Formalize sparse access oracle"
```

Each task should record:

- target oracle or block encoding,
- source paper or open problem,
- Lean declarations to create or repair,
- proof obligations,
- build-gate status.

Do not mark a task complete unless:

```bash
lake build && lake build Tests
```

succeeds.
