port module Page.SignIn exposing (Msg, update, view)

import Html exposing (Html)
import View.SignIn as V


type alias Model =
    ()


type Msg
    = OnSignIn


port onSignIn : () -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        OnSignIn ->
            ( (), onSignIn () )


view : () -> Html Msg
view _ =
    V.view OnSignIn
