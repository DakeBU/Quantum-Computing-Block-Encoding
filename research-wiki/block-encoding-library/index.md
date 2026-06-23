# ABEIS Block-Encoding Memory Library

This directory is the reusable construction library for ABEIS.  It is meant to
act like a compact graduate textbook plus proof-template memory for coding
agents: when a target operator appears, upper and middle agents route it to a
known construction family before lower agents write Lean.

## How To Use

1. Read `route-selector.md`.
2. Pick one or more cards in `cards/`.
3. Instantiate the card as a proof blueprint: target, unitary, clean block,
   unitarity, resource tuple, and proof-DAG leaves.
4. Check `proof-network.md` for already compiled Lean leaves shared by other
   cards.
5. Record the cited theorem or external contract in `research-wiki/cited-results/`.
6. Promote a construction to the certified population only after Lean proves it.

## Priority Library

| Priority | Card | Best target shape |
| --- | --- | --- |
| P0 | `BE.PermMatrix.CleanBlock` | finite permutation matrix clean block |
| P0 | `BE.PartialPermutation.MatrixUnitTensorId` | matrix units, partial reset, controlled transfer |
| P0 | `BE.Tensor.PassiveRegister` | active operator tensored with identity |
| P0 | `BE.LCU.PrepareSelect` | finite weighted sums of unitaries/block encodings |
| P0 | `BE.Arithmetic.Product` | composition of block encodings |
| P0 | `BE.Arithmetic.Tensor` | parallel/tensor composition |
| P1 | `BE.SparseAccess.GramConstruction` | sparse access oracle constructions |
| P1 | `BE.Density.FromPurification` | density/Gram matrices from state preparation |
| P1 | `BE.HermitianDilation` | non-Hermitian target routed into Hermitian algorithms |
| P1 | `BE.Contraction.SVDDilation` | arbitrary contraction fallback |
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
