const beacon = new Image();
const timeOrigin = performance.timeOrigin;
const SERVER = "http://localhost:5000/beacon?";

const queryToString = ({ time, eventType }) => {
  return `t=${Math.floor(time)}&e=${eventType}`;
};

const performanceQueryToString = ({ startTime, endTime, eventType, name }) => {
  return `start=${Math.floor(startTime)}&end=${Math.floor(
    endTime
  )}&e=${eventType}&name=${name}`;
};

const mutationWatcher = new MutationObserver(list => {
  // console.log("[EVENT] On DOM mutate", list.length);
  list.forEach(entry => {
    beacon.src =
      SERVER +
      queryToString({
        time: timeOrigin + window.performance.now(),
        eventType: entry.type // One of 'childList' 'attibutes' 'characterData'
      });
  });
});

const performanceWatcher = new PerformanceObserver(list => {
  // console.log("[EVENT] On Perf entity changed");
  list.getEntries().forEach(entry => {
    if (entry.name.includes(SERVER)) {
      return;
    }
    beacon.src =
      SERVER +
      performanceQueryToString({
        eventType: entry.entryType,
        startTime: timeOrigin + entry.startTime,
        endTime: timeOrigin + entry.startTime + entry.duration,
        name: entry.name
      });
    // console.log(
    //   "[%s]: %s %d..%d",
    //   entry.entryType,
    //   entry.name,
    //   entry.startTime,
    //   entry.startTime + entry.duration
    // );
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
