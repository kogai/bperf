port module Page.Auth exposing (Msg(..), init, onAuthComplete, update, view)

import Html exposing (Html, text)
import Json.Decode as D exposing (Decoder, int, oneOf, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


port onVisitAuthCallback : () -> Cmd msg


port onAuthComplete : (E.Value -> msg) -> Sub msg


type alias AuthError =
    { error : String
    , errorDescription : String
    }


type alias AuthSuccess =
    { accessToken : String
    , expiresIn : Int
    , idToken : String
    }


type alias AuthPayload =
    Result AuthError AuthSuccess


decodeError : Decoder AuthError
decodeError =
    D.succeed AuthError
        |> required "error" string
        |> required "errorDescription" string


decodeSuccess : Decoder AuthSuccess
decodeSuccess =
    D.succeed AuthSuccess
        |> required "accessToken" string
        |> required "expiresIn" int
        |> required "idToken" string


decode : D.Value -> AuthPayload
decode v =
    let
        decoded =
            D.decodeValue
                (oneOf
                    [ decodeError |> D.map Err
                    , decodeSuccess |> D.map Ok
                    ]
                )
                v
    in
    case decoded of
        Err _ ->
            Err (AuthError "decode error" "something happened.")

        Ok result ->
            result


type alias Model =
    ()


type Msg
    = AuthComplete E.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        AuthComplete v ->
            let
                _ =
                    decode v
            in
            ( (), Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( ()
    , onVisitAuthCallback ()
    )


view : Model -> Html Msg
view _ =
    text "Auth completed."
