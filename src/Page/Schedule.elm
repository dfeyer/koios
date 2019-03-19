module Page.Schedule exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, span, text)
import Session exposing (Session)
import Views.Layout exposing (mainHeaderView)



-- MODEL


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Semainer | Mon carnet de board IHES"
    , content =
        div []
            [ mainHeaderView (text "Semainier")
            ]
    }



-- UPDATE


type Msg
    = GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
