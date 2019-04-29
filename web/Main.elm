module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Model as M
import Model.Auth as A
import Model.Route as R exposing (Msg(..))
import Page.Callback
import Page.Dashboard
import Page.SignIn
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import Url


init : () -> Url.Url -> Nav.Key -> ( M.Model, Cmd M.Msg )
init _ url key =
    M.init url key


update : M.Msg -> M.Model -> ( M.Model, Cmd M.Msg )
update msg model =
    M.update msg model


subscriptions : M.Model -> Sub M.Msg
subscriptions model =
    case model.route of
        R.Callback _ ->
            Sub.batch [ A.onAuthComplete <| M.mapAuth A.OnCallback ]

        _ ->
            Sub.none


view : M.Model -> Browser.Document M.Msg
view model =
    case model.route of
        R.Dashboard _ ->
            { title = "dashbaord | bperf"
            , body =
                [ Page.Dashboard.view model
                ]
            }

        R.SignIn _ ->
            { title = "sign in | bperf"
            , body =
                [ Page.SignIn.view model
                ]
            }

        R.Callback _ ->
            { title = "callback | bperf"
            , body =
                [ Page.Callback.view model
                ]
            }

        R.NotFound _ ->
            { title = "not found | bperf"
            , body =
                [ div [] [ text "404 Not found" ]
                ]
            }


main : Program () M.Model M.Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = M.mapRoute UrlChanged
        , onUrlRequest = M.mapRoute LinkClicked
        }
