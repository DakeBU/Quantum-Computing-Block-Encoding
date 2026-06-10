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

## Cycle Update Contract

Every executed multi-hour proof cycle should now leave an article-facing
update packet:

- `runs/<run-id>/article_update.md`
- `runs/<run-id>/article_update.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`

If the external technical-report project exists, the latest generated status is
mirrored to `../Auto_Proof_Papers/ABEIS/appendix/generated_cycle_status.tex`.

Middle owns this bridge.  Reviewer checks it.  The generated update is not a
polished paper section; it is the claim-to-evidence ledger that tells the
article what can safely change after a 6h active loop.  Use
`.agents/skills/qbe-project-paper-update/SKILL.md` before editing the report.

Stable claims may move into the report only when backed by one of:

- a Lean declaration and passing gate,
- a source-paper anchor plus conversion-window/proof-obligation row,
- a cited-results row with honest status,
- a proof-attempt or reviewer record explaining a system lesson.

Do not claim a case study is complete while theorem-facing `sorry` or root
block-extraction obligations remain.

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
