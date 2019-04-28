module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Page.Dashboard
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url
import View.SignIn


type Model
    = Redirect Nav.Key
    | Dashboard Nav.Key Page.Dashboard.Model
    | SignIn Nav.Key


keyOf : Model -> Nav.Key
keyOf model =
    case model of
        Redirect k ->
            k

        Dashboard k _ ->
            k

        SignIn k ->
            k


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    case url.path of
        "/sign_in" ->
            ( SignIn key, Cmd.none )

        "/dashboard" ->
            let
                ( m, c ) =
                    Page.Dashboard.init
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
    case ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl
                        (keyOf model)
                        (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            init () url (keyOf model)

        ( DashboardMsg subMsg, Dashboard k m ) ->
            let
                ( subModel, subCmd ) =
                    Page.Dashboard.update subMsg m
            in
            ( Dashboard k subModel
            , Cmd.map DashboardMsg subCmd
            )

        _ ->
            ( model
            , Cmd.none
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
