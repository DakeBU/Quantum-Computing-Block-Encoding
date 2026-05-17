# Agent Brief: Complete the Guseynov-Huang-Liu Robin one-term block encoding skeleton

Task id: `QBE-AUTO-001`

## Mission

Advance the primary Robin-boundary target toward a Lean-compiled
block-encoding/oracle certificate. The task is not to assume an oracle; it is
to identify the concrete circuit matrix or the exact missing construction gap.

## Source

- Paper: [Quantum framework for simulating linear PDEs with Robin boundary conditions](https://arxiv.org/abs/2506.20478)
- Lean target: `QuantumBlockEncoding/GHL2025.lean`
- Current status: `skeleton`

## Three-Layer Protocol

- Upper agent: choose the next objective and compress trial memory.
- Middle agent: keep the conversion window and proof obligations synchronized.
- Lower agents: try one construction/proof path each.
- Reviewer: check hidden oracle assumptions, Lean build status, resources, and
  citations.

Create a run deck:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 2
```

The agents converse through `runs/<run-id>/dialogue.md` and record durable
memory through:

```bash
python3 tools/qbe.py trial-log --task QBE-AUTO-001 --role lower --kind attempt --status blocked --notes "..."
python3 tools/qbe.py trial-summary
```

## Required Gate

```bash
lake build && lake build Tests
```

## Working Instructions

1. Use a conversion window for every LaTeX/Markdown/Lean translation.
2. Put checked code in `QuantumBlockEncoding/`.
3. Put unresolved theorem gaps in `proof-obligations/`.
4. If the paper assumes an unimplemented oracle, draft an open problem proposal.
5. Do not mark the task complete unless the Lean build gate passes.

## Useful Docs

- `docs/article_to_lean_workflow.md`
- `docs/agent_orchestration.md`
- `docs/sleep_run_guide.md`
