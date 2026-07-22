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

#doc (Manual) "Declaration catalog: PaperAndExamples" =>
%%%
file := "catalog-paper-and-examples"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

# QuantumBlockEncoding/Examples/RobinHeat.lean

12 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.Examples.RobinHeat.fourthOrderSecondDerivative" (lean := "QuantumBlockEncoding.Examples.RobinHeat.fourthOrderSecondDerivative")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:18](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L18).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.centralBulkEntries" (lean := "QuantumBlockEncoding.Examples.RobinHeat.centralBulkEntries")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:24](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L24).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.A1dx" (lean := "QuantumBlockEncoding.Examples.RobinHeat.A1dx")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:33](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L33).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.B1dx" (lean := "QuantumBlockEncoding.Examples.RobinHeat.B1dx")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L34).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.leftBoundaryRow0" (lean := "QuantumBlockEncoding.Examples.RobinHeat.leftBoundaryRow0")
Source documentation: `First row after eliminating the left Robin ghost points.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:37](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L37).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.leftBoundaryRow1" (lean := "QuantumBlockEncoding.Examples.RobinHeat.leftBoundaryRow1")
Source documentation: `Second row after eliminating the left Robin ghost points.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:45](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L45).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.rightBoundaryRowNm2" (lean := "QuantumBlockEncoding.Examples.RobinHeat.rightBoundaryRowNm2")
Source documentation: `Penultimate row after eliminating the right Robin ghost points.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:54](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L54).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.rightBoundaryRowNm1" (lean := "QuantumBlockEncoding.Examples.RobinHeat.rightBoundaryRowNm1")
Source documentation: `Last row after eliminating the right Robin ghost points.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:63](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L63).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinWindow" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinWindow")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:70](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L70).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermParameters" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermParameters")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:74](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L74).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.fourthOrderStencilWidth" (lean := "QuantumBlockEncoding.Examples.RobinHeat.fourthOrderStencilWidth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:80](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L80).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinHeatAncillas" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinHeatAncillas")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/Examples/RobinHeat.lean:83](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/Examples/RobinHeat.lean#L83).
:::

# QuantumBlockEncoding/GHL2025.lean

401 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.GHL2025.OneTermRobinParameters" (lean := "QuantumBlockEncoding.GHL2025.OneTermRobinParameters")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this structure.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:18](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L18).
:::

:::definition "QuantumBlockEncoding.GHL2025.isBulkRow" (lean := "QuantumBlockEncoding.GHL2025.isBulkRow")
Source documentation: `Classical specification of the indicator oracle U_indic(K1,K2). Returns 'true' when row index 'i' is in the bulk region [K1, K2], meaning U_indic maps |i⟩|0⟩ → |i⟩|1⟩. Returns 'false' for boundary rows (0 ≤ i < K1 or K2 < i), meaning U_indic maps |i⟩|0⟩ → |i⟩|0⟩. main.tex:1060-1065 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:32](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L32).
:::

:::definition "QuantumBlockEncoding.GHL2025.isBoundaryRow" (lean := "QuantumBlockEncoding.GHL2025.isBoundaryRow")
Source documentation: `Complement of isBulkRow: returns true for boundary rows (j < K1 or K2 < j). The paper's boundary set is {0,...,K1-1} union {K2+1,...,2^n-1}. main.tex:1113, 1035-1038 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:39](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L39).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinRegisterPartition" (lean := "QuantumBlockEncoding.GHL2025.RobinRegisterPartition")
Source documentation: `Detailed register partition matching the wavefunction ket labels in Eq. ROBIN clarified (main.tex:1113-1117). Each field is the qubit count for one register in the circuit. Total signal qubits = m_f + 1 + ceil(log2 kappa) + 4 (indicator + ancilla + 1), plus n system qubits. Pure ancillas appear in two groups totaling 2n. figure:1_term_ROBIN caption -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:49](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L49).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinRegisterPartition.totalQubits" (lean := "QuantumBlockEncoding.GHL2025.RobinRegisterPartition.totalQubits")
Source documentation: `Total qubits used by the register partition (all registers summed).`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:69](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L69).
:::

:::definition "QuantumBlockEncoding.GHL2025.defaultRobinRegisterPartition" (lean := "QuantumBlockEncoding.GHL2025.defaultRobinRegisterPartition")
Source documentation: `Default register partition from concrete parameters. figure:1_term_ROBIN -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:76](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L76).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinRegisterPartition.totalPureAncillas" (lean := "QuantumBlockEncoding.GHL2025.RobinRegisterPartition.totalPureAncillas")
Source documentation: `Pure ancilla qubits visible in the Eq. ROBIN register partition: '(n - ceil(log2 kappa)) + 1' from the O_D^BS register plus the trailing ancilla. This is intentionally narrower than the theorem's full '2n' pure-ancilla budget. The theorem-level count in 'oneTermRobinLayout' and 'oneTermRobinResourceExpr' also includes internal workspace required by the banded sparse-access and oracle subcircuits. Keep this distinction explicit to avoid treating the ket-level register partition as the full resource proof. figure:1_term_ROBIN caption, main.tex:1149, main.tex:1131-1136`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:96](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L96).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinResourceExpr" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinResourceExpr")
Source documentation: `Theorem 1-term Robin resource shape: 'O(sum_g Q_g n log n + kappa n)' gates and '2n' pure ancillas.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:103](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L103).
:::

:::definition "QuantumBlockEncoding.GHL2025.deviatingIndices" (lean := "QuantumBlockEncoding.GHL2025.deviatingIndices")
Source documentation: `Number of deviating (boundary) indices: K1 + 2^n - K2. The paper notes this is O(1) as it depends on the finite-difference accuracy order. main.tex:1092-1095 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:112](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L112).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinPreciseResourceExpr" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinPreciseResourceExpr")
Source documentation: `Precise gate cost formula from the text (main.tex:1088-1089), before absorbing the O(1) boundary deviation count into the Theorem's simplified formula. 'O(sum_g Q_g n log n + kappa * (K1 + 2^n - K2) * n)' gates. The term 'K1 + 2^n - K2' is the number of deviating rows, which is O(1). main.tex:1088-1089 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:121](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L121).
:::

:::theorem "QuantumBlockEncoding.GHL2025.deviatingIndices_example" (lean := "QuantumBlockEncoding.GHL2025.deviatingIndices_example")
Source documentation: `deviatingIndices computes K1 + gridSize - K2, the number of boundary rows. For the fourth-order stencil with K1=2, K2=gridSize(n)-3, this gives 2+3=5. main.tex:1092-1095 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:130](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L130).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinResource" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinResource")
Source documentation: `Numeric resource useful for concrete search runs with fixed parameters.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:134](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L134).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobin_pureAncilla" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobin_pureAncilla")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:140](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L140).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinLayout" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinLayout")
Source documentation: `Register layout for the one-term Robin block encoding. Signal qubits = ⌈log₂ n⌉ + ⌈log₂ G_f⌉ + ⌈log₂ κ⌉ + 4 match the paper's Theorem (main.tex:1098-1109). System qubits address 'n' grid points; pure ancillas are workspace.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L149).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinCircuit" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinCircuit")
Source documentation: `Placeholder circuit for the one-term Robin block encoding. Gate order matches Fig. 1_term_ROBIN (main.tex:1125-1163): 1. U_indic sets bulk/boundary indicator ancilla. 2. O_DT^S encodes D^T amplitudes (bulk) via sparse-amplitude oracle. 3. Ry_boundary applies controlled rotations for boundary entries. 4. O_D^BS is the banded-sparse-access oracle for D. 5. O_f encodes f(x_j) via amplitude oracle. 6. SWAP between two n-qubit registers. 7. (O_D^BS)^† uncomputes the sparse-access register. Oracle names match 'defaultRobinCircuitSkeleton' field values. figure:1_term_ROBIN -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:166](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L166).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinTheoremFacingFig4Circuit" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinTheoremFacingFig4Circuit")
Source documentation: `Theorem-facing Fig. 1-term Robin transcript. This label list is the source-facing circuit map used by the conversion window. It deliberately differs from the active seven-gate backend list: the backend matrix product still uses 'oneTermRobinCircuit', while this transcript keeps the sparse-register preparation sides, the explicit 'U_indic^dagger' cleanup slot, and the pre-SWAP 'O_DT^BS' label visible for paper audit. figure:1_term_ROBIN, eq:arbitrary sparcity -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:185](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L185).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList")
Source documentation: `The theorem-facing transcript exposes the source-correction slots explicitly. This theorem is a transcript guard only. It does not replace 'oneTermRobinCircuit', does not change 'oneTermRobinGateMatrixPlaceholders', and does not promote any oracle correctness or unitarity flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:205](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L205).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinActiveBackendCircuit_gateList" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinActiveBackendCircuit_gateList")
Source documentation: `The active backend circuit remains the seven-gate product currently used by the finite matrix semantics. Theorem-facing proof maps must not call this list the full Fig. 1-term Robin transcript, because it omits both 'H_W^(kappa)' sides and the explicit 'U_indic^dagger' source slot.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:227](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L227).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinNormalizer" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinNormalizer")
Source documentation: `Symbolic normalizer α = N_D · N_f · κ for the one-term Robin construction.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:239](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L239).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinSpec" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinSpec")
Source documentation: `Block-encoding spec for the one-term Robin derivative operator. Takes the target matrix as a parameter so the spec is reusable across different stencil choices and boundary data without creating import cycles. Normalizer: symbolic 'N_D · N_f · κ'. Error: zero (exact encoding, no approximation yet).`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:249](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L249).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinSpec_ancilla" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinSpec_ancilla")
Source documentation: `The spec's pure ancilla matches the resource formula.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:260](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L260).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinSpec_circuitCost" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinSpec_circuitCost")
Source documentation: `The spec's circuit local cost: the SWAP placeholder costs 3 CNOTs and each unexpanded oracle call is counted as one unresolved call in the candidate score. figure:1_term_ROBIN`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:269](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L269).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinNormalizer_eval" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinNormalizer_eval")
Source documentation: `Evaluating the symbolic normalizer 'N_D · N_f · κ' under an environment gives the product of the three symbol values.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:274](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L274).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinClaim" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinClaim")
Source documentation: `The paper's one-term Robin block-encoding construction claim.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:279](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L279).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneDimHamiltonianResourceExpr" (lean := "QuantumBlockEncoding.GHL2025.oneDimHamiltonianResourceExpr")
Source documentation: `One-dimensional Hamiltonian block-encoding resource shape.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:288](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L288).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneDimHamiltonianClaim" (lean := "QuantumBlockEncoding.GHL2025.oneDimHamiltonianClaim")
Source documentation: `The paper's 1D Hamiltonian block-encoding construction claim.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:296](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L296).
:::

:::definition "QuantumBlockEncoding.GHL2025.multiDimHamiltonianResourceExpr" (lean := "QuantumBlockEncoding.GHL2025.multiDimHamiltonianResourceExpr")
Source documentation: `Multidimensional Hamiltonian block-encoding resource shape.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:305](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L305).
:::

:::definition "QuantumBlockEncoding.GHL2025.multiDimHamiltonianClaim" (lean := "QuantumBlockEncoding.GHL2025.multiDimHamiltonianClaim")
Source documentation: `The paper's multidimensional Hamiltonian block-encoding construction claim.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:313](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L313).
:::

:::definition "QuantumBlockEncoding.GHL2025.ObligationRecord" (lean := "QuantumBlockEncoding.GHL2025.ObligationRecord")
Source documentation: `A proof obligation tracked by description and paper source anchor. 'proved' is 'Bool' (not 'Prop') so that unproved obligations are honest data, not mathematically false claims. main.tex -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:324](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L324).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinCircuitSkeleton" (lean := "QuantumBlockEncoding.GHL2025.RobinCircuitSkeleton")
Source documentation: `Circuit skeleton matching Fig. 1_term_ROBIN (main.tex:1137-1167). Each field corresponds to a labeled box or operation in the figure. All oracles are recorded as symbolic names; their implementation is delegated to separate oracle-contract structures. figure:1_term_ROBIN -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:334](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L334).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinGamma1" (lean := "QuantumBlockEncoding.GHL2025.RobinGamma1")
Source documentation: `Eq. ROBIN clarified, gamma_1 component (main.tex:1113). State after U_indic sets the indicator ancilla. The boundary and bulk summation terms have different normalizers: boundary: 1/(N_D · sqrt(kappa)), indicator |0> bulk: 1/sqrt(kappa), indicator |1> main.tex:1113 -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:373](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L373).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinGamma2" (lean := "QuantumBlockEncoding.GHL2025.RobinGamma2")
Source documentation: `Eq. ROBIN clarified, gamma_2 component (main.tex:1115). State after sparse-amplitude oracle encodes D^T values. main.tex:1115 -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:396](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L396).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinGamma3" (lean := "QuantumBlockEncoding.GHL2025.RobinGamma3")
Source documentation: `Eq. ROBIN clarified, gamma_3 component (main.tex:1117). State after O_f encodes f(x_j) values. main.tex:1117 -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:413](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L413).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinWavefunctionDecomposition" (lean := "QuantumBlockEncoding.GHL2025.RobinWavefunctionDecomposition")
Source documentation: `Bundle of the three intermediate wavefunction states from Eq. ROBIN clarified. Captures the full circuit state evolution from input through U_indic, O_DT^S, and O_f. main.tex:1113-1117, figure:1_term_ROBIN -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:433](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L433).
:::

:::definition "QuantumBlockEncoding.GHL2025.defaultRobinWavefunctionDecomposition" (lean := "QuantumBlockEncoding.GHL2025.defaultRobinWavefunctionDecomposition")
Source documentation: `Default wavefunction decomposition from concrete parameters. figure:1_term_ROBIN, main.tex:1113-1117 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:452](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L452).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinProofObligations" (lean := "QuantumBlockEncoding.GHL2025.RobinProofObligations")
Source documentation: `Bundle of proof obligations for the one-term Robin block encoding. Each obligation references a specific claim in the paper and tracks whether it has been formally proved. None are proved in the current version. Guseynov-Huang-Liu 2025, one-term Robin theorem, arXiv:2506.20478. -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:488](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L488).
:::

:::definition "QuantumBlockEncoding.GHL2025.defaultRobinCircuitSkeleton" (lean := "QuantumBlockEncoding.GHL2025.defaultRobinCircuitSkeleton")
Source documentation: `Default circuit skeleton for the one-term Robin construction, with oracle names matching the paper's notation. figure:1_term_ROBIN -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:553](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L553).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessPaperContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessPaperContract")
Source documentation: `Paper-level source contract for the banded sparse-access oracle in Lemma 1. The input register is the padded sparse-index register '|0>^(n-l)|s>^l' followed by the row register '|i>^n'; the output is '|r_si>^n|i>^n'. This record is intentionally separate from the current 'bandedSparseAccessMatrix' helper, which overwrites the system register with a Robin column map and therefore does not yet implement this paper contract. Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:577](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L577).
:::

