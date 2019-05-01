module Api.Events exposing (Event, Events, fetchEvents, fromHttpError)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Url.Builder as B


type alias Event =
    { time : Float
    , eventType : String
    }


type alias Events =
    List Event


decoder : Decoder Events
decoder =
    D.list
        (D.succeed Event
            |> required "time" D.float
            |> required "eventType" D.string
        )


fromHttpError : Http.Error -> String
fromHttpError e =
    case e of
        BadUrl reason ->
            "bad url " ++ reason

        BadStatus status ->
            "bad status " ++ String.fromInt status

        BadBody reason ->
            "bad body " ++ reason

        Timeout ->
            "timeout"

        NetworkError ->
            "network error"


fetchEvents : String -> String -> (Result Http.Error Events -> msg) -> Cmd msg
fetchEvents apiRoot idToken f =
    Http.request
        { url = B.crossOrigin apiRoot [ "chart", "events" ] []
        , expect = Http.expectJson f decoder
        , method = "GET"
        , body = Http.emptyBody
        , headers =
            [ Http.header "Accept" "application/json"
            , Http.header "Authorization" <| "Bearer " ++ idToken
            ]
        , timeout = Nothing
        , tracker = Nothing
        }
