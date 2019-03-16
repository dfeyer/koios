module Views.Page exposing (view)

import Components.GoToTop
import Components.MainMenu
import Components.StabyloMenu
import Html exposing (..)
import Html.Attributes exposing (..)
import Shared exposing (Model, Route(..))
import Views.Helpers exposing (ihes)


view : Model -> (Model -> Html msg) -> Html msg
view model content =
    div [ class "content" ]
        [ pageHeader model
        , div [ class "content__main" ]
            [ content model
            ]
        , pageFooter model
        , Components.GoToTop.view
        ]


navigation : Html.Html msg
navigation =
    Components.MainMenu.view
        [ ( text "Apprentissages", "/" )
        , ( text "Semainier", "/plan" )
        , ( text "Journal", "/report" )
        , ( text "Calendrier", "/agenda" )
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


footerHelpResources : Html msg
footerHelpResources =
    div [ class "page_footer__column" ]
        [ h3 []
            [ text "Apprendre" ]
        , Components.StabyloMenu.view
            [ ( text "Comment utiliser ?", "#!" )
            , ( text "Pourquoi vous inscrire ?", "#!" )
            , ( text "Respect de la vie privée?", "#!" )
            , ( text "Conditions générales", "#!" )
            ]
        ]


footerSocialResources : Html msg
footerSocialResources =
    div [ class "page_footer__column" ]
        [ h3 []
            [ text "Communauté" ]
        , Components.StabyloMenu.view
            [ ( text "Forum", "#!" )
            , ( text "Mastodon", "#!" )
            ]
        ]


pageFooter : Model -> Html msg
pageFooter model =
    footer [ class "page-footer" ]
        [ div [ class "page-footer__wrapper" ]
            [ div [ class "page-footer__columns" ]
                [ div [ class "page_footer__column" ]
                    [ h3 []
                        [ text "Carnet de bord IHES"
                        ]
                    , p []
                        [ text "Pour aider la communauté "
                        , ihes
                        , text " en Suisse Romande, le collectif "
                        , ihes
                        , text " en collaboration avec IEL Vaud développe un outil permettant de faire un suivi des apprentissages et aide les parents à faire le pont entre leur mode d'apprentissage, leurs projets et le plan d'étude romand (PER)."
                        ]
                    ]
                , footerHelpResources
                , footerSocialResources
                ]
            ]
        ]
