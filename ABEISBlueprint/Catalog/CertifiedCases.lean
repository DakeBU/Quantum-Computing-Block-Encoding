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

#doc (Manual) "Declaration catalog: CertifiedCases" =>
%%%
file := "catalog-certified-cases"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

Reader orientation: Completed transfer-operator and optimal-control certificates used as end-to-end case studies. Each card separates an accessible
reading cue from formal status, the source docstring, and the authoritative Lean panel.
The standalone Library Explorer adds full-text search and filters across every chapter.

# QuantumBlockEncoding/ColdStartTransferE1.lean

28 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.coldE1SystemIndex" (lean := "QuantumBlockEncoding.coldE1SystemIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 system index”. System-register index for one-bit registers ordered as '(T, tau, S)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System-register index for one-bit registers ordered as '(T, tau, S)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L19).
:::

:::definition "QuantumBlockEncoding.coldE1Target" (lean := "QuantumBlockEncoding.coldE1Target")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 target”. The target matrix for 'E\_1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The target matrix for 'E\_1'. It has support exactly on the two entries mapping '|1>\_T |1>\_tau |s>\_S' to '|0>\_T |0>\_tau |s>\_S'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L32).
:::

:::definition "QuantumBlockEncoding.coldE1QueryTarget" (lean := "QuantumBlockEncoding.coldE1QueryTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 query target”. Operator-first target metadata for the strict cold-start benchmark.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Operator-first target metadata for the strict cold-start benchmark.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:41](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L41).
:::

:::definition "QuantumBlockEncoding.coldE1SignalIndex" (lean := "QuantumBlockEncoding.coldE1SignalIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 signal index”. The clean block-selection index for the single signal ancilla.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The clean block-selection index for the single signal ancilla.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:55](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L55).
:::

:::definition "QuantumBlockEncoding.coldE1BlockProjection" (lean := "QuantumBlockEncoding.coldE1BlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 block projection”. Exact clean-block predicate for a one-signal-qubit candidate matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact clean-block predicate for a one-signal-qubit candidate matrix. The block projection is the '(signalIndex, signalIndex)' block of 'U', and it must equal 'coldE1Target' pointwise.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:63](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L63).
:::

:::definition "QuantumBlockEncoding.coldE1ExactNormalizer" (lean := "QuantumBlockEncoding.coldE1ExactNormalizer")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 exact normalizer”. Exact normalizer for the requested block encoding.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact normalizer for the requested block encoding.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:70](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L70).
:::

:::definition "QuantumBlockEncoding.coldE1ExactError" (lean := "QuantumBlockEncoding.coldE1ExactError")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 exact error”. Exact error for the requested block encoding.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact error for the requested block encoding.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:73](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L73).
:::

:::definition "QuantumBlockEncoding.coldE1SourceLayout" (lean := "QuantumBlockEncoding.coldE1SourceLayout")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 source layout”. Source-facing layout: three system qubits and one clean signal ancilla.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Source-facing layout: three system qubits and one clean signal ancilla.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:76](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L76).
:::

:::definition "QuantumBlockEncoding.coldE1HighLevelSeedCost" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 high level seed cost”. Source-facing seed cost under the high-level reversible-gate convention in the conversion window.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Source-facing seed cost under the high-level reversible-gate convention in the conversion window. This is not a certified 'Circuit.resource' expansion.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:85](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L85).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_gateCount" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 high level seed cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:91](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L91).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_depth" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 high level seed cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:94](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L94).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_auxiliaryQubits" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 high level seed cost auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:97](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L97).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_oracleCalls" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_oracleCalls")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 high level seed cost oracle calls”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:100](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L100).
:::

:::definition "QuantumBlockEncoding.coldE1CandidateImage" (lean := "QuantumBlockEncoding.coldE1CandidateImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 candidate image”. Candidate 'COLD-CLEAN-PERM-001' as a finite image table on '(signal,T,tau,S)' basis states.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Candidate 'COLD-CLEAN-PERM-001' as a finite image table on '(signal,T,tau,S)' basis states. The full index convention is 'signal \* 8 + coldE1SystemIndex T tau S'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:109](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L109).
:::

:::definition "QuantumBlockEncoding.coldE1CandidateMatrix" (lean := "QuantumBlockEncoding.coldE1CandidateMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 candidate matrix”. Column-vector permutation matrix for 'COLD-CLEAN-PERM-001'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Column-vector permutation matrix for 'COLD-CLEAN-PERM-001'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:129](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L129).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state0" (lean := "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state0")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image clean source state 0”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:132](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L132).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state1" (lean := "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state1")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image clean source state 1”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:136](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L136).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_injective_pointwise" (lean := "QuantumBlockEncoding.coldE1CandidateImage_injective_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image injective pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:140](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L140).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_injective" (lean := "QuantumBlockEncoding.coldE1CandidateImage_injective")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image injective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:144](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L144).
:::

:::definition "QuantumBlockEncoding.coldE1CandidatePreimage" (lean := "QuantumBlockEncoding.coldE1CandidatePreimage")
*Plain-English reading.* This definition gives the library's named construction or computation for “cold e 1 candidate preimage”. Explicit inverse image table for the task-local permutation certificate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Explicit inverse image table for the task-local permutation certificate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:150](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L150).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_preimage" (lean := "QuantumBlockEncoding.coldE1CandidateImage_preimage")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image preimage”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:169](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L169).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_surjective" (lean := "QuantumBlockEncoding.coldE1CandidateImage_surjective")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image surjective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:173](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L173).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_permutation_certificate" (lean := "QuantumBlockEncoding.coldE1CandidateImage_permutation_certificate")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate image permutation certificate”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:178](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L178).
:::

:::theorem "QuantumBlockEncoding.coldE1Target_support_state0" (lean := "QuantumBlockEncoding.coldE1Target_support_state0")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 target support state 0”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:183](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L183).
:::

:::theorem "QuantumBlockEncoding.coldE1Target_support_state1" (lean := "QuantumBlockEncoding.coldE1Target_support_state1")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 target support state 1”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:187](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L187).
:::

:::theorem "QuantumBlockEncoding.coldE1Candidate_blockProjection" (lean := "QuantumBlockEncoding.coldE1Candidate_blockProjection")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 candidate block projection”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:191](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L191).
:::

:::theorem "QuantumBlockEncoding.coldE1QueryTarget_normalizer" (lean := "QuantumBlockEncoding.coldE1QueryTarget_normalizer")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 query target normalizer”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:199](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L199).
:::

:::theorem "QuantumBlockEncoding.coldE1SourceLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.coldE1SourceLayout_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “cold e 1 source layout auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:202](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L202).
:::

# QuantumBlockEncoding/MainCase.lean

127 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.mainCaseProSystemIndex" (lean := "QuantumBlockEncoding.mainCaseProSystemIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro system index”. System-register index for one-bit registers ordered as '(T, tau, S)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System-register index for one-bit registers ordered as '(T, tau, S)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:20](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L20).
:::

