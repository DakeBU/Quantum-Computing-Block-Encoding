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

# QuantumBlockEncoding/ColdStartTransferE1.lean

28 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.coldE1SystemIndex" (lean := "QuantumBlockEncoding.coldE1SystemIndex")
Source documentation: `System-register index for one-bit registers ordered as '(T, tau, S)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L19).
:::

:::definition "QuantumBlockEncoding.coldE1Target" (lean := "QuantumBlockEncoding.coldE1Target")
Source documentation: `The target matrix for 'E_1'. It has support exactly on the two entries mapping '|1>_T |1>_tau |s>_S' to '|0>_T |0>_tau |s>_S'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L32).
:::

:::definition "QuantumBlockEncoding.coldE1QueryTarget" (lean := "QuantumBlockEncoding.coldE1QueryTarget")
Source documentation: `Operator-first target metadata for the strict cold-start benchmark.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:41](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L41).
:::

:::definition "QuantumBlockEncoding.coldE1SignalIndex" (lean := "QuantumBlockEncoding.coldE1SignalIndex")
Source documentation: `The clean block-selection index for the single signal ancilla.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:55](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L55).
:::

:::definition "QuantumBlockEncoding.coldE1BlockProjection" (lean := "QuantumBlockEncoding.coldE1BlockProjection")
Source documentation: `Exact clean-block predicate for a one-signal-qubit candidate matrix. The block projection is the '(signalIndex, signalIndex)' block of 'U', and it must equal 'coldE1Target' pointwise.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:63](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L63).
:::

:::definition "QuantumBlockEncoding.coldE1ExactNormalizer" (lean := "QuantumBlockEncoding.coldE1ExactNormalizer")
Source documentation: `Exact normalizer for the requested block encoding.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:70](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L70).
:::

:::definition "QuantumBlockEncoding.coldE1ExactError" (lean := "QuantumBlockEncoding.coldE1ExactError")
Source documentation: `Exact error for the requested block encoding.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:73](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L73).
:::

:::definition "QuantumBlockEncoding.coldE1SourceLayout" (lean := "QuantumBlockEncoding.coldE1SourceLayout")
Source documentation: `Source-facing layout: three system qubits and one clean signal ancilla.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:76](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L76).
:::

:::definition "QuantumBlockEncoding.coldE1HighLevelSeedCost" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost")
Source documentation: `Source-facing seed cost under the high-level reversible-gate convention in the conversion window. This is not a certified 'Circuit.resource' expansion.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:85](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L85).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_gateCount" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:91](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L91).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_depth" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:94](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L94).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_auxiliaryQubits" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:97](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L97).
:::

:::theorem "QuantumBlockEncoding.coldE1HighLevelSeedCost_oracleCalls" (lean := "QuantumBlockEncoding.coldE1HighLevelSeedCost_oracleCalls")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:100](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L100).
:::

:::definition "QuantumBlockEncoding.coldE1CandidateImage" (lean := "QuantumBlockEncoding.coldE1CandidateImage")
Source documentation: `Candidate 'COLD-CLEAN-PERM-001' as a finite image table on '(signal,T,tau,S)' basis states. The full index convention is 'signal * 8 + coldE1SystemIndex T tau S'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:109](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L109).
:::

:::definition "QuantumBlockEncoding.coldE1CandidateMatrix" (lean := "QuantumBlockEncoding.coldE1CandidateMatrix")
Source documentation: `Column-vector permutation matrix for 'COLD-CLEAN-PERM-001'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:129](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L129).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state0" (lean := "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state0")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:132](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L132).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state1" (lean := "QuantumBlockEncoding.coldE1CandidateImage_clean_source_state1")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:136](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L136).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_injective_pointwise" (lean := "QuantumBlockEncoding.coldE1CandidateImage_injective_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:140](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L140).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_injective" (lean := "QuantumBlockEncoding.coldE1CandidateImage_injective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:144](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L144).
:::

:::definition "QuantumBlockEncoding.coldE1CandidatePreimage" (lean := "QuantumBlockEncoding.coldE1CandidatePreimage")
Source documentation: `Explicit inverse image table for the task-local permutation certificate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:150](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L150).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_preimage" (lean := "QuantumBlockEncoding.coldE1CandidateImage_preimage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:169](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L169).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_surjective" (lean := "QuantumBlockEncoding.coldE1CandidateImage_surjective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:173](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L173).
:::

:::theorem "QuantumBlockEncoding.coldE1CandidateImage_permutation_certificate" (lean := "QuantumBlockEncoding.coldE1CandidateImage_permutation_certificate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:178](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L178).
:::

:::theorem "QuantumBlockEncoding.coldE1Target_support_state0" (lean := "QuantumBlockEncoding.coldE1Target_support_state0")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:183](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L183).
:::

:::theorem "QuantumBlockEncoding.coldE1Target_support_state1" (lean := "QuantumBlockEncoding.coldE1Target_support_state1")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:187](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L187).
:::

:::theorem "QuantumBlockEncoding.coldE1Candidate_blockProjection" (lean := "QuantumBlockEncoding.coldE1Candidate_blockProjection")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:191](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L191).
:::

:::theorem "QuantumBlockEncoding.coldE1QueryTarget_normalizer" (lean := "QuantumBlockEncoding.coldE1QueryTarget_normalizer")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:199](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L199).
:::

:::theorem "QuantumBlockEncoding.coldE1SourceLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.coldE1SourceLayout_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/ColdStartTransferE1.lean:202](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/ColdStartTransferE1.lean#L202).
:::

# QuantumBlockEncoding/MainCase.lean

127 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.mainCaseProSystemIndex" (lean := "QuantumBlockEncoding.mainCaseProSystemIndex")
Source documentation: `System-register index for one-bit registers ordered as '(T, tau, S)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:20](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L20).
:::

:::definition "QuantumBlockEncoding.mainCaseProTarget" (lean := "QuantumBlockEncoding.mainCaseProTarget")
Source documentation: `The target matrix for 'E_1'. It maps '|1>_T |1>_tau |s>_S' to '|0>_T |0>_tau |s>_S' and annihilates every other computational-basis column.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:33](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L33).
:::

:::definition "QuantumBlockEncoding.mainCaseProQueryTarget" (lean := "QuantumBlockEncoding.mainCaseProQueryTarget")
Source documentation: `Operator-first target metadata for the Pro-isolated main-case benchmark.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:44](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L44).
:::

:::definition "QuantumBlockEncoding.mainCaseProSignalIndex" (lean := "QuantumBlockEncoding.mainCaseProSignalIndex")
Source documentation: `The clean block-selection index for the single signal ancilla.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L60).
:::

