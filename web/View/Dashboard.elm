module View.Dashboard exposing (Props, view)

import Api.Durations
import Api.Networks
import Api.Sessions
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Time
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Fill(..), Transform(..))
import View.Organism.Duration as Duration
import View.Organism.Histogram as Histogram
import View.Organism.Resource as Resource
import View.Organism.Session as Session
import View.Template.Common as Layout


type alias Props =
    { events : List Float
    , durations : Api.Durations.Response
    , networks : Api.Networks.Response
    , sessions : Api.Sessions.Response
    , zone : Time.Zone
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
view { events, networks, sessions, durations, zone } =
    Layout.view <|
        div []
            [ panel "durations" <| Duration.view durations zone
            , panel "session" <| Session.view sessions zone
            , panel "network" <| Resource.view networks
            , panel "rendering" <| Histogram.view events zone
            ]
