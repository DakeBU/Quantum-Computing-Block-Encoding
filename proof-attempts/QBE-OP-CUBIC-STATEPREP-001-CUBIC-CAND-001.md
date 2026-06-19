# CUBIC-CAND-001 Proof Architecture And Shape Audit

Task: `QBE-OP-CUBIC-STATEPREP-001`
Leaf: `CUBIC-CAND-001`
Mode: exploratory construction
Author role: lower natural-language proof architect
Updated: `2026-06-19 14:49:50 JST`
Status: candidate interface audited; proof route blocked by a register-shape
obligation before Lean theorem closure.

## Source Fragment

There is no paper-source theorem for this task.  The source fragment is the
user/task operator equation

$$
N = 2^n,\qquad x_j = j/N,\qquad v_n[j] = x_j^3.
$$

The Lean-checkable target is the rank-one operator

$$
O_n = |v_n><0^n|,\qquad v_n[j] = (j/2^n)^3.
$$

A candidate approximate block encoding must prove

$$
\|O_n -
\alpha_n ((<0^a| \otimes I) U_n (|0^a> \otimes I))\|
\le \epsilon,
$$

where `epsilon = CubicStatePreparation.requestedEpsilon`.  The clean block
must therefore have first column `v_n / alpha_n` and all other columns zero.

## Definitions

Fix `n : Nat`, precision `p : Nat`, and `N = gridSize n`.  The current compiled
candidate interface is:

- `arithmeticCubicLayout n p`, with one signal qubit and
  `3*n + p + 2` pure arithmetic ancillas;
- `arithmeticCubicCircuit n p`, an oracle-label transcript for loading
  `j/2^n`, squaring, multiplying by `x`, applying an amplitude-transduction
  rotation, and uncomputing;
- `arithmeticCubicNormalizer n = conservativeNormalizer n`;
- `arithmeticCubicResourceTuple n p`, the unexpanded-oracle score;
- `arithmeticCubicClaim`, the human-facing candidate record.

These declarations seed a candidate route, but they do not yet define a
semantic matrix `U_n` or a clean-block extraction expression.

For a correct rank-one arithmetic route, the semantic clean block

$$
B_n = (<0^a| \otimes I) U_n (|0^a> \otimes I)
$$

must satisfy the following two register-level conditions:

1. For input column `0`,

   $$
   |B_n[j,0] - v_n[j]/\alpha_n| \le \delta_n
   $$

   for every output row `j`.

2. For every input column `c != 0`,

   $$
   B_n[j,c] = 0
   $$

   for every output row `j`, or an explicit leakage budget must be added.

The compiled transcript currently describes value computation for an existing
index.  By itself, that shape is compatible with a diagonal amplitude oracle,
not with the rank-one first-column map above.

## Natural-Language Proof Of The Active Local Theorem

The local theorem that a Lean worker should eventually prove is conditional:
if a candidate semantic block `B_n` satisfies the two register-level
conditions above and the entry budget

$$
\alpha_n\sqrt{N}\,\delta_n \le \epsilon,
$$

then `alpha_n * B_n` approximates `O_n`.

For column `0`, condition 1 gives

$$
|O_n[j,0] - \alpha_n B_n[j,0]|
  = |v_n[j] - \alpha_n B_n[j,0]|
  \le \alpha_n\delta_n.
$$

For every column `c != 0`, `cubicOperator_only_first_column` gives
`O_n[j,c] = 0`, and condition 2 gives `B_n[j,c] = 0`.  Thus the error matrix
has support only in its first column.  Its first-column Euclidean norm is at
most `alpha_n * sqrt N * delta_n`, so the operator norm is bounded by the same
quantity.  The entry budget then proves the requested `epsilon` inequality.

This proof uses the unnormalized rank-one target exactly.  It does not claim
that `v_n` is a normalized output state.

## Register-Shape Audit

The current `arithmeticCubicCircuit` labels are sufficient only for the middle
portion of an arithmetic amplitude oracle:

```text
load j/2^n -> square -> multiply by x -> amplitude transduction -> uncompute
```

That middle portion assumes a row/index value `j` is already present in the
system register.  A direct semantics for this transcript would naturally prove
a diagonal or value-oracle statement, such as "when the input basis is `|j>`,
the clean amplitude is proportional to `(j/2^n)^3`."  That is not the task
target.  The task target requires a rank-one operator: only input column
`0^n` may contribute, and it must contribute all output rows `j`.

Therefore `CUBIC-CAND-001` needs an additional rank-one wrapper before a
block-entry theorem is attempted.  The wrapper must include:

- a zero-input test that sends every input column `c != 0` to a non-clean
  signal branch, or otherwise proves a leakage budget;
- a row-generation step on the `c = 0` branch, such as a state-preparation
  seed or a uniform row seed plus amplitude transduction;
- a proof that the clean branch after arithmetic/uncomputation has amplitude
  `v_n[j] / alpha_n` for row `j`;
- an updated resource tuple that includes the zero-test and row-generation
  costs or records them as explicit oracle calls.

