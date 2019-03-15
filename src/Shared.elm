module Shared exposing (Group, Model, Msg(..), Route(..), Section, SectionIdentifier, Slug, Slugable, Topic, UriWithLabel, initialModel, toUriWithLabel)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
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
    , activities : List Group
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


type alias SectionIdentifier =
    { code : String
    , cycle : Int
    , order : Int
    , suffix : Maybe String
    }


toUriWithLabel : String -> String -> String -> UriWithLabel
toUriWithLabel uri label slug =
    ( uri, label, slug )


type alias UriWithLabel =
    ( String, String, String )


initialModel : Route -> List Group -> Key -> Model
initialModel route activities key =
    { key = key
    , route = route
    , activities = activities
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
