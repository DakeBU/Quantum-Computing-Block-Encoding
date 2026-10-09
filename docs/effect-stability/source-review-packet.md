# Independent source/formal/reconstruction comparison packet

Created by /root/generic_source_review; run generic-source-review-20261009-01. This is a reviewer packet, not a source-blind decoder input. Text snapshots normalize line endings and trailing whitespace; SHA256 headers identify the original input files.

## Input source-contract.md; SHA256 9712de87c5a31f0ad44d217bf1add62280b2a518b8a0a9aae8117f501343050d

# Stability of normalized pure-state effect probabilities

Source: author-derived canonical finite-dimensional mathematical contracts,
version 1 (2026-10-09). This is a reusable library formalization, with no novelty
or algorithm-complexity claim.

Let ι be a finite decidable index type and ψ a normalized vector in complex
Euclidean space. Matrices use Loewner order and the induced Euclidean operator
norm. Define p(U)=Re⟨Uψ,P Uψ⟩, where U is unitary and 0≤P≤I is an effect.
The order bounds imply ||P||≤1; this is a proved prerequisite rather than an
extra premise of the probability theorem. Unitarity gives ||Uψ||=1, also proved
internally. Positivity gives p(U)≥0; Cauchy–Schwarz and contraction give p(U)≤1.
The literal formula is defined for all matrices; it is claimed to be a
probability only under the displayed effect and normalization hypotheses.

For normalized x,y and a contraction P, split
⟨x,Px⟩−⟨y,Py⟩=⟨x−y,Px⟩+⟨y,P(x−y)⟩.
Cauchy–Schwarz bounds the real-part difference by 2||x−y||. For two unitaries
U,V with ||U−V||≤η, operator action gives ||Uψ−Vψ||≤η, hence
|p(U)−p(V)|≤2η. A separate nonnegative η premise is unnecessary: the error
certificate already forces it. The auxiliary contraction lemma has its own
literal contraction hypothesis; the effect consumer derives that hypothesis.

For lists of primitive circuits of n qubits, use the library's existing
positionwise Aligned δ certificate, δ≥0. This certificate preserves the gate
constructors/wires and bounds corresponding Ry angle errors; it is not an
automatic synthesis theorem. Existing PrimitiveCircuitPerturbation gives
||eval approximate−eval exact||≤length(exact)·δ/2, and PrimitiveSemantics gives
both circuit unitaries. Applying the probability theorem yields effect
probability difference at most length(exact)·δ. Circuit unitarity and operator
perturbation remain genuine proof dependencies, not public hypotheses.

No additional register, garbage, ancilla or tensor identification is introduced.
Global phase is carried literally in matrices, not selected by a quotient or
claimed unique. The existing PrimitiveBasis fixes the circuit register order.
The analytic result requires no oracle access, controls or inverse black box.
No hardware noise law, state-loading cost, shot cost, gate count, physical depth,
finite-bit angle synthesis, runtime or estimator theorem follows from it.

Actual dependencies include Mathlib finite Matrix order/CStar norms, complex
inner products and operator action, and the existing library's
aligned_eval_distance_le and evalPrimitiveCircuit_unitary. The reusable
probability node has actual consumers probability_mem_Icc and
CircuitEffectStability.aligned_probability_difference_le. This contribution
adds canonical Semantics nodes, not a new research route, frontier, categorical
transport, accepted circuit compiler or resource theorem. Unaffected atlas and
progress surfaces remain unchanged with that reason.


## Input source-topology.json; SHA256 ab56da52163b01a6f25a576604902fdd838911128373c7477db04b9e3f175dee

