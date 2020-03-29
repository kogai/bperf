const uuid = require("uuid");

const { API_ROOT } = process.env;
const onMeasure = Date.now();
const SERVER = `${API_ROOT}/log`;
const sessionId = uuid.v4();

const msToNs = ms => Math.floor(ms * 1000 * 1000);

const queryToString = ({ startTime, endTime, eventType, name }) => {
  return [
    `start=${startTime}`,
    `end=${endTime}`,
    `type=${eventType}`,
    `name=${name}`,
    `id=${sessionId}`
  ].join("&");
};

const send = x => {
  const beacon = new Image();
  beacon.src = SERVER + "?" + queryToString(x);
};

const performanceWatcher = new PerformanceObserver(list => {
  list.getEntries().forEach(entry => {
    if (entry.name.includes(SERVER)) {
      return;
    }
    send({
      eventType: entry.entryType,
      startTime: onMeasure + entry.startTime,
      endTime: onMeasure + entry.startTime + entry.duration,
      name: entry.name
    });
  });
});

window.addEventListener("load", () => {
  performanceWatcher.observe({
    entryTypes: ["frame", "navigation", "resource", "paint"]
  });
});

window.addEventListener("beforeunload", () => {
  mutationWatcher.disconnect();
  performanceWatcher.disconnect();
  send({
    eventType: "session",
    startTime: onMeasure,
    endTime: onMeasure + ewindow.performance.now(),
    name: "none"
  });
});
