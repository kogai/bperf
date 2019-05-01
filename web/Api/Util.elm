module Api.Util exposing (fromHttpError)

import Http exposing (Error(..))


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
