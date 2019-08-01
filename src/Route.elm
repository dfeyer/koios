module Route exposing (Route(..), fromUrl, href, pathToPosition, positionToRoute, replaceUrl)

import Browser.Navigation as Nav
import Data.Group as Group exposing (Group, Position, Section, Target, Topic)
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing (..)


type Route
    = Learning (Maybe String)
    | Schedule
    | Diary
    | Calendar
    | Login
    | Logout


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map (Learning Nothing) top
        , map Learning (s "l" </> fragment identity)
        , map Schedule (s "semainier")
        , map Diary (s "journal")
        , map Calendar (s "calendrier")
        , map Login (s "connexion")
        , map Logout (s "deconnexion")
        ]



-- PUBLIC HELPERS


positionToRoute : Maybe Position -> Route
positionToRoute maybePosition =
    case maybePosition of
        Just position ->
            case position of
                ( groupPosition, Nothing ) ->
                    case groupPosition of
                        ( group, Nothing ) ->
                            Learning (Just group.slug)

                        ( group, Just topic ) ->
                            Learning (Just (group.slug ++ "/" ++ topic.slug))

                ( ( group, Just topic ), Just sectionPosition ) ->
                    case sectionPosition of
                        ( section, Nothing ) ->
                            Learning (Just (group.slug ++ "/" ++ topic.slug ++ "/" ++ section.slug))

                        ( section, Just target ) ->
                            Learning (Just (group.slug ++ "/" ++ topic.slug ++ "/" ++ section.slug ++ "/" ++ target.position))

                _ ->
                    -- TODO show the default error page
                    Learning Nothing

        Nothing ->
            Learning Nothing


pathToPosition : List Group -> Maybe String -> Maybe Position
pathToPosition list maybePath =
    case maybePath of
        Nothing ->
            Nothing

        Just path ->
            let
                parts =
                    String.split "/" path
            in
            -- TODO Performance improvements
            case parts of
                [ groupSlug, topicSlug, sectionSlug, targetPosition ] ->
                    let
                        group =
                            Group.groupBySlug list groupSlug

                        section =
                            Group.sectionBySlug list groupSlug topicSlug sectionSlug
                    in
                    case ( group, section ) of
                        ( Just group_, Just section_ ) ->
                            Just
                                ( ( group_, Group.topicBySlug list groupSlug topicSlug )
                                , Just ( section_, Group.targetByPosition list groupSlug topicSlug sectionSlug targetPosition )
                                )

                        _ ->
                            Nothing

                [ groupSlug, topicSlug, sectionSlug ] ->
                    let
                        group =
                            Group.groupBySlug list groupSlug

                        section =
                            Group.sectionBySlug list groupSlug topicSlug sectionSlug
                    in
                    case ( group, section ) of
                        ( Just group_, Just section_ ) ->
                            Just
                                ( ( group_, Group.topicBySlug list groupSlug topicSlug )
                                , Just ( section_, Nothing )
                                )

                        _ ->
                            Nothing

                [ groupSlug, topicSlug ] ->
                    let
                        group =
                            Group.groupBySlug list groupSlug
                    in
                    case group of
                        Just group_ ->
                            Just
                                ( ( group_, Group.topicBySlug list groupSlug topicSlug )
                                , Nothing
                                )

                        Nothing ->
                            Nothing

                [ groupSlug ] ->
                    let
                        group =
                            Group.groupBySlug list groupSlug
                    in
                    case group of
                        Just group_ ->
                            Just
                                ( ( group_, Nothing )
                                , Nothing
                                )

                        Nothing ->
                            Nothing

                _ ->
                    Nothing


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    url
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Learning Nothing ->
                    []

                Learning (Just fragment) ->
                    [ "l", "#" ++ fragment ]

                Schedule ->
                    [ "semainier" ]

                Diary ->
                    [ "journal" ]

                Calendar ->
                    [ "calendrier" ]

                Login ->
                    [ "connexion" ]

                Logout ->
                    [ "deconnexion" ]
    in
    "/" ++ String.join "/" pieces
