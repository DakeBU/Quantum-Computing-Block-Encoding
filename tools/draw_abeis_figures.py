#!/usr/bin/env python3
"""Draw presentation-quality ABEIS figures.

The figures are intentionally generated as PNG files so the Overleaf report can
load them cheaply without rendering complex TikZ diagrams.
"""

from __future__ import annotations

from pathlib import Path
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch, Circle


ROOT = Path(__file__).resolve().parents[1]
ARTICLE = ROOT.parent / "Auto_Proof_Papers" / "ABEIS"
ARTICLE_FIG = ARTICLE / "figures"
README_FIG = ROOT / "docs" / "assets"

NAVY = "#182235"
TEXT = "#243044"
MUTED = "#667386"
BLUE = "#2F6BEA"
BLUE_L = "#E8F0FF"
PURPLE = "#7C3AED"
PURPLE_L = "#F0EAFE"
GREEN = "#2E9D55"
GREEN_L = "#E7F8EC"
AMBER = "#D49119"
AMBER_L = "#FFF4CC"
ORANGE = "#E56A2B"
ORANGE_L = "#FFF0E6"
RED = "#D83B35"
RED_L = "#FDE8E8"
GRAY = "#E8EDF4"
BG = "#FBFCFF"
INK = "#111827"


def setup(width: float, height: float):
    fig, ax = plt.subplots(figsize=(width, height), dpi=170)
    fig.patch.set_facecolor(BG)
    ax.set_facecolor(BG)
    ax.set_xlim(0, 100)
    ax.set_ylim(0, 100)
    ax.axis("off")
    return fig, ax


def save_figure(fig, stem: str, *, svg: bool = True, pdf: bool = False):
    """Write the same reader-facing figure to the paper and README trees."""

    suffixes = ["png"]
    if svg:
        suffixes.append("svg")
    if pdf:
        suffixes.append("pdf")
    for directory in (ARTICLE_FIG, README_FIG):
        directory.mkdir(parents=True, exist_ok=True)
        for suffix in suffixes:
            path = directory / f"{stem}.{suffix}"
            fig.savefig(path, bbox_inches="tight", facecolor=BG)
            if suffix == "svg":
                content = path.read_text(encoding="utf-8")
                path.write_text(
                    "\n".join(line.rstrip() for line in content.splitlines()) + "\n",
                    encoding="utf-8",
                )


def box(ax, x, y, w, h, title, subtitle="", fc=BLUE_L, ec=BLUE, lw=2.4, fs=17, subfs=11, radius=0.08):
    patch = FancyBboxPatch(
        (x, y),
        w,
        h,
        boxstyle=f"round,pad=0.012,rounding_size={radius * min(w, h)}",
        linewidth=lw,
        edgecolor=ec,
        facecolor=fc,
    )
    ax.add_patch(patch)
    ax.text(x + w / 2, y + h * 0.66, title, ha="center", va="center", fontsize=fs, fontweight="bold", color=TEXT)
    if subtitle:
        ax.text(x + w / 2, y + h * 0.30, subtitle, ha="center", va="center", fontsize=subfs, color=TEXT, linespacing=1.05)
    return patch


def badge(ax, x, y, w, h, text, fc=GREEN_L, ec=GREEN, fs=11):
    patch = FancyBboxPatch(
        (x, y),
        w,
        h,
        boxstyle="round,pad=0.012,rounding_size=0.45",
        linewidth=2.0,
        edgecolor=ec,
        facecolor=fc,
    )
    ax.add_patch(patch)
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=fs, fontweight="bold", color=TEXT)
    return patch


def label(ax, x, y, text, fs=14, weight="normal", color=TEXT, ha="center"):
    ax.text(x, y, text, ha=ha, va="center", fontsize=fs, fontweight=weight, color=color)


def arrow(ax, x1, y1, x2, y2, color="#334155", lw=2.3, style="-|>", rad=0.0, dashed=False, alpha=1.0):
    patch = FancyArrowPatch(
        (x1, y1),
        (x2, y2),
        arrowstyle=style,
        mutation_scale=18,
        linewidth=lw,
        color=color,
        connectionstyle=f"arc3,rad={rad}",
        linestyle="--" if dashed else "-",
        alpha=alpha,
    )
    ax.add_patch(patch)
    return patch


def group_box(ax, x, y, w, h, title, ec, fc, title_fc=None, dashed=False):
    patch = FancyBboxPatch(
        (x, y),
        w,
        h,
        boxstyle="round,pad=0.012,rounding_size=1.4",
        linewidth=2.2,
        edgecolor=ec,
        facecolor=fc,
        linestyle="--" if dashed else "-",
    )
    ax.add_patch(patch)
    if title:
        label(ax, x + 2.2, y + h - 3.2, title, fs=15, weight="bold", color=title_fc or ec, ha="left")
    return patch


