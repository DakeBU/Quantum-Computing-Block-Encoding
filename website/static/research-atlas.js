(() => {
  "use strict";
  const book = document.querySelector(".ra-book");
  if (!book) return;
  const query = book.querySelector("[data-ra-search]");
  if (query) {
    const cards = [...book.querySelectorAll("[data-ra-item]")];
    const count = book.querySelector("[data-ra-count]");
    const filter = () => {
      const terms = query.value.toLocaleLowerCase().trim().split(/\s+/).filter(Boolean);
      let visible = 0;
      cards.forEach((card) => {
        const text = card.dataset.raItem.toLocaleLowerCase();
        card.hidden = !terms.every((term) => text.includes(term));
        if (!card.hidden) visible += 1;
      });
      if (count) count.textContent = `${visible} matching cards. Shared families retain the same identity across domains.`;
    };
    query.addEventListener("input", filter);
    filter();
  }
  book.querySelectorAll("[data-ra-copy]").forEach((button) => {
    button.addEventListener("click", async () => {
      const text = button.closest("details")?.querySelector("pre code")?.textContent;
      if (!text) return;
      try {
        await navigator.clipboard.writeText(text);
        button.textContent = "Copied";
      } catch (_) {
        button.textContent = "Select and copy the text below";
      }
    });
  });
  const app = book.querySelector("[data-ra-hypergraph]");
  if (!app) return;
  const select = app.querySelector("[data-ra-edge]");
  const svg = app.querySelector("[data-ra-svg]");
  const status = app.querySelector("[data-ra-graph-status]");
  const NS = "http://www.w3.org/2000/svg";
  const mobile = window.matchMedia("(max-width: 760px)");
  let atlas = null;
  let current = null;
  const node = (tag, attrs = {}, text = null) => {
    const result = document.createElementNS(NS, tag);
    Object.entries(attrs).forEach(([key, value]) => result.setAttribute(key, String(value)));
    if (text !== null) result.textContent = text;
    return result;
  };
  const add = (tag, attrs, text) => {
    const element = node(tag, attrs, text);
    svg.append(element);
    return element;
  };
  const words = (value, max = 34) => {
    const lines = [];
    let line = "";
    for (const word of value.split(/\s+/)) {
      if (line && (line + " " + word).length > max) {
        lines.push(line);
        line = word;
      } else line += (line ? " " : "") + word;
    }
    if (line) lines.push(line);
    return lines;
  };
  function box(record, x, y, width, target = false) {
    const slug = record.id.split(":").slice(1).join(":");
    const href = record.id.startsWith("family:")
      ? `../mathematical-methods/${slug}/index.html`
      : `../mathematical-methods/index.html#${slug}`;
    const anchor = node("a", { href, tabindex: 0, "aria-label": record.label });
    anchor.append(node("title", {}, `${record.label}: ${record.id}`));
    anchor.append(node("rect", { x, y, width, height: 64, class: `ra-graph-node${target ? " ra-graph-target" : ""}` }));
    const lines = words(record.label, mobile.matches ? 40 : 32);
    const label = node("text", { x: x + 16, y: y + (lines.length > 1 ? 26 : 37), class: "ra-graph-text" });
    lines.forEach((line, index) => label.append(node("tspan", { x: x + 16, dy: index ? 19 : 0 }, line)));
    anchor.append(label);
    svg.append(anchor);
  }
  function junction(x, y) {
    add("polygon", { points: `${x},${y-34} ${x+45},${y} ${x},${y+34} ${x-45},${y}`, class: "ra-graph-junction" });
    add("text", { x, y: y + 5, "text-anchor": "middle", class: "ra-graph-and" }, "AND");
  }
  function path(points) {
    add("path", { d: points, class: "ra-graph-line", "marker-end": "url(#ra-arrow)" });
  }
  function draw() {
    if (!atlas) return;
    current = atlas.hyperedges.find((edge) => edge.id === select.value) || atlas.hyperedges[0];
    const byId = new Map([...atlas.domains, ...atlas.families].map((record) => [record.id, record]));
    svg.replaceChildren();
    svg.dataset.edgeId = current.id;
    svg.dataset.tailCount = String(current.tails.length);
    const title = add("title", {}, current.label);
    title.id = "ra-active-title";
    svg.setAttribute("aria-labelledby", title.id);
    add("desc", {}, `All ${current.tails.length} input mechanisms are required together. ${current.status}. Not a Lean implication or certified functor. ${current.failure_boundary}`);
    const defs = add("defs");
    const marker = node("marker", { id: "ra-arrow", markerWidth: 8, markerHeight: 8, refX: 7, refY: 4, orient: "auto", markerUnits: "strokeWidth" });
    marker.append(node("path", { d: "M0 0L8 4L0 8Z", fill: "var(--muted)" }));
    defs.append(marker);
    if (mobile.matches) {
      const width = 480, x = 38, boxWidth = 365;
      const middle = 74 + current.tails.length * 86;
      const height = middle + 85 + current.heads.length * 86 + 40;
      svg.setAttribute("viewBox", `0 0 ${width} ${height}`);
      add("text", { x: 38, y: 27, class: "ra-graph-label" }, "ALL INPUTS REQUIRED TOGETHER");
      current.tails.forEach((id, i) => {
        const y = 42 + i * 86;
        path(`M${x+boxWidth} ${y+32}H444V${middle}H${240+45}`);
        box(byId.get(id), x, y, boxWidth);
      });
      junction(240, middle);
      current.heads.forEach((id, i) => {
        const y = middle + 65 + i * 86;
        path(`M240 ${middle+34}V${y}`);
        box(byId.get(id), x, y, boxWidth, true);
      });
    } else {
      const height = Math.max(280, 80 + Math.max(current.tails.length, current.heads.length) * 90);
      const center = height / 2;
      svg.setAttribute("viewBox", `0 0 1000 ${height}`);
      add("text", { x: 28, y: 30, class: "ra-graph-label" }, "ALL INPUTS REQUIRED TOGETHER");
      add("text", { x: 652, y: 30, class: "ra-graph-label" }, "CONDITIONAL OUTPUT");
      current.tails.forEach((id, index) => {
        const y = center - current.tails.length * 44 + index * 88;
        path(`M348 ${y+32}C395 ${y+32},415 ${center},455 ${center}`);
        box(byId.get(id), 28, y, 320);
      });
      junction(500, center);
      current.heads.forEach((id, index) => {
        const y = center - current.heads.length * 44 + index * 88;
        path(`M545 ${center}C595 ${center},610 ${y+32},652 ${y+32}`);
        box(byId.get(id), 652, y, 320, true);
      });
    }
    status.textContent = `${current.status}: ${current.tails.length} conjunctive inputs. ${current.failure_boundary}`;
  }
  function syncHash() {
    if (!atlas) return;
    const hash = decodeURIComponent(location.hash.slice(1));
    const edge = atlas.hyperedges.find((record) => record.id === hash || record.id.split(":")[1] === hash);
    if (edge) select.value = edge.id;
    draw();
  }
  select.addEventListener("change", () => {
    draw();
    history.replaceState(null, "", "#" + current.id.split(":")[1]);
  });
  window.addEventListener("hashchange", syncHash);
  mobile.addEventListener("change", draw);
  app.querySelector("[data-ra-download-svg]").addEventListener("click", () => {
    if (!current) return;
    const clone = svg.cloneNode(true);
    // Resolve theme variables so the downloaded scientific diagram is standalone.
    const computed = getComputedStyle(document.documentElement);
    const colors = { ink: computed.getPropertyValue("--ink").trim(), muted: computed.getPropertyValue("--muted").trim(), surface: computed.getPropertyValue("--surface").trim(), block: computed.getPropertyValue("--block").trim(), state: computed.getPropertyValue("--state").trim(), warm: computed.getPropertyValue("--warm").trim(), soft: computed.getPropertyValue("--warm-soft").trim() };
    const style = node("style", {}, `.ra-graph-line{fill:none;stroke:${colors.muted};stroke-width:1.7;stroke-dasharray:6 5}.ra-graph-node{fill:${colors.surface};stroke:${colors.block};stroke-width:1.5}.ra-graph-target{stroke:${colors.state}}.ra-graph-text{fill:${colors.ink};font:15px sans-serif}.ra-graph-label{fill:${colors.muted};font:12px sans-serif}.ra-graph-and{fill:${colors.ink};font:bold 16px sans-serif}.ra-graph-junction{fill:${colors.soft};stroke:${colors.warm};stroke-width:2}`);
    clone.prepend(style);
    clone.querySelector("marker path")?.setAttribute("fill", colors.muted);
    const blob = new Blob([new XMLSerializer().serializeToString(clone)], { type: "image/svg+xml" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = current.id.replace(":", "-") + ".svg";
    link.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  });
  fetch(app.dataset.url, { cache: "no-store" }).then((response) => {
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return response.json();
  }).then((data) => { atlas = data; syncHash(); }).catch((error) => {
    status.textContent = `Interactive diagram unavailable: ${error.message}. Complete static input/output and hypothesis maps remain below.`;
    status.setAttribute("role", "alert");
  });
})();
