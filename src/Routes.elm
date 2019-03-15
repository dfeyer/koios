module Routes exposing (groupPath, homePath, matchers, parseUrl, topicPath)

import Shared exposing (..)
import Url exposing (Url)
import Url.Parser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeRoute top
        , map SectionRoute (s "activity" </> string </> string </> string)
        , map TopicRoute (s "activity" </> string </> string)
        , map GroupRoute (s "activity" </> string)
        ]


parseUrl : Url -> Route
parseUrl url =
    case parse matchers url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


pathFor : Route -> String
pathFor route =
    case route of
        HomeRoute ->
            "/"

        GroupRoute groupSlug ->
            "/activity/" ++ groupSlug

        TopicRoute groupSlug targetSlug ->
            "/activity/" ++ groupSlug ++ "/" ++ targetSlug

        SectionRoute section cycle order ->
            "/activity/" ++ section ++ "/" ++ cycle ++ "/" ++ order

        NotFoundRoute ->
            "/404"


homePath =
    pathFor HomeRoute


groupPath groupSlug =
    pathFor (GroupRoute groupSlug)


topicPath groupSlug topicSlug =
    pathFor (TopicRoute groupSlug topicSlug)