:::definition "QuantumBlockEncoding.GHL2025.defaultBandedSparseAccessPaperContract" (lean := "QuantumBlockEncoding.GHL2025.defaultBandedSparseAccessPaperContract")
Source documentation: `Default Lemma 1 register contract for the one-term Robin parameters. The 'widthCompatible' obligation stays explicit because the current parameter type does not enforce 'clog2 kappa <= n'; faithful proofs should discharge that side condition or specialize to a parameter family where it is available.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:602](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L602).
:::

:::definition "QuantumBlockEncoding.GHL2025.DerivativeOracleContract" (lean := "QuantumBlockEncoding.GHL2025.DerivativeOracleContract")
Source documentation: `Contract for the derivative oracle O_D: sparse-access oracle for the banded stencil matrix. Records stencil metadata, bandwidth, and a correctness obligation. main.tex:784-801 -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:650](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L650).
:::

:::definition "QuantumBlockEncoding.GHL2025.FunctionOracleContract" (lean := "QuantumBlockEncoding.GHL2025.FunctionOracleContract")
Source documentation: `Contract for the function oracle O_f: amplitude oracle encoding f(x) on the grid. Records the piece count, normalization bound, and a correctness obligation. main.tex:870-910`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:661](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L661).
:::

:::definition "QuantumBlockEncoding.GHL2025.derivativeOracleResource" (lean := "QuantumBlockEncoding.GHL2025.derivativeOracleResource")
Source documentation: `Resource for the derivative oracle O_D using the banded sparse-access formula from Lemma 1 of Guseynov-Huang-Liu 2025. The half-bandwidth parameter is 'stencil.leftRadius' (assumes a symmetric stencil where leftRadius = rightRadius).`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:671](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L671).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeOracleResource_pureAncilla" (lean := "QuantumBlockEncoding.GHL2025.derivativeOracleResource_pureAncilla")
Source documentation: `The derivative oracle's pure ancilla count is n - 1 (from Lemma 1).`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:675](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L675).
:::

:::definition "QuantumBlockEncoding.GHL2025.OneTermRobinTheoremData" (lean := "QuantumBlockEncoding.GHL2025.OneTermRobinTheoremData")
Source documentation: `Typed theorem data for Theorem one-term block-encoding (main.tex:1098-1109). Captures the exact block-encoding tuple (α, m, a) from the paper: α = N_D · N_f · κ (normalizer) m = ⌈log₂ n⌉ + ⌈log₂ G_f⌉ + ⌈log₂ κ⌉ + 4 (signal ancilla qubits) a = 0 (zero approximation error) along with the gate-count and pure-ancilla resource claims.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:684](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L684).
:::

:::definition "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData" (lean := "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData")
Source documentation: `Default theorem data instance from concrete parameters. main.tex:1098-1109 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:700](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L700).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinBoundaryRotationAngle" (lean := "QuantumBlockEncoding.GHL2025.RobinBoundaryRotationAngle")
Source documentation: `A controlled R_y rotation angle for a single boundary row entry. The paper (Eq. angles for Ry, main.tex:1081-1083) defines: theta_j^s = arccos(D_j^(s) / N_D) for sparse index s in {0,...,kappa-1} and boundary row j. main.tex:1081-1083 -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:714](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L714).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinBoundaryRotationSet" (lean := "QuantumBlockEncoding.GHL2025.RobinBoundaryRotationSet")
Source documentation: `The set of all boundary-controlled rotation angles for a given Robin construction. For each boundary row j and sparse index s, there is one angle theta_j^s. Total count = kappa * (K1 + gridSize - K2) = kappa * deviatingIndices. main.tex:1081-1083, 1088-1089 -`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:732](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L732).
:::

:::definition "QuantumBlockEncoding.GHL2025.RobinBoundaryRotationSet.expectedCount" (lean := "QuantumBlockEncoding.GHL2025.RobinBoundaryRotationSet.expectedCount")
Source documentation: `Number of boundary rows = K1 + gridSize - K2. Each boundary row has kappa rotation angles (one per sparse index). main.tex:1092-1095 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:752](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L752).
:::

:::definition "QuantumBlockEncoding.GHL2025.importedClaims" (lean := "QuantumBlockEncoding.GHL2025.importedClaims")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:755](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L755).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinTotalQubits" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinTotalQubits")
Source documentation: `Total number of qubits in the one-term Robin circuit. Uses the register partition total: sum of all register widths. main.tex:1098-1109 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:770](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L770).
:::

:::definition "QuantumBlockEncoding.GHL2025.effectiveRobinSignalQubits" (lean := "QuantumBlockEncoding.GHL2025.effectiveRobinSignalQubits")
Source documentation: `Effective signal qubits: total circuit qubits minus the system register width. This is the number of non-system qubits in the register partition. main.tex:1098-1109 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:777](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L777).
:::

:::theorem "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData_signalQubits_eq_layout" (lean := "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData_signalQubits_eq_layout")
Source documentation: `The theorem tuple uses the paper's signal-qubit count. This is the block-encoding parameter 'ceil(log2 n) + ceil(log2 G_f) + ceil(log2 kappa) + 4', not the number of all non-system wires in the concrete circuit register partition. Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, arXiv:2506.20478.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:789](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L789).
:::

:::theorem "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_layout" (lean := "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_layout")
Source documentation: `The theorem tuple and the reusable layout record carry the same '2n' pure-ancilla resource count.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:798](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L798).
:::

:::theorem "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_resource" (lean := "QuantumBlockEncoding.GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_resource")
Source documentation: `The theorem tuple and concrete resource record carry the same '2n' pure-ancilla count.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:807](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L807).
:::

:::theorem "QuantumBlockEncoding.GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace" (lean := "QuantumBlockEncoding.GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace")
Source documentation: `The concrete block projection has to project all non-system wires. Compared with the theorem-level signal parameter, the circuit-level projection also includes the visible padded 'O_D^BS' pure-register qubits and the trailing one-qubit ancilla in the register partition. This is an arithmetic bridge between the theorem tuple and the matrix backend, not a block-correctness proof.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:821](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L821).
:::

