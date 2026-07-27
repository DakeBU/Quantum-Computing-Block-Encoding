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

Reader orientation: Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures. Each card separates an accessible
reading cue from formal status, the source docstring, and the authoritative Lean panel.
The standalone Library Explorer adds full-text search and filters across every chapter.

# QuantumBlockEncoding/BlockEncoding.lean

22 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.RegisterLayout" (lean := "QuantumBlockEncoding.RegisterLayout")
*Plain-English reading.* This record groups the data and proof fields needed for “register layout”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:14](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L14).
:::

:::definition "QuantumBlockEncoding.RegisterLayout.auxiliaryQubits" (lean := "QuantumBlockEncoding.RegisterLayout.auxiliaryQubits")
*Plain-English reading.* This definition gives the library's named construction or computation for “auxiliary qubits”. The auxiliary qubit count used by the block-encoding score.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The auxiliary qubit count used by the block-encoding score. This combines the signal qubits selecting the block with pure ancillas that must be returned to a clean state.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:27](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L27).
:::

:::definition "QuantumBlockEncoding.BlockEncodingSpec" (lean := "QuantumBlockEncoding.BlockEncodingSpec")
*Plain-English reading.* This record groups the data and proof fields needed for “block encoding spec”. A proposition-valued field is a requirement until a constructor supplies it. A block-encoding candidate before semantic proofs are attached.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A block-encoding candidate before semantic proofs are attached.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:33](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L33).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost" (lean := "QuantumBlockEncoding.BlockEncodingCost")
*Plain-English reading.* This record groups the data and proof fields needed for “block encoding cost”. A proposition-valued field is a requirement until a constructor supplies it. Resource score for comparing two candidate block encodings of the same operator.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Resource score for comparing two candidate block encodings of the same operator. The search order is deliberately domain-specific: 1. fewer gates, 2. smaller circuit depth, 3. fewer auxiliary qubits, 4. fewer unresolved oracle calls.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:50](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L50).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.fromLayoutAndResource" (lean := "QuantumBlockEncoding.BlockEncodingCost.fromLayoutAndResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “from layout and resource”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:59](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L59).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.fromSpec" (lean := "QuantumBlockEncoding.BlockEncodingCost.fromSpec")
*Plain-English reading.* This definition gives the library's named construction or computation for “from spec”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:66](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L66).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.betterThan" (lean := "QuantumBlockEncoding.BlockEncodingCost.betterThan")
*Plain-English reading.* This definition gives the library's named construction or computation for “better than”. Strict lexicographic improvement used by candidate-population selection.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Strict lexicographic improvement used by candidate-population selection.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:70](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L70).
:::

:::definition "QuantumBlockEncoding.BlockEncodingCost.noWorseThan" (lean := "QuantumBlockEncoding.BlockEncodingCost.noWorseThan")
*Plain-English reading.* This definition gives the library's named construction or computation for “no worse than”. Non-strict version for accepting a candidate as no worse than a baseline.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Non-strict version for accepting a candidate as no worse than a baseline.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:80](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L80).
:::

:::definition "QuantumBlockEncoding.QueryOperatorTarget" (lean := "QuantumBlockEncoding.QueryOperatorTarget")
*Plain-English reading.* This record groups the data and proof fields needed for “query operator target”. A proposition-valued field is a requirement until a constructor supplies it. The concrete input ABEIS is meant to solve: a user gives an operator/query oracle target, usually as a finite matrix together with a normalization contract and optional free parameters.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The concrete input ABEIS is meant to solve: a user gives an operator/query oracle target, usually as a finite matrix together with a normalization contract and optional free parameters.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:90](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L90).
:::

:::definition "QuantumBlockEncoding.OperatorBlockEncodingCandidate" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate")
*Plain-English reading.* This record groups the data and proof fields needed for “operator block encoding candidate”. A proposition-valued field is a requirement until a constructor supplies it. A candidate unitary for an 'n'-qubit square operator.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A candidate unitary for an 'n'-qubit square operator. The size of the unitary is fixed by the chosen number of auxiliary qubits: if the target acts on 'N = 2^n' dimensions and the candidate uses 'a' auxiliary qubits, then the unitary acts on '2^(n+a)' dimensions.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:103](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L103).
:::

:::definition "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost")
*Plain-English reading.* This definition gives the library's named construction or computation for “cost”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L119).
:::

