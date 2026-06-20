# Route-Interface Contract: DIAG-ARITH-ROUTE-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

## Source Anchor

The source is the user prompt copied in
`tasks/QBE-OP-CUBIC-DIAGONAL-001.md`.  The object is the diagonal operator
$D_n$ with

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0,
alpha = 1.
```

No paper theorem, figure, or cited external result is active for this leaf.

## Existing Lean Declarations

The selected arithmetic representation is fixed:

```lean
fixedDenomCubicPayload_lt_capacity
fixedDenomCubicAmplitude_eq
fixedDenomCubicArithmeticBackend
fixedDenomCubicArithmeticBackend_computes
fixedDenomCubicArithmeticBackend_bridge_iff
```

The closed backend theorem is:

```lean
fixedDenomCubicArithmeticBackend_computes (n : Nat) :
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

The existing bridge theorem is conditional:

```lean
expandedArithmeticComputesCubicAmplitude_of_backendBridge
```

The existing normal-form theorem is:

```lean
expandedArithmeticBackendBridge_iff_of_computes
```

It shows that direct proof of `expandedArithmeticBackendBridge backend` for a
backend with a pointwise compute proof reduces to the opaque route predicate,
so direct bridge tactic search remains stale.

## Route Leaf

`DIAG-ARITH-ROUTE-INTERFACE-001` was the route-interface leaf under the blocked
parent `DIAG-ARITH-BACKEND-BRIDGE-001`.  Its normal-form target is now closed
as `fixedDenomCubicArithmeticBackend_bridge_iff`.  The active lower target is
`DIAG-ARITH-ROUTE-TRANSPARENT-001`.

The lower packet must compile one transparent arithmetic semantics interface
before another worker attacks the bridge parent.

## Closed Build-Testable Lean Target

The fixed-denominator normal form is now the closed build-testable Lean target:

```lean
theorem fixedDenomCubicArithmeticBackend_bridge_iff
    (n : Nat) :
    expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n) ↔
      expandedArithmeticComputesCubicAmplitude n (3 * n) := by
  exact expandedArithmeticBackendBridge_iff_of_computes
    (fixedDenomCubicArithmeticBackend n)
    (fixedDenomCubicArithmeticBackend_computes n)
```

This theorem is not a route certificate.  It only records the exact remaining
semantic gap for the fixed-denominator backend.

## Next Interface Requirement

After the normal form exists, a real route-semantics interface must provide the
transparent witness without changing the target:

- `expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)`, witnessed
  by `fixedDenomCubicArithmeticBackend n` and
  `fixedDenomCubicArithmeticBackend_computes n`.

This route must preserve the system index `j`, workspace
`Fin (gridSize (3 * n))`, clean workspace `0`, payload `j.val ^ 3`, amplitude
projection `(payload.val : Rat) / (gridSize (3 * n) : Rat)`, and
`exactNormalizer n = 1`.  A later bridge to the existing opaque predicate or a
contract refactor must be a separate named decision.

## Forbidden Routes

Do not:

- redefine the target as rank-one state preparation;
- normalize the diagonal vector;
- reimplement `fixedDenomCubicArithmeticBackend`;
- set a semantic proposition to `True`;
- add an axiom;
- close an opaque proposition with `trivial`;
- attack `DIAG-ROOT-001`; or
- create Qiskit, QuantumKatas-style, or QASM3 exports before a named Lean
  certificate exists.

## Typed Feedback Fields

Use these fields for the next attempt:

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
workspace_representation_specified=true
capacity_lemma_compiled=true
amplitude_eq_lemma_compiled=true
backend_compute_compiled=true
finite_arithmetic_ok=true
finite_register_ok=true
normalizer_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=compile expandedArithmeticComputesCubicAmplitudeTransparent and fixedDenomCubicArithmeticRouteTransparent before any opaque bridge/root/export work
```

## Lower Architect Refinement, 2026-06-20 07:48 JST

### Exact Source Fragment

The source is still the user-provided operator equation, not a paper theorem:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The Lean target is therefore the diagonal matrix
$D_n[row,col] = (row/2^n)^3$ when `row = col`, and $0$ otherwise, with
normalizer `exactNormalizer n = 1`.

### Definitions For The Active Local Theorem

For fixed `n`, let
`B_n = fixedDenomCubicArithmeticBackend n`.  This backend has workspace
`Fin (gridSize (3 * n))`, clean workspace `0`, payload `j.val ^ 3`, and
amplitude projection
`(payload.val : Rat) / (gridSize (3 * n) : Rat)`.

Let

```lean
H_n :=
  expandedArithmeticBackendComputesCubicAmplitude
    (fixedDenomCubicArithmeticBackend n)
