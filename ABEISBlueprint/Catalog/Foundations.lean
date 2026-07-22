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

#doc (Manual) "Declaration catalog: Foundations" =>
%%%
file := "catalog-foundations"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

# QuantumBlockEncoding/BlockEncoding.lean

22 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.RegisterLayout" (lean := "QuantumBlockEncoding.RegisterLayout")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:14](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L14).
:::

:::definition "QuantumBlockEncoding.RegisterLayout.auxiliaryQubits" (lean := "QuantumBlockEncoding.RegisterLayout.auxiliaryQubits")
Source documentation: `The auxiliary qubit count used by the block-encoding score. This combines the signal qubits selecting the block with pure ancillas that must be returned to a clean state.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:27](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L27).
:::

:::definition "QuantumBlockEncoding.BlockEncodingSpec" (lean := "QuantumBlockEncoding.BlockEncodingSpec")
Source documentation: `A block-encoding candidate before semantic proofs are attached.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:33](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L33).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost" (lean := "QuantumBlockEncoding.BlockEncodingCost")
Source documentation: `Resource score for comparing two candidate block encodings of the same operator. The search order is deliberately domain-specific: 1. fewer gates, 2. smaller circuit depth, 3. fewer auxiliary qubits, 4. fewer unresolved oracle calls.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:50](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L50).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.fromLayoutAndResource" (lean := "QuantumBlockEncoding.BlockEncodingCost.fromLayoutAndResource")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:59](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L59).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.fromSpec" (lean := "QuantumBlockEncoding.BlockEncodingCost.fromSpec")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:66](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L66).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.betterThan" (lean := "QuantumBlockEncoding.BlockEncodingCost.betterThan")
Source documentation: `Strict lexicographic improvement used by candidate-population selection.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:70](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L70).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.noWorseThan" (lean := "QuantumBlockEncoding.BlockEncodingCost.noWorseThan")
Source documentation: `Non-strict version for accepting a candidate as no worse than a baseline.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:80](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L80).
:::

:::definition "QuantumBlockEncoding.QueryOperatorTarget" (lean := "QuantumBlockEncoding.QueryOperatorTarget")
Source documentation: `The concrete input ABEIS is meant to solve: a user gives an operator/query oracle target, usually as a finite matrix together with a normalization contract and optional free parameters.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:90](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L90).
:::

:::definition "QuantumBlockEncoding.OperatorBlockEncodingCandidate" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate")
Source documentation: `A candidate unitary for an 'n'-qubit square operator. The size of the unitary is fixed by the chosen number of auxiliary qubits: if the target acts on 'N = 2^n' dimensions and the candidate uses 'a' auxiliary qubits, then the unitary acts on '2^(n+a)' dimensions.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:103](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L103).
:::

:::definition "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L119).
:::

:::definition "QuantumBlockEncoding.VerifiedOperatorBlockEncoding" (lean := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding")
Source documentation: `A verified candidate with explicit proofs of unitarity and block containment.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:131](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L131).
:::

:::definition "QuantumBlockEncoding.ApproximateOperatorBlockEncodingCandidate" (lean := "QuantumBlockEncoding.ApproximateOperatorBlockEncodingCandidate")
Source documentation: `An approximate block-encoding candidate for the same operator-first interface. The mathematical backend should instantiate 'approximationBound' with the norm inequality '‖A - α * ((⟨0^a| ⊗ I) U (|0^a⟩ ⊗ I))‖ ≤ ε'. The field is deliberately a proposition, because different finite backends may start with different norms or exact-rational surrogate checks before connecting to a full analytic norm library.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:148](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L148).
:::

:::definition "QuantumBlockEncoding.VerifiedApproximateOperatorBlockEncoding" (lean := "QuantumBlockEncoding.VerifiedApproximateOperatorBlockEncoding")
Source documentation: `A verified approximate block encoding. Exact block encodings are the special case 'epsilon = 0' when the backend proves that exact equality implies the chosen norm bound.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:159](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L159).
:::

