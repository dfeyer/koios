module Pages.Home exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href, value)
import Html.Events exposing (onClick)
import Shared exposing (..)


view : List String -> Html.Html Msg
view sections =
  div [] [ text "TODO" ]
