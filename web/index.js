const { Elm } = require("./Main");
const { AUTH0_DOMAIN, AUTH0_CLIENT_ID, API_ROOT } = process.env;

const STORAGE_KEY = "sessions";

const app = Elm.Main.init({
  flags: {
    apiRoot: API_ROOT,
    sessions: JSON.parse(localStorage.getItem(STORAGE_KEY))
  },
  node: document.getElementById("root")
});

const webAuth = new auth0.WebAuth({
  domain: AUTH0_DOMAIN,
  clientID: AUTH0_CLIENT_ID,
  responseType: "token id_token",
  scope: "openid email",
  redirectUri: `${window.location.protocol}//${window.location.host}/callback`
});

app.ports.doStartAuth.subscribe(() => {
  webAuth.authorize();
});

app.ports.doVisitAuthCallback.subscribe(() => {
  webAuth.parseHash((err, authResult) => {
    if (err === null && authResult === null) {
      return app.ports.onAuthComplete.send({
        error: "unhandled error",
        errorDescription: window.location.pathname
      });
    }

    if (err) {
      return app.ports.onAuthComplete.send(err);
    }
    return app.ports.onAuthComplete.send(authResult);
  });
});

app.ports.setSessions.subscribe(sessions => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(sessions));
});

app.ports.removeSessions.subscribe(() => {
  localStorage.removeItem(STORAGE_KEY);
});
