module Page.Calendar exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h3, span, text)
import Html.Attributes exposing (class)
import Session exposing (Session)
import Views.Event as Event
import Views.Layout exposing (mainHeaderWithChapterView)



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
    { title = "Calendrier | Mon carnet de board IHES"
    , content =
        div []
            [ mainHeaderWithChapterView (text "Calendrier") (text "Mars")
            , div [ class "calendar" ]
                (List.map
                    dayView
                    (List.range 1 30)
                )
            ]
    }


weekView : List (Html Msg) -> Html Msg
weekView days =
    div [ class "week" ]
        days


dayView : Int -> Html Msg
dayView day =
    div [ class ("day" ++ " day--" ++ String.fromInt day) ]
        [ h3 [ class "day__label" ] [ text (String.fromInt day) ]
        , Event.view 10 11 "Mathématique"
        , Event.view 15 18 "Menuiserie"
        , Event.view 20 21 "Lecture"
        ]



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
