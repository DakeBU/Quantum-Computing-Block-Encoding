# Lower Architect Packet: MAIN-PERM-UNITARY-001

Task: `QBE-MAIN-CASE-HIER-COLD-001`

Leaf: `MAIN-PERM-UNITARY-001`

Mode: exploratory construction, exact phase.

Status after local sync: the finite-bijection part of this leaf is already
implemented in `QuantumBlockEncoding/MainCase.lean` as
`mainCaseColdPartialPermImage_bijective`.  This packet records the proof design
and current proof-map status, then routes the next worker to the remaining
matrix-unitary bridge only if that stronger semantic tier is required.  Resource
and export work remain blocked until their own named certificates compile.

## Source Fragment

No local paper TeX archive is available for this task.  The source anchor for
this leaf is the task-owned operator line

```text
main case transfer operator E_k := |0><k|_time tensor |0><1|_type tensor I
```

specialized to `r = 1`, `k = 1`, and one passive `S` qubit:

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The already compiled clean-block theorem is
`mainCaseColdPartialPerm_clean_eq_target`.  This packet does not change that
target.  The finite permutation evidence for the same COLD candidate image
table is now compiled as `mainCaseColdPartialPermImage_bijective`.

## Definitions

The system basis is ordered as `(T,tau,S)`, with
`mainCaseColdSystemIndex T tau S = 4*T + 2*tau + S`.  The clean signal qubit is
`mainCaseColdCleanSignal = 0`, and the total flattened basis index is
`8*signal + mainCaseColdSystemIndex T tau S`.

The target matrix `mainCaseColdTarget` has value `1` exactly at system
row-column pairs `(0,6)` and `(1,7)`, and value `0` elsewhere.  These two
columns are the passive-register cases of
`(T,tau) = (1,1)` mapping to `(T,tau) = (0,0)`.

The COLD candidate image `p = mainCaseColdPartialPermImage` is the finite table

```text
0 -> 14, 1 -> 15, 2 -> 8, 3 -> 9,
4 -> 10, 5 -> 11, 6 -> 0, 7 -> 1,
8 -> 2, 9 -> 3, 10 -> 4, 11 -> 5,
12 -> 6, 13 -> 7, 14 -> 12, 15 -> 13.
```

For the unitarity leaf, define the inverse table `q` by

```text
0 -> 6, 1 -> 7, 2 -> 8, 3 -> 9,
4 -> 10, 5 -> 11, 6 -> 12, 7 -> 13,
8 -> 2, 9 -> 3, 10 -> 4, 11 -> 5,
12 -> 14, 13 -> 15, 14 -> 0, 15 -> 1.
```

Lean now contains this table as
`mainCaseColdPartialPermPreimage : Fin 16 -> Fin 16`.

## Active Local Theorem

The local theorem is that `p` is a bijection of `Fin 16`.  The compiled
Lean-facing statement is:

```lean
theorem mainCaseColdPartialPermImage_bijective :
    Function.Injective mainCaseColdPartialPermImage ∧
      Function.Surjective mainCaseColdPartialPermImage
```

The implementation names the predicate first:

```lean
def mainCaseColdPartialPermImageIsPermutation : Prop :=
  Function.Injective mainCaseColdPartialPermImage ∧
    Function.Surjective mainCaseColdPartialPermImage
```

and proves `mainCaseColdPartialPermImage_bijective :
mainCaseColdPartialPermImageIsPermutation`.

## Natural-Language Proof

First prove that `q` is a right inverse of `p`.  For each output index
`y : Fin 16`, the table for `q` selects the unique input listed above as the
preimage of `y`.  Substituting each of the sixteen cases into the table for
`p` gives

$$
p(q(y)) = y.
$$

This closes surjectivity: for any `y`, choose `x = q(y)`, and the right-inverse
identity supplies `p(x) = y`.

Second prove injectivity.  The shortest Lean route is either an exhaustive
finite proof,

```lean
theorem mainCaseColdPartialPermImage_injective_pointwise :
    forall x y : Fin 16,
      mainCaseColdPartialPermImage x = mainCaseColdPartialPermImage y -> x = y
```

or a second inverse-table lemma

$$
q(p(x)) = x.
$$

If the worker proves the left-inverse lemma, then for
`mainCaseColdPartialPermImage x = mainCaseColdPartialPermImage y`, applying
`mainCaseColdPartialPermPreimage` to both sides gives `q(p(x)) = q(p(y))`.
The left-inverse lemma rewrites this to `x = y`.

