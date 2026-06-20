# Lower Architect Packet: DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: lower natural-language proof architect

Updated: 2026-06-20 12:20 JST

Supersession note, 2026-06-20 12:24 JST: while this architect packet was
being recorded, concurrent lower Lean work closed
`DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` as a transparent interface.
The current Lean surface now contains `ExpandedArithmeticCleanUncomputeWitness`,
`expandedWorkspaceCleanUncomputedTransparent`, and
`expandedWorkspaceCleanUncomputedTransparent_of_witness`.  Treat the interface
declaration plan below as historical design support.  The current next Lean
leaf is `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`, with a separate
`DIAG-RY-WORKSPACE-READONLY-001` dependency before any route-level cleanup
claim.

## Source Fragment

There is no paper-source archive for this task.  The active source fragment is
the user-provided diagonal operator:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The translated target remains the diagonal matrix whose entries are

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0,
alpha = 1.
```

The clean-uncompute interface is not a new source equation.  It is QBE-local
route semantics for the expanded arithmetic plus controlled-rotation candidate.
The intended route fragment is:

```text
|j>|0_work>  -- compute payload -->       |j>|p_j>
|j>|p_j>    -- controlled R_y read-only -> |j>|p_j>
|j>|p_j>    -- inverse arithmetic -->      |j>|0_work>
```

Here the fixed-denominator payload is `p_j = j.val ^ 3`, stored in a
`3 * n`-qubit workspace, and the amplitude projection is
`p_j / gridSize (3 * n) = (j / 2^n)^3`.

## Definitions

Fix `n : Nat`.  Let `M = gridSize (3 * n)`.  For
`j : Fin (gridSize n)`, let `p_j = j.val ^ 3`.

The closed fixed-denominator arithmetic declarations are:

```lean
fixedDenomCubicPayload_lt_capacity
    (n : Nat) (j : Fin (gridSize n)) :
    j.val ^ 3 < gridSize (3 * n)

fixedDenomCubicAmplitude_eq
    (n : Nat) (j : Fin (gridSize n)) :
    (j.val : Rat) ^ 3 / (gridSize (3 * n) : Rat) =
      CubicStatePreparation.cubicAmplitude n j

fixedDenomCubicArithmeticBackend
    (n : Nat) :
    ExpandedCubicArithmeticBackend n (3 * n)

fixedDenomCubicArithmeticBackend_computes
    (n : Nat) :
    expandedArithmeticBackendComputesCubicAmplitude
      (fixedDenomCubicArithmeticBackend n)
```

The current cleanup parent is the opaque proposition:

```lean
expandedWorkspaceCleanUncomputed (n workspaceQubits : Nat) : Prop
```

The active leaf must not prove this opaque proposition.  It should add a
transparent witness interface that records the reversible cleanup data needed
for a later non-opaque route.

## Active Local Statement

The implementation-sized Lean leaf is the following interface, placed adjacent
to `expandedWorkspaceCleanUncomputed` in
`QuantumBlockEncoding/CubicStatePreparation.lean`:

```lean
structure ExpandedArithmeticCleanUncomputeWitness
    (n workspaceQubits : Nat) where
  backend : ExpandedCubicArithmeticBackend n workspaceQubits
  computes : expandedArithmeticBackendComputesCubicAmplitude backend
  computeStep :
    Fin (gridSize n) -> backend.Workspace ->
      Prod (Fin (gridSize n)) backend.Workspace
  uncomputeStep :
    Fin (gridSize n) -> backend.Workspace ->
      Prod (Fin (gridSize n)) backend.Workspace
  computeStep_matches_backend_on_clean :
    forall j,
      computeStep j backend.zeroWorkspace =
        backend.compute j backend.zeroWorkspace
  compute_preserves_index :
    forall j w, (computeStep j w).1 = j
  uncompute_preserves_index :
    forall j w, (uncomputeStep j w).1 = j
  uncompute_after_compute :
    forall j w, uncomputeStep j (computeStep j w).2 = (j, w)

def expandedWorkspaceCleanUncomputedTransparent
    (n workspaceQubits : Nat) : Prop :=
  Nonempty (ExpandedArithmeticCleanUncomputeWitness n workspaceQubits)
