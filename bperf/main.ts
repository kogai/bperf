const mutationWatcher = new MutationObserver(list => {
  console.log("[EVENT] On DOM mutate", list.length);
  list.forEach(entry => {
    if (entry.type == "childList") {
      console.log(
        "A child node has been added(%s) or removed(%s) [%d].",
        entry.addedNodes,
        entry.removedNodes,
        window.performance.now()
      );
      // console.log((entry.target as any).innerText);
      // console.log(entry.addedNodes[0]);
      // console.log(entry.target.textContent);
    } else if (entry.type == "attributes") {
      console.log("The " + entry.attributeName + " attribute was modified.");
    } else {
      console.log(entry.target, entry.type, window.performance.now());
    }
  });
});

const performanceWatcher = new PerformanceObserver(list => {
  console.log("[EVENT] On Perf entity changed");
  list.getEntries().forEach(entry => {
    console.log(
      "[%s]: %s %d..%d",
      entry.entryType,
      entry.name,
      entry.startTime,
      entry.startTime + entry.duration
    );
  });
});

mutationWatcher.observe(document.body, {
  characterData: true,
  attributes: true,
  childList: true,
  subtree: true
});

performanceWatcher.observe({
  entryTypes: ["frame", "navigation", "resource", "paint"]
});

window.addEventListener("close", () => {
  mutationWatcher.disconnect();
  performanceWatcher.disconnect();
});
