module Components.StabyloMenu exposing (view)

import Html exposing (Html, a, li, text, ul)
import Html.Attributes exposing (class, href)


view : List ( Html msg, String ) -> Html msg
view items =
    ul [ class "stabylo-menu" ]
        (List.map item items)


item : ( Html msg, String ) -> Html msg
item ( content, uri ) =
    li [ class "stabylo-menu__item" ]
        [ a [ class "stabylo-menu__link", href uri ]
            [ content ]
        ]