:::definition "QuantumBlockEncoding.mainCaseProCleanEmbed" (lean := "QuantumBlockEncoding.mainCaseProCleanEmbed")
Source documentation: `Clean embedding into the signal-system product basis.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:63](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L63).
:::

:::definition "QuantumBlockEncoding.mainCaseProBlockProjection" (lean := "QuantumBlockEncoding.mainCaseProBlockProjection")
Source documentation: `Exact clean-block predicate for a one-signal-qubit candidate matrix. The block projection is the '(signalIndex, signalIndex)' block of 'U', and it must equal 'mainCaseProTarget' pointwise.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:72](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L72).
:::

:::definition "QuantumBlockEncoding.mainCaseProExactNormalizer" (lean := "QuantumBlockEncoding.mainCaseProExactNormalizer")
Source documentation: `Exact normalizer for the requested block encoding.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:79](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L79).
:::

:::definition "QuantumBlockEncoding.mainCaseProExactError" (lean := "QuantumBlockEncoding.mainCaseProExactError")
Source documentation: `Exact error for the requested block encoding.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:82](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L82).
:::

:::definition "QuantumBlockEncoding.mainCaseProSourceLayout" (lean := "QuantumBlockEncoding.mainCaseProSourceLayout")
Source documentation: `Source-facing layout: three system qubits and one clean signal ancilla.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:85](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L85).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuit" (lean := "QuantumBlockEncoding.mainCaseProCircuit")
Source documentation: `Logical '{X,CNOT,Toffoli}' transcript for the Pro equality-transfer idea.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:91](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L91).
:::

:::definition "QuantumBlockEncoding.mainCaseProSchedule" (lean := "QuantumBlockEncoding.mainCaseProSchedule")
Source documentation: `Sequential high-level schedule for the current logical transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:99](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L99).
:::

:::definition "QuantumBlockEncoding.mainCaseProHighLevelResource" (lean := "QuantumBlockEncoding.mainCaseProHighLevelResource")
Source documentation: `High-level logical-library resource record for the Pro equality-transfer transcript. The current 'Resource' type has no Toffoli field, so controlled logical gates are counted in the 'cnot' bucket at this semantic tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:111](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L111).
:::

:::definition "QuantumBlockEncoding.mainCaseProHighLevelSeedCost" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost")
Source documentation: `Source-facing high-level score '(gateCount, depth, auxiliaryQubits, oracleCalls)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:115](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L115).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_gateCount" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L119).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_depth" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:122](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L122).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:125](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L125).
:::

:::theorem "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_oracleCalls" (lean := "QuantumBlockEncoding.mainCaseProHighLevelSeedCost_oracleCalls")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:128](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L128).
:::

:::definition "QuantumBlockEncoding.mainCaseProMatrixTableResource" (lean := "QuantumBlockEncoding.mainCaseProMatrixTableResource")
Source documentation: `Matrix-table metadata for 'mainCaseProCandidate'. This incumbent is a finite permutation witness, not the advertised Pro four-gate transcript. The single oracle call marks the unresolved executable realization instead of reusing 'mainCaseProCircuit'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:138](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L138).
:::

:::definition "QuantumBlockEncoding.mainCaseProMatrixTableCircuit" (lean := "QuantumBlockEncoding.mainCaseProMatrixTableCircuit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:141](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L141).
:::

:::definition "QuantumBlockEncoding.mainCaseProMatrixTableSchedule" (lean := "QuantumBlockEncoding.mainCaseProMatrixTableSchedule")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:143](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L143).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidateImage" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage")
Source documentation: `Candidate 'MAINCASE-PRO-PERM-001' as a finite image table on '(signal,T,tau,S)' basis states. The full index convention is 'signal * 8 + mainCaseProSystemIndex T tau S'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:151](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L151).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidateMatrix" (lean := "QuantumBlockEncoding.mainCaseProCandidateMatrix")
Source documentation: `Column-vector permutation matrix for 'MAINCASE-PRO-PERM-001'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:171](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L171).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state0" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state0")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:174](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L174).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state1" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_clean_source_state1")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:178](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L178).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_injective_pointwise" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_injective_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:182](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L182).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_injective" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_injective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:187](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L187).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidatePreimage" (lean := "QuantumBlockEncoding.mainCaseProCandidatePreimage")
Source documentation: `Explicit inverse image table for the task-local permutation certificate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:193](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L193).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_preimage" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_preimage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:212](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L212).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_surjective" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_surjective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:217](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L217).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidateImageIsPermutation" (lean := "QuantumBlockEncoding.mainCaseProCandidateImageIsPermutation")
Source documentation: `Task-local finite-permutation certificate for the candidate image.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:224](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L224).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateImage_permutation_certificate" (lean := "QuantumBlockEncoding.mainCaseProCandidateImage_permutation_certificate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:228](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L228).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidateMatrix_isRationalOrthogonal" (lean := "QuantumBlockEncoding.mainCaseProCandidateMatrix_isRationalOrthogonal")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:232](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L232).
:::

:::definition "QuantumBlockEncoding.mainCaseProReducedOfFull" (lean := "QuantumBlockEncoding.mainCaseProReducedOfFull")
Source documentation: `Reduced active index for the Pro transcript bits '(tau,T,signal)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:240](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L240).
:::

:::definition "QuantumBlockEncoding.mainCaseProStateOfFull" (lean := "QuantumBlockEncoding.mainCaseProStateOfFull")
Source documentation: `Passive state bit in the full '(signal,T,tau,S)' convention.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:244](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L244).
:::

:::definition "QuantumBlockEncoding.mainCaseProLiftReducedImage" (lean := "QuantumBlockEncoding.mainCaseProLiftReducedImage")
Source documentation: `Lift a reduced active-register image while preserving the passive state bit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:248](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L248).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedCCX012" (lean := "QuantumBlockEncoding.mainCaseProRedCCX012")
Source documentation: `Reduced Toffoli 'CCX012', with controls 'tau,T' and target 'signal'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:257](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L257).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedCX21" (lean := "QuantumBlockEncoding.mainCaseProRedCX21")
Source documentation: `Reduced 'CX21', with control 'signal' and target 'T'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:263](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L263).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedCX20" (lean := "QuantumBlockEncoding.mainCaseProRedCX20")
Source documentation: `Reduced 'CX20', with control 'signal' and target 'tau'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:271](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L271).
:::

