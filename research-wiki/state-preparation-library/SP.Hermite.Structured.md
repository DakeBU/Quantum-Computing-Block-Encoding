# Structure memory: Hermite samples without an exponential table

Task: `SP-HERMITE-POLY-002`. Evidence class: **compiled exact-real polynomial
quantum-resource root; classical cost and uniform executable certificate open**. The
[experiment packet](../../experiments/hermite-polynomial/README.md) records
both failed and surviving implementations. Consult the
[current frontier](../../proof-obligations/SP-HERMITE-POLY-002.md) before work.

## When to retrieve this card

Use for formula-defined piecewise polynomial/exponential amplitudes, binary
grid cuts, polynomial transfer cores, interval masses, or a low-bond state
preparation proposal. Do not apply it to an arbitrary unstructured amplitude
table. Always expose polynomial degree, precision and input-access costs.

The target is the existing function value divided by its Euclidean norm.
It is not the square root of that function. The output convention is
little-endian even when a candidate reads input digits most-significant first.

## Checked complete Hermite quantum-resource interface

Purpose: use the literal source family with polynomial quantum gates/depth,
without supplying a target-action oracle or a prepared bond state.
Import: `QuantumBlockEncoding.HermitePolynomialResources`.
Full name:
`QuantumBlockEncoding.HermitePolynomialPreparation.exists_polynomial_resources`.

```lean
open QuantumBlockEncoding HermitePolynomialPreparation HermiteFiniteChain

example (k n : Nat) (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit ((n + 1) + bondQubits k),
      circuit.gateCount ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      circuit.resource.depth ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      circuit.resource.oracleCalls = 0 ∧
      evalPrimitiveCircuit circuit ∈
        _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + bondQubits k)) ℂ ∧
      ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
        evalPrimitiveCircuit circuit (Fin.append x b) (fun _ => 0) =
          if b = (fun _ => 0) then
            HermiteStatePreparation.normalizedAmplitude k (n + 1) L
              (primitiveBasisLEEquiv (n + 1) x) else 0 :=
  exists_polynomial_resources k n L hL
```

Here `n+1` is the number of data qubits, and `bondQubits k` is
`Nat.clog 2 (2*k+6)`. This bounds the full instruction count and actual
wire-scheduled depth. The complete output statement proves clean ancillas;
the generic resource metadata does not infer which wires are ancillas.
Tests: `ABEISTests/HermitePolynomialPreparation.lean` and
`ABEISTests/HermitePolynomialResources.lean`. All audited roots use only the
standard three Lean axioms. This proves ideal real-angle circuit existence,
not finite-bit preprocessing, arbitrary-input preparation, or Python QASM
refinement. See the [result and cost audit](../../experiments/hermite-polynomial/FORMAL-RESULT.md).

Checked source digest for `HermitePolynomialResources.lean`:
`E3498942130F957315C3328CC0E55D1054B042A14D670BBB80C743B531832D2D`.
The [gate snapshot](../../experiments/hermite-polynomial/evidence/cycle02-formal-resource-gates.json)
records the checked roots and final integration scope. Recheck after edits;
this card is not a second acceptance database.

## Checked reusable local norm supplier

Purpose: avoid enumerating all output words just to normalize a small-core
source. Import: `QuantumBlockEncoding.TensorTrainNormEnvironment`.
Full name:
`QuantumBlockEncoding.TensorTrainNormEnvironment.norm_eq_of_contract`.

```lean
open QuantumBlockEncoding TensorTrainCanonical TensorTrainNormEnvironment
open scoped BigOperators

example {n : Nat} {I : Type*} [Fintype I] (C : Chain n 1 1)
    (e : Word n ≃ I) (target : I → ℝ)
    (h : ∀ x, contract C x 0 0 = target (e x)) :
    TensorTrainNormEnvironment.norm C = Real.sqrt (∑ i : I, target i ^ 2) :=
  norm_eq_of_contract C e target h
```

