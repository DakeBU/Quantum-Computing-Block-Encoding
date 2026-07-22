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

#doc (Manual) "Declaration catalog: Cubic" =>
%%%
file := "catalog-cubic"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

# QuantumBlockEncoding/CubicStatePreparation.lean

269 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.CubicStatePreparation.taskId" (lean := "QuantumBlockEncoding.CubicStatePreparation.taskId")
Source documentation: `Task identifier used by the retrieval and verifier ledgers.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:25](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L25).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.requestedEpsilon" (lean := "QuantumBlockEncoding.CubicStatePreparation.requestedEpsilon")
Source documentation: `User-requested error tolerance '1e-10'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:28](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L28).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.gridPoint" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridPoint")
Source documentation: `Grid point 'x_j = j / 2^n'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:31](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L31).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude")
Source documentation: `Cubic amplitude 'f(x_j) = x_j^3'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:35](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L35).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.cubicOperator" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicOperator")
Source documentation: `The rank-one operator 'O_n = |v_n><0^n|'. In column-vector convention this maps the input basis state '|0^n>' to the unnormalized vector with entries '(j / 2^n)^3', and maps every other input basis state to zero.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:43](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L43).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq")
Source documentation: `Exact rational squared norm of the unnormalized target vector. The analytic normalizer is its square root; this rational quantity is the cheap diagnostic used before any approximate rotation-synthesis route is accepted.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:51](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L51).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.conservativeNormalizer" (lean := "QuantumBlockEncoding.CubicStatePreparation.conservativeNormalizer")
Source documentation: `A conservative rational normalizer. It is not intended to be optimal; it is a stable placeholder until the approximate synthesis backend proves a sharper normalizer and error bound.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L60).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.cubicTarget" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicTarget")
Source documentation: `Operator-first target record used by the ABEIS harness.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:64](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L64).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.defaultRequiredCost" (lean := "QuantumBlockEncoding.CubicStatePreparation.defaultRequiredCost")
Source documentation: `Resource floor used for the first Scenario 2 run.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:77](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L77).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.defaultPolicy" (lean := "QuantumBlockEncoding.CubicStatePreparation.defaultPolicy")
Source documentation: `Adaptive search policy for the cubic benchmark. The zero gate/depth fields in 'defaultRequiredCost' deliberately mean "discover a concrete candidate and then rank it"; the active search is expected to relax from exact to approximate construction after a small exact-search stall window.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:89](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L89).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicDefaultPrecision" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicDefaultPrecision")
Source documentation: `First arithmetic-route precision seed for Scenario 2.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:100](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L100).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicLayout" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicLayout")
Source documentation: `Register layout for the first arithmetic-transduction candidate route. The single signal qubit is the clean block selector. The pure workspace keeps an address copy, reversible square/cube work registers, and fixed-point precision workspace. This is a candidate interface only; it does not certify the arithmetic or rotation subroutines.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:110](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L110).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicCircuit" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicCircuit")
Source documentation: `Oracle-level transcript for the scalable cubic route. The clean branch is intended to compute 'j / 2^n', reversibly form the cubic fixed-point amplitude, apply one amplitude-transduction rotation, and uncompute the arithmetic workspace. Each label remains a semantic proof obligation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:122](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L122).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicResource" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicResource")
Source documentation: `Local resource count for the unexpanded oracle-level transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:133](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L133).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicNormalizer" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicNormalizer")
Source documentation: `Normalizer used by the first arithmetic-transduction route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:137](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L137).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicCost" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicCost")
Source documentation: `Candidate score extracted from the arithmetic-route layout and transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:141](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L141).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicResourceTuple" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicResourceTuple")
Source documentation: `Resource tuple in QBE candidate-population order.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:147](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L147).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicResource_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicResource_eq")
Source documentation: `The oracle-level transcript has seven unresolved calls and depth seven.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:155](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L155).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicLayout_auxiliaryQubits")
Source documentation: `The first arithmetic route records one signal qubit plus pure workspace.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:161](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L161).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicClaim" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticCubicClaim")
Source documentation: `Human-facing construction claim for the first scalable route. This claim is an unproved candidate record, not a certified block encoding.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:170](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L170).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicLayout" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicLayout")
Source documentation: `Rank-one wrapper layout for the arithmetic cubic route. The extra pure workspace is reserved for a zero-input filter and row-generation wrapper. This is still an oracle-level interface: it repairs the register shape of the candidate transcript, but it does not certify the wrapper semantics.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:192](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L192).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCircuit" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCircuit")
Source documentation: `Rank-one candidate transcript around the arithmetic middle block. The first two calls are the missing wrapper from 'CUBIC-CAND-SHAPE-001': reject nonzero input columns from the clean branch, then generate the output row register on the zero-input branch. The final call is a placeholder cleanup for the zero-input filter. The row-generation step is intentionally not uncomputed, because the output row is the system output of the rank-one operator.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:206](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L206).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResource" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResource")
Source documentation: `Oracle-level resource count for the rank-one wrapped transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:214](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L214).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicNormalizer" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicNormalizer")
Source documentation: `Normalizer used by the rank-one wrapped arithmetic route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:218](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L218).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCost" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCost")
Source documentation: `Candidate score for the rank-one wrapped arithmetic route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:222](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L222).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResourceTuple" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResourceTuple")
Source documentation: `Resource tuple in QBE candidate-population order for the wrapped route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:228](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L228).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResource_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResource_eq")
Source documentation: `The rank-one wrapper adds three oracle-level calls to the middle block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:237](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L237).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicLayout_auxiliaryQubits")
Source documentation: `Auxiliary qubits for the wrapped route include the zero-test workspace.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:243](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L243).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResourceTuple_n2_default" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicResourceTuple_n2_default")
Source documentation: `Default small diagnostic score for the wrapped route at 'n = 2', 'p = 40'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:249](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L249).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicClaim" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicClaim")
Source documentation: `Human-facing construction claim for the rank-one wrapped scalable route. This still records obligations, not a verified block-encoding certificate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:258](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L258).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicWorkspace" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicWorkspace")
Source documentation: `Workspace seed for the Hadamard-counting mutation. This is an oracle-level interface budget for the reversible cube/comparator workspace. It is not a gate-level implementation of multiplication.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:280](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L280).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicLayout" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicLayout")
Source documentation: `Register layout for the exact Hadamard-counting candidate. The signal qubit is the reject flag. Pure ancillas are the nonzero-input flag, the 'R,T' path registers of total width '4*n', and the reversible cube/comparator workspace. Nonzero input columns set the reject signal before the 'nz' cleanup, so the clean projection cannot leak identity entries.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:291](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L291).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCircuit" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCircuit")
Source documentation: `Oracle-level transcript for the Hadamard-counting route. The row XOR is not uncomputed, because it writes the output system row for the rank-one operator. The separate nonzero-column reject signal is applied before the 'nz' cleanup, so nonzero input columns keep a clean-projection rejection witness. The Hadamard layers and reversible arithmetic are still semantic obligations at this interface tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:305](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L305).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCircuit_rejectSignalRepair" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCircuit_rejectSignalRepair")
Source documentation: `The repaired transcript records a separate nonzero-column reject signal before the final 'nz' cleanup. This is the compiled surface for 'CUBIC-HCOUNT-REJECT-REPAIR-001'; semantic clean-block correctness remains a future proof leaf.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:322](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L322).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResource" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResource")
Source documentation: `Oracle-level resource count for the Hadamard-counting route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:336](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L336).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicNormalizer" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicNormalizer")
Source documentation: `Normalizer used by the Hadamard-counting route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:340](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L340).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCost" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCost")
Source documentation: `Candidate score for the Hadamard-counting route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:344](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L344).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResourceTuple" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResourceTuple")
Source documentation: `Resource tuple in QBE candidate-population order.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:350](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L350).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResource_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResource_eq")
Source documentation: `The Hadamard-counting interface has eight unresolved oracle-level calls.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:358](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L358).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicLayout_auxiliaryQubits")
Source documentation: `Auxiliary qubits for the counting route include reject, 'nz', path, and workspace registers.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:364](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L364).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResourceTuple_n2" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicResourceTuple_n2")
Source documentation: `Default small diagnostic score for the counting route at 'n = 2'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:370](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L370).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicClaim" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicClaim")
Source documentation: `Human-facing construction claim for the Hadamard-counting exact route. This is an unproved candidate record, not a certified block encoding.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:378](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L378).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hardModeUpperAgentSchedule" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeUpperAgentSchedule")
Source documentation: `Hard Mode panel escalation schedule. The four entries are the planned parallel-agent counts for levels 0 through 3. Upper agents should only move to the next level after the active proof leaf has stalled and the reviewer has confirmed that the blocker is not just stale memory.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:401](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L401).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hardModeMiddleAgentSchedule" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeMiddleAgentSchedule")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:403](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L403).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hardModeLowerAgentSchedule" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeLowerAgentSchedule")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:405](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L405).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hardModeExactStallWindow" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeExactStallWindow")
Source documentation: `Number of consecutive cycles without a closed leaf before the first escalation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:408](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L408).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hardModeConstructionStallWindow" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeConstructionStallWindow")
Source documentation: `Number of consecutive cycles without an improving certified or finite candidate before the next Hard Mode level is considered.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:414](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L414).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hardModeLevelCycleBudget" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeLevelCycleBudget")
Source documentation: `Per-level cycle budgets before the upper panel must explicitly review progress.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:417](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L417).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.relaxedEpsilonLadder" (lean := "QuantumBlockEncoding.CubicStatePreparation.relaxedEpsilonLadder")
Source documentation: `Scenario 2 epsilon ladder. The first entry is the user-requested tolerance. Later entries are relaxed exploratory waypoints used only if the exact or requested-epsilon search stalls; a relaxed waypoint is not a substitute for a certificate at 'requestedEpsilon'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:425](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L425).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.relaxedEpsilonLadder_startsWithRequested" (lean := "QuantumBlockEncoding.CubicStatePreparation.relaxedEpsilonLadder_startsWithRequested")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:428](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L428).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hardModeSchedules_have_four_levels" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeSchedules_have_four_levels")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:432](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L432).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hardModeLowerAgentSchedule_final" (lean := "QuantumBlockEncoding.CubicStatePreparation.hardModeLowerAgentSchedule_final")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:439](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L439).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.initialExpectedPhase" (lean := "QuantumBlockEncoding.CubicStatePreparation.initialExpectedPhase")
Source documentation: `Current expected phase. This is a planning declaration, not a proof of impossibility: it records that exact finite gate synthesis should not consume the full budget before approximate arithmetic/state-preparation search starts.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:448](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L448).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridSize_pos" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridSize_pos")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:451](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L451).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicOperator_first_column" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicOperator_first_column")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:454](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L454).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicOperator_only_first_column" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicOperator_only_first_column")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:458](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L458).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.rankOneCleanBlockContract" (lean := "QuantumBlockEncoding.CubicStatePreparation.rankOneCleanBlockContract")
Source documentation: `Entrywise clean-block contract for a rank-one cubic candidate. The first field states the scaled clean first column. The second field states that all other input columns vanish in the clean block. This is a semantic obligation for a future unitary/circuit proof, not a proof that the current oracle labels already realize the contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:471](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L471).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract")
Source documentation: `Candidate-specific clean-block contract for the repaired rank-one route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:478](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L478).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq")
Source documentation: `The rank-one clean-block contract is exactly the target matrix, entry by entry, after multiplying by its normalizer.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:486](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L486).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq")
Source documentation: `Candidate-specific bridge from the repaired wrapper's clean-block contract to the fixed cubic target.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:506](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L506).
:::

