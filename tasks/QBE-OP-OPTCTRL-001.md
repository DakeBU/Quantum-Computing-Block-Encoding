# Main Case: Transfer-Operator Block Encoding

Task id: `QBE-OP-OPTCTRL-001`
Kind: `operatorBlockEncoding`
Mode: `operatorBlockEncoding`
Status: `active`
Created: `2026-06-17 01:30`

## Goal

State the query-operator target precisely.  The preferred input is a finite
matrix/operator `A`, a normalizer `alpha`, and the requested block-entry
contract:

```text
(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha
```

The system should construct a unitary candidate `U_A`, prove in Lean that it
contains the requested operator block, and score the candidate by:

1. gate count (smaller is better),
2. depth / parallel schedule length (smaller is better),
3. auxiliary qubits `a` (smaller is better),
4. unresolved oracle calls (smaller is better).

State whether this is a direct operator-to-block-encoding construction task, a
paper benchmark task, or an exploratory improvement task.  Paper benchmark
tasks reproduce a cited construction as a baseline; improvement tasks may
search for a better construction only after the original target is fixed.

Hybrid strategy:

- `operatorBlockEncoding`: given `A`, search for candidate `U_A`
  constructions, prove the block-entry and unitarity contracts, and rank
  candidates by gate count, depth, auxiliary qubits, and unresolved oracle
  calls inside a fixed asymptotic/backend tier.
- `paperBenchmark` / `faithfulPaper`: reproduce a cited construction as a
  source-faithful baseline.  Do not mutate the paper construction while proving
  the baseline.
- `exploratoryConstruction`: use Learning-Beyond-Gradients-style trial memory
  plus EoH-style candidate populations for circuit ideas.  Candidate scores are
  search hints only; Lean proof obligations decide acceptance.  This mode may
  improve a baseline after the original operator target is fixed.

## Source

- Paper/open problem: `main-case transfer operator: E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n`
- Lean target: `QuantumBlockEncoding/OptimalControl.lean`

## Operator Contract

- Operator/matrix `A`: the operator family
  `E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n`.
- System registers:
  - `time` register: contains basis states including `|0>` and `|k>`.
  - `type` register: contains basis states including `|0>` and `|1>`.
  - `state` register: `n` qubits, acted on by `I_n`.
- System qubits `n`: `TBD` for the identity/state register; total system
  dimension also depends on the time/type register sizes.
- Normalizer `alpha`: expected `1` if the partial-isometry/operator norm
  contract is confirmed; otherwise record the required scaling explicitly.
- Required block: selected clean ancilla block implementing `E_k / alpha`.
- Free parameters allowed in the oracle: `k`, time-register size, and any
  explicit encoding choices for time/type basis states.
- Required exactness or error tolerance: exact finite matrix equality first,
  followed by approximate search if exact search converges or stalls.  The
  exact target is

  ```text
  (<0^a| ⊗ I) U_A (|0^a> ⊗ I) = E_k / alpha
  ```

  and the approximate target is

  ```text
  ||E_k - alpha * ((<0^a| ⊗ I) U_A (|0^a> ⊗ I))|| <= epsilon.
  ```

  User knobs are `maxExactIterations`, `exactStallIterations`,
  `requiredCost`, `requestedEpsilon`, whether relaxed epsilon is allowed, and
  maximum upper/middle/lower agent counts for adaptive scaling.

## Baseline And Search Notes

The obvious source-level structure is a rank-one transition on the time
register, a rank-one transition on the type register, and identity on the
state register.  Lower agents should first test whether this can be implemented
as a small partial-isometry block encoding using standard unitary completion or
controlled swaps/reflections.  Candidate evolution should optimize:

1. gate count,
2. depth,
3. auxiliary qubits,
4. unresolved oracle calls.

Do not assume the displayed formula is automatically unitary; the task is to
embed it into a unitary block encoding and prove the clean block equals the
operator.

## Candidate Score

The default candidate score is defined in Lean as `BlockEncodingCost`:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Selection is lexicographic in that order inside one asymptotic/backend tier.
Parallel schedule depth is important, but it breaks ties after gate count.

## Adaptive Exact-To-Approximate Policy

ABEIS should use the following loop for this task family.

1. Search for exact BE candidates up to `maxExactIterations`.
2. If an exact candidate meeting `requiredCost` appears before the limit,
   enter Scenario 1: continue with approximate-improvement search for the
   requested `epsilon`, while keeping the exact champion as an epsilon-zero
   approximate candidate.
3. If exact search cannot meet the resource requirement, or stalls for
   `exactStallIterations`, enter Scenario 2: switch to approximate BE search.
   If the user allows relaxation, the upper layer may enlarge epsilon beyond
   the requested tolerance and must report that relaxation.
4. If no improvement appears after the configured generations, the upper layer
   may increase upper/middle/lower parallel agent counts up to the task
   maximum.  If agent-count scaling also fails, stop and report convergence or
   stall.

