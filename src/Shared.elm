module Shared exposing
    ( Group
    , Model
    , Msg(..)
    , Route(..)
    , Section
    , SectionIdentifier
    , Slug
    , Slugable
    , SlugableTarget
    , Target
    , Topic
    , UriWithLabel
    , initialModel
    , labelWithoutUri
    , toSectionIdentifier
    , toSlugableTarget
    , toUriWithLabel
    )

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (Html)
import Http
import I18Next exposing (Translations, initialTranslations)
import Url exposing (Url)


type alias Slug =
    String


type alias UUID =
    String


type alias Model =
    { key : Key
    , route : Route
    , learnings : List Group
    , translations : Translations
    }


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


toSlugableTarget : Target -> SlugableTarget
toSlugableTarget { text, position } =
    { title = text
    , slug = "#"
    , position = position
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


toUriWithLabel : String -> Html msg -> Slug -> UriWithLabel msg
toUriWithLabel uri label slug =
    ( Just uri, label, Just slug )


labelWithoutUri : Html msg -> UriWithLabel msg
labelWithoutUri label =
    ( Nothing, label, Nothing )


type alias UriWithLabel msg =
    ( Maybe String, Html msg, Maybe Slug )


initialModel : Route -> List Group -> Key -> Model
initialModel route learnings key =
    { key = key
    , route = route
    , learnings = learnings
    , translations = initialTranslations
    }


type Route
    = HomeRoute
    | GroupRoute Slug
    | TopicRoute Slug Slug
    | SectionRoute Slug Slug Slug
    | NotFoundRoute


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | TranslationsLoaded (Result Http.Error Translations)
