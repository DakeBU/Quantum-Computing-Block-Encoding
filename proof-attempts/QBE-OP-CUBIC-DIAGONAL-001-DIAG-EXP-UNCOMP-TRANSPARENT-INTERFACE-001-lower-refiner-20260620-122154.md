# Lower Refiner Attempt: DIAG-EXP-UNCOMP-TRANSPARENT-INTERFACE-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Mode: `exploratoryConstruction`

Role: lower Lean refiner/reducer

Updated: 2026-06-20 12:21 JST

## Failed Theorem And Rejected Route

The blocked parent theorem remains:

```lean
expandedWorkspaceCleanUncomputed n (3 * n)
```

No new Lean parser error was produced in this pass.  The rejected route is the
previous direct closure attempt for the opaque cleanup predicate, including any
attempt to close it by `trivial`, by an axiom, by reusing the xor finite
diagnostic as modular add/sub evidence, or by treating clean-input compute
semantics as inverse cleanup semantics.

The precise route error is a shape/register gap: the current source-aligned
route still needs explicit inverse arithmetic data and a separate statement
that the controlled rotation reads the arithmetic workspace without modifying
it.

## Refiner Patch

The current Lean surface already contained the transparent witness interface:

```lean
ExpandedArithmeticCleanUncomputeWitness
expandedWorkspaceCleanUncomputedTransparent
```

This pass added the small constructor lemma:

```lean
expandedWorkspaceCleanUncomputedTransparent_of_witness
```

It packages any future concrete
`ExpandedArithmeticCleanUncomputeWitness n workspaceQubits` as a proof of
`expandedWorkspaceCleanUncomputedTransparent n workspaceQubits`.  It does not
instantiate the fixed-denominator modular add/sub witness, does not prove the
opaque predicate `expandedWorkspaceCleanUncomputed`, and does not change the
expanded clean-block contract.

## Verdict

Keep the patch.  It is a narrow proof-reduction helper for the next modular
add/sub cleanup witness route.

Next route: instantiate `ExpandedArithmeticCleanUncomputeWitness` for the
fixed-denominator modular add/sub route and separately record/prove rotation
workspace-readonly semantics before any bridge to the opaque cleanup predicate
or contract refactor is attempted.

Gate:

```bash
python3 tools/qbe.py check
```

passed, including `lake build` and `lake build Tests`.
