# Lower Architect Packet: DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: lower natural-language proof architect

Updated: 2026-06-20 13:05 JST

## Source Fragment

There is no paper-source archive for this task.  The active source fragment is
the user-provided diagonal operator:

```text
O = sum_{j=0}^{2^n-1} f(x_j) |j><j|,
f(x) = x^3,
x_j = j / 2^n.
```

The translated target remains

```text
D_n[row, col] = if row = col then (row / 2^n)^3 else 0,
alpha = 1.
```

The present leaf is not a new source equation.  It is route semantics for the
expanded arithmetic candidate.  The fixed-denominator cleanup fragment is:

```text
|j>|w>        -- computeStep -->   |j>|(w + j^3) mod 2^(3n)>
|j>|w + j^3> -- uncomputeStep --> |j>|w>
```

The controlled rotation is only a read of the payload in this packet.  A named
Lean statement for that read-only behavior is the separate leaf
`DIAG-RY-WORKSPACE-READONLY-001`.

## Definitions

Fix `n : Nat`.  Let `M = gridSize (3 * n)` and let
`W = Fin M`.  For `j : Fin (gridSize n)`, define the payload
`p_j = j.val ^ 3`.

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

Use `backend := fixedDenomCubicArithmeticBackend n`.  Define the cleanup steps
for the witness by modular add and modular subtract:

```lean
computeStep j w =
  (j, ⟨(w.val + j.val ^ 3) % gridSize (3 * n), _⟩)

uncomputeStep j w =
  (j, ⟨(w.val + (gridSize (3 * n) - j.val ^ 3)) %
        gridSize (3 * n), _⟩)
```

The subtraction form with `gridSize (3 * n) - j.val ^ 3` is equivalent to the
middle packet's `(w + gridSize (3 * n) - j.val ^ 3) mod gridSize (3 * n)`
because `j.val ^ 3 < gridSize (3 * n)`.

## Active Local Theorem

The Lean worker should instantiate:

```lean
def fixedDenomExpandedArithmeticCleanUncomputeWitness
    (n : Nat) :
    ExpandedArithmeticCleanUncomputeWitness n (3 * n)

theorem fixedDenomWorkspaceCleanUncomputedTransparent
    (n : Nat) :
    expandedWorkspaceCleanUncomputedTransparent n (3 * n)
```

The theorem should be a direct application of
`expandedWorkspaceCleanUncomputedTransparent_of_witness`.

## Natural-Language Proof

The witness backend is `fixedDenomCubicArithmeticBackend n`, and its compute
proof is `fixedDenomCubicArithmeticBackend_computes n`.  Thus the only new
proof work is the modular cleanup part of the structure.

For clean-input compatibility, take `j : Fin (gridSize n)`.  The clean
workspace of the fixed-denominator backend has value `0`.  The payload capacity
lemma gives `p_j < M`.  Therefore `(0 + p_j) % M = p_j` by
`Nat.mod_eq_of_lt`.  After unfolding `fixedDenomCubicArithmeticBackend`, the
computed pair is exactly `(j, ⟨p_j, fixedDenomCubicPayload_lt_capacity n j⟩)`.
Use `Fin.ext` if the proof term for the upper bound differs.

The system-index preservation fields are immediate from the definitions of
`computeStep` and `uncomputeStep`, since both return `j` as the first
component.

For the inverse law, prove the reusable natural-number lemma:

```lean
lemma fixedDenom_mod_add_sub_right_inverse
    {M w p : Nat} (hM : 0 < M) (hw : w < M) (hp : p < M) :
    (((w + p) % M + (M - p)) % M) = w
```

Split on `w + p < M`.

In the non-wrapping branch, `Nat.mod_eq_of_lt` rewrites
`(w + p) % M` to `w + p`.  Since `p <= M`, arithmetic rewrites
`w + p + (M - p)` to `w + M`.  The congruence
`(w + M) % M = w` follows from `Nat.add_mod`, `Nat.mod_self`, and
`Nat.mod_eq_of_lt hw`.

