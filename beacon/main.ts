const beacon = new Image();
const SERVER = "http://localhost:5000/beacon?";

type Payload = {
  time: number;
  event_type: string;
};

const queryToString = ({ time, event_type }: Payload): string => {
  return `t=${time}&e=${event_type}`;
};

const mutationWatcher = new MutationObserver(list => {
  console.log("[EVENT] On DOM mutate", list.length);
  list.forEach(entry => {
    beacon.src =
      SERVER +
      queryToString({
        time: window.performance.now(),
        event_type: entry.type
      });
    if (entry.type == "childList") {
      console.log(
        "A child node has been added(%s) or removed(%s) [%d].",
        entry.addedNodes,
        entry.removedNodes,
        window.performance.now()
      );
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
    if (entry.name.includes(SERVER)) {
      return;
    }
    beacon.src =
      SERVER +
      queryToString({
        time: entry.startTime,
        event_type: entry.entryType
      });
    beacon.src =
      SERVER +
      queryToString({
        time: entry.startTime + entry.duration,
        event_type: entry.entryType
      });
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
