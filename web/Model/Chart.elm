module Model.Chart exposing (Model(..), Msg(..), init, update)

import Api.Events as Api
import Http


type Model
    = Loading
    | Failure String
    | Success Api.Events


type Msg
    = Response (Result Http.Error Api.Events)


init : Model
init =
    Loading


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Response (Ok xs) ->
            ( Success xs, Cmd.none )

        Response (Err e) ->
            ( Failure <| Api.fromHttpError e, Cmd.none )
