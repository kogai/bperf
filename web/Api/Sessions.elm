module Api.Sessions exposing (Response, fetch)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Time
import Url.Builder as B


type alias Session =
    { createdAt : Time.Posix
    , os : String
    , browser : String
    }


type alias Response =
    List Session


decodeCreatedAt : Decoder Time.Posix
decodeCreatedAt =
    D.map Time.millisToPosix D.int


decoder : Decoder Response
decoder =
    D.list
        (D.succeed Session
            |> required "createdAt" decodeCreatedAt
            |> required "os" D.string
            |> required "browser" D.string
        )


fetch : String -> String -> (Result Http.Error Response -> msg) -> Cmd msg
fetch apiRoot idToken f =
    Http.request
        { url = B.crossOrigin apiRoot [ "chart", "sessions" ] [ B.string "from" "1556888400000000000", B.string "to" "1556891940000000000" ]
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
