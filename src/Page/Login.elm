module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api exposing (Cred)
import Html exposing (Html, a, button, div, form, input, label, span, text)
import Html.Attributes exposing (class, href, id, name, placeholder, required, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData exposing (RemoteData(..), WebData)
import Request.PasswordLessAuth as PasswordLessAuth exposing (AuthResponse)
import Session exposing (Session)
import Viewer exposing (Viewer)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    , credentials : Maybe Credentials
    }


type alias Credentials =
    { username : String
    , password : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( initModel session
    , Cmd.none
    )


initModel : Session -> Model
initModel session =
    { session = session
    , credentials = Nothing
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
        [ loginView model ]


waitingView : Model -> Html Msg
waitingView model =
    div [] [ text "Merci de patienter quelques instants..." ]


loginView : Model -> Html Msg
loginView model =
    form
        [ class "login-form__form"
        , onSubmit LoginRequested
        ]
        [ mainHeaderView (text "Connexion")
        , label [ class "form__label" ]
            [ text "Nom d'utilisateur"
            , input
                [ class "form__input"
                , type_ "text"
                , id "username"
                , name "username"
                , required True
                , onInput UsernameEdited
                ]
                []
            , text "Mot de passe"
            , input
                [ class "form__input"
                , type_ "password"
                , id "password"
                , name "password"
                , required True
                , onInput PasswordEdited
                ]
                []
            , div [ class "form__help" ]
                [ text "Si votre compte n'existe pas ce numéro de téléphone deviendra votre identifiant" ]
            ]
        , div [ class "form__actions" ]
            [ button
                [ class "form__button"
                ]
                [ text "Se connecter" ]
            ]
        ]



-- UPDATE


type Msg
    = GotSession Session
    | Reset
    | UsernameEdited String
    | PasswordEdited String
    | LoginRequested
    | LoginCompleted (WebData AuthResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        UsernameEdited username ->
            case model.credentials of
                Just cred ->
                    ( { model | credentials = Just { cred | username = username } }, Cmd.none )

                Nothing ->
                    ( { model | credentials = Just (Credentials username "") }, Cmd.none )

        PasswordEdited password ->
            case model.credentials of
                Just cred ->
                    ( { model | credentials = Just { cred | password = password } }, Cmd.none )

                Nothing ->
                    ( { model | credentials = Just (Credentials "" password) }, Cmd.none )

        LoginRequested ->
            case model.credentials of
                Just { username, password } ->
                    ( model
                    , PasswordLessAuth.auth (PasswordLessAuth.authParameters username password) |> Cmd.map LoginCompleted
                    )

                Nothing ->
                    ( model, Cmd.none )

        LoginCompleted _ ->
            ( model
            , Cmd.none
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