Supply a *proved raw core action*, not the desired norm as a premise.
`gram` contracts a shared small right environment at each core;
`arithmeticBudget_le` and `environmentScalars_le` give the explicit schedule
and storage bounds. Tests: `ABEISTests/TensorTrainNormEnvironment.lean`.
For this source, import `QuantumBlockEncoding.HermiteFiniteNorm` and use
`localSampleNorm_eq_sampleNorm k n L hL` or `sourceChain_eq_local k n L hL`.
These exact signatures and uses are tested in `ABEISTests/HermiteFiniteNorm.lean`.
The schedule budget is not an external compiler's runtime or rounding proof.

## Generic compiler reuse boundary

For another real source with a scalar-boundary `Chain (n+1) 1 1`, retrieve
`QuantumBlockEncoding.TensorTrainPrimitivePreparation.exists_primitive_preparation`
from the matching module. Its premises are a checked maximum bond
`maxBond C <= 2^q` and exact unit mass, and its output is an actual primitive
circuit on `n+1+q` wires with at most `(n+1)*(6*(2^q)^3)` instructions,
zero oracles, unitarity and every clean/non-clean output amplitude.
Use the full statement printed and instantiated by
`ABEISTests/TensorTrainPrimitivePreparation.lean`; do not guess a namespace
or silently reverse the source word. The public data convention is encoded
by `wordOfBasis (fun i => x i.rev)`.

Source-specific kernels, normalization and bit-order adapters still have to
be proved. Existing canonicalization choices provide exact circuit existence,
not a charged classical extraction algorithm. This interface is a reusable
proof asset, not evidence that an unseen scientific task has been solved.

## Checked sample-factorization interface

Purpose: certify that every prefix/suffix cut of the literal source samples
has bounded width, rather than inferring rank from a dense numerical SVD.

Import: `QuantumBlockEncoding.HermiteSampleStructure`.
Full name:
`QuantumBlockEncoding.HermiteSampleStructure.sampled_cut_factorization`.

```lean
open QuantumBlockEncoding HermiteCutRank HermiteSampleStructure

example (k pWidth sWidth : ℕ) (L : ℝ) (hL : 0 < L) :
    FactorsThrough (ι := HermiteBond k)
      (fun x y => HermiteStatePreparation.sampledAmplitude k (pWidth + sWidth) L
        (cutSampleIndex pWidth sWidth x y)) :=
  sampled_cut_factorization k pWidth sWidth L hL
```

The code block gives the complete parameterized statement and its successful
application. `FactorsThrough` retains two explicit matrix-factor witnesses;
`hermiteBond_card` proves their inner dimension is `8*k+12`.
`normalized_cut_factorization` has the same parameters and factors samples
divided by `HermiteStatePreparation.sampleNorm k (pWidth+sWidth) L`.
Source/test: `QuantumBlockEncoding/HermiteSampleStructure.lean` and
`ABEISTests/HermiteStructure.lean`.

Closes: exact cut rank and literal target correspondence. Does not close:
consistent sequential cores, QR, primitive realization, epsilon or bit cost.

## Checked polynomial transfer interface

Import: `QuantumBlockEncoding.HermiteTransferCores`.
Full name: `QuantumBlockEncoding.HermiteTransferCores.sourceInterpolant_transfer`.

```lean
open QuantumBlockEncoding

example (k : ℕ) (origin : ℝ) (weights : List ℝ) :
    HermiteTransferCores.polynomialAmplitude (2 * k + 1)
      (HermitePolynomial.sourceInterpolant k) origin weights =
      (HermitePolynomial.sourceInterpolant k).eval (origin + weights.sum) :=
  HermiteTransferCores.sourceInterpolant_transfer k origin weights
```

Each weight updates `d+1` monomial features by an explicit binomial matrix.
This is an exact forward identity, not a stable floating-point recipe.
Its direct masked implementation is retained as the failed MPS-01 parent.

## Checked normalization anchor

