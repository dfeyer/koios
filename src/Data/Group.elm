module Data.Group exposing
    ( Group
    , GroupPosition
    , Introduction
    , Position
    , Section
    , SectionIdentifier
    , SectionPosition
    , Target
    , Topic
    , decode
    , groupBySlug
    , sectionBySlug
    , targetByPosition
    , toHtml
    , toString
    , topicBySlug
    )

import Data.Slugable exposing (Slug, Slugable)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Json.Decode as Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline exposing (required)
import Shared exposing (UUID)



-- TYPES


type alias Group =
    Slugable
        { id : UUID
        , introductions : List Introduction
        , topics : List Topic
        }


createGroup : String -> Slug -> UUID -> List Introduction -> List Topic -> Group
createGroup title slug id introductions topics =
    { title = title
    , slug = slug
    , id = id
    , introductions = introductions
    , topics = topics
    }


type alias Introduction =
    Slugable
        { id : UUID
        , url : String
        }


createIntroduction : String -> Slug -> UUID -> String -> Introduction
createIntroduction title slug id url =
    { title = title
    , slug = slug
    , id = id
    , url = url
    }


type alias Topic =
    Slugable
        { id : UUID
        , sections : List Section
        }


createTopic : String -> Slug -> UUID -> List Section -> Topic
createTopic title slug id sections =
    { title = title
    , slug = slug
    , id = id
    , sections = sections
    }


type alias Section =
    Slugable
        { id : UUID
        , identifier : SectionIdentifier
        , hash : String
        , url : String
        , pdf : Maybe String
        , targets : List Target
        , group : String
        , section : String
        , subsection : String
        }


createSection : String -> Slug -> UUID -> SectionIdentifier -> String -> String -> Maybe String -> List Target -> String -> String -> String -> Section
createSection title slug id sectionIdentifier hash url maybePdf targets group section subsection =
    { title = title
    , slug = slug
    , id = id
    , identifier = sectionIdentifier
    , hash = hash
    , url = url
    , pdf = maybePdf
    , targets = targets
    , group = group
    , section = section
    , subsection = subsection
    }


type alias Target =
    { text : String
    , position : String
    }


type alias SectionIdentifier =
    { code : String
    , cycle : Int
    , order : Int
    , suffix : Maybe String
    }


type alias Position =
    ( GroupPosition, Maybe SectionPosition )


type alias GroupPosition =
    ( Group, Maybe Topic )


type alias SectionPosition =
    ( Section, Maybe Target )



-- INFO


toHtml : Group -> Html msg
toHtml group =
    span [ class "label" ] [ text (toString group) ]


toString : Group -> String
toString group =
    group.title



-- FILTER


groupBySlug : List Group -> String -> Maybe Group
groupBySlug list groupSlug =
    List.filter (\g -> g.slug == groupSlug) list
        |> List.head


topicBySlug : List Group -> String -> String -> Maybe Topic
topicBySlug list groupSlug topicSlug =
    case groupBySlug list groupSlug of
        Nothing ->
            Nothing

        Just group ->
            List.filter (\t -> t.slug == topicSlug) group.topics
                |> List.head


sectionBySlug : List Group -> String -> String -> String -> Maybe Section
sectionBySlug list groupSlug topicSlug sectionSlug =
    case topicBySlug list groupSlug topicSlug of
        Nothing ->
            Nothing

        Just topic ->
            List.filter (\s -> s.slug == sectionSlug) topic.sections
                |> List.head


targetByPosition : List Group -> String -> String -> String -> String -> Maybe Target
targetByPosition list groupSlug topicSlug sectionSlug targetPosition =
    case sectionBySlug list groupSlug topicSlug sectionSlug of
        Nothing ->
            Nothing

        Just section ->
            List.filter (\t -> t.position == targetPosition) section.targets
                |> List.head



-- SERIALIZATION


decode : Decoder Group
decode =
    Decode.succeed createGroup
        |> required "title" string
        |> required "slug" string
        |> required "id" string
        |> required "introductions" (Decode.list decodeIntroduction)
        |> required "topics" (Decode.list decodeTopic)


decodeIntroduction : Decoder Introduction
decodeIntroduction =
    Decode.succeed createIntroduction
        |> required "title" string
        |> required "slug" string
        |> required "id" string
        |> required "url" string


decodeTopic : Decoder Topic
decodeTopic =
    Decode.succeed createTopic
        |> required "title" string
        |> required "slug" string
        |> required "id" string
        |> required "sections" (Decode.list decodeSection)


decodeSection : Decoder Section
decodeSection =
    Decode.succeed createSection
        |> required "title" string
        |> required "slug" string
        |> required "id" string
        |> required "identifier" decodeSectionIdentifier
        |> required "hash" string
        |> required "url" string
        |> required "pdf" (nullable string)
        |> required "targets" (Decode.list decodeTarget)
        |> required "group" string
        |> required "section" string
        |> required "subsection" string


decodeSectionIdentifier : Decoder SectionIdentifier
decodeSectionIdentifier =
    Decode.succeed SectionIdentifier
        |> required "code" string
        |> required "cycle" int
        |> required "order" int
        |> required "suffix" (nullable string)


decodeTarget : Decoder Target
decodeTarget =
    Decode.succeed Target
        |> required "text" string
        |> required "position" string
