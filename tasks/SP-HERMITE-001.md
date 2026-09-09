# Hermite-smoothed initial-state preparation

Task id: `SP-HERMITE-001`
Kind: `statePreparation`
Mode: `faithful-source construction`
Status: `all 88 Lean modules, executable replay, the 99-page Blueprint and unified-site checks passed locally; online release is independently gated by Pages CI`

Release status: [Pages build and deployment records](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/actions/workflows/pages.yml).
Local compilation and browser checks are not a substitute for a successful
deployment record and inspection of that deployed revision.

## Frozen scientific target

Source: Jin, Liu and Ma, arXiv:2403.19123v3, Sec. 4.3, Eqs. (4.31)–(4.32).
For each natural order `k`, the literal target is `exp(p)` below `-1`, the
two-endpoint Hermite polynomial `P_k(p)` on `[-1,0]`, and `exp(-p)` above `0`.
`P_k` has degree at most `2*k+1`, matching derivatives through order `k`.
The state has amplitudes `g_k(p_j) / sqrt(sum_j g_k(p_j)^2)` on the grid
`p_j = -pi*L + 2*pi*L*j/2^n`. Physical truncation uses `L>0`; the algebraic
preparation theorem actually holds for all real `L` and natural `n`, including
the zero-qubit case. `q0` is the least significant bit.

No rationalization of the target, dense-unitary oracle, amplitude squaring
substitution, postselection, or assumed preparation unitary is allowed.

## Closed formal frontier

- `HermitePolynomial.sourceInterpolant_eval`: literal positive coefficient formula.
- `HermitePolynomial.sourceInterpolant_degree`: degree bound.
- `HermitePolynomial.sourceInterpolant_left_iteratedDeriv` and
  `sourceInterpolant_right_iteratedDeriv`: endpoint analytic derivatives.
- `HermitePolynomial.smoothInitial_pos`: global positivity of the literal function.
- `HermiteSmoothness.smoothInitial_contDiff`: global `C^k` regularity, including junctions.
- `RealAmplitudePreparation.prepareCircuit_firstColumn`: generic nonnegative
  finite-table preparation by actual RY/CX instructions.
- `HermiteStatePreparation.hermiteStatePreparation_complete`: true normalization,
  unitary circuit denotation, exact state action, and reference compiler counts.
- `HermiteStatePreparation.hermite_noAncilla`: zero additional wires.

All names above have prefix `QuantumBlockEncoding.`. The independent review
is [source-to-certificate review](../docs/hermite-independent-review.md).

## Resource and executable boundary

For `N=2^n`, this reference compiler uses `N-1` RY gates,
`2*(N-1-n)` CX gates, zero ancillas and zero oracle calls. This is not a
global optimality claim. Exact real-angle gates do not certify finite-angle
hardware synthesis or a uniform machine-precision error bound.

The committed executable instance is `k=1,n=3,L=1`: seven RY, eight CX,
Qiskit scheduled depth thirteen. A serial schedule has depth fifteen.
The parameterized exporter and saved-artifact replay independently reconstruct
the target polynomial; their acceptance JSON is finite evidence, not a Lean log.
See [reproduction instructions](../executable-exports/SP-HERMITE-001/README.md).

## Publication and reproduction

```bash
python -m pip install -r requirements-executable.txt
python tools/check_hermite_artifacts.py
python executable-exports/SP-HERMITE-001/qiskit/export.py --self-test
python executable-exports/SP-HERMITE-001/qiskit/replay.py
python website/scripts/run_lean_gate.py
bash scripts/build-all.sh
```

The public case includes complete source downloads, theorem links, mathematical
proofs and circuit diagrams under `example-cases/hermite-smooth-state-preparation/`.
PDE recovery, Sobolev estimates and Fourier/discretization convergence remain
outside this certificate. The source's cubic example is `C^1`, not `C^2` at
the junctions; this discrepancy is explicitly explained, not silently copied.
