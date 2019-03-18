module Page.Learning.Topic exposing (chapterTitle, view)

import Data.Group
import Data.Section
import Data.Slugable exposing (compactCollectionView)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Shared exposing (Group, Msg, Section, Slug, Slugable, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderWithChapterView, pageLayoutView, rowView)


view : Group -> Topic -> Html.Html Msg
view group topic =
    pageLayoutView
        [ mainHeaderWithChapterView (chapterTitle group) (text topic.title)
        , rowView [ compactCollectionView topic.sections Data.Section.toSlug title ]
        ]


title : Section -> Html msg
title section =
    span [ class "label" ]
        [ span [ class "label__prefix" ] [ text (Data.Section.toIdentifier section.identifier) ]
        , text (Data.Section.toNavigationTitle section)
        ]


chapterTitle : Group -> Html msg
chapterTitle group =
    a [ href group.slug ] [ text group.title ]
