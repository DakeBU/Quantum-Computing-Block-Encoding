# Lower Proof Architect Packet: Ortho Bridge

Task: `QBE-MAIN-CASE-HIER-PRO-001`  
Leaf: `MAINCASE-PRO-ORTHO-BRIDGE-001`  
Run: `20260625-234024-QBE-MAIN-CASE-HIER-PRO-001-cycle02`  
Role: lower natural-language proof architect

## Source Fragment

No local paper-source archive was detected for this task.  The source fragment
being translated is therefore the task packet plus the external Pro packet:

$$
E_1 =
|0><1|_T \otimes |0><1|_{\tau} \otimes I_S,
$$

with clean-block contract

$$
(\langle 0|_a \otimes I) U (|0\rangle_a \otimes I) = E_1.
$$

The Pro packet supplies the four-gate transcript
`CCX012; CX21; CX20; X2`.  Cycle 1 already split this transcript from
`mainCaseProCandidateImage`: the two full images differ on dirty columns
`8`, `9`, `12`, and `13`, while both compiled clean-block proofs preserve the
same target.  The active fragment for this packet is not a new circuit proof.
It is the matrix-level bridge:

$$
U_{r,c} =
\begin{cases}
1, & r = p(c),\\
0, & r \ne p(c),
\end{cases}
\qquad
p \colon \mathrm{Fin}(n) \to \mathrm{Fin}(n)
\text{ bijective}.
$$

The theorem to expose to Lean is that this `permMatrix p` has identity column
and row Gram matrices over `Rat`.

## Definitions

For fixed `n`, let `p : Fin n -> Fin n`.  Reuse
`BlockEncodingClassics.permMatrix`, defined by
`permMatrix p row col = if row = p col then 1 else 0`.

Define or promote the project-local Gram predicates now sitting in
`OptimalControl.lean`:

```lean
def columnInner {n : Nat} (U : Matrix n n Rat) (i j : Fin n) : Rat :=
  (List.finRange n).foldl (fun acc k => acc + U k i * U k j) 0

def rowInner {n : Nat} (U : Matrix n n Rat) (i j : Fin n) : Rat :=
  (List.finRange n).foldl (fun acc k => acc + U i k * U j k) 0

def IsRationalOrthogonal {n : Nat} (U : Matrix n n Rat) : Prop :=
  (∀ i j : Fin n, columnInner U i j = Matrix.identity n Rat i j) ∧
    (∀ i j : Fin n, rowInner U i j = Matrix.identity n Rat i j)
```

These definitions should live in `BlockEncodingClassics.lean` or another shared
matrix-semantics file before `MainCase.lean` uses them.  `OptimalControl.lean`
is a precedent for the shape, not a certificate for this isolated task.

## Local Proof

Claim.  If `p` is injective and surjective, then
`BlockEncodingClassics.permMatrix p` is rational orthogonal.

Column proof.  Fix columns `i` and `j`.  The `k`th term of the column Gram sum
is

$$
U_{k,i} U_{k,j}
=
\mathbf{1}_{k=p(i)} \mathbf{1}_{k=p(j)}.
$$

If `i = j`, then `k = p(i)` is the unique nonzero term in `List.finRange n`,
so the sum is `1`, matching `Matrix.identity n Rat i i`.

If `i != j`, injectivity gives `p i != p j`.  No `k` can satisfy both
`k = p i` and `k = p j`, so every product in the sum is `0`.  The sum is `0`,
matching `Matrix.identity n Rat i j`.

Row proof.  Fix rows `i` and `j`.  The `k`th term of the row Gram sum is

$$
U_{i,k} U_{j,k}
=
\mathbf{1}_{i=p(k)} \mathbf{1}_{j=p(k)}.
$$

If `i != j`, no `k` can satisfy both equations, so every term is `0`.

If `i = j`, surjectivity gives a column `k0` with `p k0 = i`.  Injectivity
makes this preimage unique.  The `k0` term contributes `1`, and every other
term contributes `0`, so the sum is `1`.

