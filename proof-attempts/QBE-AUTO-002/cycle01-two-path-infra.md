# Cycle 01: Two-Path Matrix Multiplication Infrastructure

## Completed

### CircuitSemantics.lean additions (lines 224-353)

1. **`foldl_add_extract_init`** (private, line 224): Helper proving
   `ks.foldl (fun acc k => acc + f k) init = init + ks.foldl ... 0`.
   Key insight: the `ring` tactic does not solve Rat associativity directly;
   needed `Rat.add_assoc` explicitly. The `simp only [List.foldl_cons]` then
   `rw [ih, ih (0 + f k)]` then `simp only [Rat.zero_add]` then
   `exact Rat.add_assoc init (f k) _` pattern works.

2. **`foldl_add_two_of_nodup`** (private, line 235): Extracts exactly two
   nonzero terms from a foldl sum. Proved by induction on the list with four
   cases from `rcases hmem0 with rfl | htail0` and `rcases hmem1 with rfl | htail1`.
   Uses `foldl_add_unique_of_nodup` + `foldl_add_extract_init` for the cases
   where one of k0/k1 is at the head.

3. **`evalWith_mul_two_path`** (public, line 328): The reusable two-path
   matrix product reducer. Follows the exact pattern of `evalWith_mul_unique_path`.

### RobinMatrix.lean additions (lines 7538-7621)

1. **`oneTermRobinGamma3BoundaryDaggerRow0_support_n3`** (private, line 7546):
   Dagger row-0 support: `(O_D^BS)^dagger[0, k] = 0` for `k.val ≠ 96`.
   Follows the pattern of `DaggerRow32_support_n3` but uses row 0 and image 96.

2. **`oneTermRobinGamma3BoundarySwapRow96_image_n3`** (private, line 7574):
   `native_decide` fact: `swapOracleImage p 96 = 12`.

3. **`oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3`**
   (public, line 7590): Two-path reduction for `sevenGateMatrix[0,0]`.
   Applies `evalWith_mul_two_path` with `k0 = ⟨96, _⟩` and `k1 = ⟨97, _⟩`,
   using `PrefixCol0Support_n3` to show all other paths vanish.

## Failed routes

- **`foldl_add_add_left` with `(a + 0)` pattern**: The initial attempt used
  `ks.foldl ... (a + 0) = a + ks.foldl ... 0` which fails because the
  actual accumulator after `Rat.zero_add` is `f k0`, not `a + 0`.
  Fixed by using `foldl_add_extract_init` with a general `init` parameter.

- **Flat `rcases` with two separate `rcases hmemX`**: Using two sequential
  `rcases ... with ... | ...` creates 4 flat goals, but the naming of
  hypotheses can be confusing. Switched to nested `rcases hmem0 with rfl | htail0`
  followed by `rcases hmem1` within each branch for clarity and correct scoping.

- **`ring` for Rat**: The `ring` tactic does not always close Rat goals in
  Lean 4. Used `exact Rat.add_comm` and `exact Rat.add_assoc` directly.

- **`simp` with `PrefixCol0Support_n3` directly**: The prefix support lemma
  takes `i.val ≠ 96` and `i.val ≠ 97` as hypotheses (Nat inequalities), not
  Fin inequalities. Need to convert `q ≠ ⟨96, _⟩` to `q.val ≠ 96` via
  `Fin.eq_of_val_eq` before applying.
