import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

#doc (Manual) "ABEIS Lean Blueprint" =>

This Blueprint is the readable map of the Lean library behind the Automatic Block-Encoding
Intelligence System (ABEIS). It connects the user-facing quantum construction workflow to exact
Lean definitions, theorem statements, proof dependencies, and source locations.

The first four chapters explain the contracts, reusable construction routes, and completed case
studies. The declaration catalog that follows is generated from every explicit public declaration
in QuantumBlockEncoding. Generated Lean panels are resolved during the documentation build, so a
renamed or missing declaration breaks CI instead of leaving a stale web page.

The words *proved*, *contract*, and *obligation* are used deliberately. A proposition stored
inside a structure is a contract until a proof field is supplied. An exact clean-block certificate
does not by itself claim a gate implementation or resource optimality. The experimental
Robin-matrix module is included for discoverability but is separated from the default import
surface and its two open diagnostic proofs are stated plainly.

The organization of this documentation was inspired by Sho Sonoda's
[Lean Ridgelet project](https://github.com/shosonoda/lean-ridgelet) and its
[public Blueprint](https://shosonoda.github.io/lean-ridgelet/). We thank Sho Sonoda for making
that readable example public. The multi-page design, Lean declaration panels, preview runtime,
navigation, and selectable styles are provided by
[Verso Blueprint](https://github.com/leanprover/verso-blueprint), built on
[Verso](https://github.com/leanprover/verso).
