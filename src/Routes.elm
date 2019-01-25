module Routes exposing (matchers, parseUrl)

import Shared exposing (..)
import Url exposing (Url)
import Url.Parser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeRoute top
        , map GroupRoute (s "activity" </> string)
        , map TargetRoute (s "activity" </> string </> string)
        , map SectionRoute (s "activity" </> string </> string </> string)
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

        TargetRoute groupSlug targetSlug ->
            "/activity/" ++ groupSlug ++ "/" ++ targetSlug

        SectionRoute groupSlug targetSlug sectionSlug ->
            "/activity/" ++ groupSlug ++ "/" ++ targetSlug ++ "/" ++ sectionSlug

        NotFoundRoute ->
            "/404"

homePath =
    pathFor HomeRoute

activityGroupPath groupSlug =
    pathFor (GroupRoute groupSlug)

activityTargetPath groupSlug targetSlug =
    pathFor (TargetRoute groupSlug targetSlug)


activitySectionPath groupSlug targetSlug sectionSlug =
    pathFor (SectionRoute groupSlug targetSlug sectionSlug)
