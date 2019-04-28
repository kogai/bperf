module Page.SignIn exposing (Msg, update, view)

import Html exposing (Html)
import Port.WebAuth
import View.SignIn as V


type alias Model =
    ()


type Msg
    = OnSignIn


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        OnSignIn ->
            ( (), Port.WebAuth.onSignIn () )


view : () -> Html Msg
view _ =
    V.view OnSignIn



-- ////
-- // app.js
-- window.addEventListener('load', function() {
--   // ...
--   var loginStatus = document.querySelector('.container h4');
--   var loginView = document.getElementById('login-view');
--   var homeView = document.getElementById('home-view');
--   // buttons and event listeners
--   var homeViewBtn = document.getElementById('btn-home-view');
--   var loginBtn = document.getElementById('btn-login');
--   var logoutBtn = document.getElementById('btn-logout');
--   homeViewBtn.addEventListener('click', function() {
--     homeView.style.display = 'inline-block';
--     loginView.style.display = 'none';
--   });
--   logoutBtn.addEventListener('click', logout);
--   function handleAuthentication() {
--     webAuth.parseHash(function(err, authResult) {
--       if (authResult && authResult.accessToken && authResult.idToken) {
--         window.location.hash = '';
--         localLogin(authResult);
--         loginBtn.style.display = 'none';
--         homeView.style.display = 'inline-block';
--       } else if (err) {
--         homeView.style.display = 'inline-block';
--         console.log(err);
--         alert(
--           'Error: ' + err.error + '. Check the console for further details.'
--         );
--       }
--       displayButtons();
--     });
--   }
--   function localLogin(authResult) {
--     // Set isLoggedIn flag in localStorage
--     localStorage.setItem('isLoggedIn', 'true');
--     // Set the time that the Access Token will expire at
--     expiresAt = JSON.stringify(
--       authResult.expiresIn * 1000 + new Date().getTime()
--     );
--     accessToken = authResult.accessToken;
--     idToken = authResult.idToken;
--   }
--   function renewTokens() {
--     webAuth.checkSession({}, (err, authResult) => {
--       if (authResult && authResult.accessToken && authResult.idToken) {
--         localLogin(authResult);
--       } else if (err) {
--         alert(
--             'Could not get a new token '  + err.error + ':' + err.error_description + '.'
--         );
--         logout();
--       }
--       displayButtons();
--     });
--   }
--   function logout() {
--     // Remove isLoggedIn flag from localStorage
--     localStorage.removeItem('isLoggedIn');
--     // Remove tokens and expiry time
--     accessToken = '';
--     idToken = '';
--     expiresAt = 0;
--     displayButtons();
--   }
--   function isAuthenticated() {
--     // Check whether the current time is past the
--     // Access Token's expiry time
--     var expiration = parseInt(expiresAt) || 0;
--     return localStorage.getItem('isLoggedIn') === 'true' && new Date().getTime() < expiration;
--   }
--   function displayButtons() {
--     if (isAuthenticated()) {
--       loginBtn.style.display = 'none';
--       logoutBtn.style.display = 'inline-block';
--       loginStatus.innerHTML = 'You are logged in!';
--     } else {
--       loginBtn.style.display = 'inline-block';
--       logoutBtn.style.display = 'none';
--       loginStatus.innerHTML =
--         'You are not logged in! Please log in to continue.';
--     }
--   }
-- });
