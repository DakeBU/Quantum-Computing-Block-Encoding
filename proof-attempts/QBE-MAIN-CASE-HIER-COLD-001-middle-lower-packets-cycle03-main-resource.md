# Middle Lower Packets: QBE-MAIN-CASE-HIER-COLD-001 Cycle 3 MAIN-RESOURCE-001

## Shared Source Contract

The fixed operator is

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S.
$$

The COLD benchmark instance uses one qubit each for `T`, `tau`, and `S`, one
clean signal qubit at value `0`, normalizer `1`, and exact error `0`.  The
system flattening is `4*T + 2*tau + S`; the full signal-system flattening is
`8*signal + 4*T + 2*tau + S`.

Compiled COLD declarations:

| Role | Lean declaration | Status |
|---|---|---|
| target matrix and metadata | `mainCaseColdTarget`, `mainCaseColdQueryTarget` | compiled |
| clean signal and embedding | `mainCaseColdCleanSignal`, `mainCaseColdCleanEmbed` | compiled |
| finite permutation candidate | `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | compiled |
| clean-block theorem | `mainCaseColdPartialPerm_clean_eq_target` | proved |
| finite-bijection theorem | `mainCaseColdPartialPermImage_bijective` | proved |
| project-local block projection | `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection` | proved |
| source layout | `mainCaseColdSourceLayout_auxiliaryQubits` | proves layout auxiliary count `1` |
| current resource gap | `mainCaseColdResourceSchemaObligation` | open, `proved = false` |

Do not use `mainCasePro*`, previous task-specific candidate names, previous
Pro answers, or Qiskit/QASM exports as construction shortcuts.  If the same
logical gate idea is rediscovered from the COLD table, prove it under
independent `mainCaseCold*` names and record it as an independent attempt.

## Active Leaf

Leaf id: `MAIN-RESOURCE-001`.

Human rationale: the block/projection theorem is now proved, but the task still
cannot advertise a ranked block-encoding candidate or executable export because
the COLD construction has no honest circuit/resource tuple.  This leaf exists
to turn the finite permutation into a task-local circuit or to keep the
resource gap explicit.

Allowed write scope for Lean work:

- `QuantumBlockEncoding/MainCase.lean`
- `Tests/Basic.lean`

Allowed write scope for diagnostics and memory:

- `verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/`
- `proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-*`
- `runs/20260625-233740-QBE-MAIN-CASE-HIER-COLD-001-cycle03/`

Build gate after Lean edits:

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

## Lower 1: Natural-Language Proof Architect

Goal: derive a COLD-local circuit/resource route from the COLD finite image
table, not from Pro-arm declarations.

Produce a concise proof packet with:

| Field | Required content |
|---|---|
| source anchor | task packet operator contract and COLD image table in the conversion window |
| target theorem served | future `mainCaseColdPartialPermCost_*` and, after resource closure, `mainCaseColdPartialPermCandidate` |
| candidate circuit schema | a named sequence of reversible gates, or a statement that no schema was derived this cycle |
| register map | full wire order and whether wires are `(S,tau,T,signal)` or another explicit order |
| image theorem target | exact finite function the proposed circuit induces, and whether it should equal `mainCaseColdPartialPermImage` or only match the clean block |
| resource tuple | gate count, depth, auxiliary qubits, oracle calls, and the counting convention |
| Lean leaves | exact declarations lower 2 should attempt |
| rejection conditions | any finite image mismatch, dirty-branch collision, target mutation, hidden oracle, or fabricated cost |

If no circuit schema is found, retire the attempt as a resource-schema search
failure and keep `mainCaseColdResourceSchemaObligation.proved = false`.

## Lower 2: Lean Implementation Worker

Implement exactly one ready Lean leaf from lower 1.  Do not package
`mainCaseColdPartialPermCandidate` unless a circuit/resource schema and all
field theorems compile in the same patch.

Preferred declaration sequence when a schema is fixed:

```lean
def mainCaseColdCircuit : Circuit

def mainCaseColdSchedule : LayeredCircuit

def mainCaseColdHighLevelResource : Resource

def mainCaseColdPartialPermCost : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    mainCaseColdSourceLayout mainCaseColdHighLevelResource

theorem mainCaseColdPartialPermCost_auxiliaryQubits :
    mainCaseColdPartialPermCost.auxiliaryQubits = 1

theorem mainCaseColdPartialPermCost_gateCount :
    mainCaseColdPartialPermCost.gateCount = <honest count>

theorem mainCaseColdPartialPermCost_depth :
    mainCaseColdPartialPermCost.depth = <honest depth>

theorem mainCaseColdPartialPermCost_oracleCalls :
    mainCaseColdPartialPermCost.oracleCalls = 0
```

Only after those declarations compile may a later packet add:

```lean
def mainCaseColdPartialPermCandidate :
    OperatorBlockEncodingCandidate Rat 3

def mainCaseColdPartialPermVerified :
    VerifiedOperatorBlockEncoding Rat 3
```

If the circuit image is not proved this cycle, do not mark
`mainCaseColdResourceSchemaObligation.proved` as true.

## Lower 3: Necessary-Condition Verifier

Goal: reject bad resource/circuit routes before lower 2 spends proof time.

Given a proposed circuit schema, write or run a finite diagnostic that checks:

| Field | Required check |
|---|---|
| `finite_matrix_ok` | the proposed finite image is bijective on `Fin 16` |
| `block_entry_ok` | clean support is exactly rows/cols `(0,6)` and `(1,7)` |
| `ancilla_cleanup_ok` | clean signal output is clean only for source columns `(6,7)` |
| `normalizer_ok` | alpha remains `1` |
| `resource_score` | tuple matches the declared `Resource` and `BlockEncodingCost` |
| `oracle_calls` | zero only if the schema contains no unresolved oracle gate |

Write typed feedback under
`verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/` and log it with
`tools/qbe.py trial-log`.  Use `finite_matrix_counterexample` for an image or
block mismatch, `shape_or_register_gap` for wire-order mistakes,
`invalid_route` for target mutation or hidden oracle use, and
`symbolic_bridge_gap` only when the finite diagnostic passes but the Lean
bridge is still missing.

## Retired Targets

Do not reopen these unless the COLD target or image table changes:

- `MAIN-CLEAN-ENTRY-001`
- finite-bijection subleaf of `MAIN-PERM-UNITARY-001`
- `MAIN-BLOCK-PROJECTION-001`

Qiskit/QASM3 export remains blocked until a named COLD verified candidate and
resource tuple compile.
