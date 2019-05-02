module Page.Progress exposing (Model, Msg(..), init, onLoadAbort, onLoadComplete, onLoadStart, update, view)

import Html exposing (Html, div)
import Task
import Time
import View.Organism.Progress as V


type alias Model =
    Int


type Msg
    = OnLoad
    | OnComplete
    | OnAbort


init : Model
init =
    0


onLoadStart : () -> Cmd Msg
onLoadStart _ =
    Task.perform (\_ -> OnLoad) Time.now


onLoadComplete : () -> Cmd Msg
onLoadComplete _ =
    Task.perform (\_ -> OnComplete) Time.now


onLoadAbort : () -> Cmd Msg
onLoadAbort _ =
    Task.perform (\_ -> OnAbort) Time.now


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnLoad ->
            model + 1

        OnComplete ->
            model - 1

        OnAbort ->
            0


view : Model -> Html Msg
view model =
    if model > 0 then
        V.view

    else
        div [] []