In the wrapping branch, `M <= w + p`.  Since `w < M` and `p < M`, also
`w + p < M + M`.  Use `Nat.mod_eq_sub_mod` followed by `Nat.mod_eq_of_lt` to
rewrite `(w + p) % M` to `w + p - M`.  Arithmetic then rewrites
`w + p - M + (M - p)` to `w`, and `Nat.mod_eq_of_lt hw` closes the branch.

Applying this lemma with `M = gridSize (3 * n)`, `w = w.val`, and
`p = j.val ^ 3` proves

```lean
uncomputeStep j (computeStep j w).2 = (j, w)
```

after `Fin.ext`.  The required positivity input is
`CubicStatePreparation.gridSize_pos (3 * n)`, the workspace bound is `w.isLt`,
and the payload bound is `fixedDenomCubicPayload_lt_capacity n j`.

This closes only the transparent witness
`expandedWorkspaceCleanUncomputedTransparent n (3 * n)`.  It does not prove
the opaque route predicate `expandedWorkspaceCleanUncomputed`, does not prove
that the controlled rotation is workspace-read-only in Lean, and does not prove
clean-block extraction, unitarity, the root certificate, or any executable
export.

## Proof-DAG Table

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `DIAG-TGT-001` | Define the diagonal cubic target and alpha `1`. | none | existing Lean | `cubicDiagonalOperator`, `cubicDiagonalTarget`, `exactNormalizer` | task packet and conversion window | `python3 tools/qbe.py check` | proved |
| `DIAG-ARITH-FIXED-DENOM-BACKEND-001` | Fixed-denominator backend computes `CubicStatePreparation.cubicAmplitude n j` on clean workspace. | capacity and algebra leaves | existing Lean | `fixedDenomCubicArithmeticBackend`, `fixedDenomCubicArithmeticBackend_computes` | fixed-denominator proof packets | `python3 tools/qbe.py check` | proved |
| `DIAG-RY-TRANSPARENT-CONTRACT-001` | The clean-block contract consumes transparent controlled-`R_y` scalar-angle bookkeeping. | scalar-tier theorem | existing Lean | `expandedControlledRyUsesCubicAngleTransparent`, `fixedDenomControlledRyRouteTransparent`, refactored `expandedAmplitudeOracleCleanBlockContract` | conversion window | `python3 tools/qbe.py check` | proved; not route-level read-only semantics |
| `DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001` | Record explicit cleanup witness data without proving the opaque route predicate. | `ExpandedCubicArithmeticBackend`, pointwise compute contract | existing Lean | `ExpandedArithmeticCleanUncomputeWitness`, `expandedWorkspaceCleanUncomputedTransparent`, `expandedWorkspaceCleanUncomputedTransparent_of_witness` | proof attempt 20260620-1220 | `python3 tools/qbe.py check` | proved interface-only |
| `DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001` | Instantiate `expandedWorkspaceCleanUncomputedTransparent n (3 * n)` using fixed-denominator modular add/sub cleanup. | transparent cleanup interface; fixed-denominator backend; `fixedDenomCubicPayload_lt_capacity`; modular arithmetic lemma | lower Lean worker | planned `fixedDenomExpandedArithmeticCleanUncomputeWitness`, `fixedDenomWorkspaceCleanUncomputedTransparent` | this packet | `python3 tools/qbe.py check` | next active leaf |
| `DIAG-RY-WORKSPACE-READONLY-001` | State that controlled rotation reads the payload and preserves system/workspace registers. | transparent rotation bookkeeping; route register semantics | future middle/lower | no current declaration | middle memory packet 20260620-1254 | `python3 tools/qbe.py check` | blocked internal dependency |
| `DIAG-EXP-UNCOMP-001` | Route-level clean uncompute after compute, rotation, and inverse arithmetic. | fixed-denominator transparent cleanup witness plus rotation workspace-readonly semantics | future lower | opaque `expandedWorkspaceCleanUncomputed` or a future transparent contract refactor | proof-obligation ledger | `python3 tools/qbe.py check` | blocked parent |
| `DIAG-EXP-BLOCK-001` | Extract a clean block satisfying `diagonalCleanBlockContract n block`. | route cleanup, extraction semantics | future lower | `expandedAmplitudeOracleCleanBlockExtracts`; diagonal conjunct in contract | proof-obligation ledger | `python3 tools/qbe.py check` | blocked |
| `DIAG-ROOT-001` | Exact block-encoding certificate for the diagonal operator. | extraction, unitarity, resource certificate | future lower/reviewer | planned expanded certificate or conditional primitive certificate | candidate population | full project gate | blocked |

