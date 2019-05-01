module Api.Events exposing (Response, fetch)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Url.Builder as B


type alias Event =
    { time : Float
    , eventType : String
    }


type alias Response =
    List Event


decoder : Decoder Response
decoder =
    D.list
        (D.succeed Event
            |> required "time" D.float
            |> required "eventType" D.string
        )


fetch : String -> String -> (Result Http.Error Response -> msg) -> Cmd msg
fetch apiRoot idToken f =
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
