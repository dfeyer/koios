module Main exposing (init, main, subscriptions, update, view)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Data.Slugable
import Data.Topic exposing (foldTopics)
import Html exposing (..)
import Page.Blank as Blank
import Page.Learning as Learning
import Page.NotFound as NotFound
import Route exposing (..)
import Session exposing (Session)
import Shared exposing (..)
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
    | GotSession Session


toSession : Model -> Session
toSession model =
    case model of
        Redirect session ->
            session

        NotFound session ->
            session

        Learning home ->
            Learning.toSession home


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just LearningRoute ->
            Learning.init session
                |> updateWith Learning GotLearningMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
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
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage Page.Other (\_ -> Ignored) Blank.view

        NotFound _ ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        Learning learnings ->
            viewPage Page.Learning GotLearningMsg (Learning.view learnings)
