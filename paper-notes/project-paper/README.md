# Project Paper Plan

Working title:

```text
Auto-Lean-in-Sleep: Block Encoding for Quantum Computing
```

This directory is for planning the eventual project article.  It should not
become the live scratchpad for every Lean-heavy cycle.  During proof runs,
agents should update only the minimal appendix/proof-map pointers needed for
traceability.  Full prose and figures are a separate writing batch.

## Article Thesis

The main contribution is an automated theorem-proving workflow for turning
oracle-level quantum-algorithm assumptions into Lean-checked, gate-level
block-encoding constructions.

The paper should emphasize the system:

- upper/middle/lower/reviewer agent hierarchy;
- source-dependency audits against paper LaTeX and cited results;
- Lean/Markdown/LaTeX conversion windows;
- trial memory and rejected-model memory;
- faithful paper reproduction versus exploratory oracle construction.

## Case Appendices

GHL2025 is the first appendix case:

- source theorem: one-term Robin block encoding;
- key correction: `O_D^BS` must use global sparse slots;
- rejected model: row-dependent sparse branch deletion;
- current Lean state: global-slot address/source and restricted cleanup
  interfaces are compiled; full cleanup, unitarity, LCU, and block extraction
  remain obligations.

## Style References

- `YuanheZ/lean-stat-learning-theory`: use for Lean theorem exposition,
  appendix organization, and code/proof presentation.
- ARIS paper: use for automation-system narrative and figure-rich
  presentation.
- Learning Beyond Gradients: use for the memory-loop and hierarchical
  iteration framing.

## Figure Todo

- System overview: paper theorem to Lean gate matrix certificate.
- Three-layer agent stack: upper/middle/lower plus reviewer.
- Source-dependency audit loop: local TeX, cited results, Lean obligation.
- Proof-memory loop: Lean failure to proof-attempt memory to next lower packet.
- GHL2025 case diagram: global sparse-slot `O_D^BS`, SWAP, dagger cleanup.
- Faithful versus exploratory mode comparison.
