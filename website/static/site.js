(() => {
  "use strict";

  const root = document.documentElement;
  const body = document.body;
  const siteRoot = body.dataset.siteRoot || "./";

  // Presentation only: keep the frozen QA source extractor unchanged.
  // This runs synchronously before Mermaid starts; its editable companion
  // keeps the same seven identities and four typed curriculum relationships.
  function renderCurriculumRoadmap() {
    const figure = document.getElementById("diagram-quantum-domain-roadmap");
    const source = figure?.querySelector(".mermaid");
    if (!figure || !source) return;
    const curriculumMarkup = `
  <aside class="diagram-legend" aria-label="Diagram legend">
    <strong>How to read this map</strong>
    <span><i class="legend-line" aria-hidden="true"></i>Solid: shared foundations / curriculum organization</span>
    <span><i class="legend-line legend-line-dashed" aria-hidden="true"></i>Dashed: conditional reuse or support; assumptions and review required</span>
    <small>Curriculum map, not a Lean theorem-dependency graph. Listed foundation topics are not a claim of complete local coverage.</small>
  </aside>
  <div class="curriculum-flow" role="group" aria-label="Textbooks and shared Lean foundations" data-curriculum-layout="stacked">
    <section class="curriculum-node curriculum-external" data-curriculum-node="EXT">
      <h3>External Lean references</h3>
      <p>Mathlib and attributed quantum Lean libraries</p>
      <p class="curriculum-boundary">Upstream references are not automatically local proofs.</p>
    </section>
    <div class="curriculum-link conditional" data-curriculum-link="EXT:CORE" role="img" aria-label="Conditional reviewed reuse or narrow adapters into shared foundations"><span aria-hidden="true">Reviewed reuse / narrow adapters</span></div>
    <section class="curriculum-node curriculum-foundations" data-curriculum-node="CORE">
      <h3>Shared Lean foundations</h3>
      <p>Reviewed, compatible building blocks reused across textbooks</p>
      <p class="curriculum-boundary">Linear algebra · states and tensors · operators<br/>circuits and registers · norms · resource interfaces</p>
    </section>
    <div class="curriculum-link" data-curriculum-link="CORE:TEXTBOOK" role="img" aria-label="The textbooks reuse the common foundation"><span aria-hidden="true">Common foundation</span></div>
    <section class="curriculum-textbooks" data-curriculum-node="TEXTBOOK" aria-label="QuantumComputinglib textbooks">
      <h3>QuantumComputinglib textbooks</h3>
      <section class="curriculum-group" aria-label="Current textbook core">
        <h4>Current core</h4>
        <p class="curriculum-boundary">Compiled guided chapters; route-specific gaps remain visible.</p>
        <div class="curriculum-core-parts">
          <section class="curriculum-node curriculum-sp" data-curriculum-node="SP"><h4>Part I · State Preparation</h4><p>Prepare a specified quantum state.</p></section>
          <section class="curriculum-node curriculum-be" data-curriculum-node="BE"><h4>Part II · Block Encoding</h4><p>Embed an operator in a unitary block.</p></section>
        </div>
      </section>
      <section class="curriculum-group curriculum-planned" aria-label="Planned textbook extensions">
        <h4>Planned extensions</h4>
        <p class="curriculum-boundary">Each chapter requires local proof admission.</p>
        <section class="curriculum-node curriculum-qit" data-curriculum-node="QIT"><h4>Planned Part III · Quantum Information<br/>and Representation Theory</h4><p>Symmetry · Schur–Weyl · de Finetti</p></section>
        <div class="curriculum-supports" role="group" aria-label="Two conditional support paths into scientific computing">
          <div class="curriculum-link conditional" data-curriculum-link="BE:SCI" role="img" aria-label="Conditional algorithm support from Part II to Part IV"><span aria-hidden="true">Algorithm support<br/><small>from Part II</small></span></div>
          <div class="curriculum-link conditional" data-curriculum-link="QIT:SCI" role="img" aria-label="Conditional theoretical support from Part III to Part IV"><span aria-hidden="true">Theoretical support<br/><small>from Part III</small></span></div>
        </div>
        <section class="curriculum-node curriculum-sci" data-curriculum-node="SCI"><h4>Planned Part IV · Quantum Scientific Computing</h4><p>QSP/QSVT · simulation · estimation<br/>linear systems · dynamics · open systems</p></section>
      </section>
    </section>
  </div>
  <details class="curriculum-transport-notes">
    <summary>State Preparation and Block Encoding: precise transport conditions</summary>
    <p>State Preparation can supply a PREPARE layer inside Block Encoding; SELECT, inverse/unprepare, coefficient/phase and clean-register semantics are still required.</p>
    <p>Conversely, a block encoding can supply a state-preparation branch only with an input state, a nonzero accepted branch, normalization and charged postselection/amplification. This is a downstream consumer path, not the inclusion relation.</p>
    <p>External benchmark statements remain targets, not proof memory. External results become textbook foundations only after a compatible local reuse or adapter is reviewed and admitted.</p>
  </details>`;
    const template = document.createElement("template");
    template.innerHTML = curriculumMarkup;
    figure.classList.add("curriculum-diagram");
    source.replaceWith(template.content);
    const title = figure.querySelector(".diagram-toolbar strong");
    if (title) title.textContent = "Textbooks and shared Lean foundations — a curriculum map";
    document.querySelectorAll("h2").forEach((heading) => {
      if (heading.textContent.trim() === "Four textbook parts, one shared Lean graph") {
        heading.textContent = "Four textbook parts, shared Lean foundations";
      }
    });
  }

  renderCurriculumRoadmap();

  // Some embedded/preview renderers reject \operatorname even though MathJax
  // itself accepts it. Normalize only raw text nodes and never touch source-code
  // or editable text areas. This runs before the deferred MathJax script.
  function compatibleMathText(text) {
    return text.replace(/\\operatorname\{([^{}]+)\}/g, "\\mathrm{$1}");
  }

  function normalizeFragileMath(scope = document.body) {
    if (!(scope instanceof Document || scope instanceof Element)) return;
    const walker = document.createTreeWalker(
      scope,
      NodeFilter.SHOW_TEXT,
      {
        acceptNode(node) {
          const parent = node.parentElement;
          if (!parent || parent.closest("pre, code, textarea, script, style")) {
            return NodeFilter.FILTER_REJECT;
          }
          return node.nodeValue?.includes("\\operatorname{")
            ? NodeFilter.FILTER_ACCEPT
            : NodeFilter.FILTER_REJECT;
        },
      },
    );
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    nodes.forEach((node) => {
      node.nodeValue = compatibleMathText(node.nodeValue || "");
    });
  }

  normalizeFragileMath(body);

  // Reader-facing diagrams should look like textbook figures rather than UI cards.
  // This runs before Mermaid initializes, so both SVG text and HTML labels inherit
  // the same Times-family typography. The fallbacks keep Linux builds portable.
  const figureTypography = document.createElement("style");
  figureTypography.textContent = `
    .diagram-panel,
    .stage-circuit-render {
      background: #fff !important;
      border-radius: 2px !important;
      box-shadow: none !important;
    }
    .diagram-panel .mermaid,
    .diagram-panel .mermaid *,
    .diagram-panel svg text,
    .diagram-panel svg foreignObject *,
    .quantikz-preview text,
    .stage-circuit-canvas svg text,
    .circuit-live-preview svg text {
      font-family: "Times New Roman", Times, "Liberation Serif", serif !important;
      letter-spacing: 0 !important;
    }
    .diagram-panel .node rect,
    .diagram-panel .cluster rect,
    .diagram-panel .label-container,
    .quantikz-preview .qc-gate {
      rx: 2px !important;
      ry: 2px !important;
    }
    .diagram-panel .node rect,
    .diagram-panel .cluster rect {
      fill: #fff !important;
      stroke-width: 1.2px !important;
    }
    .diagram-panel .edgeLabel,
    .diagram-panel .edgeLabel p {
      background: #fff !important;
    }
    .stage-circuit-render figcaption,
    .diagram-toolbar {
      box-shadow: none !important;
    }
  `;
  document.head.append(figureTypography);

  // The small browser-side quantikz renderer deliberately supports only a
  // reviewed subset of TeX. Keep its labels mathematical instead of degrading
  // common notation to ASCII words such as "alpha", "theta", or "perp".
  const figureTextSelector = [
    ".quantikz-preview text",
    ".stage-circuit-canvas svg text",
    ".circuit-live-preview svg text",
  ].join(",");

  function mathematicalFigureLabel(text) {
    return text
      .replace(/\balpha\b/g, "α")
      .replace(/\btheta\b/g, "θ")
      .replace(/\bperp\b/g, "⊥")
      .replace(/\|([^>|]{1,48})>/g, "|$1⟩");
  }

  function normalizeFigureText(scope = document) {
    if (!(scope instanceof Document || scope instanceof Element)) return;
    if (scope instanceof Element && scope.matches(figureTextSelector)) {
      scope.textContent = mathematicalFigureLabel(scope.textContent || "");
    }
    scope.querySelectorAll(figureTextSelector).forEach((node) => {
      node.textContent = mathematicalFigureLabel(node.textContent || "");
    });
  }

  normalizeFigureText(document);
  const figureObserver = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      mutation.addedNodes.forEach((node) => {
        if (node instanceof Element) {
          normalizeFragileMath(node);
          normalizeFigureText(node);
        }
      });
    });
  });
  figureObserver.observe(document.documentElement, { childList: true, subtree: true });

  const themes = ["blueprint", "modern", "bold"];
  const savedTheme = localStorage.getItem("quantumcomputinglib-theme");
  const requestedTheme = new URLSearchParams(window.location.search).get("theme");

  function setTheme(theme) {
    const selected = themes.includes(theme) ? theme : "blueprint";
    root.dataset.theme = selected;
    localStorage.setItem("quantumcomputinglib-theme", selected);
    document.querySelectorAll("[data-theme-choice]").forEach((button) => {
      button.setAttribute(
        "aria-pressed",
        String(button.dataset.themeChoice === selected),
      );
    });
  }

  setTheme(requestedTheme || savedTheme || "blueprint");
  document.querySelectorAll("[data-theme-choice]").forEach((button) => {
    button.addEventListener("click", () => setTheme(button.dataset.themeChoice));
  });

  const menuButton = document.querySelector("[data-menu-button]");
  const nav = document.querySelector("[data-main-nav]");
  if (menuButton && nav) {
    menuButton.addEventListener("click", () => {
      const open = nav.classList.toggle("is-open");
      menuButton.setAttribute("aria-expanded", String(open));
      menuButton.setAttribute(
        "aria-label",
        open ? "Close book navigation" : "Open book navigation",
      );
    });
    nav.querySelectorAll("a").forEach((link) => {
      link.addEventListener("click", () => {
        nav.classList.remove("is-open");
        menuButton.setAttribute("aria-expanded", "false");
        menuButton.setAttribute("aria-label", "Open book navigation");
      });
    });
  }

  const searchInput = document.querySelector("[data-global-search]");
  const searchResults = document.querySelector("[data-search-results]");
  let searchEntries = null;

  async function ensureSearchIndex() {
    if (searchEntries) return searchEntries;
    const response = await fetch(`${siteRoot}search-index.json`, {
      cache: "no-store",
    });
    if (!response.ok) throw new Error(`Search index: ${response.status}`);
    const payload = await response.json();
    searchEntries = payload.entries;
    return searchEntries;
  }

  function renderSearch(entries, query) {
    if (!searchResults) return;
    searchResults.replaceChildren();
    if (!query) {
      searchResults.hidden = true;
      return;
    }
    const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
    const matches = entries
      .filter((entry) => {
        const haystack = `${entry.title} ${entry.summary} ${entry.kind || ""}`.toLowerCase();
        return terms.every((term) => haystack.includes(term));
      })
      .slice(0, 12);
    if (!matches.length) {
      const empty = document.createElement("div");
      empty.className = "callout";
      empty.textContent = "No matching declaration or chapter.";
      searchResults.append(empty);
    } else {
      matches.forEach((entry) => {
        const link = document.createElement("a");
        link.href = `${siteRoot}${entry.url}`;
        const title = document.createElement("strong");
        title.textContent = entry.title;
        const summary = document.createElement("small");
        summary.textContent = entry.summary;
        link.append(title, summary);
        searchResults.append(link);
      });
    }
    searchResults.hidden = false;
  }

  if (searchInput && searchResults) {
    searchInput.addEventListener("input", async () => {
      try {
        renderSearch(await ensureSearchIndex(), searchInput.value.trim());
      } catch {
        searchResults.hidden = false;
        searchResults.textContent = "Search index is unavailable.";
      }
    });
    document.addEventListener("click", (event) => {
      if (!event.target.closest(".search-shell")) searchResults.hidden = true;
    });
  }

  document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape") return;
    if (searchResults) searchResults.hidden = true;
    if (nav && menuButton) {
      nav.classList.remove("is-open");
      menuButton.setAttribute("aria-expanded", "false");
      menuButton.setAttribute("aria-label", "Open book navigation");
    }
  });

  const libraryRoot = document.querySelector("[data-library]");
  if (libraryRoot) {
    const rows = [...libraryRoot.querySelectorAll("[data-declaration-row]")];
    const query = document.querySelector("[data-library-query]");
    const kind = document.querySelector("[data-library-kind]");
    const catalog = document.querySelector("[data-library-catalog]");
    const status = document.querySelector("[data-library-status]");
    const count = document.querySelector("[data-library-count]");

    function filterLibrary() {
      const terms = (query?.value || "").toLowerCase().split(/\s+/).filter(Boolean);
      let visible = 0;
      rows.forEach((row) => {
        const matchesText = terms.every((term) =>
          row.dataset.search.includes(term),
        );
        const matchesKind = !kind?.value || row.dataset.kind === kind.value;
        const matchesCatalog =
          !catalog?.value || row.dataset.catalog === catalog.value;
        const matchesStatus =
          !status?.value || row.dataset.status === status.value;
        const show =
          matchesText && matchesKind && matchesCatalog && matchesStatus;
        row.hidden = !show;
        if (show) visible += 1;
      });
      if (count) count.textContent = `${visible} declarations shown`;
    }

    [query, kind, catalog, status].forEach((control) => {
      control?.addEventListener(control === query ? "input" : "change", filterLibrary);
    });
    filterLibrary();
  }

  document.querySelectorAll("[data-copy-source]").forEach((button) => {
    button.addEventListener("click", async () => {
      const source = button.closest("details")?.querySelector("pre code")?.textContent || "";
      if (!source) return;
      try {
        await navigator.clipboard.writeText(source);
        const previous = button.textContent;
        button.textContent = "Copied";
        window.setTimeout(() => { button.textContent = previous; }, 1400);
      } catch {
        button.textContent = "Copy unavailable";
      }
    });
  });

  const readerSwitcher = document.querySelector("[data-reader-mode-switch]");
  if (readerSwitcher) {
    const modes = ["concept", "math", "lean"];
    const storageKey = "quantumcomputinglib-reader-mode";
    const requested = new URLSearchParams(window.location.search).get("mode");
    const hashWantsLean = window.location.hash.startsWith("#decl-");
    const saved = localStorage.getItem(storageKey);

    function setReaderMode(mode, persist = true) {
      const selected = modes.includes(mode) ? mode : "concept";
      body.classList.add("reader-mode-enabled");
      body.dataset.readerMode = selected;
      readerSwitcher.querySelectorAll("[data-reader-mode-choice]").forEach((button) => {
        button.setAttribute(
          "aria-pressed",
          String(button.dataset.readerModeChoice === selected),
        );
      });
      if (persist) localStorage.setItem(storageKey, selected);
    }

    setReaderMode(hashWantsLean ? "lean" : requested || saved || "concept", false);
    readerSwitcher.querySelectorAll("[data-reader-mode-choice]").forEach((button) => {
      button.addEventListener("click", () => {
        setReaderMode(button.dataset.readerModeChoice);
        document.querySelector("[data-concept-first-lesson]")?.scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
      });
    });
    window.addEventListener("hashchange", () => {
      if (window.location.hash.startsWith("#decl-")) setReaderMode("lean", false);
    });
  }
})();
