module Components.GoToTop exposing (view)

import Html exposing (Html, a)
import Html.Attributes exposing (class, href, title)
import Icons.ChevronUp


view : Html msg
view =
    a [ href "#", class "go-to-top", title "Aller en haut de la page" ] [ Icons.ChevronUp.view ]
