# Candidate Population: QBE-OP-CUBIC-DIAGONAL-001

Updated: 2026-06-19 20:38 JST

Target:

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0,
alpha = 1.
```

The search is in `exploratoryConstruction` mode, but the target operator is
fixed.  Candidate scores are compared only inside the same semantic tier, using
`(gateCount, depth, auxiliaryQubits, oracleCalls)`.

## Certified Population

No candidate has entered the certified population yet.  The compiled Lean
surface currently certifies the target matrix, normalizer value, amplitude
range, clean-block contract bridge to `cubicDiagonalOperator`, and the
oracle-label resource tuple.  It does not yet certify a unitary primitive oracle
or an expanded gate-level circuit.

## Active Candidate Records

| Candidate family | Tier | Current score | Lean surface | Remaining obligations | Next route |
|---|---|---|---|---|---|
| diagonal primitive amplitude oracle | unexpanded primitive oracle-label tier | `(1, 1, 1, 1)` via `amplitudeOracleResourceTuple_eq` | `cubicDiagonalOperator`, `exactNormalizer`, `amplitudeOracleLayout`, `amplitudeOracleCircuit`, `diagonalCleanBlockContract`, `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | primitive unitary semantics and clean-block certificate remain open | close `DIAG-BLOCK-BRIDGE-001`, then state `DIAG-PRIM-UNITARY-001` without semantic flag promotion |
| reversible arithmetic plus controlled rotation | expanded arithmetic-gate tier | not scored yet | no task-specific expanded Lean declaration | reversible cube arithmetic, angle convention, controlled rotation semantics, unitarity, clean-block equality, resources | backlog unless primitive contract is rejected or stalls |

## Finite Executable Population

No finite executable candidate is promoted.  Lower 3 may run necessary-condition
checks for `n = 1, 2, 3`, but those checks only guard the target and primitive
block shape.  They are not certified block encodings and are not parents for
the certified population.

## Insight Pool

| Route | Reason kept | Status |
|---|---|---|
| primitive one-signal amplitude oracle | directly matches the diagonal target with $\alpha = 1$ and minimal unexpanded score | active |
| arithmetic exact cube with controlled `R_y` | possible gate-level expansion if primitive oracle contracts are not accepted | backlog |
| approximate polynomial or QSVT-style diagonal function route | possible later approximate route for hardware-facing expansion | insight only |

## Rejected Or Retired Routes

| Route | Reason |
|---|---|
| rank-one cubic state-preparation target | wrong operator; it encodes `|v><0^n|`, not the diagonal `D_n` |
| normalized cubic vector state preparation | changes the normalizer and target semantics |
| executable export before Lean certificate | violates the post-Lean export cadence; finite code may diagnose but not certify |

## Promotion Rule

A candidate may enter the certified population only after Lean proves:

1. the advertised unitary or primitive oracle contract at the declared tier;
2. the clean block is pointwise equal to `cubicDiagonalOperator n` with
   `exactNormalizer n = 1`;
3. the resource tuple is build-tested under the fixed score order; and
4. any executable export cites the named Lean certificate instead of replacing
   it.
