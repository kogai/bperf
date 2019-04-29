module Page.Dashboard exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Http
import Json.Decode as Decode exposing (Decoder, float, list, string)
import Json.Decode.Pipeline exposing (required)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import View.Dashboard as V


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


init : ( Model, Cmd Msg )
init =
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


view : Model -> Html Msg
view model =
    V.view <|
        case model of
            Failure ->
                V.Failure

            Loading ->
                V.Loading

            Success events ->
                V.Success <|
                    List.map (\event -> event.time) events
