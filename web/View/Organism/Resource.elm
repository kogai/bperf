module View.Organism.Resource exposing (view)

-- import Axis
-- import Histogram exposing (Bin, HistogramGenerator, Threshold, binCount)
-- import Html exposing (div, text)
-- import Scale exposing (ContinuousScale)
-- import Time exposing (toHour, toMinute, utc)
-- import Html.Attributes exposing (class)

import Color
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes exposing (fill)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))



-- w : Float
-- w =
--     400
-- h : Float
-- h =
--     250
-- padding : Float
-- padding =
--     30


type alias Props =
    List ( Float, Float )


view : Props -> Svg msg
view durations_ =
    let
        _ =
            List.take 50 durations_

        -- _ =
        --     Debug.log "durations" durations
    in
    svg
        [ width 100, height 100 ]
        [ g []
            [ rect
                [ x 0
                , y 0
                , width 30
                , height 2
                , fill <| Fill <| Color.rgb255 46 118 149
                ]
                []
            ]
        , g []
            [ rect
                [ x 10
                , y 2
                , width 30
                , height 2
                , fill <| Fill <| Color.rgb255 46 118 149
                ]
                []
            ]
        ]
