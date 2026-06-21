# Reproducible Harness Presets

This directory records the public hyperparameter settings used by ABEIS case
studies.  A preset is not a log transcript.  It is the command-level policy that
a reader can replay in an isolated checkout or adapt to another model profile.

The current paper-facing presets are:

| Preset | Purpose |
| --- | --- |
| `main_hier_high_to_low.md` | No-Pro Hierarchical Harness for the transfer-operator main case.  It starts with a high-capacity exact search, then switches to an adaptive low-capacity closeout for Qiskit/export/report synchronization. |
| `hard_hier_hinted_exact_to_approx.md` | Hinted Hierarchical Harness for the cubic diagonal operator.  It starts with high-capacity exact search using the human hint, then switches to adaptive approximate search after exact stagnation. |
| `pro_assisted_optctrl.md` | Pro-assisted transfer-operator evolution.  The ChatGPT Pro answer enters as an insight packet; Lean still decides acceptance. |

All commands assume the repository root is the current directory and the agent
profile has access to the selected model backend.  Use `--fixed-capacity` only
for the recorded high-capacity phase.  The reduced phase should normally use
the default adaptive controller.
