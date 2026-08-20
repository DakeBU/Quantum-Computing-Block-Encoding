(() => {
  "use strict";

  const app = document.querySelector("[data-lean-graph]");
  if (!app) return;

  const svg = app.querySelector("[data-graph-svg]");
  const viewport = app.querySelector("[data-graph-viewport]");
  const stage = app.querySelector("[data-graph-stage]");
  const inspector = app.querySelector("[data-graph-inspector]");
  const search = app.querySelector("[data-graph-search]");
  const trackSelect = app.querySelector("[data-graph-track]");
  const status = app.querySelector("[data-graph-status]");
  const zoomIn = app.querySelector("[data-graph-zoom-in]");
  const zoomOut = app.querySelector("[data-graph-zoom-out]");
  const resetButton = app.querySelector("[data-graph-reset]");
  const collapseButton = app.querySelector("[data-graph-collapse]");
  const NS = "http://www.w3.org/2000/svg";

  let payload = null;
  let moduleNodes = [];
  let declarationNodes = [];
  let importEdges = [];
  let nodeById = new Map();
  let declarationsByModule = new Map();
  let selectedModule = null;
  let selectedNode = null;
  let scale = 0.72;
  let translateX = 18;
  let translateY = 18;
  let dragging = false;
  let dragStart = null;

  function svgElement(name, attributes = {}) {
    const element = document.createElementNS(NS, name);
    Object.entries(attributes).forEach(([key, value]) => {
      element.setAttribute(key, String(value));
    });
    return element;
  }

  function appendText(parent, text, x, y, className, maxLength = 44) {
    const node = svgElement("text", { x, y, class: className });
    const value = String(text || "");
    node.textContent = value.length > maxLength
      ? `${value.slice(0, maxLength - 1)}…`
      : value;
    parent.append(node);
    return node;
  }

  function applyTransform() {
    viewport.setAttribute(
      "transform",
      `translate(${translateX} ${translateY}) scale(${scale})`,
    );
  }

  function setZoom(next, anchor = null) {
    const previous = scale;
    scale = Math.min(2.4, Math.max(0.22, next));
    if (anchor && previous !== scale) {
      const ratio = scale / previous;
      translateX = anchor.x - (anchor.x - translateX) * ratio;
      translateY = anchor.y - (anchor.y - translateY) * ratio;
    }
    applyTransform();
  }

  function resetView() {
    scale = 0.72;
    translateX = 18;
    translateY = 18;
    applyTransform();
  }

  function normalize(text) {
    return String(text || "").toLowerCase();
  }

  function queryTerms() {
    return normalize(search?.value).trim().split(/\s+/).filter(Boolean);
  }

  function recordHaystack(module) {
    const declarations = declarationsByModule.get(module.fullName) || [];
    return normalize([
      module.label,
      module.fullName,
      module.source,
      module.description,
      ...(module.chapters || []).map((item) => item.label),
      ...(module.cases || []).map((item) => item.label),
      ...(module.papers || []).map((item) => item.label),
      ...declarations.flatMap((item) => [item.fullName, item.plain, item.kind]),
    ].join(" "));
  }

  function moduleIsVisible(module, terms, track) {
    if (track && module.track !== track) return false;
    if (!terms.length) return true;
    const haystack = recordHaystack(module);
    return terms.every((term) => haystack.includes(term));
  }

  function linkList(title, records) {
    if (!records?.length) return "";
    const items = records.map((record) => (
      `<li><a href="${record.url}">${escapeHtml(record.label)}</a></li>`
    )).join("");
    return `<section><h4>${escapeHtml(title)}</h4><ul>${items}</ul></section>`;
  }

  function nameList(title, names) {
    if (!names?.length) return "";
    const items = names.map((name) => {
      const module = nodeById.get(`module:${name}`);
      return module
        ? `<li><button type="button" data-inspector-module="${escapeHtml(name)}">${escapeHtml(name)}</button></li>`
        : `<li><code>${escapeHtml(name)}</code></li>`;
    }).join("");
    return `<section><h4>${escapeHtml(title)}</h4><ul>${items}</ul></section>`;
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function renderModuleInspector(module) {
    selectedNode = module;
    const declarations = declarationsByModule.get(module.fullName) || [];
    const leafItems = declarations.map((declaration) => (
      `<li><button type="button" data-inspector-declaration="${escapeHtml(declaration.id)}">`
      + `<code>${escapeHtml(declaration.label)}</code>`
      + `<small>${escapeHtml(declaration.kind)} · ${escapeHtml(declaration.status)}</small>`
      + `</button></li>`
    )).join("");
    inspector.innerHTML = `
      <p class="eyebrow">Lean module branch</p>
      <h3>${escapeHtml(module.label)}</h3>
      <p><code>${escapeHtml(module.fullName)}</code></p>
      <p>${escapeHtml(module.description)}</p>
      <dl>
        <div><dt>Source</dt><dd><code>${escapeHtml(module.source)}</code></dd></div>
        <div><dt>Public leaves</dt><dd>${module.declarationCount}</dd></div>
        <div><dt>Track</dt><dd>${escapeHtml(trackLabel(module.track))}</dd></div>
      </dl>
      <p><a class="button secondary compact-button" href="${module.url}">Open module page</a></p>
      ${linkList("Textbook chapters", module.chapters)}
      ${linkList("Attached example cases", module.cases)}
      ${linkList("Paper routes", module.papers)}
      ${nameList("Imports / foundations used", module.imports)}
      ${nameList("Downstream modules importing this branch", module.importedBy)}
      <section class="lean-graph-leaf-list">
        <h4>Declaration leaves</h4>
        <p>Click a leaf for its statement role; double-click the graph leaf to open the declaration.</p>
        <ul>${leafItems || "<li>No public declaration leaves in the generated inventory.</li>"}</ul>
      </section>`;
  }

  function renderDeclarationInspector(declaration) {
    selectedNode = declaration;
    const module = nodeById.get(`module:${declaration.module}`);
    inspector.innerHTML = `
      <p class="eyebrow">Public Lean declaration leaf</p>
      <h3>${escapeHtml(declaration.label)}</h3>
      <p><code>${escapeHtml(declaration.fullName)}</code></p>
      <p>${escapeHtml(declaration.plain || "No additional plain-language summary is recorded.")}</p>
      <dl>
        <div><dt>Kind</dt><dd>${escapeHtml(declaration.kind)}</dd></div>
        <div><dt>Status</dt><dd>${escapeHtml(declaration.status)}</dd></div>
        <div><dt>Source</dt><dd><code>${escapeHtml(declaration.source)}:${declaration.line}</code></dd></div>
        <div><dt>Open proof</dt><dd>${declaration.openProof ? "yes" : "no"}</dd></div>
      </dl>
      <p><a class="button" href="${declaration.url}">Open exact declaration</a></p>
      ${module ? `<p><button type="button" class="text-button" data-inspector-module="${escapeHtml(module.fullName)}">Back to ${escapeHtml(module.label)} branch</button></p>` : ""}`;
  }

  function trackLabel(trackId) {
    return payload?.tracks?.find((track) => track.id === trackId)?.label || trackId;
  }

  function selectModule(moduleName, redraw = true) {
    const module = nodeById.get(`module:${moduleName}`);
    if (!module) return;
    selectedModule = selectedModule === moduleName ? null : moduleName;
    if (selectedModule) renderModuleInspector(module);
    if (redraw) draw();
  }

  function leafMatches(declaration, terms) {
    if (!terms.length) return true;
    const haystack = normalize([
      declaration.fullName,
      declaration.label,
      declaration.plain,
      declaration.kind,
      declaration.status,
    ].join(" "));
    return terms.every((term) => haystack.includes(term));
  }

  function drawModuleNode(group, module, position, isSelected, isRelated) {
    const node = svgElement("g", {
      class: `lean-module-node${isSelected ? " is-selected" : ""}${isRelated ? " is-related" : ""}`,
      transform: `translate(${position.x} ${position.y})`,
      tabindex: "0",
      role: "button",
      "data-node-id": module.id,
      "aria-label": `${module.fullName}, ${module.declarationCount} declarations`,
    });
    node.append(svgElement("rect", { width: 330, height: 54, rx: 10, ry: 10 }));
    appendText(node, module.label, 15, 22, "lean-module-title", 38);
    appendText(node, module.fullName, 15, 41, "lean-module-name", 48);
    const badge = svgElement("g", { transform: "translate(286 10)" });
    badge.append(svgElement("rect", { width: 32, height: 25, rx: 12 }));
    appendText(badge, module.declarationCount, 16, 17, "lean-module-count", 5)
      .setAttribute("text-anchor", "middle");
    node.append(badge);
    group.append(node);
  }

  function drawLeafLane(group, module, modulePosition, terms, graphWidth) {
    let leaves = (declarationsByModule.get(module.fullName) || [])
      .filter((leaf) => leafMatches(leaf, terms));
    const total = leaves.length;
    leaves = leaves.slice(0, 120);
    const laneX = graphWidth - 410;
    appendText(group, `${module.label} · declaration leaves`, laneX, 58, "lean-leaf-lane-title", 52);
    if (total > leaves.length) {
      appendText(
        group,
        `Showing ${leaves.length} of ${total}; narrow the search to expose another leaf.`,
        laneX,
        80,
        "lean-leaf-lane-note",
        70,
      );
    }
    leaves.forEach((leaf, index) => {
      const y = 100 + index * 39;
      const connector = svgElement("path", {
        d: `M ${modulePosition.x + 330} ${modulePosition.y + 27} C ${laneX - 100} ${modulePosition.y + 27}, ${laneX - 80} ${y + 15}, ${laneX} ${y + 15}`,
        class: "lean-leaf-edge",
      });
      group.append(connector);
      const node = svgElement("g", {
        class: `lean-declaration-node${selectedNode?.id === leaf.id ? " is-selected" : ""}`,
        transform: `translate(${laneX} ${y})`,
        tabindex: "0",
        role: "link",
        "data-node-id": leaf.id,
        "aria-label": leaf.fullName,
      });
      node.append(svgElement("rect", { width: 350, height: 30, rx: 7, ry: 7 }));
      appendText(node, leaf.label, 11, 19, "lean-declaration-title", 44);
      appendText(node, leaf.kind, 338, 19, "lean-declaration-kind", 18)
        .setAttribute("text-anchor", "end");
      group.append(node);
    });
  }

  function draw() {
    if (!payload) return;
    viewport.replaceChildren();
    const terms = queryTerms();
    const selectedTrack = trackSelect?.value || "";
    const tracks = payload.tracks.filter((track) => !selectedTrack || track.id === selectedTrack);
    const visibleModules = moduleNodes.filter((module) => (
      moduleIsVisible(module, terms, selectedTrack)
    ));
    const modulesByTrack = new Map(tracks.map((track) => [track.id, []]));
    visibleModules.forEach((module) => modulesByTrack.get(module.track)?.push(module));
    modulesByTrack.forEach((modules) => modules.sort((a, b) => a.fullName.localeCompare(b.fullName)));

    const trackWidth = 410;
    const graphWidth = Math.max(1380, tracks.length * trackWidth + 620);
    const maxRows = Math.max(1, ...[...modulesByTrack.values()].map((items) => items.length));
    const selectedLeafCount = selectedModule
      ? (declarationsByModule.get(selectedModule) || []).filter((leaf) => leafMatches(leaf, terms)).length
      : 0;
    const graphHeight = Math.max(760, 150 + maxRows * 72, 150 + Math.min(selectedLeafCount, 120) * 39);
    svg.setAttribute("viewBox", `0 0 ${graphWidth} ${graphHeight}`);
    svg.style.minHeight = `${Math.min(1100, Math.max(660, graphHeight * 0.64))}px`;

    const positions = new Map();
    tracks.forEach((track, trackIndex) => {
      const x = 42 + trackIndex * trackWidth;
      const background = svgElement("g", { class: `lean-track lean-track-${track.id}` });
      background.append(svgElement("rect", {
        x: x - 18,
        y: 20,
        width: 374,
        height: graphHeight - 40,
        rx: 18,
        ry: 18,
      }));
      appendText(background, track.label, x, 54, "lean-track-title", 42);
      appendText(background, track.methodology, x, 76, "lean-track-note", 58);
      viewport.append(background);
      (modulesByTrack.get(track.id) || []).forEach((module, rowIndex) => {
        positions.set(module.id, { x, y: 100 + rowIndex * 72 });
      });
    });

    const edgeGroup = svgElement("g", { class: "lean-import-edges" });
    importEdges.forEach((edge) => {
      const source = positions.get(edge.source);
      const target = positions.get(edge.target);
      if (!source || !target) return;
      const selected = selectedModule && (
        edge.source === `module:${selectedModule}` || edge.target === `module:${selectedModule}`
      );
      const path = svgElement("path", {
        d: `M ${source.x + 330} ${source.y + 27} C ${source.x + 365} ${source.y + 27}, ${target.x - 35} ${target.y + 27}, ${target.x} ${target.y + 27}`,
        class: `lean-import-edge${selected ? " is-selected" : ""}`,
        "marker-end": "url(#lean-graph-arrow)",
      });
      edgeGroup.append(path);
    });
    viewport.append(edgeGroup);

    const nodeGroup = svgElement("g", { class: "lean-module-nodes" });
    const related = new Set();
    if (selectedModule) {
      const module = nodeById.get(`module:${selectedModule}`);
      (module?.imports || []).forEach((name) => related.add(name));
      (module?.importedBy || []).forEach((name) => related.add(name));
    }
    visibleModules.forEach((module) => {
      const position = positions.get(module.id);
      if (!position) return;
      drawModuleNode(
        nodeGroup,
        module,
        position,
        module.fullName === selectedModule,
        related.has(module.fullName),
      );
    });
    viewport.append(nodeGroup);

    if (selectedModule) {
      const module = nodeById.get(`module:${selectedModule}`);
      const position = positions.get(`module:${selectedModule}`);
      if (module && position) {
        const leafGroup = svgElement("g", { class: "lean-leaf-lane" });
        drawLeafLane(leafGroup, module, position, terms, graphWidth);
        viewport.append(leafGroup);
      }
    }

    const leafWord = selectedModule ? `; ${selectedLeafCount} matching leaves in the open branch` : "";
    status.textContent = `${visibleModules.length} modules shown${leafWord}. Import arrows point from reusable dependencies toward modules that import them.`;
    applyTransform();
  }

  function handleNode(nodeId, open = false) {
    const node = nodeById.get(nodeId);
    if (!node) return;
    if (open && node.url) {
      window.location.href = node.url;
      return;
    }
    if (node.type === "module") {
      selectModule(node.fullName);
      return;
    }
    if (node.type === "declaration") {
      selectedNode = node;
      renderDeclarationInspector(node);
      draw();
    }
  }

  async function load() {
    try {
      const response = await fetch(app.dataset.url, { cache: "no-store" });
      if (!response.ok) throw new Error(`graph data ${response.status}`);
      payload = await response.json();
      nodeById = new Map(payload.nodes.map((node) => [node.id, node]));
      moduleNodes = payload.nodes.filter((node) => node.type === "module");
      declarationNodes = payload.nodes.filter((node) => node.type === "declaration");
      importEdges = payload.edges.filter((edge) => edge.type === "module-supports-importer");
      declarationsByModule = new Map();
      declarationNodes.forEach((declaration) => {
        const leaves = declarationsByModule.get(declaration.module) || [];
        leaves.push(declaration);
        declarationsByModule.set(declaration.module, leaves);
      });
      declarationsByModule.forEach((leaves) => (
        leaves.sort((a, b) => a.fullName.localeCompare(b.fullName))
      ));
      payload.tracks.forEach((track) => {
        const option = document.createElement("option");
        option.value = track.id;
        option.textContent = track.label;
        trackSelect.append(option);
      });
      draw();
    } catch (error) {
      status.textContent = `The Lean graph could not be loaded: ${error.message}`;
      status.classList.add("is-error");
    }
  }

  search?.addEventListener("input", () => draw());
  trackSelect?.addEventListener("change", () => {
    selectedModule = null;
    selectedNode = null;
    draw();
  });
  zoomIn?.addEventListener("click", () => setZoom(scale * 1.18));
  zoomOut?.addEventListener("click", () => setZoom(scale / 1.18));
  resetButton?.addEventListener("click", resetView);
  collapseButton?.addEventListener("click", () => {
    selectedModule = null;
    selectedNode = null;
    inspector.innerHTML = `
      <p class="eyebrow">Selected branch</p><h3>Choose a module</h3>
      <p>The inspector will show imported foundations, downstream users,
      textbook chapters, attached papers/cases, and every public Lean leaf.</p>`;
    draw();
  });

  svg.addEventListener("click", (event) => {
    const target = event.target.closest("[data-node-id]");
    if (target) handleNode(target.dataset.nodeId);
  });
  svg.addEventListener("dblclick", (event) => {
    const target = event.target.closest("[data-node-id]");
    if (target) handleNode(target.dataset.nodeId, true);
  });
  svg.addEventListener("keydown", (event) => {
    const target = event.target.closest("[data-node-id]");
    if (!target || !["Enter", " "].includes(event.key)) return;
    event.preventDefault();
    handleNode(target.dataset.nodeId, event.shiftKey);
  });

  inspector.addEventListener("click", (event) => {
    const moduleButton = event.target.closest("[data-inspector-module]");
    if (moduleButton) {
      const module = nodeById.get(`module:${moduleButton.dataset.inspectorModule}`);
      if (module) {
        selectedModule = module.fullName;
        renderModuleInspector(module);
        draw();
      }
      return;
    }
    const declarationButton = event.target.closest("[data-inspector-declaration]");
    if (declarationButton) {
      const declaration = nodeById.get(declarationButton.dataset.inspectorDeclaration);
      if (declaration) renderDeclarationInspector(declaration);
    }
  });

  stage.addEventListener("pointerdown", (event) => {
    if (event.target.closest("[data-node-id]")) return;
    dragging = true;
    dragStart = { x: event.clientX, y: event.clientY, tx: translateX, ty: translateY };
    stage.setPointerCapture(event.pointerId);
    stage.classList.add("is-dragging");
  });
  stage.addEventListener("pointermove", (event) => {
    if (!dragging || !dragStart) return;
    translateX = dragStart.tx + event.clientX - dragStart.x;
    translateY = dragStart.ty + event.clientY - dragStart.y;
    applyTransform();
  });
  function endDrag(event) {
    if (!dragging) return;
    dragging = false;
    dragStart = null;
    stage.classList.remove("is-dragging");
    if (stage.hasPointerCapture(event.pointerId)) stage.releasePointerCapture(event.pointerId);
  }
  stage.addEventListener("pointerup", endDrag);
  stage.addEventListener("pointercancel", endDrag);
  stage.addEventListener("wheel", (event) => {
    event.preventDefault();
    const bounds = svg.getBoundingClientRect();
    setZoom(
      scale * (event.deltaY < 0 ? 1.12 : 1 / 1.12),
      { x: event.clientX - bounds.left, y: event.clientY - bounds.top },
    );
  }, { passive: false });

  load();
})();
