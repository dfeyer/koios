module Page.FamilyProfile exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import RemoteData exposing (RemoteData, WebData)
import Request.Family exposing (FamiliyProfileRemoteData, Family, loadFamilyProfile)
import Session exposing (Session)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    , family : FamiliyProfileRemoteData
    }



-- TYPES
-- INIT


init : Session -> ( Model, Cmd Msg )
init session =
    ( initModel session
    , loadFamilyProfile session ProfileLoaded
    )


initModel : Session -> Model
initModel session =
    { session = session
    , family = RemoteData.NotAsked
    }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view ({ family } as model) =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            [ div [ class "login-form" ]
                (case family of
                    RemoteData.NotAsked ->
                        viewLoading

                    RemoteData.Loading ->
                        viewLoading

                    RemoteData.Failure _ ->
                        viewError

                    RemoteData.Success { name } ->
                        [ div [ class "login-form__wrapper-large" ]
                            [ mainHeaderView (text (Maybe.withDefault "" name))
                            ]
                        ]
                )
            ]
    }


viewLoading : List (Html Msg)
viewLoading =
    [ div [ class "login-form__wrapper-large" ] [ text "Chargement du profile en cours..." ]
    ]


viewError : List (Html Msg)
viewError =
    [ div [ class "login-form__wrapper-large" ] [ text "Oups, désolé impossible de traiter votre demande actuellement." ]
    ]



-- UPDATE


type Msg
    = NoOp
    | GotSession Session
    | ProfileLoaded FamiliyProfileRemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        GotSession _ ->
            ( model
            , Cmd.none
            )

        ProfileLoaded response ->
            ( { model | family = response }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
