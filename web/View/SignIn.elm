module View.SignIn exposing (view)

import Html exposing (Html, button, div, form, label, text)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onClick)
import View.Template.Common as Layout


view : msg -> Html msg
view onSignIn =
    Layout.view <|
        form
            [ class "field" ]
            [ label [ class "label" ] [ text "Sign in" ]
            , div [ class "tile is-vertical is-parent" ]
                [ button [ class "button is-primary", type_ "button", onClick onSignIn ] [ text "SignIn" ]
                ]
            ]
