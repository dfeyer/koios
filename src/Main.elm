module Main exposing (init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import I18Next
    exposing
        ( Delims(..)
        , Translations
        , fetchTranslations
        , initialTranslations
        , t
        , tr
        )
import Pages.Home
import Routes exposing (..)
import Shared exposing (..)
import Url



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
    , sections : List Section
    }


type alias TranslationFlags =
    { fr : String
    }



-- INIT


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init { translations } url key =
    let
        currentRoute =
            Routes.parseUrl url
    in
    ( initialModel currentRoute key
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
    let
        content =
            case model.sections of
                NotAsked ->
                    text ""

                Loading ->
                    text (t model.translations "loadingInProgress")

                Loaded players ->
                    pageWithData model players

                Failure ->
                    text (t model.translations "error.general")
    in
    section []
        [ nav model
        , div [ class "p-4" ] [ content ]
        ]


pageWithData : Model -> List String -> Html Msg
pageWithData model sections =
    case model.route of
        HomeRoute ->
            Pages.Home.view sections

        NotFoundRoute ->
            notFoundView


nav : Model -> Html Msg
nav model =
    let
        links =
            case model.route of
                HomeRoute ->
                    [ text (t model.translations "title.home") ]

                NotFoundRoute ->
                    [ text (t model.translations "error.notFound")
                    ]
    in
    div
        []
        links


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
