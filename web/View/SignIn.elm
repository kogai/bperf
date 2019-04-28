module View.SignIn exposing (view)

import Html exposing (Html, button, div, form, input, label, p, text)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick)
import View.Template.Common as Layout


view : msg -> Html msg
view onSignIn =
    Layout.view <|
        form
            [ class "field" ]
            [ label [ class "label" ] [ text "Label" ]
            , div [ class "tile is-vertical is-parent" ]
                [ div [ class "control" ]
                    [ input [ class "input", type_ "text", placeholder "Text input" ] []
                    ]
                , p [ class "help" ] [ text "This is a help text" ]
                , button [ class "button is-primary", type_ "button", onClick onSignIn ] [ text "SignIn" ]
                ]
            ]