:::theorem "QuantumBlockEncoding.GHL2025.effectiveRobinSignalQubits_eq_theoremData_signal_plus_visibleWorkspace" (lean := "QuantumBlockEncoding.GHL2025.effectiveRobinSignalQubits_eq_theoremData_signal_plus_visibleWorkspace")
Source documentation: `Same projection bridge, stated directly against the theorem-data tuple. This pins the matrix backend's projection dimension to the paper theorem's signal parameter plus the visible padded 'O_D^BS' workspace and the one-qubit ancilla. It is still only a layout bridge, not an ancilla-cleanup or block correctness proof.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:839](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L839).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinIndicatorBitPosition" (lean := "QuantumBlockEncoding.GHL2025.robinIndicatorBitPosition")
Source documentation: `Bit position of the indicator qubit in the compound register. = ancillaQubit + systemQubits + odPureAncillaQubits + sparseIndexQubits = 1 + n + (n - clog2 κ) + clog2 κ = 1 + 2n main.tex:1113 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:852](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L852).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinSparseColumnMap" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap")
Source documentation: `Column mapping for the banded sparse access oracle O_D^BS. Returns the column index for sparse index s in row i of the Robin derivative matrix. For bulk rows (K1 ≤ i ≤ K2): 5 entries, col(s,i) = i - 2 + s for s < 5. For left boundary: - Row 0 (3 entries): col(s,0) = s for s < 3 - Row 1 (4 entries): col(s,1) = s for s < 4 For right boundary (N = gridSize n): - Row N-2 (4 entries): col(s,N-2) = N-4+s for s < 4 - Row N-1 (3 entries): col(s,N-1) = N-3+s for s < 3 For unused sparse indices (s ≥ entry count): returns i (identity on system register). main.tex:784-801 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:869](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L869).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseOffset" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseOffset")
Source documentation: `Global sparse-slot offset table for the one-term Robin 'κ = 7' construction. The first five slots keep the existing fourth-order stencil order '{-2,-1,0,1,2}'. The final two slots record the boundary-effect diagonals '{-3,3}' required by the source audit. The active Lemma 1 address uses this global slot table; row-dependent branch deletion remains only a rejected-model helper. Guseynov-Huang-Liu 2025, Lemma 'Diagonal sparsity', Lemma 'Banded-sparse-access-oracle', and Remark 'sparsity maximum', arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:897](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L897).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress")
Source documentation: `Global sparse-access address 'r_{si}=r_{s0}+i mod 2^n'. This is the active paper address for 'O_D^BS'; it does not remove zero boundary-amplitude slots from the sparse register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:915](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L915).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_lt_gridSize" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_lt_gridSize")
Source documentation: `The global sparse-slot address is always an 'n'-bit row address.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:919](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L919).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot")
Source documentation: `Inverse sparse slot used by the post-SWAP cleanup candidate for the global offset table. This is only an executable preimage witness helper. It does not assert inverse uniqueness or promote the dagger-cleanup obligation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:934](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L934).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_lt_eight" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_lt_eight")
Source documentation: `The global inverse-slot helper fits in the three-bit sparse register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:946](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L946).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_lt_seven")
Source documentation: `The inverse sparse-slot helper stays in the active seven-slot table.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:952](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L952).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven")
Source documentation: `The inverse sparse-slot helper is an involution on the active 'κ = 7' slot set. This is a finite-table proof block for the global-source preimage route; it does not prove uniqueness of the full 'O_D^BS' matrix image.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:967](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L967).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven")
Source documentation: `The inverse sparse-slot helper is injective on the active 'κ = 7' slot set. This feeds the later clean-preimage uniqueness proof for the corrected global slot model, but it intentionally leaves the semantic cleanup and unitarity obligations false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:985](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L985).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_inverseSlot_address_eq" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_inverseSlot_address_eq")
Source documentation: `Global sparse-address roundtrip for the supplied inverse-slot helper. For an 'n >= 3' grid and any encoded sparse value below '8', addressing by a slot and then by the inverse slot returns the original row modulo '2^n'. This is the arithmetic block needed by the conditional post-SWAP preimage candidate; it is not an injectivity or cleanup proof.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1009](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1009).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseOffset_lt_gridSize_of_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseOffset_lt_gridSize_of_lt_seven")
Source documentation: `Every active global sparse-slot offset is an 'n'-bit address when '3 ≤ n'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1131](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1131).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_comp_eq_mod_offset_sum" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_comp_eq_mod_offset_sum")
Source documentation: `Composing two global sparse-slot addresses is addition by the sum of their global offsets modulo the grid size.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1149).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseOffset_sum_mod_eq_zero_unique_of_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseOffset_sum_mod_eq_zero_unique_of_lt_seven")
Source documentation: `If two active global sparse-slot offsets sum to zero modulo the grid, the first slot is the reverse slot of the second. This is only a finite arithmetic block for the corrected 'O_D^BS' address route; it does not prove dagger cleanup, unitarity, or block extraction.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1183](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1183).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven")
Source documentation: `Uniqueness of the reverse sparse slot for the corrected global-slot address. For active one-term Robin slots 's,t < 7', if applying slot 't' after slot 's' returns every in-range row 'i', then 't' must be the table inverse of 's'. This feeds the future clean-preimage uniqueness route while leaving all semantic 'O_D^BS' proof flags false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1228](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1228).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_same_row_injective_of_lt_seven" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGlobalSparseAddress_same_row_injective_of_lt_seven")
Source documentation: `For a fixed in-range row, the corrected seven-slot global address table is injective in the sparse slot. The proof reuses the reverse-slot uniqueness block rather than repeating the finite offset table. It is still only an address-level arithmetic lemma; it does not promote any 'O_D^BS' semantic flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1261](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1261).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinSparseColumnBranchValid" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnBranchValid")
Source documentation: `Row-dependent sparse-branch domain for the executable one-term Robin stencil. This predicate is a source-contract correction candidate for Lemma 1 'O_D^BS': it marks exactly the sparse indices that correspond to nonzero stencil entries in the same five row regions used by 'robinSparseColumnMap'. The active matrix is not changed by this predicate; unused branches still remain a separate unitary-extension obligation. Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1295](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1295).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnBranchValid_boundaryUnused_n3" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnBranchValid_boundaryUnused_n3")
Source documentation: `The proposed valid-branch predicate separates the boundary unused branch that caused the recorded 'n = 3' collision, while the current executable map still sends both branches to the same address.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1314](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1314).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_lt_gridSize_of_row_lt" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_lt_gridSize_of_row_lt")
Source documentation: `Proof-DAG block for the Lemma 1 address-range route. For the fourth-order Robin stencil, if the input row is an 'n'-bit value and 'n >= 2', then the executable one-term column map also returns an 'n'-bit value. The paper-level contract still records 'addressRange.proved := false' because the parameter-family side condition is not yet part of 'OneTermRobinParameters'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1329](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1329).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex")
Source documentation: `Candidate reverse sparse index for the one-term Robin stencil. Given a target row 'target' and a post-SWAP row 'row', this returns the sparse index that would make 'row' address 'target' in the executable fourth-order Robin column map. It is only a reverse-index candidate: the checked roundtrip and cleanup obligations remain separate proof blocks. Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1386](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1386).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_zero" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_zero")
Source documentation: `Normal form for the leftmost row of the executable Robin sparse map.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1396](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1396).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_one" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_one")
Source documentation: `Normal form for the second row of the executable Robin sparse map.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1401](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1401).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_bulk" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_bulk")
Source documentation: `Normal form for a bulk row of the executable Robin sparse map.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1406](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1406).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_rightBoundaryPrev" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_rightBoundaryPrev")
Source documentation: `Normal form for the penultimate row of the executable Robin sparse map.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1412](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1412).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_rightBoundaryLast" (lean := "QuantumBlockEncoding.GHL2025.robinSparseColumnMap_rightBoundaryLast")
Source documentation: `Normal form for the last row of the executable Robin sparse map.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1427).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_zero" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_zero")
Source documentation: `Reverse-index normal form for row zero.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1443](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1443).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_one" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_one")
Source documentation: `Reverse-index normal form for row one.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1448](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1448).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_bulk" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_bulk")
Source documentation: `Reverse-index normal form for a bulk row.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1453](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1453).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_rightBoundaryPrev" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_rightBoundaryPrev")
Source documentation: `Reverse-index normal form for the penultimate row.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1461](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1461).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_rightBoundaryLast" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_rightBoundaryLast")
Source documentation: `Reverse-index normal form for the last row.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1477](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1477).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnRoundtrip_of_lt_eight" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnRoundtrip_of_lt_eight")
Source documentation: `The reverse sparse-index candidate is a left inverse for the executable one-term Robin column map on the three-bit sparse-index range used by the current one-term parameter family. This is only the arithmetic roundtrip needed by the O_D^BS post-SWAP cleanup route. It does not prove uniqueness of the preimage, dagger cleanup, unitarity, or block correctness.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1502](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1502).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_lt_eight_of_columnMap" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnIndex_lt_eight_of_columnMap")
Source documentation: `The reverse-index candidate stays inside the three-bit sparse register for columns produced by the executable one-term Robin map. This is paired with 'robinSparseReverseColumnRoundtrip_of_lt_eight'; it is a local arithmetic block for the post-SWAP preimage route, not a uniqueness or dagger-cleanup proof.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1715](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1715).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnRoundtripCheck" (lean := "QuantumBlockEncoding.GHL2025.robinSparseReverseColumnRoundtripCheck")
Source documentation: `Executable finite audit for the reverse-index candidate. For each sparse-index value below 'sparseBound' and each row of the 'n'-qubit grid, this checks that forward addressing followed by 'robinSparseReverseColumnIndex' returns to the original row. A true result is local evidence for the inverse-on-range route; it is not a semantic cleanup proof for 'O_D^BS'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1875](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1875).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessPaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessPaperRegisters")
Source documentation: `Register values used by the faithful Lemma 1 'O_D^BS' contract. The current compound-index convention stores the row register in bits '[1, 1+n)' and the paper's padded sparse-address register in bits '[1+n, 1+2n)'. Inside that address block, the low 'n - clog2 kappa' bits are the padded-zero workspace and the remaining bits encode the sparse index 's'. Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1890](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1890).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters")
Source documentation: `Extract the Lemma 1 padded sparse-address and row registers from a compound basis index. This is a source-contract skeleton only; it does not alter the interim 'bandedSparseAccessMatrix' helper and does not prove unitarity.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1902](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1902).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_row_lt_gridSize" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_row_lt_gridSize")
Source documentation: `The row field extracted for Lemma 1 is always an 'n'-bit row value.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1919](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1919).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_sparseIndexValue_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_sparseIndexValue_eq")
Source documentation: `The sparse-index field is the high sparse slice of the full O_D register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1928](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1928).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_paddedZeroValue_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_paddedZeroValue_eq")
Source documentation: `The padded-zero field is the low padded slice of the full O_D register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1936](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1936).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_sparseIndex_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_sparseIndex_lt")
Source documentation: `The extracted sparse-index field always fits in its declared bit width.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1944](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1944).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_odRegisterValue_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisters_odRegisterValue_lt")
Source documentation: `The extracted O_D register value always fits in its declared 'n'-bit block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1955](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1955).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessRowDependentPaperAddress" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessRowDependentPaperAddress")
Source documentation: `Rejected row-dependent paper-address helper. This is the old active address model: it used 'robinSparseColumnMap', which deletes boundary zero-amplitude sparse slots by folding them back to the row. It is retained only for regression tests and proof-attempt memory.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1971](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1971).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddress" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddress")
Source documentation: `Paper address value 'r_si' for the one-term Robin sparse-access oracle. The active address follows the global sparse-slot formula 'r_si = r_s0 + i mod 2^n'. Boundary or zero-amplitude slots remain present in the sparse register; the coefficient layer supplies zero values where needed.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1983](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1983).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddressInRange" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddressInRange")
Source documentation: `Executable check that the paper address 'r_si' fits in the n-bit address register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1988](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1988).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddressInRange_iff" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddressInRange_iff")
Source documentation: `Boolean form of the executable 'O_D^BS' address-range check.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:1992](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L1992).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddress_lt_gridSize_of_two_le" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddress_lt_gridSize_of_two_le")
Source documentation: `The executable paper address is in range for the fourth-order grid regime '2 <= n'. This is a reusable arithmetic block; it does not promote the paper-level semantic obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2004](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2004).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddressInRange_eq_true_of_two_le" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddressInRange_eq_true_of_two_le")
Source documentation: `The executable address-range Boolean evaluates to true for the fourth-order grid regime '2 <= n'. The contract flag remains false until the paper parameter family records this side condition.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2017](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2017).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage")
Source documentation: `Executable Lemma 1 image skeleton for 'O_D^BS'. It preserves the row/system register and replaces the padded sparse-address register by 'r_si'. Correctness, unitarity, and dagger cleanup remain recorded in 'defaultBandedSparseAccessPaperContract p' with 'proved := false'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2031](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2031).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessRowDependentPaperImage" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessRowDependentPaperImage")
Source documentation: `Rejected row-dependent image helper corresponding to the old active address. This has the same register splice as 'bandedSparseAccessPaperImage', but writes the row-dependent helper address. It is not the active paper image.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2047](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2047).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisterValue_eq_mod" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperRegisterValue_eq_mod")
Source documentation: `Bit-slice extraction as arithmetic division followed by an 'n'-bit remainder. This keeps later register-splice proofs in ordinary arithmetic form.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2062](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2062).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperHighWidth_le_totalQubits" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperHighWidth_le_totalQubits")
Source documentation: `The O_D^BS address block ends before the full one-term Robin basis width.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2076](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2076).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_lowBlock_lt_highBase_of_address_lt")
Source documentation: `The low block of the paper image fits below the high-tail boundary whenever the written O_D^BS address is an n-bit value.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2087](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2087).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_mod_lowBase" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_mod_lowBase")
Source documentation: `The paper image preserves the low ancilla-and-row block modulo its width.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2133](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2133).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_div_lowBase_mod_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_div_lowBase_mod_eq")
Source documentation: `After shifting past the low block, the paper image exposes the written address modulo the n-bit O_D^BS register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2172](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2172).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt")
Source documentation: `The executable paper image remains inside the full finite basis when the input column is in range and the written O_D^BS address is n-bit.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2219](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2219).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageFin" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageFin")
Source documentation: `Finite-basis index for the executable Lemma 1 'O_D^BS' paper image. This constructor is available only when the source column is already in the full finite basis and the written 'O_D^BS' address is n-bit. It is a bridge from the arithmetic image function to matrix entries, not a unitarity proof.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2268](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2268).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageFin_val" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageFin_val")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2276](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2276).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_rowValue_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_rowValue_eq")
Source documentation: `Register extraction from the paper image preserves the row register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2284](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2284).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_odRegisterValue_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_odRegisterValue_eq")
Source documentation: `Register extraction from the paper image reports the written O_D^BS address.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2303](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2303).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperHighTail" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperHighTail")
Source documentation: `High signal/workspace bits above the n-bit 'O_D^BS' address register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2315](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2315).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_highTail_eq_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_highTail_eq_of_address_lt")
Source documentation: `The arithmetic register-splice form of 'bandedSparseAccessPaperImage' preserves all bits above the 'O_D^BS' address register when the written address is n-bit. This is a proof-DAG block for Lemma 1 register safety. It does not promote the paper-level 'noSpill' obligation because the parameter-family side conditions are still tracked by 'defaultBandedSparseAccessPaperContract'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2326](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2326).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill")
Source documentation: `Executable check that the paper-image skeleton does not write past the n-bit 'O_D^BS' address register into the indicator or 'm_f' bits above it.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2361](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2361).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill_iff" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill_iff")
Source documentation: `Boolean form of the executable high-tail no-spill check. The high-tail theorem above discharges this Boolean under an n-bit written address, while the paper-level semantic obligation remains a separate flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2371](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2371).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt")
Source documentation: `The no-spill Boolean follows from the executable n-bit address bound.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2380](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2380).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le")
Source documentation: `The no-spill Boolean is true in the fourth-order grid regime '2 <= n', reusing the address-range proof-DAG block. Semantic obligation flags remain false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2391](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2391).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanInput" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanInput")
Source documentation: `Clean-domain predicate for the Lemma 1 'O_D^BS' source equation. The paper specifies columns whose padded zero register is '|0>^(n-l)'. Columns outside this domain still need a separate unitary-completion proof; the current paper-image matrix is only a Phase 1 skeleton for that full-space extension.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2406](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2406).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSparseIndexInKappa" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSparseIndexInKappa")
Source documentation: `Faithful sparse-slot range for the Lemma 1 'O_D^BS' source equation. The paper source domain keeps the global slot 's' whenever 's < kappa'. Whether a boundary coefficient is zero is handled by the amplitude layer, not by deleting the sparse-register slot from the index oracle.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2416](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2416).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource")
Source documentation: `Faithful clean source domain for the active global-slot 'O_D^BS' address. This predicate is the padded clean input from Lemma 1 together with the global slot range 's < kappa'. It supersedes the row-dependent nonzero-branch classifier as the active source-domain contract for 'bandedSparseAccessPaperImage'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2427).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_cleanInput_eq_true" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_cleanInput_eq_true")
Source documentation: `A faithful global-slot source column is clean in the padded O_D register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2433](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2433).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_sparseIndex_lt_kappa" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_sparseIndex_lt_kappa")
Source documentation: `A faithful global-slot source column has sparse index below 'kappa'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2442](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2442).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective")
Source documentation: `Global-source wrapper for inverse-slot injectivity. For the one-term Robin 'κ = 7' family, two active global-source columns with the same reverse sparse slot have the same extracted sparse slot. This is a local source-domain block for the later unique-preimage proof; it does not promote inverse-on-range, cleanup, or unitarity obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2461](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2461).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddress_same_row_injective_of_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperAddress_same_row_injective_of_globalSlotSource")
Source documentation: `Same-row injectivity of the active paper address on the global-slot source domain. This lifts the seven-slot address lemma through the Lemma 1 register extractor: if two active global-source columns have the same row and the same corrected paper address, then their sparse slots are equal. It does not assert matrix unitarity or dagger cleanup.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2493](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2493).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidSparseBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidSparseBranch")
Source documentation: `Candidate row-dependent sparse-branch domain for a basis column of Lemma 1. This is deliberately separate from 'bandedSparseAccessPaperCleanInput'. The paper clean-input condition only checks the padded zero register, while this candidate also excludes row-boundary sparse indices that do not correspond to nonzero stencil entries. It is now a rejected-model audit helper; the active paper source domain is 'bandedSparseAccessPaperGlobalSlotSource'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2541](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2541).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource")
Source documentation: `Candidate corrected clean source domain for Lemma 1: padded-zero input plus a row-dependent valid sparse branch. This is a rejected-model contract-audit predicate only. Use 'bandedSparseAccessPaperGlobalSlotSource' for the active global-slot source contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2552](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2552).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource_cleanInput_eq_true" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource_cleanInput_eq_true")
Source documentation: `The corrected source-domain candidate implies the original clean input.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2558](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2558).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource_validSparseBranch_eq_true" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource_validSparseBranch_eq_true")
Source documentation: `The corrected source-domain candidate implies a valid sparse branch.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2567](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2567).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3")
Source documentation: `The row-dependent valid-source audit excludes the concrete unused sparse branch from the recorded 'n = 3', 'kappa = 7' rejected-model collision. The active global-slot paper image now separates the same two clean columns.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2580](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2580).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperUnusedSparseBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperUnusedSparseBranch")
Source documentation: `Classifier for clean padded-register columns whose sparse branch is invalid for the row-dependent Robin stencil. This is the source-domain side of the unused-branch extension obligation. The active O_D^BS matrices are not changed by this predicate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2601](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2601).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperUnusedSparseBranch_cleanInput_eq_true" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperUnusedSparseBranch_cleanInput_eq_true")
Source documentation: `An unused sparse branch is still in the padded clean-input domain.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2607](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2607).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperUnusedSparseBranch_validSparseBranch_eq_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperUnusedSparseBranch_validSparseBranch_eq_false")
Source documentation: `An unused sparse branch is outside the row-dependent valid-branch classifier.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2616](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2616).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanDomainSplit_iff" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanDomainSplit_iff")
Source documentation: `The executable clean padded-input domain splits into valid sparse branches and clean unused sparse branches. This is only the local Boolean classifier split for the source-contract audit. It does not choose an image for unused branches and does not promote the semantic 'cleanDomainSplit' obligation in the full-domain wrapper.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2632](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2632).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanDomainSplit_disjoint" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanDomainSplit_disjoint")
Source documentation: `The two branches in 'bandedSparseAccessPaperCleanDomainSplit_iff' are disjoint. This is a classifier fact only; injectivity and unitary extension for the eventual image rule remain separate false obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2657](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2657).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessUnusedBranchImageRuleContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessUnusedBranchImageRuleContract")
Source documentation: `Interface for the missing reversible image rule on clean unused sparse branches. No paper-backed formula has been selected yet, so 'proposedImageIndex' is 'none' and every semantic claim remains an explicit false obligation. The active 'bandedSparseAccessPaperImage' skeleton is not changed by this record.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2680](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2680).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchImageRuleContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchImageRuleContract")
Source documentation: `Default image-rule interface for one unused-branch source column. The missing reversible image is intentionally represented by 'none'; later faithful work must replace this with a paper-compatible extension before any injectivity, dagger-cleanup, or unitarity proof is attempted.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2702](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2702).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_flags_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_flags_false")
Source documentation: `The unused-branch image-rule interface is obligation-only in Phase 1.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2735](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2735).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch")
Source documentation: `Classifier bridge for the unused-branch image-rule interface. For a clean invalid sparse branch, Lean records the branch classification and keeps the image-rule target unspecified with false proof fields.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2750](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2750).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessUnusedBranchExtensionContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessUnusedBranchExtensionContract")
Source documentation: `Contract slot for a faithful reversible extension on unused sparse branches. GHL2025 keeps zero-amplitude sparse branches inside the kappa-wide register. The current active image skeleton can collide on such branches, so Phase 1 records the missing extension as obligations instead of proving injectivity or unitarity for the colliding skeleton.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2775](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2775).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract")
Source documentation: `Default unused-branch extension contract for one O_D^BS basis column. All semantic fields remain false. The record exists so later work can state the reversible completion separately from the paper image on valid branches.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2797](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2797).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract_flags_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract_flags_false")
Source documentation: `The unused-branch extension contract is obligation-only in Phase 1.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2837](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2837).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3")
Source documentation: `The unused-branch contract classifies the recorded row-dependent boundary collision without promoting any O_D^BS semantic proof flag. The active global-slot image no longer has this concrete collision; the extension fields remain false because this packet does not prove full clean-domain injectivity, dagger cleanup, or unitarity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2856](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2856).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch")
Source documentation: `Package the unused-branch classifier with the reversible-extension obligations. This is a contract bridge only: it exposes that an unused clean branch is in the clean padded-input domain, is outside the row-dependent valid sparse-branch classifier, and still has only false extension proof fields.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2875](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2875).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessFullCleanDomainExtensionContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessFullCleanDomainExtensionContract")
Source documentation: `Paper-level wrapper for the full clean-domain extension obligation of 'O_D^BS'. The paper clean domain contains every padded-zero source '|0>^(n-l)|s>^l|i>^n', including zero-amplitude sparse branches. QBE currently has only the active Lemma 1 image on valid row-dependent branches and a per-column interface for clean unused branches. This record lifts those pieces into one contract without choosing a reversible unused-branch image and without changing the active forward or dagger matrices.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2906](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2906).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract")
Source documentation: `Default full clean-domain extension contract for Lemma 1 'O_D^BS'. All semantic fields are false obligations. The nested per-column image-rule contract still has 'proposedImageIndex = none', so this declaration only records the missing proof interface for later source-domain reconciliation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2932](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2932).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_flags_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_flags_false")
Source documentation: `The full clean-domain wrapper is obligation-only in Phase 1.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:2986](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L2986).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch")
Source documentation: `The full clean-domain wrapper reuses the existing per-column unused-branch classifier bridge and keeps every extension proof flag false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3006](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3006).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit")
Source documentation: `Wrapper-facing form of the local clean-domain split audit. The classifier split is Lean-proved, while the full semantic wrapper still keeps 'cleanDomainSplit.proved = false' because no unused-branch image rule, injectivity proof, or unitary extension has been supplied.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3032](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3032).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessUnusedZeroBranchSourceDecision" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessUnusedZeroBranchSourceDecision")
Source documentation: `Lean-facing source decision for unused zero-amplitude 'O_D^BS' branches. Cycle 14 records that no paper-backed image formula and no accepted external reversible-extension theorem currently supplies the missing image rule for clean unused sparse branches. This is a blocking dependency record, not a new oracle construction.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3049](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3049).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision")
Source documentation: `Default cycle-14 source decision for unused zero-amplitude sparse branches. The false Boolean fields deliberately prevent lower proof work from treating the current colliding active image as a permutation or unitary extension.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3064](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3064).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false")
Source documentation: `The cycle-14 source decision is a blocking obligation, not a proof ticket.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3078](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3078).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsFullDomainFlagsFalse" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsFullDomainFlagsFalse")
Source documentation: `The source decision keeps the full clean-domain wrapper in obligation mode. This ties the cited-results dependency to the existing wrapper fields without changing any active matrix or promoting any semantic proof flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3091](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3091).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified")
Source documentation: `The blocking source decision keeps every unused-branch image slot unspecified. This is a guard for later lower packets: disabling proof search also means the per-column image-rule contract and the full-domain wrapper still expose 'proposedImageIndex = none' with false image-rule obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3112](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3112).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse")
Source documentation: `The blocking source decision also keeps the paper-level O_D^BS contract obligations false. This is separate from the full clean-domain wrapper: it pins the original Lemma 1 contract fields that a later proof packet would otherwise try to close.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3134](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3134).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessRobinZeroInclusionSourceContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessRobinZeroInclusionSourceContract")
Source documentation: `Source transcript for the Robin zero-inclusion sentence near Theorem 1. The paper states that zeros may be included in the sparse enumeration and then uses the range 's = 0, ..., kappa - 1' in Eq. ROBIN clarified. This source fact explains why the row-dependent nonzero-stencil classifier is not a faithful full domain restriction. It still does not choose an injective image for clean unused zero-amplitude branches.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3152](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3152).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract")
Source documentation: `Default transcript of the GHL2025 Robin zero-inclusion source text. The source records that zero-amplitude sparse branches remain in the kappa-wide sparse register. The missing image rule and any reversible extension theorem are intentionally absent, so this declaration does not unblock O_D^BS proof search.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3176](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3176).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_blocks_unusedZeroBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_blocks_unusedZeroBranch")
Source documentation: `The Robin zero-inclusion source transcript keeps the unused-branch route blocked. This guard records the exact source-backed inclusion of zero-amplitude sparse branches while preserving the absence of a branch image rule or reversible extension theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3211](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3211).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_keepsImageRuleUnspecified" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_keepsImageRuleUnspecified")
Source documentation: `The zero-inclusion transcript does not fill the per-column image-rule slot. For every one-term parameter choice and source column, the direct image-rule contract remains unspecified while lower proof search is disabled.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3239](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3239).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessPriorPDESourceContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessPriorPDESourceContract")
Source documentation: `Source contract imported from the prior PDE block-encoding paper. The prior paper supplies the same padded-register equation and an appendix decomposition into a first-row index unitary and modular addition. This record is intentionally only a source transcript: it does not provide a Robin-specific image rule for clean unused zero-amplitude sparse branches.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3264](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3264).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract")
Source documentation: `Default transcript of arXiv:2405.12855v3 Definition 6, Lemma 1, and the appendix construction for 'O_A^BS'. The field 'robinUnusedBranchImageRule = none' records the audit result: this source supports the imported sparse-access primitive, but not the missing Robin unused-branch image formula.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3285](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3285).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract_blocks_unusedZeroBranch" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract_blocks_unusedZeroBranch")
Source documentation: `The prior PDE source does not unblock the QBE unused-zero-branch extension. This is the compiled guard for the source audit: the cited theorem is recorded, but lower proof search for Robin unused-branch injectivity, cleanup, and unitarity remains disabled.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3310](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3310).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract_oracleEquation" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract_oracleEquation")
Source documentation: `The prior PDE source contract records the exact sparse-access equation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3319](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3319).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract_resource_unproved" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPriorPDESourceContract_resource_unproved")
Source documentation: `The prior PDE resource claim remains an external obligation in QBE.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3324](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3324).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanInput_iff" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanInput_iff")
Source documentation: `Boolean form of the Lemma 1 clean-input domain. The executable predicate is exactly the statement that the padded part of the 'O_D^BS' sparse-address register is zero. This only classifies columns; it does not prove the clean-input source equation or a unitary extension.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3334](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3334).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessPaperColumnContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessPaperColumnContract")
Source documentation: `Per-column audit record for the executable Lemma 1 paper image. This records the source-domain flag, the image index, and the two register properties expected from the paper equation. The Boolean fields are executable checks for the current skeleton; they are not promoted to theorem-level correctness. The obligation fields keep the clean-domain and full-unitary extension gaps explicit.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3350](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3350).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract")
Source documentation: `Default per-column contract for the 'O_D^BS' paper image skeleton.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3369](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3369).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_inputRegisters_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_inputRegisters_eq")
Source documentation: `The per-column contract uses the shared Lemma 1 register extractor.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3393](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3393).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_cleanInput_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_cleanInput_eq")
Source documentation: `The per-column clean-domain flag is the executable padded-zero predicate.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3399](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3399).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_cleanInput_iff" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_cleanInput_iff")
Source documentation: `The per-column clean-domain flag is true exactly on Lemma 1 clean columns. Columns with a nonzero padded register are still covered only by the explicit unitary-extension obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3410](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3410).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false")
Source documentation: `The per-column audit keeps the full-space unitary extension as an open obligation for every column, including non-clean padded-register inputs.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3421](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3421).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_imageIndex_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_imageIndex_eq")
Source documentation: `The per-column contract records the same image index as the paper-image skeleton.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3426](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3426).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_addressInRange_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_addressInRange_eq")
Source documentation: `The per-column contract records the executable n-bit address range check.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3432](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3432).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq")
Source documentation: `The per-column contract records the executable high-bit no-spill check.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3438](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3438).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_rowPreserved_eq_true" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_rowPreserved_eq_true")
Source documentation: `The per-column audit records that the paper image preserves the row register. This is an executable register-safety fact for the Phase 1 skeleton; it does not promote the paper-level 'forwardCorrect' obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3449](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3449).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt")
Source documentation: `The per-column audit records that the paper image writes the O_D register to the computed address whenever that address is an n-bit value.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3459](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3459).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_addressInRange_eq_true_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_addressInRange_eq_true_of_address_lt")
Source documentation: `The per-column address-range audit Boolean follows from the address bound.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3467](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3467).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq_true_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq_true_of_address_lt")
Source documentation: `The per-column no-spill audit Boolean follows from the address bound.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3475](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3475).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt")
Source documentation: `Reusable per-column register-safety package for the active Lemma 1 image skeleton. The package is deliberately conditional on the existing n-bit address hypothesis, so it does not hide the paper parameter-family obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3487](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3487).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperMatrix" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperMatrix")
Source documentation: `Matrix entries for the faithful Lemma 1 'O_D^BS' paper-image skeleton. The column 'j' has a candidate '1' entry at 'bandedSparseAccessPaperImage p j.val', which replaces the padded sparse-address register by 'r_si' and preserves the row register. This declaration is the active 'oneTermRobinGate_O_D_BS' matrix, but it does not prove that the image is in range, injective, unitary, or cleaned up by the dagger.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3509](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3509).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperMatrix_eq_image" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperMatrix_eq_image")
Source documentation: `The paper-image matrix entry is governed by 'bandedSparseAccessPaperImage'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3515](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3515).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one")
Source documentation: `Forward paper-image matrix entry at the finite image column. The hypotheses are the same explicit range hypotheses used to construct 'bandedSparseAccessPaperImageFin'. This theorem does not assert that the image function is injective or that the matrix is unitary.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3528](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3528).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperDaggerMatrix" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperDaggerMatrix")
Source documentation: `Transpose-style matrix for the faithful Lemma 1 'O_D^BS' paper-image skeleton. The entry 'M†[i,j]' is '1' exactly when column index 'j' is the forward paper image of row index 'i'. This is only the matrix-level transpose of the current executable image skeleton; the inverse, unitarity, and post-SWAP cleanup claims remain tracked by 'defaultBandedSparseAccessPaperContract p' with 'proved := false'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3545](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3545).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperDaggerMatrix_eq_image")
Source documentation: `The paper-image dagger matrix is the transpose-style matrix for the image skeleton.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3551](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3551).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one")
Source documentation: `Transpose-style paper-image matrix entry paired with the finite forward image. This is the entry relation needed before an inverse-on-range proof. It does not prove that the transpose-style matrix cleans the ancillas after SWAP.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3563](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3563).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinSparseAmplitudeValue" (lean := "QuantumBlockEncoding.GHL2025.robinSparseAmplitudeValue")
Source documentation: `Sparse amplitude value: the s-th nonzero stencil coefficient of row i in the Robin derivative matrix, returned as a Coeff value. This is the data layer that both O_DT^S (sparse amplitude oracle, Lemma 3) and Ry_boundary (boundary-controlled rotations) need. The column index corresponding to each (s, i) pair is given by 'robinSparseColumnMap'. For the fourth-order central second-derivative stencil: - Bulk rows (K1 ≤ i ≤ K2): 5 entries at offsets {-2,-1,0,1,2} - Left boundary row 0: 3 entries with Robin correction (A1*dx term) - Left boundary row 1: 4 entries with Robin correction (A1*dx term) - Right boundary row N-2: 4 entries with Robin correction (B1*dx term) - Right boundary row N-1: 3 entries with Robin correction (B1*dx term) - Unused sparse indices (s ≥ entry count): Coeff.rat 0 main.tex:822-849, 1081-1083, 1113-1117 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3588](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3588).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue" (lean := "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue")
Source documentation: `Global sparse-slot coefficient source for the one-term Robin table. Unlike 'robinSparseAmplitudeValue', the sparse index is interpreted through the active global slot table used by 'oneTermRobinGlobalSparseAddress'. Thus slot '2' is the zero-offset diagonal slot in every row. Boundary slots that are present in the global sparse register but absent from the Robin row carry coefficient '0'; the slot itself is not deleted. Guseynov-Huang-Liu 2025, Lemma 'Diagonal sparsity', Lemma 'Banded-sparse-access-oracle', the zero-inclusion paragraph before Theorem '1 term robin', and Eq. 'ROBIN clarified', arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3645](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3645).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue_boundarySlot2_row0_n3" (lean := "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue_boundarySlot2_row0_n3")
Source documentation: `Focused boundary regression: global slot '2' is the row-'0' diagonal.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3691](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3691).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue_boundarySlot2_differs_rowLocal_n3" (lean := "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue_boundarySlot2_differs_rowLocal_n3")
Source documentation: `The focused global slot is not the old row-local sparse entry. This records the contract drift found by the gamma3 boundary packet without promoting any analytic normalizer or block-encoding flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3703](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3703).
:::

:::definition "QuantumBlockEncoding.GHL2025.DerivativeNormalizerNDContract" (lean := "QuantumBlockEncoding.GHL2025.DerivativeNormalizerNDContract")
Source documentation: `Shared Phase-1 contract for every paper route that uses the normalized derivative coefficient 'D_j^(s) / N_D'. Both Lemma 3 'O_DT^S' and the boundary 'R_y' angle formulas use the same global sparse-slot coefficient source and the same normalizer symbol 'N_D'. This record keeps the common analytic gaps in one Lean object: nonzero normalizer, division semantics, coefficient bound, absolute-square semantics, square-root complement, arccos semantics, and two-by-two unitarity. It is a contract only; every obligation is false in Phase 1. Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), Fig. 1-term Robin, and boundary rotation equations, arXiv:2506.20478.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3721](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3721).
:::

