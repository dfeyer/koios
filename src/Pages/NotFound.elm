module Pages.NotFound exposing (view)

import Html exposing (Html, div, text)


view : Html msg
view =
    div []
        [ text "Vous venez de tomber sur un truc qui n'existe pas encore..."
        ]
