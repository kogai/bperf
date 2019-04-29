const { Elm } = require("./Main");
const { AUTH0_DOMAIN, AUTH0_CLIENT_ID } = process.env;

const onAuthComplete = () => {
  console.log(arguments);
};

const app = Elm.Main.init({
  flags: onAuthComplete,
  node: document.getElementById("root")
});

console.log(onAuthComplete);
console.log(app.ports);

const webAuth = new auth0.WebAuth({
  domain: AUTH0_DOMAIN,
  clientID: AUTH0_CLIENT_ID,
  responseType: "token id_token",
  scope: "openid",
  redirectUri: `${window.location.protocol}//${
    window.location.host
  }/auth/callback`
});

app.ports.onSignIn.subscribe(() => {
  webAuth.authorize();
});

app.ports.onVisitAuthCallback.subscribe(() => {
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
    console.log(authResult);
    return app.ports.onAuthComplete.send(authResult);
  });
});
