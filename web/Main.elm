module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (Html, a, div, li, text, ul)
import Html.Attributes exposing (href)
import Page.Dashboard
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url
import View.SignIn


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    }


type alias Event =
    { time : Float
    , eventType : String -- FIXME: Define as Custom type
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


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
                [ Page.Dashboard.view () ]

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