The combined injective and surjective certificate proves that the finite image
table is a permutation.  Since `mainCaseColdPartialPermMatrix` is
`BlockEncodingClassics.permMatrix p`, this is the unitarity evidence at the
current finite-permutation semantic tier.  It should feed the later COLD
candidate record through its `isUnitary` field.  It does not by itself prove a
stronger rational-orthogonality predicate unless a separate generic bridge from
bijective finite images to rational orthogonal permutation matrices is named
and proved.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Define `E_1`, register order, clean signal, normalizer, and exact error. | task packet | previous lower 2 | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CAND-IMAGE-001` | Define COLD finite image table and permutation matrix. | `MAIN-SOURCE-001` | previous lower 2 | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-CLEAN-ENTRY-001` | Clean block equals `mainCaseColdTarget`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | previous lower 2 | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | conversion window | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001A` | Define inverse table for the COLD finite image. | `MAIN-CAND-IMAGE-001` | concurrent lower 2 | `mainCaseColdPartialPermPreimage` | this packet | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001B` | Prove `p(q(y)) = y` and package surjectivity. | `MAIN-PERM-UNITARY-001A` | concurrent lower 2 | `mainCaseColdPartialPermImage_preimage`, `mainCaseColdPartialPermImage_surjective` | this packet | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001C` | Prove injectivity of `p`. | `MAIN-PERM-UNITARY-001A` | concurrent lower 2 | `mainCaseColdPartialPermImage_injective_pointwise`, `mainCaseColdPartialPermImage_injective` | this packet | `python3 tools/qbe.py check` | proved |
| `MAIN-PERM-UNITARY-001D` | Package finite-permutation/unitarity evidence. | `MAIN-PERM-UNITARY-001B`, `MAIN-PERM-UNITARY-001C` | concurrent lower 2 | `mainCaseColdPartialPermImage_bijective` | this packet and obligation ledger | `python3 tools/qbe.py check` | proved |
| `MAIN-UNITARY-BRIDGE-001` | If required, connect finite bijection of `p` to the project-local matrix-unitary predicate for `BlockEncodingClassics.permMatrix p`. | `MAIN-PERM-UNITARY-001D` | later lower/refiner | generic bridge theorem or COLD bridge obligation | proof-obligation ledger | `python3 tools/qbe.py check` | pending only if stronger semantic tier is required |
| `MAIN-RESOURCE-001` | Attach resource tuple and field theorems. | `MAIN-PERM-UNITARY-001D`, circuit/resource schema | later lower/refiner | `mainCaseColdPartialPermCost_*` | candidate population | `python3 tools/qbe.py check` | pending |
| `MAIN-EXPORT-001` | Qiskit/QASM3 export from named Lean certificates. | block, unitarity, and resource certificates | later export worker | export manifest/checks | export ledger | export checks plus project gate | blocked |

## Ordered Lean Lemmas

1. Reuse existing `mainCaseColdPartialPermImage :
   Fin 16 -> Fin 16`.
2. Reuse compiled `mainCaseColdPartialPermPreimage : Fin 16 -> Fin 16` with
   the inverse table above.
3. Reuse compiled `mainCaseColdPartialPermImage_preimage :
   forall y : Fin 16,
   mainCaseColdPartialPermImage (mainCaseColdPartialPermPreimage y) = y`.
   The proof is finite and uses `native_decide`.
4. Reuse compiled `mainCaseColdPartialPermImage_surjective :
   Function.Surjective mainCaseColdPartialPermImage` by choosing
   `mainCaseColdPartialPermPreimage y`.
5. Reuse compiled `mainCaseColdPartialPermImage_injective_pointwise :
   forall x y : Fin 16,
   mainCaseColdPartialPermImage x = mainCaseColdPartialPermImage y -> x = y`.
   The proof is finite and uses `native_decide`.  If this becomes brittle in
   a future generalized theorem, prove `mainCaseColdPartialPermPreimage_image :
   forall x : Fin 16,
   mainCaseColdPartialPermPreimage (mainCaseColdPartialPermImage x) = x`
   and use it as the injectivity bridge.
6. Reuse compiled `mainCaseColdPartialPermImage_injective :
   Function.Injective mainCaseColdPartialPermImage` from the pointwise lemma.
7. Reuse compiled `mainCaseColdPartialPermImage_bijective :
   Function.Injective mainCaseColdPartialPermImage ∧
   Function.Surjective mainCaseColdPartialPermImage`.
8. Reuse `BlockEncodingClassics.permMatrix` and
   `mainCaseColdPartialPermMatrix` as the matrix-level object.  Do not add a
   new matrix definition.
9. Reuse `mainCaseColdPartialPerm_clean_eq_target` for block containment in a
   later candidate package.  Do not reopen the clean-entry proof unless the
   table changes.

## Failure Analysis

The current target is mathematically consistent.  The candidate table is a
permutation by the explicit inverse above, and the clean block already matches
the transfer operator in Lean.  The remaining gap is certification-layer
specific: a finite-permutation witness is enough for the current
finite-permutation semantic tier, but a stronger rational-orthogonality matrix
predicate would require a generic bridge theorem from bijective `Fin n` images
to rational permutation-matrix orthogonality.

Do not close that stronger bridge by assertion or by changing
`mainCaseColdTarget`.  If the reviewer requires the stronger matrix predicate,
record a separate symbolic bridge leaf rather than mutating
`MAIN-PERM-UNITARY-001`.

## Verifier Feedback

```text
leaf=MAIN-PERM-UNITARY-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=true
normalizer_ok=true
unitarity_ok=finite_permutation_tier_true
resource_score=(null,null,1,0)
auxiliary_qubits=1
gate_count=null
depth=null
oracle_calls=0
closed_theorem_ok=true_for_finite_bijection
error_class=symbolic_bridge_gap
next_route=If the next semantic tier requires matrix orthogonality, prove a narrow bridge from finite bijection of mainCaseColdPartialPermImage to the project-local unitary predicate for mainCaseColdPartialPermMatrix; otherwise schedule MAIN-RESOURCE-001. Run python3 tools/qbe.py check after Lean edits.
```

## Handoff

The finite-bijection subleaf is no longer the next active Lean target:
`mainCaseColdPartialPermImage_bijective` now compiles under `mainCaseCold*`
names.  Next worker should either prove a narrow matrix-unitary bridge if the
semantic tier requires a rational-orthogonality predicate, or move to
`MAIN-RESOURCE-001` and attach an honest resource tuple.  Resource
declarations, a complete candidate record, and Qiskit/QASM3 export remain
blocked until the COLD unitarity semantics and resource leaves compile.