:::definition "QuantumBlockEncoding.mainCaseProRedX2" (lean := "QuantumBlockEncoding.mainCaseProRedX2")
Source documentation: `Reduced final 'X2', flipping the signal bit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:279](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L279).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitReducedImage" (lean := "QuantumBlockEncoding.mainCaseProCircuitReducedImage")
Source documentation: `Task-local reduced image for the transcript 'CCX012; CX21; CX20; X2'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:290](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L290).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitImage" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage")
Source documentation: `Task-local full image induced by the advertised Pro four-gate transcript under the full wire map 'S=0', 'tau=1', 'T=2', 'signal=3'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:300](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L300).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state0" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state0")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:303](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L303).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state1" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_clean_source_state1")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:307](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L307).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_candidate_mismatch_set" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_candidate_mismatch_set")
Source documentation: `The advertised transcript and the finite-permutation incumbent differ exactly on dirty columns '8', '9', '12', and '13'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:315](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L315).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_not_pointwise_candidate" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_not_pointwise_candidate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:321](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L321).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitMatrix" (lean := "QuantumBlockEncoding.mainCaseProCircuitMatrix")
Source documentation: `Column-vector permutation matrix induced by the advertised Pro transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:331](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L331).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_injective_pointwise" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_injective_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:334](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L334).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_injective" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_injective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:339](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L339).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_surjective_pointwise" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_surjective_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:344](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L344).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_surjective" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_surjective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:348](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L348).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitImageIsPermutation" (lean := "QuantumBlockEncoding.mainCaseProCircuitImageIsPermutation")
Source documentation: `Task-local finite-permutation certificate for the Pro transcript image.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:353](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L353).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitImage_permutation_certificate" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_permutation_certificate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:357](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L357).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitMatrix_isRationalOrthogonal" (lean := "QuantumBlockEncoding.mainCaseProCircuitMatrix_isRationalOrthogonal")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:361](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L361).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuit_cleanEntry" (lean := "QuantumBlockEncoding.mainCaseProCircuit_cleanEntry")
Source documentation: `Clean-entry calculation for the gate-derived Pro transcript image.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:369](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L369).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuit_blockProjection" (lean := "QuantumBlockEncoding.mainCaseProCircuit_blockProjection")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:379](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L379).
:::

:::theorem "QuantumBlockEncoding.mainCaseProTarget_support_state0" (lean := "QuantumBlockEncoding.mainCaseProTarget_support_state0")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:392](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L392).
:::

:::theorem "QuantumBlockEncoding.mainCaseProTarget_support_state1" (lean := "QuantumBlockEncoding.mainCaseProTarget_support_state1")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:398](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L398).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_cleanEntry" (lean := "QuantumBlockEncoding.mainCaseProCandidate_cleanEntry")
Source documentation: `Entrywise image calculation for the reusable partial-permutation wrapper.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:405](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L405).
:::

:::definition "QuantumBlockEncoding.mainCaseProExactCleanBlockCertificate" (lean := "QuantumBlockEncoding.mainCaseProExactCleanBlockCertificate")
Source documentation: `Exact clean-block package from the compiled partial-permutation leaf.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:419](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L419).
:::

:::theorem "QuantumBlockEncoding.mainCaseProExactCleanBlock_correct" (lean := "QuantumBlockEncoding.mainCaseProExactCleanBlock_correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L427).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_blockProjection" (lean := "QuantumBlockEncoding.mainCaseProCandidate_blockProjection")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:435](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L435).
:::

:::theorem "QuantumBlockEncoding.mainCaseProQueryTarget_normalizer" (lean := "QuantumBlockEncoding.mainCaseProQueryTarget_normalizer")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:444](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L444).
:::

:::theorem "QuantumBlockEncoding.mainCaseProSourceLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseProSourceLayout_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:447](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L447).
:::

:::definition "QuantumBlockEncoding.mainCaseProRationalOrthogonalBridgeObligation" (lean := "QuantumBlockEncoding.mainCaseProRationalOrthogonalBridgeObligation")
Source documentation: `Reusable proof obligation for a later shared bridge from finite bijections to the project-local rational-orthogonality matrix predicate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:454](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L454).
:::

:::definition "QuantumBlockEncoding.mainCaseProCandidate" (lean := "QuantumBlockEncoding.mainCaseProCandidate")
Source documentation: `Candidate record at the finite-permutation semantic tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:461](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L461).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitCandidate" (lean := "QuantumBlockEncoding.mainCaseProCircuitCandidate")
Source documentation: `Gate-derived candidate for the advertised Pro four-gate transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:474](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L474).
:::

:::definition "QuantumBlockEncoding.mainCaseProVerified" (lean := "QuantumBlockEncoding.mainCaseProVerified")
Source documentation: `Verified task-local candidate at the finite-permutation semantic tier. This certificate proves the block entry and the image bijection. The stronger matrix-orthogonality bridge is closed by 'mainCaseProRationalOrthogonalBridgeObligation'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:493](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L493).
:::

:::definition "QuantumBlockEncoding.mainCaseProCircuitVerified" (lean := "QuantumBlockEncoding.mainCaseProCircuitVerified")
Source documentation: `Verified task-local candidate for the advertised Pro transcript image.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:503](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L503).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_cost" (lean := "QuantumBlockEncoding.mainCaseProCandidate_cost")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:512](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L512).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCandidate_uses_matrix_table_metadata" (lean := "QuantumBlockEncoding.mainCaseProCandidate_uses_matrix_table_metadata")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:517](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L517).
:::

:::theorem "QuantumBlockEncoding.mainCaseProCircuitCandidate_cost" (lean := "QuantumBlockEncoding.mainCaseProCircuitCandidate_cost")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:523](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L523).
:::

:::definition "QuantumBlockEncoding.mainCaseColdSystemIndex" (lean := "QuantumBlockEncoding.mainCaseColdSystemIndex")
Source documentation: `System-register index for one-bit registers ordered as '(T, tau, S)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:538](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L538).
:::

:::definition "QuantumBlockEncoding.mainCaseColdTarget" (lean := "QuantumBlockEncoding.mainCaseColdTarget")
Source documentation: `The COLD target matrix for 'E_1'. It maps '|1>_T |1>_tau |s>_S' to '|0>_T |0>_tau |s>_S' and annihilates every other computational-basis column.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:551](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L551).
:::

