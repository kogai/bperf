module View.Organism.Progress exposing (view)

import Css exposing (bottom, fixed, position, px, right)
import Html exposing (Html)
import Html.Styled exposing (div, i, span, toUnstyled)
import Html.Styled.Attributes exposing (class, css)


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
