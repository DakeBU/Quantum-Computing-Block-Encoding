# Verifier Feedback: DIAG-EXPANDED-CONTRACT-001

Task: `QBE-OP-CUBIC-DIAGONAL-001`

Leaf: `DIAG-EXPANDED-CONTRACT-001`

Diagnostic artifact:
`verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/expanded_controlled_ry_check.py`

JSON feedback:
`verifier-feedback/QBE-OP-CUBIC-DIAGONAL-001/DIAG-EXPANDED-CONTRACT-001.expanded-controlled-ry.feedback.json`

## Necessary Condition

The active leaf asks for the expanded reversible-arithmetic plus controlled
`R_y` route.  A necessary condition for that route is that, after compute,
controlled rotation, and uncompute, the clean `(signal=0, workspace=0)` block
is exactly the diagonal matrix

```text
D_n[row,col] = if row = col then (row / 2^n)^3 else 0.
```

For the selected standard rotation convention

```text
R_y(theta) = [[cos(theta/2), -sin(theta/2)],
              [sin(theta/2),  cos(theta/2)]],
```

the required angle is

```text
theta_j = 2 arccos((j / 2^n)^3).
```

Then the clean signal entry is `cos(theta_j / 2) = (j / 2^n)^3`.

## Finite Check

The diagnostic checks `n = 1, 2, 3, 4` with workspace dimension `2^n`.  It
models the reversible compute/uncompute skeleton as an XOR permutation on the
workspace:

```text
|j, signal, w> -> |j, signal, w xor j>
```

then applies `R_y(theta_w)` controlled by the computed workspace value, then
applies the same permutation again to uncompute.  This is only a
contract-level finite diagnostic.  A concrete arithmetic circuit and Lean
declaration are still open obligations.

Checked conditions:

- `source_correspondence_ok=true`: the tested clean block is the user-specified
  cubic diagonal operator with `alpha=1`.
- `finite_matrix_ok=true`: diagonal entries are `(j / 2^n)^3`, off-diagonal
  entries vanish, and entries lie in `[0,1]`.
- `block_entry_ok=true`: the extracted clean block equals the target matrix in
  the checked instances.
- `unitarity_ok=true`: every selected standard `R_y(theta_j)` block is unitary,
  and the finite compute/rotate/uncompute operator has orthonormal basis
  images.
- `ancilla_cleanup_ok=true`: clean input workspace `0` returns only workspace
  `0`, and the abstract route preserves system/workspace support after
  uncompute.
- `normalizer_ok=true`: the exact normalizer remains `1`.

Maximum observed clean-block error was `1.1102230246251565e-16`; maximum
observed full-route unitarity error was `2.220446049250313e-16`.

## Typed Feedback

```text
leaf=DIAG-EXPANDED-CONTRACT-001
source_correspondence_ok=true
lean_parse_ok=null
lean_build_ok=null
finite_matrix_ok=true
block_entry_ok=true
ancilla_cleanup_ok=true
normalizer_ok=true
unitarity_ok=true
closed_theorem_ok=false
error_class=symbolic_bridge_gap
next_route=Use the expanded-route interface/bridge if present, then prove or instantiate the concrete backend obligations expandedArithmeticComputesCubicAmplitude, expandedControlledRyUsesCubicAngle, expandedWorkspaceCleanUncomputed, and expandedAmplitudeOracleCleanBlockExtracts before packaging an expanded candidate.
```

## Rejection Status

No finite/path/support contradiction was found for the expanded route.  This
does not close a theorem and must not be used as a Lean certificate.  The
retired exact standard `Rat` one-signal/no-workspace primitive route remains
parked; this diagnostic checks the expanded workspace route only.

## Current Lean Surface Note

A concurrent Lean worker compiled the expanded-route interface/bridge around
`expandedAmplitudeOracleSemanticContract_cleanBlock_eq_target`.  This finite
diagnostic remains feedback only: it supports the current route shape, while
the concrete backend obligations named above still need proof or an explicit
accepted contract before any expanded candidate is packaged or exported.
