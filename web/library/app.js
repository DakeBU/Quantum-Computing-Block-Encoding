const state = {
  inventory: null,
  filtered: [],
  visible: 40,
};

const elements = {
  search: document.querySelector("#searchInput"),
  catalog: document.querySelector("#catalogFilter"),
  kind: document.querySelector("#kindFilter"),
  status: document.querySelector("#statusFilter"),
  clear: document.querySelector("#clearFilters"),
  active: document.querySelector("#activeFilters"),
  results: document.querySelector("#results"),
  summary: document.querySelector("#resultSummary"),
  loadMore: document.querySelector("#loadMore"),
  template: document.querySelector("#declarationTemplate"),
};

function formatCount(value) {
  return new Intl.NumberFormat("en").format(value);
}

function setText(selector, value) {
  const element = document.querySelector(selector);
  if (element) element.textContent = value;
}

function uniqueSorted(values) {
  return [...new Set(values)].sort((a, b) => a.localeCompare(b));
}

function addOptions(select, values) {
  for (const value of values) {
    const option = document.createElement("option");
    option.value = value;
    option.textContent = value;
    select.append(option);
  }
}

function searchableText(declaration) {
  return [
    declaration.fullName,
    declaration.readerLabel,
    declaration.plainEnglish,
    declaration.technicalNote,
    declaration.source,
    declaration.sourcePreview,
    declaration.catalog,
    declaration.kind,
  ].join("\n").toLocaleLowerCase();
}

function syncUrl() {
  const params = new URLSearchParams();
  if (elements.search.value.trim()) params.set("q", elements.search.value.trim());
  if (elements.catalog.value) params.set("catalog", elements.catalog.value);
  if (elements.kind.value) params.set("kind", elements.kind.value);
  if (elements.status.value) params.set("status", elements.status.value);
  const suffix = params.toString() ? `?${params}` : window.location.pathname;
  window.history.replaceState(null, "", suffix);
}

function hydrateFromUrl() {
  const params = new URLSearchParams(window.location.search);
  elements.search.value = params.get("q") || "";
  elements.catalog.value = params.get("catalog") || "";
  elements.kind.value = params.get("kind") || "";
  elements.status.value = params.get("status") || "";
}

function activeFilterLabels() {
  const labels = [];
  if (elements.search.value.trim()) labels.push(`Search: ${elements.search.value.trim()}`);
  if (elements.catalog.value) labels.push(`Catalog: ${elements.catalog.value}`);
  if (elements.kind.value) labels.push(`Kind: ${elements.kind.value}`);
  if (elements.status.value === "default") labels.push("Default import surface");
  if (elements.status.value === "experimental") labels.push("Experimental module");
  return labels;
}

function renderActiveFilters() {
  elements.active.replaceChildren();
  for (const label of activeFilterLabels()) {
    const chip = document.createElement("span");
    chip.className = "filter-chip";
    chip.textContent = label;
    elements.active.append(chip);
  }
}

function createCard(declaration) {
  const card = elements.template.content.firstElementChild.cloneNode(true);
  if (declaration.experimental) card.classList.add("experimental");
  card.querySelector(".kind-badge").textContent = declaration.kind;
  card.querySelector(".status-badge").textContent =
    declaration.localStatus ||
    (declaration.experimental ? "experimental" : "default surface");
  card.querySelector(".catalog-badge").textContent = declaration.catalog;
  card.querySelector("h3").textContent = declaration.fullName;
  card.querySelector(".reader-label").textContent =
    `${declaration.readerLabel} · ${declaration.source}:${declaration.line}`;
  card.querySelector(".plain-english").textContent = declaration.plainEnglish;
  card.querySelector(".formal-status").textContent = declaration.formalStatus;
  card.querySelector("pre code").textContent =
    declaration.sourcePreview || "No bounded source preview is available.";

  const blueprint = card.querySelector(".blueprint-action");
  blueprint.href = declaration.blueprintUrl;
  blueprint.setAttribute("aria-label", `Open Blueprint catalog for ${declaration.fullName}`);

  const source = card.querySelector(".source-action");
  if (declaration.sourceUrl) {
    source.href = declaration.sourceUrl;
    source.setAttribute("aria-label", `Open source for ${declaration.fullName}`);
  } else {
    source.removeAttribute("href");
    source.textContent = "Commit link added during publication";
    source.setAttribute("aria-disabled", "true");
  }

  const copy = card.querySelector(".copy-action");
  copy.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(declaration.fullName);
      copy.textContent = "Copied";
      window.setTimeout(() => { copy.textContent = "Copy Lean name"; }, 1200);
    } catch {
      copy.textContent = "Copy unavailable";
    }
  });
  return card;
}

