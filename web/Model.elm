module Model exposing (Flags, Model, Msg(..), init, mapAuth, mapRoute, update)

import Api.Durations
import Api.Events
import Api.Networks
import Api.Sessions
import Browser.Navigation as Nav
import Model.Auth as A
import Model.Chart as C
import Model.Route as R
import Page.Account
import Page.Progress as P
import Url


type alias Flags =
    { apiRoot : String
    , sessions : Maybe A.AuthSuccess
    }


type alias Model =
    { route : R.Model
    , auth : A.Model
    , chart : C.Model
    , progress : P.Model
    , account : Page.Account.Model
    , apiRoot : String
    }


type Msg
    = Auth A.Msg
    | Chart C.Msg
    | Route R.Msg
    | Progress P.Msg
    | Account Page.Account.Msg


mapRoute : (msgPayload -> R.Msg) -> msgPayload -> Msg
mapRoute f x =
    Route <| f x


mapAuth : (msgPayload -> A.Msg) -> msgPayload -> Msg
mapAuth f x =
    Auth <| f x


whenUrlChanged : Model -> R.Model -> Cmd Msg
whenUrlChanged model route =
    case route of
        R.Dashboard _ ->
            let
                msg =
                    case model.auth of
                        A.Success { idToken } ->
                            Cmd.batch
                                [ Api.Events.fetch model.apiRoot idToken C.EventsMsg
                                , Api.Durations.fetch model.apiRoot idToken C.DurationsMsg
                                , Api.Networks.fetch model.apiRoot idToken C.NetworkMsg
                                , Api.Sessions.fetch model.apiRoot idToken C.SessionsMsg
                                ]

                        _ ->
                            Cmd.none
            in
            Cmd.batch
                [ Cmd.map Chart <| msg
                , Cmd.map Progress <| P.onLoadStart ()
                , Cmd.map Progress <| P.onLoadStart ()
                , Cmd.map Progress <| P.onLoadStart ()
                , Cmd.map Progress <| P.onLoadStart ()
                ]

        R.Callback _ ->
            Cmd.map Auth <| A.doVisitAuthCallback ()

        _ ->
            Cmd.none


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init { apiRoot, sessions } url key =
    let
        ( account, accountMsg ) =
            Page.Account.init apiRoot sessions

        model =
            { route = R.init url key
            , auth = A.init sessions
            , chart = C.init
            , progress = P.init
            , account = account
            , apiRoot = apiRoot
            }
    in
    ( model
    , Cmd.batch
        [ whenUrlChanged model model.route
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

        Chart subMsg ->
            let
                ( subModel, subCmd ) =
                    C.update subMsg model.chart
            in
            ( { model | chart = subModel }
            , Cmd.batch
                [ Cmd.map Chart subCmd
                , case subModel of
                    C.Failure _ ->
                        Cmd.map Progress <| P.onLoadAbort ()

                    _ ->
                        Cmd.map Progress <| P.onLoadComplete ()
                ]
            )

        Account subMsg ->
            let
                subModel =
                    Page.Account.update subMsg model.account
            in
            ( { model | account = subModel }, Cmd.none )

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
                , whenUrlChanged model subModel
                ]
            )
