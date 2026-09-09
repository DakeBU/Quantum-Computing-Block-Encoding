# Hermite state preparation: independent source and executable review

Reviewed on 2026-09-09 by the executable-export worker, separately from the
authors of the Lean construction. This is a source-level semantic review and
an independently calculated finite comparison, not an external third-party
audit or a replacement for the repository Lean and publication gates.

## Conclusion

The reviewed Lean definitions prepare the same mathematical sample vector as
the executable exporter. The source polynomial, normalization, little-endian
indexing, chronological gate order, RY sign convention, and recursive control
order agree. No replacement target, assumed state-preparation oracle, or
postselection occurs in the reviewed construction.

The precise symbolic result is preparation by ideal exact-real RY/CX gates.
It is not a theorem about the correctness of a Python program, decimal angle
rounding, hardware synthesis, or polynomial-time preparation. The finite
exporter and the independently reconstructed target provide separate evidence
for those concrete QASM artifacts.

## Sources inspected

- [HermiteStatePreparation.lean](../QuantumBlockEncoding/HermiteStatePreparation.lean):
  physical grid and samples, normalizer, explicit circuit, matrix denotation,
  preparation theorem, counts and certificate integration.
- [RealAmplitudePreparation.lean](../QuantumBlockEncoding/RealAmplitudePreparation.lean):
  pair norms, signed split-angle semantics, marginal recursion, wire lifting,
  first-column proof and resource recurrences.
- [HermitePolynomial.lean](../QuantumBlockEncoding/HermitePolynomial.lean):
  exact source formula, endpoint jets, degree, positivity, uniqueness and the
  equality with the independent Euclidean-algorithm interpolant.
- [HermiteSmoothness.lean](../QuantumBlockEncoding/HermiteSmoothness.lean):
  reusable derivative-preserving splice, finite-order gluing, equality of the
  original branch convention to the double splice, and global regularity.
- [PrimitiveBasisLE.lean](../QuantumBlockEncoding/PrimitiveBasisLE.lean),
  [PrimitiveCircuit.lean](../QuantumBlockEncoding/PrimitiveCircuit.lean),
  [PrimitiveSemantics.lean](../QuantumBlockEncoding/PrimitiveSemantics.lean),
  and [UniformlyControlledRy.lean](../QuantumBlockEncoding/UniformlyControlledRy.lean):
  integer indexing, exact-angle representation, primitive matrices,
  chronological evaluation and multiplexor compilation.
- [export.py](../executable-exports/SP-HERMITE-001/qiskit/export.py),
  [replay.py](../executable-exports/SP-HERMITE-001/qiskit/replay.py),
  [test_export.py](../executable-exports/SP-HERMITE-001/qiskit/test_export.py),
  and [acceptance.json](../executable-exports/SP-HERMITE-001/acceptance.json).
- [hermite-proof-flow.svg](assets/hermite-proof-flow.svg): rendered diagram and
  text-to-card containment checks.

## Exact meaning of the declarations

Names in this table are relative to `QuantumBlockEncoding`.

