module Page.Dashboard exposing (view)

import Html exposing (Html)
import Model as M
import Model.Chart as C
import TypedSvg.Types exposing (AnchorAlignment(..), Transform(..))
import View.Dashboard as V


view : M.Model -> Html M.Msg
view model =
    V.view <|
        case model.chart of
            C.Failure _ ->
                V.Failure

            C.Success { events, durations } ->
                V.Success
                    { events =
                        events
                            |> List.map (\x -> x.time)
                    , durations =
                        durations
                            |> List.map (\x -> ( x.startTime, x.endTime ))
                    }

            _ ->
                V.Loading
