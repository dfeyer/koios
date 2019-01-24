module Main exposing (init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import I18Next
    exposing
        ( Delims(..)
        , Translations
        , fetchTranslations
        , t
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
    div []
        [ pageHeader model
        , pageWithData model
        , pageFooter model
        ]


pageWithData : Model -> Html Msg
pageWithData model =
    case model.route of
        HomeRoute ->
            Pages.Home.view model

        NotFoundRoute ->
            notFoundView


icon : String -> Html Msg
icon name =
    i [ class "material-icons" ] [ text name ]


leftIcon : String -> Html Msg
leftIcon name =
    i [ class "material-icons left" ] [ text name ]


pageHeader : Model -> Html.Html Msg
pageHeader model =
    let
        links =
            case model.route of
                HomeRoute ->
                    [ ( text (t model.translations "title.home"), '#' )
                    ]

                NotFoundRoute ->
                    [ ( text (t model.translations "error.notFound"), '#' )
                    ]
    in
    nav [ class "blue-grey", attribute "role" "navigation" ]
        [ div [ class "nav-wrapper container" ]
            [ a [ class "brand-logo right", href "#", id "logo-container" ]
                [ icon "forum", text "koios" ]
            , ul [ class "left hide-on-med-and-down" ]
                [ li []
                    [ a [ href "#" ]
                        [ leftIcon "list_alt"
                        , text "plan d'étude"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ leftIcon "view_week"
                        , text "semainier"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ leftIcon "view_list"
                        , text "journal"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ leftIcon "view_agenda"
                        , text "calendrier"
                        ]
                    ]
                ]
            , ul [ class "sidenav", id "nav-mobile" ]
                [ li []
                    [ a [ href "#" ]
                        [ leftIcon "list_alt"
                        , text "plan d'étude"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ leftIcon "view_week"
                        , text "semainier"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ leftIcon "view_list"
                        , text "journal"
                        ]
                    ]
                , li []
                    [ a [ href "#" ]
                        [ leftIcon "view_agenda"
                        , text "calendrier"
                        ]
                    ]
                ]
            , a [ class "sidenav-trigger", attribute "data-target" "nav-mobile", href "#" ]
                [ i [ class "material-icons" ]
                    [ text "menu" ]
                ]
            ]
        ]


pageFooter : Model -> Html Msg
pageFooter model =
    footer [ class "page-footer blue-grey lighten-1" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col l6 s12" ]
                    [ h5 [ class "white-text" ]
                        [ text "IHES-VD // Votre portfolio IHES" ]
                    , p [ class "grey-text text-lighten-4" ]
                        [ text "Pour aider la communauté IHES en Suisse Romande, IHES-VD permet de faire un suivi des apprentissages et aide les parents à faire le pont entre leur mode d'apprentissage, leurs projets et le plan d'étude romand (PER). IHES-VD est une variante spécialisé pour la canton de vaud qui prend en compte quelques spécificités du plan d'étude cantonal." ]
                    ]
                , div [ class "col l3 s12" ]
                    [ h5 [ class "white-text" ]
                        [ text "Apprendre" ]
                    , ul []
                        [ li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Comment utiliser ?" ]
                            ]
                        , li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Pourquoi vous inscrire ?" ]
                            ]
                        , li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Respect de la vie privée" ]
                            ]
                        , li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Conditions générales" ]
                            ]
                        ]
                    ]
                , div [ class "col l3 s12" ]
                    [ h5 [ class "white-text" ]
                        [ text "Connect" ]
                    , ul []
                        [ li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Forum IEF/Romandie" ]
                            ]
                        , li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Portail IEL" ]
                            ]
                        , li []
                            [ a [ class "white-text", href "#!" ]
                                [ text "Mastondon" ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "footer-copyright" ]
            [ div [ class "container" ]
                [ text "Design & développement par "
                , a [ class "orange-text text-lighten-3", href "#" ]
                    [ text "Dominique Feyer" ]
                ]
            ]
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
