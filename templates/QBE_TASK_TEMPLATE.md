# TASK_TITLE

Task id: `TASK_ID`
Kind: `paperFormalization | oracleRealization | blockEncodingSearch | openProblemProposal`
Status: `planned`

## Goal

State the target oracle or block encoding.

## Source

- Paper link:
- Section/theorem:
- Existing Lean file:

## Lean Target

```lean
-- declaration names here
```

## Proof Obligations

- [ ] Matrix target is defined.
- [ ] Circuit schema is defined.
- [ ] Normalization is explicit.
- [ ] Ancilla layout is explicit.
- [ ] Resource expression is explicit.
- [ ] Build gate passes.

## Trial Logging

```bash
python3 tools/qbe.py trial-log --task TASK_ID --role lower --kind attempt --status running --notes "..."
python3 tools/qbe.py trial-summary
```

## Build Gate

```bash
lake build && lake build Tests
```
