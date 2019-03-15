module Pages.Group exposing (view)

import Data.Slugable exposing (collectionView)
import Data.Topic
import Html exposing (..)
import Shared exposing (Group, Model, Msg, Slug, UriWithLabel)
import Views.Layout exposing (mainHeaderView, pageLayoutView, rowView)


view : Model -> Group -> Html.Html Msg
view { activities } group =
    pageLayoutView
        [ mainHeaderView group.title
        , rowView [ collectionView group.topics (Data.Topic.toSlug group) Data.Topic.toNavigationTitle ]
        ]
