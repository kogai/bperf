module Page.SignIn exposing (view)

import Html exposing (Html)
import Model as M
import Model.Auth
import View.SignIn as V


view : M.Model -> Html M.Msg
view _ =
    V.view <| M.Auth Model.Auth.StartAuth