:::definition "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCleanBlockContract" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCleanBlockContract")
Source documentation: `Candidate-specific clean-block contract for the Hadamard-counting route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:515](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L515).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCleanBlockContract_pointwise_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubicCleanBlockContract_pointwise_eq")
Source documentation: `Candidate-specific bridge from the Hadamard-counting clean-block contract to the fixed cubic target.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:523](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L523).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.rat_cube_sq_eq_sixth" (lean := "QuantumBlockEncoding.CubicStatePreparation.rat_cube_sq_eq_sixth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:531](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L531).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude_sq_eq_gridPoint_sixth" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude_sq_eq_gridPoint_sixth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:538](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L538).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_sixthPowerFold" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_sixthPowerFold")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:543](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L543).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridSize_rat_ne_zero" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridSize_rat_ne_zero")
Source documentation: `The rational grid dimension is nonzero, for denominator side conditions.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:550](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L550).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridSize_rat_pos" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridSize_rat_pos")
Source documentation: `The rational grid dimension is positive.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:555](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L555).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.rat_div_cube_div_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.rat_div_cube_div_eq")
Source documentation: `Core rational normalization for the Hadamard-counting path ratio.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:560](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L560).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude_div_conservativeNormalizer_eq" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude_div_conservativeNormalizer_eq")
Source documentation: `Arithmetic bridge for the Hadamard-counting path formula. After scaling by 'alpha = conservativeNormalizer n = gridSize n', the candidate clean-block entry 'j^3 / gridSize^4' recovers the cubic target amplitude.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:571](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L571).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridSize_three_mul_eq_cube" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridSize_three_mul_eq_cube")
Source documentation: `Path-register capacity identity for the Hadamard-counting route.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:579](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L579).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridSize_four_mul_eq_fourth" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridSize_four_mul_eq_fourth")
Source documentation: `Four-register path-space identity for the Hadamard-counting denominator.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:585](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L585).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_thresholdCountP_finRange" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_thresholdCountP_finRange")
Source documentation: `Reusable threshold count over 'List.finRange'. If the threshold 'k' fits in an 'm'-element register, exactly 'k' entries of 'List.finRange m' have value strictly below 'k'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L596).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_thresholdFilterLength" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_thresholdFilterLength")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:625](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L625).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_threshold_le_pathCapacity" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_threshold_le_pathCapacity")
Source documentation: `The cubic threshold for row 'j' fits in the '3*n'-qubit path register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:632](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L632).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_thresholdPathCount" (lean := "QuantumBlockEncoding.CubicStatePreparation.hadamardCountingCubic_thresholdPathCount")
Source documentation: `Symbolic accepted-path count for the Hadamard-counting threshold register. For fixed output row 'j', the '3*n'-qubit threshold register contributes exactly 'j.val ^ 3' accepted values.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:645](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L645).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridPoint_nonneg" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridPoint_nonneg")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:653](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L653).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridPoint_lt_one" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridPoint_lt_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:662](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L662).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridPoint_le_one" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridPoint_le_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:669](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L669).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.rat_pow_le_one_of_nonneg_le_one" (lean := "QuantumBlockEncoding.CubicStatePreparation.rat_pow_le_one_of_nonneg_le_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:673](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L673).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude_sq_le_one" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude_sq_le_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:687](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L687).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.foldl_add_le_add_length" (lean := "QuantumBlockEncoding.CubicStatePreparation.foldl_add_le_add_length")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:693](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L693).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_gridSize" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_gridSize")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:719](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L719).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.gridSize_rat_le_sq" (lean := "QuantumBlockEncoding.CubicStatePreparation.gridSize_rat_le_sq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:731](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L731).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_conservativeNormalizer_sq" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_conservativeNormalizer_sq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:743](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L743).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_arithmeticCubicNormalizer_sq" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_arithmeticCubicNormalizer_sq")
Source documentation: `Candidate-specific normalizer bridge for the first arithmetic route. This does not certify the candidate unitary; it only records that the route's current choice 'alpha = arithmeticCubicNormalizer n' inherits the compiled conservative norm bound.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:754](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L754).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_hadamardCountingCubicNormalizer_sq" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_le_hadamardCountingCubicNormalizer_sq")
Source documentation: `Candidate-specific normalizer bridge for the Hadamard-counting route. This does not certify the Hadamard-sandwich semantics; it only records that the route's normalizer inherits the compiled conservative norm bound.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:764](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L764).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_n1" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_n1")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:769](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L769).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_n2" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_n2")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:773](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L773).
:::

:::theorem "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_n3" (lean := "QuantumBlockEncoding.CubicStatePreparation.cubicNormSq_n3")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:777](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L777).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.taskId" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.taskId")
Source documentation: `Task identifier used by the retrieval and verifier ledgers.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:786](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L786).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalOperator" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalOperator")
Source documentation: `The diagonal cubic oracle target 'D_n[row,col] = (row/2^n)^3' if 'row=col', else zero.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:789](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L789).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.exactNormalizer" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.exactNormalizer")
Source documentation: `Exact normalizer for the diagonal target at the primitive amplitude-oracle tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:795](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L795).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalTarget" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalTarget")
Source documentation: `Operator-first target record for the diagonal cubic oracle.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:798](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L798).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalOperator" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalOperator")
Source documentation: `Hinted linear diagonal target 'O_0[row,col] = row/2^n' if 'row=col', else zero. This is the input operator for the task-local QSVT consumer route. It is only the target matrix; a block-encoding circuit for this matrix is a separate proof obligation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:819](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L819).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalTarget" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalTarget")
Source documentation: `Operator-first target record for the hinted linear diagonal input 'O_0'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:825](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L825).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCleanBlockContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCleanBlockContract")
Source documentation: `Clean-block contract for the hinted linear diagonal input target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:840](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L840).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCleanBlockContract_pointwise_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCleanBlockContract_pointwise_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:846](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L846).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCleanBlock_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCleanBlock_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:853](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L853).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalExactCleanBlockFromPointwise" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalExactCleanBlockFromPointwise")
Source documentation: `Package a supplied clean-block equality for the hinted linear diagonal target as an 'ExactCleanBlock' payload. This is semantic glue only. The caller still owns the unitary proof, cleanup proof, concrete circuit, and resource tuple for the matrix 'U'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:867](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L867).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalExactCleanBlockFromPointwise_clean_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalExactCleanBlockFromPointwise_clean_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:881](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L881).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalInputBEContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalInputBEContract")
Source documentation: `Interface for a concrete block encoding of the hinted linear diagonal input. This names the fields a backend must supply before the exact clean-block payload can be used as a real input certificate. It is not itself a backend: the cleanup and resource propositions must describe the chosen circuit family.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:904](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L904).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalInputBEContract.exactPayload" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalInputBEContract.exactPayload")
Source documentation: `Extract the reusable exact clean-block payload from a concrete linear-diagonal input contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:926](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L926).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalInputBEContract.clean_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalInputBEContract.clean_eq_target")
Source documentation: `The extracted clean block equals the hinted linear diagonal target.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:932](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L932).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.householderZero" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householderZero")
Source documentation: `Clean basis index for the 8-dimensional rational Householder signal block.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:944](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L944).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.dot8" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.dot8")
Source documentation: `Explicit rational dot product for the 8-dimensional Householder support leaf.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:947](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L947).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.householder8E0Minus" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householder8E0Minus")
Source documentation: `Vector 'e_0 - v' used in the rational Householder reflection.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:952](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L952).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.householder8" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householder8")
Source documentation: `Rational 8-by-8 Householder block used by the hinted 'O_0' backend route. The later backend still has to supply rational unit-vector completions for the grid values and prove orthogonality of this block family.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:961](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L961).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.householder8E0Minus_normSq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householder8E0Minus_normSq")
Source documentation: `Norm identity for 'e_0 - v' under the rational unit-vector hypothesis.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:968](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L968).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.householder8E0Minus_normSq_ne_zero" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householder8E0Minus_normSq_ne_zero")
Source documentation: `The Householder denominator is nonzero when the clean coordinate is not one.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:977](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L977).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.householder8_clean_entry" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householder8_clean_entry")
Source documentation: `Active leaf 'HINT-HOUSEHOLDER8-CLEAN-ENTRY': the clean entry of the rational Householder block is the first coordinate of the supplied unit vector.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:989](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L989).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.householder8_isRationalOrthogonal" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.householder8_isRationalOrthogonal")
Source documentation: `Active leaf 'HINT-HOUSEHOLDER8-ORTHO': the rational 8-dimensional Householder block is orthogonal whenever the input vector has 'dot8 v v = 1' and does not equal the clean basis vector.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1132](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1132).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8SystemIndex" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8SystemIndex")
Source documentation: `System component for the task-local 'ancilla × system' direct-sum matrix.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1146](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1146).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8AncillaIndex" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8AncillaIndex")
Source documentation: `Ancilla component for the task-local 'ancilla × system' direct-sum matrix.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1151](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1151).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8Embed" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8Embed")
Source documentation: `Clean embedding for the controlled Householder direct sum.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1160](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1160).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum")
Source documentation: `Task-local controlled direct sum of supplied Householder blocks over system branches.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1165](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1165).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8_branchNontrivial_of_clean" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8_branchNontrivial_of_clean")
Source documentation: `Grid branches for the linear diagonal input never have clean Householder coordinate equal to one.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1268](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1268).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_clean_entry" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_clean_entry")
Source documentation: `Active leaf 'HINT-CONTROLLED-DIRECT-SUM': the clean block of the controlled Householder direct sum is the hinted linear diagonal operator.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1286](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1286).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_columnInner_eq_identity_of_system_ne" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_columnInner_eq_identity_of_system_ne")
Source documentation: `Column-inner bridge for the controlled Householder direct sum in the cross-branch case. This is a support leaf for 'HINT-CONTROLLED-DIRECT-SUM-ORTHO': if two columns belong to different system branches, every path contribution through the block-diagonal direct sum vanishes, so the column inner product agrees with the off-diagonal identity entry.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1360](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1360).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_columnInner_eq_branch" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_columnInner_eq_branch")
Source documentation: `Support leaf 'CDS-COL-FOLD': inside one decoded system branch, the column inner product of the controlled direct sum is the column inner product of that branch's Householder block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1799](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1799).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_rowInner_eq_branch" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_rowInner_eq_branch")
Source documentation: `Support leaf 'CDS-ROW-FOLD': inside one decoded system branch, the row inner product of the controlled direct sum is the row inner product of that branch's Householder block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1918](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1918).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_rowInner_eq_identity_of_system_ne" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_rowInner_eq_identity_of_system_ne")
Source documentation: `Row-inner bridge for the controlled Householder direct sum in the cross-branch case. This completes the branch split needed by 'controlledHouseholder8DirectSum_isRationalOrthogonal': if two rows belong to different decoded system branches, no summation path can hit both blocks.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:1972](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L1972).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_isRationalOrthogonal" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_isRationalOrthogonal")
Source documentation: `Active leaf 'HINT-CONTROLLED-DIRECT-SUM-ORTHO': branchwise rational orthogonality for the controlled direct sum of supplied 8-dimensional Householder blocks.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2012](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2012).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalRationalCompletion" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalRationalCompletion")
Source documentation: `Branch-vector completion contract for the rational Householder backend of the hinted linear diagonal input 'O_0'. This predicate records only the supplied vector family needed by the compiled Householder direct-sum support. Existence for every grid point remains blocked on the cited four-squares obligation.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2061](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2061).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalFourSquareBranchVector" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalFourSquareBranchVector")
Source documentation: `Branch vector obtained from a four-square completion of the residual '(2^n)^2 - j^2'. The first coordinate is the grid value 'j / 2^n'; the next four coordinates carry the rationalized square witnesses.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2074](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2074).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalFourSquareBranchVector_clean" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalFourSquareBranchVector_clean")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2084](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2084).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalFourSquareBranchVector_unit" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalFourSquareBranchVector_unit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2091](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2091).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_of_fourSquareWitnesses" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_of_fourSquareWitnesses")
Source documentation: `Adapter from explicit four-square witnesses to the rational-completion predicate. This is the local consumer of the still-external 'Nat.sum_four_squares' dependency; it does not prove that the witnesses exist.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2114](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2114).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_exists" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_exists")
Source documentation: `Every dyadic grid value has an unconditional rational unit-vector completion. The only number-theoretic ingredient is Lagrange's four-square theorem applied to 'gridSize n ^ 2 - j.val ^ 2'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2134](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2134).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_branchData" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_branchData")
Source documentation: `Adapter leaf for 'HINT-O0-RATIONAL-COMPLETION': a rational-completion witness also supplies the nontrivial clean-coordinate side condition needed by the Householder block.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2156](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2156).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_backendSupport" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalRationalCompletion_backendSupport")
Source documentation: `A rational-completion witness supplies the clean-block equality and rational orthogonality facts for the controlled Householder direct sum. This still does not package a complete 'LinearDiagonalInputBEContract': cleanup integration, normalizer/resource fields, and a concrete existence theorem are separate proof obligations.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2176](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2176).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderCircuit" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderCircuit")
Source documentation: `Oracle-label circuit for the proved rational Householder realization of 'O_0'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2198](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2198).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderResource" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderResource")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2201](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2201).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderResource_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderResource_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2204](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2204).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract")
Source documentation: `Unconditional exact matrix-level block encoding of the hinted input 'O_0'. Unlike the earlier interface-only payload, this certificate contains the concrete controlled Householder matrix, its rational orthogonality theorem, the clean-block theorem, the exact normalizer, and an auditable oracle-label resource equality.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2217](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2217).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_clean_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_clean_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2248](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2248).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete")
Source documentation: `Root certificate for the hinted input operator 'O_0'. This theorem exposes all matrix-level facts needed by a downstream polynomial consumer in one place, so the harness does not reopen the four-square, Householder, cleanup, normalizer, or resource leaves after they have compiled.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2261](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2261).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator")
Source documentation: `Supplied diagonal matrix for the first Scenario 2 approximate route. The function 'q' is only a proposed rational diagonal value. Approximation to the cubic target and the operator-norm bridge remain separate obligations.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2284](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2284).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ratAbs" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratAbs")
Source documentation: `Task-local rational absolute value used before a project norm API exists.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2289](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2289).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.IsDiagonalRatMatrix" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.IsDiagonalRatMatrix")
Source documentation: `Project-local rational matrices whose off-diagonal entries are zero.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2292](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2292).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.DiagonalRatOperatorNormBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.DiagonalRatOperatorNormBridge")
Source documentation: `Typed contract for the missing rational-matrix operator-norm bridge. This structure is deliberately conditional: it does not assert that the bridge is already available in this repository. A future Mathlib-backed proof or a human-accepted external contract must supply this record before an approximate block-encoding certificate may consume the norm bound.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2303](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2303).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ratSquaredEuclideanNorm" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratSquaredEuclideanNorm")
Source documentation: `Squared Euclidean norm on project-local finite rational vectors.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2314](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2314).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ratMatrixErrorAction" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratMatrixErrorAction")
Source documentation: `Action of the matrix error 'A - B' on a finite rational vector.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2318](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2318).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ratEuclideanOperatorNormErrorAtMost" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratEuclideanOperatorNormErrorAtMost")
Source documentation: `Non-vacuous squared Euclidean induced operator-norm error semantics. For nonnegative 'epsilon', this states '||(A-B)v||₂² ≤ ||epsilon v||₂²' for every rational vector 'v'. Squared norms avoid introducing square roots while retaining the finite-dimensional Euclidean operator-norm statement.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2331](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2331).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.ratMatrixErrorAction_eq_diagonal" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratMatrixErrorAction_eq_diagonal")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2453](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2453).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.ratAbs_nonneg" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratAbs_nonneg")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2468](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2468).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_eq_ratAbs_mul_self" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_eq_ratAbs_mul_self")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2472](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2472).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_nonneg" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_nonneg")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2477](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2477).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_le_of_abs_le" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_le_of_abs_le")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2481](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2481).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_vector_le_of_abs_le" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rat_mul_self_vector_le_of_abs_le")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2499](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2499).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ratEuclideanDiagonalOperatorNormBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratEuclideanDiagonalOperatorNormBridge")
Source documentation: `Concrete proof that diagonal entrywise bounds imply the squared Euclidean bound.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2509](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2509).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.ratEuclideanOperatorNormErrorAtMost_not_vacuous" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ratEuclideanOperatorNormErrorAtMost_not_vacuous")
Source documentation: `The local Euclidean error predicate is observably non-vacuous.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2525](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2525).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_isDiagonal" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_isDiagonal")
Source documentation: `The supplied approximate diagonal matrix has zero off-diagonal entries.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2539](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2539).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalOperator_isDiagonal" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalOperator_isDiagonal")
Source documentation: `The exact cubic diagonal target has zero off-diagonal entries.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2546](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2546).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalEntrywiseErrorAtMost" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalEntrywiseErrorAtMost")
Source documentation: `Entrywise scalar-error predicate for the Scenario 2 approximate diagonal route. This is strictly weaker than the open operator-norm bridge: it says only that each supplied diagonal value 'q j' is close to the target cubic amplitude.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2558](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2558).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_entrywise_error" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_entrywise_error")
Source documentation: `Local entrywise bridge for 'APPROX-DIAG-NORM': diagonal scalar errors transfer to every matrix entry of the supplied diagonal operator. This does not prove an operator-norm bound; it is the reusable finite-matrix side of the still-open diagonal norm obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2570](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2570).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_operatorNorm_error_of_contract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_operatorNorm_error_of_contract")
Source documentation: `Conditional adapter from the compiled diagonal entrywise theorem to the task-local operator-norm contract. This theorem is the narrow QBE-side consumer promised by the proof DAG. It does not close 'DIAGONAL-ENTRYWISE-ERROR-OPNORM' unconditionally; the supplied 'bridge' remains the explicit external/classical obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2597](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2597).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_operatorNorm_error" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.approxDiagonalOperator_operatorNorm_error")
Source documentation: `Unconditional local Euclidean operator-norm bound for the supplied diagonal approximation. This closes the former external bridge gap using the concrete finite rational semantics above.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2619](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2619).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.rationalCircleBranchVector" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rationalCircleBranchVector")
Source documentation: `Two-coordinate rational unit-circle branch vector for the approximate controlled-Householder route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2635](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2635).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.rationalCircleBranchVector_clean" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rationalCircleBranchVector_clean")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2641](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2641).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.rationalCircleBranchVector_unit" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.rationalCircleBranchVector_unit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2645](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2645).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_clean_entry_of_branchValue" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.controlledHouseholder8DirectSum_clean_entry_of_branchValue")
Source documentation: `Approximate-route support leaf 'APPROX-CDS-CLEAN': if each controlled Householder branch has clean coordinate 'q j', then the clean block is the supplied diagonal matrix 'diag(q)'. This is not an approximate certificate. It proves only the local clean-block shape for supplied branch vectors.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2661](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2661).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalFourSquareBranchVector" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalFourSquareBranchVector")
Source documentation: `Rational branch vector whose clean coordinate is '(j / 2^n)^3'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2709](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2709).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalFourSquareBranchVector_clean" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalFourSquareBranchVector_clean")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2719](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2719).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalFourSquareBranchVector_unit" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalFourSquareBranchVector_unit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2728](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2728).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.CubicDiagonalRationalCompletion" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.CubicDiagonalRationalCompletion")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2746](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2746).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_of_fourSquareWitnesses" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_of_fourSquareWitnesses")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2752](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2752).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_exists" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_exists")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2767](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2767).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicAmplitude_lt_one" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicAmplitude_lt_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2784](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2784).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_backendSupport" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_backendSupport")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2800](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2800).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.CubicDiagonalExactBEContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.CubicDiagonalExactBEContract")
Source documentation: `Strong exact certificate for the cubic target, including orthogonality.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2828](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2828).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2838).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_clean_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_clean_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2867](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2867).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete")
Source documentation: `Unconditional exact root certificate for the cubic diagonal operator. The conjunction deliberately includes the unitary predicate, clean-block target, normalizer, and resource equality; a clean-block-only arithmetic wrapper is not sufficient to close an operator block-encoding task.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:2879](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L2879).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonal_cube_eq_cubicDiagonalOperator" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonal_cube_eq_cubicDiagonalOperator")
Source documentation: `Target-identification leaf for the hinted route: the project-local matrix cube of 'O_0' is the cubic diagonal target 'D_n'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3001](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3001).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCubicProductCertificate" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCubicProductCertificate")
Source documentation: `The compiled non-QSVT polynomial consumer for the human hint. It reuses the exact 'O_0' clean-block payload three times through the library's product card.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3022](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3022).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCubicProductCertificate_target_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCubicProductCertificate_target_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3030](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3030).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCubicProductCertificate_clean_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalCubicProductCertificate_clean_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3040](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3040).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.cubicQSVTPolynomial" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicQSVTPolynomial")
Source documentation: `The polynomial selected by the human-hinted QSVT route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3050](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3050).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicQSVTPolynomial_gridPoint_abs_le_one" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicQSVTPolynomial_gridPoint_abs_le_one")
Source documentation: `The cubic QSVT polynomial is bounded on every spectral value used by 'O_0'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3053](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3053).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTLocalSideConditions" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTLocalSideConditions")
Source documentation: `Locally checkable side conditions for the cubic polynomial on the 'O_0' spectrum.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3064](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3064).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.cubicQSVTLocalSideConditions" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicQSVTLocalSideConditions")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3073](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3073).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTExternalSemantics" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTExternalSemantics")
Source documentation: `Single external boundary for the hinted route. The supplier must provide a certified 'O_0' block encoding and the transformed clean block. This interface replaces unconstrained QSVT proof search: all project-local leaves are compiled, while phase synthesis and the QSVT semantic theorem remain one explicit dependency.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3091](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3091).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTExternalSemantics.output_eq_cubic_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTExternalSemantics.output_eq_cubic_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3112](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3112).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTExternalSemantics.consumerContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.CubicQSVTExternalSemantics.consumerContract")
Source documentation: `Instantiate the generic consumer boundary without reopening QSVT search.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3120](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3120).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleLayout" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleLayout")
Source documentation: `One signal qubit and no pure workspace at the oracle-label tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3138](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3138).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleCircuit" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleCircuit")
Source documentation: `Oracle-level exact diagonal amplitude transcript.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3144](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3144).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResource" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResource")
Source documentation: `Resource of the oracle-label diagonal candidate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3148](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3148).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleCost" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleCost")
Source documentation: `Candidate score for the oracle-label diagonal candidate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3152](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3152).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResourceTuple" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResourceTuple")
Source documentation: `Tuple in the QBE score order '(gateCount, depth, auxiliaryQubits, oracleCalls)'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3157](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3157).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResource_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResource_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3164](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3164).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResourceTuple_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleResourceTuple_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3168](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3168).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.diagonalCleanBlockContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.diagonalCleanBlockContract")
Source documentation: `Clean-block contract for the diagonal cubic candidate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3175](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3175).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.diagonalCleanBlockContract_pointwise_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.diagonalCleanBlockContract_pointwise_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3181](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3181).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3188](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3188).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicAmplitude_le_one" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicAmplitude_le_one")
Source documentation: `Amplitude range needed by the one-signal diagonal construction.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3196](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3196).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.cubicAmplitude_nonneg" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicAmplitude_nonneg")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3203](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3203).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleDimension" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleDimension")
Source documentation: `Full matrix dimension of the unexpanded one-signal primitive oracle.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3210](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3210).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleUnitary" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleUnitary")
Source documentation: `External primitive matrix supplied by the oracle-label tier. This is only a named object for the semantic contract below. The current file does not prove that this opaque matrix is a gate-expanded unitary.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3219](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3219).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleIsUnitary" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleIsUnitary")
Source documentation: `Explicit unitarity obligation for the primitive oracle-label matrix.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3224](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3224).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts")
Source documentation: `Explicit clean-block extraction obligation for the primitive oracle-label matrix.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3229](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3229).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract")
Source documentation: `Primitive one-signal amplitude-oracle semantic contract. This contract keeps the unexpanded primitive tier honest: it requires both a unitarity obligation for the named oracle matrix and a clean-block extraction obligation whose extracted block satisfies the diagonal target contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3241](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3241).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_unitary" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_unitary")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3248](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3248).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleSemanticContract_cleanBlock_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3253](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3253).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleLayout" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleLayout")
Source documentation: `Expanded arithmetic route layout. The workspace count is explicit because the reversible arithmetic, angle synthesis, and uncomputation proof are not yet fixed to one resource backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3268](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3268).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleLayout_auxiliaryQubits" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleLayout_auxiliaryQubits")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3273](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3273).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleNormalizer_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleNormalizer_eq")
Source documentation: `The expanded route targets the same exact normalizer 'alpha = 1'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3280](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3280).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.StandardRyCleanEntryScalarTier" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.StandardRyCleanEntryScalarTier")
Source documentation: `Scalar-tier contract for the standard 'R_y' clean-entry identity. The project-local matrix layer is still exact 'Rat', so 'arccos' and 'cos' are represented here by backend-supplied scalar functions. The contract keeps the standard convention explicit: for every rational amplitude 'a' in '[0, 1]', the clean signal entry of 'R_y (2 * arccos a)' is exactly 'a' after embedding into the backend scalar tier.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3293](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3293).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedRyCleanEntryForCubicAmplitudes" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedRyCleanEntryForCubicAmplitudes")
Source documentation: `Indexwise clean-entry obligation for the cubic diagonal amplitudes in a chosen standard-'R_y' scalar tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3308](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3308).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedRyCleanEntryForCubicAmplitudes_of_standardTier" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedRyCleanEntryForCubicAmplitudes_of_standardTier")
Source documentation: `'DIAG-EXP-RY-001': the standard scalar-tier 'R_y' clean-entry contract applies to every cubic grid amplitude because the existing Lean range lemmas prove '0 <= (j / 2^n)^3 <= 1'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3321](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3321).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude")
Source documentation: `Semantic obligation that the expanded reversible arithmetic computes 'a_j = (j / 2^n)^3' into the named workspace.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3334](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3334).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ExpandedCubicArithmeticBackend" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ExpandedCubicArithmeticBackend")
Source documentation: `Backend-level shape for the expanded reversible arithmetic compute phase. The structure records only the compute half of the route: starting from a clean workspace, the backend returns the same system index together with a workspace whose distinguished amplitude register contains 'CubicStatePreparation.cubicAmplitude n j'. Clean uncompute remains the separate obligation 'expandedWorkspaceCleanUncomputed'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3346](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3346).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend")
Source documentation: `Symbolic compute-phase backend for 'DIAG-EXP-ARITH-BACKEND-001'. This witness records only the pointwise arithmetic value written by the compute phase. It does not certify a reversible gate implementation, clean uncompute, or the bridge to 'expandedArithmeticComputesCubicAmplitude'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3361](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3361).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticBackendComputesCubicAmplitude" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticBackendComputesCubicAmplitude")
Source documentation: `Pointwise arithmetic-backend semantics for 'DIAG-EXP-ARITH-001'. For each system index 'j', the compute phase preserves 'j' and writes exactly the cubic diagonal amplitude into its distinguished amplitude register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3377](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3377).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend_computes" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend_computes")
Source documentation: `The symbolic backend satisfies the pointwise compute contract for every system index. The opaque expanded-route predicate still requires a separate backend bridge witness.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3391](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3391).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticBackendBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticBackendBridge")
Source documentation: `Bridge obligation from a concrete arithmetic backend to the expanded route predicate. This is conditional for the same reason as the rotation bridge: the backend must still justify that its pointwise compute semantics are the semantics of the route predicate used by the block-encoding contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3406](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3406).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude_of_backendBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude_of_backendBridge")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3412](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3412).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticBackendBridge_iff_of_computes" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticBackendBridge_iff_of_computes")
Source documentation: `General normal form for arithmetic backend bridge proof search. Once a backend's pointwise compute contract is available, proving its bridge is equivalent to proving the opaque expanded-route predicate itself. This lemma is a proof-reduction aid; it does not supply the route semantics.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3427).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude_of_symbolicBackendBridge")
Source documentation: `Specialized conditional closure for the symbolic arithmetic backend. This does not prove the backend bridge witness; it only packages the already compiled pointwise compute proof with a future honest bridge witness for 'DIAG-ARITH-BACKEND-BRIDGE-001'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3448](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3448).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend_bridge_iff" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.symbolicExpandedCubicArithmeticBackend_bridge_iff")
Source documentation: `Normal form for the symbolic arithmetic bridge obligation. For the symbolic backend, the pointwise compute proof is already compiled, so the bridge obligation is logically equivalent to the opaque expanded-route predicate itself. This is a proof-reduction lemma, not a bridge witness: it keeps 'DIAG-ARITH-BACKEND-BRIDGE-001' blocked until a concrete route-semantics representation proves 'expandedArithmeticComputesCubicAmplitude'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3468](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3468).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicPayload_lt_capacity" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicPayload_lt_capacity")
Source documentation: `'DIAG-ARITH-FIXED-DENOM-CAP-001': the fixed-denominator cubic payload fits in the '3 * n'-qubit workspace register.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3481](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3481).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicAmplitude_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicAmplitude_eq")
Source documentation: `'DIAG-ARITH-FIXED-DENOM-ALG-001': projecting the fixed-denominator payload 'j.val ^ 3' by the '3 * n'-qubit denominator recovers the cubic grid amplitude.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3493](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3493).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticBackend" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticBackend")
Source documentation: `'DIAG-ARITH-FIXED-DENOM-BACKEND-001': concrete compute-phase backend whose '3 * n'-qubit workspace stores the fixed-denominator payload 'j.val ^ 3'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3509](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3509).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticBackend_computes" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticBackend_computes")
Source documentation: `Pointwise compute contract for the fixed-denominator arithmetic backend. This closes the backend leaf only; the bridge to 'expandedArithmeticComputesCubicAmplitude' remains a separate semantic obligation.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3527](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3527).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitudeTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitudeTransparent")
Source documentation: `Transparent arithmetic-route interface for 'DIAG-ARITH-ROUTE-TRANSPARENT-001'. This records that some explicit backend satisfies the pointwise compute contract. It is intentionally weaker than the opaque expanded-route predicate: using it as a route certificate still requires a later named bridge or contract refactor.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3546](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3546).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticRouteTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticRouteTransparent")
Source documentation: `Fixed-denominator witness for the transparent arithmetic route interface. This packages the already compiled fixed-denominator backend and its pointwise compute theorem. It does not prove 'expandedArithmeticComputesCubicAmplitude n (3 * n)'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3558](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3558).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticBackend_bridge_iff" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicArithmeticBackend_bridge_iff")
Source documentation: `Fixed-denominator normal form for the arithmetic bridge obligation. The concrete backend's pointwise compute proof is available, so direct bridge search is equivalent to proving the opaque expanded-route predicate itself. This records the remaining route-semantics gap without supplying a bridge witness.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3572](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3572).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngle" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngle")
Source documentation: `Semantic obligation for the standard 'R_y' convention on the signal qubit: for each basis index 'j', the route uses 'theta_j = 2 * arccos ((j / 2^n)^3)', so the clean entry is 'cos (theta_j / 2) = (j / 2^n)^3'.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3586](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3586).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngleTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngleTransparent")
Source documentation: `Transparent controlled-'R_y' angle-convention interface for 'DIAG-RY-TRANSPARENT-INTERFACE-001'. This records only the already compiled scalar clean-entry fact for every standard tier. It does not prove the opaque route predicate 'expandedControlledRyUsesCubicAngle'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3597](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3597).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomControlledRyRouteTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomControlledRyRouteTransparent")
Source documentation: `Fixed-denominator wrapper for the transparent controlled-'R_y' route. This packages the scalar-tier theorem at workspace size '3 * n'. It does not provide a backend witness for 'expandedControlledRyUsesCubicAngle'.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3608](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3608).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyBackendBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyBackendBridge")
Source documentation: `Backend bridge obligation from the scalar-tier 'R_y' clean-entry interface to the expanded route predicate. This is intentionally conditional: the file already proves the scalar clean-entry fact for cubic amplitudes, but a concrete backend must still justify that this fact is the semantics of the controlled rotation used by the route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3622](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3622).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngle_of_backendBridge" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngle_of_backendBridge")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3628](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3628).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyBackendBridge_iff_of_standardTier" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyBackendBridge_iff_of_standardTier")
Source documentation: `Normal form for controlled-rotation backend-bridge proof search. The scalar-tier clean-entry theorem is already compiled, so proving a backend bridge for the controlled rotation is equivalent to proving the opaque route predicate itself. This is a proof-reduction lemma for 'DIAG-RY-BACKEND-WITNESS-001'; it does not supply the missing backend semantics.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3644](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3644).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ExpandedControlledRyWorkspaceReadonlyWitness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ExpandedControlledRyWorkspaceReadonlyWitness")
Source documentation: `Transparent readonly-rotation interface for 'DIAG-RY-WORKSPACE-READONLY-001'. This records that the controlled signal rotation may read the arithmetic workspace payload while preserving both the system index and workspace value. It does not prove 'expandedWorkspaceCleanUncomputed' or any opaque route predicate.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3666](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3666).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyWorkspaceReadonlyTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyWorkspaceReadonlyTransparent")
Source documentation: `Transparent predicate for a controlled-rotation step that preserves the arithmetic workspace. This is intentionally separate from route-level cleanup; a later packet must choose either a transparent cleanup contract refactor or a nontrivial bridge.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3686](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3686).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputed" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputed")
Source documentation: `Semantic obligation that the arithmetic workspace is returned clean.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3691](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3691).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.ExpandedArithmeticCleanUncomputeWitness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.ExpandedArithmeticCleanUncomputeWitness")
Source documentation: `Transparent clean-uncompute interface for 'DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001'. This records the data needed to state honest reversible cleanup: a compute step matching the backend on clean workspace, an uncompute step that preserves the system index, and a two-sided cleanup condition after compute. It does not prove the opaque route predicate 'expandedWorkspaceCleanUncomputed'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3703](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3703).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputedTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputedTransparent")
Source documentation: `Transparent cleanup predicate backed by an explicit reversible witness. This is intentionally separate from 'expandedWorkspaceCleanUncomputed'; a later route must either instantiate this interface and refactor a contract to consume it, or supply a nontrivial bridge to the opaque predicate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3731](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3731).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputedTransparent_of_witness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputedTransparent_of_witness")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3735](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3735).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicComputeStep" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicComputeStep")
Source documentation: `Fixed-denominator reversible compute lift for 'DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001'. This modular-add step agrees with 'fixedDenomCubicArithmeticBackend' on clean workspace, but unlike the backend's overwrite-style compute field it is invertible on every workspace value.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3783](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3783).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicUncomputeStep" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicUncomputeStep")
Source documentation: `Modular-subtract inverse for 'fixedDenomCubicComputeStep'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3791](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3791).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicComputeStep_matches_backend_on_clean" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicComputeStep_matches_backend_on_clean")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3798](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3798).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicUncomputeStep_after_compute" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomCubicUncomputeStep_after_compute")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3807](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3807).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomExpandedArithmeticCleanUncomputeWitness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomExpandedArithmeticCleanUncomputeWitness")
Source documentation: `Fixed-denominator witness for the transparent clean-uncompute interface. This packages modular add/sub cleanup only. It does not prove the opaque predicate 'expandedWorkspaceCleanUncomputed', does not state controlled-rotation workspace-readonly semantics, and does not close extraction or unitarity.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3827](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3827).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomWorkspaceCleanUncomputedTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomWorkspaceCleanUncomputedTransparent")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3846](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3846).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalValueBackend" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalValueBackend")
Source documentation: `Backend-level shape for computing the hinted linear diagonal value 'x_j = j / 2^n'. This is a transparent value-computation support interface for 'HINT-O0-BACKEND'. It does not provide the signal rotation, rational orthogonal matrix, or clean-block equality required by 'LinearDiagonalInputBEContract'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3860](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3860).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalValueBackendComputesGridPoint" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalValueBackendComputesGridPoint")
Source documentation: `Pointwise value-computation contract for a linear diagonal backend. On clean workspace the backend preserves the system index and writes exactly 'CubicStatePreparation.gridPoint n j' into its distinguished value register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3874](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3874).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalValueBackend" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalValueBackend")
Source documentation: `Fixed-denominator value backend for 'O_0'. The workspace stores the numerator 'j' in an 'n'-qubit register and interprets it as the rational value 'j / 2^n'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3889](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3889).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalValueBackend_computes" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalValueBackend_computes")
Source documentation: `The fixed-denominator linear backend computes 'x_j = j / 2^n' on clean workspace.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3901](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3901).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalValueCleanUncomputeWitness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.LinearDiagonalValueCleanUncomputeWitness")
Source documentation: `Transparent cleanup witness for a linear value backend. The witness uses an invertible compute/uncompute pair around the backend's clean-workspace value contract. It is intentionally separate from the missing controlled-rotation and full clean-block obligations.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3919](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3919).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalWorkspaceCleanUncomputedTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalWorkspaceCleanUncomputedTransparent")
Source documentation: `Transparent predicate for honest compute/uncompute cleanup of an 'O_0' value backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3941](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3941).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalWorkspaceCleanUncomputedTransparent_of_witness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalWorkspaceCleanUncomputedTransparent_of_witness")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3945](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3945).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalComputeStep" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalComputeStep")
Source documentation: `Modular-add compute step for the fixed-denominator linear backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3952](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3952).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalUncomputeStep" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalUncomputeStep")
Source documentation: `Modular-subtract inverse for 'fixedDenomLinearDiagonalComputeStep'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3960](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3960).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalComputeStep_matches_backend_on_clean" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalComputeStep_matches_backend_on_clean")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3967](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3967).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalUncomputeStep_after_compute" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalUncomputeStep_after_compute")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3976](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3976).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalCleanUncomputeWitness" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalCleanUncomputeWitness")
Source documentation: `Fixed-denominator cleanup witness for the hinted 'O_0' value backend. This closes only the transparent value-compute/cleanup support leaf for 'HINT-O0-BACKEND'; a full 'LinearDiagonalInputBEContract' instance still needs a signal-amplitude matrix with 'IsRationalOrthogonal', clean-block equality, and resource accounting.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:3997](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L3997).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalWorkspaceCleanUncomputedTransparent" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.fixedDenomLinearDiagonalWorkspaceCleanUncomputedTransparent")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4016](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4016).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockExtracts" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockExtracts")
Source documentation: `Clean-block extraction obligation for the expanded arithmetic/rotation route.`.

