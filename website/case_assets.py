"""Editable quantikz schematics for the certified case-study stages.

These are deliberately grouped-register views.  Primitive gate lists remain in
the executable exports and Lean declarations named by each case page.
"""

from __future__ import annotations


STAGE_CIRCUITS: dict[str, dict[str, str]] = {
    "pauli-x-state-preparation": {
        "X candidate": r"""\begin{quantikz}[column sep=.55cm]
\lstick{$\ket0$} & \gate{X} & \rstick{$\ket1$} \qw
\end{quantikz}""",
    },
    "hadamard-plus-state-preparation": {
        "Hadamard candidate": r"""\begin{quantikz}[column sep=.55cm]
\lstick{$\ket0$} & \gate{H} & \rstick{$\ket+ $} \qw
\end{quantikz}""",
    },
    "bell-state-preparation": {
        "Bell RY+CNOT": r"""\begin{quantikz}[row sep=.4cm,column sep=.55cm]
\lstick{$q_0:\ket0$} & \gate{R_y(\pi/2)} & \ctrl{1} & \qw \\
\lstick{$q_1:\ket0$} & \qw & \targ{} & \qw
\end{quantikz}""",
    },
    "mottonen-dense-state-preparation": {
        "Dense UCRY tree": r"""\begin{quantikz}[row sep=.4cm,column sep=.55cm]
\lstick{$q_0:\ket0$} & \qw & \gate{\mathrm{UCRY}_{q_1}(3/5,4/5;5/13,12/13)} & \qw \\
\lstick{$q_1:\ket0$} & \gate{R_y(2\arccos(5/13))} & \ctrl{-1} & \qw
\end{quantikz}""",
    },
    "grover-rudolph-product-state-preparation": {
        "Generic binary tree": r"""\begin{quantikz}[row sep=.4cm,column sep=.55cm]
\lstick{$q_0:\ket0$} & \qw & \gate{\mathrm{UCRY}_{q_1}(3/5,4/5)} & \qw \\
\lstick{$q_1:\ket0$} & \gate{R_y(2\arccos(3/5))} & \ctrl{-1} & \qw
\end{quantikz}""",
        "Factorized product route": r"""\begin{quantikz}[row sep=.4cm,column sep=.55cm]
\lstick{$q_0:\ket0$} & \gate{R_y(2\arccos(3/5))} & \qw \\
\lstick{$q_1:\ket0$} & \gate{R_y(2\arccos(3/5))} & \qw
\end{quantikz}""",
    },
    "sparse-three-state-preparation": {
        "Dense three-qubit tree": r"""\begin{quantikz}[row sep=.38cm,column sep=.42cm]
\lstick{$q_0:\ket0$} & \qw & \qw & \gate{\mathrm{UCRY}_{0}(0)} & \qw \\
\lstick{$q_1:\ket0$} & \qw & \gate{\mathrm{UCRY}_{q_2}(3/5,4/5;1,0)} & \ctrl{-1} & \qw \\
\lstick{$q_2:\ket0$} & \gate{R_y(2\arccos(5/13))} & \ctrl{-1} & \ctrl{-2} & \qw
\end{quantikz}""",
        "Sparse pruned tree": r"""\begin{quantikz}[row sep=.38cm,column sep=.5cm]
\lstick{$q_0:\ket0$} & \qw & \qw & \qw \\
\lstick{$q_1:\ket0$} & \qw & \gate{\mathrm{UCRY}_{q_2}(3/5,4/5;1,0)} & \qw \\
\lstick{$q_2:\ket0$} & \gate{R_y(2\arccos(5/13))} & \ctrl{-1} & \qw
\end{quantikz}""",
    },
    "be-case-1-champion": {
        "Depth-5 completion": r"""\begin{quantikz}[row sep=.35cm, column sep=.3cm]
\lstick{$a:\ket0$} & \gate{X} & \ctrl{1} & \ctrl{2} & \targ{} & \qw \\
\lstick{$t$}        & \qw      & \targ{}  & \qw      & \ctrl{-1}& \qw \\
\lstick{$y$}        & \qw      & \qw      & \targ{}  & \ctrl{-2}& \qw \\
\lstick{$s$}        & \qw      & \qw      & \qw      & \qw      & \qw
\end{quantikz}""",
        "Equality-transfer": r"""\begin{quantikz}[row sep=.35cm, column sep=.4cm]
\lstick{$a:\ket0$} & \gate{X} & \ctrl{1} & \ctrl{2} & \targ{} & \qw \\
\lstick{$t$}        & \qw      & \targ{}  & \qw      & \ctrl{-1}& \qw \\
\lstick{$y$}        & \qw      & \qw      & \targ{}  & \ctrl{-2}& \qw \\
\lstick{$s$}        & \qw      & \qw      & \qw      & \qw      & \qw
\end{quantikz}""",
        "Parallel equality-flip": r"""\begin{quantikz}[row sep=.35cm, column sep=.55cm]
\lstick{$a:\ket0$} & \ctrl{1} & \gate{X} & \qw \\
\lstick{$t$}        & \ctrl{1} & \gate{X} & \qw \\
\lstick{$y$}        & \targ{}  & \gate{X} & \qw \\
\lstick{$s$}        & \qw      & \qw      & \qw
\end{quantikz}""",
    },
    "be-case-1-isolated-baseline": {
        "Target fixed": r"""\begin{quantikz}[row sep=.4cm, column sep=.65cm]
\lstick{$a:\ket0$} & \gate[wires=2]{U_{\rm cold}\;?} & \meter{} \\
\lstick{$t,y,s$}    &                                  & \qw
\end{quantikz}""",
        "Cold permutation": r"""\begin{quantikz}[row sep=.4cm, column sep=.55cm]
\lstick{$a:\ket0$} & \gate[wires=2]{P_{\rm cold}} & \rstick{$\ket0$ or garbage} \qw \\
\lstick{$t,y,s$}    &                               & \rstick{$E_1\ket{t,y,s}$ on clean branch} \qw
\end{quantikz}""",
    },
    "cubic-diagonal-cold": {
        "Symbolic target": r"""\begin{quantikz}[row sep=.4cm, column sep=.65cm]
\lstick{$\ket{0^3}$} & \gate[wires=2]{U_n\;?} & \meter{} \\
\lstick{$\ket j$}    &                       & \qw
\end{quantikz}""",
        "Rational branch completion": r"""\begin{quantikz}[row sep=.4cm, column sep=.55cm]
\lstick{$\ket{0^3}$} & \gate{\mathrm{complete}(x_j^3)} & \rstick{$\ket{v_j}$} \qw \\
\lstick{$\ket j$}    & \ctrl{-1}                       & \qw
\end{quantikz}""",
        "Householder direct sum": r"""\begin{quantikz}[row sep=.4cm, column sep=.55cm]
\lstick{$\ket{0^3}$} & \gate{H(v_j)} & \rstick{$x_j^3\ket0+\ket{\perp_j}$} \qw \\
\lstick{$\ket j$}    & \ctrl{-1}     & \qw
\end{quantikz}""",
    },
    "cubic-diagonal-hinted": {
        "Hint parsed": r"""\begin{quantikz}[column sep=.45cm]
\lstick{$\ket j$} & \gate{O_0:\,x_j} & \gate{p(z)=z^3} & \rstick{$x_j^3$} \qw
\end{quantikz}""",
        "Linear input block": r"""\begin{quantikz}[row sep=.4cm, column sep=.55cm]
\lstick{$\ket0$} & \gate{H(v_j^{(1)})} & \rstick{$x_j\ket0+\ket{\perp_j}$} \qw \\
\lstick{$\ket j$}& \ctrl{-1}            & \qw
\end{quantikz}""",
        "Cubic output block": r"""\begin{quantikz}[row sep=.4cm, column sep=.55cm]
\lstick{$\ket{0^3}$} & \gate{H(v_j^{(3)})} & \rstick{$x_j^3\ket0+\ket{\perp_j}$} \qw \\
\lstick{$\ket j$}    & \ctrl{-1}            & \qw
\end{quantikz}""",
    },
    "robin-ghl-one-term": {
        "Sparse-source correction": r"""\begin{quantikz}[column sep=.45cm]
\lstick{$(s,j)$} & \gate{\mathrm{audit\;address}} & \gate{\mathrm{deduplicate}} & \rstick{$7\;padded\;slots$} \qw
\end{quantikz}""",
        "Fixed-N8 Figure-4 realization": r"""\begin{quantikz}[row sep=.35cm, column sep=.24cm]
\lstick{$\ket{0^3}_s$} & \gate{H_W} & \ctrl{2} & \qw & \gate{O_{D^T}^{BS}} & \qw & \gate{(O_D^{BS})^\dagger} & \gate{H_W^\dagger} & \qw \\
\lstick{$\ket0_c$}     & \qw        & \qw      & \gate{R_y(2\arccos(D/N_D))} & \qw & \qw & \qw & \qw & \qw \\
\lstick{$\ket j$}      & \qw        & \gate{U_{\rm indic}} & \qw & \qw & \gate{\mathrm{SWAP}} & \qw & \qw & \qw
\end{quantikz}""",
        "Paper-seven normal form": r"""\begin{quantikz}[row sep=.35cm, column sep=.35cm]
\lstick{$\ket{0^3}_s$} & \gate{\mathrm{PREPARE}_7} & \ctrl{1} & \ctrl{2} & \gate{\mathrm{PREPARE}_7^\dagger} & \qw \\
\lstick{$\ket0_c$}     & \qw & \gate{R_y(2\arccos w_s)} & \qw & \qw & \qw \\
\lstick{$\ket j$}      & \qw & \qw & \gate{\mathrm{SELECT}_{+\delta_s}} & \qw & \qw
\end{quantikz}""",
        "XOR four-slot primitive": r"""\begin{quantikz}[row sep=.35cm, column sep=.32cm]
\lstick{$\ket{0^2}_s$} & \gate{\mathrm{PREPARE}_4} & \ctrl{1} & \ctrl{2} & \gate{\mathrm{PREPARE}_4^\dagger} & \qw \\
\lstick{$\ket0_c$}     & \qw & \gate{\mathrm{UCRY}(w_{s,j})} & \qw & \qw & \qw \\
\lstick{$\ket j$}      & \gate{\mathrm{pair\;basis}} & \qw & \gate{\mathrm{XOR\!\ SELECT}} & \gate{\mathrm{uncompute}} & \qw
\end{quantikz}""",
    },
}


def stage_circuit_latex(case_slug: str, stage_name: str) -> str:
    """Return a reviewed grouped-register schematic for one displayed stage."""
    return STAGE_CIRCUITS[case_slug][stage_name]
