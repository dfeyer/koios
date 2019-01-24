module Views.Layout exposing (mainHeaderView, pageLayoutView, rowCenterView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (..)


pageLayoutView : List (Html Msg) -> Html Msg
pageLayoutView content =
    div
        [ id "banner"
        , class "section no-pad-bot"
        ]
        [ div [ class "container" ]
            ([ br [] []
             , br [] []
             ]
                ++ content
                ++ [ br [] []
                   , br [] []
                   ]
            )
        ]


mainHeaderView : String -> Html Msg
mainHeaderView content =
    h1 [ class "header center black-text" ] [ text content ]


rowCenterView : List (Html Msg) -> Html Msg
rowCenterView content =
    div [ class "row center" ] content
