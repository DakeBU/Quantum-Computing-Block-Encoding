# Post-Lean Executable Exports

ABEIS is Lean-first, but it should not be Lean-only for users.  After a
block-encoding construction is certified in Lean, the harness can generate
runnable quantum-code artifacts so users can inspect, teach, benchmark, or run
the construction in familiar tooling.

## Contract

The order is:

```text
operator A, normalizer alpha, clean projector
-> candidate U_A
-> Lean certificate for unitarity and clean-block equality
-> resource record
-> executable exports requested by the user
-> export-specific checks
```

Executable exports are not allowed to promote an unproved candidate into the
certified population.  They are generated after certification, except when a
task explicitly asks for a small finite executable check as a pre-Lean
diagnostic.

## Export Targets

| Target | Output | Check |
| --- | --- | --- |
| Qiskit | Python/Qiskit circuit and helper functions. | Exact finite `Operator` or basis-action assertion when the instance is small enough. |
| QuantumKatas style | A task file plus deterministic tests. | The tests match the certified concrete instance and resource record. |
| OpenQASM 3 | Gate transcript or wrapper program. | Parser/smoke checks, plus semantic checks when the target tooling supports them. |

## Local Executable Environment

The maintained local environment is:

```bash
python3 -m virtualenv /home/nitanda_sub/mark/.venv
/home/nitanda_sub/mark/.venv/bin/python -m pip install -r requirements-executable.txt
```

When running executable-export checks or route-ablation comparisons, pass this
Python explicitly:

```bash
/home/nitanda_sub/mark/.venv/bin/python tools/run_route_ablation.py \
  reference_qiskit \
  --python /home/nitanda_sub/mark/.venv/bin/python
```

For symbolic Lean theorems, an executable export is usually a concrete
instantiation.  The artifact must state:

- register sizes and parameter values;
- the normalizer and clean projector;
- the Lean declaration it implements;
- whether the export covers a finite instance or a symbolic-family wrapper;
- any gates that are kept as named oracles.

## Where Artifacts Go

Use:

```text
executable-exports/<task-id>/<target>/
```

For example:

```text
executable-exports/QBE-OP-OPTCTRL-001/qiskit/
executable-exports/QBE-OP-OPTCTRL-001/qasm3/
executable-exports/QBE-OP-OPTCTRL-001/quantum-katas/
```

Each target directory should contain a short `README.md`, generated code, and
the command used to run the export check.

## Agent Responsibilities

- Upper: decide which exports are requested and whether the Lean certificate is
  strong enough to justify them.
- Middle: translate Lean declarations and register maps into export-facing
  natural language and implementation constraints.
- Lower Lean worker: does not write executable code until the proof target is
  closed.
- Lower export worker: writes Qiskit/QuantumKatas/QASM artifacts after the Lean
  declaration is named.
- Lower verifier: runs export-specific checks and records the result in
  `verifier-feedback/`.
- Reviewer: checks that the exported artifact does not claim a larger theorem
  than the Lean declaration proves.

This policy lets users receive both a formal certificate and practical code,
while keeping the proof layer and executable layer semantically honest.
