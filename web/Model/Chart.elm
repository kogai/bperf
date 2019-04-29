module Model.Chart exposing (Event, Events, Model(..), Msg(..), init, update)

import Http
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Event =
    { time : Float
    , eventType : String
    }


type alias Events =
    List Event


type Model
    = Loading
    | Failure String
    | Success Events


type Msg
    = Request
    | Response (Result Http.Error Events)


eventDecoder : Decoder Event
eventDecoder =
    D.succeed Event
        |> required "time" D.float
        |> required "eventType" D.string


decoder : Decoder (List Event)
decoder =
    D.list eventDecoder



-- = BadUrl String
-- | Timeout
-- | NetworkError
-- | BadStatus Int
-- | BadBody String
{-
   FIXME: Handle properly
-}


fromHttpError : Http.Error -> String
fromHttpError e =
    case e of
        _ ->
            ""


init : Model
init =
    Loading


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Request ->
            ( Loading
            , Http.get
                { url = "http://localhost:5000/events"
                , expect = Http.expectJson Response decoder
                }
            )

        Response (Ok xs) ->
            ( Success xs, Cmd.none )

        Response (Err e) ->
            ( Failure <| fromHttpError e, Cmd.none )