Without this wrapper, a Lean theorem about the compiled transcript would prove
a different operator shape from `O_n = |v_n><0^n|`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Rank-one target entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_first_column`, `cubicOperator_only_first_column` | conversion window | `python3 tools/qbe.py check` | proved |
| CUBIC-CAND-IFACE-001 | Candidate layout, oracle-label transcript, normalizer, and resource tuple. | CUBIC-TGT-001 | lower Lean worker | `arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`, `arithmeticCubicResourceTuple`, `arithmeticCubicClaim` | candidate population | `python3 tools/qbe.py check` | compiled interface |
| CUBIC-CAND-SHAPE-001 | Prove or repair that the candidate targets a rank-one first-column block, not a diagonal amplitude oracle. | CUBIC-CAND-IFACE-001, CUBIC-TGT-001 | lower architect then Lean worker | `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`, `rankOneCleanBlockContract_pointwise_eq`, `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | this file and `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md` | `python3 tools/qbe.py check` | wrapper interface and target-shape bridge compiled; semantic proof open |
| CUBIC-ZERO-001 | Zero-input test sends all `c != 0` columns out of the clean signal branch. | CUBIC-CAND-SHAPE-001 | lower Lean worker | planned zero-test semantic lemma | this file | `lake build && lake build Tests` | open |
| CUBIC-ROWGEN-001 | Row-generation branch creates the candidate row index `j` from input column `0`. | CUBIC-CAND-SHAPE-001 | lower architect/Lean later | planned row-generation contract | this file | `lake build && lake build Tests` | open |
| CUBIC-AMP-001 | Arithmetic/transduction produces entry amplitude `v_n[j] / alpha_n` within the chosen entry budget. | CUBIC-ROWGEN-001, CUBIC-ALPHA-001, arithmetic contracts | lower Lean later | planned amplitude theorem | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` | `lake build && lake build Tests` | blocked internal |
| CUBIC-ERR-ENTRY-001 | Entrywise first-column error plus zero off-columns implies operator approximation. | CUBIC-ZERO-001, CUBIC-AMP-001 | lower Lean later | planned theorem | this file and CUBIC-ERR-001 note | `lake build && lake build Tests` | designed, open |
| CUBIC-VER-CAND-001 | Finite verifier instantiates the repaired wrapper or Hadamard-counting route for small `n`. | CUBIC-CAND-SHAPE-001 | verifier lower | planned refreshed verifier-feedback packet | verifier-feedback directory | `python3 tools/qbe.py check` plus finite script | active after a concrete semantic matrix is chosen |

The rank-one wrapper and clean-block contract bridge for `CUBIC-CAND-SHAPE-001`
are now compiled.  The next active leaf is semantic: instantiate a finite
matrix/contract for either the wrapped arithmetic labels or the
Hadamard-counting route, then run the small clean-block verifier before any
large block-entry proof search.

## Intermediate Lean Lemmas In Dependency Order

1. Reuse `gridSize`, `gridPoint`, `cubicAmplitude`, `cubicOperator`,
   `cubicOperator_first_column`, `cubicOperator_only_first_column`,
   `conservativeNormalizer`, `arithmeticCubicLayout`,
   `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`,
   `arithmeticCubicResource`, `arithmeticCubicResource_eq`,
   `arithmeticCubicLayout_auxiliaryQubits`, and
   `arithmeticCubicResourceTuple`.

2. Reuse the compiled wrapper declarations
   `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`,
   `arithmeticRankOneCubicResourceTuple`, and `arithmeticRankOneCubicClaim`.

3. Reuse `rankOneCleanBlockContract` and
   `rankOneCleanBlockContract_pointwise_eq` as the clean projector/target-shape
   bridge.  The semantic proof must still show that the candidate clean block
   satisfies this contract.

4. Add `arithmeticRankOne_zero_nonfirst_columns`, proving that any input column
   `c != 0` has zero clean-block amplitude.

5. Add `arithmeticRankOne_first_column_entry`, stating the first-column entry
   relation or approximation budget for each row `j`.

6. Reuse the error-budget proof design from
   `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` to prove
   `firstColumn_entry_error_to_operator_error`.

7. Update the resource theorem so the tuple includes the zero-test and
   row-generation wrapper, not only the seven arithmetic oracle labels.

8. Only after items 3 through 7 compile should a worker package an
   `ApproximateOperatorBlockEncodingCandidate` or
   `VerifiedApproximateOperatorBlockEncoding`.

## Failure Analysis

The user target is mathematically consistent.  The current risk is a
shape/register gap in the candidate route, not a norm theorem failure.

The compiled arithmetic declarations are useful as a middle arithmetic block,
but they do not yet determine a `U_n` whose clean block is rank-one.  Proving a
block theorem directly from the current labels would likely certify a diagonal
function-amplitude oracle or an underspecified semantic obligation.  That
would be target drift.

The route should not be retired.  It should be repaired by wrapping the cubic
amplitude-transduction middle block with a zero-input filter and row-generation
subroutine, or by explicitly choosing the dense rank-one completion as a
separate baseline candidate.  The operator target, requested epsilon, and
unnormalized vector interpretation must remain unchanged.

## Typed Verifier Feedback

| Field | Value |
| --- | --- |
| `leaf` | `CUBIC-CAND-001` |
| `source_correspondence_ok` | `false` for the current candidate transcript as a full rank-one block; `true` for the task target |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `null` |
| `block_entry_ok` | `false` until the rank-one wrapper is specified |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `designed as conservativeNormalizer; proof open` |
| `unitarity_ok` | `null` |
| `resource_score` | `compiled unexpanded-oracle tuple omits rank-one wrapper cost` |
| `auxiliary_qubits` | `1 + (3*n + precision + 2)` before wrapper repair |
| `gate_count` | `7` unresolved oracle calls at the current transcript tier |
| `depth` | `7` at the current transcript tier |
| `oracle_calls` | `7` before wrapper repair |
| `closed_theorem_ok` | `false` |
| `error_class` | `shape_or_register_gap` |
| `next_route` | `Repair CUBIC-CAND-001 by adding zero-input filtering and row-generation wrapper declarations, then refresh CUBIC-VER-CAND-001 on n = 1 or n = 2 before attempting a symbolic clean-block theorem.` |
