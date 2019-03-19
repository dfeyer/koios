module Data.Group exposing (bySection, toHtml, toSlug, toString)

import Data.Topic
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Shared exposing (..)


toSlug : Group -> String
toSlug group =
    group.slug


toHtml : Group -> Html msg
toHtml group =
    span [ class "label" ] [ text (toString group) ]


toString : Group -> String
toString group =
    group.title


bySection : List Group -> SectionIdentifier -> Maybe Group
bySection groups identifier =
    List.filter (containSection identifier) groups
        |> List.head


containSection : SectionIdentifier -> Group -> Bool
containSection identifier group =
    case List.filter (Data.Topic.containSection identifier) group.topics of
        [] ->
            False

        _ ->
            True
