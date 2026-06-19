# Conversion Window: QBE-OP-CUBIC-DIAGONAL-001

Updated: 2026-06-19 20:44 JST
Mode: exploratoryConstruction
Source anchor: user-provided operator request in `tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.

## Source And Lean Symbols

| Source/user symbol | Meaning | Lean name or artifact | Status |
|---|---|---|---|
| $n$ | number of system qubits | parameter `n : Nat`; positive-qubit condition is recorded in the task text, but current Lean declarations accept all `Nat` | target surface compiled |
| $N = 2^n$ | grid size | `gridSize n` | compiled |
| $x_j = j / 2^n$ | grid point for row index `j` | `CubicStatePreparation.gridPoint n j` | compiled |
| $f(x) = x^3$ | cubic amplitude | `CubicStatePreparation.cubicAmplitude n j` | compiled |
| $D_n$ | diagonal operator with entry $(j/2^n)^3$ on row `j` | `CubicDiagonalOracle.cubicDiagonalOperator n` | compiled |
| $\alpha = 1$ | exact primitive-oracle normalizer | `CubicDiagonalOracle.exactNormalizer n` | compiled |
| one-signal diagonal amplitude oracle | primitive oracle-label candidate, not expanded arithmetic | `amplitudeOracleLayout`, `amplitudeOracleCircuit`, `amplitudeOracleResourceTuple` | compiled interface; semantic primitive unitary open |

This task is a diagonal operator block-encoding task.  It must not be rewritten
as the rank-one state-preparation target from `QBE-OP-CUBIC-STATEPREP-001`, and
the diagonal vector must not be normalized as a quantum state.

## Lean-Facing Contract

The target operator is already represented by:

```lean
CubicDiagonalOracle.cubicDiagonalOperator (n : Nat) :
  Matrix (gridSize n) (gridSize n) Rat
```

Its entrywise contract is:

```lean
fun row col =>
  if row = col then CubicStatePreparation.cubicAmplitude n row else 0
```

The primitive oracle-label route uses one signal qubit and no pure workspace at
the unexpanded tier.  Its advertised score is compiled as:

```lean
CubicDiagonalOracle.amplitudeOracleResourceTuple_eq :
  CubicDiagonalOracle.amplitudeOracleResourceTuple n = (1, 1, 1, 1)
```

The closed Lean-facing bridge is:

```lean
theorem CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target
    (n : Nat) (block : Matrix (gridSize n) (gridSize n) Rat)
    (h : CubicDiagonalOracle.diagonalCleanBlockContract n block) :
    Matrix.PointwiseEq block (CubicDiagonalOracle.cubicDiagonalTarget n).operator
