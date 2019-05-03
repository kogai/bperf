module View.Account exposing (view)

import Api.AccountDetail as Api
import Css exposing (pct, width)
import Html as UnStyled
import Html.Styled exposing (div, li, table, tbody, td, text, th, thead, toUnstyled, tr, ul)
import Html.Styled.Attributes exposing (class, css)
import View.Template.Common as Layout


view : Api.Response -> UnStyled.Html msg
view { privilege, mail } =
    div
        []
        [ table [ class "table is-bordered is-fullwidth is-striped", css [ width (pct 100) ] ]
            [ thead []
                [ th [] [ text "quantifier" ]
                , th [] [ text "value" ]
                ]
            , tbody []
                [ tr []
                    [ th []
                        [ text "product name" ]
                    , td
                        []
                        [ text "experimental-app" ]
                    ]
                , tr []
                    [ th []
                        [ text "script tag" ]
                    , td
                        []
                        [ text "<script src=\"https://beacon.bperf.com?key=aaabbbccc\" />"
                        ]
                    ]
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
                , tr []
                    [ th []
                        [ text "pricing plan" ]
                    , td
                        []
                        [ text "free" ]
                    ]
                , tr []
                    [ th []
                        [ text "your privilege" ]
                    , td
                        []
                        [ text privilege ]
                    ]
                , tr []
                    [ th []
                        [ text "mail address" ]
                    , td
                        []
                        [ text mail ]
                    ]
                ]
            ]
        ]
        |> toUnstyled
        |> Layout.view
