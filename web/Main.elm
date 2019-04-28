module Main exposing (main)

import Browser
import Browser.Navigation
import Debug
import Html exposing (div, text)
import Page.Dashboard
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url
import View.SignIn


type Model
    = Redirect Browser.Navigation.Key
    | Dashboard Browser.Navigation.Key Page.Dashboard.Model
    | SignIn Browser.Navigation.Key


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    case url.path of
        "/sign_in" ->
            ( SignIn key, Cmd.none )

        "/dashboard" ->
            let
                ( m, c ) =
                    Page.Dashboard.init ()
            in
            ( Dashboard key m, Cmd.map DashboardMsg c )

        _ ->
            ( Redirect key, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | DashboardMsg Page.Dashboard.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl
                        (case model of
                            Redirect key ->
                                key

                            Dashboard key _ ->
                                key

                            SignIn key ->
                                key
                        )
                        (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        UrlChanged { path } ->
            let
                key =
                    case model of
                        Redirect k ->
                            k

                        Dashboard k _ ->
                            k

                        SignIn k ->
                            k
            in
            case path of
                "/sign_in" ->
                    ( SignIn key, Cmd.none )

                "/dashboard" ->
                    let
                        ( m, c ) =
                            Page.Dashboard.init ()
                    in
                    ( Dashboard key m, Cmd.map DashboardMsg c )

                _ ->
                    ( Redirect key
                    , Cmd.none
                    )

        DashboardMsg subMsg ->
            let
                ( key, subModel ) =
                    case model of
                        Dashboard k m ->
                            ( k, m )

                        _ ->
                            Debug.todo "Tmp"

                ( next, subCmd ) =
                    Page.Dashboard.update subMsg subModel

                _ =
                    Debug.log "on dashboard:next" next
            in
            ( Dashboard key next
            , Cmd.map DashboardMsg subCmd
            )


view : Model -> Browser.Document Msg
view model =
    { title = "bperf-app"
    , body =
        case model of
            Dashboard _ m ->
                [ Html.map DashboardMsg <| Page.Dashboard.view m
                ]

            SignIn _ ->
                [ View.SignIn.view ]

            Redirect _ ->
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
