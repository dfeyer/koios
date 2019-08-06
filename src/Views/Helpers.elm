module Views.Helpers exposing (WithSession, ihes)

import Html exposing (..)
import Html.Attributes exposing (..)
import Session exposing (Session)


type alias WithSession a =
    { a | session : Session }


ihes : Html msg
ihes =
    abbr [ title "Instruction Hors Etablissement Scolaire" ] [ text "IHES" ]
