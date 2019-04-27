module HistogramChart exposing (main, view)

{-| Renders a histogram of a randomly generated data set
-}

import Axis
import Color
import Debug
import Histogram exposing (Bin, HistogramGenerator)
import Random exposing (Generator, Seed)
import Scale exposing (BandConfig, BandScale, ContinuousScale, defaultBandConfig)
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes exposing (class, fill, transform)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))


{-| We use addition here to approximate normal distribution.
-}
generator : Generator (List Float)
generator =
    Random.list 500 <| Random.map2 (+) (Random.float 0 10) (Random.float 0 10)


seed : Seed
seed =
    -- chosen by fair dice roll
    Random.initialSeed 227852860


data : List Float
data =
    Tuple.first <| Random.step generator seed


histogram : List Float -> List (Bin Float Float)
histogram model =
    Histogram.float
        |> Histogram.withDomain ( model |> List.head |> Maybe.withDefault 0, model |> List.reverse |> List.head |> Maybe.withDefault 100 )
        |> Histogram.compute model


w : Float
w =
    900


h : Float
h =
    450


padding : Float
padding =
    30


xScale : List Float -> ContinuousScale Float
xScale model =
    Scale.linear ( 0, w - 2 * padding ) ( model |> List.head |> Maybe.withDefault 0, model |> List.reverse |> List.head |> Maybe.withDefault 100 )


yScaleFromBins : List (Bin Float Float) -> ContinuousScale Float
yScaleFromBins bins =
    List.map .length bins
        |> List.maximum
        |> Maybe.withDefault 0
        |> toFloat
        |> Tuple.pair 0
        |> Scale.linear ( h - 2 * padding, 0 )


xAxis : List Float -> Svg msg
xAxis model =
    Axis.bottom [] <| xScale model


yAxis : List (Bin Float Float) -> Svg msg
yAxis bins =
    Axis.left [ Axis.tickCount 5 ] (yScaleFromBins bins)


column : List Float -> ContinuousScale Float -> Bin Float Float -> Svg msg
column model yScale { length, x0, x1 } =
    rect
        [ x <| Scale.convert (xScale model) x0
        , y <| Scale.convert yScale (toFloat length)
        , width <| Scale.convert (xScale model) x1 - Scale.convert (xScale model) x0
        , height <| h - Scale.convert yScale (toFloat length) - 2 * padding
        , fill <| Fill <| Color.rgb255 46 118 149
        ]
        []


view : List Float -> Svg msg
view model =
    let
        bins =
            histogram model

        _ =
            Debug.log "bins" bins
    in
    svg
        [ width w, height h ]
        [ g [ transform [ Translate (padding - 1) (h - padding) ] ]
            [ xAxis model ]
        , g [ transform [ Translate (padding - 1) padding ] ]
            [ yAxis bins ]
        , g [ transform [ Translate padding padding ], class [ "series" ] ] <|
            List.map (column model (yScaleFromBins bins)) bins
        ]


main =
    view data