{
  "schema_version": "source-proof-topology/v1",
  "reconstruction": {
    "method": "Independent reconstruction from the specified source-contract.md only; no Lean, formal packets, folded lessons, publication registry, other workspace, or previous research inspected.",
    "authority": "Author-derived reusable library contract; not an asserted external paper theorem.",
    "bounded_exhaustive": true,
    "approval_status": "PENDING_DISTINCT_REVIEW",
    "self_approved": false
  },
  "dependency_semantics": {
    "rule": "Each dependencies array is an AND group: all listed ingredients are used together. Dependencies are proof ingredients, not module-import implications.",
    "node_kinds": [
      "definition",
      "source_assumption",
      "derived_ingredient",
      "statement",
      "ambient_prerequisite"
    ],
    "excluded_rule": "EXCLUDED entries are provenance, scope constraints, or implementation/publication metadata, not theorem conclusions."
  },
  "source": {
    "path": "C:/qb261009/pq/docs/effect-stability/source-contract.md",
    "sha256": "9712de87c5a31f0ad44d217bf1add62280b2a518b8a0a9aae8117f501343050d",
    "version": "1 (2026-10-09)",
    "line_count": 47
  },
  "nodes": [
    {
      "id": "pq.finite_complex_setting",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        7,
        9
      ],
      "statement": "ι is a finite decidable index type; vectors inhabit its complex Euclidean space. Matrices act on that space with Loewner order and induced Euclidean operator norm.",
      "dependencies": []
    },
    {
      "id": "pq.normalized_state",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        7,
        7
      ],
      "statement": "||ψ||=1.",
      "dependencies": [
        "pq.finite_complex_setting"
      ]
    },
    {
      "id": "pq.effect",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        9,
        9
      ],
      "statement": "0≤P≤I in Loewner order.",
      "dependencies": [
        "pq.finite_complex_setting"
      ]
    },
    {
      "id": "pq.unitary_U",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        9,
        11
      ],
      "statement": "U is unitary.",
      "dependencies": [
        "pq.finite_complex_setting"
      ]
    },
    {
      "id": "pq.probability_formula",
      "classification": "NODE",
      "kind": "definition",
      "source_lines": [
        9,
        14
      ],
      "statement": "p_{P,ψ}(M)=Re⟨Mψ,P(Mψ)⟩ for every matrix M.",
      "dependencies": [
        "pq.finite_complex_setting"
      ],
      "domain_note": "The formula does not require normalization, an effect, or unitarity to be defined."
    },
    {
      "id": "pq.order_norm_laws",
      "classification": "NODE",
      "kind": "ambient_prerequisite",
      "source_lines": [
        8,
        12
      ],
      "statement": "Finite-dimensional positive-semidefinite order, its norm consequences, and positivity of the associated quadratic form.",
      "dependencies": [
        "pq.finite_complex_setting"
      ],
      "status": "Standard mathematical ingredients stated in prose; no new external theorem alleged."
    },
    {
      "id": "pq.inner_product_operator_laws",
      "classification": "NODE",
      "kind": "ambient_prerequisite",
      "source_lines": [
        12,
        20
      ],
      "statement": "Sesquilinearity, Re/absolute-value inequalities, Cauchy–Schwarz, the triangle inequality, operator action ||Az||≤||A||||z||, and unitary preservation of Euclidean norm.",
      "dependencies": [
        "pq.finite_complex_setting"
      ],
      "status": "Standard mathematical ingredients needed by the displayed proof."
    },
    {
      "id": "pq.effect_contraction",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        10,
        11
      ],
      "statement": "||P||≤1.",
      "dependencies": [
        "pq.effect",
        "pq.order_norm_laws"
      ],
      "separate_public_premise": false
    },
    {
      "id": "pq.unitary_state_normalization",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        11,
        12
      ],
      "statement": "||Uψ||=1.",
      "dependencies": [
        "pq.normalized_state",
        "pq.unitary_U",
        "pq.inner_product_operator_laws"
      ],
      "separate_public_premise": false
    },
    {
      "id": "pq.probability_nonnegative",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        12,
        12
      ],
      "statement": "p(U)≥0.",
      "dependencies": [
        "pq.probability_formula",
        "pq.effect",
        "pq.order_norm_laws"
      ],
      "proof": "Use positivity of the P quadratic form at Uψ; normalization is not needed for this lower bound."
    },
    {
      "id": "pq.probability_upper_bound",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        12,
        12
      ],
      "statement": "p(U)≤1.",
      "dependencies": [
        "pq.probability_formula",
        "pq.unitary_state_normalization",
        "pq.effect_contraction",
        "pq.inner_product_operator_laws"
      ],
      "proof": "Re⟨Uψ,P(Uψ)⟩≤|⟨Uψ,P(Uψ)⟩|≤||Uψ||||P(Uψ)||≤1."
    },
    {
      "id": "pq.probability_mem_Icc",
      "classification": "NODE",
      "kind": "statement",
      "source_lines": [
        12,
        14
      ],
      "statement": "Under the effect, normalization, and unitary hypotheses, p(U)∈[0,1].",
      "dependencies": [
        "pq.probability_nonnegative",
        "pq.probability_upper_bound"
      ],
      "name_status": "Consumer name explicitly reported by the source; no implementation inspected."
    },
    {
      "id": "pq.aux_normalized_pair",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        16,
        16
      ],
      "statement": "x,y are vectors with ||x||=||y||=1.",
      "dependencies": [
        "pq.finite_complex_setting"
      ],
      "applies_to": [
        "pq.contraction_quadratic_stability"
      ]
    },
    {
      "id": "pq.aux_contraction",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        16,
        22
      ],
      "statement": "P is a contraction: ||P||≤1.",
      "dependencies": [
        "pq.finite_complex_setting"
      ],
      "applies_to": [
        "pq.contraction_quadratic_stability"
      ],
      "effect_required": false
    },
    {
      "id": "pq.quadratic_split",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        16,
        17
      ],
      "statement": "⟨x,Px⟩−⟨y,Py⟩=⟨x−y,Px⟩+⟨y,P(x−y)⟩.",
      "dependencies": [
        "pq.inner_product_operator_laws"
      ],
      "proof": "Expand with sesquilinearity and linearity of matrix action. Normalization and contraction are not needed for this identity."
    },
    {
      "id": "pq.first_split_term_bound",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        18,
        18
      ],
      "statement": "|⟨x−y,Px⟩|≤||x−y||.",
      "dependencies": [
        "pq.aux_normalized_pair",
        "pq.aux_contraction",
        "pq.inner_product_operator_laws"
      ],
      "proof": "Cauchy–Schwarz and ||Px||≤||P||||x||≤1."
    },
    {
      "id": "pq.second_split_term_bound",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        18,
        18
      ],
      "statement": "|⟨y,P(x−y)⟩|≤||x−y||.",
      "dependencies": [
        "pq.aux_normalized_pair",
        "pq.aux_contraction",
        "pq.inner_product_operator_laws"
      ],
      "proof": "Cauchy–Schwarz and ||P(x−y)||≤||x−y||."
    },
    {
      "id": "pq.contraction_quadratic_stability",
      "classification": "NODE",
      "kind": "statement",
      "source_lines": [
        16,
        18
      ],
      "statement": "|Re⟨x,Px⟩−Re⟨y,Py⟩|≤2||x−y||.",
      "dependencies": [
        "pq.quadratic_split",
        "pq.first_split_term_bound",
        "pq.second_split_term_bound",
        "pq.inner_product_operator_laws"
      ],
      "scope": "Auxiliary contraction lemma; its contraction premise is literal. No positivity premise is needed."
    },
    {
      "id": "pq.unitary_V",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        18,
        19
      ],
      "statement": "V is unitary.",
      "dependencies": [
        "pq.finite_complex_setting"
      ]
    },
    {
      "id": "pq.operator_error_certificate",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        19,
        20
      ],
      "statement": "η is real and ||U−V||≤η.",
      "dependencies": [
        "pq.finite_complex_setting"
      ]
    },
    {
      "id": "pq.eta_nonnegative",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        20,
        21
      ],
      "statement": "0≤η follows from the operator error certificate.",
      "dependencies": [
        "pq.operator_error_certificate",
        "pq.inner_product_operator_laws"
      ],
      "separate_public_premise": false
    },
    {
      "id": "pq.unitary_pair_state_normalization",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        18,
        19
      ],
      "statement": "Both Uψ and Vψ are normalized.",
      "dependencies": [
        "pq.normalized_state",
        "pq.unitary_U",
        "pq.unitary_V",
        "pq.inner_product_operator_laws"
      ]
    },
    {
      "id": "pq.state_error_from_operator_error",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        19,
        19
      ],
      "statement": "||Uψ−Vψ||≤η.",
      "dependencies": [
        "pq.normalized_state",
        "pq.operator_error_certificate",
        "pq.inner_product_operator_laws"
      ],
      "proof": "Uψ−Vψ=(U−V)ψ and ||(U−V)ψ||≤||U−V||||ψ||≤η.",
      "unitarity_needed_for_this_step": false
    },
    {
      "id": "pq.effect_probability_stability",
      "classification": "NODE",
      "kind": "statement",
      "source_lines": [
        19,
        22
      ],
      "statement": "|p(U)−p(V)|≤2η.",
      "dependencies": [
        "pq.probability_formula",
        "pq.effect_contraction",
        "pq.unitary_pair_state_normalization",
        "pq.contraction_quadratic_stability",
        "pq.state_error_from_operator_error"
      ],
      "proof": "Instantiate the contraction lemma at x=Uψ,y=Vψ using the effect-derived contraction bound, then substitute the state-error bound.",
      "public_assumptions": [
        "pq.normalized_state",
        "pq.effect",
        "pq.unitary_U",
        "pq.unitary_V",
        "pq.operator_error_certificate"
      ],
      "extra_nonnegative_eta_premise": false
    },
    {
      "id": "pq.primitive_circuit_setting",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        24,
        25
      ],
      "statement": "exact and approximate are lists of primitive circuits on n qubits, on the existing fixed register basis.",
      "dependencies": [],
      "inherits": "Finite complex Euclidean semantics; ψ and P must be on that same register."
    },
    {
      "id": "pq.aligned_certificate",
      "classification": "NODE",
      "kind": "source_assumption",
      "source_lines": [
        24,
        27
      ],
      "statement": "The existing positionwise Aligned δ certificate relates exact and approximate; δ≥0.",
      "dependencies": [
        "pq.primitive_circuit_setting"
      ],
      "certificate_content": "Preserves gate constructors and wires and bounds corresponding Ry-angle errors.",
      "source_status": "A supplied library certificate, not an automatic synthesis result. The explicit δ≥0 premise is retained."
    },
    {
      "id": "pq.existing_perturbation_contract",
      "classification": "NODE",
      "kind": "ambient_prerequisite",
      "source_lines": [
        27,
        28
      ],
      "statement": "Existing PrimitiveCircuitPerturbation / aligned_eval_distance_le yields ||eval approximate−eval exact||≤length(exact)·δ/2 from Aligned δ and δ≥0.",
      "dependencies": [
        "pq.primitive_circuit_setting"
      ],
      "source_status": "Previously existing library theorem as reported by the source. Not independently re-proved or implementation-verified here."
    },
    {
      "id": "pq.existing_unitarity_contract",
      "classification": "NODE",
      "kind": "ambient_prerequisite",
      "source_lines": [
        28,
        29
      ],
      "statement": "Existing PrimitiveSemantics / evalPrimitiveCircuit_unitary yields unitary evaluation of each primitive circuit list.",
      "dependencies": [
        "pq.primitive_circuit_setting"
      ],
      "source_status": "Previously existing library theorem as reported by the source. Not a public assumption about evaluated matrices."
    },
    {
      "id": "pq.circuit_operator_error",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        28,
        28
      ],
      "statement": "||eval approximate−eval exact||≤length(exact)·δ/2.",
      "dependencies": [
        "pq.aligned_certificate",
        "pq.existing_perturbation_contract"
      ]
    },
    {
      "id": "pq.circuit_unitary_pair",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        28,
        29
      ],
      "statement": "eval approximate and eval exact are both unitary.",
      "dependencies": [
        "pq.primitive_circuit_setting",
        "pq.existing_unitarity_contract"
      ]
    },
    {
      "id": "pq.circuit_stability_instantiation",
      "classification": "NODE",
      "kind": "derived_ingredient",
      "source_lines": [
        29,
        30
      ],
      "statement": "|p(eval approximate)−p(eval exact)|≤2(length(exact)·δ/2).",
      "dependencies": [
        "pq.normalized_state",
        "pq.effect",
        "pq.circuit_operator_error",
        "pq.circuit_unitary_pair",
        "pq.effect_probability_stability"
      ],
      "proof": "Instantiate the reusable theorem with U=eval approximate, V=eval exact, η=length(exact)·δ/2."
    },
    {
      "id": "pq.aligned_probability_difference_le",
      "classification": "NODE",
      "kind": "statement",
      "source_lines": [
        29,
        31
      ],
      "statement": "|p(eval approximate)−p(eval exact)|≤length(exact)·δ.",
      "dependencies": [
        "pq.circuit_stability_instantiation"
      ],
      "proof": "Simplify 2(length(exact)·δ/2)=length(exact)·δ in real arithmetic.",
      "public_assumptions": [
        "pq.normalized_state",
        "pq.effect",
        "pq.primitive_circuit_setting",
        "pq.aligned_certificate"
      ],
      "name_status": "Consumer CircuitEffectStability.aligned_probability_difference_le explicitly reported by the source.",
      "internal_proof_dependencies": [
        "pq.circuit_operator_error",
        "pq.circuit_unitary_pair"
      ],
      "resource_claim": false
    },
    {
      "id": "pq.fixed_register_definition",
      "classification": "NODE",
      "kind": "definition",
      "source_lines": [
        33,
        35
      ],
      "statement": "The existing PrimitiveBasis fixes the circuit register order; the same literal matrix register is used throughout.",
      "dependencies": [
        "pq.primitive_circuit_setting"
      ],
      "scope": "Existing ambient definition reported by the prose; no new register/tensor identification is constructed."
    }
  ],
  "exclusions": [
    {
      "id": "pq.title",
      "classification": "EXCLUDED",
      "source_lines": [
        1,
        1
      ],
      "text": "Stability of normalized pure-state effect probabilities",
      "reason": "Title; mathematical content expanded in nodes."
    },
    {
      "id": "pq.provenance",
      "classification": "EXCLUDED",
      "source_lines": [
        3,
        5
      ],
      "text": "Author-derived canonical finite-dimensional mathematical contracts, version/date; reusable library formalization with no novelty or algorithm-complexity claim.",
      "reason": "Provenance and claim scope; no external-paper theorem attribution."
    },
    {
      "id": "pq.probability_domain_guard",
      "classification": "EXCLUDED",
      "source_lines": [
        13,
        14
      ],
      "text": "Formula defined for all matrices but probability claim needs effect and normalization hypotheses.",
      "reason": "Scope guard, represented precisely by the formula definition and interval theorem; no unconditional probability assertion."
    },
    {
      "id": "pq.synthesis_guard",
      "classification": "EXCLUDED",
      "source_lines": [
        26,
        27
      ],
      "text": "Aligned is not an automatic synthesis theorem.",
      "reason": "Scope guard; certificate contents are represented in pq.aligned_certificate."
    },
    {
      "id": "pq.internal_dependency_guard",
      "classification": "EXCLUDED",
      "source_lines": [
        30,
        31
      ],
      "text": "Circuit unitarity and operator perturbation are real dependencies, not public hypotheses.",
      "reason": "Dependency-boundary metadata reflected in circuit derivation nodes."
    },
    {
      "id": "pq.register_and_phase_scope",
      "classification": "EXCLUDED",
      "source_lines": [
        33,
        35
      ],
      "text": "No additional register, garbage, ancilla, or tensor identification; phase is carried literally in matrices without quotient selection or uniqueness.",
      "reason": "Representation/scope guard. The existing fixed register definition is separately represented."
    },
    {
      "id": "pq.oracle_scope",
      "classification": "EXCLUDED",
      "source_lines": [
        36,
        36
      ],
      "text": "No oracle access, controls or inverse black box required.",
      "reason": "Scope guard; no access-model or black-box algorithm theorem follows."
    },
    {
      "id": "pq.resource_scope",
      "classification": "EXCLUDED",
      "source_lines": [
        37,
        38
      ],
      "text": "No hardware noise law, state-loading cost, shot cost, gate count, physical depth, finite-bit angle synthesis, runtime or estimator theorem follows.",
      "reason": "Explicit exclusions of resource/statistical claims; length(exact) is only the coefficient in the stated analytic perturbation bound."
    },
    {
      "id": "pq.implementation_dependency_metadata",
      "classification": "EXCLUDED",
      "source_lines": [
        40,
        42
      ],
      "text": "Mathlib finite Matrix order/CStar norms, complex inner products/operator action; aligned_eval_distance_le and evalPrimitiveCircuit_unitary.",
      "reason": "Source-reported implementation names. Abstract laws and existing theorem contracts are separately represented, without inspecting their implementation."
    },
    {
      "id": "pq.consumer_metadata",
      "classification": "EXCLUDED",
      "source_lines": [
        42,
        44
      ],
      "text": "Reusable probability node consumers probability_mem_Icc and CircuitEffectStability.aligned_probability_difference_le.",
      "reason": "Source-reported consumer metadata. Both mathematical consumer statements are represented; no verified implementation linkage is asserted."
    },
    {
      "id": "pq.publication_scope",
      "classification": "EXCLUDED",
      "source_lines": [
        44,
        47
      ],
      "text": "Canonical Semantics nodes; no new research route/frontier/categorical transport/accepted compiler/resource theorem; atlas/progress surfaces unchanged.",
      "reason": "Publication and scope metadata, not mathematical theorem implications."
    }
  ],
  "coverage": [
    {
      "paragraph_lines": [
        1,
        1
      ],
      "items": [
        "pq.title"
      ]
    },
    {
      "paragraph_lines": [
        3,
        5
      ],
      "items": [
        "pq.provenance"
      ]
    },
    {
      "paragraph_lines": [
        7,
        14
      ],
      "items": [
        "pq.finite_complex_setting",
        "pq.normalized_state",
        "pq.effect",
        "pq.unitary_U",
        "pq.probability_formula",
        "pq.order_norm_laws",
        "pq.inner_product_operator_laws",
        "pq.effect_contraction",
        "pq.unitary_state_normalization",
        "pq.probability_nonnegative",
        "pq.probability_upper_bound",
        "pq.probability_mem_Icc",
        "pq.probability_domain_guard"
      ]
    },
    {
      "paragraph_lines": [
        16,
        22
      ],
      "items": [
        "pq.aux_normalized_pair",
        "pq.aux_contraction",
        "pq.quadratic_split",
        "pq.first_split_term_bound",
        "pq.second_split_term_bound",
        "pq.contraction_quadratic_stability",
        "pq.unitary_V",
        "pq.operator_error_certificate",
        "pq.eta_nonnegative",
        "pq.unitary_pair_state_normalization",
        "pq.state_error_from_operator_error",
        "pq.effect_probability_stability"
      ]
    },
    {
      "paragraph_lines": [
        24,
        31
      ],
      "items": [
        "pq.primitive_circuit_setting",
        "pq.aligned_certificate",
        "pq.existing_perturbation_contract",
        "pq.existing_unitarity_contract",
        "pq.circuit_operator_error",
        "pq.circuit_unitary_pair",
        "pq.circuit_stability_instantiation",
        "pq.aligned_probability_difference_le",
        "pq.synthesis_guard",
        "pq.internal_dependency_guard"
      ]
    },
    {
      "paragraph_lines": [
        33,
        38
      ],
      "items": [
        "pq.fixed_register_definition",
        "pq.register_and_phase_scope",
        "pq.oracle_scope",
        "pq.resource_scope"
      ]
    },
    {
      "paragraph_lines": [
        40,
        47
      ],
      "items": [
        "pq.implementation_dependency_metadata",
        "pq.consumer_metadata",
        "pq.publication_scope"
      ]
    }
  ],
  "boundary_notes": [
    "Auxiliary contraction stability accepts a literal contraction hypothesis. The effect stability consumer must derive that hypothesis from 0≤P≤I.",
    "Existing circuit unitarity and perturbation are proof ingredients and are obtained from their existing contracts, not exposed as arbitrary public hypotheses.",
    "The prose requires δ≥0 explicitly; unlike η, its omission is not licensed by the source.",
    "No phase quotient, register enlargement, probabilistic sampling model, resource theorem, new research novelty, or categorical transport is reconstructed.",
    "The source does not specify an external theorem numbering or exact public Lean declaration signatures. Nodes encode mathematical content only, and reported consumer names retain unverified implementation status."
  ]
}


## Input source-topology-review.json; SHA256 f9254ce10ee704af770d12ab946e806936493de3f67a34ea622f32888d92d4be

{
  "schema_version": "independent-source-topology-review/v1",
  "reviewer_identity": "/root/generic_source_review",
  "run_id": "generic-source-review-20261009-01",
  "anti_anchored": true,
  "review_order": "Raw source-contract and independently extracted source-topology only; completed and saved before inspecting Lean, formal packet, lesson, reconstruction or publication records.",
  "source_sha256": "9712de87c5a31f0ad44d217bf1add62280b2a518b8a0a9aae8117f501343050d",
  "topology_sha256": "ab56da52163b01a6f25a576604902fdd838911128373c7477db04b9e3f175dee",
  "verdict": "accepted",
  "bounded_exhaustive": true,
  "mathematically_valid": true,
  "coverage_review": [
    "Lines 1,3-5: title, canonical author provenance and no-novelty/complexity scope are excluded.",
    "Lines 7-14: finite complex Euclidean setting, normalization, effect order, unitarity, total literal formula, order/norm laws, derived contraction and output normalization, positivity, upper bound and interval statement are represented. The formula domain guard is preserved.",
    "Lines 16-22: normalized auxiliary pair and literal contraction premise, algebraic split, both term bounds and real-part stability are represented. The public effect theorem derives contraction and output normalization, then obtains state error from the operator certificate. Nonnegative eta is a consequence, not an extra premise.",
    "Lines 24-31: fixed-size primitive lists, supplied positionwise Aligned delta with explicit delta >= 0, existing perturbation and unitarity contracts, both derived ingredients and the final length-times-delta consumer are represented. No automatic alignment producer is claimed.",
    "Lines 33-38: fixed register convention and all literal phase, ancilla, oracle, hardware/statistical and finite-bit/resource exclusions are accounted for.",
    "Lines 40-47: named implementation ingredients and actual consumers are reported metadata; canonical publication boundary and unchanged atlas/progress scope are excluded."
  ],
  "mathematical_review": "The quadratic split follows by additivity of each inner-product slot and linear operator action. Each term has absolute value at most ||x-y|| by Cauchy-Schwarz, unit norms and contraction. Effect order 0 <= P <= I entails contraction; normalized unitary outputs then give the 2 eta bound from ||(U-V)psi|| <= eta. Positive quadratic forms give the lower probability bound and contraction gives the upper bound. Existing aligned circuit perturbation at eta=length(exact)*delta/2 and derived circuit unitarity give length(exact)*delta by real arithmetic.",
  "dependency_review": "All dependency identifiers resolve. Public effect premises are distinct from derived contraction/output normalization. Public circuit premises are distinct from derived circuit unitarity/operator perturbation. Each AND group is coherent; all nonblank source paragraphs, constants, representations and exclusions are covered.",
  "blockers": [],
  "limits": "Acceptance applies only to source-faithful mathematical topology at these hashes; no Lean correctness, existing-library implementation or chronology verdict is included."
}


