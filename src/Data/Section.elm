module Data.Section exposing (sectionByTopic, toHtml, toString)

import Data.Group exposing (Group, Section, SectionIdentifier, Topic)
import Data.Topic exposing (topicByGroup)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)


toHtml : Section -> Html msg
toHtml section =
    span [ class "label" ] [ text (toString section) ]


toString : Section -> String
toString { title } =
    title


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