:::definition "QuantumBlockEncoding.VerifiedOperatorBlockEncoding" (lean := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding")
*Plain-English reading.* This record groups the data and proof fields needed for “verified operator block encoding”. A proposition-valued field is a requirement until a constructor supplies it. A verified candidate with explicit proofs of unitarity and block containment.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A verified candidate with explicit proofs of unitarity and block containment.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:131](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L131).
:::

:::definition "QuantumBlockEncoding.ApproximateOperatorBlockEncodingCandidate" (lean := "QuantumBlockEncoding.ApproximateOperatorBlockEncodingCandidate")
*Plain-English reading.* This record groups the data and proof fields needed for “approximate operator block encoding candidate”. A proposition-valued field is a requirement until a constructor supplies it. An approximate block-encoding candidate for the same operator-first interface.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* An approximate block-encoding candidate for the same operator-first interface. The mathematical backend should instantiate 'approximationBound' with the norm inequality '‖A - α \* ((⟨0^a| ⊗ I) U (|0^a⟩ ⊗ I))‖ ≤ ε'. The field is deliberately a proposition, because different finite backends may start with different norms or exact-rational surrogate checks before connecting to a full analytic norm library.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:148](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L148).
:::

:::definition "QuantumBlockEncoding.VerifiedApproximateOperatorBlockEncoding" (lean := "QuantumBlockEncoding.VerifiedApproximateOperatorBlockEncoding")
*Plain-English reading.* This record groups the data and proof fields needed for “verified approximate operator block encoding”. A proposition-valued field is a requirement until a constructor supplies it. A verified approximate block encoding.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A verified approximate block encoding. Exact block encodings are the special case 'epsilon = 0' when the backend proves that exact equality implies the chosen norm bound.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:159](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L159).
:::

:::definition "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox" (lean := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox")
*Plain-English reading.* This definition gives the library's named construction or computation for “as zero error approx”. Package an exact certificate as a zero-error approximate certificate when the chosen approximate proposition is the same exact block predicate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Package an exact certificate as a zero-error approximate certificate when the chosen approximate proposition is the same exact block predicate. Analytic backends can later replace this with a theorem connecting exact block equality to a concrete operator-norm inequality.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncoding.lean:173](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L173).
:::

:::definition "QuantumBlockEncoding.AdaptiveBlockEncodingPolicy" (lean := "QuantumBlockEncoding.AdaptiveBlockEncodingPolicy")
*Plain-English reading.* This record groups the data and proof fields needed for “adaptive block encoding policy”. A proposition-valued field is a requirement until a constructor supplies it. User-level stopping and relaxation policy for operator block-encoding search.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* User-level stopping and relaxation policy for operator block-encoding search. The harness first searches for exact block encodings. If a certified exact candidate meeting 'requiredCost' appears before 'maxExactIterations', it may enter a post-convergence approximate-improvement phase for the user's requested epsilon. If the exact search stalls, the upper layer may switch to approximate search and, if allowed, relax beyond the requested epsilon.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L195).
:::

:::definition "QuantumBlockEncoding.BlockEncodingSearchPhase" (lean := "QuantumBlockEncoding.BlockEncodingSearchPhase")
*Plain-English reading.* This type lists the allowed alternatives for “block encoding search phase”; its constructors are the cases that downstream code must handle. High-level phase labels used by the candidate-population ledger.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* High-level phase labels used by the candidate-population ledger.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/BlockEncoding.lean:207](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L207).
:::

:::definition "QuantumBlockEncoding.VerifiedBlockEncoding" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding")
*Plain-English reading.* This record groups the data and proof fields needed for “verified block encoding”. A proposition-valued field is a requirement until a constructor supplies it. A verified block encoding.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A verified block encoding. The three proposition fields are intentionally parameters of the certificate so that early project files can state workflows without committing to a specific matrix norm or unitary semantics. A mathlib backend should instantiate these propositions with concrete definitions.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:220](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L220).
:::

:::theorem "QuantumBlockEncoding.VerifiedBlockEncoding.unitary" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding.unitary")
*Plain-English reading.* Lean checks the proposition indexed as “unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncoding.lean:231](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L231).
:::

:::theorem "QuantumBlockEncoding.VerifiedBlockEncoding.correct" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncoding.lean:235](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L235).
:::

:::theorem "QuantumBlockEncoding.VerifiedBlockEncoding.resource_ok" (lean := "QuantumBlockEncoding.VerifiedBlockEncoding.resource_ok")
*Plain-English reading.* Lean checks the proposition indexed as “resource ok”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncoding.lean:239](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L239).
:::

