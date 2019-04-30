module Api.User exposing (createUser)

import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Url.Builder as B


decoder : Decoder D.Value
decoder =
    D.value


createUser : String -> String -> (Result Http.Error D.Value -> msg) -> Cmd msg
createUser apiRoot accessToken f =
    Http.request
        { url = B.crossOrigin apiRoot [ "user" ] []
        , expect = Http.expectJson f decoder
        , method = "POST"
        , body = Http.jsonBody <| E.object [ ( "accessToken", E.string accessToken ) ]
        , headers =
            [ Http.header "Accept" "application/json"
            ]
        , timeout = Nothing
        , tracker = Nothing
        }
