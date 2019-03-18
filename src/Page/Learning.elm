module Page.Learning exposing (Model, Msg, init, subscriptions, toSession, update, view)

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
    { title = "Title"
    , content =
        div []
            [ mainHeaderView (text "Activités")
            , case model.position of
                Nothing ->
                    rowView [ collectionView model.learnings goToGroup groupTitle ]

                Just position ->
                    case position of
                        ( groupPosition, Nothing ) ->
                            case groupPosition of
                                ( group, Nothing ) ->
                                    viewPosition
                                        (topicByGroup model.learnings group)
                                        (goToTopic group)
                                        topicTitle

                                ( group, Just topic ) ->
                                    viewPosition
                                        (sectionByTopic model.learnings group topic)
                                        (goToSection group topic)
                                        sectionTitle

                        ( ( group, Just topic ), Just sectionPosition ) ->
                            case sectionPosition of
                                ( section, Nothing ) ->
                                    viewPosition
                                        (targetBySection model.learnings group topic section)
                                        (goToTarget group topic section)
                                        targetTitle

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


viewError : Html msg
viewError =
    div [] [ text "TODO Handle error" ]


groupTitle : Group -> Html msg
groupTitle group =
    span [ class "label" ] [ text (Data.Group.toNavigationTitle group) ]


topicTitle : Topic -> Html msg
topicTitle topic =
    span [ class "label" ] [ text (Data.Topic.toNavigationTitle topic) ]


sectionTitle : Section -> Html msg
sectionTitle section =
    span [ class "label" ] [ text (Data.Section.toNavigationTitle section) ]


targetTitle : SlugableTarget -> Html msg
targetTitle target =
    span [ class "label" ] [ text (Data.Target.toNavigationTitle (Data.Target.fromSlugableTarget target)) ]


topicByGroup : List Group -> Group -> Maybe (List Topic)
topicByGroup learnings group =
    case
        List.filter (\g -> g.id == group.id) learnings
            |> List.head
    of
        Just group_ ->
            Just group_.topics

        Nothing ->
            Nothing


sectionByTopic : List Group -> Group -> Topic -> Maybe (List Section)
sectionByTopic learnings group topic =
    case topicByGroup learnings group of
        Just topics ->
            case
                List.filter (\t -> t.id == topic.id) topics
                    |> List.head
            of
                Just topic_ ->
                    Just topic_.sections

                Nothing ->
                    Nothing

        Nothing ->
            Nothing


targetBySection : List Group -> Group -> Topic -> Section -> Maybe (List SlugableTarget)
targetBySection learnings group topic section =
    case sectionByTopic learnings group topic of
        Just sections ->
            case
                List.filter (\s -> s.id == section.id) sections
                    |> List.head
            of
                Just section_ ->
                    Just (List.map Data.Target.toSlugableTarget section_.targets)

                Nothing ->
                    Nothing

        Nothing ->
            Nothing



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
    GotPosition ( ( group, Just topic ), Just ( section, Just (Data.Target.fromSlugableTarget target) ) )


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
