module View.Dashboard exposing (Props(..), view)

import Html exposing (div, text)
import Html.Attributes exposing (class)
import TypedSvg.Attributes exposing (class)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))
import View.Organism.Histogram as Histogram
import View.Template.Common as Layout


type Props
    = Failure
    | Loading
    | Success (List Float)


view : Props -> Svg msg
view props =
    Layout.view <|
        case props of
            Loading ->
                text "Loading..."

            Failure ->
                text "Unable to load events"

            Success events ->
                div [ class [ "tile", "is-ancestor" ] ]
                    [ div [ class [ "tile", "is-parent", "is-4" ] ]
                        [ Histogram.view events ]
                    ]