This proves both Gram identities.  Applied to
`mainCaseProCircuitImage_permutation_certificate`, the result gives the
matrix-level rational orthogonality of `mainCaseProCircuitMatrix`.  Applied to
`mainCaseProCandidateImage_permutation_certificate`, it gives the same bridge
for `mainCaseProCandidateMatrix`.  The Pro circuit candidate should be the
first Lean target because it aligns with the exported transcript.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `ORTHO-DEFS-001` | Shared rational Gram definitions: `columnInner`, `rowInner`, `IsRationalOrthogonal`. | existing `Matrix`, `List.finRange`, `Rat` backend | lower 2/refiner | preferred `BlockEncodingClassics.columnInner`, `BlockEncodingClassics.rowInner`, `BlockEncodingClassics.IsRationalOrthogonal` | this packet | `python3 tools/qbe.py check` | active prerequisite |
| `ORTHO-FOLD-UNIQUE-001` | Fold over `List.finRange n` collapses when exactly one term is nonzero. | `List.finRange`, `Nodup`, rational arithmetic; existing private fold lemmas in `BlockEncodingClassics.lean` may be promoted | lower 2/refiner | preferred reusable finite-sum lemma in `BlockEncodingClassics` | this packet | `python3 tools/qbe.py check` | active prerequisite for shared theorem |
| `ORTHO-COLUMN-001` | For injective `p`, column Gram of `permMatrix p` equals identity. | `ORTHO-DEFS-001`, `ORTHO-FOLD-UNIQUE-001`, `BlockEncodingClassics.permMatrix` | lower 2 | `BlockEncodingClassics.permMatrix_columnInner_eq_identity_of_injective` | this packet | `python3 tools/qbe.py check` | next active shared leaf if fold lemma is ready |
| `ORTHO-ROW-001` | For bijective `p`, row Gram of `permMatrix p` equals identity. | `ORTHO-DEFS-001`, `ORTHO-FOLD-UNIQUE-001`, injective and surjective parts of the certificate | lower 2 | `BlockEncodingClassics.permMatrix_rowInner_eq_identity_of_bijective` | this packet | `python3 tools/qbe.py check` | after `ORTHO-COLUMN-001` |
| `ORTHO-BRIDGE-001` | Package column and row Gram identities as rational orthogonality. | `ORTHO-COLUMN-001`, `ORTHO-ROW-001` | lower 2 | `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective` | this packet | `python3 tools/qbe.py check` | target bridge |
| `MAINCASE-PRO-CIRCUIT-ORTHO-001` | Instantiate the shared bridge for the Pro transcript candidate. | `ORTHO-BRIDGE-001`, `mainCaseProCircuitImage_permutation_certificate`, `mainCaseProCircuitMatrix` | lower 2 | `mainCaseProCircuitMatrix_isRationalOrthogonal` | this packet | `python3 tools/qbe.py check`; then `lake build && lake build Tests` | next active task-local leaf |
| `MAINCASE-PRO-CANDIDATE-ORTHO-001` | Optional second instantiation for the finite-permutation incumbent. | `ORTHO-BRIDGE-001`, `mainCaseProCandidateImage_permutation_certificate`, `mainCaseProCandidateMatrix` | lower 2 | `mainCaseProCandidateMatrix_isRationalOrthogonal` | this packet | `python3 tools/qbe.py check`; then `lake build && lake build Tests` | optional after circuit theorem |
| `MAINCASE-PRO-EXPORT-001` | Qiskit/QASM3 export packet. | accepted semantic tier, block theorem, cost theorem, register map | export worker | none yet | export ledger later | export check plus project gates | blocked |

The next active Lean leaf should be `MAINCASE-PRO-CIRCUIT-ORTHO-001` if the
shared bridge closes, or a finite task-local fallback theorem by
`native_decide` if the generic fold proof is too broad for this cycle.

## Ordered Lean Lemmas

1. Reuse `BlockEncodingClassics.permMatrix`.
2. Promote or define shared `BlockEncodingClassics.columnInner`,
   `BlockEncodingClassics.rowInner`, and
   `BlockEncodingClassics.IsRationalOrthogonal`; update `OptimalControl.lean`
   to reference the shared names later if needed.
3. Promote a reusable finite fold lemma from the private helpers already in
   `BlockEncodingClassics.lean`, or add a narrower public lemma for sums with
   one nonzero entry over `List.finRange n`.
