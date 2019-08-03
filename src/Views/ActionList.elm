module Views.ActionList exposing (item, link, view)

import Html exposing (Html, a, li, ul)
import Html.Attributes exposing (class, href)


view : List a -> (a -> Html msg) -> Html msg
view items renderer =
    ul [ class "action-list" ]
        (List.map
            renderer
            items
        )


link : List (Html msg) -> Html msg
link content =
    item
        [ a [ href "#", class "action-list__link" ] content ]


item : List (Html msg) -> Html msg
item content =
    li [ class "action-list__item" ]
        content
