module Model.Chart exposing (Model(..), Msg(..), Response, init, update)

import Api.Durations
import Api.Events
import Api.Util
import Http


type alias Response =
    ( Maybe Api.Events.Response, Maybe Api.Durations.Response )


type Model
    = Loading ( Maybe Api.Events.Response, Maybe Api.Durations.Response )
    | Failure String
    | Success
        { events : Api.Events.Response
        , durations : Api.Durations.Response
        }


type Msg
    = EventsMsg (Result Http.Error Api.Events.Response)
    | DurationsMsg (Result Http.Error Api.Durations.Response)


init : Model
init =
    Loading ( Nothing, Nothing )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( EventsMsg (Ok xs), Loading ( Nothing, Nothing ) ) ->
            ( Loading ( Just xs, Nothing ), Cmd.none )

        ( EventsMsg (Ok xs), Loading ( Nothing, Just durations ) ) ->
            ( Success { events = xs, durations = durations }, Cmd.none )

        ( DurationsMsg (Ok xs), Loading ( Nothing, Nothing ) ) ->
            ( Loading ( Nothing, Just xs ), Cmd.none )

        ( DurationsMsg (Ok xs), Loading ( Just events, Nothing ) ) ->
            ( Success { events = events, durations = xs }, Cmd.none )

        ( EventsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        ( DurationsMsg (Err e), _ ) ->
            ( Failure <| Api.Util.fromHttpError e, Cmd.none )

        _ ->
            ( model, Cmd.none )
