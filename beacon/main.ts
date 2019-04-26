const beacon = new Image();
const timeOrigin = performance.timeOrigin;
const SERVER = "http://localhost:5000/beacon?";

type Payload = {
  time: number;
  eventType: string;
};

const queryToString = ({ time, eventType }: Payload): string => {
  return `t=${Math.floor(time)}&e=${eventType}`;
};

const mutationWatcher = new MutationObserver(list => {
  console.log("[EVENT] On DOM mutate", list.length);
  list.forEach(entry => {
    beacon.src =
      SERVER +
      queryToString({
        time: timeOrigin + window.performance.now(),
        eventType: entry.type
      });
    if (entry.type == "childList") {
      // console.log(
      //   "A child node has been added(%s) or removed(%s) [%d].",
      //   entry.addedNodes,
      //   entry.removedNodes,
      //   window.performance.now()
      // );
    } else if (entry.type == "attributes") {
      // console.log(
      //   "The " + entry.attributeName + " attribute was modified.",
      //   entry.target
      // );
    } else {
      // characterData
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
        time: timeOrigin + entry.startTime,
        eventType: entry.entryType
      });
    beacon.src =
      SERVER +
      queryToString({
        time: timeOrigin + entry.startTime + entry.duration,
        eventType: entry.entryType
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

window.addEventListener("beforeunload", () => {
  mutationWatcher.disconnect();
  performanceWatcher.disconnect();
  beacon.src = "http://localhost:5000/close";
});
