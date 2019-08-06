module Views.Button exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : List (Html msg) -> Html msg
view content =
    button [ class "button" ]
        content
