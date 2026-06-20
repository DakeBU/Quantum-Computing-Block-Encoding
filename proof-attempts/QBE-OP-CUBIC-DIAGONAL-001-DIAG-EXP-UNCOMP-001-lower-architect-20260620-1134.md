# Lower Architect Packet: DIAG-EXP-UNCOMP-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: lower natural-language proof architect

Updated: 2026-06-20 11:34 JST

## Source Fragment

There is no paper-source archive for this task.  The source fragment is the
user-provided diagonal operator:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The translated target remains
$D_n[row,col] = (row/2^n)^3$ when `row = col` and $0$ otherwise, with exact
normalizer `exactNormalizer n = 1`.

The clean-uncompute leaf is not a new source equation.  It is QBE-local route
semantics for the expanded arithmetic-plus-controlled-rotation construction:

```text
|j>|0_work>  -- compute cubic payload -->  |j>|p_j>
|j>|p_j>    -- controlled R_y read only --> |j>|p_j>
|j>|p_j>    -- inverse arithmetic -->       |j>|0_work>
```

Here $p_j = j^3$ is stored in a `3 * n`-qubit fixed-denominator workspace, and
the amplitude projection is $p_j / 2^{3n} = (j/2^n)^3$.

## Definitions

For fixed `n : Nat`, let

```text
M = gridSize (3 * n),
p_j = j.val ^ 3, for j : Fin (gridSize n).
```

The existing fixed-denominator representation proves:

```lean
fixedDenomCubicPayload_lt_capacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 < gridSize (3 * n)

fixedDenomCubicAmplitude_eq
    (n : Nat) (j : Fin (gridSize n)) :
    (j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j
```

The current compute backend is:

```lean
fixedDenomCubicArithmeticBackend n :
  ExpandedCubicArithmeticBackend n (3 * n)
```

with pointwise clean-input semantics:

```lean
fixedDenomCubicArithmeticBackend_computes n :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

This backend records only the clean-input compute result.  It does not encode a
global reversible permutation or an inverse arithmetic operation.  Therefore it
is not enough by itself to prove `expandedWorkspaceCleanUncomputed`.

## Local Theorem Design

The implementation-ready mathematical subleaf should be a reversible
fixed-denominator lift, not a direct proof of the opaque predicate
`expandedWorkspaceCleanUncomputed`.

Use the same workspace basis `Fin M`, clean value `0`, and payload `p_j`.  Define
a modular-add compute step and a modular-subtract uncompute step:

```text
computeStep(j, w) = (j, (w + p_j) mod M),
uncomputeStep(j, w) = (j, (w + M - p_j) mod M).
```

For clean input, `computeStep(j, 0)` stores `p_j`, since `p_j < M`.  The
distinguished amplitude register therefore contains
`p_j / M = CubicStatePreparation.cubicAmplitude n j`, by
`fixedDenomCubicAmplitude_eq`.

The cleanup proof is:

```text
uncomputeStep(j, p_j)
  = (j, (p_j + M - p_j) mod M)
  = (j, M mod M)
  = (j, 0).
```

This proves cleanup after a read-only use of the payload.  A route-level
clean-uncompute theorem still needs a Lean statement saying that the controlled
`R_y` substep reads the arithmetic workspace and does not alter it.  The
current transparent rotation predicate proves only the scalar clean-entry
identity; it does not state register preservation.

## Proposed Lean Interface

Do not prove the opaque predicate by `trivial`, by an axiom, or by setting a
semantic proposition to `True`.  The next Lean-facing interface should instead
make the missing reversible cleanup data explicit.  One acceptable shape is:

```lean
structure ExpandedCubicArithmeticUncomputeWitness
    (n workspaceQubits : Nat) where
  Workspace : Type
  zeroWorkspace : Workspace
  amplitudeRegister : Workspace -> Rat
  computeStep :
    Fin (gridSize n) -> Workspace -> Fin (gridSize n) x Workspace
  uncomputeStep :
    Fin (gridSize n) -> Workspace -> Fin (gridSize n) x Workspace
  compute_preserves_index :
    forall j, (computeStep j zeroWorkspace).1 = j
  compute_amplitude :
    forall j,
      amplitudeRegister ((computeStep j zeroWorkspace).2) =
        CubicStatePreparation.cubicAmplitude n j
  uncompute_after_clean_compute :
    forall j,
      uncomputeStep j ((computeStep j zeroWorkspace).2) =
        (j, zeroWorkspace)
