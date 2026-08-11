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

#doc (Manual) "Overview: from a user target to a Lean certificate" =>
%%%
file := "overview"
%%%

ASPBE begins with either a normalized target state or an operator together with its access model.
It does not identify a plausible circuit with a proof. The library separates the requested
mathematical object, a candidate implementation, the semantic proof, and the resource record.

# Reader map

![Map of the ASPBE Lean library and its two synchronized reader surfaces](assets/abeis-library-map.svg)

There are three useful ways into the formal library:

1. *New to Lean:* read this Overview, then Foundations, Routes, and Case Studies. Each curated
   card explains the mathematical role before showing the checked declaration.
2. *Looking for a result:* use the [Library Explorer](../../library/) to search every explicit
   public declaration and filter by catalog, declaration kind, or experimental status.
3. *Auditing a claim:* open its Blueprint declaration panel, read the exact hypotheses and
   conclusion, then follow the repository source link. The Lean signature, not the reader cue,
   determines what has been certified.

The terms used on this site have narrow meanings. A *declaration* is a named Lean definition,
type, theorem, or lemma. A *structure* is a record: proposition-valued fields are requirements
until a concrete value supplies proofs. A *theorem* or *lemma* on the default import surface has
a compiled proof. A *diagnostic* or *experimental obligation* must not be reported as a certified
result.

# Evidence pipeline

![ASPBE evidence pipeline from user contract to public formal evidence](assets/abeis-evidence-pipeline.svg)

The diagram makes the promotion boundary explicit. Search agents may propose or repair a
candidate, and finite execution can reveal a counterexample, but neither action establishes a
symbolic theorem. Promotion occurs only when Lean accepts the named declaration under the stated
contract. Documentation and executable exports remain downstream evidence with their own scopes.

:::definition "state-preparation target" (lean := "QuantumBlockEncoding.StatePreparationTarget")
For $`n` qubits, a state-preparation target stores amplitudes indexed by
$$`\operatorname{Fin}(2^n)` and an explicit normalization proposition. The source field records
where the target came from; it is metadata and cannot replace the normalization proof.
:::

:::definition "verified state preparation" (lean := "QuantumBlockEncoding.VerifiedStatePreparation") (uses := "state-preparation target")
A state-preparation candidate supplies a matrix, a circuit transcript, a schedule, resources, and
a unitarity proposition. Promotion to a verified certificate requires proofs of normalization,
unitarity, and first-column equality. Thus the user-level condition is
$$`U|0^n\rangle=|\psi\rangle.`
:::

:::theorem "Pauli X prepares one" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXCertificate_prepares_one") (uses := "verified state preparation")
The Mathlib swap matrix supplies the Pauli X gate. Its self-inverse property proves unitarity,
and its zero-input column is $`|1\rangle`. The resulting certificate includes the logical circuit,
schedule, and one-gate resource record.
:::

:::theorem "Hadamard prepares plus" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardCertificate_prepares_plus") (uses := "verified state preparation")
The standard Hadamard matrix is proved unitary over $`\mathbb C`, its equal-superposition target
is proved normalized, and concrete matrix-vector action gives
$$`H|0\rangle=(|0\rangle+|1\rangle)/\sqrt 2.`
:::

:::definition "operator query target" (lean := "QuantumBlockEncoding.QueryOperatorTarget")
An operator task records a finite matrix $`A`, a normalizer $`\alpha`, its provenance, its semantic
contract, and any free parameters. The access model and normalization remain visible inputs rather
than hidden assumptions.
:::

:::definition "operator block-encoding candidate" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate") (uses := "operator query target")
For an $`n`-qubit target and $`a` auxiliaries, the candidate matrix acts on $`2^{n+a}` dimensions.
It carries the register layout, circuit, schedule, resource count, and two separate propositions:
unitarity and containment of the normalized target in the selected block.
:::

:::definition "verified operator block encoding" (lean := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding") (uses := "operator block-encoding candidate")
The verified record contains proofs of the candidate's unitarity and block predicate. It is the
smallest user-facing certificate that closes both semantic leaves. A clean-block-only package is a
reusable intermediate result, not automatically this full certificate.
:::

:::definition "resource score" (lean := "QuantumBlockEncoding.BlockEncodingCost")
Candidates at the same semantic tier are compared lexicographically by gate count, circuit depth,
auxiliary qubits, and unresolved oracle calls. Normalizer quality and proof status are assessed
before this concrete score.
:::

:::theorem "exact certificates enter approximate search at zero error" (lean := "QuantumBlockEncoding.VerifiedOperatorBlockEncoding.asZeroErrorApprox") (uses := "verified operator block encoding")
When the approximate backend uses exact block containment as its zero-error proposition, every
verified exact certificate can seed approximate search with $`\varepsilon=0`. This is an adapter,
not a claim about an unstated operator norm.
:::

# Documentation coverage

The catalog is regenerated by scripts/generate-blueprint-catalog.py. Its committed JSON audit
records every explicit public definition, abbreviation, opaque declaration, inductive type,
structure, class, theorem, and lemma in the Lean source. It also records private declarations as
deliberate exclusions. Build-time statistics, docstring coverage, generated reader cues, source
previews, and catalog assignments are displayed by the unified website rather than copied into
this prose. Structure-generated projections are accessible through their parent structure but
are not double-counted as source declarations.

The full library, including RobinMatrix.lean, is expected to build with zero open proofs.
RobinMatrix has its own research catalog because a compiled counterexample, interface, or
conditional theorem must not be confused with an end-to-end certificate of the cited paper.
