# Middle Packet: Prepared-Circuit Contract Correction

Task: `QBE-AUTO-002`  
Run: `20260617-042830-QBE-AUTO-002-cycle01`  
Mode: `paperBenchmark`  
Leaf: `prepared_circuit_contract_correction`

## Source Contract

The active source theorem remains GHL2025 Theorem `theorem: 1 term robin`,
treated in this run as the main one-term Robin block-encoding theorem.  The
source fragments are Eq. `eq: arbitrary sparcity`, Eq. `eq: ROBIN clarified`,
Fig. `fig:1 term ROBIN`, and Definition `def:block-encoding`.

The correction is source-faithful: the paper uses the sparse-prepared Fig. 4
route, not the active seven-gate backend by itself.  Lean already records the
distinction:

| Source object | Lean object | Current status |
|---|---|---|
| full Fig. `fig:1 term ROBIN` transcript | `GHL2025.oneTermRobinTheoremFacingFig4Circuit` | 10-gate transcript guard |
| active backend component | `GHL2025.oneTermRobinCircuit` and `oneTermRobinCircuitSemantics 3` | seven-gate matrix semantics used by the finite block contract |
| sparse-prepared singleton semantics | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` | compiled local semantics object |
| active/prepared mismatch guard | `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` | compiled absence of both `H_W^(kappa)` sides from the active backend |
| current missing field | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` or the uncast equivalent | open QBE-local finite composition obligation |

No new cited result is needed.  The existing Shukla--Vedula row remains
contract-only through
`oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H` and may
be used only for prepared clean-entry evaluation, not for active/prepared
composition.

## Source-Dependency Audit

| Missing ingredient | Classification | Next route |
|---|---|---|
| theorem-facing finite block/projection route consumes the prepared singleton clean entry | `internal-paper-step` plus QBE-local interface glue | compile a non-promoting wrapper exposing the prepared singleton entry through the theorem-facing finite block interface |
| active seven-gate entry equals the prepared singleton clean entry | `internal-paper-step` plus QBE-local finite matrix semantics | keep as the next unproved active/prepared composition obligation |
| `H_W^(kappa)` clean-column behavior | `external-cited-result` | use the existing cited contract only; do not formalize Shukla--Vedula here |
| raw backend `projectionSummationStatement` or `backendExpansionStatement` as full Fig. 4 closure | `contract-drift` / invalid route | keep the no-go guards and reject as lower2 target |

## Lower 1 Packet

Write the natural-language dependency proof for the prepared-circuit correction.
Use the following proof map.

| Step | Source anchor | Lean declaration or obligation |
|---|---|---|
| distinguish the full Fig. 4 transcript from the active backend component | Fig. `fig:1 term ROBIN` and Eq. `eq: arbitrary sparcity` | `GHL2025.oneTermRobinTheoremFacingFig4Circuit_gateList`, `GHL2025.oneTermRobinActiveBackendCircuit_gateList`, `oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3` |
| select the prepared singleton clean entry as the theorem-facing projection entry | Definition `def:block-encoding` and Fig. `fig:1 term ROBIN` | `oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3`, `oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` |
| expose the prepared singleton semantics object | Eq. `eq: arbitrary sparcity` and Fig. `fig:1 term ROBIN` | `oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H` |
| keep the finite block contract unchanged | paper baseline contract | `oneTermRobinFiniteBlockCompositionContract 3` still uses `oneTermRobinCircuitSemantics 3` |
| identify the next unproved composition field | Definition `def:block-encoding` clean projection | `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env` and `oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3 H env` |

Lower1 must not turn the active backend component into the full Fig. 4 circuit.
The proof map should say that the wrapper is not root closure and that all
oracle, LCU, block-projection, normalized-equality, unitarity, resource, final
extraction, and product-to-coefficient flags remain false.

## Lower 2 Packet

Allowed write scope: `QuantumBlockEncoding/RobinMatrix.lean` only.  Add the
wrapper near
`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3` and
the compiled fixed-product pre-audit wrappers.  If the theorem already exists,
make no Lean edit and log `error_class=stale_leaf`.

Preferred theorem name:

```lean
oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3
```

Target shape:

