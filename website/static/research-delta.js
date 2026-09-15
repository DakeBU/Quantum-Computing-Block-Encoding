(() => {
  "use strict";
  const panels = [...document.querySelectorAll("[data-ra-delta]")];
  if (!panels.length) return;
  const NS = "http://www.w3.org/2000/svg";
  const mobile = matchMedia("(max-width:760px)");
  const make = (tag, attributes = {}, text) => {
    const element = document.createElementNS(NS, tag);
    Object.entries(attributes).forEach(([key, value]) => element.setAttribute(key, String(value)));
    if (text !== undefined) element.textContent = text;
    return element;
  };
  function lines(value) {
    const words = value.replace("module:QuantumBlockEncoding.", "").replace(/([a-z0-9])([A-Z])/g, "$1 $2").split(/\s+/);
    const result = []; let line = "";
    for (const word of words) {
      if (line && (line + " " + word).length > 29) { result.push(line); line = word; }
      else line += (line ? " " : "") + word;
    }
    if (line) result.push(line);
    return result;
  }
  Promise.all([fetch("../data/research/contributions.json"), fetch("../data/lean-graph.json")].map(async (response) => {
    const r = await response;
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    return r.json();
  })).then(([payload, graph]) => {
    const nodes = new Map(graph.nodes.map((node) => [node.id, node]));
    panels.forEach((panel) => {
      const delta = payload.contributions.find((item) => item.contribution_id === panel.dataset.raDelta);
      const status = panel.querySelector("[data-ra-delta-status]");
      if (!delta || delta.status !== "computed") { status.textContent = "Pinned Git history is unavailable. No computed graph delta is claimed."; return; }
      const edges = [...delta.added_imports.map(([source, target]) => ({ source, target, added: true })), ...delta.removed_imports.map(([source, target]) => ({ source, target, added: false }))];
      const ids = [...new Set([...delta.added_modules, ...delta.removed_modules, ...edges.flatMap((edge) => [edge.source, edge.target])])].sort();
      const select = panel.querySelector("[data-ra-delta-select]");
      ids.forEach((id) => { const option = document.createElement("option"); option.value = id; option.textContent = id.replace("module:QuantumBlockEncoding.", ""); select.append(option); });
      const preferred = "module:QuantumBlockEncoding.ConstructiveHermitePreparation";
      if (ids.includes(preferred)) select.value = preferred;
      const svg = panel.querySelector("[data-ra-delta-svg]");
      function draw() {
        const focus = select.value;
        const incoming = edges.filter((edge) => edge.target === focus);
        const outgoing = edges.filter((edge) => edge.source === focus);
        svg.replaceChildren();
        svg.dataset.focus = focus;
        svg.dataset.edgeCount = String(incoming.length + outgoing.length);
        svg.append(make("title", {}, `Changed module-import neighborhood of ${focus}`));
        const defs = make("defs");
        const markerId = panel.dataset.raDelta.replace(":", "-") + "-arrow";
        const marker = make("marker", { id: markerId, markerWidth: 8, markerHeight: 8, refX: 7, refY: 4, orient: "auto" });
        marker.append(make("path", { d: "M0 0L8 4L0 8Z", fill: "var(--muted)" })); defs.append(marker); svg.append(defs);
        const connect = (d, added) => svg.append(make("path", { d, fill: "none", stroke: added ? "var(--state)" : "var(--warm)", "stroke-width": 1.6, "stroke-dasharray": added ? "none" : "6 5", "marker-end": `url(#${markerId})` }));
        function box(id, x, y, width, central = false) {
          const entry = nodes.get(id);
          const link = entry?.url;
          const group = make(link ? "a" : "g", link ? { href: link, tabindex: 0, "aria-label": id } : { role: "group", "aria-label": id });
          group.append(make("title", {}, id));
          group.append(make("rect", { x, y, width, height: 84, rx: 6, fill: central ? "var(--block-soft)" : "var(--surface)", stroke: central ? "var(--block)" : "var(--line-strong)", "stroke-width": central ? 2.5 : 1.2 }));
          const label = make("text", { x: x + 12, y: y + (mobile.matches ? 27 : 22), fill: "var(--ink)", "font-size": mobile.matches ? 19 : 14, "font-family": "sans-serif" });
          lines(id).forEach((line, index) => label.append(make("tspan", { x: x + 12, dy: index ? (mobile.matches ? 23 : 17) : 0 }, line)));
          group.append(label); svg.append(group);
        }
        if (mobile.matches) {
          const center = 42 + incoming.length * 100;
          svg.setAttribute("viewBox", `0 0 480 ${center + 120 + outgoing.length * 100 + 25}`);
          incoming.forEach((edge, i) => connect(`M405 ${42+i*100+42}H452V${center+42}H405`, edge.added));
          outgoing.forEach((edge, i) => connect(`M405 ${center+42}H452V${center+120+i*100+42}H405`, edge.added));
          incoming.forEach((edge, i) => box(edge.source, 35, 42 + i * 100, 370));
          box(focus, 35, center, 370, true);
          outgoing.forEach((edge, i) => box(edge.target, 35, center + 120 + i * 100, 370));
        } else {
          const height = Math.max(250, 90 + Math.max(incoming.length, outgoing.length) * 100);
          const center = height / 2 - 42;
          svg.setAttribute("viewBox", `0 0 1000 ${height}`);
          incoming.forEach((edge, i) => connect(`M325 ${50+i*100+42}C347 ${50+i*100+42},342 ${center+42},360 ${center+42}`, edge.added));
          outgoing.forEach((edge, i) => connect(`M640 ${center+42}C658 ${center+42},653 ${50+i*100+42},675 ${50+i*100+42}`, edge.added));
          incoming.forEach((edge, i) => box(edge.source, 20, 50 + i * 100, 305));
          box(focus, 360, center, 280, true);
          outgoing.forEach((edge, i) => box(edge.target, 675, 50 + i * 100, 305));
        }
        status.textContent = `${delta.baseline.slice(0, 8)} → ${delta.head.slice(0, 8)}: ${incoming.length} changed incoming imports; ${outgoing.length} changed outgoing imports. All incident changed edges are shown. Curated contribution classes: ${delta.classes.join(", ")}.`;
      }
      select.addEventListener("change", draw); mobile.addEventListener("change", draw); draw();
    });
  }).catch((error) => panels.forEach((panel) => { panel.querySelector("[data-ra-delta-status]").textContent = "Interactive delta unavailable: " + error.message + ". The pinned JSON and static description remain available."; }));
})();
