module Page.Dashboard exposing (Model(..), Msg(..), init, update, view)

import Api.Durations
import Api.Events
import Api.Networks
import Api.Sessions
import Api.Util exposing (fromHttpError)
import Html exposing (Html, text)
import Http
import Model.Auth
import Task
import Time
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import View.Dashboard as V


type Response
    = Events Api.Events.Response
    | Durations Api.Durations.Response
    | Networks Api.Networks.Response
    | Sessions Api.Sessions.Response


type Msg
    = OnLoad
    | OnAbort Http.Error
    | OnComplete Response


type Model
    = Fetching
    | Aborted Http.Error
    | Fetched
        { events : Api.Events.Response
        , durations : Api.Durations.Response
        , networks : Api.Networks.Response
        , sessions : Api.Sessions.Response
        }
    | NotAuthenticated


onReceive : (res -> Response) -> Result Http.Error res -> Msg
onReceive f x =
    case Result.map f x of
        Ok s ->
            OnComplete s

        Err e ->
            OnAbort e


init : String -> Maybe Model.Auth.AuthSuccess -> ( Model, Cmd Msg )
init apiRoot auth =
    case auth of
        Just { idToken } ->
            ( Fetching
            , Cmd.batch
                [ Task.perform (\_ -> OnLoad) Time.now
                , Api.Events.fetch apiRoot idToken (onReceive Events)
                , Api.Durations.fetch apiRoot idToken (onReceive Durations)
                , Api.Networks.fetch apiRoot idToken (onReceive Networks)
                , Api.Sessions.fetch apiRoot idToken (onReceive Sessions)
                ]
            )

        Nothing ->
            ( NotAuthenticated, Cmd.none )


update : Msg -> Model -> Model
update msg model =
    let
        dataset =
            case model of
                Fetched d ->
                    d

                _ ->
                    { events = []
                    , durations = []
                    , networks = []
                    , sessions = []
                    }
    in
    case msg of
        OnLoad ->
            model

        OnAbort e ->
            Aborted e

        OnComplete x ->
            case x of
                Events xs ->
                    Fetched { dataset | events = List.append dataset.events xs }

                Networks xs ->
                    Fetched { dataset | networks = List.append dataset.networks xs }

                Durations xs ->
                    Fetched { dataset | durations = List.append dataset.durations xs }

                Sessions xs ->
                    Fetched { dataset | sessions = List.append dataset.sessions xs }


view : Model -> Html Msg
view model =
    case model of
        Fetching ->
            text "loading..."

        NotAuthenticated ->
            text "Need redirecting..."

        Aborted e ->
            text <| fromHttpError e

        Fetched { events, durations, networks, sessions } ->
            V.view <|
                { events =
                    events
                        |> List.map (\x -> x.time)
                , durations =
                    durations
                , networks =
                    networks
                , sessions =
                    sessions
                }
