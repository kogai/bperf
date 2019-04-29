module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Debug
import Html exposing (div, text)
import Json.Encode as E
import Page.AuthComplete
import Page.Dashboard
import Page.SignIn
import Port.WebAuth
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url


type Model
    = Redirect Nav.Key
    | Dashboard Nav.Key Page.Dashboard.Model
    | SignIn Nav.Key
    | AuthComplete Nav.Key


keyOf : Model -> Nav.Key
keyOf model =
    case model of
        Redirect k ->
            k

        AuthComplete k ->
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

        "/auth/callback" ->
            let
                ( _, c ) =
                    Page.AuthComplete.init
            in
            ( AuthComplete key, Cmd.map AuthCompleteMsg c )

        _ ->
            ( Redirect key, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        AuthComplete _ ->
            Sub.batch [ Port.WebAuth.onAuthComplete FromJs ]

        _ ->
            Sub.none


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | DashboardMsg Page.Dashboard.Msg
    | SignInMsg Page.SignIn.Msg
    | AuthCompleteMsg Page.AuthComplete.Msg
    | FromJs E.Value


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

        ( FromJs subMsg, AuthComplete k ) ->
            let
                -- ( _, subCmd ) =
                --     Page.AuthComplete.update subMsg ()
                _ =
                    Debug.log "msg" subMsg
            in
            -- ( SignIn k
            -- , Cmd.map SignInMsg subCmd
            -- )
            ( model
            , Cmd.none
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

            AuthComplete _ ->
                [ Html.map AuthCompleteMsg <| Page.AuthComplete.view ()
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
