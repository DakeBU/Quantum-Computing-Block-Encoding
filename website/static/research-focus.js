(() => {
  "use strict";
  const requested = new URLSearchParams(location.search).get("focus");
  const app = document.querySelector("[data-lean-graph]");
  if (!requested || !app) return;
  const svg = app.querySelector("[data-graph-svg]");
  const search = app.querySelector("[data-graph-search]");
  if (!svg || !search) return;
  const message = document.createElement("p");
  message.className = "ra-boundary";
  message.setAttribute("aria-live", "polite");
  app.prepend(message);
  let done = false, opening = false, observer;
  const locate = (id) => [...svg.querySelectorAll("[data-node-id]")].find((node) => node.dataset.nodeId === id);
  fetch(app.dataset.url, { cache: "no-store" }).then((response) => {
    if (!response.ok) throw new Error(`graph HTTP ${response.status}`);
    return response.json();
  }).then((graph) => {
    const target = graph.nodes.find((node) => node.id === requested);
    if (!target || !["module", "declaration"].includes(target.type)) throw new Error("unknown graph identity");
    const moduleId = target.type === "module" ? target.id : "module:" + target.module;
    const attempt = () => {
      if (done || opening) return;
      const module = locate(moduleId);
      if (!module) return;
      opening = true;
      search.value = target.fullName;
      search.dispatchEvent(new Event("input", { bubbles: true }));
      const visibleModule = locate(moduleId);
      if (!visibleModule) { opening = false; return; }
      visibleModule.dispatchEvent(new MouseEvent("click", { bubbles: true }));
      const selected = target.type === "module" ? locate(moduleId) : locate(target.id);
      if (!selected) { opening = false; return; }
      if (target.type === "declaration") selected.dispatchEvent(new MouseEvent("click", { bubbles: true }));
      done = true;
      observer.disconnect();
      const focused = locate(target.id);
      focused?.focus({ preventScroll: true });
      message.textContent = "Focused exact shared identity: " + target.id + ". Import arrows remain module-level dependencies, not elaborated proof-term claims.";
      opening = false;
    };
    observer = new MutationObserver(() => requestAnimationFrame(attempt));
    observer.observe(svg, { childList: true, subtree: true });
    attempt();
    setTimeout(() => {
      if (!done) {
        observer.disconnect();
        message.textContent = "The requested declaration is present in the graph data, but automatic focus was unavailable. Search its exact name: " + target.fullName;
      }
    }, 15000);
  }).catch((error) => { message.textContent = "Exact graph focus unavailable: " + error.message; });
})();
