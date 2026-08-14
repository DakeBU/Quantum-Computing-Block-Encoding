(() => {
  "use strict";

  const app = document.querySelector("[data-case-workbench]");
  if (!app) return;

  const dataNode = app.querySelector("[data-case-editor-data]");
  const formula = app.querySelector("[data-case-formula]");
  const formulaPreview = app.querySelector("[data-case-formula-preview]");
  const proof = app.querySelector("[data-case-proof]");
  const proofPreview = app.querySelector("[data-case-proof-preview]");
  const circuitSelect = app.querySelector("[data-case-circuit-select]");
  const circuit = app.querySelector("[data-case-circuit]");
  const circuitPreview = app.querySelector("[data-case-circuit-preview]");
  const circuitDiagnostic = app.querySelector("[data-case-circuit-diagnostic]");
  const data = JSON.parse(dataNode.textContent);
  const svgNamespace = "http://www.w3.org/2000/svg";

  const extractArgument = (source, command) => {
    const start = source.indexOf(command);
    if (start < 0) return null;
    const brace = source.indexOf("{", start + command.length);
    if (brace < 0) return null;
    let depth = 0;
    for (let index = brace; index < source.length; index += 1) {
      if (source[index] === "{") depth += 1;
      if (source[index] === "}") {
        depth -= 1;
        if (depth === 0) return source.slice(brace + 1, index);
      }
    }
    return null;
  };

  const plainLabel = (source) => source
    .replaceAll("$", "")
    .replace(/\\ket\{([^{}]*)\}/g, "|$1>")
    .replace(/\\(?:mathrm|textrm|rm)\s*\{([^{}]*)\}/g, "$1")
    .replaceAll("\\dagger", "†")
    .replaceAll("\\perp", "perp")
    .replaceAll("\\alpha", "alpha")
    .replaceAll("\\theta", "theta")
    .replaceAll("\\arccos", "arccos")
    .replace(/\\[!,;]/g, " ")
    .replace(/[{}]/g, "")
    .replace(/\\/g, "")
    .replace(/\s+/g, " ")
    .trim();

  const rowsFor = (source) => source
    .replace(/\\begin\{quantikz\}(?:\[[^\]]*\])?/, "")
    .replace(/\\end\{quantikz\}/, "")
    .trim()
    .split(/\\\\\s*(?:\n|$)/)
    .filter((row) => row.trim())
    .map((row) => row.split("&").map((cell) => cell.trim()));

  const svgElement = (name, attributes = {}) => {
    const node = document.createElementNS(svgNamespace, name);
    Object.entries(attributes).forEach(([key, value]) => node.setAttribute(key, String(value)));
    return node;
  };

  const appendText = (svg, className, x, y, value, anchor = "start") => {
    const node = svgElement("text", { class: className, x, y, "text-anchor": anchor });
    node.textContent = value;
    svg.append(node);
  };

  const renderCircuit = () => {
    const rows = rowsFor(circuit.value);
    const rowGap = 62;
    const colGap = 132;
    const left = 118;
    const top = 38;
    const columns = Math.max(1, ...rows.map((row) => row.length));
    const width = Math.max(430, left + Math.max(1, columns - 1) * colGap + 116);
    const height = Math.max(104, top * 2 + Math.max(0, rows.length - 1) * rowGap);
    const svg = svgElement("svg", {
      class: "quantikz-preview",
      viewBox: `0 0 ${width} ${height}`,
      role: "img",
      "aria-label": `${circuitSelect.value} edited circuit preview`,
    });

    rows.forEach((row, rowIndex) => {
      const y = top + rowIndex * rowGap;
      svg.append(svgElement("line", { class: "qc-wire", x1: 92, y1: y, x2: width - 34, y2: y }));
      row.forEach((cell, columnIndex) => {
        const x = left + columnIndex * colGap;
        const leftLabel = extractArgument(cell, "\\lstick");
        const rightLabel = extractArgument(cell, "\\rstick");
        const gateLabel = extractArgument(cell, "\\gate");
        if (leftLabel !== null) appendText(svg, "qc-register", 8, y + 5, plainLabel(leftLabel));
        if (gateLabel !== null) {
          const wiresMatch = cell.match(/\\gate\[wires=(\d+)\]/);
          const wires = wiresMatch ? Number(wiresMatch[1]) : 1;
          const gateHeight = 38 + (wires - 1) * rowGap;
          const gateY = y - 19;
          svg.append(svgElement("rect", {
            class: "qc-gate", x: x - 48, y: gateY, width: 96, height: gateHeight, rx: 4,
          }));
          appendText(svg, "qc-gate-label", x, gateY + gateHeight / 2 + 4, plainLabel(gateLabel), "middle");
        }
        const control = cell.match(/\\ctrl\{(-?\d+)\}/);
        if (control) {
          const targetY = y + Number(control[1]) * rowGap;
          svg.append(svgElement("line", { class: "qc-control", x1: x, y1: y, x2: x, y2: targetY }));
          svg.append(svgElement("circle", { class: "qc-control-dot", cx: x, cy: y, r: 5 }));
        }
        if (cell.includes("\\targ")) {
          svg.append(svgElement("circle", { class: "qc-target", cx: x, cy: y, r: 12 }));
          svg.append(svgElement("line", { class: "qc-target", x1: x - 8, y1: y, x2: x + 8, y2: y }));
          svg.append(svgElement("line", { class: "qc-target", x1: x, y1: y - 8, x2: x, y2: y + 8 }));
        }
        if (cell.includes("\\meter")) {
          svg.append(svgElement("path", { class: "qc-meter", d: `M${x - 15},${y + 10} A15,15 0 0 1 ${x + 15},${y + 10}` }));
          svg.append(svgElement("line", { class: "qc-meter", x1: x, y1: y + 8, x2: x + 9, y2: y - 8 }));
        }
        if (rightLabel !== null) appendText(svg, "qc-output", Math.min(width - 190, x - 20), y - 12, plainLabel(rightLabel));
      });
    });
    circuitPreview.replaceChildren(svg);
    circuitDiagnostic.textContent = rows.length
      ? `${rows.length} register row${rows.length === 1 ? "" : "s"}; preview uses the documented grouped-register quantikz subset.`
      : "No quantikz rows could be parsed. Keep the begin/end environment and separate wires with \\\\ lines.";
  };

  const typeset = async (nodes) => {
    try {
      if (window.MathJax?.startup?.promise) await window.MathJax.startup.promise;
      window.MathJax?.typesetClear?.(nodes);
      await window.MathJax?.typesetPromise?.(nodes);
    } catch (error) {
      console.error("Case preview typesetting failed", error);
    }
  };

  const renderFormula = () => {
    formulaPreview.textContent = formula.value.trim() ? `\\[${formula.value.trim()}\\]` : "Enter a construction.";
    typeset([formulaPreview]);
  };

  const inlineMath = (source) => source.replace(/\$([^$]+)\$/g, "\\($1\\)");

  const renderProof = () => {
    proofPreview.replaceChildren();
    proof.value.split(/\r?\n/).map((step) => step.trim()).filter(Boolean).forEach((step) => {
      const item = document.createElement("li");
      item.textContent = inlineMath(step);
      proofPreview.append(item);
    });
    typeset([proofPreview]);
  };

  const loadCircuit = (name) => {
    circuitSelect.value = name;
    circuit.value = data.circuits[name];
    renderCircuit();
  };

  const proofAsLatex = () => [
    "\\begin{enumerate}",
    ...proof.value.split(/\r?\n/).map((step) => step.trim()).filter(Boolean).map((step) => `  \\item ${step}`),
    "\\end{enumerate}",
  ].join("\n");

  const copyText = async (value, button) => {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(value);
    } else {
      const fallback = document.createElement("textarea");
      fallback.value = value;
      fallback.setAttribute("readonly", "");
      fallback.style.position = "fixed";
      fallback.style.opacity = "0";
      document.body.append(fallback);
      fallback.select();
      document.execCommand("copy");
      fallback.remove();
    }
    const original = button.textContent;
    button.textContent = "Copied";
    window.setTimeout(() => { button.textContent = original; }, 1200);
  };

  formula.value = data.formula;
  proof.value = data.proofSteps.join("\n");
  loadCircuit(circuitSelect.value);
  renderFormula();
  renderProof();

  formula.addEventListener("input", renderFormula);
  proof.addEventListener("input", renderProof);
  circuit.addEventListener("input", renderCircuit);
  circuitSelect.addEventListener("change", () => loadCircuit(circuitSelect.value));
  document.querySelectorAll("[data-edit-circuit]").forEach((link) => {
    link.addEventListener("click", () => loadCircuit(link.dataset.editCircuit));
  });
  app.querySelectorAll("[data-copy-editor]").forEach((button) => {
    button.addEventListener("click", () => {
      const kind = button.dataset.copyEditor;
      const value = kind === "formula" ? formula.value : kind === "proof" ? proofAsLatex() : circuit.value;
      copyText(value, button);
    });
  });
})();
