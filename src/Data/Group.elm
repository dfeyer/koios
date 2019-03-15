module Data.Group exposing (bySection, toNavigationTitle, toSlug)

import Data.Topic
import Shared exposing (..)


toSlug : Group -> String
toSlug group =
    group.slug


toNavigationTitle : Group -> String
toNavigationTitle group =
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
