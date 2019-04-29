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
        Err reason ->
            Err (AuthError "decode error" (D.errorToString reason))

        Ok result ->
            result


type alias Model =
    ()


type Msg
    = AuthComplete E.Value
    | Success AuthSuccess
    | Failure AuthError


init : ( Model, Cmd Msg )
init =
    ( ()
    , onVisitAuthCallback ()
    )


update : Msg -> Model -> Model
update msg _ =
    case msg of
        AuthComplete v ->
            case decode v of
                Ok x ->
                    -- ( (), Success x )
                    ()

                Err x ->
                    -- ( (), Cmd.none )
                    ()

        _ ->
            -- ( (), )
            ()


view : Model -> Html Msg
view _ =
    text "Auth completed."
