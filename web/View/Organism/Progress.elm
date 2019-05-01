module View.Organism.Progress exposing (view)

import Css exposing (borderRadius, fixed, height, left, num, opacity, pc, position, px, top, width)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Styled exposing (div, progress, text, toUnstyled)
import Html.Styled.Attributes as S exposing (css, max, value)


view : ( Int, Int ) -> Html msg
view ( v, m ) =
    toUnstyled <|
        if v /= m then
            div
                [ css
                    [ position fixed
                    , top (px 0)
                    , left (px 0)
                    , width (pc 100)
                    ]
                ]
                [ progress
                    [ value <| String.fromInt 15
                    , max <| String.fromInt 100
                    , S.class "progress is-info"
                    , css
                        [ height (px 5)
                        , opacity (num 0.7)
                        , borderRadius (px 0)
                        ]
                    ]
                    [ text "15%" ]
                ]

        else
            div [] []
