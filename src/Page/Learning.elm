module Page.Learning exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Group as Group
import Data.Learnings as Learnings
import Data.Section as Section
import Data.Slugable exposing (collectionView, compactCollectionView)
import Data.Target as Target
import Data.Topic as Topic
import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Session exposing (Session)
import Shared exposing (Group, Section, Slugable, SlugableTarget, Target, Topic)
import Views.Layout exposing (mainHeaderView, mainHeaderWithChapterView, rowView)



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
            (case model.position of
                Nothing ->
                    [ mainHeaderView (text "Apprentissages")
                    , rowView [ collectionView model.learnings goToGroup Group.toHtml ]
                    ]

                Just position ->
                    case position of
                        ( groupPosition, Nothing ) ->
                            case groupPosition of
                                ( group, Nothing ) ->
                                    [ mainHeaderWithChapterView
                                        groupBreadcrumb
                                        (text (Group.toString group))
                                    , viewPosition
                                        (Learnings.topicByGroup model.learnings group)
                                        (goToTopic group)
                                        Topic.toHtml
                                    ]

                                ( group, Just topic ) ->
                                    [ mainHeaderWithChapterView
                                        (topicBreadcrumb group)
                                        (text (Topic.toString topic))
                                    , viewPositionCompact
                                        (Learnings.sectionByTopic model.learnings group topic)
                                        (goToSection group topic)
                                        Section.toHtml
                                    ]

                        ( ( group, Just topic ), Just sectionPosition ) ->
                            case sectionPosition of
                                ( section, Nothing ) ->
                                    [ mainHeaderWithChapterView
                                        (sectionBreadcrumb group topic)
                                        (text (Section.toString section))
                                    , viewPositionCompact
                                        (Learnings.targetBySection model.learnings group topic section)
                                        (goToTarget group topic section)
                                        Target.toHtml
                                    ]

                                ( section, Just target ) ->
                                    [ mainHeaderWithChapterView
                                        (sectionBreadcrumb group topic)
                                        (text (Section.toString section))
                                    , div [ class "teaser" ] [ text (Target.toString target) ]
                                    ]

                        _ ->
                            [ viewError ]
            )
    }


groupBreadcrumb : Html Msg
groupBreadcrumb =
    breadcrumb
        [ ( Nothing, "Apprentissages" )
        ]


topicBreadcrumb : Group -> Html Msg
topicBreadcrumb group =
    breadcrumb
        [ ( Nothing, "Apprentissages" )
        , ( Just ( ( group, Nothing ), Nothing ), Group.toString group )
        ]


sectionBreadcrumb : Group -> Topic -> Html Msg
sectionBreadcrumb group topic =
    breadcrumb
        [ ( Nothing, "Apprentissages" )
        , ( Just ( ( group, Nothing ), Nothing ), Group.toString group )
        , ( Just ( ( group, Just topic ), Nothing ), Topic.toString topic )
        ]


breadcrumb : List ( Maybe Position, String ) -> Html Msg
breadcrumb items =
    items
        |> List.map
            (\( p, l ) ->
                case p of
                    Just p_ ->
                        a [ href "#", onClick (GotPosition p_) ] [ text l ]

                    Nothing ->
                        a [ href "#", onClick GotRoot ] [ text l ]
            )
        |> span [ class "breadcrumb" ]


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
    | GotRoot
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

        GotRoot ->
            ( { model | position = Nothing }, Cmd.none )

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
