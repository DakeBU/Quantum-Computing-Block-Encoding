---
name: qbe-proof-diagnostics
description: Audit QBE Lean proof progress for hidden axioms, placeholders, suspicious semantic-flag promotions, and reusable proof-block memory, using MathCode-like diagnostics adapted to block-encoding formalization.
argument-hint: "[task id or Lean file]"
---

# QBE Proof Diagnostics

Use this skill when a QBE agent or reviewer needs to audit Lean proof progress,
detect hidden assumptions, summarize remaining placeholders, or decide whether
a failed proof attempt produced reusable proof-block memory.

This skill is inspired by similar diagnostic patterns in
[math-ai-org/mathcode](https://github.com/math-ai-org/mathcode), especially its
Lean proof-analysis tools and theorem-store workflow. QBE adapts the pattern to
block-encoding/oracle formalization; it does not treat diagnostic scores as
proof.

## Required Checks

Before accepting a Lean proof or semantic flag promotion, run or emulate these
checks:

1. Proof-blueprint refresh:

```bash
python3 tools/qbe.py blueprint-refresh <task-id>
```

If the blueprint says the active lower target is already compiled or stale,
reviewer should ask upper/middle to retire that leaf before more proof search.

2. Full project gate:

```bash
python3 tools/qbe.py check
```

3. Hidden proof shortcut scan:

```bash
rg -n "Prop := True|:= trivial|\\bsorry\\b|\\badmit\\b|\\baxiom\\b|\\bconstant\\b|\\bpostulate\\b" \
  QuantumBlockEncoding Tests \
  -g '!QuantumBlockEncoding/Automation.lean'
```

4. Semantic flag scan for suspicious promotions:

```bash
rg -n "sparseCorrect := True|amplitudeCorrect := True|lcuCorrect := True|proved := true|Proved := true" \
  QuantumBlockEncoding Tests
```

If a scan has expected benign matches, the reviewer must name the declaration
and explain why it is not a hidden theorem closure.

## Failure Classification

Classify every failed proof attempt as exactly one of:

| Class | Meaning | Next action |
|---|---|---|
| source translation gap | The paper proof step has not been mapped to Lean declarations. | Middle updates conversion window and proof obligations. |
| local Lean lemma gap | The needed fact is QBE-local arithmetic, matrix indexing, projection, or coefficient algebra. | Lower proves a focused lemma or records a proof-attempt population. |
| external cited contract | The paper relies on a prior result not yet formalized in QBE. | Add/update `research-wiki/cited-results/`; keep status `obligation` unless proved. |
| semantic interface gap | Existing QBE structures cannot express the needed statement cleanly. | Add the smallest typed interface, without adding assumptions to the theorem. |
| invalid route | The attempt changes the paper construction or weakens the theorem. | Reject and record the reason in trial memory. |
| stale dynamic leaf | The assigned lower target is already compiled or no longer matches the active blueprint. | Upper/middle retire the directive, refresh the blueprint, and choose the next leaf. |
| connected illness area | Several failures share a wrong source contract, interface, or dependency. | Run a refiner-style repair for the shared area instead of independent lower attempts. |

## Reuse Memory

When a failed proof produced useful fragments, save them under
`proof-attempts/<task-id>/` with:

- target theorem,
- exact statement attempted,
- useful intermediate lemmas,
- failed tactic or rewrite route,
- Lean error or remaining goal,
- whether the fragment should become a shared proof-DAG block.

Do not keep proof-attempt memory only in an agent transcript. It must be a file
that future agents can read without replaying the whole run.

## Theorem-Store Analogue For QBE

QBE should gradually build a small domain-specific reuse library. Good
candidates are:

- finite basis/index conversion lemmas,
- signal-zero block projection lemmas,
- sparse-register branch decomposition lemmas,
- coefficient normalizer algebra,
- dagger/transpose entry lemmas,
- gate-list to matrix-product semantics bridges.

Prefer named Lean declarations over repeated inline proof scripts. A theorem is
eligible for reuse only after it is build-tested and appears in the
Markdown/LaTeX proof map if it corresponds to a paper step.

## Faithful Mode Boundary

In faithful paper-reproduction mode, this skill must not be used to introduce
new axioms, replacement circuits, extra assumptions, or easier target
statements. Diagnostics may suggest contracts and proof obligations, but the
paper construction remains fixed.