:::definition "QuantumBlockEncoding.ConstructionClaim" (lean := "QuantumBlockEncoding.ConstructionClaim")
*Plain-English reading.* This record groups the data and proof fields needed for “construction claim”. A proposition-valued field is a requirement until a constructor supplies it. A high-level construction claim imported from a paper or generated by AI.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A high-level construction claim imported from a paper or generated by AI.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncoding.lean:246](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncoding.lean#L246).
:::

# QuantumBlockEncoding/Circuit.lean

12 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Gate" (lean := "QuantumBlockEncoding.Gate")
*Plain-English reading.* This type lists the allowed alternatives for “gate”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Circuit.lean:13](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L13).
:::

:::definition "QuantumBlockEncoding.Circuit" (lean := "QuantumBlockEncoding.Circuit")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “circuit”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/Circuit.lean:23](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L23).
:::

:::definition "QuantumBlockEncoding.Gate.resource" (lean := "QuantumBlockEncoding.Gate.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”. Conservative elementary-resource estimate for the current IR.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Conservative elementary-resource estimate for the current IR. Oracle calls have zero local cost here because their implementation should be expanded or certified separately.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Circuit.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L32).
:::

:::definition "QuantumBlockEncoding.CircuitLayer" (lean := "QuantumBlockEncoding.CircuitLayer")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “circuit layer”. A layer is a list of gates intended to be scheduled in parallel.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A layer is a list of gates intended to be scheduled in parallel. The current IR does not yet prove non-overlap of qubits inside a layer; that belongs to the semantic proof obligations for a concrete backend.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/Circuit.lean:50](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L50).
:::

:::definition "QuantumBlockEncoding.CircuitLayer.resource" (lean := "QuantumBlockEncoding.CircuitLayer.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Circuit.lean:54](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L54).
:::

:::definition "QuantumBlockEncoding.LayeredCircuit" (lean := "QuantumBlockEncoding.LayeredCircuit")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “layered circuit”. A layered circuit is the schedule used for depth comparisons.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A layered circuit is the schedule used for depth comparisons.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/Circuit.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L60).
:::

:::definition "QuantumBlockEncoding.LayeredCircuit.resource" (lean := "QuantumBlockEncoding.LayeredCircuit.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Circuit.lean:64](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L64).
:::

:::definition "QuantumBlockEncoding.LayeredCircuit.depth" (lean := "QuantumBlockEncoding.LayeredCircuit.depth")
*Plain-English reading.* This definition gives the library's named construction or computation for “depth”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Circuit.lean:68](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L68).
:::

:::definition "QuantumBlockEncoding.Circuit.resource" (lean := "QuantumBlockEncoding.Circuit.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Circuit.lean:75](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L75).
:::

:::theorem "QuantumBlockEncoding.Circuit.resource_nil" (lean := "QuantumBlockEncoding.Circuit.resource_nil")
*Plain-English reading.* Lean checks the proposition indexed as “resource nil”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Circuit.lean:79](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L79).
:::

:::theorem "QuantumBlockEncoding.Circuit.resource_cons" (lean := "QuantumBlockEncoding.Circuit.resource_cons")
*Plain-English reading.* Lean checks the proposition indexed as “resource cons”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Circuit.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L81).
:::

:::definition "QuantumBlockEncoding.Circuit.depth" (lean := "QuantumBlockEncoding.Circuit.depth")
*Plain-English reading.* This definition gives the library's named construction or computation for “depth”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Circuit.lean:84](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Circuit.lean#L84).
:::

# QuantumBlockEncoding/Core.lean

36 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Matrix" (lean := "QuantumBlockEncoding.Matrix")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “matrix”. A finite matrix represented by its entries.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A finite matrix represented by its entries.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/Core.lean:15](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L15).
:::

:::definition "QuantumBlockEncoding.Matrix.PointwiseEq" (lean := "QuantumBlockEncoding.Matrix.PointwiseEq")
*Plain-English reading.* This definition gives the library's named construction or computation for “pointwise eq”. Pointwise equality for finite matrices.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Pointwise equality for finite matrices.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:20](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L20).
:::

:::definition "QuantumBlockEncoding.Matrix.zero" (lean := "QuantumBlockEncoding.Matrix.zero")
*Plain-English reading.* This definition gives the library's named construction or computation for “zero”. The zero finite matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The zero finite matrix.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:25](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L25).
:::

