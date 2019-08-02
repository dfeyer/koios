module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api exposing (Cred, login, logout)
import Html exposing (Html, button, div, form, input, label, text)
import Html.Attributes exposing (class, id, name, required, type_)
import Html.Events exposing (onInput, onSubmit)
import RemoteData exposing (RemoteData(..), WebData)
import Request.Auth as Auth exposing (AuthResponse)
import Route
import Session exposing (Session, isLoggedIn)
import Viewer exposing (Viewer, viewer)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    , credentials : Maybe Credentials
    , isLoading : Bool
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
    , isLoading = False
    }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view ({ session } as model) =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            [ div [ class "login-form" ]
                (case isLoggedIn session of
                    False ->
                        viewLogin model

                    True ->
                        viewLogout model
                )
            ]
    }


viewLogin : Model -> List (Html Msg)
viewLogin ({ isLoading } as model) =
    [ div [ class "login-form__wrapper" ]
        (case isLoading of
            True ->
                [ waitingView model ]

            False ->
                [ loginView model ]
        )
    ]


viewLogout : Model -> List (Html Msg)
viewLogout _ =
    -- todo implement user profile
    [ form
        [ class "login-form__form"
        , onSubmit LogoutRequested
        ]
        [ div [ class "form__actions" ]
            [ button
                [ class "form__button"
                ]
                [ text "Se déconnecter" ]
            ]
        ]
    ]


waitingView : Model -> Html Msg
waitingView _ =
    div [] [ text "Merci de patienter quelques instants..." ]


loginView : Model -> Html Msg
loginView _ =
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
                [ text "La plateforme est en version beta sur invitation, vous pouvez nous demander un accès en nous envoyant un courriel." ]
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
    | LogoutRequested
    | LoginRequested
    | LoginCompleted (WebData Cred)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) (Route.Learning Nothing)
            )

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
                    ( { model | isLoading = True }
                    , login LoginCompleted (Auth.authParameters username password)
                    )

                Nothing ->
                    ( model, Cmd.none )

        LoginCompleted (Success cred) ->
            ( { model | isLoading = False }
            , Viewer.store (viewer cred)
            )

        -- todo implement error handling
        LoginCompleted _ ->
            ( { model | isLoading = False }
            , Cmd.none
            )

        LogoutRequested ->
            ( model
            , logout
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
