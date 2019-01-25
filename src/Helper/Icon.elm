module Helper.Icon exposing (icon, leftIcon)

import Html exposing (..)
import Html.Attributes exposing (..)

icon : String -> Html msg
icon name =
    i [ class "material-icons" ] [ text name ]


leftIcon : String -> Html msg
leftIcon name =
    i [ class "material-icons left" ] [ text name ]
