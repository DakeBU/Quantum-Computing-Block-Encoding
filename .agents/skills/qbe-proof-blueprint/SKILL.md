---
name: qbe-proof-blueprint
description: Refresh and use QBE proof-blueprint snapshots as the system-of-record control layer for long Lean block-encoding runs.
argument-hint: "[task id]"
---

# QBE Proof Blueprint

Use this skill before long faithful-paper or exploratory-construction runs.

QBE studies a similar pattern in
[LeanMarathon](https://github.com/YuanheZ/LeanMarathon) and
[arXiv:2606.05400](https://arxiv.org/abs/2606.05400): a durable blueprint,
target review before proof discharge, dynamic proof-DAG leaves, bounded worker
scope, refiner repair, and deterministic gates.

QBE adapts that pattern to block-encoding formalization.  Its blueprint is not
a single LeanArchitect file; it is a compact snapshot over:

- Lean declarations in `QuantumBlockEncoding/`;
- source notation and register contracts in `conversion-windows/`;
- open semantic gaps in `proof-obligations/`;
- human proof exports in `paper-notes/`;
- cited external results in `research-wiki/cited-results/`;
- latest handoffs in `runs/<run-id>/dialogue.md`.

## Required Command

Refresh the snapshot:

```bash
python3 tools/qbe.py blueprint-refresh <task-id>
```

For automated runs, add:

```bash
--blueprint-refresh
```

to `run-cycle` or `sleep-run`.

## Stage Rules

Stage 1 target/transcript stabilization:

- map the paper theorem, proof steps, register layout, normalizer, resource
  claims, and cited contracts;
- reviewer checks for target drift before broad lower proving;
- lower agents should not invent circuits or prove simplified contracts.

Stage 2 DAG proof discharge:

- lower agents work on one dynamic leaf at a time;
- if a leaf is already compiled, upper/middle retire it before more proof
  search;
- if several failures share a dependency, use a refiner-style repair for the
  connected illness area;
- Lean plus synchronized proof-map correspondence is the only completion gate.

## Reviewer Checklist

- Does the active leaf still match the latest Lean declarations?
- Did the latest run prove the assigned target, or only discover that it was
  already compiled?
- Are unproved cited primitives recorded as contracts, not hidden assumptions?
- Are Markdown and LaTeX proof maps synchronized with accepted Lean changes?
- Is the next lower packet one local proof node, not a broad theorem-search
  request?
