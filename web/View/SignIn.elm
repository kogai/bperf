module View.SignIn exposing (view)

import Html exposing (Html, div, form, input, label, p, text)
import Html.Attributes exposing (class, placeholder, type_)
import View.Template.Common as Layout


view : Html msg
view =
    Layout.view <|
        form
            [ class "field" ]
            [ label [ class "label" ] [ text "Label" ]
            , div [ class "control" ]
                [ input [ class "input", type_ "text", placeholder "Text input" ] []
                ]
            , p [ class "help" ] [ text "This is a help text" ]
            ]
