module Page.Diary exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Group
import Data.Section
import Data.Slugable exposing (collectionView)
import Data.Target
import Data.Topic
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Http
import Session exposing (Session)
import Shared exposing (Group, Section, Slugable, SlugableTarget, Target, Topic)
import Views.Layout exposing (mainHeaderView, rowView)



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
    { title = "Journal | Mon carnet de bord IHES"
    , content =
        div []
            [ mainHeaderView (text "Journal")
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
