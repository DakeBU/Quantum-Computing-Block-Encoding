# Article To Lean Workflow

This project treats a paper as a source of candidate constructions, not as an
oracle assumption. The output target is a Lean-checked block-encoding or a
clearly stated open problem.

Local copies of a paper source may be useful while developing, but public
project artifacts should cite the paper, arXiv URL, theorem/lemma/equation
labels, figure labels, and repository paper notes.  Do not make the proof map
depend on a machine-specific absolute path.

![Conversion window](assets/conversion_window.svg)

## Step 1: Pick A Literature Entry

List the registry:

```bash
python3 tools/qbe.py list-literature
```

Choose one entry and create a task:

```bash
python3 tools/qbe.py new-task QBE-PAPER-001 \
  --mode faithfulPaper \
  --title "Formalize explicit sparse matrix block encoding" \
  --source "Camps-Lin-Van Beeumen-Yang 2024, https://arxiv.org/abs/2203.10236" \
  --target-lean "QuantumBlockEncoding/Circuit.lean"
```

For the primary target, the seed task already exists as `QBE-AUTO-001`.

## Step 2: Create A Conversion Window

```bash
python3 tools/qbe.py conversion-window QBE-PAPER-001 \
  --title "Sparse matrix block encoding"
```

Fill the window in this order:

1. LaTeX pane: exact theorem, definition, and notation from the paper.
2. Symbol map: every paper symbol gets a Lean name and type/role.
3. Oracle contract: target operator, claimed oracle behavior, ancillas, block
   entry, normalizer, and resource expression.
4. Source-contract audit: for every oracle/gate, write the exact input
   registers, exact output registers, clean-ancilla condition, normalizer, and
   Lean declaration.  If the Lean declaration is a simplified register map,
   label it as contract drift before asking lower agents to prove it.
5. Markdown pane: explain the construction and why it should satisfy the
   contract.
6. Lean-to-paper proof map: after each lower-agent change, translate what Lean
   actually proved, what failed, and what remains open back into Markdown/LaTeX
   so reviewer and upper can compare against the original paper.
7. Lean declaration plan: file names and declaration names.
8. Proof obligations: anything that cannot yet be proved.

## Step 3: Decide Whether The Oracle Is Real

For every "given oracle" line in a paper, ask:

- What matrix does it implement?
- What are the input and output registers?
- Is the oracle unitary or an isometry embedded into a unitary?
- What reversible arithmetic or state-preparation circuit realizes it?
- What normalization constant appears in the block entry?
- What ancillas must be clean at the end?
- What resource count should Lean record?

If these cannot be answered, the task is not solved. Write the gap into
`proof-obligations/` or draft an open problem:

```bash
python3 tools/qbe.py new-open-problem QBE-NEW-001 \
  --title "Gate-level coefficient oracle for nonseparable Robin data" \
  --reference "https://arxiv.org/abs/2506.20478"
```

## Step 4: Add Lean In Small Pieces

Recommended order:

1. Add names and data structures.
2. Add target matrix/operator descriptions.
3. Add candidate circuit or circuit schema.
4. Add block-encoding predicate instantiation.
5. Add resource expression.
6. Add fixed-instance executable checks in `Tests/`.

After each nontrivial Lean edit:

```bash
python3 tools/qbe.py check
```

## Step 5: Log The Attempt

Success:

```bash
python3 tools/qbe.py trial-log \
  --task QBE-PAPER-001 \
  --role lower \
  --kind build \
  --status compiled \
  --lean-gate pass \
  --from-git \
  --notes "Added the sparse-access skeleton and fixed-instance executable checks."
```

Useful failure:

```bash
python3 tools/qbe.py trial-log \
  --task QBE-PAPER-001 \
  --role lower \
  --kind attempt \
  --status blocked \
  --lean-gate fail \
  --from-git \
  --notes "Block entry cannot be stated until the matrix semantics of controlled rotations exists."
```

Then compress:

```bash
python3 tools/qbe.py trial-summary
```

## Step 6: Review Before Marking Complete

The reviewer should check:

- the source paper link is present,
- the conversion window maps every important symbol,
- the middle-agent proof map translates both directions: paper-to-Lean before
  work and Lean-to-Markdown/LaTeX after work,
- no oracle assumption remains abstract unless it is explicitly an open problem,
- no Lean oracle contract drifts from the paper's register-level
  transformation, clean-ancilla condition, or normalizer,
- the target Lean file builds,
- tests cover the resource count or core declaration,
- task status is not promoted before the build gate passes.

Only then should a task move from `planned` or `active` toward `leanCompiles`
and eventually `merged`.
