# Lower Architect Packet: QBE-MAIN-CASE-HIER-COLD-001

## Scope

This packet is for lower leaf `MAIN-CLEAN-ENTRY-001`.  It is a
natural-language proof design only.  It does not edit Lean and does not certify
the full block-encoding theorem.

The task is exploratory construction, not faithful paper reproduction.  No
local paper-source archive was detected for this task, so the source fragment
translated here is the task-owned operator contract in
`tasks/QBE-MAIN-CASE-HIER-COLD-001.md`.

## Source Fragment

The operator contract fixes

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S
$$

for one qubit in each register `(T,tau,S)`, with normalizer
`alpha = 1`.  The requested clean-block statement is

$$
(\langle 0|_{\mathrm{sig}} \otimes I) U
(|0\rangle_{\mathrm{sig}} \otimes I) = E_1.
$$

The Lean endpoint for this leaf should be:

```lean
theorem mainCaseColdPartialPerm_clean_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseColdPartialPermExactCleanBlock)
      mainCaseColdTarget
```

## Definitions

The system basis is flattened by

$$
\operatorname{sys}(T,\tau,S)=4T+2\tau+S.
$$

The signal-system basis is flattened by

$$
\operatorname{full}(b,T,\tau,S)=8b+\operatorname{sys}(T,\tau,S).
$$

The target matrix `mainCaseColdTarget` has value `1` exactly at the two
entries

$$
(\operatorname{sys}(0,0,0),\operatorname{sys}(1,1,0))=(0,6),
\qquad
(\operatorname{sys}(0,0,1),\operatorname{sys}(1,1,1))=(1,7),
$$

and has value `0` at every other entry.

The clean signal is `0`.  The clean embedding is
`mainCaseColdCleanEmbed i = BlockEncodingClassics.productIndex 0 i`, which is
the full index `i` because the signal register is clean.

The candidate image `p : Fin 16 -> Fin 16` is the task-local finite map

```text
0 -> 14, 1 -> 15, 2 -> 8, 3 -> 9,
4 -> 10, 5 -> 11, 6 -> 0, 7 -> 1,
8 -> 2, 9 -> 3, 10 -> 4, 11 -> 5,
12 -> 6, 13 -> 7, 14 -> 12, 15 -> 13
```

The candidate matrix is the permutation matrix
`BlockEncodingClassics.permMatrix p`.

## Natural-Language Proof

First prove the clean-entry predicate.  For any system row `r` and system
column `c`, the reusable clean-block theorem reduces the clean entry of the
permutation matrix to

$$
\begin{cases}
1, & \operatorname{embed}(r)=p(\operatorname{embed}(c)),\\
0, & \text{otherwise}.
\end{cases}
$$

Since `embed(c)=c` for clean columns `c : Fin 8`, the relevant values of `p`
are the first eight entries of the table:

```text
p(0)=14, p(1)=15, p(2)=8, p(3)=9,
p(4)=10, p(5)=11, p(6)=0, p(7)=1.
```

The values `8,9,10,11,14,15` are dirty-signal output indices, so they cannot
equal `embed(r)` for any system row `r : Fin 8`.  Therefore columns
`0,1,2,3,4,5` contribute only zero entries to the clean block.

Column `6` is the clean basis state `(signal,T,tau,S)=(0,1,1,0)`.  The table
gives `p(6)=0`, so the unique clean output row is `0`, which is
`(T,tau,S)=(0,0,0)`.

Column `7` is the clean basis state `(signal,T,tau,S)=(0,1,1,1)`.  The table
gives `p(7)=1`, so the unique clean output row is `1`, which is
`(T,tau,S)=(0,0,1)`.

Thus the clean block has value `1` exactly at `(row,col)=(0,6)` and
`(row,col)=(1,7)`, and value `0` elsewhere.  This is exactly
`|0><1|_T \otimes |0><1|_\tau \otimes I_S`.

The finite image is also a bijection because its image list

```text
[14,15,8,9,10,11,0,1,2,3,4,5,6,7,12,13]
```

