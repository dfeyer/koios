module Page.FamilyProfile exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Session exposing (Session)



-- MODEL


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( initModel session
    , Cmd.none
    )


initModel : Session -> Model
initModel session =
    { session = session
    }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view ({ session } as model) =
    { title = "Connexion | Mon carnet de board IHES"
    , content =
        div []
            [ div [ class "login-form" ]
                [ div [ class "login-form__wrapper-large" ] [ text "User Profile" ]
                ]
            ]
    }



-- UPDATE


type Msg
    = NoOp
    | GotSession Session


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