Import: `QuantumBlockEncoding.HermiteIntervalMass`.
Full name: `QuantumBlockEncoding.HermiteIntervalMass.sampled_mass_ge_one`.

```lean
open QuantumBlockEncoding
open scoped BigOperators

example (k n : ℕ) (L : ℝ) :
    1 ≤ ∑ j : Fin (gridSize (n + 1)),
      (HermiteStatePreparation.sampledAmplitude k (n + 1) L j) ^ 2 :=
  HermiteIntervalMass.sampled_mass_ge_one k n L
```

The actual grid contains its zero-coordinate sample, whose amplitude is one.
This anchor has no positivity assumption on `L`; physical construction still
requires `L>0`. The same module supplies `hermite_polynomial_mass` and
`exponentialMassClosed_eq`. Retrieve their complete types before assembling
piecewise intervals. A closed-form classical mass is not a coherent angle
oracle and does not make an exponentially emitted rotation tree efficient.

## Failure memory and protocol

- MPS-01's near-orthonormal QR output concealed target error about `1.529` at
  `n=8,k=8,L=10`. Validate original target action, not only internal norms.
- Large positive exponential factors overflowed even on masked-out branches.
  MPS-02 uses local positive Bernstein coordinates and bounded tail factors.
- Exact-zero pruning of float64 data can remove underflowed nonzero real terms.
  Do not label it exact symbolic truncation.
- A padded terminal stage need only clear **reachable** input columns. Its
  unused completion columns cannot all end in bond zero when the padded
  input dimension exceeds two.
- `QuantumBlockEncoding.Matrix` can shadow `_root_.Matrix` after circuit
  imports. Use `_root_.Matrix` for general finite index types; do not guess
  that a theorem has the wrong dimension because of namespace shadowing.
- Generic route-card retrieval originally dropped the Hermite root from an
  80-row result. Put its explicit qualified module/root in the task packet;
  the bounded retrieval fix preserves it. The index is still a preview,
  so verify a full signature with Lean and keep a successful instantiation.

Before reusing these results, rebuild the named test module. New retrieval
records should carry the checked source digest and gate scope; changes to a
source invalidate an old check record. Do not turn this card into a second
mutable acceptance database.

## Cycle-03 deterministic construction and stored refinements

Prefer `QuantumBlockEncoding.ConstructiveHermitePreparation.prepare` when a
consumer needs a named circuit, not an existential circuit witness. It takes
`k n : Nat` and `L : Real`, where the number of data qubits is `n+1`.
Its proof `prepare_spec k n L hL` requires only `hL : 0 < L`, and supplies
the same literal normalized source, all non-clean bond sectors equal to zero,
full unitarity, no oracles, and actual gate/depth bounds `48*(n+1)*(2*k+6)^3`.
The constructor uses the local norm supplier, deterministic rectangular LQ,
explicit active-column SO completion and primitive assembly. The source bond
bound is essential; this is not efficient loading of arbitrary amplitude lists.

Checked instantiation, from `ABEISTests/ConstructiveHermitePreparation.lean`:

```lean
open QuantumBlockEncoding

example (x : PrimitiveBasis 3)
    (b : PrimitiveBasis (HermiteFiniteChain.bondQubits 1)) :
    evalPrimitiveCircuit (ConstructiveHermitePreparation.prepare 1 2 1)
      (Fin.append x b) (fun _ => 0) =
      if b = (fun _ => 0) then
        HermiteStatePreparation.normalizedAmplitude 1 3 1
          (primitiveBasisLEEquiv 3 x) else 0 :=
  ConstructiveHermitePreparation.prepare_columns 1 2 1 (by norm_num) x b
```

Required import: `QuantumBlockEncoding.ConstructiveHermitePreparation`.
For another normalized scalar-boundary real chain, retrieve the complete
`ConstructiveTensorTrainCompiler.compile_spec` type and the arbitrary-word
`compile_word` application in the same checked test. They retain explicit
MSB source words versus public LSB wire order and require a proved bond bound.