```

The actual Lean syntax should use `×` rather than the ASCII `x` above.  This
packet writes the shape only; a Lean worker should adapt it to the file's local
style.

For the fixed-denominator route, the witness data should be:

```text
Workspace = Fin (gridSize (3 * n))
zeroWorkspace = 0
amplitudeRegister(w) = w.val / gridSize (3 * n)
computeStep(j,w) = (j, (w.val + j.val^3) mod gridSize (3 * n))
uncomputeStep(j,w) =
  (j, (w.val + gridSize (3 * n) - j.val^3) mod gridSize (3 * n))
```

If middle wants the clean-block contract to consume this leaf directly, it
should add a transparent predicate analogous to the arithmetic and rotation
transparent predicates.  That predicate must remain weaker than a unitary
certificate and must not replace the later extraction and unitarity nodes.

## Natural-Language Proof

Claim.  The fixed-denominator modular-add/sub arithmetic returns the workspace
to zero after the payload has been read without modification.

Proof.  Fix `n : Nat` and `j : Fin (gridSize n)`.  Let
`M = gridSize (3 * n)` and `p = j.val ^ 3`.  The existing theorem
`fixedDenomCubicPayload_lt_capacity n j` gives `p < M`, so `p` is a valid
workspace value in `Fin M`.

Starting from clean workspace `0`, the modular-add compute step gives
`(0 + p) mod M = p`, because `p < M`.  The amplitude register value after this
step is `(p : Rat) / (M : Rat)`, which is
`CubicStatePreparation.cubicAmplitude n j` by
`fixedDenomCubicAmplitude_eq n j`.

Assume the controlled rotation reads this workspace value and leaves the
workspace unchanged.  The modular-subtract uncompute step then receives the
same payload `p`.  Its workspace output is `(p + M - p) mod M`.  Natural-number
addition and subtraction give `p + M - p = M`, and `M mod M = 0`.  Therefore
the final workspace is the clean value `0`, and the system index remains `j`
because both arithmetic steps return `j` as the first component.

This proves the local cleanup theorem for the reversible fixed-denominator
lift.  It does not prove clean-block extraction, unitarity, the root
block-encoding certificate, or any executable export.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal target and alpha `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Package fixed-denominator compute semantics as a transparent arithmetic witness. | fixed-denominator backend compute proof | existing Lean | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent` | route-transparent packets | `python3 tools/qbe.py check` | proved; not a route certificate |
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | Feed the transparent controlled-`R_y` scalar-angle predicate into the clean-block contract. | scalar-tier range theorem | existing Lean | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent`, refactored `expandedAmplitudeOracleCleanBlockContract` | conversion window 11:22 update | `python3 tools/qbe.py check` | proved; not a route certificate |
| `DIAG-EXP-UNCOMP-001` | State and prove clean workspace restoration after controlled rotation. | transparent arithmetic and rotation contracts; fixed-denominator representation | current architect packet | opaque target `expandedWorkspaceCleanUncomputed`; proposed transparent reversible cleanup witness | this packet | `python3 tools/qbe.py check` | active parent; direct opaque proof blocked |
| `DIAG-EXP-UNCOMP-REV-LIFT-001` | Define modular-add/sub fixed-denominator cleanup and prove clean-input cleanup. | `fixedDenomCubicPayload_lt_capacity`, `fixedDenomCubicAmplitude_eq`, modular arithmetic facts | next lower Lean worker after middle approval | proposed witness/interface adjacent to `expandedWorkspaceCleanUncomputed` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled rotation reads the arithmetic payload without modifying workspace registers. | rotation route semantics | future lower or middle interface | no current declaration | this packet | `python3 tools/qbe.py check` | blocked internal |
| `DIAG-EXP-BLOCK-001` | Prove the extracted clean block satisfies `diagonalCleanBlockContract n block`. | clean uncompute, extraction semantics | future lower | `expandedAmplitudeOracleCleanBlockExtracts` plus diagonal contract conjunct | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | cleanup, extraction, unitarity/circuit semantics | future lower/reviewer | planned expanded certificate or conditional primitive certificate | candidate population | full project gate | blocked |

