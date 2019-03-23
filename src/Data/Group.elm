module Data.Group exposing (Group, Introduction, Section, SectionIdentifier, Target, Topic, toHtml, toSlug, toString)

import Data.Slugable exposing (Slugable)
import Html exposing (Html, span, text)
import Html.Attributes exposing (class)
import Shared exposing (UUID)



-- TYPES


type alias Group =
    Slugable
        { id : UUID
        , introductions : List Introduction
        , topics : List Topic
        }


type alias Introduction =
    Slugable
        { id : UUID
        , url : String
        }


type alias Topic =
    Slugable
        { id : UUID
        , sections : List Section
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


toSectionIdentifier : String -> Int -> Int -> Maybe String -> SectionIdentifier
toSectionIdentifier code cycle order maybeSuffix =
    SectionIdentifier code cycle order maybeSuffix



-- INFO


toSlug : Group -> String
toSlug group =
    group.slug


toHtml : Group -> Html msg
toHtml group =
    span [ class "label" ] [ text (toString group) ]


toString : Group -> String
toString group =
    group.title