```lean
theorem
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3
    (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let interface :=
      oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3
        H env
    let gap := oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3 H
    let sourceTarget :=
      oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3 H env
    let prepared :=
      oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H
    let clean := oneTermRobinGamma3BoundarySparseCleanIndex_n3
    interface.sourcePreparedProjectionTarget = sourceTarget ∧
      interface.sourcePreparedProjectionEntry =
        prepared.matrix clean clean ∧
      sourceTarget.preparedSemantics = prepared ∧
      sourceTarget.preparedProjectionEntry =
        prepared.matrix clean clean ∧
      interface.contractClaimSemantics = oneTermRobinCircuitSemantics 3 ∧
      interface.contractUsesActiveBackendSemantics = true ∧
      interface.theoremFacingCircuit ≠ interface.activeBackendCircuit ∧
      gap.rawEntryContractProved = true ∧
      gap.sparsePreparationAbsenceProved = true ∧
      gap.preparedCircuitEntryEqualityProved = false ∧
      sourceTarget.activeProjectionBackendUsesPreparedEntry = false ∧
      sourceTarget.activePreparedEntryEqualityProved = false ∧
      interface.correctedFiniteBlockProjectionEquality.proved = false ∧
      interface.correctedFiniteBlockProjectionEqualityProved = false ∧
      interface.fixedProductObligation.proved = false ∧
      interface.normalizedBlockEqualityProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false ∧
      interface.oracleCorrectProved = false ∧
      interface.unitaryProved = false ∧
      interface.resourceClaimProved = false
```

Suggested proof route:

```lean
  have hdistinct :
      GHL2025.oneTermRobinTheoremFacingFig4Circuit ≠
        GHL2025.oneTermRobinCircuit := by
    dsimp [GHL2025.oneTermRobinTheoremFacingFig4Circuit,
      GHL2025.oneTermRobinCircuit]
    native_decide
  have _hinterface :=
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3_transcript
      H env
  have _hgap :=
    oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript H
  have _hsource :=
    oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3_transcript
      H env
  dsimp [
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3,
    oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3,
    oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3,
    oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3,
    oneTermRobinFiniteBlockCompositionContract,
    defaultOneTermRobinCircuitBlockClaim,
    oneTermRobinCircuitBlockClaim,
    GHL2025.oneTermRobinTheoremFacingFig4Circuit,
    GHL2025.oneTermRobinCircuit]
  repeat (first | constructor | exact hdistinct | rfl)
```

Build expectation after any Lean edit:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

## Lower 3 Packet

Before lower2 spends proof-search time, check these necessary conditions.

| Field | Expected value |
|---|---|
| `leaf` | `prepared_circuit_contract_correction` |
| `source_correspondence_ok` | `true` |
| `lean_parse_ok` | `true` after any edit |
| `lean_build_ok` | `true` only after the full gate |
| `finite_matrix_ok` | `true` for the typed prepared singleton clean entry; not a proof of active/prepared equality |
| `block_entry_ok` | `true` only for exposing `interface.sourcePreparedProjectionEntry = prepared.matrix clean clean` |
| `ancilla_cleanup_ok` | `null` |
| `normalizer_ok` | `null` for this wrapper |
| `unitarity_ok` | `null` |
| `closed_theorem_ok` | `true` only if the wrapper compiles |
| `error_class` | `symbolic_bridge_gap` before compilation; `stale_leaf` if already present |
| `next_route` | prove or further reduce `oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3 H env`; do not target root closure |

Reject any route that substitutes the theorem-facing circuit into
`oneTermRobinFiniteBlockCompositionContract 3`, mutates `oneTermRobinCircuit`,
assumes `oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement`,
proves the root product obligation, or starts post-baseline improvement search.

## Middle Handoff

Middle handoff: leaf=`prepared_circuit_contract_correction`; planned Lean
target=`oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_preparedCircuitContractCorrection_n3`;
source_correspondence_ok=true; target file is
`QuantumBlockEncoding/RobinMatrix.lean`; lower2 must compile one non-promoting
wrapper only.  The next mathematical obstruction after this wrapper remains
the active/prepared selected-entry composition field.
