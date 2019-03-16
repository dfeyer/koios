module Components.MainMenu exposing (view)

import Html exposing (Html, a, li, text, ul)
import Html.Attributes exposing (class, href)


view : List ( Html msg, String ) -> Html msg
view items =
    ul [ class "main-menu" ]
        (List.map item items)


item : ( Html msg, String ) -> Html msg
item ( content, uri ) =
    li [ class "main-menu__item" ]
        [ a [ class "main-menu__link", href uri ]
            [ content ]
        ]