:::definition "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract")
Source documentation: `Default shared 'N_D' normalizer contract for one Robin coefficient. The normalized coefficient is represented by multiplying the sparse derivative coefficient by the formal symbol 'N_D_inv'. This is not a proof that 'N_D' is nonzero or that a division operation has been interpreted.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3745](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3745).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract_coefficient" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract_coefficient")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3792).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract_normalizerND" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract_normalizerND")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3797](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3797).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract_normalizedCoefficient" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDContract_normalizedCoefficient")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3802](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3802).
:::

:::definition "QuantumBlockEncoding.GHL2025.DerivativeNormalizerNDSourceBound" (lean := "QuantumBlockEncoding.GHL2025.DerivativeNormalizerNDSourceBound")
Source documentation: `Phase-1 source/bound view for the shared 'N_D' normalizer contract. This does not prove the analytic inequality. It only packages the exact coefficient source and the paper normalizer symbol used by the future bound obligation, so 'O_DT^S' and 'Ry_boundary' can point to the same fixed interface.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3815](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3815).
:::

:::definition "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound")
Source documentation: `Default source/bound interface for the paper statement '|D_j^(s)| <= N_D'. The coefficient and obligation are reused from 'derivativeNormalizerNDContract'; the obligation remains false until the coefficient semantics and analytic normalizer bound are formalized.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3833](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3833).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_sourceCoefficient" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_sourceCoefficient")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3847](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3847).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_normalizerND" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_normalizerND")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3852](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3852).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_boundFormula" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_boundFormula")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3857](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3857).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_coefficientBound" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_coefficientBound")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3862](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3862).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_coefficientBound_false" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_coefficientBound_false")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3867](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3867).
:::

:::definition "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix")
Source documentation: `Honest U_indic matrix: controlled-X on the indicator qubit, conditioned on the system register being in the bulk window [K1, K2]. For each basis state |j⟩: - Extract systemVal = bits [1, 1+n) of j - If K1 ≤ systemVal ≤ K2 (bulk row): flip indicator bit - Otherwise (boundary row): identity main.tex:1088-1099 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3880](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3880).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic")
Source documentation: `Gate matrix for U_indic using the honest permutation matrix. Controlled-X on indicator bit at position 1+2n, conditioned on bulk membership. Unitarity proved: indicatorOracleMatrix_is_permutation shows each row and column has exactly one entry equal to 1, so the matrix is a permutation matrix (hence unitary). main.tex:1088-1099 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3898](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3898).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic_dagger" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic_dagger")
Source documentation: `Theorem-facing Hermitian-conjugate slot for 'U_indic'. The indicator permutation is self-inverse, so its dagger is represented by the same matrix. This gate record exists to keep the Fig. 1-term Robin transcript faithful; the active backend product is still the seven-gate list unless a separate theorem rewires it.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3915](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3915).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic_dagger_matrix_eq")
Source documentation: `The theorem-facing 'U_indic^dagger' slot has the same matrix as 'U_indic'. This is only a transcript bridge. It does not insert the dagger slot into the active seven-gate backend product.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3931](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3931).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTMatrix" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTMatrix")
Source documentation: `Honest O_DT^S diagonal matrix: encodes the sparse amplitude data on the diagonal for bulk rows (indicator=1) and acts as identity for boundary rows (indicator=0). For each compound basis state |j⟩: - If indicator bit = 0 (boundary row): diagonal entry = Coeff.rat 1 (identity) - If indicator bit = 1 (bulk row): diagonal entry = robinSparseAmplitudeValue(n, s, i) - Off-diagonal entries are zero. NOTE: The paper's actual O_{D^T}^S (Lemma 3, main.tex:822-849) is a controlled rotation on the ancilla qubit, not a diagonal matrix. This diagonal encoding exercises the amplitude data pathway; the rotation structure is a proof obligation. main.tex:822-849 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3949](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3949).
:::

