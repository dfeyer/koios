module Views.Layout exposing (mainHeaderView, mainHeaderWithChapterView, rowView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (..)


mainHeaderView : Html msg -> Html msg
mainHeaderView content =
    header [ class "page-header" ] [ h1 [] [ content ] ]


mainHeaderWithChapterView : Html msg -> Html msg -> Html msg
mainHeaderWithChapterView chapter content =
    header [ class "page-header" ]
        [ h3 [ class "chapter" ] [ chapter ]
        , h1 [] [ content ]
        ]


rowView : List (Html msg) -> Html msg
rowView content =
    div [] content
