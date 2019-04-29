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
