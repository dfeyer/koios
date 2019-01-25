module Views.Page exposing (view)

import Helper.Icon exposing (icon, leftIcon)
import Html exposing (..)
import Html.Attributes exposing (..)
import I18Next exposing (t)
import Shared exposing (Model, Route(..))

view : Model -> (Model -> Html msg) -> Html msg
view model content =
    div []
        [ pageHeader model
        , content model
        , pageFooter model
        ]

navigation : List (Html.Html msg)
navigation =
    [ li []
        [ a [ href "/" ]
            [ leftIcon "list_alt"
            , text "activités"
            ]
        ]
    , li []
        [ a [ href "/plan" ]
            [ leftIcon "view_week"
            , text "semainier"
            ]
        ]
    , li []
        [ a [ href "/report" ]
            [ leftIcon "view_list"
            , text "journal"
            ]
        ]
    , li []
        [ a [ href "/agenda" ]
            [ leftIcon "view_agenda"
            , text "calendrier"
            ]
        ]
    ]

pageHeader : Model -> Html.Html msg
pageHeader model =
    nav [ class "blue-grey", attribute "role" "navigation" ]
        [ div [ class "nav-wrapper container" ]
            [ a [ class "brand-logo right", href "#", id "logo-container" ]
                [ icon "forum", text "koios" ]
            , ul [ class "left hide-on-med-and-down" ] navigation
            , ul [ class "sidenav", id "nav-mobile" ] navigation
            , a [ class "sidenav-trigger", attribute "data-target" "nav-mobile", href "#" ]
                [ i [ class "material-icons" ]
                    [ text "menu" ]
                ]
            ]
        ]


pageFooter : Model -> Html msg
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
