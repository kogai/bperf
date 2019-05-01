module View.Dashboard exposing (Props(..), view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import TypedSvg.Attributes exposing (class)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))
import View.Organism.Histogram as Histogram
import View.Organism.Resource as Resource
import View.Template.Common as Layout


type Props
    = Failure
    | Loading
    | Success (List Float)


panel : Html msg -> Html msg
panel x =
    div [ class [ "panel" ] ]
        [ div [ class [ "panel-heading" ] ] [ text "rendering events" ]
        , div
            [ class [ "panel-block" ] ]
            [ x ]
        ]


view : Props -> Svg msg
view props =
    Layout.view <|
        case props of
            Loading ->
                text "Loading..."

            Failure ->
                text "Unable to load events"

            Success events ->
                div []
                    [ panel <| Resource.view [ ( 10, 20 ) ]
                    , panel <| Histogram.view events
                    ]
