module Components.ContentArea exposing (infoBox, introduction, paragraph, primaryTitle, secondaryTitle, ternaryTitle, view)

import Html exposing (Attribute, Html, div, h2, h3, h4, node, p, text)
import Html.Attributes exposing (class)


view : List (Html msg) -> Html.Html msg
view list =
    node
        "main"
        [ class "content content--two" ]
        list


infoBox : List (Html msg) -> Html msg
infoBox list =
    div
        [ pclass "infobox" ]
        list


primaryTitle : String -> Html msg
primaryTitle content =
    h2
        [ pclass "title" ]
        [ text content ]


secondaryTitle : String -> Html msg
secondaryTitle content =
    h3
        [ pclass "title" ]
        [ text content ]


ternaryTitle : String -> Html msg
ternaryTitle content =
    h4
        [ pclass "title" ]
        [ text content ]


introduction : String -> Html msg
introduction content =
    p
        [ pclass "introduction" ]
        [ text content ]


paragraph : String -> Html msg
paragraph content =
    p
        [ pclass "text" ]
        [ text content ]



-- INTERNAL HELPERS


pclass : String -> Attribute msg
pclass suffix =
    class ("content__" ++ suffix)