:::definition "QuantumBlockEncoding.mainCaseColdExactNormalizer" (lean := "QuantumBlockEncoding.mainCaseColdExactNormalizer")
Source documentation: `Exact normalizer for the no-Pro COLD target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:562](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L562).
:::

:::definition "QuantumBlockEncoding.mainCaseColdExactError" (lean := "QuantumBlockEncoding.mainCaseColdExactError")
Source documentation: `Exact error for the no-Pro COLD target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:565](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L565).
:::

:::definition "QuantumBlockEncoding.mainCaseColdQueryTarget" (lean := "QuantumBlockEncoding.mainCaseColdQueryTarget")
Source documentation: `Operator-first target metadata for the no-Pro COLD benchmark.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:568](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L568).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCleanSignal" (lean := "QuantumBlockEncoding.mainCaseColdCleanSignal")
Source documentation: `The clean block-selection index for the single signal ancilla.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:584](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L584).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCleanEmbed" (lean := "QuantumBlockEncoding.mainCaseColdCleanEmbed")
Source documentation: `Clean embedding into the signal-system product basis.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:587](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L587).
:::

:::definition "QuantumBlockEncoding.mainCaseColdBlockProjection" (lean := "QuantumBlockEncoding.mainCaseColdBlockProjection")
Source documentation: `Exact clean-block predicate for a one-signal-qubit COLD candidate matrix. The block projection is the '(signal,signal) = (0,0)' block of 'U', and it must equal 'mainCaseColdTarget' pointwise.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L596).
:::

:::definition "QuantumBlockEncoding.mainCaseColdSourceLayout" (lean := "QuantumBlockEncoding.mainCaseColdSourceLayout")
Source documentation: `Source-facing layout: three system qubits and one clean signal ancilla.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:603](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L603).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermImage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage")
Source documentation: `Candidate 'MAIN-PARTIAL-PERM-001' as a COLD task-local finite image table on the '(signal,T,tau,S)' basis. The full index convention is 'signal * 8 + mainCaseColdSystemIndex T tau S'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:614](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L614).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermMatrix" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermMatrix")
Source documentation: `Column-vector permutation matrix for 'MAIN-PARTIAL-PERM-001'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:634](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L634).
:::

:::definition "QuantumBlockEncoding.mainCaseColdReducedOfFull" (lean := "QuantumBlockEncoding.mainCaseColdReducedOfFull")
Source documentation: `Reduced active index for the COLD table bits '(tau,T,signal)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:638](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L638).
:::

:::definition "QuantumBlockEncoding.mainCaseColdStateOfFull" (lean := "QuantumBlockEncoding.mainCaseColdStateOfFull")
Source documentation: `Passive state bit in the full '(signal,T,tau,S)' convention.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:642](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L642).
:::

:::definition "QuantumBlockEncoding.mainCaseColdLiftReducedImage" (lean := "QuantumBlockEncoding.mainCaseColdLiftReducedImage")
Source documentation: `Lift a reduced active-register image while preserving the passive state bit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:646](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L646).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedXT" (lean := "QuantumBlockEncoding.mainCaseColdRedXT")
Source documentation: `Reduced 'X' on the 'T' bit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:656](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L656).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedCCXTauTSignal" (lean := "QuantumBlockEncoding.mainCaseColdRedCCXTauTSignal")
Source documentation: `Reduced Toffoli with controls 'tau,T' and target 'signal'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:667](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L667).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedXTau" (lean := "QuantumBlockEncoding.mainCaseColdRedXTau")
Source documentation: `Reduced 'X' on the 'tau' bit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:673](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L673).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedCXSignalT" (lean := "QuantumBlockEncoding.mainCaseColdRedCXSignalT")
Source documentation: `Reduced CNOT with control 'signal' and target 'T'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:684](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L684).
:::

:::definition "QuantumBlockEncoding.mainCaseColdRedCXTauSignal" (lean := "QuantumBlockEncoding.mainCaseColdRedCXTauSignal")
Source documentation: `Reduced CNOT with control 'tau' and target 'signal'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:692](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L692).
:::

:::definition "QuantumBlockEncoding.mainCaseColdEvalReducedGateImages" (lean := "QuantumBlockEncoding.mainCaseColdEvalReducedGateImages")
Source documentation: `Evaluate reduced logical reversible gates as basis-state permutations.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:700](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L700).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermReducedImage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermReducedImage")
Source documentation: `Reduced COLD table induced by 'mainCaseColdPartialPermImage'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:705](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L705).
:::

:::definition "QuantumBlockEncoding.mainCaseColdReducedGateImages" (lean := "QuantumBlockEncoding.mainCaseColdReducedGateImages")
Source documentation: `Reduced gate-image transcript for the COLD resource schema.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:716](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L716).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCircuitReducedImage" (lean := "QuantumBlockEncoding.mainCaseColdCircuitReducedImage")
Source documentation: `Reduced active-register image induced by the COLD resource schema.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:725](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L725).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdReducedGateImages_eval" (lean := "QuantumBlockEncoding.mainCaseColdReducedGateImages_eval")
Source documentation: `The COLD logical reversible circuit implements the reduced table.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:729](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L729).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCircuitImage" (lean := "QuantumBlockEncoding.mainCaseColdCircuitImage")
Source documentation: `Full active-plus-passive image induced by the COLD resource schema.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:736](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L736).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdCircuitImage_eq_partialPermImage" (lean := "QuantumBlockEncoding.mainCaseColdCircuitImage_eq_partialPermImage")
Source documentation: `The COLD logical reversible circuit implements the finite table.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:740](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L740).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateXT" (lean := "QuantumBlockEncoding.mainCaseColdGateXT")
Source documentation: `Logical 'X' on the time register 'T' in the full wire layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:746](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L746).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateCCXTauTSignal" (lean := "QuantumBlockEncoding.mainCaseColdGateCCXTauTSignal")
Source documentation: `Logical Toffoli with controls 'tau,T' and target 'signal'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:750](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L750).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateXTau" (lean := "QuantumBlockEncoding.mainCaseColdGateXTau")
Source documentation: `Logical 'X' on the type register 'tau' in the full wire layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:754](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L754).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateCXSignalT" (lean := "QuantumBlockEncoding.mainCaseColdGateCXSignalT")
Source documentation: `Logical CNOT with control 'signal' and target 'T'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:758](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L758).
:::

