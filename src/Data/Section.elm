module Data.Section exposing (sectionByTopic, toCode, toHtml, toIdentifier, toSlug, toString)

import Data.Group exposing (Group, Section, SectionIdentifier, Topic)
import Data.Topic exposing (topicByGroup)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)


toSlug : Section -> String
toSlug { identifier } =
    identifier.code
        ++ "/"
        ++ String.fromInt identifier.cycle
        ++ "/"
        ++ String.fromInt identifier.order


toHtml : Section -> Html msg
toHtml section =
    span [ class "label" ] [ text (toString section) ]


toString : Section -> String
toString { title } =
    title


toIdentifier : SectionIdentifier -> String
toIdentifier { code, cycle, order } =
    String.fromInt cycle ++ String.fromInt order


toCode : SectionIdentifier -> String
toCode { code } =
    code


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