:::definition "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox" (lean := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox")
Source documentation: `Package an exact certificate as a zero-error approximate certificate when the chosen approximate proposition is the same exact block predicate. Analytic backends can later replace this with a theorem connecting exact block equality to a concrete operator-norm inequality.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:173](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L173).
:::

:::definition "QuantumBlockEncoding.AdaptiveBlockEncodingPolicy" (lean := "QuantumBlockEncoding.AdaptiveBlockEncodingPolicy")
Source documentation: `User-level stopping and relaxation policy for operator block-encoding search. The harness first searches for exact block encodings. If a certified exact candidate meeting 'requiredCost' appears before 'maxExactIterations', it may enter a post-convergence approximate-improvement phase for the user's requested epsilon. If the exact search stalls, the upper layer may switch to approximate search and, if allowed, relax beyond the requested epsilon.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L195).
:::

:::definition "QuantumBlockEncoding.BlockEncodingSearchPhase" (lean := "QuantumBlockEncoding.BlockEncodingSearchPhase")
Source documentation: `High-level phase labels used by the candidate-population ledger.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:207](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L207).
:::

:::definition "QuantumBlockEncoding.VerifiedBlockEncoding" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding")
Source documentation: `A verified block encoding. The three proposition fields are intentionally parameters of the certificate so that early project files can state workflows without committing to a specific matrix norm or unitary semantics. A mathlib backend should instantiate these propositions with concrete definitions.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:220](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L220).
:::

:::theorem "QuantumBlockEncoding.VerifiedBlockEncoding.unitary" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding.unitary")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:231](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L231).
:::

:::theorem "QuantumBlockEncoding.VerifiedBlockEncoding.correct" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding.correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:235](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L235).
:::

:::theorem "QuantumBlockEncoding.VerifiedBlockEncoding.resource_ok" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding.resource_ok")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:239](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L239).
:::

:::definition "QuantumBlockEncoding.ConstructionClaim" (lean := "QuantumBlockEncoding.ConstructionClaim")
Source documentation: `A high-level construction claim imported from a paper or generated by AI.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncoding.lean:246](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L246).
:::

# QuantumBlockEncoding/Circuit.lean

12 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Gate" (lean := "QuantumBlockEncoding.Gate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this inductive.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:13](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L13).
:::

:::definition "QuantumBlockEncoding.Circuit" (lean := "QuantumBlockEncoding.Circuit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this abbrev.`.

Kind: abbrev. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:23](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L23).
:::

:::definition "QuantumBlockEncoding.Gate.resource" (lean := "QuantumBlockEncoding.Gate.resource")
Source documentation: `Conservative elementary-resource estimate for the current IR. Oracle calls have zero local cost here because their implementation should be expanded or certified separately.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L32).
:::

:::definition "QuantumBlockEncoding.CircuitLayer" (lean := "QuantumBlockEncoding.CircuitLayer")
Source documentation: `A layer is a list of gates intended to be scheduled in parallel. The current IR does not yet prove non-overlap of qubits inside a layer; that belongs to the semantic proof obligations for a concrete backend.`.

Kind: abbrev. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:50](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L50).
:::

:::definition "QuantumBlockEncoding.CircuitLayer.resource" (lean := "QuantumBlockEncoding.CircuitLayer.resource")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:54](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L54).
:::

:::definition "QuantumBlockEncoding.LayeredCircuit" (lean := "QuantumBlockEncoding.LayeredCircuit")
Source documentation: `A layered circuit is the schedule used for depth comparisons.`.

Kind: abbrev. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L60).
:::

:::definition "QuantumBlockEncoding.LayeredCircuit.resource" (lean := "QuantumBlockEncoding.LayeredCircuit.resource")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:64](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L64).
:::

:::definition "QuantumBlockEncoding.LayeredCircuit.depth" (lean := "QuantumBlockEncoding.LayeredCircuit.depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:68](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L68).
:::

:::definition "QuantumBlockEncoding.Circuit.resource" (lean := "QuantumBlockEncoding.Circuit.resource")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:75](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L75).
:::

:::theorem "QuantumBlockEncoding.Circuit.resource_nil" (lean := "QuantumBlockEncoding.Circuit.resource_nil")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:79](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L79).
:::

:::theorem "QuantumBlockEncoding.Circuit.resource_cons" (lean := "QuantumBlockEncoding.Circuit.resource_cons")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L81).
:::

:::definition "QuantumBlockEncoding.Circuit.depth" (lean := "QuantumBlockEncoding.Circuit.depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Circuit.lean:84](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L84).
:::

# QuantumBlockEncoding/Core.lean

36 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Matrix" (lean := "QuantumBlockEncoding.Matrix")
Source documentation: `A finite matrix represented by its entries.`.

Kind: abbrev. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:15](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L15).
:::

:::definition "QuantumBlockEncoding.Matrix.PointwiseEq" (lean := "QuantumBlockEncoding.Matrix.PointwiseEq")
Source documentation: `Pointwise equality for finite matrices.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:20](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L20).
:::

