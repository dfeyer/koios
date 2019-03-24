module Views.Day exposing (labelView)

import Html exposing (..)
import Html.Attributes exposing (..)


labelView : ( String, String ) -> Html msg
labelView ( label, date ) =
    div [ class "day__label" ]
        [ h2 [ class "day__header" ] [ text label ]
        , h3 [ class "day__subheader" ] [ text date ]
        ]
