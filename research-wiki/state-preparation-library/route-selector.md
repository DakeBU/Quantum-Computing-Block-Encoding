# State-Preparation Route-Intuition Guide

State preparation is the first ABEIS application direction.  The target is
concrete:

```text
given a normalized state |psi>, construct a unitary U with U |0^n> = |psi>
```

In matrix form, the same target says that the first computational-basis column
of `U` is `|psi>`.  This is the main invariant every candidate must preserve.

If the supplied vector is not normalized, do not call it a unitary-output state
without repair.  Either normalize it and solve
`U |0^n> = |v / ||v||>`, or restate the task as a rank-one operator
`|v><0^n|` and send it to the block-encoding pipeline.

## Quick Gate Anchors

Use these as the teaching and sanity-check examples:

```text
H |0> = (|0> + |1>) / sqrt(2)
X |0> = |1>,   X |1> = |0>
```

So Hadamard prepares an equal superposition from the zero state, while Pauli-X
swaps the two computational-basis states.

## Route Matrix

| Target/access model | Route worth trying | Main proof leaf | Deprioritize when |
| --- | --- | --- | --- |
| one-qubit or small named gate | direct gate action | compute the first column or basis action | target is formula-defined across many qubits |
| explicit normalized vector in small dimension | dense unitary completion | prove the first column and unitarity of the completed matrix | vector length grows exponentially and no structure is used |
| recursively splittable amplitude vector | amplitude-split tree | norm split plus controlled sub-preparation induction | amplitudes are not normalized or lack computable partial norms |
| formula-defined amplitudes, e.g. grid polynomials | reversible arithmetic amplitude loading | compute value, rotate/load amplitude, uncompute workspace, prove error | arithmetic precision/error budget is not stated |
| LCU weights or sparse/Gram construction | PREPARE primitive for block encoding | prove state preparation first, then consume it in a clean-block theorem | no downstream block-encoding route uses the prepared state |
| unnormalized vector | normalize or rank-one fallback | prove norm/nonzero facts, or switch to `|v><0^n|` | task text silently treats an unnormalized vector as a state |

## Agent Discipline

Upper should classify the target before lower work starts:

1. normalized state preparation;
2. normalized approximate state preparation with a declared epsilon;
3. unnormalized rank-one operator, routed to block encoding;
4. paper benchmark or external contract.

Middle should write proof leaves that expose the first-column invariant:

```text
candidate U
-> prove U is unitary
-> prove U |0^n> = |psi>
-> record resources and export instantiation
```

If a state-preparation candidate later becomes a block-encoding component,
record that dependency explicitly rather than hiding it inside a larger
clean-block proof.
