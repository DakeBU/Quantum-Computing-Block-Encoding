# Lower Proof Packet: QBE-MAIN-CASE-HIER-PRO-001

Active leaf: `MAINCASE-PRO-ORTHO-BRIDGE-001`

Role: lower natural-language proof architect

## Source Fragment

No local paper-source archive was detected for this task.  The source anchor is
the task packet and conversion window for the fixed operator

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The already compiled clean-block contract is

$$
(\langle 0| \otimes I) U (|0\rangle \otimes I) = E_1,
$$

with one clean signal qubit, normalizer $\alpha = 1$, exact error
$\epsilon = 0$, and system order `(T,tau,S)`.  The active local fragment is the
unitarity upgrade for the task-local permutation matrix
`mainCaseProCandidateMatrix`.  In reusable notation, for a finite map
$p : \mathrm{Fin}\ n \to \mathrm{Fin}\ n$ define

$$
U_{r,c} =
\begin{cases}
1, & r = p(c),\\
0, & r \ne p(c).
\end{cases}
$$

The leaf should prove the rational orthogonality equations

$$
\sum_k U_{k,i} U_{k,j} = \delta_{i,j}
\quad\text{and}\quad
\sum_k U_{i,k} U_{j,k} = \delta_{i,j}.
$$

These equations are the project-local real finite-matrix proxy for
$U^T U = I$ and $U U^T = I$.

## Definitions For The Local Theorem

Use the existing declaration `BlockEncodingClassics.permMatrix`:

```lean
def BlockEncodingClassics.permMatrix {n : Nat} (p : Fin n -> Fin n) :
    Matrix n n Rat :=
  fun row col => if row = p col then 1 else 0
```

The older orthogonality interface is currently local to
`QuantumBlockEncoding.OptimalControl`:

```lean
def columnInner {n : Nat} (U : Matrix n n Rat) (i j : Fin n) : Rat :=
  (List.finRange n).foldl (fun acc k => acc + U k i * U k j) 0

def rowInner {n : Nat} (U : Matrix n n Rat) (i j : Fin n) : Rat :=
  (List.finRange n).foldl (fun acc k => acc + U i k * U j k) 0

def IsRationalOrthogonal {n : Nat} (U : Matrix n n Rat) : Prop :=
  (forall i j : Fin n, columnInner U i j = Matrix.identity n Rat i j) ∧
    (forall i j : Fin n, rowInner U i j = Matrix.identity n Rat i j)
```

The Lean worker should promote this interface, or an equivalent shared version,
to `BlockEncodingClassics.lean` instead of importing old `OptimalControl`
candidate proofs into the Pro-isolated task.  The proof should reuse
`mainCaseProCandidateImage_permutation_certificate` only for the task-local
instantiation.

## Natural-Language Proof

Let $p : \mathrm{Fin}\ n \to \mathrm{Fin}\ n$ be bijective, and let
$U = \mathrm{permMatrix}\ p$.

For the column Gram equation, fix columns $i$ and $j$.  The summand indexed by
$k$ is nonzero only when $k = p(i)$ and $k = p(j)$.

If $i = j$, the unique nonzero summand occurs at $k = p(i)$ and has value
$1 \cdot 1 = 1$.  Every other $k$ gives zero because at least one Kronecker
condition fails.  The fold over `List.finRange n` is therefore $1$, matching
`Matrix.identity n Rat i i`.

If $i \ne j$, injectivity gives $p(i) \ne p(j)$.  No index $k$ can satisfy both
$k = p(i)$ and $k = p(j)$.  Every summand is zero, so the fold is $0$, matching
`Matrix.identity n Rat i j`.

For the row Gram equation, fix rows $i$ and $j$.  The summand indexed by $k$ is
nonzero only when $i = p(k)$ and $j = p(k)$.

If $i = j$, surjectivity gives a witness $w$ with $p(w) = i$.  Injectivity makes
that witness unique: if $p(k) = i = p(w)$, then $k = w$.  The fold has exactly
one nonzero summand, at $w$, with value $1$.

If $i \ne j$, no index $k$ can satisfy both $i = p(k)$ and $j = p(k)$.  Every
summand is zero, and the fold is $0$.

