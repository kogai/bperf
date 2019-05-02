module View.Dashboard exposing (Props(..), view)

import Api.Networks
import Api.Sessions
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))
import View.Organism.Histogram as Histogram
import View.Organism.Resource as Resource
import View.Organism.Session as Session
import View.Template.Common as Layout


type Props
    = Failure
    | Loading
    | Success
        { events : List Float
        , durations : List ( Float, Float )

        -- , networks : List { name : String, startTime : Float, endTime : Float }
        , networks : Api.Networks.Response
        , sessions : Api.Sessions.Response
        }


panel : String -> Html msg -> Html msg
panel title x =
    div [ class "panel" ]
        [ div [ class "panel-heading" ] [ text title ]
        , div
            [ class "panel-block" ]
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

            Success { events, networks, sessions } ->
                div []
                    [ panel "session" <| Session.view sessions
                    , panel "network" <| Resource.view networks
                    , panel "rendering" <| Histogram.view events
                    ]