:::definition "QuantumBlockEncoding.GHL2025.SparseAmplitudeOracleDTPaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.SparseAmplitudeOracleDTPaperRegisters")
Source documentation: `Register values used by the faithful Lemma 3 'O_DT^S' contract. The compound-index convention stores the rotation ancilla in bit 0, the system row in bits '[1, 1+n)', the padded sparse register in bits '[1+n, 1+2n)', and the indicator bit at 'robinIndicatorBitPosition p'. The 'nonAncillaValue' field is 'j >>> 1'; preserving it means that only the ancilla bit may change. Guseynov-Huang-Liu 2025, Lemma 3, arXiv:2506.20478.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3978](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3978).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTPaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTPaperRegisters")
Source documentation: `Extract the Lemma 3 sparse-amplitude oracle registers from a compound basis index. This is a source-contract skeleton for the paper's controlled rotation on the ancilla qubit; it leaves the legacy diagonal data helper available.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:3991](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L3991).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCosHalf" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCosHalf")
Source documentation: `Symbolic cosine half-angle entry for the Lemma 3 O_DT^S rotation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4009](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4009).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTSinHalf" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTSinHalf")
Source documentation: `Symbolic sine half-angle entry for the Lemma 3 O_DT^S rotation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4013](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4013).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerObligation" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerObligation")
Source documentation: `Explicit unresolved source obligation for the symbolic entries in the Lemma 3 'O_DT^S' rotation skeleton. Equation (20) of Guseynov-Huang-Liu 2025 maps '|0>|s>' to an amplitude whose '|0>' component is 'D^(s) / N_D' and whose complementary component is the square-root normalizer term. The Lean symbols 'sparseAmplitudeOracleDTCosHalf row sparse' and 'sparseAmplitudeOracleDTSinHalf row sparse' are only placeholders until this coefficient/normalizer relation and the corresponding two-by-two unitarity identity are formalized.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4028](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4028).
:::

:::definition "QuantumBlockEncoding.GHL2025.SparseAmplitudeOracleDTCoefficientNormalizerContract" (lean := "QuantumBlockEncoding.GHL2025.SparseAmplitudeOracleDTCoefficientNormalizerContract")
Source documentation: `Typed Eq. (20) coefficient-normalizer contract for one 'O_DT^S' rotation block. This binds the symbolic rotation entries to the concrete Robin sparse coefficient data and the paper's 'N_D' normalizer without proving the analytic identities. The three obligations stay false until Lean has a coefficient language with the required division, square-root, absolute-value, and unitarity facts.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4043](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4043).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract")
Source documentation: `Default Eq. (20) coefficient-normalizer contract for a Robin row and global sparse slot. The coefficient is 'robinGlobalSparseAmplitudeValue p.n sparse row'; the rotation entries are the symbols used by 'sparseAmplitudeOracleDTRotationMatrix'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4063](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4063).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient")
Source documentation: `Symbolic stand-in for the Lemma 3 normalized coefficient 'D_j^(s) / N_D'. The factor 'Coeff.symbol "N_D_inv"' records the intended division by 'N_D'. It is not a proof that 'N_D' is nonzero or that the coefficient lies in the unit interval required by Eq. (20); those remain separate obligations.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4098](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4098).
:::

:::definition "QuantumBlockEncoding.GHL2025.SparseAmplitudeOracleDTCoefficientNormalizerProofRoute" (lean := "QuantumBlockEncoding.GHL2025.SparseAmplitudeOracleDTCoefficientNormalizerProofRoute")
Source documentation: `Refined proof route for the 'odts_coeff_normalizer' block. This record separates the typed Eq. (20) data from the analytic obligations: division by 'N_D', the paper's normalizer bound, the absolute-square term, the complementary square root, and the two-by-two unitarity identity. All proof obligations stay false in Phase 1.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4110](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4110).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute")
Source documentation: `Default refined proof route for one 'O_DT^S' Eq. (20) coefficient-normalizer block. The route keeps the construction fixed to the paper's controlled rotation and does not promote the gate-level unitarity claim.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4134](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4134).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_coefficient" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_coefficient")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4158](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4158).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizerND" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizerND")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4163](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4163).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizedCoefficient" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizedCoefficient")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4168](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4168).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sharedND" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sharedND")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4173](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4173).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4185](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4185).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketZeroEntry" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketZeroEntry")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4195).
:::

:::theorem "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketOneEntry" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketOneEntry")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4200](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4200).
:::

:::definition "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTRotationMatrix" (lean := "QuantumBlockEncoding.GHL2025.sparseAmplitudeOracleDTRotationMatrix")
Source documentation: `Faithful Lemma 3 controlled-rotation skeleton for 'O_DT^S'. For columns whose indicator bit is 0, the matrix acts as identity. For columns whose indicator bit is 1, it preserves every non-ancilla bit and applies a symbolic two-by-two rotation on ancilla bit 0. The symbols are indexed by the extracted row and sparse-index values; their connection to the Eq. (20) amplitudes determined by 'robinGlobalSparseAmplitudeValue p.n sparse row / N_D' remains the coefficient-normalizer proof obligation. Guseynov-Huang-Liu 2025, Lemma 3, arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4215](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4215).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_DT_S" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_DT_S")
Source documentation: `Gate matrix for O_DT^S using the faithful controlled-rotation skeleton. The legacy diagonal helper 'sparseAmplitudeOracleDTMatrix' remains available as the coefficient-data path, but the active gate now preserves all non-ancilla bits and rotates bit 0 when the indicator bit is 1. Unitarity and the normalizer-bound trigonometric identity are not yet formally proved. main.tex:822-849 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4240](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4240).
:::

:::definition "QuantumBlockEncoding.GHL2025.BoundaryRotationPaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.BoundaryRotationPaperRegisters")
Source documentation: `Register values used by the faithful 'Ry_boundary' source contract. The compound-index convention is the same one used by the active matrix: ancilla bit 0 is the rotated qubit, bits '[1, 1+n)' contain the Robin row, the high part of the O_D register contains sparse index 's', and the indicator bit determines whether the boundary rotation is active. The 'nonAncillaValue' field is preserved by the controlled rotation. Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Eq. angles for Ry, arXiv:2506.20478.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4259](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4259).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationPaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationPaperRegisters")
Source documentation: `Extract the 'Ry_boundary' register fields from a compound basis index. This is a source-contract skeleton; it does not prove the angle identities or unitarity of the symbolic rotation block.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4272](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4272).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationCosHalf" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationCosHalf")
Source documentation: `Symbolic cosine half-angle entry for the 'Ry_boundary' rotation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4290](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4290).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationSinHalf" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationSinHalf")
Source documentation: `Symbolic sine half-angle entry for the 'Ry_boundary' rotation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4294](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4294).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerObligation" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerObligation")
Source documentation: `Explicit unresolved source obligation for the 'Ry_boundary' angle/normalizer relation. The paper uses angles 'theta_j^s = arccos(D_j^(s) / N_D)' for boundary rows. The Lean symbols 'boundaryRotationCosHalf row sparse' and 'boundaryRotationSinHalf row sparse' are placeholders until the half-angle identities and the two-by-two unitarity relation are formalized.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4306](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4306).
:::

:::definition "QuantumBlockEncoding.GHL2025.BoundaryRotationAngleNormalizerContract" (lean := "QuantumBlockEncoding.GHL2025.BoundaryRotationAngleNormalizerContract")
Source documentation: `Typed angle/normalizer contract for one 'Ry_boundary' rotation block. This binds the symbolic half-angle entries used by 'boundaryRotationMatrix' to the Robin sparse coefficient source and the paper normalizer 'N_D'. It records the exact obligations without asserting the arccos relation, half-angle formulas, control condition, or unitarity.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4320](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4320).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerContract" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerContract")
Source documentation: `Default 'Ry_boundary' angle/normalizer contract for one Robin row and global sparse slot. The coefficient is 'robinGlobalSparseAmplitudeValue p.n sparse row'; the rotation entries are the symbols used by 'boundaryRotationMatrix'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4343](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4343).
:::

:::theorem "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerContract_coefficient" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerContract_coefficient")
Source documentation: `The coefficient source of the 'Ry_boundary' angle contract is definitionally the Robin global sparse-slot amplitude data layer.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4386](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4386).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationNormalizedCoefficient" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationNormalizedCoefficient")
Source documentation: `Symbolic stand-in for the paper argument 'D_j^(s) / N_D'. The factor 'Coeff.symbol "N_D_inv"' is not a proof that 'N_D' is invertible. It only records the intended normalized coefficient while the required division semantics and nonzero normalizer condition remain explicit obligations.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4398](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4398).
:::

:::definition "QuantumBlockEncoding.GHL2025.BoundaryRotationAngleNormalizerProofRoute" (lean := "QuantumBlockEncoding.GHL2025.BoundaryRotationAngleNormalizerProofRoute")
Source documentation: `Refined proof route for the 'ryb_angle_normalizer' block. This record separates the typed data already present in 'BoundaryRotationAngleNormalizerContract' from the missing analytic semantics: division by 'N_D', real arccos, square roots, the paper's normalizer bound, and the resulting two-by-two unitarity identity. All proof obligations stay false in Phase 1.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4411](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4411).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute")
Source documentation: `Default refined proof route for one 'Ry_boundary' angle-normalizer block. The route keeps the construction fixed to the paper formula 'theta_j^s = arccos(D_j^(s) / N_D)'. It does not introduce a replacement angle or promote the gate-level unitarity claim.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4438](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4438).
:::

:::theorem "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_coefficient" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_coefficient")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4467](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4467).
:::

:::theorem "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_arccosArgument" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_arccosArgument")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4472](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4472).
:::

:::theorem "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_sharedND" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_sharedND")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4477](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4477).
:::

:::theorem "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_sourceBound" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationAngleNormalizerProofRoute_sourceBound")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4487](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4487).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_sharedRoutes" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSourceBound_sharedRoutes")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4497](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4497).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue_sharedNormalizerRoutes" (lean := "QuantumBlockEncoding.GHL2025.robinGlobalSparseAmplitudeValue_sharedNormalizerRoutes")
Source documentation: `Bridge showing that the shared 'N_D' route is now sourced from the active global sparse-slot coefficient table. This only wires coefficient data through the existing contracts. It does not prove the analytic division, arccos, half-angle, or unitarity obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4514](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4514).
:::

:::definition "QuantumBlockEncoding.GHL2025.boundaryRotationMatrix" (lean := "QuantumBlockEncoding.GHL2025.boundaryRotationMatrix")
Source documentation: `Honest Ry_boundary matrix: controlled R_y rotation on the ancilla qubit (bit 0), conditioned on the indicator bit being 0 (boundary row). For bulk rows (indicator=1): acts as identity (no rotation). For boundary rows (indicator=0): applies R_y(θ_j^s) on the ancilla qubit, where θ_j^s = arccos(D_j^(s) / N_D) (main.tex:1115-1120, Eq. angles for Ry). The R_y(θ) matrix on the ancilla qubit: M(|0⟩, |0⟩) = cos(θ/2), M(|1⟩, |0⟩) = sin(θ/2) M(|0⟩, |1⟩) = -sin(θ/2), M(|1⟩, |1⟩) = cos(θ/2) Rotation entries are symbolic since the exact trigonometric values involve square roots: cos(θ/2) = √((1 + D/N_D)/2), sin(θ/2) = √((1 - D/N_D)/2). main.tex:1115-1120 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4541](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4541).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_Ry_boundary" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_Ry_boundary")
Source documentation: `Gate matrix for Ry_boundary using the honest controlled rotation matrix. R_y rotation on the ancilla qubit for boundary rows (indicator=0); identity for bulk rows (indicator=1). Unitarity not yet formally proved. main.tex:1115-1120 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4576](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4576).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSharedRoute_flags_false" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSharedRoute_flags_false")
Source documentation: `Guard for the shared 'N_D' Phase-1 route. The source-bound bridges only synchronize the two proof routes. This theorem records that the analytic obligations and the two affected gate unitarity flags still have not been promoted. Guseynov-Huang-Liu 2025, Lemma 3, Eq. (20), and Eq. angles for Ry, arXiv:2506.20478.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4594](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4594).
:::

:::theorem "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags" (lean := "QuantumBlockEncoding.GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags")
Source documentation: `Combined Phase-1 guard for the shared 'N_D' route. This packages the source-bound bridges for 'O_DT^S' and 'Ry_boundary' together with the current false-flag state. It is bookkeeping only: the analytic division, bound, square-root, arccos, half-angle, and unitarity obligations are still unproved.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4626](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4626).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessMatrix" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessMatrix")
Source documentation: `Interim O_D^BS column-map helper, not the faithful Lemma 1 paper oracle. It maps |s⟩|i⟩ → |s⟩|col(s,i)⟩ by replacing the system register bits. Bits outside the system register are preserved. The paper contract |0>^(n-l)|s>^l|i>^n -> |r_si>^n|i>^n is recorded separately in 'defaultBandedSparseAccessPaperContract'; do not use this helper as the unitarity or block-extraction target for the paper oracle. main.tex:784-801 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4679](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4679).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS")
Source documentation: `Gate record for the faithful Lemma 1 O_D^BS paper-image matrix skeleton. The matrix uses 'bandedSparseAccessPaperMatrix', which preserves the row register and writes 'r_si' into the padded sparse-address register. Unitarity, forward correctness, and block extraction remain unproved obligations. Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4702](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4702).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one")
Source documentation: `Active forward 'O_D^BS' gate entry at the finite paper image.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4712](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4712).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_contractDrift_column8_n3" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_contractDrift_column8_n3")
Source documentation: `Concrete contract-drift guard separating the active Lemma 1 paper-image matrix from the legacy sparse-column helper. For the one-term parameters 'n = 3', 'kappa = 7', source column '8' is sent by the paper-image skeleton to row '40'. The active 'O_D^BS' gate therefore has entry '(40, 8) = 1' and no entry at '(4, 8)', while the legacy helper still has its historical row-'4' entry. This is only a regression guard; it does not promote unitarity, cleanup, or block extraction.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4732](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4732).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3")
Source documentation: `Concrete rejected-model collision for the old row-dependent 'O_D^BS' address. For the one-term parameters 'n = 3', 'kappa = 7', boundary row '0' has only three nonzero Robin stencil entries. The old row-dependent address folded sparse index '3' back to the row address, colliding with sparse index '0'. The active global-slot paper image separates these columns; this theorem is retained only as regression memory for the rejected address model.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4754](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4754).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3")
Source documentation: `Concrete regression that the corrected active global-slot image separates the old boundary unused-sparse collision columns. No semantic proof flag is promoted: this only checks the active image entries for the two concrete clean columns.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4780](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4780).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3")
Source documentation: `The old boundary collision columns are both in the faithful global-slot source domain even though one of them is outside the rejected row-dependent nonzero-branch classifier. This is the regression that prevents future lower packets from treating 'bandedSparseAccessPaperValidCleanSource' as the active source predicate.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4805](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4805).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3")
Source documentation: `Encoded sparse value '7' is the first out-of-range slot for the one-term 'kappa = 7' contract. It is clean in the padded O_D register but not in the faithful global-slot source domain.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4820](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4820).
:::

