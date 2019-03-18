module Page.Learning.Group exposing (view)

import Data.Slugable exposing (collectionView)
import Data.Topic
import Html exposing (..)
import Html.Attributes exposing (class)
import Shared exposing (Group, Msg, Slug, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowView)


view : List Group -> Group -> Html.Html Msg
view learnings group =
    pageLayoutView
        [ mainHeaderView (text group.title)
        , rowView [ collectionView group.topics (Data.Topic.toSlug group) title ]
        ]


title : Topic -> Html msg
title topic =
    span [ class "label" ] [ text (Data.Topic.toNavigationTitle topic) ]