## Input formal-packet.md; SHA256 c6c79553a91e29828c247e8989caf07a64eb4bbff2554d0f40e15f3cf6b02705

```lean
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Tactic


namespace QuantumBlockEncoding.BornStability

open scoped InnerProductSpace Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

noncomputable def probability (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : ℝ :=
  (inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
    (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re

set_option maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in

theorem effect_norm_le_one (P : Matrix ι ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    ‖P‖ ≤ 1 :=
  by
    letI : CStarAlgebra (Matrix ι ι ℂ) := {}
    exact (CStarAlgebra.norm_le_one_iff_of_nonneg (A := Matrix ι ι ℂ) P hP).mpr hPI

theorem unitary_norm_map (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (ψ : EuclideanSpace ℂ ι) :
    ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ‖ = ‖ψ‖ :=
  ContinuousLinearMap.norm_map_of_mem_unitary
    (Unitary.map_mem (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := ι)) hU) ψ


theorem quadratic_difference_le {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] (P : E →L[ℂ] E) (hP : ‖P‖ ≤ 1)
    (x y : E) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    |(inner ℂ x (P x)).re - (inner ℂ y (P y)).re| ≤ 2 * ‖x - y‖ := by
  have split : inner ℂ x (P x) - inner ℂ y (P y) =
      inner ℂ (x - y) (P x) + inner ℂ y (P (x - y)) := by
    simp only [map_sub, inner_sub_left, inner_sub_right]
    ring
  have hPx : ‖P x‖ ≤ 1 := by
    calc
      ‖P x‖ ≤ ‖P‖ * ‖x‖ := P.le_opNorm x
      _ ≤ 1 := by simpa [hx] using hP
  have hPxy : ‖P (x - y)‖ ≤ ‖x - y‖ := by
    calc
      _ ≤ ‖P‖ * ‖x - y‖ := P.le_opNorm _
      _ ≤ ‖x - y‖ := by nlinarith [norm_nonneg (x - y)]
  calc
    _ = |(inner ℂ x (P x) - inner ℂ y (P y)).re| := by simp
    _ ≤ ‖inner ℂ x (P x) - inner ℂ y (P y)‖ := Complex.abs_re_le_norm _
    _ ≤ ‖inner ℂ (x - y) (P x)‖ + ‖inner ℂ y (P (x - y))‖ := by
      rw [split]; exact norm_add_le _ _
    _ ≤ ‖x - y‖ * ‖P x‖ + ‖y‖ * ‖P (x - y)‖ :=
      add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _)
    _ ≤ 2 * ‖x - y‖ := by rw [hy]; nlinarith [norm_nonneg (x - y)]


theorem probability_difference_le (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |probability U P ψ - probability V P ψ| ≤ 2 * η := by
  have hPc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
    rw [Matrix.l2_opNorm_toEuclideanCLM]
    exact effect_norm_le_one P hP hPI
  have hd : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ - Matrix.toEuclideanCLM (𝕜 := ℂ) V ψ‖ ≤ η := by
    calc
      _ = ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V) ψ‖ := by simp
      _ ≤ ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)‖ * ‖ψ‖ :=
        (Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)).le_opNorm ψ
      _ ≤ η := by
        rw [hψ, mul_one, Matrix.l2_opNorm_toEuclideanCLM]
        exact hUV
  exact (quadratic_difference_le _ hPc _ _
    (by rw [unitary_norm_map U hU, hψ])
    (by rw [unitary_norm_map V hV, hψ])).trans (by linarith)



theorem probability_mem_Icc (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    probability U P ψ ∈ Set.Icc (0 : ℝ) 1 := by
  let x := Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ
  have hx : ‖x‖ = 1 := (unitary_norm_map U hU ψ).trans hψ
  have hpos : (Matrix.toEuclideanCLM (𝕜 := ℂ) P).IsPositive := by
    apply (ContinuousLinearMap.isPositive_toLinearMap_iff _).mp
    rw [Matrix.coe_toEuclideanCLM_eq_toEuclideanLin, Matrix.isPositive_toEuclideanLin_iff]
    exact Matrix.nonneg_iff_posSemidef.mp hP
  refine ⟨hpos.re_inner_nonneg_right x, ?_⟩
  change (inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)).re ≤ 1
  calc
    _ ≤ ‖inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)‖ := Complex.re_le_norm _
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P x‖ := norm_inner_le_norm _ _
    _ ≤ 1 := by
      have hc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
        rw [Matrix.l2_opNorm_toEuclideanCLM]
        exact effect_norm_le_one P hP hPI
      have := (Matrix.toEuclideanCLM (𝕜 := ℂ) P).le_opNorm x
      rw [hx, one_mul]
      rw [hx] at this
      simpa using this.trans (by simpa using hc)

end QuantumBlockEncoding.BornStability
```
```lean
import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation


theorem aligned_probability_difference_le {n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    (exact approximate : PrimitiveCircuit n) (ha : Aligned δ exact approximate)
    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
      BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
        (exact.length : ℝ) * δ := by
  have h := BornStability.probability_difference_le
    (evalPrimitiveCircuit approximate) (evalPrimitiveCircuit exact) P ψ hψ
    (evalPrimitiveCircuit_unitary approximate) (evalPrimitiveCircuit_unitary exact)
    hP hPI (aligned_eval_distance_le hδ ha)
  convert h using 1; ring

end QuantumBlockEncoding.CircuitEffectStability
```

```lean
import QuantumBlockEncoding.Resources
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Lattice.Fold



namespace QuantumBlockEncoding

inductive ExactAngle where
  | rational (value : Rat)
  | piRational (value : Rat)
  | twiceArccosRational (value : Rat)
      (bounded : |(value : Real)| ≤ 1)
  | twiceArccosSqrtRational (value : Rat)
      (bounded : 0 ≤ (value : Real) ∧ (value : Real) ≤ 1)

  | real (value : Real)
  | add (left right : ExactAngle)
  | neg (value : ExactAngle)
  | scale (factor : Rat) (value : ExactAngle)

private def exactAngleRepr : ExactAngle → Nat → Std.Format
  | .rational value, p => reprPrec value p
  | .piRational value, p => "pi * " ++ reprPrec value p
  | .twiceArccosRational value _, p => "2 * arccos " ++ reprPrec value p
  | .twiceArccosSqrtRational value _, p => "2 * arccos sqrt " ++ reprPrec value p
  | .real _, _ => "<exact real angle; numerical export required>"
  | .add left right, p => "(" ++ exactAngleRepr left p ++ " + " ++ exactAngleRepr right p ++ ")"
  | .neg value, p => "-(" ++ exactAngleRepr value p ++ ")"
  | .scale factor value, p => reprPrec factor p ++ " * (" ++ exactAngleRepr value p ++ ")"

instance : Repr ExactAngle := ⟨exactAngleRepr⟩

namespace ExactAngle

noncomputable def eval : ExactAngle → Real
  | .rational value => (value : Real)
  | .piRational value => Real.pi * (value : Real)
  | .twiceArccosRational value _ => 2 * Real.arccos (value : Real)
  | .twiceArccosSqrtRational value _ =>
      2 * Real.arccos (Real.sqrt (value : Real))
  | .real value => value
  | .add left right => left.eval + right.eval
  | .neg value => -value.eval
  | .scale factor value => (factor : Real) * value.eval

@[simp] theorem eval_add (left right : ExactAngle) :
    (add left right).eval = left.eval + right.eval := rfl

@[simp] theorem eval_neg (value : ExactAngle) :
    (neg value).eval = -value.eval := rfl

@[simp] theorem eval_scale (factor : Rat) (value : ExactAngle) :
    (scale factor value).eval = (factor : Real) * value.eval := rfl

def sub (left right : ExactAngle) : ExactAngle :=
  add left (neg right)

def halfAdd (left right : ExactAngle) : ExactAngle :=
  scale (1 / 2) (add left right)

def halfSub (left right : ExactAngle) : ExactAngle :=
  scale (1 / 2) (sub left right)

@[simp] theorem eval_sub (left right : ExactAngle) :
    (sub left right).eval = left.eval - right.eval := by
  simp [sub, sub_eq_add_neg]

@[simp] theorem eval_half_add (left right : ExactAngle) :
    (halfAdd left right).eval = (left.eval + right.eval) / 2 := by
  simp only [halfAdd, eval_scale, eval_add]
  have halfCast : (((1 / 2 : Rat) : Real)) = (1 : Real) / 2 := by norm_num
  rw [halfCast]
  ring

@[simp] theorem eval_half_sub (left right : ExactAngle) :
    (halfSub left right).eval = (left.eval - right.eval) / 2 := by
  simp only [halfSub, eval_scale, eval_sub]
  have halfCast : (((1 / 2 : Rat) : Real)) = (1 : Real) / 2 := by norm_num
  rw [halfCast]
  ring

end ExactAngle

inductive PrimitiveGate (qubits : Nat) where
  | x (target : Fin qubits)
  | ry (target : Fin qubits) (angle : ExactAngle)
  | rz (target : Fin qubits) (angle : ExactAngle)
  | cx (control target : Fin qubits) (distinct : control ≠ target)

abbrev PrimitiveCircuit (qubits : Nat) := List (PrimitiveGate qubits)


structure PrimitiveProgram (qubits : Nat) where
  circuit : PrimitiveCircuit qubits
  globalPhase : ExactAngle

namespace PrimitiveGate

def dagger {qubits : Nat} : PrimitiveGate qubits → PrimitiveGate qubits
  | .x target => .x target
  | .ry target angle => .ry target (.neg angle)
  | .rz target angle => .rz target (.neg angle)
  | .cx control target distinct => .cx control target distinct

def touched {qubits : Nat} : PrimitiveGate qubits → Finset (Fin qubits)
  | .x target | .ry target _ | .rz target _ => {target}
  | .cx control target _ => {control, target}

def oneQubitCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .x _ | .ry _ _ | .rz _ _ => 1
  | .cx _ _ _ => 0

def twoQubitCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .cx _ _ _ => 1
  | _ => 0

end PrimitiveGate

namespace PrimitiveCircuit

def gateCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.length

def oneQubitCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.oneQubitCount) 0

def twoQubitCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.twoQubitCount) 0

def ryCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.countP fun gate => match gate with
    | .ry _ _ => true
    | _ => false

def cxCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.countP fun gate => match gate with
    | .cx _ _ _ => true
    | _ => false

@[simp] theorem ryCount_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    (left ++ right).ryCount = left.ryCount + right.ryCount := by
  simp [ryCount]

@[simp] theorem cxCount_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    (left ++ right).cxCount = left.cxCount + right.cxCount := by
  simp [cxCount]

@[simp] theorem ryCount_singleton_ry {qubits : Nat}
    (target : Fin qubits) (angle : ExactAngle) :
    ryCount ([PrimitiveGate.ry target angle] : PrimitiveCircuit qubits) = 1 := by
  rfl

@[simp] theorem ryCount_singleton_cx {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    ryCount ([PrimitiveGate.cx control target distinct] : PrimitiveCircuit qubits) = 0 := by
  rfl

@[simp] theorem cxCount_singleton_ry {qubits : Nat}
    (target : Fin qubits) (angle : ExactAngle) :
    cxCount ([PrimitiveGate.ry target angle] : PrimitiveCircuit qubits) = 0 := by
  rfl

@[simp] theorem cxCount_singleton_cx {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    cxCount ([PrimitiveGate.cx control target distinct] : PrimitiveCircuit qubits) = 1 := by
  rfl

def nextWireDepth {qubits : Nat} (depth : Fin qubits → Nat)
    (gate : PrimitiveGate qubits) : Fin qubits → Nat :=
  let layer := gate.touched.sup depth
  fun wire => if wire ∈ gate.touched then layer + 1 else depth wire

def wireDepths {qubits : Nat} (circuit : PrimitiveCircuit qubits) :
    Fin qubits → Nat :=
  circuit.foldl nextWireDepth (fun _ => 0)

def depth {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  Finset.univ.sup circuit.wireDepths

def resource {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Resource :=
  Resource.ofCountsWithDepth circuit.oneQubitCount circuit.twoQubitCount
    0 0 circuit.depth

@[simp] theorem gateCount_eq_length {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    circuit.gateCount = circuit.length := rfl

@[simp] theorem resource_oracleCalls_eq_zero {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    circuit.resource.oracleCalls = 0 := rfl

end PrimitiveCircuit

namespace PrimitiveProgram

def identity (qubits : Nat) : PrimitiveProgram qubits where
  circuit := []
  globalPhase := .rational 0


def seq {qubits : Nat} (left right : PrimitiveProgram qubits) :
    PrimitiveProgram qubits where
  circuit := left.circuit ++ right.circuit
  globalPhase := .add left.globalPhase right.globalPhase

def dagger {qubits : Nat} (program : PrimitiveProgram qubits) :
    PrimitiveProgram qubits where
  circuit := program.circuit.reverse.map PrimitiveGate.dagger
  globalPhase := .neg program.globalPhase

def resource {qubits : Nat} (program : PrimitiveProgram qubits) : Resource :=
  program.circuit.resource

end PrimitiveProgram

end QuantumBlockEncoding

```

