(() => {
  "use strict";

  const root = document.documentElement;
  const body = document.body;
  const siteRoot = body.dataset.siteRoot || "./";

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
        if (node instanceof Element) normalizeFigureText(node);
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
