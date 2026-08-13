# Executable Exports

This directory is for runnable quantum-code artifacts generated after a Lean
block-encoding certificate has closed.

ABEIS uses the following policy:

1. Lean is the acceptance authority for the advertised theorem.
2. Executable exports are produced after the matching Lean declaration is named.
3. Export checks confirm that the generated program matches the certified
   construction at the stated concrete instantiation.
4. For symbolic circuit families, each export must record the register sizes,
   target parameter values, normalizer, projector, and semantic tier it covers.

Supported export targets:

- `qiskit`: Python/Qiskit circuit plus exact finite assertions when the
  instance is small enough to materialize.
- `quantum-katas`: kata-style task and deterministic tests for teaching or
  benchmark use.
- `qasm3`: OpenQASM 3 transcript plus parser and fixed-instance checks.

Executable artifacts are useful to users who want to run the certified
construction in a familiar quantum-programming environment.  They do not
replace the Lean theorem, and passing an executable check does not promote an
uncertified candidate into the certified population.

Current Qiskit exports:

| Task | Path | Status |
|---|---|---|
| `QBE-MAIN-CASE-HIER-COLD-001` | `QBE-MAIN-CASE-HIER-COLD-001/` | Lean certificate named; Qiskit/QASM3 artifacts generated with deterministic finite checks |
| `QBE-OP-OPTCTRL-001` | `QBE-OP-OPTCTRL-001/qiskit/export.py` | Lean-certified concrete champion exported to Qiskit |
| `QBE-OP-CUBIC-STATEPREP-001` | `QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py` | fixed-instance dense baseline only; not a symbolic certificate |
| `SP-TEXTBOOK-001` | `SP-TEXTBOOK-001/qiskit/export.py` | Pauli X and Hadamard circuits exported from separately Lean-certified textbook contracts |
| `QBE-ROBIN-BE-WARM-001` | `QBE-ROBIN-BE-WARM-001/qiskit/circuit.py` | XOR four-slot `{X,RY,RZ,CX}` circuit; exact Lean refinement plus gate-by-gate Qiskit and strict OpenQASM replay |