:::definition "QuantumBlockEncoding.mainCaseProTarget" (lean := "QuantumBlockEncoding.mainCaseProTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro target”. The target matrix for 'E\_1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The target matrix for 'E\_1'. It maps '|1>\_T |1>\_tau |s>\_S' to '|0>\_T |0>\_tau |s>\_S' and annihilates every other computational-basis column.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:33](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L33).
:::

:::definition "QuantumBlockEncoding.mainCaseProQueryTarget" (lean := "QuantumBlockEncoding.mainCaseProQueryTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro query target”. Operator-first target metadata for the Pro-isolated main-case benchmark.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Operator-first target metadata for the Pro-isolated main-case benchmark.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:44](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L44).
:::

:::definition "QuantumBlockEncoding.mainCaseProSignalIndex" (lean := "QuantumBlockEncoding.mainCaseProSignalIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro signal index”. The clean block-selection index for the single signal ancilla.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The clean block-selection index for the single signal ancilla.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L60).
:::

:::definition "QuantumBlockEncoding.mainCaseProCleanEmbed" (lean := "QuantumBlockEncoding.mainCaseProCleanEmbed")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro clean embed”. Clean embedding into the signal-system product basis.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Clean embedding into the signal-system product basis.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:63](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L63).
:::

:::definition "QuantumBlockEncoding.mainCaseProBlockProjection" (lean := "QuantumBlockEncoding.mainCaseProBlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro block projection”. Exact clean-block predicate for a one-signal-qubit candidate matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact clean-block predicate for a one-signal-qubit candidate matrix. The block projection is the '(signalIndex, signalIndex)' block of 'U', and it must equal 'mainCaseProTarget' pointwise.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:72](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L72).
:::

:::definition "QuantumBlockEncoding.mainCaseProExactNormalizer" (lean := "QuantumBlockEncoding.mainCaseProExactNormalizer")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro exact normalizer”. Exact normalizer for the requested block encoding.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact normalizer for the requested block encoding.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:79](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L79).
:::

:::definition "QuantumBlockEncoding.mainCaseProExactError" (lean := "QuantumBlockEncoding.mainCaseProExactError")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro exact error”. Exact error for the requested block encoding.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact error for the requested block encoding.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:82](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L82).
:::

:::definition "QuantumBlockEncoding.mainCaseProSourceLayout" (lean := "QuantumBlockEncoding.mainCaseProSourceLayout")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro source layout”. Source-facing layout: three system qubits and one clean signal ancilla.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Source-facing layout: three system qubits and one clean signal ancilla.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:85](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L85).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuit" (lean := "QuantumBlockEncoding.mainCaseProCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit”. Logical '\{X,CNOT,Toffoli\}' transcript for the Pro equality-transfer idea.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical '\{X,CNOT,Toffoli\}' transcript for the Pro equality-transfer idea.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:91](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L91).
:::

:::definition "QuantumBlockEncoding.mainCaseProSchedule" (lean := "QuantumBlockEncoding.mainCaseProSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro schedule”. Sequential high-level schedule for the current logical transcript.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Sequential high-level schedule for the current logical transcript.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:99](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L99).
:::

:::definition "QuantumBlockEncoding.mainCaseProHighLevelResource" (lean := "QuantumBlockEncoding.mainCaseProHighLevelResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro high level resource”. High-level logical-library resource record for the Pro equality-transfer transcript.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* High-level logical-library resource record for the Pro equality-transfer transcript. The current 'Resource' type has no Toffoli field, so controlled logical gates are counted in the 'cnot' bucket at this semantic tier.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:111](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L111).
:::

:::definition "QuantumBlockEncoding.mainCaseProHighLevelSeedCost" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro high level seed cost”. Source-facing high-level score '(gateCount, depth, auxiliaryQubits, oracleCalls)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Source-facing high-level score '(gateCount, depth, auxiliaryQubits, oracleCalls)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:115](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L115).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_gateCount" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro high level seed cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L119).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_depth" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro high level seed cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:122](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L122).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro high level seed cost auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:125](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L125).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_oracleCalls" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_oracleCalls")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro high level seed cost oracle calls”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:128](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L128).
:::

:::definition "QuantumBlockEncoding.mainCaseProMatrixTableResource" (lean := "QuantumBlockEncoding.mainCaseProMatrixTableResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro matrix table resource”. Matrix-table metadata for 'mainCaseProCandidate'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix-table metadata for 'mainCaseProCandidate'. This incumbent is a finite permutation witness, not the advertised Pro four-gate transcript. The single oracle call marks the unresolved executable realization instead of reusing 'mainCaseProCircuit'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:138](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L138).
:::

:::definition "QuantumBlockEncoding.mainCaseProMatrixTableCircuit" (lean := "QuantumBlockEncoding.mainCaseProMatrixTableCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro matrix table circuit”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:141](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L141).
:::

:::definition "QuantumBlockEncoding.mainCaseProMatrixTableSchedule" (lean := "QuantumBlockEncoding.mainCaseProMatrixTableSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro matrix table schedule”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:143](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L143).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidateImage" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro candidate image”. Candidate 'MAINCASE-PRO-PERM-001' as a finite image table on '(signal,T,tau,S)' basis states.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Candidate 'MAINCASE-PRO-PERM-001' as a finite image table on '(signal,T,tau,S)' basis states. The full index convention is 'signal \* 8 + mainCaseProSystemIndex T tau S'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:151](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L151).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidateMatrix" (lean := "QuantumBlockEncoding.mainCaseProCandidateMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro candidate matrix”. Column-vector permutation matrix for 'MAINCASE-PRO-PERM-001'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Column-vector permutation matrix for 'MAINCASE-PRO-PERM-001'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:171](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L171).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state0" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state0")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image clean source state 0”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:174](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L174).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state1" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state1")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image clean source state 1”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:178](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L178).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_injective_pointwise" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_injective_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image injective pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:182](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L182).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_injective" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_injective")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image injective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:187](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L187).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidatePreimage" (lean := "QuantumBlockEncoding.mainCaseProCandidatePreimage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro candidate preimage”. Explicit inverse image table for the task-local permutation certificate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Explicit inverse image table for the task-local permutation certificate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:193](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L193).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_preimage" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_preimage")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image preimage”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:212](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L212).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_surjective" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_surjective")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image surjective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:217](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L217).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidateImageIsPermutation" (lean := "QuantumBlockEncoding.mainCaseProCandidateImageIsPermutation")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro candidate image is permutation”. Task-local finite-permutation certificate for the candidate image.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Task-local finite-permutation certificate for the candidate image.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:224](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L224).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_permutation_certificate" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_permutation_certificate")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate image permutation certificate”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:228](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L228).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateMatrix_isRationalOrthogonal" (lean := "QuantumBlockEncoding.mainCaseProCandidateMatrix_isRationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate matrix is rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:232](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L232).
:::

:::definition "QuantumBlockEncoding.mainCaseProReducedOfFull" (lean := "QuantumBlockEncoding.mainCaseProReducedOfFull")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro reduced of full”. Reduced active index for the Pro transcript bits '(tau,T,signal)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced active index for the Pro transcript bits '(tau,T,signal)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:240](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L240).
:::

:::definition "QuantumBlockEncoding.mainCaseProStateOfFull" (lean := "QuantumBlockEncoding.mainCaseProStateOfFull")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro state of full”. Passive state bit in the full '(signal,T,tau,S)' convention.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Passive state bit in the full '(signal,T,tau,S)' convention.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:244](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L244).
:::

:::definition "QuantumBlockEncoding.mainCaseProLiftReducedImage" (lean := "QuantumBlockEncoding.mainCaseProLiftReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro lift reduced image”. Lift a reduced active-register image while preserving the passive state bit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Lift a reduced active-register image while preserving the passive state bit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:248](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L248).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedCCX012" (lean := "QuantumBlockEncoding.mainCaseProRedCCX012")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro red ccx 012”. Reduced Toffoli 'CCX012', with controls 'tau,T' and target 'signal'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced Toffoli 'CCX012', with controls 'tau,T' and target 'signal'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:257](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L257).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedCX21" (lean := "QuantumBlockEncoding.mainCaseProRedCX21")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro red cx 21”. Reduced 'CX21', with control 'signal' and target 'T'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced 'CX21', with control 'signal' and target 'T'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:263](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L263).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedCX20" (lean := "QuantumBlockEncoding.mainCaseProRedCX20")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro red cx 20”. Reduced 'CX20', with control 'signal' and target 'tau'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced 'CX20', with control 'signal' and target 'tau'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:271](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L271).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedX2" (lean := "QuantumBlockEncoding.mainCaseProRedX2")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro red x 2”. Reduced final 'X2', flipping the signal bit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced final 'X2', flipping the signal bit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:279](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L279).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitReducedImage" (lean := "QuantumBlockEncoding.mainCaseProCircuitReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit reduced image”. Task-local reduced image for the transcript 'CCX012; CX21; CX20; X2'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Task-local reduced image for the transcript 'CCX012; CX21; CX20; X2'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:290](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L290).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitImage" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit image”. Task-local full image induced by the advertised Pro four-gate transcript under the full wire map 'S=0', 'tau=1', 'T=2', 'signal=3'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Task-local full image induced by the advertised Pro four-gate transcript under the full wire map 'S=0', 'tau=1', 'T=2', 'signal=3'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:300](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L300).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state0" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state0")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image clean source state 0”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:303](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L303).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state1" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state1")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image clean source state 1”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:307](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L307).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_candidate_mismatch_set" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_candidate_mismatch_set")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image candidate mismatch set”; the hypotheses and conclusion in the code panel fix its exact scope. The advertised transcript and the finite-permutation incumbent differ exactly on dirty columns '8', '9', '12', and '13'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The advertised transcript and the finite-permutation incumbent differ exactly on dirty columns '8', '9', '12', and '13'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:315](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L315).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_not_pointwise_candidate" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_not_pointwise_candidate")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image not pointwise candidate”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:321](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L321).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitMatrix" (lean := "QuantumBlockEncoding.mainCaseProCircuitMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit matrix”. Column-vector permutation matrix induced by the advertised Pro transcript.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Column-vector permutation matrix induced by the advertised Pro transcript.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:331](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L331).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_injective_pointwise" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_injective_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image injective pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:334](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L334).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_injective" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_injective")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image injective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:339](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L339).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_surjective_pointwise" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_surjective_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image surjective pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:344](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L344).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_surjective" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_surjective")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image surjective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:348](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L348).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitImageIsPermutation" (lean := "QuantumBlockEncoding.mainCaseProCircuitImageIsPermutation")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit image is permutation”. Task-local finite-permutation certificate for the Pro transcript image.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Task-local finite-permutation certificate for the Pro transcript image.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:353](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L353).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_permutation_certificate" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_permutation_certificate")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit image permutation certificate”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:357](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L357).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitMatrix_isRationalOrthogonal" (lean := "QuantumBlockEncoding.mainCaseProCircuitMatrix_isRationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit matrix is rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:361](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L361).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuit_cleanEntry" (lean := "QuantumBlockEncoding.mainCaseProCircuit_cleanEntry")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit clean entry”; the hypotheses and conclusion in the code panel fix its exact scope. Clean-entry calculation for the gate-derived Pro transcript image.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Clean-entry calculation for the gate-derived Pro transcript image.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:369](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L369).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuit_blockProjection" (lean := "QuantumBlockEncoding.mainCaseProCircuit_blockProjection")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit block projection”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:379](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L379).
:::