:::definition "QuantumBlockEncoding.Matrix.zero" (lean := "QuantumBlockEncoding.Matrix.zero")
Source documentation: `The zero finite matrix.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:25](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L25).
:::

:::definition "QuantumBlockEncoding.Matrix.identity" (lean := "QuantumBlockEncoding.Matrix.identity")
Source documentation: `The identity finite matrix.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:29](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L29).
:::

:::definition "QuantumBlockEncoding.Matrix.mul" (lean := "QuantumBlockEncoding.Matrix.mul")
Source documentation: `Finite matrix multiplication with the project-local 'Matrix' representation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L34).
:::

:::definition "QuantumBlockEncoding.gridSize" (lean := "QuantumBlockEncoding.gridSize")
Source documentation: `Number of grid points in an 'n'-qubit register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:44](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L44).
:::

:::definition "QuantumBlockEncoding.clog2" (lean := "QuantumBlockEncoding.clog2")
Source documentation: `Small ceiling-log helper for resource bookkeeping. 'clog2 m' is the number of bits needed to address 'm' alternatives, with 'clog2 0 = clog2 1 = 0'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:52](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L52).
:::

:::theorem "QuantumBlockEncoding.gridSize_zero" (lean := "QuantumBlockEncoding.gridSize_zero")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:55](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L55).
:::

:::theorem "QuantumBlockEncoding.clog2_zero" (lean := "QuantumBlockEncoding.clog2_zero")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:57](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L57).
:::

:::theorem "QuantumBlockEncoding.clog2_one" (lean := "QuantumBlockEncoding.clog2_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L60).
:::

:::theorem "QuantumBlockEncoding.log2_pred_two_pow_succ" (lean := "QuantumBlockEncoding.log2_pred_two_pow_succ")
Source documentation: `'log2 (2^(n+1)-1) = n', the arithmetic fact behind 'clog2_gridSize'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:64](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L64).
:::

:::theorem "QuantumBlockEncoding.clog2_gridSize" (lean := "QuantumBlockEncoding.clog2_gridSize")
Source documentation: `The bit-width of an 'n'-qubit grid is 'n'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:94](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L94).
:::

:::definition "QuantumBlockEncoding.BoundaryKind" (lean := "QuantumBlockEncoding.BoundaryKind")
Source documentation: `Boundary conditions tracked by this library.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:103](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L103).
:::

:::definition "QuantumBlockEncoding.Stencil" (lean := "QuantumBlockEncoding.Stencil")
Source documentation: `Finite-difference stencil metadata.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:111](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L111).
:::

:::definition "QuantumBlockEncoding.Stencil.width" (lean := "QuantumBlockEncoding.Stencil.width")
Source documentation: `The number of columns touched by a stencil row before boundary corrections.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:121](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L121).
:::

:::theorem "QuantumBlockEncoding.Stencil.width_eq" (lean := "QuantumBlockEncoding.Stencil.width_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:124](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L124).
:::

:::definition "QuantumBlockEncoding.BulkWindow" (lean := "QuantumBlockEncoding.BulkWindow")
Source documentation: `A central bulk interval '[lower, upper]' inside the computational basis rows. The first project version stores the bounds as data; stronger proofs about range validity can be added when the matrix semantics are imported.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:134](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L134).
:::

:::definition "QuantumBlockEncoding.BulkWindow.paperBoundaryLines" (lean := "QuantumBlockEncoding.BulkWindow.paperBoundaryLines")
Source documentation: `Number of boundary-side rows outside the bulk, using the paper's convention.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:142](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L142).
:::

:::definition "QuantumBlockEncoding.Coeff" (lean := "QuantumBlockEncoding.Coeff")
Source documentation: `A lightweight symbolic coefficient language for stencil entries.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:148](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L148).
:::

:::definition "QuantumBlockEncoding.Coeff.sub" (lean := "QuantumBlockEncoding.Coeff.sub")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:170](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L170).
:::

:::definition "QuantumBlockEncoding.Coeff.evalWith" (lean := "QuantumBlockEncoding.Coeff.evalWith")
Source documentation: `Evaluate a symbolic 'Coeff' to a concrete 'Rat' given an environment.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:176](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L176).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:183](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L183).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_symbol" (lean := "QuantumBlockEncoding.Coeff.evalWith_symbol")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:186](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L186).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_add" (lean := "QuantumBlockEncoding.Coeff.evalWith_add")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:189](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L189).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_mul" (lean := "QuantumBlockEncoding.Coeff.evalWith_mul")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:192](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L192).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_neg" (lean := "QuantumBlockEncoding.Coeff.evalWith_neg")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L195).
:::