```

This theorem is not a unitary certificate.  It only says that once a primitive
oracle or an expanded circuit supplies a block satisfying
`diagonalCleanBlockContract`, the block is exactly the task target.

## Source-Contract Audit

There is no paper source archive for this task.  The authoritative source is
the user-provided operator requirement.

| Contract field | Current value | Lean representation | Status |
|---|---|---|---|
| input system register | `n`-qubit index register holding `j` | row/column indices of `Matrix (gridSize n) (gridSize n) Rat` | compiled |
| signal register | one clean signal qubit selecting the clean block | `amplitudeOracleLayout n` with `signalQubits := 1` | compiled interface |
| pure ancillas | none at the primitive oracle-label tier | `amplitudeOracleLayout n` with `pureAncillas := 0` | compiled |
| output operator | diagonal entries $(j/2^n)^3$ and zero off diagonal | `cubicDiagonalOperator n` | compiled |
| normalizer | $\alpha = 1$ | `exactNormalizer n` | compiled |
| range bound | $0 \le (j/2^n)^3 \le 1$ | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | compiled |
| primitive unitary | one-signal amplitude oracle realizing the clean block | planned semantic contract | open obligation |
| expanded arithmetic route | reversible arithmetic plus controlled rotations | no Lean declaration yet | backlog, not this active leaf |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target matrix. | none | existing Lean | `CubicDiagonalOracle.cubicDiagonalOperator`, `cubicDiagonalTarget` | this conversion window, Source And Lean Symbols | `python3 tools/qbe.py check` | proved |
| `DIAG-RANGE-001` | Prove each diagonal amplitude lies in `[0,1]`. | `gridPoint_nonneg`, `gridPoint_le_one`, `rat_pow_le_one_of_nonneg_le_one` | existing Lean | `cubicAmplitude_nonneg`, `cubicAmplitude_le_one` | Source-Contract Audit | `python3 tools/qbe.py check` | proved |
| `DIAG-RESOURCE-001` | Record one-signal oracle-label layout and score `(1, 1, 1, 1)`. | `amplitudeOracleLayout`, `amplitudeOracleCircuit` | existing Lean | `amplitudeOracleResourceTuple_eq` | Lean-Facing Contract | `python3 tools/qbe.py check` | proved |
| `DIAG-BLOCK-BRIDGE-001` | Any block satisfying `diagonalCleanBlockContract` is pointwise equal to `(cubicDiagonalTarget n).operator`. | `DIAG-TGT-001`, `diagonalCleanBlockContract_pointwise_eq` | lower 2 Lean worker | `CubicDiagonalOracle.primitiveOracleCleanBlock_eq_target` | Lean-Facing Contract | `python3 tools/qbe.py check` passed 2026-06-19 20:44 JST | proved |
| `DIAG-PRIM-UNITARY-001` | State and certify the primitive one-signal amplitude-oracle unitary and clean-block extraction without expanding arithmetic. | `DIAG-RANGE-001`, `DIAG-BLOCK-BRIDGE-001`, primitive oracle semantics | lower architect then lower Lean | planned primitive semantic contract; exact name to be chosen next | Source-Contract Audit | `python3 tools/qbe.py check` | active leaf |
| `DIAG-ROOT-001` | Exact primitive operator block-encoding certificate, or an equivalent project-local certificate that keeps unitarity and block correctness explicit. | `DIAG-RESOURCE-001`, `DIAG-PRIM-UNITARY-001` | future lower Lean | planned `VerifiedOperatorBlockEncoding`-compatible artifact | Proof-DAG Frontier | `python3 tools/qbe.py check` | blocked internal obligation |
| `DIAG-EXPORT-001` | Qiskit, QuantumKatas-style, and QASM3 export plan tied to the named Lean certificate. | `DIAG-ROOT-001` | future verifier/export lower | planned `executable-exports/QBE-OP-CUBIC-DIAGONAL-001/` packet | export bridge after Lean closure | `python3 tools/qbe.py check` plus export checks | blocked downstream |

## Lower-Agent Packets

Lower 1 natural-language architect:

- Target file scope: `conversion-windows/QBE-OP-CUBIC-DIAGONAL-001.md` and `proof-obligations/QBE-OP-CUBIC-DIAGONAL-001.md`.
- Write or refine the proof design for `DIAG-PRIM-UNITARY-001`.
- Reuse `diagonalCleanBlockContract_pointwise_eq`, `cubicAmplitude_nonneg`, `cubicAmplitude_le_one`, and `amplitudeOracleResourceTuple_eq`.
- Do not introduce a rank-one operator, normalized vector state, or Qiskit export.

Lower 2 Lean implementation worker:

- Target file scope: `QuantumBlockEncoding/CubicStatePreparation.lean` inside `namespace CubicDiagonalOracle` only.
- `primitiveOracleCleanBlock_eq_target` is already compiled.
- The next Lean work should state one primitive semantic contract for the amplitude oracle.
- Do not create a `VerifiedBlockEncoding` or `VerifiedOperatorBlockEncoding` by setting semantic propositions to `True`.
- Run `python3 tools/qbe.py check` after the Lean edit and report `lean_build_ok`, `closed_theorem_ok`, and the exact declaration name.

Lower 3 necessary-condition verifier/export worker:

- Target file scope: `verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/` and optional small scripts under the run directory.
- Check small `n = 1, 2, 3` diagonal entries: diagonal entry `j` equals `(j / 2^n)^3` and off-diagonal entries vanish.
- If a candidate primitive block matrix is supplied later, check its clean block against `cubicDiagonalOperator`.
- Do not create Qiskit, QuantumKatas-style, or QASM3 exports until `DIAG-ROOT-001` names a Lean certificate.
- Record typed feedback with `leaf=DIAG-PRIM-UNITARY-001`, `source_correspondence_ok`, `finite_matrix_ok`, `block_entry_ok`, `normalizer_ok`, `error_class`, and `next_route`.

## Export Bridge Status

Requested executable exports are `qiskit`, `quantum-katas`, and `qasm3`.
They remain downstream obligations.  The export packet must wait until a Lean
certificate is named for `DIAG-ROOT-001`; finite diagonal checks may be used as
necessary-condition diagnostics but not as proof closure.
