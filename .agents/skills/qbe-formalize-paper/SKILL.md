---
name: qbe-formalize-paper
description: Turn one block-encoding/oracle-construction paper into a compiled Lean skeleton or proof increment.
argument-hint: "[paper key or URL] --target: Lean file"
---

# QBE Formalize Paper

Use this when implementing one paper from `QuantumBlockEncoding/Literature.lean`.

## Workflow

1. Identify the exact construction: matrix target, circuit/oracle, normalizer,
   ancilla layout, resource statement.
2. Create a task:
   `python3 tools/qbe.py new-task <id> --title "<paper construction>"`.
3. Create a conversion window:
   `python3 tools/qbe.py conversion-window <id> --title "<paper construction>"`.
4. Add or update Lean definitions in the target file.
5. Add at least one small test in `Tests/Basic.lean` when possible.
6. Run `python3 tools/qbe.py check`.

## Acceptance

- `lake build && lake build Tests` succeeds.
- The implementation status in `Literature.lean` is not advanced beyond what
  has actually been compiled.
- Unproved mathematical content is represented as explicit proof obligations,
  not as vague prose.