:::definition "QuantumBlockEncoding.Matrix.identity" (lean := "QuantumBlockEncoding.Matrix.identity")
*Plain-English reading.* This definition gives the library's named construction or computation for “identity”. The identity finite matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The identity finite matrix.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:29](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L29).
:::

:::definition "QuantumBlockEncoding.Matrix.mul" (lean := "QuantumBlockEncoding.Matrix.mul")
*Plain-English reading.* This definition gives the library's named construction or computation for “mul”. Finite matrix multiplication with the project-local 'Matrix' representation.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Finite matrix multiplication with the project-local 'Matrix' representation.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L34).
:::

:::definition "QuantumBlockEncoding.gridSize" (lean := "QuantumBlockEncoding.gridSize")
*Plain-English reading.* This definition gives the library's named construction or computation for “grid size”. Number of grid points in an 'n'-qubit register.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Number of grid points in an 'n'-qubit register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:44](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L44).
:::

:::definition "QuantumBlockEncoding.clog2" (lean := "QuantumBlockEncoding.clog2")
*Plain-English reading.* This definition gives the library's named construction or computation for “clog 2”. Small ceiling-log helper for resource bookkeeping.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Small ceiling-log helper for resource bookkeeping. 'clog2 m' is the number of bits needed to address 'm' alternatives, with 'clog2 0 = clog2 1 = 0'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:52](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L52).
:::

:::theorem "QuantumBlockEncoding.gridSize_zero" (lean := "QuantumBlockEncoding.gridSize_zero")
*Plain-English reading.* Lean checks the proposition indexed as “grid size zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:55](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L55).
:::

:::theorem "QuantumBlockEncoding.clog2_zero" (lean := "QuantumBlockEncoding.clog2_zero")
*Plain-English reading.* Lean checks the proposition indexed as “clog 2 zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:57](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L57).
:::

:::theorem "QuantumBlockEncoding.clog2_one" (lean := "QuantumBlockEncoding.clog2_one")
*Plain-English reading.* Lean checks the proposition indexed as “clog 2 one”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L60).
:::

:::theorem "QuantumBlockEncoding.log2_pred_two_pow_succ" (lean := "QuantumBlockEncoding.log2_pred_two_pow_succ")
*Plain-English reading.* Lean checks the proposition indexed as “log 2 pred two pow succ”; the hypotheses and conclusion in the code panel fix its exact scope. 'log2 (2^(n+1)-1) = n', the arithmetic fact behind 'clog2\_gridSize'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* 'log2 (2^(n+1)-1) = n', the arithmetic fact behind 'clog2\_gridSize'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:64](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L64).
:::

:::theorem "QuantumBlockEncoding.clog2_gridSize" (lean := "QuantumBlockEncoding.clog2_gridSize")
*Plain-English reading.* Lean checks the proposition indexed as “clog 2 grid size”; the hypotheses and conclusion in the code panel fix its exact scope. The bit-width of an 'n'-qubit grid is 'n'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The bit-width of an 'n'-qubit grid is 'n'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:94](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L94).
:::

:::definition "QuantumBlockEncoding.BoundaryKind" (lean := "QuantumBlockEncoding.BoundaryKind")
*Plain-English reading.* This type lists the allowed alternatives for “boundary kind”; its constructors are the cases that downstream code must handle. Boundary conditions tracked by this library.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Boundary conditions tracked by this library.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Core.lean:103](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L103).
:::

:::definition "QuantumBlockEncoding.Stencil" (lean := "QuantumBlockEncoding.Stencil")
*Plain-English reading.* This record groups the data and proof fields needed for “stencil”. A proposition-valued field is a requirement until a constructor supplies it. Finite-difference stencil metadata.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Finite-difference stencil metadata.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Core.lean:111](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L111).
:::

:::definition "QuantumBlockEncoding.Stencil.width" (lean := "QuantumBlockEncoding.Stencil.width")
*Plain-English reading.* This definition gives the library's named construction or computation for “width”. The number of columns touched by a stencil row before boundary corrections.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The number of columns touched by a stencil row before boundary corrections.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:121](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L121).
:::

:::theorem "QuantumBlockEncoding.Stencil.width_eq" (lean := "QuantumBlockEncoding.Stencil.width_eq")
*Plain-English reading.* Lean checks the proposition indexed as “width eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:124](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L124).
:::

