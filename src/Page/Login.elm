module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api exposing (Cred)
import Html exposing (Html, a, button, div, form, input, label, span, text)
import Html.Attributes exposing (class, href, id, name, placeholder, required, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData exposing (RemoteData(..), WebData)
import Request.PasswordLessAuth as PasswordLessAuth exposing (StartResponse, VerifyResponse)
import Session exposing (Session)
import Viewer exposing (Viewer)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    , step : Step
    , connectionType : ConnectionType
    , username : Maybe String
    , email : Maybe String
    , phone : Maybe String
    , code : Maybe String
    }


type Step
    = Start
    | ValidateCode (WebData StartResponse)


type ConnectionType
    = Email
    | Phone


init : Session -> ( Model, Cmd Msg )
init session =
    ( initModel (Debug.log "Session" session)
    , Cmd.none
    )


initModel : Session -> Model
initModel session =
    { session = session
    , step = Start
    , connectionType = Email
    , username = Nothing
    , email = Nothing
    , phone = Nothing
    , code = Nothing
    }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            [ div [ class "login-form" ]
                [ stepSelectorView model ]
            ]
    }


stepSelectorView : Model -> Html Msg
stepSelectorView model =
    div [ class "login-form__wrapper" ]
        (case model.step of
            Start ->
                [ loginView model
                ]

            ValidateCode response ->
                case response of
                    NotAsked ->
                        [ waitingView model
                        ]

                    Loading ->
                        [ waitingView model
                        ]

                    Failure error ->
                        [ waitingView model
                        ]

                    Success response_ ->
                        [ validateCodeView model
                        ]
        )


waitingView : Model -> Html Msg
waitingView model =
    div [] [ text "Merci de patienter quelques instants..." ]


validateCodeView : Model -> Html Msg
validateCodeView model =
    form
        [ class "login-form__form"
        , onSubmit RequestedValidation
        ]
        [ mainHeaderView (text "Connexion")
        , label [ class "form__label" ]
            [ text "Code validation"
            , input
                [ class "form__input"
                , type_ "text"
                , id "code"
                , name "code"
                , required True
                , onInput EnteredCode
                , value (model.code |> Maybe.withDefault "")
                ]
                []
            , div [ class "form__help" ]
                (case model.connectionType of
                    Phone ->
                        [ text "Vérifier vos SMS pour récupérer votre code de validation." ]

                    Email ->
                        [ text "Vérifier vos courriers électroniques pour récupérer votre code de validation." ]
                )
            ]
        , div [ class "form__actions" ]
            [ button
                [ class "form__button"
                ]
                [ text "Valider le code" ]
            ]
        , div [ class "form__subactions" ]
            [ a [ class "form__subaction", href "#", onClick Reset ] [ text "Envoyer un nouveau code?" ]
            ]
        ]


loginView : Model -> Html Msg
loginView model =
    form
        [ class "login-form__form"
        , onSubmit RequestedLogin
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
                        , onInput EnteredPhone
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
                        , onInput EnteredEmail
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
    | Reset
    | ConnectionTypeSwitched ConnectionType
    | UsernameEdited String
    | EnteredEmail String
    | EnteredPhone String
    | EnteredCode String
    | RequestedLogin
    | CompletedLogin (WebData StartResponse)
    | RequestedValidation
    | CompletedValidation String (WebData VerifyResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        ConnectionTypeSwitched connectionType ->
            ( { model | connectionType = connectionType }, Cmd.none )

        UsernameEdited username ->
            ( { model | username = Just username }, Cmd.none )

        EnteredEmail email ->
            ( { model | email = Just email }, Cmd.none )

        EnteredPhone phone ->
            ( { model | phone = Just phone }, Cmd.none )

        EnteredCode code ->
            ( { model | code = Just code }, Cmd.none )

        RequestedLogin ->
            case model.email of
                Just email_ ->
                    ( model
                    , PasswordLessAuth.start (PasswordLessAuth.startByEmail email_) |> Cmd.map CompletedLogin
                    )

                Nothing ->
                    -- TODO Handle missing email
                    ( model, Cmd.none )

        CompletedLogin response ->
            ( { model | step = ValidateCode response }
            , Cmd.none
            )

        RequestedValidation ->
            case ( model.email, model.code ) of
                ( Just email_, Just code_ ) ->
                    ( model, PasswordLessAuth.verify (PasswordLessAuth.verifyByEmail email_ code_) |> Cmd.map (CompletedValidation email_) )

                ( _, _ ) ->
                    -- TODO Handle missing email and/or code
                    ( model, Cmd.none )

        CompletedValidation email NotAsked ->
            ( model, Cmd.none )

        CompletedValidation email Loading ->
            ( model, Cmd.none )

        CompletedValidation email (Failure err) ->
            ( model, Cmd.none )

        CompletedValidation email (Success response) ->
            ( model
            , Viewer.store (Viewer.createViewer email response.idToken)
            )

        Reset ->
            init model.session



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