```lean
import QuantumBlockEncoding.PrimitiveCircuit
import QuantumBlockEncoding.Robin.Hadamard8Verified
import Mathlib.Tactic



namespace QuantumBlockEncoding

open QuantumBlockEncoding.Robin.ComplexLCU
open scoped Kronecker


noncomputable def standardRyMatrix (theta : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  realRotation (theta / 2)

@[simp] theorem standardRyMatrix_zero : standardRyMatrix 0 = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [standardRyMatrix, realRotation, realOrthogonalRotation]


theorem standardRyMatrix_add (left right : Real) :
    standardRyMatrix (left + right) =
      standardRyMatrix right * standardRyMatrix left := by
  have halfAdd : (left + right) / 2 = left / 2 + right / 2 := by ring
  rw [standardRyMatrix, halfAdd]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [standardRyMatrix, realRotation, realOrthogonalRotation,
      _root_.Matrix.mul_apply, Fin.sum_univ_two,
      Real.sin_add, Real.cos_add] <;> ring

@[simp] theorem star_complex_cos_ofReal (theta : Real) :
    star (Complex.cos (theta : ℂ)) = Complex.cos (theta : ℂ) := by
  rw [← Complex.ofReal_cos, Complex.star_def, Complex.conj_ofReal]

@[simp] theorem conj_complex_cos_ofReal (theta : Real) :
    (starRingEnd ℂ) (Complex.cos (theta : ℂ)) =
      Complex.cos (theta : ℂ) := by
  rw [← Complex.ofReal_cos, Complex.conj_ofReal]

@[simp] theorem star_complex_sin_ofReal (theta : Real) :
    star (Complex.sin (theta : ℂ)) = Complex.sin (theta : ℂ) := by
  rw [← Complex.ofReal_sin, Complex.star_def, Complex.conj_ofReal]

@[simp] theorem conj_complex_sin_ofReal (theta : Real) :
    (starRingEnd ℂ) (Complex.sin (theta : ℂ)) =
      Complex.sin (theta : ℂ) := by
  rw [← Complex.ofReal_sin, Complex.conj_ofReal]

theorem complex_ofReal_div_two (theta : Real) :
    (theta : ℂ) / 2 = ((theta / 2 : Real) : ℂ) := by
  norm_num

@[simp] theorem conj_complex_cos_ofReal_div_two (theta : Real) :
    (starRingEnd ℂ) (Complex.cos ((theta : ℂ) / 2)) =
      Complex.cos ((theta : ℂ) / 2) := by
  rw [complex_ofReal_div_two, ← Complex.ofReal_cos, Complex.conj_ofReal]

@[simp] theorem conj_complex_sin_ofReal_div_two (theta : Real) :
    (starRingEnd ℂ) (Complex.sin ((theta : ℂ) / 2)) =
      Complex.sin ((theta : ℂ) / 2) := by
  rw [complex_ofReal_div_two, ← Complex.ofReal_sin, Complex.conj_ofReal]

@[simp] theorem standardRyMatrix_neg (theta : Real) :
    standardRyMatrix (-theta) = star (standardRyMatrix theta) := by
  change realRotation (-theta / 2) = star (realRotation (theta / 2))
  rw [show -theta / 2 = -(theta / 2) by ring]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [realRotation, realOrthogonalRotation]


def xMatrix : _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  if row = column then 0 else 1

theorem xMatrix_conjugates_standardRy (theta : Real) :
    xMatrix * standardRyMatrix theta * xMatrix = standardRyMatrix (-theta) := by
  rw [standardRyMatrix_neg]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [xMatrix, standardRyMatrix, realRotation, realOrthogonalRotation,
      _root_.Matrix.mul_apply, Fin.sum_univ_two]

theorem standardRyMatrix_unitary (theta : Real) :
    standardRyMatrix theta ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  realRotation_unitary _


theorem standardRyMatrix_two_arccos_eq_amplitudeRotation
    (coefficient : Real) (_lower : -1 ≤ coefficient)
    (_upper : coefficient ≤ 1) :
    standardRyMatrix (2 * Real.arccos coefficient) =
      amplitudeRotation coefficient := by
  unfold standardRyMatrix amplitudeRotation
  congr 1
  ring


theorem standardRyMatrix_pi_div_two_eq_warmRobinUniformBitPrepare :
    standardRyMatrix (Real.pi / 2) =
      QuantumBlockEncoding.Robin.warmRobinUniformBitPrepare := by
  have half : (Real.pi / 2) / 2 = Real.pi / 4 := by ring
  unfold standardRyMatrix
  rw [half]
  unfold realRotation QuantumBlockEncoding.Robin.warmRobinUniformBitPrepare
  rw [Real.cos_pi_div_four, Real.sin_pi_div_four]


abbrev PrimitiveBasis (qubits : Nat) := Fin qubits → Fin 2

def flipBit (bit : Fin 2) : Fin 2 := if bit = 0 then 1 else 0

@[simp] theorem flipBit_flipBit (bit : Fin 2) : flipBit (flipBit bit) = bit := by
  fin_cases bit <;> rfl

def xBasisAction {qubits : Nat} (target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  Function.update state target (flipBit (state target))

theorem xBasisAction_involutive {qubits : Nat} (target : Fin qubits) :
    Function.Involutive (xBasisAction target) := by
  intro state
  funext wire
  by_cases same : wire = target
  · subst wire
    simp [xBasisAction]
  · simp [xBasisAction, same]

def xBasisEquiv {qubits : Nat} (target : Fin qubits) :
    PrimitiveBasis qubits ≃ PrimitiveBasis qubits where
  toFun := xBasisAction target
  invFun := xBasisAction target
  left_inv := xBasisAction_involutive target
  right_inv := xBasisAction_involutive target

def cxBasisAction {qubits : Nat} (control target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  if state control = 0 then state else xBasisAction target state

theorem cxBasisAction_involutive {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    Function.Involutive (cxBasisAction control target) := by
  intro state
  by_cases controlZero : state control = 0
  · simp [cxBasisAction, controlZero]
  · have controlUnchanged : xBasisAction target state control = state control := by
      simp [xBasisAction, distinct]
    simp [cxBasisAction, controlZero, controlUnchanged,
      xBasisAction_involutive target state]

def cxBasisEquiv {qubits : Nat} (control target : Fin qubits)
    (distinct : control ≠ target) :
    PrimitiveBasis qubits ≃ PrimitiveBasis qubits where
  toFun := cxBasisAction control target
  invFun := cxBasisAction control target
  left_inv := cxBasisAction_involutive control target distinct
  right_inv := cxBasisAction_involutive control target distinct

abbrev OtherPrimitiveWires {qubits : Nat} (target : Fin qubits) :=
  {wire : Fin qubits // wire ≠ target}

def splitPrimitiveWire {qubits : Nat} (target : Fin qubits) :
    PrimitiveBasis qubits ≃
      Fin 2 × (OtherPrimitiveWires target → Fin 2) where
  toFun state := (state target, fun wire => state wire.1)
  invFun pair wire :=
    if same : wire = target then pair.1 else pair.2 ⟨wire, same⟩
  left_inv state := by
    funext wire
    by_cases same : wire = target
    · subst wire
      simp
    · simp [same]
  right_inv pair := by
    rcases pair with ⟨targetBit, otherBits⟩
    apply Prod.ext
    · simp
    · funext wire
      simp [wire.property]

theorem splitPrimitiveWire_other_apply {qubits : Nat}
    (target : Fin qubits) (state : PrimitiveBasis qubits)
    (wire : OtherPrimitiveWires target) :
    (splitPrimitiveWire target state).2 wire = state wire.1 := rfl


noncomputable def liftPrimitiveOneQubit {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (splitPrimitiveWire target).symm
    (gate ⊗ₖ (1 : _root_.Matrix
      (OtherPrimitiveWires target → Fin 2)
      (OtherPrimitiveWires target → Fin 2) ℂ))

@[simp] theorem liftPrimitiveOneQubit_apply {qubits : Nat}
    (target : Fin qubits) (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ)
    (row column : PrimitiveBasis qubits) :
    liftPrimitiveOneQubit target gate row column =
      if (splitPrimitiveWire target row).2 =
          (splitPrimitiveWire target column).2 then
        gate (row target) (column target)
      else 0 := by
  simp only [liftPrimitiveOneQubit, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    _root_.Matrix.kroneckerMap_apply, _root_.Matrix.one_apply,
    Equiv.symm_symm]
  by_cases contextsEqual :
      (splitPrimitiveWire target row).2 =
        (splitPrimitiveWire target column).2
  · simp [contextsEqual, splitPrimitiveWire]
  · simp [contextsEqual, splitPrimitiveWire]

theorem liftPrimitiveOneQubit_unitary {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ)
    (unitary : gate ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ) :
    liftPrimitiveOneQubit target gate ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  apply reindex_unitary
  apply _root_.Matrix.kronecker_mem_unitary
  · exact unitary
  · exact (_root_.Matrix.unitaryGroup
      (OtherPrimitiveWires target → Fin 2) ℂ).one_mem


noncomputable def standardRzMatrix (theta : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  if row = column then
    if row = 0 then
      (Real.cos (theta / 2) : ℂ) - (Real.sin (theta / 2) : ℂ) * Complex.I
    else
      (Real.cos (theta / 2) : ℂ) + (Real.sin (theta / 2) : ℂ) * Complex.I
  else 0

theorem standardRzMatrix_unitary (theta : Real) :
    standardRzMatrix theta ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ := by
  let c := Real.cos (theta / 2)
  let s := Real.sin (theta / 2)
  have trig : s ^ 2 + c ^ 2 = 1 := by
    simp [c, s, Real.sin_sq_add_cos_sq]
  have minusNorm :
      star ((c : ℂ) - (s : ℂ) * Complex.I) *
          ((c : ℂ) - (s : ℂ) * Complex.I) = 1 := by
    apply Complex.ext <;> simp <;> nlinarith
  have plusNorm :
      star ((c : ℂ) + (s : ℂ) * Complex.I) *
          ((c : ℂ) + (s : ℂ) * Complex.I) = 1 := by
    apply Complex.ext <;> simp <;> nlinarith
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  ext row column
  fin_cases row <;> fin_cases column
  · simpa [standardRzMatrix, _root_.Matrix.mul_apply, c, s] using minusNorm
  · simp [standardRzMatrix, _root_.Matrix.mul_apply]
  · simp [standardRzMatrix, _root_.Matrix.mul_apply]
  · simpa [standardRzMatrix, _root_.Matrix.mul_apply, c, s] using plusNorm

@[simp] theorem standardRzMatrix_neg (theta : Real) :
    standardRzMatrix (-theta) = star (standardRzMatrix theta) := by
  ext row column
  fin_cases row <;> fin_cases column
  · change
      (Real.cos (-theta / 2) : ℂ) -
          (Real.sin (-theta / 2) : ℂ) * Complex.I =
        star ((Real.cos (theta / 2) : ℂ) -
          (Real.sin (theta / 2) : ℂ) * Complex.I)
    rw [show -theta / 2 = -(theta / 2) by ring,
      Real.cos_neg, Real.sin_neg]
    simp
  · simp [standardRzMatrix, _root_.Matrix.star_apply]
  · simp [standardRzMatrix, _root_.Matrix.star_apply]
  · change
      (Real.cos (-theta / 2) : ℂ) +
          (Real.sin (-theta / 2) : ℂ) * Complex.I =
        star ((Real.cos (theta / 2) : ℂ) +
          (Real.sin (theta / 2) : ℂ) * Complex.I)
    rw [show -theta / 2 = -(theta / 2) by ring,
      Real.cos_neg, Real.sin_neg]
    simp

theorem star_equivPermutationMatrix
    {index : Type*} [Fintype index] [DecidableEq index]
    (equiv : index ≃ index) :
    star (equivPermutationMatrix equiv) =
      equivPermutationMatrix equiv.symm := by
  ext row column
  rw [_root_.Matrix.star_apply]
  simp only [equivPermutationMatrix]
  by_cases hit : column = equiv row
  · have reverseHit : row = equiv.symm column := by
      simpa using (congrArg equiv.symm hit).symm
    rw [if_pos hit, if_pos reverseHit]
    exact star_one ℂ
  · have reverseMiss : row ≠ equiv.symm column := by
      intro reverseHit
      apply hit
      simpa using (congrArg equiv reverseHit).symm
    rw [if_neg hit, if_neg reverseMiss]
    exact star_zero ℂ

theorem star_liftPrimitiveOneQubit {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    star (liftPrimitiveOneQubit target gate) =
      liftPrimitiveOneQubit target (star gate) := by
  ext row column
  simp only [liftPrimitiveOneQubit, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    _root_.Matrix.star_apply, _root_.Matrix.kroneckerMap_apply,
    _root_.Matrix.one_apply, Equiv.symm_symm]
  by_cases otherEqual :
      (splitPrimitiveWire target row).2 = (splitPrimitiveWire target column).2
  · rw [if_pos otherEqual.symm, if_pos otherEqual, StarMul.star_mul,
      star_one, one_mul, mul_one]
  · rw [if_neg (Ne.symm otherEqual), if_neg otherEqual, mul_zero,
      star_zero, mul_zero]


noncomputable def evalPrimitiveGate {qubits : Nat} : PrimitiveGate qubits →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | .x target => equivPermutationMatrix (xBasisEquiv target)
  | .ry target angle => liftPrimitiveOneQubit target (standardRyMatrix angle.eval)
  | .rz target angle => liftPrimitiveOneQubit target (standardRzMatrix angle.eval)
  | .cx control target distinct =>
      equivPermutationMatrix (cxBasisEquiv control target distinct)

theorem evalPrimitiveGate_unitary {qubits : Nat} (gate : PrimitiveGate qubits) :
    evalPrimitiveGate gate ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  cases gate with
  | x target => exact equivPermutationMatrix_unitary _
  | ry target angle =>
      exact liftPrimitiveOneQubit_unitary target _ (standardRyMatrix_unitary _)
  | rz target angle =>
      exact liftPrimitiveOneQubit_unitary target _ (standardRzMatrix_unitary _)
  | cx control target distinct => exact equivPermutationMatrix_unitary _

theorem xBasisEquiv_symm {qubits : Nat} (target : Fin qubits) :
    (xBasisEquiv target).symm = xBasisEquiv target := by
  rfl

theorem cxBasisEquiv_symm {qubits : Nat} (control target : Fin qubits)
    (distinct : control ≠ target) :
    (cxBasisEquiv control target distinct).symm =
      cxBasisEquiv control target distinct := by
  rfl

theorem evalPrimitiveGate_dagger {qubits : Nat}
    (gate : PrimitiveGate qubits) :
    evalPrimitiveGate gate.dagger = star (evalPrimitiveGate gate) := by
  cases gate with
  | x target =>
      rw [evalPrimitiveGate, PrimitiveGate.dagger,
        star_equivPermutationMatrix, xBasisEquiv_symm]
      rfl
  | ry target angle =>
      simp only [PrimitiveGate.dagger, evalPrimitiveGate, ExactAngle.eval_neg,
        standardRyMatrix_neg]
      rw [star_liftPrimitiveOneQubit]
  | rz target angle =>
      simp only [PrimitiveGate.dagger, evalPrimitiveGate, ExactAngle.eval_neg,
        standardRzMatrix_neg]
      rw [star_liftPrimitiveOneQubit]
  | cx control target distinct =>
      rw [evalPrimitiveGate, PrimitiveGate.dagger,
        star_equivPermutationMatrix, cxBasisEquiv_symm]
      rfl


noncomputable def evalPrimitiveCircuit {qubits : Nat} : PrimitiveCircuit qubits →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | [] => 1
  | gate :: rest => evalPrimitiveCircuit rest * evalPrimitiveGate gate

theorem evalPrimitiveCircuit_unitary {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit circuit ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  induction circuit with
  | nil => exact (_root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ).one_mem
  | cons gate rest induction =>
      exact (_root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ).mul_mem
        induction (evalPrimitiveGate_unitary gate)

theorem evalPrimitiveCircuit_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit (left ++ right) =
      evalPrimitiveCircuit right * evalPrimitiveCircuit left := by
  induction left with
  | nil => simp [evalPrimitiveCircuit]
  | cons gate rest induction =>
      simp only [List.cons_append, evalPrimitiveCircuit]
      rw [induction]
      simp [mul_assoc]

theorem evalPrimitiveCircuit_dagger {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit (circuit.reverse.map PrimitiveGate.dagger) =
      star (evalPrimitiveCircuit circuit) := by
  induction circuit with
  | nil => simp [evalPrimitiveCircuit]
  | cons gate rest induction =>
      simp only [List.reverse_cons, List.map_append, List.map_singleton,
        evalPrimitiveCircuit_append, evalPrimitiveCircuit]
      rw [induction, evalPrimitiveGate_dagger]
      simp


noncomputable def evalGlobalPhase (angle : ExactAngle) : ℂ :=
  Complex.exp ((angle.eval : ℂ) * Complex.I)

theorem evalGlobalPhase_unitary (angle : ExactAngle) :
    evalGlobalPhase angle ∈ unitary ℂ := by
  unfold evalGlobalPhase
  rw [Unitary.mem_iff]
  constructor
  · change (starRingEnd ℂ)
        (Complex.exp ((angle.eval : ℂ) * Complex.I)) * _ = 1
    rw [← Complex.exp_conj, ← Complex.exp_add]
    simp
  · change _ * (starRingEnd ℂ)
        (Complex.exp ((angle.eval : ℂ) * Complex.I)) = 1
    rw [← Complex.exp_conj, ← Complex.exp_add]
    simp

@[simp] theorem evalGlobalPhase_neg (angle : ExactAngle) :
    evalGlobalPhase (.neg angle) = star (evalGlobalPhase angle) := by
  unfold evalGlobalPhase
  rw [ExactAngle.eval_neg, Complex.star_def, ← Complex.exp_conj]
  congr 2
  simp


noncomputable def evalPrimitiveProgram {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ :=
  evalGlobalPhase program.globalPhase • evalPrimitiveCircuit program.circuit

@[simp] theorem evalPrimitiveProgram_identity (qubits : Nat) :
    evalPrimitiveProgram (PrimitiveProgram.identity qubits) = 1 := by
  simp [evalPrimitiveProgram, evalGlobalPhase, PrimitiveProgram.identity,
    evalPrimitiveCircuit, ExactAngle.eval]

theorem evalPrimitiveProgram_seq {qubits : Nat}
    (left right : PrimitiveProgram qubits) :
    evalPrimitiveProgram (PrimitiveProgram.seq left right) =
      evalPrimitiveProgram right * evalPrimitiveProgram left := by
  simp only [evalPrimitiveProgram, PrimitiveProgram.seq,
    ExactAngle.eval_add, evalPrimitiveCircuit_append, evalGlobalPhase]
  rw [Complex.ofReal_add, add_mul, Complex.exp_add]
  ext row column
  simp only [_root_.Matrix.smul_apply, _root_.Matrix.mul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro wire _
  ring

theorem evalPrimitiveProgram_unitary {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    evalPrimitiveProgram program ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  exact Unitary.smul_mem_of_mem (evalGlobalPhase_unitary program.globalPhase)
    (evalPrimitiveCircuit_unitary program.circuit)

theorem evalPrimitiveProgram_dagger {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    evalPrimitiveProgram program.dagger = star (evalPrimitiveProgram program) := by
  change evalGlobalPhase (.neg program.globalPhase) •
      evalPrimitiveCircuit
        (program.circuit.reverse.map PrimitiveGate.dagger) =
    star (evalGlobalPhase program.globalPhase •
      evalPrimitiveCircuit program.circuit)
  rw [evalGlobalPhase_neg, evalPrimitiveCircuit_dagger]
  simp


structure PrimitiveRefinement (qubits : Nat) where
  circuit : PrimitiveCircuit qubits
  target : _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  exact : evalPrimitiveCircuit circuit = target

end QuantumBlockEncoding

```

