# BE.Tensor.PassiveRegister

Priority: P0

Source: tensor-product semantics for an active register plus unchanged passive
register.

## Detect When

The operator has the form

$$
A = A_{\mathrm{active}} \otimes I_{\mathrm{passive}}.
$$

## Construction

Prove the active-register construction first.  Lift the finite map or circuit
to the product space by leaving the passive coordinate unchanged.

## Lean Proof Shape

```lean
theorem cleanBlock_liftActive :
  cleanBlock (liftActive U) =
    cleanBlock U tensor I := by
  ext activeRow passiveRow activeCol passiveCol
  simp [liftActive, cleanBlock]
```

For permutation matrices, prove the lifted image theorem:

```lean
liftActive p (aux, active, passive) =
  let (aux', active') := p (aux, active)
  (aux', active', passive)
```

## Proof-DAG Leaves

- active-register clean-block theorem;
- passive-coordinate preservation;
- product-index extensionality;
- identity-entry simplification.

## Resource Notes

Passive registers do not increase gate count unless routing or wire movement is
explicitly modeled.
