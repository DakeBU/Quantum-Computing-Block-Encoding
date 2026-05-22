# GHL2025 Proof Export

This directory is the human-readable proof export for the GHL2025 one-term
Robin formalization.

- `markdown/`: readable proof notes for humans and agents.
- `latex/main.tex`: Overleaf entry point.
- `latex/sections/`: LaTeX section files included by the master document.

Lean remains the source of truth.  These notes record only proof blocks that
compiled in Lean, plus explicit remaining obligations.

Cadence: update this export once per multi-hour batch, not after every small
lower-agent change.