4. Prove
   `BlockEncodingClassics.permMatrix_columnInner_eq_identity_of_injective`.
   Use `Function.Injective p` to separate `p i` and `p j` for `i != j`.
5. Prove
   `BlockEncodingClassics.permMatrix_rowInner_eq_identity_of_bijective`.
   Use surjectivity for row diagonal existence and injectivity for uniqueness.
6. Prove
   `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`.
7. Instantiate first for `mainCaseProCircuitMatrix` using
   `mainCaseProCircuitImage_permutation_certificate`.
8. Instantiate second for `mainCaseProCandidateMatrix` using
   `mainCaseProCandidateImage_permutation_certificate` only if the first
   instantiation is already trivial.

Fallback for one narrow Lean attempt:

```lean
theorem mainCaseProCircuitMatrix_isRationalOrthogonal :
    BlockEncodingClassics.IsRationalOrthogonal mainCaseProCircuitMatrix := by
  unfold BlockEncodingClassics.IsRationalOrthogonal
    BlockEncodingClassics.columnInner BlockEncodingClassics.rowInner
    mainCaseProCircuitMatrix BlockEncodingClassics.permMatrix
    mainCaseProCircuitImage mainCaseProLiftReducedImage
    mainCaseProReducedOfFull mainCaseProStateOfFull
    mainCaseProCircuitReducedImage mainCaseProRedX2
    mainCaseProRedCX20 mainCaseProRedCX21 mainCaseProRedCCX012
  native_decide
```

Use this fallback only if the shared theorem cannot be closed quickly.  Keep
`mainCaseProRationalOrthogonalBridgeObligation.proved = false` unless a named
Lean theorem closes the bridge.

## Failure Analysis

The active target is mathematically sound.  A bijective permutation matrix has
orthonormal rows and columns over `Rat` because every row and column contains
exactly one `1` and all other entries are `0`.

The current gap is a symbolic bridge gap, not a source mismatch.  The false
route `mainCaseProCircuitImage_eq_candidate` is already retired.  The row Gram
proof should not be described as using surjectivity alone: row diagonal entries
need surjective existence and injective uniqueness.  This matters for a generic
Lean theorem.

Do not change `mainCaseProTarget`, `mainCaseProSignalIndex`,
`mainCaseProExactNormalizer`, either candidate image, or the score
`(4,4,1,0)`.  Do not import an `OptimalControl` theorem as the isolated task's
certificate.

## Typed Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-ORTHO-BRIDGE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `not_applicable_no_lean_edit` |
| `lean_build_ok` | `true`; gates passed after Markdown-only edit |
| `finite_matrix_ok` | `true` from existing permutation and clean-block declarations |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `true` for the rational-orthogonality bridge after the named Lean theorems below compiled |
| `resource_score` | `(4,4,1,0)` |
| `gate_count` | `4` |
| `depth` | `4` |
| `auxiliary_qubits` | `1` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `true` |
| `error_class` | `none` |
| `next_route` | Reviewer should audit the accepted semantic tier before Qiskit/QASM3 export. |

## Handoff

Lower 2 should implement exactly one theorem.  Prefer the shared
`permMatrix` rational-orthogonality bridge; if the generic finite-sum route
expands too far, close the task-local Pro transcript theorem first.  Exports
remain blocked until reviewer names the accepted semantic tier.

Gates passed after this Markdown-only proof design:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

## Postscript After Lean Bridge Repair

During the final gate, a concurrent Lean implementation of the shared bridge
failed in the off-diagonal column Gram branch.  The local repair was to expose
the unfolded product of permutation-matrix entries and simplify with the
already available inequality `p i != p j`.

The active bridge is now backed by these compiled declarations:

- `BlockEncodingClassics.columnInner`
- `BlockEncodingClassics.rowInner`
- `BlockEncodingClassics.IsRationalOrthogonal`
- `BlockEncodingClassics.permMatrix_columnInner_of_injective`
- `BlockEncodingClassics.permMatrix_rowInner_of_bijective`
- `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`
- `mainCaseProCandidateMatrix_isRationalOrthogonal`
- `mainCaseProCircuitMatrix_isRationalOrthogonal`

The target operator, clean signal, normalizer, candidate images, and resource
tuple were not changed.  Executable export remains a reviewer/export-worker
decision, not part of this lower proof packet.
