module Views.Breadcrumb exposing (view)

import Html exposing (Html, a, span, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)


view : List ( msg, String ) -> Html msg
view items =
    items
        |> List.map
            (\( msg, label ) ->
                a [ href "#", onClick msg ] [ text label ]
            )
        |> span [ class "breadcrumb" ]
