# External Lean Library Card: ATLAS v1

Upstream: <https://github.com/facebookresearch/atlas-lean>

Visualizer: <https://rammalahmad.github.io/atlas/>

Companion paper: [Formalizing Mathematics at Scale](https://arxiv.org/abs/2605.29955)

Formalization harness: [AutoformBot](https://github.com/facebookresearch/autoform-bot)

Pinned revision: `e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6`

Development checkout: `outer_repos/atlas-lean/v1`

## License Boundary

ATLAS v1 is licensed for academic and research use under CC BY-NC 4.0 with
an additional upstream no-training rider. It is not covered by ASPBE's MIT
license. Its Lean source and generated theorem text therefore stay in the
separate `outer_repos` checkout; generated full-text retrieval data stays under
the ignored `.qbe/external-memory/atlas-lean/` directory.

ASPBE commits only the pinned provenance record, deterministic indexing code,
aggregate audit results, curated relevance notes, and independently written
local adapters. Do not paste ATLAS theorem bodies into public memory cards.

## Install And Verify

```bash
mkdir -p ../outer_repos
git clone https://github.com/facebookresearch/atlas-lean ../outer_repos/atlas-lean
git -C ../outer_repos/atlas-lean checkout e8b31c5cb0bec89b487ce33fe525a2c0b0f8b9c6
python3 tools/qbe.py atlas-verify
```

The verification command builds ATLAS v1 with its own Lean `4.29.0` and
Mathlib pin, indexes every parsed theorem and lemma, and writes a local gate
record. This establishes upstream compilation only. It does not establish that
every declaration is hole-free, faithful to its textbook, or compatible with
ASPBE's APIs.

## Retrieval

```bash
python3 tools/qbe.py atlas-search "matrix adjoint" --clean-only
python3 tools/qbe.py atlas-search "tensor" --relevance finite-sums-products-and-tensors
python3 tools/qbe.py atlas-show Matrix.cayleyHamilton_fin_two
python3 tools/qbe.py atlas-status
```

Every indexed entry records:

- declaration name, kind, book, module, source line, and commit-pinned URL;
- public/private status and a direct `sorry` scan;
- upstream target description and evaluation scores when `report.json` has a
  matching record;
- an ASPBE relevance class;
- the explicit status `external-memory-only`.

Use `--clean-only` for the conservative default during proof planning. A
result outside the evaluated textbook targets may still compile, but it has no
ATLAS faithfulness or proof-integrity score and must be reviewed before reuse.

## ASPBE-Relevant Surfaces

| ATLAS surface | Possible ASPBE use | Admission rule |
| --- | --- | --- |
| Linear algebra, matrices, bases, spectral statements | state vectors, matrix semantics, unitarity and clean-block algebra | Prefer Mathlib directly; add only a narrow local adapter that closes an active proof-DAG edge. |
| Norms, inner products and finite-dimensional analysis | state normalization, error bounds, approximate block encodings | Check hypotheses and complex/real conventions, then compile the ASPBE-facing theorem locally. |
| Complex analysis, Fourier analysis and polynomials | phase conventions, polynomial transforms, approximation background | Treat high-level textbook results as external memory until a named local consumer theorem compiles. |
| Finite sums, products and tensor constructions | register products, LCU bookkeeping and tensor-composition proofs | Reuse Mathlib declarations where possible; do not import an entire ATLAS book for one identity. |
| Boolean functions, permutations and bit arithmetic | reversible classical subcircuits and address logic | Require explicit basis-state and cleanup semantics in ASPBE; a classical identity alone is not a circuit certificate. |
| Probability and concentration | randomized candidate generation and resource experiments | Engineering/search evidence only unless the mathematical theorem is part of the stated ASPBE contract. |
| Algorithms, complexity and combinatorial optimization | resource accounting and candidate-selection reasoning | Keep source cost models distinct from ASPBE's gate/depth/ancilla/oracle tuple. |

## Admission Status

ATLAS is a broad mathematical supplier, not a quantum-circuit library. No
ATLAS declaration is automatically a state-preparation or block-encoding
certificate. The promotion path is:

```text
ATLAS source at pinned revision
  -> upstream build and report status
  -> relevance review against one ASPBE proof obligation
  -> minimal independently maintained adapter
  -> ASPBE lake build and Tests
  -> named local declaration in positive retrieval memory
```

Entries with `sorryAx`, a failed upstream report, low faithfulness, or unclear
conventions remain negative/review memory. The harness must not cite them as
proof authority.

Declaration-level admission decisions, including false friends such as real
quadratic-form "normalization" and finite-field "Fourier" bounds, are recorded
in [`atlas-lean-relevance.md`](atlas-lean-relevance.md).

## Attribution

ATLAS v1 and its visualizer were created by Ahmad Rammal, Niket Patel, Fabian
Gloeckle, Amaury Hayat, Julia Kempe, Remi Munos, Charles Arnal, and Vivien
Cabannes. ASPBE uses ATLAS as a separately licensed external theorem-retrieval
surface and does not claim authorship of its textbook formalizations.
