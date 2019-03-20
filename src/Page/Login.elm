module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, a, div, form, input, label, span, text)
import Html.Attributes exposing (class, href, id, name, placeholder, type_, value)
import Html.Events exposing (onClick)
import Session exposing (Session)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    , connectionType : ConnectionType
    }


type ConnectionType
    = ShortMessage
    | Phone


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , connectionType = ShortMessage
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            [ mainHeaderView (text "Connexion")
            , div [ class "login-form" ]
                [ form [ class "login-form__form" ]
                    [ label [ class "form__label" ]
                        [ text "Utilisateur"
                        , input
                            [ class "form__input"
                            , type_ "text"
                            , id "username"
                            , name "username"
                            ]
                            []
                        ]
                    , label [ class "form__label" ]
                        (case model.connectionType of
                            Phone ->
                                [ text "Numéro de téléphone"
                                , input
                                    [ class "form__input"
                                    , type_ "text"
                                    , id "username"
                                    , name "phone_number"
                                    , placeholder "+41 78 111 11 11"
                                    ]
                                    []
                                ]

                            ShortMessage ->
                                [ text "Courrier électronique"
                                , input
                                    [ class "form__input"
                                    , type_ "text"
                                    , id "email"
                                    , name "email"
                                    , placeholder "vous@fournisseur.com"
                                    ]
                                    []
                                ]
                        )
                    , div [ class "form__actions" ]
                        [ input [ class "form__button", type_ "submit", value "Se connecter" ] []
                        ]
                    , div [ class "form__subactions" ]
                        (case model.connectionType of
                            Phone ->
                                [ a [ class "form__subaction", href "#", onClick (ConnectionTypeSwitched ShortMessage) ] [ text "Connexion par courrier électronique ?" ]
                                ]

                            ShortMessage ->
                                [ a [ class "form__subaction", href "#", onClick (ConnectionTypeSwitched Phone) ] [ text "Connexion par SMS ?" ]
                                ]
                        )
                    ]
                ]
            ]
    }



-- UPDATE


type Msg
    = GotSession Session
    | ConnectionTypeSwitched ConnectionType


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ConnectionTypeSwitched connectionType ->
            ( { model | connectionType = connectionType }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