:::definition "QuantumBlockEncoding.BulkWindow" (lean := "QuantumBlockEncoding.BulkWindow")
*Plain-English reading.* This record groups the data and proof fields needed for “bulk window”. A proposition-valued field is a requirement until a constructor supplies it. A central bulk interval '\[lower, upper\]' inside the computational basis rows.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A central bulk interval '\[lower, upper\]' inside the computational basis rows. The first project version stores the bounds as data; stronger proofs about range validity can be added when the matrix semantics are imported.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Core.lean:134](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L134).
:::

:::definition "QuantumBlockEncoding.BulkWindow.paperBoundaryLines" (lean := "QuantumBlockEncoding.BulkWindow.paperBoundaryLines")
*Plain-English reading.* This definition gives the library's named construction or computation for “paper boundary lines”. Number of boundary-side rows outside the bulk, using the paper's convention.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Number of boundary-side rows outside the bulk, using the paper's convention.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:142](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L142).
:::

:::definition "QuantumBlockEncoding.Coeff" (lean := "QuantumBlockEncoding.Coeff")
*Plain-English reading.* This type lists the allowed alternatives for “coeff”; its constructors are the cases that downstream code must handle. A lightweight symbolic coefficient language for stencil entries.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A lightweight symbolic coefficient language for stencil entries.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Core.lean:148](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L148).
:::

:::definition "QuantumBlockEncoding.Coeff.sub" (lean := "QuantumBlockEncoding.Coeff.sub")
*Plain-English reading.* This definition gives the library's named construction or computation for “sub”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:170](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L170).
:::

:::definition "QuantumBlockEncoding.Coeff.evalWith" (lean := "QuantumBlockEncoding.Coeff.evalWith")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval with”. Evaluate a symbolic 'Coeff' to a concrete 'Rat' given an environment.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Evaluate a symbolic 'Coeff' to a concrete 'Rat' given an environment.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:176](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L176).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat")
*Plain-English reading.* Lean checks the proposition indexed as “eval with rat”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:183](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L183).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_symbol" (lean := "QuantumBlockEncoding.Coeff.evalWith_symbol")
*Plain-English reading.* Lean checks the proposition indexed as “eval with symbol”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:186](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L186).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_add" (lean := "QuantumBlockEncoding.Coeff.evalWith_add")
*Plain-English reading.* Lean checks the proposition indexed as “eval with add”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:189](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L189).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_mul" (lean := "QuantumBlockEncoding.Coeff.evalWith_mul")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:192](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L192).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_neg" (lean := "QuantumBlockEncoding.Coeff.evalWith_neg")
*Plain-English reading.* Lean checks the proposition indexed as “eval with neg”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L195).
:::

:::theorem "QuantumBlockEncoding.Coeff.rat_zero" (lean := "QuantumBlockEncoding.Coeff.rat_zero")
*Plain-English reading.* Lean checks the proposition indexed as “rat zero”; the hypotheses and conclusion in the code panel fix its exact scope. Trivial reflexivity lemma for the zero rational coefficient.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Trivial reflexivity lemma for the zero rational coefficient.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:199](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L199).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_zero" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_zero")
*Plain-English reading.* Lean checks the proposition indexed as “eval with rat zero”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating 'Coeff.rat 0' yields '0' under any environment.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Evaluating 'Coeff.rat 0' yields '0' under any environment.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:202](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L202).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_one" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_one")
*Plain-English reading.* Lean checks the proposition indexed as “eval with rat one”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating 'Coeff.rat 1' yields '1' under any environment.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Evaluating 'Coeff.rat 1' yields '1' under any environment.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:206](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L206).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_add" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_add")
*Plain-English reading.* Lean checks the proposition indexed as “eval with rat add”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating 'Coeff.add (Coeff.rat a) (Coeff.rat b)' yields 'a + b'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Evaluating 'Coeff.add (Coeff.rat a) (Coeff.rat b)' yields 'a + b'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:210](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L210).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_mul" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_mul")
*Plain-English reading.* Lean checks the proposition indexed as “eval with rat mul”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating 'Coeff.mul (Coeff.rat a) (Coeff.rat b)' yields 'a \* b'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Evaluating 'Coeff.mul (Coeff.rat a) (Coeff.rat b)' yields 'a \* b'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:215](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L215).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_rat_neg" (lean := "QuantumBlockEncoding.Coeff.evalWith_rat_neg")
*Plain-English reading.* Lean checks the proposition indexed as “eval with rat neg”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating 'Coeff.neg (Coeff.rat a)' yields '-a'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Evaluating 'Coeff.neg (Coeff.rat a)' yields '-a'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:220](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L220).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_eq_zero_of_rat_zero" (lean := "QuantumBlockEncoding.Coeff.evalWith_eq_zero_of_rat_zero")
*Plain-English reading.* Lean checks the proposition indexed as “eval with eq zero of rat zero”; the hypotheses and conclusion in the code panel fix its exact scope. If a Coeff value is 'Coeff.rat 0', it evaluates to '0' under any environment.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* If a Coeff value is 'Coeff.rat 0', it evaluates to '0' under any environment.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:225](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L225).
:::

