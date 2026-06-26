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
    label(ax, 5, 94, "Certified evolution of the transfer-operator block encoding", fs=23, weight="bold", color=NAVY, ha="left")
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
    ax.set_title("Lean-certified generation champions", fontsize=20, fontweight="bold", color=NAVY, pad=18)
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
    fig.suptitle("Transfer-operator case: two parallel certified attempts", fontsize=20, fontweight="bold", color=NAVY)
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
    label(ax, 5, 94, "Attempt A storyboard: no-Pro Hierarchical Harness checkpoint", fs=22, weight="bold", color=NAVY, ha="left")
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
    label(ax, 5, 94, "Post-Lean executable exports: Qiskit checks for the transfer operator", fs=21, weight="bold", color=NAVY, ha="left")
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
    box(ax, 7, 27.5, 19, 6.0, "main case", "matrix-unit tensor I", fc=AMBER_L, ec=AMBER, fs=12.0, subfs=8.1)
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


def main():
    ARTICLE_FIG.mkdir(parents=True, exist_ok=True)
    README_FIG.mkdir(parents=True, exist_ok=True)
    draw_abeis_loop()
    draw_optctrl_storyboard()
    draw_optctrl_evolution()
    draw_optctrl_hier_vs_pro()
    draw_optctrl_cold_clean_storyboard()
    draw_qiskit_export_results()
    draw_quantum_lean_leaf_atlas()


if __name__ == "__main__":
    main()
