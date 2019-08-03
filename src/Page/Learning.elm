module Page.Learning exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Browser.Dom exposing (Viewport)
import Browser.Events exposing (onKeyDown, onKeyUp, onResize)
import Components.ActivityList as ActivityList
import Components.ContentArea as ContentArea
import Data.Activity as Activity exposing (Activity)
import Data.Group as Group exposing (Group, Position, Section, Target, Topic)
import Data.Section as Section
import Data.Slugable exposing (Slugable, collectionView, compactCollectionView)
import Data.Target as Target exposing (SlugableTarget)
import Data.Topic as Topic
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Route exposing (positionToRoute)
import Session exposing (Session)
import Task
import Views.Breadcrumb as Breadcrumb
import Views.Layout exposing (mainHeaderView, mainHeaderWithChapterView, rowView)



-- MODEL


type alias Model =
    { session : Session
    , learnings : List Group
    , position : Maybe Position
    , activity : Maybe Activity
    , viewport : Maybe ( Float, Float )
    }


init : Session -> List Group -> Maybe String -> ( Model, Cmd Msg )
init session learnings maybePath =
    let
        v =
            Browser.Dom.getViewport
    in
    ( { session = session
      , learnings = learnings
      , position = Route.pathToPosition learnings maybePath
      , activity = Nothing
      , viewport = Nothing
      }
    , Task.perform GotViewport Browser.Dom.getViewport
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
    , let
        targets =
            Target.targetBySection learnings group topic section
      in
      viewPositionCompact
        targets
        (goToTarget group topic section)
        Target.toHtml
    ]


viewTarget : Group -> Topic -> Section -> Target -> List (Html Msg)
viewTarget group topic section target =
    [ mainHeaderWithChapterView
        (sectionBreadcrumbView group topic)
        (text (Section.toString section))
    , div [ class "teaser" ] [ text (Target.toString target) ]
    , viewDetail
    ]


viewDetail : Html Msg
viewDetail =
    ContentArea.view
        [ ContentArea.infoBox
            [ ContentArea.primaryTitle "Introduction"
            , ContentArea.introduction "Ut suscipit sit amet ex sit amet ultricies. Sed nisl sem, mattis vitae nunc eu, accumsan blandit augue. Nunc interdum arcu id consectetur pellentesque. Nullam lectus ex, sodales dignissim porta sit amet, pharetra ultrices ex. Proin non facilisis enim. Donec ornare commodo ante, et sagittis mauris euismod vel. Ut convallis sit amet lorem quis euismod. Aenean accumsan consequat diam, nec ultrices nunc fermentum a. Donec sagittis magna nec tincidunt condimentum. In tempor malesuada dignissim. Vestibulum ultricies eu ipsum eu suscipit. Suspendisse convallis nisi id mollis tincidunt. Curabitur venenatis, libero id ultricies blandit, metus arcu sodales ligula, sit amet laoreet nisl ligula eu leo. Aenean pharetra lacinia tortor, a sagittis tellus mattis vitae."
            ]
        , ContentArea.infoBox
            [ ContentArea.secondaryTitle "Objectifs & pédagogie"
            , ContentArea.paragraph "Ut suscipit sit amet ex sit amet ultricies. Sed nisl sem, mattis vitae nunc eu, accumsan blandit augue. Nunc interdum arcu id consectetur pellentesque. Nullam lectus ex, sodales dignissim porta sit amet, pharetra ultrices ex. Proin non facilisis enim. Donec ornare commodo ante, et sagittis mauris euismod vel. Ut convallis sit amet lorem quis euismod. Aenean accumsan consequat diam, nec ultrices nunc fermentum a. Donec sagittis magna nec tincidunt condimentum. In tempor malesuada dignissim. Vestibulum ultricies eu ipsum eu suscipit. Suspendisse convallis nisi id mollis tincidunt. Curabitur venenatis, libero id ultricies blandit, metus arcu sodales ligula, sit amet laoreet nisl ligula eu leo. Aenean pharetra lacinia tortor, a sagittis tellus mattis vitae."
            , ContentArea.ternaryTitle "Objectifs"
            , ContentArea.paragraph "Ut suscipit sit amet ex sit amet ultricies. Sed nisl sem, mattis vitae nunc eu, accumsan blandit augue. Nunc interdum arcu id consectetur pellentesque. Nullam lectus ex, sodales dignissim porta sit amet, pharetra ultrices ex. Proin non facilisis enim. Donec ornare commodo ante, et sagittis mauris euismod vel. Ut convallis sit amet lorem quis euismod. Aenean accumsan consequat diam, nec ultrices nunc fermentum a. Donec sagittis magna nec tincidunt condimentum. In tempor malesuada dignissim. Vestibulum ultricies eu ipsum eu suscipit. Suspendisse convallis nisi id mollis tincidunt. Curabitur venenatis, libero id ultricies blandit, metus arcu sodales ligula, sit amet laoreet nisl ligula eu leo. Aenean pharetra lacinia tortor, a sagittis tellus mattis vitae."
            , ContentArea.ternaryTitle "Pédagogie"
            , ContentArea.paragraph "Ut suscipit sit amet ex sit amet ultricies. Sed nisl sem, mattis vitae nunc eu, accumsan blandit augue. Nunc interdum arcu id consectetur pellentesque. Nullam lectus ex, sodales dignissim porta sit amet, pharetra ultrices ex. Proin non facilisis enim. Donec ornare commodo ante, et sagittis mauris euismod vel. Ut convallis sit amet lorem quis euismod. Aenean accumsan consequat diam, nec ultrices nunc fermentum a. Donec sagittis magna nec tincidunt condimentum. In tempor malesuada dignissim. Vestibulum ultricies eu ipsum eu suscipit. Suspendisse convallis nisi id mollis tincidunt. Curabitur venenatis, libero id ultricies blandit, metus arcu sodales ligula, sit amet laoreet nisl ligula eu leo. Aenean pharetra lacinia tortor, a sagittis tellus mattis vitae."
            ]
        , ActivityList.view
            [ Activity.fromString "Lecture en couleur"
            , Activity.fromString "Fractions"
            , Activity.fromString "Histoire en histoire"
            , Activity.fromString "Biologie, le système cardiaque"
            , Activity.fromString "Dessin, le coeur"
            ]
        , ActivityList.view
            [ Activity.fromString "Lecture en couleur"
            , Activity.fromString "Fractions"
            , Activity.fromString "Histoire en histoire"
            , Activity.fromString "Biologie, le système cardiaque"
            , Activity.fromString "Dessin, le coeur"
            ]
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
    = Ignored
    | Resize Int Int
    | GotViewport Viewport
    | GotSession Session
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
        Ignored ->
            ( model, Cmd.none )

        Resize width height ->
            ( { model | viewport = Just ( toFloat width, toFloat height ) }
            , Cmd.none
            )

        GotViewport { viewport } ->
            ( { model | viewport = Just ( viewport.width, viewport.height ) }
            , Cmd.none
            )

        GotSession session ->
            ( { model | session = session }, Cmd.none )

        GotRoot ->
            ( { model | position = Nothing }, Cmd.none )

        GotPosition position ->
            ( { model | position = Just position }
            , positionToRoute (Just position)
                |> Route.replaceUrl (Session.navKey model.session)
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Session.changes GotSession (Session.navKey model.session)
        , onKeyUp (Decode.map (key False) keyCode)
        , onKeyDown (Decode.map (key True) keyCode)
        , onResize Resize
        ]


key : Bool -> Int -> Msg
key on keycode =
    case keycode of
        _ ->
            Ignored



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
