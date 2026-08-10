import QuantumBlockEncoding
import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

set_option linter.hashCommand false
set_option linter.style.longLine false
set_option verso.blueprint.externalCode.strictResolve true

#doc (Manual) "Foundations: matrices, circuits, and semantic tiers" =>
%%%
file := "foundations"
%%%

The foundational layer is intentionally finite and explicit. Matrices are functions on finite
indices; circuits are syntax; gate matrices and whole-circuit semantics are separate data. This
keeps an entrywise matrix theorem from silently becoming a hardware claim.

:::definition "project matrix backend" (lean := "QuantumBlockEncoding.Matrix")
The project-local matrix type represents an $`m`-by-$`n` matrix over $`\alpha` as a function
$$`\operatorname{Fin}(m)\to\operatorname{Fin}(n)\to\alpha.`
Finite indexing makes clean-block equalities suitable for extensional and decision procedures.
:::

:::definition "resource ledger" (lean := "QuantumBlockEncoding.Resource")
The resource record separates gates, depth, oracle calls, and measurement calls. Its fields describe
the chosen semantic tier; an unexpanded oracle call is not counted as a free physical gate.
:::

:::definition "circuit syntax" (lean := "QuantumBlockEncoding.Gate, QuantumBlockEncoding.Circuit")
A gate is a named one-qubit operation, a controlled gate, or a parallel composition. A circuit is
a sequential list of gates. This syntax is lightweight enough for generated candidates while still
retaining the register-level intent of each operation.
:::

:::definition "gate matrix semantics" (lean := "QuantumBlockEncoding.GateMatrix")
A gate-matrix value couples one syntactic gate to a concrete matrix and a unitary-contract record.
The coupling prevents a proof about a matrix from being advertised as a proof about an unrelated
gate label.
:::

:::definition "circuit matrix semantics" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics")
Whole-circuit semantics records the gate matrices, their alignment with the circuit transcript,
the evaluated product matrix, and the semantic obligations needed by the chosen backend.
:::

:::definition "clean block" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy")
Given an embedding $`e : \operatorname{Fin}(s)\to\operatorname{Fin}(t)` and a full matrix $`U`, the
selected clean block is the $`s`-dimensional matrix
$$`(i,j)\longmapsto U(e(i),e(j)).`
This definition states exactly which ancilla slice is projected.
:::

:::definition "exact clean-block certificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock") (uses := "clean block")
The reusable arithmetic certificate packages $`U`, its target $`A`, the clean embedding, and a
pointwise proof that the selected block equals $`A`. It intentionally does not include unitarity,
circuit realization, or resource optimality.
:::

:::theorem "certificate exposes its target equality" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target") (uses := "exact clean-block certificate")
For every exact clean-block package, its computed clean matrix is pointwise equal to its stored
target matrix. Downstream LCU and product proofs consume this theorem rather than reopening the
original finite-index calculation.
:::

:::definition "four certificate layers"
ASPBE distinguishes four layers: (1) clean-entry or clean-block equality, (2) unitarity,
permutation, or inverse correctness, (3) circuit realization and gate-matrix alignment, and
(4) a resource score at a named implementation level. Claims are compared only after their layer
is made explicit.
:::
