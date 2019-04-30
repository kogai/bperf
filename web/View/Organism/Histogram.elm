module View.Organism.Histogram exposing (view)

import Axis
import Color
import Histogram exposing (Bin, HistogramGenerator, Threshold, binCount)
import Html exposing (div, text)
import Html.Attributes exposing (class)
import Scale exposing (ContinuousScale)
import Time exposing (toHour, toMinute, utc)
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes exposing (class, fill, transform)
import TypedSvg.Attributes.InPx exposing (height, width, x, y)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))


toUtcString : Time.Posix -> String
toUtcString time =
    String.fromInt (toHour utc time)
        ++ ":"
        ++ String.fromInt (toMinute utc time)


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


w : Float
w =
    400


h : Float
h =
    250


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


timestampToLabel : Float -> String
timestampToLabel x =
    x |> round |> Time.millisToPosix |> toUtcString


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
        , height <| h - Scale.convert yScale (toFloat length) - 2 * padding
        , fill <| Fill <| Color.rgb255 46 118 149
        ]
        []


type alias Props =
    List Float


view : Props -> Svg msg
view props =
    let
        bins =
            histogram props
    in
    div [ class [ "panel" ] ]
        [ div [ class [ "panel-heading" ] ] [ text "rendering events" ]
        , div
            [ class [ "panel-block" ]
            ]
            [ svg
                [ width w, height h ]
                [ g [ transform [ Translate (padding - 1) (h - padding) ] ]
                    [ xAxis props ]
                , g [ transform [ Translate (padding - 1) padding ] ]
                    [ yAxis bins ]
                , g [ transform [ Translate padding padding ], class [ "series" ] ] <|
                    List.map (column props (yScaleFromBins bins)) bins
                ]
            ]
        ]
