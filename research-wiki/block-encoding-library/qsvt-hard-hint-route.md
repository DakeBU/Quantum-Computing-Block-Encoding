# QSVT Hard-Hint Route

Use this card when the user or upper agent suggests:

```text
first construct a block encoding of O_0 = sum_j x_j |j><j|,
then use QSVT to obtain x^3 or another polynomial transform
```

This is a route memory, not a completed theorem unless the referenced Lean
contracts are closed.

Use it as a consumer-route memory, not as an instruction to rederive QSVT.
Agents should first retrieve the compiled local anchors below.  If the needed
result is already covered by a compiled leaf, instantiate it or write the
smallest adapter.  If the needed QSVT theorem is still contract-only, keep that
boundary explicit and prove only the local input-BE, side-condition, or target
identification leaf.  Reproving the full QSVT theorem is a separate
foundational task and should not be assigned inside an ordinary oracle
construction run.

## Route Sketch

1. Target a diagonal value oracle:
   $$
   O_0 = \sum_{j=0}^{2^n-1} x_j |j\rangle\langle j|,
   \qquad x_j = j/2^n.
   $$
2. Build or cite a value-to-amplitude, rational-Householder, or diagonal
   controlled-rotation block encoding of `O_0`.
3. Before opening an external QSVT dependency, check the compiled product
   route. For a monomial such as `x^3`, three exact product certificates may
   close the target-identification layer immediately.
4. Treat QSVT as a resource-optimization consumer of this proved block encoding. For
   $P(x)=x^3$, the polynomial is bounded on `[-1,1]` and has odd parity.
5. Produce a proof DAG:
   `O_0 BE -> QSVT admissibility of x^3 -> QSVT consumer contract -> BE of O_0^3`.
6. If the full QSVT theorem is not formalized, mark that node
   `contract-only`; do not claim final Lean certification beyond the contract
   boundary.

## Proof Tree

```text
Goal: block-encode O = sum_j x_j^3 |j><j|
│
├─ Node A: grid/value facts
│  ├─ define x_j = j / 2^n
│  ├─ prove 0 <= x_j <= 1
│  └─ prove x_j^3 is bounded by 1
│
├─ Node B: certified BE of O_0 = diag(x_j)
│  ├─ choose a diagonal/value-to-amplitude construction
│  ├─ prove clean-block entry equality for every j
│  ├─ prove workspace cleanup or state it as an explicit contract
│  └─ prove unitarity or keep an amplitude-oracle semantic contract
│
├─ Node C: polynomial side conditions for P(x)=x^3
│  ├─ bounded on [-1,1]
│  ├─ odd parity
│  └─ degree metadata
│
├─ Node D1: compiled product consumer (first fallback for monomials)
│  ├─ multiply the proved clean-block payload three times
│  └─ identify O_0^3 with the cubic diagonal target
│
├─ Node D2: QSVT consumer (optional resource route)
│  ├─ input: proved BE of O_0
│  ├─ input: QSVT phase/admissibility certificate for P
│  └─ output: BE of P(O_0) = O_0^3
│
└─ Node E: target identification
   └─ prove O_0^3 = diag(x_j^3)
```

The current ABEIS policy is conservative: Node B can be made a normal Lean
certificate; Node C has small polynomial leaves that can be formalized; Node
D1 is the preferred compiled fallback for a monomial; Node D2 remains
`contract-only` unless a full local QSVT theorem or accepted external theorem
interface is explicitly provided. A candidate using D2 must not be reported
as fully Lean-certified while that boundary remains open.

## Lean Anchors

| Node | Current Lean anchors | Status |
| --- | --- | --- |
| A | `gridPoint_nonneg`, `gridPoint_lt_one`, `gridPoint_le_one`, `cubicAmplitude_le_one`, `cubicAmplitude_nonneg` in `CubicStatePreparation.lean` | compiled local leaves |
| B | `diagonalCleanBlockContract`, `primitiveOracleCleanBlock_eq_target`, `primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target`, `expandedAmplitudeOracleCleanBlockContract_eq_target` | compiled contract/semantic leaves |
| C | `chebyshevT`, `chebyshevT_three_recurrence`, `chebyshevT_four_recurrence`; polynomial side-condition structures are still lightweight | partial compiled leaves, not full QSVT admissibility |
| D1 | `productCleanBlockCertificate`, `productExactCleanBlockCertificate`; task adapter `linearDiagonalCubicProductCertificate` | compiled matrix-arithmetic consumer |
| D2 | `QubitizationChebyshevContract`, `QSVTConsumerContract` in `BlockEncodingClassics.lean` | contract-only consumer boundary |
| E | `diagonalCleanBlockContract_pointwise_eq`, `cubicDiagonalOperator`, `cubicDiagonalTarget` | compiled target-identification leaves |

For the cubic benchmark, the reusable rational-Householder card also exposes
`linearDiagonalHouseholderInputBEContract_complete` for the hinted input and
`cubicDiagonalHouseholderExactBEContract_complete` as an unconditional exact
root certificate.  Therefore an unavailable full QSVT semantics theorem may
block only the QSVT resource-optimization candidate; it must not keep the
operator-existence task open after the exact root certificate compiles.

Fast retrieval files:

- `QuantumBlockEncoding/CubicStatePreparation.lean`
- `QuantumBlockEncoding/BlockEncodingClassics.lean`
- `research-wiki/block-encoding-library/compiled-lean-leaf-index.md`
- `research-wiki/block-encoding-library/cards/BE.QSVT.ConsumerContract.md`
- `research-wiki/block-encoding-library/cards/BE.Qubitization.Chebyshev.md`
- `research-wiki/block-encoding-library/cards/BE.QueryModel.ValueToAmplitude.md`

## Reviewer Checklist

- Is the input block encoding of `O_0` actually certified?
- Are QSVT side conditions stated, not hidden?
- Is the theorem claiming a closed Lean proof, or only a contract skeleton?
- If Scenario 2 approximate search is active, is the epsilon tier explicit?
- Are non-Lean simulator/Qiskit checks used only as diagnostics or exports?

## Suggested Lower Tasks

- Lower Lean packet 1: prove or reuse the diagonal clean-block entry for the
  proposed `O_0` construction.  Do not touch QSVT yet.
- Lower Lean packet 2: prove boundedness/parity/degree facts for `x^3` only
  after Node B is stable.
- Lower natural-language packet: write the proof DAG and mark every QSVT
  side condition as `compiled`, `contract-only`, or `external theorem needed`.
- Middle packet: decide whether the active artifact is a fully certified
  diagonal-amplitude oracle, a QSVT contract skeleton, or an approximate
  search package.
- Reviewer packet: reject any final claim that crosses the contract-only QSVT
  boundary without a Lean theorem or explicit external theorem interface.

## Typical Failure Packets

| Failure | Scope | Repair |
| --- | --- | --- |
| Claiming `diag(x_j^3)` while only `diag(x_j)` is certified | coarse | relabel Node D as contract-only; continue proving Node B and C |
| Treating Qiskit simulation as proof for all `n` | coarse | keep Qiskit as export/diagnostic; require symbolic clean-block theorem |
| Missing workspace cleanup in value-to-amplitude oracle | fine/coarse depending on theorem | add cleanup contract or prove uncompute witness before block-entry theorem |
| Reproving grid boundedness from scratch | fine | search `compiled-lean-leaf-index.md` and reuse `gridPoint_*` / `cubicAmplitude_*` leaves |
