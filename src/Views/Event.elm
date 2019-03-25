module Views.Event exposing (emptyView, timedView, view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Int -> Int -> String -> Html msg
view start end label =
    div
        [ class "event"
        ]
        [ div [ class "event__label" ] [ text label ]
        , div [ class "event__time" ]
            [ span [ class "event__start" ] [ text (String.fromInt start ++ "h") ]
            , text "-"
            , span [ class "event__end" ] [ text (String.fromInt end ++ "h") ]
            ]
        ]


timedView : String -> Int -> Int -> Html msg
timedView label start end =
    div
        [ class "event event--timed"
        , Html.Attributes.attribute "style" ("--start: " ++ String.fromInt start ++ "; --end: " ++ String.fromInt end ++ ";")
        ]
        [ div [ class "event__label" ] [ text label ]
        , div [ class "event__time" ]
            [ span [ class "event__start" ] [ text (String.fromInt start ++ "h") ]
            , text "-"
            , span [ class "event__end" ] [ text (String.fromInt end ++ "h") ]
            ]
        ]


emptyView : Int -> Int -> Html msg
emptyView start end =
    div
        [ class "event event--empty"
        , Html.Attributes.attribute "style" ("--start: " ++ String.fromInt start ++ "; --end: " ++ String.fromInt end ++ ";")
        ]
        [ div [ class "event__actions" ] [] ]
