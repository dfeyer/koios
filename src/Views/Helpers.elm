module Views.Helpers exposing (ihes)

import Html exposing (..)
import Html.Attributes exposing (..)


ihes : Html msg
ihes =
    abbr [ title "Instruction Hors Etablissement Scolaire" ] [ text "IHES" ]