function renderResults() {
  elements.results.replaceChildren();
  const shown = state.filtered.slice(0, state.visible);
  if (!shown.length) {
    const empty = document.createElement("p");
    empty.className = "empty-state";
    empty.textContent = "No declaration matches these filters. Try a shorter name or reset the catalog.";
    elements.results.append(empty);
  } else {
    const fragment = document.createDocumentFragment();
    for (const declaration of shown) fragment.append(createCard(declaration));
    elements.results.append(fragment);
  }
  const total = state.filtered.length;
  elements.summary.textContent =
    `Showing ${formatCount(shown.length)} of ${formatCount(total)} matching declarations`;
  elements.loadMore.hidden = shown.length >= total;
  if (!elements.loadMore.hidden) {
    elements.loadMore.textContent =
      `Show ${formatCount(Math.min(40, total - shown.length))} more declarations`;
  }
}

function applyFilters() {
  const query = elements.search.value.trim().toLocaleLowerCase();
  state.filtered = state.inventory.declarations.filter((declaration) => {
    if (query && !declaration._search.includes(query)) return false;
    if (elements.catalog.value && declaration.catalog !== elements.catalog.value) return false;
    if (elements.kind.value && declaration.kind !== elements.kind.value) return false;
    if (elements.status.value === "default" && declaration.experimental) return false;
    if (elements.status.value === "experimental" && !declaration.experimental) return false;
    return true;
  });
  state.visible = 40;
  syncUrl();
  renderActiveFilters();
  renderResults();
}

async function loadInventory() {
  try {
    const response = await fetch("declarations.json");
    if (!response.ok) throw new Error(`inventory request returned ${response.status}`);
    state.inventory = await response.json();
    for (const declaration of state.inventory.declarations) {
      declaration._search = searchableText(declaration);
    }
    setText("#publicCount", formatCount(state.inventory.publicDeclarationCount));
    setText("#docCount", formatCount(state.inventory.sourceDocstringCount));
    setText("#cueCount", formatCount(state.inventory.generatedReaderCueCount));
    addOptions(elements.catalog, Object.keys(state.inventory.byCatalog));
    addOptions(elements.kind, uniqueSorted(state.inventory.declarations.map((item) => item.kind)));
    hydrateFromUrl();
    applyFilters();
  } catch (error) {
    elements.summary.textContent = "Declaration inventory could not be loaded.";
    const message = document.createElement("p");
    message.className = "empty-state";
    message.textContent = `The generated inventory is unavailable: ${error.message}`;
    elements.results.replaceChildren(message);
  }
}

let searchTimer;
elements.search.addEventListener("input", () => {
  window.clearTimeout(searchTimer);
  searchTimer = window.setTimeout(applyFilters, 120);
});
elements.catalog.addEventListener("change", applyFilters);
elements.kind.addEventListener("change", applyFilters);
elements.status.addEventListener("change", applyFilters);
elements.clear.addEventListener("click", () => {
  elements.search.value = "";
  elements.catalog.value = "";
  elements.kind.value = "";
  elements.status.value = "";
  applyFilters();
  elements.search.focus();
});
elements.loadMore.addEventListener("click", () => {
  state.visible += 40;
  renderResults();
});

loadInventory();
