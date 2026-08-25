# Agent Profiles

ASPBE can run different model backends in different execution slots. A profile
is a JSON object whose values are shell command templates. Templates use the
same placeholders as `--agent-cmd`:

```text
{root}     repository root
{prompt}   prompt file path
{run_dir}  run directory
{task}     task id
{cycle}    cycle number
{role}     upper, middle, lower, or reviewer (legacy slot label)
```

Supported keys remain:

```text
default
upper
middle
lower
lower1
lower2
lower3
lower4
reviewer
10_upper_director
20_middle_formalizer
30_lower_searcher_1
40_reviewer
```

Specific prompt-stem keys win first, then `lower1`/`upper`/`middle`/`reviewer`,
then `default`.

## Harness v2 interpretation

These names are backward-compatible **execution slots**, not cognitive castes.
Read [`../HARNESS.md`](../HARNESS.md) for the canonical Frontier Master–Worker
protocol.

A typical mapping is:

| Existing key | Harness v2 use |
| --- | --- |
| `upper` | Frontier Master contract/frontier refresh |
| `middle` | Master synthesis or a Universal Worker owning conversion/integration |
| `lower1`–`lower4` | independent Universal Worker objectives or optional lenses |
| `reviewer` | fresh-context source/semantic/Lean/integration/exposition gate |

Every Universal Worker may cross paper reading, mathematics, Lean, tests,
resource analysis, diagrams, and proof writing. Use different slot prompts or
models to create independent uncertainty-reduction strategies, not to forbid a
Worker from preserving a useful idea discovered outside its initial lens.

The CLI does not yet expose native `master`, `worker`, or `anchor` profile keys.
Do not put unsupported keys in a profile and assume they will be selected. The
compatibility mapping keeps historical runs replayable while Harness v2 is
measured and the runner evolves.

Example:

```bash
python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-001 \
  --cycles 2 \
  --agent-profile mixed-vendors.example.json \
  --execute \
  --check-each-cycle
```

The profile mechanism is vendor-neutral. Codex, Claude, GPT, Gemini, GLM,
Minimax, or a local wrapper may be used as long as the command reads the prompt
and exits with a meaningful status code.

For comparable results across the CLI, an AI chat window, and the web task
builder, keep one profile file as the provider source of truth. Provider choice
must not be hidden only in front-end state.

Recommended reproducibility fields for every long run:

```text
task id and frozen mathematical contract
raw user prompt artifact
agent profile path
model names and provider wrappers
frontier root and Worker objective packets
report language
active budget and tolerance rung
parallel Worker count and independence rationale
Lean and public gate commands
accepted substantive advances
context duplication and Master synthesis load
```
