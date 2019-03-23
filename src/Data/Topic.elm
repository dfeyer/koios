module Data.Topic exposing (bySection, containSection, foldTopics, toHtml, toSlug, toString, topicByGroup)

import Data.Group exposing (Group, SectionIdentifier, Topic)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)


toSlug : Group -> Topic -> String
toSlug group topic =
    group.slug ++ "/" ++ topic.slug


toHtml : Topic -> Html msg
toHtml topic =
    span [ class "label" ] [ text (toString topic) ]


toString : Topic -> String
toString topic =
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


topicByGroup : List Group -> Group -> Maybe (List Topic)
topicByGroup learnings group =
    case
        List.filter (\g -> g.id == group.id) learnings
            |> List.head
    of
        Just group_ ->
            Just group_.topics

        Nothing ->
            Nothing