```lean
import QuantumBlockEncoding.PrimitiveRyPerturbation
import QuantumBlockEncoding.ConstructiveHermitePreparation
import Mathlib.Data.List.Forall2


namespace QuantumBlockEncoding.PrimitiveCircuitPerturbation
open PrimitiveRyPerturbation
open scoped Matrix.Norms.L2Operator

inductive GateAligned {qubits : ℕ} (δ : ℝ) : PrimitiveGate qubits → PrimitiveGate qubits → Prop
  | unchanged (gate : PrimitiveGate qubits) : GateAligned δ gate gate
  | ry (target : Fin qubits) (a b : ExactAngle) (error : |a.eval - b.eval| ≤ δ) :
      GateAligned δ (.ry target a) (.ry target b)


def Aligned {qubits : ℕ} (δ : ℝ) (exact approximate : PrimitiveCircuit qubits) : Prop :=
  List.Forall₂ (GateAligned δ) exact approximate


end QuantumBlockEncoding.PrimitiveCircuitPerturbation

```


## Input lesson.md; SHA256 05bbd2e5eabdb17aff438cc504d5650b04e32c8ff0a01b8585b53f749efff539

# Stability of normalized pure-state effect probabilities

Source: author-derived canonical finite-dimensional mathematical contracts,
version 1 (2026-10-09). This is a reusable library formalization, with no novelty
or algorithm-complexity claim.

Let ι be a finite decidable index type and ψ a normalized vector in complex
Euclidean space. Matrices use Loewner order and the induced Euclidean operator
norm. Define p(U)=Re⟨Uψ,P Uψ⟩, where U is unitary and 0≤P≤I is an effect.
The order bounds imply ||P||≤1; this is a proved prerequisite rather than an
extra premise of the probability theorem. Unitarity gives ||Uψ||=1, also proved
internally. Positivity gives p(U)≥0; Cauchy–Schwarz and contraction give p(U)≤1.
The literal formula is defined for all matrices; it is claimed to be a
probability only under the displayed effect and normalization hypotheses.

For normalized x,y and a contraction P, split
⟨x,Px⟩−⟨y,Py⟩=⟨x−y,Px⟩+⟨y,P(x−y)⟩.
Cauchy–Schwarz bounds the real-part difference by 2||x−y||. For two unitaries
U,V with ||U−V||≤η, operator action gives ||Uψ−Vψ||≤η, hence
|p(U)−p(V)|≤2η. A separate nonnegative η premise is unnecessary: the error
certificate already forces it. The auxiliary contraction lemma has its own
literal contraction hypothesis; the effect consumer derives that hypothesis.

For lists of primitive circuits of n qubits, use the library's existing
positionwise Aligned δ certificate, δ≥0. This certificate preserves the gate
constructors/wires and bounds corresponding Ry angle errors; it is not an
automatic synthesis theorem. Existing PrimitiveCircuitPerturbation gives
||eval approximate−eval exact||≤length(exact)·δ/2, and PrimitiveSemantics gives
both circuit unitaries. Applying the probability theorem yields effect
probability difference at most length(exact)·δ. Circuit unitarity and operator
perturbation remain genuine proof dependencies, not public hypotheses.

No additional register, garbage, ancilla or tensor identification is introduced.
Global phase is carried literally in matrices, not selected by a quotient or
claimed unique. The existing PrimitiveBasis fixes the circuit register order.
The analytic result requires no oracle access, controls or inverse black box.
No hardware noise law, state-loading cost, shot cost, gate count, physical depth,
finite-bit angle synthesis, runtime or estimator theorem follows from it.

Actual dependencies include Mathlib finite Matrix order/CStar norms, complex
inner products and operator action, and the existing library's
aligned_eval_distance_le and evalPrimitiveCircuit_unitary. The reusable
probability node has actual consumers probability_mem_Icc and
CircuitEffectStability.aligned_probability_difference_le. This contribution
adds canonical Semantics nodes, not a new research route, frontier, categorical
transport, accepted circuit compiler or resource theorem. Unaffected atlas and
progress surfaces remain unchanged with that reason.

<details><summary>Exact Lean statement and proof: QuantumBlockEncoding/BornStability.lean</summary>

```lean
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Tactic

/-! Pure-state Born probabilities on the existing finite matrix semantics.
The order is Loewner order, the matrix norm is the induced Euclidean L2 norm.
No amplitude-estimation or physical noise theorem is asserted here. -/
namespace QuantumBlockEncoding.BornStability

open scoped InnerProductSpace Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

noncomputable def probability (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : ℝ :=
  (inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
    (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re

set_option maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- The contraction bound is proved from the actual effect assumptions. -/
theorem effect_norm_le_one (P : Matrix ι ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    ‖P‖ ≤ 1 :=
  by
    letI : CStarAlgebra (Matrix ι ι ℂ) := {}
    exact (CStarAlgebra.norm_le_one_iff_of_nonneg (A := Matrix ι ι ℂ) P hP).mpr hPI

theorem unitary_norm_map (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (ψ : EuclideanSpace ℂ ι) :
    ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ‖ = ‖ψ‖ :=
  ContinuousLinearMap.norm_map_of_mem_unitary
    (Unitary.map_mem (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := ι)) hU) ψ

/-- Auxiliary analytic leaf. The public effect theorem derives its norm premise. -/
theorem quadratic_difference_le {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] (P : E →L[ℂ] E) (hP : ‖P‖ ≤ 1)
    (x y : E) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    |(inner ℂ x (P x)).re - (inner ℂ y (P y)).re| ≤ 2 * ‖x - y‖ := by
  have split : inner ℂ x (P x) - inner ℂ y (P y) =
      inner ℂ (x - y) (P x) + inner ℂ y (P (x - y)) := by
    simp only [map_sub, inner_sub_left, inner_sub_right]
    ring
  have hPx : ‖P x‖ ≤ 1 := by
    calc
      ‖P x‖ ≤ ‖P‖ * ‖x‖ := P.le_opNorm x
      _ ≤ 1 := by simpa [hx] using hP
  have hPxy : ‖P (x - y)‖ ≤ ‖x - y‖ := by
    calc
      _ ≤ ‖P‖ * ‖x - y‖ := P.le_opNorm _
      _ ≤ ‖x - y‖ := by nlinarith [norm_nonneg (x - y)]
  calc
    _ = |(inner ℂ x (P x) - inner ℂ y (P y)).re| := by simp
    _ ≤ ‖inner ℂ x (P x) - inner ℂ y (P y)‖ := Complex.abs_re_le_norm _
    _ ≤ ‖inner ℂ (x - y) (P x)‖ + ‖inner ℂ y (P (x - y))‖ := by
      rw [split]; exact norm_add_le _ _
    _ ≤ ‖x - y‖ * ‖P x‖ + ‖y‖ * ‖P (x - y)‖ :=
      add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _)
    _ ≤ 2 * ‖x - y‖ := by rw [hy]; nlinarith [norm_nonneg (x - y)]

/-- Normalized pure-state effect probability is Lipschitz in a pair of unitaries. -/
theorem probability_difference_le (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |probability U P ψ - probability V P ψ| ≤ 2 * η := by
  have hPc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
    rw [Matrix.l2_opNorm_toEuclideanCLM]
    exact effect_norm_le_one P hP hPI
  have hd : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ - Matrix.toEuclideanCLM (𝕜 := ℂ) V ψ‖ ≤ η := by
    calc
      _ = ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V) ψ‖ := by simp
      _ ≤ ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)‖ * ‖ψ‖ :=
        (Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)).le_opNorm ψ
      _ ≤ η := by
        rw [hψ, mul_one, Matrix.l2_opNorm_toEuclideanCLM]
        exact hUV
  exact (quadratic_difference_le _ hPc _ _
    (by rw [unitary_norm_map U hU, hψ])
    (by rw [unitary_norm_map V hV, hψ])).trans (by linarith)


/-- A true effect measurement on a normalized unitary output lies in [0,1]. -/
theorem probability_mem_Icc (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    probability U P ψ ∈ Set.Icc (0 : ℝ) 1 := by
  let x := Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ
  have hx : ‖x‖ = 1 := (unitary_norm_map U hU ψ).trans hψ
  have hpos : (Matrix.toEuclideanCLM (𝕜 := ℂ) P).IsPositive := by
    apply (ContinuousLinearMap.isPositive_toLinearMap_iff _).mp
    rw [Matrix.coe_toEuclideanCLM_eq_toEuclideanLin, Matrix.isPositive_toEuclideanLin_iff]
    exact Matrix.nonneg_iff_posSemidef.mp hP
  refine ⟨hpos.re_inner_nonneg_right x, ?_⟩
  change (inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)).re ≤ 1
  calc
    _ ≤ ‖inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)‖ := Complex.re_le_norm _
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P x‖ := norm_inner_le_norm _ _
    _ ≤ 1 := by
      have hc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
        rw [Matrix.l2_opNorm_toEuclideanCLM]
        exact effect_norm_le_one P hP hPI
      have := (Matrix.toEuclideanCLM (𝕜 := ℂ) P).le_opNorm x
      rw [hx, one_mul]
      rw [hx] at this
      simpa using this.trans (by simpa using hc)

end QuantumBlockEncoding.BornStability
```

