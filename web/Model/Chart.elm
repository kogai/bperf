module Model.Chart exposing (Model(..), Msg(..), init, update)

import Api.Durations
import Api.Events
import Api.Networks
import Api.Util
import Http


type Model
    = Loading ( Maybe Api.Events.Response, Maybe Api.Durations.Response, Maybe Api.Networks.Response )
    | Failure String
    | Success
        { events : Api.Events.Response
        , durations : Api.Durations.Response
        , networks : Api.Networks.Response
        }


type Msg
    = EventsMsg (Result Http.Error Api.Events.Response)
    | DurationsMsg (Result Http.Error Api.Durations.Response)
    | NetworkMsg (Result Http.Error Api.Networks.Response)


init : Model
init =
    Loading ( Nothing, Nothing, Nothing )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( EventsMsg (Ok xs), Loading ( Nothing, Just durations, Just networks ) ) ->
            ( Success { events = xs, durations = durations, networks = networks }, Cmd.none )

        ( EventsMsg (Ok xs), Loading ( Nothing, durations, networks ) ) ->
            ( Loading ( Just xs, durations, networks ), Cmd.none )

        ( DurationsMsg (Ok xs), Loading ( Just events, Nothing, Just networks ) ) ->
            ( Success { events = events, durations = xs, networks = networks }, Cmd.none )

        ( DurationsMsg (Ok xs), Loading ( events, Nothing, networks ) ) ->
            ( Loading ( events, Just xs, networks ), Cmd.none )

        ( NetworkMsg (Ok xs), Loading ( Just events, Just durations, Nothing ) ) ->
            ( Success { events = events, durations = durations, networks = xs }, Cmd.none )

        ( NetworkMsg (Ok xs), Loading ( events, durations, Nothing ) ) ->
            ( Loading ( events, durations, Just xs ), Cmd.none )

        ( EventsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        ( DurationsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        _ ->
            ( model, Cmd.none )