:::theorem "QuantumBlockEncoding.mainCaseProTarget_support_state0" (lean := "QuantumBlockEncoding.mainCaseProTarget_support_state0")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro target support state 0”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:392](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L392).
:::

:::theorem "QuantumBlockEncoding.mainCaseProTarget_support_state1" (lean := "QuantumBlockEncoding.mainCaseProTarget_support_state1")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro target support state 1”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:398](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L398).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_cleanEntry" (lean := "QuantumBlockEncoding.mainCaseProCandidate_cleanEntry")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate clean entry”; the hypotheses and conclusion in the code panel fix its exact scope. Entrywise image calculation for the reusable partial-permutation wrapper.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Entrywise image calculation for the reusable partial-permutation wrapper.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:405](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L405).
:::

:::definition "QuantumBlockEncoding.mainCaseProExactCleanBlockCertificate" (lean := "QuantumBlockEncoding.mainCaseProExactCleanBlockCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro exact clean block certificate”. Exact clean-block package from the compiled partial-permutation leaf.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact clean-block package from the compiled partial-permutation leaf.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:419](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L419).
:::

:::theorem "QuantumBlockEncoding.mainCaseProExactCleanBlock_correct" (lean := "QuantumBlockEncoding.mainCaseProExactCleanBlock_correct")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro exact clean block correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L427).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_blockProjection" (lean := "QuantumBlockEncoding.mainCaseProCandidate_blockProjection")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate block projection”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:435](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L435).
:::

:::theorem "QuantumBlockEncoding.mainCaseProQueryTarget_normalizer" (lean := "QuantumBlockEncoding.mainCaseProQueryTarget_normalizer")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro query target normalizer”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:444](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L444).
:::

:::theorem "QuantumBlockEncoding.mainCaseProSourceLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseProSourceLayout_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro source layout auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:447](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L447).
:::

:::definition "QuantumBlockEncoding.mainCaseProRationalOrthogonalBridgeObligation" (lean := "QuantumBlockEncoding.mainCaseProRationalOrthogonalBridgeObligation")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro rational orthogonal bridge obligation”. Reusable proof obligation for a later shared bridge from finite bijections to the project-local rational-orthogonality matrix predicate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reusable proof obligation for a later shared bridge from finite bijections to the project-local rational-orthogonality matrix predicate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:454](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L454).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidate" (lean := "QuantumBlockEncoding.mainCaseProCandidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro candidate”. Candidate record at the finite-permutation semantic tier.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Candidate record at the finite-permutation semantic tier.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:461](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L461).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitCandidate" (lean := "QuantumBlockEncoding.mainCaseProCircuitCandidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit candidate”. Gate-derived candidate for the advertised Pro four-gate transcript.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Gate-derived candidate for the advertised Pro four-gate transcript.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:474](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L474).
:::

:::definition "QuantumBlockEncoding.mainCaseProVerified" (lean := "QuantumBlockEncoding.mainCaseProVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro verified”. Verified task-local candidate at the finite-permutation semantic tier.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified task-local candidate at the finite-permutation semantic tier. This certificate proves the block entry and the image bijection. The stronger matrix-orthogonality bridge is closed by 'mainCaseProRationalOrthogonalBridgeObligation'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:493](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L493).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitVerified" (lean := "QuantumBlockEncoding.mainCaseProCircuitVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case pro circuit verified”. Verified task-local candidate for the advertised Pro transcript image.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified task-local candidate for the advertised Pro transcript image.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:503](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L503).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_cost" (lean := "QuantumBlockEncoding.mainCaseProCandidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:512](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L512).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_uses_matrix_table_metadata" (lean := "QuantumBlockEncoding.mainCaseProCandidate_uses_matrix_table_metadata")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro candidate uses matrix table metadata”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:517](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L517).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitCandidate_cost" (lean := "QuantumBlockEncoding.mainCaseProCircuitCandidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “main case pro circuit candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:523](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L523).
:::

:::definition "QuantumBlockEncoding.mainCaseColdSystemIndex" (lean := "QuantumBlockEncoding.mainCaseColdSystemIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold system index”. System-register index for one-bit registers ordered as '(T, tau, S)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System-register index for one-bit registers ordered as '(T, tau, S)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:538](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L538).
:::

:::definition "QuantumBlockEncoding.mainCaseColdTarget" (lean := "QuantumBlockEncoding.mainCaseColdTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold target”. The COLD target matrix for 'E\_1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The COLD target matrix for 'E\_1'. It maps '|1>\_T |1>\_tau |s>\_S' to '|0>\_T |0>\_tau |s>\_S' and annihilates every other computational-basis column.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:551](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L551).
:::

:::definition "QuantumBlockEncoding.mainCaseColdExactNormalizer" (lean := "QuantumBlockEncoding.mainCaseColdExactNormalizer")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold exact normalizer”. Exact normalizer for the no-Pro COLD target.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact normalizer for the no-Pro COLD target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:562](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L562).
:::

:::definition "QuantumBlockEncoding.mainCaseColdExactError" (lean := "QuantumBlockEncoding.mainCaseColdExactError")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold exact error”. Exact error for the no-Pro COLD target.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact error for the no-Pro COLD target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:565](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L565).
:::

:::definition "QuantumBlockEncoding.mainCaseColdQueryTarget" (lean := "QuantumBlockEncoding.mainCaseColdQueryTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold query target”. Operator-first target metadata for the no-Pro COLD benchmark.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Operator-first target metadata for the no-Pro COLD benchmark.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:568](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L568).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCleanSignal" (lean := "QuantumBlockEncoding.mainCaseColdCleanSignal")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold clean signal”. The clean block-selection index for the single signal ancilla.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The clean block-selection index for the single signal ancilla.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:584](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L584).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCleanEmbed" (lean := "QuantumBlockEncoding.mainCaseColdCleanEmbed")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold clean embed”. Clean embedding into the signal-system product basis.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Clean embedding into the signal-system product basis.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:587](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L587).
:::

:::definition "QuantumBlockEncoding.mainCaseColdBlockProjection" (lean := "QuantumBlockEncoding.mainCaseColdBlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold block projection”. Exact clean-block predicate for a one-signal-qubit COLD candidate matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact clean-block predicate for a one-signal-qubit COLD candidate matrix. The block projection is the '(signal,signal) = (0,0)' block of 'U', and it must equal 'mainCaseColdTarget' pointwise.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L596).
:::

:::definition "QuantumBlockEncoding.mainCaseColdSourceLayout" (lean := "QuantumBlockEncoding.mainCaseColdSourceLayout")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold source layout”. Source-facing layout: three system qubits and one clean signal ancilla.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Source-facing layout: three system qubits and one clean signal ancilla.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:603](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L603).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermImage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm image”. Candidate 'MAIN-PARTIAL-PERM-001' as a COLD task-local finite image table on the '(signal,T,tau,S)' basis.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Candidate 'MAIN-PARTIAL-PERM-001' as a COLD task-local finite image table on the '(signal,T,tau,S)' basis. The full index convention is 'signal \* 8 + mainCaseColdSystemIndex T tau S'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:614](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L614).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermMatrix" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm matrix”. Column-vector permutation matrix for 'MAIN-PARTIAL-PERM-001'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Column-vector permutation matrix for 'MAIN-PARTIAL-PERM-001'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:634](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L634).
:::

