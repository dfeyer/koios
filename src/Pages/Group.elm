module Pages.Group exposing (view)

import Data.Slugable exposing (collectionView)
import Data.Topic
import Html exposing (..)
import Html.Attributes exposing (class)
import Shared exposing (Group, Model, Msg, Slug, Topic, UriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowView)


view : Model -> Group -> Html.Html Msg
view { activities } group =
    pageLayoutView
        [ mainHeaderView (text group.title)
        , rowView [ collectionView group.topics (Data.Topic.toSlug group) title ]
        ]


title : Topic -> Html msg
title topic =
    span [ class "label" ] [ text (Data.Topic.toNavigationTitle topic) ]
