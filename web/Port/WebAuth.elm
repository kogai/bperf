port module Port.WebAuth exposing (Msg(..), onAuthComplete, onSignIn, onVisitAuthCallback)

import Json.Encode as E


port onSignIn : () -> Cmd msg


port onVisitAuthCallback : () -> Cmd msg


type Msg
    = OnRecieveRaw String
    | AuthComplete E.Value


port onAuthComplete : (E.Value -> msg) -> Sub msg