:::definition "QuantumBlockEncoding.mainCaseColdReducedOfFull" (lean := "QuantumBlockEncoding.mainCaseColdReducedOfFull")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold reduced of full”. Reduced active index for the COLD table bits '(tau,T,signal)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced active index for the COLD table bits '(tau,T,signal)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:638](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L638).
:::

:::definition "QuantumBlockEncoding.mainCaseColdStateOfFull" (lean := "QuantumBlockEncoding.mainCaseColdStateOfFull")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold state of full”. Passive state bit in the full '(signal,T,tau,S)' convention.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Passive state bit in the full '(signal,T,tau,S)' convention.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:642](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L642).
:::

:::definition "QuantumBlockEncoding.mainCaseColdLiftReducedImage" (lean := "QuantumBlockEncoding.mainCaseColdLiftReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold lift reduced image”. Lift a reduced active-register image while preserving the passive state bit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Lift a reduced active-register image while preserving the passive state bit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:646](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L646).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedXT" (lean := "QuantumBlockEncoding.mainCaseColdRedXT")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold red xt”. Reduced 'X' on the 'T' bit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced 'X' on the 'T' bit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:656](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L656).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedCCXTauTSignal" (lean := "QuantumBlockEncoding.mainCaseColdRedCCXTauTSignal")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold red ccx tau t signal”. Reduced Toffoli with controls 'tau,T' and target 'signal'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced Toffoli with controls 'tau,T' and target 'signal'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:667](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L667).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedXTau" (lean := "QuantumBlockEncoding.mainCaseColdRedXTau")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold red x tau”. Reduced 'X' on the 'tau' bit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced 'X' on the 'tau' bit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:673](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L673).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedCXSignalT" (lean := "QuantumBlockEncoding.mainCaseColdRedCXSignalT")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold red cx signal t”. Reduced CNOT with control 'signal' and target 'T'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced CNOT with control 'signal' and target 'T'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:684](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L684).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedCXTauSignal" (lean := "QuantumBlockEncoding.mainCaseColdRedCXTauSignal")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold red cx tau signal”. Reduced CNOT with control 'tau' and target 'signal'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced CNOT with control 'tau' and target 'signal'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:692](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L692).
:::

:::definition "QuantumBlockEncoding.mainCaseColdEvalReducedGateImages" (lean := "QuantumBlockEncoding.mainCaseColdEvalReducedGateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold eval reduced gate images”. Evaluate reduced logical reversible gates as basis-state permutations.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Evaluate reduced logical reversible gates as basis-state permutations.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:700](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L700).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermReducedImage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm reduced image”. Reduced COLD table induced by 'mainCaseColdPartialPermImage'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced COLD table induced by 'mainCaseColdPartialPermImage'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:705](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L705).
:::

:::definition "QuantumBlockEncoding.mainCaseColdReducedGateImages" (lean := "QuantumBlockEncoding.mainCaseColdReducedGateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold reduced gate images”. Reduced gate-image transcript for the COLD resource schema.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced gate-image transcript for the COLD resource schema.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:716](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L716).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCircuitReducedImage" (lean := "QuantumBlockEncoding.mainCaseColdCircuitReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold circuit reduced image”. Reduced active-register image induced by the COLD resource schema.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced active-register image induced by the COLD resource schema.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:725](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L725).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdReducedGateImages_eval" (lean := "QuantumBlockEncoding.mainCaseColdReducedGateImages_eval")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold reduced gate images eval”; the hypotheses and conclusion in the code panel fix its exact scope. The COLD logical reversible circuit implements the reduced table.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The COLD logical reversible circuit implements the reduced table.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:729](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L729).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCircuitImage" (lean := "QuantumBlockEncoding.mainCaseColdCircuitImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold circuit image”. Full active-plus-passive image induced by the COLD resource schema.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Full active-plus-passive image induced by the COLD resource schema.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:736](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L736).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdCircuitImage_eq_partialPermImage" (lean := "QuantumBlockEncoding.mainCaseColdCircuitImage_eq_partialPermImage")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold circuit image eq partial perm image”; the hypotheses and conclusion in the code panel fix its exact scope. The COLD logical reversible circuit implements the finite table.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The COLD logical reversible circuit implements the finite table.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:740](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L740).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateXT" (lean := "QuantumBlockEncoding.mainCaseColdGateXT")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold gate xt”. Logical 'X' on the time register 'T' in the full wire layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on the time register 'T' in the full wire layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:746](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L746).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateCCXTauTSignal" (lean := "QuantumBlockEncoding.mainCaseColdGateCCXTauTSignal")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold gate ccx tau t signal”. Logical Toffoli with controls 'tau,T' and target 'signal'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical Toffoli with controls 'tau,T' and target 'signal'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:750](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L750).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateXTau" (lean := "QuantumBlockEncoding.mainCaseColdGateXTau")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold gate x tau”. Logical 'X' on the type register 'tau' in the full wire layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on the type register 'tau' in the full wire layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:754](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L754).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateCXSignalT" (lean := "QuantumBlockEncoding.mainCaseColdGateCXSignalT")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold gate cx signal t”. Logical CNOT with control 'signal' and target 'T'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT with control 'signal' and target 'T'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:758](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L758).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateCXTauSignal" (lean := "QuantumBlockEncoding.mainCaseColdGateCXTauSignal")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold gate cx tau signal”. Logical CNOT with control 'tau' and target 'signal'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT with control 'tau' and target 'signal'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:762](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L762).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCircuit" (lean := "QuantumBlockEncoding.mainCaseColdCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold circuit”. COLD task-local logical circuit for the finite partial-permutation table.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* COLD task-local logical circuit for the finite partial-permutation table.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:766](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L766).
:::

:::definition "QuantumBlockEncoding.mainCaseColdSchedule" (lean := "QuantumBlockEncoding.mainCaseColdSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold schedule”. Sequential COLD schedule for the current logical transcript.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Sequential COLD schedule for the current logical transcript.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:775](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L775).
:::

:::definition "QuantumBlockEncoding.mainCaseColdHighLevelResource" (lean := "QuantumBlockEncoding.mainCaseColdHighLevelResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold high level resource”. High-level logical-library resource record for the COLD transcript.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* High-level logical-library resource record for the COLD transcript. At this semantic tier, Toffoli and CNOT are counted together as controlled logical gates, matching the main-case resource convention.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:788](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L788).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermCost" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm cost”. Source-facing COLD score '(gateCount, depth, auxiliaryQubits, oracleCalls)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Source-facing COLD score '(gateCount, depth, auxiliaryQubits, oracleCalls)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L792).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_gateCount" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:796](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L796).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_depth" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:799](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L799).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm cost auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:802](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L802).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_oracleCalls" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_oracleCalls")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm cost oracle calls”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:805](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L805).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective_pointwise" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm image injective pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:808](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L808).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm image injective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:813](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L813).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermPreimage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermPreimage")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm preimage”. Explicit inverse image table for the COLD partial-permutation certificate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Explicit inverse image table for the COLD partial-permutation certificate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:819](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L819).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_preimage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_preimage")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm image preimage”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L838).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_surjective" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_surjective")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm image surjective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:843](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L843).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermImageIsPermutation" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImageIsPermutation")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm image is permutation”. Task-local finite-permutation certificate for 'MAIN-PARTIAL-PERM-001'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Task-local finite-permutation certificate for 'MAIN-PARTIAL-PERM-001'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:850](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L850).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_bijective" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_bijective")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm image bijective”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:854](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L854).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPerm_entry" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_entry")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm entry”; the hypotheses and conclusion in the code panel fix its exact scope. Entrywise image calculation for the reusable partial-permutation wrapper.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Entrywise image calculation for the reusable partial-permutation wrapper.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:860](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L860).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermExactCleanBlock" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermExactCleanBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm exact clean block”. Exact clean-block package from the compiled partial-permutation leaf.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Exact clean-block package from the compiled partial-permutation leaf.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:875](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L875).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPerm_clean_eq_target" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_clean_eq_target")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm clean eq target”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:883](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L883).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPerm_blockProjection" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_blockProjection")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm block projection”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:891](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L891).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdQueryTarget_normalizer" (lean := "QuantumBlockEncoding.mainCaseColdQueryTarget_normalizer")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold query target normalizer”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:900](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L900).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdSourceLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseColdSourceLayout_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold source layout auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:903](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L903).
:::

