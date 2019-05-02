port module Model.Auth exposing (AuthSuccess, Model(..), Msg(..), doVisitAuthCallback, init, onAuthComplete, update)

import Api.User
import Json.Decode as D exposing (Decoder, int, oneOf, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Page.Progress as P
import Task
import Time


type alias AuthError =
    { error : String
    , errorDescription : String
    }


type alias AuthSuccess =
    { accessToken : String
    , expiresIn : Int
    , idToken : String
    }


type Model
    = UnAuthorized
    | Success AuthSuccess
    | Failure AuthError


type Msg
    = StartAuth
    | OnCallback E.Value
    | OnCreateUser
    | OnCreateUserComplete


type alias AuthPayload =
    Result AuthError AuthSuccess


port doStartAuth : () -> Cmd msg


port doVisitAuthCallback : () -> Cmd msg


port setSessions : AuthSuccess -> Cmd msg


port removeSessions : () -> Cmd msg


port onAuthComplete : (E.Value -> msg) -> Sub msg


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


init : Maybe AuthSuccess -> Model
init auth =
    case auth of
        Just x ->
            Success x

        Nothing ->
            UnAuthorized


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update apiRoot msg model =
    case msg of
        OnCallback v ->
            case decode v of
                Ok x ->
                    ( Success x
                    , Cmd.batch
                        [ setSessions x
                        , Api.User.createUser apiRoot x.accessToken (\_ -> OnCreateUserComplete)
                        , Task.perform (\n -> OnCreateUser) Time.now
                        ]
                    )

                Err x ->
                    ( Failure x, removeSessions () )

        StartAuth ->
            ( UnAuthorized, doStartAuth () )

        OnCreateUser ->
            ( model, Cmd.none )

        OnCreateUserComplete ->
            ( model, Cmd.none )