## Conversion Window

### Markdown

Human explanation, scope, and dependencies.

### LaTeX

Paste-ready theorem/proof statement.  Keep notation synchronized with Lean names.

### Lean

Expected file and declarations:

```lean
-- target: QuantumBlockEncoding/OptimalControl.lean
```

## Proof Obligations

- [ ] Matrix/operator target `A` is defined.
- [ ] Candidate unitary `U_A` or circuit schema is defined.
- [ ] Block-entry contract is stated with the exact ancilla projector.
- [ ] Unitarity of `U_A` is proved or recorded as a named obligation.
- [ ] Normalization `alpha` is explicit.
- [ ] Auxiliary qubit count `a` is explicit.
- [ ] Resource score `(gateCount, depth, a, oracleCalls)` is explicit.
- [ ] Candidate comparison against the current baseline is recorded when relevant.
- [ ] `lake build && lake build Tests` succeeds.

## Generation 0 Result: One-Ancilla Permutation Completion

Lean file:

```lean
QuantumBlockEncoding/OptimalControl.lean
```

Compiled declarations:

- `OptimalControl.exampleOperator`: concrete $E_1$ for one time qubit, one
  type qubit, and one state qubit.
- `OptimalControl.exampleUnitary`: 16-dimensional one-ancilla permutation
  completion.
- `OptimalControl.exampleImage_isPermutation`: finite permutation certificate.
- `OptimalControl.example_cleanBlock`: clean block equals the target operator.
- `OptimalControl.exampleVerified`: verified candidate packaging the unitarity
  proxy and block-entry proof.
- `OptimalControl.exampleCandidate_cost`: current score.

Current score:

```text
(gateCount = 1, depth = 1, auxiliaryQubits = 1, oracleCalls = 1)
```

Interpretation: this is a mathematically verified oracle-level candidate, not
yet a decomposed gate-level circuit.  The next explore step should try to
replace the single unresolved oracle call with an explicit reversible circuit
for the four-cycle completion, then compare the resulting depth/gate count
against this baseline.

## Generation 7 Result: Evolved Clean-Block Completion

The search target was corrected from “realize the old fixed permutation
completion” to “realize any unitary/permutation completion whose clean block is
`E_1`”.  This is the right block-encoding acceptance predicate because the
non-clean blocks are free completion data.

Current concrete finite champion:

```text
Layer 1: CCX(type,time;aux)
Layer 2: X(type), X(time), X(aux) in parallel
```

Lean bit order:

```text
bit 0 = type
bit 1 = time
bit 2 = auxiliary
```

Compiled declarations:

- `OptimalControl.evolvedEqFlipImage`
- `OptimalControl.evolvedEqFlipImage_isPermutation`
- `OptimalControl.evolvedEqFlipFull_isPermutation`
- `OptimalControl.evolvedEqFlip_cleanBlock`
- `OptimalControl.evolvedEqFlipCost`
- `OptimalControl.evolvedEqFlipCost_gateCount`
- `OptimalControl.evolvedEqFlipCost_betterThan_pro`
- `OptimalControl.evolvedEqFlipCost_betterThan_depth5`
- `OptimalControl.evolvedEqFlipZeroErrorApprox`

Current expanded logical score:

```text
gateCount = 4
depth = 2
auxiliaryQubits = 1
oracleCalls = 0
```

Approximate-status interpretation:

- `OptimalControl.evolvedEqFlipZeroErrorApprox` packages the exact champion as
  a zero-error approximate certificate.
- Therefore Scenario 1 is active for this concrete case: exact search reached
  the required logical score, and approximate search may continue only if it
  finds a strictly cheaper candidate for the user's accepted epsilon.
- No cheaper approximate candidate is currently promoted to the certified
  population.

Scope:

- verified for the concrete `r = 1`, `k = 1`, one-state-bit instance;
- proof is currently finite permutation/function semantics plus clean-block
  equality;
- not yet connected to full gate-matrix semantics;
- not yet generalized to arbitrary time-register width or arbitrary state
  dimension.

Next priority:

1. Generalize `evolvedEqFlipImage` to arbitrary passive state dimension.
2. Determine the right general `r`-bit time construction and resource model:
   mixed-polarity MCX, explicit `X` conjugations, or an equality oracle tier.
3. Add full gate-matrix semantics for `{X,CNOT,Toffoli}` or explicitly keep the
   current finite-permutation witness as a verifier-feedback stage.
4. Reflect or archive the finite lower-bound search showing depth `2` is the
   first clean-block depth for the concrete logical library.

## Agent Notes

Do not mark this task complete unless the Lean build gate passes.

Use trial logging for every substantial attempt:

```bash
python3 tools/qbe.py trial-log --task QBE-OP-OPTCTRL-001 --role lower --kind attempt --status running --notes "starting construction search"
python3 tools/qbe.py trial-summary
```
