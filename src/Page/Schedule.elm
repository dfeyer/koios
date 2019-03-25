module Page.Schedule exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Hour as Hour
import Html exposing (Html, div, h2, h3, text)
import Html.Attributes exposing (class)
import Session exposing (Session)
import Views.Calendar as Calendar
import Views.Day as Day
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
    { title = "Semainer | Mon carnet de board IHES"
    , content =
        div []
            (List.concat
                [ [ mainHeaderWithChapterView (text "Semainier") (text "1 mars au 31 mars 2019")
                  ]
                , [ viewWeekList
                        [ ( "Lundi", "1 mars 2019" )
                        , ( "Mardi", "2 mars 2019" )
                        , ( "Mercredi", "3 mars 2019" )
                        , ( "Jeudi", "4 mars 2019" )
                        , ( "Vendredi", "5 mars 2019" )
                        ]
                  ]
                ]
            )
    }


viewWeekList : List ( String, String ) -> Html Msg
viewWeekList days =
    div [ class "schedule schedule--weekly" ]
        (div
            [ class "week week--vertical" ]
            (List.map
                viewHourLabel
                (List.range 9 20)
            )
            :: List.map
                (viewWeekDay eventList)
                days
        )


type alias Event =
    { begin : Int
    , end : Int
    , preview : Html Msg
    }


createEvent : (Int -> Int -> Html Msg) -> Int -> Int -> Event
createEvent preview begin end =
    { begin = begin
    , end = end
    , preview = preview begin end
    }


eventList : List Event
eventList =
    [ createEvent Event.emptyView 9 10
    , createEvent (Event.timedView "Mathématique") 10 11
    , createEvent Event.emptyView 11 12
    , createEvent Event.emptyView 12 13
    , createEvent Event.emptyView 13 14
    , createEvent Event.emptyView 14 15
    , createEvent (Event.timedView "Menuiserie") 15 18
    , createEvent (Event.timedView "FEEL") 16 18
    , createEvent Event.emptyView 18 19
    , createEvent Event.emptyView 19 20
    , createEvent (Event.timedView "Lecture") 20 21
    ]


viewHourLabel : Int -> Html Msg
viewHourLabel start =
    div
        [ class "hour__label"
        , Calendar.hourInterval start
        ]
        [ text (Hour.toString start 0) ]


viewWeekDay : List Event -> ( String, String ) -> Html Msg
viewWeekDay events label =
    div [ class "week week--vertical" ]
        (List.concat
            [ [ Day.labelView label ]
            , List.map (\e -> e.preview) events
            ]
        )



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