:::definition "QuantumBlockEncoding.GHL2025.robinFunctionValue" (lean := "QuantumBlockEncoding.GHL2025.robinFunctionValue")
Source documentation: `Symbolic function value at grid point j. Returns Coeff.symbol "f_x_j" for each grid index. The paper's O_f (Theorem amplitude-oracle for piece-wise polynomial function, main.tex:870-910) encodes f(x_j)/N_f; the 1/N_f factor is absorbed into the normalizer α = N_D · N_f · κ. main.tex:870-910 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4837](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4837).
:::

:::definition "QuantumBlockEncoding.GHL2025.FunctionOraclePaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.FunctionOraclePaperRegisters")
Source documentation: `Register values used by the paper-level function oracle 'O_f' contract. The compound-index convention stores the system row in bits '[1, 1+n)' and stores the 'm_f' function-oracle workspace immediately above the indicator bit, starting at 'robinIndicatorBitPosition p + 1'. This record is a source-contract skeleton for the paper's clean-workspace equation; it does not assert the amplitude relation or workspace cleanup. Guseynov-Huang-Liu 2025, function-oracle construction, arXiv:2506.20478.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4849](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4849).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOraclePaperRegisters" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperRegisters")
Source documentation: `Extract the system register and the 'm_f' function workspace from a compound basis index for the 'O_f' source contract. The 'nonMFValue' field is the input index with the 'm_f' workspace bits cleared. For clean-workspace columns this is the clean-branch basis index appearing in the paper equation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4864](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4864).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOracleNormalizedValue" (lean := "QuantumBlockEncoding.GHL2025.functionOracleNormalizedValue")
Source documentation: `Symbolic normalized clean-branch amplitude for the paper's function oracle. The reciprocal symbol records the intended factor '1 / N_f' without proving that 'N_f' is nonzero or that the amplitude is bounded.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4885](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4885).
:::

:::definition "QuantumBlockEncoding.GHL2025.FunctionOraclePaperImage" (lean := "QuantumBlockEncoding.GHL2025.FunctionOraclePaperImage")
Source documentation: `Paper-image source contract for one column of the function oracle 'O_f'. The clean branch records the displayed paper component '(f(x_i)/N_f)|0>^mf|i>'. The orthogonal component and all analytic side conditions are tracked as false obligations; this record is not a matrix proof and does not promote the current diagonal helper to a faithful oracle.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4896](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4896).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOraclePaperImage" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage")
Source documentation: `Build the paper-level 'O_f' image contract for one compound basis column. This captures the register-level target '|0>^mf|i> ↦ (f(x_i)/N_f)|0>^mf|i> + |orth_f(i)>' as data and keeps every unproved semantic claim explicit.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4920](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4920).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_inputRegisters_eq" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_inputRegisters_eq")
Source documentation: `Bridge lemma: the 'O_f' paper image uses the shared register extractor.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4961](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4961).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchBasisIndex_eq" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchBasisIndex_eq")
Source documentation: `Bridge lemma: the clean 'O_f' branch clears only the 'm_f' workspace bits.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4967](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4967).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchSystemValue_eq" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchSystemValue_eq")
Source documentation: `Bridge lemma: the clean 'O_f' branch preserves the extracted system value.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4973](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4973).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchWorkspaceValue_eq" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchWorkspaceValue_eq")
Source documentation: `Bridge lemma: the clean 'O_f' branch has zero 'm_f' workspace value.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4979](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4979).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchAmplitude_eq" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanBranchAmplitude_eq")
Source documentation: `Bridge lemma: the clean 'O_f' branch amplitude is the normalized function value at the system value extracted from the same column.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4987](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4987).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanWorkspaceBranch_eq" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperImage_cleanWorkspaceBranch_eq")
Source documentation: `Bridge lemma: the clean-workspace branch flag is inherited from the extractor.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:4993](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L4993).
:::

:::definition "QuantumBlockEncoding.GHL2025.FunctionOracleExternalAmplitudeSourceContract" (lean := "QuantumBlockEncoding.GHL2025.FunctionOracleExternalAmplitudeSourceContract")
Source documentation: `External source transcript for the O_f amplitude-oracle theorem cited by GHL2025. This records the theorem and coordinate-oracle equation used as a source contract for the function oracle. It does not formalize the cited theorem and does not close the analytic facts needed for the Lean 'O_f' contract.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5006](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5006).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOracleExternalAmplitudeSourceContract" (lean := "QuantumBlockEncoding.GHL2025.functionOracleExternalAmplitudeSourceContract")
Source documentation: `Default source transcript for GHL2025's function-oracle dependency. The GHL2025 theorem cites Guseynov--Liu 2024, arXiv:2411.01131, Theorem 5. The QBE status remains obligation-only: this declaration gives later proof packets a typed source anchor, not a proof of the theorem.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5031](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5031).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleExternalAmplitudeSourceContract_sourceAnchor" (lean := "QuantumBlockEncoding.GHL2025.functionOracleExternalAmplitudeSourceContract_sourceAnchor")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5072](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5072).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleExternalAmplitudeSourceContract_flags_false" (lean := "QuantumBlockEncoding.GHL2025.functionOracleExternalAmplitudeSourceContract_flags_false")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5076](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5076).
:::

:::definition "QuantumBlockEncoding.GHL2025.FunctionOracleAmplitudeProofRoute" (lean := "QuantumBlockEncoding.GHL2025.FunctionOracleAmplitudeProofRoute")
Source documentation: `Refined proof route for the 'of_nf_amplitude_route' block. The route ties the paper's coordinate-oracle equation to the current Lean source-contract data: the symbolic function value, the 'N_f' normalizer symbol, the clean-branch amplitude in 'functionOraclePaperImage', and the theorem-level function-oracle obligation. It does not prove that 'N_f' is nonzero, that 'N_f_inv' is an inverse, that the normalizer bound holds, or that the orthogonal component gives a unitary completion.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5098](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5098).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute")
Source documentation: `Default O_f amplitude-route contract for one compound basis column. The route reuses 'functionOraclePaperImage'; it only packages the dependencies needed before any future proof of the clean-branch amplitude or theorem-level 'FunctionOracleContract.amplitudeCorrect' field.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5125](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5125).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_sourceAnchor" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_sourceAnchor")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5150](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5150).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_sourceFunctionValue" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_sourceFunctionValue")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5155](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5155).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_normalizerNf" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_normalizerNf")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5160](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5160).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_normalizedAmplitude" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_normalizedAmplitude")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5165](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5165).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_paperImage" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_paperImage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5170](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5170).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_obligations_reuse_paperImage" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_obligations_reuse_paperImage")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5180](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5180).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_externalSourceContract" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_externalSourceContract")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5192](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5192).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_flags_false" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_flags_false")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5208](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5208).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags" (lean := "QuantumBlockEncoding.GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags")
Source documentation: `Combined Phase-1 guard for the 'O_f' external-source route. The bridge to the cited amplitude-oracle theorem and the false analytic flags are packaged together so later proof packets cannot use the source transcript as a proof of 'O_f' amplitude correctness or unitarity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5226](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5226).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOracleOrthogonalEntry" (lean := "QuantumBlockEncoding.GHL2025.functionOracleOrthogonalEntry")
Source documentation: `Symbolic matrix entry for the unresolved orthogonal component of 'O_f'. The paper only fixes the clean 'm_f' branch amplitude 'f(x_i) / N_f'; the remaining orthogonal completion is a unitarity obligation. This symbol records one placeholder entry for that unresolved completion without proving orthogonality, normalizer bounds, or unitarity.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5269](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5269).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix")
Source documentation: `Faithful Phase 1 matrix skeleton for the paper-level function oracle 'O_f'. For each clean-workspace input column, the clean 'm_f' branch entry is the normalized amplitude recorded by 'functionOraclePaperImage', namely 'f(x_i) / N_f' represented as 'functionOracleNormalizedValue'. Other clean-workspace output rows are zero, matching the paper statement that the unresolved component is orthogonal to the clean workspace branch. Non-clean-workspace rows carry symbolic completion entries. For non-clean input columns, the paper does not fix a branch equation, so this skeleton leaves all entries symbolic. The symbolic completion does not prove amplitude correctness, the 'N_f' bound, orthogonality, or unitarity; those obligations remain false in 'functionOraclePaperImage' and the gate record.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5289](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5289).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix_cleanBranch_entry" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix_cleanBranch_entry")
Source documentation: `The 'O_f' paper matrix exposes the clean branch amplitude for clean input columns.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5304](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5304).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix_cleanWorkspace_offBranch_zero" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix_cleanWorkspace_offBranch_zero")
Source documentation: `Other clean-workspace rows have zero 'O_f' orthogonal-completion entry.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5314](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5314).
:::

:::theorem "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix_nonCleanInput_entry" (lean := "QuantumBlockEncoding.GHL2025.functionOraclePaperMatrix_nonCleanInput_entry")
Source documentation: `Non-clean input columns are left in the symbolic 'O_f' completion branch.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5324](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5324).
:::

:::definition "QuantumBlockEncoding.GHL2025.functionOracleMatrix" (lean := "QuantumBlockEncoding.GHL2025.functionOracleMatrix")
Source documentation: `Helper-only O_f diagonal matrix: records function values f(x_j) on the diagonal. For each compound basis state |j⟩, extracts the system register value i and sets the diagonal entry to 'robinFunctionValue n i' = Coeff.symbol "f_x_i". All off-diagonal entries are zero. The entry depends only on the system register (grid point index), not on the sparse index. The paper's O_f (Theorem amplitude-oracle for piece-wise polynomial function, main.tex:870-910) encodes f(x_j)/N_f via amplitude oracle. The 1/N_f normalization is absorbed into the block-encoding normalizer α = N_D · N_f · κ. This diagonal matrix is not the paper image; the paper-level clean branch and orthogonal-component obligations are recorded by 'functionOraclePaperImage', and the active gate keeps 'unitary.proved := false'. main.tex:870-910 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5349](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5349).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_f" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_f")
Source documentation: `Gate matrix for 'O_f' using the faithful paper-image matrix skeleton. The active matrix now exposes the clean 'm_f' branch amplitude from 'functionOraclePaperImage'. The legacy diagonal helper 'functionOracleMatrix' remains available only as a function-value data check. Unitarity, amplitude correctness, the 'N_f' bound, and the orthogonal completion are still unproved. Guseynov-Huang-Liu 2025, Theorem amplitude-oracle for piece-wise polynomial function and Fig. 1-term Robin, arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5368](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5368).
:::

:::definition "QuantumBlockEncoding.GHL2025.swapOracleMatrix" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix")
Source documentation: `Honest SWAP matrix: permutation matrix swapping the system register (n qubits at bits [1, 1+n)) with the O_D^BS register (n qubits at bits [1+n, 1+2n)). For each basis state |j⟩: - Extract block1 = bits [1, 1+n) of j (system register value) - Extract block2 = bits [1+n, 1+2n) of j (O_D^BS register value) - diff = block1 XOR block2 - Swapped index = j XOR (diff <<< 1) XOR (diff <<< (1+n)) When block1 = block2 the SWAP is the identity. All bits outside the two n-qubit blocks (ancilla bit 0, indicator bit 1+2n, mf MSBs) are preserved. The SWAP image-level proof is now promoted: 'swapOracleImage' is proved self-inverse, 'swapOracleMatrix' is proved a finite permutation matrix, and 'oneTermRobinGate_SWAP.unitary.proved = true'. figure:1_term_ROBIN, main.tex:1140 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5394](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5394).
:::

:::definition "QuantumBlockEncoding.GHL2025.swapOracleImage" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage")
Source documentation: `Image function for the SWAP oracle: swaps two n-qubit register blocks. For each basis state j, swaps block1 (bits [1,1+n)) with block2 (bits [1+n,1+2n)) by XORing with the block difference shifted to each block position. main.tex:1140 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5410](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5410).
:::

:::definition "QuantumBlockEncoding.GHL2025.swapOracleDiff" (lean := "QuantumBlockEncoding.GHL2025.swapOracleDiff")
Source documentation: `The n-bit XOR difference between the two register blocks exchanged by SWAP. This is the reusable proof-DAG interface for the SWAP image route: preservation of this value after one SWAP is the local ingredient for self-inverse and later finite-domain permutation proofs.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5425](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5425).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_eq_xor_diff" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_eq_xor_diff")
Source documentation: `The SWAP image is the source index XORed by the same difference in both blocks.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5433](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5433).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleMatrix_eq_image" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix_eq_image")
Source documentation: `swapOracleMatrix entry equals image function check.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5440](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5440).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_SWAP" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_SWAP")
Source documentation: `Gate matrix for SWAP using the honest permutation matrix. Swaps system register (bits [1,n+1)) with O_D^BS register (bits [n+1,2n+1)). Unitarity is backed by the proof-DAG permutation bridge below: 'swapOracleMatrix_is_permutation'. main.tex:1140 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5452](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5452).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessDaggerMatrix" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessDaggerMatrix")
Source documentation: `Transpose-style matrix for O_D^BS, sharing the forward sparse-access image map. For each i: compute image(i) using the forward mapping, then check if j = image(i). This is the matrix transpose of bandedSparseAccessMatrix. The inverse/unitarity proof is blocked until the forward boundary column-map contract is reconciled. main.tex:1148 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5467](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5467).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_dagger" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_dagger")
Source documentation: `Gate matrix for '(O_D^BS)^†' using the transpose-style paper-image matrix. This is paired with 'bandedSparseAccessPaperMatrix'; it does not prove that the transpose is a true inverse on the relevant post-SWAP states. figure:1_term_ROBIN and Lemma 1, arXiv:2506.20478.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5489](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5489).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one")
Source documentation: `Active '(O_D^BS)^†' gate entry paired with the finite forward image.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5499](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5499).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage")
Source documentation: `Post-SWAP dagger entry from an explicitly supplied paper-image preimage. The hypothesis 'hpre' is the whole inverse-on-range input for this lemma: it does not prove that such a 'pre' exists, that it is unique, or that the dagger cleans the padded sparse-index register. The post-SWAP relation is recorded by 'hpost' for the cleanup proof-DAG interface, but the matrix entry itself is just the active transpose-style paper-image entry.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5518](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5518).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessPostSwapCleanup" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessPostSwapCleanup")
Source documentation: `Proof-carrying interface for a supplied post-SWAP cleanup preimage. The fields intentionally include the hypotheses that are not yet derived: 'postSwap', 'preimage', 'preCleanInput', and 'preAddressBound'. The record only packages consequences of those inputs: the active dagger entry and executable register-cleanup checks for the chosen preimage. Existence, uniqueness, and the paper-level 'daggerCleanup' obligation remain open.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5539](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5539).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_preimage" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_preimage")
Source documentation: `Build the post-SWAP cleanup witness from an explicitly supplied preimage. This is the fixed inverse-on-range interface for the next cleanup proof: it does not construct the preimage and does not promote any semantic proof flag.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5569](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5569).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_imageFin_entrySafety" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_imageFin_entrySafety")
Source documentation: `Reusable image witness for the active Lemma 1 'O_D^BS' gate pair. This packages the forward entry, transpose-style dagger entry, row roundtrip, written-address roundtrip, and no-spill Boolean under the explicit n-bit address hypothesis. It is not an injectivity, inverse uniqueness, cleanup, or unitarity proof.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5610](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5610).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety")
Source documentation: `Global-source specialization of the active Lemma 1 'O_D^BS' entry witness. For a finite column in the faithful source domain, the global-slot source predicate supplies the clean padded input and sparse-slot bound, while the '2 <= n' parameter-family hypothesis supplies the n-bit address bound. The result packages the finite image index and paired forward/dagger entries, but does not prove injectivity, cleanup, or unitarity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5644](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5644).
:::

