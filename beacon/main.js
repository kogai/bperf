const uuid = require("uuid");

const { API_ROOT } = process.env;
const beacon = new Image();
const onMeasure = Date.now();
const SERVER = `${API_ROOT}/beacon?`;
const sessionId = uuid.v4();

const msToNs = ms => Math.floor(ms * 1000 * 1000);

beacon.src = SERVER + `e=init&id=${sessionId}&timeOrigin=${msToNs(onMeasure)}`;

const queryToString = ({ time, eventType }) => {
  return `t=${msToNs(time)}&e=${eventType}&id=${sessionId}`;
};

const performanceQueryToString = ({ startTime, endTime, eventType, name }) => {
  return `start=${msToNs(startTime)}&end=${msToNs(
    endTime
  )}&e=${eventType}&name=${name}&id=${sessionId}`;
};

const mutationWatcher = new MutationObserver(list => {
  list.forEach(entry => {
    const b = new Image();
    b.src =
      SERVER +
      queryToString({
        time: onMeasure + window.performance.now(),
        eventType: entry.type // One of 'childList' 'attibutes' 'characterData'
      });
  });
});

const performanceWatcher = new PerformanceObserver(list => {
  list.getEntries().forEach(entry => {
    if (entry.name.includes(SERVER)) {
      return;
    }
    const b = new Image();
    b.src =
      SERVER +
      performanceQueryToString({
        eventType: entry.entryType,
        startTime: onMeasure + entry.startTime,
        endTime: onMeasure + entry.startTime + entry.duration,
        name: entry.name,
        bodySize: entry.decodedBodySize
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
