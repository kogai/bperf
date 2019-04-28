module Main exposing (main)

import Browser
import Browser.Navigation
import HistogramChart
import Html exposing (Html, a, div, li, text, ul)
import Html.Attributes exposing (href)
import Http
import Json.Decode as Decode exposing (Decoder, float, list, string)
import Json.Decode.Pipeline exposing (required)
import TypedSvg.Core exposing (text)
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url
import View.Dashboard
import View.SignIn



-- type Model
--     = Failure
--     | Loading
--     | Success Events


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    }


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



-- type Msg
--     = GotText (Result Http.Error Events)


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



-- init : () -> ( Model, Cmd Msg )
-- init _ =
--     ( Loading
--     , Http.get
--         { url = "http://localhost:5000/events"
--         , expect = Http.expectJson GotText eventsDecoder
--         }
--     )
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg _ =
--     case msg of
--         GotText result ->
--             case result of
--                 Ok fullText ->
--                     ( Success fullText, Cmd.none )
--                 Err _ ->
--                     ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- my_view : Model -> Html Msg
-- my_view model =
--     case model of
--         Failure ->
--             text "Unable to load events"
--         Loading ->
--             text "Loading..."
--         Success fullText ->
--             HistogramChart.view <| List.map (\event -> event.time) fullText
-- root_view : Model -> Html Msg
-- root_view model =
--     div []
--         [ my_view model
--         ]


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


view : Model -> Browser.Document msg
view model =
    { title = "bperf-app"
    , body =
        case model.url.path of
            "/" ->
                [ div [] [ text "Root" ]
                , ul []
                    [ viewLink "/root"
                    , viewLink "/sign_in"
                    , viewLink "/dashboard"
                    ]
                ]

            "/dashboard" ->
                [ View.Dashboard.frame () ]

            "/sign_in" ->
                [ View.SignIn.frame () ]

            _ ->
                [ div [] [ text "404 Not found" ]
                ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
