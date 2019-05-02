module View.Organism.Progress exposing (view)

import Css exposing (borderRadius, bottom, fixed, height, left, num, opacity, pc, pct, position, px, right, top, width)
import Html exposing (Html)
import Html.Styled exposing (div, i, progress, span, text, toUnstyled)
import Html.Styled.Attributes as S exposing (class, css, max, value)


view : Html msg
view =
    toUnstyled <|
        div
            [ css
                [ position fixed
                , bottom (px 10)
                , right (px 10)
                ]
            ]
            [ span [ class "icon is-medium has-text-info" ]
                [ i [ class "fas fa-spinner fa-pulse fa-2x" ] []
                ]
            ]
