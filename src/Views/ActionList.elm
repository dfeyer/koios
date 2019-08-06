module Views.ActionList exposing (actionLink, item, link, list, ul, view, viewWithActions)

import Html exposing (Attribute, Html, a, div, li)
import Html.Attributes exposing (class, href)
import List exposing (concat)


view : List a -> (a -> Html msg) -> Html msg
view items renderer =
    ul Nothing
        (list
            items
            renderer
        )


viewWithActions : List a -> (a -> Html msg) -> List (Html msg) -> Html msg
viewWithActions items renderer actions =
    div [ class "action-list-with-actions" ]
        [ ul (Just [ class "action-list-with-actions__list" ])
            (list
                items
                renderer
            )
        , div [ class "action-list-with-actions__actions" ] actions
        ]


ul : Maybe (List (Attribute msg)) -> List (Html msg) -> Html msg
ul maybeAttributes =
    let
        defaultAttributes =
            [ class "action-list" ]
    in
    case maybeAttributes of
        Just attributes ->
            Html.ul (concat [ defaultAttributes, attributes ])

        Nothing ->
            Html.ul defaultAttributes


list : List a -> (a -> Html msg) -> List (Html msg)
list items renderer =
    List.map
        renderer
        items


link : List (Html msg) -> Html msg
link content =
    item
        [ a [ href "#", class "action-list__link" ] content ]


actionLink : List (Html msg) -> Html msg
actionLink content =
    item
        [ a [ href "#", class "action-list__link action-list__link--action" ] content ]


item : List (Html msg) -> Html msg
item content =
    li [ class "action-list__item" ]
        content
