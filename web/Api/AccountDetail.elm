module Api.AccountDetail exposing (Response, fetch)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Url.Builder as B


type alias Response =
    { privilege : String
    , email : String
    }


decoder : Decoder Response
decoder =
    D.succeed Response
        |> required "privilege" D.string
        |> required "email" D.string


fetch : String -> ( String, String ) -> (Result Http.Error Response -> msg) -> Cmd msg
fetch apiRoot ( idToken, accessToken ) f =
    Http.request
        { url = B.crossOrigin apiRoot [ "account", "detail" ] []
        , expect = Http.expectJson f decoder
        , method = "GET"
        , body = Http.emptyBody
        , headers =
            [ Http.header "Accept" "application/json"
            , Http.header "Authorization" <| "Bearer " ++ idToken
            , Http.header "Access-Token" accessToken
            ]
        , timeout = Nothing
        , tracker = Nothing
        }