| Declaration | Actual statement or construction | Scope and qualification |
| --- | --- | --- |
| `HermitePolynomial.coefficientPolynomial_eval` and `sourceInterpolant_eval` | The Lean polynomial equals the finite positive-coefficient formula with `t=p+1`. | All natural `k`, real evaluation point. This is the formula actually sampled. |
| `HermitePolynomial.sourceInterpolant_left_jet` and `sourceInterpolant_right_jet` | Polynomial derivatives through order `k` have values `exp(-1)` at `-1` and `(-1)^j` at `0`. | Algebraic derivative statements; corresponding `*_iteratedDeriv` declarations connect them to analytic derivatives of the polynomial. |
| `HermitePolynomial.sourceInterpolant_degree`, `sourceInterpolant_unique` | Degree is at most `2*k+1`; a polynomial of that bounded degree with the prescribed endpoint jets is unique. | Does not establish gate optimality or minimum classical evaluation cost. |
| `HermitePolynomial.interpolant_eq_sourceInterpolant` | The extended-Euclid two-point interpolant equals the positive closed form. | An exact construction-to-construction bridge, not reliance on a numerical fit. |
| `HermitePolynomial.smoothInitial_pos` | Every value of the literal piecewise function is strictly positive. | All real `p`; this is what makes every finite target normalizable. |
| `HermiteSmoothness.smoothInitial_contDiff` | `ContDiff Real k (smoothInitial k)` for every natural `k`. | Global finite-order regularity of the literal piecewise target, proved by two applications of `contDiff_splice` and exact equality with the original branch convention. |
| `RealAmplitudePreparation.splitAngle_firstColumn` | RY of the defined exact angle sends a branch norm to the pair `(a,b)`. | Every real `a,b`, including signed pairs and the zero pair. |
| `RealAmplitudePreparation.prepareCircuit_unitary` | The denotation of the constructed primitive list is unitary. | Every real amplitude table, even the all-zero table; this statement alone makes no preparation claim for a zero target. |
| `RealAmplitudePreparation.prepareCircuit_firstColumn` | The first column equals `f/sqrt(sum f^2)`. | Requires every amplitude nonnegative and the total squared norm strictly positive. The current theorem does not advertise preparation of arbitrary signed tables. |
| `RealAmplitudePreparation.prepareMatrixLE_firstColumn` | The same preparation statement on flat little-endian integer indices. | Requires every amplitude strictly positive. Hermite positivity discharges this premise. |
| `HermiteStatePreparation.hermiteUnitary_eq_circuit` | The advertised matrix is the reindexed denotation of `hermiteCircuit`, an actual primitive list. | Definitional equality; it prevents an unrelated abstract unitary from being substituted for the circuit. |
| `HermiteStatePreparation.hermite_firstColumn` and `hermite_stateAction` | The matrix first column, equivalently its action on the all-zero ket, is the normalized literal sample vector. | All `k,n : Nat` and `L : Real`. |
| `HermiteStatePreparation.hermite_normalized` | The sum of `Complex.normSq` of every normalized amplitude equals one. | The normalizer is the square root of the actual full sample sum, not an assumed normalization flag. |
| `HermiteStatePreparation.hermiteStatePreparation_complete` | Positive normalizer, normalized vector, matrix unitarity, state action, exact RY/CX counts and zero oracle calls are conjoined. | This preparation root does not itself contain endpoint-jet, `ContDiff`, export, or hardware correctness propositions. |
| `HermiteStatePreparation.hermiteCertificate` | The constructed matrix and actual proofs populate the existing concrete certificate API. | The normalization and preparation fields are supplied by the preceding mathematical theorems. |

The root's parameter domain is deliberately broader than the usual physical
grid description. For `L>0`, `gridPoint` is the left-inclusive, right-exclusive
uniform grid on `[-pi*L,pi*L)`. At `L=0` the points coincide; negative `L`
reverses the grid. Positivity and state preparation still make sense. The
finite exporter restricts `L>0`. At `n=0`, Lean has one sample, normalized
amplitude one and the empty circuit; the QASM exporter starts at one qubit.

## Formula and boundary comparison

Writing `G_k(t)=(1-t)^(k+1) A_k(t)`, Lean defines the source polynomial by
Taylor translation of `exp(-1)*G_k(t)+G_k(1-t)`. Its evaluation theorem makes
the translation explicit:

\[
P_k(p)=e^{-1}(1-t)^{k+1}A_k(t)+t^{k+1}A_k(1-t),\qquad t=p+1.
\]

`coefficientPolynomial_eval` gives exactly the exporter's coefficients

\[
a_{k,r}=\sum_{m=0}^{r}\binom{k+r-m}{k}\frac1{m!}.
\]

Lean selects the polynomial at both `p=-1` and `p=0`; Python selects an
exponential at those endpoints. This syntactic difference does not change
the target: the order-zero endpoint theorems give equality of the values.
Both use the same two exponential tails outside the splice.

