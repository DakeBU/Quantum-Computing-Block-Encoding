# Middle Source Contract: QBE-MAIN-CASE-HIER-COLD-001 Cycle 2

## Source Anchor

The source anchor for this cycle is the user/operator contract in
`tasks/QBE-MAIN-CASE-HIER-COLD-001.md`, section `Operator Contract`.  No local
paper-source archive was detected.  The task is exploratory construction, so
the task packet is the source of truth for this leaf.

The object being translated is the concrete transfer operator

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S
$$

with one qubit in each register `(T,tau,S)`, one clean block signal qubit,
normalizer `alpha = 1`, and exact error `0`.

## Lean Contract

Lower 2 owns only this Lean repair:

- target file: `QuantumBlockEncoding/MainCase.lean`;
- optional import file: `QuantumBlockEncoding.lean` only if `MainCase` is not imported;
- prohibited certificates: `mainCasePro*`, `OptimalControl`, `ColdStartTransferE1`, prior Pro answers, and executable exports.

Required declarations:

```lean
def mainCaseColdSystemIndex (T tau S : Fin 2) : Fin 8
def mainCaseColdTarget : Matrix 8 8 Rat
def mainCaseColdExactNormalizer : Rat := 1
def mainCaseColdExactError : Rat := 0
def mainCaseColdCleanSignal : Fin 2 := 0
def mainCaseColdCleanEmbed (i : Fin 8) : Fin 16
def mainCaseColdPartialPermImage : Fin 16 -> Fin 16
def mainCaseColdPartialPermMatrix : Matrix (2 * 8) (2 * 8) Rat
```

The candidate image table is fixed for this packet:

```text
0 -> 14, 1 -> 15, 2 -> 8, 3 -> 9,
4 -> 10, 5 -> 11, 6 -> 0, 7 -> 1,
8 -> 2, 9 -> 3, 10 -> 4, 11 -> 5,
12 -> 6, 13 -> 7, 14 -> 12, 15 -> 13
```

The active theorem endpoint is:

```lean
theorem mainCaseColdPartialPerm_clean_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseColdPartialPermExactCleanBlock)
      mainCaseColdTarget
```

The intended package is:

```lean
theorem mainCaseColdPartialPerm_entry :
    forall row col : Fin 8,
      (if mainCaseColdCleanEmbed row =
            mainCaseColdPartialPermImage (mainCaseColdCleanEmbed col) then
          1
        else
          0) =
        mainCaseColdTarget row col

def mainCaseColdPartialPermExactCleanBlock :
    BlockEncodingClassics.ExactCleanBlock 8 16 :=
  BlockEncodingClassics.partialPermutationCertificate
    mainCaseColdCleanEmbed
    mainCaseColdPartialPermImage
    mainCaseColdTarget
    mainCaseColdPartialPerm_entry
```

## Ownership And Dependencies

| Item | Owner class | Lower action |
|---|---|---|
| `E_1`, register order, clean signal, normalizer, exactness | active user/operator target | encode exactly; do not mutate |
| finite completion table | QBE-local candidate glue | implement under COLD names |
| clean-block extraction theorem | QBE-local compiled semantic glue | reuse `BlockEncodingClassics.partialPermutationCertificate` |
| finite table arithmetic | local classical fact | prove by `native_decide` or finite cases |
| unitarity/resource/export layers | later QBE obligations | do not claim in this leaf |
| external cited theorem | none active | no cited-results row needed |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `MAIN-SOURCE-001` | Source matrix, register order, clean signal, normalizer, exact error. | task packet | lower 2 | `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | conversion window | `python3 tools/qbe.py check` | active prerequisite |
| `MAIN-CAND-IMAGE-001` | Task-local `Fin 16` partial-permutation table and matrix. | `MAIN-SOURCE-001` | lower 2 | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | conversion window | `python3 tools/qbe.py check` | active prerequisite |
| `MAIN-CLEAN-ENTRY-001` | Clean block of the permutation matrix equals `mainCaseColdTarget`. | `MAIN-SOURCE-001`, `MAIN-CAND-IMAGE-001` | lower 2 | `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | this packet | `python3 tools/qbe.py check` | active Lean leaf |
| `MAIN-PERM-UNITARY-001` | Finite bijection and semantic unitarity bridge. | `MAIN-CAND-IMAGE-001` | later lower/refiner | `mainCaseColdPartialPermImage_bijective` | proof obligations | `python3 tools/qbe.py check` | open |
| `MAIN-RESOURCE-001` | Resource tuple in `(gateCount, depth, auxiliaryQubits, oracleCalls)` order. | circuit schema | later lower/refiner | `mainCaseColdPartialPermCost_*` | candidate population | `python3 tools/qbe.py check` | open |

## Verifier Feedback Expected

Lower 2 should log `leaf=MAIN-CLEAN-ENTRY-001`,
`source_correspondence_ok=true`, `lean_parse_ok`, `lean_build_ok`,
`block_entry_ok`, `normalizer_ok=true`, `closed_theorem_ok`, `error_class`,
and `next_route`.  If the statement compiles and the theorem closes, the next
route is `MAIN-PERM-UNITARY-001`; otherwise the next route should name the
first malformed declaration or proof gap.

No LaTeX or executable export is due in this inner cycle.
