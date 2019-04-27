module Main exposing (main)

import Browser
import HistogramChart
import Html exposing (Html, div, text)
import Http
import Json.Decode as Decode exposing (Decoder, float, list, string)
import Json.Decode.Pipeline exposing (required)
import TypedSvg.Core exposing (text)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))


type Model
    = Failure
    | Loading
    | Success Events


type alias Event =
    { time : Float
    , eventType : String -- FIXME: Define as Custom type
    }


type alias Events =
    List Event


eventDecoder : Decoder Event
eventDecoder =
    Decode.succeed Event
        |> required "time" float
        |> required "eventType" string


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list eventDecoder


type Msg
    = GotText (Result Http.Error Events)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "http://localhost:5000/events"
        , expect = Http.expectJson GotText eventsDecoder
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


my_view : Model -> Html Msg
my_view model =
    case model of
        Failure ->
            text "Unable to load events"

        Loading ->
            text "Loading..."

        Success fullText ->
            HistogramChart.view <| List.map (\event -> event.time) fullText


root_view : Model -> Html Msg
root_view model =
    div []
        [ my_view model
        ]


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = root_view, subscriptions = subscriptions }