:::definition "QuantumBlockEncoding.GHL2025.oneTermRobinGateMatrixPlaceholders" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGateMatrixPlaceholders")
Source documentation: `List of all 7 gate matrix placeholders for the one-term Robin circuit, in the same order as 'oneTermRobinCircuit'. figure:1_term_ROBIN -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5690](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5690).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinPlaceholdersMatch" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinPlaceholdersMatch")
Source documentation: `The placeholder gate matrices match the circuit gate labels. This is trivially true because the placeholders were constructed with matching gate constructors. figure:1_term_ROBIN -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5706](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5706).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGateMatrixPlaceholders_gateList" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGateMatrixPlaceholders_gateList")
Source documentation: `The active matrix placeholder list uses the same gate order as Fig. 1-term Robin and 'oneTermRobinCircuit'. This is a structural guard only: it prevents a later proof packet from keeping similar-looking proof flags while changing the circuit order.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5722](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5722).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags")
Source documentation: `The active seven-gate matrix list keeps only the locally certified indicator and SWAP gates marked as proved. This is a Phase 1 guard for Fig. 1-term Robin. It records the current gate-level proof flags without promoting the paper-oracle obligations for 'O_DT^S', 'Ry_boundary', 'O_D^BS', 'O_f', or '(O_D^BS)^dagger'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5741](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5741).
:::

:::definition "QuantumBlockEncoding.GHL2025.indicatorOracleImage" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage")
Source documentation: `Indicator oracle image function: for each basis state j, computes the image by XORing the indicator bit at position indPos when the system register value is in the bulk window [K1, K2]. This is a self-inverse permutation. main.tex:1088-1099 -`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5757](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5757).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_eq_image" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_eq_image")
Source documentation: `The indicator oracle matrix entry is 1 exactly when i = indicatorOracleImage j. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5769](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5769).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_self_inverse_n1" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_self_inverse_n1")
Source documentation: `Self-inverse property for n=1: applying indicatorOracleImage twice returns the original value for all j in Fin domain (128 elements). Checked by native_decide over the finite Fin type. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5780](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5780).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_self_inverse_n3" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_self_inverse_n3")
Source documentation: `Self-inverse property for n=3: applying indicatorOracleImage twice returns the original value for all j in Fin domain (8192 elements). Checked by native_decide over the finite Fin type. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5794](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5794).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_injective_n1" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_injective_n1")
Source documentation: `Injectivity for n=1: derived from self-inverse property. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5806](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5806).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_injective_n3" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_injective_n3")
Source documentation: `Injectivity for n=3: derived from self-inverse property. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5822](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5822).
:::

:::theorem "QuantumBlockEncoding.GHL2025.shiftLeft_land_mask_eq_zero" (lean := "QuantumBlockEncoding.GHL2025.shiftLeft_land_mask_eq_zero")
Source documentation: `Cycle 12 helper: (b <<< pos) &&& ((1 <<< n) - 1) = 0 when pos >= n, because b <<< pos has all zeros in bits [0, pos) >= [0, n).`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5839](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5839).
:::

:::theorem "QuantumBlockEncoding.GHL2025.xor_shift_preserve_low" (lean := "QuantumBlockEncoding.GHL2025.xor_shift_preserve_low")
Source documentation: `Cycle 12 helper: XOR with a value shifted left by 'pos' preserves the low 'n' bits when 'pos >= n'. Uses AND-XOR distributivity and the zero mask lemma.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5856](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5856).
:::

:::theorem "QuantumBlockEncoding.GHL2025.xor_shift_preserve_shift_low" (lean := "QuantumBlockEncoding.GHL2025.xor_shift_preserve_shift_low")
Source documentation: `Cycle 12 helper: XOR with a high-shifted value preserves low bits after right-shifting. ((x ^^^ (b <<< pos)) >>> 1) &&& ((1 <<< n) - 1) = (x >>> 1) &&& ((1 <<< n) - 1) when pos >= 1 + n.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5867](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5867).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleDiff_lt_two_pow" (lean := "QuantumBlockEncoding.GHL2025.swapOracleDiff_lt_two_pow")
Source documentation: `SWAP proof-DAG helper: the XOR difference between the two n-bit blocks is itself an n-bit value. main.tex:1140 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5892](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5892).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleDiff_shiftRight_eq_zero" (lean := "QuantumBlockEncoding.GHL2025.swapOracleDiff_shiftRight_eq_zero")
Source documentation: `SWAP proof-DAG helper: right-shifting the n-bit block difference by n removes it. main.tex:1140 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5910](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5910).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleDiff_shiftLeft_mask_eq_zero" (lean := "QuantumBlockEncoding.GHL2025.swapOracleDiff_shiftLeft_mask_eq_zero")
Source documentation: `SWAP proof-DAG helper: shifting the block difference into the high block leaves zero in the low n-bit mask. main.tex:1140 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5925](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5925).
:::

:::theorem "QuantumBlockEncoding.GHL2025.shiftLeft_lt_two_pow_of_lt" (lean := "QuantumBlockEncoding.GHL2025.shiftLeft_lt_two_pow_of_lt")
Source documentation: `Shifting a bounded value into a register block keeps it inside the total basis width.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5938](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5938).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_lt_qubitDim" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_lt_qubitDim")
Source documentation: `SWAP proof-DAG range block: the image of the register-block SWAP stays inside the same full finite basis. This is only a range lemma; the finite permutation bridge is proved separately by 'swapOracleMatrix_is_permutation'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5956](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5956).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_block1_eq_block2" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_block1_eq_block2")
Source documentation: `SWAP proof-DAG block: after 'swapOracleImage', the low n-bit register equals the old high n-bit register. This is the first register-level bit-slice lemma needed for the eventual SWAP self-inverse/permutation proof. main.tex:1140 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:5987](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L5987).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_block2_eq_block1" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_block2_eq_block1")
Source documentation: `SWAP proof-DAG block: after 'swapOracleImage', the high n-bit register equals the old low n-bit register. This is the symmetric register equation paired with 'swapOracleImage_block1_eq_block2'; it is still only a bit-slice block, not a SWAP unitarity proof. main.tex:1140 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6015](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6015).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleDiff_preserved" (lean := "QuantumBlockEncoding.GHL2025.swapOracleDiff_preserved")
Source documentation: `SWAP proof-DAG block: the XOR difference between the two exchanged registers is preserved by one SWAP application. This uses only the two register block equations and is independent of any gate unitarity flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6049](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6049).
:::

:::theorem "QuantumBlockEncoding.GHL2025.xor_two_shifted_masks_cancel" (lean := "QuantumBlockEncoding.GHL2025.xor_two_shifted_masks_cancel")
Source documentation: `XORing the same two shifted masks twice cancels them bitwise.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6058](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6058).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_self_inverse" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_self_inverse")
Source documentation: `SWAP proof-DAG block: the image function is self-inverse. This is the arithmetic image fact reused by the finite permutation-matrix bridge.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6075](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6075).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_injective" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_injective")
Source documentation: `SWAP proof-DAG block: injectivity of the image function, derived from the self-inverse arithmetic block without opening the bit-slice proof again.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6086](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6086).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleImage_bijective" (lean := "QuantumBlockEncoding.GHL2025.swapOracleImage_bijective")
Source documentation: `SWAP proof-DAG block: bijectivity of 'swapOracleImage' on the finite full Hilbert-space basis. The finite map uses 'swapOracleImage_lt_qubitDim' for the 'Fin' constructor and 'swapOracleImage_self_inverse' for both injectivity and surjectivity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6100](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6100).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleMatrix_col_has_one" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix_col_has_one")
Source documentation: `For each SWAP matrix column, the row indexed by 'swapOracleImage' contains the unique '1' entry.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6123](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6123).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleMatrix_col_unique" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix_col_unique")
Source documentation: `For each SWAP matrix column, any '1' entry must occur at the row indexed by 'swapOracleImage'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6135](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6135).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleMatrix_row_has_one" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix_row_has_one")
Source documentation: `Every SWAP matrix row has a '1' entry, by finite surjectivity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6145](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6145).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleMatrix_row_unique" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix_row_unique")
Source documentation: `Every SWAP matrix row has a unique '1' entry, by finite injectivity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6160](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6160).
:::

:::theorem "QuantumBlockEncoding.GHL2025.swapOracleMatrix_is_permutation" (lean := "QuantumBlockEncoding.GHL2025.swapOracleMatrix_is_permutation")
Source documentation: `SWAP matrix is a finite permutation matrix: every row and column has exactly one entry equal to '1'. This closes the SWAP gate-level matrix-semantics bridge while leaving the paper-specific O_D^BS, O_f, LCU, and block-extraction obligations unchanged.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6178](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6178).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwap_rowValue_eq_address" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwap_rowValue_eq_address")
Source documentation: `After the active Lemma 1 paper image and the SWAP gate, the system-row register contains the paper address 'r_si'. This is a post-SWAP register equation under the same n-bit address hypothesis used by the finite image bridge; it does not construct a dagger preimage or promote cleanup.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6205](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6205).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue")
Source documentation: `After the active Lemma 1 paper image and the SWAP gate, the O_D register contains the original row value. This is the second post-SWAP register equation needed before inverse-on-range cleanup search.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6222](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6222).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt")
Source documentation: `After the active paper image and SWAP, the post-SWAP column is still a finite basis index whenever the source column is finite and the written paper address is n-bit. This does not prove inverse-on-range or cleanup.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6238](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6238).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister")
Source documentation: `Replace the 'O_D^BS' n-bit register of a compound index while preserving the low ancilla/system block and all high-tail bits. This is the local splice used to build a post-SWAP cleanup preimage candidate. It does not assert that the chosen 'odValue' is the correct reverse address.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6258](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6258).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_eq_splice" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_eq_splice")
Source documentation: `The paper image is the O_D-register splice with the computed paper address.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6267](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6267).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_lowBlock_lt_highBase_of_odValue_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_lowBlock_lt_highBase_of_odValue_lt")
Source documentation: `The spliced low-and-O_D block fits below the high-tail boundary for n-bit O_D values.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6275](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6275).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_mod_lowBase" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_mod_lowBase")
Source documentation: `Splicing an O_D value preserves the low ancilla-and-row block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6313](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6313).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_div_lowBase_mod_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_div_lowBase_mod_eq")
Source documentation: `Splicing an n-bit O_D value exposes that value when the O_D register is extracted.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6348](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6348).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_rowValue_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_rowValue_eq")
Source documentation: `Splicing preserves the row field.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6391](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6391).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_odRegisterValue_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_odRegisterValue_eq")
Source documentation: `Splicing an n-bit value into the O_D block makes that value the extracted O_D register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6411](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6411).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_div_highBase_eq_of_odValue_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_div_highBase_eq_of_odValue_lt")
Source documentation: `Splicing an n-bit O_D value preserves all bits above the O_D register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6423](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6423).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_lt_qubitDim_of_odValue_lt")
Source documentation: `Splicing an n-bit O_D value into a finite compound basis index preserves the full finite-basis range. This is the range counterpart of the splice register equations and does not assert that the chosen O_D value is semantically correct.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6455](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6455).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_splice_of_odValue_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_splice_of_odValue_lt")
Source documentation: `Replacing the O_D block twice is the same as keeping the second replacement.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6499](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6499).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_self" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperSpliceODRegister_self")
Source documentation: `Reconstructing an index from its low, O_D, and high blocks gives the same index.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6514](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6514).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue")
Source documentation: `Clean 'O_D^BS' register value whose padded-low part is zero and sparse part is 'sparseValue'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6556](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6556).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue_paddedZero_eq_zero" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue_paddedZero_eq_zero")
Source documentation: `The clean O_D value has zeroes in the padded low slice.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6561](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6561).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue_lt_two_pow_of_sparse_lt" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue_lt_two_pow_of_sparse_lt")
Source documentation: `A clean sparse value fits in the n-bit O_D register when the sparse width fits in n.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6570](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6570).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue_sparseIndex_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanODValue_sparseIndex_eq")
Source documentation: `Extracting the sparse slice from a clean O_D value recovers the sparse value.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6585](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6585).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanInput_odRegisterValue_eq_cleanODValue" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperCleanInput_odRegisterValue_eq_cleanODValue")
Source documentation: `On a clean Lemma 1 source column, the extracted O_D register is exactly the canonical clean sparse-register value for its sparse slot. This is the bit-slice reconstruction block needed to lift address injectivity to full paper-image injectivity. It only uses the executable clean-input predicate; it does not prove any semantic cleanup flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6605](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6605).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_injective_on_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperImage_injective_on_globalSlotSource")
Source documentation: `The corrected active 'O_D^BS' paper image is injective on the faithful global-slot clean source domain. This is a finite-register proof-DAG block, not a semantic-flag promotion. It combines low-prefix preservation, high-tail preservation, the written-address roundtrip, same-row global-address injectivity, and clean O_D register reconstruction. The obligation records for inverse-on-range, dagger cleanup, and unitarity remain false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6679](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6679).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapReverseSparse_lt_two_pow")
Source documentation: `The reverse sparse index used by the post-SWAP cleanup candidate fits in the three-bit sparse register for the one-term Robin parameter family.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6806](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6806).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapCleanODValue_lt_two_pow")
Source documentation: `The clean O_D register value spliced into the post-SWAP preimage candidate is n-bit for the one-term Robin parameter family.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6821](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6821).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate")
Source documentation: `Candidate clean preimage for the column reached by 'O_D^BS', SWAP, and then '(O_D^BS)^dagger'. The candidate keeps the post-SWAP row and high-tail bits, and replaces the 'O_D^BS' register by a clean padded register whose sparse field is the inverse global slot for the original source slot. The separate Boolean audit below checks whether this candidate is actually a paper-image preimage.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6849](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6849).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks")
Source documentation: `Executable audit for the post-SWAP preimage candidate. It checks three local facts: the candidate maps by the active paper-image skeleton to the post-SWAP column, the candidate is in the clean padded domain, and the candidate address is n-bit. Even when this Boolean is true for a finite parameter scan, the paper-level dagger cleanup and unitarity flags remain unproved.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6866](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6866).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource")
Source documentation: `The post-SWAP preimage candidate passes the executable image, clean-domain, and address-range checks for clean one-term Robin source columns. The assumptions keep the current Phase 1 contract explicit: the source column is in the finite basis, the source padded register is clean, and the one-term family uses a three-bit sparse register ('kappa = 7', 'clog2 kappa = 3'). This does not prove uniqueness, dagger cleanup, unitarity, or block extraction.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6883](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6883).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource")
Source documentation: `The clean post-SWAP preimage candidate is a finite basis index for finite clean one-term Robin source columns. This only discharges the 'Fin' constructor premise for the conditional cleanup witness; uniqueness and semantic cleanup remain open.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:6990](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L6990).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate")
Source documentation: `Instantiate the conditional post-SWAP cleanup witness with the clean-source preimage candidate. The finite 'post' and 'pre' range facts remain explicit hypotheses. This wrapper converts the accepted Boolean candidate audit into the supplied preimage equality, clean-domain proof, and n-bit address bound required by 'bandedSparseAccessPostSwapCleanup_of_preimage'. It does not prove finite range, uniqueness, semantic dagger cleanup, or unitarity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7039](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7039).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange")
Source documentation: `Instantiate the clean-source post-SWAP cleanup witness without caller-supplied finite-range premises. The theorem only supplies the 'Fin' range proofs for the already conditional candidate witness; it does not prove uniqueness, dagger cleanup, or either O_D^BS unitarity flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7080](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7080).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange")
Source documentation: `Feed the row-dependent valid-clean-source predicate into the existing post-SWAP cleanup candidate wrapper. The predicate 'bandedSparseAccessPaperValidCleanSource' is only a Phase 1 source-domain classifier. This theorem records that it supplies the clean padded-register hypothesis required by the cleanup candidate. It does not prove source-domain completeness, unused-branch unitary extension, preimage uniqueness, semantic dagger cleanup, or either O_D^BS unitarity flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7128](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7128).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange")
Source documentation: `Feed the faithful global-slot source predicate into the existing post-SWAP cleanup candidate wrapper. This is the active-source analogue of the row-dependent valid-clean-source bridge. It only extracts the padded clean-input fact from 'bandedSparseAccessPaperGlobalSlotSource' and reuses the conditional cleanup candidate. It does not prove preimage uniqueness, semantic dagger cleanup, unitarity, LCU correctness, or block extraction.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7170](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7170).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource")
Source documentation: `The post-SWAP preimage candidate audit is available on the active global-slot source domain. This is the global-source wrapper around the existing clean-source arithmetic block. It proves only the executable candidate check; inverse uniqueness, semantic dagger cleanup, and unitarity remain separate obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7210](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7210).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource")
Source documentation: `The global-source post-SWAP preimage candidate is a finite basis index. This theorem only names the range premise needed by the conditional cleanup witness. It does not prove that the candidate is unique or that the dagger cleans every in-range image.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7229](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7229).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_sparseIndex_eq")
Source documentation: `The post-SWAP preimage candidate has the reverse sparse slot in its extracted clean O_D register. This names the splice/sparse-slice calculation used by the cleanup-candidate audit so the unique-preimage route can reuse it instead of repeating the bit-level proof.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7251](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7251).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_globalSlotSource_of_globalSlotSource")
Source documentation: `The post-SWAP preimage candidate is itself an active global-slot source. The proof combines the executable candidate audit for clean input with the named reverse-slot sparse-slice lemma above. It still does not promote the inverse-on-range, uniqueness, dagger-cleanup, or unitarity obligation flags.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7296](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7296).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource")
Source documentation: `Uniqueness of the active global-slot clean preimage for the post-SWAP target. Any active global-source column that maps by the corrected paper image to the post-SWAP target must be the named reverse-slot preimage candidate. This is a finite basis-index lemma for the dagger-cleanup route; semantic obligation records remain false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7344](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7344).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessGlobalSlotInverseOnRangeContract" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessGlobalSlotInverseOnRangeContract")
Source documentation: `Proof-obligation interface for the active global-slot inverse-on-range route. The record fixes the source predicate, image function, post-SWAP target, and candidate preimage used by the corrected 'O_D^BS' route. The executable 'candidateChecks' field can be proved from 'bandedSparseAccessPaperGlobalSlotSource' by 'bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource'. The semantic inverse, uniqueness, injectivity, cleanup, and unitary-extension fields remain false in Phase 1.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7403](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7403).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract")
Source documentation: `Default global-source inverse-on-range contract for one 'O_D^BS' source column. This records the fixed route for future proof work without promoting any semantic flag or changing the active forward/dagger matrices.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7427).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_flags_false")
Source documentation: `The global-source inverse-on-range contract is obligation-only in Phase 1.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7469](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7469).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource")
Source documentation: `Global-source columns feed the fixed inverse-on-range interface and satisfy the executable candidate audit. The final fields remain false: this theorem does not assert uniqueness, injectivity, semantic dagger cleanup, or unitarity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7490](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7490).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge")
Source documentation: `Record-level bridge from the compiled post-SWAP unique-preimage theorem to the global-slot inverse-on-range contract. This theorem reflects the finite basis-index evidence in the contract fields: any active global-source preimage of the contract's post-SWAP target is the contract's candidate preimage. It deliberately keeps every semantic obligation flag in the contract false; dagger cleanup and unitarity remain separate Phase 1 obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7525](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7525).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge")
Source documentation: `Bridge the global-slot inverse-on-range contract to the concrete post-SWAP dagger cleanup witness. This theorem constructs the finite post-SWAP column and the named preimage candidate from the active global-source route, then reuses 'BandedSparseAccessPostSwapCleanup' to expose the transpose-style dagger entry and executable register checks. It deliberately keeps the semantic 'daggerCleanup' and 'unitaryExtension' flags false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7592](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7592).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap")
Source documentation: `Reviewed cleanup-contract map for the active global-slot 'O_D^BS' route. This wrapper is intentionally non-promoting. It combines the compiled post-SWAP cleanup witness with the record-level unique-preimage bridge, so later cleanup work can consume one theorem exposing the contract target, candidate preimage, active-source uniqueness, and transpose-style dagger entry. The semantic inverse, uniqueness, injectivity, cleanup, and unitary-extension obligation flags remain false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7665](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7665).
:::

