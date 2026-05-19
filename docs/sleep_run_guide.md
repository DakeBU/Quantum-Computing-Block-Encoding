# Sleep Run Guide

Sleep run mode is for unattended construction search. It creates repeated
upper/middle/lower/reviewer cycles and uses Lean as the acceptance gate.

![QBE automation pipeline](assets/qbe_pipeline.svg)

## What It Does

`sleep-run` does four things:

1. Creates a prompt deck for each cycle under `runs/<run-id>/`.
2. Gives each role a precise prompt and shared dialogue board.
3. Logs each cycle to `runs/trials.jsonl`.
4. Optionally calls an external agent command and runs `lake build`.

It does not require a specific vendor. The external command can be Codex CLI,
Claude Code, a shell wrapper, or a manual script that reads one prompt file.

## Choose The Mode First

Before an unattended run, decide which mode the task uses.

Faithful paper reproduction:

- use when reproducing GHL2025 or another cited paper,
- keep the paper construction fixed,
- record missing oracle details as proof obligations,
- require Markdown/LaTeX updates for Lean declarations tied to the paper,
- prefer one lower worker per cycle.

Exploratory construction:

- use when searching for a new block encoding or oracle realization,
- start from a precise Lean acceptance predicate,
- let lower agents try alternative constructions in separated file scopes,
- record failed attempts as trial memory,
- promote repeated failures to open-problem proposals.

The upper prompt must state the mode.  The reviewer should reject a run that
mixes faithful reproduction and exploratory invention without recording the
branch.

## Dry Run

Start with a dry run:

```bash
cd /home/nitanda_sub/mark/repos/Quantum/Quantum-Computing-Bloack-Encoding
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 2 --lower-count 2 --dry-run
python3 tools/qbe.py trial-summary
```

Open the generated files:

```bash
ls runs
sed -n '1,200p' runs/*QBE-AUTO-001-cycle01/10_upper_director.md
sed -n '1,200p' runs/*QBE-AUTO-001-cycle01/dialogue.md
```

## Manual Multi-Agent Use

If you do not want to execute agent CLIs automatically:

1. Run `run-cycle`.
2. Open each prompt file in a different agent session.
3. Tell each agent to work in the same repository.
4. Ask every agent to append a handoff through `agent-note`.
5. Run `trial-summary` and `check`.

Commands:

```bash
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 3
python3 tools/qbe.py agent-note latest --role upper --message "Objective selected."
python3 tools/qbe.py trial-summary
python3 tools/qbe.py check
```

## Automatic Use With An Agent CLI

The command template receives these placeholders:

```text
{root}     repository root
{prompt}   role prompt path
{run_dir}  run directory
{task}     task id
{cycle}    cycle number
{role}     upper, middle, lower, or reviewer
```

Example shape:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 \
  --cycles 8 \
  --lower-count 3 \
  --agent-cmd 'cd {root} && codex exec --full-auto "$(cat {prompt})"' \
  --execute \
  --check-each-cycle
```

Use your own agent CLI flags. The only QBE-side expectation is that the command
returns success or failure and leaves artifacts in the repository.

## Faithful GHL2025 Semantics Run

After the first faithful skeleton pass, the active infrastructure target is
`QBE-AUTO-002`: the circuit matrix semantics backend needed to finish the
GHL2025 Robin block-extraction proof statement.

Run one small dry-run first:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-002 --cycles 1 --lower-count 1 --dry-run
```

Then start a Claude-only unattended run:

```bash
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

This mode is intentionally conservative: one lower worker per cycle, no
exploratory block-encoding invention, and every Lean change must be mirrored in
the conversion window, LaTeX proof map, or proof-obligation ledger.

## Overnight Checklist

Before starting:

```bash
python3 tools/qbe.py check
python3 tools/qbe.py list-literature
python3 tools/qbe.py next-task
```

Prepare the active task:

```bash
python3 tools/qbe.py update-task QBE-AUTO-001 --status active --active
python3 tools/qbe.py conversion-window QBE-AUTO-001 --title "Robin one-term block encoding"
```

Start the run:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 8 --lower-count 3 --dry-run
```

Replace `--dry-run` with an `--agent-cmd ... --execute` template only after the
prompt decks look right.

After waking up:

```bash
python3 tools/qbe.py trial-summary
python3 tools/qbe.py status
git status --short
```

Review:

- `runs/trials_summary.csv`,
- latest `runs/<run-id>/90_handoff.md`,
- latest `runs/<run-id>/dialogue.md`,
- changed Lean files,
- proof obligations and open-problem proposals.

## How This Borrows From Learning Beyond Gradients

Learning Beyond Gradients logs repeated heuristic-search trials as JSONL and
rewrites compact summaries for later agent iterations. QBE applies the same
shape to proof search:

- environment score becomes Lean gate status and construction score,
- replay artifacts become conversion windows, proof obligations, and diffs,
- policy edits become Lean/circuit edits,
- failure modes become open problems or rejected directions,
- summary CSV becomes the upper agent's short-term memory.

This is not gradient learning. It is a maintainable heuristic system for
technical block-encoding construction.
