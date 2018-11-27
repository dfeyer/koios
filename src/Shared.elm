module Shared exposing (Model, Msg(..), RemoteData(..), Route(..), Section, SectionIdentifier, Targets, initialModel, mapRemoteData)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Http
import I18Next exposing (Translations, initialTranslations)
import RemoteData exposing (RemoteData(..), WebData)
import Url exposing (Url)


type alias Model =
    { key : Key
    , route : Route
    , sections : RemoteData (List String)
    , translations : Translations
    }


type alias Section =
    { title : String
    , identifier : SectionIdentifier
    , hash : String
    , url : String
    , pdf : String
    , targets : List Targets
    , group : String
    , section : String
    , subsection : String
    }


type alias Targets =
    ( String, Maybe String )


type alias SectionIdentifier =
    { code : String
    , cycle : Int
    , order : Int
    , suffix : Maybe String
    }


initialModel : Route -> Key -> Model
initialModel route key =
    { key = key
    , route = route
    , sections = NotAsked
    , translations = initialTranslations
    }


type Route
    = HomeRoute
    | NotFoundRoute


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | TranslationsLoaded (Result Http.Error Translations)


type RemoteData a
    = NotAsked
    | Loading
    | Loaded a
    | Failure


mapRemoteData : (a -> b) -> RemoteData a -> RemoteData b
mapRemoteData fn remoteData =
    case remoteData of
        NotAsked ->
            NotAsked

        Loading ->
            Loading

        Loaded data ->
            Loaded (fn data)

        Failure ->
            Failure