def draw_application_overview():
    fig, ax = setup(16.8, 6.2)
    label(
        ax,
        4.5,
        94.0,
        "ABEIS target ladder: state preparation before block encoding",
        fs=22,
        weight="bold",
        color=NAVY,
        ha="left",
    )
    label(
        ax,
        4.5,
        89.3,
        "The simpler task fixes the first column of a unitary; the harder task fixes a clean block of a larger unitary.",
        fs=12.2,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 4.5, 49.0, 28.0, 33.0, "", GREEN, "#F7FFF9")
    badge(ax, 7.0, 77.0, 12.0, 4.5, "STEP 1", fc=GREEN, ec=GREEN, fs=10.5)
    label(ax, 7.0, 70.8, "State Preparation", fs=16.2, weight="bold", color=NAVY, ha="left")
    label(ax, 7.0, 65.4, "Find a unitary U with", fs=10.4, color=MUTED, ha="left")
    ax.text(18.5, 59.0, r"$U|0^n\rangle=|\psi\rangle$", ha="center", va="center", fontsize=17.2, color=TEXT)
    label(ax, 7.0, 52.8, "First column of U is the target state.", fs=9.8, color=TEXT, ha="left")

    group_box(ax, 36.0, 49.0, 25.5, 33.0, "", BLUE, "#F6F9FF")
    badge(ax, 38.5, 77.0, 12.0, 4.5, "GATES", fc=BLUE, ec=BLUE, fs=10.5)
    label(ax, 38.5, 70.8, "Concrete anchors", fs=16.2, weight="bold", color=NAVY, ha="left")
    ax.text(48.8, 63.0, r"$H|0\rangle=(|0\rangle+|1\rangle)/\sqrt{2}$", ha="center", va="center", fontsize=14.2, color=TEXT)
    ax.text(48.8, 57.2, r"$X|0\rangle=|1\rangle,\quad X|1\rangle=|0\rangle$", ha="center", va="center", fontsize=14.2, color=TEXT)
    label(ax, 38.5, 52.3, "X swaps basis states.", fs=9.8, color=TEXT, ha="left")

    group_box(ax, 65.0, 49.0, 30.5, 33.0, "", PURPLE, "#FAF7FF")
    badge(ax, 67.5, 77.0, 12.0, 4.5, "STEP 2", fc=PURPLE, ec=PURPLE, fs=10.5)
    label(ax, 67.5, 70.8, "Block Encoding", fs=16.2, weight="bold", color=NAVY, ha="left")
    label(ax, 67.5, 65.4, "Embed a non-unitary operator A as a block:", fs=10.0, color=MUTED, ha="left")
    ax.text(
        80.2,
        58.8,
        r"$(\langle0^a|\otimes I)W(|0^a\rangle\otimes I)=A/\alpha$",
        ha="center",
        va="center",
        fontsize=12.4,
        color=TEXT,
    )
    label(ax, 67.5, 52.8, "Harder: completions, cleanup choices, costs.", fs=9.8, color=TEXT, ha="left")

    arrow(ax, 32.7, 66.5, 35.5, 66.5, color=GREEN, lw=2.7)
    arrow(ax, 61.8, 66.5, 64.5, 66.5, color=PURPLE, lw=2.7)

    group_box(ax, 7.0, 12.0, 86.0, 24.0, "Shared ABEIS loop", "#CBD5E1", "#FFFFFF", title_fc="#475569")
    box(ax, 10.5, 18.0, 17.0, 9.0, "Task", "state or operator", fc="#FFFFFF", ec="#64748B", fs=11.2, subfs=7.8)
    box(ax, 31.0, 18.0, 17.0, 9.0, "Candidates", "unitary + score", fc=AMBER_L, ec=AMBER, fs=11.2, subfs=7.8)
    box(ax, 51.5, 18.0, 17.0, 9.0, "Lean gate", "semantic proof", fc=GREEN_L, ec=GREEN, fs=11.2, subfs=7.8)
    box(ax, 72.0, 18.0, 17.0, 9.0, "Exports", "proof + QASM", fc=BLUE_L, ec=BLUE, fs=11.2, subfs=7.8)
    for x1, x2 in [(27.8, 30.6), (48.3, 51.1), (68.8, 71.6)]:
        arrow(ax, x1, 22.5, x2, 22.5, color="#475569", lw=2.1)
    label(ax, 50.0, 8.1, "State-preparation circuits can later become PREPARE primitives inside block-encoding routes.", fs=11.2, weight="bold", color=NAVY)

    for path in [
        ARTICLE_FIG / "application_overview.png",
        README_FIG / "abeis_application_overview.png",
        README_FIG / "abeis_contract_pipeline_2x.png",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_hierarchical_harness():
    fig, ax = setup(15.0, 7.8)
    label(ax, 5.0, 94.0, "Hierarchical Harness", fs=22, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        5.0,
        89.8,
        "One coordinated stack keeps the target, proof DAG, candidate population, and export boundary synchronized.",
        fs=11.6,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 5.0, 68.0, 90.0, 14.0, "Target contract", GREEN, "#F7FFF9")
    box(ax, 9.0, 72.0, 22.0, 5.6, "State prep", "U|0^n> = |psi>", fc="#FFFFFF", ec=GREEN, fs=11.5, subfs=8.0)
    box(ax, 39.0, 72.0, 22.0, 5.6, "Block encoding", "clean block = A / alpha", fc="#FFFFFF", ec=GREEN, fs=11.5, subfs=8.0)
    box(ax, 69.0, 72.0, 17.0, 5.6, "Score", "tier, gates,\ndepth, aux", fc="#FFFFFF", ec=GREEN, fs=11.0, subfs=7.8)
    arrow(ax, 31.4, 74.8, 38.6, 74.8, color=GREEN)
    arrow(ax, 61.4, 74.8, 68.6, 74.8, color=GREEN)

    group_box(ax, 5.0, 31.0, 90.0, 29.0, "Planning and execution", BLUE, "#F6F9FF")
    box(ax, 9.0, 47.5, 16.0, 6.7, "Upper", "strategy and\ncapacity", fc=BLUE_L, ec=BLUE, fs=12.0, subfs=8.2)
    box(ax, 31.0, 47.5, 16.0, 6.7, "Middle", "Lean/prose map\nand memory", fc=PURPLE_L, ec=PURPLE, fs=12.0, subfs=8.2)
    box(ax, 53.0, 47.5, 16.0, 6.7, "Reviewer", "target, source,\nLean gate", fc=RED_L, ec=RED, fs=12.0, subfs=8.2)
    box(ax, 75.0, 47.5, 14.5, 6.7, "Record", "files, logs,\npopulations", fc="#FFFFFF", ec="#64748B", fs=11.5, subfs=8.0)
    arrow(ax, 25.4, 50.8, 30.6, 50.8)
    arrow(ax, 47.4, 50.8, 52.6, 50.8)
    arrow(ax, 69.4, 50.8, 74.6, 50.8)

    box(ax, 13.0, 35.0, 18.0, 6.6, "NL architect", "construction and\nproof packet", fc=AMBER_L, ec=AMBER, fs=11.0, subfs=7.7)
    box(ax, 41.0, 35.0, 18.0, 6.6, "Lean worker", "one active\nproof leaf", fc=AMBER_L, ec=AMBER, fs=11.0, subfs=7.7)
    box(ax, 69.0, 35.0, 18.0, 6.6, "Verifier", "finite diagnostics\nand exports", fc=AMBER_L, ec=AMBER, fs=11.0, subfs=7.7)
    arrow(ax, 39.0, 47.4, 22.0, 41.8, color=PURPLE, rad=0.10)
    arrow(ax, 39.0, 47.4, 50.0, 41.8, color=PURPLE)
    arrow(ax, 39.0, 47.4, 78.0, 41.8, color=PURPLE, rad=-0.08)
    arrow(ax, 78.0, 41.7, 58.0, 47.3, color=RED, dashed=True, rad=-0.15)

    group_box(ax, 11.0, 10.0, 78.0, 12.0, "Promotion boundary", GREEN, "#F7FFF9")
    box(ax, 17.0, 13.7, 19.0, 4.8, "Insight pool", "unproved ideas", fc="#FFFFFF", ec="#94A3B8", fs=10.5, subfs=7.5)
    box(ax, 42.0, 13.7, 16.0, 4.8, "Lean proof", "acceptance gate", fc=GREEN_L, ec=GREEN, fs=10.5, subfs=7.5)
    box(ax, 64.0, 13.7, 19.0, 4.8, "Certified archive", "parents and reports", fc=BLUE_L, ec=BLUE, fs=10.5, subfs=7.5)
    arrow(ax, 36.4, 16.1, 41.6, 16.1, dashed=True, color="#64748B")
    arrow(ax, 58.4, 16.1, 63.6, 16.1, color=GREEN)

    for path in [ARTICLE_FIG / "hierarchical_harness.png", README_FIG / "hierarchical_harness.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_game_harness():
    fig, ax = setup(15.0, 7.8)
    label(ax, 5.0, 94.0, "Game Harness", fs=22, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        5.0,
        89.8,
        "Two semi-independent teams explore in parallel; a council transfers only reviewer-useful insights.",
        fs=11.6,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 5.0, 57.0, 38.0, 26.0, "Natural-Language Team", BLUE, "#F6F9FF")
    box(ax, 9.0, 72.5, 13.0, 5.2, "Upper", "route strategy", fc=BLUE_L, ec=BLUE, fs=10.7, subfs=7.5)
    box(ax, 26.0, 72.5, 13.0, 5.2, "Middle", "proof packet", fc=BLUE_L, ec=BLUE, fs=10.7, subfs=7.5)
    box(ax, 9.0, 62.5, 30.0, 6.0, "Lower workers", "human-readable construction, proof sketch, diagnostics", fc="#FFFFFF", ec=BLUE, fs=11.0, subfs=7.7)
    arrow(ax, 22.4, 75.1, 25.6, 75.1, color=BLUE)
    arrow(ax, 24.0, 72.3, 24.0, 68.8, color=BLUE)

    group_box(ax, 57.0, 57.0, 38.0, 26.0, "Lean Team", PURPLE, "#FAF7FF")
    box(ax, 61.0, 72.5, 13.0, 5.2, "Upper", "formal route", fc=PURPLE_L, ec=PURPLE, fs=10.7, subfs=7.5)
    box(ax, 78.0, 72.5, 13.0, 5.2, "Middle", "Lean leaves", fc=PURPLE_L, ec=PURPLE, fs=10.7, subfs=7.5)
    box(ax, 61.0, 62.5, 30.0, 6.0, "Lower workers", "definitions, theorem closure, build repair", fc="#FFFFFF", ec=PURPLE, fs=11.0, subfs=7.7)
    arrow(ax, 74.4, 75.1, 77.6, 75.1, color=PURPLE)
    arrow(ax, 76.0, 72.3, 76.0, 68.8, color=PURPLE)

    group_box(ax, 30.0, 34.0, 40.0, 15.0, "Game Council", ORANGE, "#FFF8F0")
    box(ax, 35.0, 38.5, 30.0, 5.8, "Transfer and scheduling", "route useful sketches to Lean; export certified Lean proofs to prose", fc=ORANGE_L, ec=ORANGE, fs=11.4, subfs=7.8)
    arrow(ax, 28.0, 57.0, 38.0, 49.2, color=BLUE, rad=-0.12)
    arrow(ax, 72.0, 57.0, 62.0, 49.2, color=PURPLE, rad=0.12)
    arrow(ax, 38.0, 34.0, 24.0, 57.0, color=ORANGE, dashed=True, rad=-0.18)
    arrow(ax, 62.0, 34.0, 76.0, 57.0, color=ORANGE, dashed=True, rad=0.18)

    group_box(ax, 8.0, 12.0, 84.0, 13.0, "Shared acceptance rule", GREEN, "#F7FFF9")
    box(ax, 13.0, 15.7, 20.0, 5.0, "Insight pool", "team ideas and Pro input", fc="#FFFFFF", ec="#94A3B8", fs=10.5, subfs=7.4)
    box(ax, 40.0, 15.7, 20.0, 5.0, "Reviewer + Lean", "semantic certificate", fc=GREEN_L, ec=GREEN, fs=10.5, subfs=7.4)
    box(ax, 67.0, 15.7, 20.0, 5.0, "Certified output", "proof note and exports", fc=BLUE_L, ec=BLUE, fs=10.5, subfs=7.4)
    arrow(ax, 33.4, 18.2, 39.6, 18.2, dashed=True, color="#64748B")
    arrow(ax, 60.4, 18.2, 66.6, 18.2, color=GREEN)
    label(ax, 50.0, 8.2, "More agents are opened only after recorded stagnation and with a fixed generation budget.", fs=10.8, weight="bold", color=NAVY)

    for path in [ARTICLE_FIG / "game_harness.png", README_FIG / "game_harness.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_abeis_loop():
    fig, ax = setup(15.5, 8.6)
    label(ax, 5, 95, "ABEIS loop: evolve block encodings, certify with Lean, export runnable code", fs=21, weight="bold", color=NAVY, ha="left")
    label(ax, 5, 91.3, "The loop combines target control, evolutionary candidate search, proof-DAG work, and post-certification code delivery.", fs=12, color=MUTED, ha="left")

    # Target band.
    group_box(ax, 5, 73, 90, 14, "", GREEN, "#F4FBF6")
    badge(ax, 7.5, 84.3, 11.5, 4.2, "TARGET", fc=GREEN, ec=GREEN, fs=11)
    box(ax, 11, 76.4, 21, 7.4, "Operator", "A, alpha, projector,\nepsilon", fc="#FFFFFF", ec=GREEN, fs=13.5, subfs=9.6)
    box(ax, 40, 76.4, 22, 7.4, "Priority", "tier, gates, depth,\nauxiliary qubits", fc="#FFFFFF", ec=GREEN, fs=13.5, subfs=9.6)
    box(ax, 72, 76.4, 16, 7.4, "Mode", "paper / construct\n/ improve", fc="#FFFFFF", ec=GREEN, fs=13.5, subfs=9.6)
    arrow(ax, 32.5, 80.1, 39.3, 80.1, color=GREEN)
    arrow(ax, 62.6, 80.1, 71.3, 80.1, color=GREEN)

    # Control band.
    group_box(ax, 5, 36, 90, 29, "", BLUE, "#F5F8FF")
    badge(ax, 7.5, 62.3, 14, 4.2, "CONTROL", fc=BLUE, ec=BLUE, fs=11)
    box(ax, 10, 53, 17, 7.4, "Record", "Lean, memory,\npopulation", fc="#FFFFFF", ec="#64748B", fs=13.5, subfs=9.5)
    box(ax, 33, 53, 17, 7.4, "Upper", "target audit,\nLexElim", fc=BLUE_L, ec=BLUE, fs=13.5, subfs=9.5)
    box(ax, 56, 53, 17, 7.4, "Middle", "Lean <-> prose,\nretrieval", fc=PURPLE_L, ec=PURPLE, fs=13.5, subfs=9.5)
    box(ax, 79, 53, 12, 7.4, "Review", "source and\nLean gate", fc=RED_L, ec=RED, fs=12.5, subfs=8.8)
    arrow(ax, 27.4, 56.7, 32.3, 56.7)
    arrow(ax, 50.4, 56.7, 55.3, 56.7)
    arrow(ax, 73.4, 56.7, 78.3, 56.7)

    box(ax, 13, 40.5, 15, 6.8, "Architect", "candidate\nproof DAG", fc=AMBER_L, ec=AMBER, fs=12.5, subfs=8.8)
    box(ax, 42, 40.5, 15, 6.8, "Lean worker", "one proof\nleaf", fc=AMBER_L, ec=AMBER, fs=12.5, subfs=8.8)
    box(ax, 71, 40.5, 15, 6.8, "Verifier", "finite block\nand depth", fc=AMBER_L, ec=AMBER, fs=12.5, subfs=8.8)
    arrow(ax, 64.5, 52.8, 20.5, 47.6, rad=-0.12)
    arrow(ax, 64.5, 52.8, 49.5, 47.6)
    arrow(ax, 64.5, 52.8, 78.5, 47.6)
    arrow(ax, 79.0, 47.5, 84.5, 52.8)
    arrow(ax, 84.0, 52.8, 78.0, 48.0, color=RED, dashed=True, rad=0.12)
    label(ax, 84.2, 49.5, "repair", fs=9.3, color=RED)

    # Population band.
    group_box(ax, 5, 8, 90, 20, "", ORANGE, "#FFF8F0")
    badge(ax, 7.5, 25.2, 16, 4.2, "POPULATION", fc=ORANGE, ec=ORANGE, fs=11)
    box(ax, 10, 15, 18, 6.8, "Insight pool", "Pro, Python,\nhuman sketches", fc="#FFFFFF", ec="#94A3B8", fs=12.5, subfs=8.7)
    box(ax, 40, 15, 18, 6.8, "Lean gate", "unitarity +\nblock entry", fc=GREEN_L, ec=GREEN, fs=12.5, subfs=8.7)
    box(ax, 70, 15, 18, 6.8, "Certified parents", "mutation and\ncrossover", fc=ORANGE_L, ec=ORANGE, fs=12.5, subfs=8.7)
    box(ax, 70, 7.5, 18, 5.2, "Exports", "Qiskit / Katas / QASM", fc="#FFFFFF", ec="#475569", fs=11.5, subfs=8.2)
    arrow(ax, 28.4, 18.4, 39.3, 18.4, dashed=True, color="#64748B")
    arrow(ax, 58.4, 18.4, 69.3, 18.4, color=GREEN)
    arrow(ax, 79, 15, 79, 13.1, color="#475569")
    arrow(ax, 79, 21.9, 20.5, 40.2, rad=-0.18, color=ORANGE)
    label(ax, 48, 29.7, "only Lean-certified candidates become evolutionary parents", fs=11.3, weight="bold", color=NAVY)

    for path in [ARTICLE_FIG / "abeis_loop.png", README_FIG / "abeis_loop.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def wire(ax, x1, x2, y, name):
    ax.plot([x1, x2], [y, y], color="#334155", lw=2.1)
    label(ax, x1 - 1.2, y, name, fs=11, weight="bold", color="#334155", ha="right")


def gate(ax, x, y, w, h, text, fc="#FFFFFF", ec="#334155", fs=10):
    box(ax, x, y, w, h, text, fc=fc, ec=ec, lw=1.9, fs=fs, subfs=8, radius=0.12)


def control(ax, x, y, filled=True):
    ax.add_patch(Circle((x, y), 0.75, facecolor="#334155" if filled else "#FFFFFF", edgecolor="#334155", lw=1.7))


def circuit_card(ax, x, y, w, h, title, subtitle, score, lean, kind):
    group_box(ax, x, y, w, h, "", "#CBD5E1", "#FFFFFF")
    label(ax, x + 2.0, y + h - 4.0, title, fs=14.3, weight="bold", color=NAVY, ha="left")
    label(ax, x + 2.0, y + h - 8.6, subtitle, fs=9.6, color=MUTED, ha="left")
    badge(ax, x + w - 12.6, y + 3.5, 10.3, 4.3, score, fc=GREEN_L, ec=GREEN, fs=9.5)
    label(ax, x + 2.0, y + 5.6, lean, fs=8.3, color="#475569", ha="left")

    x0, x1 = x + 5.4, x + w - 5.6
    ys = [y + 22.5, y + 17.5, y + 12.5]
    for nm, yy in zip(["a", "T", "tau"], ys):
        wire(ax, x0, x1, yy, nm)

    if kind == "seed":
        gate(ax, x + 13.4, y + 11.2, w - 24, 13.4, "opaque\ncompletion\nU_pi", fc=BLUE_L, ec=BLUE, fs=11.2)
        label(ax, x + w / 2, y + 29.0, "correct seed; one unresolved oracle call", fs=9.2, color=MUTED)
    elif kind == "pro":
        gx = [x + 10.5, x + 15.8, x + 20.8, x + 23.5]
        control(ax, gx[0], ys[1]); control(ax, gx[0], ys[2])
        ax.plot([gx[0], gx[0]], [ys[2], ys[0]], color="#334155", lw=1.8)
        gate(ax, gx[0]-2, ys[0]-1.8, 4, 3.6, "X", fc="#FFFFFF", ec="#334155", fs=11)
        for xx, target_y, ctrl_y in [(gx[1], ys[1], ys[0]), (gx[2], ys[2], ys[0])]:
            control(ax, xx, ctrl_y)
            ax.plot([xx, xx], [min(ctrl_y, target_y), max(ctrl_y, target_y)], color="#334155", lw=1.8)
            gate(ax, xx-2, target_y-1.8, 4, 3.6, "X", fc="#FFFFFF", ec="#334155", fs=11)
        gate(ax, gx[3]-2, ys[0]-1.8, 4, 3.6, "X", fc="#FFFFFF", ec="#334155", fs=11)
        label(ax, x + w / 2, y + 29.0, "flag selected branch, then transfer", fs=9.2, color=MUTED)
    elif kind == "champ":
        gx = [x + 10.5, x + 21.0]
        control(ax, gx[0], ys[1]); control(ax, gx[0], ys[2])
        ax.plot([gx[0], gx[0]], [ys[2], ys[0]], color="#334155", lw=1.8)
        gate(ax, gx[0]-2, ys[0]-1.8, 4, 3.6, "X", fc="#FFFFFF", ec="#334155", fs=11)
        for yy in ys:
            gate(ax, gx[1]-2, yy-1.8, 4, 3.6, "X", fc=GREEN_L, ec=GREEN, fs=11)
        ax.plot([gx[1]-3, gx[1]+3], [ys[0]+3.2, ys[0]+3.2], color=GREEN, lw=2.0)
        label(ax, x + w / 2, y + 29.0, "three flips form one parallel layer", fs=9.2, color=MUTED)


def draw_optctrl_storyboard():
    fig, ax = setup(15.5, 8.0)
    label(ax, 5, 94, "BE Case 1 | certified evolution of the transfer operator", fs=23, weight="bold", color=NAVY, ha="left")
    label(ax, 5, 89.8, "Only Lean-certified candidates are parents or plotted solutions; insight-pool ideas must be promoted by proof.", fs=12.5, color=MUTED, ha="left")

    circuit_card(ax, 5, 43, 28, 39, "Gen 0: seed", "oracle-level baseline", "(1,1,1,1)", "Lean: exampleVerified", "seed")
    circuit_card(ax, 36, 43, 28, 39, "Gen 6: proposal", "ChatGPT Pro transfer", "(4,4,1,0)", "Lean: proEqTransferVerified", "pro")
    circuit_card(ax, 67, 43, 28, 39, "Gen 7: champion", "evolved equality-flip", "(4,2,1,0)", "Lean: evolvedEqFlipVerified", "champ")
    arrow(ax, 33.5, 62.5, 35.4, 62.5, color=ORANGE, lw=2.8)
    arrow(ax, 64.5, 62.5, 66.4, 62.5, color=ORANGE, lw=2.8)
    label(ax, 34.4, 67.2, "proof\nrepair", fs=9.5, color=ORANGE)
    label(ax, 65.4, 67.2, "mutation +\nselection", fs=9.5, color=ORANGE)

    group_box(ax, 8, 11, 84, 22, "Certified-population rule", GREEN, "#F4FBF6")
    box(ax, 13, 17.2, 17, 8, "Insight pool", "Pro / Python /\nhuman sketches", fc="#FFFFFF", ec="#94A3B8", fs=13, subfs=9.5)
    box(ax, 42, 17.2, 17, 8, "Lean gate", "unitary + clean\nblock equality", fc=GREEN_L, ec=GREEN, fs=13, subfs=9.5)
    box(ax, 71, 17.2, 17, 8, "Parents", "mutation and\ncrossover only here", fc=ORANGE_L, ec=ORANGE, fs=13, subfs=9.5)
    arrow(ax, 30.3, 21.2, 41.6, 21.2, dashed=True, color="#64748B")
    arrow(ax, 59.3, 21.2, 70.6, 21.2, color=GREEN)
    label(ax, 50, 9.0, "Unverified circuits can inspire the next attempt, but they cannot be champions.", fs=12, weight="bold", color=NAVY)

    for path in [ARTICLE_FIG / "optctrl_storyboard.png", README_FIG / "optctrl_storyboard.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_optctrl_evolution():
    fig, ax = plt.subplots(figsize=(11.8, 6.4), dpi=180)
    fig.patch.set_facecolor(BG)
    ax.set_facecolor("#FFFFFF")
    gens = [0, 2, 6, 7, 8, 9]
    gate = [1, 6, 4, 4, 4, 4]
    depth = [1, 5, 4, 2, 2, 2]
    oracle = [1, 0, 0, 0, 0, 0]
    ax.plot(gens, gate, marker="o", ms=9, lw=3.2, color=BLUE, label="Gate count")
    ax.plot(gens, depth, marker="s", ms=8, lw=3.2, color=ORANGE, label="Depth")
    ax.plot(gens, oracle, marker="^", ms=8, lw=2.8, color=PURPLE, label="Oracle calls")
    ax.axvspan(7.55, 9.25, facecolor=GREEN_L, edgecolor=GREEN, linewidth=1.6, alpha=0.78)
    ax.text(8.4, 5.42, "Approximate phase\nexact incumbent, epsilon = 0", ha="center", va="center", fontsize=10.5, color=GREEN, fontweight="bold")
    ax.set_title("BE Case 1 | Lean-certified generation champions", fontsize=20, fontweight="bold", color=NAVY, pad=18)
    ax.set_xlabel("Generation", fontsize=15, fontweight="bold")
    ax.set_ylabel("Lower is better", fontsize=15, fontweight="bold")
    ax.set_xticks(gens)
    ax.set_ylim(-0.35, 6.6)
    ax.grid(True, axis="y", color="#E2E8F0", linewidth=1.2)
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["left", "bottom"]].set_color("#64748B")
    ax.tick_params(labelsize=12)
    leg = ax.legend(loc="upper left", bbox_to_anchor=(0.02, 0.98), frameon=True, fontsize=12)
    leg.get_frame().set_edgecolor("#CBD5E1")
    leg.get_frame().set_facecolor("#FFFFFF")
    for x, y, txt in [(0, 1, "seed"), (2, 6, "decomposed"), (6, 4, "Pro"), (7, 4, "champion")]:
        ax.annotate(txt, (x, y), xytext=(0, 14), textcoords="offset points", ha="center", fontsize=10.5, fontweight="bold", color=TEXT)
    fig.tight_layout(pad=1.4)
    for path in [ARTICLE_FIG / "optctrl_evolution.png", README_FIG / "optctrl_evolution.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_optctrl_hier_vs_pro():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14.5, 5.8), dpi=180, sharey=True)
    fig.patch.set_facecolor(BG)
    for ax in (ax1, ax2):
        ax.set_facecolor("#FFFFFF")
        ax.grid(True, axis="y", color="#E2E8F0", linewidth=1.2)
        ax.spines[["top", "right"]].set_visible(False)
        ax.spines[["left", "bottom"]].set_color("#64748B")
        ax.tick_params(labelsize=11)
        ax.set_ylim(-0.3, 6.6)
        ax.set_xlabel("Certified step", fontsize=13, fontweight="bold")

    ax1.set_title("Attempt A: no-Pro Hierarchical Harness", fontsize=16, fontweight="bold", color=NAVY)
    ax1.set_ylabel("Lower is better", fontsize=13, fontweight="bold")
    cold_steps = [0, 1, 2, 3]
    ax1.plot([1, 2, 3], [4, 4, 4], marker="o", ms=9, lw=3.0, color=BLUE, label="Gate count")
    ax1.plot([1, 2, 3], [4, 4, 4], marker="s", ms=8, lw=3.0, color=ORANGE, label="Depth")
    ax1.axvspan(1.55, 2.45, facecolor=GREEN_L, edgecolor=GREEN, linewidth=1.4, alpha=0.7)
    ax1.scatter([0], [0], s=70, marker="x", color=RED, linewidth=2.4)
    ax1.annotate("target fixed", (0, 0), xytext=(10, 18), textcoords="offset points", fontsize=10, fontweight="bold", color=TEXT)
    ax1.annotate("COLD-CLEAN-PERM-001\nLean checkpoint", (1, 4), xytext=(0, 18), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=TEXT)
    ax1.annotate("epsilon=0\napprox incumbent", (2, 4), xytext=(0, -38), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=GREEN)
    ax1.annotate("Qiskit/export\npassed", (3, 4), xytext=(0, 18), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=GREEN)
    ax1.set_xticks(cold_steps)
    ax1.set_xticklabels(["target", "Lean", "Approx", "export"])

    ax2.set_title("Attempt B: Pro-assisted evolution", fontsize=16, fontweight="bold", color=NAVY)
    gens = [2, 6, 7, 8]
    gates = [6, 4, 4, 4]
    depths = [5, 4, 2, 2]
    ax2.plot(gens, gates, marker="o", ms=9, lw=3.0, color=BLUE, label="Gate count")
    ax2.plot(gens, depths, marker="s", ms=8, lw=3.0, color=ORANGE, label="Depth")
    ax2.axvspan(7.55, 8.25, facecolor=GREEN_L, edgecolor=GREEN, linewidth=1.4, alpha=0.7)
    ax2.annotate("depth-5\ncertificate", (2, 5), xytext=(0, 18), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=TEXT)
    ax2.annotate("Pro idea\npromoted by Lean", (6, 4), xytext=(0, 18), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=TEXT)
    ax2.annotate("evolved\nchampion", (7, 2), xytext=(0, -38), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=GREEN)
    ax2.annotate("epsilon=0 approx\nQiskit/export passed", (8, 2), xytext=(0, 18), textcoords="offset points", ha="center", fontsize=9.3, fontweight="bold", color=GREEN)
    ax2.set_xticks(gens)
    ax2.set_xticklabels(["Gen 2", "Gen 6", "Gen 7", "Approx+export"])

    handles, labels_ = ax2.get_legend_handles_labels()
    fig.legend(handles, labels_, loc="lower center", ncol=2, frameon=True, fontsize=12)
    fig.suptitle("BE Case 1 | transfer operator: two certified search arms", fontsize=20, fontweight="bold", color=NAVY)
    fig.tight_layout(rect=(0, 0.08, 1, 0.93), pad=1.3)
    for path in [
        ARTICLE_FIG / "optctrl_hier_vs_pro.png",
        README_FIG / "optctrl_hier_vs_pro.png",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_optctrl_cold_clean_storyboard():
    fig, ax = setup(15.6, 7.8)
    label(ax, 5, 94, "BE Case 1 | no-Pro isolated checkpoint", fs=22, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        5,
        89.7,
        "This figure shows the currently Lean-certified clean-start candidate. It is a checkpoint under continued convergence testing, not a final optimality claim.",
        fs=11.5,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 5, 14, 90, 66, "", "#CBD5E1", "#FFFFFF")
    label(ax, 9, 74, "COLD-CLEAN-PERM-001", fs=17, weight="bold", color=NAVY, ha="left")
    badge(ax, 71, 71.8, 18, 5, "score (4,4,1,0)", fc=GREEN_L, ec=GREEN, fs=11.2)
    label(ax, 9, 68.6, "Target:  E1 = |0><1|_T tensor |0><1|_tau tensor I_S", fs=12, color=TEXT, ha="left")
    label(ax, 9, 64.7, "Full basis index: 8*a + 4*T + 2*tau + S.  Clean block projects a = 0 on both sides.", fs=10.8, color=MUTED, ha="left")

    # Draw a compact circuit-level schematic.
    x0, x1 = 12, 88
    ys = [54, 45, 36, 27]
    names = ["a", "T", "tau", "S"]
    for nm, yy in zip(names, ys):
        wire(ax, x0, x1, yy, nm)

    # Logical permutation block.
    gate(ax, 28, 24.2, 22, 32.8, "finite\npermutation\nU_pi", fc=BLUE_L, ec=BLUE, fs=13)
    label(ax, 39, 60.2, "Lean proves U_pi is unitary by an explicit inverse table", fs=10.2, color=TEXT)
    arrow(ax, 51, 54, 61, 54, color=GREEN, lw=2.5)
    arrow(ax, 51, 45, 61, 45, color=GREEN, lw=2.5)
    arrow(ax, 51, 36, 61, 36, color=GREEN, lw=2.5)
    arrow(ax, 51, 27, 61, 27, color=GREEN, lw=2.5)

    # Clean projection and target branch.
    gate(ax, 63, 57.0, 17, 8.0, "clean\nprojector", fc=GREEN_L, ec=GREEN, fs=10.5)
    gate(ax, 63, 18.7, 17, 8.0, "dirty branches\nremoved", fc=GRAY, ec="#64748B", fs=10.2)
    label(ax, 55, 19.8, "(0,1,1,S) maps to (0,0,0,S);", fs=10.2, color=TEXT)
    label(ax, 55, 16.7, "all other clean inputs leave the clean block.", fs=10.2, color=TEXT)

    group_box(ax, 10, 6.5, 80, 5.5, "", GREEN, "#F4FBF6")
    label(
        ax,
        50,
        9.2,
        "Lean certificates: blockProjection + permutation certificate.  Qiskit is a post-Lean executable export.",
        fs=10.2,
        weight="bold",
        color=NAVY,
    )

    for path in [ARTICLE_FIG / "optctrl_cold_clean_storyboard.png", README_FIG / "optctrl_cold_clean_storyboard.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_qiskit_export_results():
    fig, ax = setup(14.8, 7.2)
    label(ax, 5, 94, "BE Case 1 | post-Lean executable acceptance", fs=21, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        5,
        89.8,
        "Qiskit is used here as a runnable artifact and finite self-test after Lean certification, not as the mathematical certificate.",
        fs=12,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 5, 16, 42, 66, "", "#CBD5E1", "#FFFFFF")
    label(ax, 8, 77.5, "Attempt A: no-Pro", fs=15.5, weight="bold", color=NAVY, ha="left")
    badge(ax, 31, 76.0, 12, 4.6, "(4,4,1,0)", fc=GREEN_L, ec=GREEN, fs=10.5)
    box(ax, 9, 62, 34, 8, "Lean certificate", "blockProjection + permutation", fc=BLUE_L, ec=BLUE, fs=11.8, subfs=8.6)
    box(ax, 9, 49, 34, 8, "Qiskit finite check", "matrix / block / unitarity", fc=GREEN_L, ec=GREEN, fs=11.8, subfs=8.6)
    box(ax, 9, 36, 34, 8, "Status", "all finite export checks passed", fc="#FFFFFF", ec=GREEN, fs=12, subfs=9.5)
    label(ax, 26, 27.5, "This export uses a finite permutation matrix;\nit is not a primitive hardware decomposition.", fs=10.4, color=MUTED)

    group_box(ax, 53, 16, 42, 66, "", "#CBD5E1", "#FFFFFF")
    label(ax, 56, 77.5, "Attempt B: Pro", fs=15.5, weight="bold", color=NAVY, ha="left")
    badge(ax, 79, 76.0, 12, 4.6, "(4,2,1,0)", fc=GREEN_L, ec=GREEN, fs=10.5)
    box(ax, 57, 62, 34, 8, "Lean certificate", "evolvedEqFlipVerified", fc=BLUE_L, ec=BLUE, fs=11.8, subfs=8.8)
    box(ax, 57, 49, 34, 8, "Qiskit circuit", "4 qubits, 4 gates,\nQiskit depth 2", fc=GREEN_L, ec=GREEN, fs=11.4, subfs=8.0)
    box(ax, 57, 36, 34, 8, "Errors", "clean-block error 0\nunitarity error 0", fc="#FFFFFF", ec=GREEN, fs=11.4, subfs=8.2)
    label(ax, 74, 27.5, "The exported Python circuit is runnable\nand matches the Lean-certified matrix.", fs=10.4, color=MUTED)

    arrow(ax, 43.5, 53, 52.5, 53, color=ORANGE, lw=2.8)
    label(ax, 48, 58, "resource\nimprovement", fs=10.2, weight="bold", color=ORANGE)

    group_box(ax, 11, 6.5, 78, 5.5, "", GREEN, "#F4FBF6")
    label(ax, 50, 9.2, "Human-facing result: users receive both the Lean theorem names and runnable Qiskit export checks.", fs=10.8, weight="bold", color=NAVY)

    for path in [ARTICLE_FIG / "qiskit_export_results.png", README_FIG / "qiskit_export_results.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def _candidate_card(ax, x, title, tier, tier_color, target, score, theorem):
    """Shared shell for the two case-study candidate storyboards."""

    group_box(ax, x, 16, 22, 64, "", "#CBD5E1", "#FFFFFF")
    label(ax, x + 2, 75.5, title, fs=12.2, weight="bold", color=NAVY, ha="left")
    badge(ax, x + 2, 68.3, 18, 4.8, tier, fc="#FFFFFF", ec=tier_color, fs=8.8)
    label(ax, x + 2, 63.7, target, fs=8.7, color=MUTED, ha="left")
    if score:
        badge(ax, x + 2, 20.2, 18, 5.0, score, fc=GREEN_L, ec=GREEN, fs=9.2)
    else:
        badge(ax, x + 2, 20.2, 18, 5.0, "not rankable", fc=AMBER_L, ec=AMBER, fs=9.0)
    label(ax, x + 2, 17.8, theorem, fs=6.8, color="#475569", ha="left")


def draw_be_case1_candidates():
    """Four Lean-certified BE Case 1 candidates in one readable visual grammar."""

    fig, ax = setup(19.2, 9.0)
    label(ax, 3, 96, "BE Case 1 | certified candidate sequence", fs=22, weight="bold", color=NAVY, ha="left")
    label(ax, 3, 91.5, "Every card is a complete block encoding of the same transfer target; score comparisons stay inside a resource tier.", fs=10.8, color=MUTED, ha="left")
    badge(ax, 70, 92.8, 12, 3.6, "FULL BE", fc=GREEN_L, ec=GREEN, fs=8.1)
    badge(ax, 83.5, 92.8, 13.5, 3.6, "LEAN CERTIFIED", fc=BLUE_L, ec=BLUE, fs=8.1)

    xs = [3, 27, 51, 75]
    cards = [
        ("1  Oracle seed", "oracle-label tier", BLUE, r"target: $E_1$", "(1,1,1,1)", "exampleVerified"),
        ("2  Depth-5 circuit", "expanded logical tier", BLUE, r"target: $E_1$", "(6,5,1,0)", "reducedDepth5Verified"),
        ("3  Transfer circuit", "expanded logical tier", BLUE, r"target: $E_1$", "(4,4,1,0)", "proEqTransferVerified"),
        ("4  Parallel champion", "expanded logical tier", GREEN, r"target: $E_1$", "(4,2,1,0)", "evolvedEqFlipVerified"),
    ]
    for x, card in zip(xs, cards):
        _candidate_card(ax, x, *card)

    # Seed: a certified matrix-table completion behind one oracle label.
    for yy, nm in zip((55.5, 49.5, 43.5), ("a", "T", "tau")):
        wire(ax, xs[0] + 4.5, xs[0] + 18.8, yy, nm)
    gate(ax, xs[0] + 8.2, 41.5, 8.8, 16, "U_pi", fc=BLUE_L, ec=BLUE, fs=12)
    label(ax, xs[0] + 11, 36.7, "exact matrix table", fs=8.4, color=MUTED)

    # Depth-5: a longer certified reversible decomposition.
    for yy, nm in zip((55.5, 49.5, 43.5), ("a", "T", "tau")):
        wire(ax, xs[1] + 4.5, xs[1] + 18.8, yy, nm)
    for gx, txt in zip((xs[1] + 7.0, xs[1] + 10.2, xs[1] + 13.4, xs[1] + 16.6), ("=", "X", "CX", "X")):
        gate(ax, gx - 1.4, 46.2, 2.8, 6.5, txt, fc="#FFFFFF", ec=BLUE, fs=7.8)
    label(ax, xs[1] + 11, 36.7, "6 gates / 5 layers", fs=8.4, color=MUTED)

    # Four-gate transfer construction.
    for yy, nm in zip((55.5, 49.5, 43.5), ("a", "T", "tau")):
        wire(ax, xs[2] + 4.5, xs[2] + 18.8, yy, nm)
    control(ax, xs[2] + 8.5, 49.5)
    control(ax, xs[2] + 8.5, 43.5)
    ax.plot([xs[2] + 8.5, xs[2] + 8.5], [43.5, 55.5], color="#334155", lw=1.6)
    gate(ax, xs[2] + 7.1, 52.3, 2.8, 6.4, "X", fc=BLUE_L, ec=BLUE, fs=8.2)
    for gx, yy in ((xs[2] + 13, 49.5), (xs[2] + 16.2, 43.5)):
        gate(ax, gx - 1.4, yy - 3.2, 2.8, 6.4, "X", fc="#FFFFFF", ec=BLUE, fs=8.2)
    label(ax, xs[2] + 11, 36.7, "4 gates / 4 layers", fs=8.4, color=MUTED)

    # Champion: equal gate count, but independent flips share one layer.
    for yy, nm in zip((55.5, 49.5, 43.5), ("a", "T", "tau")):
        wire(ax, xs[3] + 4.5, xs[3] + 18.8, yy, nm)
    control(ax, xs[3] + 8.2, 49.5)
    control(ax, xs[3] + 8.2, 43.5)
    ax.plot([xs[3] + 8.2, xs[3] + 8.2], [43.5, 55.5], color="#334155", lw=1.6)
    gate(ax, xs[3] + 6.8, 52.3, 2.8, 6.4, "X", fc=GREEN_L, ec=GREEN, fs=8.2)
    for yy in (55.5, 49.5, 43.5):
        gate(ax, xs[3] + 14.2, yy - 2.5, 3.0, 5.0, "X", fc=GREEN_L, ec=GREEN, fs=8.0)
    ax.plot([xs[3] + 13.6, xs[3] + 17.8], [59.5, 59.5], color=GREEN, lw=2.0)
    label(ax, xs[3] + 11, 36.7, "4 gates / 2 layers", fs=8.4, color=GREEN, weight="bold")

    for left, right in zip(xs[:-1], xs[1:]):
        arrow(ax, left + 22.3, 48, right - 0.3, 48, color=ORANGE, lw=1.8)
    label(ax, 50, 7.5, "The oracle seed is a separate abstraction tier. Within the expanded logical tier, the certified frontier improves (6,5,1,0) -> (4,4,1,0) -> (4,2,1,0).", fs=9.7, weight="bold", color=NAVY)
    save_figure(fig, "be_case1_candidates")
    plt.close(fig)


def draw_be_case2_candidates():
    """Case 2 milestones without promoting partial certificates to full BEs."""

    fig, ax = setup(19.2, 9.0)
    label(ax, 3, 96, "BE Case 2 | certified construction milestones", fs=22, weight="bold", color=NAVY, ha="left")
    label(ax, 3, 91.5, "Green cards are complete block encodings; amber is a legal reusable clean-block certificate, not a full candidate.", fs=10.8, color=MUTED, ha="left")
    badge(ax, 70, 92.8, 12, 3.6, "FULL BE", fc=GREEN_L, ec=GREEN, fs=8.1)
    badge(ax, 83.5, 92.8, 13.5, 3.6, "INTERMEDIATE", fc=AMBER_L, ec=AMBER, fs=8.1)

    xs = [3, 27, 51, 75]
    cards = [
        ("1  Exact input BE", "complete supplier", GREEN, r"target: $O_0=\mathrm{diag}(j/N)$", "(1,1,3,1)", "linear...Contract_complete"),
        ("2  Cubic clean block", "clean-block certificate", AMBER, r"target block: $O_0^3=D_n$", "", "linear...Product...clean_eq"),
        ("3  Exact cubic BE", "complete target root", GREEN, r"target: $D_n=\mathrm{diag}((j/N)^3)$", "(1,1,3,1)", "cubic...Contract_complete"),
        ("4  Executable gate", "finite n=2 acceptance", ORANGE, r"same exact $D_n$ export", "QASM PASS", "Operator + OpenQASM 3"),
    ]
    for x, card in zip(xs, cards):
        _candidate_card(ax, x, *card)

    # Linear input block encoding.
    group_box(ax, xs[0] + 4, 38.5, 14, 20, "", GREEN, "#F8FFFA")
    label(ax, xs[0] + 11, 55.0, r"$U_0$", fs=12.5, weight="bold", color=NAVY)
    box(ax, xs[0] + 5.5, 42.2, 6.2, 7.2, r"$O_0$", "clean", fc=GREEN_L, ec=GREEN, fs=10, subfs=7)
    label(ax, xs[0] + 14.6, 45.8, "*", fs=15, color=MUTED)
    label(ax, xs[0] + 11, 34.0, r"$U_0^\mathsf{T}U_0=I$", fs=8.8, color=GREEN, weight="bold")

    # Product card: exact target block arithmetic, but no packaged unitary root.
    for gx in (xs[1] + 5.4, xs[1] + 10.4, xs[1] + 15.4):
        box(ax, gx, 45, 3.6, 8, r"$O_0$", fc=PURPLE_L, ec=PURPLE, fs=8.2)
    label(ax, xs[1] + 9.5, 49, "x", fs=9, color=MUTED)
    label(ax, xs[1] + 14.5, 49, "x", fs=9, color=MUTED)
    arrow(ax, xs[1] + 8.9, 40.8, xs[1] + 16.2, 40.8, color=AMBER, lw=1.7)
    badge(ax, xs[1] + 7.3, 35.5, 9.5, 4.2, r"clean = $D_n$", fc=AMBER_L, ec=AMBER, fs=7.4)

    # Complete direct cubic Householder block encoding.
    group_box(ax, xs[2] + 4, 38.5, 14, 20, "", GREEN, "#F8FFFA")
    label(ax, xs[2] + 11, 55.0, r"$U_D$", fs=12.5, weight="bold", color=NAVY)
    box(ax, xs[2] + 5.5, 42.2, 6.2, 7.2, r"$D_n$", "clean", fc=GREEN_L, ec=GREEN, fs=10, subfs=7)
    label(ax, xs[2] + 14.6, 45.8, "*", fs=15, color=MUTED)
    label(ax, xs[2] + 11, 34.0, r"$U_D^\mathsf{T}U_D=I$", fs=8.8, color=GREEN, weight="bold")

    # Finite exported circuit metrics are deliberately not mixed into the logical score.
    for yy, nm in zip((54.5, 49, 43.5), ("q0", "q1", "anc")):
        wire(ax, xs[3] + 4.2, xs[3] + 18.7, yy, nm)
    gate(ax, xs[3] + 8.4, 41.0, 7.2, 16, "QASM3", fc=ORANGE_L, ec=ORANGE, fs=10.2)
    label(ax, xs[3] + 11, 36.0, "638 gates | depth 465", fs=8.0, color=MUTED)
    label(ax, xs[3] + 11, 33.0, "clean error 0", fs=8.4, color=GREEN, weight="bold")

    for left, right in zip(xs[:-1], xs[1:]):
        arrow(ax, left + 22.3, 48, right - 0.3, 48, color=ORANGE, lw=1.8)
    label(ax, 50, 7.5, r"The hinted $O_0$ route contributes a complete supplier and a clean-block product card. The direct cubic Householder root is the first complete, rankable solution for $D_n$.", fs=9.7, weight="bold", color=NAVY)
    save_figure(fig, "be_case2_candidates")
    plt.close(fig)


def draw_be_case1_convergence():
    """Certified score frontier for Case 1, with resource tiers kept separate."""

    fig, ax = plt.subplots(figsize=(15.8, 7.4), dpi=180)
    fig.patch.set_facecolor(BG)
    ax.set_facecolor("#FFFFFF")
    steps = [1, 2, 3, 4]
    gates = [6, 4, 4, 4]
    depths = [5, 4, 2, 2]
    oracles = [0, 0, 0, 0]
    ax.axvspan(0.65, 4.35, color=BLUE_L, alpha=0.48)
    ax.plot(steps, gates, marker="o", ms=9, lw=3.0, color=BLUE, label="gate count")
    ax.plot(steps, depths, marker="s", ms=8, lw=3.0, color=ORANGE, label="depth")
    ax.plot(steps, oracles, marker="^", ms=8, lw=2.6, color=PURPLE, label="oracle calls")
    ax.scatter([0], [1], s=110, marker="D", color="#94A3B8", edgecolor="#475569", zorder=5)
    ax.annotate("oracle tier\n(1,1,1,1)", (0, 1), xytext=(0, 18), textcoords="offset points", ha="center", fontsize=10, fontweight="bold", color="#475569")
    ax.annotate("tier expansion", (0.45, 3.1), ha="center", fontsize=9.5, color=MUTED, rotation=90)
    for x, y, text_ in ((1, 6, "depth-5"), (2, 4, "4-gate transfer"), (3, 2, "depth-2 champion"), (4, 2, "export passed")):
        ax.annotate(text_, (x, y), xytext=(0, 15 if x != 3 else -34), textcoords="offset points", ha="center", fontsize=9.6, fontweight="bold", color=GREEN if x >= 3 else TEXT)
    ax.set_title("BE Case 1 | certified frontier by proof step", fontsize=20, fontweight="bold", color=NAVY, pad=18)
    ax.text(0.0, 1.025, "Only the expanded logical tier is connected and compared lexicographically.", transform=ax.transAxes, fontsize=11, color=MUTED)
    ax.set_xticks([0, 1, 2, 3, 4], ["oracle seed", "step 1", "step 2", "step 3", "accept"])
    ax.set_ylabel("logical resource count", fontsize=13, fontweight="bold")
    ax.set_ylim(-0.4, 7.0)
    ax.grid(True, axis="y", color="#E2E8F0", linewidth=1.1)
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["left", "bottom"]].set_color("#64748B")
    ax.tick_params(labelsize=11)
    legend = ax.legend(loc="upper right", ncol=3, frameon=True, fontsize=10.5)
    legend.get_frame().set_edgecolor("#CBD5E1")
    legend.get_frame().set_facecolor("#FFFFFF")
    fig.text(0.5, 0.015, "Expanded-tier frontier: (6,5,1,0) -> (4,4,1,0) -> (4,2,1,0). Every plotted point has a Lean certificate.", ha="center", fontsize=10.2, fontweight="bold", color=NAVY)
    fig.tight_layout(rect=(0.03, 0.055, 0.98, 0.96))
    save_figure(fig, "be_case1_convergence")
    plt.close(fig)


def draw_be_case2_convergence():
    """Proof-closure milestones for the cold and hinted Case 2 arms."""

    fig, ax = plt.subplots(figsize=(15.8, 7.4), dpi=180)
    fig.patch.set_facecolor(BG)
    ax.set_facecolor("#FFFFFF")
    cold_x, cold_y = [0, 1, 3, 4], [0, 1, 3, 4]
    hint_x, hint_y = [0, 1, 2, 3, 4], [0, 2, 2, 3, 4]
    ax.plot(cold_x, cold_y, marker="o", ms=9, lw=3.0, color=BLUE, label="cold arm")
    ax.plot(hint_x, hint_y, marker="s", ms=8, lw=3.0, color=PURPLE, label="hinted arm")
    ax.axhspan(2.75, 4.25, color=GREEN_L, alpha=0.58)
    annotations = [
        (1, 1, "cubic branch\nproof leaves", BLUE, -42),
        (1, 2, "exact $O_0$\nsupplier", PURPLE, 16),
        (2, 2, "$O_0^3$ clean\nblock card", PURPLE, -42),
        (3, 3, "full $D_n$ root", GREEN, 16),
        (4, 4, "Qiskit + QASM\naccepted", GREEN, 16),
    ]
    for x, y, text_, color, offset in annotations:
        ax.annotate(text_, (x, y), xytext=(0, offset), textcoords="offset points", ha="center", fontsize=9.5, fontweight="bold", color=color)
    ax.set_title("BE Case 2 | certified closure by proof milestone", fontsize=20, fontweight="bold", color=NAVY, pad=18)
    ax.text(0.0, 1.025, "Milestone order records proof closure, not wall-clock time or model-call count.", transform=ax.transAxes, fontsize=11, color=MUTED)
    ax.set_xticks([0, 1, 2, 3, 4], ["target", "supplier/leaves", "consumer", "full root", "accept"])
    ax.set_yticks([0, 1, 2, 3, 4], ["target fixed", "proof leaves", "supplier / clean block", "full target BE", "Lean + export"])
    ax.set_xlim(-0.15, 4.2)
    ax.set_ylim(-0.25, 4.35)
    ax.grid(True, axis="y", color="#E2E8F0", linewidth=1.1)
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["left", "bottom"]].set_color("#64748B")
    ax.tick_params(labelsize=11)
    legend = ax.legend(loc="lower right", frameon=True, fontsize=11)
    legend.get_frame().set_edgecolor("#CBD5E1")
    legend.get_frame().set_facecolor("#FFFFFF")
    fig.text(0.5, 0.015, r"Both isolated arms reach the same complete cubic root; the hinted arm additionally closes the exact $O_0$ supplier and product clean block.", ha="center", fontsize=10.2, fontweight="bold", color=NAVY)
    fig.tight_layout(rect=(0.03, 0.055, 0.98, 0.96))
    save_figure(fig, "be_case2_convergence")
    plt.close(fig)


def _draw_lex_score_table(title, subtitle, rows, footer, stem):
    """Render a compact table that keeps semantic eligibility next to scores."""

    fig, ax = setup(18.4, 8.2)
    label(ax, 3, 95, title, fs=22, weight="bold", color=NAVY, ha="left")
    label(ax, 3, 90.5, subtitle, fs=10.7, color=MUTED, ha="left")
    columns = ((3, 29, "Candidate / route"), (32, 18, "Certificate tier"), (50, 12, "Target"), (62, 15, "Score (g,d,a,o)"), (77, 20, "Selection status"))
    for x, w, text_ in columns:
        patch = FancyBboxPatch((x, 79), w, 7, boxstyle="round,pad=0.01,rounding_size=0.5", linewidth=1.4, edgecolor=NAVY, facecolor=NAVY)
        ax.add_patch(patch)
        label(ax, x + 1.4, 82.5, text_, fs=9.2, weight="bold", color="#FFFFFF", ha="left")
    y_positions = (67, 55, 43, 31)
    for y, row in zip(y_positions, rows):
        candidate, tier, target, score, status, status_color = row
        row_fc = GREEN_L if status_color == GREEN else AMBER_L if status_color == AMBER else "#F8FAFC"
        for x, w, _ in columns:
            patch = FancyBboxPatch((x, y), w, 9.5, boxstyle="round,pad=0.01,rounding_size=0.35", linewidth=1.0, edgecolor="#D7DEE8", facecolor=row_fc if x == 77 else "#FFFFFF")
            ax.add_patch(patch)
        label(ax, 4.4, y + 4.75, candidate, fs=9.0, weight="bold", color=TEXT, ha="left")
        label(ax, 33.4, y + 4.75, tier, fs=8.7, color=TEXT, ha="left")
        label(ax, 51.4, y + 4.75, target, fs=8.9, color=TEXT, ha="left")
        ax.text(69.5, y + 4.75, score, ha="center", va="center", fontsize=9.2, fontweight="bold", family="monospace", color=TEXT)
        label(ax, 78.4, y + 4.75, status, fs=8.6, weight="bold", color=status_color, ha="left")
    group_box(ax, 3, 10, 94, 13.5, "Reading rule", BLUE, "#F7FAFF")
    label(ax, 5.5, 15.0, footer, fs=9.2, color=TEXT, ha="left")
    save_figure(fig, stem)
    plt.close(fig)


def draw_be_case1_score_table():
    rows = [
        ("Oracle matrix-table seed", "complete BE / oracle", r"$E_1$", "(1,1,1,1)", "separate resource tier", BLUE),
        ("Reduced depth-5 circuit", "complete BE / expanded", r"$E_1$", "(6,5,1,0)", "eligible parent", BLUE),
        ("Pro or no-Pro transfer", "complete BE / expanded", r"$E_1$", "(4,4,1,0)", "frontier improvement", BLUE),
        ("Evolved parallel flip", "complete BE / expanded", r"$E_1$", "(4,2,1,0)", "selected champion", GREEN),
    ]
    _draw_lex_score_table(
        "BE Case 1 | lexicographic selection table",
        "Order inside one semantic/resource tier: gate count, depth, auxiliary qubits, then unresolved oracle calls.",
        rows,
        "Do not compare the one-call oracle abstraction directly with expanded logical circuits. In the expanded tier, four gates tie and depth 2 defeats depth 4.",
        "be_case1_score_table",
    )


def draw_be_case2_score_table():
    rows = [
        ("Primitive amplitude oracle", "conditional candidate", r"$D_n$", "(1,1,1,1)", "blocked: contract open", RED),
        ("Exact linear Householder", "complete supplier BE", r"$O_0$", "(1,1,3,1)", "different target", BLUE),
        ("Three-input product card", "clean block only", r"$D_n$", "--", "not a full BE", AMBER),
        ("Exact cubic Householder", "complete target BE", r"$D_n$", "(1,1,3,1)", "selected root", GREEN),
    ]
    _draw_lex_score_table(
        "BE Case 2 | eligibility before lexicographic score",
        "A lower tuple cannot win until the target, unitarity, clean block, normalizer, and resource obligations are all closed.",
        rows,
        "For Householder roots, a=3 follows from total dimension 8N; Lean certifies one oracle label at depth 1. The n=2 cubic QASM expansion (638 gates, depth 465) is an export metric, not this logical score.",
        "be_case2_score_table",
    )


def draw_evolution_acceptance_pipeline():
    """Reader-facing view of population evolution and the two final gates."""

    fig, ax = setup(18.0, 7.0)
    label(ax, 4, 94, "ABEIS evolves a route, then requires two different gates", fs=23, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        4,
        88,
        "Middle maintains candidates; upper/reviewer selects direction; Lean proves the family; Qiskit/QASM validates the declared finite export.",
        fs=11.5,
        color=MUTED,
        ha="left",
    )

    xs = [3, 20, 37, 54, 71, 87]
    widths = [12.5, 12.5, 12.5, 12.5, 12.5, 10.0]
    nodes = [
        ("Fixed contract", "state/target, alpha,\nprojector, epsilon", BLUE_L, BLUE),
        ("Memory + population", "retrieve, propose,\nretain / retire", PURPLE_L, PURPLE),
        ("Selected direction", "mutate / crossover,\none ready leaf", AMBER_L, AMBER),
        ("Lean gate", "unitary + semantic\nroot certificate", GREEN_L, GREEN),
        ("Executable gate", "Qiskit Operator +\nparsed QASM3", ORANGE_L, ORANGE),
        ("Complete", "both gates\nand artifacts pass", GREEN_L, GREEN),
    ]
    for x, w, (title, subtitle, fc, ec) in zip(xs, widths, nodes):
        box(ax, x, 55, w, 18, title, subtitle, fc=fc, ec=ec, fs=12.3, subfs=8.3)
    for index in range(len(xs) - 1):
        arrow(ax, xs[index] + widths[index], 64, xs[index + 1], 64, color="#475569", lw=2.2)

    box(
        ax,
        19,
        22,
        29,
        14,
        "Typed evolution feedback",
        "fitness evidence, parents, selection, failure class",
        fc="#FFFFFF",
        ec=PURPLE,
        fs=11.8,
        subfs=8.1,
    )
    box(
        ax,
        55,
        22,
        27,
        14,
        "Bounded control decision",
        "one capacity level or one adjacent epsilon rung",
        fc="#FFFFFF",
        ec=BLUE,
        fs=11.8,
        subfs=8.1,
    )
    arrow(ax, 60, 55, 47, 36, color=RED, lw=2.0, dashed=True, rad=-0.08)
    arrow(ax, 33, 36, 27, 55, color=PURPLE, lw=2.0, dashed=True, rad=0.08)
    arrow(ax, 42, 55, 58, 36, color=AMBER, lw=1.8, dashed=True, rad=0.08)
    arrow(ax, 69, 36, 76, 55, color=BLUE, lw=1.8, dashed=True, rad=-0.08)
    label(ax, 49, 44, "no progress", fs=9.5, weight="bold", color=RED)
    label(ax, 4, 9, "Stop invariant", fs=10.5, weight="bold", color=RED, ha="left")
    label(
        ax,
        16,
        9,
        "unchanged evidence without a typed population/control update stops before another model call",
        fs=10.2,
        color=TEXT,
        ha="left",
    )

    for path in [
        ARTICLE_FIG / "abeis_evolution_acceptance.png",
        ARTICLE_FIG / "abeis_evolution_acceptance.svg",
        README_FIG / "abeis_evolution_acceptance.png",
        README_FIG / "abeis_evolution_acceptance.svg",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_aspbe_harness_flow():
    """Draw the shared controller without merging its two input contracts."""

    fig, ax = setup(18.0, 7.0)
    label(ax, 4, 94, "ASPBE turns a fixed quantum contract into checked evidence", fs=21, weight="bold", color=NAVY, ha="left")
    label(ax, 4, 89, "State Preparation and Block Encoding enter separately; search infrastructure is shared only after the contract is frozen.", fs=11, color=MUTED, ha="left")

    box(ax, 4, 64, 18, 13, "State Preparation", r"$U|0^n\rangle=|\psi\rangle$", fc="#F7FCF9", ec=GREEN, fs=12, subfs=10)
    box(ax, 4, 43, 18, 13, "Block Encoding", r"$\|A-\alpha\Pi U\Pi^\dagger\|\leq\varepsilon$", fc="#F8F7FC", ec=PURPLE, fs=12, subfs=9.1)

    stages = [
        (29, "Freeze", "hash target +\nconventions"),
        (44, "Retrieve", "compiled lemmas +\nmemory cards"),
        (59, "Select", "population route +\nready DAG leaf"),
        (74, "Prove", "diagnostic + one\nnamed Lean leaf"),
        (89, "Accept", "Lean root, then\nQiskit / QASM"),
    ]
    for x, title, note in stages:
        edge = GREEN if title == "Accept" else "#64748B"
        face = GREEN_L if title == "Accept" else "#FFFFFF"
        box(ax, x - 6, 52, 12, 16, title, note, fc=face, ec=edge, fs=11.5, subfs=7.8, lw=1.8)
    arrow(ax, 22, 70.5, 23, 62, color=GREEN, lw=1.8)
    arrow(ax, 22, 49.5, 23, 58, color=PURPLE, lw=1.8)
    for left, right in zip(stages, stages[1:]):
        arrow(ax, left[0] + 6.3, 60, right[0] - 6.3, 60, color="#475569", lw=1.8)

    label(ax, 29, 75, "UPPER", fs=8.5, weight="bold", color=MUTED)
    label(ax, 51.5, 75, "MIDDLE", fs=8.5, weight="bold", color=MUTED)
    label(ax, 74, 75, "LOWER", fs=8.5, weight="bold", color=MUTED)
    label(ax, 89, 75, "REVIEW + GATES", fs=8.5, weight="bold", color=MUTED)

    ax.plot([29, 89], [35, 35], color="#CBD5E1", linewidth=1.5)
    durable = [
        (29, "contract", "fixed"),
        (44, "memory", "typed reuse"),
        (59, "population + DAG", "propose / retain / retire"),
        (74, "feedback", "classified failure"),
        (89, "evidence", "digest + artifacts"),
    ]
    for x, title, note in durable:
        ax.scatter([x], [35], s=42, facecolor="white", edgecolor="#64748B", linewidth=1.3, zorder=3)
        label(ax, x, 29.5, title, fs=9.3, weight="bold", color=TEXT)
        label(ax, x, 25.5, note, fs=7.8, color=MUTED)
    label(ax, 23, 35, "DURABLE STATE", fs=8.3, weight="bold", color=MUTED, ha="right")

    arrow(ax, 80, 52, 53, 38, color=RED, lw=1.6, dashed=True, rad=0.16)
    label(ax, 68, 41.5, "typed failure updates the route", fs=8.4, weight="bold", color=RED)
    arrow(ax, 59, 24, 29, 18, color=BLUE, lw=1.4, dashed=True, rad=-0.08)
    label(ax, 44, 14.5, "upper may change one capacity level or one adjacent epsilon rung", fs=8.4, color=BLUE)
    label(ax, 4, 7.5, "STOP RULE", fs=9, weight="bold", color=RED, ha="left")
    label(ax, 14, 7.5, "same leaf + same evidence digest + no typed population or policy change  ->  stop before another model call", fs=9.3, weight="bold", color=NAVY, ha="left")

    save_figure(fig, "aspbe_harness_flow", pdf=True)
    plt.close(fig)


def draw_be_case2_summary():
    """Reader-facing comparison of the isolated cold and hinted hard arms."""

    fig, ax = setup(18.0, 9.0)
    label(ax, 4, 95, "BE Case 2 | cubic diagonal operator", fs=23, weight="bold", color=NAVY, ha="left")
    label(ax, 4, 90.7, "Two isolated arms close the same exact contract and then pass independent Qiskit / OpenQASM 3 acceptance.", fs=11.5, color=MUTED, ha="left")
    group_box(ax, 12, 79.0, 76, 8.5, "", BLUE, "#F7FAFF")
    ax.text(50, 83.0, r"$D_n=\mathrm{diag}\!\left(0^3,(1/N)^3,\ldots,((N-1)/N)^3\right),\quad N=2^n,\ \alpha=1$", ha="center", va="center", fontsize=13.5, color=TEXT)

    lanes = [
        (4, "COLD ARM", "No prior cubic run memory", BLUE, BLUE_L),
        (52, "HINTED ARM", r"Seed: $O_0=\mathrm{diag}(j/2^n)$ then $x^3$", PURPLE, PURPLE_L),
    ]
    for x, title, subtitle, ec, fc in lanes:
        group_box(ax, x, 22, 44, 55, title, ec, "#FFFFFF")
        label(ax, x + 4, 70.8, subtitle, fs=10.2, color=MUTED, ha="left")

    # Cold lane.
    box(ax, 8, 57, 36, 10, "Direct cubic completion", "four squares for $N^6-j^6$\nclean coordinate $(j/N)^3$", fc=BLUE_L, ec=BLUE, fs=12.2, subfs=8.3)
    box(ax, 8, 43, 36, 10, "Exact Lean root", "cubicDiagonalHouseholder\nExactBEContract_complete", fc=GREEN_L, ec=GREEN, fs=12.2, subfs=8.1)
    box(ax, 8, 29, 36, 10, "Finite executable gate | n=2", "clean block 0 | unitary 2.22e-16\nQASM error 1.86e-12 | parsed", fc=ORANGE_L, ec=ORANGE, fs=11.7, subfs=8.0)
    arrow(ax, 26, 56.7, 26, 53.3, color=BLUE, lw=2.0)
    arrow(ax, 26, 42.7, 26, 39.3, color=GREEN, lw=2.0)

    # Hinted lane.
    box(ax, 56, 57, 36, 10, "Hint translated into two roots", "linear $O_0$ supplier + $O_0^3=D_n$\nQSVT optional, not a blocker", fc=PURPLE_L, ec=PURPLE, fs=12.0, subfs=8.1)
    box(ax, 56, 43, 36, 10, "Exact Lean roots", "linearDiagonalHouseholder...complete\ncubicDiagonalHouseholder...complete", fc=GREEN_L, ec=GREEN, fs=11.8, subfs=7.8)
    box(ax, 56, 29, 36, 10, "Finite executable gate | n=2", "linear + cubic clean blocks 0\nmax QASM error 1.86e-12 | parsed", fc=ORANGE_L, ec=ORANGE, fs=11.7, subfs=8.0)
    arrow(ax, 74, 56.7, 74, 53.3, color=PURPLE, lw=2.0)
    arrow(ax, 74, 42.7, 74, 39.3, color=GREEN, lw=2.0)

    group_box(ax, 7, 7, 86, 10, "", GREEN, "#F5FCF7")
    label(ax, 9.5, 14.7, "Frozen acceptance boundary", fs=11.0, weight="bold", color=GREEN, ha="left")
    badge(ax, 10, 8.6, 14, 3.7, "control v5", fc=GREEN_L, ec=GREEN, fs=9.0)
    badge(ax, 27, 8.6, 19, 3.7, "fresh isolated copies", fc=GREEN_L, ec=GREEN, fs=9.0)
    badge(ax, 49, 8.6, 18, 3.7, "Lean + Tests pass", fc=GREEN_L, ec=GREEN, fs=9.0)
    badge(ax, 70, 8.6, 19, 3.7, "Qiskit 2.4.2 pass", fc=GREEN_L, ec=GREEN, fs=9.0)
    label(ax, 50, 3.7, "Final closeout reused compiled roots and spent zero model input tokens; search is skipped when no open proof leaf remains.", fs=10.1, weight="bold", color=NAVY)

    for path in [
        ARTICLE_FIG / "be_case2_cold_hinted.png",
        ARTICLE_FIG / "be_case2_cold_hinted.svg",
        README_FIG / "be_case2_cold_hinted.png",
        README_FIG / "be_case2_cold_hinted.svg",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_be_case2_proof_dag():
    """Expose the mathematical Lean dependencies for the cubic hard case."""

    fig, ax = setup(19.0, 9.2)
    label(ax, 3.5, 95, "BE Case 2 | exact rational Householder proof DAG", fs=22, weight="bold", color=NAVY, ha="left")
    label(ax, 3.5, 90.8, "Dependencies run left to right. Boxes show the mathematical move first and the representative Lean declaration second.", fs=11.0, color=MUTED, ha="left")

    headers = [(4, "NUMBER THEORY"), (22, "BRANCH VECTOR"), (40, "HOUSEHOLDER"), (57, "CONTROLLED SUM"), (74, "ROOT CERTIFICATE"), (89, "EXPORT")]
    for x, text_ in headers:
        label(ax, x, 84.5, text_, fs=8.7, weight="bold", color="#64748B", ha="left")

    # Linear / hinted row.
    label(ax, 2.5, 68, "linear", fs=9.5, weight="bold", color=PURPLE, ha="left")
    box(ax, 4, 61, 15, 13, r"$N^2-j^2=\sum_1^4 s_k^2$", "Nat.sum_four_squares\n...Completion_exists", fc=PURPLE_L, ec=PURPLE, fs=10.8, subfs=6.9)
    box(ax, 22, 61, 15, 13, r"$v_j[0]=j/N$", "...FourSquareBranchVector\nclean + unit", fc=PURPLE_L, ec=PURPLE, fs=10.8, subfs=6.9)
    box(ax, 40, 61, 14, 13, r"$H(v_j)_{00}=v_j[0]$", "householder8_clean_entry\nhouseholder8_isRationalOrthogonal", fc=BLUE_L, ec=BLUE, fs=10.8, subfs=6.7)
    box(ax, 57, 61, 14, 13, r"$\bigoplus_j H(v_j)$", "...clean_entry\n...isRationalOrthogonal", fc=BLUE_L, ec=BLUE, fs=10.8, subfs=6.7)
    box(ax, 74, 61, 12, 13, r"BE of $O_0$", "linearDiagonalHouseholder\nInputBEContract_complete", fc=GREEN_L, ec=GREEN, fs=10.6, subfs=6.5)
    box(ax, 89, 61, 8, 13, "QASM3", "linear\nparsed", fc=ORANGE_L, ec=ORANGE, fs=10.3, subfs=6.7)

    # Cubic / cold row.
    label(ax, 2.5, 40, "cubic", fs=9.5, weight="bold", color=BLUE, ha="left")
    box(ax, 4, 33, 15, 13, r"$N^6-j^6=\sum_1^4 s_k^2$", "Nat.sum_four_squares\n...Completion_exists", fc=BLUE_L, ec=BLUE, fs=10.8, subfs=6.9)
    box(ax, 22, 33, 15, 13, r"$v_j[0]=(j/N)^3$", "cubicDiagonalFourSquare\nBranchVector_clean + unit", fc=BLUE_L, ec=BLUE, fs=10.8, subfs=6.7)
    box(ax, 40, 33, 14, 13, r"$H(v_j)_{00}=v_j[0]$", "shared Householder\nclean + orthogonal", fc=BLUE_L, ec=BLUE, fs=10.8, subfs=6.7)
    box(ax, 57, 33, 14, 13, r"$\bigoplus_j H(v_j)$", "backendSupport\nclean block + orthogonal", fc=BLUE_L, ec=BLUE, fs=10.8, subfs=6.7)
    box(ax, 74, 33, 12, 13, r"BE of $D_n$", "cubicDiagonalHouseholder\nExactBEContract_complete", fc=GREEN_L, ec=GREEN, fs=10.6, subfs=6.4)
    box(ax, 89, 33, 8, 13, "QASM3", "cubic\nparsed", fc=ORANGE_L, ec=ORANGE, fs=10.3, subfs=6.7)

    for y in (67.5, 39.5):
        for x1, x2 in [(19.3, 21.7), (37.3, 39.7), (54.3, 56.7), (71.3, 73.7), (86.3, 88.7)]:
            arrow(ax, x1, y, x2, y, color="#475569", lw=1.7)

    group_box(ax, 18, 11, 68, 14, "Hint interpretation", PURPLE, "#FBF9FF")
    box(ax, 22, 15, 19, 6, r"$O_0^3=D_n$", "cubicGridValue_eq_...pow_three", fc="#FFFFFF", ec=PURPLE, fs=10.7, subfs=6.8)
    box(ax, 47, 15, 17, 6, "QSVT consumer", "optional resource route", fc="#FFFFFF", ec=PURPLE, fs=10.7, subfs=6.8)
    box(ax, 70, 15, 12, 6, "Root closed", "direct exact BE", fc=GREEN_L, ec=GREEN, fs=10.7, subfs=6.8)
    arrow(ax, 41.3, 18, 46.7, 18, color=PURPLE, lw=1.7, dashed=True)
    arrow(ax, 64.3, 18, 69.7, 18, color=PURPLE, lw=1.7, dashed=True)
    arrow(ax, 80, 60.7, 76, 25.3, color=PURPLE, lw=1.4, dashed=True, rad=-0.18)
    label(ax, 50, 5.3, "The hint is useful direction evidence, but the exact cubic Householder root removes QSVT as a correctness dependency.", fs=10.2, weight="bold", color=NAVY)

    for path in [
        ARTICLE_FIG / "be_case2_proof_dag.png",
        ARTICLE_FIG / "be_case2_proof_dag.svg",
        README_FIG / "be_case2_proof_dag.png",
        README_FIG / "be_case2_proof_dag.svg",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_abeis_lean_lemma_tree():
    """Domain-oriented Lean tree for researchers; this is not import order."""

    fig, ax = setup(21.0, 11.8)
    label(ax, 3.5, 96, "ABEIS Lean lemma tree | mathematical dependency view", fs=23, weight="bold", color=NAVY, ha="left")
    label(ax, 3.5, 92.3, "Read top to bottom; arrows are representative dependencies, while the generated declaration index is exhaustive.", fs=10.8, color=MUTED, ha="left")

    layers = [
        (78.3, "1  FINITE ALGEBRA + CIRCUITS", BLUE),
        (61, "2  SEMANTIC CERTIFICATES", GREEN),
        (40, "3  REUSABLE CONSTRUCTION ROUTES", PURPLE),
        (20, "4  CERTIFIED CONSUMERS", AMBER),
    ]
    for y, text_, color in layers:
        label(ax, 3.5, y + 12.2, text_, fs=9.0, weight="bold", color=color, ha="left")

    foundation = [
        (4, "Core", "Matrix, PointwiseEq\nFin / grid arithmetic"),
        (28, "CircuitSemantics", "eval paths, products\nclean-index extraction"),
        (52, "Circuit", "gate syntax\nlayered schedules"),
        (76, "Resources", "gates, depth\naux, oracle calls"),
    ]
    for x, title, sub in foundation:
        box(ax, x, 80, 20, 9, title, sub, fc=BLUE_L, ec=BLUE, fs=11.5, subfs=7.6)

    contracts = [
        (4, "State preparation", "FirstColumnMatches\nVerifiedStatePreparation"),
        (28, "Exact clean block", "ExactCleanBlock\nclean_eq_target"),
        (52, "Approximate BE", "VerifiedApproximate...\nzero-error promotion"),
        (76, "Candidate score", "target fidelity gate\nlexicographic Resource"),
    ]
    for x, title, sub in contracts:
        box(ax, x, 61, 20, 9, title, sub, fc=GREEN_L, ec=GREEN, fs=11.3, subfs=7.4)

    routes = [
        (3, "Permutation", "permMatrix orthogonality\npartialPermutationCertificate"),
        (22, "Householder", "clean entry + orthogonality\ncontrolled direct sum"),
        (41, "Sparse / value", "oneSparse, row-column\ncompute-rotate-uncompute"),
        (60, "LCU / product", "weightedSum2\nproductExactCleanBlock"),
        (79, "QSVT / dilation", "consumer contract\nscalar fallback"),
    ]
    for x, title, sub in routes:
        box(ax, x, 40, 17, 10, title, sub, fc=PURPLE_L, ec=PURPLE, fs=10.7, subfs=7.0)

    consumers = [
        (4, "State-prep cases", "single-qubit + first-column\nPREPARE memories"),
        (28, "BE Case 1", "coldE1...permutation\nevolvedEqFlipVerified"),
        (52, "BE Case 2", "linear + cubic\nHouseholder roots"),
        (76, "Paper cases", "GHL2025 + RobinHeat\nsource correspondence"),
    ]
    for x, title, sub in consumers:
        box(ax, x, 20, 20, 10, title, sub, fc=AMBER_L, ec=AMBER, fs=11.2, subfs=7.1)

    # Foundation to contract.
    for x in (14, 38, 62, 86):
        arrow(ax, x, 79.7, x, 70.3, color=BLUE, lw=1.7)
    # Contracts fan into reusable routes.
    for x1, x2 in [(14, 11.5), (38, 30.5), (38, 49.5), (62, 68.5), (86, 87.5)]:
        arrow(ax, x1, 60.7, x2, 50.3, color=GREEN, lw=1.6, rad=0.05)
    # Routes to task consumers.
    for x1, x2 in [(11.5, 38), (30.5, 62), (49.5, 86), (68.5, 86), (87.5, 62)]:
        arrow(ax, x1, 39.7, x2, 30.3, color=PURPLE, lw=1.6, rad=-0.05)
    arrow(ax, 30.5, 39.7, 14, 30.3, color=PURPLE, lw=1.4, dashed=True, rad=0.10)

    label(ax, 8, 15.8, "5  ACCEPTANCE + RETRIEVAL", fs=9.0, weight="bold", color="#64748B", ha="left")
    group_box(ax, 6, 4, 88, 9, "", "#64748B", "#FFFFFF")
    badge(ax, 10, 6.5, 17, 4, "Lean root anchors", fc=GREEN_L, ec=GREEN, fs=9.2)
    badge(ax, 31, 6.5, 18, 4, "compiled leaf index", fc=BLUE_L, ec=BLUE, fs=9.2)
    badge(ax, 53, 6.5, 17, 4, "Qiskit Operator", fc=ORANGE_L, ec=ORANGE, fs=9.2)
    badge(ax, 74, 6.5, 16, 4, "parsed QASM3", fc=ORANGE_L, ec=ORANGE, fs=9.2)
    for x in (14, 38, 62, 86):
        arrow(ax, x, 19.7, x, 13.3, color=AMBER, lw=1.6)

    for path in [
        ARTICLE_FIG / "abeis_lean_lemma_tree.png",
        ARTICLE_FIG / "abeis_lean_lemma_tree.svg",
        README_FIG / "abeis_lean_lemma_tree.png",
        README_FIG / "abeis_lean_lemma_tree.svg",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def draw_quantum_lean_leaf_atlas():
    fig, ax = setup(16.5, 9.2)
    label(ax, 5, 94.5, "ABEIS Lean leaf atlas: from quantum libraries to block-encoding certificates", fs=21, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        5,
        90.5,
        "Small Mathlib-quality leaves are the reusable proof weapons. External quantum Lean projects are reference surfaces, not hidden dependencies.",
        fs=11.3,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 4, 72.0, 92, 14.0, "", "#94A3B8", "#FFFFFF")
    label(ax, 6.2, 84.0, "Reference foundations", fs=13.5, weight="bold", color="#64748B", ha="left")
    box(ax, 7, 75.1, 19, 6.3, "Mathlib", "finite sums, matrices,\nextensionality", fc=GRAY, ec="#64748B", fs=12.3, subfs=8.5)
    box(ax, 29, 75.1, 25, 6.3, "quantum-computing-lean", "states, gates,\nprojectors, actions", fc=BLUE_L, ec=BLUE, fs=11.9, subfs=8.2)
    box(ax, 57, 75.1, 16, 6.3, "Lean-QuantumInfo", "quantum-info\nstyle reference", fc=PURPLE_L, ec=PURPLE, fs=11.4, subfs=8.0)
    box(ax, 76, 75.1, 17, 6.3, "lean-quantum", "states, channels,\noperator style", fc=PURPLE_L, ec=PURPLE, fs=11.5, subfs=8.0)

    group_box(ax, 4, 43.5, 92, 24.0, "", BLUE, "#F8FBFF")
    label(ax, 6.2, 65.5, "ABEIS compiled leaf layer", fs=13.5, weight="bold", color=BLUE, ha="left")
    box(ax, 7, 57.0, 18, 6.0, "clean block", "entrywise extensionality", fc=BLUE_L, ec=BLUE, fs=12.1, subfs=8.0)
    box(ax, 28, 57.0, 18, 6.0, "permutation", "image table,\ninverse, unitarity", fc=BLUE_L, ec=BLUE, fs=12.1, subfs=8.0)
    box(ax, 49, 57.0, 18, 6.0, "sparse access", "delta sums,\nunique slots", fc=BLUE_L, ec=BLUE, fs=12.1, subfs=8.0)
    box(ax, 70, 57.0, 21, 6.0, "arithmetic", "LCU, product,\ntensor resources", fc=BLUE_L, ec=BLUE, fs=12.1, subfs=8.0)
    box(ax, 15, 46.9, 21, 6.0, "dilation / Hermitian", "contraction fallback,\nsymmetry contracts", fc=GREEN_L, ec=GREEN, fs=11.8, subfs=7.9)
    box(ax, 40, 46.9, 21, 6.0, "QSVT consumer", "uses a proved BE;\nno hidden oracle", fc=GREEN_L, ec=GREEN, fs=11.8, subfs=7.9)
    box(ax, 65, 46.9, 21, 6.0, "approximate BE", "epsilon-zero incumbent,\nrelaxed search", fc=GREEN_L, ec=GREEN, fs=11.8, subfs=7.9)

    group_box(ax, 4, 17.0, 92, 20.0, "", GREEN, "#F7FFF9")
    label(ax, 6.2, 35.0, "Task certificates and exports", fs=13.5, weight="bold", color=GREEN, ha="left")
    box(ax, 7, 27.5, 19, 6.0, "BE Case 1", "matrix-unit tensor I", fc=AMBER_L, ec=AMBER, fs=12.0, subfs=8.1)
    box(ax, 30, 27.5, 19, 6.0, "formula oracles", "diagonal/value-to-\namplitude routes", fc=AMBER_L, ec=AMBER, fs=11.6, subfs=7.9)
    box(ax, 53, 27.5, 19, 6.0, "paper cases", "GHL, sparse PDE,\nstructured matrices", fc=AMBER_L, ec=AMBER, fs=11.6, subfs=7.9)
    box(ax, 76, 27.5, 17, 6.0, "exports", "LaTeX proof,\nQiskit/QASM", fc=AMBER_L, ec=AMBER, fs=11.6, subfs=7.9)
    box(ax, 27, 18.9, 46, 4.8, "Mathlib-quality policy", "small statements, explicit APIs, stable proof routes, reusable hidden regularity", fc="#FFFFFF", ec="#64748B", fs=11.2, subfs=8.0)

    # Arrows from foundations to leaves.
    for x in [16.5, 41.5, 65, 84.5]:
        arrow(ax, x, 74.8, x, 68.0, color="#64748B", lw=2.0)
    for x1, x2 in [(16, 16), (42, 37), (65, 58), (85, 80)]:
        arrow(ax, x1, 71.8, x2, 63.8, color="#64748B", lw=1.8, dashed=True)

    # Leaf dependencies.
    arrow(ax, 25, 60.4, 28, 60.4, color=BLUE, lw=2.5)
    arrow(ax, 46, 60.4, 49, 60.4, color=BLUE, lw=2.5)
    arrow(ax, 67, 60.4, 70, 60.4, color=BLUE, lw=2.5)
    arrow(ax, 37, 56.9, 25.5, 53.4, color=GREEN, lw=2.1, rad=0.15)
    arrow(ax, 58, 56.9, 50.5, 53.4, color=GREEN, lw=2.1, rad=0.12)
    arrow(ax, 80, 56.9, 75.5, 53.4, color=GREEN, lw=2.1, rad=0.10)

    # Leaves to task layer.
    for x1, x2 in [(16, 16.5), (37, 39.5), (58, 62.5), (80, 84.5)]:
        arrow(ax, x1, 43.2, x2, 34.1, color=AMBER, lw=2.0)
    arrow(ax, 50, 43.2, 50, 34.1, color=AMBER, lw=2.0)

    # Policy feedback.
    box(ax, 7, 6.4, 34, 5.1, "failure signal", "recheck statement, assumptions, or counterexample", fc=RED_L, ec=RED, fs=10.8, subfs=7.6)
    arrow(ax, 24, 11.7, 8.8, 43.8, color=RED, lw=1.8, dashed=True, rad=0.22)

    for path in [ARTICLE_FIG / "quantum_lean_leaf_atlas.png", README_FIG / "quantum_lean_leaf_atlas.png"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def module_node(ax, x, y, w, h, title, subtitle="", fc="#FFFFFF", ec="#94A3B8", fs=10.6, subfs=7.2):
    return box(ax, x, y, w, h, title, subtitle, fc=fc, ec=ec, lw=1.8, fs=fs, subfs=subfs, radius=0.14)


def draw_abeis_lean_leaf_module_graph():
    fig, ax = setup(24.0, 16.0)
    label(ax, 3.5, 97.2, "ABEIS Lean leaf module graph", fs=24, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        3.5,
        94.3,
        "Quantum circuit construction is centered in blue/green.  Gray nodes are reference surfaces kept in memory; they are not hidden dependencies.",
        fs=10.8,
        color=MUTED,
        ha="left",
    )

    # External/reference surface.  These are intentionally gray: ABEIS records
    # them as searchable memories and style references, not as hidden imports.
    group_box(ax, 3.0, 79.0, 94.0, 12.0, "", "#CBD5E1", "#FFFFFF", title_fc="#475569")
    label(ax, 5.2, 89.0, "Reference surfaces kept in memory", fs=11.0, weight="bold", color="#475569", ha="left")
    ref_fc, ref_ec = "#F8FAFC", "#94A3B8"
    module_node(ax, 5.0, 82.0, 12.5, 5.5, "Mathlib", "Matrix, Finset,\nFintype, BigOperators", fc=ref_fc, ec=ref_ec, fs=8.8, subfs=6.3)
    module_node(ax, 20.0, 82.0, 17.0, 5.5, "quantum-computing-lean", "Matrix / States\nGates.Basic / Actions\nProjectors / Measurement", fc=ref_fc, ec=ref_ec, fs=8.4, subfs=5.8)
    module_node(ax, 40.0, 82.0, 18.0, 5.5, "Lean-QuantumInfo", "Braket / Unitary / CPTP\nPOVM / Entropy / Distance\nForMathlib.Matrix", fc=ref_fc, ec=ref_ec, fs=8.4, subfs=5.8)
    module_node(ax, 61.0, 82.0, 17.0, 5.5, "lean-quantum", "QuantumState / Channel\nNaimark extension\nTrace inequalities", fc=ref_fc, ec=ref_ec, fs=8.4, subfs=5.8)
    module_node(ax, 81.0, 82.0, 12.5, 5.5, "Block-encoding texts", "Lin notes, GSLW,\nLCU, QSVT", fc=ref_fc, ec=ref_ec, fs=8.4, subfs=6.0)

    # ABEIS public file tree and semantic bridge.
    group_box(ax, 3.0, 62.5, 94.0, 13.0, "", BLUE, "#F8FBFF")
    label(ax, 5.2, 73.4, "ABEIS file tree: quantum-circuit and block-encoding core", fs=11.0, weight="bold", color=BLUE, ha="left")
    module_node(ax, 5.0, 65.5, 12.0, 4.8, "Core.lean", "Coeff trees, matrices,\nstencil data", fc=BLUE_L, ec=BLUE, fs=8.8, subfs=6.0)
    module_node(ax, 19.0, 65.5, 12.0, 4.8, "Resources.lean", "gates, depth,\nasymptotic resources", fc=BLUE_L, ec=BLUE, fs=8.8, subfs=6.0)
    module_node(ax, 33.0, 65.5, 12.0, 4.8, "Circuit.lean", "gate syntax,\ncircuit syntax", fc=BLUE_L, ec=BLUE, fs=8.8, subfs=6.0)
    module_node(ax, 47.0, 65.5, 16.0, 4.8, "BlockEncoding.lean", "targets, candidates,\nverified / approximate records", fc=BLUE_L, ec=BLUE, fs=8.8, subfs=6.0)
    module_node(ax, 66.0, 65.5, 27.0, 4.8, "CircuitSemantics.lean", "evalWith path lemmas; block extraction; projection/backend contracts;\nsignal-system indices", fc=BLUE_L, ec=BLUE, fs=8.7, subfs=5.8)
    for x1, x2 in [(17.2, 18.7), (31.2, 32.7), (45.2, 46.7), (63.2, 65.7)]:
        arrow(ax, x1, 67.9, x2, 67.9, color=BLUE, lw=1.8)
    for x in [11.0, 25.0, 39.0, 55.0, 79.5]:
        arrow(ax, x, 79.0, x, 73.0, color="#64748B", lw=1.3, dashed=True)

    # Detailed proof-weapon layer.
    group_box(ax, 3.0, 26.5, 94.0, 32.5, "", BLUE, "#F8FBFF")
    label(ax, 5.2, 56.8, "BlockEncodingClassics.lean: compiled reusable proof weapons", fs=11.0, weight="bold", color=BLUE, ha="left")
    bx, by, bw, bh = 5.0, 49.3, 14.6, 5.2
    leaves = [
        (bx, by, "Clean blocks", "cleanBlockBy_permMatrix_entry\ncleanBlockProduct_eq_target"),
        (bx + 16.0, by, "Permutation", "permMatrix_columnInner_of_injective\npermMatrix_isRationalOrthogonal_of_bijective"),
        (bx + 32.0, by, "One-sparse", "oneSparseMatrix_entry_if\noneSparse_from_support"),
        (bx + 48.0, by, "Sparse access", "sparseColumnCleanEntry_unique_slot\nrowColumnSparseDeltaEntry"),
        (bx + 64.0, by, "Value oracle", "ValueToAmplitudeContract.correct\ncompute-rotate-uncompute contract"),
        (bx, by - 8.0, "LCU", "oneTermLCU_cleanBlock\nLCUCertificate.correct"),
        (bx + 16.0, by - 8.0, "Weighted sums", "weightedSum2_entry\ntwoTermLCUCertificate_cleanBlock_entry"),
        (bx + 32.0, by - 8.0, "Product / tensor", "matrix_mul_congr_pointwise\nproductExactCleanBlockCertificate"),
        (bx + 48.0, by - 8.0, "Resources", "tensorResourceCost_*\nproductResourceCost_*"),
        (bx + 64.0, by - 8.0, "Approximate BE", "ZeroErrorApproxCleanBlock\nexactAsZeroErrorApproxCleanBlock_bound"),
        (bx, by - 16.0, "Dilation", "scalarDilation_cleanEntry\nscalarDilation_rows*_orthogonal"),
        (bx + 16.0, by - 16.0, "Hermitian", "IsSymmetric\ncleanBlockBy_symmetric_of_symmetric"),
        (bx + 32.0, by - 16.0, "Chebyshev", "chebyshevT_succ_succ\nchebyshevT_three/four_recurrence"),
        (bx + 48.0, by - 16.0, "QSVT consumer", "QubitizationChebyshevContract\nQSVTConsumerContract"),
        (bx + 64.0, by - 16.0, "Exact package", "ExactCleanBlock\npartialPermutationCertificate"),
    ]
    for x, y, title, sub in leaves:
        module_node(ax, x, y, bw, bh, title, sub, fc=BLUE_L, ec=BLUE, fs=7.7, subfs=4.9)
    # Readability arrows: entries -> support -> arithmetic -> consumers.
    for y in [53.3, 45.3, 37.3]:
        for x1 in [19.8, 35.8, 51.8, 67.8]:
            arrow(ax, x1, y, x1 + 1.0, y, color=BLUE, lw=1.2, alpha=0.8)
    arrow(ax, 79.5, 62.5, 79.5, 59.2, color=BLUE, lw=1.8)

    # Case-study and export consumers.
    group_box(ax, 3.0, 8.0, 94.0, 15.0, "", GREEN, "#F8FFF9")
    label(ax, 5.2, 21.0, "Consumers: certified examples, paper wrappers, exports, and memory", fs=11.0, weight="bold", color=GREEN, ha="left")
    module_node(ax, 5.0, 14.0, 15.0, 5.2, "MainCase.lean", "Pro/cold candidates\npermutation proofs\nresource tuples", fc=GREEN_L, ec=GREEN, fs=8.2, subfs=5.4)
    module_node(ax, 22.5, 14.0, 17.0, 5.2, "CubicStatePreparation.lean", "diagonal cubic operator\namplitude oracle contracts\nexpanded arithmetic backend", fc=GREEN_L, ec=GREEN, fs=7.7, subfs=5.0)
    module_node(ax, 42.0, 14.0, 14.5, 5.2, "GHL2025 / RobinHeat", "paper benchmark wrappers\nRobin boundary ledgers", fc=GREEN_L, ec=GREEN, fs=7.9, subfs=5.2)
    module_node(ax, 59.0, 14.0, 14.5, 5.2, "TechnicalLemmas /\nPapers/*.lean", "re-export surfaces\npaper interfaces", fc=GREEN_L, ec=GREEN, fs=7.7, subfs=5.0)
    module_node(ax, 76.0, 14.0, 9.5, 5.2, "Exports", "Qiskit\nQASM", fc=AMBER_L, ec=AMBER, fs=8.0, subfs=5.3)
    module_node(ax, 87.0, 14.0, 8.0, 5.2, "Memory", "cards\nMathlib hits", fc=AMBER_L, ec=AMBER, fs=8.0, subfs=5.2)

    for x in [12.5, 31.0, 49.3, 66.3, 80.8, 91.0]:
        arrow(ax, x, 26.5, x, 19.5, color=GREEN, lw=1.6)
    arrow(ax, 84.5, 16.6, 87.0, 16.6, color=AMBER, lw=1.4)

    # Failure/judge memory is not a Lean theorem layer, but it tells the agents
    # how to avoid repeating bad proof routes.
    module_node(ax, 5.0, 2.0, 26.0, 4.0, "Failure-memory / reviewer judge", "fine/coarse failure packets; decomposed requirement vectors", fc=RED_L, ec=RED, fs=8.1, subfs=5.3)
    module_node(ax, 34.0, 2.0, 28.0, 4.0, "Complete declaration index", "research-wiki/block-encoding-library/compiled-lean-leaf-index.md", fc=AMBER_L, ec=AMBER, fs=8.1, subfs=5.3)
    module_node(ax, 65.0, 2.0, 30.0, 4.0, "QSVT hard-hint route", "O0 diagonal/value BE -> QSVT side conditions -> x^3 BE contract", fc=PURPLE_L, ec=PURPLE, fs=8.1, subfs=5.3)
    arrow(ax, 89.0, 8.0, 80.5, 6.2, color=PURPLE, lw=1.3, dashed=True, rad=-0.1)

    for path in [
        ARTICLE_FIG / "abeis_lean_leaf_module_graph.png",
        ARTICLE_FIG / "abeis_lean_leaf_module_graph.svg",
        README_FIG / "abeis_lean_leaf_module_graph.png",
        README_FIG / "abeis_lean_leaf_module_graph.svg",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)



def draw_abeis_detailed_lean_leaf_module_graph():
    """Draw the public detailed Lean leaf graph.

    This graph is intentionally closer to a module/dependency atlas than to a
    simple file tree.  It makes the compiled ABEIS leaves visible at the level
    where upper and middle agents actually retrieve them, while still showing
    nearby Mathlib and quantum Lean reference surfaces.
    """
    fig, ax = setup(32.0, 23.0)
    label(ax, 2.5, 98.0, "ABEIS Lean leaf module graph", fs=25, weight="bold", color=NAVY, ha="left")
    label(
        ax,
        2.5,
        95.8,
        "Blue/green/amber nodes are compiled ABEIS Lean leaves; gray/purple nodes are searchable external reference memories.  The map is centered on quantum-circuit block-encoding construction.",
        fs=10.6,
        color=MUTED,
        ha="left",
    )

    group_box(ax, 2.0, 83.0, 96.0, 10.8, "Reference memories: inspect before inventing local infrastructure", "#CBD5E1", "#FFFFFF")
    ref_nodes = [
        (3.8, 87.1, 13.0, "Mathlib", "Fin/Fintype\nMatrix/ext\nFinset sums\nPolynomial/norm"),
        (18.5, 87.1, 16.5, "quantum-computing-lean", "Matrix/State\nStates\nGates.Basic\nProjectors"),
        (36.8, 87.1, 15.5, "gate-action reference", "X/H/CNOT/TOFFOLI\nSWAP actions\nunitarity leaves\ndecompositions"),
        (54.0, 87.1, 13.2, "Lean-QuantumInfo", "ForMathlib.Matrix\nchannels/probability\nPOVM/braket\nentropy"),
        (69.0, 87.1, 12.2, "lean-quantum", "states/qudits\nchannels\ntrace/norm\noperator style"),
        (83.0, 87.1, 13.0, "textbook BE", "Lin 2201.08309\nGSLW/QSVT\nLow-Chuang\nLCU/sparse"),
    ]
    for x, y, w, title, sub in ref_nodes:
        module_node(ax, x, y, w, 4.8, title, sub, fc="#F8FAFC", ec="#94A3B8", fs=6.9, subfs=4.45)

    group_box(ax, 2.0, 70.0, 96.0, 9.4, "ABEIS local Lean files: public surfaces and declaration counts", BLUE, "#F8FBFF")
    file_nodes = [
        (3.5, "Core.lean", "36\nMatrix/Coeff\nstencil"),
        (14.5, "Resources.lean", "25\ngates/depth\nparallel"),
        (26.0, "Circuit.lean", "12\ngate syntax\nlayers"),
        (37.0, "BlockEncoding.lean", "22\ntarget/candidate\nverified records"),
        (52.0, "CircuitSemantics.lean", "42\nevalWith\nprojection"),
        (69.0, "BlockEncodingClassics.lean", "84\ntextbook\nBE leaves"),
        (88.0, "Automation.lean", "39\nharness\ncontracts"),
    ]
    widths = [9.0, 9.0, 8.8, 12.0, 13.5, 15.5, 8.6]
    for (x, title, sub), w in zip(file_nodes, widths):
        module_node(ax, x, 73.0, w, 4.4, title, sub, fc=BLUE_L, ec=BLUE, fs=6.3, subfs=4.2)
    for i in range(len(file_nodes) - 1):
        x1 = file_nodes[i][0] + widths[i]
        x2 = file_nodes[i + 1][0] - 0.3
        arrow(ax, x1, 75.2, x2, 75.2, color=BLUE, lw=1.1, alpha=0.75)
    for x, _, _, _, _ in ref_nodes:
        arrow(ax, x + 5.5, 86.9, x + 5.5, 79.5, color="#94A3B8", lw=0.9, dashed=True, alpha=0.7)

    group_box(ax, 2.0, 28.0, 96.0, 38.5, "Compiled ABEIS proof leaves: reusable theorem moves", BLUE, "#F9FCFF")
    leaf_groups = [
        (3.5, 58.0, "finite matrix core", [("Matrix/Coeff", "Matrix, PointwiseEq\nevalWith_*"), ("finite indices", "gridSize, clog2\nFin bounds"), ("matrix product", "mul, identity\ncongruence")], BLUE_L, BLUE),
        (20.0, 58.0, "circuit semantics", [("eval paths", "evalWith_mul_apply\nunique/two-path"), ("branch sums", "selectedBranch\nprojection/backend"), ("signal block", "row/col index\nprojection_apply")], BLUE_L, BLUE),
        (36.5, 58.0, "projector / clean block", [("clean entry", "cleanBlockBy_*\ncleanBlockProduct_*"), ("entry ext", "eq_target_of_entry\nproduct ext"), ("exact record", "ExactCleanBlock\nclean_eq_target")], GREEN_L, GREEN),
        (53.0, 58.0, "permutation / unitarity", [("perm matrix", "permMatrix\nrow/columnInner"), ("orthogonal", "injective/bijective\nrational orthogonal"), ("partial perm", "partialPermutation\ncertificate")], GREEN_L, GREEN),
        (69.5, 58.0, "sparse oracles", [("one-sparse", "oneSparseMatrix\nfrom_support"), ("column sparse", "no_hit\nunique_slot"), ("row-column", "delta entry\ncertificate")], GREEN_L, GREEN),
        (86.0, 58.0, "value oracles", [("value->amp", "ValueToAmplitude\ncompute-rotate"), ("Ry scalar", "clean-entry\nangle tier"), ("uncompute", "workspace clean\nreadonly witness")], GREEN_L, GREEN),
        (3.5, 43.8, "composition", [("LCU", "oneTermLCU\ntwoTerm LCU"), ("weighted sum", "weightedSum2\ncongr pointwise"), ("product/tensor", "product BE\ntensorResource")], AMBER_L, AMBER),
        (20.0, 43.8, "dilation / Hermitian", [("scalar dilation", "cleanEntry\nrow norms"), ("orthogonality", "rows01/10\nunit norm"), ("Hermitian", "IsSymmetric\nHBE contract")], AMBER_L, AMBER),
        (36.5, 43.8, "QSVT / polynomial", [("Chebyshev", "T0,T1,T2\nT3/T4 recurrence"), ("QSVT contract", "consumer only\nno hidden oracle"), ("hard hint", "O0 diagonal\nthen QSVT")], PURPLE_L, PURPLE),
        (53.0, 43.8, "approximate BE", [("epsilon record", "ApproxCandidate\nVerifiedApprox"), ("zero incumbent", "exactAsZero\nbound"), ("epsilon ladder", "relaxedEpsilon\npolicy leaves")], PURPLE_L, PURPLE),
        (69.5, 43.8, "resource ordering", [("cost API", "gateCount\ndepth/aux/oracle"), ("parallel", "LayeredCircuit\ndepth"), ("candidate score", "cost theorem\ncomparison tuple")], AMBER_L, AMBER),
        (86.0, 43.8, "failure/reviewer leaves", [("typed feedback", "fine/coarse\nerror_class"), ("judge vector", "hard gates\nsoft scores"), ("stable proof", "small leaf\nroute lock")], RED_L, RED),
    ]
    small_w = 13.0
    for x, y, group, leaves, fc, ec in leaf_groups:
        label(ax, x, y + 5.8, group, fs=7.3, weight="bold", color=ec, ha="left")
        for i, (title, sub) in enumerate(leaves):
            module_node(ax, x, y - i * 3.7, small_w, 3.0, title, sub, fc=fc, ec=ec, fs=5.5, subfs=3.6)
        arrow(ax, x + 6.5, 72.8, x + 6.5, y + 5.2, color=ec, lw=0.9, dashed=True, alpha=0.65)

    for y in [62.0, 47.8, 32.2]:
        for x1, x2 in [(16.8, 19.5), (33.3, 36.0), (49.8, 52.5), (66.3, 69.0), (82.8, 85.5)]:
            arrow(ax, x1, y, x2, y, color="#64748B", lw=1.0, alpha=0.5)

    group_box(ax, 2.0, 13.0, 96.0, 11.0, "Consumers: tasks that instantiate the leaves", GREEN, "#F8FFF9")
    consumers = [
        (3.5, "MainCase.lean", "124 decls\ntransfer operator\nPro/cold arms"),
        (18.5, "CubicStatePreparation.lean", "158 decls\ndiagonal/rank-one\ncubic arithmetic"),
        (36.0, "GHL2025.lean", "401 decls\nRobin/PDE\nsparse + function"),
        (52.5, "RobinHeat.lean", "12 decls\nexample wrapper"),
        (66.5, "TechnicalLemmas.lean", "re-export surface\nexternal facts"),
        (82.0, "Exports", "LaTeX proof\nQiskit / QASM\nfigures"),
    ]
    for x, title, sub in consumers:
        ec = AMBER if title == "Exports" else GREEN
        fc = AMBER_L if title == "Exports" else GREEN_L
        module_node(ax, x, 16.0, 13.0, 4.8, title, sub, fc=fc, ec=ec, fs=6.5, subfs=4.25)
        arrow(ax, x + 6.5, 28.0, x + 6.5, 21.0, color=ec, lw=1.1)

    group_box(ax, 2.0, 2.8, 96.0, 7.0, "Retrieval and proof-engineering discipline", "#94A3B8", "#FFFFFF")
    policy = [
        (3.5, "compiled index", "965 declarations\nmd/json"),
        (18.5, "route selector", "textbook intuition\nnot rigid detection"),
        (34.0, "QSVT route", "O0 diagonal ->\nQSVT side conditions"),
        (51.0, "Mathlib search", "reuse generic\nfinite algebra"),
        (67.0, "failure memory", "persistent failure\n= signal"),
        (83.0, "reviewer judge", "decomposed vector\nhard Lean gate"),
    ]
    for x, title, sub in policy:
        color = RED if title in {"failure memory", "reviewer judge"} else "#64748B"
        fill = RED_L if title in {"failure memory", "reviewer judge"} else "#F8FAFC"
        module_node(ax, x, 5.0, 12.0, 3.0, title, sub, fc=fill, ec=color, fs=5.8, subfs=3.7)

    badge(ax, 75.0, 95.8, 5.0, 1.8, "ABEIS", fc=BLUE_L, ec=BLUE, fs=5.8)
    badge(ax, 80.8, 95.8, 5.0, 1.8, "task", fc=GREEN_L, ec=GREEN, fs=5.8)
    badge(ax, 86.6, 95.8, 5.0, 1.8, "memory", fc="#F8FAFC", ec="#94A3B8", fs=5.8)
    badge(ax, 92.4, 95.8, 5.0, 1.8, "judge", fc=RED_L, ec=RED, fs=5.8)

    for path in [
        ARTICLE_FIG / "abeis_lean_leaf_module_graph.png",
        ARTICLE_FIG / "abeis_lean_leaf_module_graph.svg",
        README_FIG / "abeis_lean_leaf_module_graph.png",
        README_FIG / "abeis_lean_leaf_module_graph.svg",
    ]:
        path.parent.mkdir(parents=True, exist_ok=True)
        fig.savefig(path, bbox_inches="tight", facecolor=BG)
    plt.close(fig)


def normalize_svg_whitespace():
    """Keep generated SVG diffs compatible with repository whitespace checks."""

    names = (
        "abeis_agent_cycle_detail.svg",
        "aspbe_harness_flow.svg",
        "abeis_lean_lemma_tree.svg",
        "be_case1_candidates.svg",
        "be_case1_convergence.svg",
        "be_case1_score_table.svg",
        "be_case2_cold_hinted.svg",
        "be_case2_candidates.svg",
        "be_case2_convergence.svg",
        "be_case2_proof_dag.svg",
        "be_case2_score_table.svg",
    )
    for directory in (ARTICLE_FIG, README_FIG):
        for name in names:
            path = directory / name
            content = path.read_text(encoding="utf-8")
            path.write_text(
                "\n".join(line.rstrip() for line in content.splitlines()) + "\n",
                encoding="utf-8",
            )


def main():
    ARTICLE_FIG.mkdir(parents=True, exist_ok=True)
    README_FIG.mkdir(parents=True, exist_ok=True)
    draw_application_overview()
    draw_hierarchical_harness()
    draw_game_harness()
    draw_abeis_loop()
    draw_optctrl_storyboard()
    draw_optctrl_evolution()
    draw_optctrl_hier_vs_pro()
    draw_optctrl_cold_clean_storyboard()
    draw_qiskit_export_results()
    draw_be_case1_candidates()
    draw_be_case1_convergence()
    draw_be_case1_score_table()
    draw_be_case2_candidates()
    draw_be_case2_convergence()
    draw_be_case2_score_table()
    draw_evolution_acceptance_pipeline()
    draw_aspbe_harness_flow()
    draw_be_case2_summary()
    draw_be_case2_proof_dag()
    draw_abeis_lean_lemma_tree()
    draw_quantum_lean_leaf_atlas()
    draw_abeis_lean_leaf_module_graph()
    draw_abeis_detailed_lean_leaf_module_graph()
    normalize_svg_whitespace()


if __name__ == "__main__":
    main()