:::definition "QuantumBlockEncoding.mainCaseColdGateCXTauSignal" (lean := "QuantumBlockEncoding.mainCaseColdGateCXTauSignal")
Source documentation: `Logical CNOT with control 'tau' and target 'signal'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:762](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L762).
:::

:::definition "QuantumBlockEncoding.mainCaseColdCircuit" (lean := "QuantumBlockEncoding.mainCaseColdCircuit")
Source documentation: `COLD task-local logical circuit for the finite partial-permutation table.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:766](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L766).
:::

:::definition "QuantumBlockEncoding.mainCaseColdSchedule" (lean := "QuantumBlockEncoding.mainCaseColdSchedule")
Source documentation: `Sequential COLD schedule for the current logical transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:775](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L775).
:::

:::definition "QuantumBlockEncoding.mainCaseColdHighLevelResource" (lean := "QuantumBlockEncoding.mainCaseColdHighLevelResource")
Source documentation: `High-level logical-library resource record for the COLD transcript. At this semantic tier, Toffoli and CNOT are counted together as controlled logical gates, matching the main-case resource convention.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:788](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L788).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermCost" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost")
Source documentation: `Source-facing COLD score '(gateCount, depth, auxiliaryQubits, oracleCalls)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L792).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_gateCount" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:796](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L796).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_depth" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:799](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L799).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:802](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L802).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCost_oracleCalls" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCost_oracleCalls")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:805](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L805).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective_pointwise" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:808](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L808).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_injective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:813](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L813).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermPreimage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermPreimage")
Source documentation: `Explicit inverse image table for the COLD partial-permutation certificate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:819](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L819).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_preimage" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_preimage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L838).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_surjective" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_surjective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:843](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L843).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermImageIsPermutation" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImageIsPermutation")
Source documentation: `Task-local finite-permutation certificate for 'MAIN-PARTIAL-PERM-001'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:850](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L850).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermImage_bijective" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermImage_bijective")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:854](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L854).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPerm_entry" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_entry")
Source documentation: `Entrywise image calculation for the reusable partial-permutation wrapper.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:860](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L860).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermExactCleanBlock" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermExactCleanBlock")
Source documentation: `Exact clean-block package from the compiled partial-permutation leaf.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:875](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L875).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPerm_clean_eq_target" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_clean_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:883](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L883).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPerm_blockProjection" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_blockProjection")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:891](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L891).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdQueryTarget_normalizer" (lean := "QuantumBlockEncoding.mainCaseColdQueryTarget_normalizer")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:900](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L900).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdSourceLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.mainCaseColdSourceLayout_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:903](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L903).
:::

:::definition "QuantumBlockEncoding.mainCaseColdResourceSchemaObligation" (lean := "QuantumBlockEncoding.mainCaseColdResourceSchemaObligation")
Source documentation: `Resource-schema obligation for 'MAIN-RESOURCE-001'. The COLD-local circuit image and resource field theorems below justify the advertised high-level logical resource tuple for the candidate package.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:912](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L912).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermCandidate" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCandidate")
Source documentation: `COLD task-local candidate package at the finite-permutation semantic tier. The target, candidate matrix, block projection, and logical resource tuple are all COLD-local declarations; this package does not use the separate 'mainCasePro*' arm as evidence.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:925](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L925).
:::

:::definition "QuantumBlockEncoding.mainCaseColdPartialPermVerified" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermVerified")
Source documentation: `Verified COLD block-encoding package for the transfer operator at the current finite-permutation semantic tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:942](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L942).
:::

:::theorem "QuantumBlockEncoding.mainCaseColdPartialPermCandidate_cost" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermCandidate_cost")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/MainCase.lean:952](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/MainCase.lean#L952).
:::

# QuantumBlockEncoding/OptimalControl.lean

133 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.OptimalControl.IsPermutation" (lean := "QuantumBlockEncoding.OptimalControl.IsPermutation")
Source documentation: `Local finite-permutation certificate used as a lightweight unitarity proxy.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:28](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L28).
:::

:::definition "QuantumBlockEncoding.OptimalControl.targetState0" (lean := "QuantumBlockEncoding.OptimalControl.targetState0")
Source documentation: `System index for 'time=0', 'type=0', 'state=0'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L32).
:::

:::definition "QuantumBlockEncoding.OptimalControl.targetState1" (lean := "QuantumBlockEncoding.OptimalControl.targetState1")
Source documentation: `System index for 'time=0', 'type=0', 'state=1'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:35](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L35).
:::

:::definition "QuantumBlockEncoding.OptimalControl.sourceState0" (lean := "QuantumBlockEncoding.OptimalControl.sourceState0")
Source documentation: `System index for 'time=1', 'type=1', 'state=0'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:38](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L38).
:::

:::definition "QuantumBlockEncoding.OptimalControl.sourceState1" (lean := "QuantumBlockEncoding.OptimalControl.sourceState1")
Source documentation: `System index for 'time=1', 'type=1', 'state=1'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:41](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L41).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleOperator" (lean := "QuantumBlockEncoding.OptimalControl.exampleOperator")
Source documentation: `The concrete 'E_1' operator for one time qubit, one type qubit, and one state qubit. It maps '|1>_time |1>_type |s>' to '|0>_time |0>_type |s>' and annihilates every other basis state.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:48](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L48).
:::

:::definition "QuantumBlockEncoding.OptimalControl.cleanIndex" (lean := "QuantumBlockEncoding.OptimalControl.cleanIndex")
Source documentation: `Clean-ancilla embedding into the first half of the one-ancilla space.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:57](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L57).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleTarget" (lean := "QuantumBlockEncoding.OptimalControl.exampleTarget")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L60).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleLayout" (lean := "QuantumBlockEncoding.OptimalControl.exampleLayout")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:67](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L67).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleImage" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage")
Source documentation: `Permutation image for the one-ancilla unitary completion. For each state bit 's', the four-cycle is '(0, source_s) -> (0, target_s) -> (1, source_s) -> (1, target_s) -> (0, source_s)'. Every other system basis state just swaps the auxiliary qubit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:82](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L82).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleImageInv" (lean := "QuantumBlockEncoding.OptimalControl.exampleImageInv")
Source documentation: `Inverse permutation for 'exampleImage'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:101](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L101).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleImage_leftInverse" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage_leftInverse")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L119).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleImage_rightInverse" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage_rightInverse")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:123](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L123).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.exampleImage_isPermutation")
Source documentation: `The image function is a finite permutation, hence a permutation unitary.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:128](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L128).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedTargetImage" (lean := "QuantumBlockEncoding.OptimalControl.reducedTargetImage")
Source documentation: `The reduced three-bit permutation induced by 'exampleImage' on '(type,time,aux)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L149).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redX0" (lean := "QuantumBlockEncoding.OptimalControl.redX0")
Source documentation: `Logical 'X' on reduced bit 0.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:160](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L160).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redX2" (lean := "QuantumBlockEncoding.OptimalControl.redX2")
Source documentation: `Logical 'X' on reduced bit 2.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:171](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L171).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redX1" (lean := "QuantumBlockEncoding.OptimalControl.redX1")
Source documentation: `Logical 'X' on reduced bit 1.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:182](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L182).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX01" (lean := "QuantumBlockEncoding.OptimalControl.redCX01")
Source documentation: `Logical CNOT with control reduced bit 0 and target reduced bit 1.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:193](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L193).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX10" (lean := "QuantumBlockEncoding.OptimalControl.redCX10")
Source documentation: `Logical CNOT with control reduced bit 1 and target reduced bit 0.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:201](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L201).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX20" (lean := "QuantumBlockEncoding.OptimalControl.redCX20")
Source documentation: `Logical CNOT with control reduced bit 2 and target reduced bit 0.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:209](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L209).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCX21" (lean := "QuantumBlockEncoding.OptimalControl.redCX21")
Source documentation: `Logical CNOT with control reduced bit 2 and target reduced bit 1.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:217](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L217).
:::

