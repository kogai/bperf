module Api.Networks exposing (Response, fetch)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Url.Builder as B


type alias Network =
    { startTime : Float
    , endTime : Float
    }


type alias Response =
    List Network


decoder : Decoder Response
decoder =
    D.list
        (D.succeed Network
            |> required "startTime" D.float
            |> required "endTime" D.float
        )


fetch : String -> String -> (Result Http.Error Response -> msg) -> Cmd msg
fetch apiRoot idToken f =
    Http.request
        { url = B.crossOrigin apiRoot [ "chart", "networks" ] []
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
