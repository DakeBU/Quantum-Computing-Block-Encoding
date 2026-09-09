# Hermite smooth state preparation

## Frozen contract

For every natural smoothness order `k` and every finite qubit grid, prepare the
normalized samples of the two-endpoint Hermite extension of `exp(-abs(p))`.
The positive half-axis is `exp(-p)`; the middle polynomial has degree at most
`2*k+1` and matches derivatives through order `k` at `-1` and `0`.
The circuit uses explicit rotations and controlled gates, with no assumed
state-preparation oracle. Exact symbolic semantics and finite floating-point
exports are separate evidence classes.

## Frontier at local resumption

Root acceptance target: explicit Hermite source conditions, normalized target,
unitary state-preparation action, executable replay, and a theorem-linked case page.

Highest certified frontier: no new Hermite implementation is yet compiled.
The inherited development branch contains only three workflow files.

Blocking interfaces: Hermite polynomial construction; generic preparation
semantics; source-to-circuit integration; fail-closed artifact checks.

Independent uncertainties: algebraic endpoint proof, circuit compilation,
and executable numeric replay.

Evidence required for merge: named Lean roots, `lake build`, `lake build Tests`,
mandatory-file negative tests, executable replay, and the full site gate.

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| H | Explicit Hermite polynomial and endpoint jets | Polynomial algebra | Polynomial worker | Pending | This window | Lean | active leaf |
| S | Generic normalized sample preparation | Rotation semantics | Circuit worker | Pending | This window | Lean | active leaf |
| E | Primitive export and numerical replay | H, S conventions | Export worker | Finite evidence only | This window | NumPy and Qiskit | active leaf |
| R | Hermite root and public case | H, S, E | Frontier Master | Pending | Case page | Full repository gate | blocked internal |

Historical chat drafts were not committed. Their mathematical formulas and
register conventions are recovered from the handoff; new evidence is produced
locally and must not be inferred from the earlier workflow green status.

## Verified frontier after local construction (2026-09-09)

The preceding table records the starting frontier, not the current result.
The full local Lean gate now builds the library, Tests, and all 88 discovered
source modules explicitly with Lean 4.29.1. No `sorry`, `admit`, extra axiom,
assumed preparation oracle, or replacement scientific target was introduced.

| Node | Current evidence | Status |
| --- | --- | --- |
| H | `HermitePolynomial.sourceInterpolant_eval`, endpoint derivative theorems, positivity and uniqueness; `HermiteSmoothness.smoothInitial_contDiff` | compiled general-order construction and global smoothness |
| S | `RealAmplitudePreparation.prepareCircuit_firstColumn`, primitive unitarity and exact reference RY/CX counts | compiled reusable nonnegative-amplitude constructor |
| E | Mandatory artifact checks, 15 executable tests and independent saved-QASM replay | passed finite numerical acceptance; not a symbolic family certificate |
| R | `HermiteStatePreparation.hermiteStatePreparation_complete`, normalized literal grid samples, zero ancillary wires; full rendered case and source downloads | Lean root closed; final Blueprint assembly and online deployment pending |

All declaration names in this table have prefix `QuantumBlockEncoding.`.
Independent review is recorded in
[the source-to-certificate review](../docs/hermite-independent-review.md).
The actual frontend renders the complete mathematical explanation, six formula
containers, two figures and twelve downloads. Desktop/mobile checks exposed a
grid overflow, which was fixed and covered by a browser regression test.

The remaining publication blocker is a reproduced Windows mixed-separator
defect in pinned Verso search-asset output. A failed renderer is not promoted
to a successful website build. Remote publication status must be established
separately from these local proof and rendering results.