:::theorem "QuantumBlockEncoding.Coeff.rat_zero" (lean := "QuantumBlockEncoding.Coeff.rat_zero")
Source documentation: `Trivial reflexivity lemma for the zero rational coefficient.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:199](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L199).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_zero" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_zero")
Source documentation: `Evaluating 'Coeff.rat 0' yields '0' under any environment.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:202](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L202).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_one" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_one")
Source documentation: `Evaluating 'Coeff.rat 1' yields '1' under any environment.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:206](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L206).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_add" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_add")
Source documentation: `Evaluating 'Coeff.add (Coeff.rat a) (Coeff.rat b)' yields 'a + b'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:210](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L210).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_mul" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_mul")
Source documentation: `Evaluating 'Coeff.mul (Coeff.rat a) (Coeff.rat b)' yields 'a * b'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:215](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L215).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_neg" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_neg")
Source documentation: `Evaluating 'Coeff.neg (Coeff.rat a)' yields '-a'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:220](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L220).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_eq_zero_of_rat_zero" (lean := "QuantumBlockEncoding.Coeff.evalWith_eq_zero_of_rat_zero")
Source documentation: `If a Coeff value is 'Coeff.rat 0', it evaluates to '0' under any environment.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:225](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L225).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_eq_one_of_rat_one" (lean := "QuantumBlockEncoding.Coeff.evalWith_eq_one_of_rat_one")
Source documentation: `If a Coeff value is 'Coeff.rat 1', it evaluates to '1' under any environment.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:229](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L229).
:::

:::definition "QuantumBlockEncoding.Coeff.divNat" (lean := "QuantumBlockEncoding.Coeff.divNat")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:232](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L232).
:::

:::definition "QuantumBlockEncoding.StencilEntry" (lean := "QuantumBlockEncoding.StencilEntry")
Source documentation: `One symbolic nonzero entry in a finite-difference row.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Core.lean:238](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L238).
:::

# QuantumBlockEncoding/Resources.lean

25 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Resource" (lean := "QuantumBlockEncoding.Resource")
Source documentation: `Exact resource counts for candidate block-encoding circuits. 'depth' is the sequential circuit depth under the current schedule. A later hardware backend can refine the gate set, but ABEIS always records this field because parallelizing two independent gates is a real improvement even when the total gate count is unchanged.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:21](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L21).
:::

:::definition "QuantumBlockEncoding.Resource.gates" (lean := "QuantumBlockEncoding.Resource.gates")
Source documentation: `Gate count used by the search score before an oracle call is expanded.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L32).
:::

:::definition "QuantumBlockEncoding.Resource.add" (lean := "QuantumBlockEncoding.Resource.add")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L34).
:::

:::definition "QuantumBlockEncoding.Resource.parallel" (lean := "QuantumBlockEncoding.Resource.parallel")
Source documentation: `Resource combination for one parallel layer. Gate counts add, while depth is the maximum of the parallel subcircuits.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:45](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L45).
:::

:::definition "QuantumBlockEncoding.Resource.scale" (lean := "QuantumBlockEncoding.Resource.scale")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:55](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L55).
:::

:::definition "QuantumBlockEncoding.Resource.ofCounts" (lean := "QuantumBlockEncoding.Resource.ofCounts")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:62](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L62).
:::

:::definition "QuantumBlockEncoding.Resource.ofCountsWithDepth" (lean := "QuantumBlockEncoding.Resource.ofCountsWithDepth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:68](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L68).
:::

:::theorem "QuantumBlockEncoding.Resource.gates_eq" (lean := "QuantumBlockEncoding.Resource.gates_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:75](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L75).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_oneQubit" (lean := "QuantumBlockEncoding.Resource.zero_oneQubit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:77](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L77).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_cnot" (lean := "QuantumBlockEncoding.Resource.zero_cnot")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:78](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L78).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_oracleCalls" (lean := "QuantumBlockEncoding.Resource.zero_oracleCalls")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:79](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L79).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_pureAncilla" (lean := "QuantumBlockEncoding.Resource.zero_pureAncilla")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:80](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L80).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_depth" (lean := "QuantumBlockEncoding.Resource.zero_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L81).
:::

:::theorem "QuantumBlockEncoding.Resource.add_oneQubit" (lean := "QuantumBlockEncoding.Resource.add_oneQubit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:82](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L82).
:::

:::theorem "QuantumBlockEncoding.Resource.add_cnot" (lean := "QuantumBlockEncoding.Resource.add_cnot")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:84](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L84).
:::

