module Main exposing (init, main, subscriptions, update, view)

import Api exposing (Cred, logout, storageDecoder)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Data.Group as Group exposing (Group)
import Html exposing (..)
import Html.Attributes exposing (class, title)
import Html.Events exposing (onClick)
import Icons.ChevronUp
import Json.Decode as Decode exposing (Decoder, Value, nullable, string)
import Json.Decode.Pipeline exposing (required)
import Page.Blank as Blank
import Page.Calendar as Calendar
import Page.Diary as Diary
import Page.FamilyProfile as FamilyProfile
import Page.Learning as Learning
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Schedule as Schedule
import Route exposing (..)
import Session exposing (Session)
import Task
import Tasks.Ui exposing (scrollToTop)
import Url exposing (Url)
import Viewer exposing (Viewer)
import Views.Page as Page



-- NOTE: Based on discussions around how asset management features
-- like code splitting and lazy loading have been shaping up, it's possible
-- that most of this file may become unnecessary in a future release of Elm.
-- Avoid putting things in this module unless there is no alternative!
-- See https://discourse.elm-lang.org/t/elm-spa-in-0-19/1800/2 for more.


type alias Model =
    { module_ : Module
    , learnings : List Group
    }


type Module
    = Redirect Session
    | NotFound Session
    | Learning Learning.Model
    | Schedule Schedule.Model
    | Diary Diary.Model
    | Calendar Calendar.Model
    | Login Login.Model
    | FamilyProfile FamilyProfile.Model



-- MAIN


main : Program Value Model Msg
main =
    Api.application decodeFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }



-- INIT


type alias Flags =
    { translations : TranslationFlags
    , learnings : List Group
    , viewer : Maybe Viewer
    }


decodeFlags : Decoder Flags
decodeFlags =
    Decode.succeed Flags
        |> required "translations" decodeTranslationFlags
        |> required "learnings" (Decode.list Group.decode)
        |> required "viewer" (nullable (storageDecoder Viewer.decoder))


type alias TranslationFlags =
    { fr : String
    }


decodeTranslationFlags : Decoder TranslationFlags
decodeTranslationFlags =
    Decode.succeed TranslationFlags
        |> required "fr" string


init : Maybe Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeFlags url navKey =
    case maybeFlags of
        Just { learnings, viewer } ->
            changeRouteTo (Route.fromUrl url)
                { module_ = Redirect (Session.fromViewer navKey viewer)
                , learnings = learnings
                }

        Nothing ->
            -- TODO Handle broken flags
            changeRouteTo (Route.fromUrl url)
                { module_ = Redirect (Session.fromViewer navKey Nothing)
                , learnings = []
                }



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
    | GotLoginMsg Login.Msg
    | GotSession Session
    | GotFamiliyProfileMsg FamilyProfile.Msg
    | ScrollToTop


toSession : Model -> Session
toSession { module_ } =
    case module_ of
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

        Login login ->
            Login.toSession login

        FamilyProfile family ->
            FamilyProfile.toSession family


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( { model | module_ = NotFound session }, Cmd.none )

        Just (Route.Learning path) ->
            Learning.init session model.learnings path
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

        Just Route.FamilyProfile ->
            FamilyProfile.init session
                |> updateWith FamilyProfile GotFamiliyProfileMsg model

        Just Route.Login ->
            Login.init session
                |> updateWith Login GotLoginMsg model

        Just Route.Logout ->
            ( model, logout )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ module_ } as model) =
    case ( msg, module_ ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ScrollToTop, _ ) ->
            ( model, Task.attempt (always Ignored) scrollToTop )

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( ChangedRoute route, _ ) ->
            changeRouteTo route model

        ( GotLearningMsg subMsg, Learning learnings ) ->
            Learning.update subMsg learnings
                |> updateWith Learning GotLearningMsg model

        ( GotLoginMsg subMsg, Login login ) ->
            Login.update subMsg login
                |> updateWith Login GotLoginMsg model

        ( GotFamiliyProfileMsg subMsg, FamilyProfile profile ) ->
            FamilyProfile.update subMsg profile
                |> updateWith FamilyProfile GotFamiliyProfileMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWith : (subModel -> Module) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( { model | module_ = toModel subModel }
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions ({ module_ } as model) =
    case module_ of
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

        Login login ->
            Sub.map GotLoginMsg (Login.subscriptions login)

        FamilyProfile family ->
            Sub.map GotFamiliyProfileMsg (FamilyProfile.subscriptions family)



-- VIEW


view : Model -> Document Msg
view ({ module_ } as model) =
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
    case module_ of
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

        Login login ->
            viewPage Page.Login GotLoginMsg (Login.view login)

        FamilyProfile family ->
            viewPage Page.FamilyProfile GotFamiliyProfileMsg (FamilyProfile.view family)


scrollToTopView : msg -> Html msg
scrollToTopView msg =
    div
        [ onClick msg
        , class "go-to-top"
        , title "Aller en haut de la page"
        ]
        [ Icons.ChevronUp.view ]


onClickNoBubble : msg -> Html.Attribute msg
onClickNoBubble msg =
    Html.Events.custom "click"
        (Decode.succeed { message = msg, stopPropagation = True, preventDefault = True })
