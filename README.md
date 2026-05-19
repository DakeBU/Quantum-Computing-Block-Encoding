# Auto-Lean-in-Sleep: Block Encoding for Quantum Computing

Lean 4 project for turning quantum oracle assumptions into concrete
gate-level circuit matrices and Lean-checked block-encoding certificates.

The project target is:

```text
specific problem -> concrete circuit matrix -> Lean-checked oracle/block-encoding certificate
```

The project explicitly avoids stopping at "assume an oracle exists". If a paper
uses an oracle, this repository asks for the matrix, circuit schema, ancilla
layout, normalizer, and resource count needed to run it on a quantum computer.

![QBE automation pipeline](docs/assets/qbe_pipeline.svg)

## Primary Target

The first target is the Robin-boundary PDE simulation construction:

- Nikita Guseynov, Xiajie Huang, Nana Liu,
  [Quantum framework for simulating linear PDEs with Robin boundary conditions](https://arxiv.org/abs/2506.20478),
  arXiv 2025 / published 2026. Status: `skeleton`.

The primary Lean file is:

```text
QuantumBlockEncoding/GHL2025.lean
```

## Quick Start

```bash
cd /home/nitanda_sub/mark/repos/Quantum/Quantum-Computing-Bloack-Encoding

python3 tools/qbe.py init
python3 tools/qbe.py list-literature
python3 tools/qbe.py next-task
python3 tools/qbe.py check
```

The mandatory acceptance gate is always:

```bash
lake build && lake build Tests
```

## What This Repository Contains

Compiled Lean source of truth:

- `QuantumBlockEncoding/Core.lean`: base finite index and grid helpers.
- `QuantumBlockEncoding/Circuit.lean`: circuit and gate-level placeholders.
- `QuantumBlockEncoding/BlockEncoding.lean`: block-encoding contracts.
- `QuantumBlockEncoding/GHL2025.lean`: primary Robin-boundary target.
- `QuantumBlockEncoding/Literature.lean`: clickable literature registry.
- `QuantumBlockEncoding/OpenProblems.lean`: Lean-registered open problems.
- `QuantumBlockEncoding/Automation.lean`: compiled automation contracts.

Automation and knowledge artifacts:

- `tools/qbe.py`: no-dependency project CLI.
- `tasks/`: task contracts.
- `conversion-windows/`: synchronized Lean/LaTeX/Markdown workspaces.
- `proof-obligations/`: explicit proof and oracle gaps.
- `open-problem-proposals/`: draft open problems.
- `runs/`: prompt decks, dialogue boards, trial logs, and summaries.
- `agent-briefs/`: generated context packets for agents.
- `research-wiki/`: persistent paper/idea/claim/gap memory.

## Agent Automation

QBE adapts the ARIS plain-file automation pattern to Lean proof work:

```text
literature/open problem -> formal spec -> circuit search -> Lean proof -> review -> docs
```

The implementation also borrows the trial-memory pattern from Learning Beyond
Gradients: append detailed JSONL trial records and rewrite a compact summary
CSV after every attempt.

![Three-layer agent stack](docs/assets/agent_stack.svg)

The current roles are compiled in `QuantumBlockEncoding/Automation.lean`:

- Upper agent: chooses strategy and compresses memory.
- Middle agent: maintains LaTeX/Markdown/Lean conversion and proof obligations.
- Lower agents: try concrete construction/proof paths.
- Reviewer: checks Lean build, hidden oracle assumptions, resources, and links.

QBE has two operating modes:

- Faithful paper reproduction: reproduce a specific paper's circuit/block
  encoding in Lean.  This is the current mode for GHL2025.
- Exploratory construction: search for new oracle or block-encoding
  constructions under a precise Lean-checkable target.

In faithful mode, agents must not invent a replacement construction.  Missing
oracle details become proof obligations.  In exploratory mode, agents may
search, but every candidate must be tied to an acceptance predicate and logged
as trial memory.

## Design Lineage

QBE is not a clone of either upstream project.  It adapts their working
patterns to a theorem-proving target where Lean, not an empirical score, is the
final judge.

| Source pattern | In the source project | QBE adaptation |
| --- | --- | --- |
| [ARIS](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep) skills | Single-purpose `SKILL.md` files describe workflows that any LLM can execute. | `tools/qbe.py run-cycle` generates role prompts for upper, middle, lower, and reviewer agents.  The prompts are task-specific instead of global slash commands. |
| ARIS plain files | Markdown templates, `MANIFEST.md`, research wiki, review artifacts, and no database lock-in. | `tasks/`, `conversion-windows/`, `paper-notes/`, `proof-obligations/`, `runs/`, and `research-wiki/` are all plain files that humans and agents can edit. |
| ARIS review loops | A reviewer model checks papers, experiments, citations, and claims. | The reviewer agent checks Lean build status, hidden oracle assumptions, normalizers, ancilla layout, resource counts, citations, and faithful-vs-exploratory mode discipline. |
| [Learning Beyond Gradients](https://github.com/Trinkle23897/learning-beyond-gradients) trial memory | Coding agents iterate policies and record `trials.jsonl`, `summary.csv`, videos, logs, and rejected directions. | QBE records proof/circuit attempts in `runs/trials.jsonl` and `runs/trials_summary.csv`; rejected constructions become proof obligations or open problems. |
| Heuristic-system maintenance | Code, tests, logs, and summaries form the learnable object, not neural weights. | Lean declarations, tests, conversion windows, proof-obligation ledgers, and trial summaries form the evolving proof system. |

The analogy is:

```text
ARIS empirical paper pipeline:
papers -> ideas -> experiments -> review -> paper

Learning Beyond Gradients heuristic loop:
state/test/log feedback -> code edit -> trial record -> summary -> next edit

QBE proof pipeline:
paper/open condition -> oracle contract -> circuit matrix -> Lean check -> review -> proof map
```

QBE's many Markdown files are therefore not decoration.  They play the same
operational role that ARIS skills, templates, manifests, and research-wiki
pages play: they are the stable interface between humans, agents, and the next
cycle.  The extra QBE-specific layer is the Lean/LaTeX/Markdown conversion
window, because a theorem-proving project must preserve the correspondence
between source-paper notation and checked declarations.

## For Paper Authors

Use this repository when your paper says or implies an oracle such as "assume
access to $O_A$", but the eventual quantum algorithm needs a concrete
gate-level circuit matrix, ancilla layout, normalizer, and resource statement.

There are two entry points.

### Reproduce An Existing Paper

Use faithful paper-reproduction mode when the construction already exists in a
paper and you want QBE to formalize it.

1. Register a task:

```bash
python3 tools/qbe.py new-task QBE-PAPER-001 \
  --kind paperReproduction \
  --title "Formalize my paper's block encoding" \
  --source "arXiv:XXXX.XXXXX" \
  --target-lean "QuantumBlockEncoding/MyPaper.lean"
```

2. Edit `tasks/QBE-PAPER-001.md` and set:

```text
Mode: `faithfulPaper`
```

Then paste the theorem, oracle definition, source equations, and expected
resource statement into the task.

3. Create the conversion window:

```bash
python3 tools/qbe.py conversion-window QBE-PAPER-001 \
  --title "My paper oracle-to-circuit map"
```

4. Run a conservative agent loop:

```bash
python3 tools/qbe.py update-task QBE-PAPER-001 --status active --active
python3 tools/qbe.py sleep-run QBE-PAPER-001 \
  --cycles 3 \
  --lower-count 1 \
  --agent-cmd 'bash tools/qbe_claude_faithful.sh {root} {prompt}' \
  --execute \
  --check-each-cycle
```

Expected outputs:

- Lean declarations in `QuantumBlockEncoding/MyPaper.lean`,
- tests under `Tests/`,
- a symbol map in `conversion-windows/QBE-PAPER-001.md`,
- readable derivations in `paper-notes/`,
- remaining gaps in `proof-obligations/`,
- run memory in `runs/trials.jsonl` and `runs/trials_summary.csv`.

### Search For A New Oracle Construction

Use exploratory construction mode when your theoretical algorithm needs an
oracle, but no paper gives a gate-level implementation yet.

1. Draft the open problem:

```bash
python3 tools/qbe.py new-open-problem QBE-EXP-001 \
  --title "Block encoding for my new oracle condition" \
  --motivation "Theory assumes an oracle; no concrete circuit is known."
```

2. Create a task:

```bash
python3 tools/qbe.py new-task QBE-EXP-001 \
  --kind exploratoryConstruction \
  --title "Search for a circuit realizing my oracle condition" \
  --source "open problem / arXiv:XXXX.XXXXX" \
  --target-lean "QuantumBlockEncoding/OpenProblems.lean"
```

Edit `tasks/QBE-EXP-001.md` and set:

```text
Mode: `exploratoryConstruction`
```

3. State the Lean-checkable acceptance predicate before running agents.  A good
target says:

- the target matrix/operator,
- the allowed ancilla registers,
- the required block entry,
- the normalizer,
- the resource expression,
- what counts as a successful circuit matrix.

4. Run multiple lower agents only after the target is precise:

```bash
python3 tools/qbe.py sleep-run QBE-EXP-001 \
  --cycles 6 \
  --lower-count 3 \
  --agent-cmd 'cd {root} && claude -p --permission-mode bypassPermissions --effort high "$(cat {prompt})"' \
  --execute \
  --check-each-cycle
```

In exploratory mode, failed attempts are first-class results.  They should be
logged, summarized, and either turned into better lemmas or promoted into open
problem statements.

Create one prompt deck:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 2
```

Create repeated prompt decks for an overnight dry run:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 8 --lower-count 3 --dry-run
```

Append role messages to the shared dialogue board:

```bash
python3 tools/qbe.py agent-note latest --role upper \
  --message "Cycle objective: remove one abstract Robin oracle assumption."
```

Log trial memory:

```bash
python3 tools/qbe.py trial-log \
  --task QBE-AUTO-001 \
  --role lower \
  --kind attempt \
  --status blocked \
  --lean-gate not-run \
  --from-git \
  --notes "Coefficient oracle still needs a reversible arithmetic circuit."

python3 tools/qbe.py trial-summary
```

Full guide:

- [Agent orchestration](docs/agent_orchestration.md)
- [Sleep run guide](docs/sleep_run_guide.md)
- [Article to Lean workflow](docs/article_to_lean_workflow.md)

## Faithful GHL2025 Overnight Run

For the current paper-reproduction target, use `QBE-AUTO-002` as the
infrastructure task that makes the GHL2025 circuit semantics concrete:

```bash
cd /home/nitanda_sub/mark/repos/Quantum/Quantum-Computing-Bloack-Encoding
python3 tools/qbe.py update-task QBE-AUTO-002 --status active --active

mkdir -p runs/logs
nohup bash -lc '
python3 tools/qbe.py sleep-run QBE-AUTO-002 \
  --cycles 4 \
  --lower-count 1 \
  --agent-cmd '"'"'bash tools/qbe_claude_faithful.sh {root} {prompt}'"'"' \
  --execute \
  --check-each-cycle
' > runs/logs/claude-qbe-auto-002-$(date +%Y%m%d-%H%M%S).log 2>&1 &
```

Use one lower worker for this faithful mode until the paper's register layout,
matrix semantics, and block-extraction target are stable.

## Lean/LaTeX/Markdown Conversion

Every serious paper target should use a conversion window.

![Conversion window](docs/assets/conversion_window.svg)

Create one:

```bash
python3 tools/qbe.py conversion-window QBE-AUTO-001 \
  --title "Robin one-term block encoding"
```

The conversion window has three synchronized panes:

- LaTeX: exact theorem/proof notation from the paper.
- Markdown: construction explanation, design choices, and rejected paths.
- Lean: declaration names, target files, and buildable code.

Any symbol that cannot be mapped to Lean becomes a proof obligation or an open
problem. It should not remain an implicit oracle assumption.

## Command Reference

| Command | Purpose |
| --- | --- |
| `python3 tools/qbe.py init` | Initialize workflow files and state. |
| `python3 tools/qbe.py check` | Run `lake build && lake build Tests`. |
| `python3 tools/qbe.py status` | Show git status and run build gates. |
| `python3 tools/qbe.py list-literature` | Print literature entries with links. |
| `python3 tools/qbe.py list-tasks` | List task files in `tasks/`. |
| `python3 tools/qbe.py next-task` | Suggest the next task. |
| `python3 tools/qbe.py new-task ...` | Create a task contract. |
| `python3 tools/qbe.py update-task ...` | Update task status and active task. |
| `python3 tools/qbe.py conversion-window ...` | Create a Lean/LaTeX/Markdown window. |
| `python3 tools/qbe.py new-open-problem ...` | Draft an open problem proposal. |
| `python3 tools/qbe.py agent-brief ...` | Generate an agent context packet. |
| `python3 tools/qbe.py run-cycle ...` | Create one multi-agent prompt deck. |
| `python3 tools/qbe.py sleep-run ...` | Create or execute repeated agent cycles. |
| `python3 tools/qbe.py agent-note ...` | Append to a run dialogue board. |
| `python3 tools/qbe.py trial-log ...` | Append one JSONL trial record. |
| `python3 tools/qbe.py trial-summary` | Rewrite and print trial summaries. |

## Literature Roadmap

The source of truth is `QuantumBlockEncoding/Literature.lean`. This README
mirrors the initial checklist with clickable links.

Primary target:

| Status | Paper | Target |
| --- | --- | --- |
| `skeleton` | Guseynov, Huang, Liu, [Quantum framework for simulating linear PDEs with Robin boundary conditions](https://arxiv.org/abs/2506.20478) | `QuantumBlockEncoding/GHL2025.lean` |

Explicit block-encoding and oracle-construction papers:

| Status | Paper | Target |
| --- | --- | --- |
| `planned` | Guseynov, Huang, Liu, [Efficient explicit gate construction of block-encoding for Hamiltonians needed for simulating partial differential equations](https://arxiv.org/abs/2405.12855) | `QuantumBlockEncoding/GHL2025.lean` |
| `planned` | Kharazi, Alkadri, Liu, Mandadapu, Whaley, [Explicit block encodings of boundary value problems for many-body elliptic operators](https://arxiv.org/abs/2407.18347) | `QuantumBlockEncoding/OpenProblems.lean` |
| `planned` | Camps, Lin, Van Beeumen, Yang, [Explicit quantum circuits for block encodings of certain sparse matrices](https://arxiv.org/abs/2203.10236) | `QuantumBlockEncoding/Circuit.lean` |
| `planned` | Camps, Van Beeumen, [FABLE: Fast Approximate Quantum Circuits for Block-Encodings](https://arxiv.org/abs/2205.00081) | `QuantumBlockEncoding/Circuit.lean` |
| `planned` | Li, Ni, Ying, [On efficient quantum block encoding of pseudo-differential operators](https://arxiv.org/abs/2301.08908) | `QuantumBlockEncoding/OpenProblems.lean` |
| `planned` | Guseynov, Liu, [Efficient explicit circuit for quantum state preparation of piece-wise continuous functions](https://arxiv.org/abs/2411.01131) | `QuantumBlockEncoding/OpenProblems.lean` |

Core composition and QSVT framework:

| Status | Paper | Target |
| --- | --- | --- |
| `planned` | Gilyen, Su, Low, Wiebe, [Quantum singular value transformation and beyond](https://arxiv.org/abs/1806.01838) | `QuantumBlockEncoding/BlockEncoding.lean` |
| `planned` | Low, Chuang, [Optimal Hamiltonian simulation by quantum signal processing](https://arxiv.org/abs/1606.02685) | `QuantumBlockEncoding/OpenProblems.lean` |
| `planned` | Childs, Wiebe, [Hamiltonian simulation using linear combinations of unitary operations](https://arxiv.org/abs/1202.5822) | `QuantumBlockEncoding/BlockEncoding.lean` |
| `planned` | Berry, Childs, Cleve, Kothari, Somma, [Exponential improvement in precision for simulating sparse Hamiltonians](https://arxiv.org/abs/1312.1414) | `QuantumBlockEncoding/Resources.lean` |
| `planned` | Rossi, Chuang, [Multivariable quantum signal processing (M-QSP)](https://arxiv.org/abs/2205.06261) | `QuantumBlockEncoding/OpenProblems.lean` |

PDE simulation and Schrodingerisation context:

| Status | Paper | Target |
| --- | --- | --- |
| `planned` | Jin, Liu, Yu, [Quantum simulation of partial differential equations via Schrodingerization](https://arxiv.org/abs/2212.13969) | `QuantumBlockEncoding/OpenProblems.lean` |
| `planned` | Hu, Jin, Liu, Zhang, [Quantum circuits for partial differential equations via Schrodingerisation](https://arxiv.org/abs/2403.10032) | `QuantumBlockEncoding/OpenProblems.lean` |

Arithmetic subroutines for concrete oracle implementation:

| Status | Paper | Target |
| --- | --- | --- |
| `planned` | Draper, Kutin, Rains, Svore, [A logarithmic-depth quantum carry-lookahead adder](https://arxiv.org/abs/quant-ph/0406142) | `QuantumBlockEncoding/Circuit.lean` |
| `planned` | Haener, Roetteler, Svore, [Optimizing quantum circuits for arithmetic](https://arxiv.org/abs/1805.12445) | `QuantumBlockEncoding/Circuit.lean` |

Seed citation graph:

- [Google Scholar citation set supplied by the project owner](https://scholar.google.com/scholar?oi=bibs&hl=zh-CN&cites=14261843797372216914,13308862874802569087)

## Reference Works And Source Links

This repository cites external work by original source link:

- [wanshuiyin/Auto-claude-code-research-in-sleep](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep):
  ARIS-style plain-file research automation, artifact contracts, and review
  gates. QBE adapts the pattern to Lean proof automation.
- [Learning Beyond Gradients](https://trinkle23897.github.io/learning-beyond-gradients/)
  and its [artifact repository](https://github.com/Trinkle23897/learning-beyond-gradients):
  trial JSONL logs, summary CSVs, and iterative heuristic-system maintenance.
- [Timeroot/Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo):
  style reference for finite-dimensional quantum information formalization.
- [teorth/optimizationproblems](https://github.com/teorth/optimizationproblems):
  style reference for open mathematical problem registries.

See [Attribution](docs/attribution.md) and [NOTICE](NOTICE.md).

## Citation

If you use ARIS in your research, please cite:

```bibtex
@misc{huangbu2026autoblockencoding,
  author = {{Huang}, Xiajie and {Bu}, Dake},
  title = {{Auto-Lean-in-Sleep: Block Encoding for Quantum Computing}},
  year = {2026},
  month = {May},
  note = {Project page: \url{https://github.com/DakeBU/Quantum-Computing-Block-Encoding}}
}
```
