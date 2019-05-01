module Model exposing (Flags, Model, Msg(..), init, mapAuth, mapRoute, update)

import Api.Durations
import Api.Events
import Api.Networks
import Browser.Navigation as Nav
import Model.Auth as A
import Model.Chart as C
import Model.Route as R
import Url


type alias Flags =
    { apiRoot : String
    , sessions : Maybe A.AuthSuccess
    }


type alias Model =
    { route : R.Model
    , auth : A.Model
    , chart : C.Model
    , apiRoot : String
    }


type Msg
    = Auth A.Msg
    | Chart C.Msg
    | Route R.Msg


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
                                ]

                        _ ->
                            Cmd.none
            in
            Cmd.map Chart <| msg

        R.Callback _ ->
            Cmd.map Auth <| A.doVisitAuthCallback ()

        _ ->
            Cmd.none


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init { apiRoot, sessions } url key =
    let
        model =
            { route = R.init url key
            , auth = A.init sessions
            , chart = C.init
            , apiRoot = apiRoot
            }
    in
    ( model
    , whenUrlChanged model model.route
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Auth subMsg ->
            let
                ( subModel, subCmd ) =
                    A.update model.apiRoot subMsg model.auth
            in
            ( { model | auth = subModel }, Cmd.map Auth subCmd )

        Chart subMsg ->
            let
                ( subModel, subCmd ) =
                    C.update subMsg model.chart
            in
            ( { model | chart = subModel }, Cmd.map Chart subCmd )

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
