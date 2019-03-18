module Shared exposing
    ( Group
    , Section
    , SectionIdentifier
    , Slug
    , Slugable
    , SlugableTarget
    , Target
    , Topic
    , UriWithLabel
    , toSectionIdentifier
    , toUriWithLabel
    )

import Html exposing (Html)


type alias Slug =
    String


type alias UUID =
    String


type alias Slugable a =
    { a | title : String, slug : Slug }


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


type alias SlugableTarget =
    Slugable
        { position : String
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


toUriWithLabel : msg -> Html msg -> UriWithLabel msg
toUriWithLabel msg label =
    ( msg, label )


type alias UriWithLabel msg =
    ( msg, Html msg )
