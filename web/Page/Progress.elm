module Page.Progress exposing (Model, Msg(..), init, onLoadComplete, onLoadStart, update, view)

import Html exposing (Html, div)
import Task
import Time
import View.Organism.Progress as V


type alias Model =
    Int


type Msg
    = OnLoad
    | OnComplete Int


init : Model
init =
    0


onLoadStart : () -> Cmd Msg
onLoadStart _ =
    Task.perform (\_ -> OnLoad) Time.now


onLoadComplete : Int -> Cmd Msg
onLoadComplete n =
    Task.perform (\_ -> OnComplete n) Time.now


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnLoad ->
            model + 1

        OnComplete n ->
            model - n


view : Model -> Html Msg
view model =
    if model > 0 then
        V.view

    else
        div [] []
