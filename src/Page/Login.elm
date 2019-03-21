module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, a, button, div, form, input, label, span, text)
import Html.Attributes exposing (class, href, id, name, placeholder, required, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData exposing (RemoteData(..), WebData)
import Request.PasswordLessAuth exposing (StartResponse, start, startByEmail)
import Session exposing (Session)
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
    ( initModel session
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
        , onSubmit ValidationRequested
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
                , onInput CodeEdited
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
    | Reset
    | ConnectionTypeSwitched ConnectionType
    | UsernameEdited String
    | EmailEdited String
    | PhoneEdited String
    | CodeEdited String
    | LoginRequested
    | ValidationRequested
    | LoginStarted (WebData StartResponse)


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

        CodeEdited code ->
            ( { model | code = Just code }, Cmd.none )

        LoginRequested ->
            case model.email of
                Nothing ->
                    ( model, Cmd.none )

                Just email_ ->
                    ( model
                    , start (startByEmail email_) |> Cmd.map LoginStarted
                    )

        LoginStarted response ->
            ( { model | step = ValidateCode response }
            , Cmd.none
            )

        ValidationRequested ->
            ( model, Cmd.none )

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