:::theorem "QuantumBlockEncoding.Coeff.evalWith_eq_one_of_rat_one" (lean := "QuantumBlockEncoding.Coeff.evalWith_eq_one_of_rat_one")
*Plain-English reading.* Lean checks the proposition indexed as “eval with eq one of rat one”; the hypotheses and conclusion in the code panel fix its exact scope. If a Coeff value is 'Coeff.rat 1', it evaluates to '1' under any environment.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* If a Coeff value is 'Coeff.rat 1', it evaluates to '1' under any environment.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Core.lean:229](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L229).
:::

:::definition "QuantumBlockEncoding.Coeff.divNat" (lean := "QuantumBlockEncoding.Coeff.divNat")
*Plain-English reading.* This definition gives the library's named construction or computation for “div nat”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Core.lean:232](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L232).
:::

:::definition "QuantumBlockEncoding.StencilEntry" (lean := "QuantumBlockEncoding.StencilEntry")
*Plain-English reading.* This record groups the data and proof fields needed for “stencil entry”. A proposition-valued field is a requirement until a constructor supplies it. One symbolic nonzero entry in a finite-difference row.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* One symbolic nonzero entry in a finite-difference row.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Core.lean:238](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Core.lean#L238).
:::

# QuantumBlockEncoding/Resources.lean

25 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Resource" (lean := "QuantumBlockEncoding.Resource")
*Plain-English reading.* This record groups the data and proof fields needed for “resource”. A proposition-valued field is a requirement until a constructor supplies it. Exact resource counts for candidate block-encoding circuits.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Exact resource counts for candidate block-encoding circuits. 'depth' is the sequential circuit depth under the current schedule. A later hardware backend can refine the gate set, but ABEIS always records this field because parallelizing two independent gates is a real improvement even when the total gate count is unchanged.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Resources.lean:21](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L21).
:::

:::definition "QuantumBlockEncoding.Resource.gates" (lean := "QuantumBlockEncoding.Resource.gates")
*Plain-English reading.* This definition gives the library's named construction or computation for “gates”. Gate count used by the search score before an oracle call is expanded.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Gate count used by the search score before an oracle call is expanded.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L32).
:::

:::definition "QuantumBlockEncoding.Resource.add" (lean := "QuantumBlockEncoding.Resource.add")
*Plain-English reading.* This definition gives the library's named construction or computation for “add”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L34).
:::

:::definition "QuantumBlockEncoding.Resource.parallel" (lean := "QuantumBlockEncoding.Resource.parallel")
*Plain-English reading.* This definition gives the library's named construction or computation for “parallel”. Resource combination for one parallel layer.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Resource combination for one parallel layer. Gate counts add, while depth is the maximum of the parallel subcircuits.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:45](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L45).
:::

:::definition "QuantumBlockEncoding.Resource.scale" (lean := "QuantumBlockEncoding.Resource.scale")
*Plain-English reading.* This definition gives the library's named construction or computation for “scale”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:55](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L55).
:::

:::definition "QuantumBlockEncoding.Resource.ofCounts" (lean := "QuantumBlockEncoding.Resource.ofCounts")
*Plain-English reading.* This definition gives the library's named construction or computation for “of counts”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:62](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L62).
:::

:::definition "QuantumBlockEncoding.Resource.ofCountsWithDepth" (lean := "QuantumBlockEncoding.Resource.ofCountsWithDepth")
*Plain-English reading.* This definition gives the library's named construction or computation for “of counts with depth”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:68](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L68).
:::

