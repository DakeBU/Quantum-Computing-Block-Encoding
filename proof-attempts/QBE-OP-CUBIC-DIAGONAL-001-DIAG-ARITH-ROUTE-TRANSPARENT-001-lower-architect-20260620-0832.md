# Lower Proof Architect Packet: DIAG-ARITH-ROUTE-TRANSPARENT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`
Role: lower natural-language proof architect
Timestamp: 2026-06-20 08:32 JST

## Source Fragment

The active source is the user-provided operator equation, not a paper theorem:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The Lean target remains the diagonal operator $D_n$ with
$D_n[row,col] = (row/2^n)^3$ when `row = col` and $D_n[row,col] = 0$
otherwise.  The normalizer remains `exactNormalizer n = 1`.

## Definitions

For fixed `n`, the closed fixed-denominator backend is
`fixedDenomCubicArithmeticBackend n :
ExpandedCubicArithmeticBackend n (3 * n)`.

Its workspace is `Fin (gridSize (3 * n))`.  The clean workspace value is `0`.
On input `j : Fin (gridSize n)`, its compute phase preserves `j` and writes
the payload `j.val ^ 3`.  Its distinguished amplitude projection maps a
payload to `(payload.val : Rat) / (gridSize (3 * n) : Rat)`.

The closed pointwise compute theorem is:

```lean
fixedDenomCubicArithmeticBackend_computes (n : Nat) :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

The transparent arithmetic route predicate should be:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend
```

This predicate states only that there exists a concrete backend satisfying the
pointwise arithmetic compute contract at the given workspace size.  It does not
state block-entry correctness, unitarity, clean uncompute, rotation semantics,
or executable export correctness.

## Active Local Theorem

The next Lean worker should prove:

```lean
theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

Natural-language proof.  Choose the witness
`fixedDenomCubicArithmeticBackend n`.  The required proof attached to that
witness is exactly `fixedDenomCubicArithmeticBackend_computes n`.  Therefore
the existential transparent route predicate holds for workspace size `3 * n`.

This theorem is definition-free after the transparent predicate is introduced.
It should compile as:

```lean
  exact ⟨fixedDenomCubicArithmeticBackend n,
    fixedDenomCubicArithmeticBackend_computes n⟩
```

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target with `alpha = 1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | `tasks/QBE-OP-CUBIC-DIAGONAL-001.md` | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Prove `j.val ^ 3 < gridSize (3 * n)`. | `j.isLt`, `gridSize_three_mul_eq_cube` | existing Lean | `fixedDenomCubicPayload_lt_capacity` | fixed-denominator proof packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Prove the fixed-denominator payload projection equals `cubicAmplitude n j`. | capacity leaf, rational algebra | existing Lean | `fixedDenomCubicAmplitude_eq` | fixed-denominator proof packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define the fixed-denominator backend and prove pointwise compute semantics. | capacity and algebra leaves | existing Lean | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes` | backend proof packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-ROUTE-NF-001` | Record that direct bridge search for the fixed backend is equivalent to the opaque route predicate. | backend compute theorem, `expandedArithmeticBackendBridge_iff_of_computes` | existing Lean | `fixedDenomCubicArithmeticBackend_bridge_iff` | route-interface packet | `python3 tools/qbe.py check` | proved normal-form memory, not a route certificate |
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Introduce the transparent existential arithmetic predicate and prove the fixed-denominator witness theorem. | backend compute theorem | lower Lean worker | proposed `expandedArithmeticComputesCubicAmplitudeTransparent`, proposed `fixedDenomCubicArithmeticRouteTransparent` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Close or explicitly replace the existing opaque arithmetic route predicate. | transparent route witness plus an upper or middle contract decision | future lower worker | `expandedArithmeticBackendBridge`, `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | proof-obligations ledger | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete controlled-`R_y` backend witness. | scalar-tier bridge and backend rotation semantics | future lower worker | `expandedControlledRyBackendBridge` | proof-obligations ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-EXP-UNCOMP-001` | Prove clean workspace uncompute. | arithmetic route decision and rotation backend witness | future lower worker | `expandedWorkspaceCleanUncomputed` | proof-obligations ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Package a verified block-encoding certificate. | arithmetic, rotation, uncompute, extraction, unitarity | future lower worker | planned expanded certificate or conditional primitive certificate with a real semantic proof | candidate population | full project gate | blocked |

## Ordered Lean Lemmas

1. Reuse `fixedDenomCubicPayload_lt_capacity`.  This is already proved and
   should not be reassigned.
2. Reuse `fixedDenomCubicAmplitude_eq`.  This is already proved and should not
   be reassigned.
3. Reuse `fixedDenomCubicArithmeticBackend`.  This is the selected backend
   witness and should not be redefined.
4. Reuse `fixedDenomCubicArithmeticBackend_computes`.  This is the proof term
   needed by the transparent existential predicate.
5. Reuse `fixedDenomCubicArithmeticBackend_bridge_iff` only as normal-form
   memory.  It explains why direct opaque bridge search is stale.
6. Add `expandedArithmeticComputesCubicAmplitudeTransparent`.  This is the
   transparent local interface for the arithmetic route.
7. Add `fixedDenomCubicArithmeticRouteTransparent`.  This is the one active
   theorem for the next Lean worker.

## Failure Analysis

The diagonal target is not mathematically wrong.  The fixed-denominator
arithmetic representation is also not the current obstruction: capacity,
payload projection, backend definition, backend compute semantics, and bridge
normal form all compile.

The current obstruction is the route semantics around the opaque predicate
`expandedArithmeticComputesCubicAmplitude n (3 * n)`.  The theorem
`fixedDenomCubicArithmeticBackend_bridge_iff` shows that direct proof of
`expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)` is
equivalent to proving that opaque predicate.  Therefore another direct bridge
attempt is a stale route with `error_class=symbolic_bridge_gap`.

The transparent existential predicate is the honest theorem currently supported
by the closed Lean facts.  It is not equivalent to a block-encoding
certificate, and it must not be counted as closing the opaque route predicate
unless a later named bridge or contract refactor is explicitly adopted and
compiled.

## Typed Verifier Feedback

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
capacity_lemma_compiled=true
amplitude_eq_lemma_compiled=true
backend_compute_compiled=true
normal_form_theorem=fixedDenomCubicArithmeticBackend_bridge_iff
finite_arithmetic_ok=true
finite_register_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
route_certificate_ok=false
closed_theorem_ok=false
lean_parse_ok=null
lean_build_ok=null
error_class=symbolic_bridge_gap
next_route=compile expandedArithmeticComputesCubicAmplitudeTransparent and fixedDenomCubicArithmeticRouteTransparent; keep opaque bridge, root, Ry backend witness, clean uncompute, and exports blocked
```

## Handoff

Lower architect handoff: `DIAG-ARITH-ROUTE-TRANSPARENT-001` is the next active
leaf.  The next Lean edit should add the transparent existential predicate and
the fixed-denominator witness theorem from
`fixedDenomCubicArithmeticBackend_computes`.  Do not retry the opaque bridge,
do not modify the fixed-denominator backend, and do not promote this witness to
root, block-entry, unitarity, ancilla-cleanup, or export certification.
