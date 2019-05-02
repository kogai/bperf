module Model.Chart exposing (Model(..), Msg(..), init, update)

import Api.Durations
import Api.Events
import Api.Networks
import Api.Sessions
import Api.Util
import Http


type Model
    = Failure String
    | Dataset
        { events : Api.Events.Response
        , durations : Api.Durations.Response
        , networks : Api.Networks.Response
        , sessions : Api.Sessions.Response
        }


type Msg
    = EventsMsg (Result Http.Error Api.Events.Response)
    | DurationsMsg (Result Http.Error Api.Durations.Response)
    | NetworkMsg (Result Http.Error Api.Networks.Response)
    | SessionsMsg (Result Http.Error Api.Sessions.Response)


init : Model
init =
    Dataset
        { events = []
        , durations = []
        , networks = []
        , sessions = []
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( EventsMsg (Ok xs), Dataset x ) ->
            ( Dataset { x | events = List.append x.events xs }, Cmd.none )

        ( DurationsMsg (Ok xs), Dataset x ) ->
            ( Dataset { x | durations = List.append x.durations xs }, Cmd.none )

        ( SessionsMsg (Ok xs), Dataset x ) ->
            ( Dataset { x | sessions = List.append x.sessions xs }, Cmd.none )

        ( NetworkMsg (Ok xs), Dataset x ) ->
            ( Dataset { x | networks = List.append x.networks xs }, Cmd.none )

        ( EventsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        ( DurationsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        ( SessionsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        ( NetworkMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        _ ->
            ( model, Cmd.none )
