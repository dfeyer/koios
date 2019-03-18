module Page.NotFound exposing (view)

import Html exposing (Html)


view : { title : String, content : Html msg }
view =
    { title = "Page not found"
    , content = Html.text "Oups..."
    }
