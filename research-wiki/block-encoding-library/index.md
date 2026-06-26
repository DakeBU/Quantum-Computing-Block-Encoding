# ABEIS Block-Encoding Memory Library

This directory is the reusable construction library for ABEIS.  It is meant to
act like a compact graduate textbook plus proof-template memory for coding
agents: when a target operator appears, upper agents recall analogous classic
constructions, middle agents turn the most plausible ideas into proof-DAG
leaves and insight-pool alternatives, and lower agents test those leaves in
Lean or natural language.

## How To Use

1. Read `route-selector.md`.
2. Pick one or more cards in `cards/`.
3. Instantiate the card as a proof blueprint: target, unitary, clean block,
   unitarity, resource tuple, and proof-DAG leaves.
4. Check `compiled-lean-leaf-index.md` and `proof-network.md` for already
   compiled Lean leaves shared by other cards.
5. Record the cited theorem or external contract in `research-wiki/cited-results/`.
6. Promote a construction to the certified population only after Lean proves it.

For expert block-encoding work, read the files in this order:

```text
lin-2201-08309.md        textbook backbone and intuition
route-selector.md        access-model and normalizer decision matrix
proof-network.md         typed edges between reusable proof leaves
compiled-lean-leaf-index.md/json
                         complete generated declaration ledger
lean-roadmap.md          formalized / contract-only / obligation status
qsvt-hard-hint-route.md  fast path for diagonal-grid polynomial hints
cards/<route>.md         task-specific construction template
paper-notes/block-encoding-library/classic_leaves.tex
                         human-facing LaTeX proof templates
```

## Textbook Backbone

`lin-2201-08309.md` is the current textbook backbone for entrywise
block-encoding proofs.  It links Lin 2201.08309 to ABEIS cards and Lean leaves:
entrywise clean blocks, value-to-amplitude contracts, one-sparse and sparse
oracles, LCU, dilation, Hermitian/qubitization consumers, and QSVT contracts.
This is an active memory library, not a claim that every textbook theorem has
already been formalized.  `proof-network.md` marks the exact status of each
leaf.  For readers who want proof-sketch exercises before looking at Lean,
`paper-notes/block-encoding-library/classic_leaves.tex` gives compact
paper-facing proofs for the main reusable leaves.

## Priority Library

| Priority | Card | Best target shape |
| --- | --- | --- |
| P0 | `BE.EntrywiseExact.CleanBlock` | any exact candidate with finite clean entries |
| P0 | `BE.PermMatrix.CleanBlock` | finite permutation matrix clean block |
| P0 | `BE.PartialPermutation.MatrixUnitTensorId` | matrix units, partial reset, controlled transfer |
| P0 | `BE.Tensor.PassiveRegister` | active operator tensored with identity |
| P0 | `BE.Sparse.OneSparsePermutation` | one nonzero entry per column/row |
| P0 | `BE.LCU.PrepareSelect` | finite weighted sums of unitaries/block encodings |
| P0 | `BE.Arithmetic.Product` | composition of block encodings |
| P0 | `BE.Arithmetic.Tensor` | parallel/tensor composition |
| P1 | `BE.QueryModel.ValueToAmplitude` | value oracle plus controlled rotation and uncompute |
| P1 | `BE.Sparse.ColumnOracle` | sparse column-location/value oracle route |
| P1 | `BE.Sparse.RowColumnOracle` | general sparse row/column location route |
| P1 | `BE.SparseAccess.GramConstruction` | sparse access oracle constructions |
| P1 | `BE.Density.FromPurification` | density/Gram matrices from state preparation |
| P1 | `BE.HermitianBlockEncoding` | Hermitian BE route for qubitization consumers |
| P1 | `BE.HermitianDilation` | non-Hermitian target routed into Hermitian algorithms |
| P1 | `BE.Contraction.SVDDilation` | arbitrary contraction fallback |
| P2 | `BE.Qubitization.Chebyshev` | Chebyshev powers after Hermitian BE |
| P2 | `BE.QSVT.ConsumerContract` | downstream polynomial transformation of a proved BE |
| P2 | `BE.FABLE.ApproxDense` | approximate dense block-encoding synthesis |
| P2 | `BE.StructuredSparse.ExplicitCircuits` | structured sparse arithmetic/pattern circuits |

## Current ABEIS Examples

| Task | Primary route | Notes |
| --- | --- | --- |
| `QBE-OP-OPTCTRL-001` / `QBE-OP-OPTCTRL-COLD-CLEAN-001` | partial permutation + clean block + passive register | Target is a matrix unit tensor identity, so LCU/QSVT are rejected as first routes. |
| `QBE-OP-CUBIC-DIAGONAL-001` | diagonal contraction + controlled rotation + arithmetic | Route should prove scalar clean entries and reversible arithmetic separately. |
| `QBE-OP-CUBIC-STATEPREP-001` | state preparation / approximate ladder | Exact route may be too strict; approximate search must state epsilon tiers explicitly. |

## Source Discipline

Classic papers are cited in `research-wiki/cited-results/block-encoding-classics.md`.
Cards may cite papers as source memory, but a card is not accepted as a theorem
until it has either a Lean declaration or an explicit external-contract status.

## Compiled Leaf Network

`proof-network.md` records which card nodes now share compiled Lean declarations
in `QuantumBlockEncoding/BlockEncodingClassics.lean`.
`compiled-lean-leaf-index.md` and `compiled-lean-leaf-index.json` list all
indexed ABEIS declarations by file for fast agent retrieval.

For hints of the form "first encode \(O_0=\sum_j x_j |j\rangle\langle j|\),
then use QSVT for \(x^3\)", read `qsvt-hard-hint-route.md` before assigning
lower work.
