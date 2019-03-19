module Data.Learnings exposing (sectionByTopic, targetBySection, topicByGroup)

import Data.Target as Target
import Shared exposing (..)


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


sectionByTopic : List Group -> Group -> Topic -> Maybe (List Section)
sectionByTopic learnings group topic =
    case topicByGroup learnings group of
        Just topics ->
            case
                List.filter (\t -> t.id == topic.id) topics
                    |> List.head
            of
                Just topic_ ->
                    Just topic_.sections

                Nothing ->
                    Nothing

        Nothing ->
            Nothing


targetBySection : List Group -> Group -> Topic -> Section -> Maybe (List SlugableTarget)
targetBySection learnings group topic section =
    case sectionByTopic learnings group topic of
        Just sections ->
            case
                List.filter (\s -> s.id == section.id) sections
                    |> List.head
            of
                Just section_ ->
                    Just (List.map Target.toSlugableTarget section_.targets)

                Nothing ->
                    Nothing

        Nothing ->
            Nothing
