module View.Dashboard exposing (frame)

import Html exposing (Html, div, text)


frame : () -> Html msg
frame _ =
    div [] [ text "Dashboard" ]