:::definition "QuantumBlockEncoding.OptimalControl.redCCX012" (lean := "QuantumBlockEncoding.OptimalControl.redCCX012")
Source documentation: `Logical Toffoli with controls reduced bits 0,1 and target reduced bit 2.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:225](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L225).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Image" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Image")
Source documentation: `Depth-5 logical circuit found by the first EoH-style explore pass: 1. 'CCX(0,1;2)' 2. 'CX(0,1)' 3. 'CX(1,0)' 4. 'X(0)' 5. parallel layer '{X(2), CX(0,1)}'`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:239](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L239).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Image_eq_target" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Image_eq_target")
Source documentation: `The expanded logical circuit realizes the same reduced permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:243](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L243).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedOfFull" (lean := "QuantumBlockEncoding.OptimalControl.reducedOfFull")
Source documentation: `Extract the active '(type,time,aux)' register from the full index.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:248](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L248).
:::

:::definition "QuantumBlockEncoding.OptimalControl.stateOfFull" (lean := "QuantumBlockEncoding.OptimalControl.stateOfFull")
Source documentation: `Extract the passive state bit from the full index.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:252](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L252).
:::

:::definition "QuantumBlockEncoding.OptimalControl.liftReducedImage" (lean := "QuantumBlockEncoding.OptimalControl.liftReducedImage")
Source documentation: `Lift a reduced active-register permutation while leaving the state bit fixed.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:256](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L256).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5_lifts_exampleImage" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5_lifts_exampleImage")
Source documentation: `The depth-5 reduced circuit lifts to the full one-ancilla permutation because the state bit is passive.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:266](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L266).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Full_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Full_isPermutation")
Source documentation: `The depth-5 full active-plus-state completion is a permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:271](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L271).
:::

:::definition "QuantumBlockEncoding.OptimalControl.unitaryFromReducedImage" (lean := "QuantumBlockEncoding.OptimalControl.unitaryFromReducedImage")
Source documentation: `Matrix induced by a reduced active-register permutation lifted over the passive state bit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:280](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L280).
:::

:::definition "QuantumBlockEncoding.OptimalControl.CleanBlockE1" (lean := "QuantumBlockEncoding.OptimalControl.CleanBlockE1")
Source documentation: `The clean block condition for the concrete optimal-control target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:284](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L284).
:::

:::definition "QuantumBlockEncoding.OptimalControl.columnInner" (lean := "QuantumBlockEncoding.OptimalControl.columnInner")
Source documentation: `Column inner products for concrete rational matrix-level unitarity checks.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:290](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L290).
:::

:::definition "QuantumBlockEncoding.OptimalControl.rowInner" (lean := "QuantumBlockEncoding.OptimalControl.rowInner")
Source documentation: `Row inner products for concrete rational matrix-level unitarity checks.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:294](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L294).
:::

:::definition "QuantumBlockEncoding.OptimalControl.IsRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.IsRationalOrthogonal")
Source documentation: `Concrete real/rational unitary proxy for this finite permutation-matrix sandbox. Since all entries are rational and all current exact circuits are real, this is the finite 'UᵀU = I' and 'UUᵀ = I' condition.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:302](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L302).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleOperator_not_rationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.exampleOperator_not_rationalOrthogonal")
Source documentation: `The target operator itself is not unitary. Therefore an exact unscaled zero-auxiliary block encoding cannot use 'E_1' as the whole unitary matrix. One auxiliary qubit is locally necessary for this concrete exact construction model.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:312](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L312).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5_cleanBlock")
Source documentation: `The depth-5 fixed-completion candidate has the required clean block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:322](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L322).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary")
Source documentation: `Matrix of the depth-5 fixed-completion logical circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:327](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L327).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_isRationalOrthogonal")
Source documentation: `The depth-5 fixed-completion matrix is rational orthogonal/unitary.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:331](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L331).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Unitary_cleanBlock")
Source documentation: `The depth-5 fixed-completion matrix has the required clean block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:339](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L339).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferImage" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferImage")
Source documentation: `ChatGPT Pro's structured equality-flag/transfer construction specialized to the concrete 'r = 1, k = 1' instance: 1. 'CCX(type,time;aux)' flags 'time=1,type=1'. 2. 'CX(aux,time)' transfers flagged 'time' to '0'. 3. 'CX(aux,type)' transfers flagged 'type' to '0'. 4. 'X(aux)' moves the selected branch back into the clean block.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:354](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L354).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferImage_isPermutation")
Source documentation: `Pro's reduced active-register map is a permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:358](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L358).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferFull_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferFull_isPermutation")
Source documentation: `Pro's full active-plus-state completion is a permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:364](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L364).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransfer_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransfer_cleanBlock")
Source documentation: `Pro's construction has the required clean block for the concrete target.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:370](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L370).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary")
Source documentation: `Matrix of Pro's equality-flag/transfer construction.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:375](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L375).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_isRationalOrthogonal")
Source documentation: `Pro's equality-flag/transfer matrix is rational orthogonal/unitary.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:379](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L379).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferUnitary_cleanBlock")
Source documentation: `Pro's equality-flag/transfer matrix has the required clean block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:387](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L387).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage")
Source documentation: `An evolved child of the Pro construction. The same equality flag is followed by a parallel layer of three 'X' gates on '(type,time,aux)'. This uses the freedom in the unitary completion: it does not reproduce 'exampleImage', but it does satisfy the same clean-block contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:399](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L399).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage_isPermutation")
Source documentation: `The evolved reduced active-register map is a permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:403](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L403).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipFull_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipFull_isPermutation")
Source documentation: `The evolved full active-plus-state completion is a permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:409](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L409).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlip_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlip_cleanBlock")
Source documentation: `The evolved depth-2 construction has the required clean block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:415](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L415).
:::

