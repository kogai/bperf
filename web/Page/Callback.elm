port module Page.Callback exposing (view)

import Html exposing (Html, div, text)
import Json.Decode as D exposing (Decoder, int, oneOf, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Model as M
import Model.Auth as A


view : M.Model -> Html M.Msg
view model =
    case model.auth of
        A.UnAuthorized ->
            text "Authorization process has been started."

        A.Success { accessToken, expiresIn, idToken } ->
            div []
                [ div []
                    [ text "Authorization process has been successed."
                    ]
                , div []
                    [ text <| "accessToken:" ++ accessToken ++ " idToken:" ++ idToken ++ " expiresIn:" ++ String.fromInt expiresIn
                    ]
                ]

        A.Failure { errorDescription } ->
            text errorDescription
