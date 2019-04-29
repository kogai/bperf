module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Page.Auth
import Page.Dashboard
import Page.SignIn
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url


type Model
    = Redirect Nav.Key
    | Dashboard Nav.Key Page.Dashboard.Model
    | SignIn Nav.Key
    | Auth Nav.Key


keyOf : Model -> Nav.Key
keyOf model =
    case model of
        Redirect k ->
            k

        Auth k ->
            k

        SignIn k ->
            k

        Dashboard k _ ->
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

        "/callback" ->
            let
                ( _, c ) =
                    Page.Auth.init
            in
            ( Auth key, Cmd.map AuthMsg c )

        _ ->
            ( Redirect key, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Auth _ ->
            Sub.batch [ Page.Auth.onAuthComplete (\v -> AuthMsg <| Page.Auth.AuthComplete v) ]

        _ ->
            Sub.none


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | DashboardMsg Page.Dashboard.Msg
    | SignInMsg Page.SignIn.Msg
    | AuthMsg Page.Auth.Msg


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

        ( SignInMsg subMsg, SignIn k ) ->
            let
                ( _, subCmd ) =
                    Page.SignIn.update subMsg ()
            in
            ( SignIn k
            , Cmd.map SignInMsg subCmd
            )

        ( AuthMsg subMsg, Auth k ) ->
            let
                ( _, subCmd ) =
                    Page.Auth.update subMsg ()
            in
            ( Auth k
            , Cmd.map AuthMsg subCmd
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
                [ Html.map SignInMsg <| Page.SignIn.view ()
                ]

            Auth _ ->
                [ Html.map AuthMsg <| Page.Auth.view ()
                ]

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
