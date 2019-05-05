module View.Organism.Session exposing (view)

import Api.Sessions
import Axis
import Color
import Constant.Chart as C
import Histogram exposing (Bin, HistogramGenerator, Threshold, binCount)
import Html.Attributes exposing (class)
import Scale exposing (ContinuousScale)
import Service.Time exposing (toReaadbleHours)
import Time exposing (utc)
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes exposing (class, fill, transform)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))


tupleMap : (a -> b) -> ( a, a ) -> ( b, b )
tupleMap f ( a1, a2 ) =
    ( f a1, f a2 )


threshhold : Threshold a Float
threshhold fn list domain =
    List.length list
        |> toFloat
        |> logBase 2
        |> ceiling
        |> (+) 1
        |> (\_ ->
                binCount (tupleMap fn domain) 100
           )


dynamicGenerator : HistogramGenerator Float Float
dynamicGenerator =
    Histogram.custom threshhold (\n -> n)


histogram : List Float -> List (Bin Float Float)
histogram model =
    dynamicGenerator
        |> Histogram.withDomain ( model |> List.head |> Maybe.withDefault 0, model |> List.reverse |> List.head |> Maybe.withDefault 100 )
        |> Histogram.compute model


xScale : List Float -> ContinuousScale Float
xScale model =
    Scale.linear ( 0, C.w - 2 * C.p ) ( model |> List.head |> Maybe.withDefault 0, model |> List.reverse |> List.head |> Maybe.withDefault 100 )


yScaleFromBins : List (Bin Float Float) -> ContinuousScale Float
yScaleFromBins bins =
    List.map .length bins
        |> List.maximum
        |> Maybe.withDefault 0
        |> toFloat
        |> Tuple.pair 0
        |> Scale.linear ( C.h - 2 * C.p, 0 )


timestampToLabel : Float -> String
timestampToLabel x =
    x |> round |> Time.millisToPosix |> toReaadbleHours utc


xAxis : List Float -> Svg msg
xAxis model =
    Axis.bottom
        [ Axis.tickFormat timestampToLabel ]
        (xScale model)


yAxis : List (Bin Float Float) -> Svg msg
yAxis bins =
    Axis.left [ Axis.tickCount 5 ] (yScaleFromBins bins)


column : List Float -> ContinuousScale Float -> Bin Float Float -> Svg msg
column model yScale { length, x0, x1 } =
    rect
        [ x <| Scale.convert (xScale model) x0
        , y <| Scale.convert yScale (toFloat length)
        , width <| Scale.convert (xScale model) x1 - Scale.convert (xScale model) x0
        , height <| C.h - Scale.convert yScale (toFloat length) - 2 * C.p
        , fill <| Fill <| Color.rgb255 46 118 149
        ]
        []


view : Api.Sessions.Response -> Svg msg
view sessions =
    let
        props =
            sessions
                |> List.map (\{ createdAt } -> Time.posixToMillis createdAt)
                |> List.map toFloat
                |> List.map ((*) 1000)

        bins =
            histogram props
    in
    svg
        [ width C.w, height C.h ]
        [ g [ transform [ Translate (C.p - 1) (C.h - C.p) ] ]
            [ xAxis props ]
        , g [ transform [ Translate (C.p - 1) C.p ] ]
            [ yAxis bins ]
        , g [ transform [ Translate C.p C.p ], class [ "series" ] ] <|
            List.map (column props (yScaleFromBins bins)) bins
        ]