The preparation root is not, by its type, a proof of global smoothness.
That result now has its separate named theorem:
`QuantumBlockEncoding.HermiteSmoothness.smoothInitial_contDiff` proves
`ContDiff Real k (smoothInitial k)` for every natural order `k`. Its proof
uses matching analytic endpoint derivatives, the reusable `contDiff_splice`
theorem at both junctions, and `smoothInitial_eq_double_splice` to recover
the exact original endpoint branch convention. This is an actual global
regularity proposition, rather than an inference from the function's name.
The preparation and regularity roots remain distinct; publication must
include both in the successful Lean gate.
In particular the order-one cubic has middle second derivative `8/e-10`
at zero, whereas the right exponential has second derivative `1`; it should
not be described as `C^2`.

## Circuit and executable correspondence

The flat Lean basis recurrence is
`index = bit(q0) + 2*index(remaining wires)`, so it agrees with the Qiskit
little-endian basis. `lastBasisEquiv` removes the highest wire; it does not
reverse the already prepared lower wires. The recursive marginal is

\[
g(b)=\sqrt{f(b,0)^2+f(b,1)^2}.
\]

Recursing on this marginal prepares lower-bit masses before the highest-bit
split. Expanding the recursion gives precisely the exporter's prefixes
`j mod 2^d=s`. The earlier gates act on the lower wires by `liftGate`, leaving
the new high wire untouched until its multiplexor.

For positive Hermite samples the two child amplitudes `a,b` are nonnegative.
Lean's split angle is `2*arccos(a/sqrt(a^2+b^2))`; the exporter uses
`2*atan2(b,a)`. These expressions select the same first-quadrant angle.
Both assign zero to an all-zero subtree. The exporter rescales every sample
by the same positive maximum before constructing masses; the resulting
conditional ratios are unchanged.

Both compilers consume the lowest supplied control first, split angle tables
into its zero and one assignments, and emit chronological
`half-add subtree; CX; half-sub subtree; CX`. Lean evaluates later gates on
the left of earlier gates, matching circuit execution. Its
`standardRyMatrix(theta)` uses the physical half-angle, so the sign and factor
of two agree with `QuantumCircuit.ry` and OpenQASM.

This comparison is a mathematical and source-level correspondence. The
Python exporter is not extracted from Lean, and no theorem equates Python
execution with the Lean evaluator. In particular, floating-point `atan2`,
square roots, exponential evaluation and serialization remain outside the
symbolic proof.

## Resource and exact-angle boundary

The proven reference counts are `2^n-1` RY and `2*(2^n-1-n)` CX. The literal
construction uses only these gate forms on exactly `n` wires, with no
ancillary register or measurement. The zero-oracle field is consistent with
the primitive language, which has no oracle instruction. It is not a bound
on the classical work required to enumerate the amplitude table.

`ExactAngle.real` stores a mathematical real value and its evaluator returns
that value. This is legitimate exact matrix semantics; it does not introduce
an assumed proof of the state action. It also does not supply a computable
decimal evaluator or a finite gate-synthesis approximation theorem. Resource
statements count ideal rotations at unit cost and exclude classical table
construction, precision cost, fault-tolerant decomposition and connectivity
overhead. The representative Qiskit depth of 13 is a finite measurement, not
the asserted arbitrary-width depth theorem. No resource-optimality claim is
supported by this construction.

Textual inspection found no `sorry`, `admit`, explicit new `axiom`, or `unsafe`
declaration in the two reviewed preparation modules. This is not a complete
transitive axiom audit. The shared little-endian support file contains finite
`native_decide` lemmas; the general preparation proof itself proceeds by
induction and the primitive matrix theorems. Final acceptance must be tied to
the repository's recorded build results, rather than this textual check.

## Finite evidence and negative tests

For `k=1,n=3,L=1`, the saved acceptance artifact records 7 RY, 8 CX, depth 13,
zero ancillas and zero oracle calls. Primitive NumPy evaluation, direct
Qiskit statevector evaluation, and OpenQASM 2/3 round trips have maximum
amplitude error `1.942890293094024e-16` against the normalized target.