:::theorem "QuantumBlockEncoding.Resource.gates_eq" (lean := "QuantumBlockEncoding.Resource.gates_eq")
*Plain-English reading.* Lean checks the proposition indexed as “gates eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:75](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L75).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_oneQubit" (lean := "QuantumBlockEncoding.Resource.zero_oneQubit")
*Plain-English reading.* Lean checks the proposition indexed as “zero one qubit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:77](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L77).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_cnot" (lean := "QuantumBlockEncoding.Resource.zero_cnot")
*Plain-English reading.* Lean checks the proposition indexed as “zero cnot”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:78](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L78).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_oracleCalls" (lean := "QuantumBlockEncoding.Resource.zero_oracleCalls")
*Plain-English reading.* Lean checks the proposition indexed as “zero oracle calls”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:79](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L79).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_pureAncilla" (lean := "QuantumBlockEncoding.Resource.zero_pureAncilla")
*Plain-English reading.* Lean checks the proposition indexed as “zero pure ancilla”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:80](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L80).
:::

:::theorem "QuantumBlockEncoding.Resource.zero_depth" (lean := "QuantumBlockEncoding.Resource.zero_depth")
*Plain-English reading.* Lean checks the proposition indexed as “zero depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L81).
:::

:::theorem "QuantumBlockEncoding.Resource.add_oneQubit" (lean := "QuantumBlockEncoding.Resource.add_oneQubit")
*Plain-English reading.* Lean checks the proposition indexed as “add one qubit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:82](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L82).
:::

:::theorem "QuantumBlockEncoding.Resource.add_cnot" (lean := "QuantumBlockEncoding.Resource.add_cnot")
*Plain-English reading.* Lean checks the proposition indexed as “add cnot”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:84](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L84).
:::

:::theorem "QuantumBlockEncoding.Resource.add_oracleCalls" (lean := "QuantumBlockEncoding.Resource.add_oracleCalls")
*Plain-English reading.* Lean checks the proposition indexed as “add oracle calls”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:86](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L86).
:::

:::theorem "QuantumBlockEncoding.Resource.add_pureAncilla" (lean := "QuantumBlockEncoding.Resource.add_pureAncilla")
*Plain-English reading.* Lean checks the proposition indexed as “add pure ancilla”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:88](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L88).
:::

:::theorem "QuantumBlockEncoding.Resource.add_depth" (lean := "QuantumBlockEncoding.Resource.add_depth")
*Plain-English reading.* Lean checks the proposition indexed as “add depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/Resources.lean:90](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L90).
:::

:::definition "QuantumBlockEncoding.CostExpr" (lean := "QuantumBlockEncoding.CostExpr")
*Plain-English reading.* This type lists the allowed alternatives for “cost expr”; its constructors are the cases that downstream code must handle. A small expression language for big-O resource formulas.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A small expression language for big-O resource formulas.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/Resources.lean:96](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L96).
:::

:::definition "QuantumBlockEncoding.CostExpr.atoms" (lean := "QuantumBlockEncoding.CostExpr.atoms")
*Plain-English reading.* This definition gives the library's named construction or computation for “atoms”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:116](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L116).
:::

:::definition "QuantumBlockEncoding.AsymptoticResource" (lean := "QuantumBlockEncoding.AsymptoticResource")
*Plain-English reading.* This record groups the data and proof fields needed for “asymptotic resource”. A proposition-valued field is a requirement until a constructor supplies it. Big-O style resource claim.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Big-O style resource claim.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/Resources.lean:122](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L122).
:::

:::definition "QuantumBlockEncoding.AsymptoticResource.add" (lean := "QuantumBlockEncoding.AsymptoticResource.add")
*Plain-English reading.* This definition gives the library's named construction or computation for “add”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:129](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L129).
:::