</details>

<details><summary>Exact Lean statement and proof: QuantumBlockEncoding/CircuitEffectStability.lean</summary>

```lean
import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation

/-- An alignment certificate is required; this does not synthesize rounding. -/
theorem aligned_probability_difference_le {n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    (exact approximate : PrimitiveCircuit n) (ha : Aligned δ exact approximate)
    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
      BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
        (exact.length : ℝ) * δ := by
  have h := BornStability.probability_difference_le
    (evalPrimitiveCircuit approximate) (evalPrimitiveCircuit exact) P ψ hψ
    (evalPrimitiveCircuit_unitary approximate) (evalPrimitiveCircuit_unitary exact)
    hP hPI (aligned_eval_distance_le hδ ha)
  convert h using 1; ring

end QuantumBlockEncoding.CircuitEffectStability
```

</details>


## Input blind-reconstruction.md; SHA256 d002b4c5eb9120fe42a80f3e53f871a34557fe20d0e9bacf8520be88f5b573a8

# Independent formal reconstruction: effect stability

Decoder identity: `/root/generic_blind_decode`.
Run ID: `generic-blind-decode-20261009-efd2870d-d7f6-4aa9-89a8-e2a410527bab`.
Only input read: `docs/effect-stability/formal-packet.md`.
Packet SHA256: `c6c79553a91e29828c247e8989caf07a64eb4bbff2554d0f40e15f3cf6b02705`.
Revision: independently reread the expanded formal packet containing ambient circuit, evaluation, and alignment definitions.
Source blind: true. This is a reconstruction, not a source review or acceptance verdict.

## Norm, order, and inner-product conventions

The first six declarations are in `QuantumBlockEncoding.BornStability`. The packet declares the ambient variables `{ι : Type*} [Fintype ι] [DecidableEq ι]` for its matrix statements. Binder lists below preserve this displayed context; they do not assert that Lean retains unused ambient instance parameters in every elaborated declaration. The abstract `E` lemma does not use `ι`. Matrices are square matrices `Matrix ι ι ℂ`. The opened scopes include `InnerProductSpace`, `Matrix.Norms.L2Operator`, and `MatrixOrder`.

The matrix norm is the operator norm on the complex Euclidean space `EuclideanSpace ℂ ι`, induced by its L2 norm. In particular the packet explicitly uses `Matrix.l2_opNorm_toEuclideanCLM` to identify it with the continuous-linear-map operator norm. It is not an entrywise, Frobenius, or dimension-weighted matrix norm. Vector norms are Euclidean norms. In the abstract inner-product lemma, map norms are the continuous-linear-map operator norms for the supplied inner-product space.

Matrix comparisons use the Loewner order: `0 ≤ P` is positive semidefiniteness, including Hermitian symmetry; `P ≤ 1` means the identity minus `P` is positive semidefinite. The matrix `1` is the identity. These are not entrywise comparisons. Together these inequalities express an effect. There is no idempotence premise. Mathlib's complex inner product is conjugate-linear in the first argument and linear in the second; `.re` takes a real part, yielding the usual real expectation of a positive Hermitian effect when the relevant premises hold.

## Seven declarations

### 1. `BornStability.probability`

A `noncomputable def` with shared index/instance binders as above, explicit `(U P : Matrix ι ι ℂ)` and `(ψ : EuclideanSpace ℂ ι)`, result `ℝ`. Its literal body is:

```lean
(inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
  (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re
```

Writing `T_A = Matrix.toEuclideanCLM (𝕜 := ℂ) A`, this is `Re ⟨T_U ψ, T_P(T_U ψ)⟩`. The definition requires neither normalization nor unitarity nor positivity. The name alone does not give an interval bound.

### 2. `BornStability.effect_norm_le_one`

Explicit binders `(P : Matrix ι ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1)` with the shared index/instance binders. Conclusion: `‖P‖ ≤ 1`.

A positive semidefinite matrix below the identity is an L2 operator-norm contraction. The proof uses the C-star-algebra order characterization of the unit norm bound. This statement concerns only `P`, with no state or unitary.

### 3. `BornStability.unitary_norm_map`

Explicit binders, in order: `(U : Matrix ι ι ℂ)`, `(hU : U ∈ Matrix.unitaryGroup ι ℂ)`, `(ψ : EuclideanSpace ℂ ι)`; shared index/instance binders. Conclusion:

```lean
‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ‖ = ‖ψ‖
```

Every vector's norm is preserved by a matrix belonging to the matrix unitary group. No normalization premise is needed.

### 4. `BornStability.quadratic_difference_le`

This declaration is abstract over an inner-product space and has no matrix-index premise. Its full binder sequence is:

```lean
{E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
(P : E →L[ℂ] E) (hP : ‖P‖ ≤ 1)
(x y : E) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1)
```

Conclusion:

```lean
|(inner ℂ x (P x)).re - (inner ℂ y (P y)).re| ≤ 2 * ‖x - y‖
```

For two unit vectors and any continuous complex-linear contraction, the difference of real quadratic expressions is at most twice their distance. Positivity, self-adjointness, finite dimension, and completeness are not assumptions. The proof splits the complex difference as `⟨x-y,Px⟩ + ⟨y,P(x-y)⟩` and bounds its real part by the complex norm, then uses the inner-product and operator-norm estimates.

### 5. `BornStability.probability_difference_le`

With the shared index/instance binders, the actual explicit and implicit argument order is:

```lean
(U V P : Matrix ι ι ℂ)
(ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
(hU : U ∈ Matrix.unitaryGroup ι ℂ)
(hV : V ∈ Matrix.unitaryGroup ι ℂ)
(hP : 0 ≤ P) (hPI : P ≤ 1)
{η : ℝ} (hUV : ‖U - V‖ ≤ η)
```

Conclusion: `|probability U P ψ - probability V P ψ| ≤ 2 * η`.

For the same unit input vector and same effect, perturbing between two unitary matrices by at most `η` in L2 operator norm perturbs this real expectation by at most `2η`. The proof obtains a unit-vector distance bound from the operator distance, then applies the abstract quadratic estimate.

### 6. `BornStability.probability_mem_Icc`

With the shared index/instance binders, explicit binders in order are:

```lean
(U P : Matrix ι ι ℂ)
(ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
(hU : U ∈ Matrix.unitaryGroup ι ℂ)
(hP : 0 ≤ P) (hPI : P ≤ 1)
```

Conclusion: `probability U P ψ ∈ Set.Icc (0 : ℝ) 1`, meaning both `0 ≤ probability U P ψ` and `probability U P ψ ≤ 1`. The endpoints are included. Positivity gives the lower bound and contraction plus unit norm gives the upper bound.

### 7. `CircuitEffectStability.aligned_probability_difference_le`

This declaration is in `QuantumBlockEncoding.CircuitEffectStability`, opening `Matrix.Norms.L2Operator` and `MatrixOrder`, and `PrimitiveCircuitPerturbation`. Its binder sequence is:

```lean
{n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
(exact approximate : PrimitiveCircuit n)
(ha : Aligned δ exact approximate)
(P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
(ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
(hP : 0 ≤ P) (hPI : P ≤ 1)
```

Conclusion:

```lean
|BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
  BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
    (exact.length : ℝ) * δ
```

Under the listwise gate alignment defined below and nonnegative real `δ`, evaluation of the two circuits changes the same effect expectation on the same unit input by at most the real coercion of the exact circuit's length times `δ`. The literal multiplier is `exact.length`, not `2 * exact.length`. Alignment also entails that the approximate list has the same length.

The proof applies `probability_difference_le` to approximate evaluation first and exact evaluation second, using circuit unitarity and an imported aligned evaluation-distance bound; its final conversion uses ring arithmetic. The expanded packet contains the definitions and the circuit-unitarity proof reconstructed below. It still does not display the signature or body of `aligned_eval_distance_le`, so the latter helper's full binder list and derivation cannot be reconstructed from this packet.

## Ambient formal definitions used by declaration 7

These definitions are supplied inside the expanded packet and are now decoded explicitly. They provide mathematical meaning for the circuit estimate without asserting a physical implementation or synthesis procedure.

### Exact angles and gates

`QuantumBlockEncoding.ExactAngle` is an inductive syntax with these constructors and literal evaluations:

| Constructor and binders | Real evaluation |
|---|---|
| `rational (value : Rat)` | `(value : Real)` |
| `piRational (value : Rat)` | `Real.pi * (value : Real)` |
| `twiceArccosRational (value : Rat) (bounded : |(value : Real)| ≤ 1)` | `2 * Real.arccos (value : Real)` |
| `twiceArccosSqrtRational (value : Rat) (bounded : 0 ≤ (value : Real) ∧ (value : Real) ≤ 1)` | `2 * Real.arccos (Real.sqrt (value : Real))` |
| `real (value : Real)` | `value` |
| `add (left right : ExactAngle)` | `left.eval + right.eval` |
| `neg (value : ExactAngle)` | `-value.eval` |
| `scale (factor : Rat) (value : ExactAngle)` | `(factor : Real) * value.eval` |

`ExactAngle.eval` is noncomputable and has type `ExactAngle → Real`. The proof fields in the two bounded constructors constrain their rational inputs; the `.real` constructor accepts every real number. Other expressions can evaluate to arbitrary real values. `ExactAngle.sub left right` is literally `add left (neg right)`. `halfAdd left right` is `scale (1 / 2) (add left right)` and `halfSub left right` is `scale (1 / 2) (sub left right)`, with the factor rational. Their evaluations are subtraction, half the sum, and half the difference, respectively.

`PrimitiveGate (qubits : Nat)` is inductive with exactly these constructors:

```lean
| x (target : Fin qubits)
| ry (target : Fin qubits) (angle : ExactAngle)
| rz (target : Fin qubits) (angle : ExactAngle)
| cx (control target : Fin qubits) (distinct : control ≠ target)
```

`PrimitiveCircuit (qubits : Nat)` is an abbreviation for `List (PrimitiveGate qubits)`. Hence `exact.length` counts every list entry, including `x`, `ry`, `rz`, and `cx`; it is not depth or just the number of perturbed rotations. Every target is a valid finite wire index and every controlled-X constructor carries proof that its control differs from its target. The dagger operation preserves `x` and `cx` and negates the angle syntax for `ry` and `rz`. A `PrimitiveProgram` separately stores a circuit and an exact global phase; the stated stability theorem accepts circuits, not programs.

### Basis and gate/circuit semantics

The literal abbreviation is `PrimitiveBasis (qubits : Nat) := Fin qubits → Fin 2`. A basis index is a full assignment of a binary value to each wire, giving `2^qubits` indices. `flipBit bit := if bit = 0 then 1 else 0`. `xBasisAction target state := Function.update state target (flipBit (state target))`. The equivalence `xBasisEquiv target` uses that action as both its forward and inverse map. The controlled action is `cxBasisAction control target state := if state control = 0 then state else xBasisAction target state`; its equivalence similarly uses this involution as forward and inverse, requiring `control ≠ target`.