contains every element of `0..15` exactly once.  This supports the later
`MAIN-PERM-UNITARY-001` leaf, but the clean-entry theorem itself only needs
the entrywise predicate above.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Define the COLD system index, target matrix, clean signal, normalizer, and exact error. | task packet | lower Lean worker | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | this packet and conversion window | `python3 tools/qbe.py check` | active prerequisite |
| `MAIN-CAND-IMAGE-001` | Define the task-local `Fin 16` candidate image and matrix. | `MAIN-SOURCE-001` | lower Lean worker | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | this packet | `python3 tools/qbe.py check` | active prerequisite |
| `MAIN-CLEAN-ENTRY-001` | Prove the clean-block entries equal `mainCaseColdTarget` and package through `partialPermutationCertificate`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | lower Lean worker | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `MAIN-PERM-UNITARY-001` | Prove the finite image is bijective and connect that to the task unitarity layer. | `MAIN-CAND-IMAGE-001` | later lower/refiner | `mainCaseColdPartialPermImage_bijective` or equivalent | proof-obligation ledger | `python3 tools/qbe.py check` | open |
| `MAIN-RESOURCE-001` | Certify the resource tuple in `(gateCount, depth, auxiliaryQubits, oracleCalls)` order. | circuit schema or honest high-level resource model | later lower/refiner | `mainCaseColdPartialPermCost_*` | candidate-population ledger | `python3 tools/qbe.py check` | open |
| `MAIN-EXPORT-001` | Generate Qiskit and QASM3 artifacts from named Lean certificates. | block, unitarity, and resource certificates | export worker | export manifest/checks | executable export ledger | export checks plus project gate | blocked |

## Ordered Lean Lemmas

1. `mainCaseColdSystemIndex (T tau S : Fin 2) : Fin 8`.
   Reuse `omega` or finite arithmetic as in existing local register-index
   declarations, but do not refer to `mainCasePro*` theorems.

2. `mainCaseColdTarget : Matrix 8 8 Rat`.
   Define it by the two target support pairs `(0,6)` and `(1,7)`, or by the
   corresponding `mainCaseColdSystemIndex` terms.

3. `mainCaseColdExactNormalizer : Rat := 1`,
   `mainCaseColdExactError : Rat := 0`, and
   `mainCaseColdCleanSignal : Fin 2 := 0`.

4. `mainCaseColdCleanEmbed (i : Fin 8) : Fin 16`.
   Reuse `BlockEncodingClassics.productIndex mainCaseColdCleanSignal i`.

5. `mainCaseColdPartialPermImage : Fin 16 -> Fin 16`.
   Define the table above under COLD task-local names.

6. `mainCaseColdPartialPermMatrix : Matrix (2 * 8) (2 * 8) Rat`.
   Reuse `BlockEncodingClassics.permMatrix mainCaseColdPartialPermImage`.

7. `mainCaseColdPartialPerm_entry`.
   Statement:

   ```lean
   theorem mainCaseColdPartialPerm_entry :
       forall row col : Fin 8,
         (if mainCaseColdCleanEmbed row =
               mainCaseColdPartialPermImage (mainCaseColdCleanEmbed col) then
             1
           else
             0) =
           mainCaseColdTarget row col
   ```

   A finite proof by `native_decide` after unfolding the table should be
   acceptable.  If `native_decide` is too opaque, split rows and columns with
   `fin_cases`.

8. `mainCaseColdPartialPermExactCleanBlock`.
   Reuse:

   ```lean
   BlockEncodingClassics.partialPermutationCertificate
     mainCaseColdCleanEmbed
     mainCaseColdPartialPermImage
     mainCaseColdTarget
     mainCaseColdPartialPerm_entry
   ```

9. `mainCaseColdPartialPerm_clean_eq_target`.
   Reuse `BlockEncodingClassics.ExactCleanBlock.clean_eq_target`.

10. Later leaf only: `mainCaseColdPartialPermImage_bijective`.
    The image-list argument above gives the proof idea.  It should not block
    `MAIN-CLEAN-ENTRY-001` unless the task requires a full candidate record in
    the same Lean edit.

## Failure Analysis

The current target is mathematically well-shaped for the partial-permutation
route.  The candidate does not change the operator, normalizer, clean signal,
or passive identity factor.

There is one important layer boundary.  `ExactCleanBlock` certifies the
clean-block matrix equality, but it does not by itself certify full matrix
unitarity, gate realization, or resource optimality.  Those are separate
obligations: `MAIN-PERM-UNITARY-001` and `MAIN-RESOURCE-001`.

The local paper-source archive is absent.  This is not a source-theorem
blocker for this exploratory task because the task packet itself supplies the
operator contract, but a future paper-benchmark route would need an explicit
source artifact before claiming source-faithful reproduction.

## Typed Verifier Feedback

```text
leaf=MAIN-CLEAN-ENTRY-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=true
normalizer_ok=true
unitarity_ok=true
resource_score=(null,null,1,0)
auxiliary_qubits=1
gate_count=null
depth=null
oracle_calls=0
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=implement mainCaseColdPartialPerm_entry and package mainCaseColdPartialPermExactCleanBlock using BlockEncodingClassics.partialPermutationCertificate
```

`closed_theorem_ok=false` because no COLD Lean declaration has yet closed the
endpoint theorem in this natural-language packet.
