module View.Organism.Resource exposing (view)

import Color
import Scale exposing (BandScale, ContinuousScale, defaultBandConfig)
import Time
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes exposing (fill)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))


w : Float
w =
    700


h : Float
h =
    300


padding : Float
padding =
    30



-- xAxis : List ( Time.Posix, Float ) -> Svg msg
-- xAxis model =
--     Axis.bottom [] (Scale.toRenderable dateFormat (xScale model))
-- yAxis : Svg msg
-- yAxis =
--     Axis.left [ Axis.tickCount 5 ] yScale


yScale : List ( Time.Posix, Float ) -> BandScale Time.Posix
yScale model =
    List.map Tuple.first model
        |> Scale.band { defaultBandConfig | paddingInner = 0.1, paddingOuter = 0.1 } ( 0, h - 2 * padding )


{-| Scale.linear : outputRange -> inputRange -> Scale


    scale_ =
        Scale.linear ( 50, 100 ) ( 0, 1 )

    --> 75

-}
xScale : ContinuousScale Float
xScale =
    Scale.linear ( 0, w ) ( 0, 3000 )


yyScale : ContinuousScale Float
yyScale =
    Scale.linear ( 0, h ) ( 0, 50 )


column : BandScale Time.Posix -> Int -> ( Time.Posix, Float ) -> Svg msg
column scale idx ( date, value ) =
    g []
        [ rect
            [ x <| Scale.convert scale date
            , y <| Scale.convert yyScale (toFloat idx)
            , height <| Scale.bandwidth scale
            , width <| Scale.convert xScale value
            , fill <| Fill <| Color.rgb255 46 118 149
            ]
            []
        ]


type alias Props =
    List ( Float, Float )


view : Props -> Svg msg
view networks_ =
    let
        networks =
            networks_
                |> List.take 50
                |> List.map (\( s, e ) -> ( s, e - s ))
                |> List.map (Tuple.mapFirst round)
                |> List.map (Tuple.mapFirst Time.millisToPosix)
    in
    svg
        [ width w, height h ]
        (List.indexedMap (column (yScale networks)) networks)