## Ordered Lean Lemmas

1. Reuse `fixedDenomCubicArithmeticBackend n` as the witness backend.
2. Reuse `fixedDenomCubicArithmeticBackend_computes n` as the witness compute
   proof.
3. Prove the helper lemma
   `fixedDenom_mod_add_sub_right_inverse`, or an equivalent local theorem,
   using `Nat.mod_eq_of_lt`, `Nat.mod_eq_sub_mod`, `Nat.add_mod`,
   `Nat.mod_self`, and `omega`.
4. Define `fixedDenomExpandedArithmeticCleanUncomputeWitness n` with modular
   add/sub steps on `Fin (gridSize (3 * n))`.
5. Prove `computeStep_matches_backend_on_clean` by unfolding the backend and
   using `fixedDenomCubicPayload_lt_capacity n j`.
6. Prove both index-preservation fields by `rfl` or one-step simplification.
7. Prove `uncompute_after_compute` using
   `fixedDenom_mod_add_sub_right_inverse`, `w.isLt`,
   `fixedDenomCubicPayload_lt_capacity n j`, and `Fin.ext`.
8. Derive `fixedDenomWorkspaceCleanUncomputedTransparent n` using
   `expandedWorkspaceCleanUncomputedTransparent_of_witness`.

Do not use `fixedDenomCubicArithmeticBackend_bridge_iff` or
`expandedControlledRyBackendBridge_iff_of_standardTier` for this leaf.  Those
normal forms route back to opaque predicates and are stale for the current
cleanup witness.

## Failure Analysis

The active fixed-denominator transparent witness is mathematically well-shaped.
It preserves the diagonal target because it reuses the backend whose amplitude
projection is already proved by `fixedDenomCubicAmplitude_eq`.  It also keeps
the normalizer at `alpha = 1`.

This leaf still cannot close route-level cleanup.  The missing dependency is a
named Lean statement that the controlled `R_y` step reads the payload and does
not alter the workspace or system index.  The finite diagnostic has checked a
read-only model, but no Lean declaration currently records it.  Therefore a
later worker must state or prove `DIAG-RY-WORKSPACE-READONLY-001` before any
contract refactor or bridge can honestly consume the transparent cleanup
witness as route-level cleanup.

The leaf also must not be used to close `expandedWorkspaceCleanUncomputed` by
`trivial`, by an axiom, or by changing an opaque semantic proposition.  The
root block-encoding certificate and executable exports remain blocked.

## Typed Feedback

```text
leaf=DIAG-EXP-UNCOMP-FIXED-DENOM-WITNESS-001
blocked_parent=DIAG-EXP-UNCOMP-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_mod_add_sub_cleanup_ok=true
rotation_workspace_readonly_ok=finite-model-only
lean_rotation_workspace_readonly_statement_present=false
block_entry_ok=null
clean_block_extraction_ok=null
unitarity_ok=null
normalizer_ok=true
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=Lean worker should instantiate fixedDenomExpandedArithmeticCleanUncomputeWitness and fixedDenomWorkspaceCleanUncomputedTransparent; separately state DIAG-RY-WORKSPACE-READONLY-001 before any route-level cleanup bridge or extraction proof.
```