```

and let

```lean
R_n := expandedArithmeticComputesCubicAmplitude n (3 * n)
```

The existing Lean theorem `fixedDenomCubicArithmeticBackend_computes n`
proves `H_n`.  The bridge predicate for this backend is definitionally the
function type `H_n -> R_n`.

### Natural-Language Proof Of The Local Normal Form

Claim:

```lean
expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n) ↔
  expandedArithmeticComputesCubicAmplitude n (3 * n)
```

Proof.  In the forward direction, assume
`hBridge : expandedArithmeticBackendBridge (fixedDenomCubicArithmeticBackend n)`.
Apply `hBridge` to the already proved pointwise compute theorem
`fixedDenomCubicArithmeticBackend_computes n`.  The result is exactly
`expandedArithmeticComputesCubicAmplitude n (3 * n)`.

In the reverse direction, assume
`hRoute : expandedArithmeticComputesCubicAmplitude n (3 * n)`.  To prove the
bridge, introduce an arbitrary proof of
`expandedArithmeticBackendComputesCubicAmplitude
  (fixedDenomCubicArithmeticBackend n)` and return `hRoute`.  This proves the
function type required by `expandedArithmeticBackendBridge`.

The proof is already abstracted by
`expandedArithmeticBackendBridge_iff_of_computes`.  The fixed-denominator
specialization is now closed by applying that theorem to
`fixedDenomCubicArithmeticBackend n` and
`fixedDenomCubicArithmeticBackend_computes n`.

This normal form does not prove the route predicate.  It proves that, once the
fixed-denominator pointwise compute theorem is known, a direct bridge proof is
equivalent to the opaque route predicate itself.

### Transparent Route-Semantics Interface

The next honest interface should expose the arithmetic route semantics without
making `expandedArithmeticComputesCubicAmplitude` a semantic flag proved by
`trivial`.  A transparent candidate is:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  ∃ backend : ExpandedCubicArithmeticBackend n workspaceQubits,
    expandedArithmeticBackendComputesCubicAmplitude backend
```

For the fixed-denominator backend, the witness theorem would be:

```lean
theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n) := by
  exact ⟨fixedDenomCubicArithmeticBackend n,
    fixedDenomCubicArithmeticBackend_computes n⟩
```

This is the transparent arithmetic content currently proved by Lean.  It still
does not close the existing opaque route predicate unless middle or upper
chooses one of two explicit contract routes:

- refactor the expanded clean-block contract to use the transparent existential
  predicate; or
- add a named accepted bridge from the transparent existential predicate to
  `expandedArithmeticComputesCubicAmplitude`.

Either route must remain separate from rotation semantics, clean uncompute,
clean-block extraction, unitarity, and executable exports.

### Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target with alpha `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-CAP-001` | Show `j.val ^ 3` fits in the `3 * n` workspace. | `j.isLt`, `gridSize_three_mul_eq_cube` | existing Lean | `fixedDenomCubicPayload_lt_capacity` | fixed-denominator proof packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-ALG-001` | Show the payload projection equals `cubicAmplitude n j`. | capacity lemma, rational algebra | existing Lean | `fixedDenomCubicAmplitude_eq` | fixed-denominator proof packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Define `B_n` and prove its pointwise compute contract. | cap and algebra leaves | existing Lean | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes` | fixed-denominator backend packet | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-ROUTE-NF-001` | Record `expandedArithmeticBackendBridge B_n ↔ R_n`. | backend compute theorem, `expandedArithmeticBackendBridge_iff_of_computes` | lower Lean worker | `fixedDenomCubicArithmeticBackend_bridge_iff` | this section | `python3 tools/qbe.py check` | compiled in current workspace; not a route certificate |
| `DIAG-ARITH-ROUTE-TRANSPARENT-001` | Define and prove the transparent existential arithmetic route predicate for `B_n`. | backend compute theorem | middle contract decision, then lower Lean worker | proposed `expandedArithmeticComputesCubicAmplitudeTransparent`, `fixedDenomCubicArithmeticRouteTransparent` | this section | `python3 tools/qbe.py check` | contract-design leaf |
| `DIAG-ARITH-BACKEND-BRIDGE-001` | Close or explicitly replace the opaque arithmetic route predicate. | route normal form, transparent-route contract decision | future lower worker | `expandedArithmeticBackendBridge`, `expandedArithmeticComputesCubicAmplitude_of_backendBridge` | proof obligations ledger | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-RY-BACKEND-WITNESS-001` | Supply a concrete controlled-`R_y` backend witness. | scalar-tier bridge | future lower worker | `expandedControlledRyBackendBridge` | proof obligations ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-EXP-UNCOMP-001` | Prove clean workspace uncompute. | arithmetic and rotation route witnesses | future lower worker | `expandedWorkspaceCleanUncomputed` | proof obligations ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Package a verified block-encoding certificate. | arithmetic, rotation, uncompute, extraction, unitarity | future lower worker | planned expanded certificate or `primitiveAmplitudeOracleVerified n h` | candidate population | full project gate | blocked |

