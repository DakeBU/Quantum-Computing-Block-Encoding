(() => {
  "use strict";

  const switcher = document.querySelector("[data-reader-mode-switch]");
  if (!switcher) return;

  const body = document.body;
  const modes = ["concept", "math", "lean"];
  const storageKey = "quantumcomputinglib-reader-mode";
  const requested = new URLSearchParams(window.location.search).get("mode");
  const hashWantsLean = window.location.hash.startsWith("#decl-");
  const saved = localStorage.getItem(storageKey);

  function setMode(mode, persist = true) {
    const selected = modes.includes(mode) ? mode : "concept";
    body.classList.add("reader-mode-enabled");
    body.dataset.readerMode = selected;
    switcher.querySelectorAll("[data-reader-mode-choice]").forEach((button) => {
      button.setAttribute(
        "aria-pressed",
        String(button.dataset.readerModeChoice === selected),
      );
    });
    if (persist) localStorage.setItem(storageKey, selected);
  }

  setMode(hashWantsLean ? "lean" : requested || saved || "concept", false);

  switcher.querySelectorAll("[data-reader-mode-choice]").forEach((button) => {
    button.addEventListener("click", () => {
      setMode(button.dataset.readerModeChoice);
      const lesson = document.querySelector("[data-concept-first-lesson]");
      lesson?.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  });

  window.addEventListener("hashchange", () => {
    if (window.location.hash.startsWith("#decl-")) setMode("lean", false);
  });
})();
