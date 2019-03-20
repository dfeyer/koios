module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, a, button, div, form, input, label, span, text)
import Html.Attributes exposing (class, href, id, name, placeholder, required, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Session exposing (Session)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    , connectionType : ConnectionType
    , username : Maybe String
    , email : Maybe String
    , phone : Maybe String
    }


type ConnectionType
    = Email
    | Phone


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , connectionType = Email
      , username = Nothing
      , email = Nothing
      , phone = Nothing
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            [ div [ class "login-form" ]
                [ loginFormView model
                ]
            ]
    }


loginFormView : Model -> Html Msg
loginFormView model =
    form
        [ class "login-form__form"
        , onSubmit LoginRequested
        ]
        [ mainHeaderView (text "Connexion")
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
                        , required True
                        , onInput PhoneEdited
                        ]
                        []
                    , div [ class "form__help" ]
                        [ text "Si votre compte n'existe pas ce numéro de téléphone deviendra votre identifiant" ]
                    ]

                Email ->
                    [ text "Courrier électronique"
                    , input
                        [ class "form__input"
                        , type_ "text"
                        , id "email"
                        , name "email"
                        , placeholder "vous@fournisseur.com"
                        , required True
                        , onInput EmailEdited
                        ]
                        []
                    , div [ class "form__help" ]
                        [ text "Si votre compte n'existe pas cette adresse de courrier électronique deviendra votre identifiant" ]
                    ]
            )
        , div [ class "form__actions" ]
            [ button
                [ class "form__button"
                ]
                [ text "Se connecter" ]
            ]
        , div [ class "form__subactions" ]
            (case model.connectionType of
                Phone ->
                    [ a [ class "form__subaction", href "#", onClick (ConnectionTypeSwitched Email) ] [ text "Connexion par courrier électronique ?" ]
                    ]

                Email ->
                    [ a [ class "form__subaction", href "#", onClick (ConnectionTypeSwitched Phone) ] [ text "Connexion par SMS ?" ]
                    ]
            )
        ]



-- UPDATE


type Msg
    = GotSession Session
    | ConnectionTypeSwitched ConnectionType
    | UsernameEdited String
    | EmailEdited String
    | PhoneEdited String
    | LoginRequested


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ConnectionTypeSwitched connectionType ->
            ( { model | connectionType = connectionType }, Cmd.none )

        UsernameEdited username ->
            ( { model | username = Just username }, Cmd.none )

        EmailEdited email ->
            ( { model | email = Just email }, Cmd.none )

        PhoneEdited phone ->
            ( { model | phone = Just phone }, Cmd.none )

        LoginRequested ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