The normal-form node `DIAG-ARITH-ROUTE-NF-001` is now a compiled memory lemma
in the current workspace.  It prevents future agents from treating the bridge
as a fresh tactic-search problem.  The next route is the contract-design leaf
`DIAG-ARITH-ROUTE-TRANSPARENT-001`, not a retry of the opaque bridge parent.

### Ordered Intermediate Lean Lemmas

1. Reuse `fixedDenomCubicArithmeticBackend_computes n`.
2. Reuse
   `expandedArithmeticBackendBridge_iff_of_computes
      (fixedDenomCubicArithmeticBackend n)
      (fixedDenomCubicArithmeticBackend_computes n)`.
3. Reuse the definition-free theorem
   `fixedDenomCubicArithmeticBackend_bridge_iff`.
4. After a middle or upper contract decision, add the transparent
   existential predicate and fixed-denominator witness theorem sketched above.
5. Do not attempt `expandedArithmeticComputesCubicAmplitude n (3 * n)` directly
   until the transparent predicate is either adopted by the contract or bridged
   by a named, nontrivial route-semantics theorem.

### Failure Analysis

The diagonal target is mathematically consistent with the fixed-denominator
backend.  The current obstruction is not a source-translation failure and not a
finite arithmetic counterexample.  The obstruction is that
`expandedArithmeticComputesCubicAmplitude` is opaque, while the already proved
backend theorem is pointwise.  Since
`expandedArithmeticBackendBridge` is `H_n -> R_n` and `H_n` is proved, direct
bridge search is equivalent to proving `R_n` itself.  Classify repeated direct
bridge attempts as `symbolic_bridge_gap`.

Typed feedback:

```text
leaf=DIAG-ARITH-ROUTE-TRANSPARENT-001
blocked_parent=DIAG-ARITH-BACKEND-BRIDGE-001
source_correspondence_ok=true
normalizer_ok=true
finite_arithmetic_ok=true
finite_register_ok=true
block_entry_ok=null
unitarity_ok=null
ancilla_cleanup_ok=null
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=compile the adopted transparent arithmetic route predicate and fixed-denominator witness; do not retry the now-normalized opaque bridge parent
```

### Current-Workspace Closure Note

During closeout, the shared dialogue recorded that a lower Lean worker closed
`fixedDenomCubicArithmeticBackend_bridge_iff`.  A task-local Lean name check
also finds that declaration in `QuantumBlockEncoding/CubicStatePreparation.lean`.
This changes the next active route: the normal-form memory lemma is no longer
the next Lean leaf.  The remaining arithmetic obstruction is the honest
semantic choice between adopting a transparent route predicate, such as the
existential interface above, or adding a named nontrivial bridge from that
transparent predicate to the existing opaque
`expandedArithmeticComputesCubicAmplitude`.

## Middle Adoption, 2026-06-20 08:12 JST

Middle adopts the transparent existential predicate as the next lower-facing
source contract for `DIAG-ARITH-ROUTE-TRANSPARENT-001`.

The lower Lean worker should add exactly this interface shape in
`QuantumBlockEncoding/CubicStatePreparation.lean`, inside
`namespace CubicDiagonalOracle`:

```lean
def expandedArithmeticComputesCubicAmplitudeTransparent
    (n workspaceQubits : Nat) : Prop :=
  Exists fun backend : ExpandedCubicArithmeticBackend n workspaceQubits =>
    expandedArithmeticBackendComputesCubicAmplitude backend

theorem fixedDenomCubicArithmeticRouteTransparent
    (n : Nat) :
    expandedArithmeticComputesCubicAmplitudeTransparent n (3 * n)
```

The proof should be the existential witness
`fixedDenomCubicArithmeticBackend n` with proof
`fixedDenomCubicArithmeticBackend_computes n`.

This is QBE-local semantic glue for the user-provided diagonal target.  It is
not a cited theorem, not a root block-encoding certificate, and not a proof of
the existing opaque predicate
`expandedArithmeticComputesCubicAmplitude n (3 * n)`.  After the transparent
witness compiles, upper or middle must explicitly choose whether to refactor
the expanded arithmetic contract to use this transparent predicate or add a
named nontrivial bridge to the existing opaque predicate.  Direct bridge
search, rotation backend work, clean uncompute, root certification, and
executable exports remain blocked.
