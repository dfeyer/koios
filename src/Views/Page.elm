module Views.Page exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import I18Next exposing (t)
import Shared exposing (Model, Route(..))


view : Model -> (Model -> Html msg) -> Html msg
view model content =
    div [ class "content" ]
        [ pageHeader model
        , div [ class "content__main" ]
            [ content model
            ]
        , pageFooter model
        ]


navigation : Html.Html msg
navigation =
    ul [ class "main-menu" ]
        [ li [ class "main-menu__item" ]
            [ a [ class "main-menu__link", href "/" ]
                [ text "activités"
                ]
            ]
        , li [ class "main-menu__item" ]
            [ a [ class "main-menu__link", href "/plan" ]
                [ text "semainier"
                ]
            ]
        , li [ class "main-menu__item" ]
            [ a [ class "main-menu__link", href "/report" ]
                [ text "journal"
                ]
            ]
        , li [ class "main-menu__item" ]
            [ a [ class "main-menu__link", href "/agenda" ]
                [ text "calendrier"
                ]
            ]
        ]


pageHeader : Model -> Html.Html msg
pageHeader model =
    nav [ class "main-navigation", attribute "role" "navigation" ]
        [ div [ class "main-navigation__wrapper" ]
            [ a [ class "main-navigation__logo", href "/", id "logo-container" ]
                [ text "Carnet de bord" ]
            , navigation
            ]
        ]


pageFooter : Model -> Html msg
pageFooter model =
    footer [ class "page-footer" ]
        [ div [ class "page-footer__wrapper" ]
            [ div [ class "page-footer__columns" ]
                [ div [ class "page_footer__column" ]
                    [ h3 []
                        [ text "IHES-VD // Votre portfolio IHES" ]
                    , p []
                        [ text "Pour aider la communauté IHES en Suisse Romande, IHES-VD permet de faire un suivi des apprentissages et aide les parents à faire le pont entre leur mode d'apprentissage, leurs projets et le plan d'étude romand (PER). IHES-VD est une variante spécialisé pour la canton de vaud qui prend en compte quelques spécificités du plan d'étude cantonal." ]
                    ]
                , div [ class "page_footer__column" ]
                    [ h3 []
                        [ text "Apprendre" ]
                    , ul [ class "stabylo-menu" ]
                        [ li [ class "stabylo-menu__item" ]
                            [ a [ class "stabylo-menu__link", href "#!" ]
                                [ text "Comment utiliser ?" ]
                            ]
                        , li [ class "stabylo-menu__item" ]
                            [ a [ class "stabylo-menu__link", href "#!" ]
                                [ text "Pourquoi vous inscrire ?" ]
                            ]
                        , li [ class "stabylo-menu__item" ]
                            [ a [ class "stabylo-menu__link", href "#!" ]
                                [ text "Respect de la vie privée" ]
                            ]
                        , li [ class "stabylo-menu__item" ]
                            [ a [ class "stabylo-menu__link", href "#!" ]
                                [ text "Conditions générales" ]
                            ]
                        ]
                    ]
                , div [ class "page_footer__column" ]
                    [ h3 []
                        [ text "Communauté" ]
                    , ul [ class "stabylo-menu" ]
                        [ li [ class "stabylo-menu__item" ]
                            [ a [ class "stabylo-menu__link", href "#!" ]
                                [ text "Forum" ]
                            ]
                        , li [ class "stabylo-menu__item" ]
                            [ a [ class "stabylo-menu__link", href "#!" ]
                                [ text "Mastodon" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