:::theorem "QuantumBlockEncoding.GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge" (lean := "QuantumBlockEncoding.GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge")
Source documentation: `Default-paper-contract cleanup-route bridge for the active global-slot 'O_D^BS' route. This theorem ties the compiled cleanup-contract map back to 'defaultBandedSparseAccessPaperContract p'. It exposes the post-SWAP cleanup witness, active-source uniqueness, and transpose-style dagger entry while recording that the paper-contract cleanup and unitary-extension flags, and the two active 'O_D^BS' gate-unitarity flags, remain false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7759](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7759).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero")
Source documentation: `Off-candidate dagger entries are zero on the active global-slot source domain. For the fixed post-SWAP target in the global-slot inverse-on-range contract, any other active global-source preimage whose index is not the named candidate cannot have a transpose-style '(O_D^BS)^†' entry into that target. This is a matrix-entry bridge only: it does not promote dagger cleanup or unitary flags.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7804](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7804).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup")
Source documentation: `Restricted active-domain dagger-column cleanup for the global-slot route. For the contract post-SWAP target, the named candidate has dagger entry '1', and every other active global-source row has dagger entry '0'. This is only a column statement over 'bandedSparseAccessPaperGlobalSlotSource'; it does not promote semantic cleanup, unitarity, circuit-unitarity, or block-extraction obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7867](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7867).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator")
Source documentation: `Indicator form of the restricted active-domain dagger column. This is the same active-source-only column statement as 'bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup', rewritten as one if-then-else formula. It does not promote inverse, cleanup, unitarity, circuit-unitarity, or block-extraction obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:7956](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L7956).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessCleanupScope" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessCleanupScope")
Source documentation: `Allowed scopes for the next 'O_D^BS' cleanup theorem packet. This is planning data for Phase 1 faithful-paper work. Selecting a scope here does not prove cleanup, full-domain injectivity, or unitary extension.`.

Kind: inductive. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8043](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8043).
:::

:::definition "QuantumBlockEncoding.GHL2025.BandedSparseAccessCleanupScopeDecision" (lean := "QuantumBlockEncoding.GHL2025.BandedSparseAccessCleanupScopeDecision")
Source documentation: `Non-promoting decision for the next 'O_D^BS' cleanup theorem domain. The current compiled matrix-entry theorem is restricted to active global-source rows. Full clean-domain cleanup still needs a reversible image rule for every clean unused sparse branch, and full-space cleanup/unitarity still needs a separate reversible-extension argument. This record keeps that boundary machine-checkable before any lower proof packet tries to promote 'daggerCleanup'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8059](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8059).
:::

:::definition "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision")
Source documentation: `Default cleanup-scope decision after the restricted dagger-column indicator. The selected theorem domain is active global-source only. The surrounding obligation records are copied from the existing paper and full-domain contracts so their 'proved = false' status stays synchronized with the actual contracts.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8079](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8079).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision_activeGlobalSource" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision_activeGlobalSource")
Source documentation: `The cleanup-scope decision selects the active global-source theorem and keeps all broader cleanup/unitarity obligations closed to proof-flag promotion.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8100](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8100).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard")
Source documentation: `The cleanup-scope decision does not accept the prior PDE sparse-access transcript as a full-space unitary-extension proof. This is a guard for the next Phase 1 source-contract packet: the prior paper's equation is recorded as a source anchor, while its resource proof and any Robin-specific reversible-extension use remain unproved in QBE.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8131](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8131).
:::

:::theorem "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked" (lean := "QuantumBlockEncoding.GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked")
Source documentation: `The cleanup-scope decision keeps the full clean-domain image-rule slot blocked. This guard ties the active-global-source scope choice to the unused-branch source decision and the full clean-domain wrapper. It is not a cleanup or unitarity theorem: the missing image rule remains 'none', proof search remains disabled, and every full clean-domain semantic field stays false.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8161](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8161).
:::

:::theorem "QuantumBlockEncoding.GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3" (lean := "QuantumBlockEncoding.GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3")
Source documentation: `Concrete boundary-source regression for the default paper-contract cleanup route. The historical source column '48' is outside the rejected row-dependent valid source predicate, but it is an active global-slot source for Lemma 1. This instance routes that column through the default cleanup bridge without promoting any 'O_D^BS' semantic proof flag.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8200](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8200).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinIndicatorBitPosition_ge" (lean := "QuantumBlockEncoding.GHL2025.robinIndicatorBitPosition_ge")
Source documentation: `Cycle 12: robinIndicatorBitPosition = 1 + 2*p.n, hence >= 1 + p.n.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8249](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8249).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_systemVal_preserved" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_systemVal_preserved")
Source documentation: `Cycle 12: The system register value is preserved by indicatorOracleImage. XORing with a bit at position indPos = 1 + 2n does not affect bits [1, 1+n). main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8259](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8259).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_isBulk_preserved" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_isBulk_preserved")
Source documentation: `Cycle 12: The isBulk predicate gives the same result for j and indicatorOracleImage p j, because isBulk only depends on the system register value, which is preserved. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8273](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8273).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_self_inverse" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_self_inverse")
Source documentation: `Cycle 12: General self-inverse property for indicatorOracleImage. Applying the indicator oracle image twice returns the original value for all j, because the indicator bit is XORed twice (and isBulk is preserved). main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8288](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8288).
:::

:::theorem "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge" (lean := "QuantumBlockEncoding.GHL2025.oneTermRobinGate_U_indic_dagger_selfInverseBridge")
Source documentation: `Source-facing bridge for the explicit 'U_indic^dagger' transcript slot. The dagger slot uses the same matrix as 'U_indic' because the underlying indicator image is self-inverse. This theorem records the bridge used by the conversion window; it does not change the active backend gate list.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8303](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8303).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_injective" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_injective")
Source documentation: `Cycle 12: General injectivity for indicatorOracleImage, derived from self-inverse. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8314](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8314).
:::

:::theorem "QuantumBlockEncoding.GHL2025.robinIndicatorBitPosition_lt_totalQubits" (lean := "QuantumBlockEncoding.GHL2025.robinIndicatorBitPosition_lt_totalQubits")
Source documentation: `Cycle 12: robinIndicatorBitPosition is strictly below oneTermRobinTotalQubits. indPos = 1 + 2n < 2n + clog2 n + clog2 fp + 5 = totalQubits, since clog2 ≥ 0 and 5 > 1.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8325](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8325).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_lt" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_lt")
Source documentation: `Cycle 12: indicatorOracleImage preserves the qubitDim bound. When j < 2^totalQubits, the image is also < 2^totalQubits, because the XOR operand is either 0 or a single bit at position indPos < totalQubits.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8336](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8336).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleImage_bijective" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleImage_bijective")
Source documentation: `Cycle 12: Bijectivity of indicatorOracleImage on the Fin domain. A self-inverse function on a finite type is bijective: injective by cancellation, surjective because image(image(j)) = j. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8354](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8354).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_col_has_one" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_col_has_one")
Source documentation: `Cycle 12: For each column j, there is exactly one row i with M[i][j] = 1, namely i = ⟨indicatorOracleImage p j.val, ...⟩. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8377](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8377).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_col_unique" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_col_unique")
Source documentation: `Cycle 12: For each column j, any row i with M[i][j] = 1 must equal ⟨indicatorOracleImage p j.val, ...⟩, so the 1-entry is unique per column. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8389](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8389).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_row_has_one" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_row_has_one")
Source documentation: `Cycle 12: For each row i, there exists a column j with M[i][j] = 1, from surjectivity of indicatorOracleImage. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8402](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8402).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_row_unique" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_row_unique")
Source documentation: `Cycle 12: For each row i, the column j with M[i][j] = 1 is unique, from injectivity of indicatorOracleImage. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8420](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8420).
:::

:::theorem "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_is_permutation" (lean := "QuantumBlockEncoding.GHL2025.indicatorOracleMatrix_is_permutation")
Source documentation: `Cycle 12: indicatorOracleMatrix is a permutation matrix: each row has exactly one entry equal to 1, and each column has exactly one entry equal to 1. This follows from indicatorOracleImage being a bijection on the Fin domain. main.tex:1088-1099 -`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/GHL2025.lean:8436](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/GHL2025.lean#L8436).
:::
