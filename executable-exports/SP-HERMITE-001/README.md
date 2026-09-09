# Hermite smooth state preparation: executable evidence

This directory contains a reproducible `k=1`, `n=3`, `L=1` example with an
explicit circuit of **7 RY and 8 CNOT gates**, zero ancillas and zero oracle
calls. Qiskit reports depth 13 for this unoptimized reference sequence.
The files are finite numerical evidence. Symbolic theorems and their Lean
build records are maintained separately by the repository gate.

## Reproduce

From the repository root, using Python with `requirements-executable.txt`:

```bash
python executable-exports/SP-HERMITE-001/qiskit/export.py --self-test
python executable-exports/SP-HERMITE-001/qiskit/export.py --k 1 --n 3 --L 1
python executable-exports/SP-HERMITE-001/qiskit/replay.py
```

The default exporter requires Qiskit **and** the OpenQASM 3 importer. Missing
dependencies produce an error. `--numpy-only` is an explicit diagnostic mode:
its output has `accepted: false`, and the independent acceptance replay rejects
it. A new export first invalidates any previous acceptance record, so a failed
attempt cannot leave an older green result in that output directory. A missing
test file or a test suite containing zero tests is also an error.

To retain the representative artifacts when exploring another case, choose an
output directory:

```bash
python executable-exports/SP-HERMITE-001/qiskit/export.py --k 3 --n 5 --L 1 --out-dir _out/hermite-k3-n5
python executable-exports/SP-HERMITE-001/qiskit/replay.py --directory _out/hermite-k3-n5
```

The finite interpreter limits exports to `1 <= n <= 10`; full expanded figures
are generated for `n <= 5`. These are practical replay limits, not limitations
on a separately proved symbolic theorem. Independent endpoint interpolation
supports `0 <= k <= 30`.

## Construction and wire convention

Let `t=p+1` and

\[
a_{k,r}=\sum_{m=0}^{r}\binom{k+r-m}{k}\frac1{m!},\qquad
A_k(t)=\sum_{r=0}^{k}a_{k,r}t^r.
\]

The middle polynomial is

\[
P_k(p)=e^{-1}(1-t)^{k+1}A_k(t)+t^{k+1}A_k(1-t).
\]

It joins `exp(p)` on `p <= -1` to `exp(-p)` on `p >= 0`, matching derivatives
through order `k`. All coefficients of `A_k` are positive. The factored
evaluation therefore avoids the cancellation of an expanded interpolant on
the middle interval. The exact rational endpoint tests keep the coefficient
of `exp(-1)` separate from the rational part.

The source convention follows [arXiv:2403.19123v3](https://arxiv.org/abs/2403.19123v3),
Section 4.3, equations (4.31)–(4.32). The order-one cubic is `C^1`; its middle
second derivative at `p=0` is `8/e-10`, not the right-hand value `1`.

At `p_j=-pi L+2 pi L j/2^n`, the target is

\[
|\psi\rangle=\sum_j\frac{f(p_j)}{\sqrt{\sum_i f(p_i)^2}}|j\rangle.
\]

`q[0]` is the least-significant bit. The low-bit prefix `s` at depth `d`
contains indices `j mod 2^d=s`. Define its mass `M_d(s)` as the sum of squared
samples in that set. At depth `d`, target wire `q[d]` receives an RY selected
by the lower `d` wires, with angle

\[
\theta_{d,s}=2\operatorname{atan2}
\left(\sqrt{M_{d+1}(s+2^d)},\sqrt{M_{d+1}(s)}\right).
\]

The convention is `RY(theta)|0> = cos(theta/2)|0> + sin(theta/2)|1>`.
A zero-mass parent uses angle zero; it is unreachable from the prepared state.
The all-zero input is rejected because it cannot be normalized.

Each multiplexor is compiled recursively. For its lowest control, form
`half_add=(angle_0+angle_1)/2` and `half_sub=(angle_0-angle_1)/2`, then execute
`UCRY(half_add); CX; UCRY(half_sub); CX` on the remaining controls. This mirrors
`QuantumBlockEncoding.compileUniformlyControlledRy_eval_controlledRyBlockMatrix`
in `QuantumBlockEncoding/UniformlyControlledRy.lean`. No generic state
initialization or opaque state-preparation routine is used.

## Evidence files

| File | Meaning |
| --- | --- |
| `manifest.json` | Parameters, conventions, source and named formal interface |
| `circuit.svg` | Every emitted primitive, with registers and stage semantics |
| `circuit.qasm`, `circuit.qasm3` | OpenQASM 3 serialization |
| `circuit.qasm2` | Independent OpenQASM 2 serialization |
| `samples.csv` | Grid points, raw samples, normalized target and primitive replay |
| `mass-tree.json` | Conditional masses and uncompiled rotation angles |
| `endpoint-jets.json` | Exact rational derivative checks at both endpoints |
| `acceptance.json` | Finite replay results, source hash and artifact hashes |

The independent `replay.py` imports no exporter functions. It solves the full
Hermite endpoint equations with exact rational Gaussian elimination, evaluates
that alternative polynomial with 100 decimal digits, then parses each saved
QASM circuit and compares its statevector with the independently reconstructed
target. Missing files, stale source hashes, changed artifact hashes, extra
gate types and incorrect reference gate counts are errors. A forged success
field and recomputed digest do not bypass the semantic replay.

The regression suite checks every column of several multiplexor matrices,
all basis targets through four qubits, zero-mass branches, endian and rotation
sign conventions, exact endpoint jets through order 12, resource counts,
independent interpolation, and Qiskit/QASM round trips. It does not substitute
for `lake build && lake build Tests` or the website publication gate.