Next active leaf for a Lean worker: `DIAG-EXP-UNCOMP-REV-LIFT-001`, but only
after middle accepts the transparent reversible-cleanup interface.  A worker
should not attack `expandedWorkspaceCleanUncomputed n (3 * n)` directly under
the current opaque surface.

## Ordered Lean Lemmas

1. Reuse `fixedDenomCubicPayload_lt_capacity n j` to prove the payload
   `j.val ^ 3` fits in `Fin (gridSize (3 * n))`.
2. Reuse `fixedDenomCubicAmplitude_eq n j` for the amplitude register value
   after clean compute.
3. Add a payload helper, if useful:
   `fixedDenomCubicPayload n j : Fin (gridSize (3 * n))`.
4. Add `fixedDenomCubicComputeStep` as modular addition by the payload on
   `Fin (gridSize (3 * n))`.
5. Add `fixedDenomCubicUncomputeStep` as modular subtraction by the same
   payload.
6. Prove `fixedDenomCubicComputeStep_zero_eq_payload` using
   `Nat.mod_eq_of_lt` and `fixedDenomCubicPayload_lt_capacity`.
7. Prove `fixedDenomCubicUncomputeStep_after_compute_zero` using
   `p + M - p = M` and `Nat.mod_self`.
8. Package these into the approved transparent uncompute witness.  Do not
   derive the opaque predicate unless a separate route-semantics bridge is
   stated.

## Failure Analysis

The diagonal target is still mathematically consistent.  The current
implementation target is blocked because the Lean surface has two gaps:

1. `expandedWorkspaceCleanUncomputed n workspaceQubits` is opaque, so a direct
   proof would require a semantic witness that is not present.
2. `ExpandedCubicArithmeticBackend` records only clean-input compute behavior.
   It does not record a reversible action on arbitrary workspace states or an
   inverse operation.

The fixed-denominator backend's current `compute` field overwrites the
workspace and ignores the input workspace.  That is enough for pointwise
amplitude computation from zero, but it is not a reversible gate-level
semantics.  A clean-uncompute proof should therefore route through a reversible
modular-add/sub lift that has the same clean-input payload and amplitude
projection.

The controlled-rotation transparent predicate also does not state that the
rotation leaves the arithmetic workspace unchanged.  That read-only fact must
be recorded before the cleanup theorem is used as a route-level statement.

Invalid routes: proving the opaque predicate by `trivial`, adding an axiom,
setting a semantic proposition to `True`, switching to rank-one state
preparation, claiming unitarity from the cleanup witness, or preparing
Qiskit/QuantumKatas/QASM3 exports before `DIAG-ROOT-001`.

## Typed Feedback

```text
leaf=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
normalizer_ok=true
unitarity_ok=null
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=middle should approve a transparent reversible clean-uncompute interface with modular-add/sub fixed-denominator witness, plus a read-only controlled-rotation workspace statement; lower Lean should not prove expandedWorkspaceCleanUncomputed directly
```

## Handoff

`DIAG-EXP-UNCOMP-001` should remain a parent node, not a direct tactic target.
The next implementation-sized leaf is a transparent reversible-cleanup witness
for the fixed-denominator workspace: modular add `j.val ^ 3` into
`Fin (gridSize (3 * n))`, let the rotation read the payload without changing
the workspace, then modular subtract the same payload to return to zero.  This
will still not certify extraction, unitarity, the root block encoding, or
executable exports.
