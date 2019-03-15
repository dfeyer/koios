module Views.Layout exposing (mainHeaderView, mainHeaderWithChapterView, pageLayoutView, rowView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (..)


pageLayoutView : List (Html Msg) -> Html Msg
pageLayoutView content =
    div
        [ id "banner"
        ]
        [ div []
            content
        ]


mainHeaderView : String -> Html Msg
mainHeaderView content =
    h1 [] [ text content ]


mainHeaderWithChapterView : String -> String -> Html Msg
mainHeaderWithChapterView chapter content =
    div []
        [ h3 [ class "chapter" ] [ text chapter ]
        , h1 [] [ text content ]
        ]


rowView : List (Html Msg) -> Html Msg
rowView content =
    div [] content
