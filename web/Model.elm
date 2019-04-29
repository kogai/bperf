module Model exposing (Model, Msg(..), init, mapAuth, mapRoute, update)

import Browser.Navigation as Nav
import Model.Auth
import Model.Chart
import Model.Route
import Url


type alias Model =
    { route : Model.Route.Model
    , auth : Model.Auth.Model
    , chart : Model.Chart.Model
    }


type Msg
    = Auth Model.Auth.Msg
    | Chart Model.Chart.Msg
    | Route Model.Route.Msg


mapRoute : (msgPayload -> Model.Route.Msg) -> msgPayload -> Msg
mapRoute f x =
    Route <| f x


mapAuth : (msgPayload -> Model.Auth.Msg) -> msgPayload -> Msg
mapAuth f x =
    Auth <| f x


init : Url.Url -> Nav.Key -> Model
init url key =
    { route = Model.Route.init url key
    , auth = Model.Auth.init
    , chart = Model.Chart.init
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Auth subMsg ->
            let
                ( subModel, subCmd ) =
                    Model.Auth.update subMsg model.auth
            in
            ( { model | auth = subModel }, Cmd.map Auth subCmd )

        Chart subMsg ->
            let
                ( subModel, subCmd ) =
                    Model.Chart.update subMsg model.chart
            in
            ( { model | chart = subModel }, Cmd.map Chart subCmd )

        Route subMsg ->
            let
                ( subModel, subCmd ) =
                    Model.Route.update subMsg model.route
            in
            ( { model | route = subModel }, Cmd.map Route subCmd )
