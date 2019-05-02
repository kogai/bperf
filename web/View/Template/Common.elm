module View.Template.Common exposing (view)

import Html exposing (Html, a, div, footer, header, li, text, ul)
import Html.Attributes exposing (class, href, style)


view : Html msg -> Html msg
view children =
    div [ style "position" "relative" ]
        [ header
            [ style "border-bottom" "1px solid #eee"
            , style "padding" "1rem"
            ]
            [ ul [ class "level" ]
                [ li [ class "level-item level-left" ] [ a [ href "/" ] [ text "bperf" ] ]
                , li [ class "level-item level-right" ] [ a [ href "/dashboard" ] [ text "dashboard" ] ]
                , li [ class "level-item level-right" ] [ a [ href "/account" ] [ text "account" ] ]
                , li [ class "level-item level-right" ] [ a [ href "/sign_in" ] [ text "sign in" ] ]
                ]
            ]
        , div [ class "container", style "padding" "1rem" ]
            [ children
            ]
        , footer [ class "footer" ] [ text "Footer is still under development" ]
        ]