:::definition "QuantumBlockEncoding.mainCaseColdResourceSchemaObligation" (lean := "QuantumBlockEncoding.mainCaseColdResourceSchemaObligation")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold resource schema obligation”. Resource-schema obligation for 'MAIN-RESOURCE-001'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Resource-schema obligation for 'MAIN-RESOURCE-001'. The COLD-local circuit image and resource field theorems below justify the advertised high-level logical resource tuple for the candidate package.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:912](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L912).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermCandidate" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCandidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm candidate”. COLD task-local candidate package at the finite-permutation semantic tier.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* COLD task-local candidate package at the finite-permutation semantic tier. The target, candidate matrix, block projection, and logical resource tuple are all COLD-local declarations; this package does not use the separate 'mainCasePro\*' arm as evidence.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:925](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L925).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermVerified" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “main case cold partial perm verified”. Verified COLD block-encoding package for the transfer operator at the current finite-permutation semantic tier.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified COLD block-encoding package for the transfer operator at the current finite-permutation semantic tier.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/MainCase.lean:942](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L942).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCandidate_cost" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCandidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “main case cold partial perm candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/MainCase.lean:952](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L952).
:::

# QuantumBlockEncoding/OptimalControl.lean

133 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.OptimalControl.IsPermutation" (lean := "QuantumBlockEncoding.OptimalControl.IsPermutation")
*Plain-English reading.* This definition gives the library's named construction or computation for “is permutation”. Local finite-permutation certificate used as a lightweight unitarity proxy.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Local finite-permutation certificate used as a lightweight unitarity proxy.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:28](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L28).
:::

:::definition "QuantumBlockEncoding.OptimalControl.targetState0" (lean := "QuantumBlockEncoding.OptimalControl.targetState0")
*Plain-English reading.* This definition gives the library's named construction or computation for “target state 0”. System index for 'time=0', 'type=0', 'state=0'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System index for 'time=0', 'type=0', 'state=0'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L32).
:::

:::definition "QuantumBlockEncoding.OptimalControl.targetState1" (lean := "QuantumBlockEncoding.OptimalControl.targetState1")
*Plain-English reading.* This definition gives the library's named construction or computation for “target state 1”. System index for 'time=0', 'type=0', 'state=1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System index for 'time=0', 'type=0', 'state=1'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:35](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L35).
:::

:::definition "QuantumBlockEncoding.OptimalControl.sourceState0" (lean := "QuantumBlockEncoding.OptimalControl.sourceState0")
*Plain-English reading.* This definition gives the library's named construction or computation for “source state 0”. System index for 'time=1', 'type=1', 'state=0'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System index for 'time=1', 'type=1', 'state=0'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:38](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L38).
:::

:::definition "QuantumBlockEncoding.OptimalControl.sourceState1" (lean := "QuantumBlockEncoding.OptimalControl.sourceState1")
*Plain-English reading.* This definition gives the library's named construction or computation for “source state 1”. System index for 'time=1', 'type=1', 'state=1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* System index for 'time=1', 'type=1', 'state=1'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:41](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L41).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleOperator" (lean := "QuantumBlockEncoding.OptimalControl.exampleOperator")
*Plain-English reading.* This definition gives the library's named construction or computation for “example operator”. The concrete 'E\_1' operator for one time qubit, one type qubit, and one state qubit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The concrete 'E\_1' operator for one time qubit, one type qubit, and one state qubit. It maps '|1>\_time |1>\_type |s>' to '|0>\_time |0>\_type |s>' and annihilates every other basis state.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:48](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L48).
:::

:::definition "QuantumBlockEncoding.OptimalControl.cleanIndex" (lean := "QuantumBlockEncoding.OptimalControl.cleanIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean index”. Clean-ancilla embedding into the first half of the one-ancilla space.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Clean-ancilla embedding into the first half of the one-ancilla space.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:57](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L57).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleTarget" (lean := "QuantumBlockEncoding.OptimalControl.exampleTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “example target”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L60).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleLayout" (lean := "QuantumBlockEncoding.OptimalControl.exampleLayout")
*Plain-English reading.* This definition gives the library's named construction or computation for “example layout”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:67](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L67).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleImage" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “example image”. Permutation image for the one-ancilla unitary completion.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Permutation image for the one-ancilla unitary completion. For each state bit 's', the four-cycle is '(0, source\_s) -> (0, target\_s) -> (1, source\_s) -> (1, target\_s) -> (0, source\_s)'. Every other system basis state just swaps the auxiliary qubit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:82](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L82).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleImageInv" (lean := "QuantumBlockEncoding.OptimalControl.exampleImageInv")
*Plain-English reading.* This definition gives the library's named construction or computation for “example image inv”. Inverse permutation for 'exampleImage'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Inverse permutation for 'exampleImage'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:101](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L101).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleImage_leftInverse" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage_leftInverse")
*Plain-English reading.* Lean checks the proposition indexed as “example image left inverse”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L119).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleImage_rightInverse" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage_rightInverse")
*Plain-English reading.* Lean checks the proposition indexed as “example image right inverse”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:123](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L123).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “example image is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. The image function is a finite permutation, hence a permutation unitary.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The image function is a finite permutation, hence a permutation unitary.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:128](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L128).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedTargetImage" (lean := "QuantumBlockEncoding.OptimalControl.reducedTargetImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced target image”. The reduced three-bit permutation induced by 'exampleImage' on '(type,time,aux)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The reduced three-bit permutation induced by 'exampleImage' on '(type,time,aux)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L149).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redX0" (lean := "QuantumBlockEncoding.OptimalControl.redX0")
*Plain-English reading.* This definition gives the library's named construction or computation for “red x 0”. Logical 'X' on reduced bit 0.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on reduced bit 0.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:160](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L160).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redX2" (lean := "QuantumBlockEncoding.OptimalControl.redX2")
*Plain-English reading.* This definition gives the library's named construction or computation for “red x 2”. Logical 'X' on reduced bit 2.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on reduced bit 2.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:171](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L171).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redX1" (lean := "QuantumBlockEncoding.OptimalControl.redX1")
*Plain-English reading.* This definition gives the library's named construction or computation for “red x 1”. Logical 'X' on reduced bit 1.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on reduced bit 1.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:182](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L182).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX01" (lean := "QuantumBlockEncoding.OptimalControl.redCX01")
*Plain-English reading.* This definition gives the library's named construction or computation for “red cx 01”. Logical CNOT with control reduced bit 0 and target reduced bit 1.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT with control reduced bit 0 and target reduced bit 1.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:193](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L193).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX10" (lean := "QuantumBlockEncoding.OptimalControl.redCX10")
*Plain-English reading.* This definition gives the library's named construction or computation for “red cx 10”. Logical CNOT with control reduced bit 1 and target reduced bit 0.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT with control reduced bit 1 and target reduced bit 0.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:201](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L201).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX20" (lean := "QuantumBlockEncoding.OptimalControl.redCX20")
*Plain-English reading.* This definition gives the library's named construction or computation for “red cx 20”. Logical CNOT with control reduced bit 2 and target reduced bit 0.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT with control reduced bit 2 and target reduced bit 0.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:209](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L209).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX21" (lean := "QuantumBlockEncoding.OptimalControl.redCX21")
*Plain-English reading.* This definition gives the library's named construction or computation for “red cx 21”. Logical CNOT with control reduced bit 2 and target reduced bit 1.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT with control reduced bit 2 and target reduced bit 1.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:217](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L217).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCCX012" (lean := "QuantumBlockEncoding.OptimalControl.redCCX012")
*Plain-English reading.* This definition gives the library's named construction or computation for “red ccx 012”. Logical Toffoli with controls reduced bits 0,1 and target reduced bit 2.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical Toffoli with controls reduced bits 0,1 and target reduced bit 2.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:225](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L225).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Image" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Image")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 image”. Depth-5 logical circuit found by the first EoH-style explore pass: 1.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Depth-5 logical circuit found by the first EoH-style explore pass: 1. 'CCX(0,1;2)' 2. 'CX(0,1)' 3. 'CX(1,0)' 4. 'X(0)' 5. parallel layer '\{X(2), CX(0,1)\}'

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:239](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L239).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Image_eq_target" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Image_eq_target")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 image eq target”; the hypotheses and conclusion in the code panel fix its exact scope. The expanded logical circuit realizes the same reduced permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The expanded logical circuit realizes the same reduced permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:243](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L243).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedOfFull" (lean := "QuantumBlockEncoding.OptimalControl.reducedOfFull")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced of full”. Extract the active '(type,time,aux)' register from the full index.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Extract the active '(type,time,aux)' register from the full index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:248](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L248).
:::

