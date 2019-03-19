module Components.MainMenu exposing (view)

import Html exposing (Html, a, li, text, ul)
import Html.Attributes exposing (class, href)
import Route exposing (Route)


view : List ( Html msg, Route ) -> Html msg
view items =
    ul [ class "main-menu" ]
        (List.map item items)


item : ( Html msg, Route ) -> Html msg
item ( content, route ) =
    li [ class "main-menu__item" ]
        [ a [ class "main-menu__link", Route.href route ]
            [ content ]
        ]
