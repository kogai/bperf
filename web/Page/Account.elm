module Page.Account exposing (Model(..), Msg(..), init, update, view)

import Api.AccountDetail as Api
import Api.Util exposing (fromHttpError)
import Html exposing (Html, text)
import Http
import Model.Auth
import Task
import Time
import View.Account as V


type Msg
    = OnLoad
    | OnAbort Http.Error
    | OnComplete Api.Response


type Model
    = Fetching
    | Aborted Http.Error
    | Fetched Api.Response
    | NotAuthenticated


onReceive : Result Http.Error Api.Response -> Msg
onReceive x =
    case x of
        Ok s ->
            OnComplete s

        Err e ->
            OnAbort e


init : String -> Maybe Model.Auth.AuthSuccess -> ( Model, Cmd Msg )
init apiRoot auth =
    case auth of
        Just { idToken, accessToken } ->
            ( Fetching
            , Cmd.batch
                [ Task.perform (\_ -> OnLoad) Time.now
                , Api.fetch apiRoot ( idToken, accessToken ) onReceive
                ]
            )

        Nothing ->
            ( NotAuthenticated, Cmd.none )


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnLoad ->
            model

        OnAbort e ->
            Aborted e

        OnComplete x ->
            Fetched x


view : Model -> Html Msg
view model =
    case model of
        Fetching ->
            text "loading..."

        NotAuthenticated ->
            text "Need redirecting..."

        Aborted e ->
            text <| fromHttpError e

        Fetched x ->
            V.view x
