# GHL2025 Proof Export Status

Source paper: Nikita Guseynov, Xiajie Huang, Nana Liu, "Quantum framework for
simulating linear PDEs with Robin boundary conditions", arXiv:2506.20478.

Lean source: `QuantumBlockEncoding/GHL2025.lean`.

Build gate after this export:

```bash
python3 tools/qbe.py check
```

## Compiled Blocks Exported Here

| Block | Main Lean declarations | Status |
|---|---|---|
| Circuit gate-list alignment | `oneTermRobinPlaceholdersMatch` | proved |
| Dimension compatibility | `Examples.RobinHeat.oneTermRobinCircuitDimCompat` | proved |
| Indicator oracle permutation route | `indicatorOracleImage_self_inverse`, `indicatorOracleImage_bijective`, `indicatorOracleMatrix_is_permutation` | proved |
| SWAP first bit-slice route | `swapOracleDiff_lt_two_pow`, `swapOracleDiff_shiftRight_eq_zero`, `swapOracleDiff_shiftLeft_mask_eq_zero`, `swapOracleImage_block1_eq_block2` | proved partial block |
| O_D^BS register-safety route | `bandedSparseAccessPaperAddressInRange_eq_true_of_two_le`, `bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt`, `bandedSparseAccessPaperImage_rowValue_eq`, `bandedSparseAccessPaperImage_odRegisterValue_eq`, `bandedSparseAccessPaperImageNoSpill_eq_true_of_address_lt` | proved executable blocks |
| O_D^BS matrix-entry bridge | `bandedSparseAccessPaperMatrix_imageFin_eq_one`, `bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one`, active gate entry bridge lemmas | proved under explicit hypotheses |
| O_f clean-branch matrix skeleton | `functionOraclePaperMatrix_cleanBranch_entry`, `functionOraclePaperMatrix_cleanWorkspace_offBranch_zero`, `functionOraclePaperMatrix_nonCleanInput_entry` | proved skeleton entries |

## Still Open

The following are still obligations, not proved theorems:

- SWAP full self-inverse, bijection, permutation, and gate unitarity.
- O_D^BS injectivity, inverse-on-range, dagger cleanup, and gate unitarity.
- O_DT^S Eq. (20) coefficient-normalizer relation and rotation unitarity.
- Ry boundary arccos, half-angle, normalizer, and rotation unitarity.
- O_f normalizer bound, orthogonal completion, and unitary extension.
- Final block extraction of the full circuit with normalizer $N_D N_f \kappa$.
