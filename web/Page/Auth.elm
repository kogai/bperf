port module Page.Auth exposing (Model(..), Msg(..), init, onAuthComplete, update, view)

import Html exposing (Html, div, text)
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
        decoder =
            D.decodeValue
                (oneOf
                    [ decodeError |> D.map Err
                    , decodeSuccess |> D.map Ok
                    ]
                )
    in
    case decoder v of
        Err reason ->
            Err (AuthError "decode error" (D.errorToString reason))

        Ok result ->
            result


type Model
    = Attempt
    | Success AuthSuccess
    | Failure AuthError


type Msg
    = OnAuth E.Value
    | OnSuccess AuthSuccess
    | OnFailure AuthError


init : ( Model, Cmd Msg )
init =
    ( Attempt
    , onVisitAuthCallback ()
    )


update : Msg -> Model -> Model
update msg _ =
    case msg of
        OnAuth v ->
            case decode v of
                Ok x ->
                    Success x

                Err x ->
                    Failure x

        _ ->
            Attempt


view : Model -> Html Msg
view model =
    case model of
        Attempt ->
            text "Authorization process has been started."

        Success { accessToken, expiresIn, idToken } ->
            div []
                [ div []
                    [ text "Authorization process has been successed."
                    ]
                , div []
                    [ text <| "accessToken:" ++ accessToken ++ " idToken:" ++ idToken ++ " expiresIn:" ++ String.fromInt expiresIn
                    ]
                ]

        Failure { errorDescription } ->
            text errorDescription
