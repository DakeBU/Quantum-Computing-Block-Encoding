(() => {
  "use strict";

  const root = document.documentElement;
  const body = document.body;
  const siteRoot = body.dataset.siteRoot || "./";
  const themes = ["blueprint", "modern", "bold"];
  const savedTheme = localStorage.getItem("abeis-theme");
  const requestedTheme = new URLSearchParams(window.location.search).get("theme");

  function setTheme(theme) {
    const selected = themes.includes(theme) ? theme : "blueprint";
    root.dataset.theme = selected;
    localStorage.setItem("abeis-theme", selected);
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
})();
