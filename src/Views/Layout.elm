module Views.Layout exposing (mainHeaderView, mainHeaderWithChapterView, pageLayoutView, rowView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (..)


pageLayoutView : List (Html msg) -> Html msg
pageLayoutView content =
    div
        [ id "banner"
        ]
        [ div []
            content
        ]


mainHeaderView : Html msg -> Html msg
mainHeaderView content =
    h1 [] [ content ]


mainHeaderWithChapterView : Html msg -> Html msg -> Html msg
mainHeaderWithChapterView chapter content =
    div []
        [ h3 [ class "chapter" ] [ chapter ]
        , h1 [] [ content ]
        ]


rowView : List (Html msg) -> Html msg
rowView content =
    div [] content