`OtherPrimitiveWires target` abbreviates `{wire : Fin qubits // wire ≠ target}`. `splitPrimitiveWire target` is an equivalence from the full basis to `Fin 2 × (OtherPrimitiveWires target → Fin 2)`: its forward map is `(state target, fun wire => state wire.1)`, and its inverse at `(targetBit, otherBits)` returns `targetBit` on the target and the corresponding other bit elsewhere.

For implicit `{qubits : Nat}`, explicit target and a `Fin 2` square complex matrix `gate`, the noncomputable lifted one-wire matrix is literally:

```lean
Matrix.reindexAlgEquiv ℂ ℂ (splitPrimitiveWire target).symm
  (gate ⊗ₖ (1 : Matrix
    (OtherPrimitiveWires target → Fin 2)
    (OtherPrimitiveWires target → Fin 2) ℂ))
```

The packet also states and proves that this entry equals `gate (row target) (column target)` when the other-bit assignments agree, and equals zero otherwise. Thus it acts on the target factor and leaves all other wires unchanged.

`standardRyMatrix (theta : Real)` is literally the imported helper `realRotation (theta / 2)`. The packet supplies its zero, addition, adjoint, and unitary facts. The helper `realRotation` itself is not defined in this packet, so the literal reference is retained rather than inventing an undisplayed entry-sign convention. `standardRzMatrix theta` is explicitly diagonal: entry `(0,0)` is `cos(theta/2) - sin(theta/2) * I`, entry `(1,1)` is `cos(theta/2) + sin(theta/2) * I`, and off-diagonal entries are zero, with the trigonometric real values coerced to complex numbers.

`evalPrimitiveGate` is a noncomputable definition with implicit `{qubits : Nat}` and type `PrimitiveGate qubits → Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ`. Its literal branches are:

```lean
| .x target => equivPermutationMatrix (xBasisEquiv target)
| .ry target angle => liftPrimitiveOneQubit target (standardRyMatrix angle.eval)
| .rz target angle => liftPrimitiveOneQubit target (standardRzMatrix angle.eval)
| .cx control target distinct =>
    equivPermutationMatrix (cxBasisEquiv control target distinct)
```

The named permutation-matrix helper is imported; the actual basis equivalences are explicit above. The packet proves each evaluated gate unitary using permutation unitarity or one-wire lifting of a unitary rotation. Circuit evaluation is the following literal recursion, with implicit `{qubits : Nat}` and matrix result on the full primitive basis:

```lean
| [] => 1
| gate :: rest => evalPrimitiveCircuit rest * evalPrimitiveGate gate
```

For `[g₁, …, gₘ]`, this is the reversed matrix product `eval(gₘ) * … * eval(g₁)`; the head gate acts first on a column-vector input. The packet proves circuit unitarity by list induction and proves `evalPrimitiveCircuit (left ++ right) = evalPrimitiveCircuit right * evalPrimitiveCircuit left`. It also proves that reversing a circuit and mapping the gate dagger evaluates to the matrix adjoint. Program evaluation separately multiplies circuit evaluation by the global phase `Complex.exp ((angle.eval : ℂ) * Complex.I)`.

### Literal gatewise and listwise alignment

In `QuantumBlockEncoding.PrimitiveCircuitPerturbation`, the exact inductive declaration is:

```lean
inductive GateAligned {qubits : ℕ} (δ : ℝ) :
    PrimitiveGate qubits → PrimitiveGate qubits → Prop
  | unchanged (gate : PrimitiveGate qubits) : GateAligned δ gate gate
  | ry (target : Fin qubits) (a b : ExactAngle)
      (error : |a.eval - b.eval| ≤ δ) :
      GateAligned δ (.ry target a) (.ry target b)
```

The literal list definition is:

```lean
def Aligned {qubits : ℕ} (δ : ℝ)
    (exact approximate : PrimitiveCircuit qubits) : Prop :=
  List.Forall₂ (GateAligned δ) exact approximate
```

Consequently aligned lists have equal length, and corresponding gates in their original order are either literally unchanged or are `ry` gates on the same target whose evaluated real angles differ in absolute value by at most `δ`. A changed `rz`, `x`, or `cx` gate or a different target cannot form an aligned pair; unequal list lengths cannot align. There is no constructor granting alignment merely because gates have been reordered: all resulting positions must still meet the pairwise rule. A permutation can happen to satisfy that rule, for example when same-target `ry` angles remain within the bound. Distinct angle syntax can also have the same real evaluation and satisfy the `ry` constructor at `δ=0`. The angle bound is on evaluated real values directly, without reducing them modulo a period and without taking a matrix or projective distance. The alignment definition itself imposes no `0 ≤ δ`; its unchanged branch works for any real `δ`. The stability theorem separately requires nonnegativity.

## Seven semantic slots, compared using formal content only

| Slot | Matrix expectation definition | Effect / unitary facts | Abstract quadratic estimate | Matrix probability estimates | Circuit estimate |
|---|---|---|---|---|---|
| 1. Quantification | Arbitrary finite index type and complex matrices/vector | Same finite type; effect or unitary matrix | Arbitrary complex inner-product space and continuous linear map | Same finite type; common vector/effect; one or two unitaries | Implicit natural `n` and real `δ`; two lists of primitive gates on `n` wires |
| 2. Literal object | Real part of `⟨Uψ, P(Uψ)⟩` via Euclidean maps | Matrix norm or vector norm after matrix action | Real parts of quadratic expressions | The literally defined real expectation | Expectations of reversed products of evaluated primitive gates |
| 3. Required premises | None | `0≤P≤1`, or unitary membership | Map norm ≤1 and both vectors of norm exactly one | Unit input, unitary membership, `0≤P≤1`; distance bound for difference theorem | `δ≥0`, listwise identical gates or same-target `ry` with evaluated-angle error ≤`δ`, unit input, `0≤P≤1` |
| 4. Claimed result | A real scalar | Norm ≤1; exact preservation of any vector norm | Absolute real difference ≤ twice vector distance | Absolute difference ≤`2η`; inclusive interval `[0,1]` | Absolute difference ≤ real exact length times `δ` |
| 5. Constants / strictness | No bound in definition | Weak contraction; exact equality for norm preservation | Factor two and weak inequality | Factor two; closed interval endpoints | Factor one times length and `δ`; weak inequality |
| 6. Conventions / scope | Euclidean action; first argument conjugate-linear | L2 operator norm; Loewner order; identity matrix | General operator norm; no positivity required | Same state/effect on both sides; operator distance of unitary matrices | Same state/effect; approximate-minus-exact ordering; basis `Fin n → Fin 2`; list order retained |
| 7. Edge cases / limitations | Arbitrary inputs need not yield a probability | Zero effects and identity effects allowed; finite index may be empty | Zero-dimensional space cannot furnish a unit vector | `hUV` entails `η≥0`; `η=0` forces equal expectation; `2η` can exceed one | At `δ=0`, different `ry` angle syntax can align when evaluations agree; empty exact forces empty approximate; changed `rz` is excluded |

The finite index type need not be nonempty. In the empty-index case every Euclidean vector has norm zero, so a norm-one premise cannot hold; the effect and norm-preservation facts still make sense. No separate `η≥0` premise is present, since it follows from the distance bound. Unnormalized vectors are admitted by the literal probability definition and norm-preservation theorem but excluded from the probability estimates. `P=0` yields zero expectation. For `P=1`, unitary evaluation on a unit input yields expectation one. An effect can be a non-projector, so interval and stability claims do not depend on projection identities. In the primitive setting the basis is always nonempty: at `n=0` it has the single empty assignment, and each gate constructor would need a nonexistent `Fin 0` target, so the only circuit is `[]`, evaluating to the one-dimensional identity. Alignment with an empty exact list requires an empty approximate list. When `δ=0`, the theorem gives zero expectation difference, including the case where paired `ry` syntax differs but its real evaluations agree. If no gates change, alignment holds for any `δ`, but the theorem's explicit `hδ` still requires a nonnegative value. The upper bound uses the full exact list length, so unchanged gates also count; no sharpened count of changed rotations is claimed.

## What these declarations do not prove

The seven central declarations do not establish a synthesis procedure that produces a requested aligned approximate circuit or verify a supplied angle-error hypothesis automatically. The expanded ambient packet defines the actual gate/list alignment and proves gate and circuit unitarity, but does not display the imported aligned evaluation-distance theorem's derivation. It does not show a perturbation guarantee for changed `rz` gates, altered targets, reordered lists, independent global phases of programs, or general circuits outside this primitive representation. It does not prove synthesis accuracy, depth or resource costs, block-encoding correctness, an amplitude-estimation procedure, a measurement implementation, distributional total-variation bounds for an entire measurement family, bounds for mixed states, changing effects, adaptive protocols, noisy nonunitary channels, or sample-based statistical estimates. The abstract contraction lemma does not by itself show the quadratic expressions are probabilities. The matrix interval theorem does not apply to arbitrary nonunitary or unnormalized inputs. The displayed constants are upper bounds, with no claim of optimality. These artifacts concern only the bounded real quadratic, unitary, effect, and explicitly decoded primitive alignment/evaluation interfaces displayed in the packet.


## Input port-statement-seal.json; SHA256 0c5c95dc7f9636cab64f7aca29e863782f8818bece8e5e591c23a2f93e0f7762

{
  "phase": "exact clean-port signature audit corrected after port; not a fresh pre-proof Source-Anchor seal",
  "sources": "author-derived generic mathematical contracts; no research objective or algorithm source attribution",
  "typing": "finite carriers, decidable equality and real/complex spaces",
  "source_inputs": "only the explicitly displayed error certificates, interval coverage, maximizer, normalized state, unitaries and effect bounds",
  "derived_not_inputs": [
    "effect contraction from Loewner bounds",
    "output normalization from unitarity",
    "circuit unitary and aligned circuit perturbation from existing library producers"
  ],
  "definition_audit": "literal probability formula and literal weak endpoint interval comparisons; strict removal of disjoint intervals. No new characterized choice object.",
  "scope_boundary": "no estimator, stochastic independence, complexity or physical runtime theorem",
  "signatures": [
    {
      "module": "QuantumBlockEncoding/BornStability.lean",
      "signature": "noncomputable def probability (U P : Matrix \u03b9 \u03b9 \u2102)\n    (\u03c8 : EuclideanSpace \u2102 \u03b9) : \u211d",
      "sha256": "8229e3b8d4b7458eb8260794f645de30362c2539630a677fb590a4124eed1820"
    },
    {
      "module": "QuantumBlockEncoding/BornStability.lean",
      "signature": "theorem effect_norm_le_one (P : Matrix \u03b9 \u03b9 \u2102) (hP : 0 \u2264 P) (hPI : P \u2264 1) :\n    \u2016P\u2016 \u2264 1",
      "sha256": "02483292a222e8df9af1e19994d9df1c65269c644705e972aa7334a8c0111854"
    },
    {
      "module": "QuantumBlockEncoding/BornStability.lean",
      "signature": "theorem unitary_norm_map (U : Matrix \u03b9 \u03b9 \u2102)\n    (hU : U \u2208 Matrix.unitaryGroup \u03b9 \u2102) (\u03c8 : EuclideanSpace \u2102 \u03b9) :\n    \u2016Matrix.toEuclideanCLM (\ud835\udd5c := \u2102) U \u03c8\u2016 = \u2016\u03c8\u2016",
      "sha256": "614c6888eb19df5eab4eb910708a87a4de534e1a24ea840d37a2dfa96395a565"
    },
    {
      "module": "QuantumBlockEncoding/BornStability.lean",
      "signature": "theorem quadratic_difference_le {E : Type*} [NormedAddCommGroup E]\n    [InnerProductSpace \u2102 E] (P : E \u2192L[\u2102] E) (hP : \u2016P\u2016 \u2264 1)\n    (x y : E) (hx : \u2016x\u2016 = 1) (hy : \u2016y\u2016 = 1) :\n    |(inner \u2102 x (P x)).re - (inner \u2102 y (P y)).re| \u2264 2 * \u2016x - y\u2016",
      "sha256": "7eb9ce43d5b5c2a6431818ab6fa227bf373a156bd68b3f41b3ec48706a6f4ea4"
    },
    {
      "module": "QuantumBlockEncoding/BornStability.lean",
      "signature": "theorem probability_difference_le (U V P : Matrix \u03b9 \u03b9 \u2102)\n    (\u03c8 : EuclideanSpace \u2102 \u03b9) (h\u03c8 : \u2016\u03c8\u2016 = 1)\n    (hU : U \u2208 Matrix.unitaryGroup \u03b9 \u2102) (hV : V \u2208 Matrix.unitaryGroup \u03b9 \u2102)\n    (hP : 0 \u2264 P) (hPI : P \u2264 1) {\u03b7 : \u211d} (hUV : \u2016U - V\u2016 \u2264 \u03b7) :\n    |probability U P \u03c8 - probability V P \u03c8| \u2264 2 * \u03b7",
      "sha256": "87fdeef9d7b3f20e0aa4d60ee1a16b3dc428fc2a4ea42120c0b535504c6abdf7"
    },
    {
      "module": "QuantumBlockEncoding/BornStability.lean",
      "signature": "theorem probability_mem_Icc (U P : Matrix \u03b9 \u03b9 \u2102)\n    (\u03c8 : EuclideanSpace \u2102 \u03b9) (h\u03c8 : \u2016\u03c8\u2016 = 1)\n    (hU : U \u2208 Matrix.unitaryGroup \u03b9 \u2102) (hP : 0 \u2264 P) (hPI : P \u2264 1) :\n    probability U P \u03c8 \u2208 Set.Icc (0 : \u211d) 1",
      "sha256": "cc5952467a85dc3f6afa0c4feeba940b6480460281a027e980ac3693ab8d1f49"
    },
    {
      "module": "QuantumBlockEncoding/CircuitEffectStability.lean",
      "signature": "theorem aligned_probability_difference_le {n : \u2115} {\u03b4 : \u211d} (h\u03b4 : 0 \u2264 \u03b4)\n    (exact approximate : PrimitiveCircuit n) (ha : Aligned \u03b4 exact approximate)\n    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) \u2102)\n    (\u03c8 : EuclideanSpace \u2102 (PrimitiveBasis n)) (h\u03c8 : \u2016\u03c8\u2016 = 1)\n    (hP : 0 \u2264 P) (hPI : P \u2264 1) :\n    |BornStability.probability (evalPrimitiveCircuit approximate) P \u03c8 -\n      BornStability.probability (evalPrimitiveCircuit exact) P \u03c8| \u2264\n        (exact.length : \u211d) * \u03b4",
      "sha256": "bb0976126a4024b3249d088e10d1b6caa69c791b2bb8ddba501e69e678dff4f5"
    }
  ],
  "declaration_level": "Canonical reusable library nodes and their internal providers; no external-paper or new-research-result source anchor.",
  "chronology_boundary": "Proof artifacts already existed. The v1 export is retained as superseded-invalid evidence. This v2 audit repairs metadata only; no mathematical signature was modified, and no retrospective proof-development chronology is asserted. Canonical reusable node status is separate from a fresh Source Anchor lifecycle.",
  "schema_version": 2
}