:::theorem "QuantumBlockEncoding.Resource.add_oracleCalls" (lean := "QuantumBlockEncoding.Resource.add_oracleCalls")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:86](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L86).
:::

:::theorem "QuantumBlockEncoding.Resource.add_pureAncilla" (lean := "QuantumBlockEncoding.Resource.add_pureAncilla")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:88](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L88).
:::

:::theorem "QuantumBlockEncoding.Resource.add_depth" (lean := "QuantumBlockEncoding.Resource.add_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:90](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L90).
:::

:::definition "QuantumBlockEncoding.CostExpr" (lean := "QuantumBlockEncoding.CostExpr")
Source documentation: `A small expression language for big-O resource formulas.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:96](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L96).
:::

:::definition "QuantumBlockEncoding.CostExpr.atoms" (lean := "QuantumBlockEncoding.CostExpr.atoms")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:116](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L116).
:::

:::definition "QuantumBlockEncoding.AsymptoticResource" (lean := "QuantumBlockEncoding.AsymptoticResource")
Source documentation: `Big-O style resource claim.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:122](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L122).
:::

:::definition "QuantumBlockEncoding.AsymptoticResource.add" (lean := "QuantumBlockEncoding.AsymptoticResource.add")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:129](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L129).
:::

:::definition "QuantumBlockEncoding.bandedSparseAccessResource" (lean := "QuantumBlockEncoding.bandedSparseAccessResource")
Source documentation: `Lemma 1 resource count from Guseynov-Huang-Liu 2025.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:138](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L138).
:::

:::definition "QuantumBlockEncoding.sparseAmplitudeOracleResource" (lean := "QuantumBlockEncoding.sparseAmplitudeOracleResource")
Source documentation: `Lemma 3 resource count for the sparse-amplitude oracle.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:145](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L145).
:::

:::definition "QuantumBlockEncoding.indicatorResource" (lean := "QuantumBlockEncoding.indicatorResource")
Source documentation: `Appendix comparator/indicator resource count.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Resources.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L149).
:::

# QuantumBlockEncoding/StatePreparation.lean

11 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.zeroBasisIndex" (lean := "QuantumBlockEncoding.zeroBasisIndex")
Source documentation: `The computational all-zero basis index in an 'n'-qubit register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:15](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L15).
:::

:::definition "QuantumBlockEncoding.StatePreparationTarget" (lean := "QuantumBlockEncoding.StatePreparationTarget")
Source documentation: `A normalized state requested by the user.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L19).
:::

:::definition "QuantumBlockEncoding.FirstColumnMatches" (lean := "QuantumBlockEncoding.FirstColumnMatches")
Source documentation: `The matrix-level first-column acceptance predicate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:25](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L25).
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate" (lean := "QuantumBlockEncoding.StatePreparationCandidate")
Source documentation: `A state-preparation candidate before semantic proofs are attached.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:31](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L31).
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget" (lean := "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget")
Source documentation: `The candidate's fixed semantic target; callers cannot replace it by a flag.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:43](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L43).
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate.cost" (lean := "QuantumBlockEncoding.StatePreparationCandidate.cost")
Source documentation: `Reuse the block-encoding resource order for state-preparation candidates.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:47](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L47).
:::

:::definition "QuantumBlockEncoding.VerifiedStatePreparation" (lean := "QuantumBlockEncoding.VerifiedStatePreparation")
Source documentation: `A candidate promoted by proofs of normalization, unitarity, and state action.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:58](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L58).
:::

:::definition "QuantumBlockEncoding.ApproximateStatePreparationCandidate" (lean := "QuantumBlockEncoding.ApproximateStatePreparationCandidate")
Source documentation: `An approximate candidate with a backend-specific state-error predicate.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:65](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L65).
:::

:::definition "QuantumBlockEncoding.VerifiedApproximateStatePreparation" (lean := "QuantumBlockEncoding.VerifiedApproximateStatePreparation")
Source documentation: `A verified approximate state-preparation certificate.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:72](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L72).
:::

:::definition "QuantumBlockEncoding.VerifiedStatePreparation.asZeroErrorApprox" (lean := "QuantumBlockEncoding.VerifiedStatePreparation.asZeroErrorApprox")
Source documentation: `Package an exact state-preparation certificate as a zero-error approximate certificate when the backend uses the exact first-column predicate as its zero-error proposition.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:86](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L86).
:::

:::theorem "QuantumBlockEncoding.VerifiedStatePreparation.firstColumn" (lean := "QuantumBlockEncoding.VerifiedStatePreparation.firstColumn")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/StatePreparation.lean:98](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L98).
:::
