module Page.AuthComplete exposing (Msg(..), init, view)

import Html exposing (Html, text)
import Json.Encode as E
import Port.WebAuth


type alias Model =
    ()


type Msg
    = AuthComplete Port.WebAuth.Msg



-- AuthComplete E.Value
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg _ =
--     case msg of
--         OnSignIn ->
--             ( (), Port.WebAuth.onSignIn () )


init : ( Model, Cmd Msg )
init =
    ( ()
    , Port.WebAuth.onVisitAuthCallback ()
    )


view : () -> Html Msg
view _ =
    text "Auth completed."