Kind: opaque. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4023](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4023).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockContract")
Source documentation: `Expanded-route clean-block contract for 'DIAG-EXPANDED-CONTRACT-001'. This is an interface, not a proof of the expanded circuit. It keeps the transparent arithmetic witness, transparent controlled-rotation witness, and clean-uncompute obligations explicit and requires the extracted clean block to satisfy the existing diagonal contract.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4035](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4035).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockContract_diagonal" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockContract_diagonal")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4044](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4044).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockContract_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockContract_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4051](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4051).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleSemanticContract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleSemanticContract")
Source documentation: `Conditional semantic interface for an expanded arithmetic/rotation route with an explicit workspace size.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4063](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4063).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4068](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4068).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate")
Source documentation: `Conditional candidate at the primitive oracle-label tier.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4080](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4080).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_costTuple_eq" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_costTuple_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4097](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4097).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_unitary_from_contract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_unitary_from_contract")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4108](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4108).
:::

:::theorem "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_block_from_contract" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCandidate_block_from_contract")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4114](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4114).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleVerified" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleVerified")
Source documentation: `Conditional exact certificate for the primitive oracle-label tier. This packages a verified block encoding only from an explicit proof of 'primitiveAmplitudeOracleSemanticContract n'; the contract itself remains an open primitive-oracle obligation until such a proof or accepted primitive axiom is supplied.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4128](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4128).
:::

:::definition "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleClaim" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.amplitudeOracleClaim")
Source documentation: `Human-facing construction claim for the first exact diagonal route.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CubicStatePreparation.lean:4136](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CubicStatePreparation.lean#L4136).
:::
