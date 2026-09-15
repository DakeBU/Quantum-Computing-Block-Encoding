from pathlib import Path

README_MARK = "## News 🔥\n\n"
ROBIN = "- **14 August 2026.** For the selected $n=3$ Robin boundary instance in [Guseynov–Huang–Liu, *Block encoding by signal processing*](https://arxiv.org/abs/2406.18072), ASPBE formally reduced the audited $T^{\\dagger 3}$ branch from **49 to 30** $T^{\\dagger 3}$ gates and from **52 to 32** CNOTs, while keeping five qubits and zero ancillas under the same primitive model.\n"
SCH = "- **10 September 2026.** For the smooth auxiliary $p$-register initial state required by [Jin–Liu–Ma’s Schrödingerisation PDE construction](https://arxiv.org/abs/2403.19123v3), connected to the smooth-function state-preparation program of [Holmes–Matsuura](https://arxiv.org/abs/2005.04351), ASPBE exploited the exact Hermite–Bernstein/tensor-train structure to replace generic $\\Theta(2^{n_p})$ amplitude loading by $G\\le 48n_p(2k+6)^3$: **linear $O(n_p)$ gate complexity for fixed smoothness order $k$**, with $O(\\log k)$ workspace. [Read the Lean-verified worked case →](https://dakebu.github.io/Quantum-Computing-Block-Encoding/example-cases/hermite-smooth-state-preparation/index.html)\n"

readme = Path("README.md")
text = readme.read_text(encoding="utf-8")
if text.count(README_MARK) != 1:
    raise SystemExit("README News anchor changed")
if "14 August 2026." not in text:
    text = text.replace(README_MARK, README_MARK + ROBIN + SCH + "\n", 1)
old = "These News items intentionally preserve the **early project chronology**. Routine recent engineering and website updates are not added here; current mathematical status is generated from the checkout and shown in QuantumComputinglib and the Implementation Map."
new = "These News items preserve the **early project chronology** and add only major, mathematically audited construction milestones. Routine engineering and website updates are not added here; current mathematical status is generated from the checkout and shown in QuantumComputinglib and the Implementation Map."
if old not in text and new not in text:
    raise SystemExit("README News boundary sentence changed")
text = text.replace(old, new, 1)
readme.write_text(text, encoding="utf-8")

site = Path("website/scripts/build_site.py")
source = site.read_text(encoding="utf-8")
anchor = '  <ol class="milestone-list">\n    <li><time datetime="2026-08-10">10 August 2026</time>'
cards = r'''  <ol class="milestone-list">
    <li><time datetime="2026-09-10">10 September 2026</time><div><strong>Schrödingerisation smooth auxiliary-state preparation: exponential-to-linear in the grid-register width.</strong><p>The smooth auxiliary \(p\)-register state required by <a href="https://arxiv.org/abs/2403.19123v3">Jin–Liu–Ma’s PDE Schrödingerisation construction</a>, viewed alongside the smooth-function state-preparation route of <a href="https://arxiv.org/abs/2005.04351">Holmes–Matsuura</a>, has exact Hermite–Bernstein/tensor-train structure. ASPBE turns generic \(\Theta(2^{{n_p}})\) amplitude loading into \(G\le48n_p(2k+6)^3\), hence \(O(n_p)\) gates for fixed \(k\), with \(O(\log k)\) workspace. <a href="example-cases/hermite-smooth-state-preparation/index.html">Open the Lean-verified worked case →</a></p></div></li>
    <li><time datetime="2026-08-14">14 August 2026</time><div><strong>Robin boundary block encoding: a smaller certified primitive.</strong><p>For the selected \(n=3\) Robin boundary instance in <a href="https://arxiv.org/abs/2406.18072">Guseynov–Huang–Liu, <em>Block encoding by signal processing</em></a>, ASPBE reduced the audited \(T^{{\dagger 3}}\) branch from 49 to 30 \(T^{{\dagger 3}}\) gates and from 52 to 32 CNOTs, with the same five qubits and zero ancillas under the fixed primitive model.</p></div></li>
    <li><time datetime="2026-08-10">10 August 2026</time>'''
if source.count(anchor) != 1:
    raise SystemExit("homepage News anchor changed")
if 'datetime="2026-09-10"' not in source:
    source = source.replace(anchor, cards, 1)
site.write_text(source, encoding="utf-8")