The separate replay tool imports no exporter functions. It solves all
endpoint interpolation equations by exact rational Gaussian elimination,
evaluates the resulting expanded polynomial at 100 decimal digits, and
replays the saved QASM. This target computation differs materially from the
exporter's positive factored formula. The independently reconstructed sample
values differ by at most `1.1102230246251565e-16`; the saved QASM errors remain
`1.942890293094024e-16`.

All 15 exporter regressions passed in the recorded local run. They include
full-column multiplexor checks, all basis targets through four qubits,
zero-mass subtrees, endian/sign checks, exact rational endpoint jets through
order 12, independent interpolation, and backend round trips. Negative tests
show failure for missing Qiskit, stale acceptance after failure, missing or
changed artifacts, and a forged success field with an updated artifact hash
but an incorrect circuit. These finite tests support the executable bridge;
they do not prove an arbitrary-width numerical error bound.

The final cross-platform byte audit found that Windows text output had used
CRLF for generated artifacts. The exporter now explicitly writes LF-only
UTF-8 JSON, QASM, SVG and CSV, and a regression inspects the emitted bytes.
The packet's scoped Git line-ending rule preserves the exporter source and
artifact bytes across Windows and Linux checkouts; regenerated hashes and
independent replay are checked after this normalization. All 13 packet files
have zero carriage-return bytes, and each raw Git blob hash equals its hash
after Git's clean filter. The active attributes report `text` and `eol=lf`
for the exporter, CSV and acceptance record.

## Figure review

`docs/assets/hermite-proof-flow.svg` was rendered in a headless browser at a
1200-by-650 viewport and visually inspected. Automated bounding-box checks
found zero text labels outside their containing cards or the SVG. The four
construction stages and the two evidence panels are readable, and the exact
versus finite distinction is visible without reading a separate caption.
No visual defect required an edit.

The diagram is a conceptual route map, not the literal Lean dependency graph:
strict positivity establishes the normalizer, primitive semantics establishes
unitarity, and endpoint jets establish the source interpolation contract.
Its detailed circuit companion supplies the individual gate and register
transcript. The figure's green panel must be read together with the named
theorem scopes above and the separate smoothness and build gates.

## Reproduction and acceptance

```bash
python executable-exports/SP-HERMITE-001/qiskit/export.py --self-test
python executable-exports/SP-HERMITE-001/qiskit/replay.py
lake build
lake build Tests
bash scripts/build-all.sh
```

The first two commands reproduce the finite evidence reviewed here. The
remaining commands are the independent obligations for symbolic and website
publication acceptance; this review note does not claim to be their log.

## Local browser acceptance (2026-09-09)

The genuine generated Hermite case was opened in a headless Chromium-based
browser using the canonical frontend and its actual Lean build record. This
checked the frontend snapshot before final Blueprint assembly, not a deployed
GitHub Pages release. No substitute certificate or injected success report was
used.

At desktop width 1440 pixels and mobile width 390 pixels, the page scroll width
equals the viewport width, including after opening a complete source panel.
An initially reproduced mobile grid overflow was repaired in the canonical
stylesheet; the final check used that stylesheet without browser-injected CSS.
A separate responsive regression passes at widths 390, 768 and 1440 pixels.
Long mathematical expressions remain scrollable inside their own containers,
rather than being clipped or forcing the whole page sideways.

The inspected snapshot has six successfully rendered mathematical containers,
two loaded SVG figures, eleven source panels with copy buttons, and twelve
download links. All twelve downloads and the linked build record returned
nonempty successful responses. Four complete Lean source panels and the
complete LaTeX panel match their repository sources. Copying the LaTeX panel
also matches exactly after normalizing only Windows clipboard CRLF to LF.
No browser runtime errors, failed requests, or mathematical-rendering errors
were observed in these two viewport checks.

These observations do not establish remote availability, a successful GitHub
Actions run, completion of the full Blueprint site, or the contents of a later
deployed revision. Online publication still requires its own successful build,
deployment record and live-page inspection. The checks also do not cover every
browser, accessibility technology, external theorem link, or future CDN state.
