module Page.Learning exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.Group as Group exposing (Group, Section, Target, Topic)
import Data.Section as Section
import Data.Slugable exposing (Slugable, collectionView, compactCollectionView)
import Data.Target as Target exposing (SlugableTarget)
import Data.Topic as Topic
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Session exposing (Session)
import Views.Breadcrumb as Breadcrumb
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


init : Session -> List Group -> ( Model, Cmd Msg )
init session learnings =
    ( { session = session
      , learnings = learnings
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
                    viewLearnings model.learnings

                Just position ->
                    case position of
                        ( groupPosition, Nothing ) ->
                            case groupPosition of
                                ( group, Nothing ) ->
                                    viewGroup model.learnings group

                                ( group, Just topic ) ->
                                    viewTopic model.learnings group topic

                        ( ( group, Just topic ), Just sectionPosition ) ->
                            case sectionPosition of
                                ( section, Nothing ) ->
                                    viewSection model.learnings group topic section

                                ( section, Just target ) ->
                                    viewTarget group topic section target

                        _ ->
                            [ viewError ]
            )
    }


viewLearnings : List Group -> List (Html Msg)
viewLearnings learnings =
    [ mainHeaderView (text "Apprentissages")
    , rowView [ collectionView learnings goToGroup Group.toHtml ]
    ]


viewGroup : List Group -> Group -> List (Html Msg)
viewGroup learnings group =
    [ mainHeaderWithChapterView
        groupBreadcrumbView
        (text (Group.toString group))
    , viewPosition
        (Topic.topicByGroup learnings group)
        (goToTopic group)
        Topic.toHtml
    ]


viewTopic : List Group -> Group -> Topic -> List (Html Msg)
viewTopic learnings group topic =
    [ mainHeaderWithChapterView
        (topicBreadcrumbView group)
        (text (Topic.toString topic))
    , viewPositionCompact
        (Section.sectionByTopic learnings group topic)
        (goToSection group topic)
        Section.toHtml
    ]


viewSection : List Group -> Group -> Topic -> Section -> List (Html Msg)
viewSection learnings group topic section =
    [ mainHeaderWithChapterView
        (sectionBreadcrumbView group topic)
        (text (Section.toString section))
    , viewPositionCompact
        (Target.targetBySection learnings group topic section)
        (goToTarget group topic section)
        Target.toHtml
    ]


viewTarget : Group -> Topic -> Section -> Target -> List (Html Msg)
viewTarget group topic section target =
    [ mainHeaderWithChapterView
        (sectionBreadcrumbView group topic)
        (text (Section.toString section))
    , div [ class "teaser" ] [ text (Target.toString target) ]
    ]


groupBreadcrumbView : Html Msg
groupBreadcrumbView =
    Breadcrumb.view
        [ ( GotRoot, "Apprentissages" )
        ]


topicBreadcrumbView : Group -> Html Msg
topicBreadcrumbView group =
    Breadcrumb.view
        [ ( GotRoot, "Apprentissages" )
        , ( GotPosition ( ( group, Nothing ), Nothing ), Group.toString group )
        ]


sectionBreadcrumbView : Group -> Topic -> Html Msg
sectionBreadcrumbView group topic =
    Breadcrumb.view
        [ ( GotRoot, "Apprentissages" )
        , ( GotPosition ( ( group, Nothing ), Nothing ), Group.toString group )
        , ( GotPosition ( ( group, Just topic ), Nothing ), Topic.toString topic )
        ]


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
