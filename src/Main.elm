module Main exposing (init, main, subscriptions, update, view)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, title)
import Html.Events
import Icons.ChevronUp
import Json.Decode as Decode
import Page.Blank as Blank
import Page.Calendar as Calendar
import Page.Diary as Diary
import Page.Learning as Learning
import Page.NotFound as NotFound
import Page.Schedule as Schedule
import Route exposing (..)
import Session exposing (Session)
import Shared exposing (..)
import Task
import Tasks.Ui exposing (scrollToTop)
import Url exposing (Url)
import Views.Page as Page



-- NOTE: Based on discussions around how asset management features
-- like code splitting and lazy loading have been shaping up, it's possible
-- that most of this file may become unnecessary in a future release of Elm.
-- Avoid putting things in this module unless there is no alternative!
-- See https://discourse.elm-lang.org/t/elm-spa-in-0-19/1800/2 for more.


type Model
    = Redirect Session
    | NotFound Session
    | Learning Learning.Model
    | Schedule Schedule.Model
    | Diary Diary.Model
    | Calendar Calendar.Model



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }



-- FLAGS


type alias Flags =
    { translations : TranslationFlags
    , learnings : List Group
    }


type alias TranslationFlags =
    { fr : String
    }



-- INIT


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init { learnings } url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey Nothing learnings))



-- UPDATE


type Msg
    = Ignored
    | ChangedRoute (Maybe Route)
    | ChangedUrl Url
    | ClickedLink UrlRequest
    | GotLearningMsg Learning.Msg
    | GotScheduleMsg Schedule.Msg
    | GotDiaryMsg Diary.Msg
    | GotCalendarMsg Calendar.Msg
    | GotSession Session
    | ScrollToTop
    | GotToTop ()


toSession : Model -> Session
toSession model =
    case model of
        Redirect session ->
            session

        NotFound session ->
            session

        Learning learning ->
            Learning.toSession learning

        Schedule schedule ->
            Schedule.toSession schedule

        Diary diary ->
            Diary.toSession diary

        Calendar calendar ->
            Calendar.toSession calendar


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Learning ->
            Learning.init session
                |> updateWith Learning GotLearningMsg model

        Just Route.Schedule ->
            Schedule.init session
                |> updateWith Schedule GotScheduleMsg model

        Just Route.Diary ->
            Diary.init session
                |> updateWith Diary GotDiaryMsg model

        Just Route.Calendar ->
            Calendar.init session
                |> updateWith Calendar GotCalendarMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ScrollToTop, _ ) ->
            ( model, Task.perform GotToTop scrollToTop )

        ( ClickedLink urlRequest, _ ) ->
            case Debug.log "ClickedLink" urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl (Debug.log "ChangedUrl" url)) model

        ( ChangedRoute route, _ ) ->
            changeRouteTo (Debug.log "ChangedRoute" route) model

        ( GotLearningMsg subMsg, Learning learnings ) ->
            Learning.update subMsg learnings
                |> updateWith Learning GotLearningMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model))

        Learning learnings ->
            Sub.map GotLearningMsg (Learning.subscriptions learnings)

        Schedule schedule ->
            Sub.map GotScheduleMsg (Schedule.subscriptions schedule)

        Diary diary ->
            Sub.map GotDiaryMsg (Diary.subscriptions diary)

        Calendar calendar ->
            Sub.map GotCalendarMsg (Calendar.subscriptions calendar)



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage p toMsg config =
            let
                { title, body } =
                    Page.view (Session.viewer (toSession model)) p config
            in
            { title = title
            , body = scrollToTopView ScrollToTop :: List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage Page.Other (\_ -> Ignored) Blank.view

        NotFound _ ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        Learning learning ->
            viewPage Page.Learning GotLearningMsg (Learning.view learning)

        Schedule schedule ->
            viewPage Page.Schedule GotScheduleMsg (Schedule.view schedule)

        Diary diary ->
            viewPage Page.Diary GotDiaryMsg (Diary.view diary)

        Calendar calendar ->
            viewPage Page.Calendar GotCalendarMsg (Calendar.view calendar)


scrollToTopView : msg -> Html msg
scrollToTopView msg =
    a [ Html.Attributes.href "#", onClickNoBubble msg, class "go-to-top", title "Aller en haut de la page" ] [ Icons.ChevronUp.view ]


onClickNoBubble : msg -> Html.Attribute msg
onClickNoBubble msg =
    Html.Events.custom "click"
        (Decode.succeed { message = msg, stopPropagation = True, preventDefault = True })
