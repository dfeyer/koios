module Data.Topic exposing (bySection, containSection, foldTopics, toNavigationTitle, toSlug)

import Shared exposing (Group, SectionIdentifier, Slugable, Topic, UriWithLabel)


toSlug : Group -> Topic -> String
toSlug group topic =
    group.slug ++ "/" ++ topic.slug


toNavigationTitle : Topic -> String
toNavigationTitle topic =
    topic.title


bySection : List Group -> SectionIdentifier -> Maybe Topic
bySection groups identifier =
    List.filter (containSection identifier) (foldTopics groups)
        |> List.head


containSection : SectionIdentifier -> Topic -> Bool
containSection identifier topic =
    case List.filter (\s -> s.identifier == identifier) topic.sections of
        [] ->
            False

        _ ->
            True


foldTopics : List Group -> List Topic
foldTopics groups =
    List.foldr (\g a -> List.append a g.topics) [] groups
