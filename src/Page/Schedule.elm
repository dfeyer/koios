module Page.Schedule exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h2, h3, text)
import Html.Attributes exposing (class)
import Session exposing (Session)
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
                viewWeekDay
                days
        )


viewHourLabel : Int -> Html Msg
viewHourLabel start =
    div
        [ class "hour__label"
        , Html.Attributes.attribute "style" ("--start: " ++ String.fromInt start ++ "; --end: " ++ String.fromInt (start + 1) ++ ";")
        ]
        [ text (String.fromInt (start + 1) ++ ":00") ]


viewWeekDay : ( String, String ) -> Html Msg
viewWeekDay label =
    div [ class "week week--vertical" ]
        [ Day.labelView label
        , Event.timedView 10 11 "Mathématique"
        , Event.timedView 15 18 "Menuiserie"
        , Event.timedView 20 21 "Lecture"
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