:::definition "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost" (lean := "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost")
Source documentation: `Lightweight score for the logical reversible gate library '{X,CNOT,Toffoli}'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:420](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L420).
:::

:::definition "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.gateCount" (lean := "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:431](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L431).
:::

:::definition "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.betterThan" (lean := "QuantumBlockEncoding.OptimalControl.LogicalReversibleCost.betterThan")
Source documentation: `Lexicographic order inside one fixed logical reversible gate library. ABEIS compares asymptotic scale first outside this concrete record. Once two candidates are in the same scale class for the chosen backend, the local priority is gate count, then parallel depth, then auxiliary qubits, then unexpanded oracle calls.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:442](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L442).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost")
Source documentation: `Expanded score for 'reducedDepth5Image' before hardware decomposition.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:454](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L454).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_gateCount" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:462](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L462).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_oracleFree" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Cost_oracleFree")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:466](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L466).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferCost" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCost")
Source documentation: `Expanded score for Pro's equality-flag/transfer construction.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:471](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L471).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferCost_gateCount" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:479](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L479).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferCost_betterThan_depth5" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCost_betterThan_depth5")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:483](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L483).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost")
Source documentation: `Expanded score for the evolved equality-flag/parallel-flip construction.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:489](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L489).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_gateCount" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:497](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L497).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_pro" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_pro")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:501](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L501).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_depth5" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCost_betterThan_depth5")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:506](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L506).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary")
Source documentation: `Matrix of the evolved depth-2 logical gate product.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:512](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L512).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal")
Source documentation: `The evolved matrix is a concrete rational unitary matrix in the project-local real/permutation sense: both its column and row Gram matrices are identity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:519](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L519).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_cleanBlock")
Source documentation: `The evolved concrete matrix has the required clean block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:527](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L527).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedGateMatrix" (lean := "QuantumBlockEncoding.OptimalControl.reducedGateMatrix")
Source documentation: `Full-space gate matrix for a reduced active-register permutation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:534](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L534).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCCX_type_time_aux" (lean := "QuantumBlockEncoding.OptimalControl.gateCCX_type_time_aux")
Source documentation: `Logical Toffoli gate 'CCX(type,time;aux)' in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:545](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L545).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateX_type" (lean := "QuantumBlockEncoding.OptimalControl.gateX_type")
Source documentation: `Logical 'X' on the type bit in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:549](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L549).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateX_time" (lean := "QuantumBlockEncoding.OptimalControl.gateX_time")
Source documentation: `Logical 'X' on the time bit in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:553](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L553).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateX_aux" (lean := "QuantumBlockEncoding.OptimalControl.gateX_aux")
Source documentation: `Logical 'X' on the block-encoding auxiliary bit in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:557](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L557).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_type_time" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_type_time")
Source documentation: `Logical CNOT from type to time in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:561](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L561).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_time_type" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_time_type")
Source documentation: `Logical CNOT from time to type in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:565](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L565).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_aux_type" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_aux_type")
Source documentation: `Logical CNOT from auxiliary to type in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:569](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L569).
:::

:::definition "QuantumBlockEncoding.OptimalControl.gateCX_aux_time" (lean := "QuantumBlockEncoding.OptimalControl.gateCX_aux_time")
Source documentation: `Logical CNOT from auxiliary to time in the concrete layout.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:573](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L573).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Circuit" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Circuit")
Source documentation: `The depth-5 fixed-completion circuit in sequential-list form.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:577](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L577).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Schedule" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Schedule")
Source documentation: `The depth-5 fixed-completion schedule.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:587](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L587).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices")
Source documentation: `Gate matrices for the depth-5 fixed-completion circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L596).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateMatrices_matchCircuit")
Source documentation: `The gate-matrix labels match the depth-5 circuit transcript.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:606](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L606).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evalReducedGateImages" (lean := "QuantumBlockEncoding.OptimalControl.evalReducedGateImages")
Source documentation: `Evaluate reduced logical reversible gates as basis-state permutations.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:611](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L611).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages")
Source documentation: `Reduced permutation images of the depth-5 logical circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:615](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L615).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5GateImages_eval")
Source documentation: `The depth-5 logical reversible circuit implements 'reducedDepth5Image'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:619](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L619).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferCircuit" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCircuit")
Source documentation: `Pro's equality-flag/transfer circuit in sequential-list form.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:625](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L625).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferSchedule" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferSchedule")
Source documentation: `Pro's equality-flag/transfer schedule.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:629](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L629).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices")
Source documentation: `Gate matrices for Pro's equality-flag/transfer circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:633](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L633).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateMatrices_matchCircuit")
Source documentation: `The gate-matrix labels match Pro's circuit transcript.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:641](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L641).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages")
Source documentation: `Reduced permutation images of Pro's logical circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:646](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L646).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferGateImages_eval")
Source documentation: `Pro's logical reversible circuit implements 'proEqTransferImage'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:650](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L650).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCircuit" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCircuit")
Source documentation: `The evolved depth-2 circuit in sequential-list form.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:656](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L656).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipSchedule" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipSchedule")
Source documentation: `The evolved depth-2 schedule: one Toffoli layer, then three parallel flips.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:660](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L660).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices")
Source documentation: `Gate matrices for the evolved concrete circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:664](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L664).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateMatrices_matchCircuit")
Source documentation: `The gate-matrix labels match the evolved circuit transcript.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:672](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L672).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages")
Source documentation: `Reduced permutation images of the evolved logical circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:677](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L677).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_eval")
Source documentation: `The logical reversible circuit implements exactly the reduced permutation used to build 'evolvedEqFlipUnitary'. This is the efficient semantic bridge for the current logical reversible tier; the heavier raw 'evalGateMatrices' product is left to a later backend if the project chooses a hardware decomposition.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:686](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L686).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_lift_eval" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipGateImages_lift_eval")
Source documentation: `The lifted logical circuit implements the full active-plus-state image.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:692](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L692).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Resource" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Resource")
Source documentation: `Resource record for the depth-5 logical '{X,CNOT,Toffoli}' interpretation. The current 'Resource' type has no Toffoli field, so 'cnot' stores all controlled logical gates in this tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:703](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L703).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferResource" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferResource")
Source documentation: `Resource record for Pro's logical '{X,CNOT,Toffoli}' interpretation. The current 'Resource' type has no Toffoli field, so 'cnot' stores all controlled logical gates in this tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:711](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L711).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipResource" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipResource")
Source documentation: `Resource record for the evolved logical '{X,CNOT,Toffoli}' interpretation. The current 'Resource' type has no Toffoli field, so 'cnot' stores the single logical Toffoli in this tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:719](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L719).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate")
Source documentation: `Verified candidate data for the older depth-5 concrete logical BE.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:723](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L723).
:::

:::definition "QuantumBlockEncoding.OptimalControl.reducedDepth5Verified" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Verified")
Source documentation: `Verified concrete depth-5 block encoding for 'E_1'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:739](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L739).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.reducedDepth5Candidate_cost")
Source documentation: `The verified depth-5 candidate has the advertised logical-library score.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:749](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L749).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate")
Source documentation: `Verified candidate data for Pro's equality-flag/transfer BE.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:755](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L755).
:::

