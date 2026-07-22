import QuantumBlockEncoding
import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

set_option linter.hashCommand false
set_option linter.style.longLine false
set_option verso.blueprint.externalCode.strictResolve true

#doc (Manual) "Reusable block-encoding routes" =>
%%%
file := "routes"
%%%

Construction routes are proof patterns, not labels inferred from a matrix alone. Each route names
the access model, normalization, cleanup requirement, and final reusable Lean leaf.

:::theorem "permutation clean-entry bridge" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry")
For a finite map $`p`, the permutation-matrix entry selected by an embedding $`e` is
$$`U(e(i),e(j))=\begin{cases}1,&e(i)=p(e(j)),\\0,&\text{otherwise.}\end{cases}`
Concrete tasks reduce their block proof to a finite image calculation.
:::

:::theorem "permutation target extensionality" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry") (uses := "permutation clean-entry bridge")
If the finite image formula agrees with a target $`A` at every pair of system indices, the whole
selected block is pointwise equal to $`A`.
:::

:::definition "partial-permutation route" (lean := "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate") (uses := "permutation target extensionality")
An embedding, a finite image map, a target matrix, and the entry theorem compile into an exact
clean-block certificate. This is the preferred route for matrix units, projectors, resets on a
subspace, and partial injections when the completion is explicit.
:::

:::definition "one-sparse certificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate")
The one-sparse interface packages a support map and the proof that all target entries reduce to
the corresponding Kronecker-delta support. It is appropriate when each column has at most one
possible nonzero row.
:::

:::definition "sparse-column and row-column routes" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate, QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate")
Sparse certificates expose the finite slot sum that must collapse. They do not assume uniqueness:
the task must supply the no-hit or unique-hit proof and, for the general route, correct row and
column access.
:::

:::definition "value-to-amplitude contract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract")
A reversible value oracle may feed a controlled rotation only when the amplitude entry and
workspace cleanup are both proved. The record prevents compute-rotate-uncompute from hiding a
dirty ancilla.
:::

:::definition "LCU certificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate")
At the arithmetic layer, an LCU certificate stores the extracted clean block, target, normalizer,
term count, and pointwise equality. PREPARE-SELECT semantics must be proved before a physical
circuit is identified with this arithmetic object.
:::

:::theorem "two-term LCU arithmetic" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry") (uses := "LCU certificate")
Once both input blocks are certified, the two-term constructor proves each output entry equals
$$`w_L A_L(i,j)+w_R A_R(i,j).`
The normalizer and term count are carried by the certificate.
:::

:::theorem "product congruence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise") (uses := "exact clean-block certificate")
Pointwise-equal component matrices remain pointwise equal after finite matrix multiplication.
This is the common compiled leaf for product composition after the embedded blocks have been
extracted.
:::

:::definition "exact product adapter" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate") (uses := "product congruence")
Two exact clean-block packages are promoted to the arithmetic interface and combined into a
certificate for the product of their targets. Circuit depth and gate counts require separate
resource proofs.
:::

:::definition "Hermitian dilation contract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract")
A non-Hermitian input is converted to a named doubled target with an explicit entry formula. The
record exists to prevent later polynomial-transform arguments from silently assuming Hermiticity.
:::

:::definition "QSVT consumer contract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract") (uses := "exact clean-block certificate")
QSVT is downstream of a proved input block. The consumer record cannot be formed without that
certificate and explicit polynomial side conditions; it is not a shortcut for constructing the
original data-loading oracle.
:::

:::theorem "exact-to-approximate clean-block adapter" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound") (uses := "exact clean-block certificate")
Every exact clean-block certificate supplies a zero-error incumbent for approximate search at the
same semantic layer. A stronger operator-norm statement still requires its named norm bridge.
:::
