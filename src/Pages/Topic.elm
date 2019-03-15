module Pages.Topic exposing (chapterTitle, view)

import Data.Group
import Data.Section
import Data.Slugable exposing (compactCollectionView)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Routes exposing (groupPath)
import Shared exposing (Group, Model, Msg, Section, Slug, Slugable, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderWithChapterView, pageLayoutView, rowView)


view : Model -> Group -> Topic -> Html.Html Msg
view model group topic =
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
    a [ href (groupPath group.slug) ] [ text group.title ]