:::definition "QuantumBlockEncoding.OptimalControl.proEqTransferVerified" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferVerified")
Source documentation: `Verified concrete Pro block encoding for 'E_1'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:771](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L771).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.proEqTransferCandidate_cost")
Source documentation: `The verified Pro candidate has the advertised logical-library score.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:781](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L781).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate")
Source documentation: `Final concrete block-encoding candidate for the one-time-bit, one-type-bit, one-state-bit optimal-control target. This is final only for this concrete logical gate-matrix tier; general 'k', wider time registers, and hardware decomposition remain separate tasks.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L792).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified")
Source documentation: `Verified concrete depth-2 block encoding for 'E_1'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:808](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L808).
:::

:::definition "QuantumBlockEncoding.OptimalControl.evolvedEqFlipZeroErrorApprox" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipZeroErrorApprox")
Source documentation: `The exact evolved candidate is also a zero-error approximate block encoding. This is the Lean anchor for Scenario 1 of the adaptive exact-to-approximate policy: after exact convergence, approximate search may continue, but the current champion already satisfies every nonnegative requested tolerance.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:823](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L823).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipCandidate_cost")
Source documentation: `The verified evolved candidate has the advertised logical-library score.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:828](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L828).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget")
Source documentation: `Route-ablation target block with entries 'target[0, 6] = 1' and 'target[1, 7] = 1', and all other entries zero.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:848](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L848).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget_eq_exampleOperator" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationTarget_eq_exampleOperator")
Source documentation: `The route-ablation target is entrywise the concrete 'E_1' target used above.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:856](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L856).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationCircuit" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationCircuit")
Source documentation: `Direct route-ablation circuit in sequential-list form.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:862](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L862).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationSchedule" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationSchedule")
Source documentation: `Direct route-ablation schedule: Toffoli first, then the three flips.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:866](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L866).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages")
Source documentation: `Reduced permutation images for the direct route-ablation circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:870](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L870).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationImage" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationImage")
Source documentation: `Reduced active-register image induced by the direct route-ablation circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:874](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L874).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages_eval" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateImages_eval")
Source documentation: `The direct route-ablation circuit is the stated 'CCX; X(type); X(time); X(aux)' map.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:878](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L878).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationImage_isPermutation" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationImage_isPermutation")
Source documentation: `The direct route-ablation image is a finite permutation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:884](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L884).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary")
Source documentation: `Matrix of the direct route-ablation logical circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:890](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L890).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary_isRationalOrthogonal" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationUnitary_isRationalOrthogonal")
Source documentation: `The direct route-ablation matrix is rational orthogonal/unitary in the project-local finite permutation sense.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:897](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L897).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblation_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblation_cleanBlock")
Source documentation: `Named clean-block theorem for the controlled route ablation. The top-left auxiliary block, with auxiliary input and output both '0', is exactly the requested 'E_1' matrix.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:910](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L910).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices")
Source documentation: `Gate matrices for the direct route-ablation circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:917](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L917).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices_matchCircuit" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationGateMatrices_matchCircuit")
Source documentation: `The direct route-ablation gate-matrix labels match its circuit transcript.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:925](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L925).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationCost" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationCost")
Source documentation: `Logical-library cost for the direct route-ablation circuit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:931](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L931).
:::

:::definition "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple")
Source documentation: `Resource tuple in route-ablation order: '(gateCount, depth, auxiliaryQubits, oracleCalls)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:940](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L940).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple_eq" (lean := "QuantumBlockEncoding.OptimalControl.directRouteAblationResourceTuple_eq")
Source documentation: `The direct route-ablation resource tuple is '(4, 2, 1, 0)'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:948](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L948).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleUnitary" (lean := "QuantumBlockEncoding.OptimalControl.exampleUnitary")
Source documentation: `Matrix of the one-ancilla permutation unitary completion.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:953](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L953).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.example_cleanBlock" (lean := "QuantumBlockEncoding.OptimalControl.example_cleanBlock")
Source documentation: `The clean block of 'exampleUnitary' is exactly the optimal-control operator 'E_1' on the 8-dimensional system register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:960](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L960).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleCircuit" (lean := "QuantumBlockEncoding.OptimalControl.exampleCircuit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:966](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L966).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleSchedule" (lean := "QuantumBlockEncoding.OptimalControl.exampleSchedule")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:969](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L969).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleResource" (lean := "QuantumBlockEncoding.OptimalControl.exampleResource")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:972](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L972).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleCandidate" (lean := "QuantumBlockEncoding.OptimalControl.exampleCandidate")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:975](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L975).
:::

:::definition "QuantumBlockEncoding.OptimalControl.exampleVerified" (lean := "QuantumBlockEncoding.OptimalControl.exampleVerified")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:990](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L990).
:::

:::theorem "QuantumBlockEncoding.OptimalControl.exampleCandidate_cost" (lean := "QuantumBlockEncoding.OptimalControl.exampleCandidate_cost")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/OptimalControl.lean:995](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/OptimalControl.lean#L995).
:::
