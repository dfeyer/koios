module Page.Schedule exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, div, h2, span, text)
import Html.Attributes exposing (class)
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
            (List.concat
                [ [ mainHeaderView (text "Semainier")
                  ]
                , [ viewWeekList
                        [ "Lundi"
                        , "Mardi"
                        , "Mercredi"
                        , "Jeudi"
                        , "Vendredi"
                        ]
                  ]
                ]
            )
    }


viewWeekList : List String -> Html Msg
viewWeekList days =
    div [ class "schedule schedule--weekly" ]
        (List.map
            viewWeekDay
            days
        )


viewWeekDay : String -> Html Msg
viewWeekDay label =
    div [ class "week week--vertical" ]
        [ h2 [ class "week__label" ] [ text label ]
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
