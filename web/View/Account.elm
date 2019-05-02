module View.Account exposing (view)

import Html as UnStyled
import Html.Styled exposing (div, text, toUnstyled)
import View.Template.Common as Layout


view : UnStyled.Html msg
view =
    div []
        [ text "account page"
        ]
        |> toUnstyled
        |> Layout.view
