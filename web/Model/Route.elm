module Model.Route exposing (Model(..), Msg(..), init, update)

import Browser
import Browser.Navigation as Nav
import Url


type Model
    = NotFound Nav.Key
    | SignIn Nav.Key
    | Dashboard Nav.Key
    | Callback Nav.Key
    | Account Nav.Key


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


keyOf : Model -> Nav.Key
keyOf model =
    case model of
        NotFound k ->
            k

        SignIn k ->
            k

        Dashboard k ->
            k

        Callback k ->
            k

        Account k ->
            k


init : Url.Url -> Nav.Key -> Model
init url key =
    case url.path of
        "/sign_in" ->
            SignIn key

        "/dashboard" ->
            Dashboard key

        "/callback" ->
            Callback key

        "/account" ->
            Account key

        _ ->
            NotFound key


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl
                        (keyOf model)
                        (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( init url (keyOf model), Cmd.none )
