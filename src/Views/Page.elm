module Views.Page exposing (Page(..), view)

import Browser exposing (Document)
import Components.MainMenu
import Components.StabyloMenu
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route(..), positionToRoute)
import Viewer exposing (Viewer)
import Views.Helpers exposing (ihes)


{-| Determines which navbar link (if any) will be rendered as active.
Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.
-}
type Page
    = Other
    | Learning
    | Schedule
    | Diary
    | Calendar
    | Login


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view _ page { title, content } =
    { title = title
    , body =
        [ pageWrapper
            [ pageHeader page
            , progress
            , contentWrapper
                [ content
                ]
            , pageFooter
            ]
        ]
    }


progress : Html msg
progress =
    div [ class "progress" ] [ div [] [] ]


pageWrapper : List (Html msg) -> Html msg
pageWrapper =
    div [ class "content" ]


contentWrapper : List (Html msg) -> Html msg
contentWrapper =
    div [ class "content__main" ]


navigation : Page -> Html.Html msg
navigation page =
    Components.MainMenu.view
        [ ( text "Apprentissages", positionToRoute Nothing )
        , ( text "Semainier", Route.Schedule )
        , ( text "Journal", Route.Diary )
        , ( text "Calendrier", Route.Calendar )
        , ( text "Connexion", Route.Login )
        ]


pageHeader : Page -> Html.Html msg
pageHeader page =
    nav [ class "main-navigation", attribute "role" "navigation" ]
        [ div [ class "main-navigation__wrapper" ]
            [ a [ class "main-navigation__logo", Route.href (positionToRoute Nothing), id "logo-container" ]
                [ text "Carnet de bord" ]
            , navigation page
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


pageFooter : Html msg
pageFooter =
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
