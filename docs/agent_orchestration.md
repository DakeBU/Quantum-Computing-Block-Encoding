# Agent Orchestration

QBE uses ARIS-style plain files, but the target is different: an overnight run
must move one block-encoding/oracle task closer to a Lean-checked circuit
certificate.

The implementation is intentionally local and inspectable:

- prompt decks live in `runs/<run-id>/`,
- agent dialogue lives in `runs/<run-id>/dialogue.md`,
- trial memory lives in `runs/trials.jsonl`,
- compressed run memory lives in `runs/trials_summary.csv`,
- the acceptance gate is `lake build && lake build Tests`.

![Three-layer agent stack](assets/agent_stack.svg)

## Roles

Upper agent:

- chooses the next objective,
- decomposes the task,
- rejects weak directions,
- compresses trial memory into the next handoff.

Middle agent:

- owns the conversion window,
- maps LaTeX symbols to Markdown explanations and Lean declarations,
- maintains proof obligations,
- keeps the target small enough for lower agents.

Lower agents:

- try one construction path each,
- edit Lean or supporting notes in a narrow scope,
- run the Lean gate if they edit Lean,
- log both successes and useful failures.

Reviewer:

- checks the diff and the build result,
- looks for hidden oracle assumptions,
- checks normalizers, ancillas, resource counts, and citations,
- decides whether a gap should become an open problem.

## Create A Prompt Deck

```bash
cd /home/nitanda_sub/mark/repos/Quantum/Quantum-Computing-Bloack-Encoding
python3 tools/qbe.py run-cycle QBE-AUTO-001 --cycle 1 --lower-count 2
```

This creates a directory like:

```text
runs/20260517-153000-QBE-AUTO-001-cycle01/
  00_context.md
  10_upper_director.md
  20_middle_formalizer.md
  30_lower_searcher_1.md
  30_lower_searcher_2.md
  40_reviewer.md
  90_handoff.md
  dialogue.md
```

You can give each prompt file to a separate coding agent. They do not need to
share a chat window. Their shared state is the repository plus `dialogue.md`.

## Make Agents Converse

The simplest conversation protocol is a shared board:

```bash
python3 tools/qbe.py agent-note latest --role upper \
  --message "Cycle objective: formalize the Robin one-term normalizer and reject any construction that leaves the coefficient oracle abstract."

python3 tools/qbe.py agent-note latest --role middle \
  --message "Mapped A, U, alpha, and ancilla projector. Missing: concrete coefficient state-preparation circuit."

python3 tools/qbe.py agent-note latest --role lower \
  --message "Attempted diagonal coefficient encoding; blocked because coefficient arithmetic circuit is not represented yet."

python3 tools/qbe.py agent-note latest --role reviewer \
  --message "This should be promoted to an arithmetic-oracle open problem unless a gate-level coefficient circuit is added."
```

The dialogue board is markdown, so a human can edit it directly if that is more
convenient.

## Trial Memory

Every serious attempt should be logged:

```bash
python3 tools/qbe.py trial-log \
  --task QBE-AUTO-001 \
  --role lower \
  --kind attempt \
  --status blocked \
  --lean-gate not-run \
  --from-git \
  --notes "Diagonal coefficient encoding needs an explicit reversible arithmetic circuit."

python3 tools/qbe.py trial-summary
```

This follows the useful part of the Learning Beyond Gradients artifact pattern:
append rich JSONL records, then rewrite a small CSV summary after each attempt.
The JSONL file preserves detail; the CSV gives the upper agent a short memory.

## Overnight Pattern

Dry run first:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 --cycles 3 --lower-count 2 --dry-run
```

This only creates prompt decks and trial records. It does not call any external
agent.

When you have a local agent CLI, pass it as an execution template. The template
can use these placeholders:

- `{root}`: repository root,
- `{prompt}`: prompt file path,
- `{run_dir}`: run directory,
- `{task}`: task id,
- `{cycle}`: cycle number,
- `{role}`: inferred agent role.

Example shape:

```bash
python3 tools/qbe.py sleep-run QBE-AUTO-001 \
  --cycles 8 \
  --lower-count 3 \
  --agent-cmd 'cd {root} && codex exec --full-auto "$(cat {prompt})"' \
  --execute \
  --check-each-cycle
```

Adjust the `codex exec` flags to the CLI you actually use. The QBE side only
requires that the command reads the prompt, edits the repository if needed, and
returns a process exit code.

## Stop Conditions

Stop or require human review when:

- Lean fails and the reviewer cannot localize the error,
- a lower agent edits outside its assigned scope,
- a paper assumption cannot be converted into a circuit-level target,
- trial summaries repeat the same failure without a new construction idea,
- the proof would need a theorem not yet represented in the project.

In those cases, promote the gap into `proof-obligations/` or
`open-problem-proposals/` instead of pretending the oracle is solved.
