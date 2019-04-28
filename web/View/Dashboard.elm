module View.Dashboard exposing (frame)

import Html exposing (Html, div, text)
import View.Template.Common as Layout


frame : () -> Html msg
frame _ =
    Layout.view <|
        div [] [ text "Dashboard" ]