The following reusable cost refinements close local interfaces only:

| Import / namespace suffix | Producer and checked bridge | Assumptions / cost boundary |
| --- | --- | --- |
| `StoredRectangularGivens` | `compile`, `compile_reduced`, `compile_transform`, `compile_total_cost_le` | stored N-by-M input; all shapes and zero pivots; extended exact-real operations, not bits |
| `StoredThinLQ` | `compile_R`, `compile_Q`, `compile_total_cost_le` | outputs exactly equal `ConstructiveThinLQ.factor`; transpose and extraction charged |
| `StoredBernstein` | `restrict_value`, `restrict_total_cost_le` | stored degree-d coefficient input; two-edge restriction, repeated row work counted; source generation excluded |
| `SelectedRyTrace` | `selected_refines`, `selected_gateCount` | exact rational local trace instantiated with one symbolic angle; not float64 QR/rounding correctness |

All four suffixes follow `QuantumBlockEncoding`. Their matching
`ABEISTests/*.lean` files carry successful calls and axiom checks; cycle-03
integration evidence carries source digests. A costed local supplier must
still be composed through the actual source-to-output algorithm before
claiming total classical polynomial cost. The new exact-real producer by
itself does not fill that gap or certify a numerical backend.

## Cycle-04 supplier lookup

Use the following complete import names; matching tests contain checked
instantiations. See the [cycle-04 packet](../../experiments/hermite-polynomial/CYCLE04-RESULT.md)
for the current scoped versus integrated gate status.

| Import suffix after `QuantumBlockEncoding.` | Retrieve first | Important boundary |
| --- | --- | --- |
| `HermiteBinaryCutoff` | `compute_value n L hL`, `compute_cost n L op` | `n+1` data bits; exact-real comparison, not finite-bit classification |
| `HermiteExplicitBond` | `bondEquiv k`, `same_literal_source k n L hL x` | computable explicit index layout; only observable contraction is equated to the old layout |
| `StoredHermiteCoefficients` | `compile_value k r`, `compile_pos k r`, `compile_exponentialCalls k` | cached original positive coefficients; one exponential counted separately |
| `StoredTensorTrainNorm` | `gram_value C`, `norm_value C`, `norm_total_cost_le C D bound` | already stored input; do not evaluate a dense all-word sum to supply the norm |
| `StoredSelectedRyTrace` | `selected_value wires target distinct chosen`, `selected_total_cost_le` | exact ordered local trace; `2^q` is local control size, not data-grid size |

These modules are supplier candidates for a composed stored Hermite compiler.
They do not by themselves replace `ConstructiveHermitePreparation.prepare`
or discharge finite-precision and full executable-family acceptance.

## Cycle-05 source and accuracy lookup

All following suffixes use the import prefix `QuantumBlockEncoding.`.
`StoredHermiteRawSource.raw_value k n L hL` gives literal stored-chain
equality, and `raw_contract k n L hL x` supplies every raw sample.
`StoredHermiteRawCost.raw_certified k n L hL` binds that same returned
chain to its polynomial ordinary budget and separate exponential/selected
integer ledgers. Use the checked `ABEISTests/StoredHermiteRawSource.lean`
norm-consumer calls; do not insert a dense sample-norm evaluator.

`PrimitiveRyPerturbation.eval_ry_clm_distance_le target a b` uses the actual
physical target and Euclidean operator norm. The circuit consumer
`PrimitiveCircuitPerturbation.prepare_conditional_clm_distance_le k n L hε approximate aligned`
requires positional gate alignment and angle budget
`ε/(24*(n+1)*(2*k+6)^3)`. It does not compute rounded angles.
Wrong-wire substitutions and gate reordering are rejected in the matching
tests; equal raw angles on different wires do not imply equal operators.

See the [cycle-05 acceptance boundary](../../experiments/hermite-polynomial/CYCLE05-RESULT.md).
Old cardinality-based and new explicit source layouts have equal observable
action, not a proved entrywise-identical internal representation.
