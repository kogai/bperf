module View.Organism.Duration exposing (view)

import Api.Durations
import Html as UnStyled
import Html.Styled exposing (Html, table, tbody, td, text, th, thead, toUnstyled, tr)
import Html.Styled.Attributes exposing (class)
import Service.Time exposing (toReaadble)
import Time exposing (utc)


tableRow : String -> String -> Html msg
tableRow k v =
    tr []
        [ th []
            [ text k ]
        , td
            []
            [ text v ]
        ]


view : Api.Durations.Response -> UnStyled.Html msg
view ds =
    toUnstyled <|
        table
            [ class "table is-bordered is-fullwidth is-striped" ]
            [ thead
                []
                [ th [] [ text "session start at" ]
                , th [] [ text "first-contentful-paint(ms)" ]
                ]
            , tbody [] <|
                List.map
                    (\{ startTime, duration } ->
                        tableRow
                            (startTime |> round |> Time.millisToPosix |> toReaadble utc)
                            (duration |> round |> String.fromInt)
                    )
                    (List.take 10 ds)
            ]
