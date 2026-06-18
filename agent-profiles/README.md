# Agent Profiles

ABEIS can run different model backends for different layers or slots of the
multi-agent harness.  A profile is a JSON object whose values are shell command
templates.  Templates use the same placeholders as `--agent-cmd`:

```text
{root}     repository root
{prompt}   prompt file path
{run_dir}  run directory
{task}     task id
{cycle}    cycle number
{role}     upper, middle, lower, or reviewer
```

Supported keys are:

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

Example:

```bash
python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-001 \
  --cycles 2 \
  --lower-count 3 \
  --parallel-lower \
  --agent-profile mixed-vendors.example.json \
  --execute \
  --check-each-cycle
```

The profile mechanism is vendor-neutral.  You can use Codex, Claude, GPT,
Gemini, GLM, Minimax, or a local wrapper as long as the command reads the
prompt and exits with a meaningful status code.

