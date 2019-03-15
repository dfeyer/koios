module Main exposing (init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Data.Slugable
import Data.Topic exposing (foldTopics)
import Html exposing (..)
import I18Next
    exposing
        ( Delims(..)
        , Translations
        , fetchTranslations
        , t
        )
import Pages.Group
import Pages.Home
import Pages.NotFound
import Pages.Section
import Pages.Topic
import Routes exposing (..)
import Shared exposing (..)
import Url
import Views.Page



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }



-- FLAGS


type alias Flags =
    { translations : TranslationFlags
    , activities : List Group
    }


type alias TranslationFlags =
    { fr : String
    }



-- INIT


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init { translations, activities } url key =
    let
        currentRoute =
            Routes.parseUrl url
    in
    ( initialModel currentRoute activities key
    , fetchTranslations TranslationsLoaded translations.fr
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TranslationsLoaded (Ok translations) ->
            ( { model | translations = translations }, Cmd.none )

        TranslationsLoaded (Err _) ->
            ( model, Cmd.none )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        OnUrlChange url ->
            let
                newRoute =
                    Routes.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = t model.translations "title.default"
    , body = [ page model ]
    }


page : Model -> Html Msg
page model =
    Views.Page.view model pageWithData


pageWithData : Model -> Html Msg
pageWithData model =
    case model.route of
        HomeRoute ->
            Pages.Home.view model

        GroupRoute groupSlug ->
            case maybeGroup model.activities groupSlug of
                Just group ->
                    Pages.Group.view model group

                Nothing ->
                    Pages.NotFound.view

        TopicRoute groupSlug topicSlug ->
            case maybeTopic model.activities groupSlug topicSlug of
                ( Just group, Just topic ) ->
                    Pages.Topic.view model group topic

                _ ->
                    Pages.NotFound.view

        SectionRoute code cycle order ->
            let
                sectionIdentifier =
                    toSectionIdentifier code
                        (String.toInt cycle |> Maybe.withDefault 0)
                        (String.toInt order |> Maybe.withDefault 0)
                        Nothing
            in
            case maybeSection model.activities sectionIdentifier of
                Just section ->
                    Pages.Section.view model section

                _ ->
                    Pages.NotFound.view

        NotFoundRoute ->
            Pages.NotFound.view


maybeGroup : List Group -> Slug -> Maybe Group
maybeGroup list groupSlug =
    Data.Slugable.filter list groupSlug


maybeTopic : List Group -> Slug -> Slug -> ( Maybe Group, Maybe Topic )
maybeTopic list groupSlug topicSlug =
    case maybeGroup list groupSlug of
        Just group ->
            ( Just group
            , Data.Slugable.filter group.topics topicSlug
            )

        Nothing ->
            ( Nothing, Nothing )


maybeSection : List Group -> SectionIdentifier -> Maybe Section
maybeSection groups identifier =
    foldTopics groups
        |> List.foldr (\s a -> List.append a s.sections) []
        |> List.filter (\section -> section.identifier == identifier)
        |> List.head
