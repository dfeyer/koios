module Page.Learning.Section exposing (view)

import Data.Group
import Data.Section
import Data.Slugable exposing (compactCollectionView)
import Data.Target exposing (toSlugableList)
import Data.Topic
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Page.Learning.Topic
import Shared exposing (Group, Msg, Section, SlugableTarget, Target, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderWithChapterView, pageLayoutView, rowView)


view : List Group -> Section -> Html.Html Msg
view learnings section =
    let
        maybeGroup =
            Data.Group.bySection learnings section.identifier

        maybeTopic =
            Data.Topic.bySection learnings section.identifier
    in
    case ( maybeGroup, maybeTopic ) of
        ( Just g, Just t ) ->
            pageLayoutView
                [ mainHeaderWithChapterView (chapterTitle g t) (pageTitle section)
                , rowView [ compactCollectionView (toSlugableList section.targets) Data.Target.toSlug title ]
                ]

        ( _, _ ) ->
            div [ class "todo" ] [ text "Missing implementation" ]


title : SlugableTarget -> Html msg
title target =
    span [ class "label" ]
        [ span [ class "label__prefix" ] [ text target.position ]
        , text target.title
        ]


pageTitle : Section -> Html msg
pageTitle section =
    span []
        [ span [ class "label__prefix" ] [ text (Data.Section.toIdentifier section.identifier) ]
        , text (Data.Section.toNavigationTitle section)
        ]


chapterTitle : Group -> Topic -> Html msg
chapterTitle group topic =
    span [ class "breadcrumb" ]
        [ Page.Learning.Topic.chapterTitle group
        , a [ href (group.slug ++ "/" ++ topic.slug) ] [ text topic.title ]
        ]
