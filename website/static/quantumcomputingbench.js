/* Progressive enhancement: all exercise links work without JavaScript. */
(() => {
  "use strict";
  function start() {
    const controls = document.querySelector("[data-qcb-controls]");
    if (!controls) return;
    const query = controls.querySelector("[data-qcb-query]");
    const count = controls.querySelector("[data-qcb-count]");
    const cards = [...document.querySelectorAll("[data-qcb-card]")];
    controls.hidden = false;
    function update() {
      const terms = query.value.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);
      let visible = 0;
      for (const card of cards) {
        const text = card.dataset.qcbSearch.toLocaleLowerCase();
        card.hidden = !terms.every(term => text.includes(term));
        if (!card.hidden) visible++;
      }
      count.textContent = `${visible} of ${cards.length} exercises${visible ? "" : " — no matches"}`;
    }
    query.addEventListener("input", update);
    update();
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", start);
  else start();
})();