:::definition "QuantumBlockEncoding.OptimalControl.stateOfFull" (lean := "QuantumBlockEncoding.OptimalControl.stateOfFull")
*Plain-English reading.* This definition gives the library's named construction or computation for “state of full”. Extract the passive state bit from the full index.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Extract the passive state bit from the full index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:252](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L252).
:::

:::definition "QuantumBlockEncoding.OptimalControl.liftReducedImage" (lean := "QuantumBlockEncoding.OptimalControl.liftReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “lift reduced image”. Lift a reduced active-register permutation while leaving the state bit fixed.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Lift a reduced active-register permutation while leaving the state bit fixed.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:256](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L256).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5_lifts_exampleImage" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5_lifts_exampleImage")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 lifts example image”; the hypotheses and conclusion in the code panel fix its exact scope. The depth-5 reduced circuit lifts to the full one-ancilla permutation because the state bit is passive.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 reduced circuit lifts to the full one-ancilla permutation because the state bit is passive.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:266](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L266).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Full_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Full_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 full is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. The depth-5 full active-plus-state completion is a permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 full active-plus-state completion is a permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:271](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L271).
:::

:::definition "QuantumBlockEncoding.OptimalControl.unitaryFromReducedImage" (lean := "QuantumBlockEncoding.OptimalControl.unitaryFromReducedImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “unitary from reduced image”. Matrix induced by a reduced active-register permutation lifted over the passive state bit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix induced by a reduced active-register permutation lifted over the passive state bit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:280](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L280).
:::

:::definition "QuantumBlockEncoding.OptimalControl.CleanBlockE1" (lean := "QuantumBlockEncoding.OptimalControl.CleanBlockE1")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block e 1”. The clean block condition for the concrete optimal-control target.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The clean block condition for the concrete optimal-control target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:284](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L284).
:::

:::definition "QuantumBlockEncoding.OptimalControl.columnInner" (lean := "QuantumBlockEncoding.OptimalControl.columnInner")
*Plain-English reading.* This definition gives the library's named construction or computation for “column inner”. Column inner products for concrete rational matrix-level unitarity checks.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Column inner products for concrete rational matrix-level unitarity checks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:290](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L290).
:::

:::definition "QuantumBlockEncoding.OptimalControl.rowInner" (lean := "QuantumBlockEncoding.OptimalControl.rowInner")
*Plain-English reading.* This definition gives the library's named construction or computation for “row inner”. Row inner products for concrete rational matrix-level unitarity checks.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Row inner products for concrete rational matrix-level unitarity checks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:294](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L294).
:::

:::definition "QuantumBlockEncoding.OptimalControl.IsRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.IsRationalOrthogonal")
*Plain-English reading.* This definition gives the library's named construction or computation for “is rational orthogonal”. Concrete real/rational unitary proxy for this finite permutation-matrix sandbox.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Concrete real/rational unitary proxy for this finite permutation-matrix sandbox. Since all entries are rational and all current exact circuits are real, this is the finite 'UᵀU = I' and 'UUᵀ = I' condition.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:302](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L302).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleOperator_not_rationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.exampleOperator_not_rationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “example operator not rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope. The target operator itself is not unitary.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The target operator itself is not unitary. Therefore an exact unscaled zero-auxiliary block encoding cannot use 'E\_1' as the whole unitary matrix. One auxiliary qubit is locally necessary for this concrete exact construction model.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:312](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L312).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 clean block”; the hypotheses and conclusion in the code panel fix its exact scope. The depth-5 fixed-completion candidate has the required clean block.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 fixed-completion candidate has the required clean block.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:322](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L322).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 unitary”. Matrix of the depth-5 fixed-completion logical circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix of the depth-5 fixed-completion logical circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:327](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L327).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_isRationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 unitary is rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope. The depth-5 fixed-completion matrix is rational orthogonal/unitary.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 fixed-completion matrix is rational orthogonal/unitary.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:331](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L331).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 unitary clean block”; the hypotheses and conclusion in the code panel fix its exact scope. The depth-5 fixed-completion matrix has the required clean block.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 fixed-completion matrix has the required clean block.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:339](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L339).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferImage" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer image”. ChatGPT Pro's structured equality-flag/transfer construction specialized to the concrete 'r = 1, k = 1' instance: 1.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* ChatGPT Pro's structured equality-flag/transfer construction specialized to the concrete 'r = 1, k = 1' instance: 1. 'CCX(type,time;aux)' flags 'time=1,type=1'. 2. 'CX(aux,time)' transfers flagged 'time' to '0'. 3. 'CX(aux,type)' transfers flagged 'type' to '0'. 4. 'X(aux)' moves the selected branch back into the clean block.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:354](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L354).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferImage_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer image is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. Pro's reduced active-register map is a permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's reduced active-register map is a permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:358](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L358).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferFull_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferFull_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer full is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. Pro's full active-plus-state completion is a permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's full active-plus-state completion is a permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:364](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L364).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransfer_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransfer_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer clean block”; the hypotheses and conclusion in the code panel fix its exact scope. Pro's construction has the required clean block for the concrete target.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's construction has the required clean block for the concrete target.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:370](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L370).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer unitary”. Matrix of Pro's equality-flag/transfer construction.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix of Pro's equality-flag/transfer construction.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:375](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L375).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_isRationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer unitary is rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope. Pro's equality-flag/transfer matrix is rational orthogonal/unitary.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's equality-flag/transfer matrix is rational orthogonal/unitary.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:379](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L379).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer unitary clean block”; the hypotheses and conclusion in the code panel fix its exact scope. Pro's equality-flag/transfer matrix has the required clean block.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's equality-flag/transfer matrix has the required clean block.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:387](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L387).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip image”. An evolved child of the Pro construction.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* An evolved child of the Pro construction. The same equality flag is followed by a parallel layer of three 'X' gates on '(type,time,aux)'. This uses the freedom in the unitary completion: it does not reproduce 'exampleImage', but it does satisfy the same clean-block contract.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:399](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L399).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip image is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. The evolved reduced active-register map is a permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved reduced active-register map is a permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:403](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L403).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipFull_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipFull_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip full is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. The evolved full active-plus-state completion is a permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved full active-plus-state completion is a permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:409](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L409).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlip_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlip_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip clean block”; the hypotheses and conclusion in the code panel fix its exact scope. The evolved depth-2 construction has the required clean block.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved depth-2 construction has the required clean block.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:415](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L415).
:::

:::definition "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost" (lean := "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost")
*Plain-English reading.* This record groups the data and proof fields needed for “logical reversible cost”. A proposition-valued field is a requirement until a constructor supplies it. Lightweight score for the logical reversible gate library '\{X,CNOT,Toffoli\}'.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Lightweight score for the logical reversible gate library '\{X,CNOT,Toffoli\}'.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/OptimalControl.lean:420](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L420).
:::

