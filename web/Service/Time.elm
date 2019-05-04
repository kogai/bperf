module Service.Time exposing (toReaadble, toReaadbleShort)

import String exposing (join)
import Time exposing (Month(..), Zone, toDay, toHour, toMinute, toMonth, toSecond, toYear)


toTwoDigits : Int -> String
toTwoDigits t =
    if t <= 9 then
        "0" ++ String.fromInt t

    else
        String.fromInt t


toMonth_ : Zone -> Time.Posix -> Int
toMonth_ z t =
    case toMonth z t of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


toReaadbleShort : Zone -> Time.Posix -> String
toReaadbleShort zone time =
    List.map (\f -> toTwoDigits <| f zone time) [ toHour, toMinute, toSecond ]
        |> join ":"


toReaadble : Zone -> Time.Posix -> String
toReaadble zone time =
    let
        years =
            List.map (\f -> toTwoDigits <| f zone time) [ toYear, toMonth_, toDay ]
                |> join "-"

        hours =
            toReaadbleShort zone time
    in
    years ++ " " ++ hours
