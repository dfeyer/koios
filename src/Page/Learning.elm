module Page.Learning exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Group as Group
import Data.Learnings as Learnings
import Data.Section as Section
import Data.Slugable exposing (collectionView, compactCollectionView)
import Data.Target as Target
import Data.Topic as Topic
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Session exposing (Session)
import Shared exposing (Group, Section, Slugable, SlugableTarget, Target, Topic)
import Views.Layout exposing (mainHeaderView, rowView)



-- MODEL


type alias Model =
    { session : Session
    , learnings : List Group
    , position : Maybe Position
    }


type alias Position =
    ( GroupPosition, Maybe SectionPosition )


type alias GroupPosition =
    ( Group, Maybe Topic )


type alias SectionPosition =
    ( Section, Maybe Target )


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , learnings = Session.learningList session
      , position = Nothing
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Apprentissages | Mon carnet de bord IHES"
    , content =
        div []
            [ mainHeaderView (text "Apprentissages")
            , case model.position of
                Nothing ->
                    rowView [ collectionView model.learnings goToGroup Group.toHtml ]

                Just position ->
                    case position of
                        ( groupPosition, Nothing ) ->
                            case groupPosition of
                                ( group, Nothing ) ->
                                    viewPosition
                                        (Learnings.topicByGroup model.learnings group)
                                        (goToTopic group)
                                        Topic.toHtml

                                ( group, Just topic ) ->
                                    viewPositionCompact
                                        (Learnings.sectionByTopic model.learnings group topic)
                                        (goToSection group topic)
                                        Section.toHtml

                        ( ( group, Just topic ), Just sectionPosition ) ->
                            case sectionPosition of
                                ( section, Nothing ) ->
                                    viewPositionCompact
                                        (Learnings.targetBySection model.learnings group topic section)
                                        (goToTarget group topic section)
                                        Target.toHtml

                                ( section, Just target ) ->
                                    div [] [ text "TODO Target detail" ]

                        _ ->
                            viewError

            -- , rowView [ collectionView model.learnings Data.Group.toSlug titleView ]
            ]
    }


viewPosition : Maybe (List (Slugable a)) -> (Slugable a -> msg) -> (Slugable a -> Html msg) -> Html msg
viewPosition list msg toTitle =
    case list of
        Just c ->
            rowView [ collectionView c msg toTitle ]

        Nothing ->
            viewError


viewPositionCompact : Maybe (List (Slugable a)) -> (Slugable a -> msg) -> (Slugable a -> Html msg) -> Html msg
viewPositionCompact list msg toTitle =
    case list of
        Just c ->
            rowView [ compactCollectionView c msg toTitle ]

        Nothing ->
            viewError


viewError : Html msg
viewError =
    div [] [ text "TODO Handle error" ]



-- UPDATE


type Msg
    = GotSession Session
    | GotPosition Position


goToGroup : Group -> Msg
goToGroup group =
    GotPosition ( ( group, Nothing ), Nothing )


goToTopic : Group -> Topic -> Msg
goToTopic group topic =
    GotPosition ( ( group, Just topic ), Nothing )


goToSection : Group -> Topic -> Section -> Msg
goToSection group topic section =
    GotPosition ( ( group, Just topic ), Just ( section, Nothing ) )


goToTarget : Group -> Topic -> Section -> SlugableTarget -> Msg
goToTarget group topic section target =
    GotPosition ( ( group, Just topic ), Just ( section, Just (Target.fromSlugableTarget target) ) )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        GotPosition position ->
            ( { model | position = Just position }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