## Actual module QuantumBlockEncoding\BornStability.lean; SHA256 640851e0c59ff8da95a4045b84f4a48cfa5621a5a31002110fd71a4e1938e25e

import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Tactic

/-! Pure-state Born probabilities on the existing finite matrix semantics.
The order is Loewner order, the matrix norm is the induced Euclidean L2 norm.
No amplitude-estimation or physical noise theorem is asserted here. -/
namespace QuantumBlockEncoding.BornStability

open scoped InnerProductSpace Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

noncomputable def probability (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : ℝ :=
  (inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
    (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re

set_option maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- The contraction bound is proved from the actual effect assumptions. -/
theorem effect_norm_le_one (P : Matrix ι ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    ‖P‖ ≤ 1 :=
  by
    letI : CStarAlgebra (Matrix ι ι ℂ) := {}
    exact (CStarAlgebra.norm_le_one_iff_of_nonneg (A := Matrix ι ι ℂ) P hP).mpr hPI

theorem unitary_norm_map (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (ψ : EuclideanSpace ℂ ι) :
    ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ‖ = ‖ψ‖ :=
  ContinuousLinearMap.norm_map_of_mem_unitary
    (Unitary.map_mem (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := ι)) hU) ψ

/-- Auxiliary analytic leaf. The public effect theorem derives its norm premise. -/
theorem quadratic_difference_le {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] (P : E →L[ℂ] E) (hP : ‖P‖ ≤ 1)
    (x y : E) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    |(inner ℂ x (P x)).re - (inner ℂ y (P y)).re| ≤ 2 * ‖x - y‖ := by
  have split : inner ℂ x (P x) - inner ℂ y (P y) =
      inner ℂ (x - y) (P x) + inner ℂ y (P (x - y)) := by
    simp only [map_sub, inner_sub_left, inner_sub_right]
    ring
  have hPx : ‖P x‖ ≤ 1 := by
    calc
      ‖P x‖ ≤ ‖P‖ * ‖x‖ := P.le_opNorm x
      _ ≤ 1 := by simpa [hx] using hP
  have hPxy : ‖P (x - y)‖ ≤ ‖x - y‖ := by
    calc
      _ ≤ ‖P‖ * ‖x - y‖ := P.le_opNorm _
      _ ≤ ‖x - y‖ := by nlinarith [norm_nonneg (x - y)]
  calc
    _ = |(inner ℂ x (P x) - inner ℂ y (P y)).re| := by simp
    _ ≤ ‖inner ℂ x (P x) - inner ℂ y (P y)‖ := Complex.abs_re_le_norm _
    _ ≤ ‖inner ℂ (x - y) (P x)‖ + ‖inner ℂ y (P (x - y))‖ := by
      rw [split]; exact norm_add_le _ _
    _ ≤ ‖x - y‖ * ‖P x‖ + ‖y‖ * ‖P (x - y)‖ :=
      add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _)
    _ ≤ 2 * ‖x - y‖ := by rw [hy]; nlinarith [norm_nonneg (x - y)]

/-- Normalized pure-state effect probability is Lipschitz in a pair of unitaries. -/
theorem probability_difference_le (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |probability U P ψ - probability V P ψ| ≤ 2 * η := by
  have hPc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
    rw [Matrix.l2_opNorm_toEuclideanCLM]
    exact effect_norm_le_one P hP hPI
  have hd : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ - Matrix.toEuclideanCLM (𝕜 := ℂ) V ψ‖ ≤ η := by
    calc
      _ = ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V) ψ‖ := by simp
      _ ≤ ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)‖ * ‖ψ‖ :=
        (Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)).le_opNorm ψ
      _ ≤ η := by
        rw [hψ, mul_one, Matrix.l2_opNorm_toEuclideanCLM]
        exact hUV
  exact (quadratic_difference_le _ hPc _ _
    (by rw [unitary_norm_map U hU, hψ])
    (by rw [unitary_norm_map V hV, hψ])).trans (by linarith)


/-- A true effect measurement on a normalized unitary output lies in [0,1]. -/
theorem probability_mem_Icc (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    probability U P ψ ∈ Set.Icc (0 : ℝ) 1 := by
  let x := Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ
  have hx : ‖x‖ = 1 := (unitary_norm_map U hU ψ).trans hψ
  have hpos : (Matrix.toEuclideanCLM (𝕜 := ℂ) P).IsPositive := by
    apply (ContinuousLinearMap.isPositive_toLinearMap_iff _).mp
    rw [Matrix.coe_toEuclideanCLM_eq_toEuclideanLin, Matrix.isPositive_toEuclideanLin_iff]
    exact Matrix.nonneg_iff_posSemidef.mp hP
  refine ⟨hpos.re_inner_nonneg_right x, ?_⟩
  change (inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)).re ≤ 1
  calc
    _ ≤ ‖inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)‖ := Complex.re_le_norm _
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P x‖ := norm_inner_le_norm _ _
    _ ≤ 1 := by
      have hc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
        rw [Matrix.l2_opNorm_toEuclideanCLM]
        exact effect_norm_le_one P hP hPI
      have := (Matrix.toEuclideanCLM (𝕜 := ℂ) P).le_opNorm x
      rw [hx, one_mul]
      rw [hx] at this
      simpa using this.trans (by simpa using hc)

end QuantumBlockEncoding.BornStability


## Actual module QuantumBlockEncoding\CircuitEffectStability.lean; SHA256 407be0ea8a4bdf5f83a9ca99372f9bbb131c44fb475d027cb50c337bfb046d2b

import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation

/-- An alignment certificate is required; this does not synthesize rounding. -/
theorem aligned_probability_difference_le {n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    (exact approximate : PrimitiveCircuit n) (ha : Aligned δ exact approximate)
    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
      BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
        (exact.length : ℝ) * δ := by
  have h := BornStability.probability_difference_le
    (evalPrimitiveCircuit approximate) (evalPrimitiveCircuit exact) P ψ hψ
    (evalPrimitiveCircuit_unitary approximate) (evalPrimitiveCircuit_unitary exact)
    hP hPI (aligned_eval_distance_le hδ ha)
  convert h using 1; ring

end QuantumBlockEncoding.CircuitEffectStability


## Existing aligned perturbation definitions and proof excerpt; full-file SHA256 92c3259a8a2a13ed46f84bc502e7156002e766fcd9d57c8604aa8f828e0eaac4

import QuantumBlockEncoding.PrimitiveRyPerturbation
import QuantumBlockEncoding.ConstructiveHermitePreparation
import Mathlib.Data.List.Forall2

/-! conditional circuit perturbation theorem. Alignment is
positional: only RY angles may change, always on the same physical target;
all other instructions remain exactly the same. No rounded-circuit supplier
or numerical angle algorithm is constructed or assumed to be free.
All norms are Euclidean induced L2 operator norms. The telescoping proof uses
the actual chronological convention eval(g::rest) = eval(rest) * eval(g).
-/
namespace QuantumBlockEncoding.PrimitiveCircuitPerturbation
open PrimitiveRyPerturbation
open scoped Matrix.Norms.L2Operator

inductive GateAligned {qubits : ℕ} (δ : ℝ) : PrimitiveGate qubits → PrimitiveGate qubits → Prop
  | unchanged (gate : PrimitiveGate qubits) : GateAligned δ gate gate
  | ry (target : Fin qubits) (a b : ExactAngle) (error : |a.eval - b.eval| ≤ δ) :
      GateAligned δ (.ry target a) (.ry target b)

/-- A Forall₂ witness preserves every position, physical label and list length. -/
def Aligned {qubits : ℕ} (δ : ℝ) (exact approximate : PrimitiveCircuit qubits) : Prop :=
  List.Forall₂ (GateAligned δ) exact approximate

theorem GateAligned.touched_eq {qubits : ℕ} {δ : ℝ} {a b : PrimitiveGate qubits}
    (h : GateAligned δ a b) : a.touched = b.touched := by
  cases h <;> rfl

theorem Aligned.length_eq {qubits : ℕ} {δ : ℝ} {exact approximate : PrimitiveCircuit qubits}
    (h : Aligned δ exact approximate) : exact.length = approximate.length :=
  List.Forall₂.length_eq h

theorem Aligned.refl {qubits : ℕ} (δ : ℝ) (circuit : PrimitiveCircuit qubits) :
    Aligned δ circuit circuit := by
  induction circuit with
  | nil => exact .nil
  | cons gate rest ih => exact .cons (.unchanged gate) ih

theorem GateAligned.distance_le {qubits : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    {exact approximate : PrimitiveGate qubits} (h : GateAligned δ exact approximate) :
    ‖evalPrimitiveGate approximate - evalPrimitiveGate exact‖ ≤ δ / 2 := by
  cases h with
  | unchanged gate => simpa using (div_nonneg hδ (by norm_num : (0 : ℝ) ≤ 2))
  | ry target a b herror =>
      rw [norm_sub_rev]
      exact (eval_ry_distance_le target a b).trans (div_le_div_of_nonneg_right herror (by norm_num))

/-- No gate order is commuted: each induction step matches the actual evaluator. -/
theorem aligned_eval_distance_le {qubits : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    {exact approximate : PrimitiveCircuit qubits} (aligned : Aligned δ exact approximate) :
    ‖evalPrimitiveCircuit approximate - evalPrimitiveCircuit exact‖ ≤
      (exact.length : ℝ) * δ / 2 := by
  induction aligned with
  | nil => simp
  | @cons exactGate approximateGate exactRest approximateRest head tail ih =>
      simp only [evalPrimitiveCircuit]
      have split : evalPrimitiveCircuit approximateRest * evalPrimitiveGate approximateGate -
          evalPrimitiveCircuit exactRest * evalPrimitiveGate exactGate =
          (evalPrimitiveCircuit approximateRest - evalPrimitiveCircuit exactRest) *
              evalPrimitiveGate approximateGate +
            evalPrimitiveCircuit exactRest *
              (evalPrimitiveGate approximateGate - evalPrimitiveGate exactGate) := by
        noncomm_ring
      rw [split]
      calc
        _ ≤ ‖(evalPrimitiveCircuit approximateRest - evalPrimitiveCircuit exactRest) *
                evalPrimitiveGate approximateGate‖ +
              ‖evalPrimitiveCircuit exactRest *
                (evalPrimitiveGate approximateGate - evalPrimitiveGate exactGate)‖ := norm_add_le _ _
        _ = ‖evalPrimitiveCircuit approximateRest - evalPrimitiveCircuit exactRest‖ +
              ‖evalPrimitiveGate approximateGate - evalPrimitiveGate exactGate‖ := by
          rw [CStarRing.norm_mul_mem_unitary _ (evalPrimitiveGate_unitary approximateGate),
            CStarRing.norm_mem_unitary_mul _ (evalPrimitiveCircuit_unitary exactRest)]
        _ ≤ (exactRest.length : ℝ) * δ / 2 + δ / 2 :=
          add_le_add ih (head.distance_le hδ)
        _ = _ := by simp only [List.length_cons, Nat.cast_add, Nat.cast_one]; ring

/-- Explicit Euclidean CLM formulation prevents accidental entrywise-norm use. -/
theorem aligned_eval_clm_distance_le {qubits : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    {exact approximate : PrimitiveCircuit qubits} (aligned : Aligned δ exact approximate) :
    ‖_root_.Matrix.toEuclideanCLM (𝕜 := ℂ) (n := PrimitiveBasis qubits)
      (evalPrimitiveCircuit approximate - evalPrimitiveCircuit exact)‖ ≤
        (exact.length : ℝ) * δ / 2 := by
  rw [_root_.Matrix.l2_opNorm_toEuclideanCLM]
  exact aligned_eval_distance_le hδ aligned
