module Model exposing (Flags, Model, Msg(..), init, mapAuth, mapRoute, update)

import Browser.Navigation as Nav
import Model.Auth as A
import Model.Route as R
import Page.Account
import Page.Dashboard
import Page.Progress as P
import Url


type alias Flags =
    { apiRoot : String
    , sessions : Maybe A.AuthSuccess
    }


type alias Model =
    { route : R.Model
    , auth : A.Model
    , progress : P.Model
    , dashboard : Page.Dashboard.Model
    , account : Page.Account.Model
    , apiRoot : String
    }


type Msg
    = Auth A.Msg
    | Route R.Msg
    | Progress P.Msg
    | Dashboard Page.Dashboard.Msg
    | Account Page.Account.Msg


mapRoute : (msgPayload -> R.Msg) -> msgPayload -> Msg
mapRoute f x =
    Route <| f x


mapAuth : (msgPayload -> A.Msg) -> msgPayload -> Msg
mapAuth f x =
    Auth <| f x


whenUrlChanged : R.Model -> Cmd Msg
whenUrlChanged route =
    case route of
        R.Callback _ ->
            Cmd.map Auth <| A.doVisitAuthCallback ()

        _ ->
            Cmd.none


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init { apiRoot, sessions } url key =
    let
        ( dashboard, dashboardMsg ) =
            Page.Dashboard.init apiRoot sessions

        ( account, accountMsg ) =
            Page.Account.init apiRoot sessions

        model =
            { route = R.init url key
            , auth = A.init sessions
            , dashboard = dashboard
            , progress = P.init
            , account = account
            , apiRoot = apiRoot
            }
    in
    ( model
    , Cmd.batch
        [ whenUrlChanged model.route
        , Cmd.map Dashboard dashboardMsg
        , Cmd.map Account accountMsg
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Auth subMsg ->
            let
                ( subModel, subCmd ) =
                    A.update model.apiRoot subMsg model.auth

                progressCmd =
                    case subMsg of
                        A.OnCreateUser ->
                            P.onLoadStart ()

                        A.OnCreateUserComplete ->
                            P.onLoadComplete ()

                        _ ->
                            Cmd.none
            in
            ( { model | auth = subModel }
            , Cmd.batch
                [ Cmd.map Auth subCmd
                , Cmd.map Progress <| progressCmd
                ]
            )

        Dashboard subMsg ->
            let
                subModel =
                    Page.Dashboard.update subMsg model.dashboard

                nextMsg =
                    case subMsg of
                        Page.Dashboard.OnLoad ->
                            Cmd.map Progress <| P.onLoadStart ()

                        Page.Dashboard.OnAbort _ ->
                            Cmd.map Progress <| P.onLoadAbort ()

                        Page.Dashboard.OnComplete _ ->
                            Cmd.map Progress <| P.onLoadComplete ()
            in
            ( { model | dashboard = subModel }, nextMsg )

        Account subMsg ->
            let
                subModel =
                    Page.Account.update subMsg model.account

                nextMsg =
                    case subMsg of
                        Page.Account.OnLoad ->
                            Cmd.map Progress <| P.onLoadStart ()

                        Page.Account.OnAbort _ ->
                            Cmd.map Progress <| P.onLoadAbort ()

                        Page.Account.OnComplete _ ->
                            Cmd.map Progress <| P.onLoadComplete ()
            in
            ( { model | account = subModel }, nextMsg )

        Progress subMsg ->
            let
                subModel =
                    P.update subMsg model.progress
            in
            ( { model | progress = subModel }, Cmd.none )

        Route subMsg ->
            let
                ( subModel, subCmd ) =
                    R.update subMsg model.route
            in
            ( { model | route = subModel }
            , Cmd.batch
                [ Cmd.map Route subCmd
                , whenUrlChanged subModel
                ]
            )