Together these two equations prove that `permMatrix p` is rational orthogonal.
Instantiating $p$ with `mainCaseProCandidateImage` and the compiled certificate
`mainCaseProCandidateImage_permutation_certificate` proves the task-local
bridge for `mainCaseProCandidateMatrix`.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAINCASE-PRO-ORTHO-PRED-001` | Shared definitions of `columnInner`, `rowInner`, and `IsRationalOrthogonal` for project-local rational matrices. | existing `Matrix.identity`, `List.finRange` fold convention | lower 2/refiner | suggested `BlockEncodingClassics.columnInner`, `BlockEncodingClassics.rowInner`, `BlockEncodingClassics.IsRationalOrthogonal` | this packet | `python3 tools/qbe.py check` | blocked internal |
| `MAINCASE-PRO-PERMMATRIX-COL-001` | If `p` is injective, columns of `permMatrix p` have identity Gram entries. | `MAINCASE-PRO-ORTHO-PRED-001`, `BlockEncodingClassics.permMatrix`, private fold lemmas in `BlockEncodingClassics.lean` | lower 2 | suggested `BlockEncodingClassics.permMatrix_columnInner` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `MAINCASE-PRO-PERMMATRIX-ROW-001` | If `p` is bijective, rows of `permMatrix p` have identity Gram entries. | `MAINCASE-PRO-PERMMATRIX-COL-001` only for shared notation; mathematically uses injective and surjective parts | lower 2 | suggested `BlockEncodingClassics.permMatrix_rowInner` | this packet | `python3 tools/qbe.py check` | open |
| `MAINCASE-PRO-ORTHO-GENERIC-001` | Package the column and row Gram equations into rational orthogonality for any bijective finite image. | `MAINCASE-PRO-PERMMATRIX-COL-001`, `MAINCASE-PRO-PERMMATRIX-ROW-001` | lower 2/refiner | suggested `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective` | this packet | `python3 tools/qbe.py check` | open |
| `MAINCASE-PRO-ORTHO-TASK-001` | Instantiate the generic theorem for `mainCaseProCandidateImage`. | `MAINCASE-PRO-ORTHO-GENERIC-001`, `mainCaseProCandidateImage_permutation_certificate` | lower 2 | suggested `mainCaseProCandidateMatrix_isRationalOrthogonal` | conversion window plus this packet | `python3 tools/qbe.py check` | open |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Close or retire `mainCaseProRationalOrthogonalBridgeObligation`. | `MAINCASE-PRO-ORTHO-TASK-001` | middle/reviewer | `mainCaseProRationalOrthogonalBridgeObligation` should no longer be the only record | proof-obligations ledger | `lake build && lake build Tests` | open |

The next active Lean leaf is `MAINCASE-PRO-PERMMATRIX-COL-001`.  It is small
enough for one Lean worker because it only needs the column fold and injectivity.

## Intermediate Lean Lemmas

1. `BlockEncodingClassics.columnInner`

   Reuse the formula from `OptimalControl.columnInner`, but place the shared
   declaration in `BlockEncodingClassics.lean` or another shared file imported
   by both `OptimalControl.lean` and `MainCase.lean`.

2. `BlockEncodingClassics.rowInner`

   Reuse the formula from `OptimalControl.rowInner`.

3. `BlockEncodingClassics.IsRationalOrthogonal`

   Reuse the formula from `OptimalControl.IsRationalOrthogonal`.  This avoids
   importing task-specific old candidates into the Pro-isolated file.

4. `BlockEncodingClassics.permMatrix_columnInner`

   Suggested statement:

   ```lean
   theorem permMatrix_columnInner {n : Nat} (p : Fin n -> Fin n)
       (hp : Function.Injective p) :
       forall i j : Fin n,
         columnInner (permMatrix p) i j = Matrix.identity n Rat i j
   ```

   Reuse `permMatrix`, `foldlRat_add_unique_of_nodup`,
   `foldlRat_add_zero_of_all_zero`, `finRangeNodup`, and
   `List.mem_finRange`.  This theorem should be implemented in
   `BlockEncodingClassics.lean` so the existing private fold lemmas remain
   available.

5. `BlockEncodingClassics.permMatrix_rowInner`

   Suggested statement:

   ```lean
   theorem permMatrix_rowInner {n : Nat} (p : Fin n -> Fin n)
       (hinj : Function.Injective p) (hsurj : Function.Surjective p) :
       forall i j : Fin n,
         rowInner (permMatrix p) i j = Matrix.identity n Rat i j
   ```

   Use surjectivity only in the diagonal row case, to choose the unique witness
   column.

6. `BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective`

   Suggested statement:

   ```lean
   theorem permMatrix_isRationalOrthogonal_of_bijective {n : Nat}
       (p : Fin n -> Fin n)
       (hinj : Function.Injective p) (hsurj : Function.Surjective p) :
       IsRationalOrthogonal (permMatrix p)
   ```

   The proof is the pair of the preceding two lemmas.

7. `mainCaseProCandidateMatrix_isRationalOrthogonal`

   Suggested task-local statement:

   ```lean
   theorem mainCaseProCandidateMatrix_isRationalOrthogonal :
       BlockEncodingClassics.IsRationalOrthogonal mainCaseProCandidateMatrix
   ```

   Reuse `mainCaseProCandidateMatrix`,
   `mainCaseProCandidateImage_permutation_certificate`,
   `mainCaseProCandidateImage_injective`, and
   `mainCaseProCandidateImage_surjective`.

## Failure Analysis

The current target is mathematically coherent.  The mismatch is semantic, not a
counterexample: `mainCaseProVerified` currently takes
`mainCaseProCandidateImageIsPermutation` as its `isUnitary` proposition, while
older `OptimalControl` candidates use rational orthogonality of the matrix.
That is why `mainCaseProRationalOrthogonalBridgeObligation` remains open even
though the finite permutation and clean block already compile.

No new assumption is needed.  The route should not change
`mainCaseProTarget`, `mainCaseProSignalIndex`, `mainCaseProCandidateImage`, or
the resource tuple.  The route should also not import
`OptimalControl.proEqTransferUnitary_isRationalOrthogonal` as a certificate for
this task, because the Pro-isolated task requires task-local promotion.

## Typed Verifier Feedback

| Field | Value |
|---|---|
| `leaf` | `MAINCASE-PRO-ORTHO-BRIDGE-001` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `null` |
| `lean_build_ok` | `null` |
| `finite_matrix_ok` | `true` |
| `block_entry_ok` | `true` |
| `ancilla_cleanup_ok` | `true` |
| `normalizer_ok` | `true` |
| `unitarity_ok` | `false` for rational orthogonality; `true` for finite bijection tier |
| `resource_score` | `(4,4,1,0)` |
| `auxiliary_qubits` | `1` |
| `gate_count` | `4` |
| `depth` | `4` |
| `oracle_calls` | `0` |
| `closed_theorem_ok` | `false` |
| `error_class` | `symbolic_bridge_gap` |
| `next_route` | `Prove public column Gram theorem for injective permMatrix in BlockEncodingClassics.lean, then row Gram theorem using surjectivity.` |