```

This interface is intentionally weaker than the opaque route predicate and
stronger than a path-only cleanup test.  It requires an explicit backend, a
pointwise compute proof, a compute step, an uncompute step, preservation of the
system index, agreement with the backend on clean input, and an inverse law for
every workspace value.

## Natural-Language Proof

The active leaf is definition-only.  Its mathematical role is to make the
missing reversible cleanup data explicit without certifying the route.

The structure fields are sufficient for the next fixed-denominator witness
because they separate three facts that are currently conflated by the opaque
predicate.  First, the `backend` and `computes` fields tie cleanup to an
already checked arithmetic backend rather than to an unrelated workspace
operation.  Second, `computeStep_matches_backend_on_clean` ensures that the
explicit reversible step agrees with the existing clean-input backend
semantics used to compute `CubicStatePreparation.cubicAmplitude n j`.  Third,
`uncompute_after_compute` rules out a fake constant workspace eraser: the
uncompute step must invert the compute step for every workspace value.

For the later fixed-denominator instantiation, use workspace
`Fin (gridSize (3 * n))`.  Define `computeStep` as modular addition by
`p_j = j.val ^ 3` and define `uncomputeStep` as modular subtraction by the same
payload.  The capacity theorem `fixedDenomCubicPayload_lt_capacity n j` proves
that clean compute stores a valid payload, and
`fixedDenomCubicAmplitude_eq n j` proves that the payload projection is the
cubic grid amplitude.  The modular inverse proof then shows that
`uncomputeStep j (computeStep j w).2 = (j, w)` for every workspace value `w`.

This proof does not state that the controlled `R_y` operation preserves the
workspace.  That is a separate route-semantics dependency,
`DIAG-RY-WORKSPACE-READONLY-001`.  Route-level clean uncompute cannot close
until that dependency is stated or proved.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal target and alpha `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Package fixed-denominator arithmetic compute semantics as a transparent witness. | `fixedDenomCubicArithmeticBackend_computes` | existing Lean | `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent` | route-transparent packets | `python3 tools/qbe.py check` | proved; not a route certificate |
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | Feed the transparent controlled-`R_y` scalar-angle predicate into the clean-block contract. | `expandedRyCleanEntryForCubicAmplitudes_of_standardTier` | existing Lean | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent`, refactored `expandedAmplitudeOracleCleanBlockContract` | conversion window 11:22 update | `python3 tools/qbe.py check` | proved; not a route certificate |
| `DIAG-EXP-UNCOMP-001` | Route-level clean uncompute after compute and controlled rotation. | transparent arithmetic and rotation contracts; fixed-denominator representation; rotation workspace-readonly semantics | middle/source-correspondence | opaque target `expandedWorkspaceCleanUncomputed` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked parent; do not attack directly |
| `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` | Introduce transparent reversible cleanup witness data without proving the opaque predicate. | `ExpandedCubicArithmeticBackend`, `expandedArithmeticBackendComputesCubicAmplitude` | next lower Lean worker | proposed `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent` | this packet and middle 12:16 coordinator packet | `python3 tools/qbe.py check` | active leaf |
| `DIAG-EXP-UNCOMP-REV-LIFT-001` | Instantiate the transparent interface for fixed-denominator modular add/sub cleanup. | transparent cleanup interface; `fixedDenomCubicPayload_lt_capacity`; `fixedDenomCubicAmplitude_eq`; modular arithmetic facts | future lower Lean worker | future witness of `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` | lower architect packet 11:34 plus this packet | `python3 tools/qbe.py check` | next subleaf after interface compiles |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that the controlled rotation reads the arithmetic payload without modifying workspace registers. | rotation route semantics | future middle/lower interface | no current declaration | this packet | `python3 tools/qbe.py check` | blocked internal dependency |
| `DIAG-EXP-BLOCK-001` | Prove the extracted clean block satisfies `diagonalCleanBlockContract n block`. | cleanup, extraction semantics | future lower worker | `expandedAmplitudeOracleCleanBlockExtracts`; diagonal conjunct in `expandedAmplitudeOracleCleanBlockContract` | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | cleanup, extraction, unitarity/circuit semantics | future lower/reviewer | planned expanded certificate or conditional primitive certificate | candidate population | full project gate | blocked |

Next active leaf for a Lean worker after the concurrent Lean update:
`DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001`.  The interface leaf in this packet
is now closed in Lean and should not be reassigned.

## Ordered Lean Lemmas And Declarations

1. Reuse the now-compiled `ExpandedArithmeticCleanUncomputeWitness` interface,
   plus `ExpandedCubicArithmeticBackend` and
   `expandedArithmeticBackendComputesCubicAmplitude`; do not duplicate the
   backend or cleanup records.
2. For the fixed-denominator witness, reuse `fixedDenomCubicArithmeticBackend n`
   and `fixedDenomCubicArithmeticBackend_computes n` as the witness backend
   and compute proof.
3. Define modular add/sub steps on `Fin (gridSize (3 * n))` and prove the
   inverse law using `fixedDenomCubicPayload_lt_capacity`,
   `Nat.mod_eq_of_lt`, natural-number subtraction lemmas, and `Nat.mod_self`.
4. State or prove the separate `DIAG-RY-WORKSPACE-READONLY-001` dependency
   before using the witness for route-level cleanup.
5. Keep `expandedWorkspaceCleanUncomputed`, clean-block extraction, unitarity,
   `DIAG-ROOT-001`, and executable exports blocked until middle selects a
   nontrivial bridge or contract refactor.

Historical interface declaration order, now closed by concurrent Lean work:

1. Reuse `ExpandedCubicArithmeticBackend` and
   `expandedArithmeticBackendComputesCubicAmplitude`; do not duplicate the
   backend record.
2. Add `structure ExpandedArithmeticCleanUncomputeWitness
   (n workspaceQubits : Nat)` adjacent to `expandedWorkspaceCleanUncomputed`.
3. Add `def expandedWorkspaceCleanUncomputedTransparent
   (n workspaceQubits : Nat) : Prop := Nonempty
   (ExpandedArithmeticCleanUncomputeWitness n workspaceQubits)`.
4. Do not instantiate the fixed-denominator modular add/sub witness in this
   leaf.
5. For the next leaf, reuse `fixedDenomCubicArithmeticBackend n` and
   `fixedDenomCubicArithmeticBackend_computes n` as the witness backend and
   compute proof.
6. For the next leaf, define modular add/sub steps on
   `Fin (gridSize (3 * n))` and prove the inverse law using
   `fixedDenomCubicPayload_lt_capacity`, `Nat.mod_eq_of_lt`, natural-number
   subtraction lemmas, and `Nat.mod_self`.
7. Keep `expandedWorkspaceCleanUncomputed`, clean-block extraction, unitarity,
   `DIAG-ROOT-001`, and executable exports blocked until middle selects a
   nontrivial bridge or contract refactor.

## Failure Analysis

The current target is mathematically consistent, but route-level cleanup is
not ready for a direct Lean proof.

The first blocker is that `expandedWorkspaceCleanUncomputed` is opaque.  A
direct proof would need a route-semantics witness that the current Lean surface
does not expose.  Proving it by `trivial`, by an axiom, or by changing the
semantic proposition would hide the gap.

The second blocker is that `fixedDenomCubicArithmeticBackend` records only the
clean-input compute behavior used for amplitude calculation.  It does not
record an inverse arithmetic operation on arbitrary workspace states.  The
transparent witness interface fixes that shape gap without changing the user
operator or promoting the route to a certificate.

The third blocker is independent: the route-level cleanup proof also needs a
statement that the controlled `R_y` substep reads the workspace and leaves it
unchanged.  The transparent rotation predicate records scalar angle
bookkeeping only, so `DIAG-RY-WORKSPACE-READONLY-001` remains a separate
dependency.

The finite xor cleanup diagnostic must not be cited as evidence for the exact
modular add/sub witness.  It remains useful generic support that cleanup is
plausible, but the next fixed-denominator witness needs either its own Lean
proof or a matching finite modular add/sub diagnostic.

## Typed Feedback

```text
leaf=DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=true
lean_build_ok=true
finite_matrix_ok=true
finite_mod_add_sub_cleanup_ok=null
rotation_workspace_readonly_ok=null
finite_xor_diagnostic_reused_for_mod_add_sub=false
normalizer_ok=true
block_entry_ok=null
ancilla_cleanup_ok=null
unitarity_ok=null
clean_block_extraction_ok=null
closed_interface_ok=true
closed_theorem_ok=false
route_certificate_ok=false
error_class=symbolic_bridge_gap
next_route=retire the transparent interface leaf; instantiate the
  fixed-denominator modular add/sub witness for
  expandedWorkspaceCleanUncomputedTransparent n (3 * n), and separately state
  rotation workspace-readonly semantics before any route-level cleanup bridge
```
