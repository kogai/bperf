const uuid = require("uuid");

const { API_ROOT } = process.env;
const beacon = new Image();
const timeOrigin = performance.timeOrigin;
const SERVER = `${API_ROOT}/beacon?`;
const sessionId = uuid.v4();

beacon.src = SERVER + `e=init&id=${sessionId}`;

const queryToString = ({ time, eventType }) => {
  return `t=${Math.floor(time)}&e=${eventType}&id=${sessionId}`;
};

const performanceQueryToString = ({ startTime, endTime, eventType, name }) => {
  return `start=${Math.floor(startTime)}&end=${Math.floor(
    endTime
  )}&e=${eventType}&name=${name}&id=${sessionId}`;
};

const mutationWatcher = new MutationObserver(list => {
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
  beacon.src = `${API_ROOT}/close`;
});
