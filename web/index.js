// require('./index.html');
const { Elm } = require("./Main");
const { AUTH0_DOMAIN, AUTH0_CLIENT_ID } = process.env;

const app = Elm.Main.init({
  flags: null,
  node: document.getElementById("root")
});

app.ports.onSignIn.subscribe(() => {
  const webAuth = new auth0.WebAuth({
    domain: AUTH0_DOMAIN,
    clientID: AUTH0_CLIENT_ID,
    responseType: "token id_token",
    scope: "openid",
    redirectUri: window.location.href
  });
  webAuth.authorize();
});