:::definition "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.gateCount" (lean := "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.gateCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate count”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:431](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L431).
:::

:::definition "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.betterThan" (lean := "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.betterThan")
*Plain-English reading.* This definition gives the library's named construction or computation for “better than”. Lexicographic order inside one fixed logical reversible gate library.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Lexicographic order inside one fixed logical reversible gate library. ABEIS compares asymptotic scale first outside this concrete record. Once two candidates are in the same scale class for the chosen backend, the local priority is gate count, then parallel depth, then auxiliary qubits, then unexpanded oracle calls.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:442](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L442).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 cost”. Expanded score for 'reducedDepth5Image' before hardware decomposition.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Expanded score for 'reducedDepth5Image' before hardware decomposition.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:454](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L454).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_gateCount" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:462](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L462).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_oracleFree" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_oracleFree")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 cost oracle free”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:466](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L466).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferCost" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer cost”. Expanded score for Pro's equality-flag/transfer construction.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Expanded score for Pro's equality-flag/transfer construction.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:471](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L471).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferCost_gateCount" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:479](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L479).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferCost_betterThan_depth5" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCost_betterThan_depth5")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer cost better than depth 5”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:483](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L483).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip cost”. Expanded score for the evolved equality-flag/parallel-flip construction.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Expanded score for the evolved equality-flag/parallel-flip construction.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:489](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L489).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_gateCount" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:497](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L497).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_pro" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_pro")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip cost better than pro”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:501](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L501).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_depth5" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_depth5")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip cost better than depth 5”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:506](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L506).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip unitary”. Matrix of the evolved depth-2 logical gate product.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix of the evolved depth-2 logical gate product.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:512](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L512).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip unitary is rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope. The evolved matrix is a concrete rational unitary matrix in the project-local real/permutation sense: both its column and row Gram matrices are identity.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved matrix is a concrete rational unitary matrix in the project-local real/permutation sense: both its column and row Gram matrices are identity.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:519](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L519).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip unitary clean block”; the hypotheses and conclusion in the code panel fix its exact scope. The evolved concrete matrix has the required clean block.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved concrete matrix has the required clean block.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:527](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L527).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedGateMatrix" (lean := "QuantumBlockEncoding.OptimalControl.reducedGateMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced gate matrix”. Full-space gate matrix for a reduced active-register permutation.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Full-space gate matrix for a reduced active-register permutation.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:534](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L534).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCCX_type_time_aux" (lean := "QuantumBlockEncoding.OptimalControl.gateCCX_type_time_aux")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate ccx type time aux”. Logical Toffoli gate 'CCX(type,time;aux)' in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical Toffoli gate 'CCX(type,time;aux)' in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:545](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L545).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateX_type" (lean := "QuantumBlockEncoding.OptimalControl.gateX_type")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate x type”. Logical 'X' on the type bit in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on the type bit in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:549](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L549).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateX_time" (lean := "QuantumBlockEncoding.OptimalControl.gateX_time")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate x time”. Logical 'X' on the time bit in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on the time bit in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:553](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L553).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateX_aux" (lean := "QuantumBlockEncoding.OptimalControl.gateX_aux")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate x aux”. Logical 'X' on the block-encoding auxiliary bit in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical 'X' on the block-encoding auxiliary bit in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:557](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L557).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_type_time" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_type_time")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate cx type time”. Logical CNOT from type to time in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT from type to time in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:561](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L561).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_time_type" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_time_type")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate cx time type”. Logical CNOT from time to type in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT from time to type in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:565](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L565).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_aux_type" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_aux_type")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate cx aux type”. Logical CNOT from auxiliary to type in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT from auxiliary to type in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:569](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L569).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_aux_time" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_aux_time")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate cx aux time”. Logical CNOT from auxiliary to time in the concrete layout.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical CNOT from auxiliary to time in the concrete layout.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:573](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L573).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Circuit" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Circuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 circuit”. The depth-5 fixed-completion circuit in sequential-list form.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 fixed-completion circuit in sequential-list form.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:577](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L577).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Schedule" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Schedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 schedule”. The depth-5 fixed-completion schedule.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 fixed-completion schedule.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:587](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L587).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 gate matrices”. Gate matrices for the depth-5 fixed-completion circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Gate matrices for the depth-5 fixed-completion circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L596).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices_matchCircuit")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 gate matrices match circuit”; the hypotheses and conclusion in the code panel fix its exact scope. The gate-matrix labels match the depth-5 circuit transcript.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The gate-matrix labels match the depth-5 circuit transcript.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:606](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L606).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evalReducedGateImages" (lean := "QuantumBlockEncoding.OptimalControl.evalReducedGateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval reduced gate images”. Evaluate reduced logical reversible gates as basis-state permutations.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Evaluate reduced logical reversible gates as basis-state permutations.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:611](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L611).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 gate images”. Reduced permutation images of the depth-5 logical circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced permutation images of the depth-5 logical circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:615](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L615).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages_eval")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 gate images eval”; the hypotheses and conclusion in the code panel fix its exact scope. The depth-5 logical reversible circuit implements 'reducedDepth5Image'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The depth-5 logical reversible circuit implements 'reducedDepth5Image'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:619](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L619).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferCircuit" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer circuit”. Pro's equality-flag/transfer circuit in sequential-list form.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's equality-flag/transfer circuit in sequential-list form.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:625](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L625).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferSchedule" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer schedule”. Pro's equality-flag/transfer schedule.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's equality-flag/transfer schedule.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:629](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L629).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer gate matrices”. Gate matrices for Pro's equality-flag/transfer circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Gate matrices for Pro's equality-flag/transfer circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:633](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L633).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices_matchCircuit")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer gate matrices match circuit”; the hypotheses and conclusion in the code panel fix its exact scope. The gate-matrix labels match Pro's circuit transcript.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The gate-matrix labels match Pro's circuit transcript.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:641](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L641).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer gate images”. Reduced permutation images of Pro's logical circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced permutation images of Pro's logical circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:646](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L646).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages_eval")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer gate images eval”; the hypotheses and conclusion in the code panel fix its exact scope. Pro's logical reversible circuit implements 'proEqTransferImage'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Pro's logical reversible circuit implements 'proEqTransferImage'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:650](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L650).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCircuit" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip circuit”. The evolved depth-2 circuit in sequential-list form.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved depth-2 circuit in sequential-list form.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:656](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L656).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipSchedule" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip schedule”. The evolved depth-2 schedule: one Toffoli layer, then three parallel flips.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The evolved depth-2 schedule: one Toffoli layer, then three parallel flips.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:660](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L660).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip gate matrices”. Gate matrices for the evolved concrete circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Gate matrices for the evolved concrete circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:664](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L664).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices_matchCircuit")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip gate matrices match circuit”; the hypotheses and conclusion in the code panel fix its exact scope. The gate-matrix labels match the evolved circuit transcript.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The gate-matrix labels match the evolved circuit transcript.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:672](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L672).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip gate images”. Reduced permutation images of the evolved logical circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced permutation images of the evolved logical circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:677](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L677).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_eval")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip gate images eval”; the hypotheses and conclusion in the code panel fix its exact scope. The logical reversible circuit implements exactly the reduced permutation used to build 'evolvedEqFlipUnitary'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The logical reversible circuit implements exactly the reduced permutation used to build 'evolvedEqFlipUnitary'. This is the efficient semantic bridge for the current logical reversible tier; the heavier raw 'evalGateMatrices' product is left to a later backend if the project chooses a hardware decomposition.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:686](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L686).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_lift_eval" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_lift_eval")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip gate images lift eval”; the hypotheses and conclusion in the code panel fix its exact scope. The lifted logical circuit implements the full active-plus-state image.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The lifted logical circuit implements the full active-plus-state image.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:692](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L692).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Resource" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 resource”. Resource record for the depth-5 logical '\{X,CNOT,Toffoli\}' interpretation.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Resource record for the depth-5 logical '\{X,CNOT,Toffoli\}' interpretation. The current 'Resource' type has no Toffoli field, so 'cnot' stores all controlled logical gates in this tier.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:703](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L703).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferResource" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer resource”. Resource record for Pro's logical '\{X,CNOT,Toffoli\}' interpretation.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Resource record for Pro's logical '\{X,CNOT,Toffoli\}' interpretation. The current 'Resource' type has no Toffoli field, so 'cnot' stores all controlled logical gates in this tier.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:711](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L711).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipResource" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip resource”. Resource record for the evolved logical '\{X,CNOT,Toffoli\}' interpretation.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Resource record for the evolved logical '\{X,CNOT,Toffoli\}' interpretation. The current 'Resource' type has no Toffoli field, so 'cnot' stores the single logical Toffoli in this tier.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:719](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L719).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 candidate”. Verified candidate data for the older depth-5 concrete logical BE.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified candidate data for the older depth-5 concrete logical BE.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:723](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L723).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Verified" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Verified")
*Plain-English reading.* This definition gives the library's named construction or computation for “reduced depth 5 verified”. Verified concrete depth-5 block encoding for 'E\_1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified concrete depth-5 block encoding for 'E\_1'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:739](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L739).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “reduced depth 5 candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope. The verified depth-5 candidate has the advertised logical-library score.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The verified depth-5 candidate has the advertised logical-library score.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:749](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L749).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer candidate”. Verified candidate data for Pro's equality-flag/transfer BE.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified candidate data for Pro's equality-flag/transfer BE.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:755](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L755).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferVerified" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “pro eq transfer verified”. Verified concrete Pro block encoding for 'E\_1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified concrete Pro block encoding for 'E\_1'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:771](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L771).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “pro eq transfer candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope. The verified Pro candidate has the advertised logical-library score.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The verified Pro candidate has the advertised logical-library score.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:781](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L781).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip candidate”. Final concrete block-encoding candidate for the one-time-bit, one-type-bit, one-state-bit optimal-control target.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Final concrete block-encoding candidate for the one-time-bit, one-type-bit, one-state-bit optimal-control target. This is final only for this concrete logical gate-matrix tier; general 'k', wider time registers, and hardware decomposition remain separate tasks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L792).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip verified”. Verified concrete depth-2 block encoding for 'E\_1'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Verified concrete depth-2 block encoding for 'E\_1'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:808](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L808).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipZeroErrorApprox" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipZeroErrorApprox")
*Plain-English reading.* This definition gives the library's named construction or computation for “evolved eq flip zero error approx”. The exact evolved candidate is also a zero-error approximate block encoding.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The exact evolved candidate is also a zero-error approximate block encoding. This is the Lean anchor for Scenario 1 of the adaptive exact-to-approximate policy: after exact convergence, approximate search may continue, but the current champion already satisfies every nonnegative requested tolerance.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:823](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L823).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “evolved eq flip candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope. The verified evolved candidate has the advertised logical-library score.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The verified evolved candidate has the advertised logical-library score.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:828](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L828).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation target”. Route-ablation target block with entries 'target\[0, 6\] = 1' and 'target\[1, 7\] = 1', and all other entries zero.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Route-ablation target block with entries 'target\[0, 6\] = 1' and 'target\[1, 7\] = 1', and all other entries zero.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:848](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L848).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget_eq_exampleOperator" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget_eq_exampleOperator")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation target eq example operator”; the hypotheses and conclusion in the code panel fix its exact scope. The route-ablation target is entrywise the concrete 'E\_1' target used above.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The route-ablation target is entrywise the concrete 'E\_1' target used above.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:856](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L856).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationCircuit" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation circuit”. Direct route-ablation circuit in sequential-list form.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Direct route-ablation circuit in sequential-list form.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:862](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L862).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationSchedule" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation schedule”. Direct route-ablation schedule: Toffoli first, then the three flips.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Direct route-ablation schedule: Toffoli first, then the three flips.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:866](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L866).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation gate images”. Reduced permutation images for the direct route-ablation circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced permutation images for the direct route-ablation circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:870](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L870).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationImage" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationImage")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation image”. Reduced active-register image induced by the direct route-ablation circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Reduced active-register image induced by the direct route-ablation circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:874](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L874).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages_eval")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation gate images eval”; the hypotheses and conclusion in the code panel fix its exact scope. The direct route-ablation circuit is the stated 'CCX; X(type); X(time); X(aux)' map.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The direct route-ablation circuit is the stated 'CCX; X(type); X(time); X(aux)' map.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:878](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L878).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationImage_isPermutation")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation image is permutation”; the hypotheses and conclusion in the code panel fix its exact scope. The direct route-ablation image is a finite permutation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The direct route-ablation image is a finite permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:884](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L884).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation unitary”. Matrix of the direct route-ablation logical circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix of the direct route-ablation logical circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:890](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L890).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary_isRationalOrthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation unitary is rational orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope. The direct route-ablation matrix is rational orthogonal/unitary in the project-local finite permutation sense.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The direct route-ablation matrix is rational orthogonal/unitary in the project-local finite permutation sense.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:897](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L897).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblation_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblation_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation clean block”; the hypotheses and conclusion in the code panel fix its exact scope. Named clean-block theorem for the controlled route ablation.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Named clean-block theorem for the controlled route ablation. The top-left auxiliary block, with auxiliary input and output both '0', is exactly the requested 'E\_1' matrix.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:910](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L910).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation gate matrices”. Gate matrices for the direct route-ablation circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Gate matrices for the direct route-ablation circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:917](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L917).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices_matchCircuit")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation gate matrices match circuit”; the hypotheses and conclusion in the code panel fix its exact scope. The direct route-ablation gate-matrix labels match its circuit transcript.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The direct route-ablation gate-matrix labels match its circuit transcript.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:925](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L925).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationCost" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation cost”. Logical-library cost for the direct route-ablation circuit.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Logical-library cost for the direct route-ablation circuit.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:931](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L931).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple")
*Plain-English reading.* This definition gives the library's named construction or computation for “direct route ablation resource tuple”. Resource tuple in route-ablation order: '(gateCount, depth, auxiliaryQubits, oracleCalls)'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Resource tuple in route-ablation order: '(gateCount, depth, auxiliaryQubits, oracleCalls)'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:940](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L940).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple_eq" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple_eq")
*Plain-English reading.* Lean checks the proposition indexed as “direct route ablation resource tuple eq”; the hypotheses and conclusion in the code panel fix its exact scope. The direct route-ablation resource tuple is '(4, 2, 1, 0)'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The direct route-ablation resource tuple is '(4, 2, 1, 0)'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:948](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L948).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleUnitary" (lean := "QuantumBlockEncoding.OptimalControl.exampleUnitary")
*Plain-English reading.* This definition gives the library's named construction or computation for “example unitary”. Matrix of the one-ancilla permutation unitary completion.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* Matrix of the one-ancilla permutation unitary completion.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:953](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L953).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.example_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.example_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “example clean block”; the hypotheses and conclusion in the code panel fix its exact scope. The clean block of 'exampleUnitary' is exactly the optimal-control operator 'E\_1' on the 8-dimensional system register.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The clean block of 'exampleUnitary' is exactly the optimal-control operator 'E\_1' on the 8-dimensional system register.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:960](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L960).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleCircuit" (lean := "QuantumBlockEncoding.OptimalControl.exampleCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “example circuit”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:966](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L966).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleSchedule" (lean := "QuantumBlockEncoding.OptimalControl.exampleSchedule")
*Plain-English reading.* This definition gives the library's named construction or computation for “example schedule”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:969](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L969).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleResource" (lean := "QuantumBlockEncoding.OptimalControl.exampleResource")
*Plain-English reading.* This definition gives the library's named construction or computation for “example resource”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:972](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L972).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleCandidate" (lean := "QuantumBlockEncoding.OptimalControl.exampleCandidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “example candidate”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:975](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L975).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleVerified" (lean := "QuantumBlockEncoding.OptimalControl.exampleVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “example verified”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/OptimalControl.lean:990](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L990).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleCandidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.exampleCandidate_cost")
*Plain-English reading.* Lean checks the proposition indexed as “example candidate cost”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Completed transfer-operator and optimal-control certificates used as end-to-end case studies.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/OptimalControl.lean:995](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L995).
:::
