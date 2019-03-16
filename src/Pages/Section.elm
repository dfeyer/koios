module Pages.Section exposing (view)

import Data.Group
import Data.Slugable exposing (compactCollectionView)
import Data.Target exposing (toSlugableList)
import Data.Topic
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Pages.Topic
import Routes exposing (topicPath)
import Shared exposing (Group, Model, Msg, Section, SlugableTarget, Target, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderWithChapterView, pageLayoutView, rowView)


view : Model -> Section -> Html.Html Msg
view { learnings } section =
    let
        maybeGroup =
            Data.Group.bySection learnings section.identifier

        maybeTopic =
            Data.Topic.bySection learnings section.identifier
    in
    case ( maybeGroup, maybeTopic ) of
        ( Just g, Just t ) ->
            pageLayoutView
                [ mainHeaderWithChapterView (chapterTitle g t) (text section.title)
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


chapterTitle : Group -> Topic -> Html msg
chapterTitle group topic =
    span [ class "breadcrumb" ]
        [ Pages.Topic.chapterTitle group
        , a [ href (topicPath group.slug topic.slug) ] [ text topic.title ]
        ]
