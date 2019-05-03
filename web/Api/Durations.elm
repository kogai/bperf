module Api.Durations exposing (Response, fetch)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Url.Builder as B


type alias Duration =
    { startTime : Float
    , duration : Float
    }


type alias Response =
    List Duration


decoder : Decoder Response
decoder =
    D.list
        (D.succeed Duration
            |> required "startTime" D.float
            |> required "durationMs" D.float
        )


fetch : String -> String -> (Result Http.Error Response -> msg) -> Cmd msg
fetch apiRoot idToken f =
    Http.request
        { url = B.crossOrigin apiRoot [ "chart", "durations" ] []
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
