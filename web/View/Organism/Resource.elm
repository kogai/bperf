module View.Organism.Resource exposing (view)

import Color
import Constant.Chart as C
import Scale exposing (BandScale, ContinuousScale, defaultBandConfig)
import Time
import TypedSvg exposing (g, rect, style, svg, text_)
import TypedSvg.Attributes exposing (class, fill)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg, text)
import TypedSvg.Types exposing (Fill(..), Transform(..))


yScale : List ( Time.Posix, Float ) -> BandScale Time.Posix
yScale model =
    List.map Tuple.first model
        |> Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.1 } ( 0, C.h - 2 * C.p )


{-| Scale.linear : outputRange -> inputRange -> Scale


    scale_ =
        Scale.linear ( 50, 100 ) ( 0, 1 )

    --> 75

-}
xScale : ContinuousScale Float
xScale =
    Scale.linear ( 0, C.w ) ( 0, 3000 )


yyScale : Int -> ContinuousScale Float
yyScale len =
    Scale.linear ( 0, C.h ) ( 0, toFloat len )


column :
    Int
    -> BandScale Time.Posix
    -> Int
    ->
        { name : String
        , startTime : Time.Posix
        , duration : Float
        }
    -> Svg msg
column len scale idx { startTime, duration, name } =
    g [ class [ "column" ] ]
        [ rect
            [ x <| Scale.convert scale startTime
            , y <| Scale.convert (yyScale len) (toFloat idx)
            , height <| Scale.bandwidth scale
            , width <| Scale.convert xScale duration
            , fill <| Fill <| Color.rgb255 46 118 149
            ]
            []
        , text_
            [ x <| Scale.convert scale startTime
            , y <| Scale.convert (yyScale len) (toFloat idx)
            ]
            [ text name ]
        ]


type alias Props =
    List
        { name : String
        , startTime : Float
        , endTime : Float
        }


view : Props -> Svg msg
view networks_ =
    let
        networks =
            networks_
                |> List.take 50
                |> List.map (\{ startTime, endTime, name } -> { startTime = startTime, name = name, duration = endTime - startTime })
                |> List.map (\{ startTime, duration, name } -> { duration = duration, name = name, startTime = round startTime })
                |> List.map (\{ startTime, duration, name } -> { duration = duration, name = name, startTime = Time.millisToPosix startTime })
    in
    svg
        [ width C.w, height C.h ]
        [ style [] [ text """
            .column text { display: none; }
            .column:hover text { display: inline; }
          """ ]
        , g [] <| List.indexedMap (column (List.length networks) (yScale <| List.map (\{ startTime, duration } -> ( startTime, duration )) networks)) networks
        ]
