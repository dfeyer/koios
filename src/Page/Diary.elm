module Page.Diary exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, article, div, footer, h1, h2, header, section, span, text)
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
    { title = "Journal | Mon carnet de board IHES"
    , content =
        div []
            [ mainHeaderView (text "Journal")
            , section [ class "feed" ]
                [ feedItemView [ text "..." ]
                , feedItemView [ text "..." ]
                , feedItemView [ text "..." ]
                ]
            ]
    }


feedItemView : List (Html msg) -> Html msg
feedItemView content =
    article [ class "feed-item" ]
        [ header [ class "feed-item__header" ]
            [ h2 [ class "feed-item__headline" ] [ text "Samedi, 23 mars 2019" ] ]
        , div [ class "feed-item__content" ] content
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
