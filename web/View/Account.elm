module View.Account exposing (view)

import Api.AccountDetail as Api
import Css exposing (pct, width)
import Html as UnStyled
import Html.Styled exposing (Html, div, h1, li, table, tbody, td, text, th, thead, toUnstyled, tr, ul)
import Html.Styled.Attributes exposing (class, css)
import View.Template.Common as Layout


tableRow : String -> String -> Html msg
tableRow k v =
    tr []
        [ th []
            [ text k ]
        , td
            []
            [ text v ]
        ]


view : Api.Response -> UnStyled.Html msg
view { privilege, mail } =
    div
        []
        [ h1 [ class "title is-3" ] [ text "Product information" ]
        , table [ class "table is-bordered is-fullwidth is-striped", css [ width (pct 100) ] ]
            [ thead []
                [ th [] [ text "quantifier" ]
                , th [] [ text "value" ]
                ]
            , tbody []
                [ tableRow "product name" "experimental-app"
                , tableRow "script tag" "<script src=\"https://beacon.bperf.com?key=aaabbbccc\" />"
                , tr []
                    [ th []
                        [ text "monitoring targets" ]
                    , td
                        []
                        [ ul []
                            [ li [] [ text "http://localhost:3000" ]
                            , li [] [ text "http://localhost:4000" ]
                            ]
                        ]
                    ]
                , tableRow "pricing plan" "free"
                ]
            ]
        , h1 [ class "title is-3" ] [ text "User information" ]
        , table [ class "table is-bordered is-fullwidth is-striped", css [ width (pct 100) ] ]
            [ thead []
                [ th [] [ text "quantifier" ]
                , th [] [ text "value" ]
                ]
            , tbody []
                [ tableRow "your privilege" privilege
                , tableRow "mail address" mail
                ]
            ]
        ]
        |> toUnstyled
        |> Layout.view