:::definition "QuantumBlockEncoding.bandedSparseAccessResource" (lean := "QuantumBlockEncoding.bandedSparseAccessResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “banded sparse access resource”. Lemma 1 resource count from Guseynov-Huang-Liu 2025.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Lemma 1 resource count from Guseynov-Huang-Liu 2025.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:138](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L138).
:::

:::definition "QuantumBlockEncoding.sparseAmplitudeOracleResource" (lean := "QuantumBlockEncoding.sparseAmplitudeOracleResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “sparse amplitude oracle resource”. Lemma 3 resource count for the sparse-amplitude oracle.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Lemma 3 resource count for the sparse-amplitude oracle.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:145](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L145).
:::

:::definition "QuantumBlockEncoding.indicatorResource" (lean := "QuantumBlockEncoding.indicatorResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “indicator resource”. Appendix comparator/indicator resource count.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Appendix comparator/indicator resource count.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/Resources.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Resources.lean#L149).
:::

# QuantumBlockEncoding/StatePreparation.lean

11 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.zeroBasisIndex" (lean := "QuantumBlockEncoding.zeroBasisIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “zero basis index”. The computational all-zero basis index in an 'n'-qubit register.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The computational all-zero basis index in an 'n'-qubit register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/StatePreparation.lean:15](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L15).
:::

:::definition "QuantumBlockEncoding.StatePreparationTarget" (lean := "QuantumBlockEncoding.StatePreparationTarget")
*Plain-English reading.* This record groups the data and proof fields needed for “state preparation target”. A proposition-valued field is a requirement until a constructor supplies it. A normalized state requested by the user.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A normalized state requested by the user.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/StatePreparation.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L19).
:::

:::definition "QuantumBlockEncoding.FirstColumnMatches" (lean := "QuantumBlockEncoding.FirstColumnMatches")
*Plain-English reading.* This definition gives the library's named construction or computation for “first column matches”. The matrix-level first-column acceptance predicate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The matrix-level first-column acceptance predicate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/StatePreparation.lean:25](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L25).
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate" (lean := "QuantumBlockEncoding.StatePreparationCandidate")
*Plain-English reading.* This record groups the data and proof fields needed for “state preparation candidate”. A proposition-valued field is a requirement until a constructor supplies it. A state-preparation candidate before semantic proofs are attached.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A state-preparation candidate before semantic proofs are attached.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/StatePreparation.lean:31](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L31).
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget" (lean := "QuantumBlockEncoding.StatePreparationCandidate.preparesTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “prepares target”. The candidate's fixed semantic target; callers cannot replace it by a flag.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The candidate's fixed semantic target; callers cannot replace it by a flag.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/StatePreparation.lean:43](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L43).
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate.cost" (lean := "QuantumBlockEncoding.StatePreparationCandidate.cost")
*Plain-English reading.* This definition gives the library's named construction or computation for “cost”. Reuse the block-encoding resource order for state-preparation candidates.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Reuse the block-encoding resource order for state-preparation candidates.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/StatePreparation.lean:47](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L47).
:::

:::definition "QuantumBlockEncoding.VerifiedStatePreparation" (lean := "QuantumBlockEncoding.VerifiedStatePreparation")
*Plain-English reading.* This record groups the data and proof fields needed for “verified state preparation”. A proposition-valued field is a requirement until a constructor supplies it. A candidate promoted by proofs of normalization, unitarity, and state action.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A candidate promoted by proofs of normalization, unitarity, and state action.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/StatePreparation.lean:58](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L58).
:::

:::definition "QuantumBlockEncoding.ApproximateStatePreparationCandidate" (lean := "QuantumBlockEncoding.ApproximateStatePreparationCandidate")
*Plain-English reading.* This record groups the data and proof fields needed for “approximate state preparation candidate”. A proposition-valued field is a requirement until a constructor supplies it. An approximate candidate with a backend-specific state-error predicate.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* An approximate candidate with a backend-specific state-error predicate.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/StatePreparation.lean:65](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L65).
:::

:::definition "QuantumBlockEncoding.VerifiedApproximateStatePreparation" (lean := "QuantumBlockEncoding.VerifiedApproximateStatePreparation")
*Plain-English reading.* This record groups the data and proof fields needed for “verified approximate state preparation”. A proposition-valued field is a requirement until a constructor supplies it. A verified approximate state-preparation certificate.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* A verified approximate state-preparation certificate.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/StatePreparation.lean:72](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L72).
:::

:::definition "QuantumBlockEncoding.VerifiedStatePreparation.asZeroErrorApprox" (lean := "QuantumBlockEncoding.VerifiedStatePreparation.asZeroErrorApprox")
*Plain-English reading.* This definition gives the library's named construction or computation for “as zero error approx”. Package an exact state-preparation certificate as a zero-error approximate certificate when the backend uses the exact first-column predicate as its zero-error proposition.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* Package an exact state-preparation certificate as a zero-error approximate certificate when the backend uses the exact first-column predicate as its zero-error proposition.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/StatePreparation.lean:86](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L86).
:::

:::theorem "QuantumBlockEncoding.VerifiedStatePreparation.firstColumn" (lean := "QuantumBlockEncoding.VerifiedStatePreparation.firstColumn")
*Plain-English reading.* Lean checks the proposition indexed as “first column”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Core finite matrices, task contracts, resource records, circuit syntax, and certificate data structures.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/StatePreparation.lean:98](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/StatePreparation.lean#L98).
:::
